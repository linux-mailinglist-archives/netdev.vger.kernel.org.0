Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B2953B108
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbiFBBVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbiFBBVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:21:17 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB5713F40B;
        Wed,  1 Jun 2022 18:21:15 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id 2so2522000qtw.0;
        Wed, 01 Jun 2022 18:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2zgx/Nj1R3FESeeEs10kVJw6wQK1ufWJhd3lAYxfZQY=;
        b=WV266bOa++yZ40ZP19vRrHg1PC7/IBLm8gwAC4nKifi1PKmAcztGqwH8x2g7hXgzOW
         DQzs4MkmDdpIwpmW9yHP856zXOwXlmbt1GwdK38j6Ydw1Tw/TGMBP5Qe4+tl1eI7ymsK
         um4tCSAKOvjdyOFdaJlay605T5HMqXVmD9sHraV0qmlqtki3fym8rz8HIZT+PneVjbe5
         cu941AD/uaKQSPUFhjYOpYMbW0UB/1/VWNs8H+3JLjwp7JpKgg6VmKpeeMhA2kUvGeDV
         sQImEh+X6XgsasZyifciGWipriUDID4X8XiuBJKTr+zRlxgUeiEV1J5eE1HDZPKBQU2+
         0MOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2zgx/Nj1R3FESeeEs10kVJw6wQK1ufWJhd3lAYxfZQY=;
        b=KF1tQYDkCyr8aOFRqtbg/DsfvW1ewBYKOOXhGaDuAZoBx/NbREwg1RsKclVryufZPl
         VF1qwjsd02X19CtT7ewkKKF2rJLXHBXXC/R5rfShHMgOy6Z+axREGnxwIRL5OU2FPKO5
         JSkVAxUxohtfg+gpUc6r0r0pmPjVoaqbxyzazT40PEyOj28wJxa8CH4eDBXpx6HspxZf
         FuUs9t6tBt/m1FHvcQRdN6tiNT0tyOcjxIAjoPzIgZpSnrQbnndY2ppk8wVMDiGxbAbY
         vZUUbufuHb8pR9kwG2Nv/nzgJCpjR0JrJmYjsS0L+V7FofIopTOtHDtZ+6NvhlhZX6Jz
         dwoQ==
X-Gm-Message-State: AOAM532hjsam/W3A4wND/6F005/ervE892u21rcryFSEBglPz5EecQ0P
        VLICu4cx95MVeiQGACZtiicHE0XnFuw=
X-Google-Smtp-Source: ABdhPJwYjONNE5NpeYfAs2Jru2Bwl4ExnACrdxaGwVJKA8vsbtNCDe18JQG3QZ3siOjjOwQqGb3duw==
X-Received: by 2002:a05:622a:148c:b0:304:baaa:5abb with SMTP id t12-20020a05622a148c00b00304baaa5abbmr2037408qtx.678.1654132875413;
        Wed, 01 Jun 2022 18:21:15 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:a168:6dba:43b7:3240])
        by smtp.gmail.com with ESMTPSA id x4-20020ac87304000000b002f39b99f670sm2077654qto.10.2022.06.01.18.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 18:21:14 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v3 2/4] net: introduce a new proto_ops ->read_skb()
Date:   Wed,  1 Jun 2022 18:21:03 -0700
Message-Id: <20220602012105.58853-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
References: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
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
 include/linux/net.h |  4 ++++
 include/net/tcp.h   |  3 +--
 include/net/udp.h   |  3 +--
 net/core/skmsg.c    | 20 +++++---------------
 net/ipv4/af_inet.c  |  3 ++-
 net/ipv4/tcp.c      |  9 +++------
 net/ipv4/udp.c      | 10 ++++------
 net/ipv6/af_inet6.c |  3 ++-
 net/unix/af_unix.c  | 23 +++++++++--------------
 9 files changed, 31 insertions(+), 47 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 12093f4db50c..a03485e8cbb2 100644
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
@@ -214,6 +216,8 @@ struct proto_ops {
 	 */
 	int		(*read_sock)(struct sock *sk, read_descriptor_t *desc,
 				     sk_read_actor_t recv_actor);
+	/* This is different from read_sock(), it reads an entire skb at a time. */
+	int		(*read_skb)(struct sock *sk, skb_read_actor_t recv_actor);
 	int		(*sendpage_locked)(struct sock *sk, struct page *page,
 					   int offset, size_t size, int flags);
 	int		(*sendmsg_locked)(struct sock *sk, struct msghdr *msg,
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 878544d0f8f9..3aa859c9a0fb 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -669,8 +669,7 @@ void tcp_get_info(struct sock *, struct tcp_info *);
 /* Read 'sendfile()'-style from a TCP socket */
 int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		  sk_read_actor_t recv_actor);
-int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
-		 sk_read_actor_t recv_actor);
+int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor);
 
 void tcp_initialize_rcv_mss(struct sock *sk);
 
