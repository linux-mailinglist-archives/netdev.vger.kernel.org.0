Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5739343252
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhCUMLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:11:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18188 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229945AbhCUMKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 08:10:25 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12LC4fqB017646;
        Sun, 21 Mar 2021 05:10:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=q+RPbjs7VZ6h2iodOOnHOlvhrG2h7/cWt6A0/Hm+zyw=;
 b=CJUuTjRhuslcc4rGk1v6HQfM0OdU6uJAdzihTj+ApFoeu3y/RENmv1g4+SI7Um8YvqHY
 2f7PX9NfpLc/ItWQva/EJmbxTFsgTZQhLrZA020CP7gvNgg8+zbjJTMMeGE2Gbjo25oB
 PBnqZOugHsppBrrgG8efoAJ85F/oSIoYvqqFuZVAiATN+KDtvQTUQe4C0gSDJXtjO1ZU
 m639byFlQ9KdRg5kZBfx6VczOn+80RE5TfYRAG+qgi5ommnYb1bYU5NdaDo0ybZD11Yu
 fycwDLM0GqUp5aMt/6BaWeKiIp42V/zovXIXKLCWAHqsee5vAyTdY2s1fvCn/hNUm93G hA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnt34w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 05:10:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 21 Mar
 2021 05:10:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 21 Mar 2021 05:10:20 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 2F6213F7041;
        Sun, 21 Mar 2021 05:10:16 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 5/8] octeontx2-af: Put CGX LMAC also in Higig2 mode
Date:   Sun, 21 Mar 2021 17:39:55 +0530
Message-ID: <20210321120958.17531-6-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210321120958.17531-1-hkelam@marvell.com>
References: <20210321120958.17531-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-21_01:2021-03-19,2021-03-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently upon user request to enable Higig2 mode, only NPC packet
parsing related settings are done. This patch adds config to put
CGX LMAC also in Higig2 mode. Actual hardware config is done by firmware,
so send a request to firmware to get the config done.

Adds support for higig2 pause frames such that when user enables
higig2, 802.3 pause frames are disabled and higig2 pause frames
are enabled vice versa.

Other changes
    - CGX HW doesn't support timestamping when in Higig2 mode, so
      made PTP and Higig2 settings mutually exclusive.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 136 ++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  16 ++-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  14 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  34 +++++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  17 +++
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  14 ++
 7 files changed, 214 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index aa86691885d..1cbd1ffe039 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -460,18 +460,32 @@ int cgx_lmac_tx_enable(void *cgxd, int lmac_id, bool enable)
 	return !!(last & DATA_PKT_TX_EN);
 }
 
