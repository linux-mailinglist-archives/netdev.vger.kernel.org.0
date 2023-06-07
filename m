Return-Path: <netdev+bounces-8930-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6B1572655D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:02:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACBD01C20D97
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221CD370F3;
	Wed,  7 Jun 2023 16:02:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102F534D94
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:02:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74DC1BD6
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686153721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8D0wC9fv92syi9P0txy4u3x9OYG9qdDRSwlIhKUuZis=;
	b=AlSl/wpCOywW/iWMSo958QxxbMs8YuNS54JY0p1tH2Cq1yPRaVAuhwQzM9LpZ1Ckrlvcr2
	C7nv4PCVSi+4bOwXGXk7bprDWUNB5jSxl9t4GkE1UZiqALoB4wG6OIW5xrbQWOIteL6v3M
	SxrqKf+ZQoaCUQ5ocQbcN5GU2sGL3Pw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-5P-u-6H6Mdur6K0hMBQNtg-1; Wed, 07 Jun 2023 12:01:55 -0400
X-MC-Unique: 5P-u-6H6Mdur6K0hMBQNtg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93E991C01E9B;
	Wed,  7 Jun 2023 16:01:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 775CD400E400;
	Wed,  7 Jun 2023 16:01:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20230607155420.11462-1-kuniyu@amazon.com>
References: <20230607155420.11462-1-kuniyu@amazon.com> <2269950.1686152632@warthog.procyon.org.uk>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: dhowells@redhat.com, axboe@kernel.dk, borisp@nvidia.com,
    chuck.lever@oracle.com, davem@davemloft.net, dsahern@kernel.org,
    edumazet@google.com, john.fastabend@gmail.com, kuba@kernel.org,
    linux-kernel@vger.kernel.org, linux-mm@kvack.org,
    netdev@vger.kernel.org, pabeni@redhat.com,
    torvalds@linux-foundation.org, willemdebruijn.kernel@gmail.com,
    willy@infradead.org
Subject: Re: [PATCH net-next v5 07/14] ipv4, ipv6: Use splice_eof() to flush
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2284050.1686153708.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Jun 2023 17:01:48 +0100
Message-ID: <2284051.1686153708@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Kuniyuki Iwashima <kuniyu@amazon.com> wrote:

> >      - In udpv6_splice_eof(), use udp_v6_push_pending_frames().
> =

> You missed this change ;)

No I didn't - I just forgot to save the buffer :-/

David
---
commit a630e96e3b1073dc39fd370d60ccb3d5367ce9e6
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jun 7 14:44:34 2023 +0100

    ipv4, ipv6: Use splice_eof() to flush
    =

    Allow splice to undo the effects of MSG_MORE after prematurely ending =
a
    splice/sendfile due to getting an EOF condition (->splice_read() retur=
ned
    0) after splice had called sendmsg() with MSG_MORE set when the user d=
idn't
    set MSG_MORE.
    =

    For UDP, a pending packet will not be emitted if the socket is closed
    before it is flushed; with this change, it be flushed by ->splice_eof(=
).
    =

    For TCP, it's not clear that MSG_MORE is actually effective.
    =

    Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
    Link: https://lore.kernel.org/r/CAHk-=3Dwh=3DV579PDYvkpnTobCLGczbgxpMg=
GmmhqiTyE34Cpi5Gg@mail.gmail.com/
    Signed-off-by: David Howells <dhowells@redhat.com>
    cc: Kuniyuki Iwashima <kuniyu@amazon.com>
    cc: Eric Dumazet <edumazet@google.com>
    cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
    cc: David Ahern <dsahern@kernel.org>
    cc: "David S. Miller" <davem@davemloft.net>
    cc: Jakub Kicinski <kuba@kernel.org>
    cc: Paolo Abeni <pabeni@redhat.com>
    cc: Jens Axboe <axboe@kernel.dk>
    cc: Matthew Wilcox <willy@infradead.org>
    cc: netdev@vger.kernel.org

Notes:
    ver #6)
     - In inet_splice_eof(), use prot after deref of sk->sk_prot.
     - In udpv6_splice_eof(), use udp_v6_push_pending_frames().
     - In udpv6_splice_eof(), don't check for AF_INET.

diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index 77f4b0ef5b92..a75333342c4e 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -35,6 +35,7 @@ void __inet_accept(struct socket *sock, struct socket *n=
ewsock,
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
@@ -327,6 +327,7 @@ int tcp_sendmsg(struct sock *sk, struct msghdr *msg, s=
ize_t size);
 int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size);
 int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *copied=
,
 			 size_t size, struct ubuf_info *uarg);
+void tcp_splice_eof(struct socket *sock);
 int tcp_sendpage(struct sock *sk, struct page *page, int offset, size_t s=
ize,
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
index b5735b3551cf..fd233c4195ac 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -831,6 +831,21 @@ int inet_sendmsg(struct socket *sock, struct msghdr *=
msg, size_t size)
 }
 EXPORT_SYMBOL(inet_sendmsg);
 =

