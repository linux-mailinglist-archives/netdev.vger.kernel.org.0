Return-Path: <netdev+bounces-9109-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 249227274A7
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 03:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DE9C1C20F5D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 01:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21181EC9;
	Thu,  8 Jun 2023 01:57:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111FA7F6
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 01:57:50 +0000 (UTC)
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1130626A6;
	Wed,  7 Jun 2023 18:57:47 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="6.00,225,1681138800"; 
   d="scan'208";a="162642301"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 08 Jun 2023 10:57:47 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
	by relmlir5.idc.renesas.com (Postfix) with ESMTP id 111B5401140A;
	Thu,  8 Jun 2023 10:57:47 +0900 (JST)
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: s.shtylyov@omp.ru,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: lanhao@huawei.com,
	simon.horman@corigine.com,
	netdev@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Phong Hoang <phong.hoang.wz@renesas.com>
Subject: [PATCH net v3] net: renesas: rswitch: Fix timestamp feature after all descriptors are used
Date: Thu,  8 Jun 2023 10:57:27 +0900
Message-Id: <20230608015727.1862917-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The timestamp descriptors were intended to act cyclically. Descriptors
from index 0 through gq->ring_size - 1 contain actual information, and
the last index (gq->ring_size) should have LINKFIX to indicate
the first index 0 descriptor. However, the LINKFIX value is missing,
causing the timestamp feature to stop after all descriptors are used.
To resolve this issue, set the LINKFIX to the timestamp descritors.

Reported-by: Phong Hoang <phong.hoang.wz@renesas.com>
Fixes: 33f5d733b589 ("net: renesas: rswitch: Improve TX timestamp accuracy")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 Since I got this report locally, I didn't add Closes: tag.

 Changes from v2:
https://lore.kernel.org/all/20230607070141.1795982-1-yoshihiro.shimoda.uh@renesas.com/
 - Rebase the latest net.git / main branch.
 - Fix typo in the commit description.
 - Modify the implementation of setting the last LINKFIX setting from
   rswitch_gwca_ts_queue_fill() to rswitch_gwca_ts_queue_alloc() because
   the last LINKFIX setting is only needed at the initialization time.

 Changes from v1:
https://lore.kernel.org/all/20230607064402.1795548-1-yoshihiro.shimoda.uh@renesas.com/
 - Fix typo in the subject.

 drivers/net/ethernet/renesas/rswitch.c | 36 ++++++++++++++++----------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index aace87139cea..fa6d6202b129 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -347,17 +347,6 @@ static int rswitch_gwca_queue_alloc(struct net_device *ndev,
 	return -ENOMEM;
 }
 
-static int rswitch_gwca_ts_queue_alloc(struct rswitch_private *priv)
-{
-	struct rswitch_gwca_queue *gq = &priv->gwca.ts_queue;
-
-	gq->ring_size = TS_RING_SIZE;
-	gq->ts_ring = dma_alloc_coherent(&priv->pdev->dev,
-					 sizeof(struct rswitch_ts_desc) *
-					 (gq->ring_size + 1), &gq->ring_dma, GFP_KERNEL);
-	return !gq->ts_ring ? -ENOMEM : 0;
-}
-
 static void rswitch_desc_set_dptr(struct rswitch_desc *desc, dma_addr_t addr)
 {
 	desc->dptrl = cpu_to_le32(lower_32_bits(addr));
@@ -533,6 +522,28 @@ static void rswitch_gwca_linkfix_free(struct rswitch_private *priv)
 	gwca->linkfix_table = NULL;
 }
 
+static int rswitch_gwca_ts_queue_alloc(struct rswitch_private *priv)
+{
+	struct rswitch_gwca_queue *gq = &priv->gwca.ts_queue;
+	struct rswitch_ts_desc *desc;
+
+	gq->ring_size = TS_RING_SIZE;
+	gq->ts_ring = dma_alloc_coherent(&priv->pdev->dev,
+					 sizeof(struct rswitch_ts_desc) *
+					 (gq->ring_size + 1), &gq->ring_dma, GFP_KERNEL);
+
+	if (!gq->ts_ring)
+		return -ENOMEM;
+
+	rswitch_gwca_ts_queue_fill(priv, 0, TS_RING_SIZE);
+	desc = &gq->ts_ring[gq->ring_size];
+	desc->desc.die_dt = DT_LINKFIX;
+	rswitch_desc_set_dptr(&desc->desc, gq->ring_dma);
+	INIT_LIST_HEAD(&priv->gwca.ts_info_list);
+
+	return 0;
+}
+
 static struct rswitch_gwca_queue *rswitch_gwca_get(struct rswitch_private *priv)
 {
 	struct rswitch_gwca_queue *gq;
@@ -1780,9 +1791,6 @@ static int rswitch_init(struct rswitch_private *priv)
 	if (err < 0)
 		goto err_ts_queue_alloc;
 
-	rswitch_gwca_ts_queue_fill(priv, 0, TS_RING_SIZE);
-	INIT_LIST_HEAD(&priv->gwca.ts_info_list);
-
 	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
 		err = rswitch_device_alloc(priv, i);
 		if (err < 0) {
-- 
2.25.1


