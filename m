Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615E463F70B
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiLASBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiLASBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:01:16 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C0EB5D92;
        Thu,  1 Dec 2022 10:01:07 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1DknnL015716;
        Thu, 1 Dec 2022 10:01:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=EEHLQDJqY4pf2q9ETg4Y+uD1vZVXrRTOAJ8XDXPyWjA=;
 b=AYIssinM9TKetDSL7z4FLgNXU75ikohUHwIICrVkY/L8nlJJLJu8w2TMNXBNjqR1+pGT
 zbQM4TE6btASyFqeDaxlnlZq9PSSWLd9bN5XPiJe2IHMyYCY+WCJD6QfNXAJG/yfnxJ4
 YfQQqDjpo5ZZC4Ggyl6LM6VkIjv5zmabUOT/1PVY6ZuEHGIz7yhVSQkdRljle33Hp7CA
 5X3visRfcDlaVk7JhOydXFKtKPPRnrt1HD6nGK4Bt093PCknSS+kyjrWsWlo+zSK9bPD
 vzjSshhY50Abt8WDs9yYTidVazKVVmRLTENsDp9diL/IbU3BJ9kQUg4n7HkME1P7ut0t rQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m6k712xys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 10:01:01 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 1 Dec
 2022 10:00:59 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 1 Dec 2022 10:00:59 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 687AC3F7045;
        Thu,  1 Dec 2022 10:00:56 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH v3 4/4] octeontx2-af: Add FEC stats for RPM/RPM_USX block
Date:   Thu, 1 Dec 2022 23:30:40 +0530
Message-ID: <20221201180040.14147-5-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221201180040.14147-1-hkelam@marvell.com>
References: <20221201180040.14147-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 3AOGQk0OSsRpOoauV8yrhAhfz4jkjzOb
X-Proofpoint-GUID: 3AOGQk0OSsRpOoauV8yrhAhfz4jkjzOb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_12,2022-12-01_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CN10K silicon MAC block RPM and CN10KB silicon MAC block RPM_USX
both support BASER and RSFEC modes.

Also MAC (CGX) on OcteonTx2 silicon variants and MAC (RPM) on
OcteonTx3 CN10K are different and FEC stats need to be read
differently. CN10KB MAC block (RPM_USX) fec csr offsets are same
as CN10K MAC block (RPM) mac_ops points to same fn(). Upper layer
interface between  RVU AF and PF netdev is  kept same. Based on
silicon variant appropriate fn() pointer is called to  read FEC stats

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   |  5 ++
 .../marvell/octeontx2/af/lmac_common.h        |  3 +
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 58 +++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rpm.h   | 14 ++++-
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  4 +-
 5 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 242c5b0eb15d..b2b71fe80d61 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -742,6 +742,10 @@ int cgx_get_fec_stats(void *cgxd, int lmac_id, struct cgx_fec_stats_rsp *rsp)
 
 	if (!cgx || lmac_id >= cgx->lmac_count)
 		return -ENODEV;
