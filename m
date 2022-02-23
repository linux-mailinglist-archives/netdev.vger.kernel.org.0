Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6DF4C1A54
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243594AbiBWR6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235343AbiBWR6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:58:13 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DD23C722
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:57:44 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id f17so16093326wrh.7
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kuUqmR8e7tBubJrcnRiXKu14uUHymMXzEtqn26wDjMY=;
        b=QhGw0Es2gc9ImVcPAlWRojvH+QkoFfEB4c1LkFu5CQCMAFTrUXc84KlEJbD47+g9K8
         iEbjrwBOm474BrkkrVrrgiHuVUn0ce25EHPmCVJay8FvArm0H2OPR31R+Rq+FWKgPbl/
         GTpRCmpC0O9U3AWyJJWxvbv4C8AQo0+JzQpluVvY7AxtnFkYA3JZKow1E4pDW+UoiVJ0
         FwHD0sGp1KHse/XVx5Bei0LS+G3UwGPj/hP4rBWZyUKsMRlkrl+6PG3UCgt5HNB+/j56
         jYXzWqyOxkmNhHzxZ+S9BrK/KZv9NpZnLcej+AtpA+wPbC5RPhqElObf+tqMu7Sztx3L
         gHLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kuUqmR8e7tBubJrcnRiXKu14uUHymMXzEtqn26wDjMY=;
        b=FKDL5rK+rC5N30OXENn3NYzR5UUEdr6C0SK9OXDOkBaNWjf4V6j3ldoW0HwFspZKLg
         cpZ2cyMlOdBsnJQgRcb91vgcE+FJZ6M85nDNK3U23Y6+YQDEJx7dsj5aicaHiXbFb0dn
         gx8CU7mJhUEWeJsoJgbTc4fJXmadBKgblUj+VaD+FeZPXQrmPDjo9lLk6yQXWBYbQJJy
         U346lLiKRRFQZsf0FnZjzZTCmoV2QUWalpceZ06eGLaAfiY2szLoy7FsiUA5dz4wjOV6
         mUe1ElVl2W2WXL5hAMwXqWrK6usAogS8dleSfVAlrYDKNs3Qb7c9I3lPqoIJ9v2BMtVt
         B/sg==
X-Gm-Message-State: AOAM531FS2ne3jmQdGneF8dCW9NqLtMich80UyQdEdZlza0nvf1EILQj
        b2q4AedZ6RzcEhaDcO1ww4wdbQ==
X-Google-Smtp-Source: ABdhPJy4uBHgzpoUQ4QYxRcrXcf5E4zECHbW6Wad2kS7WGXbh0uoVAIC2dgI59wf5MB9kzlpmFZhnw==
X-Received: by 2002:a5d:64ec:0:b0:1e6:8d72:b8af with SMTP id g12-20020a5d64ec000000b001e68d72b8afmr572362wri.165.1645639062502;
        Wed, 23 Feb 2022 09:57:42 -0800 (PST)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id g16-20020a7bc4d0000000b0037bbe255339sm414482wmk.15.2022.02.23.09.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 09:57:42 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v3] net/tcp: Merge TCP-MD5 inbound callbacks
Date:   Wed, 23 Feb 2022 17:57:40 +0000
Message-Id: <20220223175740.452397-1-dima@arista.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions do essentially the same work to verify TCP-MD5 sign.
Code can be merged into one family-independent function in order to
reduce copy'n'paste and generated code.
Later with TCP-AO option added, this will allow to create one function
that's responsible for segment verification, that will have all the
different checks for MD5/AO/non-signed packets, which in turn will help
to see checks for all corner-cases in one function, rather than spread
around different families and functions.

Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
v2: Rebased on net-next
v3: Correct rebase on net-next for !CONFIG_TCP_MD5

 include/net/tcp.h   | 13 ++++++++
 net/ipv4/tcp.c      | 70 ++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c | 78 +++------------------------------------------
 net/ipv6/tcp_ipv6.c | 62 +++--------------------------------
 4 files changed, 92 insertions(+), 131 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 04f4650e0ff0..479a27777ad6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1674,6 +1674,11 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 		return NULL;
 	return __tcp_md5_do_lookup(sk, l3index, addr, family);
 }
+bool tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
+			  enum skb_drop_reason *reason,
+			  const void *saddr, const void *daddr,
+			  int family, int dif, int sdif);
+
 
 #define tcp_twsk_md5_key(twsk)	((twsk)->tw_md5_key)
 #else
@@ -1683,6 +1688,14 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 {
 	return NULL;
 }
