Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4962D4D76
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388442AbgLIWTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:19:08 -0500
Received: from correo.us.es ([193.147.175.20]:32980 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388415AbgLIWTF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 17:19:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AE8D6D2DA12
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 23:18:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9FF2CDA8F4
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 23:18:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9562EDA8F3; Wed,  9 Dec 2020 23:18:09 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48CF5DA72F;
        Wed,  9 Dec 2020 23:18:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Dec 2020 23:18:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1AC0F4265A5A;
        Wed,  9 Dec 2020 23:18:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/4] netfilter: nft_dynset: fix timeouts later than 23 days
Date:   Wed,  9 Dec 2020 23:18:08 +0100
Message-Id: <20201209221810.32504-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201209221810.32504-1-pablo@netfilter.org>
References: <20201209221810.32504-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use nf_msecs_to_jiffies64 and nf_jiffies64_to_msecs as provided by
8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23
days"), otherwise ruleset listing breaks.

Fixes: a8b1e36d0d1d ("netfilter: nft_dynset: fix element timeout for HZ != 1000")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 4 ++++
 net/netfilter/nf_tables_api.c     | 4 ++--
 net/netfilter/nft_dynset.c        | 8 +++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 55b4cadf290a..c1c0a4ff92ae 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1524,4 +1524,8 @@ void __init nft_chain_route_init(void);
 void nft_chain_route_fini(void);
 
 void nf_tables_trans_destroy_flush_work(void);
+
+int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result);
+__be64 nf_jiffies64_to_msecs(u64 input);
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 23abf1578594..c2f59879a48d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3719,7 +3719,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 }
 
-static int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
+int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 {
 	u64 ms = be64_to_cpu(nla_get_be64(nla));
 	u64 max = (u64)(~((u64)0));
@@ -3733,7 +3733,7 @@ static int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 	return 0;
 }
 
-static __be64 nf_jiffies64_to_msecs(u64 input)
+__be64 nf_jiffies64_to_msecs(u64 input)
 {
 	return cpu_to_be64(jiffies64_to_msecs(input));
 }
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 64ca13a1885b..9af4f93c7f0e 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -157,8 +157,10 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_DYNSET_TIMEOUT] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
-		timeout = msecs_to_jiffies(be64_to_cpu(nla_get_be64(
-						tb[NFTA_DYNSET_TIMEOUT])));
+
+		err = nf_msecs_to_jiffies64(tb[NFTA_DYNSET_TIMEOUT], &timeout);
+		if (err)
+			return err;
 	}
 
 	priv->sreg_key = nft_parse_register(tb[NFTA_DYNSET_SREG_KEY]);
@@ -267,7 +269,7 @@ static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (nla_put_string(skb, NFTA_DYNSET_SET_NAME, priv->set->name))
 		goto nla_put_failure;
 	if (nla_put_be64(skb, NFTA_DYNSET_TIMEOUT,
-			 cpu_to_be64(jiffies_to_msecs(priv->timeout)),
+			 nf_jiffies64_to_msecs(priv->timeout),
 			 NFTA_DYNSET_PAD))
 		goto nla_put_failure;
 	if (priv->expr && nft_expr_dump(skb, NFTA_DYNSET_EXPR, priv->expr))
-- 
2.20.1

