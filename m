Return-Path: <netdev+bounces-6021-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E18471461C
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:09:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A4F3280E58
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219B9613D;
	Mon, 29 May 2023 08:08:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173AA5661
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:08:54 +0000 (UTC)
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5796FA7;
	Mon, 29 May 2023 01:08:52 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="6.00,200,1681138800"; 
   d="scan'208";a="164772898"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 29 May 2023 17:08:50 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
	by relmlir5.idc.renesas.com (Postfix) with ESMTP id 02263400C741;
	Mon, 29 May 2023 17:08:50 +0900 (JST)
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
Subject: [PATCH net-next 4/5] net: renesas: rswitch: Use AXI_TLIM_N queues if a TX queue
Date: Mon, 29 May 2023 17:08:39 +0900
Message-Id: <20230529080840.1156458-5-yoshihiro.shimoda.uh@renesas.com>
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

To use per-queue rate limiter feature in the future, use AXI_TLIM_N
queues if a TX queue.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 10 ++++++----
 drivers/net/ethernet/renesas/rswitch.h |  2 ++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 4aab5d8aad2f..4ae34b0206cd 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -533,12 +533,14 @@ static void rswitch_gwca_linkfix_free(struct rswitch_private *priv)
 	gwca->linkfix_table = NULL;
 }
 
-static struct rswitch_gwca_queue *rswitch_gwca_get(struct rswitch_private *priv)
+static struct rswitch_gwca_queue *rswitch_gwca_get(struct rswitch_private *priv,
+						   bool dir_tx)
 {
 	struct rswitch_gwca_queue *gq;
 	int index;
 
-	index = find_first_zero_bit(priv->gwca.used, GWCA_AXI_CHAIN_N);
+	index = find_next_zero_bit(priv->gwca.used, GWCA_AXI_CHAIN_N,
+				   dir_tx ? GWCA_AXI_TRIM_BASE : 0);
 	if (index >= GWCA_AXI_CHAIN_N)
 		return NULL;
 	set_bit(index, priv->gwca.used);
@@ -561,7 +563,7 @@ static int rswitch_txdmac_alloc(struct net_device *ndev)
 	struct rswitch_private *priv = rdev->priv;
 	int err;
 
-	rdev->tx_queue = rswitch_gwca_get(priv);
+	rdev->tx_queue = rswitch_gwca_get(priv, true);
 	if (!rdev->tx_queue)
 		return -EBUSY;
 
@@ -595,7 +597,7 @@ static int rswitch_rxdmac_alloc(struct net_device *ndev)
 	struct rswitch_private *priv = rdev->priv;
 	int err;
 
-	rdev->rx_queue = rswitch_gwca_get(priv);
+	rdev->rx_queue = rswitch_gwca_get(priv, false);
 	if (!rdev->rx_queue)
 		return -EBUSY;
 
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index c3c2c92c2a1e..7ba45ddab42a 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -49,7 +49,9 @@
 #define GWRO			RSWITCH_GWCA0_OFFSET
 
 #define GWCA_AXI_CHAIN_N	128
+#define GWCA_AXI_TLIM_N		32
 #define GWCA_NUM_IRQ_REGS	(GWCA_AXI_CHAIN_N / BITS_PER_TYPE(u32))
+#define GWCA_AXI_TRIM_BASE	(GWCA_AXI_CHAIN_N - GWCA_AXI_TLIM_N)
 
 #define GWCA_TS_IRQ_RESOURCE_NAME	"gwca0_rxts0"
 #define GWCA_TS_IRQ_NAME		"rswitch: gwca0_rxts0"
-- 
2.25.1


