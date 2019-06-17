Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F4647BDB
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfFQILM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:11:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51211 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfFQILM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 04:11:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so8184362wma.1
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 01:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T2DYrJyMKowWyAQpSFGQeU51o1KpgHm1+BmumkXfwiw=;
        b=VlzMiAV9ZL942+T6PN1t43bqCjqUfvSfcQycNhc90IQJMuepCPYZEvI5IE7XLS3v87
         35rDSpA0Rpev5oJnzo++eKFZzXLTYED850q0GNyBcvDglrCXuHUtVpIvUe07MtmSLx8x
         75q4gUelfxtUA9d8XsStLaYb1pqFQNk94mI3y22a5cYNbhsJB0hTgJYibKMuIf00Cxq1
         ZfDihPqika9gXZiuDt1+TO0o552W3MjenoQP+oOaVIY04l0UUrTA01KZhgEfdbp2yTCw
         cpFNUNi5i/hclWNYFoRL0eDvjTInV8YIhvmkR25ahDzR6s00Bh0+3+OOXFIrNqGX6c+i
         d8NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T2DYrJyMKowWyAQpSFGQeU51o1KpgHm1+BmumkXfwiw=;
        b=DKRW8eLy3CZ3Uct0hTmHs5RYjhBU3HC5am5O8VA6gife0+7Qwlt8CT3GDhFGezEtEi
         d8zVkuFNI/bvQLSrKNDxyTUL/FmAgiYnNNBOvpdbGUSqW+Q264Azln+mFcUZUPkw9Ri1
         V8R3QpwmGLC0ivk9aZkEYFWGS/+ogvtxUItvx63Z+LRErQzqFVWDzwYFYfJJ1ikGvbSS
         OHlK5BzlNxlrW/PaD2ezCgJBRSzZErJI31XMisMPeTbTOgEq9nUfyfggeRwH945Y3HE6
         vfYQABmsgO2qyQVt0di8CJWjqKvBARUwJ63w9pKaNZbq3q4WoccT+lO6qxKUC3lRZy/x
         P/zg==
X-Gm-Message-State: APjAAAVUgEsrwiN96U1BNJpumss9nu9krppY70RHaJWA2roOSJIU4NaQ
        Fp0HKsYbJpTS8IOIALzslO5eq81NyncWgg==
X-Google-Smtp-Source: APXvYqzxF21yyweKsYKW3hgO4fHW4jzgSg/Fx14kVgSq8vaOzEW4AXxAil+hYP1itIxNuTlJ+ZyEMA==
X-Received: by 2002:a1c:968c:: with SMTP id y134mr16400721wmd.122.1560759068656;
        Mon, 17 Jun 2019 01:11:08 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id j189sm21734900wmb.48.2019.06.17.01.11.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 01:11:07 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, edumazet@google.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, jbaron@akamai.com,
        cpaasch@apple.com, David.Laight@aculab.com, ycheng@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3] net: ipv4: move tcp_fastopen server side code to SipHash library
Date:   Mon, 17 Jun 2019 10:09:33 +0200
Message-Id: <20190617080933.32152-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using a bare block cipher in non-crypto code is almost always a bad idea,
not only for security reasons (and we've seen some examples of this in
the kernel in the past), but also for performance reasons.

In the TCP fastopen case, we call into the bare AES block cipher one or
two times (depending on whether the connection is IPv4 or IPv6). On most
systems, this results in a call chain such as

  crypto_cipher_encrypt_one(ctx, dst, src)
    crypto_cipher_crt(tfm)->cit_encrypt_one(crypto_cipher_tfm(tfm), ...);
      aesni_encrypt
        kernel_fpu_begin();
        aesni_enc(ctx, dst, src); // asm routine
        kernel_fpu_end();

It is highly unlikely that the use of special AES instructions has a
benefit in this case, especially since we are doing the above twice
for IPv6 connections, instead of using a transform which can process
the entire input in one go.

We could switch to the cbcmac(aes) shash, which would at least get
rid of the duplicated overhead in *some* cases (i.e., today, only
arm64 has an accelerated implementation of cbcmac(aes), while x86 will
end up using the generic cbcmac template wrapping the AES-NI cipher,
which basically ends up doing exactly the above). However, in the given
context, it makes more sense to use a light-weight MAC algorithm that
is more suitable for the purpose at hand, such as SipHash.

Since the output size of SipHash already matches our chosen value for
TCP_FASTOPEN_COOKIE_SIZE, and given that it accepts arbitrary input
sizes, this greatly simplifies the code as well.

NOTE: Server farms backing a single server IP for load balancing purposes
      and sharing a single fastopen key will be adversely affected by
      this change unless all systems in the pool receive their kernel
      upgrades at the same time.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v3: mention potential deployment issues for server farms in commit log
    remove CONFIG_INET Kconfig dependency on CRYPTO_AES