-static int cgx_lmac_get_pause_frm_status(void *cgxd, int lmac_id,
-					 u8 *tx_pause, u8 *rx_pause)
+static int cgx_lmac_get_higig2_pause_frm_status(void *cgxd, int lmac_id,
+						u8 *tx_pause, u8 *rx_pause)
 {
 	struct cgx *cgx = cgxd;
 	u64 cfg;
 
-	if (is_dev_rpm(cgx))
-		return 0;
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_HG2_CONTROL);
+
+	*rx_pause = !!(cfg & CGXX_SMUX_HG2_CONTROL_RX_ENABLE);
+	*tx_pause = !!(cfg & CGXX_SMUX_HG2_CONTROL_TX_ENABLE);
+	return 0;
+}
+
+int cgx_lmac_get_pause_frm_status(void *cgxd, int lmac_id,
+				  u8 *tx_pause, u8 *rx_pause)
+{
+	struct cgx *cgx = cgxd;
+	u64 cfg;
 
 	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 
+	if (is_higig2_enabled(cgxd, lmac_id))
+		return cgx_lmac_get_higig2_pause_frm_status(cgxd, lmac_id,
+							    tx_pause, rx_pause);
+
 	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
 	*rx_pause = !!(cfg & CGX_SMUX_RX_FRM_CTL_CTL_BCK);
 
@@ -480,17 +494,51 @@ static int cgx_lmac_get_pause_frm_status(void *cgxd, int lmac_id,
 	return 0;
 }
 
-static int cgx_lmac_enadis_pause_frm(void *cgxd, int lmac_id,
-				     u8 tx_pause, u8 rx_pause)
+static int cgx_lmac_enadis_higig2_pause_frm(void *cgxd, int lmac_id,
+					    u8 tx_pause, u8 rx_pause)
 {
 	struct cgx *cgx = cgxd;
 	u64 cfg;
 
-	if (is_dev_rpm(cgx))
-		return 0;
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_HG2_CONTROL);
+	cfg &= ~CGXX_SMUX_HG2_CONTROL_RX_ENABLE;
+	cfg |= rx_pause ? CGXX_SMUX_HG2_CONTROL_RX_ENABLE : 0x0;
+	cgx_write(cgx, lmac_id, CGXX_SMUX_HG2_CONTROL, cfg);
 
-	if (!is_lmac_valid(cgx, lmac_id))
-		return -ENODEV;
+	/* Forward PAUSE information to TX block */
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
+	cfg &= ~CGX_SMUX_RX_FRM_CTL_CTL_BCK;
+	cfg |= rx_pause ? CGX_SMUX_RX_FRM_CTL_CTL_BCK : 0x0;
+	cgx_write(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL, cfg);
+
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_HG2_CONTROL);
+	cfg &= ~CGXX_SMUX_HG2_CONTROL_TX_ENABLE;
+	cfg |= tx_pause ? CGXX_SMUX_HG2_CONTROL_TX_ENABLE : 0x0;
+	cgx_write(cgx, lmac_id, CGXX_SMUX_HG2_CONTROL, cfg);
+
+	/* allow intra packet hg2 generation */
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_PAUSE_PKT_INTERVAL);
+	cfg &= ~CGXX_SMUX_TX_PAUSE_PKT_HG2_INTRA_EN;
+	cfg |= tx_pause ? CGXX_SMUX_TX_PAUSE_PKT_HG2_INTRA_EN : 0x0;
+	cgx_write(cgx, lmac_id, CGXX_SMUX_TX_PAUSE_PKT_INTERVAL, cfg);
+
+	cfg = cgx_read(cgx, 0, CGXX_CMR_RX_OVR_BP);
+	if (tx_pause) {
+		cfg &= ~CGX_CMR_RX_OVR_BP_EN(lmac_id);
+	} else {
+		cfg |= CGX_CMR_RX_OVR_BP_EN(lmac_id);
+		cfg &= ~CGX_CMR_RX_OVR_BP_BP(lmac_id);
+	}
+
+	cgx_write(cgx, 0, CGXX_CMR_RX_OVR_BP, cfg);
+	return 0;
+}
+
+static int cgx_lmac_enadis_8023_pause_frm(void *cgxd, int lmac_id,
+					  u8 tx_pause, u8 rx_pause)
+{
+	struct cgx *cgx = cgxd;
+	u64 cfg;
 
 	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
 	cfg &= ~CGX_SMUX_RX_FRM_CTL_CTL_BCK;
@@ -513,6 +561,22 @@ static int cgx_lmac_enadis_pause_frm(void *cgxd, int lmac_id,
 	return 0;
 }
 
+int cgx_lmac_enadis_pause_frm(void *cgxd, int lmac_id,
+			      u8 tx_pause, u8 rx_pause)
+{
+	struct cgx *cgx = cgxd;
+
+	if (!is_lmac_valid(cgx, lmac_id))
+		return -ENODEV;
+
+	if (is_higig2_enabled(cgxd, lmac_id))
+		return cgx_lmac_enadis_higig2_pause_frm(cgxd, lmac_id,
+							 tx_pause, rx_pause);
+	else
+		return cgx_lmac_enadis_8023_pause_frm(cgxd, lmac_id,
+						       tx_pause, rx_pause);
+}
+
 static void cgx_lmac_pause_frm_config(void *cgxd, int lmac_id, bool enable)
 {
 	struct cgx *cgx = cgxd;
@@ -520,6 +584,7 @@ static void cgx_lmac_pause_frm_config(void *cgxd, int lmac_id, bool enable)
 
 	if (!is_lmac_valid(cgx, lmac_id))
 		return;
+
 	if (enable) {
 		/* Enable receive pause frames */
 		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
@@ -543,6 +608,12 @@ static void cgx_lmac_pause_frm_config(void *cgxd, int lmac_id, bool enable)
 		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_PAUSE_PKT_INTERVAL,
 			  cfg | (DEFAULT_PAUSE_TIME / 2));
 
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_PAUSE_PKT_INTERVAL);
+		cfg = FIELD_SET(HG2_INTRA_INTERVAL, (DEFAULT_PAUSE_TIME / 2),
+				cfg);
+		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_PAUSE_PKT_INTERVAL,
+			  cfg);
+
 		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_TX_PAUSE_PKT_TIME,
 			  DEFAULT_PAUSE_TIME);
 
