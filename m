Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBDF598D04
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345693AbiHRUAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345280AbiHRUAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:00:30 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB80D11C6;
        Thu, 18 Aug 2022 13:00:29 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id w3so3217138edc.2;
        Thu, 18 Aug 2022 13:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=lst4jYQoWqW22J7+IkYDuwssupI9FP63jPAToNOVsvc=;
        b=ROWSk0/XdwyIBT4fnj9tgFmokvehPRJyhCYqfsA5FjjQ4lY/C8Cqlsco+9uMf6If9A
         hCeurLETrgwEzxlKXSNPKTn8e8755sdPDF1edvoZdxI+pzMrMp0GLI+WOAM8G+5zYiD5
         mbe/L6mMgJT+0adneN5dMzd6+w5ywv2ZxsZIfm1HdJdc7NGxNUEzu2pY+0LHgeUFnLbz
         kx56CTNLCMDW3A5lXywBqaZpDbWbOnPobMJFHyNZhuRzJ+4Am12lUiT81fVVt8W8/qh4
         u/EtKFQAfXnJYFolUnb1tvjSdSfVPvub9itP4sV3C4A77ZlTOyvDiRFsOtyTwtJiN4j6
         y9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=lst4jYQoWqW22J7+IkYDuwssupI9FP63jPAToNOVsvc=;
        b=7EM07HaMC5Ubh/uHfbqbNb9Ir8Uf/K9B+6t5uU3NqPfS3uAHCZYgb8PqozbAKvChNx
         3E4G7h837enQ3EM4fno94by4cIZuvcNK1FvaOAD0xwN7zDOdeUfykC1DmFSwjewDFfyA
         ppusg8BK83aaMu/M4W8Xyxu0EpOWarFZWjBfS/NrISpLGJZ5mAjFCUP5VCDv9vOvIFHL
         XuQWSjicWfFvaOHm6HDu2hlCFSGpfZYScb7wlOUAB5sLvYFpYy0d2KlMMGEXAAMCDH12
         qoa+IK4tTufKzjq01Za29RLz/EFV32qD422TkD7LdZlLR9UNEUqZ1xIo/o2NNOySETqc
         pkmg==
X-Gm-Message-State: ACgBeo0jl7wq+OFnLaunoLS9zklJL2ABevhFVO0cFOjJnY53Gb4iisq4
        6hps2awn/zPBA6jc9cfth7E=
X-Google-Smtp-Source: AA6agR7CEBfGHkUfSEOyYXwlLOwZXSuJgvgi+VXeAKk8rbhESZ0HGFDK8awj1TmAlyrq9YWsvotjxw==
X-Received: by 2002:a05:6402:26cb:b0:43e:6fab:11c6 with SMTP id x11-20020a05640226cb00b0043e6fab11c6mr3328293edd.272.1660852827694;
        Thu, 18 Aug 2022 13:00:27 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:27 -0700 (PDT)
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
Subject: [PATCH v7 06/26] tcp: Refactor tcp_inbound_md5_hash into tcp_inbound_sig_hash
Date:   Thu, 18 Aug 2022 22:59:40 +0300
Message-Id: <42b7fa32c0fca77abb1e6a234f2dac45798f605b.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
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
 net/ipv4/tcp_input.c     | 39 ++++++++++++++++++++++--------
 net/ipv4/tcp_ipv4.c      | 12 +++++-----
 net/ipv6/tcp_ipv6.c      |  8 +++----
 6 files changed, 115 insertions(+), 39 deletions(-)

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
index fbe18b5bf576..96e7e406e324 100644
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
@@ -1685,32 +1707,19 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
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
 
@@ -1723,10 +1732,25 @@ static inline void tcp_put_md5sig_pool(void)
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
index 4c61c32ccf49..0611a2160b63 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4568,24 +4568,24 @@ int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *ke
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
@@ -4594,11 +4594,10 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	 * in an L3 domain and dif is set to the l3mdev
 	 */
 	l3index = sdif ? dif : 0;
 
 	hash_expected = tcp_md5_do_lookup(sk, l3index, saddr, family);
-	hash_location = tcp_parse_md5sig_option(th);
 
 	/* We've parsed the options - do we have a hash? */
 	if (!hash_expected && !hash_location)
 		return SKB_NOT_DROPPED_YET;
 
@@ -4641,14 +4640,44 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
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
index ab5f0ea166f1..fa20afd15248 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4186,43 +4186,62 @@ static bool tcp_fast_parse_options(const struct net *net,
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
+enum skb_drop_reason tcp_parse_sig_options(const struct tcphdr *th,
+					   const u8 **md5ptr,
+					   const u8 **aoptr)
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
index 46ba754afd2b..58b5f197bde1 100644
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
index 30dc9d4eec83..2edfe631878e 100644
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

