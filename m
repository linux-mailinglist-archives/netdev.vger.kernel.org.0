Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B68497ECA
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239240AbiAXMNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239227AbiAXMNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:13:35 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35ACCC061749;
        Mon, 24 Jan 2022 04:13:27 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id m4so20850047ejb.9;
        Mon, 24 Jan 2022 04:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z1MzRL3KGUT7mmdNhGvG5Z+aU+EMpVJKg8j7N+zPlbU=;
        b=Hz6QlKUoZ/ssQYmT9J4AeNL6da9nj5fjOZFb75MvM4DuQhES9JPBpNWiGeymoInguZ
         +fR86Cu7VqG+95Owl0d1Sf9NuqSIdmibt4a4JFFjuahT0fIf10lDCSSEoC9ucAdOPb37
         J+NAA7TxUo4asVYmYUko5j5IlPpf3hzyu5xPaxFdoi4LT6Dyw9HMRf+XE5honwU9JNIn
         J9ugCxGAxkPOZM9Gu6TrNuAxQExx3flEMGcpHr2fAZLUlV7QoM14vaLHgY/grQX3icHh
         oh4OXPmh06zRt1pdQ92Ztnye5hN1UImnUbGGTTsA6K9Pbe62hlNV9eagCqdU5Kifhy/k
         3OdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z1MzRL3KGUT7mmdNhGvG5Z+aU+EMpVJKg8j7N+zPlbU=;
        b=nyr16tZGXIP8wWysfaNjhzoCd9a/JsYdvxKpdjVNuSjmJSbEtQ1PmcTmJTm1hg7HAh
         xlbPSQoI4SG2FI1ttHBj8dO6P8hnTE2NGsDw3qTbeQ6uvxMCBv3nlfrVoBHOIHFaE684
         c1UGgAdDpMTxI3LCpJ97eq8ooXutjb9z7DyNts9olVUN2IVnjkK52lQEEDnbXCN1cBF4
         DgsEazrr9bnpY4K2ENIguqlMzI/7sIEzc9T/oWqlHLrhIOGv6sngc2MUsXDqCe1SQAdo
         qLF4HYQI9DdAayjLgOlS2ndPVeHrAxAMiuosm1qbb8C9+FEIOJaPr1gdY/NMe04QpV19
         qYFA==
X-Gm-Message-State: AOAM532In+SnF6A5jHXkrexvR1rOEadWPXx9AGUsqX+CqHgC8zoxEYOK
        Pt91KRqN9kfcd8zijjxnYc4=
X-Google-Smtp-Source: ABdhPJxjnWvD0L3ns46CwyTx5Q2syvIMCJO44US+TV+FEZNnHDuAVkd7IZnZp2V+u2dA5FUQ0oGLkw==
X-Received: by 2002:a17:907:1690:: with SMTP id hc16mr1227577ejc.445.1643026405742;
        Mon, 24 Jan 2022 04:13:25 -0800 (PST)
Received: from ponky.lan ([2a04:241e:502:a09c:a21f:7a9f:9158:4a40])
        by smtp.gmail.com with ESMTPSA id b16sm4847517eja.211.2022.01.24.04.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:13:25 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
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
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 03/20] tcp: authopt: Add crypto initialization
Date:   Mon, 24 Jan 2022 14:12:49 +0200
Message-Id: <43d6fdc8afe265731e31a5c5099e9cbbad7cf52d.1643026076.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1643026076.git.cdleonard@gmail.com>
References: <cover.1643026076.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The crypto_shash API is used in order to compute packet signatures. The
API comes with several unfortunate limitations:

1) Allocating a crypto_shash can sleep and must be done in user context.
2) Packet signatures must be computed in softirq context
3) Packet signatures use dynamic "traffic keys" which require exclusive
access to crypto_shash for crypto_setkey.

The solution is to allocate one crypto_shash for each possible cpu for
each algorithm at setsockopt time. The per-cpu tfm is then borrowed from
softirq context, signatures are computed and the tfm is returned.

The pool for each algorithm is allocated on first use.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |  16 ++++
 net/ipv4/tcp_authopt.c    | 195 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 210 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 0d9cab459d10..bbd0c0977954 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -4,10 +4,24 @@
 
 #include <uapi/linux/tcp.h>
 #include <net/netns/tcp_authopt.h>
 #include <linux/tcp.h>
 
