Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6ABE6DCF5C
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 03:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjDKBdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 21:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjDKBdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 21:33:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84704173B
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 18:33:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1431161A81
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 01:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38123C4339C;
        Tue, 11 Apr 2023 01:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681176809;
        bh=QzSYsmFH4kvxdlK3TtFTeeK1wHrVchsWmGVTm8uNIZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJvO1KuGYVRp6ov62aoVOjsrFuGRUbujITmFZhME+YBYmZG+RCtnG0fTbYqvJdYgu
         oyisQWMuJySA2bmgapx5M+crKOO4WDDmLOjF5M53FOVhh1wwfJ6tXwSR/JgKbREliP
         9s5J1/82CEA/cBTXGzPuE7VWomJCVJKKqSW/sKXTZZbcMihSvFzvBjCRLEvBY6LxTt
         4Tbi5Prq70jfY3SfB3yS8xOPLb0fuY/bTQqfqEsLk25USFjGgJNPY2i5aOmcxLfeQ0
         OlijnqRF3cxh8ddsg/c+x6CWX+qVCNwqAAmJ8ms+mFCzJtXKfBgpPujna0k8cZQko6
         Ghzz45arhlZgA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/3] net: docs: update the sample code in driver.rst
Date:   Mon, 10 Apr 2023 18:33:21 -0700
Message-Id: <20230411013323.513688-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411013323.513688-1-kuba@kernel.org>
References: <20230411013323.513688-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sample code talks about single-queue devices and uses locks.
Update it to something resembling more modern code.
Make sure we mention use of READ_ONCE() / WRITE_ONCE().

Change the comment which talked about consumer on the xmit side.
AFAIU xmit is the producer and completions are a consumer.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/driver.rst | 61 +++++++++++++----------------
 1 file changed, 27 insertions(+), 34 deletions(-)

diff --git a/Documentation/networking/driver.rst b/Documentation/networking/driver.rst
index 4071f2c00f8b..4f5dfa9c022e 100644
--- a/Documentation/networking/driver.rst
+++ b/Documentation/networking/driver.rst
@@ -47,30 +47,43 @@ Instead it must maintain the queue properly.  For example,
 
 .. code-block:: c
 
+	static u32 drv_tx_avail(struct drv_ring *dr)
+	{
+		u32 used = READ_ONCE(dr->prod) - READ_ONCE(dr->cons);
+
+		return dr->tx_ring_size - (used & bp->tx_ring_mask);
+	}
+
 	static netdev_tx_t drv_hard_start_xmit(struct sk_buff *skb,
 					       struct net_device *dev)
 	{
 		struct drv *dp = netdev_priv(dev);
+		struct netdev_queue *txq;
+		struct drv_ring *dr;
+		int idx;
+
+		idx = skb_get_queue_mapping(skb);
+		dr = dp->tx_rings[idx];
+		txq = netdev_get_tx_queue(dev, idx);
 
-		lock_tx(dp);
 		//...
-		/* This is a hard error log it. */
-		if (TX_BUFFS_AVAIL(dp) <= (skb_shinfo(skb)->nr_frags + 1)) {
+		/* This should be a very rare race - log it. */
+		if (drv_tx_avail(dr) <= skb_shinfo(skb)->nr_frags + 1) {
 			netif_stop_queue(dev);
-			unlock_tx(dp);
-			printk(KERN_ERR PFX "%s: BUG! Tx Ring full when queue awake!\n",
-			       dev->name);
+			netdev_warn(dev, "Tx Ring full when queue awake!\n");
 			return NETDEV_TX_BUSY;
 		}
 
 		//... queue packet to card ...
-		//... update tx consumer index ...
 
-		if (TX_BUFFS_AVAIL(dp) <= (MAX_SKB_FRAGS + 1))
-			netif_stop_queue(dev);
+		netdev_tx_sent_queue(txq, skb->len);
+
+		//... update tx producer index using WRITE_ONCE() ...
+
+		if (!netif_txq_maybe_stop(txq, drv_tx_avail(dr),
+					  MAX_SKB_FRAGS + 1, 2 * MAX_SKB_FRAGS))
+			dr->stats.stopped++;
 
-		//...
-		unlock_tx(dp);
 		//...
 		return NETDEV_TX_OK;
 	}
@@ -79,30 +92,10 @@ Instead it must maintain the queue properly.  For example,
 
 .. code-block:: c
 
-	if (netif_queue_stopped(dp->dev) &&
-	    TX_BUFFS_AVAIL(dp) > (MAX_SKB_FRAGS + 1))
-		netif_wake_queue(dp->dev);
-
-For a non-scatter-gather supporting card, the three tests simply become:
-
-.. code-block:: c
-
-		/* This is a hard error log it. */
-		if (TX_BUFFS_AVAIL(dp) <= 0)
-
-and:
-
-.. code-block:: c
-
-		if (TX_BUFFS_AVAIL(dp) == 0)
-
-and:
-
-.. code-block:: c
+	//... update tx consumer index using WRITE_ONCE() ...
 
-	if (netif_queue_stopped(dp->dev) &&
-	    TX_BUFFS_AVAIL(dp) > 0)
-		netif_wake_queue(dp->dev);
+	netif_txq_completed_wake(txq, cmpl_pkts, cmpl_bytes,
+				 drv_tx_avail(dr), 2 * MAX_SKB_FRAGS);
 
 Lockless queue stop / wake helper macros
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 
2.39.2

