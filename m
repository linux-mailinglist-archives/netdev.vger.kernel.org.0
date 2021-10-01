Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A23E41F090
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354772AbhJAPJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:09:02 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:49085 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1354932AbhJAPIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:49 -0400
X-IronPort-AV: E=Sophos;i="5.85,339,1624287600"; 
   d="scan'208";a="95822208"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 02 Oct 2021 00:07:04 +0900
Received: from localhost.localdomain (unknown [10.226.92.36])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id AC9BA43DDFC2;
        Sat,  2 Oct 2021 00:07:01 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 06/10] ravb: Exclude gPTP feature support for RZ/G2L
Date:   Fri,  1 Oct 2021 16:06:32 +0100
Message-Id: <20211001150636.7500-7-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car supports gPTP feature whereas RZ/G2L does not support it.
This patch excludes gtp feature support for RZ/G2L.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
RFC->v1:
 * handled timestamps only for gptp cases.
 * Removed ptp check from irq handler
---
 drivers/net/ethernet/renesas/ravb_main.c | 85 ++++++++++++++----------
 1 file changed, 49 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 5790a9332e7b..ac141a491ca2 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1403,6 +1403,7 @@ static int ravb_get_ts_info(struct net_device *ndev,
 			    struct ethtool_ts_info *info)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *hw_info = priv->info;
 
 	info->so_timestamping =
 		SOF_TIMESTAMPING_TX_SOFTWARE |
@@ -1416,7 +1417,8 @@ static int ravb_get_ts_info(struct net_device *ndev,
 		(1 << HWTSTAMP_FILTER_NONE) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
 		(1 << HWTSTAMP_FILTER_ALL);
-	info->phc_index = ptp_clock_index(priv->ptp.clock);
+	if (hw_info->gptp || hw_info->ccc_gac)
+		info->phc_index = ptp_clock_index(priv->ptp.clock);
 
 	return 0;
 }
@@ -1640,6 +1642,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	unsigned int num_tx_desc = priv->num_tx_desc;
 	u16 q = skb_get_queue_mapping(skb);
 	struct ravb_tstamp_skb *ts_skb;
@@ -1716,28 +1719,30 @@ static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	desc->dptr = cpu_to_le32(dma_addr);
 
 	/* TX timestamp required */
-	if (q == RAVB_NC) {
-		ts_skb = kmalloc(sizeof(*ts_skb), GFP_ATOMIC);
-		if (!ts_skb) {
-			if (num_tx_desc > 1) {
-				desc--;
-				dma_unmap_single(ndev->dev.parent, dma_addr,
-						 len, DMA_TO_DEVICE);
+	if (info->gptp || info->ccc_gac) {
+		if (q == RAVB_NC) {
+			ts_skb = kmalloc(sizeof(*ts_skb), GFP_ATOMIC);
+			if (!ts_skb) {
+				if (num_tx_desc > 1) {
+					desc--;
+					dma_unmap_single(ndev->dev.parent, dma_addr,
+							 len, DMA_TO_DEVICE);
+				}
+				goto unmap;
 			}
-			goto unmap;
+			ts_skb->skb = skb_get(skb);
+			ts_skb->tag = priv->ts_skb_tag++;
+			priv->ts_skb_tag &= 0x3ff;
+			list_add_tail(&ts_skb->list, &priv->ts_skb_list);
+
+			/* TAG and timestamp required flag */
+			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+			desc->tagh_tsr = (ts_skb->tag >> 4) | TX_TSR;
+			desc->ds_tagl |= cpu_to_le16(ts_skb->tag << 12);
 		}
-		ts_skb->skb = skb_get(skb);
-		ts_skb->tag = priv->ts_skb_tag++;
-		priv->ts_skb_tag &= 0x3ff;
-		list_add_tail(&ts_skb->list, &priv->ts_skb_list);
 
-		/* TAG and timestamp required flag */
-		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-		desc->tagh_tsr = (ts_skb->tag >> 4) | TX_TSR;
-		desc->ds_tagl |= cpu_to_le16(ts_skb->tag << 12);
+		skb_tx_timestamp(skb);
 	}
-
-	skb_tx_timestamp(skb);
 	/* Descriptor type must be set after all the above writes */
 	dma_wmb();
 	if (num_tx_desc > 1) {
@@ -1858,10 +1863,12 @@ static int ravb_close(struct net_device *ndev)
 			   "device will be stopped after h/w processes are done.\n");
 
 	/* Clear the timestamp list */
-	list_for_each_entry_safe(ts_skb, ts_skb2, &priv->ts_skb_list, list) {
-		list_del(&ts_skb->list);
-		kfree_skb(ts_skb->skb);
-		kfree(ts_skb);
+	if (info->gptp || info->ccc_gac) {
+		list_for_each_entry_safe(ts_skb, ts_skb2, &priv->ts_skb_list, list) {
+			list_del(&ts_skb->list);
+			kfree_skb(ts_skb->skb);
+			kfree(ts_skb);
+		}
 	}
 
 	/* PHY disconnect */
@@ -2207,9 +2214,11 @@ static void ravb_set_config_mode(struct net_device *ndev)
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
 		/* Set CSEL value */
 		ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
-	} else {
+	} else if (info->ccc_gac) {
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG |
 			    CCC_GAC | CCC_CSEL_HPB);
+	} else {
+		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
 	}
 }
 
@@ -2395,13 +2404,15 @@ static int ravb_probe(struct platform_device *pdev)
 	/* Set AVB config mode */
 	ravb_set_config_mode(ndev);
 
-	/* Set GTI value */
-	error = ravb_set_gti(ndev);
-	if (error)
-		goto out_disable_refclk;
+	if (info->gptp || info->ccc_gac) {
+		/* Set GTI value */
+		error = ravb_set_gti(ndev);
+		if (error)
+			goto out_disable_refclk;
 
-	/* Request GTI loading */
-	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+		/* Request GTI loading */
+		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+	}
 
 	if (info->internal_delay) {
 		ravb_parse_delay_mode(np, ndev);
@@ -2602,13 +2613,15 @@ static int __maybe_unused ravb_resume(struct device *dev)
 	/* Set AVB config mode */
 	ravb_set_config_mode(ndev);
 
-	/* Set GTI value */
-	ret = ravb_set_gti(ndev);
-	if (ret)
-		return ret;
+	if (info->gptp || info->ccc_gac) {
+		/* Set GTI value */
+		ret = ravb_set_gti(ndev);
+		if (ret)
+			return ret;
 
-	/* Request GTI loading */
-	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+		/* Request GTI loading */
+		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+	}
 
 	if (info->internal_delay)
 		ravb_set_delay_mode(ndev);
-- 
2.17.1

