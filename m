Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C0F6772FD
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 23:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjAVWXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 17:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjAVWXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 17:23:19 -0500
Received: from forward102p.mail.yandex.net (forward102p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227158A66
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 14:23:15 -0800 (PST)
Received: from iva1-adaa4d2a0364.qloud-c.yandex.net (iva1-adaa4d2a0364.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a0e:0:640:adaa:4d2a])
        by forward102p.mail.yandex.net (Yandex) with ESMTP id BA310393F692;
        Mon, 23 Jan 2023 01:21:21 +0300 (MSK)
Received: by iva1-adaa4d2a0364.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id KL0bdDxfDOs1-Nwpt7mds;
        Mon, 23 Jan 2023 01:21:20 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1674426080;
        bh=Zn8ML+Gw7jK1fICbr+boa77UmdIPMkYhzoG/WxZxszs=;
        h=Cc:To:Subject:From:Date:Message-ID;
        b=LY9Cn4UdAkkmiumykszkdH5GAA0e6cwn49d50DWsV6yBRvJwvnW8cAx0lfBzWc4rQ
         bcZTu0p9t3KsW/OT8pA2R/2KMTwWfyGHwylEB3qcZrTAWh6DLs/G38mlFY2LdTEysg
         04FlzebSdrrQ8XOORY8W+lexeLkG3zhTocEj8Bug=
Authentication-Results: iva1-adaa4d2a0364.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Message-ID: <72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru>
Date:   Mon, 23 Jan 2023 01:21:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Kirill Tkhai <tkhai@ya.ru>
Subject: [PATCH net-next] unix: Guarantee sk_state relevance in case of it was
 assigned by a task on other cpu
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Language: en-US
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuniyu@amazon.com, gorcunov@gmail.com,
        tkhai@ya.ru
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some functions use unlocked check for sock::sk_state. This does not guarantee
a new value assigned to sk_state on some CPU is already visible on this CPU.

Example:

[CPU0:Task0]                    [CPU1:Task1]
unix_listen()
  unix_state_lock(sk);
  sk->sk_state = TCP_LISTEN;
  unix_state_unlock(sk);
                                unix_accept()
                                  if (sk->sk_state != TCP_LISTEN) /* not visible */
                                     goto out;                    /* return error */

Task1 may miss new sk->sk_state value, and then unix_accept() returns error.
Since in this situation unix_accept() is called chronologically later, such
behavior is not obvious and it is wrong.

This patch aims to fix the problem. A new function unix_sock_state() is
introduced, and it makes sure a user never misses a new state assigned just
before the function is called. We will use it in the places, where unlocked
sk_state dereferencing was used before.

Note, that there remain some more places with sk_state unfixed. Also, the same
problem is with unix_peer(). This will be a subject for future patches.

Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
---
 net/unix/af_unix.c |   43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 009616fa0256..f53e09a0753b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -247,6 +247,28 @@ struct sock *unix_peer_get(struct sock *s)
 }
 EXPORT_SYMBOL_GPL(unix_peer_get);
 
+/* This function returns current sk->sk_state guaranteeing
+ * its relevance in case of assignment was made on other CPU.
+ */
+static unsigned char unix_sock_state(struct sock *sk)
+{
+	unsigned char s_state = READ_ONCE(sk->sk_state);
+
+	/* SOCK_STREAM and SOCK_SEQPACKET sockets never change their
+	 * sk_state after switching to TCP_ESTABLISHED or TCP_LISTEN.
+	 * We may avoid taking the lock in case of those states are
+	 * already visible.
+	 */
+	if ((s_state == TCP_ESTABLISHED || s_state == TCP_LISTEN)
+	    && sk->sk_type != SOCK_DGRAM)
+		return s_state;
+
+	unix_state_lock(sk);
+	s_state = sk->sk_state;
+	unix_state_unlock(sk);
+	return s_state;
+}
+
 static struct unix_address *unix_create_addr(struct sockaddr_un *sunaddr,
 					     int addr_len)
 {
@@ -812,13 +834,9 @@ static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
 	int nr_fds = 0;
 
 	if (sk) {
-		s_state = READ_ONCE(sk->sk_state);
+		s_state = unix_sock_state(sk);
 		u = unix_sk(sk);
 
-		/* SOCK_STREAM and SOCK_SEQPACKET sockets never change their
-		 * sk_state after switching to TCP_ESTABLISHED or TCP_LISTEN.
-		 * SOCK_DGRAM is ordinary. So, no lock is needed.
-		 */
 		if (sock->type == SOCK_DGRAM || s_state == TCP_ESTABLISHED)
 			nr_fds = atomic_read(&u->scm_stat.nr_fds);
 		else if (s_state == TCP_LISTEN)
@@ -1686,7 +1704,7 @@ static int unix_accept(struct socket *sock, struct socket *newsock, int flags,
 		goto out;
 
 	err = -EINVAL;
-	if (sk->sk_state != TCP_LISTEN)
+	if (unix_sock_state(sk) != TCP_LISTEN)
 		goto out;
 
 	/* If socket state is TCP_LISTEN it cannot change (for now...),
@@ -2178,7 +2196,8 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 	if (msg->msg_namelen) {
-		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
+		unsigned char s_state = unix_sock_state(sk);
+		err = s_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
 		goto out_err;
 	} else {
 		err = -ENOTCONN;
@@ -2279,7 +2298,7 @@ static ssize_t unix_stream_sendpage(struct socket *socket, struct page *page,
 		return -EOPNOTSUPP;
 
 	other = unix_peer(sk);
-	if (!other || sk->sk_state != TCP_ESTABLISHED)
+	if (!other || unix_sock_state(sk) != TCP_ESTABLISHED)
 		return -ENOTCONN;
 
 	if (false) {
@@ -2391,7 +2410,7 @@ static int unix_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (err)
 		return err;
 
-	if (sk->sk_state != TCP_ESTABLISHED)
+	if (unix_sock_state(sk) != TCP_ESTABLISHED)
 		return -ENOTCONN;
 
 	if (msg->msg_namelen)
@@ -2405,7 +2424,7 @@ static int unix_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg,
 {
 	struct sock *sk = sock->sk;
 
-	if (sk->sk_state != TCP_ESTABLISHED)
+	if (unix_sock_state(sk) != TCP_ESTABLISHED)
 		return -ENOTCONN;
 
 	return unix_dgram_recvmsg(sock, msg, size, flags);
@@ -2689,7 +2708,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 
 static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
-	if (unlikely(sk->sk_state != TCP_ESTABLISHED))
+	if (unlikely(unix_sock_state(sk) != TCP_ESTABLISHED))
 		return -ENOTCONN;
 
 	return unix_read_skb(sk, recv_actor);
@@ -2713,7 +2732,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 	size_t size = state->size;
 	unsigned int last_len;
 
-	if (unlikely(sk->sk_state != TCP_ESTABLISHED)) {
+	if (unlikely(unix_sock_state(sk) != TCP_ESTABLISHED)) {
 		err = -EINVAL;
 		goto out;
 	}


