Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6F646D26B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhLHLl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbhLHLlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:41:39 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9319AC061746;
        Wed,  8 Dec 2021 03:38:07 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id o20so7316320eds.10;
        Wed, 08 Dec 2021 03:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dAbVM5/BoNe1vEnajlCw7z2bI1EoKRGeD7c1mrofev8=;
        b=oSh+lp9sTNDFS8q+zY7PI5caeiVP7hAZwiP+LY/nAwlo/KLI70xjh3VPA02LndKhPD
         cKPELX7WJSxlRYYZ0D5aYMtUNrfedOTFG8yG+fncEoAIx+Wtv94dk4wSZQpOrNq5J4gL
         b7aF4RddS9b0hre6wOpyO3g1QVPbR0jTHX1/F/OkRU7vqvQBMpKSRA+dSOZowLIF9Jkw
         DZsUyzPXUImvNZ9QlTAJgShqMRPM2vZENTWwFOTAG6za6MT4brN4DhTYROCJWCnBK1Zx
         l0A3BUe0GRXGuRvRUxhSJoGFHxx/AbifNTvVREBhy/Dk2uYrcHoG0vy5rfVCDR1Xwi2k
         X21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dAbVM5/BoNe1vEnajlCw7z2bI1EoKRGeD7c1mrofev8=;
        b=vZg0eD5xTderIz4QV229Jh4epDQOtmNwsOCp34THVE3t2m0nAWXSnnd0Vp/S1M6Fjz
         guTsaDqtqxHofVFOzm/ct0wDDpCy94h87w6dkGSG00sZcPMg12nkvzKcygMxDvVwq17g
         VkENoq/qwjQ210u7z1tEedDPv22D03DtbbLx91ZWcZ7cPVUEheBBMD48r1519d21uU9o
         uY7z915Bpewk5e97FF+DaHLEgfGEHLNMIn+mFquPDNpMrMxxss91oyZZMH0z7hXN1aUd
         lT1z1S6XhMlpl94D683WDBf153VONQKuwW66ftbfTyrsgYBIdDipBn3ixuG8WbUWC0Dd
         M7IA==
X-Gm-Message-State: AOAM5322xuNaLJSK3avncsBiL7lYrRhdlB+LaOtMMjySUT8b1Inc8zjT
        GH5LaX/40f4a1MxdRC00mzk=
X-Google-Smtp-Source: ABdhPJwjsdkrVPRokAvTNVLX/0JFVRO72E4TK6EFb+Xr+xwOovf4AzOMfMIqfGe/g3kWJ9erZ8obNw==
X-Received: by 2002:a05:6402:34f:: with SMTP id r15mr18452841edw.80.1638963486124;
        Wed, 08 Dec 2021 03:38:06 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:3c9f:e05b:4dff:43ba])
        by smtp.gmail.com with ESMTPSA id g11sm1883810edz.53.2021.12.08.03.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:38:05 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 05/18] tcp: authopt: Compute packet signatures
Date:   Wed,  8 Dec 2021 13:37:20 +0200
Message-Id: <aa1cc5ba73961d23fecb915f3d88fdbd0f5f0e81.1638962992.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
References: <cover.1638962992.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Computing tcp authopt packet signatures is a two step process:

* traffic key is computed based on tcp 4-tuple, initial sequence numbers
and the secret key.
* packet mac is computed based on traffic key and content of individual
packets.

The traffic key could be cached for established sockets but it is not.

A single code path exists for ipv4/ipv6 and input/output. This keeps the
code short but slightly slower due to lots of conditionals.

On output we read remote IP address from socket members on output, we
can't use skb network header because it's computed after TCP options.

On input we read remote IP address from skb network headers, we can't
use socket binding members because those are not available for SYN.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |   9 +
 net/ipv4/tcp_authopt.c    | 537 +++++++++++++++++++++++++++++++++++---
 2 files changed, 510 insertions(+), 36 deletions(-)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 5217b6c7c900..ce005f7ce797 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -64,10 +64,19 @@ struct tcp_authopt_info {
 	u32 src_isn;
 	/** @dst_isn: Remote Initial Sequence Number */
 	u32 dst_isn;
 };
 
