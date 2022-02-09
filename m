Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789AB4AEAE0
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbiBIHPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236506AbiBIHPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:15:31 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B480C05CB80;
        Tue,  8 Feb 2022 23:15:34 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21926b6x003738;
        Tue, 8 Feb 2022 23:15:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=n8IKaMUUD4WzqcBjhrWcm0NoHer1T7N3YjrA1le8RAc=;
 b=a0kuvKaVFCay663tR8qp5kl8Cit8QtpZ/MFz8YSbaaf5H2AeY9dxxzH/P/MsaKOaSC8N
 GB8jDdhAup7U7G54bfHKl9/wUmrRFrc+B6J1wJ1p0D9Qz152nta/fdhE0QFpk011b5M4
 Hw3eGtkZ89lwesLR+CZfJ/4XSC+pxLcE/NxxGvw626VfSxk8Kb9el5Ld99ubCXFRdFiv
 xmt/qrNbF0RG4RbPvNXuMpCnCAsyjDn1sgDGLYA8yh69mw1G35Hiy15XnGxTJcXVHFgD
 lsaEeJuO2Ljs7nE2fxpDRsCWMDX4TSOSHNRcgTS21ML/4y+kq5zOSwUWHjvXRCEAXp55 3A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3e44hth16u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 23:15:32 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Feb
 2022 23:15:30 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 8 Feb 2022 23:15:30 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 95C513F706B;
        Tue,  8 Feb 2022 23:15:27 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH V2 2/4] octeontx2-af: Priority flow control configuration support
Date:   Wed, 9 Feb 2022 12:45:17 +0530
Message-ID: <20220209071519.10403-3-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220209071519.10403-1-hkelam@marvell.com>
References: <20220209071519.10403-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: xImHTeQ3apicDnGIoHh1v7TX8fQm2JI5
X-Proofpoint-ORIG-GUID: xImHTeQ3apicDnGIoHh1v7TX8fQm2JI5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_03,2022-02-07_02,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Kumar Kori <skori@marvell.com>

Prirority based flow control (802.1Qbb)  mechanism is similar to
ethernet pause frames (802.3x) instead pausing all traffic on a link,
PFC allows user to selectively pause traffic according to its class.

Oceteontx2 MAC block (CGX) and CN10K Mac block (RPM) both supports
PFC. As upper layer mbox handler is same for both the MACs, this
patch configures PFC by calling apporopritate callbacks.

Signed-off-by: Sunil Kumar Kori <skori@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   |  42 +++++
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |   9 ++
 .../marvell/octeontx2/af/lmac_common.h        |   3 +
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  17 +++
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 144 ++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  28 ++++
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  23 +++
 7 files changed, 251 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index fb7069c757f5..64e8211d14ba 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -817,6 +817,47 @@ static void cgx_lmac_pause_frm_config(void *cgxd, int lmac_id, bool enable)
 	cgx_write(cgx, lmac_id, CGXX_SMUX_TX_CTL, cfg);
 }
 
