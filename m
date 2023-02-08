Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EBF68FBBC
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 00:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjBHX5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 18:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjBHX5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 18:57:31 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E76CF1E2AE;
        Wed,  8 Feb 2023 15:57:30 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,281,1669042800"; 
   d="scan'208";a="148941675"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 09 Feb 2023 08:57:29 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id E3D2E400EF7C;
        Thu,  9 Feb 2023 08:57:28 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v2 2/4] net: renesas: rswitch: Move linkfix variables to rswitch_gwca
Date:   Thu,  9 Feb 2023 08:57:19 +0900
Message-Id: <20230208235721.2336249-3-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230208235721.2336249-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230208235721.2336249-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve readability, move linkfix related variables to
struct rswitch_gwca. Also, rename function names "desc" with "linkfix".

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 39 ++++++++++++++------------
 drivers/net/ethernet/renesas/rswitch.h |  6 ++--
 2 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 6207692f9c56..b256dadada1d 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -386,7 +386,7 @@ static int rswitch_gwca_queue_format(struct net_device *ndev,
 	rswitch_desc_set_dptr(&desc->desc, gq->ring_dma);
 	desc->desc.die_dt = DT_LINKFIX;
 
-	linkfix = &priv->linkfix_table[gq->index];
+	linkfix = &priv->gwca.linkfix_table[gq->index];
 	linkfix->die_dt = DT_LINKFIX;
 	rswitch_desc_set_dptr(linkfix, gq->ring_dma);
 
@@ -470,7 +470,7 @@ static int rswitch_gwca_queue_ext_ts_format(struct net_device *ndev,
 	rswitch_desc_set_dptr(&desc->desc, gq->ring_dma);
 	desc->desc.die_dt = DT_LINKFIX;
 
-	linkfix = &priv->linkfix_table[gq->index];
+	linkfix = &priv->gwca.linkfix_table[gq->index];
 	linkfix->die_dt = DT_LINKFIX;
 	rswitch_desc_set_dptr(linkfix, gq->ring_dma);
 
@@ -480,28 +480,31 @@ static int rswitch_gwca_queue_ext_ts_format(struct net_device *ndev,
 	return 0;
 }
 
-static int rswitch_gwca_desc_alloc(struct rswitch_private *priv)
+static int rswitch_gwca_linkfix_alloc(struct rswitch_private *priv)
 {
 	int i, num_queues = priv->gwca.num_queues;
+	struct rswitch_gwca *gwca = &priv->gwca;
 	struct device *dev = &priv->pdev->dev;
 
-	priv->linkfix_table_size = sizeof(struct rswitch_desc) * num_queues;
-	priv->linkfix_table = dma_alloc_coherent(dev, priv->linkfix_table_size,
-						 &priv->linkfix_table_dma, GFP_KERNEL);
-	if (!priv->linkfix_table)
+	gwca->linkfix_table_size = sizeof(struct rswitch_desc) * num_queues;
+	gwca->linkfix_table = dma_alloc_coherent(dev, gwca->linkfix_table_size,
+						 &gwca->linkfix_table_dma, GFP_KERNEL);
+	if (!gwca->linkfix_table)
 		return -ENOMEM;
 	for (i = 0; i < num_queues; i++)
-		priv->linkfix_table[i].die_dt = DT_EOS;
+		gwca->linkfix_table[i].die_dt = DT_EOS;
 
 	return 0;
 }
 
-static void rswitch_gwca_desc_free(struct rswitch_private *priv)
+static void rswitch_gwca_linkfix_free(struct rswitch_private *priv)
 {
-	if (priv->linkfix_table)
-		dma_free_coherent(&priv->pdev->dev, priv->linkfix_table_size,
-				  priv->linkfix_table, priv->linkfix_table_dma);
-	priv->linkfix_table = NULL;
+	struct rswitch_gwca *gwca = &priv->gwca;
+
+	if (gwca->linkfix_table)
+		dma_free_coherent(&priv->pdev->dev, gwca->linkfix_table_size,
+				  gwca->linkfix_table, gwca->linkfix_table_dma);
+	gwca->linkfix_table = NULL;
 }
 
 static struct rswitch_gwca_queue *rswitch_gwca_get(struct rswitch_private *priv)
@@ -617,8 +620,8 @@ static int rswitch_gwca_hw_init(struct rswitch_private *priv)
 
 	iowrite32(GWVCC_VEM_SC_TAG, priv->addr + GWVCC);
 	iowrite32(0, priv->addr + GWTTFC);
-	iowrite32(lower_32_bits(priv->linkfix_table_dma), priv->addr + GWDCBAC1);
-	iowrite32(upper_32_bits(priv->linkfix_table_dma), priv->addr + GWDCBAC0);
+	iowrite32(lower_32_bits(priv->gwca.linkfix_table_dma), priv->addr + GWDCBAC1);
+	iowrite32(upper_32_bits(priv->gwca.linkfix_table_dma), priv->addr + GWDCBAC0);
 	rswitch_gwca_set_rate_limit(priv, priv->gwca.speed);
 
 	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
@@ -1650,7 +1653,7 @@ static int rswitch_init(struct rswitch_private *priv)
 	if (err < 0)
 		return err;
 
-	err = rswitch_gwca_desc_alloc(priv);
+	err = rswitch_gwca_linkfix_alloc(priv);
 	if (err < 0)
 		return -ENOMEM;
 
@@ -1712,7 +1715,7 @@ static int rswitch_init(struct rswitch_private *priv)
 		rswitch_device_free(priv, i);
 
 err_device_alloc:
-	rswitch_gwca_desc_free(priv);
+	rswitch_gwca_linkfix_free(priv);
 
 	return err;
 }
@@ -1791,7 +1794,7 @@ static void rswitch_deinit(struct rswitch_private *priv)
 		rswitch_device_free(priv, i);
 	}
 
-	rswitch_gwca_desc_free(priv);
+	rswitch_gwca_linkfix_free(priv);
 
 	rswitch_clock_disable(priv);
 }
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index 390ec242ed69..79c8ff01021c 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -930,6 +930,9 @@ struct rswitch_gwca_queue {
 #define RSWITCH_NUM_IRQ_REGS	(RSWITCH_MAX_NUM_QUEUES / BITS_PER_TYPE(u32))
 struct rswitch_gwca {
 	int index;
+	struct rswitch_desc *linkfix_table;
+	dma_addr_t linkfix_table_dma;
+	u32 linkfix_table_size;
 	struct rswitch_gwca_queue *queues;
 	int num_queues;
 	DECLARE_BITMAP(used, RSWITCH_MAX_NUM_QUEUES);
@@ -969,9 +972,6 @@ struct rswitch_private {
 	struct platform_device *pdev;
 	void __iomem *addr;
 	struct rcar_gen4_ptp_private *ptp_priv;
-	struct rswitch_desc *linkfix_table;
-	dma_addr_t linkfix_table_dma;
-	u32 linkfix_table_size;
 
 	struct rswitch_device *rdev[RSWITCH_NUM_PORTS];
 
-- 
2.25.1

