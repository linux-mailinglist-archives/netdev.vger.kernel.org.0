Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2163149FC8
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 09:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgA0IWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 03:22:13 -0500
Received: from correo.us.es ([193.147.175.20]:36458 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729110AbgA0IWM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 03:22:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A4B9BB1937
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 09:22:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9638ADA70E
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 09:22:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8B2A1DA707; Mon, 27 Jan 2020 09:22:07 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F7A9DA70F;
        Mon, 27 Jan 2020 09:22:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 27 Jan 2020 09:22:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1C00C42EFB81;
        Mon, 27 Jan 2020 09:22:05 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/6] netfilter: nf_tables: Support for sets with multiple ranged fields
Date:   Mon, 27 Jan 2020 09:20:51 +0100
Message-Id: <20200127082054.318263-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200127082054.318263-1-pablo@netfilter.org>
References: <20200127082054.318263-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

Introduce a new nested netlink attribute, NFTA_SET_DESC_CONCAT, used
to specify the length of each field in a set concatenation.

This allows set implementations to support concatenation of multiple
ranged items, as they can divide the input key into matching data for
every single field. Such set implementations would be selected as
they specify support for NFT_SET_INTERVAL and allow desc->field_count
to be greater than one. Explicitly disallow this for nft_set_rbtree.

In order to specify the interval for a set entry, userspace would
include in NFTA_SET_DESC_CONCAT attributes field lengths, and pass
range endpoints as two separate keys, represented by attributes
NFTA_SET_ELEM_KEY and NFTA_SET_ELEM_KEY_END.

While at it, export the number of 32-bit registers available for
packet matching, as nftables will need this to know the maximum
number of field lengths that can be specified.

For example, "packets with an IPv4 address between 192.0.2.0 and
192.0.2.42, with destination port between 22 and 25", can be
expressed as two concatenated elements:

  NFTA_SET_ELEM_KEY:            192.0.2.0 . 22
  NFTA_SET_ELEM_KEY_END:        192.0.2.42 . 25

and NFTA_SET_DESC_CONCAT attribute would contain:

  NFTA_LIST_ELEM
    NFTA_SET_FIELD_LEN:		4
  NFTA_LIST_ELEM
    NFTA_SET_FIELD_LEN:		2

