Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15C29105052
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfKUKSm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Nov 2019 05:18:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50430 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726197AbfKUKSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:18:42 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-tri0EfN1OAWOH-_xBVuV4w-1; Thu, 21 Nov 2019 05:18:37 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66C8ADBA3;
        Thu, 21 Nov 2019 10:18:36 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-31.ams2.redhat.com [10.36.116.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7047694A4;
        Thu, 21 Nov 2019 10:18:34 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH ipsec-next v6 1/6] net: add queue argument to __skb_wait_for_more_packets and __skb_{,try_}recv_datagram
Date:   Thu, 21 Nov 2019 11:18:23 +0100
Message-Id: <b681b82594f79edf8065b0cf81a38eb969fbf88c.1574329035.git.sd@queasysnail.net>
In-Reply-To: <cover.1574329035.git.sd@queasysnail.net>
References: <cover.1574329035.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: tri0EfN1OAWOH-_xBVuV4w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used by ESP over TCP to handle the queue of IKE messages.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: David S. Miller <davem@davemloft.net>
---
v6: rebase on top of commits 7c422d0ce975 and 3f926af3f4d6
v2: document the new argument to __skb_try_recv_datagram

 include/linux/skbuff.h | 11 ++++++++---
 net/core/datagram.c    | 27 +++++++++++++++++----------
 net/ipv4/udp.c         |  3 ++-
 net/unix/af_unix.c     |  7 ++++---
 4 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dfe02b658829..81aeb2ff1ca6 100644
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
index da805ee7558b..fbf88bab10aa 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1691,7 +1691,8 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 
 		/* sk_queue is empty, reader_queue may contain peeked packets */
 	} while (timeo &&
-		 !__skb_wait_for_more_packets(sk, &error, &timeo,
+		 !__skb_wait_for_more_packets(sk, &sk->sk_receive_queue,
+					      &error, &timeo,
 					      (struct sk_buff *)sk_queue));
 
 	*err = error;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 193cba2d777b..f1a2944115d5 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2046,8 +2046,8 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 		mutex_lock(&u->iolock);
 
 		skip = sk_peek_offset(sk, flags);
-		skb = __skb_try_recv_datagram(sk, flags, NULL, &skip, &err,
-					      &last);
+		skb = __skb_try_recv_datagram(sk, &sk->sk_receive_queue, flags,
+					      NULL, &skip, &err, &last);
 		if (skb)
 			break;
 
@@ -2056,7 +2056,8 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 		if (err != -EAGAIN)
 			break;
 	} while (timeo &&
-		 !__skb_wait_for_more_packets(sk, &err, &timeo, last));
+		 !__skb_wait_for_more_packets(sk, &sk->sk_receive_queue,
+					      &err, &timeo, last));
 
 	if (!skb) { /* implies iolock unlocked */
 		unix_state_lock(sk);
-- 
2.23.0

