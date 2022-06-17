Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990E954FE22
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 22:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240175AbiFQUK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiFQUKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:10:52 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B92B1ADA2
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 13:10:51 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id u18so4754927plb.3
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 13:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oNc045B7BLcIvVYAq03Rx5vnCQ+VNLfIq5DzBILiyAw=;
        b=ELlVSNfkJ0pfZHW4lXpMKiKCHaj6oTHzKfb2y9lwBzXK9KbYv6s1r76gjyy/ZEexg8
         0tiH5I4VKZLqMI5BiHEGq/Hs8EqtkdCu48Bby6G7ufPAMNDdOBUsRuJ9vqjscdZ/3e0Z
         T2RCGqDHHldlGAC3vBySMYPSWygEeWymnNeXdqSMOXgZbXgVDMTtIoE7w8OCZxQRnb1Q
         JJocee07eN/7cjt5Ipz/6wQTr7QzsoTapJXr21JuQz6aJgkZP/yVOxix0/mVkJ/EfTLl
         2KtvgFJHLoks9htUN3lnylqb+nd4CKrehCABlzxoLRnYS7rPN4B3yQQS8ToWwCjJsJ0G
         jN7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oNc045B7BLcIvVYAq03Rx5vnCQ+VNLfIq5DzBILiyAw=;
        b=Y90YJ7WkwslNUV6gd/x3BdSi3bBw9V63g9zIyprzwEX60797SkmkcneFiHL3z7CDAR
         Y1orpkwSjzQvnRhSnPzkqSSGcx2B+VgIMt6N7D9bNyCLeN6Xp1B4r3jV4cUCME5NU9u+
         MUrBpbOEL4/VARvz6y6XDfnN2Z3rfZql4XFQ8F3hTnuJ+o5/dMaeqWxnpjOq08gKjN8o
         VJvc9L8ULNucr35xSpFsVfxRt3hFB9dkjyDWl5qa09oLWpKZR4o/Z6R292xYO+77gbv+
         i4tD2GSA5beiCBXwLWvP7fGEzR8YGNKdGHF+/CYJzeUF4ps7jXRVa9jkVns29lLMT7kX
         TQHw==
X-Gm-Message-State: AJIora9+b1Wd6pxBVpu+fNuuS+p8ZFhAS+2KZYy5dVnjR/n2G7eA6aO5
        fskdL952eC1q2G5Doox3TpY=
X-Google-Smtp-Source: AGRyM1sm9/RSZV4qAtgTxch6CgDPR9/rx+W/VR66xepImPMJNDZFM8AWRJxqPKjqq7nkQFHPUHUqTQ==
X-Received: by 2002:a17:903:249:b0:168:ecca:43e with SMTP id j9-20020a170903024900b00168ecca043emr11672506plh.14.1655496650883;
        Fri, 17 Jun 2022 13:10:50 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d5d2:fc18:6baf:e16b])
        by smtp.gmail.com with ESMTPSA id ja14-20020a170902efce00b00168adae4ea2sm3931758plb.39.2022.06.17.13.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 13:10:50 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/2] raw: use more conventional iterators
Date:   Fri, 17 Jun 2022 13:10:44 -0700
Message-Id: <20220617201045.2659460-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220617201045.2659460-1-eric.dumazet@gmail.com>
References: <20220617201045.2659460-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

In order to prepare the following patch,
I change raw v4 & v6 code to use more conventional
iterators.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/raw.h   |   5 +--
 include/net/rawv6.h |   6 +--
 net/ipv4/raw.c      |  91 +++++++++++++------------------------
 net/ipv4/raw_diag.c |  33 +++++++-------
 net/ipv6/raw.c      | 107 ++++++++++++++++----------------------------
 5 files changed, 92 insertions(+), 150 deletions(-)

diff --git a/include/net/raw.h b/include/net/raw.h
index 8ad8df5948536483c3467bff68ec0796b0712e67..719d3556fc0a6a764b0072a76dac8c436c96d53d 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -20,9 +20,8 @@
 extern struct proto raw_prot;
 
 extern struct raw_hashinfo raw_v4_hashinfo;
