Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBB33119D4
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhBFDVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:21:19 -0500
Received: from correo.us.es ([193.147.175.20]:53504 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbhBFDIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 22:08:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B182419192F
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 02:50:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0561DA789
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 02:50:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 94356DA72F; Sat,  6 Feb 2021 02:50:15 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 995D6DA730;
        Sat,  6 Feb 2021 02:50:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Feb 2021 02:50:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 5FB8242E0F80;
        Sat,  6 Feb 2021 02:50:12 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 5/7] netfilter: nftables: add nft_parse_register_store() and use it
Date:   Sat,  6 Feb 2021 02:50:03 +0100
Message-Id: <20210206015005.23037-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210206015005.23037-1-pablo@netfilter.org>
References: <20210206015005.23037-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new function combines the netlink register attribute parser
and the store validation function.

This update requires to replace:

        enum nft_registers      dreg:8;

in many of the expression private areas otherwise compiler complains
with:

        error: cannot take address of bit-field ‘dreg’

when passing the register field as reference.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      |  8 +++---
 include/net/netfilter/nf_tables_core.h |  6 ++---
 include/net/netfilter/nft_fib.h        |  2 +-
 include/net/netfilter/nft_meta.h       |  2 +-
 net/bridge/netfilter/nft_meta_bridge.c |  5 ++--
 net/netfilter/nf_tables_api.c          | 34 ++++++++++++++++++++++----
 net/netfilter/nft_bitwise.c            | 13 +++++-----
 net/netfilter/nft_byteorder.c          |  8 +++---
 net/netfilter/nft_ct.c                 |  7 +++---
 net/netfilter/nft_exthdr.c             |  8 +++---
 net/netfilter/nft_fib.c                |  5 ++--
 net/netfilter/nft_hash.c               | 17 ++++++-------
 net/netfilter/nft_immediate.c          |  6 ++---
 net/netfilter/nft_lookup.c             |  8 +++---
 net/netfilter/nft_meta.c               |  5 ++--
 net/netfilter/nft_numgen.c             | 15 +++++-------
 net/netfilter/nft_osf.c                |  8 +++---
 net/netfilter/nft_payload.c            |  6 ++---
 net/netfilter/nft_rt.c                 |  7 +++---
 net/netfilter/nft_socket.c             |  7 +++---
 net/netfilter/nft_tunnel.c             |  8 +++---
 net/netfilter/nft_xfrm.c               |  7 +++---
 22 files changed, 100 insertions(+), 92 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 033b31aa38cc..78d174517749 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -204,10 +204,10 @@ unsigned int nft_parse_register(const struct nlattr *attr);
 int nft_dump_register(struct sk_buff *skb, unsigned int attr, unsigned int reg);
 
 int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
-int nft_validate_register_store(const struct nft_ctx *ctx,
-				enum nft_registers reg,
-				const struct nft_data *data,
-				enum nft_data_types type, unsigned int len);
+int nft_parse_register_store(const struct nft_ctx *ctx,
+			     const struct nlattr *attr, u8 *dreg,
+			     const struct nft_data *data,
+			     enum nft_data_types type, unsigned int len);
 
 /**
  *	struct nft_userdata - user defined data associated with an object
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index b7aff03a3f0f..fd10a7862fdc 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -27,7 +27,7 @@ struct nft_bitwise_fast_expr {
 	u32			mask;
 	u32			xor;
 	u8			sreg;
-	enum nft_registers	dreg:8;
+	u8			dreg;
 };
 
 struct nft_cmp_fast_expr {
@@ -40,7 +40,7 @@ struct nft_cmp_fast_expr {
 
 struct nft_immediate_expr {
 	struct nft_data		data;
-	enum nft_registers	dreg:8;
+	u8			dreg;
 	u8			dlen;
 };
 
@@ -60,7 +60,7 @@ struct nft_payload {
 	enum nft_payload_bases	base:8;
 	u8			offset;
 	u8			len;
-	enum nft_registers	dreg:8;
+	u8			dreg;
 };
 
 struct nft_payload_set {
diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index 628b6fa579cd..237f3757637e 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -5,7 +5,7 @@
 #include <net/netfilter/nf_tables.h>
 
 struct nft_fib {
-	enum nft_registers	dreg:8;
+	u8			dreg;
 	u8			result;
 	u32			flags;
 };
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index 946fa8c83798..2dce55c736f4 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -7,7 +7,7 @@
 struct nft_meta {
 	enum nft_meta_keys	key:8;
 	union {
-		enum nft_registers	dreg:8;
+		u8		dreg;
 		u8		sreg;
 	};
 };
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 8e8ffac037cd..97805ec424c1 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -87,9 +87,8 @@ static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
 		return nft_meta_get_init(ctx, expr, tb);
 	}
 
-	priv->dreg = nft_parse_register(tb[NFTA_META_DREG]);
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, len);
+	return nft_parse_register_store(ctx, tb[NFTA_META_DREG], &priv->dreg,
+					NULL, NFT_DATA_VALUE, len);
 }
 
 static struct nft_expr_type nft_meta_bridge_type;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1e82ebba230d..c23163ffb5a1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4438,6 +4438,12 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
 	return nft_delset(&ctx, set);
 }
 
+static int nft_validate_register_store(const struct nft_ctx *ctx,
+				       enum nft_registers reg,
+				       const struct nft_data *data,
+				       enum nft_data_types type,
+				       unsigned int len);
+
 static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
 					struct nft_set *set,
 					const struct nft_set_iter *iter,
@@ -8675,10 +8681,11 @@ EXPORT_SYMBOL_GPL(nft_parse_register_load);
  * 	A value of NULL for the data means that its runtime gathered
  * 	data.
  */