v4: No changes
v3: Complete rework, NFTA_SET_DESC_CONCAT instead of NFTA_SET_SUBKEY
v2: No changes

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  8 +++
 include/uapi/linux/netfilter/nf_tables.h | 15 ++++++
 net/netfilter/nf_tables_api.c            | 90 +++++++++++++++++++++++++++++++-
 net/netfilter/nft_set_rbtree.c           |  3 ++
 4 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 504c0aa93805..4170c033d461 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -264,11 +264,15 @@ struct nft_set_iter {
  *	@klen: key length
  *	@dlen: data length
  *	@size: number of set elements
+ *	@field_len: length of each field in concatenation, bytes
+ *	@field_count: number of concatenated fields in element
  */
 struct nft_set_desc {
 	unsigned int		klen;
 	unsigned int		dlen;
 	unsigned int		size;
+	u8			field_len[NFT_REG32_COUNT];
+	u8			field_count;
 };
 
 /**
@@ -409,6 +413,8 @@ void nft_unregister_set(struct nft_set_type *type);
  * 	@dtype: data type (verdict or numeric type defined by userspace)
  * 	@objtype: object type (see NFT_OBJECT_* definitions)
  * 	@size: maximum set size
+ *	@field_len: length of each field in concatenation, bytes
+ *	@field_count: number of concatenated fields in element
  *	@use: number of rules references to this set
  * 	@nelems: number of elements
  * 	@ndeact: number of deactivated elements queued for removal
@@ -435,6 +441,8 @@ struct nft_set {
 	u32				dtype;
 	u32				objtype;
 	u32				size;
+	u8				field_len[NFT_REG32_COUNT];
+	u8				field_count;
 	u32				use;
 	atomic_t			nelems;
 	u32				ndeact;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c13106496bd2..065218a20bb7 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -48,6 +48,7 @@ enum nft_registers {
 
 #define NFT_REG_SIZE	16
 #define NFT_REG32_SIZE	4
+#define NFT_REG32_COUNT	(NFT_REG32_15 - NFT_REG32_00 + 1)
 
 /**
  * enum nft_verdicts - nf_tables internal verdicts
@@ -301,15 +302,29 @@ enum nft_set_policies {
  * enum nft_set_desc_attributes - set element description
  *
  * @NFTA_SET_DESC_SIZE: number of elements in set (NLA_U32)
+ * @NFTA_SET_DESC_CONCAT: description of field concatenation (NLA_NESTED)
  */
 enum nft_set_desc_attributes {
 	NFTA_SET_DESC_UNSPEC,
 	NFTA_SET_DESC_SIZE,
+	NFTA_SET_DESC_CONCAT,
 	__NFTA_SET_DESC_MAX
 };
 #define NFTA_SET_DESC_MAX	(__NFTA_SET_DESC_MAX - 1)
 
 /**
+ * enum nft_set_field_attributes - attributes of concatenated fields
+ *
+ * @NFTA_SET_FIELD_LEN: length of single field, in bits (NLA_U32)
+ */
+enum nft_set_field_attributes {
+	NFTA_SET_FIELD_UNSPEC,
+	NFTA_SET_FIELD_LEN,
+	__NFTA_SET_FIELD_MAX
+};
+#define NFTA_SET_FIELD_MAX	(__NFTA_SET_FIELD_MAX - 1)
+
+/**
  * enum nft_set_attributes - nf_tables set netlink attributes
  *
  * @NFTA_SET_TABLE: table name (NLA_STRING)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5f645a85538a..d1318bdf49ca 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3391,6 +3391,7 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 
 static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
 	[NFTA_SET_DESC_SIZE]		= { .type = NLA_U32 },
+	[NFTA_SET_DESC_CONCAT]		= { .type = NLA_NESTED },
 };
 
 static int nft_ctx_init_from_setattr(struct nft_ctx *ctx, struct net *net,
@@ -3557,6 +3558,33 @@ static __be64 nf_jiffies64_to_msecs(u64 input)
 	return cpu_to_be64(jiffies64_to_msecs(input));
 }
 
+static int nf_tables_fill_set_concat(struct sk_buff *skb,
+				     const struct nft_set *set)
+{
+	struct nlattr *concat, *field;
+	int i;
+
+	concat = nla_nest_start_noflag(skb, NFTA_SET_DESC_CONCAT);
+	if (!concat)
+		return -ENOMEM;
+
+	for (i = 0; i < set->field_count; i++) {
+		field = nla_nest_start_noflag(skb, NFTA_LIST_ELEM);
+		if (!field)
+			return -ENOMEM;
+
+		if (nla_put_be32(skb, NFTA_SET_FIELD_LEN,
+				 htonl(set->field_len[i])))
+			return -ENOMEM;
+
+		nla_nest_end(skb, field);
+	}
+
+	nla_nest_end(skb, concat);
+
+	return 0;
+}
+
 static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			      const struct nft_set *set, u16 event, u16 flags)
 {
@@ -3620,11 +3648,17 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 		goto nla_put_failure;
 
 	desc = nla_nest_start_noflag(skb, NFTA_SET_DESC);
+
 	if (desc == NULL)
 		goto nla_put_failure;
 	if (set->size &&
 	    nla_put_be32(skb, NFTA_SET_DESC_SIZE, htonl(set->size)))
 		goto nla_put_failure;
+
+	if (set->field_count > 1 &&
+	    nf_tables_fill_set_concat(skb, set))
+		goto nla_put_failure;
+
 	nla_nest_end(skb, desc);
 
 	nlmsg_end(skb, nlh);
@@ -3797,6 +3831,53 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 	return err;
 }
 
+static const struct nla_policy nft_concat_policy[NFTA_SET_FIELD_MAX + 1] = {
+	[NFTA_SET_FIELD_LEN]	= { .type = NLA_U32 },
+};
+
+static int nft_set_desc_concat_parse(const struct nlattr *attr,
+				     struct nft_set_desc *desc)
+{
+	struct nlattr *tb[NFTA_SET_FIELD_MAX + 1];
+	u32 len;
+	int err;
+
+	err = nla_parse_nested_deprecated(tb, NFTA_SET_FIELD_MAX, attr,
+					  nft_concat_policy, NULL);
+	if (err < 0)
+		return err;
+
+	if (!tb[NFTA_SET_FIELD_LEN])
+		return -EINVAL;
+
+	len = ntohl(nla_get_be32(tb[NFTA_SET_FIELD_LEN]));
+
+	if (len * BITS_PER_BYTE / 32 > NFT_REG32_COUNT)
+		return -E2BIG;
+
+	desc->field_len[desc->field_count++] = len;
+
+	return 0;
+}
+
+static int nft_set_desc_concat(struct nft_set_desc *desc,
+			       const struct nlattr *nla)
+{
+	struct nlattr *attr;
+	int rem, err;
+
+	nla_for_each_nested(attr, nla, rem) {
+		if (nla_type(attr) != NFTA_LIST_ELEM)
+			return -EINVAL;
+
+		err = nft_set_desc_concat_parse(attr, desc);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
 static int nf_tables_set_desc_parse(struct nft_set_desc *desc,
 				    const struct nlattr *nla)
 {
@@ -3810,8 +3891,10 @@ static int nf_tables_set_desc_parse(struct nft_set_desc *desc,
 
 	if (da[NFTA_SET_DESC_SIZE] != NULL)
 		desc->size = ntohl(nla_get_be32(da[NFTA_SET_DESC_SIZE]));
+	if (da[NFTA_SET_DESC_CONCAT])
+		err = nft_set_desc_concat(desc, da[NFTA_SET_DESC_CONCAT]);
 
-	return 0;
+	return err;
 }
 
 static int nf_tables_newset(struct net *net, struct sock *nlsk,
@@ -3834,6 +3917,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	unsigned char *udata;
 	u16 udlen;
 	int err;
+	int i;
 
 	if (nla[NFTA_SET_TABLE] == NULL ||
 	    nla[NFTA_SET_NAME] == NULL ||
@@ -4012,6 +4096,10 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	set->gc_int = gc_int;
 	set->handle = nf_tables_alloc_handle(table);
 
+	set->field_count = desc.field_count;
+	for (i = 0; i < desc.field_count; i++)
+		set->field_len[i] = desc.field_len[i];
+
 	err = ops->init(set, &desc, nla);
 	if (err < 0)
 		goto err3;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index a9f804f7a04a..5000b938ab1e 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -466,6 +466,9 @@ static void nft_rbtree_destroy(const struct nft_set *set)
 static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
 				struct nft_set_estimate *est)
 {
+	if (desc->field_count > 1)
+		return false;
+
 	if (desc->size)
 		est->size = sizeof(struct nft_rbtree) +
 			    desc->size * sizeof(struct nft_rbtree_elem);
-- 
2.11.0

