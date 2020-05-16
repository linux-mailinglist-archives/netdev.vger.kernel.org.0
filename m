Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05B71D5DA6
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 03:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgEPBaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 21:30:09 -0400
Received: from mga18.intel.com ([134.134.136.126]:60902 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgEPBaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 21:30:04 -0400
IronPort-SDR: GOtCJREuFPoDfP7uITBWPoCjCTwkSNi44OxjwNIv4sGCEc20XWNnLkw6uBE8pC7ZkTeOfHOgjq
 Ofce1wrXf9pQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 18:30:02 -0700
IronPort-SDR: vqkOq6Ox8xCLG47AUPRmPrFwzEh9SfJV+9/l+AOcATanSbLa2SNwwbiqSB36glvbblvq76Kfui
 FEMBlts0rtyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,397,1583222400"; 
   d="scan'208";a="307569183"
Received: from wkbertra-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.251.131.129])
  by FMSMGA003.fm.intel.com with ESMTP; 15 May 2020 18:30:02 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
Subject: [next-queue RFC 4/4] igc: Add support for exposing frame preemption stats registers
Date:   Fri, 15 May 2020 18:29:48 -0700
Message-Id: <20200516012948.3173993-5-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516012948.3173993-1-vinicius.gomes@intel.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[WIP]

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  9 +++++++++
 drivers/net/ethernet/intel/igc/igc_regs.h    | 10 ++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 48d5d18..09d72f7 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -322,6 +322,15 @@ static void igc_ethtool_get_regs(struct net_device *netdev,
 
 	for (i = 0; i < 8; i++)
 		regs_buff[205 + i] = rd32(IGC_ETQF(i));
+
+	regs_buff[214] = rd32(IGC_PRMPTDTCNT);
+	regs_buff[215] = rd32(IGC_PRMEVNTTCNT);
+	regs_buff[216] = rd32(IGC_PRMPTDRCNT);
+	regs_buff[217] = rd32(IGC_PRMEVNTRCNT);
+	regs_buff[218] = rd32(IGC_PRMPBLTCNT);
+	regs_buff[219] = rd32(IGC_PRMPBLRCNT);
+	regs_buff[220] = rd32(IGC_PRMEXPTCNT);
+	regs_buff[221] = rd32(IGC_PRMEXPRCNT);
 }
 
 static void igc_ethtool_get_wol(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 7f999cf..010bb48 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -211,6 +211,16 @@
 
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
2.26.2