@@ -561,10 +632,18 @@ static void cgx_lmac_pause_frm_config(void *cgxd, int lmac_id, bool enable)
 		cfg &= ~CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
 		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
 
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_HG2_CONTROL);
+		cfg &= ~CGXX_SMUX_HG2_CONTROL_RX_ENABLE;
+		cgx_write(cgx, lmac_id, CGXX_SMUX_HG2_CONTROL, cfg);
+
 		/* Disable pause frames transmission */
 		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_CTL);
 		cfg &= ~CGX_SMUX_TX_CTL_L2P_BP_CONV;
 		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_CTL, cfg);
+
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_HG2_CONTROL);
+		cfg &= ~CGXX_SMUX_HG2_CONTROL_TX_ENABLE;
+		cgx_write(cgx, lmac_id, CGXX_SMUX_HG2_CONTROL, cfg);
 	}
 }
 
@@ -1242,6 +1321,37 @@ unsigned long cgx_get_lmac_bmap(void *cgxd)
 	return cgx->lmac_bmap;
 }
 
+void cgx_lmac_enadis_higig2(void *cgxd, int lmac_id, bool enable)
+{
+	struct cgx *cgx = cgxd;
+	u64 req = 0, resp;
+
+	/* disable 802.3 pause frames before enabling higig2 */
+	if (enable) {
+		cgx_lmac_enadis_8023_pause_frm(cgxd, lmac_id, false, false);
+		cgx_lmac_enadis_higig2_pause_frm(cgxd, lmac_id, true, true);
+	}
+
+	req = FIELD_SET(CMDREG_ID, CGX_CMD_HIGIG, req);
+	req = FIELD_SET(CMDREG_ENABLE, enable, req);
+	cgx_fwi_cmd_generic(req, &resp, cgx, lmac_id);
+
+	/* enable 802.3 pause frames as higig2 disabled */
+	if (!enable) {
+		cgx_lmac_enadis_higig2_pause_frm(cgxd, lmac_id, false, false);
+		cgx_lmac_enadis_8023_pause_frm(cgxd, lmac_id, true, true);
+	}
+}
+
+bool is_higig2_enabled(void *cgxd, int lmac_id)
+{
+	struct cgx *cgx = cgxd;
+	u64 cfg;
+
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_CTL);
+	return (cfg & CGXX_SMUX_TX_CTL_HIGIG_EN);
+}
+
 static int cgx_lmac_init(struct cgx *cgx)
 {
 	struct lmac *lmac;
@@ -1328,9 +1438,11 @@ static int cgx_lmac_exit(struct cgx *cgx)
 static void cgx_populate_features(struct cgx *cgx)
 {
 	if (is_dev_rpm(cgx))
-		cgx->hw_features =  (RVU_MAC_RPM | RVU_LMAC_FEAT_FC);
+		cgx->hw_features = (RVU_LMAC_FEAT_DMACF | RVU_MAC_RPM |
+				    RVU_LMAC_FEAT_FC);
 	else
-		cgx->hw_features = (RVU_LMAC_FEAT_FC | RVU_LMAC_FEAT_PTP);
+		cgx->hw_features = (RVU_LMAC_FEAT_FC  | RVU_LMAC_FEAT_HIGIG2 |
+				    RVU_LMAC_FEAT_PTP | RVU_LMAC_FEAT_DMACF);
 }
 
 static struct mac_ops	cgx_mac_ops    = {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 237a91b801e..1547e66fb24 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -74,14 +74,20 @@
 #define CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK	BIT_ULL(3)
 #define CGX_GMP_GMI_RXX_FRM_CTL_PTP_MODE BIT_ULL(12)
 #define CGXX_SMUX_TX_CTL		0x20178
+#define CGXX_SMUX_TX_CTL_HIGIG_EN	BIT_ULL(8)
 #define CGXX_SMUX_TX_PAUSE_PKT_TIME	0x20110
 #define CGXX_SMUX_TX_PAUSE_PKT_INTERVAL	0x20120
+#define CGXX_SMUX_TX_PAUSE_PKT_HG2_INTRA_EN	BIT_ULL(32)
+#define HG2_INTRA_INTERVAL		GENMASK_ULL(31, 16)
 #define CGXX_GMP_GMI_TX_PAUSE_PKT_TIME	0x38230
 #define CGXX_GMP_GMI_TX_PAUSE_PKT_INTERVAL	0x38248
 #define CGX_SMUX_TX_CTL_L2P_BP_CONV	BIT_ULL(7)
 #define CGXX_CMR_RX_OVR_BP		0x130
 #define CGX_CMR_RX_OVR_BP_EN(X)		BIT_ULL(((X) + 8))
 #define CGX_CMR_RX_OVR_BP_BP(X)		BIT_ULL(((X) + 4))
+#define CGXX_SMUX_HG2_CONTROL		0x20210
+#define CGXX_SMUX_HG2_CONTROL_TX_ENABLE		BIT_ULL(18)
+#define CGXX_SMUX_HG2_CONTROL_RX_ENABLE		BIT_ULL(17)
 
 #define CGX_COMMAND_REG			CGXX_SCRATCH1_REG
 #define CGX_EVENT_REG			CGXX_SCRATCH0_REG
@@ -147,10 +153,10 @@ int cgx_get_link_info(void *cgxd, int lmac_id,
 		      struct cgx_link_user_info *linfo);
 int cgx_lmac_linkup_start(void *cgxd);
 int cgx_get_fwdata_base(u64 *base);
-int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
-			   u8 *tx_pause, u8 *rx_pause);
-int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
-			   u8 tx_pause, u8 rx_pause);
+int cgx_lmac_get_pause_frm_status(void *cgxd, int lmac_id,
+				  u8 *tx_pause, u8 *rx_pause);
+int cgx_lmac_enadis_pause_frm(void *cgxd, int lmac_id,
+			      u8 tx_pause, u8 rx_pause);
 void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable);
 u8 cgx_lmac_get_p2x(int cgx_id, int lmac_id);
 int cgx_set_fec(u64 fec, int cgx_id, int lmac_id);
