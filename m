Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98745375429
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 14:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhEFMyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 08:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhEFMyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 08:54:52 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A809FC061574;
        Thu,  6 May 2021 05:53:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b14-20020a17090a6e0eb0290155c7f6a356so2792810pjk.0;
        Thu, 06 May 2021 05:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=isiRHE6erzH3OqFs7FYZrU6UPnUfyE+MT5i6BPHKk6E=;
        b=c9xoFIb5KW84B5V2Peaf6JP1bPGGpxk9cKyTkQlgx7LPVw3RbOX4JgMPl9n4Fv4Qcb
         DMaQQUvseA9qJ7yhf1zHroRYGDKEJBsJU6GC4cPBvAZs6yVOV3WvTj1iCQ1reP0NAfF8
         +sX7yrEH20NL4EqYiixg7wxx7UbB1es1Z4LdaDV5bRnNjwmcwaC9ug2WopsmyWuVfjx+
         qYSSfVbFzRAMDPIsWQoL0GkltlYb7lQyNVFwfEiWVfRsc4dsLrsx/wWAMOQUtfH47ijZ
         3haIrqHqfmjspJVRcn7Ke9ySX0Pb9Atum6FBjF8Y9ixAZsZLOidJ+056SbeeCRVMUe/6
         MU7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=isiRHE6erzH3OqFs7FYZrU6UPnUfyE+MT5i6BPHKk6E=;
        b=Cn/YEvp+nGPme8/jD+e0rkZgrYQUAQWnl1xv3OBUpFHioMmGlWRC8C1ommqKDoIb9G
         IxVRThbQlwvA9gNO9DZl4+zq1pfnkpmT1wk/1ODSVpsiIu0UPC/7tRv3IP8JzGz/mFFg
         3vDv/Vja0XRvCIBy4qtfoXpqAbfRbZK88lWm6mv3+NrrDPYP3BzcNdsXRIZ3zvTar39L
         yIWdWsuJ2NNmMbk7xybl5UR7q7W3ERqxkZgLF3x6s8q/UNVh2lNQo89n+HsROKwD/CGK
         uBW8UV8HgrhyxVaozpcrsKrfhkjIdmXPuuAvcv7OMnoVFruq28T9BMWU51vxdDpID2xl
         F64g==
X-Gm-Message-State: AOAM531reGPFNxJPvkzd5vaL/w9zhj8jGpK4NsxurS7UoL9Ptu9Shcn+
        wJew/S1WOiQ3BV1OZ7H96Rm/OSWRheM=
X-Google-Smtp-Source: ABdhPJyTNoyWh1KofZmp//XjKBaGBa7VMyDSXXlsoPSkW6LbnN6piHMEb7TvzgWmdjXjIRVxz55eXQ==
X-Received: by 2002:a17:90a:a613:: with SMTP id c19mr17740276pjq.117.1620305634259;
        Thu, 06 May 2021 05:53:54 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4970:7438:9f62:403a])
        by smtp.gmail.com with ESMTPSA id s3sm2306900pgs.62.2021.05.06.05.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 05:53:53 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 2/2] netfilter: nf_tables: avoid potential overflows on 32bit arches
Date:   Thu,  6 May 2021 05:53:50 -0700
Message-Id: <20210506125350.3887306-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
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

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: 0ed6389c483d ("netfilter: nf_tables: rename set implementations")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |  7 +++++--
 net/netfilter/nft_set_hash.c  | 10 +++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0b7fe0a902ff56c162741e6715ad62d928381ea7..c14213bc714b1a54a4287ae898d3a096b21e00ac 100644
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
index 328f2ce32e4cbd772afe03a10f6d13a7ed6b93d5..7b3d0a78c5696747a2e71b1a58303fa141de6c2b 100644
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
2.31.1.527.g47e6f16901-goog

