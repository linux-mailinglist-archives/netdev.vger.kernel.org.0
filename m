Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF69B36F1B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfFFIue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:50:34 -0400
Received: from inva020.nxp.com ([92.121.34.13]:50232 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727402AbfFFIuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 04:50:32 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C76F61A0A72;
        Thu,  6 Jun 2019 10:50:30 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BAF6D1A0A7D;
        Thu,  6 Jun 2019 10:50:30 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 833F4205C7;
        Thu,  6 Jun 2019 10:50:30 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next v2 2/3] dpaa2-eth: Support multiple traffic classes on Tx
Date:   Thu,  6 Jun 2019 11:50:28 +0300
Message-Id: <1559811029-28002-3-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559811029-28002-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1559811029-28002-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DPNI objects can have multiple traffic classes, as reflected by
the num_tc attribute. Until now we ignored its value and only
used traffic class 0.

This patch adds support for multiple Tx traffic classes; the skb
priority information received from the stack is used to select the
hardware Tx queue on which to enqueue the frame.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
---
v2: Extra processing on the fast path happens only when TC is used

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 47 ++++++++++++++++--------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |  9 ++++-
 2 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index a12fc45..98de092 100644
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
@@ -2380,11 +2394,10 @@ static inline int dpaa2_eth_enqueue_qd(struct dpaa2_eth_priv *priv,
 
 static inline int dpaa2_eth_enqueue_fq(struct dpaa2_eth_priv *priv,
 				       struct dpaa2_eth_fq *fq,
-				       struct dpaa2_fd *fd,
-				       u8 prio __always_unused)
+				       struct dpaa2_fd *fd, u8 prio)
 {
 	return dpaa2_io_service_enqueue_fq(fq->channel->dpio,
-					   fq->tx_fqid, fd);
+					   fq->tx_fqid[prio], fd);
 }
 
 static void set_enqueue_mode(struct dpaa2_eth_priv *priv)
@@ -2540,17 +2553,21 @@ static int setup_tx_flow(struct dpaa2_eth_priv *priv,
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpni_queue queue;
 	struct dpni_queue_id qid;
-	int err;
+	int i, err;
 
-	err = dpni_get_queue(priv->mc_io, 0, priv->mc_token,
-			     DPNI_QUEUE_TX, 0, fq->flowid, &queue, &qid);
-	if (err) {
-		dev_err(dev, "dpni_get_queue(TX) failed\n");
-		return err;
+	for (i = 0; i < dpaa2_eth_tc_count(priv); i++) {
+		err = dpni_get_queue(priv->mc_io, 0, priv->mc_token,
+				     DPNI_QUEUE_TX, i, fq->flowid,
+				     &queue, &qid);
+		if (err) {
+			dev_err(dev, "dpni_get_queue(TX) failed\n");
+			return err;
+		}
+		fq->tx_fqid[i] = qid.fqid;
 	}
 
+	/* All Tx queues belonging to the same flowid have the same qdbin */
 	fq->tx_qdbin = qid.qdbin;
-	fq->tx_fqid = qid.fqid;
 
 	err = dpni_get_queue(priv->mc_io, 0, priv->mc_token,
 			     DPNI_QUEUE_TX_CONFIRM, 0, fq->flowid,
@@ -3250,7 +3267,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	dev = &dpni_dev->dev;
 
 	/* Net device */
-	net_dev = alloc_etherdev_mq(sizeof(*priv), DPAA2_ETH_MAX_TX_QUEUES);
+	net_dev = alloc_etherdev_mq(sizeof(*priv), DPAA2_ETH_MAX_NETDEV_QUEUES);
 	if (!net_dev) {
 		dev_err(dev, "alloc_etherdev_mq() failed\n");
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index e180d5a..9af18c2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -282,10 +282,13 @@ struct dpaa2_eth_ch_stats {
 };
 
 /* Maximum number of queues associated with a DPNI */
+#define DPAA2_ETH_MAX_TCS		8
 #define DPAA2_ETH_MAX_RX_QUEUES		16
 #define DPAA2_ETH_MAX_TX_QUEUES		16
 #define DPAA2_ETH_MAX_QUEUES		(DPAA2_ETH_MAX_RX_QUEUES + \
 					DPAA2_ETH_MAX_TX_QUEUES)
+#define DPAA2_ETH_MAX_NETDEV_QUEUES	\
+	(DPAA2_ETH_MAX_TX_QUEUES * DPAA2_ETH_MAX_TCS)
 
 #define DPAA2_ETH_MAX_DPCONS		16
 
@@ -299,8 +302,9 @@ struct dpaa2_eth_priv;
 struct dpaa2_eth_fq {
 	u32 fqid;
 	u32 tx_qdbin;
-	u32 tx_fqid;
+	u32 tx_fqid[DPAA2_ETH_MAX_TCS];
 	u16 flowid;
+	u8 tc;
 	int target_cpu;
 	u32 dq_frames;
 	u32 dq_bytes;
@@ -448,6 +452,9 @@ static inline int dpaa2_eth_cmp_dpni_ver(struct dpaa2_eth_priv *priv,
 #define dpaa2_eth_fs_count(priv)        \
 	((priv)->dpni_attrs.fs_entries)
 
+#define dpaa2_eth_tc_count(priv)	\
+	((priv)->dpni_attrs.num_tcs)
+
 /* We have exactly one {Rx, Tx conf} queue per channel */
 #define dpaa2_eth_queue_count(priv)     \
 	((priv)->num_channels)
-- 
2.7.4

