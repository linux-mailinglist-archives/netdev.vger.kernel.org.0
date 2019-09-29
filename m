Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73ECCC1469
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 14:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfI2MJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 08:09:51 -0400
Received: from srv2.anyservers.com ([77.79.239.202]:45344 "EHLO
        srv2.anyservers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfI2MJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 08:09:51 -0400
X-Greylist: delayed 3896 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Sep 2019 08:09:49 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=asmblr.net;
         s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UGFdkqUa8YCB1zspwQFuNMI+5cdkItOR1DiDLqvD2NU=; b=AI7LaS1ihLZE1/gVhYkROz0C0d
        JOhsz+Lkc+1nHK5nJvWXnvnURhyB5niXotN/fT4WDZKp0aoDGcEFDf8QV0oM4r31DIoDgWaAeOl/b
        qwE1krJeVxdSbDAQy7U0YR1fe1INa4g4rmtzoMdmzgC35YLw0JF+VBPBmD/LqwQCN4N/VEAb7irIg
        aCPig7bDxrsid3TQrRJEKCPOTMhyz5+BwmKF2LDl5igBayB+7mctrt2JbYTj3CtO9F2sIvaXkOs+n
        NwbsrCayWwOZ6g6159Dpw40ku46XjEj/kmwkuejN0U61HiXixG1IB4ILj0eIS5Lby44BvEoHv2gCn
        xpkofsyQ==;
Received: from [5.174.236.109] (port=55200 helo=milkyway.galaxy)
        by srv2.anyservers.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <amade@asmblr.net>)
        id 1iEX0U-003gdJ-Jt; Sun, 29 Sep 2019 13:04:50 +0200
From:   =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
Subject: [RFC PATCH 1/2] net: tap: Fix incorrect memory access
Date:   Sun, 29 Sep 2019 13:05:01 +0200
Message-Id: <20190929110502.2284-2-amade@asmblr.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929110502.2284-1-amade@asmblr.net>
References: <20190929110502.2284-1-amade@asmblr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv2.anyservers.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - asmblr.net
X-Get-Message-Sender-Via: srv2.anyservers.com: authenticated_id: amade@asmblr.net
X-Authenticated-Sender: srv2.anyservers.com: amade@asmblr.net
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KASAN reported incorrect memory access when sock_init_data() was called.
This happens due to the fact that if sock_init_data() is called with
sock argument being not NULL, it goes into path using SOCK_INODE macro.
SOCK_INODE itself is just a wrapper around
container_of(socket, struct socket_alloc, socket).

As can be seen from that flow sock_init_data, should be called with
sock, being part of struct socket_alloc, instead of being part of
struct tap_queue.

Refactor code to follow flow similar in other places where sock is
allocated correctly.

Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
---
 drivers/net/tap.c      | 34 +++++++++++++++++++++-------------
 include/linux/if_tap.h |  2 +-
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index dd614c2cd994..d1f59bad599f 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -501,6 +501,7 @@ static void tap_sock_destruct(struct sock *sk)
 static int tap_open(struct inode *inode, struct file *file)
 {
 	struct net *net = current->nsproxy->net_ns;
+	struct socket *sock;
 	struct tap_dev *tap;
 	struct tap_queue *q;
 	int err = -ENODEV;
@@ -515,17 +516,25 @@ static int tap_open(struct inode *inode, struct file *file)
 					     &tap_proto, 0);
 	if (!q)
 		goto err;
+
+	sock = sock_alloc();
+	if (!sock) {
+		sk_free(&q->sk);
+		goto err;
+	}
+	q->sock = sock;
+
 	if (ptr_ring_init(&q->ring, tap->dev->tx_queue_len, GFP_KERNEL)) {
+		sock_release(q->sock);
 		sk_free(&q->sk);
 		goto err;
 	}
 
-	init_waitqueue_head(&q->sock.wq.wait);
-	q->sock.type = SOCK_RAW;
-	q->sock.state = SS_CONNECTED;
-	q->sock.file = file;
-	q->sock.ops = &tap_socket_ops;
-	sock_init_data(&q->sock, &q->sk);
+	sock->type = SOCK_RAW;
+	sock->state = SS_CONNECTED;
+	sock->file = file;
+	sock->ops = &tap_socket_ops;
+	sock_init_data(sock, &q->sk);
 	q->sk.sk_write_space = tap_sock_write_space;
 	q->sk.sk_destruct = tap_sock_destruct;
 	q->flags = IFF_VNET_HDR | IFF_NO_PI | IFF_TAP;
@@ -578,13 +587,13 @@ static __poll_t tap_poll(struct file *file, poll_table *wait)
 		goto out;
 
 	mask = 0;
-	poll_wait(file, &q->sock.wq.wait, wait);
+	poll_wait(file, &q->sock->wq.wait, wait);
 
 	if (!ptr_ring_empty(&q->ring))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	if (sock_writeable(&q->sk) ||
-	    (!test_and_set_bit(SOCKWQ_ASYNC_NOSPACE, &q->sock.flags) &&
+	    (!test_and_set_bit(SOCKWQ_ASYNC_NOSPACE, &q->sock->flags) &&
 	     sock_writeable(&q->sk)))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
@@ -1210,7 +1219,7 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 static int tap_sendmsg(struct socket *sock, struct msghdr *m,
 		       size_t total_len)
 {
-	struct tap_queue *q = container_of(sock, struct tap_queue, sock);
+	struct tap_queue *q = container_of(sock->sk, struct tap_queue, sk);
 	struct tun_msg_ctl *ctl = m->msg_control;
 	struct xdp_buff *xdp;
 	int i;
@@ -1230,7 +1239,7 @@ static int tap_sendmsg(struct socket *sock, struct msghdr *m,
 static int tap_recvmsg(struct socket *sock, struct msghdr *m,
 		       size_t total_len, int flags)
 {
-	struct tap_queue *q = container_of(sock, struct tap_queue, sock);
+	struct tap_queue *q = container_of(sock->sk, struct tap_queue, sk);
 	struct sk_buff *skb = m->msg_control;
 	int ret;
 	if (flags & ~(MSG_DONTWAIT|MSG_TRUNC)) {
@@ -1247,8 +1256,7 @@ static int tap_recvmsg(struct socket *sock, struct msghdr *m,
 
 static int tap_peek_len(struct socket *sock)
 {
-	struct tap_queue *q = container_of(sock, struct tap_queue,
-					       sock);
+	struct tap_queue *q = container_of(sock->sk, struct tap_queue, sk);
 	return PTR_RING_PEEK_CALL(&q->ring, __skb_array_len_with_tag);
 }
 
@@ -1271,7 +1279,7 @@ struct socket *tap_get_socket(struct file *file)
 	q = file->private_data;
 	if (!q)
 		return ERR_PTR(-EBADFD);
-	return &q->sock;
+	return q->sock;
 }
 EXPORT_SYMBOL_GPL(tap_get_socket);
 
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 915a187cfabd..60d00609d6ed 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -61,7 +61,7 @@ struct tap_dev {
 
 struct tap_queue {
 	struct sock sk;
-	struct socket sock;
+	struct socket *sock;
 	int vnet_hdr_sz;
 	struct tap_dev __rcu *tap;
 	struct file *file;
-- 
2.23.0

