Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DC965C6A5
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 19:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbjACSp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 13:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238522AbjACSo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 13:44:58 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CFB15735
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 10:43:09 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id o15so23532163wmr.4
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 10:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZGB0nXL5lDSPjHJnL5DlSQ8h9YUkZb4l2ZPDpaU7QxQ=;
        b=RdRMwEYxzD775m3arepB5LyRu0Ig1LHh/xcSxHPwrhelwpmtNKjgngaawdGmCeKJ4c
         GX+5cu2KWYgVpGFN6XCLdrcx+R0tfWKntrcFkXe/XR+WVIgsaL4CzpumbyOpWOWzbSHG
         jwjG8BYba3zLFHVHhCaslcYvC1ZIopP6UQbxM31WcUICjhIR2EQGrnuG8F/SFaqEb4Mc
         I7AnnKwQVgQlk5gNpjRiGt10mtf+l/oKm47mWGttc/Cqv5bSiV+1sAnZkyVluo8GyE5g
         urVVSsQk2Uw5Qm6pw44S4w2j+gUzTeWUsdbcKgyqRZjfT5toVoZTJcvSWxqa4Psx7Rkt
         95jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZGB0nXL5lDSPjHJnL5DlSQ8h9YUkZb4l2ZPDpaU7QxQ=;
        b=T1h4wQxGDh6XIGct9cvFJW+Oa02JjQxUVbe3eA9PwTZPY4IRUf5i5/nkXFosxsPJ0m
         tNpyT0/RDxLV0pxKAA1CIRBZzJB0zp9qPGfUtwrK4EaQuOM5P1fsbo7fGZHtBiK9Gc0Z
         4ya8GwfUN2xrNfLZjOLF7o3olS34cjbUyXR7/QQTLNpDMuFXDCtz5vWJPzSbV0mZgLQL
         TrDIN57ir55oQoq2ru09y5wU0fxwXE8rQEEAa0vpyH/aMVciLCLFcwoNSHJqAILpdbuV
         3Aovg8xg6PcOCndL8ehyMu49fflTarPNfy9ZHPmAz1S8nwl9nj9N7A2BMxD4PtVEobSz
         VZEQ==
X-Gm-Message-State: AFqh2krP1jL1VaHWmWCy+10YPBgs6wM99VP2uWdTsPIWg1w+DXhRn+9X
        IoMSTLl3+zIUbs+sy2w7VVFTjA==
X-Google-Smtp-Source: AMrXdXtf3rZD3poviDBHKZAwvUU6jzH+H6fClQUoPkKRYNo4Ui2CQqav2Dv2Lk5364eS9fGHfm9u6g==
X-Received: by 2002:a05:600c:26d1:b0:3d1:e907:17c1 with SMTP id 17-20020a05600c26d100b003d1e90717c1mr32083681wmv.38.1672771388426;
        Tue, 03 Jan 2023 10:43:08 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id i18-20020a5d5232000000b0028e55b44a99sm13811578wra.17.2023.01.03.10.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 10:43:08 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v2 3/5] crypto/net/tcp: Use crypto_pool for TCP-MD5
Date:   Tue,  3 Jan 2023 18:42:55 +0000
Message-Id: <20230103184257.118069-4-dima@arista.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103184257.118069-1-dima@arista.com>
References: <20230103184257.118069-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use crypto_pool API that was designed with tcp_md5sig_pool in mind.
The conversion to use crypto_pool will allow:
- to reuse ahash_request(s) for different users
- to allocate only one per-CPU scratch buffer rather than a new one for
  each user
- to have a common API for net/ users that need ahash on RX/TX fast path

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h        |  24 +++------
 net/ipv4/Kconfig         |   2 +-
 net/ipv4/tcp.c           | 105 ++++++++++-----------------------------
 net/ipv4/tcp_ipv4.c      |  92 ++++++++++++++++++++--------------
 net/ipv4/tcp_minisocks.c |  21 +++++---
 net/ipv6/tcp_ipv6.c      |  53 +++++++++-----------
 6 files changed, 129 insertions(+), 168 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index db9f828e9d1e..048057cb4c2e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1664,12 +1664,6 @@ union tcp_md5sum_block {
 #endif
 };
 
