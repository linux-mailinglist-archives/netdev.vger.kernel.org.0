Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B59B3F6EEF
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 07:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbhHYFrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 01:47:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28806 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232096AbhHYFrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 01:47:20 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OISFYo024969;
        Tue, 24 Aug 2021 22:46:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=ZtN16GHhUt+sHil6bIAPuHuO4p5ULFUOZK9szr+tuz0=;
 b=apoDS8FQyfMnBQlV5hGURtR+VWVdoYnLulsOkWgod8m09k6wxXGqNcmAqKSfUXTJk8QK
 ReGQ1bSKpuDJqwK9SKw1XOE3Ko2Mp3I7uNdOin9l7ix5cjQxzDVRpBjXpGPBqIzpbyEK
 t+bh2+5v18AiWDdb6NbT1EX+noYRw69bPsrsrIogk1ELWut0eQFRAkuX/DXT0a4WXOZE
 2ewI4ZY4mwVW36uUmFzfY82ZQyDtGPejmd3hK3u66MC4kJ2lP/hq4wNHlChenmXTPvte
 I53oI97ydoU6gZX0G3TDJMGyPJRAXOnHZ5VKjcppPkGnPleWPehIPin7fS4kuJa3LZHZ QA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3an62ksy8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 22:46:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 24 Aug
 2021 22:46:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 24 Aug 2021 22:46:26 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id E90823F7051;
        Tue, 24 Aug 2021 22:46:22 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <ndabilpuram@marvell.com>
Subject: [PATCH] octeontx2-af: Wait for TX link idle for credits change
Date:   Wed, 25 Aug 2021 11:16:21 +0530
Message-ID: <20210825054621.3863-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 8LuBmQZVTjaCeuUevRagJzd8kOkdySis
X-Proofpoint-GUID: 8LuBmQZVTjaCeuUevRagJzd8kOkdySis
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-25_01,2021-08-25_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nithin Dabilpuram <ndabilpuram@marvell.com>

NIX_AF_TX_LINKX_NORM_CREDIT holds running counter of
tx credits available per link. But, tx credits should be
configured based on MTU config. So MTU change needs tx
credit count update.

An issue exists whereby when both PF & VF are enabled and
PF traffic is flowing, if VF requests for MTU update,
updating the NORM_CREDIT register will lead to corruption
of credit count and subsequent deadlock of tx link as
the NORM_CREDIT register holds running count.