+static inline bool tcp_inbound_md5_hash(const struct sock *sk,
+					const struct sk_buff *skb,
+					enum skb_drop_reason *reason,
+					const void *saddr, const void *daddr,
+					int family, int dif, int sdif)
+{
+	return false;
+}
 #define tcp_twsk_md5_key(twsk)	NULL
 #endif
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 760e8221d321..68f1236b2858 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4431,6 +4431,76 @@ int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *ke
 }
 EXPORT_SYMBOL(tcp_md5_hash_key);
 
+/* Called with rcu_read_lock() */
+bool tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
+			  enum skb_drop_reason *reason,
+			  const void *saddr, const void *daddr,
+			  int family, int dif, int sdif)
+{
+	/*
+	 * This gets called for each TCP segment that arrives
+	 * so we want to be efficient.
+	 * We have 3 drop cases:
+	 * o No MD5 hash and one expected.
+	 * o MD5 hash and we're not expecting one.
+	 * o MD5 hash and its wrong.
+	 */
+	const __u8 *hash_location = NULL;
+	struct tcp_md5sig_key *hash_expected;
+	const struct tcphdr *th = tcp_hdr(skb);
+	struct tcp_sock *tp = tcp_sk(sk);
+	int genhash, l3index;
+	u8 newhash[16];
+
+	/* sdif set, means packet ingressed via a device
+	 * in an L3 domain and dif is set to the l3mdev
+	 */
+	l3index = sdif ? dif : 0;
+
+	hash_expected = tcp_md5_do_lookup(sk, l3index, saddr, family);
+	hash_location = tcp_parse_md5sig_option(th);
+
+	/* We've parsed the options - do we have a hash? */
+	if (!hash_expected && !hash_location)
+		return false;
+
+	if (hash_expected && !hash_location) {
+		*reason = SKB_DROP_REASON_TCP_MD5NOTFOUND;
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
+		return true;
+	}
+
+	if (!hash_expected && hash_location) {
+		*reason = SKB_DROP_REASON_TCP_MD5UNEXPECTED;
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
+		return true;
+	}
+
+	/* check the signature */
+	genhash = tp->af_specific->calc_md5_hash(newhash, hash_expected,
+						 NULL, skb);
+
+	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
+		*reason = SKB_DROP_REASON_TCP_MD5FAILURE;
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
+		if (family == AF_INET) {
+			net_info_ratelimited("MD5 Hash failed for (%pI4, %d)->(%pI4, %d)%s L3 index %d\n",
+					saddr, ntohs(th->source),
+					daddr, ntohs(th->dest),
+					genhash ? " tcp_v4_calc_md5_hash failed"
+					: "", l3index);
+		} else {
+			net_info_ratelimited("MD5 Hash %s for [%pI6c]:%u->[%pI6c]:%u L3 index %d\n",
+					genhash ? "failed" : "mismatch",
+					saddr, ntohs(th->source),
+					daddr, ntohs(th->dest), l3index);
+		}
+		return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL(tcp_inbound_md5_hash);
+
 #endif
 
 void tcp_done(struct sock *sk)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d42824aedc36..411357ad9757 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1409,76 +1409,6 @@ EXPORT_SYMBOL(tcp_v4_md5_hash_skb);
 
 #endif
 
-/* Called with rcu_read_lock() */
-static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
-				    const struct sk_buff *skb,
-				    int dif, int sdif,
-				    enum skb_drop_reason *reason)
-{
-#ifdef CONFIG_TCP_MD5SIG
-	/*
-	 * This gets called for each TCP segment that arrives
-	 * so we want to be efficient.
-	 * We have 3 drop cases:
-	 * o No MD5 hash and one expected.
-	 * o MD5 hash and we're not expecting one.
-	 * o MD5 hash and its wrong.
-	 */
-	const __u8 *hash_location = NULL;
-	struct tcp_md5sig_key *hash_expected;
-	const struct iphdr *iph = ip_hdr(skb);
-	const struct tcphdr *th = tcp_hdr(skb);
-	const union tcp_md5_addr *addr;
-	unsigned char newhash[16];
-	int genhash, l3index;
-
-	/* sdif set, means packet ingressed via a device
-	 * in an L3 domain and dif is set to the l3mdev
-	 */
-	l3index = sdif ? dif : 0;
-
-	addr = (union tcp_md5_addr *)&iph->saddr;
-	hash_expected = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
-	hash_location = tcp_parse_md5sig_option(th);
-
-	/* We've parsed the options - do we have a hash? */
-	if (!hash_expected && !hash_location)
-		return false;
-
-	if (hash_expected && !hash_location) {
-		*reason = SKB_DROP_REASON_TCP_MD5NOTFOUND;
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
-		return true;
-	}
-
-	if (!hash_expected && hash_location) {
-		*reason = SKB_DROP_REASON_TCP_MD5UNEXPECTED;
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
-		return true;
-	}
-
-	/* Okay, so this is hash_expected and hash_location -
-	 * so we need to calculate the checksum.
-	 */
-	genhash = tcp_v4_md5_hash_skb(newhash,
-				      hash_expected,
-				      NULL, skb);
-
-	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
-		*reason = SKB_DROP_REASON_TCP_MD5FAILURE;
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
-		net_info_ratelimited("MD5 Hash failed for (%pI4, %d)->(%pI4, %d)%s L3 index %d\n",
-				     &iph->saddr, ntohs(th->source),
-				     &iph->daddr, ntohs(th->dest),
-				     genhash ? " tcp_v4_calc_md5_hash failed"
-				     : "", l3index);
-		return true;
-	}
-	return false;
-#endif
-	return false;
-}
-
 static void tcp_v4_init_req(struct request_sock *req,
 			    const struct sock *sk_listener,
 			    struct sk_buff *skb)
