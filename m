Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42853119D5
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhBFDV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:21:27 -0500
Received: from correo.us.es ([193.147.175.20]:53506 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhBFDIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 22:08:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6CB84191928
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 02:50:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54A3DDA73D
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 02:50:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 490B8DA722; Sat,  6 Feb 2021 02:50:15 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 448DEDA73F;
        Sat,  6 Feb 2021 02:50:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Feb 2021 02:50:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 08E9E42E0F80;
        Sat,  6 Feb 2021 02:50:11 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 4/7] netfilter: nftables: add nft_parse_register_load() and use it
Date:   Sat,  6 Feb 2021 02:50:02 +0100
Message-Id: <20210206015005.23037-5-pablo@netfilter.org>
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
and the load validation function.

This update requires to replace:

	enum nft_registers      sreg:8;

in many of the expression private areas otherwise compiler complains
with:

	error: cannot take address of bit-field ‘sreg’

when passing the register field as reference.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      |  2 +-
 include/net/netfilter/nf_tables_core.h |  6 ++---
 include/net/netfilter/nft_meta.h       |  2 +-
 net/ipv4/netfilter/nft_dup_ipv4.c      | 18 ++++++-------
 net/ipv6/netfilter/nft_dup_ipv6.c      | 18 ++++++-------
 net/netfilter/nf_tables_api.c          | 18 +++++++++++--
 net/netfilter/nft_bitwise.c            | 10 ++++----
 net/netfilter/nft_byteorder.c          |  6 ++---
 net/netfilter/nft_cmp.c                |  8 +++---
 net/netfilter/nft_ct.c                 |  5 ++--
 net/netfilter/nft_dup_netdev.c         |  6 ++---
 net/netfilter/nft_dynset.c             | 12 ++++-----
 net/netfilter/nft_exthdr.c             |  6 ++---
 net/netfilter/nft_fwd_netdev.c         | 18 ++++++-------
 net/netfilter/nft_hash.c               | 10 +++++---
 net/netfilter/nft_lookup.c             |  6 ++---
 net/netfilter/nft_masq.c               | 18 ++++++-------
 net/netfilter/nft_meta.c               |  3 +--
 net/netfilter/nft_nat.c                | 35 +++++++++++---------------
 net/netfilter/nft_objref.c             |  6 ++---
 net/netfilter/nft_payload.c            |  4 +--
 net/netfilter/nft_queue.c              | 12 ++++-----
 net/netfilter/nft_range.c              |  6 ++---
 net/netfilter/nft_redir.c              | 18 ++++++-------
 net/netfilter/nft_tproxy.c             | 14 +++++------
 25 files changed, 132 insertions(+), 135 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f4af8362d234..033b31aa38cc 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -203,7 +203,7 @@ int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest);
 unsigned int nft_parse_register(const struct nlattr *attr);
 int nft_dump_register(struct sk_buff *skb, unsigned int attr, unsigned int reg);
 
