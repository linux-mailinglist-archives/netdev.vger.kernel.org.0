Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADEA602DCF
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiJRODH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiJROCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:02:43 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EC3CF879;
        Tue, 18 Oct 2022 07:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666101759; x=1697637759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RkiUUj60o6FLNMt4eAQsTiMQGRhAoNuFCHZcWK5racQ=;
  b=GSwbSDZwdFBV58qjnzQ5xWW691+w7gKOlTqfgAAEzXZ1ssA5tlC4+LFZ
   vgGNJodKc0A0lr4oqXhaJ3nVuqhs8pHFm6xb/R9R+N3boWcUcCoAkUuyA
   hifs0NYIBfsrDhIRHEopUn8g6sSVP1GlFy3lMCXKgI9To0SAclat28eB4
   3tVKGSzbYgsJuCF4B0KGlnKQYKgOPvQMEcABbooI00Wsw+JM2jlc/6S1/
   yYAuWQVsKrQEigYRg4c9BARBAFfXI7nTwG58VzpZVpVNYMMhklZEXnYoH
   JasgHRYRtMKSZIMCaWG3w8loOMqTM56Fd1vV8iDkIqhiAXTYWoDELy1K5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="286502880"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="286502880"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 07:02:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="697510414"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="697510414"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 18 Oct 2022 07:02:36 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29IE2TUQ011675;
        Tue, 18 Oct 2022 15:02:35 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 6/6] netlink: add universal 'bigint' attribute type
Date:   Tue, 18 Oct 2022 16:00:27 +0200
Message-Id: <20221018140027.48086-7-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018140027.48086-1-alexandr.lobakin@intel.com>
References: <20221018140027.48086-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new type of Netlink attribute -- big integer.

Basically bigints are just arrays of u32s, but can carry anything,
with 1 bit precision. Using variable-length arrays of a fixed type
gives the following:

* versatility: one type can carry scalars from u8 to u64, bitmaps,
  binary data etc.;
* scalability: the same Netlink attribute can be changed to a wider
  (or shorter) data type with no compatibility issues, same for
  growing bitmaps;
* optimization: 4-byte units don't require wasting slots for empty
  padding attributes (they always have natural alignment in Netlink
  messages).

The only downside is that get/put functions sometimes are not just
direct assignment inlines due to the internal representation using
bitmaps (longs) and the bitmap API.

Basic consumer functions/macros are:
* nla_put_bigint() and nla_get_bigint() -- to easily put a bigint to
  an skb or get it from a received message (only pointer to an
  unsigned long array and the number of bits in it are needed);
* nla_put_bigint_{u,be,le,net}{8,16,32,64}() -- alternatives to the
  already existing family to send/receive scalars using the new type
  (instead of distinct attr types);
* nla_total_size_bigint*() -- to provide estimate size in bytes to
  Netlink needed to store a bigint/type;
* NLA_POLICY_BIGINT*() -- to declare a Netlink policy for a bigint
  attribute.

There are also *_bitmap() aliases for the *_bigint() helpers which
have no differences and designed to distinguish bigints from bitmaps
in the call sites (for readability).

Netlink policy for a bigint can have an optional bitmap mask of bits
supported by the code -- for example, to filter out obsolete bits
removed some time ago or limit value to n bits (e.g. 53 instead of
64). Without it, Netlink will just make sure no bits past the passed
number are set. Both variants can be requested from the userspace
and the kernel will put a mask into a new policy attribute
(%NL_POLICY_TYPE_ATTR_BIGINT_MASK).

Note on including <linux/bitmap.h> into <net/netlink.h>: seems to
introduce no visible compilation time regressions, make includecheck
doesn't see anything illegit as well. Hiding everything inside
lib/nlattr.c would require making a couple dozens optimizable
inlines external, doesn't sound optimal.