-/* - pool: digest algorithm, hash description and scratch buffer */
-struct tcp_md5sig_pool {
-	struct ahash_request	*md5_req;
-	void			*scratch;
-};
-
 /* - functions */
 int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk, const struct sk_buff *skb);
@@ -1725,17 +1719,15 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 #define tcp_twsk_md5_key(twsk)	NULL
 #endif
 
-bool tcp_alloc_md5sig_pool(void);
-
-struct tcp_md5sig_pool *tcp_get_md5sig_pool(void);
-static inline void tcp_put_md5sig_pool(void)
-{
-	local_bh_enable();
-}
+struct crypto_pool_ahash;
+int tcp_md5_alloc_crypto_pool(void);
+void tcp_md5_release_crypto_pool(void);
+void tcp_md5_add_crypto_pool(void);
+extern int tcp_md5_crypto_pool_id;
 
-int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *, const struct sk_buff *,
-			  unsigned int header_len);
-int tcp_md5_hash_key(struct tcp_md5sig_pool *hp,
+int tcp_md5_hash_skb_data(struct crypto_pool_ahash *hp,
+			  const struct sk_buff *skb, unsigned int header_len);
+int tcp_md5_hash_key(struct crypto_pool_ahash *hp,
 		     const struct tcp_md5sig_key *key);
 
 /* From tcp_fastopen.c */
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 2dfb12230f08..46e8bdb749df 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -743,7 +743,7 @@ config DEFAULT_TCP_CONG
 
 config TCP_MD5SIG
 	bool "TCP: MD5 Signature Option support (RFC2385)"
-	select CRYPTO
+	select CRYPTO_POOL
 	select CRYPTO_MD5
 	help
 	  RFC2385 specifies a method of giving MD5 protection to TCP sessions.
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c567d5e8053e..b06a21949cf0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -244,6 +244,7 @@
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -4411,98 +4412,45 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
 EXPORT_SYMBOL(tcp_getsockopt);
 
 #ifdef CONFIG_TCP_MD5SIG
-static DEFINE_PER_CPU(struct tcp_md5sig_pool, tcp_md5sig_pool);
-static DEFINE_MUTEX(tcp_md5sig_mutex);
-static bool tcp_md5sig_pool_populated = false;
+int tcp_md5_crypto_pool_id = -1;
+EXPORT_SYMBOL(tcp_md5_crypto_pool_id);
 
-static void __tcp_alloc_md5sig_pool(void)
+int tcp_md5_alloc_crypto_pool(void)
 {
-	struct crypto_ahash *hash;
-	int cpu;
-
-	hash = crypto_alloc_ahash("md5", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(hash))
-		return;
-
-	for_each_possible_cpu(cpu) {
-		void *scratch = per_cpu(tcp_md5sig_pool, cpu).scratch;
-		struct ahash_request *req;
-
-		if (!scratch) {
-			scratch = kmalloc_node(sizeof(union tcp_md5sum_block) +
-					       sizeof(struct tcphdr),
-					       GFP_KERNEL,
-					       cpu_to_node(cpu));
-			if (!scratch)
-				return;
-			per_cpu(tcp_md5sig_pool, cpu).scratch = scratch;
-		}
-		if (per_cpu(tcp_md5sig_pool, cpu).md5_req)
-			continue;
-
-		req = ahash_request_alloc(hash, GFP_KERNEL);
-		if (!req)
-			return;
+	int ret;
 
-		ahash_request_set_callback(req, 0, NULL, NULL);
+	ret = crypto_pool_reserve_scratch(sizeof(union tcp_md5sum_block) +
+					  sizeof(struct tcphdr));
+	if (ret)
+		return ret;
 
-		per_cpu(tcp_md5sig_pool, cpu).md5_req = req;
+	ret = crypto_pool_alloc_ahash("md5");
+	if (ret >= 0) {
+		tcp_md5_crypto_pool_id = ret;
+		return 0;
 	}
-	/* before setting tcp_md5sig_pool_populated, we must commit all writes
-	 * to memory. See smp_rmb() in tcp_get_md5sig_pool()
-	 */
-	smp_wmb();
-	/* Paired with READ_ONCE() from tcp_alloc_md5sig_pool()
-	 * and tcp_get_md5sig_pool().
-	*/
-	WRITE_ONCE(tcp_md5sig_pool_populated, true);
+	return ret;
 }
+EXPORT_SYMBOL(tcp_md5_alloc_crypto_pool);
 
-bool tcp_alloc_md5sig_pool(void)
+void tcp_md5_release_crypto_pool(void)
 {
-	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
-	if (unlikely(!READ_ONCE(tcp_md5sig_pool_populated))) {
-		mutex_lock(&tcp_md5sig_mutex);
-
-		if (!tcp_md5sig_pool_populated)
-			__tcp_alloc_md5sig_pool();
-
-		mutex_unlock(&tcp_md5sig_mutex);
-	}
-	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
-	return READ_ONCE(tcp_md5sig_pool_populated);
+	crypto_pool_release(tcp_md5_crypto_pool_id);
 }
-EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
+EXPORT_SYMBOL(tcp_md5_release_crypto_pool);
 
-
-/**
- *	tcp_get_md5sig_pool - get md5sig_pool for this user
- *
- *	We use percpu structure, so if we succeed, we exit with preemption
- *	and BH disabled, to make sure another thread or softirq handling
- *	wont try to get same context.
- */
-struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
+void tcp_md5_add_crypto_pool(void)
 {
-	local_bh_disable();
-
-	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
-	if (READ_ONCE(tcp_md5sig_pool_populated)) {
-		/* coupled with smp_wmb() in __tcp_alloc_md5sig_pool() */
-		smp_rmb();
-		return this_cpu_ptr(&tcp_md5sig_pool);
-	}
-	local_bh_enable();
-	return NULL;
+	crypto_pool_add(tcp_md5_crypto_pool_id);
 }
-EXPORT_SYMBOL(tcp_get_md5sig_pool);
+EXPORT_SYMBOL(tcp_md5_add_crypto_pool);
 
-int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
+int tcp_md5_hash_skb_data(struct crypto_pool_ahash *hp,
 			  const struct sk_buff *skb, unsigned int header_len)
 {
 	struct scatterlist sg;
 	const struct tcphdr *tp = tcp_hdr(skb);
-	struct ahash_request *req = hp->md5_req;
+	struct ahash_request *req = hp->req;
 	unsigned int i;
 	const unsigned int head_data_len = skb_headlen(skb) > header_len ?
 					   skb_headlen(skb) - header_len : 0;
@@ -4536,16 +4484,17 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 }
 EXPORT_SYMBOL(tcp_md5_hash_skb_data);
 
-int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *key)
+int tcp_md5_hash_key(struct crypto_pool_ahash *hp,
+		     const struct tcp_md5sig_key *key)
 {
 	u8 keylen = READ_ONCE(key->keylen); /* paired with WRITE_ONCE() in tcp_md5_do_add */
 	struct scatterlist sg;
 
 	sg_init_one(&sg, key->key, keylen);
-	ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
+	ahash_request_set_crypt(hp->req, &sg, NULL, keylen);
 
 	/* We use data_race() because tcp_md5_do_add() might change key->key under us */
-	return data_race(crypto_ahash_update(hp->md5_req));
+	return data_race(crypto_ahash_update(hp->req));
 }
 EXPORT_SYMBOL(tcp_md5_hash_key);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8320d0ecb13a..93273b9a2948 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -79,6 +79,7 @@
 #include <linux/btf_ids.h>
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
@@ -1212,10 +1213,6 @@ static int __tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
 	if (!key)
 		return -ENOMEM;
-	if (!tcp_alloc_md5sig_pool()) {
-		sock_kfree_s(sk, key, sizeof(*key));
-		return -ENOMEM;
-	}
 
 	memcpy(key->key, newkey, newkeylen);
 	key->keylen = newkeylen;
@@ -1237,8 +1234,13 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
-		if (tcp_md5sig_info_add(sk, GFP_KERNEL))
+		if (tcp_md5_alloc_crypto_pool())
+			return -ENOMEM;
+
+		if (tcp_md5sig_info_add(sk, GFP_KERNEL)) {
+			tcp_md5_release_crypto_pool();
 			return -ENOMEM;
+		}
 
 		if (!static_branch_inc(&tcp_md5_needed.key)) {
 			struct tcp_md5sig_info *md5sig;
@@ -1246,6 +1248,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 			md5sig = rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
 			rcu_assign_pointer(tp->md5sig_info, NULL);
 			kfree_rcu(md5sig, rcu);
+			tcp_md5_release_crypto_pool();
 			return -EUSERS;
 		}
 	}
