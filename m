Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1692713E5D5
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390848AbgAPRNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:13:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390219AbgAPRNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9305120684;
        Thu, 16 Jan 2020 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194828;
        bh=Uc8ca9AD02USo6YyogNUXPtsgC0fZNG6CSuWH9YoxfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAXISYVR0sKaHalVFFcQxTWlzExHp+319S6UKebem6lWIvtzdSnYP1Ft3jF6Pyo76
         c+7qOiGAW8zHv7TU0R7fPPQ+PEo2oNqg93cUnzD3dSlfJeisusfdq3rEgP6TYtGCWS
         4snnW2UIjWm4rSvcapqAQ1AevROb5bn1KjaxwEZg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 631/671] dpaa_eth: avoid timestamp read on error paths
Date:   Thu, 16 Jan 2020 12:04:29 -0500
Message-Id: <20200116170509.12787-368-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

[ Upstream commit 9a4f4f3a894ff4487f5597b7aabba9432b238292 ]

The dpaa_cleanup_tx_fd() function is called by the frame transmit
confirmation callback but also on several error paths. This function
is reading the transmit timestamp value. Avoid reading an invalid
timestamp value on the error paths.

Fixes: 4664856e9ca2 ("dpaa_eth: add support for hardware timestamping")
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 3cd62a71ddea..d7736c9c6339 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1600,13 +1600,15 @@ static int dpaa_eth_refill_bpools(struct dpaa_priv *priv)
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
@@ -1648,7 +1650,8 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	}
 
 	/* DMA unmapping is required before accessing the HW provided info */
-	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+	if (ts && priv->tx_tstamp &&
+	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 
 		if (!fman_port_get_tstamp(priv->mac_dev->port[TX], (void *)skbh,
@@ -2118,7 +2121,7 @@ dpaa_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 	if (likely(dpaa_xmit(priv, percpu_stats, queue_mapping, &fd) == 0))
 		return NETDEV_TX_OK;
 
-	dpaa_cleanup_tx_fd(priv, &fd);
+	dpaa_cleanup_tx_fd(priv, &fd, false);
 skb_to_fd_failed:
 enomem:
 	percpu_stats->tx_errors++;
@@ -2164,7 +2167,7 @@ static void dpaa_tx_error(struct net_device *net_dev,
 
 	percpu_priv->stats.tx_errors++;
 
-	skb = dpaa_cleanup_tx_fd(priv, fd);
+	skb = dpaa_cleanup_tx_fd(priv, fd, false);
 	dev_kfree_skb(skb);
 }
 
@@ -2205,7 +2208,7 @@ static void dpaa_tx_conf(struct net_device *net_dev,
 
 	percpu_priv->tx_confirm++;
 
-	skb = dpaa_cleanup_tx_fd(priv, fd);
+	skb = dpaa_cleanup_tx_fd(priv, fd, true);
 
 	consume_skb(skb);
 }
@@ -2435,7 +2438,7 @@ static void egress_ern(struct qman_portal *portal,
 	percpu_priv->stats.tx_fifo_errors++;
 	count_ern(percpu_priv, msg);
 
-	skb = dpaa_cleanup_tx_fd(priv, fd);
+	skb = dpaa_cleanup_tx_fd(priv, fd, false);
 	dev_kfree_skb_any(skb);
 }
 
-- 
2.20.1

