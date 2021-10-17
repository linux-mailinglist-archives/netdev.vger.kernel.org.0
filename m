Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356D3430C29
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 23:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344623AbhJQVEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 17:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344621AbhJQVEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 17:04:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175BFC061768
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 14:01:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcDI4-0000Ip-7n
        for netdev@vger.kernel.org; Sun, 17 Oct 2021 23:01:56 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4EBB9695F05
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 21:01:49 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 25310695EB5;
        Sun, 17 Oct 2021 21:01:45 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 779818b8;
        Sun, 17 Oct 2021 21:01:43 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Ziyang Xuan <william.xuanziyang@huawei.com>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 06/11] can: isotp: isotp_sendmsg(): fix TX buffer concurrent access in isotp_sendmsg()
Date:   Sun, 17 Oct 2021 23:01:37 +0200
Message-Id: <20211017210142.2108610-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211017210142.2108610-1-mkl@pengutronix.de>
References: <20211017210142.2108610-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

When isotp_sendmsg() concurrent, tx.state of all TX processes can be
ISOTP_IDLE. The conditions so->tx.state != ISOTP_IDLE and
wq_has_sleeper(&so->wait) can not protect TX buffer from being
accessed by multiple TX processes.

We can use cmpxchg() to try to modify tx.state to ISOTP_SENDING firstly.
If the modification of the previous process succeed, the later process
must wait tx.state to ISOTP_IDLE firstly. Thus, we can ensure TX buffer
is accessed by only one process at the same time. And we should also
restore the original tx.state at the subsequent error processes.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/c2517874fbdf4188585cf9ddf67a8fa74d5dbde5.1633764159.git.william.xuanziyang@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 2ac29c2b2ca6..d1f54273c0bb 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -121,7 +121,7 @@ enum {
 struct tpcon {
 	int idx;
 	int len;
-	u8 state;
+	u32 state;
 	u8 bs;
 	u8 sn;
 	u8 ll_dl;
@@ -848,6 +848,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
+	u32 old_state = so->tx.state;
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf;
@@ -860,47 +861,55 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		return -EADDRNOTAVAIL;
 
 	/* we do not support multiple buffers - for now */
-	if (so->tx.state != ISOTP_IDLE || wq_has_sleeper(&so->wait)) {
-		if (msg->msg_flags & MSG_DONTWAIT)
-			return -EAGAIN;
+	if (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE ||
+	    wq_has_sleeper(&so->wait)) {
+		if (msg->msg_flags & MSG_DONTWAIT) {
+			err = -EAGAIN;
+			goto err_out;
+		}
 
 		/* wait for complete transmission of current pdu */
 		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
 		if (err)
-			return err;
+			goto err_out;
 	}
 
-	if (!size || size > MAX_MSG_LENGTH)
-		return -EINVAL;
+	if (!size || size > MAX_MSG_LENGTH) {
+		err = -EINVAL;
+		goto err_out;
+	}
 
 	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
 	off = (so->tx.ll_dl > CAN_MAX_DLEN) ? 1 : 0;
 
 	/* does the given data fit into a single frame for SF_BROADCAST? */
 	if ((so->opt.flags & CAN_ISOTP_SF_BROADCAST) &&
-	    (size > so->tx.ll_dl - SF_PCI_SZ4 - ae - off))
-		return -EINVAL;
+	    (size > so->tx.ll_dl - SF_PCI_SZ4 - ae - off)) {
+		err = -EINVAL;
+		goto err_out;
+	}
 
 	err = memcpy_from_msg(so->tx.buf, msg, size);
 	if (err < 0)
-		return err;
+		goto err_out;
 
 	dev = dev_get_by_index(sock_net(sk), so->ifindex);
-	if (!dev)
-		return -ENXIO;
+	if (!dev) {
+		err = -ENXIO;
+		goto err_out;
+	}
 
 	skb = sock_alloc_send_skb(sk, so->ll.mtu + sizeof(struct can_skb_priv),
 				  msg->msg_flags & MSG_DONTWAIT, &err);
 	if (!skb) {
 		dev_put(dev);
-		return err;
+		goto err_out;
 	}
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
 	can_skb_prv(skb)->skbcnt = 0;
 
-	so->tx.state = ISOTP_SENDING;
 	so->tx.len = size;
 	so->tx.idx = 0;
 
@@ -956,7 +965,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (err) {
 		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
 			       __func__, ERR_PTR(err));
-		return err;
+		goto err_out;
 	}
 
 	if (wait_tx_done) {
@@ -965,6 +974,13 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	}
 
 	return size;
+
+err_out:
+	so->tx.state = old_state;
+	if (so->tx.state == ISOTP_IDLE)
+		wake_up_interruptible(&so->wait);
+
+	return err;
 }
 
 static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
-- 
2.33.0


