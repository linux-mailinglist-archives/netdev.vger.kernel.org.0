Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7BBB13F1B7
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405566AbgAPSaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:30:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391990AbgAPRZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:25:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CB47246DC;
        Thu, 16 Jan 2020 17:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195531;
        bh=USVgftlGwiLXXi5/H+/NWK1w91iAaWxgSLPLjyHHRn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iCtmNUd5wmY/ESVpu5SoLK8QS0X2M3wZDf+x0Wd3rpdSxw5HqC6Hkyv386Gotn4We
         RKCdYzOyI/vyghcKf4ZYdgGEskN+8Qu6J0ESAfygW36C0iAOfgWdOMUh+RbGSAkxem
         ro5i/+LFyQnBTsSCPV4+Q7DtXObX4ZFl/UFSCGnk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 126/371] netfilter: nft_set_hash: fix lookups with fixed size hash on big endian
Date:   Thu, 16 Jan 2020 12:19:58 -0500
Message-Id: <20200116172403.18149-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 3b02b0adc242a72b5e46019b6a9e4f84823592f6 ]

Call jhash_1word() for the 4-bytes key case from the insertion and
deactivation path, otherwise big endian arch set lookups fail.

Fixes: 446a8268b7f5 ("netfilter: nft_set_hash: add lookup variant for fixed size hashtable")
Reported-by: Florian Westphal <fw@strlen.de>
Tested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_hash.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 33aa2ac3a62e..73f8f99b1193 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -442,6 +442,23 @@ static bool nft_hash_lookup_fast(const struct net *net,
 	return false;
 }
 
+static u32 nft_jhash(const struct nft_set *set, const struct nft_hash *priv,
+		     const struct nft_set_ext *ext)
+{
+	const struct nft_data *key = nft_set_ext_key(ext);
+	u32 hash, k1;
+
+	if (set->klen == 4) {
+		k1 = *(u32 *)key;
+		hash = jhash_1word(k1, priv->seed);
+	} else {
+		hash = jhash(key, set->klen, priv->seed);
+	}
+	hash = reciprocal_scale(hash, priv->buckets);
+
+	return hash;
+}
+
 static int nft_hash_insert(const struct net *net, const struct nft_set *set,
 			   const struct nft_set_elem *elem,
 			   struct nft_set_ext **ext)
@@ -451,8 +468,7 @@ static int nft_hash_insert(const struct net *net, const struct nft_set *set,
 	u8 genmask = nft_genmask_next(net);
 	u32 hash;
 
-	hash = jhash(nft_set_ext_key(&this->ext), set->klen, priv->seed);
-	hash = reciprocal_scale(hash, priv->buckets);
+	hash = nft_jhash(set, priv, &this->ext);
 	hlist_for_each_entry(he, &priv->table[hash], node) {
 		if (!memcmp(nft_set_ext_key(&this->ext),
 			    nft_set_ext_key(&he->ext), set->klen) &&
@@ -491,8 +507,7 @@ static void *nft_hash_deactivate(const struct net *net,
 	u8 genmask = nft_genmask_next(net);
 	u32 hash;
 
-	hash = jhash(nft_set_ext_key(&this->ext), set->klen, priv->seed);
-	hash = reciprocal_scale(hash, priv->buckets);
+	hash = nft_jhash(set, priv, &this->ext);
 	hlist_for_each_entry(he, &priv->table[hash], node) {
 		if (!memcmp(nft_set_ext_key(&this->ext), &elem->key.val,
 			    set->klen) ||
-- 
2.20.1