@@ -1262,8 +1265,12 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
-		if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC)))
+		tcp_md5_add_crypto_pool();
+
+		if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC))) {
+			tcp_md5_release_crypto_pool();
 			return -ENOMEM;
+		}
 
 		if (!static_key_fast_inc_not_disabled(&tcp_md5_needed.key.key)) {
 			struct tcp_md5sig_info *md5sig;
@@ -1272,6 +1279,7 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
 			net_warn_ratelimited("Too many TCP-MD5 keys in the system\n");
 			rcu_assign_pointer(tp->md5sig_info, NULL);
 			kfree_rcu(md5sig, rcu);
+			tcp_md5_release_crypto_pool();
 			return -EUSERS;
 		}
 	}
@@ -1371,7 +1379,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
-static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
+static int tcp_v4_md5_hash_headers(struct crypto_pool_ahash *hp,
 				   __be32 daddr, __be32 saddr,
 				   const struct tcphdr *th, int nbytes)
 {
@@ -1379,7 +1387,7 @@ static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
 	struct scatterlist sg;
 	struct tcphdr *_th;
 
-	bp = hp->scratch;
+	bp = hp->base.scratch;
 	bp->saddr = saddr;
 	bp->daddr = daddr;
 	bp->pad = 0;
@@ -1391,37 +1399,34 @@ static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
 	_th->check = 0;
 
 	sg_init_one(&sg, bp, sizeof(*bp) + sizeof(*th));
-	ahash_request_set_crypt(hp->md5_req, &sg, NULL,
+	ahash_request_set_crypt(hp->req, &sg, NULL,
 				sizeof(*bp) + sizeof(*th));
-	return crypto_ahash_update(hp->md5_req);
+	return crypto_ahash_update(hp->req);
 }
 
 static int tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 			       __be32 daddr, __be32 saddr, const struct tcphdr *th)
 {
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct crypto_pool_ahash hp;
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
+	if (crypto_pool_get(tcp_md5_crypto_pool_id, (struct crypto_pool *)&hp))
 		goto clear_hash_noput;
-	req = hp->md5_req;
 
-	if (crypto_ahash_init(req))
+	if (crypto_ahash_init(hp.req))
 		goto clear_hash;
-	if (tcp_v4_md5_hash_headers(hp, daddr, saddr, th, th->doff << 2))
+	if (tcp_v4_md5_hash_headers(&hp, daddr, saddr, th, th->doff << 2))
 		goto clear_hash;
-	if (tcp_md5_hash_key(hp, key))
+	if (tcp_md5_hash_key(&hp, key))
 		goto clear_hash;
-	ahash_request_set_crypt(req, NULL, md5_hash, 0);
-	if (crypto_ahash_final(req))
+	ahash_request_set_crypt(hp.req, NULL, md5_hash, 0);
+	if (crypto_ahash_final(hp.req))
 		goto clear_hash;
 
-	tcp_put_md5sig_pool();
+	crypto_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
+	crypto_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
@@ -1431,8 +1436,7 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk,
 			const struct sk_buff *skb)
 {
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct crypto_pool_ahash hp;
 	const struct tcphdr *th = tcp_hdr(skb);
 	__be32 saddr, daddr;
 
@@ -1445,29 +1449,27 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 		daddr = iph->daddr;
 	}
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
+	if (crypto_pool_get(tcp_md5_crypto_pool_id, (struct crypto_pool *)&hp))
 		goto clear_hash_noput;
