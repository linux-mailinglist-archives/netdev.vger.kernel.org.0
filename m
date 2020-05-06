Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A501C7882
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgEFRr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:47:29 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47566 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728630AbgEFRr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 13:47:28 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A046D1A0CF3;
        Wed,  6 May 2020 19:47:26 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 93EBC1A0D08;
        Wed,  6 May 2020 19:47:26 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5EF9C205C6;
        Wed,  6 May 2020 19:47:26 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     hawk@kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/2] dpaa2-eth: add bulking to XDP_TX
Date:   Wed,  6 May 2020 20:47:18 +0300
Message-Id: <20200506174718.20916-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506174718.20916-1-ioana.ciornei@nxp.com>
References: <20200506174718.20916-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add driver level bulking to the XDP_TX action.

An array of frame descriptors is held for each Tx frame queue and
populated accordingly when the action returned by the XDP program is
XDP_TX. The frames will be actually enqueued only when the array is
filled. At the end of the NAPI cycle a flush on the queued frames is
performed in order to enqueue the remaining FDs.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 68 ++++++++++++-------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  1 +
 2 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 0f3e842a4fd6..b1c64288a1fb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -273,13 +273,43 @@ static int dpaa2_eth_xdp_flush(struct dpaa2_eth_priv *priv,
 	return total_enqueued;
 }
 
-static int xdp_enqueue(struct dpaa2_eth_priv *priv, struct dpaa2_fd *fd,
-		       void *buf_start, u16 queue_id)
+static void xdp_tx_flush(struct dpaa2_eth_priv *priv,
+			 struct dpaa2_eth_channel *ch,
+			 struct dpaa2_eth_fq *fq)
+{
+	struct rtnl_link_stats64 *percpu_stats;
+	struct dpaa2_fd *fds;
+	int enqueued, i;
+
+	percpu_stats = this_cpu_ptr(priv->percpu_stats);
+
+	// enqueue the array of XDP_TX frames
+	enqueued = dpaa2_eth_xdp_flush(priv, fq, &fq->xdp_tx_fds);
+
+	/* update statistics */
+	percpu_stats->tx_packets += enqueued;
+	fds = fq->xdp_tx_fds.fds;
+	for (i = 0; i < enqueued; i++) {
+		percpu_stats->tx_bytes += dpaa2_fd_get_len(&fds[i]);
+		ch->stats.xdp_tx++;
+	}
+	for (i = enqueued; i < fq->xdp_tx_fds.num; i++) {
+		xdp_release_buf(priv, ch, dpaa2_fd_get_addr(&fds[i]));
+		percpu_stats->tx_errors++;
+		ch->stats.xdp_tx_err++;
+	}
+	fq->xdp_tx_fds.num = 0;
+}
+
+static void xdp_enqueue(struct dpaa2_eth_priv *priv,
+			struct dpaa2_eth_channel *ch,
+			struct dpaa2_fd *fd,
+			void *buf_start, u16 queue_id)
 {
-	struct dpaa2_eth_fq *fq;
 	struct dpaa2_faead *faead;
+	struct dpaa2_fd *dest_fd;
+	struct dpaa2_eth_fq *fq;
 	u32 ctrl, frc;
-	int i, err;
 
 	/* Mark the egress frame hardware annotation area as valid */
 	frc = dpaa2_fd_get_frc(fd);
@@ -296,13 +326,13 @@ static int xdp_enqueue(struct dpaa2_eth_priv *priv, struct dpaa2_fd *fd,
 	faead->conf_fqid = 0;
 
 	fq = &priv->fq[queue_id];
-	for (i = 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
-		err = priv->enqueue(priv, fq, fd, 0, 1, NULL);
-		if (err != -EBUSY)
-			break;
-	}
+	dest_fd = &fq->xdp_tx_fds.fds[fq->xdp_tx_fds.num++];
+	memcpy(dest_fd, fd, sizeof(*dest_fd));
 
-	return err;
+	if (fq->xdp_tx_fds.num < DEV_MAP_BULK_SIZE)
+		return;
+
+	xdp_tx_flush(priv, ch, fq);
 }
 
 static u32 run_xdp(struct dpaa2_eth_priv *priv,
@@ -311,14 +341,11 @@ static u32 run_xdp(struct dpaa2_eth_priv *priv,
 		   struct dpaa2_fd *fd, void *vaddr)
 {
 	dma_addr_t addr = dpaa2_fd_get_addr(fd);
-	struct rtnl_link_stats64 *percpu_stats;
 	struct bpf_prog *xdp_prog;
 	struct xdp_buff xdp;
 	u32 xdp_act = XDP_PASS;
 	int err;
 
-	percpu_stats = this_cpu_ptr(priv->percpu_stats);
-
 	rcu_read_lock();
 
 	xdp_prog = READ_ONCE(ch->xdp.prog);
@@ -341,16 +368,7 @@ static u32 run_xdp(struct dpaa2_eth_priv *priv,
 	case XDP_PASS:
 		break;
 	case XDP_TX:
-		err = xdp_enqueue(priv, fd, vaddr, rx_fq->flowid);
-		if (err) {
-			xdp_release_buf(priv, ch, addr);
-			percpu_stats->tx_errors++;
-			ch->stats.xdp_tx_err++;
-		} else {
-			percpu_stats->tx_packets++;
-			percpu_stats->tx_bytes += dpaa2_fd_get_len(fd);
-			ch->stats.xdp_tx++;
-		}
+		xdp_enqueue(priv, ch, fd, vaddr, rx_fq->flowid);
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(xdp_act);
@@ -1168,6 +1186,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 	int store_cleaned, work_done;
 	struct list_head rx_list;
 	int retries = 0;
+	u16 flowid;
 	int err;
 
 	ch = container_of(napi, struct dpaa2_eth_channel, napi);
@@ -1190,6 +1209,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 			break;
 		if (fq->type == DPAA2_RX_FQ) {
 			rx_cleaned += store_cleaned;
+			flowid = fq->flowid;
 		} else {
 			txconf_cleaned += store_cleaned;
 			/* We have a single Tx conf FQ on this channel */
@@ -1232,6 +1252,8 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 
 	if (ch->xdp.res & XDP_REDIRECT)
 		xdp_do_flush_map();
+	else if (rx_cleaned && ch->xdp.res & XDP_TX)
+		xdp_tx_flush(priv, ch, &priv->fq[flowid]);
 
 	return work_done;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index b5f7dbbc2a02..9c37b6946cec 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -334,6 +334,7 @@ struct dpaa2_eth_fq {
 	struct dpaa2_eth_fq_stats stats;
 
 	struct dpaa2_eth_xdp_fds xdp_redirect_fds;
+	struct dpaa2_eth_xdp_fds xdp_tx_fds;
 };
 
 struct dpaa2_eth_ch_xdp {
-- 
2.17.1

