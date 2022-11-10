Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D85623B49
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 06:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiKJFcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 00:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiKJFcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 00:32:05 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29FA2D746
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 21:32:02 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id F2F4220288; Thu, 10 Nov 2022 13:31:56 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1668058317;
        bh=jXTueZm1nWyp+5e3MyhTkgRg2ph+vuaebUODfZ9wyCI=;
        h=From:To:Cc:Subject:Date;
        b=Hn+v3LM/FWxTT47HLKlfLTihYOumj+gn8b7kI2OESM0ehgUxwLEBj+otEvpcnRzic
         XQTjFO9oq7IxV/JwwvGNH0UqMEu9zjJ4r6bptZ0IrZBP3oZVlFr/a/DyDDOEa8Cj1q
         fI4Qoji8Tx6dyVCPya1CAK3L0DlXbWF68+YjxMhhSo6nfsFgBj2o3Vxo1Y7OeKzh20
         myLYnbXJpAMU8qEW1V9asN8WvM3eEdLTn1ADs46lCs2UzQYzCIDLUZe3vvL2WKTKZ9
         spjIJzTVMhI52/ecVFH8OYkIiEwMA9wAlNeqbze6emXB+qTfgxdVdoo6mJjJN8Ut0U
         aC089TPNePm1A==
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Jian Zhang <zhangjian.3032@bytedance.com>
Subject: [PATCH net] mctp i2c: don't count unused / invalid keys for flow release
Date:   Thu, 10 Nov 2022 13:31:35 +0800
Message-Id: <20221110053135.329071-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're currently hitting the WARN_ON in mctp_i2c_flow_release:

    if (midev->release_count > midev->i2c_lock_count) {
        WARN_ONCE(1, "release count overflow");

This may be hit if we expire a flow before sending the first packet it
contains - as we will not be pairing the increment of release_count
(performed on flow release) with the i2c lock operation (only
performed on actual TX).

To fix this, only release a flow if we've encountered it previously (ie,
dev_flow_state does not indicate NEW), as we will mark the flow as
ACTIVE at the same time as accounting for the i2c lock operation. We
also need to add an INVALID flow state, to indicate when we've done the
release.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Reported-by: Jian Zhang <zhangjian.3032@bytedance.com>
Tested-by: Jian Zhang <zhangjian.3032@bytedance.com>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 drivers/net/mctp/mctp-i2c.c | 47 +++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 53846c6b56ca..aca3697b0962 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -43,6 +43,7 @@
 enum {
 	MCTP_I2C_FLOW_STATE_NEW = 0,
 	MCTP_I2C_FLOW_STATE_ACTIVE,
+	MCTP_I2C_FLOW_STATE_INVALID,
 };
 
 /* List of all struct mctp_i2c_client
@@ -374,12 +375,18 @@ mctp_i2c_get_tx_flow_state(struct mctp_i2c_dev *midev, struct sk_buff *skb)
 	 */
 	if (!key->valid) {
 		state = MCTP_I2C_TX_FLOW_INVALID;
-
-	} else if (key->dev_flow_state == MCTP_I2C_FLOW_STATE_NEW) {
-		key->dev_flow_state = MCTP_I2C_FLOW_STATE_ACTIVE;
-		state = MCTP_I2C_TX_FLOW_NEW;
 	} else {
-		state = MCTP_I2C_TX_FLOW_EXISTING;
+		switch (key->dev_flow_state) {
+		case MCTP_I2C_FLOW_STATE_NEW:
+			key->dev_flow_state = MCTP_I2C_FLOW_STATE_ACTIVE;
+			state = MCTP_I2C_TX_FLOW_NEW;
+			break;
+		case MCTP_I2C_FLOW_STATE_ACTIVE:
+			state = MCTP_I2C_TX_FLOW_EXISTING;
+			break;
+		default:
+			state = MCTP_I2C_TX_FLOW_INVALID;
+		}
 	}
 
 	spin_unlock_irqrestore(&key->lock, flags);
@@ -617,21 +624,31 @@ static void mctp_i2c_release_flow(struct mctp_dev *mdev,
 
 {
 	struct mctp_i2c_dev *midev = netdev_priv(mdev->dev);
+	bool queue_release = false;
 	unsigned long flags;
 
 	spin_lock_irqsave(&midev->lock, flags);
-	midev->release_count++;
-	spin_unlock_irqrestore(&midev->lock, flags);
-
-	/* Ensure we have a release operation queued, through the fake
-	 * marker skb
+	/* if we have seen the flow/key previously, we need to pair the
+	 * original lock with a release
 	 */
-	spin_lock(&midev->tx_queue.lock);
-	if (!midev->unlock_marker.next)
-		__skb_queue_tail(&midev->tx_queue, &midev->unlock_marker);
-	spin_unlock(&midev->tx_queue.lock);
+	if (key->dev_flow_state == MCTP_I2C_FLOW_STATE_ACTIVE) {
+		midev->release_count++;
+		queue_release = true;
+	}
+	key->dev_flow_state = MCTP_I2C_FLOW_STATE_INVALID;
+	spin_unlock_irqrestore(&midev->lock, flags);
 
-	wake_up(&midev->tx_wq);
+	if (queue_release) {
+		/* Ensure we have a release operation queued, through the fake
+		 * marker skb
+		 */
+		spin_lock(&midev->tx_queue.lock);
+		if (!midev->unlock_marker.next)
+			__skb_queue_tail(&midev->tx_queue,
+					 &midev->unlock_marker);
+		spin_unlock(&midev->tx_queue.lock);
+		wake_up(&midev->tx_wq);
+	}
 }
 
 static const struct net_device_ops mctp_i2c_ops = {
-- 
2.37.2

