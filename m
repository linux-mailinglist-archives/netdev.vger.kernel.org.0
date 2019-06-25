Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E90A51FAC
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbfFYAON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:14:13 -0400
Received: from mail.us.es ([193.147.175.20]:38020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbfFYAMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 05674C04B4
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E851CDA709
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DD170DA703; Tue, 25 Jun 2019 02:12:52 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C366CDA70A;
        Tue, 25 Jun 2019 02:12:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 95E414265A2F;
        Tue, 25 Jun 2019 02:12:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 19/26] netfilter: nf_tables: enable set expiration time for set elements
Date:   Tue, 25 Jun 2019 02:12:26 +0200
Message-Id: <20190625001233.22057-20-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laura Garcia Liebana <nevola@gmail.com>

Currently, the expiration of every element in a set or map
is a read-only parameter generated at kernel side.

This change will permit to set a certain expiration date
per element that will be required, for example, during
stateful replication among several nodes.

This patch handles the NFTA_SET_ELEM_EXPIRATION in order
to configure the expiration parameter per element, or
will use the timeout in the case that the expiration
is not set.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c     | 26 ++++++++++++++++++++------
 net/netfilter/nft_dynset.c        |  2 +-
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5b8624ae4a27..9e8493aad49d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -636,7 +636,7 @@ static inline struct nft_object **nft_set_ext_obj(const struct nft_set_ext *ext)
 void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *data,
-			u64 timeout, gfp_t gfp);
+			u64 timeout, u64 expiration, gfp_t gfp);
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d444405211c5..412bb85e9d29 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3873,6 +3873,7 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 	[NFTA_SET_ELEM_DATA]		= { .type = NLA_NESTED },
 	[NFTA_SET_ELEM_FLAGS]		= { .type = NLA_U32 },
 	[NFTA_SET_ELEM_TIMEOUT]		= { .type = NLA_U64 },
+	[NFTA_SET_ELEM_EXPIRATION]	= { .type = NLA_U64 },
 	[NFTA_SET_ELEM_USERDATA]	= { .type = NLA_BINARY,
 					    .len = NFT_USERDATA_MAXLEN },
 	[NFTA_SET_ELEM_EXPR]		= { .type = NLA_NESTED },
@@ -4326,7 +4327,7 @@ static struct nft_trans *nft_trans_elem_alloc(struct nft_ctx *ctx,
 void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *data,
-			u64 timeout, gfp_t gfp)
+			u64 timeout, u64 expiration, gfp_t gfp)
 {
 	struct nft_set_ext *ext;
 	void *elem;
@@ -4341,9 +4342,11 @@ void *nft_set_elem_init(const struct nft_set *set,
 	memcpy(nft_set_ext_key(ext), key, set->klen);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		memcpy(nft_set_ext_data(ext), data, set->dlen);
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION))
-		*nft_set_ext_expiration(ext) =
-			get_jiffies_64() + timeout;
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
+		*nft_set_ext_expiration(ext) = get_jiffies_64() + expiration;
+		if (expiration == 0)
+			*nft_set_ext_expiration(ext) += timeout;
+	}
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT))
 		*nft_set_ext_timeout(ext) = timeout;
 
@@ -4408,6 +4411,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_trans *trans;
 	u32 flags = 0;
 	u64 timeout;
+	u64 expiration;
 	u8 ulen;
 	int err;
 
@@ -4451,6 +4455,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		timeout = set->timeout;
 	}
 
+	expiration = 0;
+	if (nla[NFTA_SET_ELEM_EXPIRATION] != NULL) {
+		if (!(set->flags & NFT_SET_TIMEOUT))
+			return -EINVAL;
+		err = nf_msecs_to_jiffies64(nla[NFTA_SET_ELEM_EXPIRATION],
+					    &expiration);
+		if (err)
+			return err;
+	}
+
 	err = nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &d1,
 			    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
@@ -4533,7 +4547,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 	err = -ENOMEM;
 	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, data.data,
-				      timeout, GFP_KERNEL);
+				      timeout, expiration, GFP_KERNEL);
 	if (elem.priv == NULL)
 		goto err3;
 
@@ -4735,7 +4749,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 
 	err = -ENOMEM;
 	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, NULL, 0,
-				      GFP_KERNEL);
+				      0, GFP_KERNEL);
 	if (elem.priv == NULL)
 		goto err2;
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 8394560aa695..bfb9f7463b03 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -60,7 +60,7 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 	elem = nft_set_elem_init(set, &priv->tmpl,
 				 &regs->data[priv->sreg_key],
 				 &regs->data[priv->sreg_data],
-				 timeout, GFP_ATOMIC);
+				 timeout, 0, GFP_ATOMIC);
 	if (elem == NULL)
 		goto err1;
 
-- 
2.11.0

