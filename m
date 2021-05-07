Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66BF3769AD
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 19:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhEGRtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 13:49:00 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49148 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhEGRsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 13:48:51 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 55F9064150;
        Fri,  7 May 2021 19:47:04 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 8/8] netfilter: nftables: avoid potential overflows on 32bit arches
Date:   Fri,  7 May 2021 19:47:39 +0200
Message-Id: <20210507174739.1850-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210507174739.1850-1-pablo@netfilter.org>
References: <20210507174739.1850-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

User space could ask for very large hash tables, we need to make sure
our size computations wont overflow.

nf_tables_newset() needs to double check the u64 size
will fit into size_t field.

Fixes: 0ed6389c483d ("netfilter: nf_tables: rename set implementations")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |  7 +++++--
 net/netfilter/nft_set_hash.c  | 10 +++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 926da6ed8d51..d63d2d8f769c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4184,6 +4184,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	unsigned char *udata;
 	struct nft_set *set;
 	struct nft_ctx ctx;
+	size_t alloc_size;
 	u64 timeout;
 	char *name;
 	int err, i;
@@ -4329,8 +4330,10 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	size = 0;
 	if (ops->privsize != NULL)
 		size = ops->privsize(nla, &desc);
-
-	set = kvzalloc(sizeof(*set) + size + udlen, GFP_KERNEL);
+	alloc_size = sizeof(*set) + size + udlen;
+	if (alloc_size < size)
+		return -ENOMEM;
+	set = kvzalloc(alloc_size, GFP_KERNEL);
 	if (!set)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 328f2ce32e4c..7b3d0a78c569 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -623,7 +623,7 @@ static u64 nft_hash_privsize(const struct nlattr * const nla[],
 			     const struct nft_set_desc *desc)
 {
 	return sizeof(struct nft_hash) +
-	       nft_hash_buckets(desc->size) * sizeof(struct hlist_head);
+	       (u64)nft_hash_buckets(desc->size) * sizeof(struct hlist_head);
 }
 
 static int nft_hash_init(const struct nft_set *set,
@@ -663,8 +663,8 @@ static bool nft_hash_estimate(const struct nft_set_desc *desc, u32 features,
 		return false;
 
 	est->size   = sizeof(struct nft_hash) +
-		      nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
-		      desc->size * sizeof(struct nft_hash_elem);
+		      (u64)nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
+		      (u64)desc->size * sizeof(struct nft_hash_elem);
 	est->lookup = NFT_SET_CLASS_O_1;
 	est->space  = NFT_SET_CLASS_O_N;
 
@@ -681,8 +681,8 @@ static bool nft_hash_fast_estimate(const struct nft_set_desc *desc, u32 features
 		return false;
 
 	est->size   = sizeof(struct nft_hash) +
-		      nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
-		      desc->size * sizeof(struct nft_hash_elem);
+		      (u64)nft_hash_buckets(desc->size) * sizeof(struct hlist_head) +
+		      (u64)desc->size * sizeof(struct nft_hash_elem);
 	est->lookup = NFT_SET_CLASS_O_1;
 	est->space  = NFT_SET_CLASS_O_N;
 
-- 
2.30.2

