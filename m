Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE19AFE63
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfIKOM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:12:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48456 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbfIKOM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 10:12:56 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95D3B1918645;
        Wed, 11 Sep 2019 14:12:55 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.205.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F3FE5DA60;
        Wed, 11 Sep 2019 14:12:54 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next v2 1/6] net: add queue argument to __skb_wait_for_more_packets and __skb_{,try_}recv_datagram
Date:   Wed, 11 Sep 2019 16:13:02 +0200
Message-Id: <9affe39579820515f74488c49ea9eccc9686df52.1568192824.git.sd@queasysnail.net>
In-Reply-To: <cover.1568192824.git.sd@queasysnail.net>
References: <cover.1568192824.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Wed, 11 Sep 2019 14:12:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used by ESP over TCP to handle the queue of IKE messages.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
v2: document the new argument to __skb_try_recv_datagram

 include/linux/skbuff.h | 11 ++++++++---
 net/core/datagram.c    | 27 +++++++++++++++++----------
 net/ipv4/udp.c         |  3 ++-
 net/unix/af_unix.c     |  7 ++++---
 4 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 77c6dc88e95d..d37b46746b77 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3435,7 +3435,8 @@ static inline void skb_frag_list_init(struct sk_buff *skb)
 	for (iter = skb_shinfo(skb)->frag_list; iter; iter = iter->next)
 
 
-int __skb_wait_for_more_packets(struct sock *sk, int *err, long *timeo_p,
+int __skb_wait_for_more_packets(struct sock *sk, struct sk_buff_head *queue,
+				int *err, long *timeo_p,
 				const struct sk_buff *skb);
 struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
 					  struct sk_buff_head *queue,
@@ -3444,12 +3445,16 @@ struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
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
index 4cc8dc5db2b7..ef192359f707 100644
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
 
-	if (sk->sk_receive_queue.prev != skb)
+	if (queue->prev != skb)
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
-	} while (sk->sk_receive_queue.prev != *last);
+	} while (queue->prev != *last);
 
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
index d88821c794fb..aaac348a86d2 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1676,7 +1676,8 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 
 		/* sk_queue is empty, reader_queue may contain peeked packets */
 	} while (timeo &&
-		 !__skb_wait_for_more_packets(sk, &error, &timeo,
+		 !__skb_wait_for_more_packets(sk, &sk->sk_receive_queue,
+					      &error, &timeo,
 					      (struct sk_buff *)sk_queue));
 
 	*err = error;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 67e87db5877f..93e004f97f48 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2048,8 +2048,8 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 		mutex_lock(&u->iolock);
 
 		skip = sk_peek_offset(sk, flags);
-		skb = __skb_try_recv_datagram(sk, flags, NULL, &skip, &err,
-					      &last);
+		skb = __skb_try_recv_datagram(sk, &sk->sk_receive_queue, flags,
+					      NULL, &skip, &err, &last);
 		if (skb)
 			break;
 
@@ -2058,7 +2058,8 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 		if (err != -EAGAIN)
 			break;
 	} while (timeo &&
-		 !__skb_wait_for_more_packets(sk, &err, &timeo, last));
+		 !__skb_wait_for_more_packets(sk, &sk->sk_receive_queue,
+					      &err, &timeo, last));
 
 	if (!skb) { /* implies iolock unlocked */
 		unix_state_lock(sk);
-- 
2.22.0

