Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC09452739
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 03:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244249AbhKPCUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 21:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238364AbhKORnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:43:03 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC31C028BBF
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:23:11 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id x131so15628033pfc.12
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rpQ17slqm5Qas4jCMFODU0p4WG++20urTlIiK72fGWQ=;
        b=DiYGfw45ZukbaYNBBHSkmaMrk+O2LV2dbHozGZBUj+4u9Z7JmjdL6WCb2jpbG8yekm
         xLi2V+2yRkpOafjCeR9e+A0PSARER1/6hI1exPvPmoxyVni9X6SuLkQiK6Gqmy7mpVwF
         +fCt653W65wZ38WddYzMYxsBaPicdsHsTn0aH4jmeGKqzB0Q2W1ntmTHcu1bgVZw78Q5
         YLU8aaWlRyDFIQYDZUzD1S9K1Cu3UUIgZmhPpMI3fhlbFv2btgUcGyA1+Y1IgjkVLqcf
         J3YfndyoN3g4PlmM9A8EfmJp8b3j/DjbDZ6vBtku/wQgPSHwbHD6FqtKbyoEVxCAsfku
         Eaaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rpQ17slqm5Qas4jCMFODU0p4WG++20urTlIiK72fGWQ=;
        b=jnysClmN+RBTA3AljAqPNq9RrelwGyJl1SfmymgwQ1DGBKlkM8edVYEbO3txXgZT32
         WxYhcGBuixWTqova35gc+YLeC/iPnWQfhlsSUcUxJ90G5gq101e2rLEAVHfYK0aw4n++
         8MpoY2MIwVI4g/78NZilZrrWJPn6DHA1mMsK+OQEjdoT655QzyAa4iigpsLtgXopeSmm
         qysxHXZ68CfLB4i7l8DyoYmVgPQTS5Gs57QPutTxRMN3FZjJ7kWeZLAEUAENVSswjCPM
         R+UVxYs6In+s6/YjBCzFKzsRtBPwwG1xSGXxSbNp4dFLDfwWfAtmVcq29Gw8ZbvpNL1U
         wolA==
X-Gm-Message-State: AOAM533eVPiIEC6xEliEm00b9j0Pf8gEUB6CKmCoauNvrxN3kp3gRr26
        0j/lwFtYJ29l+9UNaBbs/bQ=
X-Google-Smtp-Source: ABdhPJxW7p/yw6HpSccIfo65ufm2bl1Ixw0f2CGYUOYWQVeIF8SEn20o4clfmgrVDaWNQH6/CTdQJg==
X-Received: by 2002:a65:6a56:: with SMTP id o22mr296366pgu.249.1636996990800;
        Mon, 15 Nov 2021 09:23:10 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id a12sm18740840pjq.16.2021.11.15.09.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:23:10 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/3] net: align static siphash keys
Date:   Mon, 15 Nov 2021 09:23:03 -0800
Message-Id: <20211115172303.3732746-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115172303.3732746-1-eric.dumazet@gmail.com>
References: <20211115172303.3732746-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

siphash keys use 16 bytes.

Define siphash_aligned_key_t macro so that we can make sure they
are not crossing a cache line boundary.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/siphash.h              | 2 ++
 net/core/flow_dissector.c            | 2 +-
 net/core/secure_seq.c                | 4 ++--
 net/ipv4/route.c                     | 2 +-
 net/ipv4/syncookies.c                | 2 +-
 net/ipv6/route.c                     | 2 +-
 net/ipv6/syncookies.c                | 2 +-
 net/netfilter/nf_conntrack_core.c    | 4 ++--
 net/netfilter/nf_conntrack_expect.c  | 2 +-
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 net/netfilter/nf_nat_core.c          | 2 +-
 11 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/siphash.h b/include/linux/siphash.h
index bf21591a9e5e653585c26cb3f3f0857256c0eb89..3f7427b9e9357d98b1e21a981cf227195bbdd2aa 100644
--- a/include/linux/siphash.h
+++ b/include/linux/siphash.h
@@ -21,6 +21,8 @@ typedef struct {
 	u64 key[2];
 } siphash_key_t;
 