-int nft_validate_register_load(enum nft_registers reg, unsigned int len);
+int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
 int nft_validate_register_store(const struct nft_ctx *ctx,
 				enum nft_registers reg,
 				const struct nft_data *data,
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 8657e6815b07..b7aff03a3f0f 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -26,14 +26,14 @@ void nf_tables_core_module_exit(void);
 struct nft_bitwise_fast_expr {
 	u32			mask;
 	u32			xor;
-	enum nft_registers	sreg:8;
+	u8			sreg;
 	enum nft_registers	dreg:8;
 };
 
 struct nft_cmp_fast_expr {
 	u32			data;
 	u32			mask;
-	enum nft_registers	sreg:8;
+	u8			sreg;
 	u8			len;
 	bool			inv;
 };
@@ -67,7 +67,7 @@ struct nft_payload_set {
 	enum nft_payload_bases	base:8;
 	u8			offset;
 	u8			len;
-	enum nft_registers	sreg:8;
+	u8			sreg;
 	u8			csum_type;
 	u8			csum_offset;
 	u8			csum_flags;
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index 07e2fd507963..946fa8c83798 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -8,7 +8,7 @@ struct nft_meta {
 	enum nft_meta_keys	key:8;
 	union {
 		enum nft_registers	dreg:8;
-		enum nft_registers	sreg:8;
+		u8		sreg;
 	};
 };
 
diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft_dup_ipv4.c
index bcdb37f86a94..aeb631760eb9 100644
--- a/net/ipv4/netfilter/nft_dup_ipv4.c
+++ b/net/ipv4/netfilter/nft_dup_ipv4.c
@@ -13,8 +13,8 @@
 #include <net/netfilter/ipv4/nf_dup_ipv4.h>
 
 struct nft_dup_ipv4 {
-	enum nft_registers	sreg_addr:8;
-	enum nft_registers	sreg_dev:8;
+	u8	sreg_addr;
+	u8	sreg_dev;
 };
 
 static void nft_dup_ipv4_eval(const struct nft_expr *expr,
@@ -40,16 +40,16 @@ static int nft_dup_ipv4_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_DUP_SREG_ADDR] == NULL)
 		return -EINVAL;
 
-	priv->sreg_addr = nft_parse_register(tb[NFTA_DUP_SREG_ADDR]);
-	err = nft_validate_register_load(priv->sreg_addr, sizeof(struct in_addr));
+	err = nft_parse_register_load(tb[NFTA_DUP_SREG_ADDR], &priv->sreg_addr,
+				      sizeof(struct in_addr));
 	if (err < 0)
 		return err;
 
-	if (tb[NFTA_DUP_SREG_DEV] != NULL) {
-		priv->sreg_dev = nft_parse_register(tb[NFTA_DUP_SREG_DEV]);
-		return nft_validate_register_load(priv->sreg_dev, sizeof(int));
-	}
-	return 0;
+	if (tb[NFTA_DUP_SREG_DEV])
+		err = nft_parse_register_load(tb[NFTA_DUP_SREG_DEV],
+					      &priv->sreg_dev, sizeof(int));
+
+	return err;
 }
 
 static int nft_dup_ipv4_dump(struct sk_buff *skb, const struct nft_expr *expr)
diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup_ipv6.c
index 8b5193efb1f1..3a00d95e964e 100644
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -13,8 +13,8 @@
 #include <net/netfilter/ipv6/nf_dup_ipv6.h>
 
 struct nft_dup_ipv6 {
-	enum nft_registers	sreg_addr:8;
-	enum nft_registers	sreg_dev:8;
+	u8	sreg_addr;
+	u8	sreg_dev;
 };
 
 static void nft_dup_ipv6_eval(const struct nft_expr *expr,
@@ -38,16 +38,16 @@ static int nft_dup_ipv6_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_DUP_SREG_ADDR] == NULL)
 		return -EINVAL;
 
-	priv->sreg_addr = nft_parse_register(tb[NFTA_DUP_SREG_ADDR]);
-	err = nft_validate_register_load(priv->sreg_addr, sizeof(struct in6_addr));
+	err = nft_parse_register_load(tb[NFTA_DUP_SREG_ADDR], &priv->sreg_addr,
+				      sizeof(struct in6_addr));
 	if (err < 0)
 		return err;
 
-	if (tb[NFTA_DUP_SREG_DEV] != NULL) {
-		priv->sreg_dev = nft_parse_register(tb[NFTA_DUP_SREG_DEV]);
-		return nft_validate_register_load(priv->sreg_dev, sizeof(int));
-	}
-	return 0;
+	if (tb[NFTA_DUP_SREG_DEV])
+		err = nft_parse_register_load(tb[NFTA_DUP_SREG_DEV],
+					      &priv->sreg_dev, sizeof(int));
+
+	return err;
 }
 
 static int nft_dup_ipv6_dump(struct sk_buff *skb, const struct nft_expr *expr)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 15c467f1a9dd..1e82ebba230d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8634,7 +8634,7 @@ EXPORT_SYMBOL_GPL(nft_dump_register);
  * 	Validate that the input register is one of the general purpose
  * 	registers and that the length of the load is within the bounds.
  */