+/* TCP authopt as found in header */
+struct tcphdr_authopt {
+	u8 num;
+	u8 len;
+	u8 keyid;
+	u8 rnextkeyid;
+	u8 mac[0];
+};
+
 #ifdef CONFIG_TCP_AUTHOPT
 void tcp_authopt_clear(struct sock *sk);
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 478969d53094..29524ed56733 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -8,10 +8,15 @@
 /* All current algorithms have a mac length of 12 but crypto API digestsize can be larger */
 #define TCP_AUTHOPT_MAXMACBUF			20
 #define TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN		20
 #define TCP_AUTHOPT_MACLEN			12
 
+struct tcp_authopt_alg_pool {
+	struct crypto_ahash *tfm;
+	struct ahash_request *req;
+};
+
 /* Constant data with per-algorithm information from RFC5926
  * The "KDF" and "MAC" happen to be the same for both algorithms.
  */
 struct tcp_authopt_alg_imp {
 	/* Name of algorithm in crypto-api */
@@ -19,14 +24,14 @@ struct tcp_authopt_alg_imp {
 	/* One of the TCP_AUTHOPT_ALG_* constants from uapi */
 	u8 alg_id;
 	/* Length of traffic key */
 	u8 traffic_key_len;
 
-	/* shared crypto_shash */
+	/* shared crypto_ahash */
 	struct mutex init_mutex;
 	bool init_done;
-	struct crypto_shash * __percpu *tfms;
+	struct tcp_authopt_alg_pool __percpu *pool;
 };
 
 static struct tcp_authopt_alg_imp tcp_authopt_alg_list[] = {
 	{
 		.alg_id = TCP_AUTHOPT_ALG_HMAC_SHA_1_96,
@@ -48,59 +53,77 @@ static inline struct tcp_authopt_alg_imp *tcp_authopt_alg_get(int alg_num)
 	if (alg_num <= 0 || alg_num > 2)
 		return NULL;
 	return &tcp_authopt_alg_list[alg_num - 1];
 }
 
+static int tcp_authopt_alg_pool_init(struct tcp_authopt_alg_imp *alg,
+				     struct tcp_authopt_alg_pool *pool)
+{
+	pool->tfm = crypto_alloc_ahash(alg->alg_name, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(pool->tfm))
+		return PTR_ERR(pool->tfm);
+
+	pool->req = ahash_request_alloc(pool->tfm, GFP_ATOMIC);
+	if (IS_ERR(pool->req))
+		return PTR_ERR(pool->req);
+	ahash_request_set_callback(pool->req, 0, NULL, NULL);
+
+	return 0;
+}
+
+static void tcp_authopt_alg_pool_free(struct tcp_authopt_alg_pool *pool)
+{
+	ahash_request_free(pool->req);
+	pool->req = NULL;
+	crypto_free_ahash(pool->tfm);
+	pool->tfm = NULL;
+}
+
 static void __tcp_authopt_alg_free(struct tcp_authopt_alg_imp *alg)
 {
 	int cpu;
-	struct crypto_shash *tfm;
+	struct tcp_authopt_alg_pool *pool;
 
-	if (!alg->tfms)
+	if (!alg->pool)
 		return;
 	for_each_possible_cpu(cpu) {
-		tfm = *per_cpu_ptr(alg->tfms, cpu);
-		if (tfm) {
-			crypto_free_shash(tfm);
-			*per_cpu_ptr(alg->tfms, cpu) = NULL;
-		}
+		pool = per_cpu_ptr(alg->pool, cpu);
+		tcp_authopt_alg_pool_free(pool);
 	}
-	free_percpu(alg->tfms);
-	alg->tfms = NULL;
+	free_percpu(alg->pool);
+	alg->pool = NULL;
 }
 
 static int __tcp_authopt_alg_init(struct tcp_authopt_alg_imp *alg)
 {
-	struct crypto_shash *tfm;
+	struct tcp_authopt_alg_pool *pool;
 	int cpu;
 	int err;
 
 	BUILD_BUG_ON(TCP_AUTHOPT_MAXMACBUF < TCPOLEN_AUTHOPT_OUTPUT);
 	if (WARN_ON_ONCE(alg->traffic_key_len > TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN))
 		return -ENOBUFS;
 
-	alg->tfms = alloc_percpu(struct crypto_shash *);
-	if (!alg->tfms)
+	alg->pool = alloc_percpu(struct tcp_authopt_alg_pool);
+	if (!alg->pool)
 		return -ENOMEM;
 	for_each_possible_cpu(cpu) {
-		tfm = crypto_alloc_shash(alg->alg_name, 0, 0);
-		if (IS_ERR(tfm)) {
-			err = PTR_ERR(tfm);
+		pool = per_cpu_ptr(alg->pool, cpu);
+		err = tcp_authopt_alg_pool_init(alg, pool);
+		if (err)
 			goto out_err;
-		}
 
+		pool = per_cpu_ptr(alg->pool, cpu);
 		/* sanity checks: */
-		if (WARN_ON_ONCE(crypto_shash_digestsize(tfm) != alg->traffic_key_len)) {
+		if (WARN_ON_ONCE(crypto_ahash_digestsize(pool->tfm) != alg->traffic_key_len)) {
 			err = -EINVAL;
 			goto out_err;
 		}
-		if (WARN_ON_ONCE(crypto_shash_digestsize(tfm) > TCP_AUTHOPT_MAXMACBUF)) {
+		if (WARN_ON_ONCE(crypto_ahash_digestsize(pool->tfm) > TCP_AUTHOPT_MAXMACBUF)) {
 			err = -EINVAL;
 			goto out_err;
 		}
-
-		*per_cpu_ptr(alg->tfms, cpu) = tfm;
 	}
 	return 0;
 
 out_err:
 	__tcp_authopt_alg_free(alg);
@@ -123,42 +146,43 @@ static int tcp_authopt_alg_require(struct tcp_authopt_alg_imp *alg)
 out:
 	mutex_unlock(&alg->init_mutex);
 	return err;
 }
 
-static struct crypto_shash *tcp_authopt_alg_get_tfm(struct tcp_authopt_alg_imp *alg)
+static struct tcp_authopt_alg_pool *tcp_authopt_alg_get_pool(struct tcp_authopt_alg_imp *alg)
 {
 	local_bh_disable();
-	return *this_cpu_ptr(alg->tfms);
+	return this_cpu_ptr(alg->pool);
 }
 
-static void tcp_authopt_alg_put_tfm(struct tcp_authopt_alg_imp *alg, struct crypto_shash *tfm)
+static void tcp_authopt_alg_put_pool(struct tcp_authopt_alg_imp *alg,
+				     struct tcp_authopt_alg_pool *pool)
 {
-	WARN_ON(tfm != *this_cpu_ptr(alg->tfms));
+	WARN_ON(pool != this_cpu_ptr(alg->pool));
 	local_bh_enable();
 }
 
-static struct crypto_shash *tcp_authopt_get_kdf_shash(struct tcp_authopt_key_info *key)
+static struct tcp_authopt_alg_pool *tcp_authopt_get_kdf_pool(struct tcp_authopt_key_info *key)
 {
-	return tcp_authopt_alg_get_tfm(key->alg);
+	return tcp_authopt_alg_get_pool(key->alg);
 }
 
-static void tcp_authopt_put_kdf_shash(struct tcp_authopt_key_info *key,
-				      struct crypto_shash *tfm)
+static void tcp_authopt_put_kdf_pool(struct tcp_authopt_key_info *key,
+				     struct tcp_authopt_alg_pool *pool)
 {
-	return tcp_authopt_alg_put_tfm(key->alg, tfm);
+	return tcp_authopt_alg_put_pool(key->alg, pool);
 }
 
-static struct crypto_shash *tcp_authopt_get_mac_shash(struct tcp_authopt_key_info *key)
+static struct tcp_authopt_alg_pool *tcp_authopt_get_mac_pool(struct tcp_authopt_key_info *key)
 {
-	return tcp_authopt_alg_get_tfm(key->alg);
+	return tcp_authopt_alg_get_pool(key->alg);
 }
 
-static void tcp_authopt_put_mac_shash(struct tcp_authopt_key_info *key,
-				      struct crypto_shash *tfm)
+static void tcp_authopt_put_mac_pool(struct tcp_authopt_key_info *key,
+				     struct tcp_authopt_alg_pool *pool)
 {
-	return tcp_authopt_alg_put_tfm(key->alg, tfm);
+	return tcp_authopt_alg_put_pool(key->alg, pool);
 }
 
 /* checks that ipv4 or ipv6 addr matches. */
 static bool ipvx_addr_match(struct sockaddr_storage *a1,
 			    struct sockaddr_storage *a2)
@@ -425,5 +449,446 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
 	hlist_add_head_rcu(&key_info->node, &info->head);
 
 	return 0;
 }
+
+static int tcp_authopt_get_isn(struct sock *sk,
+			       struct tcp_authopt_info *info,
+			       struct sk_buff *skb,
+			       int input,
+			       __be32 *sisn,
+			       __be32 *disn)
+{
+	struct tcphdr *th = tcp_hdr(skb);
+
+	/* Special cases for SYN and SYN/ACK */
+	if (th->syn && !th->ack) {
+		*sisn = th->seq;
+		*disn = 0;
+		return 0;
+	}
+	if (th->syn && th->ack) {
+		*sisn = th->seq;
+		*disn = htonl(ntohl(th->ack_seq) - 1);
+		return 0;
+	}
+
+	if (sk->sk_state == TCP_NEW_SYN_RECV) {
+		struct tcp_request_sock *rsk = (struct tcp_request_sock *)sk;
+
+		if (WARN_ONCE(!input, "Caller passed wrong socket"))
+			return -EINVAL;
+		*sisn = htonl(rsk->rcv_isn);
+		*disn = htonl(rsk->snt_isn);
+		return 0;
+	} else if (sk->sk_state == TCP_LISTEN) {
+		/* Signature computation for non-syn packet on a listen
+		 * socket is not possible because we lack the initial
+		 * sequence numbers.
+		 *
+		 * Input segments that are not matched by any request,
+		 * established or timewait socket will get here. These
+		 * are not normally sent by peers.
+		 *
+		 * Their signature might be valid but we don't have
+		 * enough state to determine that. TCP-MD5 can attempt
+		 * to validate and reply with a signed RST because it
+		 * doesn't care about ISNs.
+		 *
+		 * Reporting an error from signature code causes the
+		 * packet to be discarded which is good.
+		 */
+		if (WARN_ONCE(!input, "Caller passed wrong socket"))
+			return -EINVAL;
+		*sisn = 0;
+		*disn = 0;
+		return 0;
+	}
+	if (WARN_ONCE(!info, "caller did not pass tcp_authopt_info\n"))
+		return -EINVAL;
+	/* Initial sequence numbers for ESTABLISHED connections from info */
+	if (input) {
+		*sisn = htonl(info->dst_isn);
+		*disn = htonl(info->src_isn);
+	} else {
+		*sisn = htonl(info->src_isn);
+		*disn = htonl(info->dst_isn);
+	}
+	return 0;
+}
+
+/* Feed one buffer into ahash
+ * The buffer is assumed to be DMA-able
+ */
+static int crypto_ahash_buf(struct ahash_request *req, u8 *buf, uint len)
+{
+	struct scatterlist sg;
+
+	sg_init_one(&sg, buf, len);
+	ahash_request_set_crypt(req, &sg, NULL, len);
+
+	return crypto_ahash_update(req);
+}
+
+/* feed traffic key into ahash */
+static int tcp_authopt_ahash_traffic_key(struct tcp_authopt_alg_pool *pool,
+					 struct sock *sk,
+					 struct sk_buff *skb,
+					 struct tcp_authopt_info *info,
+					 bool input,
+					 bool ipv6)
+{
+	struct tcphdr *th = tcp_hdr(skb);
+	int err;
+	__be32 sisn, disn;
+	__be16 digestbits = htons(crypto_ahash_digestsize(pool->tfm) * 8);
+
+	// RFC5926 section 3.1.1.1
+	err = crypto_ahash_buf(pool->req, "\x01TCP-AO", 7);
+	if (err)
+		return err;
+
+	/* Addresses from packet on input and from sk_common on output
+	 * This is because on output MAC is computed before prepending IP header
+	 */
+	if (input) {
+		if (ipv6)
+			err = crypto_ahash_buf(pool->req, (u8 *)&ipv6_hdr(skb)->saddr, 32);
+		else
+			err = crypto_ahash_buf(pool->req, (u8 *)&ip_hdr(skb)->saddr, 8);
+		if (err)
+			return err;
+	} else {
+		if (ipv6) {
+			err = crypto_ahash_buf(pool->req, (u8 *)&sk->sk_v6_rcv_saddr, 16);
+			if (err)
+				return err;
+			err = crypto_ahash_buf(pool->req, (u8 *)&sk->sk_v6_daddr, 16);
+			if (err)
+				return err;
+		} else {
+			err = crypto_ahash_buf(pool->req, (u8 *)&sk->sk_rcv_saddr, 4);
+			if (err)
+				return err;
+			err = crypto_ahash_buf(pool->req, (u8 *)&sk->sk_daddr, 4);
+			if (err)
+				return err;
+		}
+	}
+
+	/* TCP ports from header */
+	err = crypto_ahash_buf(pool->req, (u8 *)&th->source, 4);
+	if (err)
+		return err;
+	err = tcp_authopt_get_isn(sk, info, skb, input, &sisn, &disn);
+	if (err)
+		return err;
+	err = crypto_ahash_buf(pool->req, (u8 *)&sisn, 4);
+	if (err)
+		return err;
+	err = crypto_ahash_buf(pool->req, (u8 *)&disn, 4);
+	if (err)
+		return err;
+	err = crypto_ahash_buf(pool->req, (u8 *)&digestbits, 2);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/* Convert a variable-length key to a 16-byte fixed-length key for AES-CMAC
+ * This is described in RFC5926 section 3.1.1.2
+ */
+static int aes_setkey_derived(struct crypto_ahash *tfm, struct ahash_request *req,
+			      u8 *key, size_t keylen)
+{
+	static const u8 zeros[16] = {0};
+	struct scatterlist sg;
+	u8 derived_key[16];
+	int err;
+
+	if (WARN_ON_ONCE(crypto_ahash_digestsize(tfm) != sizeof(derived_key)))
+		return -EINVAL;
+	err = crypto_ahash_setkey(tfm, zeros, sizeof(zeros));
+	if (err)
+		return err;
+	err = crypto_ahash_init(req);
+	if (err)
+		return err;
+	sg_init_one(&sg, key, keylen);
+	ahash_request_set_crypt(req, &sg, derived_key, keylen);
+	err = crypto_ahash_digest(req);
+	if (err)
+		return err;
+	return crypto_ahash_setkey(tfm, derived_key, sizeof(derived_key));
+}
+
+static int tcp_authopt_setkey(struct tcp_authopt_alg_pool *pool, struct tcp_authopt_key_info *key)
+{
+	if (key->alg_id == TCP_AUTHOPT_ALG_AES_128_CMAC_96 && key->keylen != 16)
+		return aes_setkey_derived(pool->tfm, pool->req, key->key, key->keylen);
+	else
+		return crypto_ahash_setkey(pool->tfm, key->key, key->keylen);
+}
+
+static int tcp_authopt_get_traffic_key(struct sock *sk,
+				       struct sk_buff *skb,
+				       struct tcp_authopt_key_info *key,
+				       struct tcp_authopt_info *info,
+				       bool input,
+				       bool ipv6,
+				       u8 *traffic_key)
+{
+	struct tcp_authopt_alg_pool *pool;
+	int err;
+
+	pool = tcp_authopt_get_kdf_pool(key);
+	if (IS_ERR(pool))
+		return PTR_ERR(pool);
+
+	err = tcp_authopt_setkey(pool, key);
+	if (err)
+		goto out;
+	err = crypto_ahash_init(pool->req);
+	if (err)
+		goto out;
+
+	err = tcp_authopt_ahash_traffic_key(pool, sk, skb, info, input, ipv6);
+	if (err)
+		goto out;
+
+	ahash_request_set_crypt(pool->req, NULL, traffic_key, 0);
+	err = crypto_ahash_final(pool->req);
+	if (err)
+		return err;
+
+out:
+	tcp_authopt_put_kdf_pool(key, pool);
+	return err;
+}
+
+static int crypto_ahash_buf_zero(struct ahash_request *req, int len)
+{
+	u8 zeros[TCP_AUTHOPT_MACLEN] = {0};
+	int buflen, err;
+
+	/* In practice this is always called with len exactly 12.
+	 * Even on input we drop unusual signature sizes early.
+	 */
+	while (len) {
+		buflen = min_t(int, len, sizeof(zeros));
+		err = crypto_ahash_buf(req, zeros, buflen);
+		if (err)
+			return err;
+		len -= buflen;
+	}
+
+	return 0;
+}
+
+static int tcp_authopt_hash_tcp4_pseudoheader(struct tcp_authopt_alg_pool *pool,
+					      __be32 saddr,
+					      __be32 daddr,
+					      int nbytes)
+{
+	struct tcp4_pseudohdr phdr = {
+		.saddr = saddr,
+		.daddr = daddr,
+		.pad = 0,
+		.protocol = IPPROTO_TCP,
+		.len = htons(nbytes)
+	};
+	return crypto_ahash_buf(pool->req, (u8 *)&phdr, sizeof(phdr));
+}
+
+static int tcp_authopt_hash_tcp6_pseudoheader(struct tcp_authopt_alg_pool *pool,
+					      struct in6_addr *saddr,
+					      struct in6_addr *daddr,
+					      u32 plen)
+{
+	int err;
+	__be32 buf[2];
+
+	buf[0] = htonl(plen);
+	buf[1] = htonl(IPPROTO_TCP);
+
+	err = crypto_ahash_buf(pool->req, (u8 *)saddr, sizeof(*saddr));
+	if (err)
+		return err;
+	err = crypto_ahash_buf(pool->req, (u8 *)daddr, sizeof(*daddr));
+	if (err)
+		return err;
+	return crypto_ahash_buf(pool->req, (u8 *)&buf, sizeof(buf));
+}
+
+/** Hash tcphdr options.
+ *
+ * If include_options is false then only the TCPOPT_AUTHOPT option itself is hashed
+ * Point to AO inside TH is passed by the caller
+ */
+static int tcp_authopt_hash_opts(struct tcp_authopt_alg_pool *pool,
+				 struct tcphdr *th,
+				 struct tcphdr_authopt *aoptr,
+				 bool include_options)
+{
+	int err;
+	/* start of options */
+	u8 *tcp_opts = (u8 *)(th + 1);
+	/* start of options */
+	u8 *aobuf = (u8 *)aoptr;
+	u8 aolen = aoptr->len;
+
+	if (WARN_ONCE(aoptr->num != TCPOPT_AUTHOPT, "Bad aoptr\n"))
+		return -EINVAL;
+
+	if (include_options) {
+		/* end of options */
+		u8 *tcp_data = ((u8 *)th) + th->doff * 4;
+
+		err = crypto_ahash_buf(pool->req, tcp_opts, aobuf - tcp_opts + 4);
+		if (err)
+			return err;
+		err = crypto_ahash_buf_zero(pool->req, aolen - 4);
+		if (err)
+			return err;
+		err = crypto_ahash_buf(pool->req, aobuf + aolen, tcp_data - (aobuf + aolen));
+		if (err)
+			return err;
+	} else {
+		err = crypto_ahash_buf(pool->req, aobuf, 4);
+		if (err)
+			return err;
+		err = crypto_ahash_buf_zero(pool->req, aolen - 4);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int tcp_authopt_hash_packet(struct tcp_authopt_alg_pool *pool,
+				   struct sock *sk,
+				   struct sk_buff *skb,
+				   struct tcphdr_authopt *aoptr,
+				   bool input,
+				   bool ipv6,
+				   bool include_options,
+				   u8 *macbuf)
+{
+	struct tcphdr *th = tcp_hdr(skb);
+	int err;
+
+	/* NOTE: SNE unimplemented */
+	__be32 sne = 0;
+
+	err = crypto_ahash_init(pool->req);
+	if (err)
+		return err;
+
+	err = crypto_ahash_buf(pool->req, (u8 *)&sne, 4);
+	if (err)
+		return err;
+
+	if (ipv6) {
+		struct in6_addr *saddr;
+		struct in6_addr *daddr;
+
+		if (input) {
+			saddr = &ipv6_hdr(skb)->saddr;
+			daddr = &ipv6_hdr(skb)->daddr;
+		} else {
+			saddr = &sk->sk_v6_rcv_saddr;
+			daddr = &sk->sk_v6_daddr;
+		}
+		err = tcp_authopt_hash_tcp6_pseudoheader(pool, saddr, daddr, skb->len);
+		if (err)
+			return err;
+	} else {
+		__be32 saddr;
+		__be32 daddr;
+
+		if (input) {
+			saddr = ip_hdr(skb)->saddr;
+			daddr = ip_hdr(skb)->daddr;
+		} else {
+			saddr = sk->sk_rcv_saddr;
+			daddr = sk->sk_daddr;
+		}
+		err = tcp_authopt_hash_tcp4_pseudoheader(pool, saddr, daddr, skb->len);
+		if (err)
+			return err;
+	}
+
+	// TCP header with checksum set to zero
+	{
+		struct tcphdr hashed_th = *th;
+
+		hashed_th.check = 0;
+		err = crypto_ahash_buf(pool->req, (u8 *)&hashed_th, sizeof(hashed_th));
+		if (err)
+			return err;
+	}
+
+	// TCP options
+	err = tcp_authopt_hash_opts(pool, th, aoptr, include_options);
+	if (err)
+		return err;
+
+	// Rest of SKB->data
+	err = tcp_sig_hash_skb_data(pool->req, skb, th->doff << 2);
+	if (err)
+		return err;
+
+	ahash_request_set_crypt(pool->req, NULL, macbuf, 0);
+	return crypto_ahash_final(pool->req);
+}
+
+/* __tcp_authopt_calc_mac - Compute packet MAC using key
+ *
+ * The macbuf output buffer must be large enough to fit the digestsize of the
+ * underlying transform before truncation.
+ * This means TCP_AUTHOPT_MAXMACBUF, not TCP_AUTHOPT_MACLEN
+ */
+static int __tcp_authopt_calc_mac(struct sock *sk,
+				  struct sk_buff *skb,
+				  struct tcphdr_authopt *aoptr,
+				  struct tcp_authopt_key_info *key,
+				  struct tcp_authopt_info *info,
+				  bool input,
+				  char *macbuf)
+{
+	struct tcp_authopt_alg_pool *mac_pool;
+	u8 traffic_key[TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN];
+	int err;
+	bool ipv6 = (sk->sk_family != AF_INET);
+
+	if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6)
+		return -EINVAL;
+
+	err = tcp_authopt_get_traffic_key(sk, skb, key, info, input, ipv6, traffic_key);
+	if (err)
+		return err;
+
+	mac_pool = tcp_authopt_get_mac_pool(key);
+	if (IS_ERR(mac_pool))
+		return PTR_ERR(mac_pool);
+	err = crypto_ahash_setkey(mac_pool->tfm, traffic_key, key->alg->traffic_key_len);
+	if (err)
+		goto out;
+	err = crypto_ahash_init(mac_pool->req);
+	if (err)
+		return err;
+
+	err = tcp_authopt_hash_packet(mac_pool,
+				      sk,
+				      skb,
+				      aoptr,
+				      input,
+				      ipv6,
+				      !(key->flags & TCP_AUTHOPT_KEY_EXCLUDE_OPTS),
+				      macbuf);
+
+out:
+	tcp_authopt_put_mac_pool(key, mac_pool);
+	return err;
+}
-- 
2.25.1

