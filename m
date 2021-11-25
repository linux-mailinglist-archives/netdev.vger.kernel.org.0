Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6A245DE00
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356216AbhKYPxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:53:12 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:41171 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356173AbhKYPvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 10:51:40 -0500
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 96E9910001D;
        Thu, 25 Nov 2021 15:48:26 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH net-next 4/4] net: mvneta: Add TC traffic shaping offload
Date:   Thu, 25 Nov 2021 16:48:13 +0100
Message-Id: <20211125154813.579169-5-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20211125154813.579169-1-maxime.chevallier@bootlin.com>
References: <20211125154813.579169-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mvneta controller is able to do some tocken-bucket per-queue traffic
shaping. This commit adds support for setting these using the TC mqprio
interface.

The token-bucket parameters are customisable, but the current
implementation configures them to have a 10kbps resolution for the
rate limitation, since it allows to cover the whole range of max_rate
values from 10kbps to 5Gbps with 10kbps increments.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 121 +++++++++++++++++++++++++-
 1 file changed, 120 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index aba452e8abfe..ca7b3c5cfe0a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -248,12 +248,39 @@
 #define      MVNETA_TXQ_SENT_DESC_MASK           0x3fff0000
 #define MVNETA_PORT_TX_RESET                     0x3cf0
 #define      MVNETA_PORT_TX_DMA_RESET            BIT(0)
+#define MVNETA_TXQ_CMD1_REG			 0x3e00
+#define      MVNETA_TXQ_CMD1_BW_LIM_SEL_V1	 BIT(3)
+#define      MVNETA_TXQ_CMD1_BW_LIM_EN		 BIT(0)
+#define MVNETA_REFILL_NUM_CLK_REG		 0x3e08
+#define      MVNETA_REFILL_MAX_NUM_CLK		 0x0000ffff
 #define MVNETA_TX_MTU                            0x3e0c
 #define MVNETA_TX_TOKEN_SIZE                     0x3e14
 #define      MVNETA_TX_TOKEN_SIZE_MAX            0xffffffff
+#define MVNETA_TXQ_BUCKET_REFILL_REG(q)		 (0x3e20 + ((q) << 2))
+#define      MVNETA_TXQ_BUCKET_REFILL_PERIOD_MASK	0x3ff00000
+#define      MVNETA_TXQ_BUCKET_REFILL_PERIOD_SHIFT	20
+#define      MVNETA_TXQ_BUCKET_REFILL_VALUE_MAX	 0x0007ffff
 #define MVNETA_TXQ_TOKEN_SIZE_REG(q)             (0x3e40 + ((q) << 2))
 #define      MVNETA_TXQ_TOKEN_SIZE_MAX           0x7fffffff
 
+/* The values of the bucket refill base period and refill period are taken from
+ * the reference manual, and adds up to a base resolution of 10Kbps. This allows
+ * to cover all rate-limit values from 10Kbps up to 5Gbps
+ */
+
+/* Base period for the rate limit algorithm */
+#define MVNETA_TXQ_BUCKET_REFILL_BASE_PERIOD_NS	100
+
+/* Number of Base Period to wait between each bucket refill */
+#define MVNETA_TXQ_BUCKET_REFILL_PERIOD	1000
+
+/* The base resolution for rate limiting, in bps. Any max_rate value should be
+ * a multiple of that value.
+ */
+#define MVNETA_TXQ_RATE_LIMIT_RESOLUTION (NSEC_PER_SEC / \
+					 (MVNETA_TXQ_BUCKET_REFILL_BASE_PERIOD_NS * \
+					  MVNETA_TXQ_BUCKET_REFILL_PERIOD))
+
 #define MVNETA_LPI_CTRL_0                        0x2cc0
 #define MVNETA_LPI_CTRL_1                        0x2cc4
 #define      MVNETA_LPI_REQUEST_ENABLE           BIT(0)
@@ -4906,11 +4933,75 @@ static void mvneta_map_vlan_prio_to_rxq(struct mvneta_port *pp, u8 pri, u8 rxq)
 	mvreg_write(pp, MVNETA_VLAN_PRIO_TO_RXQ, val);
 }
 
