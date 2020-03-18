Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA81A189308
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgCRAkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:40:47 -0400
Received: from correo.us.es ([193.147.175.20]:45604 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbgCRAkY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9F84627F8B0
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F39BDA736
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 84C83DA3A0; Wed, 18 Mar 2020 01:39:51 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9890EDA736;
        Wed, 18 Mar 2020 01:39:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:49 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6D27D426CCB9;
        Wed, 18 Mar 2020 01:39:49 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 20/29] nft_set_pipapo: Prepare for single ranged field usage
Date:   Wed, 18 Mar 2020 01:39:47 +0100
Message-Id: <20200318003956.73573-21-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

A few adjustments in nft_pipapo_init() are needed to allow usage of
this set back-end for a single, ranged field.

Provide a convenient NFT_PIPAPO_MIN_FIELDS definition that currently
makes sure that the rbtree back-end is selected instead, for sets
with a single field.

This finally allows a fair comparison with rbtree sets, by defining
NFT_PIPAPO_MIN_FIELDS as 0 and skipping rbtree back-end initialisation:

 ---------------.--------------------------.-------------------------.
 AMD Epyc 7402  |      baselines, Mpps     |   Mpps, % over rbtree   |
  1 thread      |__________________________|_________________________|
  3.35GHz       |        |        |        |            |            |
  768KiB L1D$   | netdev |  hash  | rbtree |            |   pipapo   |
 ---------------|  hook  |   no   | single |   pipapo   |single field|
 type   entries |  drop  | ranges | field  |single field|    AVX2    |
 ---------------|--------|--------|--------|------------|------------|
 net,port       |        |        |        |            |            |
          1000  |   19.0 |   10.4 |    3.8 | 6.0   +58% | 9.6  +153% |
 ---------------|--------|--------|--------|------------|------------|
 port,net       |        |        |        |            |            |
           100  |   18.8 |   10.3 |    5.8 | 9.1   +57% |11.6  +100% |
 ---------------|--------|--------|--------|------------|------------|
 net6,port      |        |        |        |            |            |
          1000  |   16.4 |    7.6 |    1.8 | 2.8   +55% | 6.5  +261% |
 ---------------|--------|--------|--------|------------|------------|
 port,proto     |        |        |        |     [1]    |    [1]     |
         30000  |   19.6 |   11.6 |    3.9 | 0.9   -77% | 2.7   -31% |
 ---------------|--------|--------|--------|------------|------------|
 port,proto     |        |        |        |            |            |
         10000  |   19.6 |   11.6 |    4.4 | 2.1   -52% | 5.6   +27% |
 ---------------|--------|--------|--------|------------|------------|
 port,proto     |        |        |        |            |            |
 4 threads 10000|   77.9 |   45.1 |   17.4 | 8.3   -52% |22.4   +29% |
 ---------------|--------|--------|--------|------------|------------|
 net6,port,mac  |        |        |        |            |            |
            10  |   16.5 |    5.4 |    4.3 | 4.5    +5% | 8.2   +91% |
 ---------------|--------|--------|--------|------------|------------|
 net6,port,mac, |        |        |        |            |            |
 proto    1000  |   16.5 |    5.7 |    1.9 | 2.8   +47% | 6.6  +247% |
 ---------------|--------|--------|--------|------------|------------|
 net,mac        |        |        |        |            |            |
          1000  |   19.0 |    8.4 |    3.9 | 6.0   +54% | 9.9  +154% |
 ---------------'--------'--------'--------'------------'------------'
 [1] Causes switch of lookup table buckets for 'port' to 4-bit groups

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c      | 19 ++++++++++++-------
 net/netfilter/nft_set_pipapo.h      |  3 +++
 net/netfilter/nft_set_pipapo_avx2.c |  3 ++-
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 1e8dd5dccdf7..c1afb6c94edc 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1983,7 +1983,8 @@ static u64 nft_pipapo_privsize(const struct nlattr * const nla[],
 static bool nft_pipapo_estimate(const struct nft_set_desc *desc, u32 features,
 				struct nft_set_estimate *est)
 {
-	if (!(features & NFT_SET_INTERVAL) || desc->field_count <= 1)
+	if (!(features & NFT_SET_INTERVAL) ||
+	    desc->field_count < NFT_PIPAPO_MIN_FIELDS)
 		return false;
 
 	est->size = pipapo_estimate_size(desc);
@@ -2016,17 +2017,19 @@ static int nft_pipapo_init(const struct nft_set *set,
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m;
 	struct nft_pipapo_field *f;
-	int err, i;
+	int err, i, field_count;
 
-	if (desc->field_count > NFT_PIPAPO_MAX_FIELDS)
+	field_count = desc->field_count ? : 1;
+
+	if (field_count > NFT_PIPAPO_MAX_FIELDS)
 		return -EINVAL;
 
-	m = kmalloc(sizeof(*priv->match) + sizeof(*f) * desc->field_count,
+	m = kmalloc(sizeof(*priv->match) + sizeof(*f) * field_count,
 		    GFP_KERNEL);
 	if (!m)
 		return -ENOMEM;
 
-	m->field_count = desc->field_count;
+	m->field_count = field_count;
 	m->bsize_max = 0;
 
 	m->scratch = alloc_percpu(unsigned long *);
@@ -2050,10 +2053,12 @@ static int nft_pipapo_init(const struct nft_set *set,
 	rcu_head_init(&m->rcu);
 
 	nft_pipapo_for_each_field(f, i, m) {
+		int len = desc->field_len[i] ? : set->klen;
+
 		f->bb = NFT_PIPAPO_GROUP_BITS_INIT;
-		f->groups = desc->field_len[i] * NFT_PIPAPO_GROUPS_PER_BYTE(f);
+		f->groups = len * NFT_PIPAPO_GROUPS_PER_BYTE(f);
 
-		priv->width += round_up(desc->field_len[i], sizeof(u32));
+		priv->width += round_up(len, sizeof(u32));
 
 		f->bsize = 0;
 		f->rules = 0;
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 3cfc0a385ee2..25a75591583e 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -8,6 +8,9 @@
 /* Count of concatenated fields depends on count of 32-bit nftables registers */
 #define NFT_PIPAPO_MAX_FIELDS		NFT_REG32_COUNT
 
+/* Restrict usage to multiple fields, make sure rbtree is used otherwise */
+#define NFT_PIPAPO_MIN_FIELDS		2
+
 /* Largest supported field size */
 #define NFT_PIPAPO_MAX_BYTES		(sizeof(struct in6_addr))
 #define NFT_PIPAPO_MAX_BITS		(NFT_PIPAPO_MAX_BYTES * BITS_PER_BYTE)
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index f6e20154d2b7..d65ae0e23028 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1087,7 +1087,8 @@ static int nft_pipapo_avx2_lookup_slow(unsigned long *map, unsigned long *fill,
 bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
 			      struct nft_set_estimate *est)
 {
-	if (!(features & NFT_SET_INTERVAL) || desc->field_count <= 1)
+	if (!(features & NFT_SET_INTERVAL) ||
+	    desc->field_count < NFT_PIPAPO_MIN_FIELDS)
 		return false;
 
 	if (!boot_cpu_has(X86_FEATURE_AVX2) || !boot_cpu_has(X86_FEATURE_AVX))
-- 
2.11.0

