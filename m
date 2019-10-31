Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D6CEB2E5
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbfJaOiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:38:10 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54796 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbfJaOiJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 10:38:09 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A68A41A0209;
        Thu, 31 Oct 2019 15:38:07 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 995FF1A054D;
        Thu, 31 Oct 2019 15:38:07 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 53EB4205E9;
        Thu, 31 Oct 2019 15:38:07 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, jakub.kicinski@netronome.com, joe@perches.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [net-next v2 04/13] dpaa_eth: avoid timestamp read on error paths
Date:   Thu, 31 Oct 2019 16:37:50 +0200
Message-Id: <1572532679-472-5-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1572532679-472-1-git-send-email-madalin.bucur@nxp.com>
References: <1572532679-472-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpaa_cleanup_tx_fd() function is called by the frame transmit
confirmation callback but also on several error paths. This function
is reading the transmit timestamp value. Avoid reading an invalid
timestamp value on the error paths.

Fixes: 4664856e9ca2 ("dpaa_eth: add support for hardware timestamping")
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index efb4753f0723..75ade6a5599a 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1571,13 +1571,15 @@ static int dpaa_eth_refill_bpools(struct dpaa_priv *priv)
  * Skb freeing is not handled here.
  *
  * This function may be called on error paths in the Tx function, so guard
- * against cases when not all fd relevant fields were filled in.
+ * against cases when not all fd relevant fields were filled in. To avoid
+ * reading the invalid transmission timestamp for the error paths set ts to
+ * false.
  *
  * Return the skb backpointer, since for S/G frames the buffer containing it
  * gets freed here.
  */
 static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
-					  const struct qm_fd *fd)
+					  const struct qm_fd *fd, bool ts)
 {
 	const enum dma_data_direction dma_dir = DMA_TO_DEVICE;
 	struct device *dev = priv->net_dev->dev.parent;
@@ -1619,7 +1621,8 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	}
 
 	/* DMA unmapping is required before accessing the HW provided info */
-	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+	if (ts && priv->tx_tstamp &&
+	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 
 		if (!fman_port_get_tstamp(priv->mac_dev->port[TX], (void *)skbh,
@@ -2085,7 +2088,7 @@ dpaa_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 	if (likely(dpaa_xmit(priv, percpu_stats, queue_mapping, &fd) == 0))
 		return NETDEV_TX_OK;
 
-	dpaa_cleanup_tx_fd(priv, &fd);
+	dpaa_cleanup_tx_fd(priv, &fd, false);
 skb_to_fd_failed:
 enomem:
 	percpu_stats->tx_errors++;
@@ -2131,7 +2134,7 @@ static void dpaa_tx_error(struct net_device *net_dev,
 
 	percpu_priv->stats.tx_errors++;
 
-	skb = dpaa_cleanup_tx_fd(priv, fd);
+	skb = dpaa_cleanup_tx_fd(priv, fd, false);
 	dev_kfree_skb(skb);
 }
 
@@ -2171,7 +2174,7 @@ static void dpaa_tx_conf(struct net_device *net_dev,
 
 	percpu_priv->tx_confirm++;
 
-	skb = dpaa_cleanup_tx_fd(priv, fd);
+	skb = dpaa_cleanup_tx_fd(priv, fd, true);
 
 	consume_skb(skb);
 }
@@ -2398,7 +2401,7 @@ static void egress_ern(struct qman_portal *portal,
 	percpu_priv->stats.tx_fifo_errors++;
 	count_ern(percpu_priv, msg);
 
-	skb = dpaa_cleanup_tx_fd(priv, fd);
+	skb = dpaa_cleanup_tx_fd(priv, fd, false);
 	dev_kfree_skb_any(skb);
 }
 
-- 
2.1.0

