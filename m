Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE351301046
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbhAVWrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:47:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:1521 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbhAVWqH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 17:46:07 -0500
IronPort-SDR: GfO2L+3CSkBGdBqyHlPFgZoHd4z/XuBmkYuRsfapvV2c/TDwLPwSRtiy+x+jgpxVd2L8O5G7Aw
 WrlEOWcF1GZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="166619676"
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="166619676"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:21 -0800
IronPort-SDR: rds6fI4o/yf+yYLN9TUnZ/2i28k/f2r4eBJeZhYDWt3CdkXcI8T9bUBg+YDlT+9zKRHVv6oGSW
 atnM8SuDYy/w==
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="355390556"
Received: from apalur-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.155.78])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:20 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v3 3/8] igc: Set the RX packet buffer size for TSN mode
Date:   Fri, 22 Jan 2021 14:44:48 -0800
Message-Id: <20210122224453.4161729-4-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122224453.4161729-1-vinicius.gomes@intel.com>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for supporting frame preemption, when entering TSN mode
set the receive packet buffer to 16KB for the Express MAC, 16KB for
the Preemptible MAC and 2KB for the BMC, according to the datasheet
section 7.1.3.2.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |  2 ++
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 32f5fd684139..0e78abfd99ee 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -351,6 +351,8 @@
 #define IGC_RXPBS_CFG_TS_EN	0x80000000 /* Timestamp in Rx buffer */
 
 #define IGC_TXPBSIZE_TSN	0x04145145 /* 5k bytes buffer for each queue */
+#define IGC_RXPBSIZE_TSN	0x00010090 /* 16KB for EXP + 16KB for BE + 2KB for BMC */
+#define IGC_RXPBSIZE_SIZE_MASK	0x0001FFFF
 
 #define IGC_DTXMXPKTSZ_TSN	0x19 /* 1600 bytes of max TX DMA packet size */
 #define IGC_DTXMXPKTSZ_DEFAULT	0x98 /* 9728-byte Jumbo frames */
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 174103c4bea6..38451cf05ac6 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -24,7 +24,7 @@ static bool is_any_launchtime(struct igc_adapter *adapter)
 static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
-	u32 tqavctrl;
+	u32 tqavctrl, rxpbs;
 	int i;
 
 	if (!(adapter->flags & IGC_FLAG_TSN_QBV_ENABLED))
@@ -35,6 +35,11 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 	wr32(IGC_TXPBS, I225_TXPBSIZE_DEFAULT);
 	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_DEFAULT);
 
+	rxpbs = rd32(IGC_RXPBS) & ~IGC_RXPBSIZE_SIZE_MASK;
+	rxpbs |= I225_RXPBSIZE_DEFAULT;
+
+	wr32(IGC_RXPBS, rxpbs);
+
 	tqavctrl = rd32(IGC_TQAVCTRL);
 	tqavctrl &= ~(IGC_TQAVCTRL_TRANSMIT_MODE_TSN |
 		      IGC_TQAVCTRL_ENHANCED_QAV);
@@ -64,7 +69,7 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
 	u32 tqavctrl, baset_l, baset_h;
-	u32 sec, nsec, cycle;
+	u32 sec, nsec, cycle, rxpbs;
 	ktime_t base_time, systim;
 	int i;
 
@@ -79,6 +84,11 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 	wr32(IGC_TXPBS, IGC_TXPBSIZE_TSN);
 
 	tqavctrl = rd32(IGC_TQAVCTRL);
+	rxpbs = rd32(IGC_RXPBS) & ~IGC_RXPBSIZE_SIZE_MASK;
+	rxpbs |= IGC_RXPBSIZE_TSN;
+
+	wr32(IGC_RXPBS, rxpbs);
+
 	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
 	wr32(IGC_TQAVCTRL, tqavctrl);
 
-- 
2.30.0

