Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946B657448C
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 07:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbiGNFgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 01:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiGNFgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 01:36:12 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EC722B08;
        Wed, 13 Jul 2022 22:36:10 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E4P0GN025737;
        Wed, 13 Jul 2022 22:36:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=+f2VZ9+imA8Wz7n72Rrn25RH8jgq0IemxV7O0PNAxVE=;
 b=LUYYg+2uxVjLHNs8X3Mehjv5NkLkn8vZqX3GLJd0au2pvqzGNJfInnJ0NG+bLEJ+CyDV
 jkPO57C5KsxaQbxmwHFxkMfgC7FW/++HlrXK6P4l/18bRQe+MFOu5LJ8bPic+OiJDeBN
 NxRh1WXTUJ+/eAjH8KxTKTTY4zCkyhkRhRBuzgEO78WzJgbnagNJZnybWP66opy5ncb8
 JPOZ/DRJmeA1v6AavM4sZxwOHrdi64DnoRDkSWY6VTDgOF6BiX8o85pFaSyXY1+K1gMR
 qxXUWJvj5bFd/N7x1iKFAPeApftCqoEE5aT31HhqIld/5dWvBBFdrBaTl7SFDMMgCXzN 4Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9udu3rjs-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 22:36:04 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 13 Jul
 2022 22:36:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 13 Jul 2022 22:36:01 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 346713F704D;
        Wed, 13 Jul 2022 22:35:58 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <sgoutham@marvell.com>,
        Nithin Dabilpuram <ndabilpuram@marvell.com>,
        Geetha Sowjanya <gakula@marvell.com>
Subject: [net-next PATCH] octeontx2-af: Set NIX link credits based on max LMAC
Date:   Thu, 14 Jul 2022 11:05:55 +0530
Message-ID: <20220714053555.5119-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: X23R9p1WcZ0rDTH8sjAJ-3QNGboj3TyH
X-Proofpoint-ORIG-GUID: X23R9p1WcZ0rDTH8sjAJ-3QNGboj3TyH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_04,2022-07-13_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

When number of LMACs active on a CGX/RPM are 3, then
current NIX link credit config based on per lmac fifo
length which inturn  is calculated as
'lmac_fifo_len = total_fifo_len / 3', is incorrect. In HW
one of the LMAC gets half of the FIFO and rest gets 1/4th.

Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha Sowjanya <gakula@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 27 +++++++++++++++
 .../marvell/octeontx2/af/lmac_common.h        |  1 +
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 30 ++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  2 +-
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 16 +++++++++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 34 ++++++++++++++-----
 7 files changed, 102 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 618b9d167fa6..0d31efb31b54 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -498,6 +498,32 @@ static u8 cgx_get_lmac_type(void *cgxd, int lmac_id)
 	return (cfg >> CGX_LMAC_TYPE_SHIFT) & CGX_LMAC_TYPE_MASK;
 }
 
