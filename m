Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202B312D4C9
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 23:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfL3WTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 17:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727732AbfL3WTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 17:19:34 -0500
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 969FD20748;
        Mon, 30 Dec 2019 22:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577743879;
        bh=p9lfYrkdMI4Gr0Y8lklDv6uWHe9WvEiC3aiYck8Vseg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xs+ShqqPrHy2IYImdNpZ2CaqXAczbNw33xjR/VcJ07RzXoNRWHaVuC/qAQXkxYYHe
         HutMFy7+SSsN6eBvwl5WS5yClPnr2fPXNwYa4ljRnt2g0Bi404f27zIebxPjTf6PbY
         +Xn4gfr84XnJBQlSWFd05p+exxH9AJCkGfVWami0=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        roopa@cumulusnetworks.com, sharpd@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 3/9] ipv4/tcp: Pass dif and sdif to tcp_v4_inbound_md5_hash
Date:   Mon, 30 Dec 2019 14:14:27 -0800
Message-Id: <20191230221433.2717-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230221433.2717-1-dsahern@kernel.org>
References: <20191230221433.2717-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The original ingress device index is saved to the cb space of the skb
and the cb is moved during tcp processing. Since tcp_v4_inbound_md5_hash
can be called before and after the cb move, pass dif and sdif to it so
the caller can save both prior to the cb move. Both are used by a later
patch.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/tcp_ipv4.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c2bfff528578..93f220793add 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -707,6 +707,8 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		key = tcp_md5_do_lookup(sk, addr, AF_INET);
 	} else if (hash_location) {
 		const union tcp_md5_addr *addr;
+		int sdif = tcp_v4_sdif(skb);
+		int dif = inet_iif(skb);
 
 		/*
 		 * active side is lost. Try to find listening socket through
@@ -718,8 +720,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		sk1 = __inet_lookup_listener(net, &tcp_hashinfo, NULL, 0,
 					     ip_hdr(skb)->saddr,
 					     th->source, ip_hdr(skb)->daddr,
-					     ntohs(th->source), inet_iif(skb),
-					     tcp_v4_sdif(skb));
+					     ntohs(th->source), dif, sdif);
 		/* don't send rst if it can't find key */
 		if (!sk1)
 			goto out;
@@ -1293,7 +1294,8 @@ EXPORT_SYMBOL(tcp_v4_md5_hash_skb);
 
 /* Called with rcu_read_lock() */
 static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
-				    const struct sk_buff *skb)
+				    const struct sk_buff *skb,
+				    int dif, int sdif)
 {
 #ifdef CONFIG_TCP_MD5SIG
 	/*
@@ -1817,6 +1819,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	struct net *net = dev_net(skb->dev);
 	struct sk_buff *skb_to_free;
 	int sdif = inet_sdif(skb);
+	int dif = inet_iif(skb);
 	const struct iphdr *iph;
 	const struct tcphdr *th;
 	bool refcounted;
@@ -1865,7 +1868,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (unlikely(tcp_v4_inbound_md5_hash(sk, skb))) {
+		if (unlikely(tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
@@ -1923,7 +1926,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
 
-	if (tcp_v4_inbound_md5_hash(sk, skb))
+	if (tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))
 		goto discard_and_relse;
 
 	nf_reset_ct(skb);
-- 
2.11.0