Suggested-by: Jakub Kicinski <kuba@kernel.org> # NLA_BITMAP -> NLA_BIGINT
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/net/netlink.h        | 208 ++++++++++++++++++++++++++++++++++-
 include/uapi/linux/netlink.h |   6 +
 lib/nlattr.c                 |  42 ++++++-
 net/netlink/policy.c         |  40 +++++++
 4 files changed, 294 insertions(+), 2 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 4418b1981e31..2b7194e7a540 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -2,7 +2,7 @@
 #ifndef __NET_NETLINK_H
 #define __NET_NETLINK_H
 
-#include <linux/types.h>
+#include <linux/bitmap.h>
 #include <linux/netlink.h>
 #include <linux/jiffies.h>
 #include <linux/in6.h>
@@ -180,6 +180,7 @@ enum {
 	NLA_S32,
 	NLA_S64,
 	NLA_BITFIELD32,
+	NLA_BIGINT,
 	NLA_REJECT,
 	__NLA_TYPE_MAX,
 };
@@ -235,12 +236,15 @@ enum nla_policy_validation {
  *                         given type fits, using it verifies minimum length
  *                         just like "All other"
  *    NLA_BITFIELD32       Unused
+ *    NLA_BIGINT           Number of bits in the big integer
  *    NLA_REJECT           Unused
  *    All other            Minimum length of attribute payload
  *
  * Meaning of validation union:
  *    NLA_BITFIELD32       This is a 32-bit bitmap/bitselector attribute and
  *                         `bitfield32_valid' is the u32 value of valid flags
+ *    NLA_BIGINT           `bigint_mask` is a pointer to the mask of the valid
+ *                         bits of the given bigint to perform the validation.
  *    NLA_REJECT           This attribute is always rejected and `reject_message'
  *                         may point to a string to report as the error instead
  *                         of the generic one in extended ACK.
@@ -327,6 +331,7 @@ struct nla_policy {
 			s16 min, max;
 			u8 network_byte_order:1;
 		};
+		const unsigned long *bigint_mask;
 		int (*validate)(const struct nlattr *attr,
 				struct netlink_ext_ack *extack);
 		/* This entry is special, and used for the attribute at index 0
@@ -451,6 +456,35 @@ struct nla_policy {
 }
 #define NLA_POLICY_MIN_LEN(_len)	NLA_POLICY_MIN(NLA_BINARY, _len)
 
+/**
+ * NLA_POLICY_BIGINT - represent &nla_policy for a bigint attribute
+ * @nbits - number of bits in the bigint
+ * @... - optional pointer to a bitmap carrying a mask of supported bits
+ */
+#define NLA_POLICY_BIGINT(nbits, ...) {					\
+	.type = NLA_BIGINT,						\
+	.len = (nbits),							\
+	.bigint_mask =							\
+		(typeof((__VA_ARGS__ + 0) ? : NULL))(__VA_ARGS__ + 0),	\
+	.validation_type = (__VA_ARGS__ + 0) ? NLA_VALIDATE_MASK : 0,	\
+}
+
+/* Simplify (and encourage) using the bigint type to send scalars */
+#define NLA_POLICY_BIGINT_TYPE(type, ...)				\
+	NLA_POLICY_BIGINT(BITS_PER_TYPE(type), ##__VA_ARGS__)
+
+#define NLA_POLICY_BIGINT_U8		NLA_POLICY_BIGINT_TYPE(u8)
+#define NLA_POLICY_BIGINT_U16		NLA_POLICY_BIGINT_TYPE(u16)
+#define NLA_POLICY_BIGINT_U32		NLA_POLICY_BIGINT_TYPE(u32)
+#define NLA_POLICY_BIGINT_U64		NLA_POLICY_BIGINT_TYPE(u64)
+
+/* Transparent alias (for readability purposes) */
+#define NLA_POLICY_BITMAP(nbits, ...)					\
+	NLA_POLICY_BIGINT((nbits), ##__VA_ARGS__)
+
+#define nla_policy_bigint_mask(pt)	((pt)->bigint_mask)
+#define nla_policy_bigint_nbits(pt)	((pt)->len)
+
 /**
  * struct nl_info - netlink source information
  * @nlh: Netlink message header of original request
@@ -1556,6 +1590,28 @@ static inline int nla_put_bitfield32(struct sk_buff *skb, int attrtype,
 	return nla_put(skb, attrtype, sizeof(tmp), &tmp);
 }
 
+/**
+ * nla_put_bigint - Add a bigint Netlink attribute to a socket buffer
+ * @skb: socket buffer to add attribute to
+ * @attrtype: attribute type
+ * @bigint: bigint to put, as array of unsigned longs
+ * @nbits: number of bits in the bigint
+ */
+static inline int nla_put_bigint(struct sk_buff *skb, int attrtype,
+				 const unsigned long *bigint,
+				 size_t nbits)
+{
+	struct nlattr *nla;
+
+	nla = nla_reserve(skb, attrtype, bitmap_arr32_size(nbits));
+	if (unlikely(!nla))
+		return -EMSGSIZE;
+
+	bitmap_to_arr32(nla_data(nla), bigint, nbits);
+
+	return 0;
+}
+
 /**
  * nla_get_u32 - return payload of u32 attribute
  * @nla: u32 netlink attribute
@@ -1749,6 +1805,134 @@ static inline struct nla_bitfield32 nla_get_bitfield32(const struct nlattr *nla)
 	return tmp;
 }
 
+/**
+ * nla_get_bigint - Return a bigint from u32-array bigint Netlink attribute
+ * @nla: %NLA_BIGINT Netlink attribute
+ * @bigint: target container, as array of unsigned longs
+ * @nbits: expected number of bits in the bigint
+ */
+static inline void nla_get_bigint(const struct nlattr *nla,
+				  unsigned long *bigint,
+				  size_t nbits)
+{
+	size_t diff = BITS_TO_LONGS(nbits);
+
+	/* Core validated nla_len() is (n + 1) * sizeof(u32), leave a hint */
+	nbits = clamp_t(size_t, BYTES_TO_BITS(nla_len(nla)),
+			BITS_PER_TYPE(u32), nbits);
+	bitmap_from_arr32(bigint, nla_data(nla), nbits);
+
+	diff -= BITS_TO_LONGS(nbits);
+	memset(bigint + BITS_TO_LONGS(nbits), 0, diff * sizeof(long));
+}
+
+/* The macros below build the following set of functions, allowing to
+ * easily use the %NLA_BIGINT API to send scalar values. Their fake
+ * declarations are provided under #if 0, so that source code indexers
+ * could build references to them.
+ */
+#if 0
+int nla_put_bigint_s8(struct sk_buff *skb, int attrtype, __s8 value);
+__s8 nla_get_bigint_s8(const struct nlattr *nla);
+int nla_put_bigint_s16(struct sk_buff *skb, int attrtype, __s16 value);
+__s16 nla_get_bigint_s16(const struct nlattr *nla);
+int nla_put_bigint_s32(struct sk_buff *skb, int attrtype, __s32 value);
+__s32 nla_get_bigint_s32(const struct nlattr *nla);
+int nla_put_bigint_s64(struct sk_buff *skb, int attrtype, __s64 value);
+__s64 nla_get_bigint_s64(const struct nlattr *nla);
+
+int nla_put_bigint_u8(struct sk_buff *skb, int attrtype, __u8 value);
+__u8 nla_get_bigint_u8(const struct nlattr *nla);
+int nla_put_bigint_u16(struct sk_buff *skb, int attrtype, __u16 value);
+__u16 nla_get_bigint_u16(const struct nlattr *nla);
+int nla_put_bigint_u32(struct sk_buff *skb, int attrtype, __u32 value);
+__u32 nla_get_bigint_u32(const struct nlattr *nla);
+int nla_put_bigint_u64(struct sk_buff *skb, int attrtype, __u64 value);
+__u64 nla_get_bigint_u64(const struct nlattr *nla);
+
+int nla_put_bigint_be16(struct sk_buff *skb, int attrtype, __be16 value);
+__be16 nla_get_bigint_be16(const struct nlattr *nla);
+int nla_put_bigint_be32(struct sk_buff *skb, int attrtype, __be32 value);
+__be32 nla_get_bigint_be32(const struct nlattr *nla);
+int nla_put_bigint_be64(struct sk_buff *skb, int attrtype, __be64 value);
+__be64 nla_get_bigint_be64(const struct nlattr *nla);
+
+int nla_put_bigint_le16(struct sk_buff *skb, int attrtype, __le16 value);
+__le16 nla_get_bigint_le16(const struct nlattr *nla);
+int nla_put_bigint_le32(struct sk_buff *skb, int attrtype, __le32 value);
+__le32 nla_get_bigint_le32(const struct nlattr *nla);
+int nla_put_bigint_le64(struct sk_buff *skb, int attrtype, __le64 value);
+__le64 nla_get_bigint_le64(const struct nlattr *nla);
+
+int nla_put_bigint_net16(struct sk_buff *skb, int attrtype, __be16 value);
+__be16 nla_get_bigint_net16(const struct nlattr *nla);
+int nla_put_bigint_net32(struct sk_buff *skb, int attrtype, __be32 value);
+__be32 nla_get_bigint_net32(const struct nlattr *nla);
+int nla_put_bigint_net64(struct sk_buff *skb, int attrtype, __be64 value);
+__be64 nla_get_bigint_net64(const struct nlattr *nla);
+#endif
+
+#define NLA_BUILD_BIGINT_TYPE(type)					 \
+static inline int							 \
+nla_put_bigint_##type(struct sk_buff *skb, int attrtype, __##type value) \
+{									 \
+	DECLARE_BITMAP(bigint, BITS_PER_TYPE(u64)) = {			 \
+		BITMAP_FROM_U64((__force u64)value),			 \
+	};								 \
+									 \
+	return nla_put_bigint(skb, attrtype, bigint,			 \
+			      BITS_PER_TYPE(__##type));			 \
+}									 \
+									 \
+static inline __##type							 \
+nla_get_bigint_##type(const struct nlattr *nla)				 \
+{									 \
+	DECLARE_BITMAP(bigint, BITS_PER_TYPE(u64));			 \
+									 \
+	nla_get_bigint(nla, bigint, BITS_PER_TYPE(__##type));		 \
+									 \
+	return (__force __##type)BITMAP_TO_U64(bigint);			 \
+}
+
+#define NLA_BUILD_BIGINT_NET(width)					 \
+static inline int							 \
+nla_put_bigint_net##width(struct sk_buff *skb, int attrtype,		 \
+			  __be##width value)				 \
+{									 \
+	return nla_put_bigint_be##width(skb,				 \
+					attrtype | NLA_F_NET_BYTEORDER,  \
+					value);				 \
+}									 \
+									 \
+static inline __be##width						 \
+nla_get_bigint_net##width(const struct nlattr *nla)			 \
+{									 \
+	return nla_get_bigint_be##width(nla);				 \
+}
+
+#define NLA_BUILD_BIGINT_ORDER(order)					 \
+	NLA_BUILD_BIGINT_TYPE(order##16);				 \
+	NLA_BUILD_BIGINT_TYPE(order##32);				 \
+	NLA_BUILD_BIGINT_TYPE(order##64)
+
+NLA_BUILD_BIGINT_TYPE(s8);
+NLA_BUILD_BIGINT_TYPE(u8);
+
+NLA_BUILD_BIGINT_ORDER(s);
+NLA_BUILD_BIGINT_ORDER(u);
+NLA_BUILD_BIGINT_ORDER(be);
+NLA_BUILD_BIGINT_ORDER(le);
+
+NLA_BUILD_BIGINT_NET(16);
+NLA_BUILD_BIGINT_NET(32);
+NLA_BUILD_BIGINT_NET(64);
+
+/* Aliases for readability */
+#define nla_put_bitmap(skb, attrtype, bitmap, nbits)			 \
+	nla_put_bigint((skb), (attrtype), (bitmap), (nbits))
+#define nla_get_bitmap(nlattr, bitmap, nbits)				 \
+	nla_get_bigint((nlattr), (bitmap), (nbits))
+
 /**
  * nla_memdup - duplicate attribute memory (kmemdup)
  * @src: netlink attribute to duplicate from
@@ -1921,6 +2105,28 @@ static inline int nla_total_size_64bit(int payload)
 		;
 }
 
+/**
+ * nla_total_size_bigint - get total size of Netlink attr for a number of bits
+ * @nbits: number of bits to store in the attribute
+ *
+ * Returns the size in bytes of a Netlink attribute needed to carry
+ * the specified number of bits.
+ */
+static inline size_t nla_total_size_bigint(size_t nbits)
+{
+	return nla_total_size(bitmap_arr32_size(nbits));
+}
+
+#define nla_total_size_bigint_type(type)		\
+	nla_total_size_bigint(BITS_PER_TYPE(type))
+
+#define nla_total_size_bigint_u8()	nla_total_size_bigint_type(u8)
+#define nla_total_size_bigint_u16()	nla_total_size_bigint_type(u16)
+#define nla_total_size_bigint_u32()	nla_total_size_bigint_type(u32)
+#define nla_total_size_bigint_u64()	nla_total_size_bigint_type(u64)
+
+#define nla_total_size_bitmap(nbits)	nla_total_size_bigint(nbits)
+
 /**
  * nla_for_each_attr - iterate over a stream of attributes
  * @pos: loop counter, set to current attribute
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index e2ae82e3f9f7..15e599961b23 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -298,6 +298,8 @@ struct nla_bitfield32 {
  *	entry has attributes again, the policy for those inner ones
  *	and the corresponding maxtype may be specified.
  * @NL_ATTR_TYPE_BITFIELD32: &struct nla_bitfield32 attribute
+ * @NL_ATTR_TYPE_BIGINT: array of 32-bit unsigned integers which form
+ *	one big integer or bitmap. Validated by an optional bitmask.
  */
 enum netlink_attribute_type {
 	NL_ATTR_TYPE_INVALID,
@@ -322,6 +324,7 @@ enum netlink_attribute_type {
 	NL_ATTR_TYPE_NESTED_ARRAY,
 
 	NL_ATTR_TYPE_BITFIELD32,
+	NL_ATTR_TYPE_BIGINT,
 };
 
 /**
@@ -351,6 +354,8 @@ enum netlink_attribute_type {
  *	bitfield32 type (U32)
  * @NL_POLICY_TYPE_ATTR_MASK: mask of valid bits for unsigned integers (U64)
  * @NL_POLICY_TYPE_ATTR_PAD: pad attribute for 64-bit alignment
+ * @NL_POLICY_TYPE_ATTR_BIGINT_MASK: array with mask of valid
+ *	bits for bigints
  *
  * @__NL_POLICY_TYPE_ATTR_MAX: number of attributes
  * @NL_POLICY_TYPE_ATTR_MAX: highest attribute number
@@ -369,6 +374,7 @@ enum netlink_policy_type_attr {
 	NL_POLICY_TYPE_ATTR_BITFIELD32_MASK,
 	NL_POLICY_TYPE_ATTR_PAD,
 	NL_POLICY_TYPE_ATTR_MASK,
+	NL_POLICY_TYPE_ATTR_BIGINT_MASK,
 
 	/* keep last */
 	__NL_POLICY_TYPE_ATTR_MAX,
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 40f22b177d69..c923ee6d2876 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -81,6 +81,33 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
 	return 0;
 }
 
+static int nla_validate_bigint_mask(const struct nla_policy *pt,
+				    const struct nlattr *nla,
+				    struct netlink_ext_ack *extack)
+{
+	unsigned long *bigint;
+	size_t nbits;
+	bool res;
+
+	nbits = min_t(size_t, BYTES_TO_BITS(nla_len(nla)),
+		      nla_policy_bigint_nbits(pt));
+
+	bigint = bitmap_alloc(nbits, in_task() ? GFP_KERNEL : GFP_ATOMIC);
+	if (!bigint)
+		return -ENOMEM;
+
+	nla_get_bigint(nla, bigint, nbits);
+	res = bitmap_andnot(bigint, bigint, nla_policy_bigint_mask(pt), nbits);
+	bitmap_free(bigint);
+
+	if (res) {
+		NL_SET_ERR_MSG_ATTR_POL(extack, nla, pt, "unexpected bit set");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
 			      const struct nla_policy *policy,
 			      struct netlink_ext_ack *extack,
@@ -365,6 +392,8 @@ static int nla_validate_mask(const struct nla_policy *pt,
 	case NLA_U64:
 		value = nla_get_u64(nla);
 		break;
+	case NLA_BIGINT:
+		return nla_validate_bigint_mask(pt, nla, extack);
 	default:
 		return -EINVAL;
 	}
@@ -445,6 +474,15 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			goto out_err;
 		break;
 
+	case NLA_BIGINT:
+		if (!bitmap_validate_arr32(nla_data(nla), nla_len(nla),
+					   nla_policy_bigint_nbits(pt))) {
+			err = -EINVAL;
+			goto out_err;
+		}
+
+		break;
+
 	case NLA_NUL_STRING:
 		if (pt->len)
 			minlen = min_t(int, attrlen, pt->len + 1);
@@ -672,7 +710,9 @@ nla_policy_len(const struct nla_policy *p, int n)
 	int i, len = 0;
 
 	for (i = 0; i < n; i++, p++) {
-		if (p->len)
+		if (p->type == NLA_BIGINT)
+			len += nla_total_size_bigint(nla_policy_bigint_nbits(p));
+		else if (p->len)
 			len += nla_total_size(p->len);
 		else if (nla_attr_len[p->type])
 			len += nla_total_size(nla_attr_len[p->type]);
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index 87e3de0fde89..79f8caeb8a77 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -234,6 +234,10 @@ int netlink_policy_dump_attr_size_estimate(const struct nla_policy *pt)
 		       2 * (nla_attr_size(0) + nla_attr_size(sizeof(u64)));
 	case NLA_BITFIELD32:
 		return common + nla_attr_size(sizeof(u32));
+	case NLA_BIGINT:
+		/* maximum is common, aligned validation mask as u32-arr */
+		return common +
+		       nla_total_size_bigint(nla_policy_bigint_nbits(pt));
 	case NLA_STRING:
 	case NLA_NUL_STRING:
 	case NLA_BINARY:
@@ -247,6 +251,36 @@ int netlink_policy_dump_attr_size_estimate(const struct nla_policy *pt)
 	return 0;
 }
 
+static bool
+__netlink_policy_dump_write_attr_bigint(struct sk_buff *skb,
+					const struct nla_policy *pt)
+{
+	if (pt->validation_type == NLA_VALIDATE_MASK) {
+		if (nla_put_bigint(skb, NL_POLICY_TYPE_ATTR_BIGINT_MASK,
+				   nla_policy_bigint_mask(pt),
+				   nla_policy_bigint_nbits(pt)))
+			return false;
+	} else {
+		unsigned long *mask;
+		int ret;
+
+		mask = bitmap_alloc(nla_policy_bigint_nbits(pt),
+				    in_task() ? GFP_KERNEL : GFP_ATOMIC);
+		if (!mask)
+			return false;
+
+		bitmap_fill(mask, nla_policy_bigint_nbits(pt));
+		ret = nla_put_bigint(skb, NL_POLICY_TYPE_ATTR_BIGINT_MASK,
+				     mask, nla_policy_bigint_nbits(pt));
+		bitmap_free(mask);
+
+		if (ret)
+			return false;
+	}
+
+	return true;
+}
+
 static int
 __netlink_policy_dump_write_attr(struct netlink_policy_dump_state *state,
 				 struct sk_buff *skb,
@@ -346,6 +380,12 @@ __netlink_policy_dump_write_attr(struct netlink_policy_dump_state *state,
 				pt->bitfield32_valid))
 			goto nla_put_failure;
 		break;
+	case NLA_BIGINT:
+		if (!__netlink_policy_dump_write_attr_bigint(skb, pt))
+			goto nla_put_failure;
+
+		type = NL_ATTR_TYPE_BIGINT;
+		break;
 	case NLA_STRING:
 	case NLA_NUL_STRING:
 	case NLA_BINARY:
-- 
2.37.3