-int nft_validate_register_load(enum nft_registers reg, unsigned int len)
+static int nft_validate_register_load(enum nft_registers reg, unsigned int len)
 {
 	if (reg < NFT_REG_1 * NFT_REG_SIZE / NFT_REG32_SIZE)
 		return -EINVAL;
@@ -8645,7 +8645,21 @@ int nft_validate_register_load(enum nft_registers reg, unsigned int len)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(nft_validate_register_load);
+
+int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len)
+{
+	u32 reg;
+	int err;
+
+	reg = nft_parse_register(attr);
+	err = nft_validate_register_load(reg, len);
+	if (err < 0)
+		return err;
+
+	*sreg = reg;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_parse_register_load);
 
 /**
  *	nft_validate_register_store - validate an expressions' register store
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index bbd773d74377..2157970b3cd3 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -16,7 +16,7 @@
 #include <net/netfilter/nf_tables_offload.h>
 
 struct nft_bitwise {
-	enum nft_registers	sreg:8;
+	u8			sreg;
 	enum nft_registers	dreg:8;
 	enum nft_bitwise_ops	op:8;
 	u8			len;
@@ -169,8 +169,8 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 
 	priv->len = len;
 
-	priv->sreg = nft_parse_register(tb[NFTA_BITWISE_SREG]);
-	err = nft_validate_register_load(priv->sreg, priv->len);
+	err = nft_parse_register_load(tb[NFTA_BITWISE_SREG], &priv->sreg,
+				      priv->len);
 	if (err < 0)
 		return err;
 
@@ -315,8 +315,8 @@ static int nft_bitwise_fast_init(const struct nft_ctx *ctx,
 	struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
 	int err;
 
-	priv->sreg = nft_parse_register(tb[NFTA_BITWISE_SREG]);
-	err = nft_validate_register_load(priv->sreg, sizeof(u32));
+	err = nft_parse_register_load(tb[NFTA_BITWISE_SREG], &priv->sreg,
+				      sizeof(u32));
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 12bed3f7bbc6..0960563cd5a1 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -16,7 +16,7 @@
 #include <net/netfilter/nf_tables.h>
 
 struct nft_byteorder {
-	enum nft_registers	sreg:8;
+	u8			sreg;
 	enum nft_registers	dreg:8;
 	enum nft_byteorder_ops	op:8;
 	u8			len;
@@ -131,14 +131,14 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 		return -EINVAL;
 	}
 
-	priv->sreg = nft_parse_register(tb[NFTA_BYTEORDER_SREG]);
 	err = nft_parse_u32_check(tb[NFTA_BYTEORDER_LEN], U8_MAX, &len);
 	if (err < 0)
 		return err;
 
 	priv->len = len;
 
-	err = nft_validate_register_load(priv->sreg, priv->len);
+	err = nft_parse_register_load(tb[NFTA_BYTEORDER_SREG], &priv->sreg,
+				      priv->len);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 00e563a72d3d..3640eea8a87b 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -18,7 +18,7 @@
 
 struct nft_cmp_expr {
 	struct nft_data		data;
-	enum nft_registers	sreg:8;
+	u8			sreg;
 	u8			len;
 	enum nft_cmp_ops	op:8;
 };
@@ -87,8 +87,7 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return err;
 	}
 
-	priv->sreg = nft_parse_register(tb[NFTA_CMP_SREG]);
-	err = nft_validate_register_load(priv->sreg, desc.len);
+	err = nft_parse_register_load(tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
 	if (err < 0)
 		return err;
 
@@ -174,8 +173,7 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	priv->sreg = nft_parse_register(tb[NFTA_CMP_SREG]);
-	err = nft_validate_register_load(priv->sreg, desc.len);
+	err = nft_parse_register_load(tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 8bcd49f14797..c1d7a3c615d8 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -28,7 +28,7 @@ struct nft_ct {
 	enum ip_conntrack_dir	dir:8;
 	union {
 		enum nft_registers	dreg:8;
-		enum nft_registers	sreg:8;
+		u8		sreg;
 	};
 };
 
@@ -600,8 +600,7 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 		}
 	}
 
-	priv->sreg = nft_parse_register(tb[NFTA_CT_SREG]);
-	err = nft_validate_register_load(priv->sreg, len);
+	err = nft_parse_register_load(tb[NFTA_CT_SREG], &priv->sreg, len);
 	if (err < 0)
 		goto err1;
 
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index 40788b3f1071..bbf3fcba3df4 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -14,7 +14,7 @@
 #include <net/netfilter/nf_dup_netdev.h>
 
 struct nft_dup_netdev {
-	enum nft_registers	sreg_dev:8;
+	u8	sreg_dev;
 };
 
 static void nft_dup_netdev_eval(const struct nft_expr *expr,
@@ -40,8 +40,8 @@ static int nft_dup_netdev_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_DUP_SREG_DEV] == NULL)
 		return -EINVAL;
 
-	priv->sreg_dev = nft_parse_register(tb[NFTA_DUP_SREG_DEV]);
-	return nft_validate_register_load(priv->sreg_dev, sizeof(int));
+	return nft_parse_register_load(tb[NFTA_DUP_SREG_DEV], &priv->sreg_dev,
+				       sizeof(int));
 }
 
 static int nft_dup_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 0b053f75cd60..b20c4c7ea57b 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -16,8 +16,8 @@ struct nft_dynset {
 	struct nft_set			*set;
 	struct nft_set_ext_tmpl		tmpl;
 	enum nft_dynset_ops		op:8;
-	enum nft_registers		sreg_key:8;
-	enum nft_registers		sreg_data:8;
+	u8				sreg_key;
+	u8				sreg_data;
 	bool				invert;
 	bool				expr;
 	u8				num_exprs;
@@ -219,8 +219,8 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			return err;
 	}
 
-	priv->sreg_key = nft_parse_register(tb[NFTA_DYNSET_SREG_KEY]);
-	err = nft_validate_register_load(priv->sreg_key, set->klen);
+	err = nft_parse_register_load(tb[NFTA_DYNSET_SREG_KEY], &priv->sreg_key,
+				      set->klen);
 	if (err < 0)
 		return err;
 
@@ -230,8 +230,8 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		if (set->dtype == NFT_DATA_VERDICT)
 			return -EOPNOTSUPP;
 
-		priv->sreg_data = nft_parse_register(tb[NFTA_DYNSET_SREG_DATA]);
-		err = nft_validate_register_load(priv->sreg_data, set->dlen);
+		err = nft_parse_register_load(tb[NFTA_DYNSET_SREG_DATA],
+					      &priv->sreg_data, set->dlen);
 		if (err < 0)
 			return err;
 	} else if (set->flags & NFT_SET_MAP)
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 3c48cdc8935d..9c2b3bde1ac9 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -20,7 +20,7 @@ struct nft_exthdr {
 	u8			len;
 	u8			op;
 	enum nft_registers	dreg:8;
-	enum nft_registers	sreg:8;
+	u8			sreg;
 	u8			flags;
 };
 
@@ -400,11 +400,11 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
 	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
 	priv->offset = offset;
 	priv->len    = len;
-	priv->sreg   = nft_parse_register(tb[NFTA_EXTHDR_SREG]);
 	priv->flags  = flags;
 	priv->op     = op;
 
-	return nft_validate_register_load(priv->sreg, priv->len);
+	return nft_parse_register_load(tb[NFTA_EXTHDR_SREG], &priv->sreg,
+				       priv->len);
 }
 
 static int nft_exthdr_ipv4_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index b77985986b24..cd59afde5b2f 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -18,7 +18,7 @@
 #include <net/ip.h>
 
 struct nft_fwd_netdev {
-	enum nft_registers	sreg_dev:8;
+	u8	sreg_dev;
 };
 
 static void nft_fwd_netdev_eval(const struct nft_expr *expr,
@@ -50,8 +50,8 @@ static int nft_fwd_netdev_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_FWD_SREG_DEV] == NULL)
 		return -EINVAL;
 
-	priv->sreg_dev = nft_parse_register(tb[NFTA_FWD_SREG_DEV]);
-	return nft_validate_register_load(priv->sreg_dev, sizeof(int));
+	return nft_parse_register_load(tb[NFTA_FWD_SREG_DEV], &priv->sreg_dev,
+				       sizeof(int));
 }
 
 static int nft_fwd_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
@@ -78,8 +78,8 @@ static int nft_fwd_netdev_offload(struct nft_offload_ctx *ctx,
 }
 
 struct nft_fwd_neigh {
-	enum nft_registers	sreg_dev:8;
-	enum nft_registers	sreg_addr:8;
+	u8			sreg_dev;
+	u8			sreg_addr;
 	u8			nfproto;
 };
 
@@ -157,8 +157,6 @@ static int nft_fwd_neigh_init(const struct nft_ctx *ctx,
 	    !tb[NFTA_FWD_NFPROTO])
 		return -EINVAL;
 
-	priv->sreg_dev = nft_parse_register(tb[NFTA_FWD_SREG_DEV]);
-	priv->sreg_addr = nft_parse_register(tb[NFTA_FWD_SREG_ADDR]);
 	priv->nfproto = ntohl(nla_get_be32(tb[NFTA_FWD_NFPROTO]));
 
 	switch (priv->nfproto) {
@@ -172,11 +170,13 @@ static int nft_fwd_neigh_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	err = nft_validate_register_load(priv->sreg_dev, sizeof(int));
+	err = nft_parse_register_load(tb[NFTA_FWD_SREG_DEV], &priv->sreg_dev,
+				      sizeof(int));
 	if (err < 0)
 		return err;
 
-	return nft_validate_register_load(priv->sreg_addr, addr_len);
+	return nft_parse_register_load(tb[NFTA_FWD_SREG_ADDR], &priv->sreg_addr,
+				       addr_len);
 }
 
 static int nft_fwd_neigh_dump(struct sk_buff *skb, const struct nft_expr *expr)
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 96371d878e7e..7ee6c6da50ae 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -14,7 +14,7 @@
 #include <linux/jhash.h>
 
 struct nft_jhash {
-	enum nft_registers      sreg:8;
+	u8			sreg;
 	enum nft_registers      dreg:8;
 	u8			len;
 	bool			autogen_seed:1;
@@ -83,7 +83,6 @@ static int nft_jhash_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_HASH_OFFSET])
 		priv->offset = ntohl(nla_get_be32(tb[NFTA_HASH_OFFSET]));
 
-	priv->sreg = nft_parse_register(tb[NFTA_HASH_SREG]);
 	priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
 
 	err = nft_parse_u32_check(tb[NFTA_HASH_LEN], U8_MAX, &len);
@@ -94,6 +93,10 @@ static int nft_jhash_init(const struct nft_ctx *ctx,
 
 	priv->len = len;
 
+	err = nft_parse_register_load(tb[NFTA_HASH_SREG], &priv->sreg, len);
+	if (err < 0)
+		return err;
+
 	priv->modulus = ntohl(nla_get_be32(tb[NFTA_HASH_MODULUS]));
 	if (priv->modulus < 1)
 		return -ERANGE;
@@ -108,8 +111,7 @@ static int nft_jhash_init(const struct nft_ctx *ctx,
 		get_random_bytes(&priv->seed, sizeof(priv->seed));
 	}
 
-	return nft_validate_register_load(priv->sreg, len) &&
-	       nft_validate_register_store(ctx, priv->dreg, NULL,
+	return nft_validate_register_store(ctx, priv->dreg, NULL,
 					   NFT_DATA_VALUE, sizeof(u32));
 }
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index f1363b8aabba..9e87b6d39f51 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -17,7 +17,7 @@
 
 struct nft_lookup {
 	struct nft_set			*set;
-	enum nft_registers		sreg:8;
+	u8				sreg;
 	enum nft_registers		dreg:8;
 	bool				invert;
 	struct nft_set_binding		binding;
@@ -76,8 +76,8 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-	priv->sreg = nft_parse_register(tb[NFTA_LOOKUP_SREG]);
-	err = nft_validate_register_load(priv->sreg, set->klen);
+	err = nft_parse_register_load(tb[NFTA_LOOKUP_SREG], &priv->sreg,
+				      set->klen);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 71390b727040..9953e8053753 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -15,8 +15,8 @@
 
 struct nft_masq {
 	u32			flags;
-	enum nft_registers      sreg_proto_min:8;
-	enum nft_registers      sreg_proto_max:8;
+	u8			sreg_proto_min;
+	u8			sreg_proto_max;
 };
 
 static const struct nla_policy nft_masq_policy[NFTA_MASQ_MAX + 1] = {
@@ -54,19 +54,15 @@ static int nft_masq_init(const struct nft_ctx *ctx,
 	}
 
 	if (tb[NFTA_MASQ_REG_PROTO_MIN]) {
-		priv->sreg_proto_min =
-			nft_parse_register(tb[NFTA_MASQ_REG_PROTO_MIN]);
-
-		err = nft_validate_register_load(priv->sreg_proto_min, plen);
+		err = nft_parse_register_load(tb[NFTA_MASQ_REG_PROTO_MIN],
+					      &priv->sreg_proto_min, plen);
 		if (err < 0)
 			return err;
 
 		if (tb[NFTA_MASQ_REG_PROTO_MAX]) {
-			priv->sreg_proto_max =
-				nft_parse_register(tb[NFTA_MASQ_REG_PROTO_MAX]);
-
-			err = nft_validate_register_load(priv->sreg_proto_max,
-							 plen);
+			err = nft_parse_register_load(tb[NFTA_MASQ_REG_PROTO_MAX],
+						      &priv->sreg_proto_max,
+						      plen);
 			if (err < 0)
 				return err;
 		} else {
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index bf4b3ad5314c..65e231ec1884 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -661,8 +661,7 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	priv->sreg = nft_parse_register(tb[NFTA_META_SREG]);
-	err = nft_validate_register_load(priv->sreg, len);
+	err = nft_parse_register_load(tb[NFTA_META_SREG], &priv->sreg, len);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 4bcf33b049c4..0840c635b752 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -21,10 +21,10 @@
 #include <net/ip.h>
 
 struct nft_nat {
-	enum nft_registers      sreg_addr_min:8;
-	enum nft_registers      sreg_addr_max:8;
-	enum nft_registers      sreg_proto_min:8;
-	enum nft_registers      sreg_proto_max:8;
+	u8			sreg_addr_min;
+	u8			sreg_addr_max;
+	u8			sreg_proto_min;
+	u8			sreg_proto_max;
 	enum nf_nat_manip_type  type:8;
 	u8			family;
 	u16			flags;
@@ -206,18 +206,15 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	priv->family = family;
 
 	if (tb[NFTA_NAT_REG_ADDR_MIN]) {
-		priv->sreg_addr_min =
-			nft_parse_register(tb[NFTA_NAT_REG_ADDR_MIN]);
-		err = nft_validate_register_load(priv->sreg_addr_min, alen);
+		err = nft_parse_register_load(tb[NFTA_NAT_REG_ADDR_MIN],
+					      &priv->sreg_addr_min, alen);
 		if (err < 0)
 			return err;
 
 		if (tb[NFTA_NAT_REG_ADDR_MAX]) {
-			priv->sreg_addr_max =
-				nft_parse_register(tb[NFTA_NAT_REG_ADDR_MAX]);
-
-			err = nft_validate_register_load(priv->sreg_addr_max,
-							 alen);
+			err = nft_parse_register_load(tb[NFTA_NAT_REG_ADDR_MAX],
+						      &priv->sreg_addr_max,
+						      alen);
 			if (err < 0)
 				return err;
 		} else {
@@ -229,19 +226,15 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	plen = sizeof_field(struct nf_nat_range, min_addr.all);
 	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
-		priv->sreg_proto_min =
-			nft_parse_register(tb[NFTA_NAT_REG_PROTO_MIN]);
-
-		err = nft_validate_register_load(priv->sreg_proto_min, plen);
+		err = nft_parse_register_load(tb[NFTA_NAT_REG_PROTO_MIN],
+					      &priv->sreg_proto_min, plen);
 		if (err < 0)
 			return err;
 
 		if (tb[NFTA_NAT_REG_PROTO_MAX]) {
-			priv->sreg_proto_max =
-				nft_parse_register(tb[NFTA_NAT_REG_PROTO_MAX]);
-
-			err = nft_validate_register_load(priv->sreg_proto_max,
-							 plen);
+			err = nft_parse_register_load(tb[NFTA_NAT_REG_PROTO_MAX],
+						      &priv->sreg_proto_max,
+						      plen);
 			if (err < 0)
 				return err;
 		} else {
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 5f9207a9f485..bc104d36d3bb 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -95,7 +95,7 @@ static const struct nft_expr_ops nft_objref_ops = {
 
 struct nft_objref_map {
 	struct nft_set		*set;
-	enum nft_registers	sreg:8;
+	u8			sreg;
 	struct nft_set_binding	binding;
 };
 
@@ -137,8 +137,8 @@ static int nft_objref_map_init(const struct nft_ctx *ctx,
 	if (!(set->flags & NFT_SET_OBJECT))
 		return -EINVAL;
 
-	priv->sreg = nft_parse_register(tb[NFTA_OBJREF_SET_SREG]);
-	err = nft_validate_register_load(priv->sreg, set->klen);
+	err = nft_parse_register_load(tb[NFTA_OBJREF_SET_SREG], &priv->sreg,
+				      set->klen);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 47d4e0e21651..d4e88db4116d 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -658,7 +658,6 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 	priv->base        = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
 	priv->offset      = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	priv->len         = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
-	priv->sreg        = nft_parse_register(tb[NFTA_PAYLOAD_SREG]);
 
 	if (tb[NFTA_PAYLOAD_CSUM_TYPE])
 		priv->csum_type =
@@ -691,7 +690,8 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	return nft_validate_register_load(priv->sreg, priv->len);
+	return nft_parse_register_load(tb[NFTA_PAYLOAD_SREG], &priv->sreg,
+				       priv->len);
 }
 
 static int nft_payload_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 23265d757acb..9ba1de51ac07 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -19,10 +19,10 @@
 static u32 jhash_initval __read_mostly;
 
 struct nft_queue {
-	enum nft_registers	sreg_qnum:8;
-	u16			queuenum;
-	u16			queues_total;
-	u16			flags;
+	u8	sreg_qnum;
+	u16	queuenum;
+	u16	queues_total;
+	u16	flags;
 };
 
 static void nft_queue_eval(const struct nft_expr *expr,
@@ -111,8 +111,8 @@ static int nft_queue_sreg_init(const struct nft_ctx *ctx,
 	struct nft_queue *priv = nft_expr_priv(expr);
 	int err;
 
-	priv->sreg_qnum = nft_parse_register(tb[NFTA_QUEUE_SREG_QNUM]);
-	err = nft_validate_register_load(priv->sreg_qnum, sizeof(u32));
+	err = nft_parse_register_load(tb[NFTA_QUEUE_SREG_QNUM],
+				      &priv->sreg_qnum, sizeof(u32));
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index 89efcc5a533d..e4a1c44d7f51 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -15,7 +15,7 @@
 struct nft_range_expr {
 	struct nft_data		data_from;
 	struct nft_data		data_to;
-	enum nft_registers	sreg:8;
+	u8			sreg;
 	u8			len;
 	enum nft_range_ops	op:8;
 };
@@ -86,8 +86,8 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 		goto err2;
 	}
 
-	priv->sreg = nft_parse_register(tb[NFTA_RANGE_SREG]);
-	err = nft_validate_register_load(priv->sreg, desc_from.len);
+	err = nft_parse_register_load(tb[NFTA_RANGE_SREG], &priv->sreg,
+				      desc_from.len);
 	if (err < 0)
 		goto err2;
 
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 2056051c0af0..ba09890dddb5 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -14,8 +14,8 @@
 #include <net/netfilter/nf_tables.h>
 
 struct nft_redir {
-	enum nft_registers	sreg_proto_min:8;
-	enum nft_registers	sreg_proto_max:8;
+	u8			sreg_proto_min;
+	u8			sreg_proto_max;
 	u16			flags;
 };
 
@@ -50,19 +50,15 @@ static int nft_redir_init(const struct nft_ctx *ctx,
 
 	plen = sizeof_field(struct nf_nat_range, min_addr.all);
 	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
-		priv->sreg_proto_min =
-			nft_parse_register(tb[NFTA_REDIR_REG_PROTO_MIN]);
-
-		err = nft_validate_register_load(priv->sreg_proto_min, plen);
+		err = nft_parse_register_load(tb[NFTA_REDIR_REG_PROTO_MIN],
+					      &priv->sreg_proto_min, plen);
 		if (err < 0)
 			return err;
 
 		if (tb[NFTA_REDIR_REG_PROTO_MAX]) {
-			priv->sreg_proto_max =
-				nft_parse_register(tb[NFTA_REDIR_REG_PROTO_MAX]);
-
-			err = nft_validate_register_load(priv->sreg_proto_max,
-							 plen);
+			err = nft_parse_register_load(tb[NFTA_REDIR_REG_PROTO_MAX],
+						      &priv->sreg_proto_max,
+						      plen);
 			if (err < 0)
 				return err;
 		} else {
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index d67f83a0958d..43a5a780a6d3 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -13,9 +13,9 @@
 #endif
 
 struct nft_tproxy {
-	enum nft_registers      sreg_addr:8;
-	enum nft_registers      sreg_port:8;
-	u8			family;
+	u8	sreg_addr;
+	u8	sreg_port;
+	u8	family;
 };
 
 static void nft_tproxy_eval_v4(const struct nft_expr *expr,
@@ -247,15 +247,15 @@ static int nft_tproxy_init(const struct nft_ctx *ctx,
 	}
 
 	if (tb[NFTA_TPROXY_REG_ADDR]) {
-		priv->sreg_addr = nft_parse_register(tb[NFTA_TPROXY_REG_ADDR]);
-		err = nft_validate_register_load(priv->sreg_addr, alen);
+		err = nft_parse_register_load(tb[NFTA_TPROXY_REG_ADDR],
+					      &priv->sreg_addr, alen);
 		if (err < 0)
 			return err;
 	}
 
 	if (tb[NFTA_TPROXY_REG_PORT]) {
-		priv->sreg_port = nft_parse_register(tb[NFTA_TPROXY_REG_PORT]);
-		err = nft_validate_register_load(priv->sreg_port, sizeof(u16));
+		err = nft_parse_register_load(tb[NFTA_TPROXY_REG_PORT],
+					      &priv->sreg_port, sizeof(u16));
 		if (err < 0)
 			return err;
 	}
-- 
2.20.1