+
+	if (cgx->lmac_idmap[lmac_id]->link_info.fec == OTX2_FEC_NONE)
+		return 0;
+
 	fec_stats_count =
 		cgx_set_fec_stats_count(&cgx->lmac_idmap[lmac_id]->link_info);
 	if (cgx->lmac_idmap[lmac_id]->link_info.fec == OTX2_FEC_BASER) {
@@ -1749,6 +1753,7 @@ static struct mac_ops	cgx_mac_ops    = {
 	.mac_lmac_intl_lbk =    cgx_lmac_internal_loopback,
 	.mac_get_rx_stats  =	cgx_get_rx_stats,
 	.mac_get_tx_stats  =	cgx_get_tx_stats,
+	.get_fec_stats	   =	cgx_get_fec_stats,
 	.mac_enadis_rx_pause_fwding =	cgx_lmac_enadis_rx_pause_fwding,
 	.mac_get_pause_frm_status =	cgx_lmac_get_pause_frm_status,
 	.mac_enadis_pause_frm =		cgx_lmac_enadis_pause_frm,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index 386fb73ad366..39aaf0e4467d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -126,6 +126,9 @@ struct mac_ops {
 	int                     (*mac_get_pfc_frm_cfg)(void *cgxd, int lmac_id,
 						       u8 *tx_pause, u8 *rx_pause);
 
+	/* FEC stats */
+	int			(*get_fec_stats)(void *cgxd, int lmac_id,
+						 struct cgx_fec_stats_rsp *rsp);
 };
 
 struct cgx {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index a15a59d5dff8..de0d88dd10d6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -27,6 +27,7 @@ static struct mac_ops		rpm_mac_ops   = {
 	.mac_lmac_intl_lbk =    rpm_lmac_internal_loopback,
 	.mac_get_rx_stats  =	rpm_get_rx_stats,
 	.mac_get_tx_stats  =	rpm_get_tx_stats,
+	.get_fec_stats	   =	rpm_get_fec_stats,
 	.mac_enadis_rx_pause_fwding =	rpm_lmac_enadis_rx_pause_fwding,
 	.mac_get_pause_frm_status =	rpm_lmac_get_pause_frm_status,
 	.mac_enadis_pause_frm =		rpm_lmac_enadis_pause_frm,
@@ -57,6 +58,7 @@ static struct mac_ops		rpm2_mac_ops   = {
 	.mac_lmac_intl_lbk =    rpm_lmac_internal_loopback,
 	.mac_get_rx_stats  =	rpm_get_rx_stats,
 	.mac_get_tx_stats  =	rpm_get_tx_stats,
+	.get_fec_stats	   =	rpm_get_fec_stats,
 	.mac_enadis_rx_pause_fwding =	rpm_lmac_enadis_rx_pause_fwding,
 	.mac_get_pause_frm_status =	rpm_lmac_get_pause_frm_status,
 	.mac_enadis_pause_frm =		rpm_lmac_enadis_pause_frm,
@@ -655,3 +657,59 @@ int  rpm_lmac_get_pfc_frm_cfg(void *rpmd, int lmac_id, u8 *tx_pause, u8 *rx_paus
 
 	return 0;
 }
+
+int rpm_get_fec_stats(void *rpmd, int lmac_id, struct cgx_fec_stats_rsp *rsp)
+{
+	u64 val_lo, val_hi;
+	rpm_t *rpm = rpmd;
+	u64 cfg;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return -ENODEV;
+
+	if (rpm->lmac_idmap[lmac_id]->link_info.fec == OTX2_FEC_NONE)
+		return 0;
+
+	if (rpm->lmac_idmap[lmac_id]->link_info.fec == OTX2_FEC_BASER) {
+		val_lo = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_VL0_CCW_LO);
+		val_hi = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_CW_HI);
+		rsp->fec_corr_blks = (val_hi << 16 | val_lo);
+
+		val_lo = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_VL0_NCCW_LO);
+		val_hi = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_CW_HI);
+		rsp->fec_uncorr_blks = (val_hi << 16 | val_lo);
+
+		/* 50G uses 2 Physical serdes lines */
+		if (rpm->lmac_idmap[lmac_id]->link_info.lmac_type_id ==
+		    LMAC_MODE_50G_R) {
+			val_lo = rpm_read(rpm, lmac_id,
+					  RPMX_MTI_FCFECX_VL1_CCW_LO);
+			val_hi = rpm_read(rpm, lmac_id,
+					  RPMX_MTI_FCFECX_CW_HI);
+			rsp->fec_corr_blks += (val_hi << 16 | val_lo);
+
+			val_lo = rpm_read(rpm, lmac_id,
+					  RPMX_MTI_FCFECX_VL1_NCCW_LO);
+			val_hi = rpm_read(rpm, lmac_id,
+					  RPMX_MTI_FCFECX_CW_HI);
+			rsp->fec_uncorr_blks += (val_hi << 16 | val_lo);
+		}
+	} else {
+		/* enable RS-FEC capture */
+		cfg = rpm_read(rpm, 0, RPMX_MTI_STAT_STATN_CONTROL);
+		cfg |= RPMX_RSFEC_RX_CAPTURE | BIT(lmac_id);
+		rpm_write(rpm, 0, RPMX_MTI_STAT_STATN_CONTROL, cfg);
+
+		val_lo = rpm_read(rpm, 0,
+				  RPMX_MTI_RSFEC_STAT_COUNTER_CAPTURE_2);
+		val_hi = rpm_read(rpm, 0, RPMX_MTI_STAT_DATA_HI_CDC);
+		rsp->fec_corr_blks = (val_hi << 32 | val_lo);
+
+		val_lo = rpm_read(rpm, 0,
+				  RPMX_MTI_RSFEC_STAT_COUNTER_CAPTURE_3);
+		val_hi = rpm_read(rpm, 0, RPMX_MTI_STAT_DATA_HI_CDC);
+		rsp->fec_uncorr_blks = (val_hi << 32 | val_lo);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index fc20a35bd8f9..22147b4c2137 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -25,7 +25,6 @@
 #define RPMX_CMRX_SW_INT_ENA_W1S        0x198
 #define RPMX_CMRX_LINK_CFG		0x1070
 #define RPMX_MTI_PCS100X_CONTROL1       0x20000
-#define RPMX_MTI_LPCSX_CONTROL1         0x30000
 #define RPMX_MTI_PCS_LBK                BIT_ULL(14)
 #define RPMX_MTI_LPCSX_CONTROL(id)     (0x30000 | ((id) * 0x100))
 
@@ -81,6 +80,18 @@
 #define RPMX_TS_BINARY_MODE				BIT_ULL(11)
 #define RPMX_CONST1					0x2008
 
+/* FEC stats */
+#define RPMX_MTI_STAT_STATN_CONTROL			0x10018
+#define RPMX_MTI_STAT_DATA_HI_CDC			0x10038
+#define RPMX_RSFEC_RX_CAPTURE				BIT_ULL(27)
+#define RPMX_MTI_RSFEC_STAT_COUNTER_CAPTURE_2		0x40050
+#define RPMX_MTI_RSFEC_STAT_COUNTER_CAPTURE_3		0x40058
+#define RPMX_MTI_FCFECX_VL0_CCW_LO			0x38618
+#define RPMX_MTI_FCFECX_VL0_NCCW_LO			0x38620
+#define RPMX_MTI_FCFECX_VL1_CCW_LO			0x38628
+#define RPMX_MTI_FCFECX_VL1_NCCW_LO			0x38630
+#define RPMX_MTI_FCFECX_CW_HI				0x38638
+
 /* CN10KB CSR Declaration */
 #define  RPM2_CMRX_SW_INT				0x1b0
 #define  RPM2_CMRX_SW_INT_ENA_W1S			0x1b8
@@ -119,4 +130,5 @@ int rpm_lmac_get_pfc_frm_cfg(void *rpmd, int lmac_id, u8 *tx_pause,
 			     u8 *rx_pause);
 int rpm2_get_nr_lmacs(void *rpmd);
 bool is_dev_rpm2(void *rpmd);
+int rpm_get_fec_stats(void *cgxd, int lmac_id, struct cgx_fec_stats_rsp *rsp);
 #endif /* RPM_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 53580e0381c9..438b212fb54a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -579,6 +579,7 @@ int rvu_mbox_handler_cgx_fec_stats(struct rvu *rvu,
 				   struct cgx_fec_stats_rsp *rsp)
 {
 	int pf = rvu_get_pf(req->hdr.pcifunc);
+	struct mac_ops *mac_ops;
 	u8 cgx_idx, lmac;
 	void *cgxd;
 
@@ -587,7 +588,8 @@ int rvu_mbox_handler_cgx_fec_stats(struct rvu *rvu,
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
 
 	cgxd = rvu_cgx_pdata(cgx_idx, rvu);
-	return cgx_get_fec_stats(cgxd, lmac, rsp);
+	mac_ops = get_mac_ops(cgxd);
+	return  mac_ops->get_fec_stats(cgxd, lmac, rsp);
 }
 
 int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
-- 
2.17.1

