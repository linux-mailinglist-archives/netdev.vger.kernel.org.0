Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BFB2CB41C
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 05:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgLBEzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 23:55:02 -0500
Received: from mga04.intel.com ([192.55.52.120]:43301 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgLBEzC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 23:55:02 -0500
IronPort-SDR: PS7X+Ea7RmHujVqB3+ZWpjBD56aTflVLRBOGgWf9nIizJKrS/Gopk+d8kAaYLmeCJayLAJD4vS
 lV+H0LrfE9UQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9822"; a="170387540"
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="170387540"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 20:53:50 -0800
IronPort-SDR: YVrnecCPQENo2hfl06eRNaVcm0cgimH/R70lhkacYkV1i8YMh8Z5KMnBXOdi9Fg6fKcm99LL0a
 hDVj5FO5XIFg==
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="549888388"
Received: from shivanif-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.152.222])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 20:53:50 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next v1 8/9] igc: Add support for exposing frame preemption stats registers
Date:   Tue,  1 Dec 2020 20:53:24 -0800
Message-Id: <20201202045325.3254757-9-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202045325.3254757-1-vinicius.gomes@intel.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose the Frame Preemption counters, so the number of
express/preemptible packets can be monitored by userspace.

These registers are cleared when read, so the value shown is the
number of events that happened since the last read.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  8 ++++++++
 drivers/net/ethernet/intel/igc/igc_regs.h    | 10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 492c6592c150..14a14a61de45 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -325,6 +325,14 @@ static void igc_ethtool_get_regs(struct net_device *netdev,
 
 	regs_buff[213] = adapter->stats.tlpic;
 	regs_buff[214] = adapter->stats.rlpic;
+	regs_buff[215] = rd32(IGC_PRMPTDTCNT);
+	regs_buff[216] = rd32(IGC_PRMEVNTTCNT);
+	regs_buff[217] = rd32(IGC_PRMPTDRCNT);
+	regs_buff[218] = rd32(IGC_PRMEVNTRCNT);
+	regs_buff[219] = rd32(IGC_PRMPBLTCNT);
+	regs_buff[220] = rd32(IGC_PRMPBLRCNT);
+	regs_buff[221] = rd32(IGC_PRMEXPTCNT);
+	regs_buff[222] = rd32(IGC_PRMEXPRCNT);
 }
 
 static void igc_ethtool_get_wol(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index b52dd9d737e8..69e295d69d84 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -197,6 +197,16 @@
 
 #define IGC_FTQF(_n)	(0x059E0 + (4 * (_n)))  /* 5-tuple Queue Fltr */
 
+/* Time sync registers - preemption statistics */
+#define IGC_PRMPTDTCNT	0x04280  /* Good TX Preempted Packets */
+#define IGC_PRMEVNTTCNT	0x04298  /* TX Preemption event counter */
+#define IGC_PRMPTDRCNT	0x04284  /* Good RX Preempted Packets */
+#define IGC_PRMEVNTRCNT	0x0429C  /* RX Preemption event counter */
+#define IGC_PRMPBLTCNT	0x04288  /* Good TX Preemptable Packets */
+#define IGC_PRMPBLRCNT	0x0428C  /* Good RX Preemptable Packets */
+#define IGC_PRMEXPTCNT	0x04290  /* Good TX Express Packets */
+#define IGC_PRMEXPRCNT	0x042A0  /* Preemption Exception Counter */
+
 /* Transmit Scheduling Registers */
 #define IGC_TQAVCTRL		0x3570
 #define IGC_TXQCTL(_n)		(0x3344 + 0x4 * (_n))
-- 
2.29.2