+int cgx_lmac_pfc_config(void *cgxd, int lmac_id, u8 tx_pause,
+			u8 rx_pause, u16 pfc_en)
+{
+	struct cgx *cgx = cgxd;
+	u64 cfg;
+
+	if (!is_lmac_valid(cgx, lmac_id))
+		return -ENODEV;
+
+	/* Return as no traffic classes are requested */
+	if (tx_pause && !pfc_en)
+		return 0;
+
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_CBFC_CTL);
+
+	if (rx_pause) {
+		cfg |= (CGXX_SMUX_CBFC_CTL_RX_EN |
+			CGXX_SMUX_CBFC_CTL_BCK_EN |
+			CGXX_SMUX_CBFC_CTL_DRP_EN);
+	} else {
+		cfg &= ~(CGXX_SMUX_CBFC_CTL_RX_EN |
+			CGXX_SMUX_CBFC_CTL_BCK_EN |
+			CGXX_SMUX_CBFC_CTL_DRP_EN);
+	}
+
+	if (tx_pause)
+		cfg |= CGXX_SMUX_CBFC_CTL_TX_EN;
+	else
+		cfg &= ~CGXX_SMUX_CBFC_CTL_TX_EN;
+
+	cfg = FIELD_SET(CGX_PFC_CLASS_MASK, pfc_en, cfg);
+
+	cgx_write(cgx, lmac_id, CGXX_SMUX_CBFC_CTL, cfg);
+
+	/* Write source MAC address which will be filled into PFC packet */
+	cfg = cgx_lmac_addr_get(cgx->cgx_id, lmac_id);
+	cgx_write(cgx, lmac_id, CGXX_SMUX_SMAC, cfg);
+
+	return 0;
+}
+
 void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable)
 {
 	struct cgx *cgx = cgxd;
@@ -1559,6 +1600,7 @@ static struct mac_ops	cgx_mac_ops    = {
 	.mac_enadis_ptp_config =	cgx_lmac_ptp_config,
 	.mac_rx_tx_enable =		cgx_lmac_rx_tx_enable,
 	.mac_tx_enable =		cgx_lmac_tx_enable,
+	.pfc_config =                   cgx_lmac_pfc_config,
 };
 
 static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index ab1e4abdea38..27c6fa925e10 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -76,6 +76,13 @@
 #define CGXX_SMUX_TX_CTL		0x20178
 #define CGXX_SMUX_TX_PAUSE_PKT_TIME	0x20110
 #define CGXX_SMUX_TX_PAUSE_PKT_INTERVAL	0x20120
+#define CGXX_SMUX_SMAC                        0x20108
+#define CGXX_SMUX_CBFC_CTL                    0x20218
+#define CGXX_SMUX_CBFC_CTL_RX_EN             BIT_ULL(0)
+#define CGXX_SMUX_CBFC_CTL_TX_EN             BIT_ULL(1)
+#define CGXX_SMUX_CBFC_CTL_DRP_EN            BIT_ULL(2)
+#define CGXX_SMUX_CBFC_CTL_BCK_EN            BIT_ULL(3)
+#define CGX_PFC_CLASS_MASK		     GENMASK_ULL(47, 32)
 #define CGXX_GMP_GMI_TX_PAUSE_PKT_TIME	0x38230
 #define CGXX_GMP_GMI_TX_PAUSE_PKT_INTERVAL	0x38248
 #define CGX_SMUX_TX_CTL_L2P_BP_CONV	BIT_ULL(7)
@@ -172,4 +179,6 @@ u64 cgx_lmac_read(int cgx_id, int lmac_id, u64 offset);
 int cgx_lmac_addr_update(u8 cgx_id, u8 lmac_id, u8 *mac_addr, u8 index);
 u64 cgx_read_dmac_ctrl(void *cgxd, int lmac_id);
 u64 cgx_read_dmac_entry(void *cgxd, int index);
+int cgx_lmac_pfc_config(void *cgxd, int lmac_id, u8 tx_pause, u8 rx_pause,
+			u16 pfc_en);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index b33e7d1d0851..8f6b7d14b18b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -110,6 +110,9 @@ struct mac_ops {
 
 	int			(*mac_rx_tx_enable)(void *cgxd, int lmac_id, bool enable);
 	int			(*mac_tx_enable)(void *cgxd, int lmac_id, bool enable);
+	int                     (*pfc_config)(void *cgxd, int lmac_id,
+					      u8 tx_pause, u8 rx_pause, u16 pfc_en);
+
 };
 
 struct cgx {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 58e2aeebc14f..f8d0e7f42567 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -172,6 +172,8 @@ M(RPM_STATS,		0x21C, rpm_stats, msg_req, rpm_stats_rsp)	\
 M(CGX_MAC_ADDR_RESET,	0x21D, cgx_mac_addr_reset, msg_req, msg_rsp)	\
 M(CGX_MAC_ADDR_UPDATE,	0x21E, cgx_mac_addr_update, cgx_mac_addr_update_req, \
 			       msg_rsp)					\
+M(CGX_PRIO_FLOW_CTRL_CFG, 0x21F, cgx_prio_flow_ctrl_cfg, cgx_pfc_cfg,  \
+				 cgx_pfc_rsp)                               \
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 M(NPA_LF_ALLOC,		0x400, npa_lf_alloc,				\
 				npa_lf_alloc_req, npa_lf_alloc_rsp)	\
@@ -609,6 +611,21 @@ struct rpm_stats_rsp {
 	u64 tx_stats[RPM_TX_STATS_COUNT];
 };
 
+struct cgx_pfc_cfg {
+	struct mbox_msghdr hdr;
+	u8 rx_pause;
+	u8 tx_pause;
+	u16 pfc_en; /*  bitmap indicating pfc enabled traffic classes */
+};
+
+struct cgx_pfc_rsp {
+	struct mbox_msghdr hdr;
+	u8 rx_pause;
+	u8 tx_pause;
+};
+
+ /* NPA mbox message formats */
+
 struct npc_set_pkind {
 	struct mbox_msghdr hdr;
 #define OTX2_PRIV_FLAGS_DEFAULT  BIT_ULL(0)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 8c0b35a868cf..a9a93c66ab07 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -32,6 +32,7 @@ static struct mac_ops	rpm_mac_ops   = {
 	.mac_enadis_ptp_config =	rpm_lmac_ptp_config,
 	.mac_rx_tx_enable =		rpm_lmac_rx_tx_enable,
 	.mac_tx_enable =		rpm_lmac_tx_enable,
+	.pfc_config =                   rpm_lmac_pfc_config,
 };
 
 struct mac_ops *rpm_get_mac_ops(void)
@@ -129,6 +130,85 @@ int rpm_lmac_get_pause_frm_status(void *rpmd, int lmac_id,
 	return 0;
 }
 
+static void rpm_cfg_pfc_quanta_thresh(rpm_t *rpm, int lmac_id, u16 pfc_en,
+				      bool enable)
+{
+	u64 quanta_offset = 0, quanta_thresh = 0, cfg;
+	int i, shift;
+
+	/* Set pause time and interval */
+	for_each_set_bit(i, (unsigned long *)&pfc_en, 16) {
+		switch (i) {
+		case 0:
+		case 1:
+			quanta_offset = RPMX_MTI_MAC100X_CL01_PAUSE_QUANTA;
+			quanta_thresh = RPMX_MTI_MAC100X_CL01_QUANTA_THRESH;
+			break;
+		case 2:
+		case 3:
+			quanta_offset = RPMX_MTI_MAC100X_CL23_PAUSE_QUANTA;
+			quanta_thresh = RPMX_MTI_MAC100X_CL23_QUANTA_THRESH;
+			break;
+		case 4:
+		case 5:
+			quanta_offset = RPMX_MTI_MAC100X_CL45_PAUSE_QUANTA;
+			quanta_thresh = RPMX_MTI_MAC100X_CL45_QUANTA_THRESH;
+			break;
+		case 6:
+		case 7:
+			quanta_offset = RPMX_MTI_MAC100X_CL67_PAUSE_QUANTA;
+			quanta_thresh = RPMX_MTI_MAC100X_CL67_QUANTA_THRESH;
+			break;
+		case 8:
+		case 9:
+			quanta_offset = RPMX_MTI_MAC100X_CL89_PAUSE_QUANTA;
+			quanta_thresh = RPMX_MTI_MAC100X_CL89_QUANTA_THRESH;
+			break;
+		case 10:
+		case 11:
+			quanta_offset = RPMX_MTI_MAC100X_CL1011_PAUSE_QUANTA;
+			quanta_thresh = RPMX_MTI_MAC100X_CL1011_QUANTA_THRESH;
+			break;
+		case 12:
+		case 13:
+			quanta_offset = RPMX_MTI_MAC100X_CL1213_PAUSE_QUANTA;
+			quanta_thresh = RPMX_MTI_MAC100X_CL1213_QUANTA_THRESH;
+			break;
+		case 14:
+		case 15:
+			quanta_offset = RPMX_MTI_MAC100X_CL1415_PAUSE_QUANTA;
+			quanta_thresh = RPMX_MTI_MAC100X_CL1415_QUANTA_THRESH;
+			break;
+		}
+
+		if (!quanta_offset || !quanta_thresh)
+			continue;
+
+		shift = (i % 2) ? 1 : 0;
+		cfg = rpm_read(rpm, lmac_id, quanta_offset);
+		if (enable) {
+			cfg |= ((u64)RPM_DEFAULT_PAUSE_TIME <<  shift * 16);
+		} else {
+			if (!shift)
+				cfg &= ~GENMASK_ULL(15, 0);
+			else
+				cfg &= ~GENMASK_ULL(31, 16);
+		}
+		rpm_write(rpm, lmac_id, quanta_offset, cfg);
+
+		cfg = rpm_read(rpm, lmac_id, quanta_thresh);
+		if (enable) {
+			cfg |= ((u64)(RPM_DEFAULT_PAUSE_TIME / 2) <<  shift * 16);
+		} else {
+			if (!shift)
+				cfg &= ~GENMASK_ULL(15, 0);
+			else
+				cfg &= ~GENMASK_ULL(31, 16);
+		}
+		rpm_write(rpm, lmac_id, quanta_thresh, cfg);
+	}
+}
+
 int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
 			      u8 rx_pause)
 {
@@ -152,8 +232,12 @@ int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
 
 	cfg = rpm_read(rpm, 0, RPMX_CMR_RX_OVR_BP);
 	if (tx_pause) {
+		/* Configure CL0 Pause Quanta & threshold for 802.3X frames */
+		rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, 1, true);
 		cfg &= ~RPMX_CMR_RX_OVR_BP_EN(lmac_id);
 	} else {
+		/* Disable all Pause Quanta & threshold values */
+		rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, 0xffff, false);
 		cfg |= RPMX_CMR_RX_OVR_BP_EN(lmac_id);
 		cfg &= ~RPMX_CMR_RX_OVR_BP_BP(lmac_id);
 	}
