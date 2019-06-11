Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D6B3CA60
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404099AbfFKLuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:50:09 -0400
Received: from inva020.nxp.com ([92.121.34.13]:35650 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403936AbfFKLuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 07:50:06 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 935B21A0AA4;
        Tue, 11 Jun 2019 13:50:04 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 911AB1A0AA0;
        Tue, 11 Jun 2019 13:50:04 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5977E2062B;
        Tue, 11 Jun 2019 13:50:04 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next v3 2/3] dpaa2-eth: Support multiple traffic classes on Tx
Date:   Tue, 11 Jun 2019 14:50:02 +0300
Message-Id: <1560253803-6613-3-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560253803-6613-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1560253803-6613-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DPNI objects can have multiple traffic classes, as reflected by
the num_tc attribute. Until now we ignored its value and only
used traffic class 0.

This patch adds support for multiple Tx traffic classes; we have
num_queues x num_tcs hardware queues available for each interface.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
---
v3: move code changes on the Tx fastpath to patch 3/3
v2: Extra processing on the fast path happens only when TC is used

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 23 +++++++++++++----------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |  7 ++++++-
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index a12fc45..86c771d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2380,11 +2380,10 @@ static inline int dpaa2_eth_enqueue_qd(struct dpaa2_eth_priv *priv,
 
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
@@ -2540,17 +2539,21 @@ static int setup_tx_flow(struct dpaa2_eth_priv *priv,
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
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index e180d5a..73756e6 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -282,6 +282,7 @@ struct dpaa2_eth_ch_stats {
 };
 
 /* Maximum number of queues associated with a DPNI */
+#define DPAA2_ETH_MAX_TCS		8
 #define DPAA2_ETH_MAX_RX_QUEUES		16
 #define DPAA2_ETH_MAX_TX_QUEUES		16
 #define DPAA2_ETH_MAX_QUEUES		(DPAA2_ETH_MAX_RX_QUEUES + \
@@ -299,8 +300,9 @@ struct dpaa2_eth_priv;
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
@@ -448,6 +450,9 @@ static inline int dpaa2_eth_cmp_dpni_ver(struct dpaa2_eth_priv *priv,
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