+void inet_splice_eof(struct socket *sock)
+{
+	const struct proto *prot;
+	struct sock *sk =3D sock->sk;
+
+	if (unlikely(inet_send_prepare(sk)))
+		return;
+
+	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
+	prot =3D READ_ONCE(sk->sk_prot);
+	if (prot->splice_eof)
+		prot->splice_eof(sock);
+}
+EXPORT_SYMBOL_GPL(inet_splice_eof);
+
 ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
 		      size_t size, int flags)
 {
@@ -1050,6 +1065,7 @@ const struct proto_ops inet_stream_ops =3D {
 #ifdef CONFIG_MMU
 	.mmap		   =3D tcp_mmap,
 #endif
+	.splice_eof	   =3D inet_splice_eof,
 	.sendpage	   =3D inet_sendpage,
 	.splice_read	   =3D tcp_splice_read,
 	.read_sock	   =3D tcp_read_sock,
@@ -1084,6 +1100,7 @@ const struct proto_ops inet_dgram_ops =3D {
 	.read_skb	   =3D udp_read_skb,
 	.recvmsg	   =3D inet_recvmsg,
 	.mmap		   =3D sock_no_mmap,
+	.splice_eof	   =3D inet_splice_eof,
 	.sendpage	   =3D inet_sendpage,
 	.set_peek_off	   =3D sk_set_peek_off,
 #ifdef CONFIG_COMPAT
@@ -1115,6 +1132,7 @@ static const struct proto_ops inet_sockraw_ops =3D {
 	.sendmsg	   =3D inet_sendmsg,
 	.recvmsg	   =3D inet_recvmsg,
 	.mmap		   =3D sock_no_mmap,
+	.splice_eof	   =3D inet_splice_eof,
 	.sendpage	   =3D inet_sendpage,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	   =3D inet_compat_ioctl,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 53b7751b68e1..09f03221a6f1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1371,6 +1371,22 @@ int tcp_sendmsg(struct sock *sk, struct msghdr *msg=
, size_t size)
 }
 EXPORT_SYMBOL(tcp_sendmsg);
 =

+void tcp_splice_eof(struct socket *sock)
+{
+	struct sock *sk =3D sock->sk;
+	struct tcp_sock *tp =3D tcp_sk(sk);
+	int mss_now, size_goal;
+
+	if (!tcp_write_queue_tail(sk))
+		return;
+
+	lock_sock(sk);
+	mss_now =3D tcp_send_mss(sk, &size_goal, 0);
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
@@ -3116,6 +3116,7 @@ struct proto tcp_prot =3D {
 	.keepalive		=3D tcp_set_keepalive,
 	.recvmsg		=3D tcp_recvmsg,
 	.sendmsg		=3D tcp_sendmsg,
+	.splice_eof		=3D tcp_splice_eof,
 	.sendpage		=3D tcp_sendpage,
 	.backlog_rcv		=3D tcp_v4_do_rcv,
 	.release_cb		=3D tcp_release_cb,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index fd3dae081f3a..df5e407286d7 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1324,6 +1324,21 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg=
, size_t len)
 }
 EXPORT_SYMBOL(udp_sendmsg);
 =

+void udp_splice_eof(struct socket *sock)
+{
+	struct sock *sk =3D sock->sk;
+	struct udp_sock *up =3D udp_sk(sk);
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
@@ -2918,6 +2933,7 @@ struct proto udp_prot =3D {
 	.getsockopt		=3D udp_getsockopt,
 	.sendmsg		=3D udp_sendmsg,
 	.recvmsg		=3D udp_recvmsg,
+	.splice_eof		=3D udp_splice_eof,
 	.sendpage		=3D udp_sendpage,
 	.release_cb		=3D ip4_datagram_release_cb,
 	.hash			=3D udp_lib_hash,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 2bbf13216a3d..564942bee067 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -695,6 +695,7 @@ const struct proto_ops inet6_stream_ops =3D {
 #ifdef CONFIG_MMU
 	.mmap		   =3D tcp_mmap,
 #endif
+	.splice_eof	   =3D inet_splice_eof,
 	.sendpage	   =3D inet_sendpage,
 	.sendmsg_locked    =3D tcp_sendmsg_locked,
 	.sendpage_locked   =3D tcp_sendpage_locked,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d657713d1c71..c17c8ff94b79 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2150,6 +2150,7 @@ struct proto tcpv6_prot =3D {
 	.keepalive		=3D tcp_set_keepalive,
 	.recvmsg		=3D tcp_recvmsg,
 	.sendmsg		=3D tcp_sendmsg,
+	.splice_eof		=3D tcp_splice_eof,
 	.sendpage		=3D tcp_sendpage,
 	.backlog_rcv		=3D tcp_v6_do_rcv,
 	.release_cb		=3D tcp_release_cb,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index e5a337e6b970..317b01c9bc39 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1653,6 +1653,20 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *m=
sg, size_t len)
 }
 EXPORT_SYMBOL(udpv6_sendmsg);
 =

+static void udpv6_splice_eof(struct socket *sock)
+{
+	struct sock *sk =3D sock->sk;
+	struct udp_sock *up =3D udp_sk(sk);
+
+	if (!up->pending || READ_ONCE(up->corkflag))
+		return;
+
+	lock_sock(sk);
+	if (up->pending && !READ_ONCE(up->corkflag))
+		udp_v6_push_pending_frames(sk);
+	release_sock(sk);
+}
+
 void udpv6_destroy_sock(struct sock *sk)
 {
 	struct udp_sock *up =3D udp_sk(sk);
@@ -1764,6 +1778,7 @@ struct proto udpv6_prot =3D {
 	.getsockopt		=3D udpv6_getsockopt,
 	.sendmsg		=3D udpv6_sendmsg,
 	.recvmsg		=3D udpv6_recvmsg,
+	.splice_eof		=3D udpv6_splice_eof,
 	.release_cb		=3D ip6_datagram_release_cb,
 	.hash			=3D udp_lib_hash,
 	.unhash			=3D udp_lib_unhash,


