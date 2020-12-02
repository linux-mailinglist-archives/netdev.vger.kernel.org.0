Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273B12CB418
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 05:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgLBEyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 23:54:32 -0500
Received: from mga04.intel.com ([192.55.52.120]:43301 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgLBEyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 23:54:31 -0500
IronPort-SDR: J89DlEzW/Mn5nLyXIy1tNqVCa9VxKXTf+6kxz6atMcvhFcNzS8ZhJKk8kqc5pryeaOksgyP21K
 j1C0LtlwUwIg==
X-IronPort-AV: E=McAfee;i="6000,8403,9822"; a="170387531"
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="170387531"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 20:53:47 -0800
IronPort-SDR: QD3nCDN9+K7fqN39slVDNSPnW0LqPPLlHrVmeGUMx4eNvQArWuXCwJKHFx/EO9NOAfaGM1jNTU
 zHd6AKhF7m5g==
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="549888358"
Received: from shivanif-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.152.222])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 20:53:47 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next v1 0/9] ethtool: Add support for frame preemption
Date:   Tue,  1 Dec 2020 20:53:16 -0800
Message-Id: <20201202045325.3254757-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

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
qdiscs (was thinking of mqprio) to also configure which queues should
be marked as express/preemptible.

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


Vinicius Costa Gomes (9):
  ethtool: Add support for configuring frame preemption
  taprio: Add support for frame preemption offload
  igc: Set the RX packet buffer size for TSN mode
  igc: Only dump registers if configured to dump HW information
  igc: Avoid TX Hangs because long cycles
  igc: Add support for tuning frame preemption via ethtool
  igc: Add support for Frame Preemption offload
  igc: Add support for exposing frame preemption stats registers
  igc: Separate TSN configurations that can be updated

 drivers/net/ethernet/intel/igc/igc.h         |  10 ++
 drivers/net/ethernet/intel/igc/igc_defines.h |   6 +
 drivers/net/ethernet/intel/igc/igc_dump.c    |   3 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  63 ++++++++
 drivers/net/ethernet/intel/igc/igc_main.c    |  31 +++-
 drivers/net/ethernet/intel/igc/igc_regs.h    |  10 ++
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 158 ++++++++++++++-----
 drivers/net/ethernet/intel/igc/igc_tsn.h     |   1 +
 include/linux/ethtool.h                      |  19 +++
 include/linux/netdevice.h                    |   1 +
 include/net/pkt_sched.h                      |   4 +
 include/uapi/linux/ethtool_netlink.h         |  17 ++
 include/uapi/linux/pkt_sched.h               |   1 +
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/netlink.c                        |  19 +++
 net/ethtool/netlink.h                        |   4 +
 net/ethtool/preempt.c                        | 151 ++++++++++++++++++
 net/sched/sch_taprio.c                       |  41 ++++-
 18 files changed, 491 insertions(+), 50 deletions(-)
 create mode 100644 net/ethtool/preempt.c

-- 
2.29.2

