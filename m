Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB3C2CCA06
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387723AbgLBWzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387674AbgLBWzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:55:13 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36015C061A48
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:53:56 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id w6so1967pfu.1
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yC4TtlbK31NIsMHDt9xMetZqQod/Od5w+vG2xAeN+28=;
        b=RagS3LnRH+sN+jMeFtoqOSXbChAuKbcN2mOLwHDV5zSR2gbg0eqrE67woFf8wSll7N
         OL4EqKXbEvGhAezhjQAuqNnsYarNLPwQh0fZgkd8Sh/cEcn1oxOYow1LTpXAZMaChorT
         nDRUeiMxoQ8BhvPBVcblYRpMvHR/4Oepbwh9zI605wHkJVJUsD5wDCOpBWxbrC2UKhop
         lBg3V97PYLn41IHWzET8Rpe/ZNoUEpiVOQVtYlOBwk64viBPTRlXunpwnOU9THW6334D
         VgCKttxaJtW58yddy+c3i+KqP1BwGu6lz/EyrbDn4j0Ykl3RgxNsAamZ3GLRooyy+y3O
         T8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yC4TtlbK31NIsMHDt9xMetZqQod/Od5w+vG2xAeN+28=;
        b=JlisvyCCc+kir9FR4iAIgvoLRiF1Vz9ZnO3mXZnvyht+/RV6uLCS4xLmbUSca6z3QO
         loJe4oWVwXHkVkv9r0QVjM4rTR/dZECBWhQCZaRXYLZ8nHw8ucYkbQqvd7oWdAmDUdS2
         djtZBNDn2eYXXhlVTgXJpgDgmphEIo3PHNgF3LmEdTshmZ3dFZGeMVsy9mFwXDtsM67x
         aaq/FBGR7tt7UUOpPtX2dJRxJrEOki/RNrjrOr6j65VmiYeW9yNoN8kMbRibGQLA7G8Z
         y87+vC5ku235iqkP+mqvLI8XJi9UGprfGcZSpBXnCkNHKvUDhgcATJKM+lvGmvHbA79Q
         lj2w==
X-Gm-Message-State: AOAM530s4/Ddpruio8yNfzmCBIvX3Pmay6vATTUf/PVwOBSybhPkn9QP
        7OKhB3I7HuvMhCFMkkUqoxM=
X-Google-Smtp-Source: ABdhPJxYnYGA+TEOovM+AEDrjPoxf9Kh768xf6g2gfbZ5TbNEQhkLmWxhTHp9ki+tlvobXDil3fn1g==
X-Received: by 2002:a62:e70e:0:b029:18b:913e:9d1d with SMTP id s14-20020a62e70e0000b029018b913e9d1dmr180020pfh.47.1606949635776;
        Wed, 02 Dec 2020 14:53:55 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id i3sm39962pjs.34.2020.12.02.14.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:53:55 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v3 2/8] net-tcp: Introduce tcp_recvmsg_locked().
Date:   Wed,  2 Dec 2020 14:53:43 -0800
Message-Id: <20201202225349.935284-3-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
References: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
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

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

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

