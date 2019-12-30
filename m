Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E7B12D4CD
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 23:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfL3WTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 17:19:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727746AbfL3WTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 17:19:35 -0500
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54B8A20730;
        Mon, 30 Dec 2019 22:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577743879;
        bh=wn583Le/XzBXpq127fONgoGuYTVvklSxaHWqyNK1Acg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6NESb/szWiywnzxDInKOkGvPUsWDckhUGsuhaXOvk8hmVlUBza+RjdyCxYCbsi+5
         t+hmQy3x5Abj6+G1zXSilTslwb1rXmIolWJUr9hVlNn0s4VoRZk2dVl40sSPoNIO0I
         6yo1dbOmtTwC+1fA800nwCFT+8IqijGRVQF8BC5Q=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        roopa@cumulusnetworks.com, sharpd@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 2/9] ipv6/tcp: Pass dif and sdif to tcp_v6_inbound_md5_hash
Date:   Mon, 30 Dec 2019 14:14:26 -0800
Message-Id: <20191230221433.2717-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230221433.2717-1-dsahern@kernel.org>
References: <20191230221433.2717-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The original ingress device index is saved to the cb space of the skb
and the cb is moved during tcp processing. Since tcp_v6_inbound_md5_hash
can be called before and after the cb move, pass dif and sdif to it so
the caller can save both prior to the cb move. Both are used by a later
patch.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/tcp_ipv6.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index df5fd9109696..e94f23b61b62 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -698,7 +698,8 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 #endif
 
 static bool tcp_v6_inbound_md5_hash(const struct sock *sk,
-				    const struct sk_buff *skb)
+				    const struct sk_buff *skb,
+				    int dif, int sdif)
 {
 #ifdef CONFIG_TCP_MD5SIG
 	const __u8 *hash_location = NULL;
@@ -953,6 +954,9 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	if (sk && sk_fullsock(sk)) {
 		key = tcp_v6_md5_do_lookup(sk, &ipv6h->saddr);
 	} else if (hash_location) {
+		int dif = tcp_v6_iif_l3_slave(skb);
+		int sdif = tcp_v6_sdif(skb);
+
 		/*
 		 * active side is lost. Try to find listening socket through
 		 * source port, and then find md5 key through listening socket.
@@ -964,9 +968,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 					   &tcp_hashinfo, NULL, 0,
 					   &ipv6h->saddr,
 					   th->source, &ipv6h->daddr,
-					   ntohs(th->source),
-					   tcp_v6_iif_l3_slave(skb),
-					   tcp_v6_sdif(skb));
+					   ntohs(th->source), dif, sdif);
 		if (!sk1)
 			goto out;
 
@@ -1480,6 +1482,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 {
 	struct sk_buff *skb_to_free;
 	int sdif = inet6_sdif(skb);
+	int dif = inet6_iif(skb);
 	const struct tcphdr *th;
 	const struct ipv6hdr *hdr;
 	bool refcounted;
@@ -1528,7 +1531,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (tcp_v6_inbound_md5_hash(sk, skb)) {
+		if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif)) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
@@ -1583,7 +1586,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
 
-	if (tcp_v6_inbound_md5_hash(sk, skb))
+	if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif))
 		goto discard_and_relse;
 
 	if (tcp_filter(sk, skb))
-- 
2.11.0