@@ -166,21 +250,6 @@ void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable)
 	rpm_t *rpm = rpmd;
 	u64 cfg;
 
-	if (enable) {
-		/* Set pause time and interval */
-		cfg = rpm_read(rpm, lmac_id,
-			       RPMX_MTI_MAC100X_CL01_PAUSE_QUANTA);
-		cfg &= ~0xFFFFULL;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_CL01_PAUSE_QUANTA,
-			  cfg | RPM_DEFAULT_PAUSE_TIME);
-		/* Set pause interval as the hardware default is too short */
-		cfg = rpm_read(rpm, lmac_id,
-			       RPMX_MTI_MAC100X_CL01_QUANTA_THRESH);
-		cfg &= ~0xFFFFULL;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_CL01_QUANTA_THRESH,
-			  cfg | (RPM_DEFAULT_PAUSE_TIME / 2));
-	}
-
 	/* ALL pause frames received are completely ignored */
 	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
 	cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE;
@@ -302,3 +371,48 @@ void rpm_lmac_ptp_config(void *rpmd, int lmac_id, bool enable)
 		cfg &= ~RPMX_RX_TS_PREPEND;
 	rpm_write(rpm, lmac_id, RPMX_CMRX_CFG, cfg);
 }
+
+int rpm_lmac_pfc_config(void *rpmd, int lmac_id, u8 tx_pause, u8 rx_pause, u16 pfc_en)
+{
+	rpm_t *rpm = rpmd;
+	u64 cfg;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return -ENODEV;
+
+	/* reset PFC class quanta and threshold */
+	rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, 0xffff, false);
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+
+	if (rx_pause) {
+		cfg &= ~(RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE |
+				RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE |
+				RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_FWD);
+	} else {
+		cfg |= (RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE |
+				RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE |
+				RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_FWD);
+	}
+
+	if (tx_pause) {
+		rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, pfc_en, true);
+		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
+	} else {
+		rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, 0xfff, false);
+		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
+	}
+
+	if (!rx_pause && !tx_pause)
+		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_PFC_MODE;
+	else
+		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_PFC_MODE;
+
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL);
+	cfg = FIELD_SET(RPM_PFC_CLASS_MASK, pfc_en, cfg);
+	rpm_write(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL, cfg);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index ff580311edd0..2d2f5d150f03 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -33,7 +33,21 @@
 #define RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE	BIT_ULL(8)
 #define RPMX_MTI_MAC100X_COMMAND_CONFIG_PFC_MODE	BIT_ULL(19)
 #define RPMX_MTI_MAC100X_CL01_PAUSE_QUANTA		0x80A8
