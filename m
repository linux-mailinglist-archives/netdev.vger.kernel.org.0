Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B96B2E8DE8
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 20:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbhACTaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 14:30:15 -0500
Received: from correo.us.es ([193.147.175.20]:40824 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727524AbhACTaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 14:30:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A785D11772E
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 20:28:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99937DA844
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 20:28:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8DCD5DA730; Sun,  3 Jan 2021 20:28:53 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5AFCBDA73F;
        Sun,  3 Jan 2021 20:28:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 03 Jan 2021 20:28:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 29720426CC84;
        Sun,  3 Jan 2021 20:28:51 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/3] netfilter: nftables: add set expression flags
Date:   Sun,  3 Jan 2021 20:29:20 +0100
Message-Id: <20210103192920.18639-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210103192920.18639-1-pablo@netfilter.org>
References: <20210103192920.18639-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The set flag NFT_SET_EXPR provides a hint to the kernel that userspace
supports for multiple expressions per set element. In the same
direction, NFT_DYNSET_F_EXPR specifies that dynset expression defines
multiple expressions per set element.

This allows new userspace software with old kernels to bail out with
EOPNOTSUPP. This update is similar to ef516e8625dd ("netfilter:
nf_tables: reintroduce the NFT_SET_CONCAT flag"). The NFT_SET_EXPR flag
needs to be set on when the NFTA_SET_EXPRESSIONS attribute is specified.
The NFT_SET_EXPR flag is not set on with NFTA_SET_EXPR to retain
backward compatibility in old userspace binaries.

Fixes: 48b0ae046ee9 ("netfilter: nftables: netlink support for several set element expressions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 3 +++
 net/netfilter/nf_tables_api.c            | 6 +++++-
 net/netfilter/nft_dynset.c               | 9 +++++++--
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 28b6ee53305f..b1633e7ba529 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -293,6 +293,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_EVAL: set can be updated from the evaluation path
  * @NFT_SET_OBJECT: set contains stateful objects
  * @NFT_SET_CONCAT: set contains a concatenation
+ * @NFT_SET_EXPR: set contains expressions
  */
 enum nft_set_flags {
 	NFT_SET_ANONYMOUS		= 0x1,
@@ -303,6 +304,7 @@ enum nft_set_flags {
 	NFT_SET_EVAL			= 0x20,
 	NFT_SET_OBJECT			= 0x40,
 	NFT_SET_CONCAT			= 0x80,
+	NFT_SET_EXPR			= 0x100,
 };
 
 /**
@@ -706,6 +708,7 @@ enum nft_dynset_ops {
 
 enum nft_dynset_flags {
 	NFT_DYNSET_F_INV	= (1 << 0),
+	NFT_DYNSET_F_EXPR	= (1 << 1),
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4186b1e52d58..15c467f1a9dd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4162,7 +4162,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		if (flags & ~(NFT_SET_ANONYMOUS | NFT_SET_CONSTANT |
 			      NFT_SET_INTERVAL | NFT_SET_TIMEOUT |
 			      NFT_SET_MAP | NFT_SET_EVAL |
-			      NFT_SET_OBJECT | NFT_SET_CONCAT))
+			      NFT_SET_OBJECT | NFT_SET_CONCAT | NFT_SET_EXPR))
 			return -EOPNOTSUPP;
 		/* Only one of these operations is supported */
 		if ((flags & (NFT_SET_MAP | NFT_SET_OBJECT)) ==
@@ -4304,6 +4304,10 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		struct nlattr *tmp;
 		int left;
 
+		if (!(flags & NFT_SET_EXPR)) {
+			err = -EINVAL;
+			goto err_set_alloc_name;
+		}
 		i = 0;
 		nla_for_each_nested(tmp, nla[NFTA_SET_EXPRESSIONS], left) {
 			if (i == NFT_SET_EXPR_MAX) {
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index f35df221a633..0b053f75cd60 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -19,6 +19,7 @@ struct nft_dynset {
 	enum nft_registers		sreg_key:8;
 	enum nft_registers		sreg_data:8;
 	bool				invert;
+	bool				expr;
 	u8				num_exprs;
 	u64				timeout;
 	struct nft_expr			*expr_array[NFT_SET_EXPR_MAX];
@@ -175,11 +176,12 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 
 	if (tb[NFTA_DYNSET_FLAGS]) {
 		u32 flags = ntohl(nla_get_be32(tb[NFTA_DYNSET_FLAGS]));
-
-		if (flags & ~NFT_DYNSET_F_INV)
+		if (flags & ~(NFT_DYNSET_F_INV | NFT_DYNSET_F_EXPR))
 			return -EOPNOTSUPP;
 		if (flags & NFT_DYNSET_F_INV)
 			priv->invert = true;
+		if (flags & NFT_DYNSET_F_EXPR)
+			priv->expr = true;
 	}
 
 	set = nft_set_lookup_global(ctx->net, ctx->table,
@@ -261,6 +263,9 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		struct nlattr *tmp;
 		int left;
 
+		if (!priv->expr)
+			return -EINVAL;
+
 		i = 0;
 		nla_for_each_nested(tmp, tb[NFTA_DYNSET_EXPRESSIONS], left) {
 			if (i == NFT_SET_EXPR_MAX) {
-- 
2.20.1