+#define siphash_aligned_key_t siphash_key_t __aligned(16)
+
 static inline bool siphash_key_is_zero(const siphash_key_t *key)
 {
 	return !(key->key[0] | key->key[1]);
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 3255f57f5131af315f0148909e69ff4c91e66b94..257976cb55cee86ae16623e240c553eb78ad433f 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1460,7 +1460,7 @@ bool __skb_flow_dissect(const struct net *net,
 }
 EXPORT_SYMBOL(__skb_flow_dissect);
 
-static siphash_key_t hashrnd __read_mostly;
+static siphash_aligned_key_t hashrnd;
 static __always_inline void __flow_hash_secret_init(void)
 {
 	net_get_random_once(&hashrnd, sizeof(hashrnd));
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index b5bc680d475536de6da68a9a8815691cf81176a6..9b8443774449f5bb8cd2c62ca34eedf139eeb3ed 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -19,8 +19,8 @@
 #include <linux/in6.h>
 #include <net/tcp.h>
 
-static siphash_key_t net_secret __read_mostly;
-static siphash_key_t ts_secret __read_mostly;
+static siphash_aligned_key_t net_secret;
+static siphash_aligned_key_t ts_secret;
 
 static __always_inline void net_secret_init(void)
 {
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 0b4103b1e6220f97f11a75f960476c161ccb3f39..243a0c52be42b60226a38dce980956b33e583d80 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -602,7 +602,7 @@ static void fnhe_remove_oldest(struct fnhe_hash_bucket *hash)
 
 static u32 fnhe_hashfun(__be32 daddr)
 {
-	static siphash_key_t fnhe_hash_key __read_mostly;
+	static siphash_aligned_key_t fnhe_hash_key;
 	u64 hval;
 
 	net_get_random_once(&fnhe_hash_key, sizeof(fnhe_hash_key));
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 8696dc343ad2cd08fabfb714a32ac67459e4df7e..2cb3b852d14861231ac47f0b3e4daeb57682ffd2 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -14,7 +14,7 @@
 #include <net/tcp.h>
 #include <net/route.h>
 
-static siphash_key_t syncookie_secret[2] __read_mostly;
+static siphash_aligned_key_t syncookie_secret[2];
 
 #define COOKIEBITS 24	/* Upper bits store count */
 #define COOKIEMASK (((__u32)1 << COOKIEBITS) - 1)
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 3ae25b8ffbd6fbeda4b46438dc14b11235558f10..5e8f2f15607db7e6589b8bdb984e62512ad30589 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1485,7 +1485,7 @@ static void rt6_exception_remove_oldest(struct rt6_exception_bucket *bucket)
 static u32 rt6_exception_hash(const struct in6_addr *dst,
 			      const struct in6_addr *src)
 {
-	static siphash_key_t rt6_exception_key __read_mostly;
+	static siphash_aligned_key_t rt6_exception_key;
 	struct {
 		struct in6_addr dst;
 		struct in6_addr src;
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index e8cfb9e997bf062d24cf3e4d4e95a447890c7952..d1b61d00368e1f58725e9997f74a0b144901277e 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -20,7 +20,7 @@
 #define COOKIEBITS 24	/* Upper bits store count */
 #define COOKIEMASK (((__u32)1 << COOKIEBITS) - 1)
 
-static siphash_key_t syncookie6_secret[2] __read_mostly;
+static siphash_aligned_key_t syncookie6_secret[2];
 
 /* RFC 2460, Section 8.3:
  * [ipv6 tcp] MSS must be computed as the maximum packet size minus 60 [..]
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 770a63103c7a4240b8559a97f707588d569beba8..054ee9d25efe174684025d60ea7b72e79c7ca19e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -189,7 +189,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
 unsigned int nf_conntrack_max __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_max);
 seqcount_spinlock_t nf_conntrack_generation __read_mostly;
-static siphash_key_t nf_conntrack_hash_rnd __read_mostly;
+static siphash_aligned_key_t nf_conntrack_hash_rnd;
 
 static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple,
 			      unsigned int zoneid,
@@ -482,7 +482,7 @@ EXPORT_SYMBOL_GPL(nf_ct_invert_tuple);
  */
 u32 nf_ct_get_id(const struct nf_conn *ct)
 {
-	static __read_mostly siphash_key_t ct_id_seed;
+	static siphash_aligned_key_t ct_id_seed;
 	unsigned long a, b, c, d;
 
 	net_get_random_once(&ct_id_seed, sizeof(ct_id_seed));
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index f562eeef42349e6e40f15b056405dd53d9916f1e..1e89b595ecd086eb55f6fb8d9aa31f3abe2afc33 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -41,7 +41,7 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_hash);
 unsigned int nf_ct_expect_max __read_mostly;
 
 static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
-static siphash_key_t nf_ct_expect_hashrnd __read_mostly;
+static siphash_aligned_key_t nf_ct_expect_hashrnd;
 
 /* nf_conntrack_expect helper functions */
 void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f1e5443fe7c74cde3f5f0a1a01bcbe530bedb75c..3d6c8da3de1fbbfc64dea06ab5946f9e79ff72ee 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2997,7 +2997,7 @@ static const union nf_inet_addr any_addr;
 
 static __be32 nf_expect_get_id(const struct nf_conntrack_expect *exp)
 {
-	static __read_mostly siphash_key_t exp_id_seed;
+	static siphash_aligned_key_t exp_id_seed;
 	unsigned long a, b, c, d;
 
 	net_get_random_once(&exp_id_seed, sizeof(exp_id_seed));
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 4d50d51db796276c84fbc3486b870bd591d93796..ab9f6c75524d80c9d3ef032c9911e60b02206b88 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -34,7 +34,7 @@ static unsigned int nat_net_id __read_mostly;
 
 static struct hlist_head *nf_nat_bysource __read_mostly;
 static unsigned int nf_nat_htable_size __read_mostly;
-static siphash_key_t nf_nat_hash_rnd __read_mostly;
+static siphash_aligned_key_t nf_nat_hash_rnd;
 
 struct nf_nat_lookup_hook_priv {
 	struct nf_hook_entries __rcu *entries;
-- 
2.34.0.rc1.387.gb447b232ab-goog