@@ -168,4 +174,6 @@ u64 cgx_lmac_read(int cgx_id, int lmac_id, u64 offset);
 int cgx_set_phy_mod_type(int mod, void *cgxd, int lmac_id);
 int cgx_get_phy_mod_type(void *cgxd, int lmac_id);
 int cgx_get_pkind(void *cgxd, u8 lmac_id, int *pkind);
+void cgx_lmac_enadis_higig2(void *cgxd, int lmac_id, bool enable);
+bool is_higig2_enabled(void *cgxd, int lmac_id);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 1ce22782260..a1f71ee9e98 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -509,10 +509,13 @@ struct cgx_set_link_mode_rsp {
 };
 
 #define RVU_LMAC_FEAT_FC		BIT_ULL(0) /* pause frames */
-#define RVU_LMAC_FEAT_PTP		BIT_ULL(1) /* precison time protocol */
-#define RVU_MAC_VERSION			BIT_ULL(2)
-#define RVU_MAC_CGX			BIT_ULL(3)
-#define RVU_MAC_RPM			BIT_ULL(4)
+#define	RVU_LMAC_FEAT_HIGIG2		BIT_ULL(1)
+			/* flow control from physical link higig2 messages */
+#define RVU_LMAC_FEAT_PTP		BIT_ULL(2) /* precison time protocol */
+#define RVU_LMAC_FEAT_DMACF		BIT_ULL(3) /* DMAC FILTER */
+#define RVU_MAC_VERSION			BIT_ULL(4)
+#define RVU_MAC_CGX			BIT_ULL(5)
+#define RVU_MAC_RPM			BIT_ULL(6)
 
 struct cgx_features_info_msg {
 	struct mbox_msghdr hdr;
@@ -631,6 +634,7 @@ enum nix_af_status {
 	NIX_AF_ERR_TX_VTAG_NOSPC    = -421,
 	NIX_AF_ERR_RX_VTAG_INUSE    = -422,
 	NIX_AF_ERR_NPC_KEY_NOT_SUPP = -423,
+	NIX_AF_ERR_PTP_CONFIG_FAIL  = -424,
 };
 
 /* For NIX RX vtag action  */
@@ -1003,6 +1007,8 @@ enum npc_af_status {
 	NPC_MCAM_ALLOC_DENIED	= -702,
 	NPC_MCAM_ALLOC_FAILED	= -703,
 	NPC_MCAM_PERM_DENIED	= -704,
+	NPC_AF_ERR_HIGIG_CONFIG_FAIL	= -705,
+	NPC_AF_ERR_HIGIG_NOT_SUPPORTED	= -706,
 };
 
 struct npc_mcam_alloc_entry_req {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 292351bad5b..ae51937ee46 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -618,6 +618,8 @@ int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id, int index,
 			   int rxtxflag, u64 *stat);
 bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc);
 bool rvu_cgx_is_pkind_config_permitted(struct rvu *rvu, u16 pcifunc);
