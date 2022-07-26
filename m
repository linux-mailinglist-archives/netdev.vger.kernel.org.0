Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAED580B32
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbiGZGQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237683AbiGZGQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:16:27 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC90BF4A;
        Mon, 25 Jul 2022 23:15:52 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id mf4so24384682ejc.3;
        Mon, 25 Jul 2022 23:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3A89M6f/ZAUek7dxYg8vkPNRORGAYIO7TwHRAva/jSw=;
        b=mEkE6nG04vVrPwFDujbZsT/7OvjuWtFcW4BEwOs3bm/DKWGJdhmvt3iipqL35vObWb
         eIsY9zZen6XVoM5WQUYxXhNoX2DnR8SRUeSoSgjhdLtGmT4zAuZvNHQyz4VR0oBq6An8
         ZmgHs6mL4giyi0GH7ZD1fL/DmZI930YGiaN/A7pt5y7xIXEx44jAYUmECSsGsq4+HJ87
         bOQdMEtjPY6PgY6Oa1Cd4a8qotxYKhH5aEbfU5uzc76mCUjrnWvuXL5ukrvVczUUh4AW
         37b3sXqog15PjMBYE/0+ktHOokT0JWDCaUy/xf6BDY9NIGYmH9LjafBkEEdjl6QjWcDH
         EgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3A89M6f/ZAUek7dxYg8vkPNRORGAYIO7TwHRAva/jSw=;
        b=U94V63V1bP0MJfBMpwDUQ1c3GQGvmp1f7XbqUTSlRemh9Yx3lXk+rZ6MdX5sccjM4i
         zavHcFJEF4C79ES2a29RzDfTVzRsWf49tFbxmPcrtQIuLYRfylOZU0b8UAyRGPiVQ7MC
         2NSuXM8uXRja3nxLBvIGoDaISFmJH2Qpj6ktHc4hJXQxGkH/U0XxPgwcdTnrtprxJJYY
         OqZN5qm9Yg66at/y/gt2/hSA6wKdo0QsbpiuE4WDnf3Pl4PFgLw/Q+VV8jnlTI0nXcEw
         mOMU/+iQbeSR3Fpdp21O5RTLmrvGTfjk+bKEMUJ9KzNaRfSGwiliwUHH/4qvr0awNjWO
         GGAA==
X-Gm-Message-State: AJIora+fiKCZXMTyZzw4HabqMneMGtAVjpxbX6/XphfY8NyZyPgJ7Oqh
        flPsQB8TT0d6YA7YBtnk7sA=
X-Google-Smtp-Source: AGRyM1t6dUaXs7cEK7p1Vv3yLm+utwnP1P6VInHIQ2li/10pnCZnbrzNfeF7xrqhfUHhAyOUWIHlFQ==
X-Received: by 2002:a17:907:a426:b0:72e:faf6:2873 with SMTP id sg38-20020a170907a42600b0072efaf62873mr12933458ejc.74.1658816151154;
        Mon, 25 Jul 2022 23:15:51 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:15:50 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 07/26] tcp: Refactor tcp_inbound_md5_hash into tcp_inbound_sig_hash
Date:   Tue, 26 Jul 2022 09:15:09 +0300
Message-Id: <69a18af444691e88217ee13e20fa5f796c3834ff.1658815925.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1658815925.git.cdleonard@gmail.com>
References: <cover.1658815925.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TCP-MD5 and TCP-AO signature options must be handled together so
replace the old tcp_inbound_md5_hash with tcp_inbound_sig_hash which
will handle both options.

As a side effect of this change Linux will start dropping packets where
both MD5 and AO are present instead of ignoring the so-far unrecognized
AO option. This is a direct requirement from RFC5925 2.2

