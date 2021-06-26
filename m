Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34B63B4B87
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 02:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFZAgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 20:36:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:48448 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhFZAgD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 20:36:03 -0400
IronPort-SDR: Obom+VQb4pxWp1V+5SUae+snJIleDQzXE4FszBawh6CMHmfqtOUoAhyurPpRkGUXCw7+uP5qKe
 NvHPP08edE4g==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="195054016"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="195054016"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:40 -0700
IronPort-SDR: GqdBDBdxUL9Es7PEfXblA2eVd+27IFX+2tzCKGQ3JALDbpTNcWD6agBTwaafUBbiVKe7x4EA9D
 YIFPDxci/0jw==
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="557008593"
Received: from aschmalt-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.160.59])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:40 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v4 00/12] ethtool: Add support for frame preemption
Date:   Fri, 25 Jun 2021 17:33:02 -0700
Message-Id: <20210626003314.3159402-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When the APIs, now including verification, are fine, I can separate
this series into smaller pieces, to make further review easier. I am
proposing this as one series so it's easier to get the full picture.


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


Vinicius Costa Gomes (12):
  ethtool: Add support for configuring frame preemption
  taprio: Add support for frame preemption offload
  core: Introduce netdev_tc_map_to_queue_mask()
  taprio: Replace tc_map_to_queue_mask()
  mqprio: Add support for frame preemption offload
  igc: Add support for enabling frame preemption via ethtool
  igc: Add support for TC_SETUP_PREEMPT
  igc: Simplify TSN flags handling
  igc: Add support for setting frame preemption configuration
  ethtool: Add support for Frame Preemption verification
  igc: Check incompatible configs for Frame Preemption
  igc: Add support for Frame Preemption verification

 Documentation/networking/ethtool-netlink.rst |  41 +++
 drivers/net/ethernet/intel/igc/igc.h         |  27 ++
 drivers/net/ethernet/intel/igc/igc_defines.h |  17 ++
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  45 ++++
 drivers/net/ethernet/intel/igc/igc_main.c    | 249 ++++++++++++++++++-
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 127 ++++++----
 drivers/net/ethernet/intel/igc/igc_tsn.h     |   1 +
 include/linux/ethtool.h                      |  24 ++
 include/linux/netdevice.h                    |   2 +
 include/net/pkt_sched.h                      |   4 +
 include/uapi/linux/ethtool_netlink.h         |  19 ++
 include/uapi/linux/pkt_sched.h               |   2 +
 net/core/dev.c                               |  20 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |  25 ++
 net/ethtool/netlink.c                        |  19 ++
 net/ethtool/netlink.h                        |   4 +
 net/ethtool/preempt.c                        | 157 ++++++++++++
 net/sched/sch_mqprio.c                       |  41 ++-
 net/sched/sch_taprio.c                       |  65 +++--
 20 files changed, 815 insertions(+), 76 deletions(-)
 create mode 100644 net/ethtool/preempt.c

-- 
2.32.0

