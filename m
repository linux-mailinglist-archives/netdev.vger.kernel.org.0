Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1975F52E1C0
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344308AbiETBQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiETBP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:15:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E982558A
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653009354; x=1684545354;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=G1XpN9NqsICntJ89GlkBc4NgibI/yoEyZfhTslacGns=;
  b=iHFesLfINejgoCvcZ2v9XbcE2RJToZwZg7Zn1kBM2ExYevzwb78gSjc4
   HI+aYhRjcNypWtYMpvffIWTHyPJ4oc585HLpUsZX54esIrhJ1QYR6eqAF
   3x8yyoqCljp6WeZKgeMVR+57NqnBPwuvlhfGPIjhfeMYzdI74QDwnGDDw
   PytZ9JE6+EUetXnQbKhKZ5WE648/jFyxWN6m4q/VZKLrciYzXvrZdJ4Qp
   m2XRp8aNswT4TSfie9AHTf4rNZzFg1rA3Dpwnldm+gc3c06Qr+/ka28cW
   7Sns83Htkrf8ICtlt4wy0p+6eWYxLyP7d6n8HjT4L8i5qRISCRgn6Syf5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="333064148"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="333064148"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570534531"
Received: from vcostago-mobl3.jf.intel.com ([10.24.14.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:53 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v5 00/11] ethtool: Add support for frame preemption
Date:   Thu, 19 May 2022 18:15:27 -0700
Message-Id: <20220520011538.1098888-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Please consider this as a PATCH-like quality RFC (in short, even in
the absence of comments, please do not apply this series as is), my
aim is to get an consensus on the userspace API.

I also found some weirdness with Intel I226, that I would like to
investigate better. So, maybe it's a good use of everyone's time to
have this series out, so people can take a look at the more
controversial parts while I investigate/fix those issues.

(The checkpatch.pl warnings about the spelling of "preemptible" are
ignored because that's the way it's spelled in IEEE 802.1Q-2018, but
in IEEE 802.3-2018 it's preemptable, it's a mess)

Changes from v4:
 - Went back to exposing the per-queue frame preemption bits via
   ethtool-netlink only, via taprio/mqprio was seen as too much
   trouble. (Vladimir Oltean)
 - Fixed documentation and code/patch organization changes (Vladimir
   Oltean).

Changes from v3:
 - Added early support for sending/receiving support for verification
   frames (Vladimir Oltean). This is a bit more than RFC-quality, but
   adding this so people can see how it fits together with the rest.
   The driver specific bits are interesting because the hardware does
   the absolute minimum, the driver needs to do the heavy lifting.

 - Added support for setting preemptible/express traffic classes via
   tc-mqprio (Vladimir Oltean). mqprio parsing of configuration
   options is... interesting, so comments here are going to be useful,
   I may have missed something.

Changes from v2:
 - Fixed some copy&paste mistakes, documentation formatting and
   slightly improved error reporting (Jakub Kicinski);

Changes from v1:
 - The minimum fragment size configuration was changed to be
   configured in bytes to be more future proof, in case the standard
   changes this (the previous definition was '(X + 1) * 64', X being
   [0..3]) (Michal Kubecek);
 - In taprio, frame preemption is now configured by traffic classes (was
   done by queues) (Jakub Kicinski, Vladimir Oltean);
 - Various netlink protocol validation improvements (Jakub Kicinski);
 - Dropped the IGC register dump for frame preemption registers, until a
   stardandized way of exposing that is agreed (Jakub Kicinski);

Changes from RFC v2:
 - Reorganised the offload enabling/disabling on the driver size;
 - Added a few igc fixes;

Changes from RFC v1:
 - The per-queue preemptible/express setting is moved to applicable
   qdiscs (Jakub Kicinski and others);
 - "min-frag-size" now follows the 802.3br specification more closely,
   it's expressed as X in '64(1 + X) + 4' (Joergen Andreasen);

Another point that should be noted is the addition of the
TC_SETUP_PREEMPT offload type, the idea behind this is to allow other
qdiscs (was thinking of mqprio) to also configure which traffic
classes should be marked as express/preemptible.

Original cover letter (lightly edited):

This is still an RFC because two main reasons, I want to confirm that
this approach (per-queue settings via qdiscs, device settings via
ethtool) looks good, even though there aren't much more options left ;-)
The other reason is that while testing this I found some weirdness
in the driver that I would need a bit more time to investigate.

(In case these patches are not enough to give an idea of how things
work, I can send the userspace patches, of course.)

The idea of this "hybrid" approach is that applications/users would do
the following steps to configure frame preemption:

$ tc qdisc replace dev $IFACE parent root handle 100 taprio \
      num_tc 3 \
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@1 2@2 \
      base-time $BASE_TIME \
      sched-entry S 0f 10000000 \
      preempt 1110 \
      flags 0x2 

The "preempt" parameter is the only difference, it configures which
traffic classes are marked as preemptible, in this example, traffic
class 0 is marked as "not preemptible", so it is express, the rest of
the four traffic classes are preemptible.

The next step, of this example, would be to enable frame preemption in
the device, via ethtool, and set the minimum fragment size to 192 bytes:

$ sudo ./ethtool --set-frame-preemption $IFACE fp on min-frag-size 192

Cheers,


Vinicius Costa Gomes (11):
  ethtool: Add support for configuring frame preemption
  ethtool: Add support for Frame Preemption verification
  igc: Add support for receiving frames with all zeroes address
  igc: Set the RX packet buffer size for TSN mode
  igc: Optimze TX buffer sizes for TSN
  igc: Add support for receiving errored frames
  igc: Add support for enabling frame preemption via ethtool
  igc: Add support for setting frame preemption configuration
  igc: Add support for Frame Preemption verification
  igc: Check incompatible configs for Frame Preemption
  igc: Add support for exposing frame preemption stats registers

 Documentation/networking/ethtool-netlink.rst |  55 ++++
 drivers/net/ethernet/intel/igc/igc.h         |  29 ++-
 drivers/net/ethernet/intel/igc/igc_defines.h |  22 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  92 +++++++
 drivers/net/ethernet/intel/igc/igc_main.c    | 256 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_regs.h    |  10 +
 drivers/net/ethernet/intel/igc/igc_tsn.c     |  57 ++++-
 include/linux/ethtool.h                      |  26 ++
 include/uapi/linux/ethtool_netlink.h         |  20 ++
 net/ethtool/Makefile                         |   3 +-
 net/ethtool/common.c                         |  23 ++
 net/ethtool/netlink.c                        |  19 ++
 net/ethtool/netlink.h                        |   4 +
 net/ethtool/preempt.c                        | 188 ++++++++++++++
 14 files changed, 791 insertions(+), 13 deletions(-)
 create mode 100644 net/ethtool/preempt.c

-- 
2.35.3

