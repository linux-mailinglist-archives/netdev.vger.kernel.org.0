Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89643986C5
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730953AbfHUVqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 17:46:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727874AbfHUVqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 17:46:01 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E0651307D921;
        Wed, 21 Aug 2019 21:46:00 +0000 (UTC)
Received: from hog.localdomain, (ovpn-204-30.brq.redhat.com [10.40.204.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9E85194B9;
        Wed, 21 Aug 2019 21:45:59 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 1/7] net: add queue argument to __skb_wait_for_more_packets and __skb_{,try_}recv_datagram
Date:   Wed, 21 Aug 2019 23:46:19 +0200
Message-Id: <46946935e3faf51447443c9504d56c5eba49bef2.1566395202.git.sd@queasysnail.net>
In-Reply-To: <cover.1566395202.git.sd@queasysnail.net>
References: <cover.1566395202.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 21 Aug 2019 21:46:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used by ESP over TCP to handle the queue of IKE messages.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 include/linux/skbuff.h | 11 ++++++++---
 net/core/datagram.c    | 26 ++++++++++++++++----------
 net/ipv4/udp.c         |  3 ++-
 net/unix/af_unix.c     |  7 ++++---
 4 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 98ff5ac98caa..149c542115a6 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3377,7 +3377,8 @@ static inline void skb_frag_list_init(struct sk_buff *skb)
 	for (iter = skb_shinfo(skb)->frag_list; iter; iter = iter->next)
 
 
-int __skb_wait_for_more_packets(struct sock *sk, int *err, long *timeo_p,
+int __skb_wait_for_more_packets(struct sock *sk, struct sk_buff_head *queue,
+				int *err, long *timeo_p,
 				const struct sk_buff *skb);
 struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
 					  struct sk_buff_head *queue,
@@ -3386,12 +3387,16 @@ struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
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
index 45a162ef5e02..5fe681e1f4ae 100644
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
@@ -241,13 +242,14 @@ struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
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
@@ -278,7 +280,7 @@ struct sk_buff *__skb_try_recv_datagram(struct sock *sk, unsigned int flags,
 			break;
 
 		sk_busy_loop(sk, flags & MSG_DONTWAIT);
-	} while (sk->sk_receive_queue.prev != *last);
+	} while (queue->prev != *last);
 
 	error = -EAGAIN;
 
@@ -288,7 +290,9 @@ struct sk_buff *__skb_try_recv_datagram(struct sock *sk, unsigned int flags,
 }
 EXPORT_SYMBOL(__skb_try_recv_datagram);
 
-struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
+struct sk_buff *__skb_recv_datagram(struct sock *sk,
+				    struct sk_buff_head *sk_queue,
+				    unsigned int flags,
 				    void (*destructor)(struct sock *sk,
 						       struct sk_buff *skb),
 				    int *off, int *err)
@@ -299,15 +303,16 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
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
@@ -318,7 +323,8 @@ struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned int flags,
 {
 	int off = 0;
 
-	return __skb_recv_datagram(sk, flags | (noblock ? MSG_DONTWAIT : 0),
+	return __skb_recv_datagram(sk, &sk->sk_receive_queue,
+				   flags | (noblock ? MSG_DONTWAIT : 0),
 				   NULL, &off, err);
 }
 EXPORT_SYMBOL(skb_recv_datagram);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8fb250ed53d4..40067fc4c82b 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1690,7 +1690,8 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 
 		/* sk_queue is empty, reader_queue may contain peeked packets */
 	} while (timeo &&
-		 !__skb_wait_for_more_packets(sk, &error, &timeo,
+		 !__skb_wait_for_more_packets(sk, &sk->sk_receive_queue,
+					      &error, &timeo,
 					      (struct sk_buff *)sk_queue));
 
 	*err = error;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e68d7454f2e3..91c1ffd82ff9 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2053,8 +2053,8 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 		mutex_lock(&u->iolock);
 
 		skip = sk_peek_offset(sk, flags);
-		skb = __skb_try_recv_datagram(sk, flags, NULL, &skip, &err,
-					      &last);
+		skb = __skb_try_recv_datagram(sk, &sk->sk_receive_queue, flags,
+					      NULL, &skip, &err, &last);
 		if (skb)
 			break;
 
@@ -2063,7 +2063,8 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
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

