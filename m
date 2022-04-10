Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4549D4FAEC6
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 18:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243490AbiDJQNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 12:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239776AbiDJQND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 12:13:03 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E114831C
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 09:10:52 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id b17-20020a0568301df100b005ce0456a9efso9712235otj.9
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 09:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QvVQEeiHae78BuQG/hbFlRDtvKj18+ZwVmX/KR4TZr8=;
        b=HrshSbvzTaasnoZ1rnsDLN087GwzPczPRHqFFsG4E9SKOzm3DfXgUZcAMz8nUMV8hl
         0seHfZt+qevIYxKIAaYuebfMbY0FOPL5fjxsC7CYb+ivBVtxhdLiRRdDA22t4fO43QC8
         VXLUjpiqgnr3alhPpmigPXLDCsBbYIe1iuTiynnQIJxeyN/9MgRf3EOnw8AkenceS/yT
         TiTB42S3Jsvfw+VwUMn9XMnAhbWdeyv6KUa3Ps5c7oen48BJrpXdu/XZcCs41obcmC//
         VWYp2ek4JuKgAXmFhGb7IpzejSl2exhtBgKHzSIqGnUtirq2FMESr5y1czsRYvCedJnc
         umbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QvVQEeiHae78BuQG/hbFlRDtvKj18+ZwVmX/KR4TZr8=;
        b=7fxUMaYHla+KeSzAbJK2HxP1hTLRSYW//sMAx5BnFPkUGC+i9REqJzC8GxPhNxen2/
         Lb4asuUADTHWc7wHrT/8PYiNp+8zsTScseb0cPCAR4rkIiqWFqwYVeFzRmAaQyAEnSnG
         VkAneutEQd/LwEYQapqP0m/+k8fPDFnzIhmd4ksdjZdrv8g9jk/C90vjpeEmiXHLlYo+
         tuJQkZMkwGyWXRHDWfn3KOMnWkH5fneSH5cyx5dvSnpE9GLPVL9IMvGYYH8xvC67G30I
         l2DlgaHM92G2D+dwu5fcRKsd/RVcnoS2XteL8ROaDhF/9lWLIsaF3ZZF+OmAOQvp28nE
         B8cg==
X-Gm-Message-State: AOAM533C2NXKOxRDtnT3k3/KsbZLl/5TNhGwQbp6LMpZxa6q8vr+9D8k
        AUAOicyHu+7H7CYT0bitn23IWo3Ky3M=
X-Google-Smtp-Source: ABdhPJwwlrs7FPhefeI230MGllBncwjOPemiGhRq/gaNSUzLuQqy+CPNXsGz0AaPQg6mC8XsTnbUfg==
X-Received: by 2002:a05:6830:4d3:b0:5cb:73f0:2f1a with SMTP id s19-20020a05683004d300b005cb73f02f1amr9618988otd.30.1649607051635;
        Sun, 10 Apr 2022 09:10:51 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:9a32:f478:4bc0:f027])
        by smtp.gmail.com with ESMTPSA id v21-20020a4ade95000000b00320f814c73bsm10550200oou.47.2022.04.10.09.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 09:10:51 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v1 2/4] net: introduce a new proto_ops ->read_skb()
Date:   Sun, 10 Apr 2022 09:10:40 -0700
Message-Id: <20220410161042.183540-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently both splice() and sockmap use ->read_sock() to
read skb from receive queue, but for sockmap we only read
one entire skb at a time, so ->read_sock() is too conservative
to use. Introduce a new proto_ops ->read_skb() which supports
this sematic, with this we can finally pass the ownership of
skb to recv actors.

For non-TCP protocols, all ->read_sock() can be simply
converted to ->read_skb().

Cc: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/net.h |  3 +++
 include/net/tcp.h   |  3 +--
 include/net/udp.h   |  3 +--
 net/core/skmsg.c    | 20 +++++---------------
 net/ipv4/af_inet.c  |  3 ++-
 net/ipv4/tcp.c      |  9 +++------
 net/ipv4/udp.c      | 10 ++++------
 net/ipv6/af_inet6.c |  3 ++-
 net/unix/af_unix.c  | 23 +++++++++--------------
 9 files changed, 30 insertions(+), 47 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 12093f4db50c..adcc4e54ec4a 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -152,6 +152,8 @@ struct module;
 struct sk_buff;
 typedef int (*sk_read_actor_t)(read_descriptor_t *, struct sk_buff *,
 			       unsigned int, size_t);
