Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2762F2642B8
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 11:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbgIJJrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 05:47:19 -0400
Received: from inva021.nxp.com ([92.121.34.21]:49712 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730335AbgIJJq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 05:46:56 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2A9372005C7;
        Thu, 10 Sep 2020 11:46:54 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E569520076B;
        Thu, 10 Sep 2020 11:46:50 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id C571C402DF;
        Thu, 10 Sep 2020 11:46:46 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 3/5] dpaa2-eth: invoke dpaa2_eth_enable_tx_tstamp() once in code
Date:   Thu, 10 Sep 2020 17:38:33 +0800
Message-Id: <20200910093835.24317-4-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910093835.24317-1-yangbo.lu@nxp.com>
References: <20200910093835.24317-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Invoke dpaa2_eth_enable_tx_tstamp() once in code after building FD,
rather than calling it in dpaa2_eth_build_single_fd(),
dpaa2_eth_build_sg_fd_single_buf(), and dpaa2_eth_build_sg_fd().

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 31 ++++++++++++------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index daf8fd4..a8c311fb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -589,7 +589,8 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_fd *fd, void *buf_start)
 /* Create a frame descriptor based on a fragmented skb */
 static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
 				 struct sk_buff *skb,
-				 struct dpaa2_fd *fd)
+				 struct dpaa2_fd *fd,
+				 void **swa_addr)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	void *sgt_buf = NULL;
@@ -658,6 +659,7 @@ static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
 	 * skb backpointer in the software annotation area. We'll need
 	 * all of them on Tx Conf.
 	 */
+	*swa_addr = (void *)sgt_buf;
 	swa = (struct dpaa2_eth_swa *)sgt_buf;
 	swa->type = DPAA2_ETH_SWA_SG;
 	swa->sg.skb = skb;
@@ -677,9 +679,6 @@ static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
 	dpaa2_fd_set_len(fd, skb->len);
 	dpaa2_fd_set_ctrl(fd, FD_CTRL_PTA);
 
-	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
-		dpaa2_eth_enable_tx_tstamp(fd, sgt_buf);
-
 	return 0;
 
 dma_map_single_failed:
@@ -699,7 +698,8 @@ static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
  */
 static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 					    struct sk_buff *skb,
-					    struct dpaa2_fd *fd)
+					    struct dpaa2_fd *fd,
+					    void **swa_addr)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpaa2_eth_sgt_cache *sgt_cache;
@@ -737,6 +737,7 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 	dpaa2_sg_set_final(sgt, true);
 
 	/* Store the skb backpointer in the SGT buffer */
+	*swa_addr = (void *)sgt_buf;
 	swa = (struct dpaa2_eth_swa *)sgt_buf;
 	swa->type = DPAA2_ETH_SWA_SINGLE;
 	swa->single.skb = skb;
@@ -755,9 +756,6 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 	dpaa2_fd_set_len(fd, skb->len);
 	dpaa2_fd_set_ctrl(fd, FD_CTRL_PTA);
 
-	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
-		dpaa2_eth_enable_tx_tstamp(fd, sgt_buf);
-
 	return 0;
 
 sgt_map_failed:
@@ -774,7 +772,8 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 /* Create a frame descriptor based on a linear skb */
 static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
 				     struct sk_buff *skb,
-				     struct dpaa2_fd *fd)
+				     struct dpaa2_fd *fd,
+				     void **swa_addr)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	u8 *buffer_start, *aligned_start;
@@ -795,6 +794,7 @@ static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
 	 * (in the private data area) such that we can release it
 	 * on Tx confirm
 	 */
+	*swa_addr = (void *)buffer_start;
 	swa = (struct dpaa2_eth_swa *)buffer_start;
 	swa->type = DPAA2_ETH_SWA_SINGLE;
 	swa->single.skb = skb;
@@ -811,9 +811,6 @@ static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
 	dpaa2_fd_set_format(fd, dpaa2_fd_single);
 	dpaa2_fd_set_ctrl(fd, FD_CTRL_PTA);
 
-	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
-		dpaa2_eth_enable_tx_tstamp(fd, buffer_start);
-
 	return 0;
 }
 
@@ -939,6 +936,7 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	u32 fd_len;
 	u8 prio = 0;
 	int err, i;
+	void *swa;
 
 	percpu_stats = this_cpu_ptr(priv->percpu_stats);
 	percpu_extras = this_cpu_ptr(priv->percpu_extras);
@@ -959,17 +957,17 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	memset(&fd, 0, sizeof(fd));
 
 	if (skb_is_nonlinear(skb)) {
-		err = dpaa2_eth_build_sg_fd(priv, skb, &fd);
+		err = dpaa2_eth_build_sg_fd(priv, skb, &fd, &swa);
 		percpu_extras->tx_sg_frames++;
 		percpu_extras->tx_sg_bytes += skb->len;
 	} else if (skb_headroom(skb) < needed_headroom) {
-		err = dpaa2_eth_build_sg_fd_single_buf(priv, skb, &fd);
+		err = dpaa2_eth_build_sg_fd_single_buf(priv, skb, &fd, &swa);
 		percpu_extras->tx_sg_frames++;
 		percpu_extras->tx_sg_bytes += skb->len;
 		percpu_extras->tx_converted_sg_frames++;
 		percpu_extras->tx_converted_sg_bytes += skb->len;
 	} else {
-		err = dpaa2_eth_build_single_fd(priv, skb, &fd);
+		err = dpaa2_eth_build_single_fd(priv, skb, &fd, &swa);
 	}
 
 	if (unlikely(err)) {
@@ -977,6 +975,9 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 		goto err_build_fd;
 	}
 
+	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
+		dpaa2_eth_enable_tx_tstamp(&fd, swa);
+
 	/* Tracing point */
 	trace_dpaa2_tx_fd(net_dev, &fd);
 
-- 
2.7.4

