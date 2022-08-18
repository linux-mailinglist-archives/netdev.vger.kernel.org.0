Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB715989D8
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345336AbiHRRCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345404AbiHRRAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:00:44 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979F0C12F2
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:31 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id ay12so1133279wmb.1
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ucIkbr5pakBiR2TacO+yVhlQffxrHozaVQKUUYy+noE=;
        b=SfHc/nulc5vwGhsDjWwmvyb7SUvYd0Kq6IRkfHBJPbBYIGSCYShfh8tWkufYtfp5bP
         XqK6PE/RABZarTSlICpPj/8NEnhTePjnH2uBdwa2+Tq/l17Zg3zik/PAxRxHWKMYjmwm
         wCDLv/v7tdGt0POKVaf6Za/9IaZUZEmCBW62iupfQNOTCMdFtCtqNUgCol7S43Y2jhKB
         KQauupqqXYwP/ACd4Vpu0YhHXocXLhpxRv+aCBT+aNHd+7RqLZ4zzlBiYFbxzgUu4VnQ
         2T5Q/f3FffbgHyM7MnaP1+RjHWygZLpBfzjJrKlMXng+bzDTh4Ap/h+Lu7qe+takdg9q
         x/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ucIkbr5pakBiR2TacO+yVhlQffxrHozaVQKUUYy+noE=;
        b=pMdFP6FaR1irFZaWL5khF4a71zvLwTNOI568iLNtBL30Yu6jmx/JihxuWxeGFZ28Jr
         pMZKeVeo0kweukoWsQdqGSzyO7NRvkVwcbeWp/2J4NA1ajwgXEOFiGUtH6ymfb+WM7sM
         V9ELmvZmdX7l2W2JfKRCbMDAXEidVuCK0BGGfbgAJsUKESQ6MtvC13a7KTYv7zYL3gAk
         QJHFD6EXydAkP2i31VlfhhuDCneS2eubACr835zqcMgEwktklBlglPVB8Sdw+59fQb/m
         WKWsZaIYgQEF5p1ryY3RLO2ykJhf9GeemzThnIsXxuHI2Y5nvj5C1u/+rCLB+c/jHKR7
         +GUg==
X-Gm-Message-State: ACgBeo0ClmvcLw4N1ocSJSObs7H61yOmJB2K+IKTLljQx4cSKboREqYz
        awvK+XikVqZvGuDZwbPttgWvUA==
X-Google-Smtp-Source: AA6agR6lilmPQDSbc5GoriEsdw7v5HePPlXwHstI+DbqMzJRo+B52RQbsu5Hdj7NLk6bnn3mLMdIlg==
X-Received: by 2002:a1c:a187:0:b0:3a5:e055:715b with SMTP id k129-20020a1ca187000000b003a5e055715bmr2514610wme.171.1660842031048;
        Thu, 18 Aug 2022 10:00:31 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:30 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 12/31] net/tcp: Add tcp_parse_auth_options()
