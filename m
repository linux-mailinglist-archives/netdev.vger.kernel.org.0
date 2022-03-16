Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572B94DB9B8
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358081AbiCPUuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245572AbiCPUuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:50:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0D15A5B9
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:49:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nUaaM-0003tb-DC
        for netdev@vger.kernel.org; Wed, 16 Mar 2022 21:49:34 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D02444CB8B
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 20:47:11 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7CB0B4CB5F;
        Wed, 16 Mar 2022 20:47:11 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ecba342f;
        Wed, 16 Mar 2022 20:47:11 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 1/5] can: isotp: sanitize CAN ID checks in isotp_bind()
Date:   Wed, 16 Mar 2022 21:47:06 +0100
Message-Id: <20220316204710.716341-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316204710.716341-1-mkl@pengutronix.de>
References: <20220316204710.716341-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

Syzbot created an environment that lead to a state machine status that
can not be reached with a compliant CAN ID address configuration.
The provided address information consisted of CAN ID 0x6000001 and 0xC28001
which both boil down to 11 bit CAN IDs 0x001 in sending and receiving.

Sanitize the SFF/EFF CAN ID values before performing the address checks.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/20220316164258.54155-1-socketcan@hartkopp.net
Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index d4c0b4704987..1662103ce125 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1148,6 +1148,7 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	struct net *net = sock_net(sk);
 	int ifindex;
 	struct net_device *dev;
+	canid_t tx_id, rx_id;
 	int err = 0;
 	int notify_enetdown = 0;
 	int do_rx_reg = 1;
@@ -1155,8 +1156,18 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	if (len < ISOTP_MIN_NAMELEN)
 		return -EINVAL;
 
-	if (addr->can_addr.tp.tx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG))
-		return -EADDRNOTAVAIL;
+	/* sanitize tx/rx CAN identifiers */
+	tx_id = addr->can_addr.tp.tx_id;
+	if (tx_id & CAN_EFF_FLAG)
+		tx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
+	else
+		tx_id &= CAN_SFF_MASK;
+
+	rx_id = addr->can_addr.tp.rx_id;
+	if (rx_id & CAN_EFF_FLAG)
+		rx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
+	else
+		rx_id &= CAN_SFF_MASK;
 
 	if (!addr->can_ifindex)
 		return -ENODEV;
@@ -1168,21 +1179,13 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 		do_rx_reg = 0;
 
 	/* do not validate rx address for functional addressing */
-	if (do_rx_reg) {
-		if (addr->can_addr.tp.rx_id == addr->can_addr.tp.tx_id) {
-			err = -EADDRNOTAVAIL;
-			goto out;
-		}
-
-		if (addr->can_addr.tp.rx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG)) {
-			err = -EADDRNOTAVAIL;
-			goto out;
-		}
+	if (do_rx_reg && rx_id == tx_id) {
+		err = -EADDRNOTAVAIL;
+		goto out;
 	}
 
 	if (so->bound && addr->can_ifindex == so->ifindex &&
-	    addr->can_addr.tp.rx_id == so->rxid &&
-	    addr->can_addr.tp.tx_id == so->txid)
+	    rx_id == so->rxid && tx_id == so->txid)
 		goto out;
 
 	dev = dev_get_by_index(net, addr->can_ifindex);
@@ -1206,16 +1209,14 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	ifindex = dev->ifindex;
 
 	if (do_rx_reg) {
-		can_rx_register(net, dev, addr->can_addr.tp.rx_id,
-				SINGLE_MASK(addr->can_addr.tp.rx_id),
+		can_rx_register(net, dev, rx_id, SINGLE_MASK(rx_id),
 				isotp_rcv, sk, "isotp", sk);
 
 		/* no consecutive frame echo skb in flight */
 		so->cfecho = 0;
 
 		/* register for echo skb's */
-		can_rx_register(net, dev, addr->can_addr.tp.tx_id,
-				SINGLE_MASK(addr->can_addr.tp.tx_id),
+		can_rx_register(net, dev, tx_id, SINGLE_MASK(tx_id),
 				isotp_rcv_echo, sk, "isotpe", sk);
 	}
 
@@ -1239,8 +1240,8 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 
 	/* switch to new settings */
 	so->ifindex = ifindex;
-	so->rxid = addr->can_addr.tp.rx_id;
-	so->txid = addr->can_addr.tp.tx_id;
+	so->rxid = rx_id;
+	so->txid = tx_id;
 	so->bound = 1;
 
 out:

base-commit: 231fdac3e58f4e52e387930c73bf535439607563
-- 
2.35.1