+void rvu_cgx_enadis_higig2(struct rvu *rvu, int pf, bool enable);
+bool rvu_cgx_is_higig2_enabled(struct rvu *rvu, int pf);
 
 /* NPA APIs */
 int rvu_npa_init(struct rvu *rvu);
@@ -639,6 +641,7 @@ int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add);
 struct nix_hw *get_nix_hw(struct rvu_hwinfo *hw, int blkaddr);
 int rvu_get_next_nix_blkaddr(struct rvu *rvu, int blkaddr);
 void rvu_nix_reset_mac(struct rvu_pfvf *pfvf, int pcifunc);
+u64 rvu_nix_is_ptp_tx_enabled(struct rvu *rvu, u16 pcifunc);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 9c30692070b..2f35b5f8268 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -424,6 +424,36 @@ void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable)
 		mac_ops->mac_enadis_rx_pause_fwding(cgxd, lmac_id, false);
 }
 
+void rvu_cgx_enadis_higig2(struct rvu *rvu, int pf, bool enable)
+{
+	u8 cgx_id, lmac_id;
+	void *cgxd;
+
+	if (!is_pf_cgxmapped(rvu, pf))
+		return;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+	cgx_lmac_enadis_higig2(cgxd, lmac_id, enable);
+}
+
+bool rvu_cgx_is_higig2_enabled(struct rvu *rvu, int pf)
+{
+	u8 cgx_id, lmac_id;
+	void *cgxd;
+
+	if (is_mac_feature_supported(rvu, pf, RVU_LMAC_FEAT_HIGIG2) == false)
+		return 0;
+
+	if (!is_pf_cgxmapped(rvu, pf))
+		return false;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+
+	return is_higig2_enabled(cgxd, lmac_id);
+}
+
 int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start)
 {
 	int pf = rvu_get_pf(pcifunc);
@@ -604,6 +634,10 @@ static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 	if (!is_mac_feature_supported(rvu, pf, RVU_LMAC_FEAT_PTP))
 		return 0;
 
+	/* Silicon does not support enabling time stamp in higig mode */
+	if (enable && rvu_cgx_is_higig2_enabled(rvu, pf))
+		return NIX_AF_ERR_PTP_CONFIG_FAIL;
+
 	/* This msg is expected only from PFs that are mapped to CGX LMACs,
 	 * if received from other PF/VF simply ACK, nothing to do.
 	 */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index ed96ebc4022..56ade799011 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3707,6 +3707,10 @@ static int rvu_nix_lf_ptp_tx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 	if (!is_mac_feature_supported(rvu, pf, RVU_LMAC_FEAT_PTP))
 		return 0;
 
+	/* Silicon does not support enabling time stamp in higig mode */
+	if (rvu_cgx_is_higig2_enabled(rvu, rvu_get_pf(pcifunc)))
+		return NIX_AF_ERR_PTP_CONFIG_FAIL;
+
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
 	if (blkaddr < 0)
 		return NIX_AF_ERR_AF_LF_INVALID;
@@ -3799,3 +3803,16 @@ void rvu_nix_reset_mac(struct rvu_pfvf *pfvf, int pcifunc)
 	if (from_vf)
 		ether_addr_copy(pfvf->mac_addr, pfvf->default_mac);
 }
