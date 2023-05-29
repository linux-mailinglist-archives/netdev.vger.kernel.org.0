Return-Path: <netdev+bounces-6023-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB964714622
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DF831C209E2
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531E95661;
	Mon, 29 May 2023 08:08:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4966B6AB2
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:08:55 +0000 (UTC)
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF4B590;
	Mon, 29 May 2023 01:08:52 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="6.00,200,1681138800"; 
   d="scan'208";a="161242016"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 29 May 2023 17:08:50 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
	by relmlir5.idc.renesas.com (Postfix) with ESMTP id 2286F400C741;
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
Subject: [PATCH net-next 5/5] net: renesas: rswitch: Use per-queue rate limiter
Date: Mon, 29 May 2023 17:08:40 +0900
Message-Id: <20230529080840.1156458-6-yoshihiro.shimoda.uh@renesas.com>
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

Use per-queue rate limiter instead of global rate limiter. Otherwise
TX performance will be low when we use multiple ports at the same time.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 51 +++++++++++++++++---------
 drivers/net/ethernet/renesas/rswitch.h | 15 +++++++-
 2 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 4ae34b0206cd..a7195625a2c7 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -156,22 +156,31 @@ static int rswitch_gwca_axi_ram_reset(struct rswitch_private *priv)
 	return rswitch_reg_wait(priv->addr, GWARIRM, GWARIRM_ARR, GWARIRM_ARR);
 }
 
-static void rswitch_gwca_set_rate_limit(struct rswitch_private *priv, int rate)
+static void rswitch_gwca_set_rate_limit(struct rswitch_private *priv,
+					struct rswitch_gwca_queue *txq)
 {
-	u32 gwgrlulc, gwgrlc;
+	u64 period_ps;
+	unsigned long rate;
+	u32 gwrlc;
 
-	switch (rate) {
-	case 1000:
-		gwgrlulc = 0x0000005f;
-		gwgrlc = 0x00010260;
-		break;
-	default:
-		dev_err(&priv->pdev->dev, "%s: This rate is not supported (%d)\n", __func__, rate);
-		return;
-	}
+	rate = clk_get_rate(priv->aclk);
+	if (!rate)
+		rate = RSWITCH_ACLK_DEFAULT;
+
+	period_ps = div64_u64(1000000000000ULL, rate);
+
+	/* GWRLC value = 256 * ACLK_period[ns] * maxBandwidth[Gbps] */
+	gwrlc = 256 * period_ps * txq->speed / 1000000;
+
+	/* To avoid overflow internally, the value should be 97% */
+	gwrlc = gwrlc * 97 / 100;
 
-	iowrite32(gwgrlulc, priv->addr + GWGRLULC);
-	iowrite32(gwgrlc, priv->addr + GWGRLC);
+	dev_dbg(&priv->pdev->dev,
+		"%s: index = %d, speed = %d, rate = %ld, gwrlc = %08x\n",
+		__func__, txq->index_trim, txq->speed, rate, gwrlc);
+
+	iowrite32(GWRLULC_NOT_REQUIRED, priv->addr + GWRLULC(txq->index_trim));
+	iowrite32(gwrlc | GWRLC_RLE, priv->addr + GWRLC(txq->index_trim));
 }
 
 static bool rswitch_is_any_data_irq(struct rswitch_private *priv, u32 *dis, bool tx)
@@ -548,6 +557,10 @@ static struct rswitch_gwca_queue *rswitch_gwca_get(struct rswitch_private *priv,
 	memset(gq, 0, sizeof(*gq));
 	gq->index = index;
 
+	/* The first "Rate limiter" queue is located at GWCA_AXI_CHAIN_N - 1 */
+	if (dir_tx)
+		gq->index_trim = GWCA_AXI_CHAIN_N - index - 1;
+
 	return gq;
 }
 
@@ -651,7 +664,6 @@ static int rswitch_gwca_hw_init(struct rswitch_private *priv)
 	iowrite32(lower_32_bits(priv->gwca.ts_queue.ring_dma), priv->addr + GWTDCAC10);
 	iowrite32(upper_32_bits(priv->gwca.ts_queue.ring_dma), priv->addr + GWTDCAC00);
 	iowrite32(GWCA_TS_IRQ_BIT, priv->addr + GWTSDCC0);
-	rswitch_gwca_set_rate_limit(priv, priv->gwca.speed);
 
 	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
 		err = rswitch_rxdmac_init(priv, i);
@@ -1441,6 +1453,8 @@ static int rswitch_open(struct net_device *ndev)
 	napi_enable(&rdev->napi);
 	netif_start_queue(ndev);
 