v2: rebase onto net-next
    reverse order of operands in BUILD_BUG_ON() comparison expression

 include/linux/tcp.h     |  7 +-
 include/net/tcp.h       | 10 +-
 net/Kconfig             |  2 -
 net/ipv4/tcp_fastopen.c | 97 +++++++-------------
 4 files changed, 36 insertions(+), 80 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index c23019a3b264..9ea0e71f5c6a 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -58,12 +58,7 @@ static inline unsigned int tcp_optlen(const struct sk_buff *skb)
 
 /* TCP Fast Open Cookie as stored in memory */
 struct tcp_fastopen_cookie {
-	union {
-		u8	val[TCP_FASTOPEN_COOKIE_MAX];
-#if IS_ENABLED(CONFIG_IPV6)
-		struct in6_addr addr;
-#endif
-	};
+	u64	val[TCP_FASTOPEN_COOKIE_MAX / sizeof(u64)];
 	s8	len;
 	bool	exp;	/* In RFC6994 experimental option format */
 };
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 96e0e53ff440..184930b02779 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1628,9 +1628,9 @@ bool tcp_fastopen_defer_connect(struct sock *sk, int *err);
 
 /* Fastopen key context */
 struct tcp_fastopen_context {
-	struct crypto_cipher	*tfm[TCP_FASTOPEN_KEY_MAX];
-	__u8			key[TCP_FASTOPEN_KEY_BUF_LENGTH];
-	struct rcu_head		rcu;
+	__u8		key[TCP_FASTOPEN_KEY_MAX][TCP_FASTOPEN_KEY_LENGTH];
+	int		num;
+	struct rcu_head	rcu;
 };
 
 extern unsigned int sysctl_tcp_fastopen_blackhole_timeout;
@@ -1665,9 +1665,7 @@ bool tcp_fastopen_cookie_match(const struct tcp_fastopen_cookie *foc,
 static inline
 int tcp_fastopen_context_len(const struct tcp_fastopen_context *ctx)
 {
-	if (ctx->tfm[1])
-		return 2;
-	return 1;
+	return ctx->num;
 }
 
 /* Latencies incurred by various limits for a sender. They are
diff --git a/net/Kconfig b/net/Kconfig
index d122f53c6fa2..57f51a279ad6 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -67,8 +67,6 @@ source "net/xdp/Kconfig"
 
 config INET
 	bool "TCP/IP networking"
-	select CRYPTO
-	select CRYPTO_AES
 	---help---
 	  These are the protocols used on the Internet and on most local
 	  Ethernets. It is highly recommended to say Y here (this will enlarge
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 7d19fa4c8121..46b67128e1ca 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -7,6 +7,7 @@
 #include <linux/tcp.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
+#include <linux/siphash.h>
 #include <net/inetpeer.h>
 #include <net/tcp.h>
 
@@ -37,14 +38,8 @@ static void tcp_fastopen_ctx_free(struct rcu_head *head)
 {
 	struct tcp_fastopen_context *ctx =
 	    container_of(head, struct tcp_fastopen_context, rcu);
-	int i;
 
-	/* We own ctx, thus no need to hold the Fastopen-lock */
-	for (i = 0; i < TCP_FASTOPEN_KEY_MAX; i++) {
-		if (ctx->tfm[i])
-			crypto_free_cipher(ctx->tfm[i]);
-	}
-	kfree(ctx);
+	kzfree(ctx);
 }
 
 void tcp_fastopen_destroy_cipher(struct sock *sk)
@@ -72,41 +67,6 @@ void tcp_fastopen_ctx_destroy(struct net *net)
 		call_rcu(&ctxt->rcu, tcp_fastopen_ctx_free);
 }
 
-static struct tcp_fastopen_context *tcp_fastopen_alloc_ctx(void *primary_key,
-							   void *backup_key,
-							   unsigned int len)
-{
-	struct tcp_fastopen_context *new_ctx;
-	void *key = primary_key;
-	int err, i;
-
-	new_ctx = kmalloc(sizeof(*new_ctx), GFP_KERNEL);
-	if (!new_ctx)
-		return ERR_PTR(-ENOMEM);
-	for (i = 0; i < TCP_FASTOPEN_KEY_MAX; i++)
-		new_ctx->tfm[i] = NULL;
-	for (i = 0; i < (backup_key ? 2 : 1); i++) {
-		new_ctx->tfm[i] = crypto_alloc_cipher("aes", 0, 0);
-		if (IS_ERR(new_ctx->tfm[i])) {
-			err = PTR_ERR(new_ctx->tfm[i]);
-			new_ctx->tfm[i] = NULL;
-			pr_err("TCP: TFO aes cipher alloc error: %d\n", err);
-			goto out;
-		}
-		err = crypto_cipher_setkey(new_ctx->tfm[i], key, len);
-		if (err) {
-			pr_err("TCP: TFO cipher key error: %d\n", err);
-			goto out;
-		}
-		memcpy(&new_ctx->key[i * TCP_FASTOPEN_KEY_LENGTH], key, len);
-		key = backup_key;
-	}
-	return new_ctx;
-out:
-	tcp_fastopen_ctx_free(&new_ctx->rcu);
-	return ERR_PTR(err);
-}
-
 int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
 			      void *primary_key, void *backup_key,
 			      unsigned int len)