+typedef int (*skb_read_actor_t)(struct sock *, struct sk_buff *);
+
 
 struct proto_ops {
 	int		family;
@@ -214,6 +216,7 @@ struct proto_ops {
 	 */
 	int		(*read_sock)(struct sock *sk, read_descriptor_t *desc,
 				     sk_read_actor_t recv_actor);
+	int		(*read_skb)(struct sock *sk, skb_read_actor_t recv_actor);
 	int		(*sendpage_locked)(struct sock *sk, struct page *page,
 					   int offset, size_t size, int flags);
 	int		(*sendmsg_locked)(struct sock *sk, struct msghdr *msg,
diff --git a/include/net/tcp.h b/include/net/tcp.h
index f0d4ce6855e1..56946d5e8160 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -667,8 +667,7 @@ void tcp_get_info(struct sock *, struct tcp_info *);
 /* Read 'sendfile()'-style from a TCP socket */
 int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		  sk_read_actor_t recv_actor);
-int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
-		 sk_read_actor_t recv_actor);
+int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor);
 
 void tcp_initialize_rcv_mss(struct sock *sk);
 
diff --git a/include/net/udp.h b/include/net/udp.h
index f1c2a88c9005..90cc590d42e3 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -305,8 +305,7 @@ struct sock *__udp6_lib_lookup(struct net *net,
 			       struct sk_buff *skb);
 struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport);
-int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
-		  sk_read_actor_t recv_actor);
+int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor);
 
 /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
  * possibly multiple cache miss on dequeue()
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cc381165ea08..19bca36940a2 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1155,21 +1155,17 @@ static void sk_psock_done_strp(struct sk_psock *psock)
 }
 #endif /* CONFIG_BPF_STREAM_PARSER */
 
-static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
-				 unsigned int offset, size_t orig_len)
+static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 {
-	struct sock *sk = (struct sock *)desc->arg.data;
 	struct sk_psock *psock;
 	struct bpf_prog *prog;
 	int ret = __SK_DROP;
-	int len = orig_len;
+	int len = skb->len;
 
 	/* clone here so sk_eat_skb() in tcp_read_sock does not drop our data */
 	skb = skb_clone(skb, GFP_ATOMIC);
-	if (!skb) {
-		desc->error = -ENOMEM;
+	if (!skb)
 		return 0;
-	}
 
 	rcu_read_lock();
 	psock = sk_psock(sk);
@@ -1199,16 +1195,10 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 static void sk_psock_verdict_data_ready(struct sock *sk)
 {
 	struct socket *sock = sk->sk_socket;
-	read_descriptor_t desc;
 
-	if (unlikely(!sock || !sock->ops || !sock->ops->read_sock))
+	if (unlikely(!sock || !sock->ops || !sock->ops->read_skb))
 		return;
-
-	desc.arg.data = sk;
-	desc.error = 0;
-	desc.count = 1;
-
-	sock->ops->read_sock(sk, &desc, sk_psock_verdict_recv);
+	sock->ops->read_skb(sk, sk_psock_verdict_recv);
 }
 
 void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 72fde2888ad2..c60262bcac88 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1041,6 +1041,7 @@ const struct proto_ops inet_stream_ops = {
 	.sendpage	   = inet_sendpage,
 	.splice_read	   = tcp_splice_read,
 	.read_sock	   = tcp_read_sock,
+	.read_skb	   = tcp_read_skb,
 	.sendmsg_locked    = tcp_sendmsg_locked,
 	.sendpage_locked   = tcp_sendpage_locked,
 	.peek_len	   = tcp_peek_len,
@@ -1068,7 +1069,7 @@ const struct proto_ops inet_dgram_ops = {
 	.setsockopt	   = sock_common_setsockopt,
 	.getsockopt	   = sock_common_getsockopt,
 	.sendmsg	   = inet_sendmsg,
-	.read_sock	   = udp_read_sock,
+	.read_skb	   = udp_read_skb,
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = inet_sendpage,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8b054bcc6849..74e472e8178f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1730,8 +1730,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 }
 EXPORT_SYMBOL(tcp_read_sock);
 
-int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
-		 sk_read_actor_t recv_actor)
+int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
 	struct sk_buff *skb;
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -1747,7 +1746,7 @@ int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
 			size_t len;
 
 			len = skb->len - offset;
-			used = recv_actor(desc, skb, offset, len);
+			used = recv_actor(sk, skb);
 			if (used <= 0) {
 				if (!copied)
 					copied = used;
@@ -1768,9 +1767,7 @@ int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
 			break;
 		}
 		kfree_skb(skb);
-		if (!desc->count)
-			break;
-		WRITE_ONCE(tp->copied_seq, seq);
+		break;
 	}
 	WRITE_ONCE(tp->copied_seq, seq);
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 6b4d8361560f..9faca5758ed6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1796,8 +1796,7 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 }
 EXPORT_SYMBOL(__skb_recv_udp);
 
