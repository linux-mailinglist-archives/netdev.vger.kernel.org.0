Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460934277F2
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 09:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbhJIHnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 03:43:37 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13713 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbhJIHnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 03:43:37 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HRH5f42whzWZKb;
        Sat,  9 Oct 2021 15:40:06 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Sat, 9 Oct 2021 15:41:38 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <socketcan@hartkopp.net>, <mkl@pengutronix.de>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2 2/2] can: isotp: fix tx buffer concurrent access in isotp_sendmsg()
Date:   Sat, 9 Oct 2021 15:40:30 +0800
Message-ID: <c2517874fbdf4188585cf9ddf67a8fa74d5dbde5.1633764159.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633764159.git.william.xuanziyang@huawei.com>
References: <cover.1633764159.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When isotp_sendmsg() concurrent, tx.state of all tx processes can be
ISOTP_IDLE. The conditions so->tx.state != ISOTP_IDLE and
wq_has_sleeper(&so->wait) can not protect tx buffer from being accessed
by multiple tx processes.

We can use cmpxchg() to try to modify tx.state to ISOTP_SENDING firstly.
If the modification of the previous process succeed, the later process
must wait tx.state to ISOTP_IDLE firstly. Thus, we can ensure tx buffer
is accessed by only one process at the same time. And we should also
restore the original tx.state at the subsequent error processes.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
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
2.25.1