+static u32 cgx_get_lmac_fifo_len(void *cgxd, int lmac_id)
+{
+	struct cgx *cgx = cgxd;
+	u8 num_lmacs;
+	u32 fifo_len;
+
+	fifo_len = cgx->mac_ops->fifo_len;
+	num_lmacs = cgx->mac_ops->get_nr_lmacs(cgx);
+
+	switch (num_lmacs) {
+	case 1:
+		return fifo_len;
+	case 2:
+		return fifo_len / 2;
+	case 3:
+		/* LMAC0 gets half of the FIFO, reset 1/4th */
+		if (lmac_id == 0)
+			return fifo_len / 2;
+		return fifo_len / 4;
+	case 4:
+	default:
+		return fifo_len / 4;
+	}
+	return 0;
+}
+
 /* Configure CGX LMAC in internal loopback mode */
 int cgx_lmac_internal_loopback(void *cgxd, int lmac_id, bool enable)
 {
@@ -1704,6 +1730,7 @@ static struct mac_ops	cgx_mac_ops    = {
 	.tx_stats_cnt   =       18,
 	.get_nr_lmacs	=	cgx_get_nr_lmacs,
 	.get_lmac_type  =       cgx_get_lmac_type,
+	.lmac_fifo_len	=	cgx_get_lmac_fifo_len,
 	.mac_lmac_intl_lbk =    cgx_lmac_internal_loopback,
 	.mac_get_rx_stats  =	cgx_get_rx_stats,
 	.mac_get_tx_stats  =	cgx_get_tx_stats,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index f30581bf0688..52b6016789fa 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -80,6 +80,7 @@ struct mac_ops {
 	 */
 	int			(*get_nr_lmacs)(void *cgx);
 	u8                      (*get_lmac_type)(void *cgx, int lmac_id);
+	u32                     (*lmac_fifo_len)(void *cgx, int lmac_id);
 	int                     (*mac_lmac_intl_lbk)(void *cgx, int lmac_id,
 						     bool enable);
 	/* Register Stats related functions */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 05666922a45b..abeb3986e36a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -22,6 +22,7 @@ static struct mac_ops	rpm_mac_ops   = {
 	.tx_stats_cnt   =       34,
 	.get_nr_lmacs	=	rpm_get_nr_lmacs,
 	.get_lmac_type  =       rpm_get_lmac_type,
+	.lmac_fifo_len	=	rpm_get_lmac_fifo_len,
 	.mac_lmac_intl_lbk =    rpm_lmac_internal_loopback,
 	.mac_get_rx_stats  =	rpm_get_rx_stats,
 	.mac_get_tx_stats  =	rpm_get_tx_stats,
@@ -347,6 +348,35 @@ u8 rpm_get_lmac_type(void *rpmd, int lmac_id)
 	return err;
 }
 
+u32 rpm_get_lmac_fifo_len(void *rpmd, int lmac_id)
+{
+	rpm_t *rpm = rpmd;
+	u64 hi_perf_lmac;
+	u8 num_lmacs;
+	u32 fifo_len;
+
+	fifo_len = rpm->mac_ops->fifo_len;
+	num_lmacs = rpm->mac_ops->get_nr_lmacs(rpm);
+
+	switch (num_lmacs) {
+	case 1:
+		return fifo_len;
+	case 2:
+		return fifo_len / 2;
+	case 3:
+		/* LMAC marked as hi_perf gets half of the FIFO and rest 1/4th */
+		hi_perf_lmac = rpm_read(rpm, 0, CGXX_CMRX_RX_LMACS);
+		hi_perf_lmac = (hi_perf_lmac >> 4) & 0x3ULL;
+		if (lmac_id == hi_perf_lmac)
+			return fifo_len / 2;
+		return fifo_len / 4;
+	case 4:
+	default:
+		return fifo_len / 4;
+	}
+	return 0;
+}
+
 int rpm_lmac_internal_loopback(void *rpmd, int lmac_id, bool enable)
 {
 	rpm_t *rpm = rpmd;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index 8205f2626f61..805b1657856c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -74,6 +74,7 @@
 /* Function Declarations */
 int rpm_get_nr_lmacs(void *rpmd);
 u8 rpm_get_lmac_type(void *rpmd, int lmac_id);
+u32 rpm_get_lmac_fifo_len(void *rpmd, int lmac_id);
 int rpm_lmac_internal_loopback(void *rpmd, int lmac_id, bool enable);
 void rpm_lmac_enadis_rx_pause_fwding(void *rpmd, int lmac_id, bool enable);
 int rpm_lmac_get_pause_frm_status(void *cgxd, int lmac_id, u8 *tx_pause,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index e5fdb7b62651..d15bc443335d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -827,7 +827,7 @@ int rvu_cgx_config_tx(void *cgxd, int lmac_id, bool enable);
 int rvu_cgx_prio_flow_ctrl_cfg(struct rvu *rvu, u16 pcifunc, u8 tx_pause, u8 rx_pause,
 			       u16 pfc_en);
 int rvu_cgx_cfg_pause_frm(struct rvu *rvu, u16 pcifunc, u8 tx_pause, u8 rx_pause);
-
+u32 rvu_cgx_get_lmac_fifolen(struct rvu *rvu, int cgx, int lmac);
 int npc_get_nixlf_mcam_index(struct npc_mcam *mcam, u16 pcifunc, int nixlf,
 			     int type);
 bool is_mcam_entry_enabled(struct rvu *rvu, struct npc_mcam *mcam, int blkaddr,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 5090ddcc7e8a..e9989982fbbd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -861,6 +861,22 @@ u32 rvu_cgx_get_fifolen(struct rvu *rvu)
 	return fifo_len;
 }
 
+u32 rvu_cgx_get_lmac_fifolen(struct rvu *rvu, int cgx, int lmac)
+{
+	struct mac_ops *mac_ops;
+	void *cgxd;
+
+	cgxd = rvu_cgx_pdata(cgx, rvu);
+	if (!cgxd)
+		return 0;
+
+	mac_ops = get_mac_ops(cgxd);
+	if (!mac_ops->lmac_fifo_len)
+		return 0;
+
+	return mac_ops->lmac_fifo_len(cgxd, lmac);
+}
+
 static int rvu_cgx_config_intlbk(struct rvu *rvu, u16 pcifunc, bool en)
 {
 	int pf = rvu_get_pf(pcifunc);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 1d3323da6930..0879a48411f3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4010,9 +4010,13 @@ int rvu_mbox_handler_nix_set_hw_frs(struct rvu *rvu, struct nix_frs_cfg *req,
 		return 0;
 
 	/* Update transmit credits for CGX links */
-	lmac_fifo_len =
-		rvu_cgx_get_fifolen(rvu) /
-		cgx_get_lmac_cnt(rvu_cgx_pdata(cgx, rvu));
+	lmac_fifo_len = rvu_cgx_get_lmac_fifolen(rvu, cgx, lmac);
+	if (!lmac_fifo_len) {
+		dev_err(rvu->dev,
+			"%s: Failed to get CGX/RPM%d:LMAC%d FIFO size\n",
+			__func__, cgx, lmac);
+		return 0;
+	}
 	return nix_config_link_credits(rvu, blkaddr, link, pcifunc,
 				       (lmac_fifo_len - req->maxlen) / 16);
 }
@@ -4064,7 +4068,10 @@ static void nix_link_config(struct rvu *rvu, int blkaddr,
 	struct rvu_hwinfo *hw = rvu->hw;
 	int cgx, lmac_cnt, slink, link;
 	u16 lbk_max_frs, lmac_max_frs;
+	unsigned long lmac_bmap;
 	u64 tx_credits, cfg;
+	u64 lmac_fifo_len;
+	int iter;
 
 	rvu_get_lbk_link_max_frs(rvu, &lbk_max_frs);
 	rvu_get_lmac_link_max_frs(rvu, &lmac_max_frs);
@@ -4098,12 +4105,23 @@ static void nix_link_config(struct rvu *rvu, int blkaddr,
 		/* Skip when cgx is not available or lmac cnt is zero */
 		if (lmac_cnt <= 0)
 			continue;
-		tx_credits = ((rvu_cgx_get_fifolen(rvu) / lmac_cnt) -
-			       lmac_max_frs) / 16;
-		/* Enable credits and set credit pkt count to max allowed */
-		cfg =  (tx_credits << 12) | (0x1FF << 2) | BIT_ULL(1);
 		slink = cgx * hw->lmac_per_cgx;
-		for (link = slink; link < (slink + lmac_cnt); link++) {
+
+		/* Get LMAC id's from bitmap */
+		lmac_bmap = cgx_get_lmac_bmap(rvu_cgx_pdata(cgx, rvu));
+		for_each_set_bit(iter, &lmac_bmap, MAX_LMAC_PER_CGX) {
+			lmac_fifo_len = rvu_cgx_get_lmac_fifolen(rvu, cgx, iter);
+			if (!lmac_fifo_len) {
+				dev_err(rvu->dev,
+					"%s: Failed to get CGX/RPM%d:LMAC%d FIFO size\n",
+					__func__, cgx, iter);
+				continue;
+			}
+			tx_credits = (lmac_fifo_len - lmac_max_frs) / 16;
+			/* Enable credits and set credit pkt count to max allowed */
+			cfg =  (tx_credits << 12) | (0x1FF << 2) | BIT_ULL(1);
+
+			link = iter + slink;
 			nix_hw->tx_credits[link] = tx_credits;
 			rvu_write64(rvu, blkaddr,
 				    NIX_AF_TX_LINKX_NORM_CREDIT(link), cfg);
-- 
2.17.1

