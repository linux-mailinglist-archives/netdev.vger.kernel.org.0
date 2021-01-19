Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AC42FAE25
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 01:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732176AbhASAld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 19:41:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:38525 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729933AbhASAlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 19:41:31 -0500
IronPort-SDR: TCY2drA7nZnknuPdbURapQsxaixsleyiejOZKUkt9vFpYLrZm2mkGY2I3Bothw9fqQWWfSO+4z
 yJOAnMMZEZjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="179011251"
X-IronPort-AV: E=Sophos;i="5.79,357,1602572400"; 
   d="scan'208";a="179011251"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 16:40:49 -0800
IronPort-SDR: 4hawrQJj2fpyw45PFJX567hqDcoEqwoOCDKSLDlraM+SazFR400XCZ1JL8NDwYvnev65Xcc4Fp
 ToV0+ulebJCA==
X-IronPort-AV: E=Sophos;i="5.79,357,1602572400"; 
   d="scan'208";a="426285752"
Received: from cemillan-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.57.184])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 16:40:48 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v2 0/8] ethtool: Add support for frame preemption
Date:   Mon, 18 Jan 2021 16:40:20 -0800
Message-Id: <20210119004028.2809425-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Original cover letter:

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
queues are marked as preemptible, in this example, queue 0 is marked
as "not preemptible", so it is express, the rest of the four queues
are preemptible.

The next step, of this example, would be to enable frame preemption in
the device, via ethtool, and set the minimum fragment size to 2:

$ sudo ./ethtool --set-frame-preemption $IFACE fp on min-frag-size 2

Cheers,

Vinicius Costa Gomes (8):
  ethtool: Add support for configuring frame preemption
  taprio: Add support for frame preemption offload
  igc: Set the RX packet buffer size for TSN mode
  igc: Only dump registers if configured to dump HW information
  igc: Avoid TX Hangs because long cycles
  igc: Add support for tuning frame preemption via ethtool
  igc: Add support for Frame Preemption offload
  igc: Separate TSN configurations that can be updated

 Documentation/networking/ethtool-netlink.rst |  38 +++++
 drivers/net/ethernet/intel/igc/igc.h         |  12 ++
 drivers/net/ethernet/intel/igc/igc_defines.h |   6 +
 drivers/net/ethernet/intel/igc/igc_dump.c    |   3 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  53 ++++++
 drivers/net/ethernet/intel/igc/igc_main.c    |  31 +++-
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 162 ++++++++++++++-----
 drivers/net/ethernet/intel/igc/igc_tsn.h     |   1 +
 include/linux/ethtool.h                      |  39 ++++-
 include/linux/netdevice.h                    |   1 +
 include/net/pkt_sched.h                      |   4 +
 include/uapi/linux/ethtool_netlink.h         |  17 ++
 include/uapi/linux/pkt_sched.h               |   1 +
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |  10 ++
 net/ethtool/netlink.c                        |  19 +++
 net/ethtool/netlink.h                        |   4 +
 net/ethtool/preempt.c                        | 146 +++++++++++++++++
 net/sched/sch_taprio.c                       |  41 ++++-
 19 files changed, 539 insertions(+), 51 deletions(-)
 create mode 100644 net/ethtool/preempt.c

-- 
2.30.0