@@ -115,11 +75,20 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
 	struct fastopen_queue *q;
 	int err = 0;
 
-	ctx = tcp_fastopen_alloc_ctx(primary_key, backup_key, len);
-	if (IS_ERR(ctx)) {
-		err = PTR_ERR(ctx);
+	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		err = -ENOMEM;
 		goto out;
 	}
+
+	memcpy(ctx->key[0], primary_key, len);
+	if (backup_key) {
+		memcpy(ctx->key[1], backup_key, len);
+		ctx->num = 2;
+	} else {
+		ctx->num = 1;
+	}
+
 	spin_lock(&net->ipv4.tcp_fastopen_ctx_lock);
 	if (sk) {
 		q = &inet_csk(sk)->icsk_accept_queue.fastopenq;
@@ -141,31 +110,30 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
 
 static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
 					     struct sk_buff *syn,
-					     struct crypto_cipher *tfm,
+					     const u8 *key,
 					     struct tcp_fastopen_cookie *foc)
 {
+	BUILD_BUG_ON(TCP_FASTOPEN_KEY_LENGTH != sizeof(siphash_key_t));
+	BUILD_BUG_ON(TCP_FASTOPEN_COOKIE_SIZE != sizeof(u64));
+
 	if (req->rsk_ops->family == AF_INET) {
 		const struct iphdr *iph = ip_hdr(syn);
-		__be32 path[4] = { iph->saddr, iph->daddr, 0, 0 };
 
-		crypto_cipher_encrypt_one(tfm, foc->val, (void *)path);
+		foc->val[0] = siphash(&iph->saddr,
+				      sizeof(iph->saddr) +
+				      sizeof(iph->daddr),
+				      (const siphash_key_t *)key);
 		foc->len = TCP_FASTOPEN_COOKIE_SIZE;
 		return true;
 	}
-
 #if IS_ENABLED(CONFIG_IPV6)
 	if (req->rsk_ops->family == AF_INET6) {
 		const struct ipv6hdr *ip6h = ipv6_hdr(syn);
-		struct tcp_fastopen_cookie tmp;
-		struct in6_addr *buf;
-		int i;
-
-		crypto_cipher_encrypt_one(tfm, tmp.val,
-					  (void *)&ip6h->saddr);
-		buf = &tmp.addr;
-		for (i = 0; i < 4; i++)
-			buf->s6_addr32[i] ^= ip6h->daddr.s6_addr32[i];
-		crypto_cipher_encrypt_one(tfm, foc->val, (void *)buf);
+
+		foc->val[0] = siphash(&ip6h->saddr,
+				      sizeof(ip6h->saddr) +
+				      sizeof(ip6h->daddr),
+				      (const siphash_key_t *)key);
 		foc->len = TCP_FASTOPEN_COOKIE_SIZE;
 		return true;
 	}
@@ -173,11 +141,8 @@ static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
 	return false;
 }
 
-/* Generate the fastopen cookie by doing aes128 encryption on both
- * the source and destination addresses. Pad 0s for IPv4 or IPv4-mapped-IPv6
- * addresses. For the longer IPv6 addresses use CBC-MAC.
- *
- * XXX (TFO) - refactor when TCP_FASTOPEN_COOKIE_SIZE != AES_BLOCK_SIZE.
+/* Generate the fastopen cookie by applying SipHash to both the source and
+ * destination addresses.
  */
 static void tcp_fastopen_cookie_gen(struct sock *sk,
 				    struct request_sock *req,
@@ -189,7 +154,7 @@ static void tcp_fastopen_cookie_gen(struct sock *sk,
 	rcu_read_lock();
 	ctx = tcp_fastopen_get_ctx(sk);
 	if (ctx)
-		__tcp_fastopen_cookie_gen_cipher(req, syn, ctx->tfm[0], foc);
+		__tcp_fastopen_cookie_gen_cipher(req, syn, ctx->key[0], foc);
 	rcu_read_unlock();
 }
 
@@ -253,7 +218,7 @@ static int tcp_fastopen_cookie_gen_check(struct sock *sk,
 	if (!ctx)
 		goto out;
 	for (i = 0; i < tcp_fastopen_context_len(ctx); i++) {
-		__tcp_fastopen_cookie_gen_cipher(req, syn, ctx->tfm[i], foc);
+		__tcp_fastopen_cookie_gen_cipher(req, syn, ctx->key[i], foc);
 		if (tcp_fastopen_cookie_match(foc, orig)) {
 			ret = i + 1;
 			goto out;
-- 
2.20.1

