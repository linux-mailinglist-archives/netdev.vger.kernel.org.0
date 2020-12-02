Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266F32CC967
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387521AbgLBWLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387514AbgLBWLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:11:01 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB92C061A04
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:10:15 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id f14so1385548pju.4
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=whasLqjMPGXLpEY20tjlFFBh+irnxgmgA2f5gTPPoVE=;
        b=n6AUQNBq1hDjghI5BAyogXEB+6/kpj4y//6WpIjiujILlZ2YNaxX3Ms7Cid2052N4y
         B8GydnlEEPIPuEIQUO442jW5U7EKsXfiugXksQ9FGKwj4JT4tvD3MzXiu3gYOrgMckmr
         P8vBy8hhu9rbNza/kydh/dNWtKYwBhBEOAoAzxaw+sMlVQx645FrlLiAj4Nxvd13WJMP
         tyGK0fiuMNyQx7B9WVVjUMgJw2CWZN0U9k/bpA0+L5daOvmzdggsyX0y7RfWoeUX7SOy
         RpVUxc5UzR6WnXi7xgSA8M/Qa8GYlKiBiybl/intPoDUQi4TQVWHbQkZucK+b7AgN1DH
         wTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=whasLqjMPGXLpEY20tjlFFBh+irnxgmgA2f5gTPPoVE=;
        b=NZzbizYRmIUu5d0pmKV2f0C2z+pq7I6fDAn1XMTDZfx2lB4SWd31lV8gi6ivWgAGEM
         krjipWCAtWWdBQIkIsyUFhNL7VaygAS0cW+rzqlSLiA7jSBY6beBLYRwFOiCVVbtxaz2
         mBVtAZXKwJvqnoOl45S9sAXqShKWLcUrTiopDiZuWvcpV2u1/nHYxg5iBuFgN3+bHWIs
         iCTadO3hvynlhyljbhb2Tew7ooRnKoc33DwScuqjYZ+/8P55/SGAoeI/Xjd/1yzdMMGJ
         Mg6jJ4vKyFXNMtqJ3axIFfuFOZkR+q/OZag/TCWFWibBZEXjMF3LUrOTLo62R8dZDhjw
         5t2g==
X-Gm-Message-State: AOAM530ulR2x6/NYzLzhLq8d0czzo3jCqP3owTlEcbHfi2iJzJSxN5OV
        CKhWSoIsN6Q5LW6lU6m5EFg=
X-Google-Smtp-Source: ABdhPJwwyZt0H3dr6KsD+JLnjNW6xSz3FBDs7nwiFARLng3kX5ddUcGMFQ3g40EqA1uYTYsDZAHRqA==
X-Received: by 2002:a17:902:900c:b029:da:b7a3:d83a with SMTP id a12-20020a170902900cb02900dab7a3d83amr214419plp.57.1606947015448;
        Wed, 02 Dec 2020 14:10:15 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id p16sm4872pju.47.2020.12.02.14.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:10:15 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v2 2/8] net-tcp: Introduce tcp_recvmsg_locked().
Date:   Wed,  2 Dec 2020 14:09:39 -0800
Message-Id: <20201202220945.911116-3-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Refactor tcp_recvmsg() by splitting it into locked and unlocked
portions. Callers already holding the socket lock and not using
ERRQUEUE/cmsg/busy polling can simply call tcp_recvmsg_locked().
This is in preparation for a short-circuit copy performed by
TCP receive zerocopy for small (< PAGE_SIZE, or otherwise requested
by the user) reads.
---
 net/ipv4/tcp.c | 69 ++++++++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 30 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 887c6e986927..232cb478bacd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2065,36 +2065,28 @@ static int tcp_inq_hint(struct sock *sk)
  *	Probably, code can be easily improved even more.
  */
 
-int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
-		int flags, int *addr_len)
+static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
+			      int nonblock, int flags,
+			      struct scm_timestamping_internal *tss,
+			      int *cmsg_flags)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	int copied = 0;
 	u32 peek_seq;
 	u32 *seq;
 	unsigned long used;
-	int err, inq;
+	int err;
 	int target;		/* Read at least this many bytes */
 	long timeo;
 	struct sk_buff *skb, *last;
 	u32 urg_hole = 0;
-	struct scm_timestamping_internal tss;
-	int cmsg_flags;
-
-	if (unlikely(flags & MSG_ERRQUEUE))
-		return inet_recv_error(sk, msg, len, addr_len);
-
-	if (sk_can_busy_loop(sk) && skb_queue_empty_lockless(&sk->sk_receive_queue) &&
-	    (sk->sk_state == TCP_ESTABLISHED))
-		sk_busy_loop(sk, nonblock);
-
-	lock_sock(sk);
 
 	err = -ENOTCONN;
 	if (sk->sk_state == TCP_LISTEN)
 		goto out;
 
-	cmsg_flags = tp->recvmsg_inq ? 1 : 0;
+	if (tp->recvmsg_inq)
+		*cmsg_flags = 1;
 	timeo = sock_rcvtimeo(sk, nonblock);
 
 	/* Urgent data needs to be handled specially. */
@@ -2274,8 +2266,8 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 		}
 
 		if (TCP_SKB_CB(skb)->has_rxtstamp) {
-			tcp_update_recv_tstamps(skb, &tss);
-			cmsg_flags |= 2;
+			tcp_update_recv_tstamps(skb, tss);
+			*cmsg_flags |= 2;
 		}
 
 		if (used + offset < skb->len)
@@ -2301,22 +2293,9 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 
 	/* Clean up data we have read: This will do ACK frames. */
 	tcp_cleanup_rbuf(sk, copied);
-
-	release_sock(sk);
-
-	if (cmsg_flags) {
-		if (cmsg_flags & 2)
-			tcp_recv_timestamp(msg, sk, &tss);
-		if (cmsg_flags & 1) {
-			inq = tcp_inq_hint(sk);
-			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(inq), &inq);
-		}
-	}
-
 	return copied;
 
 out:
-	release_sock(sk);
 	return err;
 
 recv_urg:
@@ -2327,6 +2306,36 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 	err = tcp_peek_sndq(sk, msg, len);
 	goto out;
 }
+
+int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
+		int flags, int *addr_len)
+{
+	int cmsg_flags = 0, ret, inq;
+	struct scm_timestamping_internal tss;
+
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return inet_recv_error(sk, msg, len, addr_len);
+
+	if (sk_can_busy_loop(sk) &&
+	    skb_queue_empty_lockless(&sk->sk_receive_queue) &&
+	    sk->sk_state == TCP_ESTABLISHED)
+		sk_busy_loop(sk, nonblock);
+
+	lock_sock(sk);
+	ret = tcp_recvmsg_locked(sk, msg, len, nonblock, flags, &tss,
+				 &cmsg_flags);
+	release_sock(sk);
+
+	if (cmsg_flags && ret >= 0) {
+		if (cmsg_flags & 2)
+			tcp_recv_timestamp(msg, sk, &tss);
+		if (cmsg_flags & 1) {
+			inq = tcp_inq_hint(sk);
+			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(inq), &inq);
+		}
+	}
+	return ret;
+}
 EXPORT_SYMBOL(tcp_recvmsg);
 
 void tcp_set_state(struct sock *sk, int state)
-- 
2.29.2.576.ga3fc446d84-goog

