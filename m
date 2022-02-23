Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6624C1297
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240426AbiBWMST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240419AbiBWMSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:18:18 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CE09E9D9
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:17:50 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id d28so11533764wra.4
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AcFlk5NLo4FXRllcKSpbB7UHXIeMkr/gx8QJaFZjkzo=;
        b=hs1THwKZ7T7H2frd5gsuHEYyP1/BhO3xo0caGPCDJJWJ5q/Jc+KI1o+Vl6YVLJP/Cx
         GheQEFQT4vV81r89PzsBIJQdiAcG7xgA60FgJFdktV3giInXemsXl67lui9azxEVlvh3
         u5nloWrtzrTCqSTsHkUpd37NlzlcbUuFL2mxf72HThDjJ/o+A4T6p2CTyw7Fk3pO9U3t
         3h7p9QHrBWxc3vm6xwZMCtag5KUbgcqTsyWh/OCAKocyrX9vCHjUp0myhJ8pQ0r9e92M
         mYPQhsPv6f1mJeP+YSae6lAaE8mgRwoymwifANPE2epgYZjo5+x38Ry+a/SCR/8x3uEo
         ++lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AcFlk5NLo4FXRllcKSpbB7UHXIeMkr/gx8QJaFZjkzo=;
        b=S3bjs7lSkPB0CqWWuAuOGHnPPqR6Wo1fpZfad9TNggYngxuj5/B6UrBYRn2rV3berg
         mbU04qqHVCw9lDfDRSfMBinIdeJaxfBaCAPqDMNBGkjycpkeyI2Ozg12TkO1XVeAKoAY
         jJyhjFRtV54BhUF6Y74Bp5PibupHuF4etcmoPjzXhrvI6gBF62KYz2hTKMOTVA6asApY
         mxk/tvGTvpHwL+UB6TJSX/0GqT2Vuzb2GymDJnUEUjkg/xc4YvWnofFQySo+3kgbZIhc
         bta4EFdth85aLVZ2jYZb46lTro7byyPimec2uylkkvjLMURr1Ry1Bbg75YlaL4OeRf2I
         TOYA==
X-Gm-Message-State: AOAM530Z07NfWnbg36qv9jxAtPgcD7fRBeEImRb6fAstMZ/cpuH9Cxt1
        Fh9YloYsgFIUnohTvqk2G+Kjqg==
X-Google-Smtp-Source: ABdhPJwBcpy7TJ4/gwQstdhpgOGMrIgE5F/y1IWH6yqA1qdL8QAQVi/4uICOUmVXtdbGTtIqfU9/VA==
X-Received: by 2002:a5d:64ac:0:b0:1e7:1415:2548 with SMTP id m12-20020a5d64ac000000b001e714152548mr23575408wrp.267.1645618668611;
        Wed, 23 Feb 2022 04:17:48 -0800 (PST)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id u15sm68958630wrs.18.2022.02.23.04.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 04:17:48 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2] net/tcp: Merge TCP-MD5 inbound callbacks
Date:   Wed, 23 Feb 2022 12:17:46 +0000
Message-Id: <20220223121746.421327-1-dima@arista.com>
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

 include/net/tcp.h   | 12 +++++++
 net/ipv4/tcp.c      | 70 ++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c | 78 +++------------------------------------------
 net/ipv6/tcp_ipv6.c | 62 +++--------------------------------
 4 files changed, 91 insertions(+), 131 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 04f4650e0ff0..2e60864d7865 100644
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
@@ -1683,6 +1688,13 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 {
 	return NULL;
 }
+static inline bool tcp_inbound_md5_hash(const struct sock *sk,
+					const struct sk_buff *skb,
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

