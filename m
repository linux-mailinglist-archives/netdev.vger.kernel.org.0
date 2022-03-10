Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156C74D4B4C
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiCJOce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343952AbiCJObb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:31:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1554BB91EA
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:29:11 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSJmv-0005pe-D9
        for netdev@vger.kernel.org; Thu, 10 Mar 2022 15:29:09 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4A93347D7E
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:29:07 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B972447D72;
        Thu, 10 Mar 2022 14:29:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 26e89d59;
        Thu, 10 Mar 2022 14:29:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 04/29] vxcan: remove sk reference in peer skb
Date:   Thu, 10 Mar 2022 15:28:38 +0100
Message-Id: <20220310142903.341658-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310142903.341658-1-mkl@pengutronix.de>
References: <20220310142903.341658-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

With can_create_echo_skb() the skb which is forwarded to the peer CAN
interface shares the sk pointer from the originating socket.
This makes the CAN frame show up in the peer namespace as a TX packet.

With the use of skb_clone() analogue to the handling in gw.c the peer
skb gets a new start in the peer namespace and correctly appears as
a RX packet.

Link: https://lore.kernel.org/all/20220309120416.83514-4-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/vxcan.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
index 556f1a12ec9a..51501af8d9fc 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -33,28 +33,33 @@ struct vxcan_priv {
 	struct net_device __rcu	*peer;
 };
 
-static netdev_tx_t vxcan_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t vxcan_xmit(struct sk_buff *oskb, struct net_device *dev)
 {
 	struct vxcan_priv *priv = netdev_priv(dev);
 	struct net_device *peer;
-	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
+	struct canfd_frame *cfd = (struct canfd_frame *)oskb->data;
 	struct net_device_stats *peerstats, *srcstats = &dev->stats;
+	struct sk_buff *skb;
 	u8 len;
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dropped_invalid_skb(dev, oskb))
 		return NETDEV_TX_OK;
 
 	rcu_read_lock();
 	peer = rcu_dereference(priv->peer);
 	if (unlikely(!peer)) {
-		kfree_skb(skb);
+		kfree_skb(oskb);
 		dev->stats.tx_dropped++;
 		goto out_unlock;
 	}
 
-	skb = can_create_echo_skb(skb);
-	if (!skb)
+	skb = skb_clone(oskb, GFP_ATOMIC);
+	if (skb) {
+		consume_skb(oskb);
+	} else {
+		kfree(oskb);
 		goto out_unlock;
+	}
 
 	/* reset CAN GW hop counter */
 	skb->csum_start = 0;
-- 
2.35.1


