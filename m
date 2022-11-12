Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7031C6266F4
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbiKLEdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbiKLEcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:32:20 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5315CD3F;
        Fri, 11 Nov 2022 20:32:17 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AC3j0Lq015249;
        Fri, 11 Nov 2022 20:32:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=yJ7s/wloifKFUsreyhXIVgx6S/4erQGBiZyHWg7LjQc=;
 b=PTe8vaxeQ9WpTt6L+9sL0F2llhHgtzJV8On0JuQmvwWrOFa0eqno1NqYvunIBxSduRHg
 +p+oBtzGw2oLpL/j4jzduALgYVhCxJNIGp6YS2G8cU/OJrYsM2EXLAExO0AdtF9/rxw1
 LCTgmjEtHABosYCeGHXNRkVhiO0f6ibD6GQX1ZDqeLzNd2miwmKrLsiz1PlpeLGYlqLT
 vZ8zmaQdbCsRCxww3kAQVAm3nozz1X5QV5jfLDBRcx2h2D+9oX761y7PM1E8H6fcBjMA
 NOsCzRtcy8cmoN0TW/RWIb8yJTcz3ZYRb54yd066Go9WTO6dhnHuok+VcadL4MREQIlc 8g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kt1nv0bep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 20:32:12 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Nov
 2022 20:32:10 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 11 Nov 2022 20:32:10 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id EA4C63F7043;
        Fri, 11 Nov 2022 20:32:06 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH 6/9] octeontx2-af: Reset MAC block RX/TX statistics
Date:   Sat, 12 Nov 2022 10:01:38 +0530
Message-ID: <20221112043141.13291-7-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221112043141.13291-1-hkelam@marvell.com>
References: <20221112043141.13291-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7P6t_1-nt1tdqOdPTnLmzAOwA0uO-IEi
X-Proofpoint-GUID: 7P6t_1-nt1tdqOdPTnLmzAOwA0uO-IEi
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

From: Revital Regev <revitalm@marvell.com>

Each PF netdev is assigned with MAC and LMAC pair on the init.
This patch adds support to reset statistics of LMAC assigned with PF
netdev and adds lmac validation before accessing the same.

Signed-off-by: Revital Regev <revitalm@marvell.com>
Signed-off-by: Angela Czubak <aczubak@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 64 +++++++++++++++----
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  1 +
 .../marvell/octeontx2/af/lmac_common.h        |  2 +
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  1 +
 .../net/ethernet/marvell/octeontx2/af/rpm.c   |  7 ++
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 29 +++++++++
 7 files changed, 94 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 1b194b2da7cc..1383d1636cbe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -24,6 +24,8 @@
 #define DRV_NAME	"Marvell-CGX/RPM"
 #define DRV_STRING      "Marvell CGX/RPM Driver"
 
+#define CGX_RX_STAT_GLOBAL_INDEX	9
+
 static LIST_HEAD(cgx_list);
 
 /* Convert firmware speed encoding to user format(Mbps) */
@@ -169,6 +171,9 @@ void cgx_lmac_write(int cgx_id, int lmac_id, u64 offset, u64 val)
 {
 	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
 
+	/* Software must not access disabled LMAC registers */
+	if (!is_lmac_valid(cgx_dev, lmac_id))
+		return;
 	cgx_write(cgx_dev, lmac_id, offset, val);
 }
 
@@ -176,6 +181,9 @@ u64 cgx_lmac_read(int cgx_id, int lmac_id, u64 offset)
 {
 	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
 
+	/* Software must not access disabled LMAC registers */
+	if (!is_lmac_valid(cgx_dev, lmac_id))
+		return 0;
 	return cgx_read(cgx_dev, lmac_id, offset);
 }
 
@@ -242,6 +250,9 @@ int cgx_lmac_addr_set(u8 cgx_id, u8 lmac_id, u8 *mac_addr)
 	int index, id;
 	u64 cfg;
 
+	if (!lmac)
+		return -ENODEV;
+
 	/* access mac_ops to know csr_offset */
 	mac_ops = cgx_dev->mac_ops;
 
@@ -559,15 +570,16 @@ void cgx_lmac_promisc_config(int cgx_id, int lmac_id, bool enable)
 {
 	struct cgx *cgx = cgx_get_pdata(cgx_id);
 	struct lmac *lmac = lmac_pdata(lmac_id, cgx);
-	u16 max_dmac = lmac->mac_to_index_bmap.max;
 	struct mac_ops *mac_ops;
+	u16 max_dmac;
 	int index, i;
 	u64 cfg = 0;
 	int id;
 
-	if (!cgx)
+	if (!cgx || !lmac)
 		return;
 
+	max_dmac = lmac->mac_to_index_bmap.max;
 	id = get_sequence_id_of_lmac(cgx, lmac_id);
 
 	mac_ops = cgx->mac_ops;
@@ -687,6 +699,11 @@ int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat)
 
 	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
