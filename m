Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE464C019F
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiBVSuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbiBVSug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:50:36 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B274B13294E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:50:09 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d27so35219992wrb.5
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cEeMW15JH3+YV/B4DePfoz/ob0B0l6VDDpHXJ6xjfBo=;
        b=F8CX+p5FcG++1upoPOplcqNDA6JRNZMBvYAbcGavBLyZvz2ojG7PZr3lJGSV/QSZG5
         FNJpL/NMOJNh4Ap/oUyTRpfMnD1OI+i9J3H5EoViV33sznzXwuEvplw+Sr0/8RdsQhQT
         /Dea40C/nC21uAvS4khmGX8Ej5wAxYeioZu6W3bZdxHm4tBFceUS+GagR4F8emBeiN3L
         w9e/FPxHMa7Elj2ILAqGZV2bVqijeGqy5g7rzNXo5Q5iKeCAuaJINQguJ265OPmhZwtM
         3jHD7XpO01fmfeIduhpZhUXr+Ay8xa0JNMicF5tkfewdv3907zyknbqj0SfRTO55Ke7+
         L3Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cEeMW15JH3+YV/B4DePfoz/ob0B0l6VDDpHXJ6xjfBo=;
        b=dq9YJFaHcH5kkM4xe6tdUn8LEl8Ko90NAsv4Qg5Sdzfqecxq3e6JODtSh3n7pJXLFK
         D116Wb0AAJBJKyxiuvyakuESfA6M+VHFL2lTO7wvGARfEGhhMxniBJVLlQFyrzXAgJDY
         /qevAq+lEZASaDzD7mY+IQMD92iBN0fRdjIlrUuiYscdn9qBn/Hs2rm5J7/r1M9pCpvp
         Q3rnpjvEpGiI0XYdA7wcPumc3fs26+9zvd8aO0ZmTCe0r4rtCEe6n3r+R87i53dAHDzu
         vwwl3u4zJPgclrmQODgb1iDNBFIiiGKZqMEj7ViDkjPm3AwHrwOaf1i8BUcTkY/hnSLL
         lUSA==
X-Gm-Message-State: AOAM5310zaosA1nYQlcuGohGNb135B8tl2k6+tMzPyK853HZjfLx8f99
        Wcb+bXy7nkdRCA5Sn1BN9eI5rA==
X-Google-Smtp-Source: ABdhPJw4TVQqL8U58e7qoKs9BT+TNFeo4FRhtVc97BDkAgy5kn1x+sw51fATWiUnqU+16OVBq7mYIw==
X-Received: by 2002:a5d:6488:0:b0:1ea:7ff1:93e with SMTP id o8-20020a5d6488000000b001ea7ff1093emr4938773wri.284.1645555808165;
        Tue, 22 Feb 2022 10:50:08 -0800 (PST)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id d2sm25796326wro.49.2022.02.22.10.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 10:50:07 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] net/tcp: Merge TCP-MD5 inbound callbacks
Date:   Tue, 22 Feb 2022 18:50:06 +0000
Message-Id: <20220222185006.337620-1-dima@arista.com>
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
 include/net/tcp.h   | 11 +++++++
 net/ipv4/tcp.c      | 66 ++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c | 73 ++++-----------------------------------------
 net/ipv6/tcp_ipv6.c | 57 +++--------------------------------
 4 files changed, 86 insertions(+), 121 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index b9fc978fb2ca..598f89ef9546 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1673,6 +1673,10 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 		return NULL;
 	return __tcp_md5_do_lookup(sk, l3index, addr, family);
 }
+bool tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
+			  const void *saddr, const void *daddr,
+			  int family, int dif, int sdif);
+
 
 #define tcp_twsk_md5_key(twsk)	((twsk)->tw_md5_key)
 #else
@@ -1682,6 +1686,13 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
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
index 02cb275e5487..546647534381 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4432,6 +4432,72 @@ int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *ke
 }
 EXPORT_SYMBOL(tcp_md5_hash_key);
 
+/* Called with rcu_read_lock() */
+bool tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
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
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
+		return true;
+	}
+
+	if (!hash_expected && hash_location) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
+		return true;
+	}
+
+	/* check the signature */
+	genhash = tp->af_specific->calc_md5_hash(newhash, hash_expected,
+						 NULL, skb);
+
+	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
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
index fec656f5a39e..bf2f6aff146d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1403,72 +1403,6 @@ EXPORT_SYMBOL(tcp_v4_md5_hash_skb);
 
 #endif
 
-/* Called with rcu_read_lock() */
-static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
-				    const struct sk_buff *skb,
-				    int dif, int sdif)
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
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
-		return true;
-	}
-
-	if (!hash_expected && hash_location) {
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
@@ -2019,7 +1953,9 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (unlikely(tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))) {
+		if (unlikely(tcp_inbound_md5_hash(sk, skb,
+						  &iph->saddr, &iph->daddr,
+						  AF_INET, dif, sdif))) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
@@ -2089,7 +2025,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
 
-	if (tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))
+	if (tcp_inbound_md5_hash(sk, skb, &iph->saddr, &iph->daddr,
+				AF_INET, dif, sdif))
 		goto discard_and_relse;
 
 	nf_reset_ct(skb);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 075ee8a2df3b..30cd0a074c2c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -772,57 +772,6 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 
 #endif
 
-static bool tcp_v6_inbound_md5_hash(const struct sock *sk,
-				    const struct sk_buff *skb,
-				    int dif, int sdif)
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
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
-		return true;
-	}
-
-	if (!hash_expected && hash_location) {
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
@@ -1676,7 +1625,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif)) {
+		if (tcp_inbound_md5_hash(sk, skb, &hdr->saddr, &hdr->daddr,
+					 AF_INET6, dif, sdif)) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
@@ -1743,7 +1693,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
 
-	if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif))
+	if (tcp_inbound_md5_hash(sk, skb, &hdr->saddr, &hdr->daddr,
+				 AF_INET6, dif, sdif))
 		goto discard_and_relse;
 
 	if (tcp_filter(sk, skb))

base-commit: 038101e6b2cd5c55f888f85db42ea2ad3aecb4b6
-- 
2.35.1