-struct sock *__raw_v4_lookup(struct net *net, struct sock *sk,
-			     unsigned short num, __be32 raddr,
-			     __be32 laddr, int dif, int sdif);
+bool raw_v4_match(struct net *net, struct sock *sk, unsigned short num,
+		  __be32 raddr, __be32 laddr, int dif, int sdif);
 
 int raw_abort(struct sock *sk, int err);
 void raw_icmp_error(struct sk_buff *, int, u32);
diff --git a/include/net/rawv6.h b/include/net/rawv6.h
index 53d86b6055e8cceaf9b394e10fcff025b8c1b236..c48c1298699a049b907cd4b4e09c9b3f6a961d5b 100644
--- a/include/net/rawv6.h
+++ b/include/net/rawv6.h
@@ -5,9 +5,9 @@
 #include <net/protocol.h>
 
 extern struct raw_hashinfo raw_v6_hashinfo;
-struct sock *__raw_v6_lookup(struct net *net, struct sock *sk,
-			     unsigned short num, const struct in6_addr *loc_addr,
-			     const struct in6_addr *rmt_addr, int dif, int sdif);
+bool raw_v6_match(struct net *net, struct sock *sk, unsigned short num,
+		  const struct in6_addr *loc_addr,
+		  const struct in6_addr *rmt_addr, int dif, int sdif);
 
 int raw_abort(struct sock *sk, int err);
 
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index bbd717805b103e56f9c9343ffa45674d2a43e137..c194e758ea8b132966ef606afe8e63fef3db7075 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -117,24 +117,19 @@ void raw_unhash_sk(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(raw_unhash_sk);
 
-struct sock *__raw_v4_lookup(struct net *net, struct sock *sk,
-			     unsigned short num, __be32 raddr, __be32 laddr,
-			     int dif, int sdif)
+bool raw_v4_match(struct net *net, struct sock *sk, unsigned short num,
+		  __be32 raddr, __be32 laddr, int dif, int sdif)
 {
-	sk_for_each_from(sk) {
-		struct inet_sock *inet = inet_sk(sk);
+	struct inet_sock *inet = inet_sk(sk);
 
-		if (net_eq(sock_net(sk), net) && inet->inet_num == num	&&
-		    !(inet->inet_daddr && inet->inet_daddr != raddr) 	&&
-		    !(inet->inet_rcv_saddr && inet->inet_rcv_saddr != laddr) &&
-		    raw_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif))
-			goto found; /* gotcha */
-	}
-	sk = NULL;
-found:
-	return sk;
+	if (net_eq(sock_net(sk), net) && inet->inet_num == num	&&
+	    !(inet->inet_daddr && inet->inet_daddr != raddr) 	&&
+	    !(inet->inet_rcv_saddr && inet->inet_rcv_saddr != laddr) &&
+	    raw_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif))
+		return true;
+	return false;
 }
