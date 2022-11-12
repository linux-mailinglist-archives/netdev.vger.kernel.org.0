Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618F16266F2
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbiKLEc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbiKLEcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:32:19 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347F35F875;
        Fri, 11 Nov 2022 20:32:14 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AC3ewmd005896;
        Fri, 11 Nov 2022 20:32:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=4q3tmmlL79Fbns+C12MPKAKqvodXxPP2wpfNKelR2cw=;
 b=aIm/jz1KO+s+gSMmcQ6WOe3PtZnLv8DVS5K5dcD+5sSzFF5Qb6aFY8I/5Y2kLQjg0Zp+
 4cEHsvmuPpU+CVVrcMhUKVt6+K8ZNFDdc2X5KQxg9lQ82BAebr67DNdY1K5hJPAMScDK
 fPUaNHBsp1zZpnt1FUd/nz4jucM5CDJg0mXtWUaH9QLyzSDzsR3L+cSAUW4lD+PfPnSt
 OeR0fhprxmnkjsvGZ5n/VwPwkpQYSMgNVx7jREdwIePNELBmCRZVFg8up/Kavbv3nele
 p+3rjBwu8k7D9eLscjrU+ue/YPOTvnv2lHQhbrMuYwQD3t54rr4PL/l9i+oQ5nIhdC0g Zw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kt1nv0bef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 20:32:08 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Nov
 2022 20:32:06 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Nov 2022 20:32:06 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id E97013F704E;
        Fri, 11 Nov 2022 20:32:02 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH 5/9] octeontx2-af: Add support for RPM FEC stats
Date:   Sat, 12 Nov 2022 10:01:37 +0530
Message-ID: <20221112043141.13291-6-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221112043141.13291-1-hkelam@marvell.com>
References: <20221112043141.13291-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: DiP55cuXW17HGbgzyjPHpfdKISuXuGSb
X-Proofpoint-GUID: DiP55cuXW17HGbgzyjPHpfdKISuXuGSb
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

RPM/CGX blocks support both RS-FEC and BASER modes.
This patch adds support to display these FEC stats.

FEC stats are integrated to below file
cat /sys/kernel/debug/cn10k/rpm/rpmx/lmacx/stats

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   |  5 ++
 .../marvell/octeontx2/af/lmac_common.h        |  3 ++
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 51 +++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rpm.h   | 14 ++++-
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  4 +-
 .../marvell/octeontx2/af/rvu_debugfs.c        | 11 ++++
 6 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 942ad87905e9..1b194b2da7cc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -752,6 +752,10 @@ int cgx_get_fec_stats(void *cgxd, int lmac_id, struct cgx_fec_stats_rsp *rsp)
 
 	if (!cgx || lmac_id >= cgx->lmac_count)
 		return -ENODEV;