This difference can be detected remotely without ever establishing a
connection and used to fingerprint linux version. This seems acceptable.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/dropreason.h |  4 ++++
 include/net/tcp.h        | 52 +++++++++++++++++++++++++++++-----------
 net/ipv4/tcp.c           | 39 ++++++++++++++++++++++++++----
 net/ipv4/tcp_input.c     | 37 ++++++++++++++++++++--------
 net/ipv4/tcp_ipv4.c      | 12 +++++-----
 net/ipv6/tcp_ipv6.c      |  8 +++----
 6 files changed, 113 insertions(+), 39 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index fae9b40e54fa..c5397c24296c 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -229,10 +229,14 @@ enum skb_drop_reason {
 	/**
 	 * @SKB_DROP_REASON_PKT_TOO_BIG: packet size is too big (maybe exceed the
 	 * MTU)
 	 */
 	SKB_DROP_REASON_PKT_TOO_BIG,
+	/**
+	 * @SKB_DROP_REASON_TCP_BOTHAOMD5: Both AO and MD5 found in packet.
+	 */
+	SKB_DROP_REASON_TCP_BOTHAOMD5,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
 	 */
 	SKB_DROP_REASON_MAX,
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 793e8802fef0..b107ee5ab108 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -424,11 +424,33 @@ int tcp_mmap(struct file *file, struct socket *sock,
 	     struct vm_area_struct *vma);
 #endif
 void tcp_parse_options(const struct net *net, const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx,
 		       int estab, struct tcp_fastopen_cookie *foc);
-const u8 *tcp_parse_md5sig_option(const struct tcphdr *th);
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
+enum skb_drop_reason tcp_parse_sig_options(const struct tcphdr *th,
+			  const u8 **md5ptr,
+			  const u8 **aoptr);
+#else
+static inline enum skb_drop_reason tcp_parse_sig_options(const struct tcphdr *th,
+			  const u8 **md5ptr,
+			  const u8 **aoptr)
+{
+	*aoptr = NULL;
+	*md5ptr = NULL;
+	return 0;
+}
+#endif
+static inline const u8 *tcp_parse_md5sig_option(const struct tcphdr *th)
+{
+	const u8 *md5, *ao;
+	int ret;
+
+	ret = tcp_parse_sig_options(th, &md5, &ao);
+
+	return (md5 && !ao && !ret) ? md5 : NULL;
+}
 
 /*
  *	BPF SKB-less helpers
  */
 u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
@@ -1683,32 +1705,19 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 	if (!static_branch_unlikely(&tcp_md5_needed))
 		return NULL;
 	return __tcp_md5_do_lookup(sk, l3index, addr, family);
 }
 
-enum skb_drop_reason
-tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
-		     const void *saddr, const void *daddr,
-		     int family, int dif, int sdif);
-
-
 #define tcp_twsk_md5_key(twsk)	((twsk)->tw_md5_key)
 #else
 static inline struct tcp_md5sig_key *
 tcp_md5_do_lookup(const struct sock *sk, int l3index,
 		  const union tcp_md5_addr *addr, int family)
 {
 	return NULL;
 }
 
-static inline enum skb_drop_reason
-tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
-		     const void *saddr, const void *daddr,
-		     int family, int dif, int sdif)
-{
-	return SKB_NOT_DROPPED_YET;
-}
 #define tcp_twsk_md5_key(twsk)	NULL
 #endif
 
 bool tcp_alloc_md5sig_pool(void);
 
@@ -1721,10 +1730,25 @@ static inline void tcp_put_md5sig_pool(void)
 int tcp_sig_hash_skb_data(struct ahash_request *, const struct sk_buff *,
 			  unsigned int header_len);
 int tcp_md5_hash_key(struct tcp_md5sig_pool *hp,
 		     const struct tcp_md5sig_key *key);
 
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
+enum skb_drop_reason
+tcp_inbound_sig_hash(const struct sock *sk, const struct sk_buff *skb,
+		     const void *saddr, const void *daddr,
+		     int family, int dif, int sdif);
+#else
+static inline enum skb_drop_reason
+tcp_inbound_sig_hash(const struct sock *sk, const struct sk_buff *skb,
+		     const void *saddr, const void *daddr,
+		     int family, int dif, int sdif)
+{
+	return SKB_NOT_DROPPED_YET;
+}
+#endif
+
 /* From tcp_fastopen.c */
 void tcp_fastopen_cache_get(struct sock *sk, u16 *mss,
 			    struct tcp_fastopen_cookie *cookie);
 void tcp_fastopen_cache_set(struct sock *sk, u16 mss,
 			    struct tcp_fastopen_cookie *cookie, bool syn_lost,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4cdc34200bcf..3b950768cbaf 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4528,24 +4528,24 @@ int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *ke
 	return data_race(crypto_ahash_update(hp->md5_req));
 }
 EXPORT_SYMBOL(tcp_md5_hash_key);
 
 /* Called with rcu_read_lock() */