-EXPORT_SYMBOL_GPL(__raw_v4_lookup);
+EXPORT_SYMBOL_GPL(raw_v4_match);
 
 /*
  *	0 - deliver
@@ -168,23 +163,21 @@ static int icmp_filter(const struct sock *sk, const struct sk_buff *skb)
  */
 static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 {
+	struct net *net = dev_net(skb->dev);;
 	int sdif = inet_sdif(skb);
 	int dif = inet_iif(skb);
-	struct sock *sk;
 	struct hlist_head *head;
 	int delivered = 0;
-	struct net *net;
+	struct sock *sk;
 
-	read_lock(&raw_v4_hashinfo.lock);
 	head = &raw_v4_hashinfo.ht[hash];
 	if (hlist_empty(head))
-		goto out;
-
-	net = dev_net(skb->dev);
-	sk = __raw_v4_lookup(net, __sk_head(head), iph->protocol,
-			     iph->saddr, iph->daddr, dif, sdif);
-
-	while (sk) {
+		return 0;
+	read_lock(&raw_v4_hashinfo.lock);
+	sk_for_each(sk, head) {
+		if (!raw_v4_match(net, sk, iph->protocol,
+				  iph->saddr, iph->daddr, dif, sdif))
+			continue;
 		delivered = 1;
 		if ((iph->protocol != IPPROTO_ICMP || !icmp_filter(sk, skb)) &&
 		    ip_mc_sf_allow(sk, iph->daddr, iph->saddr,
@@ -195,31 +188,16 @@ static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 			if (clone)
 				raw_rcv(sk, clone);
 		}
-		sk = __raw_v4_lookup(net, sk_next(sk), iph->protocol,
-				     iph->saddr, iph->daddr,
-				     dif, sdif);
 	}
-out:
 	read_unlock(&raw_v4_hashinfo.lock);
 	return delivered;
 }
 
 int raw_local_deliver(struct sk_buff *skb, int protocol)
 {
-	int hash;
-	struct sock *raw_sk;
-
-	hash = protocol & (RAW_HTABLE_SIZE - 1);
-	raw_sk = sk_head(&raw_v4_hashinfo.ht[hash]);
-
-	/* If there maybe a raw socket we must check - if not we
-	 * don't care less
-	 */
-	if (raw_sk && !raw_v4_input(skb, ip_hdr(skb), hash))
-		raw_sk = NULL;
-
-	return raw_sk != NULL;
+	int hash = protocol & (RAW_HTABLE_SIZE - 1);
 
+	return raw_v4_input(skb, ip_hdr(skb), hash);
 }
 
 static void raw_err(struct sock *sk, struct sk_buff *skb, u32 info)
@@ -286,29 +264,24 @@ static void raw_err(struct sock *sk, struct sk_buff *skb, u32 info)
 
 void raw_icmp_error(struct sk_buff *skb, int protocol, u32 info)
 {
-	int hash;
-	struct sock *raw_sk;
+	struct net *net = dev_net(skb->dev);;
+	int dif = skb->dev->ifindex;
+	int sdif = inet_sdif(skb);
+	struct hlist_head *head;
 	const struct iphdr *iph;
-	struct net *net;
+	struct sock *sk;
+	int hash;
 
 	hash = protocol & (RAW_HTABLE_SIZE - 1);
+	head = &raw_v4_hashinfo.ht[hash];
 
 	read_lock(&raw_v4_hashinfo.lock);
-	raw_sk = sk_head(&raw_v4_hashinfo.ht[hash]);
-	if (raw_sk) {
-		int dif = skb->dev->ifindex;
-		int sdif = inet_sdif(skb);
-
+	sk_for_each(sk, head) {
 		iph = (const struct iphdr *)skb->data;
-		net = dev_net(skb->dev);
-
-		while ((raw_sk = __raw_v4_lookup(net, raw_sk, protocol,
-						iph->daddr, iph->saddr,
-						dif, sdif)) != NULL) {
-			raw_err(raw_sk, skb, info);
-			raw_sk = sk_next(raw_sk);
-			iph = (const struct iphdr *)skb->data;
-		}
+		if (!raw_v4_match(net, sk, iph->protocol,
+				  iph->saddr, iph->daddr, dif, sdif))
+			continue;
+		raw_err(sk, skb, info);
 	}
 	read_unlock(&raw_v4_hashinfo.lock);
 }
diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index ccacbde30a2c50b7d05a1729cb6b56542866ab82..b6d92dc7b051d1ccf2df50689d041251d0745430 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -34,31 +34,30 @@ raw_get_hashinfo(const struct inet_diag_req_v2 *r)
  * use helper to figure it out.
  */
 
-static struct sock *raw_lookup(struct net *net, struct sock *from,
-			       const struct inet_diag_req_v2 *req)
+static bool raw_lookup(struct net *net, struct sock *sk,
+		       const struct inet_diag_req_v2 *req)
 {
 	struct inet_diag_req_raw *r = (void *)req;
-	struct sock *sk = NULL;
 
 	if (r->sdiag_family == AF_INET)
-		sk = __raw_v4_lookup(net, from, r->sdiag_raw_protocol,
-				     r->id.idiag_dst[0],
-				     r->id.idiag_src[0],
-				     r->id.idiag_if, 0);
+		return raw_v4_match(net, sk, r->sdiag_raw_protocol,
+				    r->id.idiag_dst[0],
+				    r->id.idiag_src[0],
+				    r->id.idiag_if, 0);
 #if IS_ENABLED(CONFIG_IPV6)
 	else
-		sk = __raw_v6_lookup(net, from, r->sdiag_raw_protocol,
-				     (const struct in6_addr *)r->id.idiag_src,
-				     (const struct in6_addr *)r->id.idiag_dst,
-				     r->id.idiag_if, 0);
+		return raw_v6_match(net, sk, r->sdiag_raw_protocol,
+				    (const struct in6_addr *)r->id.idiag_src,
+				    (const struct in6_addr *)r->id.idiag_dst,
+				    r->id.idiag_if, 0);
 #endif
-	return sk;
+	return false;
 }
 
 static struct sock *raw_sock_get(struct net *net, const struct inet_diag_req_v2 *r)
 {
 	struct raw_hashinfo *hashinfo = raw_get_hashinfo(r);
-	struct sock *sk = NULL, *s;
+	struct sock *sk;
 	int slot;
 
 	if (IS_ERR(hashinfo))
@@ -66,9 +65,8 @@ static struct sock *raw_sock_get(struct net *net, const struct inet_diag_req_v2
 
 	read_lock(&hashinfo->lock);
 	for (slot = 0; slot < RAW_HTABLE_SIZE; slot++) {
-		sk_for_each(s, &hashinfo->ht[slot]) {
-			sk = raw_lookup(net, s, r);
-			if (sk) {
+		sk_for_each(sk, &hashinfo->ht[slot]) {
+			if (raw_lookup(net, sk, r)) {
 				/*
 				 * Grab it and keep until we fill
 				 * diag meaage to be reported, so
@@ -81,10 +79,11 @@ static struct sock *raw_sock_get(struct net *net, const struct inet_diag_req_v2
 			}
 		}
 	}
+	sk = ERR_PTR(-ENOENT);
 out_unlock:
 	read_unlock(&hashinfo->lock);
 
-	return sk ? sk : ERR_PTR(-ENOENT);
+	return sk;
 }
 
 static int raw_diag_dump_one(struct netlink_callback *cb,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 3b7cbd522b5483e7cf0d17a3d3533839481515bc..c0f2e34759846562dddba24b4de8970dc4b4db89 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -66,41 +66,27 @@ struct raw_hashinfo raw_v6_hashinfo = {
 };
 EXPORT_SYMBOL_GPL(raw_v6_hashinfo);
 
-struct sock *__raw_v6_lookup(struct net *net, struct sock *sk,
-		unsigned short num, const struct in6_addr *loc_addr,
-		const struct in6_addr *rmt_addr, int dif, int sdif)
+bool raw_v6_match(struct net *net, struct sock *sk, unsigned short num,
+		  const struct in6_addr *loc_addr,
+		  const struct in6_addr *rmt_addr, int dif, int sdif)
 {
-	bool is_multicast = ipv6_addr_is_multicast(loc_addr);
-
-	sk_for_each_from(sk)
-		if (inet_sk(sk)->inet_num == num) {
-
-			if (!net_eq(sock_net(sk), net))
-				continue;
-
-			if (!ipv6_addr_any(&sk->sk_v6_daddr) &&
-			    !ipv6_addr_equal(&sk->sk_v6_daddr, rmt_addr))
-				continue;
-
-			if (!raw_sk_bound_dev_eq(net, sk->sk_bound_dev_if,
-						 dif, sdif))
-				continue;
-
-			if (!ipv6_addr_any(&sk->sk_v6_rcv_saddr)) {
-				if (ipv6_addr_equal(&sk->sk_v6_rcv_saddr, loc_addr))
-					goto found;
-				if (is_multicast &&
-				    inet6_mc_check(sk, loc_addr, rmt_addr))
-					goto found;
-				continue;
-			}
-			goto found;
-		}
-	sk = NULL;
-found:
-	return sk;
+	if (inet_sk(sk)->inet_num != num ||
+	    !net_eq(sock_net(sk), net) ||
+	    (!ipv6_addr_any(&sk->sk_v6_daddr) &&
+	     !ipv6_addr_equal(&sk->sk_v6_daddr, rmt_addr)) ||
+	    !raw_sk_bound_dev_eq(net, sk->sk_bound_dev_if,
+				 dif, sdif))
+		return false;
+
+	if (ipv6_addr_any(&sk->sk_v6_rcv_saddr) ||
+	    ipv6_addr_equal(&sk->sk_v6_rcv_saddr, loc_addr) ||
+	    (ipv6_addr_is_multicast(loc_addr) &&
+	     inet6_mc_check(sk, loc_addr, rmt_addr)))
+		return true;
+
+	return false;
 }
-EXPORT_SYMBOL_GPL(__raw_v6_lookup);
+EXPORT_SYMBOL_GPL(raw_v6_match);
 
 /*
  *	0 - deliver
@@ -156,31 +142,28 @@ EXPORT_SYMBOL(rawv6_mh_filter_unregister);
  */
 static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 {
+	struct net *net = dev_net(skb->dev);
 	const struct in6_addr *saddr;
 	const struct in6_addr *daddr;
+	struct hlist_head *head;
 	struct sock *sk;
 	bool delivered = false;
 	__u8 hash;
-	struct net *net;
 
 	saddr = &ipv6_hdr(skb)->saddr;
 	daddr = saddr + 1;
 
 	hash = nexthdr & (RAW_HTABLE_SIZE - 1);
-
+	head = &raw_v6_hashinfo.ht[hash];
+	if (hlist_empty(head))
+		return false;
 	read_lock(&raw_v6_hashinfo.lock);
-	sk = sk_head(&raw_v6_hashinfo.ht[hash]);
-
-	if (!sk)
-		goto out;
-
-	net = dev_net(skb->dev);
-	sk = __raw_v6_lookup(net, sk, nexthdr, daddr, saddr,
-			     inet6_iif(skb), inet6_sdif(skb));
-
-	while (sk) {
+	sk_for_each(sk, head) {
 		int filtered;
 
+		if (!raw_v6_match(net, sk, nexthdr, daddr, saddr,
+				  inet6_iif(skb), inet6_sdif(skb)))
+			continue;
 		delivered = true;
 		switch (nexthdr) {
 		case IPPROTO_ICMPV6:
@@ -219,23 +202,14 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 				rawv6_rcv(sk, clone);
 			}
 		}
-		sk = __raw_v6_lookup(net, sk_next(sk), nexthdr, daddr, saddr,
-				     inet6_iif(skb), inet6_sdif(skb));
 	}
-out:
 	read_unlock(&raw_v6_hashinfo.lock);
 	return delivered;
 }
 
 bool raw6_local_deliver(struct sk_buff *skb, int nexthdr)
 {
-	struct sock *raw_sk;
-
-	raw_sk = sk_head(&raw_v6_hashinfo.ht[nexthdr & (RAW_HTABLE_SIZE - 1)]);
-	if (raw_sk && !ipv6_raw_deliver(skb, nexthdr))
-		raw_sk = NULL;
-
-	return raw_sk != NULL;
+	return ipv6_raw_deliver(skb, nexthdr);
 }
 
 /* This cleans up af_inet6 a bit. -DaveM */
@@ -361,28 +335,25 @@ static void rawv6_err(struct sock *sk, struct sk_buff *skb,
 void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 		u8 type, u8 code, int inner_offset, __be32 info)
 {
-	struct sock *sk;
-	int hash;
 	const struct in6_addr *saddr, *daddr;
-	struct net *net;
+	struct net *net = dev_net(skb->dev);
+	struct hlist_head *head;
+	struct sock *sk;
+	int hash;
 
 	hash = nexthdr & (RAW_HTABLE_SIZE - 1);
-
+	head = &raw_v6_hashinfo.ht[hash];
 	read_lock(&raw_v6_hashinfo.lock);
-	sk = sk_head(&raw_v6_hashinfo.ht[hash]);
-	if (sk) {
+	sk_for_each(sk, head) {
 		/* Note: ipv6_hdr(skb) != skb->data */
 		const struct ipv6hdr *ip6h = (const struct ipv6hdr *)skb->data;
 		saddr = &ip6h->saddr;
 		daddr = &ip6h->daddr;
-		net = dev_net(skb->dev);
 
-		while ((sk = __raw_v6_lookup(net, sk, nexthdr, saddr, daddr,
-					     inet6_iif(skb), inet6_iif(skb)))) {
-			rawv6_err(sk, skb, NULL, type, code,
-					inner_offset, info);
-			sk = sk_next(sk);
-		}
+		if (!raw_v6_match(net, sk, nexthdr, &ip6h->saddr, &ip6h->daddr,
+				  inet6_iif(skb), inet6_iif(skb)))
+			continue;
+		rawv6_err(sk, skb, NULL, type, code, inner_offset, info);
 	}
 	read_unlock(&raw_v6_hashinfo.lock);
 }
-- 
2.36.1.476.g0c4daa206d-goog