-int nft_validate_register_store(const struct nft_ctx *ctx,
-				enum nft_registers reg,
-				const struct nft_data *data,
-				enum nft_data_types type, unsigned int len)
+static int nft_validate_register_store(const struct nft_ctx *ctx,
+				       enum nft_registers reg,
+				       const struct nft_data *data,
+				       enum nft_data_types type,
+				       unsigned int len)
 {
 	int err;
 
@@ -8710,7 +8717,24 @@ int nft_validate_register_store(const struct nft_ctx *ctx,
 		return 0;
 	}
 }
-EXPORT_SYMBOL_GPL(nft_validate_register_store);
+
+int nft_parse_register_store(const struct nft_ctx *ctx,
+			     const struct nlattr *attr, u8 *dreg,
+			     const struct nft_data *data,
+			     enum nft_data_types type, unsigned int len)
+{
+	int err;
+	u32 reg;
+
+	reg = nft_parse_register(attr);
+	err = nft_validate_register_store(ctx, reg, data, type, len);
+	if (err < 0)
+		return err;
+
+	*dreg = reg;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_parse_register_store);
 
 static const struct nla_policy nft_verdict_policy[NFTA_VERDICT_MAX + 1] = {
 	[NFTA_VERDICT_CODE]	= { .type = NLA_U32 },
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 2157970b3cd3..47b0dba95054 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -17,7 +17,7 @@
 
 struct nft_bitwise {
 	u8			sreg;
-	enum nft_registers	dreg:8;
+	u8			dreg;
 	enum nft_bitwise_ops	op:8;
 	u8			len;
 	struct nft_data		mask;
@@ -174,9 +174,9 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	priv->dreg = nft_parse_register(tb[NFTA_BITWISE_DREG]);
-	err = nft_validate_register_store(ctx, priv->dreg, NULL,
-					  NFT_DATA_VALUE, priv->len);
+	err = nft_parse_register_store(ctx, tb[NFTA_BITWISE_DREG],
+				       &priv->dreg, NULL, NFT_DATA_VALUE,
+				       priv->len);
 	if (err < 0)
 		return err;
 
@@ -320,9 +320,8 @@ static int nft_bitwise_fast_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	priv->dreg = nft_parse_register(tb[NFTA_BITWISE_DREG]);
-	err = nft_validate_register_store(ctx, priv->dreg, NULL,
-					  NFT_DATA_VALUE, sizeof(u32));
+	err = nft_parse_register_store(ctx, tb[NFTA_BITWISE_DREG], &priv->dreg,
+				       NULL, NFT_DATA_VALUE, sizeof(u32));
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 0960563cd5a1..9d5947ab8d4e 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -17,7 +17,7 @@
 
 struct nft_byteorder {
 	u8			sreg;
-	enum nft_registers	dreg:8;
+	u8			dreg;
 	enum nft_byteorder_ops	op:8;
 	u8			len;
 	u8			size;
@@ -142,9 +142,9 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	priv->dreg = nft_parse_register(tb[NFTA_BYTEORDER_DREG]);
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, priv->len);
+	return nft_parse_register_store(ctx, tb[NFTA_BYTEORDER_DREG],
+					&priv->dreg, NULL, NFT_DATA_VALUE,
+					priv->len);
 }
 
 static int nft_byteorder_dump(struct sk_buff *skb, const struct nft_expr *expr)
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index c1d7a3c615d8..882fe8648653 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -27,7 +27,7 @@ struct nft_ct {
 	enum nft_ct_keys	key:8;
 	enum ip_conntrack_dir	dir:8;
 	union {
-		enum nft_registers	dreg:8;
+		u8		dreg;
 		u8		sreg;
 	};
 };
@@ -498,9 +498,8 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		}
 	}
 