-enum skb_drop_reason
+static enum skb_drop_reason
 tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		     const void *saddr, const void *daddr,
-		     int family, int dif, int sdif)
+		     int family, int dif, int sdif,
+		     const u8 *hash_location)
 {
 	/*
 	 * This gets called for each TCP segment that arrives
 	 * so we want to be efficient.
 	 * We have 3 drop cases:
 	 * o No MD5 hash and one expected.
 	 * o MD5 hash and we're not expecting one.
 	 * o MD5 hash and its wrong.
 	 */
-	const __u8 *hash_location = NULL;
 	struct tcp_md5sig_key *hash_expected;
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int genhash, l3index;
 	u8 newhash[16];
@@ -4554,11 +4554,10 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	 * in an L3 domain and dif is set to the l3mdev
 	 */
 	l3index = sdif ? dif : 0;
 
 	hash_expected = tcp_md5_do_lookup(sk, l3index, saddr, family);
-	hash_location = tcp_parse_md5sig_option(th);
 
 	/* We've parsed the options - do we have a hash? */
 	if (!hash_expected && !hash_location)
 		return SKB_NOT_DROPPED_YET;
 
@@ -4592,14 +4591,44 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		}
 		return SKB_DROP_REASON_TCP_MD5FAILURE;
 	}
 	return SKB_NOT_DROPPED_YET;
 }