-	req = hp->md5_req;
 
-	if (crypto_ahash_init(req))
+	if (crypto_ahash_init(hp.req))
 		goto clear_hash;
 
-	if (tcp_v4_md5_hash_headers(hp, daddr, saddr, th, skb->len))
+	if (tcp_v4_md5_hash_headers(&hp, daddr, saddr, th, skb->len))
 		goto clear_hash;
-	if (tcp_md5_hash_skb_data(hp, skb, th->doff << 2))
+	if (tcp_md5_hash_skb_data(&hp, skb, th->doff << 2))
 		goto clear_hash;
-	if (tcp_md5_hash_key(hp, key))
+	if (tcp_md5_hash_key(&hp, key))
 		goto clear_hash;
-	ahash_request_set_crypt(req, NULL, md5_hash, 0);
-	if (crypto_ahash_final(req))
+	ahash_request_set_crypt(hp.req, NULL, md5_hash, 0);
+	if (crypto_ahash_final(hp.req))
 		goto clear_hash;
 
-	tcp_put_md5sig_pool();
+	crypto_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
+	crypto_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
@@ -2285,6 +2287,18 @@ static int tcp_v4_init_sock(struct sock *sk)
 	return 0;
 }
 
+#ifdef CONFIG_TCP_MD5SIG
+static void tcp_md5sig_info_free_rcu(struct rcu_head *head)
+{
+	struct tcp_md5sig_info *md5sig;
+
+	md5sig = container_of(head, struct tcp_md5sig_info, rcu);
+	kfree(md5sig);
+	static_branch_slow_dec_deferred(&tcp_md5_needed);
+	tcp_md5_release_crypto_pool();
+}
+#endif
+
 void tcp_v4_destroy_sock(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -2309,10 +2323,12 @@ void tcp_v4_destroy_sock(struct sock *sk)
 #ifdef CONFIG_TCP_MD5SIG
 	/* Clean up the MD5 key list, if any */
 	if (tp->md5sig_info) {
+		struct tcp_md5sig_info *md5sig;
+
+		md5sig = rcu_dereference_protected(tp->md5sig_info, 1);
 		tcp_clear_md5_list(sk);
-		kfree_rcu(rcu_dereference_protected(tp->md5sig_info, 1), rcu);
-		tp->md5sig_info = NULL;
-		static_branch_slow_dec_deferred(&tcp_md5_needed);
+		call_rcu(&md5sig->rcu, tcp_md5sig_info_free_rcu);
+		rcu_assign_pointer(tp->md5sig_info, NULL);
 	}
 #endif
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index e002f2e1d4f2..b2ffda09f3b4 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -261,11 +261,10 @@ static void tcp_time_wait_init(struct sock *sk, struct tcp_timewait_sock *tcptw)
 		tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
 		if (!tcptw->tw_md5_key)
 			return;
-		if (!tcp_alloc_md5sig_pool())
-			goto out_free;
 		if (!static_key_fast_inc_not_disabled(&tcp_md5_needed.key.key))
 			goto out_free;
 	}