-int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
-		  sk_read_actor_t recv_actor)
+int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
 	int copied = 0;
 
@@ -1819,7 +1818,7 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 			continue;
 		}
 
-		used = recv_actor(desc, skb, 0, skb->len);
+		used = recv_actor(sk, skb);
 		if (used <= 0) {
 			if (!copied)
 				copied = used;
@@ -1830,13 +1829,12 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		}
 
 		kfree_skb(skb);
-		if (!desc->count)
-			break;
+		break;
 	}
 
 	return copied;
 }
-EXPORT_SYMBOL(udp_read_sock);
+EXPORT_SYMBOL(udp_read_skb);
 
 /*
  * 	This should be easy, if there is something there we
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 7d7b7523d126..06c1b16aa739 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -702,6 +702,7 @@ const struct proto_ops inet6_stream_ops = {
 	.sendpage_locked   = tcp_sendpage_locked,
 	.splice_read	   = tcp_splice_read,
 	.read_sock	   = tcp_read_sock,
+	.read_skb	   = tcp_read_skb,
 	.peek_len	   = tcp_peek_len,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
@@ -727,7 +728,7 @@ const struct proto_ops inet6_dgram_ops = {
 	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
 	.sendmsg	   = inet6_sendmsg,		/* retpoline's sake */
 	.recvmsg	   = inet6_recvmsg,		/* retpoline's sake */
-	.read_sock	   = udp_read_sock,
+	.read_skb	   = udp_read_skb,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
 	.set_peek_off	   = sk_set_peek_off,
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index fecbd95da918..06cf0570635d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -741,10 +741,8 @@ static ssize_t unix_stream_splice_read(struct socket *,  loff_t *ppos,
 				       unsigned int flags);
 static int unix_dgram_sendmsg(struct socket *, struct msghdr *, size_t);
 static int unix_dgram_recvmsg(struct socket *, struct msghdr *, size_t, int);
-static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
-			  sk_read_actor_t recv_actor);
-static int unix_stream_read_sock(struct sock *sk, read_descriptor_t *desc,
-				 sk_read_actor_t recv_actor);
+static int unix_read_skb(struct sock *sk, skb_read_actor_t recv_actor);
+static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor);
 static int unix_dgram_connect(struct socket *, struct sockaddr *,
 			      int, int);
 static int unix_seqpacket_sendmsg(struct socket *, struct msghdr *, size_t);
@@ -798,7 +796,7 @@ static const struct proto_ops unix_stream_ops = {
 	.shutdown =	unix_shutdown,
 	.sendmsg =	unix_stream_sendmsg,
 	.recvmsg =	unix_stream_recvmsg,
-	.read_sock =	unix_stream_read_sock,
+	.read_skb =	unix_stream_read_skb,
 	.mmap =		sock_no_mmap,
 	.sendpage =	unix_stream_sendpage,
 	.splice_read =	unix_stream_splice_read,
@@ -823,7 +821,7 @@ static const struct proto_ops unix_dgram_ops = {
 	.listen =	sock_no_listen,
 	.shutdown =	unix_shutdown,
 	.sendmsg =	unix_dgram_sendmsg,
-	.read_sock =	unix_read_sock,
+	.read_skb =	unix_read_skb,
 	.recvmsg =	unix_dgram_recvmsg,
 	.mmap =		sock_no_mmap,
 	.sendpage =	sock_no_sendpage,
@@ -2490,8 +2488,7 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t si
 	return __unix_dgram_recvmsg(sk, msg, size, flags);
 }
 
-static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
-			  sk_read_actor_t recv_actor)
+static int unix_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
 	int copied = 0;
 
@@ -2506,7 +2503,7 @@ static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 		if (!skb)
 			return err;
 
-		used = recv_actor(desc, skb, 0, skb->len);
+		used = recv_actor(sk, skb);
 		if (used <= 0) {
 			if (!copied)
 				copied = used;
@@ -2517,8 +2514,7 @@ static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 		}
 
 		kfree_skb(skb);
-		if (!desc->count)
-			break;
+		break;
 	}
 
 	return copied;
@@ -2653,13 +2649,12 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 }
 #endif
 
-static int unix_stream_read_sock(struct sock *sk, read_descriptor_t *desc,
-				 sk_read_actor_t recv_actor)
+static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
 	if (unlikely(sk->sk_state != TCP_ESTABLISHED))
 		return -ENOTCONN;
 
-	return unix_read_sock(sk, desc, recv_actor);
+	return unix_read_skb(sk, recv_actor);
 }
 
 static int unix_stream_read_generic(struct unix_stream_read_state *state,
-- 
2.32.0

