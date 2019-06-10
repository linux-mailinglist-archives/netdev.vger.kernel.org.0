Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7073A3B159
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 10:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388760AbfFJIzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 04:55:44 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:57797 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388742AbfFJIzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 04:55:42 -0400
X-Originating-IP: 90.88.159.246
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id D9BBAFF813;
        Mon, 10 Jun 2019 08:55:37 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        ymarkman@marvell.com, mw@semihalf.com
Subject: [PATCH net-next 3/3] net: mvpp2: Add support for more ethtool counters
Date:   Mon, 10 Jun 2019 10:55:29 +0200
Message-Id: <20190610085529.16803-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610085529.16803-1-maxime.chevallier@bootlin.com>
References: <20190610085529.16803-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Besides the MIB counters, some other useful counters can be exposed to
the user. This commit adds support for :

 - Per-port counters, that indicate FIFO drops and classifier drops,
 - Per-rxq counters,
 - Per-txq counters

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  18 +++
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 132 +++++++++++++++---
 2 files changed, 132 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index d67c970f02e5..4d9564ba68f6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -329,8 +329,26 @@
 #define     MVPP22_BM_ADDR_HIGH_VIRT_RLS_MASK	0xff00
 #define     MVPP22_BM_ADDR_HIGH_VIRT_RLS_SHIFT	8
 
+/* Packet Processor per-port counters */
+#define MVPP2_OVERRUN_ETH_DROP			0x7000
+#define MVPP2_CLS_ETH_DROP			0x7020
+
 /* Hit counters registers */
 #define MVPP2_CTRS_IDX				0x7040
+#define     MVPP22_CTRS_TX_CTR(port, txq)	((txq) | ((port) << 3) | BIT(7))
+#define MVPP2_TX_DESC_ENQ_CTR			0x7100
+#define MVPP2_TX_DESC_ENQ_TO_DDR_CTR		0x7104
+#define MVPP2_TX_BUFF_ENQ_TO_DDR_CTR		0x7108
+#define MVPP2_TX_DESC_ENQ_HW_FWD_CTR		0x710c
+#define MVPP2_RX_DESC_ENQ_CTR			0x7120
+#define MVPP2_TX_PKTS_DEQ_CTR			0x7130
+#define MVPP2_TX_PKTS_FULL_QUEUE_DROP_CTR	0x7200
+#define MVPP2_TX_PKTS_EARLY_DROP_CTR		0x7204
+#define MVPP2_TX_PKTS_BM_DROP_CTR		0x7208
+#define MVPP2_TX_PKTS_BM_MC_DROP_CTR		0x720c
+#define MVPP2_RX_PKTS_FULL_QUEUE_DROP_CTR	0x7220
+#define MVPP2_RX_PKTS_EARLY_DROP_CTR		0x7224
+#define MVPP2_RX_PKTS_BM_DROP_CTR		0x7228
 #define MVPP2_CLS_DEC_TBL_HIT_CTR		0x7700
 #define MVPP2_CLS_FLOW_TBL_HIT_CTR		0x7704
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 01380ccb2139..c51f1d5b550b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1258,6 +1258,17 @@ static u64 mvpp2_read_count(struct mvpp2_port *port,
 	return val;
 }
 
