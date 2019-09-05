Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F0AAA7EC
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 18:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390832AbfIEQEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 12:04:15 -0400
Received: from correo.us.es ([193.147.175.20]:53100 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389090AbfIEQEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 12:04:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E74D51228D5
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8E05FF2EB
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CE88BB8017; Thu,  5 Sep 2019 18:04:08 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3038FB362;
        Thu,  5 Sep 2019 18:04:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Sep 2019 18:04:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 83A1D42EE38E;
        Thu,  5 Sep 2019 18:04:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 7/8] netfilter: nft_quota: add quota object update support
Date:   Thu,  5 Sep 2019 18:03:59 +0200
Message-Id: <20190905160400.25399-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190905160400.25399-1-pablo@netfilter.org>
References: <20190905160400.25399-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_quota.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index c8745d454bf8..4413690591f2 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -13,7 +13,7 @@
 #include <net/netfilter/nf_tables.h>
 
 struct nft_quota {
-	u64		quota;
+	atomic64_t	quota;
 	unsigned long	flags;
 	atomic64_t	consumed;
 };
@@ -21,7 +21,8 @@ struct nft_quota {
 static inline bool nft_overquota(struct nft_quota *priv,
 				 const struct sk_buff *skb)
 {
-	return atomic64_add_return(skb->len, &priv->consumed) >= priv->quota;
+	return atomic64_add_return(skb->len, &priv->consumed) >=
+	       atomic64_read(&priv->quota);
 }
 
 static inline bool nft_quota_invert(struct nft_quota *priv)
@@ -89,7 +90,7 @@ static int nft_quota_do_init(const struct nlattr * const tb[],
 			return -EOPNOTSUPP;
 	}
 
-	priv->quota = quota;
+	atomic64_set(&priv->quota, quota);
 	priv->flags = flags;
 	atomic64_set(&priv->consumed, consumed);
 
@@ -105,10 +106,22 @@ static int nft_quota_obj_init(const struct nft_ctx *ctx,
 	return nft_quota_do_init(tb, priv);
 }
 
+static void nft_quota_obj_update(struct nft_object *obj,
+				 struct nft_object *newobj)
+{
+	struct nft_quota *newpriv = nft_obj_data(newobj);
+	struct nft_quota *priv = nft_obj_data(obj);
+	u64 newquota;
+
+	newquota = atomic64_read(&newpriv->quota);
+	atomic64_set(&priv->quota, newquota);
+	priv->flags = newpriv->flags;
+}
+
 static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 			     bool reset)
 {
-	u64 consumed, consumed_cap;
+	u64 consumed, consumed_cap, quota;
 	u32 flags = priv->flags;
 
 	/* Since we inconditionally increment consumed quota for each packet
@@ -116,14 +129,15 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 	 * userspace.
 	 */
 	consumed = atomic64_read(&priv->consumed);
-	if (consumed >= priv->quota) {
-		consumed_cap = priv->quota;
+	quota = atomic64_read(&priv->quota);
+	if (consumed >= quota) {
+		consumed_cap = quota;
 		flags |= NFT_QUOTA_F_DEPLETED;
 	} else {
 		consumed_cap = consumed;
 	}
 
-	if (nla_put_be64(skb, NFTA_QUOTA_BYTES, cpu_to_be64(priv->quota),
+	if (nla_put_be64(skb, NFTA_QUOTA_BYTES, cpu_to_be64(quota),
 			 NFTA_QUOTA_PAD) ||
 	    nla_put_be64(skb, NFTA_QUOTA_CONSUMED, cpu_to_be64(consumed_cap),
 			 NFTA_QUOTA_PAD) ||
@@ -155,6 +169,7 @@ static const struct nft_object_ops nft_quota_obj_ops = {
 	.init		= nft_quota_obj_init,
 	.eval		= nft_quota_obj_eval,
 	.dump		= nft_quota_obj_dump,
+	.update		= nft_quota_obj_update,
 };
 
 static struct nft_object_type nft_quota_obj_type __read_mostly = {
-- 
2.11.0