+
+	/* pass lmac as 0 for CGX_CMR_RX_STAT9-12 */
+	if (idx >= CGX_RX_STAT_GLOBAL_INDEX)
+		lmac_id = 0;
+
 	*rx_stat =  cgx_read(cgx, lmac_id, CGXX_CMRX_RX_STAT0 + (idx * 8));
 	return 0;
 }
@@ -711,6 +728,30 @@ u64 cgx_get_dmacflt_dropped_pktcnt(void *cgxd, int lmac_id)
 	return cgx_read(cgx, lmac_id, CGXX_CMRX_RX_STAT4);
 }
 
+int cgx_stats_rst(void *cgxd, int lmac_id)
+{
+	struct cgx *cgx = cgxd;
+	int stat_id;
+
+	if (!is_lmac_valid(cgx, lmac_id))
+		return -ENODEV;
+
+	for (stat_id = 0 ; stat_id < CGX_RX_STATS_COUNT; stat_id++) {
+		if (stat_id >= CGX_RX_STAT_GLOBAL_INDEX)
+		/* pass lmac as 0 for CGX_CMR_RX_STAT9-12 */
+			cgx_write(cgx, 0,
+				  (CGXX_CMRX_RX_STAT0 + (stat_id * 8)), 0);
+		else
+			cgx_write(cgx, lmac_id,
+				  (CGXX_CMRX_RX_STAT0 + (stat_id * 8)), 0);
+	}
+
+	for (stat_id = 0 ; stat_id < CGX_TX_STATS_COUNT; stat_id++)
+		cgx_write(cgx, lmac_id, CGXX_CMRX_TX_STAT0 + (stat_id * 8), 0);
+
+	return 0;
+}
+
 u64 cgx_features_get(void *cgxd)
 {
 	return ((struct cgx *)cgxd)->hw_features;
@@ -750,7 +791,7 @@ int cgx_get_fec_stats(void *cgxd, int lmac_id, struct cgx_fec_stats_rsp *rsp)
 	int corr_reg, uncorr_reg;
 	struct cgx *cgx = cgxd;
 
-	if (!cgx || lmac_id >= cgx->lmac_count)
+	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 
 	if (cgx->lmac_idmap[lmac_id]->link_info.fec == OTX2_FEC_NONE)
@@ -784,9 +825,9 @@ int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable)
 
 	cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_CFG);
 	if (enable)
-		cfg |= CMR_EN | DATA_PKT_RX_EN | DATA_PKT_TX_EN;
+		cfg |=  DATA_PKT_RX_EN | DATA_PKT_TX_EN;
 	else
-		cfg &= ~(CMR_EN | DATA_PKT_RX_EN | DATA_PKT_TX_EN);
+		cfg &= ~(DATA_PKT_RX_EN | DATA_PKT_TX_EN);
 	cgx_write(cgx, lmac_id, CGXX_CMRX_CFG, cfg);
 	return 0;
 }
@@ -1724,7 +1765,7 @@ static int cgx_lmac_exit(struct cgx *cgx)
 		lmac = cgx->lmac_idmap[i];
 		if (!lmac)
 			continue;
-		cgx->mac_ops->mac_pause_frm_config(cgx, lmac->lmac_id, false);
+		cgx->mac_ops->mac_pause_frm_config(cgx, i, false);
 		cgx_configure_interrupt(cgx, lmac, lmac->lmac_id, true);
 		kfree(lmac->mac_to_index_bmap.bmap);
 		kfree(lmac->name);
@@ -1790,6 +1831,7 @@ static struct mac_ops	cgx_mac_ops    = {
 	.mac_get_pfc_frm_cfg   =        cgx_lmac_get_pfc_frm_cfg,
 	.mac_reset                       =      cgx_lmac_reset,
 	.get_dmacflt_dropped_pktcnt      =      cgx_get_dmacflt_dropped_pktcnt,
+	.mac_stats_rst			 =      cgx_stats_rst,
 };
 
 static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -1863,7 +1905,6 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	list_add(&cgx->cgx_list, &cgx_list);
 
-
 	cgx_populate_features(cgx);
 
 	mutex_init(&cgx->lock);
