Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1036DE920
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 03:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjDLBuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 21:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjDLBur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 21:50:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97504C24;
        Tue, 11 Apr 2023 18:50:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F3BD62D28;
        Wed, 12 Apr 2023 01:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7CBC433D2;
        Wed, 12 Apr 2023 01:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681264245;
        bh=SQVkvpkkVpFYKUjaj0YFjy6WYRkxtetS3WPY8FhJEPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPK+P/FYXKkiqMG/hIEkXfS6Zspq+WXs66mXcekL5ZQ5FjFXjLM1BRGDE3yExAdhG
         cJG2ckMFBtlg0B/yLt8AzYX7eVUHf9GK3rnYvjqr4EiAykkCp79imMw4TURqIQIaFl
         wEOAeH7ixMB4ZMl1i4XMDicdoRe0vboSCuWqpX6i4gxMtQluQTo7vpVw7PYMgIvVOG
         W8m44oxbWsViVW2nqch7MEiGvbuIM2mhvpAQea4f8aIUG7TAy2CbPbXvDbinl/IWLb
         GCuRGuG+CHsiICHvQg2dixNPWm/AAEaMT1qGRx2VfDE2msuUYADzfW6OKA20xBZgfP
         r9uReVN/Wz4DA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next v2 1/3] net: docs: update the sample code in driver.rst
Date:   Tue, 11 Apr 2023 18:50:36 -0700
Message-Id: <20230412015038.674023-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412015038.674023-1-kuba@kernel.org>
References: <20230412015038.674023-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: corbet@lwn.net
CC: linux-doc@vger.kernel.org
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

