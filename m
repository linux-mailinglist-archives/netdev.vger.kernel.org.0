Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50A61E93D3
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgE3VIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:08:43 -0400
Received: from inva021.nxp.com ([92.121.34.21]:60750 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbgE3VIh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 17:08:37 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2C2232013B4;
        Sat, 30 May 2020 23:08:34 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1CC98200200;
        Sat, 30 May 2020 23:08:34 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D35E5203C0;
        Sat, 30 May 2020 23:08:33 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 1/7] dpaa2-eth: Add support for Rx traffic classes
Date:   Sun, 31 May 2020 00:08:08 +0300
Message-Id: <20200530210814.348-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200530210814.348-1-ioana.ciornei@nxp.com>
References: <20200530210814.348-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

The firmware reserves for each DPNI a number of RX frame queues
equal to the number of configured flows x number of configured
traffic classes.

Current driver configuration directs all incoming traffic to
FQs corresponding to TC0, leaving all other priority levels unused.

Start adding support for multiple ingress traffic classes, by
configuring the FQs associated with all priority levels, not just
TC0. All settings that are per-TC, such as those related to
hashing and flow steering, are also updated.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v4:
 - none

 .../freescale/dpaa2/dpaa2-eth-debugfs.c       |  7 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 70 +++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  4 +-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 19 +++--
 4 files changed, 68 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 0a31e4268dfb..c453a23045c1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -81,8 +81,8 @@ static int dpaa2_dbg_fqs_show(struct seq_file *file, void *offset)
 	int i, err;
 
 	seq_printf(file, "FQ stats for %s:\n", priv->net_dev->name);
