Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36EF76266EC
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbiKLEce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbiKLEcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:32:17 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB595EFA1;
        Fri, 11 Nov 2022 20:32:10 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AC4OnEp017067;
        Fri, 11 Nov 2022 20:32:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=rve2huJuQIiU1uMyG47vF9C57bb2WyhstZBzTXWwz60=;
 b=DmzFODg25TkpTofOrYPyjZFw0GX620s14LJjyAyLk86oiZwCCVUmWU9POB0W//TYvxAS
 zl9iTjeVq0gnh+QQr7XA5pUVFzkycOqv6rZTlBoHw5Viy94Ix0reAgxCP6dh3eo0YFYa
 z51DWxrOlbpuHTmB8RN3w6TTe+XLsLIQmakEKn3TOfy8AFw0Lq1NIp8WqbVbiEqkf53P
 GNVR42BrDSJt6UZsNMyL7wWdxLDkAVlCT7A5CZvaqBb1EzfRhpQnWrw4KiIRiogmOmiS
 dB+FDUtPsWisocuRWGJlCkf3rTNIb5rMCT8tmAUA0blP5iO4DG+amRhwcCdlA9/NFKde PQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kt1jn8by8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 20:32:00 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 11 Nov
 2022 20:31:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Nov 2022 20:31:58 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id E6CB03F7048;
        Fri, 11 Nov 2022 20:31:54 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH 3/9] octeontx2-af: Reset MAC specific csrs on FLR
Date:   Sat, 12 Nov 2022 10:01:35 +0530
Message-ID: <20221112043141.13291-4-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221112043141.13291-1-hkelam@marvell.com>
References: <20221112043141.13291-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: LVbdfr6u-taX1IF80UJebNKgI6hZZiw8
X-Proofpoint-ORIG-GUID: LVbdfr6u-taX1IF80UJebNKgI6hZZiw8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-12_02,2022-11-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PF or VF can configure MAC csrs to enable PFC/Pause frames etc.
But on FLR these csrs are not getting reset and have stale data.

This patch addresses the issue by resetting csrs on FLR.

Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 16 +++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  2 ++
 .../marvell/octeontx2/af/lmac_common.h        |  1 +
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 20 +++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  2 ++
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 18 +++++++++++++++++
 8 files changed, 61 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 242c5b0eb15d..f6ab85f01ee7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1544,6 +1544,21 @@ int cgx_lmac_linkup_start(void *cgxd)
 	return 0;
 }
 