+#define RPMX_MTI_MAC100X_CL23_PAUSE_QUANTA		0x80B0
+#define RPMX_MTI_MAC100X_CL45_PAUSE_QUANTA		0x80B8
+#define RPMX_MTI_MAC100X_CL67_PAUSE_QUANTA		0x80C0
 #define RPMX_MTI_MAC100X_CL01_QUANTA_THRESH		0x80C8
+#define RPMX_MTI_MAC100X_CL23_QUANTA_THRESH		0x80D0
+#define RPMX_MTI_MAC100X_CL45_QUANTA_THRESH		0x80D8
+#define RPMX_MTI_MAC100X_CL67_QUANTA_THRESH		0x80E0
+#define RPMX_MTI_MAC100X_CL89_PAUSE_QUANTA		0x8108
+#define RPMX_MTI_MAC100X_CL1011_PAUSE_QUANTA		0x8110
+#define RPMX_MTI_MAC100X_CL1213_PAUSE_QUANTA		0x8118
+#define RPMX_MTI_MAC100X_CL1415_PAUSE_QUANTA		0x8120
+#define RPMX_MTI_MAC100X_CL89_QUANTA_THRESH		0x8128
+#define RPMX_MTI_MAC100X_CL1011_QUANTA_THRESH		0x8130
+#define RPMX_MTI_MAC100X_CL1213_QUANTA_THRESH		0x8138
+#define RPMX_MTI_MAC100X_CL1415_QUANTA_THRESH		0x8140
 #define RPM_DEFAULT_PAUSE_TIME			0xFFFF
 #define RPMX_CMR_RX_OVR_BP		0x4120
 #define RPMX_CMR_RX_OVR_BP_EN(x)	BIT_ULL((x) + 8)
