Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB5B1437C7
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 08:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgAUHjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 02:39:12 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:36770 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728689AbgAUHjI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 02:39:08 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 55AA62055E;
        Tue, 21 Jan 2020 08:39:06 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id s2NIbxf_CC26; Tue, 21 Jan 2020 08:39:05 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8D7FC20561;
        Tue, 21 Jan 2020 08:39:03 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 21 Jan 2020
 08:39:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 3F1A5318017A;
 Tue, 21 Jan 2020 08:39:03 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/6] net: add queue argument to __skb_wait_for_more_packets and __skb_{,try_}recv_datagram
Date:   Tue, 21 Jan 2020 08:38:53 +0100
Message-ID: <20200121073858.31120-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121073858.31120-1-steffen.klassert@secunet.com>
References: <20200121073858.31120-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

This will be used by ESP over TCP to handle the queue of IKE messages.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/skbuff.h | 11 ++++++++---
 net/core/datagram.c    | 27 +++++++++++++++++----------
 net/ipv4/udp.c         |  3 ++-
 net/unix/af_unix.c     |  7 ++++---
 4 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e9133bcf0544..49a10f9cc538 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3459,7 +3459,8 @@ static inline void skb_frag_list_init(struct sk_buff *skb)
 	for (iter = skb_shinfo(skb)->frag_list; iter; iter = iter->next)
 
 
-int __skb_wait_for_more_packets(struct sock *sk, int *err, long *timeo_p,
+int __skb_wait_for_more_packets(struct sock *sk, struct sk_buff_head *queue,
+				int *err, long *timeo_p,
 				const struct sk_buff *skb);
 struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
 					  struct sk_buff_head *queue,
@@ -3468,12 +3469,16 @@ struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
 							   struct sk_buff *skb),
 					  int *off, int *err,
 					  struct sk_buff **last);