+
+	if (cgx->lmac_idmap[lmac_id]->link_info.fec == OTX2_FEC_NONE)
+		return 0;
+
 	fec_stats_count =
 		cgx_set_fec_stats_count(&cgx->lmac_idmap[lmac_id]->link_info);
 	if (cgx->lmac_idmap[lmac_id]->link_info.fec == OTX2_FEC_BASER) {
@@ -1774,6 +1778,7 @@ static struct mac_ops	cgx_mac_ops    = {
 	.mac_lmac_intl_lbk =    cgx_lmac_internal_loopback,
 	.mac_get_rx_stats  =	cgx_get_rx_stats,
 	.mac_get_tx_stats  =	cgx_get_tx_stats,
+	.get_fec_stats	   =	cgx_get_fec_stats,
 	.mac_enadis_rx_pause_fwding =	cgx_lmac_enadis_rx_pause_fwding,
 	.mac_get_pause_frm_status =	cgx_lmac_get_pause_frm_status,
 	.mac_enadis_pause_frm =		cgx_lmac_enadis_pause_frm,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index 18b03940b34b..120f04bfa988 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -128,6 +128,9 @@ struct mac_ops {
 	int			(*mac_reset)(void *cgxd, int lmac_id);
 	u64			(*get_dmacflt_dropped_pktcnt)(void *cgxd, int lmac_id);
 
+	/* FEC stats */
+	int			(*get_fec_stats)(void *cgxd, int lmac_id,
+						 struct cgx_fec_stats_rsp *rsp);
 };
 
 struct cgx {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 641d82000768..6aa1c6a0e02c 100644
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
@@ -59,6 +60,7 @@ static struct mac_ops		rpm2_mac_ops   = {
 	.mac_lmac_intl_lbk =    rpm_lmac_internal_loopback,
 	.mac_get_rx_stats  =	rpm_get_rx_stats,
 	.mac_get_tx_stats  =	rpm_get_tx_stats,
+	.get_fec_stats	   =	rpm_get_fec_stats,
 	.mac_enadis_rx_pause_fwding =	rpm_lmac_enadis_rx_pause_fwding,
 	.mac_get_pause_frm_status =	rpm_lmac_get_pause_frm_status,
 	.mac_enadis_pause_frm =		rpm_lmac_enadis_pause_frm,
@@ -436,6 +438,55 @@ int rpm_get_tx_stats(void *rpmd, int lmac_id, int idx, u64 *tx_stat)
 	return 0;
 }
 
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
+		rsp->fec_corr_blks = (val_hi << 32 | val_lo);
+
+		val_lo = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_VL0_NCCW_LO);
+		val_hi = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_CW_HI);
+		rsp->fec_uncorr_blks = (val_hi << 32 | val_lo);
+
+		/* 50G uses 2 Physical serdes lines */
+		if (rpm->lmac_idmap[lmac_id]->link_info.lmac_type_id == LMAC_MODE_50G_R) {
+			val_lo = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_VL1_CCW_LO);
+			val_hi = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_CW_HI);
+			rsp->fec_corr_blks += (val_hi << 32 | val_lo);
+
+			val_lo = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_VL1_NCCW_LO);
+			val_hi = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_CW_HI);
+			rsp->fec_uncorr_blks += (val_hi << 32 | val_lo);
+		}
+	} else {
+		/* enable RS-FEC capture */
+		cfg = rpm_read(rpm, 0, RPMX_MTI_STAT_STATN_CONTROL);
+		cfg |= RPMX_RSFEC_RX_CAPTURE | BIT(lmac_id);
+		rpm_write(rpm, 0, RPMX_MTI_STAT_STATN_CONTROL, cfg);
+
+		val_lo = rpm_read(rpm, 0, RPMX_MTI_RSFEC_STAT_COUNTER_CAPTURE_2);
+		val_hi = rpm_read(rpm, 0, RPMX_MTI_STAT_DATA_HI_CDC);
+		rsp->fec_corr_blks = (val_hi << 32 | val_lo);
+
+		val_lo = rpm_read(rpm, 0, RPMX_MTI_RSFEC_STAT_COUNTER_CAPTURE_3);
+		val_hi = rpm_read(rpm, 0, RPMX_MTI_STAT_DATA_HI_CDC);
+		rsp->fec_uncorr_blks = (val_hi << 32 | val_lo);
+	}
+
+	return 0;
+}
+
 u64 rpm_get_dmacflt_dropped_pktcnt(void *rpmd, int lmac_id)
 {
 	rpm_t *rpm = rpmd;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index 8ed2f9c9624b..c86066d2052f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -25,7 +25,6 @@
 #define RPMX_CMRX_SW_INT_ENA_W1S        0x198
 #define RPMX_CMRX_LINK_CFG		0x1070
 #define RPMX_MTI_PCS100X_CONTROL1       0x20000
-#define RPMX_MTI_LPCSX_CONTROL1         0x30000
 #define RPMX_MTI_PCS_LBK                BIT_ULL(14)
 #define RPMX_MTI_LPCSX_CONTROL(id)     (0x30000 | ((id) * 0x100))
 
@@ -82,6 +81,18 @@
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
@@ -111,6 +122,7 @@ int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
 			      u8 rx_pause);
 int rpm_get_tx_stats(void *rpmd, int lmac_id, int idx, u64 *tx_stat);
 int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat);
+int rpm_get_fec_stats(void *cgxd, int lmac_id, struct cgx_fec_stats_rsp *rsp);
 u64 rpm_get_dmacflt_dropped_pktcnt(void *rpmd, int lmac_id);
 void rpm_lmac_ptp_config(void *rpmd, int lmac_id, bool enable);
 int rpm_lmac_rx_tx_enable(void *rpmd, int lmac_id, bool enable);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 3124aed1806f..fb3e5f1dbe3a 100644
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
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index c5a0076b8082..b038ca855221 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2388,6 +2388,7 @@ static void rvu_dbg_npa_init(struct rvu *rvu)
 static int cgx_print_stats(struct seq_file *s, int lmac_id)
 {
 	struct cgx_link_user_info linfo;
+	struct cgx_fec_stats_rsp fec_rsp;
 	struct mac_ops *mac_ops;
 	void *cgxd = s->private;
 	u64 ucast, mcast, bcast;
@@ -2488,6 +2489,16 @@ static int cgx_print_stats(struct seq_file *s, int lmac_id)
 		stat++;
 	}
 
+	fec_rsp.fec_corr_blks = 0;
+	fec_rsp.fec_uncorr_blks = 0;
+
+	seq_printf(s, "\n=======%s FEC_STATS======\n\n", mac_ops->name);
+	err = mac_ops->get_fec_stats(cgxd, lmac_id, &fec_rsp);
+	if (err)
+		return err;
+	seq_printf(s, "Fec Corrected Errors:  %llu\n",  fec_rsp.fec_corr_blks);
+	seq_printf(s, "Fec Uncorrected Errors: %llu\n", fec_rsp.fec_uncorr_blks);
+
 	return err;
 }
 
-- 
2.17.1