@@ -45,6 +59,18 @@
 #define RPM_LMAC_FWI			0xa
 #define RPM_TX_EN			BIT_ULL(0)
 #define RPM_RX_EN			BIT_ULL(1)
+#define RPMX_CMRX_PRT_CBFC_CTL                         0x5B08
+#define RPMX_CMRX_PRT_CBFC_CTL_LOGL_EN_RX_SHIFT        33
+#define RPMX_CMRX_PRT_CBFC_CTL_PHYS_BP_SHIFT           16
+#define RPMX_CMRX_PRT_CBFC_CTL_LOGL_EN_TX_SHIFT        0
+#define RPM_PFC_CLASS_MASK			       GENMASK_ULL(48, 33)
+#define RPMX_MTI_MAC100X_CL89_QUANTA_THRESH		0x8128
+#define RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_PAD_EN              BIT_ULL(11)
+#define RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE           BIT_ULL(8)
+#define RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_FWD              BIT_ULL(7)
+#define RPMX_MTI_MAC100X_CL01_PAUSE_QUANTA              0x80A8
+#define RPMX_MTI_MAC100X_CL89_PAUSE_QUANTA		0x8108
+#define RPM_DEFAULT_PAUSE_TIME                          0xFFFF
 
 /* Function Declarations */
 int rpm_get_nr_lmacs(void *rpmd);
@@ -61,4 +87,6 @@ int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat);
 void rpm_lmac_ptp_config(void *rpmd, int lmac_id, bool enable);
 int rpm_lmac_rx_tx_enable(void *rpmd, int lmac_id, bool enable);
 int rpm_lmac_tx_enable(void *rpmd, int lmac_id, bool enable);
+int rpm_lmac_pfc_config(void *rpmd, int lmac_id, u8 tx_pause, u8 rx_pause,
+			u16 pfc_en);
 #endif /* RPM_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 8a7ac5a8b821..b2dac088dc43 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -1079,3 +1079,26 @@ int rvu_mbox_handler_cgx_mac_addr_update(struct rvu *rvu,
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	return cgx_lmac_addr_update(cgx_id, lmac_id, req->mac_addr, req->index);
 }
+
+int rvu_mbox_handler_cgx_prio_flow_ctrl_cfg(struct rvu *rvu,
+					    struct cgx_pfc_cfg *req,
+					    struct cgx_pfc_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	struct mac_ops *mac_ops;
+	u8 cgx_id, lmac_id;
+	void *cgxd;
+
+	/* This msg is expected only from PF/VFs that are mapped to CGX LMACs,
+	 * if received from other PF/VF simply ACK, nothing to do.
+	 */
+	if (!is_pf_cgxmapped(rvu, pf))
+		return -ENODEV;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+	mac_ops = get_mac_ops(cgxd);
+
+	return mac_ops->pfc_config(cgxd, lmac_id, req->tx_pause, req->rx_pause,
+				   req->pfc_en);
+}
-- 
2.17.1