+/* According to RFC5925 the length of the authentication option varies based on
+ * the signature algorithm. Linux only implements the algorithms defined in
+ * RFC5926 which have a constant length of 16.
+ *
+ * This is used in stack allocation of tcp option buffers for output. It is
+ * shorter than the length of the MD5 option.
+ *
+ * Input packets can have authentication options of different lengths but they
+ * will always be flagged as invalid (since no such algorithms are supported).
+ */
+#define TCPOLEN_AUTHOPT_OUTPUT	16
+
+struct tcp_authopt_alg_imp;
+
 /**
  * struct tcp_authopt_key_info - Representation of a Master Key Tuple as per RFC5925
  *
  * Key structure lifetime is protected by RCU so send/recv code needs to hold a
  * single rcu_read_lock until they're done with the key.
@@ -33,10 +47,12 @@ struct tcp_authopt_key_info {
 	u8 keylen;
 	/** @key: Same as &tcp_authopt_key.key */
 	u8 key[TCP_AUTHOPT_MAXKEYLEN];
 	/** @addr: Same as &tcp_authopt_key.addr */
 	struct sockaddr_storage addr;
+	/** @alg: Algorithm implementation matching alg_id */
+	struct tcp_authopt_alg_imp *alg;
 };
 
 /**
  * struct tcp_authopt_info - Per-socket information regarding tcp_authopt
  *
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 17392c42e99f..9c853e2e0627 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -2,10 +2,192 @@
 
 #include <net/tcp_authopt.h>
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/kref.h>
+#include <crypto/hash.h>
+
+/* All current algorithms have a mac length of 12 but crypto API digestsize can be larger */
+#define TCP_AUTHOPT_MAXMACBUF			20
+#define TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN		20
+#define TCP_AUTHOPT_MACLEN			12
+
+struct tcp_authopt_alg_pool {
+	struct crypto_ahash *tfm;
+	struct ahash_request *req;
+};
+
+/* Constant data with per-algorithm information from RFC5926
+ * The "KDF" and "MAC" happen to be the same for both algorithms.
+ */
+struct tcp_authopt_alg_imp {
+	/* Name of algorithm in crypto-api */
+	const char *alg_name;
+	/* One of the TCP_AUTHOPT_ALG_* constants from uapi */
+	u8 alg_id;
+	/* Length of traffic key */
+	u8 traffic_key_len;
+
+	/* shared crypto_ahash */
+	struct mutex init_mutex;
+	bool init_done;
+	struct tcp_authopt_alg_pool __percpu *pool;
+};
+
+static struct tcp_authopt_alg_imp tcp_authopt_alg_list[] = {
+	{
+		.alg_id = TCP_AUTHOPT_ALG_HMAC_SHA_1_96,
+		.alg_name = "hmac(sha1)",
+		.traffic_key_len = 20,
+		.init_mutex = __MUTEX_INITIALIZER(tcp_authopt_alg_list[0].init_mutex),
+	},
+	{
+		.alg_id = TCP_AUTHOPT_ALG_AES_128_CMAC_96,
+		.alg_name = "cmac(aes)",
+		.traffic_key_len = 16,
+		.init_mutex = __MUTEX_INITIALIZER(tcp_authopt_alg_list[1].init_mutex),
+	},
+};
+
+/* get a pointer to the tcp_authopt_alg instance or NULL if id invalid */
+static inline struct tcp_authopt_alg_imp *tcp_authopt_alg_get(int alg_num)
+{
+	if (alg_num <= 0 || alg_num > 2)
+		return NULL;
+	return &tcp_authopt_alg_list[alg_num - 1];
+}
+
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
+	if (!IS_ERR_OR_NULL(pool->req))
+		ahash_request_free(pool->req);
+	pool->req = NULL;
+	if (!IS_ERR_OR_NULL(pool->tfm))
+		crypto_free_ahash(pool->tfm);
+	pool->tfm = NULL;
+}
+
+static void __tcp_authopt_alg_free(struct tcp_authopt_alg_imp *alg)
+{
+	int cpu;
+	struct tcp_authopt_alg_pool *pool;
+
+	if (!alg->pool)
+		return;
+	for_each_possible_cpu(cpu) {
+		pool = per_cpu_ptr(alg->pool, cpu);
+		tcp_authopt_alg_pool_free(pool);
+	}
+	free_percpu(alg->pool);
+	alg->pool = NULL;
+}
+
+static int __tcp_authopt_alg_init(struct tcp_authopt_alg_imp *alg)
+{
+	struct tcp_authopt_alg_pool *pool;
+	int cpu;
+	int err;
+
+	BUILD_BUG_ON(TCP_AUTHOPT_MAXMACBUF < TCPOLEN_AUTHOPT_OUTPUT);
+	if (WARN_ON_ONCE(alg->traffic_key_len > TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN))
+		return -ENOBUFS;
+
+	alg->pool = alloc_percpu(struct tcp_authopt_alg_pool);
+	if (!alg->pool)
+		return -ENOMEM;
+	for_each_possible_cpu(cpu) {
+		pool = per_cpu_ptr(alg->pool, cpu);
+		err = tcp_authopt_alg_pool_init(alg, pool);
+		if (err)
+			goto out_err;
+
+		pool = per_cpu_ptr(alg->pool, cpu);
+		/* sanity checks: */
+		if (WARN_ON_ONCE(crypto_ahash_digestsize(pool->tfm) != alg->traffic_key_len)) {
+			err = -EINVAL;
+			goto out_err;
+		}
+		if (WARN_ON_ONCE(crypto_ahash_digestsize(pool->tfm) > TCP_AUTHOPT_MAXMACBUF)) {
+			err = -EINVAL;
+			goto out_err;
+		}
+	}
+	return 0;
+
+out_err:
+	pr_info("Failed to initialize %s\n", alg->alg_name);
+	__tcp_authopt_alg_free(alg);
+	return err;
+}
+
+static int tcp_authopt_alg_require(struct tcp_authopt_alg_imp *alg)
+{
+	int err = 0;
+
+	mutex_lock(&alg->init_mutex);
+	if (alg->init_done)
+		goto out;
+	err = __tcp_authopt_alg_init(alg);
+	if (err)
+		goto out;
+	pr_info("initialized tcp-ao algorithm %s", alg->alg_name);
+	alg->init_done = true;
+
+out:
+	mutex_unlock(&alg->init_mutex);
+	return err;
+}
+
+static struct tcp_authopt_alg_pool *tcp_authopt_alg_get_pool(struct tcp_authopt_alg_imp *alg)
+{
+	local_bh_disable();
+	return this_cpu_ptr(alg->pool);
+}
+
+static void tcp_authopt_alg_put_pool(struct tcp_authopt_alg_imp *alg,
+				     struct tcp_authopt_alg_pool *pool)
+{
+	WARN_ON(pool != this_cpu_ptr(alg->pool));
+	local_bh_enable();
+}
+
+static struct tcp_authopt_alg_pool *tcp_authopt_get_kdf_pool(struct tcp_authopt_key_info *key)
+{
+	return tcp_authopt_alg_get_pool(key->alg);
+}
+
+static void tcp_authopt_put_kdf_pool(struct tcp_authopt_key_info *key,
+				     struct tcp_authopt_alg_pool *pool)
+{
+	return tcp_authopt_alg_put_pool(key->alg, pool);
+}
+
+static struct tcp_authopt_alg_pool *tcp_authopt_get_mac_pool(struct tcp_authopt_key_info *key)
+{
+	return tcp_authopt_alg_get_pool(key->alg);
+}
+
+static void tcp_authopt_put_mac_pool(struct tcp_authopt_key_info *key,
+				     struct tcp_authopt_alg_pool *pool)
+{
+	return tcp_authopt_alg_put_pool(key->alg, pool);
+}
 
 static inline struct netns_tcp_authopt *sock_net_tcp_authopt(const struct sock *sk)
 {
 	return &sock_net(sk)->tcp_authopt;
 }
