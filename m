Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD2460674D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 19:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiJTRtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 13:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiJTRtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 13:49:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A222FAE79
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 10:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666288178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JSqL0qYiG8iF8Q2dZujhqIpzkNeCX2hBCyo0QWm/22w=;
        b=KFHKghY6HJIc/gTW+uKjRq8rdJq9jL0R98oiWzkkZYecwy9QKJkJ04bTSYIOKlRddKnwtZ
        h4MfKfaM3NTjQ/83rSVBOs/XGhzOylYEvnQhesFjPnZXRmwgDdsfbxrJxI7QDXRwUVCleJ
        DFbeUs407hdHjG3KZf1hqxc6SLB88L8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-MgwX3JluPHmaqyOt18wUSQ-1; Thu, 20 Oct 2022 13:49:27 -0400
X-MC-Unique: MgwX3JluPHmaqyOt18wUSQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 096F31871CD4;
        Thu, 20 Oct 2022 17:49:27 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D207D49BB67;
        Thu, 20 Oct 2022 17:49:17 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.linux.dev,
        David Ahern <dsahern@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH net-next v2 2/2] udp: track the forward memory release threshold in an hot cacheline
Date:   Thu, 20 Oct 2022 19:48:52 +0200
Message-Id: <2dede94e742d8096d6ac5e0f1979054ee158d9a8.1666287924.git.pabeni@redhat.com>
In-Reply-To: <cover.1666287924.git.pabeni@redhat.com>
References: <cover.1666287924.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the receiver process and the BH runs on different cores,
udp_rmem_release() experience a cache miss while accessing sk_rcvbuf,
as the latter shares the same cacheline with sk_forward_alloc, written
by the BH.

With this patch, UDP tracks the rcvbuf value and its update via custom
SOL_SOCKET socket options, and copies the forward memory threshold value
used by udp_rmem_release() in a different cacheline, already accessed by
the above function and uncontended.

Since the UDP socket init operation grown a bit, factor out the common
code between v4 and v6 in a shared helper.

Overall the above give a 10% peek throughput increase under UDP flood.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
 - factor out common init helper for udp && udpv6 sock (Kuniyuki)
---
 include/linux/udp.h |  3 +++
 include/net/udp.h   |  9 +++++++++
 net/ipv4/udp.c      | 18 +++++++++++++++---
 net/ipv6/udp.c      |  4 ++--
 4 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index e96da4157d04..5cdba00a904a 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -87,6 +87,9 @@ struct udp_sock {
 
 	/* This field is dirtied by udp_recvmsg() */
 	int		forward_deficit;
+
+	/* This fields follows rcvbuf value, and is touched by udp_recvmsg */
+	int		forward_threshold;
 };
 
 #define UDP_MAX_SEGMENTS	(1 << 6UL)
diff --git a/include/net/udp.h b/include/net/udp.h
index fee053bcd17c..de4b528522bb 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -174,6 +174,15 @@ INDIRECT_CALLABLE_DECLARE(int udpv6_rcv(struct sk_buff *));
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 				  netdev_features_t features, bool is_ipv6);
 
+static inline void udp_lib_init_sock(struct sock *sk)
+{
+	struct udp_sock *up = udp_sk(sk);
+
+	skb_queue_head_init(&up->reader_queue);
+	up->forward_threshold = sk->sk_rcvbuf >> 2;
+	set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
+}
+
 /* hash routines shared between UDPv4/6 and UDP-Litev4/6 */
 static inline int udp_lib_hash(struct sock *sk)
 {
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8126f67d18b3..e361ad93999e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1448,7 +1448,7 @@ static void udp_rmem_release(struct sock *sk, int size, int partial,
 	if (likely(partial)) {
 		up->forward_deficit += size;
 		size = up->forward_deficit;
-		if (size < (sk->sk_rcvbuf >> 2) &&
+		if (size < READ_ONCE(up->forward_threshold) &&
 		    !skb_queue_empty(&up->reader_queue))
 			return;
 	} else {
@@ -1622,7 +1622,7 @@ static void udp_destruct_sock(struct sock *sk)
 
 int udp_init_sock(struct sock *sk)
 {
-	skb_queue_head_init(&udp_sk(sk)->reader_queue);
+	udp_lib_init_sock(sk);
 	sk->sk_destruct = udp_destruct_sock;
 	return 0;
 }
@@ -2671,6 +2671,18 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 	int err = 0;
 	int is_udplite = IS_UDPLITE(sk);
 
+	if (level == SOL_SOCKET) {
+		err = sk_setsockopt(sk, level, optname, optval, optlen);
+
+		if (optname == SO_RCVBUF || optname == SO_RCVBUFFORCE) {
+			sockopt_lock_sock(sk);
+			/* paired with READ_ONCE in udp_rmem_release() */
+			WRITE_ONCE(up->forward_threshold, sk->sk_rcvbuf >> 2);
+			sockopt_release_sock(sk);
+		}
+		return err;
+	}
+
 	if (optlen < sizeof(int))
 		return -EINVAL;
 
@@ -2784,7 +2796,7 @@ EXPORT_SYMBOL(udp_lib_setsockopt);
 int udp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 		   unsigned int optlen)
 {
-	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
+	if (level == SOL_UDP  ||  level == SOL_UDPLITE || level == SOL_SOCKET)
 		return udp_lib_setsockopt(sk, level, optname,
 					  optval, optlen,
 					  udp_push_pending_frames);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 8d09f0ea5b8c..b0bc4e27ec2f 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -64,7 +64,7 @@ static void udpv6_destruct_sock(struct sock *sk)
 
 int udpv6_init_sock(struct sock *sk)
 {
-	skb_queue_head_init(&udp_sk(sk)->reader_queue);
+	udp_lib_init_sock(sk);
 	sk->sk_destruct = udpv6_destruct_sock;
 	return 0;
 }
@@ -1671,7 +1671,7 @@ void udpv6_destroy_sock(struct sock *sk)
 int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 		     unsigned int optlen)
 {
-	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
+	if (level == SOL_UDP  ||  level == SOL_UDPLITE || level == SOL_SOCKET)
 		return udp_lib_setsockopt(sk, level, optname,
 					  optval, optlen,
 					  udp_v6_push_pending_frames);
-- 
2.37.3