-	priv->dreg = nft_parse_register(tb[NFTA_CT_DREG]);
-	err = nft_validate_register_store(ctx, priv->dreg, NULL,
-					  NFT_DATA_VALUE, len);
+	err = nft_parse_register_store(ctx, tb[NFTA_CT_DREG], &priv->dreg, NULL,
+				       NFT_DATA_VALUE, len);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 9c2b3bde1ac9..f64f0017e9a5 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -19,7 +19,7 @@ struct nft_exthdr {
 	u8			offset;
 	u8			len;
 	u8			op;
-	enum nft_registers	dreg:8;
+	u8			dreg;
 	u8			sreg;
 	u8			flags;
 };
@@ -350,12 +350,12 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
 	priv->offset = offset;
 	priv->len    = len;
-	priv->dreg   = nft_parse_register(tb[NFTA_EXTHDR_DREG]);
 	priv->flags  = flags;
 	priv->op     = op;
 
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, priv->len);
+	return nft_parse_register_store(ctx, tb[NFTA_EXTHDR_DREG],
+					&priv->dreg, NULL, NFT_DATA_VALUE,
+					priv->len);
 }
 
 static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 4dfdaeaf09a5..b10ce732b337 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -86,7 +86,6 @@ int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return -EINVAL;
 
 	priv->result = ntohl(nla_get_be32(tb[NFTA_FIB_RESULT]));
-	priv->dreg = nft_parse_register(tb[NFTA_FIB_DREG]);
 
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
@@ -106,8 +105,8 @@ int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return -EINVAL;
 	}
 
-	err = nft_validate_register_store(ctx, priv->dreg, NULL,
-					  NFT_DATA_VALUE, len);
+	err = nft_parse_register_store(ctx, tb[NFTA_FIB_DREG], &priv->dreg,
+				       NULL, NFT_DATA_VALUE, len);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 7ee6c6da50ae..f829f5289e16 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -15,7 +15,7 @@
 
 struct nft_jhash {
 	u8			sreg;
-	enum nft_registers      dreg:8;
+	u8			dreg;
 	u8			len;
 	bool			autogen_seed:1;
 	u32			modulus;
@@ -38,7 +38,7 @@ static void nft_jhash_eval(const struct nft_expr *expr,
 }
 
 struct nft_symhash {
-	enum nft_registers      dreg:8;
+	u8			dreg;
 	u32			modulus;
 	u32			offset;
 };
@@ -83,8 +83,6 @@ static int nft_jhash_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_HASH_OFFSET])
 		priv->offset = ntohl(nla_get_be32(tb[NFTA_HASH_OFFSET]));
 
-	priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
-
 	err = nft_parse_u32_check(tb[NFTA_HASH_LEN], U8_MAX, &len);
 	if (err < 0)
 		return err;
@@ -111,8 +109,8 @@ static int nft_jhash_init(const struct nft_ctx *ctx,
 		get_random_bytes(&priv->seed, sizeof(priv->seed));
 	}
 
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, sizeof(u32));
+	return nft_parse_register_store(ctx, tb[NFTA_HASH_DREG], &priv->dreg,
+					NULL, NFT_DATA_VALUE, sizeof(u32));
 }
 
 static int nft_symhash_init(const struct nft_ctx *ctx,
@@ -128,8 +126,6 @@ static int nft_symhash_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_HASH_OFFSET])
 		priv->offset = ntohl(nla_get_be32(tb[NFTA_HASH_OFFSET]));
 
-	priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
-
 	priv->modulus = ntohl(nla_get_be32(tb[NFTA_HASH_MODULUS]));
 	if (priv->modulus < 1)
 		return -ERANGE;