@@ -1891,10 +1932,11 @@ static void cgx_remove(struct pci_dev *pdev)
 {
 	struct cgx *cgx = pci_get_drvdata(pdev);
 
-	if (cgx) {
-		cgx_lmac_exit(cgx);
-		list_del(&cgx->cgx_list);
-	}
+	if (!cgx)
+		return;
+
+	cgx_lmac_exit(cgx);
+	list_del(&cgx->cgx_list);
 	pci_free_irq_vectors(pdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 2bdf6de244c3..a34f45367d82 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -142,6 +142,7 @@ int cgx_lmac_evh_register(struct cgx_event_cb *cb, void *cgxd, int lmac_id);
 int cgx_lmac_evh_unregister(void *cgxd, int lmac_id);
 int cgx_get_tx_stats(void *cgxd, int lmac_id, int idx, u64 *tx_stat);
 int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat);
+int cgx_stats_rst(void *cgxd, int lmac_id);
 int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable);
 int cgx_lmac_tx_enable(void *cgxd, int lmac_id, bool enable);
 int cgx_lmac_addr_set(u8 cgx_id, u8 lmac_id, u8 *mac_addr);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index 120f04bfa988..e176abfdeae7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -131,6 +131,8 @@ struct mac_ops {
 	/* FEC stats */
 	int			(*get_fec_stats)(void *cgxd, int lmac_id,
 						 struct cgx_fec_stats_rsp *rsp);
+
+	int			 (*mac_stats_rst)(void *cgxd, int lmac_id);
 };
 
 struct cgx {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 8d5d5a0f68c4..260c48ba2c98 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -166,6 +166,7 @@ M(CGX_FEC_STATS,	0x217, cgx_fec_stats, msg_req, cgx_fec_stats_rsp) \
 M(CGX_SET_LINK_MODE,	0x218, cgx_set_link_mode, cgx_set_link_mode_req,\
 			       cgx_set_link_mode_rsp)	\
 M(CGX_GET_PHY_FEC_STATS, 0x219, cgx_get_phy_fec_stats, msg_req, msg_rsp) \
+M(CGX_STATS_RST,	0x21A, cgx_stats_rst, msg_req, msg_rsp)		\
 M(CGX_FEATURES_GET,	0x21B, cgx_features_get, msg_req,		\
 			       cgx_features_info_msg)			\
 M(RPM_STATS,		0x21C, rpm_stats, msg_req, rpm_stats_rsp)	\
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 6aa1c6a0e02c..f0e20822492b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -72,6 +72,7 @@ static struct mac_ops		rpm2_mac_ops   = {
 	.mac_get_pfc_frm_cfg   =        rpm_lmac_get_pfc_frm_cfg,
 	.mac_reset	       =        rpm_lmac_reset,
 	.get_dmacflt_dropped_pktcnt =   rpm_get_dmacflt_dropped_pktcnt,
+	.mac_stats_rst		=	rpm_stats_rst,
 };
 
 bool is_dev_rpm2(void *rpmd)
@@ -742,3 +743,9 @@ int rpm_lmac_reset(void *rpmd, int lmac_id)
 
 	return 0;
 }
+
+int rpm_stats_rst(void *rpmd, int lmac_id)
+{
+	//Todo implement stats reset
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index c86066d2052f..217533506f7c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -134,4 +134,5 @@ int rpm_lmac_get_pfc_frm_cfg(void *rpmd, int lmac_id, u8 *tx_pause,
 int rpm_lmac_reset(void *rpmd, int lmac_id);
 int rpm2_get_nr_lmacs(void *rpmd);
 bool is_dev_rpm2(void *rpmd);
+int rpm_stats_rst(void *rpmd, int lmac_id);
 #endif /* RPM_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index fb3e5f1dbe3a..8a8a12ac7ac8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -592,6 +592,35 @@ int rvu_mbox_handler_cgx_fec_stats(struct rvu *rvu,
 	return  mac_ops->get_fec_stats(cgxd, lmac, rsp);
 }
 
+int rvu_mbox_handler_cgx_stats_rst(struct rvu *rvu, struct msg_req *req,
+				   struct msg_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	struct rvu_pfvf	*parent_pf;
+	struct mac_ops *mac_ops;
+	u8 cgx_idx, lmac;
+	void *cgxd;
+
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -ENODEV;
+
+	parent_pf = &rvu->pf[pf];
+	/* To ensure reset cgx stats won't affect VF stats,
+	 *  check if it used by only PF interface.
+	 *  If not, return
+	 */
+	if (parent_pf->cgx_users > 1) {
+		dev_info(rvu->dev, "CGX busy, could not reset statistics\n");
+		return 0;
+	}
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
+	cgxd = rvu_cgx_pdata(cgx_idx, rvu);
+	mac_ops = get_mac_ops(cgxd);
+
+	return mac_ops->mac_stats_rst(cgxd, lmac);
+}
+
 int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
 				      struct cgx_mac_addr_set_or_get *req,
 				      struct cgx_mac_addr_set_or_get *rsp)
-- 
2.17.1

