Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF91745B3E
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 13:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfFNLOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 07:14:21 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41767 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbfFNLOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 07:14:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so2087786wrm.8
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 04:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A6Z1LqiLaSf16bzt/TLpDp5YwVKxpkQ5dNmQV6Owvz0=;
        b=e62gdd4ZrP0D78wf96huq0fpS+pSSTU+2nQwff9qnWgYVWIbNAdhA3VNNfcUJiLUCu
         w2L54zNs8czz/uDUbyON3W5M8pcUtszaid62cTyrig3/FmJ4/rQTdBK3OgVMV1ry33jX
         TDi9C52GBiDWt8GaM12EiXE4a98Hhx2kPes1kprz9V+9AXp5iWqWXFAjJaMN6PSmXL/V
         U8P7r+Er8kwX4gNHFl9Akl9FDsN95Ei2ZkFtHazidheyN4p7B/oBVW1JWPtP/xmv9Tv3
         r6kJzaTEsrjO3gv0z9oaTdOV4LQcfKHRW3ayknJV3/VUxkxvcH1cFazsYE95Utgf/upq
         BnOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A6Z1LqiLaSf16bzt/TLpDp5YwVKxpkQ5dNmQV6Owvz0=;
        b=P14w9+uWH7IQwzocr2kg2OK2sx2L2/LxtgU8snNOjrk5zxYhK9W654fbMYxKUnkUiJ
         WAajVz/8jRFF5rB+ZjJh3xtk2ELYNpSeSFL0HTJ59z29gmW7zy4XKr6nh9TgmzhDiNp7
         hDrYjHLNagaeQ2ksEIC5MP1ATl8ycboIuU0XBcrGY1m4TMibr5HcXexR7s8gRe/MPOkB
         +wZqmPzHw1e7Da/MVJusij0ffWvp2dxJkDyqYnfku7gEugRwdHJeZaDL4aUnMGYJ9426
         Ia9dJCCfeE4cFPDlwK624D/Iq0bwqW+xo1LLqOSQvYXuIljZja5d6DnPcsaM0eV5PR82
         DWWQ==
X-Gm-Message-State: APjAAAXK+qfbqOEb/39+dfdYVnn2/aoC2ShnHsfxsJqn8JbQ7DgzhbCV
        EvbBpQ5p4z4/rgV+MvNi+DAOXBLVYdontg==
X-Google-Smtp-Source: APXvYqwxQcS1wE9M3wyhSJruFuZ7TtazTdbJrfGd3cPn2FfVXaYoCW0F2pfuVSNTeuljyiquU4AIlQ==
X-Received: by 2002:a5d:5552:: with SMTP id g18mr3412414wrw.254.1560510858213;
        Fri, 14 Jun 2019 04:14:18 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:e99d:7886:2d7f:9b24])
        by smtp.gmail.com with ESMTPSA id o11sm2238693wmh.37.2019.06.14.04.14.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 04:14:17 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebigger@kernel.org, edumazet@google.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH] net: ipv4: move tcp_fastopen server side code to SipHash library
Date:   Fri, 14 Jun 2019 13:14:07 +0200
Message-Id: <20190614111407.26725-1-ard.biesheuvel@linaro.org>
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

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
NOTE: This approach assumes that there are no external dependencies,
      i.e., that there are no tools that implement the same algorithm
      to calculate TCP fastopen cookies outside of the kernel.

 include/linux/tcp.h     |  7 +--
 include/net/tcp.h       |  1 -
 net/ipv4/tcp_fastopen.c | 55 +++++++-------------
 3 files changed, 19 insertions(+), 44 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 711361af9ce0..ce3319133632 100644
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
index ac2f53fbfa6b..1630e61bd3e4 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1624,7 +1624,6 @@ bool tcp_fastopen_defer_connect(struct sock *sk, int *err);
 
 /* Fastopen key context */
 struct tcp_fastopen_context {
-	struct crypto_cipher	*tfm;
 	__u8			key[TCP_FASTOPEN_KEY_LENGTH];
 	struct rcu_head		rcu;
 };
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 018a48477355..4d3ccfa6b7ce 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -7,6 +7,7 @@
 #include <linux/tcp.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
+#include <linux/siphash.h>
 #include <net/inetpeer.h>
 #include <net/tcp.h>
 
@@ -37,8 +38,7 @@ static void tcp_fastopen_ctx_free(struct rcu_head *head)
 {
 	struct tcp_fastopen_context *ctx =
 	    container_of(head, struct tcp_fastopen_context, rcu);
-	crypto_free_cipher(ctx->tfm);
-	kfree(ctx);
+	kzfree(ctx);
 }
 
 void tcp_fastopen_destroy_cipher(struct sock *sk)
