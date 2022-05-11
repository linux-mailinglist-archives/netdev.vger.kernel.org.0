Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D320A5232F0
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235654AbiEKMTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242272AbiEKMT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:19:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32F571A38
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:19:23 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nolJH-0000qE-Ql; Wed, 11 May 2022 14:19:19 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nolJI-001gNu-8e; Wed, 11 May 2022 14:19:18 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nolJG-00BJXp-Bi; Wed, 11 May 2022 14:19:18 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH 1/1] can: skb: add and set local_origin flag
Date:   Wed, 11 May 2022 14:19:13 +0200
Message-Id: <20220511121913.2696181-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new can_skb_priv::local_origin flag to be able detect egress
packages even if they was sent directly from kernel and not assigned to
some socket.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
---
 drivers/net/can/dev/skb.c | 3 +++
 include/linux/can/skb.h   | 1 +
 net/can/raw.c             | 2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 61660248c69e..3e2357fb387e 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -63,6 +63,7 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 
 		/* save frame_len to reuse it when transmission is completed */
 		can_skb_prv(skb)->frame_len = frame_len;
+		can_skb_prv(skb)->local_origin = true;
 
 		skb_tx_timestamp(skb);
 
@@ -200,6 +201,7 @@ struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf)
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
 	can_skb_prv(skb)->skbcnt = 0;
+	can_skb_prv(skb)->local_origin = false;
 
 	*cf = skb_put_zero(skb, sizeof(struct can_frame));
 
@@ -231,6 +233,7 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
 	can_skb_prv(skb)->skbcnt = 0;
+	can_skb_prv(skb)->local_origin = false;
 
 	*cfd = skb_put_zero(skb, sizeof(struct canfd_frame));
 
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index fdb22b00674a..1b8a8cf2b13b 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -52,6 +52,7 @@ struct can_skb_priv {
 	int ifindex;
 	int skbcnt;
 	unsigned int frame_len;
+	bool local_origin;
 	struct can_frame cf[];
 };
 
diff --git a/net/can/raw.c b/net/can/raw.c
index b7dbb57557f3..df2d9334b395 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -173,7 +173,7 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 	/* add CAN specific message flags for raw_recvmsg() */
 	pflags = raw_flags(skb);
 	*pflags = 0;
-	if (oskb->sk)
+	if (can_skb_prv(skb)->local_origin)
 		*pflags |= MSG_DONTROUTE;
 	if (oskb->sk == sk)
 		*pflags |= MSG_CONFIRM;
-- 
2.30.2