+int cgx_lmac_reset(void *cgxd, int lmac_id)
+{
+	struct cgx *cgx = cgxd;
+	u64 cfg;
+
+	if (!is_lmac_valid(cgx, lmac_id))
+		return -ENODEV;
+
+	/* Resetting PFC related CSRs */
+	cfg = 0xff;
+	cgx_write(cgxd, lmac_id, CGXX_CMRX_RX_LOGL_XON, cfg);
+
+	return 0;
+}
+
 static int cgx_configure_interrupt(struct cgx *cgx, struct lmac *lmac,
 				   int cnt, bool req_free)
 {
@@ -1758,6 +1773,7 @@ static struct mac_ops	cgx_mac_ops    = {
 	.mac_tx_enable =		cgx_lmac_tx_enable,
 	.pfc_config =                   cgx_lmac_pfc_config,
 	.mac_get_pfc_frm_cfg   =        cgx_lmac_get_pfc_frm_cfg,
+	.mac_reset   =        cgx_lmac_reset,
 };
 
 static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index fb2d37676d84..9273b96f68d2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -36,6 +36,7 @@
 #define CGXX_CMRX_INT_ENA_W1S		0x058
 #define CGXX_CMRX_RX_ID_MAP		0x060
 #define CGXX_CMRX_RX_STAT0		0x070
+#define CGXX_CMRX_RX_LOGL_XON		0x100
 #define CGXX_CMRX_RX_LMACS		0x128
 #define CGXX_CMRX_RX_DMAC_CTL0		(0x1F8 + mac_ops->csr_offset)
 #define CGX_DMAC_CTL0_CAM_ENABLE	BIT_ULL(3)
@@ -182,4 +183,5 @@ int cgx_lmac_get_pfc_frm_cfg(void *cgxd, int lmac_id, u8 *tx_pause,
 			     u8 *rx_pause);
 int verify_lmac_fc_cfg(void *cgxd, int lmac_id, u8 tx_pause, u8 rx_pause,
 		       int pfvf_idx);
+int cgx_lmac_reset(void *cgxd, int lmac_id);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index 386fb73ad366..152c50bf6d1e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -125,6 +125,7 @@ struct mac_ops {
 
 	int                     (*mac_get_pfc_frm_cfg)(void *cgxd, int lmac_id,
 						       u8 *tx_pause, u8 *rx_pause);
+	int			(*mac_reset)(void *cgxd, int lmac_id);
 
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index a15a59d5dff8..d40aca0940bf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -36,6 +36,7 @@ static struct mac_ops		rpm_mac_ops   = {
 	.mac_tx_enable =		rpm_lmac_tx_enable,
 	.pfc_config =                   rpm_lmac_pfc_config,
 	.mac_get_pfc_frm_cfg   =        rpm_lmac_get_pfc_frm_cfg,
+	.mac_reset             =        rpm_lmac_reset,
 };
 
 static struct mac_ops		rpm2_mac_ops   = {
@@ -66,6 +67,7 @@ static struct mac_ops		rpm2_mac_ops   = {
 	.mac_tx_enable =		rpm_lmac_tx_enable,
 	.pfc_config =                   rpm_lmac_pfc_config,
 	.mac_get_pfc_frm_cfg   =        rpm_lmac_get_pfc_frm_cfg,
+	.mac_reset	       =        rpm_lmac_reset,
 };
 
 bool is_dev_rpm2(void *rpmd)
@@ -655,3 +657,21 @@ int  rpm_lmac_get_pfc_frm_cfg(void *rpmd, int lmac_id, u8 *tx_pause, u8 *rx_paus
 
 	return 0;
 }
+
+int rpm_lmac_reset(void *rpmd, int lmac_id)
+{
+	u64 rx_logl_xon, cfg;
+	rpm_t *rpm = rpmd;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return -ENODEV;
+
+	/* Resetting PFC related CSRs */
+	rx_logl_xon = is_dev_rpm2(rpm) ? RPM2_CMRX_RX_LOGL_XON :
+					 RPMX_CMRX_RX_LOGL_XON;
+	cfg = 0xff;
+
+	rpm_write(rpm, lmac_id, rx_logl_xon, cfg);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index fc20a35bd8f9..4b28b9879995 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -52,6 +52,7 @@
 #define RPMX_MTI_MAC100X_CL1011_QUANTA_THRESH		0x8130
 #define RPMX_MTI_MAC100X_CL1213_QUANTA_THRESH		0x8138
 #define RPMX_MTI_MAC100X_CL1415_QUANTA_THRESH		0x8140
+#define RPMX_CMRX_RX_LOGL_XON		0x4100
 #define RPMX_CMR_RX_OVR_BP		0x4120
 #define RPMX_CMR_RX_OVR_BP_EN(x)	BIT_ULL((x) + 8)
 #define RPMX_CMR_RX_OVR_BP_BP(x)	BIT_ULL((x) + 4)
@@ -117,6 +118,7 @@ int rpm_lmac_pfc_config(void *rpmd, int lmac_id, u8 tx_pause, u8 rx_pause,
 			u16 pfc_en);
 int rpm_lmac_get_pfc_frm_cfg(void *rpmd, int lmac_id, u8 *tx_pause,
 			     u8 *rx_pause);
+int rpm_lmac_reset(void *rpmd, int lmac_id);
 int rpm2_get_nr_lmacs(void *rpmd);
 bool is_dev_rpm2(void *rpmd);
 #endif /* RPM_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 3f5e09b77d4b..b937f3c5938f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2590,6 +2590,7 @@ static void __rvu_flr_handler(struct rvu *rvu, u16 pcifunc)
 	 * Since LF is detached use LF number as -1.
 	 */
 	rvu_npc_free_mcam_entries(rvu, pcifunc, -1);
+	rvu_mac_reset(rvu, pcifunc);
 
 	mutex_unlock(&rvu->flr_lock);
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index f43b8e80135b..7423d50d99dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -847,6 +847,7 @@ int rvu_cgx_config_tx(void *cgxd, int lmac_id, bool enable);
 int rvu_cgx_prio_flow_ctrl_cfg(struct rvu *rvu, u16 pcifunc, u8 tx_pause, u8 rx_pause,
 			       u16 pfc_en);
 int rvu_cgx_cfg_pause_frm(struct rvu *rvu, u16 pcifunc, u8 tx_pause, u8 rx_pause);
+void rvu_mac_reset(struct rvu *rvu, u16 pcifunc);
 u32 rvu_cgx_get_lmac_fifolen(struct rvu *rvu, int cgx, int lmac);
 int npc_get_nixlf_mcam_index(struct npc_mcam *mcam, u16 pcifunc, int nixlf,
 			     int type);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 53580e0381c9..3fa828feb6cd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -1246,3 +1246,21 @@ int rvu_mbox_handler_cgx_prio_flow_ctrl_cfg(struct rvu *rvu,
 	mac_ops->mac_get_pfc_frm_cfg(cgxd, lmac_id, &rsp->tx_pause, &rsp->rx_pause);
 	return err;
 }
+
+void rvu_mac_reset(struct rvu *rvu, u16 pcifunc)
+{
+	int pf = rvu_get_pf(pcifunc);
+	struct mac_ops *mac_ops;
+	struct cgx *cgxd;
+	u8 cgx, lmac;
+
+	if (!is_pf_cgxmapped(rvu, pf))
+		return;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx, &lmac);
+	cgxd = rvu_cgx_pdata(cgx, rvu);
+	mac_ops = get_mac_ops(cgxd);
+
+	if (mac_ops->mac_reset(cgxd, lmac))
+		dev_err(rvu->dev, "Failed to reset MAC\n");
+}
-- 
2.17.1