@@ -76,23 +76,9 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
-	ctx->tfm = crypto_alloc_cipher("aes", 0, 0);
 
-	if (IS_ERR(ctx->tfm)) {
-		err = PTR_ERR(ctx->tfm);
-error:		kfree(ctx);
-		pr_err("TCP: TFO aes cipher alloc error: %d\n", err);
-		return err;
-	}
-	err = crypto_cipher_setkey(ctx->tfm, key, len);
-	if (err) {
-		pr_err("TCP: TFO cipher key error: %d\n", err);
-		crypto_free_cipher(ctx->tfm);
-		goto error;
-	}
 	memcpy(ctx->key, key, len);
 
-
 	spin_lock(&net->ipv4.tcp_fastopen_ctx_lock);
 	if (sk) {
 		q = &inet_csk(sk)->icsk_accept_queue.fastopenq;
@@ -112,11 +98,14 @@ error:		kfree(ctx);
 }
 
 static bool __tcp_fastopen_cookie_gen(struct sock *sk, const void *path,
-				      struct tcp_fastopen_cookie *foc)
+				      int size, struct tcp_fastopen_cookie *foc)
 {
 	struct tcp_fastopen_context *ctx;
 	bool ok = false;
 
+	BUILD_BUG_ON(sizeof(siphash_key_t) != TCP_FASTOPEN_KEY_LENGTH);
+	BUILD_BUG_ON(sizeof(u64) != TCP_FASTOPEN_COOKIE_SIZE);
+
 	rcu_read_lock();
 
 	ctx = rcu_dereference(inet_csk(sk)->icsk_accept_queue.fastopenq.ctx);
@@ -124,7 +113,7 @@ static bool __tcp_fastopen_cookie_gen(struct sock *sk, const void *path,
 		ctx = rcu_dereference(sock_net(sk)->ipv4.tcp_fastopen_ctx);
 
 	if (ctx) {
-		crypto_cipher_encrypt_one(ctx->tfm, foc->val, path);
+		foc->val[0] = siphash(path, size, (siphash_key_t *)&ctx->key);
 		foc->len = TCP_FASTOPEN_COOKIE_SIZE;
 		ok = true;
 	}
@@ -132,11 +121,8 @@ static bool __tcp_fastopen_cookie_gen(struct sock *sk, const void *path,
 	return ok;
 }
 
-/* Generate the fastopen cookie by doing aes128 encryption on both
- * the source and destination addresses. Pad 0s for IPv4 or IPv4-mapped-IPv6
- * addresses. For the longer IPv6 addresses use CBC-MAC.
- *
- * XXX (TFO) - refactor when TCP_FASTOPEN_COOKIE_SIZE != AES_BLOCK_SIZE.
+/* Generate the fastopen cookie by applying SipHash to both the source and
+ * destination addresses.
  */
 static bool tcp_fastopen_cookie_gen(struct sock *sk,
 				    struct request_sock *req,
@@ -146,25 +132,20 @@ static bool tcp_fastopen_cookie_gen(struct sock *sk,
 	if (req->rsk_ops->family == AF_INET) {
 		const struct iphdr *iph = ip_hdr(syn);
 
-		__be32 path[4] = { iph->saddr, iph->daddr, 0, 0 };
-		return __tcp_fastopen_cookie_gen(sk, path, foc);
+		return __tcp_fastopen_cookie_gen(sk, &iph->saddr,
+						 sizeof(iph->saddr) +
+						 sizeof(iph->daddr),
+						 foc);
 	}
 
-#if IS_ENABLED(CONFIG_IPV6)
-	if (req->rsk_ops->family == AF_INET6) {
+	if (IS_ENABLED(CONFIG_IPV6) && req->rsk_ops->family == AF_INET6) {
 		const struct ipv6hdr *ip6h = ipv6_hdr(syn);
-		struct tcp_fastopen_cookie tmp;
-
-		if (__tcp_fastopen_cookie_gen(sk, &ip6h->saddr, &tmp)) {
-			struct in6_addr *buf = &tmp.addr;
-			int i;
 
-			for (i = 0; i < 4; i++)
-				buf->s6_addr32[i] ^= ip6h->daddr.s6_addr32[i];
-			return __tcp_fastopen_cookie_gen(sk, buf, foc);
-		}
+		return __tcp_fastopen_cookie_gen(sk, &ip6h->saddr,
+						 sizeof(ip6h->saddr) +
+						 sizeof(ip6h->daddr),
+						 foc);
 	}
-#endif
 	return false;
 }
 
-- 
2.20.1

