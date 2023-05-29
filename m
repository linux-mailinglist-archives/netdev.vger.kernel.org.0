Return-Path: <netdev+bounces-6020-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 316C071461B
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:09:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2038280CEE
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5024422;
	Mon, 29 May 2023 08:08:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858995661
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:08:53 +0000 (UTC)
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC29AB5;
	Mon, 29 May 2023 01:08:51 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="6.00,200,1681138800"; 
   d="scan'208";a="164772895"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 29 May 2023 17:08:49 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
	by relmlir5.idc.renesas.com (Postfix) with ESMTP id D6D67400C742;
	Mon, 29 May 2023 17:08:49 +0900 (JST)
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: s.shtylyov@omp.ru,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	geert+renesas@glider.be,
	magnus.damm@gmail.com
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next 3/5] net: renesas: rswitch: Alloc all 128 queues
Date: Mon, 29 May 2023 17:08:38 +0900
Message-Id: <20230529080840.1156458-4-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

To use per-queue rate limiter feature in the future, alloc all 128
queues (GWCA_AXI_CHAIN_N) of GWCA so that drop num_queues from
struct rswitch_gwca. Notes that add a condition of gwca.used flag
in rswitch_data_irq() because the previous code always set the flag
of all queues.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 19 ++++++++++---------
 drivers/net/ethernet/renesas/rswitch.h |  1 -
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 51df96de6fd5..4aab5d8aad2f 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -508,16 +508,16 @@ static int rswitch_gwca_queue_ext_ts_format(struct net_device *ndev,
 
 static int rswitch_gwca_linkfix_alloc(struct rswitch_private *priv)
 {
-	int i, num_queues = priv->gwca.num_queues;
 	struct rswitch_gwca *gwca = &priv->gwca;
 	struct device *dev = &priv->pdev->dev;
+	int i;
 
-	gwca->linkfix_table_size = sizeof(struct rswitch_desc) * num_queues;
+	gwca->linkfix_table_size = sizeof(struct rswitch_desc) * GWCA_AXI_CHAIN_N;
 	gwca->linkfix_table = dma_alloc_coherent(dev, gwca->linkfix_table_size,
 						 &gwca->linkfix_table_dma, GFP_KERNEL);
 	if (!gwca->linkfix_table)
 		return -ENOMEM;
-	for (i = 0; i < num_queues; i++)
+	for (i = 0; i < GWCA_AXI_CHAIN_N; i++)
 		gwca->linkfix_table[i].die_dt = DT_EOS;
 
 	return 0;
@@ -538,8 +538,8 @@ static struct rswitch_gwca_queue *rswitch_gwca_get(struct rswitch_private *priv)
 	struct rswitch_gwca_queue *gq;
 	int index;
 
-	index = find_first_zero_bit(priv->gwca.used, priv->gwca.num_queues);
-	if (index >= priv->gwca.num_queues)
+	index = find_first_zero_bit(priv->gwca.used, GWCA_AXI_CHAIN_N);
+	if (index >= GWCA_AXI_CHAIN_N)
 		return NULL;
 	set_bit(index, priv->gwca.used);
 	gq = &priv->gwca.queues[index];
@@ -846,7 +846,10 @@ static irqreturn_t rswitch_data_irq(struct rswitch_private *priv, u32 *dis)
 	struct rswitch_gwca_queue *gq;
 	int i, index, bit;
 
-	for (i = 0; i < priv->gwca.num_queues; i++) {
+	for (i = 0; i < GWCA_AXI_CHAIN_N; i++) {
+		if (!test_bit(i, priv->gwca.used))
+			continue;
+
 		gq = &priv->gwca.queues[i];
 		index = gq->index / 32;
 		bit = BIT(gq->index % 32);
@@ -1890,9 +1893,7 @@ static int renesas_eth_sw_probe(struct platform_device *pdev)
 	}
 
 	priv->gwca.index = AGENT_INDEX_GWCA;
-	priv->gwca.num_queues = min(RSWITCH_NUM_PORTS * NUM_QUEUES_PER_NDEV,
-				    GWCA_AXI_CHAIN_N);
-	priv->gwca.queues = devm_kcalloc(&pdev->dev, priv->gwca.num_queues,
+	priv->gwca.queues = devm_kcalloc(&pdev->dev, GWCA_AXI_CHAIN_N,
 					 sizeof(*priv->gwca.queues), GFP_KERNEL);
 	if (!priv->gwca.queues)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index 550a6bff9078..c3c2c92c2a1e 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -956,7 +956,6 @@ struct rswitch_gwca {
 	dma_addr_t linkfix_table_dma;
 	u32 linkfix_table_size;
 	struct rswitch_gwca_queue *queues;
-	int num_queues;
 	struct rswitch_gwca_queue ts_queue;
 	struct list_head ts_info_list;
 	DECLARE_BITMAP(used, GWCA_AXI_CHAIN_N);
-- 
2.25.1


