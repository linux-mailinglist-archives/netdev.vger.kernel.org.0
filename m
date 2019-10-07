Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D923CE0AA
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfJGLip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:38:45 -0400
Received: from inva020.nxp.com ([92.121.34.13]:58088 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727376AbfJGLio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 07:38:44 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DD1BE1A02BB;
        Mon,  7 Oct 2019 13:38:41 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D02441A064D;
        Mon,  7 Oct 2019 13:38:41 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 96E922060A;
        Mon,  7 Oct 2019 13:38:41 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 3/3] dpaa2-eth: Avoid unbounded while loops
Date:   Mon,  7 Oct 2019 14:38:28 +0300
Message-Id: <1570448308-16248-4-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1570448308-16248-1-git-send-email-ioana.ciornei@nxp.com>
References: <1570448308-16248-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

Throughout the driver there are several places where we wait
indefinitely for DPIO portal commands to be executed, while
the portal returns a busy response code.

Even though in theory we are guaranteed the portals become
available eventually, in practice the QBMan hardware module
may become unresponsive in various corner cases.

Make sure we can never get stuck in an infinite while loop
by adding a retry counter for all portal commands.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - return -ETIMEDOUT where possible if the number of retries is hit


 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 32 +++++++++++++++++++-----
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |  8 ++++++
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 2c5072fa9aa0..1b959d7ec923 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -221,6 +221,7 @@ static void xdp_release_buf(struct dpaa2_eth_priv *priv,
 			    struct dpaa2_eth_channel *ch,
 			    dma_addr_t addr)
 {
+	int retries = 0;
 	int err;
 
 	ch->xdp.drop_bufs[ch->xdp.drop_cnt++] = addr;
@@ -229,8 +230,11 @@ static void xdp_release_buf(struct dpaa2_eth_priv *priv,
 
 	while ((err = dpaa2_io_service_release(ch->dpio, priv->bpid,
 					       ch->xdp.drop_bufs,
-					       ch->xdp.drop_cnt)) == -EBUSY)
+					       ch->xdp.drop_cnt)) == -EBUSY) {
+		if (retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
+			break;
 		cpu_relax();
+	}
 
 	if (err) {
 		free_bufs(priv, ch->xdp.drop_bufs, ch->xdp.drop_cnt);
@@ -458,7 +462,7 @@ static int consume_frames(struct dpaa2_eth_channel *ch,
 	struct dpaa2_eth_fq *fq = NULL;
 	struct dpaa2_dq *dq;
 	const struct dpaa2_fd *fd;
-	int cleaned = 0;
+	int cleaned = 0, retries = 0;
 	int is_last;
 
 	do {
@@ -469,6 +473,11 @@ static int consume_frames(struct dpaa2_eth_channel *ch,
 			 * the store until we get some sort of valid response
 			 * token (either a valid frame or an "empty dequeue")
 			 */
+			if (retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES) {
+				netdev_err_once(priv->net_dev,
+						"Unable to read a valid dequeue response\n");
+				return -ETIMEDOUT;
+			}
 			continue;
 		}
 
@@ -477,6 +486,7 @@ static int consume_frames(struct dpaa2_eth_channel *ch,
 
 		fq->consume(priv, ch, fd, fq);
 		cleaned++;
+		retries = 0;
 	} while (!is_last);
 
 	if (!cleaned)
@@ -949,6 +959,7 @@ static int add_bufs(struct dpaa2_eth_priv *priv,
 	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
 	struct page *page;
 	dma_addr_t addr;
+	int retries = 0;
 	int i, err;
 
 	for (i = 0; i < DPAA2_ETH_BUFS_PER_CMD; i++) {
@@ -980,8 +991,11 @@ static int add_bufs(struct dpaa2_eth_priv *priv,
 release_bufs:
 	/* In case the portal is busy, retry until successful */
 	while ((err = dpaa2_io_service_release(ch->dpio, bpid,
-					       buf_array, i)) == -EBUSY)
+					       buf_array, i)) == -EBUSY) {
+		if (retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
+			break;
 		cpu_relax();
+	}
 
 	/* If release command failed, clean up and bail out;
 	 * not much else we can do about it
@@ -1032,16 +1046,21 @@ static int seed_pool(struct dpaa2_eth_priv *priv, u16 bpid)
 static void drain_bufs(struct dpaa2_eth_priv *priv, int count)
 {
 	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
+	int retries = 0;
 	int ret;
 
 	do {
 		ret = dpaa2_io_service_acquire(NULL, priv->bpid,
 					       buf_array, count);
 		if (ret < 0) {
+			if (ret == -EBUSY &&
+			    retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
+				continue;
 			netdev_err(priv->net_dev, "dpaa2_io_service_acquire() failed\n");
 			return;
 		}
 		free_bufs(priv, buf_array, ret);
+		retries = 0;
 	} while (ret);
 }
 
@@ -1094,7 +1113,7 @@ static int pull_channel(struct dpaa2_eth_channel *ch)
 						    ch->store);
 		dequeues++;
 		cpu_relax();
-	} while (err == -EBUSY);
+	} while (err == -EBUSY && dequeues < DPAA2_ETH_SWP_BUSY_RETRIES);
 
 	ch->stats.dequeue_portal_busy += dequeues;
 	if (unlikely(err))
@@ -1118,6 +1137,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 	struct netdev_queue *nq;
 	int store_cleaned, work_done;
 	struct list_head rx_list;
+	int retries = 0;
 	int err;
 
 	ch = container_of(napi, struct dpaa2_eth_channel, napi);
@@ -1136,7 +1156,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 		refill_pool(priv, ch, priv->bpid);
 
 		store_cleaned = consume_frames(ch, &fq);
-		if (!store_cleaned)
+		if (store_cleaned <= 0)
 			break;
 		if (fq->type == DPAA2_RX_FQ) {
 			rx_cleaned += store_cleaned;
@@ -1163,7 +1183,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 	do {
 		err = dpaa2_io_service_rearm(ch->dpio, &ch->nctx);
 		cpu_relax();
-	} while (err == -EBUSY);
+	} while (err == -EBUSY && retries++ < DPAA2_ETH_SWP_BUSY_RETRIES);
 	WARN_ONCE(err, "CDAN notifications rearm failed on core %d",
 		  ch->nctx.desired_cpu);
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 8a0e65b3267f..686b651edcb2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -245,6 +245,14 @@ static inline struct dpaa2_faead *dpaa2_get_faead(void *buf_addr, bool swa)
  */
 #define DPAA2_ETH_ENQUEUE_RETRIES	10
 
+/* Number of times to retry DPIO portal operations while waiting
+ * for portal to finish executing current command and become
+ * available. We want to avoid being stuck in a while loop in case
+ * hardware becomes unresponsive, but not give up too easily if
+ * the portal really is busy for valid reasons
+ */
+#define DPAA2_ETH_SWP_BUSY_RETRIES	1000
+
 /* Driver statistics, other than those in struct rtnl_link_stats64.
  * These are usually collected per-CPU and aggregated by ethtool.
  */
-- 
1.9.1