@@ -49,11 +231,10 @@ void tcp_authopt_clear(struct sock *sk)
 	if (info) {
 		tcp_authopt_free(sk, info);
 		tcp_sk(sk)->authopt_info = NULL;
 	}
 }
-
 /* checks that ipv4 or ipv6 addr matches. */
 static bool ipvx_addr_match(struct sockaddr_storage *a1,
 			    struct sockaddr_storage *a2)
 {
 	if (a1->ss_family != a2->ss_family)
@@ -206,10 +387,11 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
 	struct tcp_authopt_key_info *key_info, *old_key_info;
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
+	struct tcp_authopt_alg_imp *alg;
 	int err;
 
 	sock_owned_by_me(sk);
 	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
@@ -247,10 +429,20 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	/* Initialize tcp_authopt_info if not already set */
 	info = __tcp_authopt_info_get_or_create(sk);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 
+	/* check the algorithm */
+	alg = tcp_authopt_alg_get(opt.alg);
+	if (!alg)
+		return -EINVAL;
+	if (WARN_ON_ONCE(alg->alg_id != opt.alg))
+		return -EINVAL;
+	err = tcp_authopt_alg_require(alg);
+	if (err)
+		return err;
+
 	key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
 	if (!key_info)
 		return -ENOMEM;
 	mutex_lock(&net->mutex);
 	kref_init(&key_info->ref);
@@ -262,10 +454,11 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 		tcp_authopt_key_del(net, old_key_info);
 	key_info->flags = opt.flags & TCP_AUTHOPT_KEY_KNOWN_FLAGS;
 	key_info->send_id = opt.send_id;
 	key_info->recv_id = opt.recv_id;
 	key_info->alg_id = opt.alg;
+	key_info->alg = alg;
 	key_info->keylen = opt.keylen;
 	memcpy(key_info->key, opt.key, opt.keylen);
 	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
 	hlist_add_head_rcu(&key_info->node, &net->head);
 	mutex_unlock(&net->mutex);
-- 
2.25.1