This patch provides workaround by pausing link traffic
using NIX_AF_TL1X_SW_XOFF, waiting for existing packets to
drain, and used credits be returned before updating new
credit count.

Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   1 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 102 ++++++++++++++++--
 2 files changed, 92 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index d88f595e63b0..d86c6b366547 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -314,6 +314,7 @@ struct nix_hw {
 	struct nix_lso lso;
 	struct nix_txvlan txvlan;
 	struct nix_ipolicer *ipolicer;
+	u64    *tx_credits;
 };
 
 /* RVU block's capabilities or functionality,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index c5e3f90e562d..a5c8067c8aef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3457,6 +3457,77 @@ static void nix_find_link_frs(struct rvu *rvu,
 		req->minlen = minlen;
 }
 
+static int
+nix_config_link_credits(struct rvu *rvu, int blkaddr, int link,
+			u16 pcifunc, u64 tx_credits)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id = 0, lmac_id = 0;
+	unsigned long poll_tmo;
+	bool restore_tx_en = 0;
+	struct nix_hw *nix_hw;
+	u64 cfg, sw_xoff = 0;
+	u32 schq = 0;
+	u32 credits;
+	int rc;
+
+	nix_hw = get_nix_hw(rvu->hw, blkaddr);
+	if (!nix_hw)
+		return NIX_AF_ERR_INVALID_NIXBLK;
+
+	if (tx_credits == nix_hw->tx_credits[link])
+		return 0;
+
+	/* Enable cgx tx if disabled for credits to be back */
+	if (is_pf_cgxmapped(rvu, pf)) {
+		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+		restore_tx_en = !cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu),
+						    lmac_id, true);
+	}
+
+	mutex_lock(&rvu->rsrc_lock);
+	/* Disable new traffic to link */
+	if (hw->cap.nix_shaping) {
+		schq = nix_get_tx_link(rvu, pcifunc);
+		sw_xoff = rvu_read64(rvu, blkaddr, NIX_AF_TL1X_SW_XOFF(schq));
+		rvu_write64(rvu, blkaddr,
+			    NIX_AF_TL1X_SW_XOFF(schq), BIT_ULL(0));
+	}
+
+	rc = -EBUSY;
+	poll_tmo = jiffies + usecs_to_jiffies(10000);
+	/* Wait for credits to return */
+	do {
+		if (time_after(jiffies, poll_tmo))
+			goto exit;
+		usleep_range(100, 200);
+
+		cfg = rvu_read64(rvu, blkaddr,
+				 NIX_AF_TX_LINKX_NORM_CREDIT(link));
+		credits = (cfg >> 12) & 0xFFFFFULL;
+	} while (credits != nix_hw->tx_credits[link]);
+
+	cfg &= ~(0xFFFFFULL << 12);
+	cfg |= (tx_credits << 12);
+	rvu_write64(rvu, blkaddr, NIX_AF_TX_LINKX_NORM_CREDIT(link), cfg);
+	rc = 0;
+
+	nix_hw->tx_credits[link] = tx_credits;
+
+exit:
+	/* Enable traffic back */
+	if (hw->cap.nix_shaping && !sw_xoff)
+		rvu_write64(rvu, blkaddr, NIX_AF_TL1X_SW_XOFF(schq), 0);
+
+	/* Restore state of cgx tx */
+	if (restore_tx_en)
+		cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
+
+	mutex_unlock(&rvu->rsrc_lock);
+	return rc;
+}
+
 int rvu_mbox_handler_nix_set_hw_frs(struct rvu *rvu, struct nix_frs_cfg *req,
 				    struct msg_rsp *rsp)
 {
@@ -3545,11 +3616,8 @@ int rvu_mbox_handler_nix_set_hw_frs(struct rvu *rvu, struct nix_frs_cfg *req,
 	lmac_fifo_len =
 		rvu_cgx_get_fifolen(rvu) /
 		cgx_get_lmac_cnt(rvu_cgx_pdata(cgx, rvu));
-	cfg = rvu_read64(rvu, blkaddr, NIX_AF_TX_LINKX_NORM_CREDIT(link));
-	cfg &= ~(0xFFFFFULL << 12);
-	cfg |=  ((lmac_fifo_len - req->maxlen) / 16) << 12;
-	rvu_write64(rvu, blkaddr, NIX_AF_TX_LINKX_NORM_CREDIT(link), cfg);
-	return 0;
+	return nix_config_link_credits(rvu, blkaddr, link, pcifunc,
+				       (lmac_fifo_len - req->maxlen) / 16);
 }
 
 int rvu_mbox_handler_nix_set_rx_cfg(struct rvu *rvu, struct nix_rx_cfg *req,
@@ -3593,12 +3661,13 @@ static u64 rvu_get_lbk_link_credits(struct rvu *rvu, u16 lbk_max_frs)
 	return 1600; /* 16 * max LBK datarate = 16 * 100Gbps */
 }
 
-static void nix_link_config(struct rvu *rvu, int blkaddr)
+static void nix_link_config(struct rvu *rvu, int blkaddr,
+			    struct nix_hw *nix_hw)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
 	int cgx, lmac_cnt, slink, link;
 	u16 lbk_max_frs, lmac_max_frs;
-	u64 tx_credits;
+	u64 tx_credits, cfg;
 
 	rvu_get_lbk_link_max_frs(rvu, &lbk_max_frs);
 	rvu_get_lmac_link_max_frs(rvu, &lmac_max_frs);
@@ -3629,15 +3698,18 @@ static void nix_link_config(struct rvu *rvu, int blkaddr)
 	 */
 	for (cgx = 0; cgx < hw->cgx; cgx++) {
 		lmac_cnt = cgx_get_lmac_cnt(rvu_cgx_pdata(cgx, rvu));
+		/* Skip when cgx is not available or lmac cnt is zero */
+		if (lmac_cnt <= 0)
+			continue;
 		tx_credits = ((rvu_cgx_get_fifolen(rvu) / lmac_cnt) -
 			       lmac_max_frs) / 16;
 		/* Enable credits and set credit pkt count to max allowed */
-		tx_credits =  (tx_credits << 12) | (0x1FF << 2) | BIT_ULL(1);
+		cfg =  (tx_credits << 12) | (0x1FF << 2) | BIT_ULL(1);
 		slink = cgx * hw->lmac_per_cgx;
 		for (link = slink; link < (slink + lmac_cnt); link++) {
+			nix_hw->tx_credits[link] = tx_credits;
 			rvu_write64(rvu, blkaddr,
-				    NIX_AF_TX_LINKX_NORM_CREDIT(link),
-				    tx_credits);
+				    NIX_AF_TX_LINKX_NORM_CREDIT(link), cfg);
 		}
 	}
 
@@ -3645,6 +3717,7 @@ static void nix_link_config(struct rvu *rvu, int blkaddr)
 	slink = hw->cgx_links;
 	for (link = slink; link < (slink + hw->lbk_links); link++) {
 		tx_credits = rvu_get_lbk_link_credits(rvu, lbk_max_frs);
+		nix_hw->tx_credits[link] = tx_credits;
 		/* Enable credits and set credit pkt count to max allowed */
 		tx_credits =  (tx_credits << 12) | (0x1FF << 2) | BIT_ULL(1);
 		rvu_write64(rvu, blkaddr,
@@ -3908,8 +3981,13 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 		if (err)
 			return err;
 
+		nix_hw->tx_credits = kcalloc(hw->cgx_links + hw->lbk_links,
+					     sizeof(u64), GFP_KERNEL);
+		if (!nix_hw->tx_credits)
+			return -ENOMEM;
+
 		/* Initialize CGX/LBK/SDP link credits, min/max pkt lengths */
-		nix_link_config(rvu, blkaddr);
+		nix_link_config(rvu, blkaddr, nix_hw);
 
 		/* Enable Channel backpressure */
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_CFG, BIT_ULL(0));
@@ -3965,6 +4043,8 @@ static void rvu_nix_block_freemem(struct rvu *rvu, int blkaddr,
 			kfree(txsch->schq.bmap);
 		}
 
+		kfree(nix_hw->tx_credits);
+
 		nix_ipolicer_freemem(rvu, nix_hw);
 
 		vlan = &nix_hw->txvlan;
-- 
2.17.1