@@ -137,8 +133,9 @@ static int nft_symhash_init(const struct nft_ctx *ctx,
 	if (priv->offset + priv->modulus - 1 < priv->offset)
 		return -EOVERFLOW;
 
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, sizeof(u32));
+	return nft_parse_register_store(ctx, tb[NFTA_HASH_DREG],
+					&priv->dreg, NULL, NFT_DATA_VALUE,
+					sizeof(u32));
 }
 
 static int nft_jhash_dump(struct sk_buff *skb,
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index c63eb3b17178..90c64d27ae53 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -48,9 +48,9 @@ static int nft_immediate_init(const struct nft_ctx *ctx,
 
 	priv->dlen = desc.len;
 
-	priv->dreg = nft_parse_register(tb[NFTA_IMMEDIATE_DREG]);
-	err = nft_validate_register_store(ctx, priv->dreg, &priv->data,
-					  desc.type, desc.len);
+	err = nft_parse_register_store(ctx, tb[NFTA_IMMEDIATE_DREG],
+				       &priv->dreg, &priv->data, desc.type,
+				       desc.len);
 	if (err < 0)
 		goto err1;
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 9e87b6d39f51..b0f558b4fea5 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -18,7 +18,7 @@
 struct nft_lookup {
 	struct nft_set			*set;
 	u8				sreg;
-	enum nft_registers		dreg:8;
+	u8				dreg;
 	bool				invert;
 	struct nft_set_binding		binding;
 };
@@ -100,9 +100,9 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 		if (!(set->flags & NFT_SET_MAP))
 			return -EINVAL;
 
-		priv->dreg = nft_parse_register(tb[NFTA_LOOKUP_DREG]);
-		err = nft_validate_register_store(ctx, priv->dreg, NULL,
-						  set->dtype, set->dlen);
+		err = nft_parse_register_store(ctx, tb[NFTA_LOOKUP_DREG],
+					       &priv->dreg, NULL, set->dtype,
+					       set->dlen);
 		if (err < 0)
 			return err;
 	} else if (set->flags & NFT_SET_MAP)
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 65e231ec1884..a7e01e9952f1 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -535,9 +535,8 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	priv->dreg = nft_parse_register(tb[NFTA_META_DREG]);
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, len);
+	return nft_parse_register_store(ctx, tb[NFTA_META_DREG], &priv->dreg,
+					NULL, NFT_DATA_VALUE, len);
 }
 EXPORT_SYMBOL_GPL(nft_meta_get_init);
 
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index f1fc824f9737..722cac1e90e0 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -16,7 +16,7 @@
 static DEFINE_PER_CPU(struct rnd_state, nft_numgen_prandom_state);
 
 struct nft_ng_inc {
-	enum nft_registers      dreg:8;
+	u8			dreg;
 	u32			modulus;
 	atomic_t		counter;
 	u32			offset;
@@ -66,11 +66,10 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
 	if (priv->offset + priv->modulus - 1 < priv->offset)
 		return -EOVERFLOW;
 
-	priv->dreg = nft_parse_register(tb[NFTA_NG_DREG]);
 	atomic_set(&priv->counter, priv->modulus - 1);
 
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, sizeof(u32));
+	return nft_parse_register_store(ctx, tb[NFTA_NG_DREG], &priv->dreg,
+					NULL, NFT_DATA_VALUE, sizeof(u32));
 }
 
 static int nft_ng_dump(struct sk_buff *skb, enum nft_registers dreg,
@@ -100,7 +99,7 @@ static int nft_ng_inc_dump(struct sk_buff *skb, const struct nft_expr *expr)
 }
 
 struct nft_ng_random {
-	enum nft_registers      dreg:8;
+	u8			dreg;
 	u32			modulus;
 	u32			offset;
 };
@@ -140,10 +139,8 @@ static int nft_ng_random_init(const struct nft_ctx *ctx,
 
 	prandom_init_once(&nft_numgen_prandom_state);
 
-	priv->dreg = nft_parse_register(tb[NFTA_NG_DREG]);
-
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, sizeof(u32));
+	return nft_parse_register_store(ctx, tb[NFTA_NG_DREG], &priv->dreg,
+					NULL, NFT_DATA_VALUE, sizeof(u32));
 }
 
 static int nft_ng_random_dump(struct sk_buff *skb, const struct nft_expr *expr)
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index c261d57a666a..ac61f708b82d 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -6,7 +6,7 @@
 #include <linux/netfilter/nfnetlink_osf.h>
 
 struct nft_osf {
-	enum nft_registers	dreg:8;
+	u8			dreg;
 	u8			ttl;
 	u32			flags;
 };
@@ -78,9 +78,9 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 		priv->flags = flags;
 	}
 
