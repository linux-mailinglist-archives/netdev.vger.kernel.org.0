Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 639F43CA61
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404112AbfFKLuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:50:10 -0400
Received: from inva020.nxp.com ([92.121.34.13]:35702 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403957AbfFKLuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 07:50:06 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DC5091A0A90;
        Tue, 11 Jun 2019 13:50:04 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D960E1A0EF1;
        Tue, 11 Jun 2019 13:50:04 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A145820600;
        Tue, 11 Jun 2019 13:50:04 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next v3 3/3] dpaa2-eth: Add mqprio support
Date:   Tue, 11 Jun 2019 14:50:03 +0300
Message-Id: <1560253803-6613-4-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560253803-6613-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1560253803-6613-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement mqprio qdisc support by mapping traffic classes to
different hardware enqueue priorities. The maximum number of
supported traffic classes is an attribute of each DPNI object.

The traffic classes map to hardware priorities from highest (0)
to lowest (highest prio number). The skb priority information
received from the stack is used to select the hardware Tx queue
on which to enqueue the frame.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Bogdan Purcareata <bogdan.purcareata@nxp.com>
---
v2: no changes
v3: move Tx fastpath code changes to this patch, to make it
more clear how skb queue mapping is used for FQ selection

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 67 ++++++++++++++++++++++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |  2 +
 2 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 86c771d..6f69422 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -757,6 +757,7 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	u16 queue_mapping;
 	unsigned int needed_headroom;
 	u32 fd_len;
+	u8 prio = 0;
 	int err, i;
 
 	percpu_stats = this_cpu_ptr(priv->percpu_stats);
@@ -814,6 +815,18 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	 * a queue affined to the same core that processed the Rx frame
 	 */
 	queue_mapping = skb_get_queue_mapping(skb);
+
+	if (net_dev->num_tc) {
+		prio = netdev_txq_to_tc(net_dev, queue_mapping);
+		/* Hardware interprets priority level 0 as being the highest,
+		 * so we need to do a reverse mapping to the netdev tc index
+		 */
+		prio = net_dev->num_tc - prio - 1;
+		/* We have only one FQ array entry for all Tx hardware queues
+		 * with the same flow id (but different priority levels)
+		 */
+		queue_mapping %= dpaa2_eth_queue_count(priv);
+	}
 	fq = &priv->fq[queue_mapping];
 
 	fd_len = dpaa2_fd_get_len(&fd);
@@ -824,7 +837,7 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	 * the Tx confirmation callback for this frame
 	 */
 	for (i = 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
-		err = priv->enqueue(priv, fq, &fd, 0);
+		err = priv->enqueue(priv, fq, &fd, prio);
 		if (err != -EBUSY)
 			break;
 	}
@@ -1877,16 +1890,17 @@ static int update_xps(struct dpaa2_eth_priv *priv)
 	struct net_device *net_dev = priv->net_dev;
 	struct cpumask xps_mask;
 	struct dpaa2_eth_fq *fq;
-	int i, num_queues;
+	int i, num_queues, netdev_queues;
 	int err = 0;
 
 	num_queues = dpaa2_eth_queue_count(priv);
+	netdev_queues = (net_dev->num_tc ? : 1) * num_queues;
 
 	/* The first <num_queues> entries in priv->fq array are Tx/Tx conf
 	 * queues, so only process those
 	 */
-	for (i = 0; i < num_queues; i++) {
-		fq = &priv->fq[i];
+	for (i = 0; i < netdev_queues; i++) {
+		fq = &priv->fq[i % num_queues];
 
 		cpumask_clear(&xps_mask);
 		cpumask_set_cpu(fq->target_cpu, &xps_mask);
@@ -1901,6 +1915,48 @@ static int update_xps(struct dpaa2_eth_priv *priv)
 	return err;
 }
 
+static int dpaa2_eth_setup_tc(struct net_device *net_dev,
+			      enum tc_setup_type type, void *type_data)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	struct tc_mqprio_qopt *mqprio = type_data;
+	u8 num_tc, num_queues;
+	int i;
+
+	if (type != TC_SETUP_QDISC_MQPRIO)
+		return -EINVAL;
+
+	mqprio->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
+	num_queues = dpaa2_eth_queue_count(priv);
+	num_tc = mqprio->num_tc;
+
+	if (num_tc == net_dev->num_tc)
+		return 0;
+
+	if (num_tc  > dpaa2_eth_tc_count(priv)) {
+		netdev_err(net_dev, "Max %d traffic classes supported\n",
+			   dpaa2_eth_tc_count(priv));
+		return -EINVAL;
+	}
+
+	if (!num_tc) {
+		netdev_reset_tc(net_dev);
+		netif_set_real_num_tx_queues(net_dev, num_queues);
+		goto out;
+	}
+
+	netdev_set_num_tc(net_dev, num_tc);
+	netif_set_real_num_tx_queues(net_dev, num_tc * num_queues);
+
+	for (i = 0; i < num_tc; i++)
+		netdev_set_tc_queue(net_dev, i, num_queues, i * num_queues);
+
+out:
+	update_xps(priv);
+
+	return 0;
+}
+
 static const struct net_device_ops dpaa2_eth_ops = {
 	.ndo_open = dpaa2_eth_open,
 	.ndo_start_xmit = dpaa2_eth_tx,
@@ -1913,6 +1969,7 @@ static const struct net_device_ops dpaa2_eth_ops = {
 	.ndo_change_mtu = dpaa2_eth_change_mtu,
 	.ndo_bpf = dpaa2_eth_xdp,
 	.ndo_xdp_xmit = dpaa2_eth_xdp_xmit,
+	.ndo_setup_tc = dpaa2_eth_setup_tc,
 };
 
 static void cdan_cb(struct dpaa2_io_notification_ctx *ctx)
@@ -3253,7 +3310,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	dev = &dpni_dev->dev;
 
 	/* Net device */
-	net_dev = alloc_etherdev_mq(sizeof(*priv), DPAA2_ETH_MAX_TX_QUEUES);
+	net_dev = alloc_etherdev_mq(sizeof(*priv), DPAA2_ETH_MAX_NETDEV_QUEUES);
 	if (!net_dev) {
 		dev_err(dev, "alloc_etherdev_mq() failed\n");
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 73756e6..9af18c2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -287,6 +287,8 @@ struct dpaa2_eth_ch_stats {
 #define DPAA2_ETH_MAX_TX_QUEUES		16
 #define DPAA2_ETH_MAX_QUEUES		(DPAA2_ETH_MAX_RX_QUEUES + \
 					DPAA2_ETH_MAX_TX_QUEUES)
+#define DPAA2_ETH_MAX_NETDEV_QUEUES	\
+	(DPAA2_ETH_MAX_TX_QUEUES * DPAA2_ETH_MAX_TCS)
 
 #define DPAA2_ETH_MAX_DPCONS		16
 
-- 
2.7.4