+static int mvneta_enable_per_queue_rate_limit(struct mvneta_port *pp)
+{
+	unsigned long core_clk_rate;
+	u32 refill_cycles;
+	u32 val;
+
+	core_clk_rate = clk_get_rate(pp->clk);
+	if (!core_clk_rate)
+		return -EINVAL;
+
+	refill_cycles = MVNETA_TXQ_BUCKET_REFILL_BASE_PERIOD_NS /
+			(NSEC_PER_SEC / core_clk_rate);
+
+	if (refill_cycles > MVNETA_REFILL_MAX_NUM_CLK)
+		return -EINVAL;
+
+	/* Enable bw limit algorithm version 3 */
+	val = mvreg_read(pp, MVNETA_TXQ_CMD1_REG);
+	val &= ~(MVNETA_TXQ_CMD1_BW_LIM_SEL_V1 | MVNETA_TXQ_CMD1_BW_LIM_EN);
+	mvreg_write(pp, MVNETA_TXQ_CMD1_REG, val);
+
+	/* Set the base refill rate */
+	mvreg_write(pp, MVNETA_REFILL_NUM_CLK_REG, refill_cycles);
+
+	return 0;
+}
+
+static void mvneta_disable_per_queue_rate_limit(struct mvneta_port *pp)
+{
+	u32 val = mvreg_read(pp, MVNETA_TXQ_CMD1_REG);
+
+	val |= (MVNETA_TXQ_CMD1_BW_LIM_SEL_V1 | MVNETA_TXQ_CMD1_BW_LIM_EN);
+	mvreg_write(pp, MVNETA_TXQ_CMD1_REG, val);
+}
+
+static int mvneta_setup_queue_rates(struct mvneta_port *pp, int queue,
+				    u64 min_rate, u64 max_rate)
+{
+	u32 refill_val;
+	u32 val = 0;
+
+	/* Convert to from Bps to bps */
+	max_rate *= 8;
+
+	if (min_rate)
+		return -EINVAL;
+
+	if (max_rate % MVNETA_TXQ_RATE_LIMIT_RESOLUTION)
+		return -EINVAL;
+
+	refill_val = max_rate / MVNETA_TXQ_RATE_LIMIT_RESOLUTION;
+
+	if (refill_val == 0 || refill_val > MVNETA_TXQ_BUCKET_REFILL_VALUE_MAX)
+		return -EINVAL;
+
+	val = refill_val;
+	val |= (MVNETA_TXQ_BUCKET_REFILL_PERIOD <<
+		MVNETA_TXQ_BUCKET_REFILL_PERIOD_SHIFT);
+
+	mvreg_write(pp, MVNETA_TXQ_BUCKET_REFILL_REG(queue), val);
+
+	return 0;
+}
+
 static int mvneta_setup_mqprio(struct net_device *dev,
 			       struct tc_mqprio_qopt_offload *mqprio)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
-	int rxq, tc;
+	int rxq, txq, tc, ret;
 	u8 num_tc;
 
 	if (mqprio->qopt.hw != TC_MQPRIO_HW_OFFLOAD_TCS)
@@ -4924,6 +5015,7 @@ static int mvneta_setup_mqprio(struct net_device *dev,
 	mvneta_clear_rx_prio_map(pp);
 
 	if (!num_tc) {
+		mvneta_disable_per_queue_rate_limit(pp);
 		netdev_reset_tc(dev);
 		return 0;
 	}
@@ -4944,6 +5036,33 @@ static int mvneta_setup_mqprio(struct net_device *dev,
 		}
 	}
 
+	if (mqprio->shaper != TC_MQPRIO_SHAPER_BW_RATE) {
+		mvneta_disable_per_queue_rate_limit(pp);
+		return 0;
+	}
+
+	if (mqprio->qopt.num_tc > txq_number)
+		return -EINVAL;
+
+	ret = mvneta_enable_per_queue_rate_limit(pp);
+	if (ret)
+		return ret;
+
+	for (tc = 0; tc < mqprio->qopt.num_tc; tc++) {
+		for (txq = mqprio->qopt.offset[tc];
+		     txq < mqprio->qopt.count[tc] + mqprio->qopt.offset[tc];
+		     txq++) {
+			if (txq >= txq_number)
+				return -EINVAL;
+
+			ret = mvneta_setup_queue_rates(pp, txq,
+						       mqprio->min_rate[tc],
+						       mqprio->max_rate[tc]);
+			if (ret)
+				return ret;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.25.4

