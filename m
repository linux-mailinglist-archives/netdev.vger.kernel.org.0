Return-Path: <netdev+bounces-8881-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B694F7262E0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D6BA281448
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D97B01ACA0;
	Wed,  7 Jun 2023 14:32:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C739137346
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:32:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B692172E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686148356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vvYX0FjZprfEU41+87A4pQCc64jz60fQuum5imcGYY8=;
	b=gQhVHgMB5XD3lCqNrfL7SBl+f/qe+HAt2rv2L8VfARm0/Nphcb8RZK/od6SENujUmDZbAs
	nkgeWKET9Mm9MX+V3A2RfGzPPW6gUVyzQb29WVlRpmRTc2pmoDB4SztYQ4Au/UH5HUKoQ9
	j3j+DSb0w3g9dVtVBB96eB75/gBSNYc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-1Z_Rr_ttOkOs9_GQq91k1g-1; Wed, 07 Jun 2023 10:06:35 -0400
X-MC-Unique: 1Z_Rr_ttOkOs9_GQq91k1g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3EBD185A794;
	Wed,  7 Jun 2023 14:06:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7B901492B00;
	Wed,  7 Jun 2023 14:06:31 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 07/14] ipv4, ipv6: Use splice_eof() to flush
Date: Wed,  7 Jun 2023 15:05:52 +0100
Message-ID: <20230607140559.2263470-8-dhowells@redhat.com>
In-Reply-To: <20230607140559.2263470-1-dhowells@redhat.com>
References: <20230607140559.2263470-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Allow splice to undo the effects of MSG_MORE after prematurely ending a
splice/sendfile due to getting an EOF condition (->splice_read() returned
0) after splice had called sendmsg() with MSG_MORE set when the user didn't
set MSG_MORE.

For UDP, a pending packet will not be emitted if the socket is closed
before it is flushed; with this change, it be flushed by ->splice_eof().

For TCP, it's not clear that MSG_MORE is actually effective.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/CAHk-=wh=V579PDYvkpnTobCLGczbgxpMgGmmhqiTyE34Cpi5Gg@mail.gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Dumazet <edumazet@google.com>
cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
cc: David Ahern <dsahern@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 include/net/inet_common.h |  1 +
 include/net/tcp.h         |  1 +
 include/net/udp.h         |  1 +
 net/ipv4/af_inet.c        | 18 ++++++++++++++++++
 net/ipv4/tcp.c            | 16 ++++++++++++++++
 net/ipv4/tcp_ipv4.c       |  1 +
 net/ipv4/udp.c            | 16 ++++++++++++++++
 net/ipv6/af_inet6.c       |  1 +
 net/ipv6/tcp_ipv6.c       |  1 +
 net/ipv6/udp.c            | 18 ++++++++++++++++++
 10 files changed, 74 insertions(+)

diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index 77f4b0ef5b92..a75333342c4e 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -35,6 +35,7 @@ void __inet_accept(struct socket *sock, struct socket *newsock,
 		   struct sock *newsk);
 int inet_send_prepare(struct sock *sk);
 int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
+void inet_splice_eof(struct socket *sock);
 ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
 		      size_t size, int flags);
 int inet_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 68990a8f556a..49611af31bb7 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -327,6 +327,7 @@ int tcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size);
 int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *copied,
 			 size_t size, struct ubuf_info *uarg);
+void tcp_splice_eof(struct socket *sock);
 int tcp_sendpage(struct sock *sk, struct page *page, int offset, size_t size,
 		 int flags);
 int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
diff --git a/include/net/udp.h b/include/net/udp.h
index 5cad44318d71..4ed0b47c5582 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -278,6 +278,7 @@ int udp_get_port(struct sock *sk, unsigned short snum,
 int udp_err(struct sk_buff *, u32);
 int udp_abort(struct sock *sk, int err);
 int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
+void udp_splice_eof(struct socket *sock);
 int udp_push_pending_frames(struct sock *sk);
 void udp_flush_pending_frames(struct sock *sk);
 int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b5735b3551cf..6cfb78592836 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -831,6 +831,21 @@ int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 }
 EXPORT_SYMBOL(inet_sendmsg);
 