-	priv->dreg = nft_parse_register(tb[NFTA_OSF_DREG]);
-	err = nft_validate_register_store(ctx, priv->dreg, NULL,
-					  NFT_DATA_VALUE, NFT_OSF_MAXGENRELEN);
+	err = nft_parse_register_store(ctx, tb[NFTA_OSF_DREG], &priv->dreg,
+				       NULL, NFT_DATA_VALUE,
+				       NFT_OSF_MAXGENRELEN);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index d4e88db4116d..cb1c8c231880 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -144,10 +144,10 @@ static int nft_payload_init(const struct nft_ctx *ctx,
 	priv->base   = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
 	priv->offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	priv->len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
-	priv->dreg   = nft_parse_register(tb[NFTA_PAYLOAD_DREG]);
 
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, priv->len);
+	return nft_parse_register_store(ctx, tb[NFTA_PAYLOAD_DREG],
+					&priv->dreg, NULL, NFT_DATA_VALUE,
+					priv->len);
 }
 
 static int nft_payload_dump(struct sk_buff *skb, const struct nft_expr *expr)
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index 7cfcb0e2f7ee..bcd01a63e38f 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -15,7 +15,7 @@
 
 struct nft_rt {
 	enum nft_rt_keys	key:8;
-	enum nft_registers	dreg:8;
+	u8			dreg;
 };
 
 static u16 get_tcpmss(const struct nft_pktinfo *pkt, const struct dst_entry *skbdst)
@@ -141,9 +141,8 @@ static int nft_rt_get_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	priv->dreg = nft_parse_register(tb[NFTA_RT_DREG]);
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, len);
+	return nft_parse_register_store(ctx, tb[NFTA_RT_DREG], &priv->dreg,
+					NULL, NFT_DATA_VALUE, len);
 }
 
 static int nft_rt_get_dump(struct sk_buff *skb,
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index a28aca5124ce..c9b8a2b03b71 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -10,7 +10,7 @@
 struct nft_socket {
 	enum nft_socket_keys		key:8;
 	union {
-		enum nft_registers	dreg:8;
+		u8			dreg;
 	};
 };
 
@@ -133,9 +133,8 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	priv->dreg = nft_parse_register(tb[NFTA_SOCKET_DREG]);
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, len);
+	return nft_parse_register_store(ctx, tb[NFTA_SOCKET_DREG], &priv->dreg,
+					NULL, NFT_DATA_VALUE, len);
 }
 
 static int nft_socket_dump(struct sk_buff *skb,
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index d3eb953d0333..3b27926d5382 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -15,7 +15,7 @@
 
 struct nft_tunnel {
 	enum nft_tunnel_keys	key:8;
-	enum nft_registers	dreg:8;
+	u8			dreg;
 	enum nft_tunnel_mode	mode:8;
 };
 
@@ -93,8 +93,6 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	priv->dreg = nft_parse_register(tb[NFTA_TUNNEL_DREG]);
-
 	if (tb[NFTA_TUNNEL_MODE]) {
 		priv->mode = ntohl(nla_get_be32(tb[NFTA_TUNNEL_MODE]));
 		if (priv->mode > NFT_TUNNEL_MODE_MAX)
@@ -103,8 +101,8 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
 		priv->mode = NFT_TUNNEL_MODE_NONE;
 	}
 
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, len);
+	return nft_parse_register_store(ctx, tb[NFTA_TUNNEL_DREG], &priv->dreg,
+					NULL, NFT_DATA_VALUE, len);
 }
 
 static int nft_tunnel_get_dump(struct sk_buff *skb,
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 06d5cabf1d7c..cbbbc4ecad3a 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -24,7 +24,7 @@ static const struct nla_policy nft_xfrm_policy[NFTA_XFRM_MAX + 1] = {
 
 struct nft_xfrm {
 	enum nft_xfrm_keys	key:8;
-	enum nft_registers	dreg:8;
+	u8			dreg;
 	u8			dir;
 	u8			spnum;
 };
@@ -86,9 +86,8 @@ static int nft_xfrm_get_init(const struct nft_ctx *ctx,
 
 	priv->spnum = spnum;
 
-	priv->dreg = nft_parse_register(tb[NFTA_XFRM_DREG]);
-	return nft_validate_register_store(ctx, priv->dreg, NULL,
-					   NFT_DATA_VALUE, len);
+	return nft_parse_register_store(ctx, tb[NFTA_XFRM_DREG], &priv->dreg,
+					NULL, NFT_DATA_VALUE, len);
 }
 
 /* Return true if key asks for daddr/saddr and current
-- 
2.20.1