@@ -2035,8 +1965,9 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (unlikely(tcp_v4_inbound_md5_hash(sk, skb, dif, sdif,
-						     &drop_reason))) {
+		if (unlikely(tcp_inbound_md5_hash(sk, skb, &drop_reason,
+						  &iph->saddr, &iph->daddr,
+						  AF_INET, dif, sdif))) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
@@ -2110,7 +2041,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 	}
 
-	if (tcp_v4_inbound_md5_hash(sk, skb, dif, sdif, &drop_reason))
+	if (tcp_inbound_md5_hash(sk, skb, &drop_reason, &iph->saddr,
+				 &iph->daddr, AF_INET, dif, sdif))
 		goto discard_and_relse;
 
 	nf_reset_ct(skb);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 749de8529c83..e98af869ff3a 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -773,61 +773,6 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 
 #endif
 
-static bool tcp_v6_inbound_md5_hash(const struct sock *sk,
-				    const struct sk_buff *skb,
-				    int dif, int sdif,
-				    enum skb_drop_reason *reason)
-{
-#ifdef CONFIG_TCP_MD5SIG
-	const __u8 *hash_location = NULL;
-	struct tcp_md5sig_key *hash_expected;
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
-	const struct tcphdr *th = tcp_hdr(skb);
-	int genhash, l3index;
-	u8 newhash[16];
-
-	/* sdif set, means packet ingressed via a device
-	 * in an L3 domain and dif is set to the l3mdev
-	 */
-	l3index = sdif ? dif : 0;
-
-	hash_expected = tcp_v6_md5_do_lookup(sk, &ip6h->saddr, l3index);
-	hash_location = tcp_parse_md5sig_option(th);
-
-	/* We've parsed the options - do we have a hash? */
-	if (!hash_expected && !hash_location)
-		return false;
-
-	if (hash_expected && !hash_location) {
-		*reason = SKB_DROP_REASON_TCP_MD5NOTFOUND;
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
-		return true;
-	}
-
-	if (!hash_expected && hash_location) {
-		*reason = SKB_DROP_REASON_TCP_MD5UNEXPECTED;
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
-		return true;
-	}
-
-	/* check the signature */
-	genhash = tcp_v6_md5_hash_skb(newhash,
-				      hash_expected,
-				      NULL, skb);
-
-	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
-		*reason = SKB_DROP_REASON_TCP_MD5FAILURE;
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
-		net_info_ratelimited("MD5 Hash %s for [%pI6c]:%u->[%pI6c]:%u L3 index %d\n",
-				     genhash ? "failed" : "mismatch",
-				     &ip6h->saddr, ntohs(th->source),
-				     &ip6h->daddr, ntohs(th->dest), l3index);
-		return true;
-	}
-#endif
-	return false;
-}
-
 static void tcp_v6_init_req(struct request_sock *req,
 			    const struct sock *sk_listener,
 			    struct sk_buff *skb)
@@ -1687,8 +1632,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif,
-					    &drop_reason)) {
+		if (tcp_inbound_md5_hash(sk, skb, &drop_reason, &hdr->saddr,
+					 &hdr->daddr, AF_INET6, dif, sdif)) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
@@ -1759,7 +1704,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 	}
 
-	if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif, &drop_reason))
+	if (tcp_inbound_md5_hash(sk, skb, &drop_reason, &hdr->saddr,
+				 &hdr->daddr, AF_INET6, dif, sdif))
 		goto discard_and_relse;
 
 	if (tcp_filter(sk, skb)) {

base-commit: 922ea87ff6f2b63f413c6afa2c25b287dce76639
prerequisite-patch-id: f4dc7ba51eadb9fccabb755c41854bedeeaf8954
-- 
2.35.1