+/* Some counters are accessed indirectly by first writing an index to
+ * MVPP2_CTRS_IDX. The index can represent various resources depending on the
+ * register we access, it can be a hit counter for some classification tables,
+ * a counter specific to a rxq, a txq or a buffer pool.
+ */
+static u32 mvpp2_read_index(struct mvpp2 *priv, u32 index, u32 reg)
+{
+	mvpp2_write(priv, MVPP2_CTRS_IDX, index);
+	return mvpp2_read(priv, reg);
+}
+
 /* Due to the fact that software statistics and hardware statistics are, by
  * design, incremented at different moments in the chain of packet processing,
  * it is very likely that incoming packets could have been dropped after being
@@ -1297,32 +1308,114 @@ static const struct mvpp2_ethtool_counter mvpp2_ethtool_mib_regs[] = {
 	{ MVPP2_MIB_LATE_COLLISION, "late_collision" },
 };
 
+static const struct mvpp2_ethtool_counter mvpp2_ethtool_port_regs[] = {
+	{ MVPP2_OVERRUN_ETH_DROP, "rx_fifo_or_parser_overrun_drops" },
+	{ MVPP2_CLS_ETH_DROP, "rx_classifier_drops" },
+};
+
+static const struct mvpp2_ethtool_counter mvpp2_ethtool_txq_regs[] = {
+	{ MVPP2_TX_DESC_ENQ_CTR, "txq_%d_desc_enqueue" },
+	{ MVPP2_TX_DESC_ENQ_TO_DDR_CTR, "txq_%d_desc_enqueue_to_ddr" },
+	{ MVPP2_TX_BUFF_ENQ_TO_DDR_CTR, "txq_%d_buff_euqueue_to_ddr" },
+	{ MVPP2_TX_DESC_ENQ_HW_FWD_CTR, "txq_%d_desc_hardware_forwarded" },
+	{ MVPP2_TX_PKTS_DEQ_CTR, "txq_%d_packets_dequeued" },
+	{ MVPP2_TX_PKTS_FULL_QUEUE_DROP_CTR, "txq_%d_queue_full_drops" },
+	{ MVPP2_TX_PKTS_EARLY_DROP_CTR, "txq_%d_packets_early_drops" },
+	{ MVPP2_TX_PKTS_BM_DROP_CTR, "txq_%d_packets_bm_drops" },
+	{ MVPP2_TX_PKTS_BM_MC_DROP_CTR, "txq_%d_packets_rep_bm_drops" },
+};
+
+static const struct mvpp2_ethtool_counter mvpp2_ethtool_rxq_regs[] = {
+	{ MVPP2_RX_DESC_ENQ_CTR, "rxq_%d_desc_enqueue" },
+	{ MVPP2_RX_PKTS_FULL_QUEUE_DROP_CTR, "rxq_%d_queue_full_drops" },
+	{ MVPP2_RX_PKTS_EARLY_DROP_CTR, "rxq_%d_packets_early_drops" },
+	{ MVPP2_RX_PKTS_BM_DROP_CTR, "rxq_%d_packets_bm_drops" },
+};
+
+#define MVPP2_N_ETHTOOL_STATS(ntxqs, nrxqs)	(ARRAY_SIZE(mvpp2_ethtool_mib_regs) + \
+						 ARRAY_SIZE(mvpp2_ethtool_port_regs) + \
+						 (ARRAY_SIZE(mvpp2_ethtool_txq_regs) * (ntxqs)) + \
+						 (ARRAY_SIZE(mvpp2_ethtool_rxq_regs) * (nrxqs)))
+
 static void mvpp2_ethtool_get_strings(struct net_device *netdev, u32 sset,
 				      u8 *data)
 {
-	if (sset == ETH_SS_STATS) {
-		int i;
+	struct mvpp2_port *port = netdev_priv(netdev);
+	int i, q;
 
-		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_mib_regs); i++)
-			strscpy(data + i * ETH_GSTRING_LEN,
-				mvpp2_ethtool_mib_regs[i].string,
-				ETH_GSTRING_LEN);
+	if (sset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_mib_regs); i++) {
+		strscpy(data, mvpp2_ethtool_mib_regs[i].string,
+			ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_port_regs); i++) {
+		strscpy(data, mvpp2_ethtool_port_regs[i].string,
+			ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+
+	for (q = 0; q < port->ntxqs; q++) {
+		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_txq_regs); i++) {
+			snprintf(data, ETH_GSTRING_LEN,
+				 mvpp2_ethtool_txq_regs[i].string, q);
+			data += ETH_GSTRING_LEN;
+		}
+	}
+
+	for (q = 0; q < port->nrxqs; q++) {
+		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_rxq_regs); i++) {
+			snprintf(data, ETH_GSTRING_LEN,
+				 mvpp2_ethtool_rxq_regs[i].string,
+				 q);
+			data += ETH_GSTRING_LEN;
+		}
 	}
 }
 
+static void mvpp2_read_stats(struct mvpp2_port *port)
+{
+	u64 *pstats;
+	int i, q;
+
+	pstats = port->ethtool_stats;
+
+	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_mib_regs); i++)
+		*pstats++ += mvpp2_read_count(port, &mvpp2_ethtool_mib_regs[i]);
+
+	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_port_regs); i++)
+		*pstats++ += mvpp2_read(port->priv,
+					mvpp2_ethtool_port_regs[i].offset +
+					4 * port->id);
+
+	for (q = 0; q < port->ntxqs; q++)
+		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_txq_regs); i++)
+			*pstats++ += mvpp2_read_index(port->priv,
+						      MVPP22_CTRS_TX_CTR(port->id, i),
+						      mvpp2_ethtool_txq_regs[i].offset);
+
+	/* Rxqs are numbered from 0 from the user standpoint, but not from the
+	 * driver's. We need to add the  port->first_rxq offset.
+	 */
+	for (q = 0; q < port->nrxqs; q++)
+		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_rxq_regs); i++)
+			*pstats++ += mvpp2_read_index(port->priv,
+						      port->first_rxq + i,
+						      mvpp2_ethtool_rxq_regs[i].offset);
+}
+
 static void mvpp2_gather_hw_statistics(struct work_struct *work)
 {
 	struct delayed_work *del_work = to_delayed_work(work);
 	struct mvpp2_port *port = container_of(del_work, struct mvpp2_port,
 					       stats_work);
-	u64 *pstats;
-	int i;
 
 	mutex_lock(&port->gather_stats_lock);
 
-	pstats = port->ethtool_stats;
-	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_mib_regs); i++)
-		*pstats++ += mvpp2_read_count(port, &mvpp2_ethtool_mib_regs[i]);
+	mvpp2_read_stats(port);
 
 	/* No need to read again the counters right after this function if it
 	 * was called asynchronously by the user (ie. use of ethtool).
@@ -1346,14 +1439,16 @@ static void mvpp2_ethtool_get_stats(struct net_device *dev,
 
 	mutex_lock(&port->gather_stats_lock);
 	memcpy(data, port->ethtool_stats,
-	       sizeof(u64) * ARRAY_SIZE(mvpp2_ethtool_mib_regs));
+	       sizeof(u64) * MVPP2_N_ETHTOOL_STATS(port->ntxqs, port->nrxqs));
 	mutex_unlock(&port->gather_stats_lock);
 }
 
 static int mvpp2_ethtool_get_sset_count(struct net_device *dev, int sset)
 {
+	struct mvpp2_port *port = netdev_priv(dev);
+
 	if (sset == ETH_SS_STATS)
-		return ARRAY_SIZE(mvpp2_ethtool_mib_regs);
+		return MVPP2_N_ETHTOOL_STATS(port->ntxqs, port->nrxqs);
 
 	return -EOPNOTSUPP;
 }
@@ -4261,7 +4356,7 @@ static int mvpp2_port_init(struct mvpp2_port *port)
 	struct mvpp2 *priv = port->priv;
 	struct mvpp2_txq_pcpu *txq_pcpu;
 	unsigned int thread;
-	int queue, err, i;
+	int queue, err;
 
 	/* Checks for hardware constraints */
 	if (port->first_rxq + port->nrxqs >
@@ -4368,9 +4463,10 @@ static int mvpp2_port_init(struct mvpp2_port *port)
 	if (err)
 		goto err_free_percpu;
 
-	/* Read the GOP statistics to reset the hardware counters */
-	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_mib_regs); i++)
-		mvpp2_read_count(port, &mvpp2_ethtool_mib_regs[i]);
+	/* Clear all port stats */
+	mvpp2_read_stats(port);
+	memset(port->ethtool_stats, 0,
+	       MVPP2_N_ETHTOOL_STATS(port->ntxqs, port->nrxqs) * sizeof(u64));
 
 	return 0;
 
@@ -5053,7 +5149,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	}
 
 	port->ethtool_stats = devm_kcalloc(&pdev->dev,
-					   ARRAY_SIZE(mvpp2_ethtool_mib_regs),
+					   MVPP2_N_ETHTOOL_STATS(ntxqs, nrxqs),
 					   sizeof(u64), GFP_KERNEL);
 	if (!port->ethtool_stats) {
 		err = -ENOMEM;
-- 
2.20.1