-	seq_printf(file, "%s%16s%16s%16s%16s\n",
-		   "VFQID", "CPU", "Type", "Frames", "Pending frames");
+	seq_printf(file, "%s%16s%16s%16s%16s%16s\n",
+		   "VFQID", "CPU", "TC", "Type", "Frames", "Pending frames");
 
 	for (i = 0; i <  priv->num_fqs; i++) {
 		fq = &priv->fq[i];
@@ -90,9 +90,10 @@ static int dpaa2_dbg_fqs_show(struct seq_file *file, void *offset)
 		if (err)
 			fcnt = 0;
 
-		seq_printf(file, "%5d%16d%16s%16llu%16u\n",
+		seq_printf(file, "%5d%16d%16d%16s%16llu%16u\n",
 			   fq->fqid,
 			   fq->target_cpu,
+			   fq->tc,
 			   fq_type_to_str(fq),
 			   fq->stats.frames,
 			   fcnt);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index fe3806d54630..01263e247d39 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1290,6 +1290,7 @@ static void disable_ch_napi(struct dpaa2_eth_priv *priv)
 static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv, bool enable)
 {
 	struct dpni_taildrop td = {0};
+	struct dpaa2_eth_fq *fq;
 	int i, err;
 
 	if (priv->rx_td_enabled == enable)
@@ -1299,11 +1300,12 @@ static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv, bool enable)
 	td.threshold = DPAA2_ETH_TAILDROP_THRESH;
 
 	for (i = 0; i < priv->num_fqs; i++) {
-		if (priv->fq[i].type != DPAA2_RX_FQ)
+		fq = &priv->fq[i];
+		if (fq->type != DPAA2_RX_FQ)
 			continue;
 		err = dpni_set_taildrop(priv->mc_io, 0, priv->mc_token,
-					DPNI_CP_QUEUE, DPNI_QUEUE_RX, 0,
-					priv->fq[i].flowid, &td);
+					DPNI_CP_QUEUE, DPNI_QUEUE_RX,
+					fq->tc, fq->flowid, &td);
 		if (err) {
 			netdev_err(priv->net_dev,
 				   "dpni_set_taildrop() failed\n");
@@ -2407,7 +2409,7 @@ static void set_fq_affinity(struct dpaa2_eth_priv *priv)
 
 static void setup_fqs(struct dpaa2_eth_priv *priv)
 {
-	int i;
+	int i, j;
 
 	/* We have one TxConf FQ per Tx flow.
 	 * The number of Tx and Rx queues is the same.
@@ -2419,10 +2421,13 @@ static void setup_fqs(struct dpaa2_eth_priv *priv)
 		priv->fq[priv->num_fqs++].flowid = (u16)i;
 	}
 
-	for (i = 0; i < dpaa2_eth_queue_count(priv); i++) {
-		priv->fq[priv->num_fqs].type = DPAA2_RX_FQ;
-		priv->fq[priv->num_fqs].consume = dpaa2_eth_rx;
-		priv->fq[priv->num_fqs++].flowid = (u16)i;
+	for (j = 0; j < dpaa2_eth_tc_count(priv); j++) {
+		for (i = 0; i < dpaa2_eth_queue_count(priv); i++) {
+			priv->fq[priv->num_fqs].type = DPAA2_RX_FQ;
+			priv->fq[priv->num_fqs].consume = dpaa2_eth_rx;
+			priv->fq[priv->num_fqs].tc = (u8)j;
+			priv->fq[priv->num_fqs++].flowid = (u16)i;
+		}
 	}
 
 	/* For each FQ, decide on which core to process incoming frames */
@@ -2789,7 +2794,7 @@ static int setup_rx_flow(struct dpaa2_eth_priv *priv,
 	int err;
 
 	err = dpni_get_queue(priv->mc_io, 0, priv->mc_token,
-			     DPNI_QUEUE_RX, 0, fq->flowid, &queue, &qid);
+			     DPNI_QUEUE_RX, fq->tc, fq->flowid, &queue, &qid);
 	if (err) {
 		dev_err(dev, "dpni_get_queue(RX) failed\n");
 		return err;
@@ -2802,7 +2807,7 @@ static int setup_rx_flow(struct dpaa2_eth_priv *priv,
 	queue.destination.priority = 1;
 	queue.user_context = (u64)(uintptr_t)fq;
 	err = dpni_set_queue(priv->mc_io, 0, priv->mc_token,
-			     DPNI_QUEUE_RX, 0, fq->flowid,
+			     DPNI_QUEUE_RX, fq->tc, fq->flowid,
 			     DPNI_QUEUE_OPT_USER_CTX | DPNI_QUEUE_OPT_DEST,
 			     &queue);
 	if (err) {
@@ -2811,6 +2816,10 @@ static int setup_rx_flow(struct dpaa2_eth_priv *priv,
 	}
 
 	/* xdp_rxq setup */
+	/* only once for each channel */
+	if (fq->tc > 0)
+		return 0;
+
 	err = xdp_rxq_info_reg(&fq->channel->xdp_rxq, priv->net_dev,
 			       fq->flowid);
 	if (err) {
@@ -2948,7 +2957,7 @@ static int config_legacy_hash_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpni_rx_tc_dist_cfg dist_cfg;
-	int err;
+	int i, err = 0;
 
 	memset(&dist_cfg, 0, sizeof(dist_cfg));
 
@@ -2956,9 +2965,14 @@ static int config_legacy_hash_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
 	dist_cfg.dist_size = dpaa2_eth_queue_count(priv);
 	dist_cfg.dist_mode = DPNI_DIST_MODE_HASH;
 
-	err = dpni_set_rx_tc_dist(priv->mc_io, 0, priv->mc_token, 0, &dist_cfg);
-	if (err)
-		dev_err(dev, "dpni_set_rx_tc_dist failed\n");
+	for (i = 0; i < dpaa2_eth_tc_count(priv); i++) {
+		err = dpni_set_rx_tc_dist(priv->mc_io, 0, priv->mc_token,
+					  i, &dist_cfg);
+		if (err) {
+			dev_err(dev, "dpni_set_rx_tc_dist failed\n");
+			break;
+		}
+	}
 
 	return err;
 }
@@ -2968,7 +2982,7 @@ static int config_hash_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpni_rx_dist_cfg dist_cfg;
-	int err;
+	int i, err = 0;
 
 	memset(&dist_cfg, 0, sizeof(dist_cfg));
 
@@ -2976,9 +2990,15 @@ static int config_hash_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
 	dist_cfg.dist_size = dpaa2_eth_queue_count(priv);
 	dist_cfg.enable = 1;
 
-	err = dpni_set_rx_hash_dist(priv->mc_io, 0, priv->mc_token, &dist_cfg);
-	if (err)
-		dev_err(dev, "dpni_set_rx_hash_dist failed\n");
+	for (i = 0; i < dpaa2_eth_tc_count(priv); i++) {
+		dist_cfg.tc = i;
+		err = dpni_set_rx_hash_dist(priv->mc_io, 0, priv->mc_token,
+					    &dist_cfg);
+		if (err) {
+			dev_err(dev, "dpni_set_rx_hash_dist failed\n");
+			break;
+		}
+	}
 
 	return err;
 }
@@ -2988,7 +3008,7 @@ static int config_cls_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpni_rx_dist_cfg dist_cfg;
-	int err;
+	int i, err = 0;
 
 	memset(&dist_cfg, 0, sizeof(dist_cfg));
 
@@ -2996,9 +3016,15 @@ static int config_cls_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
 	dist_cfg.dist_size = dpaa2_eth_queue_count(priv);
 	dist_cfg.enable = 1;
 
-	err = dpni_set_rx_fs_dist(priv->mc_io, 0, priv->mc_token, &dist_cfg);
-	if (err)
-		dev_err(dev, "dpni_set_rx_fs_dist failed\n");
+	for (i = 0; i < dpaa2_eth_tc_count(priv); i++) {
+		dist_cfg.tc = i;
+		err = dpni_set_rx_fs_dist(priv->mc_io, 0, priv->mc_token,
+					  &dist_cfg);
+		if (err) {
+			dev_err(dev, "dpni_set_rx_fs_dist failed\n");
+			break;
+		}
+	}
 
 	return err;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 0581fbf1f98c..580ad5fd7bd8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -294,7 +294,9 @@ struct dpaa2_eth_ch_stats {
 
 /* Maximum number of queues associated with a DPNI */
 #define DPAA2_ETH_MAX_TCS		8
-#define DPAA2_ETH_MAX_RX_QUEUES		16
+#define DPAA2_ETH_MAX_RX_QUEUES_PER_TC	16
+#define DPAA2_ETH_MAX_RX_QUEUES		\
+	(DPAA2_ETH_MAX_RX_QUEUES_PER_TC * DPAA2_ETH_MAX_TCS)
 #define DPAA2_ETH_MAX_TX_QUEUES		16
 #define DPAA2_ETH_MAX_QUEUES		(DPAA2_ETH_MAX_RX_QUEUES + \
 					DPAA2_ETH_MAX_TX_QUEUES)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 049afd1d6252..8bf169783bea 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -547,7 +547,7 @@ static int do_cls_rule(struct net_device *net_dev,
 	dma_addr_t key_iova;
 	u64 fields = 0;
 	void *key_buf;
-	int err;
+	int i, err;
 
 	if (fs->ring_cookie != RX_CLS_FLOW_DISC &&
 	    fs->ring_cookie >= dpaa2_eth_queue_count(priv))
@@ -607,11 +607,18 @@ static int do_cls_rule(struct net_device *net_dev,
 			fs_act.options |= DPNI_FS_OPT_DISCARD;
 		else
 			fs_act.flow_id = fs->ring_cookie;
-		err = dpni_add_fs_entry(priv->mc_io, 0, priv->mc_token, 0,
-					fs->location, &rule_cfg, &fs_act);
-	} else {
-		err = dpni_remove_fs_entry(priv->mc_io, 0, priv->mc_token, 0,
-					   &rule_cfg);
+	}
+	for (i = 0; i < dpaa2_eth_tc_count(priv); i++) {
+		if (add)
+			err = dpni_add_fs_entry(priv->mc_io, 0, priv->mc_token,
+						i, fs->location, &rule_cfg,
+						&fs_act);
+		else
+			err = dpni_remove_fs_entry(priv->mc_io, 0,
+						   priv->mc_token, i,
+						   &rule_cfg);
+		if (err)
+			break;
 	}
 
 	dma_unmap_single(dev, key_iova, rule_cfg.key_size * 2, DMA_TO_DEVICE);
-- 
2.17.1

