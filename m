Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24732578B35
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbiGRTsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236321AbiGRTsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB75231DC3
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 12:48:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 393B46170A
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 19:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BBAC341D0;
        Mon, 18 Jul 2022 19:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658173710;
        bh=s6E/FmdFf7uYZwJleMpbevIzKUkMazRJEgfzE7WY2Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lV+RrDz/jzDiCSgzYl1jDf52h9RXspMUfZXVOyWeZpg6XtxV2usVp4Q7Fb/87qaMv
         ZgrRdkDkoFTKj6oR/Qgur92Gek3/zLKUGvn8D+Aax2Zm9f+9x3S0xRVxYc6kaKBxt+
         cnR/p9YiYq5fp53fHz+4I/b34ZCdBlrFS7pzssbNbCmFqq1RGoO62Z8mFtM+9GtZDb
         wZtlTbUhLX0PEEo86+jTiItvRphxOO9pKw1q2hhATi9fJkxHJZTpQL9V8rBUcalTHh
         9BZCMZtMkmdHjkRyau/wGp9YxeP/X8B/tnyIbe2ZJ2xEbaGhZR68Jig5Z0W4KI5RG0
         Zu19eS+zygDvg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Subject: [PATCH net-next 5/7] tcp: allow tls to decrypt directly from the tcp rcv queue
Date:   Mon, 18 Jul 2022 12:48:09 -0700
Message-Id: <20220718194811.1728061-6-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220718194811.1728061-1-kuba@kernel.org>
References: <20220718194811.1728061-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose TCP rx queue accessor and cleanup, so that TLS can
decrypt directly from the TCP queue. The expectation
is that the caller can access the skb returned from
tcp_recv_skb() and up to inq bytes worth of data (some
of which may be in ->next skbs) and then call
tcp_read_done() when data has been consumed.
The socket lock must be held continuously across
those two operations.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: yoshfuji@linux-ipv6.org
CC: dsahern@kernel.org
---
 include/net/tcp.h |  2 ++
 net/ipv4/tcp.c    | 44 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 8e48dc56837b..90340d66b731 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -673,6 +673,8 @@ void tcp_get_info(struct sock *, struct tcp_info *);
 int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		  sk_read_actor_t recv_actor);
 int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor);
+struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off);
+void tcp_read_done(struct sock *sk, size_t len);
 
 void tcp_initialize_rcv_mss(struct sock *sk);
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 96b6e9c22068..155251a6c5a6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1625,7 +1625,7 @@ static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
 	__kfree_skb(skb);
 }
 
-static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
+struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
 {
 	struct sk_buff *skb;
 	u32 offset;
@@ -1648,6 +1648,7 @@ static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(tcp_recv_skb);
 
 /*
  * This routine provides an alternative to tcp_recvmsg() for routines
@@ -1778,6 +1779,47 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 }
 EXPORT_SYMBOL(tcp_read_skb);
 
+void tcp_read_done(struct sock *sk, size_t len)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	u32 seq = tp->copied_seq;
+	struct sk_buff *skb;
+	size_t left;
+	u32 offset;
+
+	if (sk->sk_state == TCP_LISTEN)
+		return;
+
+	left = len;
+	while (left && (skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
+		int used;
+
+		used = min_t(size_t, skb->len - offset, left);
+		seq += used;
+		left -= used;
+
+		if (skb->len > offset + used)
+			break;
+
+		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
+			tcp_eat_recv_skb(sk, skb);
+			++seq;
+			break;
+		}
+		tcp_eat_recv_skb(sk, skb);
+	}
+	WRITE_ONCE(tp->copied_seq, seq);
+
+	tcp_rcv_space_adjust(sk);
+
+	/* Clean up data we have read: This will do ACK frames. */
+	if (left != len) {
+		tcp_recv_skb(sk, seq, &offset);
+		tcp_cleanup_rbuf(sk, len - left);
+	}
+}
+EXPORT_SYMBOL(tcp_read_done);
+
 int tcp_peek_len(struct socket *sock)
 {
 	return tcp_inq(sock->sk);
-- 
2.36.1