-struct sk_buff *__skb_try_recv_datagram(struct sock *sk, unsigned flags,
+struct sk_buff *__skb_try_recv_datagram(struct sock *sk,
+					struct sk_buff_head *queue,
+					unsigned int flags,
 					void (*destructor)(struct sock *sk,
 							   struct sk_buff *skb),
 					int *off, int *err,
 					struct sk_buff **last);
-struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned flags,
+struct sk_buff *__skb_recv_datagram(struct sock *sk,
+				    struct sk_buff_head *sk_queue,
+				    unsigned int flags,
 				    void (*destructor)(struct sock *sk,
 						       struct sk_buff *skb),
 				    int *off, int *err);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index da3c24ed129c..a78e7f864c1e 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -84,7 +84,8 @@ static int receiver_wake_function(wait_queue_entry_t *wait, unsigned int mode, i
 /*
  * Wait for the last received packet to be different from skb
  */
-int __skb_wait_for_more_packets(struct sock *sk, int *err, long *timeo_p,
+int __skb_wait_for_more_packets(struct sock *sk, struct sk_buff_head *queue,
+				int *err, long *timeo_p,
 				const struct sk_buff *skb)
 {
 	int error;
@@ -97,7 +98,7 @@ int __skb_wait_for_more_packets(struct sock *sk, int *err, long *timeo_p,
 	if (error)
 		goto out_err;
 
-	if (READ_ONCE(sk->sk_receive_queue.prev) != skb)
+	if (READ_ONCE(queue->prev) != skb)
 		goto out;
 
 	/* Socket shut down? */
@@ -209,6 +210,7 @@ struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
 /**
  *	__skb_try_recv_datagram - Receive a datagram skbuff
  *	@sk: socket
+ *	@queue: socket queue from which to receive
  *	@flags: MSG\_ flags
  *	@destructor: invoked under the receive lock on successful dequeue
  *	@off: an offset in bytes to peek skb from. Returns an offset
@@ -241,13 +243,14 @@ struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
  *	quite explicitly by POSIX 1003.1g, don't change them without having
  *	the standard around please.
  */
-struct sk_buff *__skb_try_recv_datagram(struct sock *sk, unsigned int flags,
+struct sk_buff *__skb_try_recv_datagram(struct sock *sk,
+					struct sk_buff_head *queue,
+					unsigned int flags,
 					void (*destructor)(struct sock *sk,
 							   struct sk_buff *skb),
 					int *off, int *err,
 					struct sk_buff **last)
 {
-	struct sk_buff_head *queue = &sk->sk_receive_queue;
 	struct sk_buff *skb;
 	unsigned long cpu_flags;
 	/*
@@ -278,7 +281,7 @@ struct sk_buff *__skb_try_recv_datagram(struct sock *sk, unsigned int flags,
 			break;
 
 		sk_busy_loop(sk, flags & MSG_DONTWAIT);
-	} while (READ_ONCE(sk->sk_receive_queue.prev) != *last);
+	} while (READ_ONCE(queue->prev) != *last);
 
 	error = -EAGAIN;
 
@@ -288,7 +291,9 @@ struct sk_buff *__skb_try_recv_datagram(struct sock *sk, unsigned int flags,
 }
 EXPORT_SYMBOL(__skb_try_recv_datagram);
 
-struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
+struct sk_buff *__skb_recv_datagram(struct sock *sk,
+				    struct sk_buff_head *sk_queue,
+				    unsigned int flags,
 				    void (*destructor)(struct sock *sk,
 						       struct sk_buff *skb),
 				    int *off, int *err)
@@ -299,15 +304,16 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
 	do {
-		skb = __skb_try_recv_datagram(sk, flags, destructor, off, err,
-					      &last);
+		skb = __skb_try_recv_datagram(sk, sk_queue, flags, destructor,
+					      off, err, &last);
 		if (skb)
 			return skb;
 
 		if (*err != -EAGAIN)
 			break;
 	} while (timeo &&
-		!__skb_wait_for_more_packets(sk, err, &timeo, last));
+		 !__skb_wait_for_more_packets(sk, sk_queue, err,
+					      &timeo, last));
 
 	return NULL;
 }
@@ -318,7 +324,8 @@ struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned int flags,
 {
 	int off = 0;
 
-	return __skb_recv_datagram(sk, flags | (noblock ? MSG_DONTWAIT : 0),
+	return __skb_recv_datagram(sk, &sk->sk_receive_queue,
+				   flags | (noblock ? MSG_DONTWAIT : 0),
 				   NULL, &off, err);
 }
 EXPORT_SYMBOL(skb_recv_datagram);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4da5758cc718..e5738d1217a1 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1708,7 +1708,8 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 
 		/* sk_queue is empty, reader_queue may contain peeked packets */
 	} while (timeo &&
-		 !__skb_wait_for_more_packets(sk, &error, &timeo,
+		 !__skb_wait_for_more_packets(sk, &sk->sk_receive_queue,
+					      &error, &timeo,
 					      (struct sk_buff *)sk_queue));
 
 	*err = error;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 7cfdce10de36..a7f707fc4cac 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2058,8 +2058,8 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 		mutex_lock(&u->iolock);
 
 		skip = sk_peek_offset(sk, flags);
-		skb = __skb_try_recv_datagram(sk, flags, NULL, &skip, &err,
-					      &last);
+		skb = __skb_try_recv_datagram(sk, &sk->sk_receive_queue, flags,
+					      NULL, &skip, &err, &last);
 		if (skb)
 			break;
 
@@ -2068,7 +2068,8 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 		if (err != -EAGAIN)
 			break;
 	} while (timeo &&
-		 !__skb_wait_for_more_packets(sk, &err, &timeo, last));
+		 !__skb_wait_for_more_packets(sk, &sk->sk_receive_queue,
+					      &err, &timeo, last));
 
 	if (!skb) { /* implies iolock unlocked */
 		unix_state_lock(sk);
-- 
2.17.1