+	rswitch_gwca_set_rate_limit(rdev->priv, rdev->tx_queue);
+
 	rswitch_enadis_data_irq(rdev->priv, rdev->tx_queue->index, true);
 	rswitch_enadis_data_irq(rdev->priv, rdev->rx_queue->index, true);
 
@@ -1723,9 +1737,6 @@ static int rswitch_device_alloc(struct rswitch_private *priv, int index)
 	if (err < 0)
 		goto out_get_params;
 
-	if (rdev->priv->gwca.speed < rdev->etha->speed)
-		rdev->priv->gwca.speed = rdev->etha->speed;
-
 	err = rswitch_rxdmac_alloc(ndev);
 	if (err < 0)
 		goto out_rxdmac;
@@ -1734,6 +1745,8 @@ static int rswitch_device_alloc(struct rswitch_private *priv, int index)
 	if (err < 0)
 		goto out_txdmac;
 
+	rdev->tx_queue->speed = rdev->etha->speed;
+
 	return 0;
 
 out_txdmac:
@@ -1903,6 +1916,10 @@ static int renesas_eth_sw_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
+	priv->aclk = devm_clk_get_optional(&pdev->dev, "aclk");
+	if (IS_ERR(priv->aclk))
+		return PTR_ERR(priv->aclk);
+
 	ret = rswitch_init(priv);
 	if (ret < 0) {
 		pm_runtime_put(&pdev->dev);
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index 7ba45ddab42a..741f45266c29 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -7,9 +7,11 @@
 #ifndef __RSWITCH_H__
 #define __RSWITCH_H__
 
+#include <linux/clk.h>
 #include <linux/platform_device.h>
 #include "rcar_gen4_ptp.h"
 
+#define RSWITCH_ACLK_DEFAULT	400000000UL
 #define RSWITCH_NUM_PORTS	3
 #define rswitch_for_each_enabled_port(priv, i)		\
 	for (i = 0; i < RSWITCH_NUM_PORTS; i++)		\
@@ -676,7 +678,7 @@ enum rswitch_reg {
 	GWIDACAM10	= GWRO + 0x0984,
 	GWGRLC		= GWRO + 0x0a00,
 	GWGRLULC	= GWRO + 0x0a04,
-	GWRLIVC0	= GWRO + 0x0a80,
+	GWRLC0		= GWRO + 0x0a80,
 	GWRLULC0	= GWRO + 0x0a84,
 	GWIDPC		= GWRO + 0x0b00,
 	GWIDC0		= GWRO + 0x0c00,
@@ -778,6 +780,11 @@ enum rswitch_gwca_mode {
 #define GWTRC(queue)		(GWTRC0 + (queue) / 32 * 4)
 #define GWDCC_OFFS(queue)	(GWDCC0 + (queue) * 4)
 
+#define GWRLC(trim)		(GWRLC0 + (trim) * 8)
+#define GWRLC_RLE		BIT(16)
+#define GWRLULC(trim)		(GWRLULC0 + (trim) * 8)
+#define GWRLULC_NOT_REQUIRED	0x00800000
+
 #define GWDIS(i)		(GWDIS0 + (i) * 0x10)
 #define GWDIE(i)		(GWDIE0 + (i) * 0x10)
 #define GWDID(i)		(GWDID0 + (i) * 0x10)
@@ -942,6 +949,10 @@ struct rswitch_gwca_queue {
 	bool dir_tx;
 	struct sk_buff **skbs;
 	struct net_device *ndev;	/* queue to ndev for irq */
+
+	/* For tx_ring */
+	int index_trim;
+	int speed;
 };
 
 struct rswitch_gwca_ts_info {
@@ -963,7 +974,6 @@ struct rswitch_gwca {
 	DECLARE_BITMAP(used, GWCA_AXI_CHAIN_N);
 	u32 tx_irq_bits[GWCA_NUM_IRQ_REGS];
 	u32 rx_irq_bits[GWCA_NUM_IRQ_REGS];
-	int speed;
 };
 
 #define NUM_QUEUES_PER_NDEV	2
@@ -997,6 +1007,7 @@ struct rswitch_private {
 	struct platform_device *pdev;
 	void __iomem *addr;
 	struct rcar_gen4_ptp_private *ptp_priv;
+	struct clk *aclk;
 
 	struct rswitch_device *rdev[RSWITCH_NUM_PORTS];
 	DECLARE_BITMAP(opened_ports, RSWITCH_NUM_PORTS);
-- 
2.25.1