-EXPORT_SYMBOL(tcp_inbound_md5_hash);
 
 #endif /* CONFIG_TCP_MD5SIG */
 
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
+
+enum skb_drop_reason
+tcp_inbound_sig_hash(const struct sock *sk, const struct sk_buff *skb,
+		     const void *saddr, const void *daddr,
+		     int family, int dif, int sdif)
+{
+	/* FIXME: Restore reqsk handling */
+	const u8 *md5, *ao;
+	enum skb_drop_reason ret;
+	const struct sock *parent_sk;
+
+	if (sk->sk_state == TCP_NEW_SYN_RECV)
+		parent_sk = inet_reqsk(sk)->rsk_listener;
+	else
+		parent_sk = sk;
+
+	ret = tcp_parse_sig_options(tcp_hdr(skb), &md5, &ao);
+	if (ret)
+		return ret;
+
+#ifdef CONFIG_TCP_MD5SIG
+	return tcp_inbound_md5_hash(parent_sk, skb, saddr, daddr, family, dif, sdif, md5);
+#else
+	return SKB_NOT_DROPPED_YET;
+#endif
+}
+EXPORT_SYMBOL(tcp_inbound_sig_hash);
+
+#endif /* defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT) */
+
 void tcp_done(struct sock *sk)
 {
 	struct request_sock *req;
 
 	/* We might be called with a new socket, after
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ae73b34d32e9..a7ac580a65c7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4184,43 +4184,60 @@ static bool tcp_fast_parse_options(const struct net *net,
 		tp->rx_opt.rcv_tsecr -= tp->tsoffset;
 
 	return true;
 }
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
 /*
- * Parse MD5 Signature option
+ * Parse MD5 and AO options
+ *
+ * md5ptr: pointer to content of MD5 option (16-byte hash)
+ * aoptr: pointer to start of AO option (variable length)
  */
-const u8 *tcp_parse_md5sig_option(const struct tcphdr *th)
+enum skb_drop_reason tcp_parse_sig_options(const struct tcphdr *th, const u8 **md5ptr, const u8 **aoptr)
 {
 	int length = (th->doff << 2) - sizeof(*th);
 	const u8 *ptr = (const u8 *)(th + 1);
 
+	*md5ptr = NULL;
+	*aoptr = NULL;
+
 	/* If not enough data remaining, we can short cut */
-	while (length >= TCPOLEN_MD5SIG) {
+	while (length >= 4) {
 		int opcode = *ptr++;
 		int opsize;
 
 		switch (opcode) {
 		case TCPOPT_EOL:
-			return NULL;
+			goto out;
 		case TCPOPT_NOP:
 			length--;
 			continue;
 		default:
 			opsize = *ptr++;
 			if (opsize < 2 || opsize > length)
-				return NULL;
-			if (opcode == TCPOPT_MD5SIG)
-				return opsize == TCPOLEN_MD5SIG ? ptr : NULL;
+				goto out;
+			if (opcode == TCPOPT_MD5SIG && opsize == TCPOLEN_MD5SIG)
+				*md5ptr = ptr;
+			if (opcode == TCPOPT_AUTHOPT)
+				*aoptr = ptr - 2;
 		}
 		ptr += opsize - 2;
 		length -= opsize;
 	}
-	return NULL;
+
+out:
+	/* RFC5925 2.2: An endpoint MUST NOT use TCP-AO for the same connection
+	 * in which TCP MD5 is used. When both options appear, TCP MUST silently
+	 * discard the segment.
+	 */
+	if (*md5ptr && *aoptr)
+		return SKB_DROP_REASON_TCP_BOTHAOMD5;
+
+	return SKB_NOT_DROPPED_YET;
 }
-EXPORT_SYMBOL(tcp_parse_md5sig_option);
+EXPORT_SYMBOL(tcp_parse_sig_options);
 #endif
 
 /* Sorry, PAWS as specified is broken wrt. pure-ACKs -DaveM
  *
  * It is not fatal. If this ACK does _not_ change critical state (seqs, window)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5c13d3460ce1..93c564022748 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1964,17 +1964,17 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	if (sk->sk_state == TCP_NEW_SYN_RECV) {
 		struct request_sock *req = inet_reqsk(sk);
 		bool req_stolen = false;
 		struct sock *nsk;
 
-		sk = req->rsk_listener;
-		if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
+		if (!xfrm4_policy_check(req->rsk_listener, XFRM_POLICY_IN, skb))
 			drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		else
-			drop_reason = tcp_inbound_md5_hash(sk, skb,
-						   &iph->saddr, &iph->daddr,
-						   AF_INET, dif, sdif);
+			drop_reason = tcp_inbound_sig_hash(sk, skb,
+							   &iph->saddr, &iph->daddr,
+							   AF_INET, dif, sdif);
+		sk = req->rsk_listener;
 		if (unlikely(drop_reason)) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
 		}
@@ -2046,11 +2046,11 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb)) {
 		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto discard_and_relse;
 	}
 
-	drop_reason = tcp_inbound_md5_hash(sk, skb, &iph->saddr,
+	drop_reason = tcp_inbound_sig_hash(sk, skb, &iph->saddr,
 					   &iph->daddr, AF_INET, dif, sdif);
 	if (drop_reason)
 		goto discard_and_relse;
 
 	nf_reset_ct(skb);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 16e85ae4f029..12f63ce66bcc 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1632,14 +1632,14 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	if (sk->sk_state == TCP_NEW_SYN_RECV) {
 		struct request_sock *req = inet_reqsk(sk);
 		bool req_stolen = false;
 		struct sock *nsk;
 
-		sk = req->rsk_listener;
-		drop_reason = tcp_inbound_md5_hash(sk, skb,
+		drop_reason = tcp_inbound_sig_hash(sk, skb,
 						   &hdr->saddr, &hdr->daddr,
 						   AF_INET6, dif, sdif);
+		sk = req->rsk_listener;
 		if (drop_reason) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
 		}
@@ -1707,12 +1707,12 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb)) {
 		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto discard_and_relse;
 	}
 
-	drop_reason = tcp_inbound_md5_hash(sk, skb, &hdr->saddr, &hdr->daddr,
-					   AF_INET6, dif, sdif);
+	drop_reason = tcp_inbound_sig_hash(sk, skb, &hdr->saddr,
+					   &hdr->daddr, AF_INET6, dif, sdif);
 	if (drop_reason)
 		goto discard_and_relse;
 
 	if (tcp_filter(sk, skb)) {
 		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
-- 
2.25.1

