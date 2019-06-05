Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C40B35A03
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 11:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfFEJ5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 05:57:31 -0400
Received: from inva021.nxp.com ([92.121.34.21]:57172 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727092AbfFEJ53 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 05:57:29 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D537C200778;
        Wed,  5 Jun 2019 11:57:27 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C898820076D;
        Wed,  5 Jun 2019 11:57:27 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 902E2205FA;
        Wed,  5 Jun 2019 11:57:27 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next 1/3] dpaa2-eth: Refactor xps code
Date:   Wed,  5 Jun 2019 12:57:24 +0300
Message-Id: <1559728646-4332-2-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559728646-4332-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1559728646-4332-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the code configuring xps on the netdev TX queues to a
separate function. A subsequent patch will need to call
this in another context as well.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 45 +++++++++++++++++-------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 753957e..a12fc45 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1872,6 +1872,35 @@ static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
 	return n - drops;
 }
 
+static int update_xps(struct dpaa2_eth_priv *priv)
+{
+	struct net_device *net_dev = priv->net_dev;
+	struct cpumask xps_mask;
+	struct dpaa2_eth_fq *fq;
+	int i, num_queues;
+	int err = 0;
+
+	num_queues = dpaa2_eth_queue_count(priv);
+
+	/* The first <num_queues> entries in priv->fq array are Tx/Tx conf
+	 * queues, so only process those
+	 */
+	for (i = 0; i < num_queues; i++) {
+		fq = &priv->fq[i];
+
+		cpumask_clear(&xps_mask);
+		cpumask_set_cpu(fq->target_cpu, &xps_mask);
+
+		err = netif_set_xps_queue(net_dev, &xps_mask, i);
+		if (err) {
+			netdev_warn_once(net_dev, "Error setting XPS queue\n");
+			break;
+		}
+	}
+
+	return err;
+}
+
 static const struct net_device_ops dpaa2_eth_ops = {
 	.ndo_open = dpaa2_eth_open,
 	.ndo_start_xmit = dpaa2_eth_tx,
@@ -2138,10 +2167,9 @@ static struct dpaa2_eth_channel *get_affine_channel(struct dpaa2_eth_priv *priv,
 static void set_fq_affinity(struct dpaa2_eth_priv *priv)
 {
 	struct device *dev = priv->net_dev->dev.parent;
-	struct cpumask xps_mask;
 	struct dpaa2_eth_fq *fq;
 	int rx_cpu, txc_cpu;
-	int i, err;
+	int i;
 
 	/* For each FQ, pick one channel/CPU to deliver frames to.
 	 * This may well change at runtime, either through irqbalance or
@@ -2160,17 +2188,6 @@ static void set_fq_affinity(struct dpaa2_eth_priv *priv)
 			break;
 		case DPAA2_TX_CONF_FQ:
 			fq->target_cpu = txc_cpu;
-
-			/* Tell the stack to affine to txc_cpu the Tx queue
-			 * associated with the confirmation one
-			 */
-			cpumask_clear(&xps_mask);
-			cpumask_set_cpu(txc_cpu, &xps_mask);
-			err = netif_set_xps_queue(priv->net_dev, &xps_mask,
-						  fq->flowid);
-			if (err)
-				dev_err(dev, "Error setting XPS queue\n");
-
 			txc_cpu = cpumask_next(txc_cpu, &priv->dpio_cpumask);
 			if (txc_cpu >= nr_cpu_ids)
 				txc_cpu = cpumask_first(&priv->dpio_cpumask);
@@ -2180,6 +2197,8 @@ static void set_fq_affinity(struct dpaa2_eth_priv *priv)
 		}
 		fq->channel = get_affine_channel(priv, fq->target_cpu);
 	}
+
+	update_xps(priv);
 }
 
 static void setup_fqs(struct dpaa2_eth_priv *priv)
-- 
2.7.4