diff --git a/include/net/udp.h b/include/net/udp.h
index b83a00330566..47a0e3359771 100644
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
index 7e03f96e441b..f7f63b7d990c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1160,21 +1160,17 @@ static void sk_psock_done_strp(struct sk_psock *psock)
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
@@ -1204,16 +1200,10 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
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
index 93da9f783bec..f615263855d0 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1040,6 +1040,7 @@ const struct proto_ops inet_stream_ops = {
 	.sendpage	   = inet_sendpage,
 	.splice_read	   = tcp_splice_read,
 	.read_sock	   = tcp_read_sock,
+	.read_skb	   = tcp_read_skb,
 	.sendmsg_locked    = tcp_sendmsg_locked,
 	.sendpage_locked   = tcp_sendpage_locked,
 	.peek_len	   = tcp_peek_len,
@@ -1067,7 +1068,7 @@ const struct proto_ops inet_dgram_ops = {
 	.setsockopt	   = sock_common_setsockopt,
 	.getsockopt	   = sock_common_getsockopt,
 	.sendmsg	   = inet_sendmsg,
-	.read_sock	   = udp_read_sock,
+	.read_skb	   = udp_read_skb,
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = inet_sendpage,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a18e9ababf54..8b9327a0d0d5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1709,8 +1709,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 }
 EXPORT_SYMBOL(tcp_read_sock);
 
-int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
-		 sk_read_actor_t recv_actor)
+int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	u32 seq = tp->copied_seq;
@@ -1725,7 +1724,7 @@ int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
 		int used;
 
 		__skb_unlink(skb, &sk->sk_receive_queue);
-		used = recv_actor(desc, skb, 0, skb->len);
+		used = recv_actor(sk, skb);
 		if (used <= 0) {
 			if (!copied)
 				copied = used;
@@ -1740,9 +1739,7 @@ int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
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
index aa9f2ec3dc46..0a1e90b80e36 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1795,8 +1795,7 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 }
 EXPORT_SYMBOL(__skb_recv_udp);
 
-int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
-		  sk_read_actor_t recv_actor)
+int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
 	int copied = 0;
 
@@ -1818,7 +1817,7 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 			continue;
 		}
 
-		used = recv_actor(desc, skb, 0, skb->len);
+		used = recv_actor(sk, skb);
 		if (used <= 0) {
 			if (!copied)
 				copied = used;
@@ -1829,13 +1828,12 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
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
index 70564ddccc46..1aea5ef9bdea 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -701,6 +701,7 @@ const struct proto_ops inet6_stream_ops = {
 	.sendpage_locked   = tcp_sendpage_locked,
 	.splice_read	   = tcp_splice_read,
 	.read_sock	   = tcp_read_sock,
+	.read_skb	   = tcp_read_skb,
 	.peek_len	   = tcp_peek_len,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet6_compat_ioctl,
@@ -726,7 +727,7 @@ const struct proto_ops inet6_dgram_ops = {
 	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
 	.sendmsg	   = inet6_sendmsg,		/* retpoline's sake */
 	.recvmsg	   = inet6_recvmsg,		/* retpoline's sake */
-	.read_sock	   = udp_read_sock,
+	.read_skb	   = udp_read_skb,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
 	.set_peek_off	   = sk_set_peek_off,
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 654dcef7cfb3..3a96008ec331 100644
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
@@ -2487,8 +2485,7 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t si
 	return __unix_dgram_recvmsg(sk, msg, size, flags);
 }
 
-static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
-			  sk_read_actor_t recv_actor)
+static int unix_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
 	int copied = 0;
 
@@ -2503,7 +2500,7 @@ static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 		if (!skb)
 			return err;
 
-		used = recv_actor(desc, skb, 0, skb->len);
+		used = recv_actor(sk, skb);
 		if (used <= 0) {
 			if (!copied)
 				copied = used;
@@ -2514,8 +2511,7 @@ static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 		}
 
 		kfree_skb(skb);
-		if (!desc->count)
-			break;
+		break;
 	}
 
 	return copied;
@@ -2650,13 +2646,12 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
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
2.34.1