Date:   Thu, 18 Aug 2022 17:59:46 +0100
Message-Id: <20220818170005.747015-13-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a helper that:
(1) shares the common code with TCP-MD5 header options parsing
(2) looks for hash signature only once for both TCP-MD5 and TCP-AO
(3) fails with -EEXIST if any TCP sign option is present twice, see
    RFC5925 (2.2):
    ">> A single TCP segment MUST NOT have more than one TCP-AO in its
    options sequence. When multiple TCP-AOs appear, TCP MUST discard
    the segment."

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h    | 24 +++++++++++++++++++++++-
 include/net/tcp_ao.h |  3 +++
 net/ipv4/tcp.c       |  3 ++-
 net/ipv4/tcp_input.c | 39 +++++++++++++++++++++++++++++----------
 net/ipv4/tcp_ipv4.c  | 21 ++++++++++++++-------
 net/ipv6/tcp_ipv6.c  | 17 +++++++++++------
 6 files changed, 82 insertions(+), 25 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index d91a963f430d..061fe8471bfc 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -428,7 +428,6 @@ int tcp_mmap(struct file *file, struct socket *sock,
 void tcp_parse_options(const struct net *net, const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx,
 		       int estab, struct tcp_fastopen_cookie *foc);
-const u8 *tcp_parse_md5sig_option(const struct tcphdr *th);
 
 /*
  *	BPF SKB-less helpers
@@ -2467,4 +2466,27 @@ static inline u64 tcp_transmit_time(const struct sock *sk)
 	return 0;
 }
 
+static inline int tcp_parse_auth_options(const struct tcphdr *th,
+		const u8 **md5_hash, const struct tcp_ao_hdr **aoh)
+{
+	const u8 *md5_tmp, *ao_tmp;
+	int ret;
+
+	ret = tcp_do_parse_auth_options(th, &md5_tmp, &ao_tmp);
+	if (ret)
+		return ret;
+
+	if (md5_hash)
+		*md5_hash = md5_tmp;
+
+	if (aoh) {
+		if (!ao_tmp)
+			*aoh = NULL;
+		else
+			*aoh = (struct tcp_ao_hdr *)(ao_tmp - 2);
+	}
+
+	return 0;
+}
+
 #endif	/* _TCP_H */
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index f840b693d038..b5516c83e489 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -87,6 +87,9 @@ struct tcp_ao_info {
 	u32			rcv_sne_seq;
 };
 
+int tcp_do_parse_auth_options(const struct tcphdr *th,
+			      const u8 **md5_hash, const u8 **ao_hash);
+
 #ifdef CONFIG_TCP_AO
 /* TCP-AO structures and functions */
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 85854b8afc47..a5e94d8e8450 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4526,7 +4526,8 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	l3index = sdif ? dif : 0;
 
 	hash_expected = tcp_md5_do_lookup(sk, l3index, saddr, family);
-	hash_location = tcp_parse_md5sig_option(th);
+	if (tcp_parse_auth_options(th, &hash_location, NULL))
+		return true;
 
 	/* We've parsed the options - do we have a hash? */
 	if (!hash_expected && !hash_location)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a5d6c7f1ead3..27e95876cba1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4188,39 +4188,58 @@ static bool tcp_fast_parse_options(const struct net *net,
 	return true;
 }
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 /*
- * Parse MD5 Signature option
+ * Parse Signature options
  */
-const u8 *tcp_parse_md5sig_option(const struct tcphdr *th)
+int tcp_do_parse_auth_options(const struct tcphdr *th,
+			      const u8 **md5_hash, const u8 **ao_hash)
 {
 	int length = (th->doff << 2) - sizeof(*th);
 	const u8 *ptr = (const u8 *)(th + 1);
+	unsigned int minlen = TCPOLEN_MD5SIG;
+
+	if (IS_ENABLED(CONFIG_TCP_AO))
+		minlen = sizeof(struct tcp_ao_hdr) + 1;
+
+	*md5_hash = NULL;
+	*ao_hash = NULL;
 
 	/* If not enough data remaining, we can short cut */
-	while (length >= TCPOLEN_MD5SIG) {
+	while (length >= minlen) {
 		int opcode = *ptr++;
 		int opsize;
 
 		switch (opcode) {
 		case TCPOPT_EOL:
-			return NULL;
+			return 0;
 		case TCPOPT_NOP:
 			length--;
 			continue;
 		default:
 			opsize = *ptr++;
 			if (opsize < 2 || opsize > length)
-				return NULL;
-			if (opcode == TCPOPT_MD5SIG)
-				return opsize == TCPOLEN_MD5SIG ? ptr : NULL;
+				return -EINVAL;
+			if (opcode == TCPOPT_MD5SIG) {
+				if (opsize != TCPOLEN_MD5SIG)
+					return -EINVAL;
+				if (unlikely(*md5_hash || *ao_hash))
+					return -EEXIST;
+				*md5_hash = ptr;
+			} else if (opcode == TCPOPT_AO) {
+				if (opsize <= sizeof(struct tcp_ao_hdr))
+					return -EINVAL;
+				if (unlikely(*md5_hash || *ao_hash))
+					return -EEXIST;
+				*ao_hash = ptr;
+			}
 		}
 		ptr += opsize - 2;
 		length -= opsize;
 	}
-	return NULL;
+	return 0;
 }
-EXPORT_SYMBOL(tcp_parse_md5sig_option);
+EXPORT_SYMBOL(tcp_do_parse_auth_options);
 #endif
 
 /* Sorry, PAWS as specified is broken wrt. pure-ACKs -DaveM
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f6fe9ec1c99d..034549c73beb 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -660,7 +660,9 @@ EXPORT_SYMBOL(tcp_v4_send_check);
  *	Exception: precedence violation. We do not implement it in any case.
  */
 
-#ifdef CONFIG_TCP_MD5SIG
+#ifdef CONFIG_TCP_AO
+#define OPTION_BYTES MAX_TCP_OPTION_SPACE
+#elif CONFIG_TCP_MD5SIG
 #define OPTION_BYTES TCPOLEN_MD5SIG_ALIGNED
 #else
 #define OPTION_BYTES sizeof(__be32)
@@ -676,7 +678,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	struct ip_reply_arg arg;
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key *key = NULL;
-	const __u8 *hash_location = NULL;
+	const __u8 *md5_hash_location = NULL;
 	unsigned char newhash[16];
 	int genhash;
 	struct sock *sk1 = NULL;
@@ -715,9 +717,14 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	arg.iov[0].iov_len  = sizeof(rep.th);
 
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
+	/* Invalid TCP option size or twice included auth */
+	if (tcp_parse_auth_options(tcp_hdr(skb), &md5_hash_location, NULL))
+		return;
+
 	rcu_read_lock();
-	hash_location = tcp_parse_md5sig_option(th);
+#endif
+#ifdef CONFIG_TCP_MD5SIG
 	if (sk && sk_fullsock(sk)) {
 		const union tcp_md5_addr *addr;
 		int l3index;
@@ -728,7 +735,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
 		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
 		key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
-	} else if (hash_location) {
+	} else if (md5_hash_location) {
 		const union tcp_md5_addr *addr;
 		int sdif = tcp_v4_sdif(skb);
 		int dif = inet_iif(skb);
@@ -760,7 +767,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 
 
 		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(hash_location, newhash, 16) != 0)
+		if (genhash || memcmp(md5_hash_location, newhash, 16) != 0)
 			goto out;
 
 	}
@@ -835,7 +842,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 out:
 	rcu_read_unlock();
 #endif
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index b5fa5ae53a47..ba968e856ca9 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -982,7 +982,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	u32 seq = 0, ack_seq = 0;
 	struct tcp_md5sig_key *key = NULL;
 #ifdef CONFIG_TCP_MD5SIG
-	const __u8 *hash_location = NULL;
+	const __u8 *md5_hash_location = NULL;
 	unsigned char newhash[16];
 	int genhash;
 	struct sock *sk1 = NULL;
@@ -1002,9 +1002,14 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		return;
 
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
+	/* Invalid TCP option size or twice included auth */
+	if (tcp_parse_auth_options(th, &md5_hash_location, NULL))
+		return;
+
 	rcu_read_lock();
-	hash_location = tcp_parse_md5sig_option(th);
+#endif
+#ifdef CONFIG_TCP_MD5SIG
 	if (sk && sk_fullsock(sk)) {
 		int l3index;
 
@@ -1013,7 +1018,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		 */
 		l3index = tcp_v6_sdif(skb) ? tcp_v6_iif_l3_slave(skb) : 0;
 		key = tcp_v6_md5_do_lookup(sk, &ipv6h->saddr, l3index);
-	} else if (hash_location) {
+	} else if (md5_hash_location) {
 		int dif = tcp_v6_iif_l3_slave(skb);
 		int sdif = tcp_v6_sdif(skb);
 		int l3index;
@@ -1043,7 +1048,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 			goto out;
 
 		genhash = tcp_v6_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(hash_location, newhash, 16) != 0)
+		if (genhash || memcmp(md5_hash_location, newhash, 16) != 0)
 			goto out;
 	}
 #endif
@@ -1076,7 +1081,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1,
 			     ipv6_get_dsfield(ipv6h), label, priority);
 
-#ifdef CONFIG_TCP_MD5SIG
+#if  defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 out:
 	rcu_read_unlock();
 #endif
-- 
2.37.2

