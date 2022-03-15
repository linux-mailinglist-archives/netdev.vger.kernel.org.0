Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724394DA415
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 21:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242789AbiCOUjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 16:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238876AbiCOUjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 16:39:40 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E693434A0
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 13:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1647376704;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=KMDY+gLoV9k745Yqvlwn4CapRWlH0lMiANSIpNvkV7k=;
    b=ToAsZtF1zmx0A/SpVGAo37EV4fLF/7AdnoZueaGwCPK5PbSt10EjLz2vhnl0Su38Nz
    sd0tdzy9xONWqIrEQg8l3dtGYsfflMYJ6gN86reDdK7kLUrWls3rs0l6WR7Q3KsLl7O0
    rQ3oXnmDoEm/E1d6mcESNZcXYwMJnQLjp13WIFWwGWN1bWCufpO2bwfFxpA6FhEKf5Y2
    3yipBCOkMZOP+IxKFv18/ChNhHkQHCCKE6Tui0hhhF72ur3ZHeSBxem1JQ9mBpzRhB3f
    IVF5q2krDKZwaB0Uo8/U6VjtMoUI0DQPM5+slSoYWs4HzWZUoXfgT10ldINHbP+yqa5o
    KbOQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9IyLecSWJafUvprl4"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.41.0 AUTH)
    with ESMTPSA id a046a1y2FKcO13G
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 15 Mar 2022 21:38:24 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     netdev@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
Subject: [net-next] can: isotp: sanitize CAN ID checks in isotp_bind()
Date:   Tue, 15 Mar 2022 21:37:48 +0100
Message-Id: <20220315203748.1892-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot created an environment that lead to a state machine status that
can not be reached with a compliant CAN ID address configuration.
The provided address information consisted of CAN ID 0x6000001 and 0xC28001
which both boil down to 11 bit CAN IDs 0x001 in sending and receiving.

Sanitize the SFF/EFF CAN ID values before performing the address checks.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/isotp.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index d4c0b4704987..1662103ce125 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1146,19 +1146,30 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
 	struct net *net = sock_net(sk);
 	int ifindex;
 	struct net_device *dev;
+	canid_t tx_id, rx_id;
 	int err = 0;
 	int notify_enetdown = 0;
 	int do_rx_reg = 1;
 
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
 
 	lock_sock(sk);
@@ -1166,25 +1177,17 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	/* do not register frame reception for functional addressing */
 	if (so->opt.flags & CAN_ISOTP_SF_BROADCAST)
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
 	if (!dev) {
 		err = -ENODEV;
@@ -1204,20 +1207,18 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 		notify_enetdown = 1;
 
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
 
 	dev_put(dev);
 
@@ -1237,12 +1238,12 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 		}
 	}
 
 	/* switch to new settings */
 	so->ifindex = ifindex;
-	so->rxid = addr->can_addr.tp.rx_id;
-	so->txid = addr->can_addr.tp.tx_id;
+	so->rxid = rx_id;
+	so->txid = tx_id;
 	so->bound = 1;
 
 out:
 	release_sock(sk);
 
-- 
2.30.2