+void inet_splice_eof(struct socket *sock)
+{
+	const struct proto *prot;
+	struct sock *sk = sock->sk;
+
+	if (unlikely(inet_send_prepare(sk)))
+		return;
+
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	prot = READ_ONCE(sk->sk_prot);
+	if (prot->splice_eof)
+		sk->sk_prot->splice_eof(sock);
+}
+EXPORT_SYMBOL_GPL(inet_splice_eof);
+
 ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
 		      size_t size, int flags)
 {
@@ -1050,6 +1065,7 @@ const struct proto_ops inet_stream_ops = {
 #ifdef CONFIG_MMU
 	.mmap		   = tcp_mmap,
 #endif
+	.splice_eof	   = inet_splice_eof,
 	.sendpage	   = inet_sendpage,
 	.splice_read	   = tcp_splice_read,
 	.read_sock	   = tcp_read_sock,
@@ -1084,6 +1100,7 @@ const struct proto_ops inet_dgram_ops = {
 	.read_skb	   = udp_read_skb,
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
+	.splice_eof	   = inet_splice_eof,
 	.sendpage	   = inet_sendpage,
 	.set_peek_off	   = sk_set_peek_off,
 #ifdef CONFIG_COMPAT
@@ -1115,6 +1132,7 @@ static const struct proto_ops inet_sockraw_ops = {
 	.sendmsg	   = inet_sendmsg,
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
+	.splice_eof	   = inet_splice_eof,
 	.sendpage	   = inet_sendpage,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   = inet_compat_ioctl,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 53b7751b68e1..09f03221a6f1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1371,6 +1371,22 @@ int tcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 }
 EXPORT_SYMBOL(tcp_sendmsg);
 
+void tcp_splice_eof(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct tcp_sock *tp = tcp_sk(sk);
+	int mss_now, size_goal;
+
+	if (!tcp_write_queue_tail(sk))
+		return;
+
+	lock_sock(sk);
+	mss_now = tcp_send_mss(sk, &size_goal, 0);
+	tcp_push(sk, 0, mss_now, tp->nonagle, size_goal);
+	release_sock(sk);
+}
+EXPORT_SYMBOL_GPL(tcp_splice_eof);
+
 /*
  *	Handle reading urgent data. BSD has very simple semantics for
  *	this, no blocking and very strange errors 8)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 53e9ce2f05bb..84a5d557dc1a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3116,6 +3116,7 @@ struct proto tcp_prot = {
 	.keepalive		= tcp_set_keepalive,
 	.recvmsg		= tcp_recvmsg,
 	.sendmsg		= tcp_sendmsg,
+	.splice_eof		= tcp_splice_eof,
 	.sendpage		= tcp_sendpage,
 	.backlog_rcv		= tcp_v4_do_rcv,
 	.release_cb		= tcp_release_cb,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index fd3dae081f3a..df5e407286d7 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1324,6 +1324,21 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 }
 EXPORT_SYMBOL(udp_sendmsg);
 
+void udp_splice_eof(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct udp_sock *up = udp_sk(sk);
+
+	if (!up->pending || READ_ONCE(up->corkflag))
+		return;
+
+	lock_sock(sk);
+	if (up->pending && !READ_ONCE(up->corkflag))
+		udp_push_pending_frames(sk);
+	release_sock(sk);
+}
+EXPORT_SYMBOL_GPL(udp_splice_eof);
+
 int udp_sendpage(struct sock *sk, struct page *page, int offset,
 		 size_t size, int flags)
 {
@@ -2918,6 +2933,7 @@ struct proto udp_prot = {
 	.getsockopt		= udp_getsockopt,
 	.sendmsg		= udp_sendmsg,
 	.recvmsg		= udp_recvmsg,
+	.splice_eof		= udp_splice_eof,
 	.sendpage		= udp_sendpage,
 	.release_cb		= ip4_datagram_release_cb,
 	.hash			= udp_lib_hash,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 2bbf13216a3d..564942bee067 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -695,6 +695,7 @@ const struct proto_ops inet6_stream_ops = {
 #ifdef CONFIG_MMU
 	.mmap		   = tcp_mmap,
 #endif
+	.splice_eof	   = inet_splice_eof,
 	.sendpage	   = inet_sendpage,
 	.sendmsg_locked    = tcp_sendmsg_locked,
 	.sendpage_locked   = tcp_sendpage_locked,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d657713d1c71..c17c8ff94b79 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2150,6 +2150,7 @@ struct proto tcpv6_prot = {
 	.keepalive		= tcp_set_keepalive,
 	.recvmsg		= tcp_recvmsg,
 	.sendmsg		= tcp_sendmsg,
+	.splice_eof		= tcp_splice_eof,
 	.sendpage		= tcp_sendpage,
 	.backlog_rcv		= tcp_v6_do_rcv,
 	.release_cb		= tcp_release_cb,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index e5a337e6b970..6c5975b13ae3 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1653,6 +1653,23 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 }
 EXPORT_SYMBOL(udpv6_sendmsg);
 
+static void udpv6_splice_eof(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct udp_sock *up = udp_sk(sk);
+
+	if (!up->pending || READ_ONCE(up->corkflag))
+		return;
+
+	if (up->pending == AF_INET)
+		udp_splice_eof(sock);
+
+	lock_sock(sk);
+	if (up->pending && !READ_ONCE(up->corkflag))
+		udp_push_pending_frames(sk);
+	release_sock(sk);
+}
+
 void udpv6_destroy_sock(struct sock *sk)
 {
 	struct udp_sock *up = udp_sk(sk);
@@ -1764,6 +1781,7 @@ struct proto udpv6_prot = {
 	.getsockopt		= udpv6_getsockopt,
 	.sendmsg		= udpv6_sendmsg,
 	.recvmsg		= udpv6_recvmsg,
+	.splice_eof		= udpv6_splice_eof,
 	.release_cb		= ip6_datagram_release_cb,
 	.hash			= udp_lib_hash,
 	.unhash			= udp_lib_unhash,