+
+u64 rvu_nix_is_ptp_tx_enabled(struct rvu *rvu, u16 pcifunc)
+{
+	int blkaddr, nixlf, err;
+	u64 cfg;
+
+	err = nix_get_nixlf(rvu, pcifunc, &nixlf, &blkaddr);
+	if (err)
+		return false;
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf));
+	return (cfg & BIT_ULL(32));
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 802668e1f90..dba57a6b439 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2850,6 +2850,7 @@ int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
 			   u64 pkind)
 {
 	int pf = rvu_get_pf(pcifunc);
+	bool enable_higig2 = false;
 	int blkaddr, nixlf, rc;
 	u64 rxpkind, txpkind;
 	u8 cgx_id, lmac_id;
@@ -2861,8 +2862,17 @@ int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
 	if (mode & OTX2_PRIV_FLAGS_EDSA) {
 		rxpkind = NPC_RX_EDSA_PKIND;
 	} else if (mode & OTX2_PRIV_FLAGS_HIGIG) {
+		/* Silicon does not support enabling higig in time stamp mode */
+		if (rvu_nix_is_ptp_tx_enabled(rvu, pcifunc))
+			return NPC_AF_ERR_HIGIG_CONFIG_FAIL;
+
+		if (is_mac_feature_supported(rvu, pf, RVU_LMAC_FEAT_HIGIG2) ==
+		    false)
+			return NPC_AF_ERR_HIGIG_NOT_SUPPORTED;
+
 		rxpkind = NPC_RX_HIGIG_PKIND;
 		txpkind = NPC_TX_HIGIG_PKIND;
+		enable_higig2 = true;
 	} else if (mode & OTX2_PRIV_FLAGS_CUSTOM) {
 		rxpkind = pkind;
 		txpkind = pkind;
@@ -2889,6 +2899,10 @@ int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
 		rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf),
 			    txpkind);
 	}
+
+	if (enable_higig2 ^ rvu_cgx_is_higig2_enabled(rvu, pf))
+		rvu_cgx_enadis_higig2(rvu, pf, enable_higig2);
+
 	return 0;
 }
 
-- 
2.17.1