+	tcp_md5_add_crypto_pool();
 	return;
 out_free:
 	WARN_ON_ONCE(1);
@@ -349,16 +348,26 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 }
 EXPORT_SYMBOL(tcp_time_wait);
 
+#ifdef CONFIG_TCP_MD5SIG
+static void tcp_md5_twsk_free_rcu(struct rcu_head *head)
+{
+	struct tcp_md5sig_key *key;
+
+	key = container_of(head, struct tcp_md5sig_key, rcu);
+	kfree(key);
+	static_branch_slow_dec_deferred(&tcp_md5_needed);
+	tcp_md5_release_crypto_pool();
+}
+#endif
+
 void tcp_twsk_destructor(struct sock *sk)
 {
 #ifdef CONFIG_TCP_MD5SIG
 	if (static_branch_unlikely(&tcp_md5_needed.key)) {
 		struct tcp_timewait_sock *twsk = tcp_twsk(sk);
 
-		if (twsk->tw_md5_key) {
-			kfree_rcu(twsk->tw_md5_key, rcu);
-			static_branch_slow_dec_deferred(&tcp_md5_needed);
-		}
+		if (twsk->tw_md5_key)
+			call_rcu(&twsk->tw_md5_key->rcu, tcp_md5_twsk_free_rcu);
 	}
 #endif
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 11b736a76bd7..1a94b5f6d152 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -64,6 +64,7 @@
 #include <linux/seq_file.h>
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
@@ -672,7 +673,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
-static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
+static int tcp_v6_md5_hash_headers(struct crypto_pool_ahash *hp,
 				   const struct in6_addr *daddr,
 				   const struct in6_addr *saddr,
 				   const struct tcphdr *th, int nbytes)
@@ -681,7 +682,7 @@ static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
 	struct scatterlist sg;
 	struct tcphdr *_th;
 
-	bp = hp->scratch;
+	bp = hp->base.scratch;
 	/* 1. TCP pseudo-header (RFC2460) */
 	bp->saddr = *saddr;
 	bp->daddr = *daddr;
@@ -693,38 +694,35 @@ static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
 	_th->check = 0;
 
 	sg_init_one(&sg, bp, sizeof(*bp) + sizeof(*th));
-	ahash_request_set_crypt(hp->md5_req, &sg, NULL,
+	ahash_request_set_crypt(hp->req, &sg, NULL,
 				sizeof(*bp) + sizeof(*th));
-	return crypto_ahash_update(hp->md5_req);
+	return crypto_ahash_update(hp->req);
 }
 
 static int tcp_v6_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 			       const struct in6_addr *daddr, struct in6_addr *saddr,
 			       const struct tcphdr *th)
 {
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct crypto_pool_ahash hp;
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
+	if (crypto_pool_get(tcp_md5_crypto_pool_id, (struct crypto_pool *)&hp))
 		goto clear_hash_noput;
-	req = hp->md5_req;
 
-	if (crypto_ahash_init(req))
+	if (crypto_ahash_init(hp.req))
 		goto clear_hash;
-	if (tcp_v6_md5_hash_headers(hp, daddr, saddr, th, th->doff << 2))
+	if (tcp_v6_md5_hash_headers(&hp, daddr, saddr, th, th->doff << 2))
 		goto clear_hash;
-	if (tcp_md5_hash_key(hp, key))
+	if (tcp_md5_hash_key(&hp, key))
 		goto clear_hash;
-	ahash_request_set_crypt(req, NULL, md5_hash, 0);
-	if (crypto_ahash_final(req))
+	ahash_request_set_crypt(hp.req, NULL, md5_hash, 0);
+	if (crypto_ahash_final(hp.req))
 		goto clear_hash;
 
-	tcp_put_md5sig_pool();
+	crypto_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
+	crypto_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
@@ -736,8 +734,7 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 			       const struct sk_buff *skb)
 {
 	const struct in6_addr *saddr, *daddr;
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct crypto_pool_ahash hp;
 	const struct tcphdr *th = tcp_hdr(skb);
 
 	if (sk) { /* valid for establish/request sockets */
@@ -749,29 +746,27 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 		daddr = &ip6h->daddr;
 	}
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
+	if (crypto_pool_get(tcp_md5_crypto_pool_id, (struct crypto_pool *)&hp))
 		goto clear_hash_noput;
-	req = hp->md5_req;
 
-	if (crypto_ahash_init(req))
+	if (crypto_ahash_init(hp.req))
 		goto clear_hash;
 
-	if (tcp_v6_md5_hash_headers(hp, daddr, saddr, th, skb->len))
+	if (tcp_v6_md5_hash_headers(&hp, daddr, saddr, th, skb->len))
 		goto clear_hash;
-	if (tcp_md5_hash_skb_data(hp, skb, th->doff << 2))
+	if (tcp_md5_hash_skb_data(&hp, skb, th->doff << 2))
 		goto clear_hash;
-	if (tcp_md5_hash_key(hp, key))
+	if (tcp_md5_hash_key(&hp, key))
 		goto clear_hash;
-	ahash_request_set_crypt(req, NULL, md5_hash, 0);
-	if (crypto_ahash_final(req))
+	ahash_request_set_crypt(hp.req, NULL, md5_hash, 0);
+	if (crypto_ahash_final(hp.req))
 		goto clear_hash;
 
-	tcp_put_md5sig_pool();
+	crypto_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
+	crypto_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
-- 
2.39.0

