Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F05B57D093
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiGUQCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiGUQCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:02:06 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BD987C1C;
        Thu, 21 Jul 2022 09:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658419324; x=1689955324;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+ZXx8PpQH9ORcZ620YbfxkO6vGclgqajHlTMOeal9nE=;
  b=NHjzRfDm4pIkhyhoppIYIFkchI0q8ABBEJzh2LLci8NsZ5RQuUKsNvmu
   AhWB3Tjk0+gQ3hkawJAsSwTWnjsjJ8DVQaHbKHmNJSahEEhGTzQ+ABouT
   cHhn3khAukjq8GMRA7zpNtSfif+0wvup1ZMwcPoPxL3q/jUkrnKK0fEsN
   k4WTLV4aZxvqxTFXL7tXQ6HCGPs5dtwVIlJJXbNWFnQiR6OAKw8LQuGTS
   zB8AHARE/2wezTdxB9ZIfl86cc7DmNF0BwjBipbVQ7jVjxyCv1V5EfAfp
   Hmga5oczsYBwo2JhqCwbysClmC9Jj8TcPobTdKZBxJLzltZ7LgB53a83M
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="348787166"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="348787166"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 09:01:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="740727604"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 21 Jul 2022 09:01:43 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26LG1crc003918;
        Thu, 21 Jul 2022 17:01:42 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] netlink: add 'bitmap' attribute type (%NL_ATTR_TYPE_BITMAP / %NLA_BITMAP)
Date:   Thu, 21 Jul 2022 17:59:50 +0200
Message-Id: <20220721155950.747251-5-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721155950.747251-1-alexandr.lobakin@intel.com>
References: <20220721155950.747251-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new type of Netlink attribute -- bitmap.

Internally, bitmaps are represented as arrays of unsigned longs.
This provides optimal performance and memory usage; however, bitness
dependent types can't be used to communicate between kernel and
userspace -- for example, userapp can be 32-bit on a 64-bit system.
So, to provide reliable communication data type, 64-bit arrays are
used. Netlink core takes care of converting them from/to unsigned
longs when sending or receiving Netlink messages; although, on LE
and 64-bit systems conversion is a no-op. They also can have
explicit byteorder -- core code also handles this (both kernel and
userspace must know in advance the byteorder of a particular
attribute), as well as cases when the userspace and the kernel
assume different number of bits (-> different number of u64s) for
an attribute.

Basic consumer functions/macros are:
* nla_put_bitmap and nla_get_bitmap families -- to easily put a
  bitmap to an skb or get it from a received message (only pointer
  to an unsigned long bitmap and the number of bits in it are
  needed), with optional explicit byteorder;
* nla_total_size_bitmap() -- to provide estimate size in bytes to
  Netlink needed to store a bitmap;
* {,__}NLA_POLICY_BITMAP() -- to declare a Netlink policy for a
  bitmap attribute.

Netlink policy for a bitmap can have an optional bitmap mask of bits
supported by the code -- for example, to filter out obsolete bits
removed some time ago. Without it, Netlink will make sure no bits
past the passed number are set. Both variants can be requested from
the userspace and the kernel will put a mask into a new policy
attribute (%NL_POLICY_TYPE_ATTR_BITMAP_MASK).

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/net/netlink.h        | 159 ++++++++++++++++++++++++++++++++++-
 include/uapi/linux/netlink.h |   5 ++
 lib/nlattr.c                 |  43 +++++++++-
 net/netlink/policy.c         |  44 ++++++++++
 4 files changed, 249 insertions(+), 2 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 7a2a9d3144ba..87fcb8d0cbe8 100644
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
+	NLA_BITMAP,
 	NLA_REJECT,
 	__NLA_TYPE_MAX,
 };
@@ -235,12 +236,16 @@ enum nla_policy_validation {
  *                         given type fits, using it verifies minimum length
  *                         just like "All other"
  *    NLA_BITFIELD32       Unused
+ *    NLA_BITMAP           Number of bits in the bitmap
  *    NLA_REJECT           Unused
  *    All other            Minimum length of attribute payload
  *
  * Meaning of validation union:
  *    NLA_BITFIELD32       This is a 32-bit bitmap/bitselector attribute and
  *                         `bitfield32_valid' is the u32 value of valid flags
+ *    NLA_BITMAP           `bitmap_mask` is a pointer to the mask of the valid
+ *                         bits of the given bitmap to perform the validation,
+ *                         its lowest 2 bits specify its type (u64/be64/le64).
  *    NLA_REJECT           This attribute is always rejected and `reject_message'
  *                         may point to a string to report as the error instead
  *                         of the generic one in extended ACK.
@@ -326,6 +331,7 @@ struct nla_policy {
 		struct {
 			s16 min, max;
 		};
+		const unsigned long *bitmap_mask;
 		int (*validate)(const struct nlattr *attr,
 				struct netlink_ext_ack *extack);
 		/* This entry is special, and used for the attribute at index 0
@@ -442,6 +448,47 @@ struct nla_policy {
 }
 #define NLA_POLICY_MIN_LEN(_len)	NLA_POLICY_MIN(NLA_BINARY, _len)
 
+/* `unsigned long` has alignment of 4 or 8 bytes, so [1:0] are always zero.
+ * We put bitmap type (%BITMAP_ARR_*64) there to not inflate &nla_policy
+ * (one new `u32` field adds 10 Kb to kernel data). Bitmap type is 0 (native)
+ * in most cases, which means no pointer modifications.
+ * The variable arguments can take only one optional argument: pointer to
+ * the bitmap mask used for validation. If it's not present, ::bitmap_mask
+ * carries only bitmap type.
+ * The first cast here ensures that the passed mask bitmap is compatible with
+ * `const unsigned long *`, the second -- that @_type is scalar.
+ */
+#define __NLA_POLICY_BITMAP_MASK(_type, ...)				 \
+	((typeof((__VA_ARGS__ + 0) ? : NULL))				 \
+	 ((typeof((_type) + 0UL))(__VA_ARGS__ + 0) + (_type)))
+
+static_assert(__BITMAP_ARR_TYPE_NUM <= __alignof__(long));
+
+/**
+ * __NLA_POLICY_BITMAP - represent &nla_policy for a bitmap attribute
+ * @_nbits - number of bits in the bitmap
+ * @_type - type of the an arr64 used for communication (%BITMAP_ARR_*64)
+ * @... - optional pointer to a bitmap carrying mask of supported bits
+ */
+#define __NLA_POLICY_BITMAP(_nbits, _type, ...) {			 \
+	.type = NLA_BITMAP,						 \
+	.len = (_nbits),						 \
+	.bitmap_mask = __NLA_POLICY_BITMAP_MASK((_type), ##__VA_ARGS__), \
+	.validation_type = (__VA_ARGS__ + 0) ? NLA_VALIDATE_MASK : 0,	 \
+}
+
+#define NLA_POLICY_BITMAP(nbits, ...)					 \
+	__NLA_POLICY_BITMAP((nbits), BITMAP_ARR_U64, ##__VA_ARGS__)
+
+#define nla_policy_bitmap_mask(pt)					 \
+	((typeof((pt)->bitmap_mask))					 \
+	 ((size_t)(pt)->bitmap_mask & ~(__alignof__(long) - 1)))
+
+#define nla_policy_bitmap_type(pt)					 \
+	((u32)((size_t)(pt)->bitmap_mask & (__alignof__(long) - 1)))
+
+#define nla_policy_bitmap_nbits(pt)	((pt)->len)
+
 /**
  * struct nl_info - netlink source information
  * @nlh: Netlink message header of original request
@@ -1545,6 +1592,63 @@ static inline int nla_put_bitfield32(struct sk_buff *skb, int attrtype,
 	return nla_put(skb, attrtype, sizeof(tmp), &tmp);
 }
 
+/**
+ * __nla_put_bitmap - Add a bitmap netlink attribute to a socket buffer
+ * @skb: socket buffer to add attribute to
+ * @attrtype: attribute type
+ * @bitmap: bitmap to put
+ * @nbits: number of bits in the bitmap
+ * @type: type of the u64-array bitmap to put (%BITMAP_ARR_*64)
+ * @padattr: attribute type for the padding
+ */
+static inline int __nla_put_bitmap(struct sk_buff *skb, int attrtype,
+				   const unsigned long *bitmap,
+				   size_t nbits, u32 type, int padattr)
+{
+	struct nlattr *nla;
+
+	nla = nla_reserve_64bit(skb, attrtype, bitmap_arr64_size(nbits),
+				padattr);
+	if (unlikely(!nla))
+		return -EMSGSIZE;
+
+	bitmap_to_arr64_type(nla_data(nla), bitmap, nbits, type);
+
+	return 0;
+}
+
+static inline int nla_put_bitmap(struct sk_buff *skb, int attrtype,
+				 const unsigned long *bitmap, size_t nbits,
+				 int padattr)
+{
+	return __nla_put_bitmap(skb, attrtype, bitmap, nbits, BITMAP_ARR_U64,
+				padattr);
+}
+
+static inline int nla_put_bitmap_be(struct sk_buff *skb, int attrtype,
+				    const unsigned long *bitmap, size_t nbits,
+				    int padattr)
+{
+	return __nla_put_bitmap(skb, attrtype, bitmap, nbits, BITMAP_ARR_BE64,
+				padattr);
+}
+
+static inline int nla_put_bitmap_le(struct sk_buff *skb, int attrtype,
+				    const unsigned long *bitmap, size_t nbits,
+				    int padattr)
+{
+	return __nla_put_bitmap(skb, attrtype, bitmap, nbits, BITMAP_ARR_LE64,
+				padattr);
+}
+
+static inline int nla_put_bitmap_net(struct sk_buff *skb, int attrtype,
+				     const unsigned long *bitmap, size_t nbits,
+				     int padattr)
+{
+	return nla_put_bitmap_be(skb, attrtype | NLA_F_NET_BYTEORDER, bitmap,
+				 nbits, padattr);
+}
+
 /**
  * nla_get_u32 - return payload of u32 attribute
  * @nla: u32 netlink attribute
@@ -1738,6 +1842,47 @@ static inline struct nla_bitfield32 nla_get_bitfield32(const struct nlattr *nla)
 	return tmp;
 }
 
+/**
+ * __nla_get_bitmap - Return a bitmap from u64-array bitmap Netlink attribute
+ * @nla: %NLA_BITMAP Netlink attribute
+ * @bitmap: target container
+ * @nbits: expected number of bits in the bitmap
+ * @type: expected type of the attribute (%BITMAP_ARR_*64)
+ */
+static inline void __nla_get_bitmap(const struct nlattr *nla,
+				    unsigned long *bitmap,
+				    size_t nbits, u32 type)
+{
+	size_t diff = ALIGN(nbits, BITS_PER_LONG);
+
+	nbits = min_t(typeof(nbits), nbits, nla_len(nla) * BITS_PER_BYTE);
+	bitmap_from_arr64_type(bitmap, nla_data(nla), nbits, type);
+
+	diff -= ALIGN(nbits, BITS_PER_LONG);
+	if (diff)
+		bitmap_clear(bitmap, ALIGN(nbits, BITS_PER_LONG), diff);
+}
+
+static inline void nla_get_bitmap(const struct nlattr *nla,
+				  unsigned long *bitmap, size_t nbits)
+{
+	return __nla_get_bitmap(nla, bitmap, nbits, BITMAP_ARR_U64);
+}
+
+static inline void nla_get_bitmap_be(const struct nlattr *nla,
+				     unsigned long *bitmap, size_t nbits)
+{
+	return __nla_get_bitmap(nla, bitmap, nbits, BITMAP_ARR_BE64);
+}
+
+static inline void nla_get_bitmap_le(const struct nlattr *nla,
+				     unsigned long *bitmap, size_t nbits)
+{
+	return __nla_get_bitmap(nla, bitmap, nbits, BITMAP_ARR_LE64);
+}
+
+#define nla_get_bitmap_net nla_get_bitmap_be
+
 /**
  * nla_memdup - duplicate attribute memory (kmemdup)
  * @src: netlink attribute to duplicate from
@@ -1910,6 +2055,18 @@ static inline int nla_total_size_64bit(int payload)
 		;
 }
 
+/**
+ * nla_total_size_bitmap - get total size of Netlink attr for a number of bits
+ * @nbits: number of bits to store in the attribute
+ *
+ * Returns the size in bytes of a Netlink attribute needed to carry
+ * the specified number of bits.
+ */
+static inline size_t nla_total_size_bitmap(size_t nbits)
+{
+	return nla_total_size_64bit(bitmap_arr64_size(nbits));
+}
+
 /**
  * nla_for_each_attr - iterate over a stream of attributes
  * @pos: loop counter, set to current attribute
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 855dffb4c1c3..cb55d3ce810b 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -284,6 +284,8 @@ struct nla_bitfield32 {
  *	entry has attributes again, the policy for those inner ones
  *	and the corresponding maxtype may be specified.
  * @NL_ATTR_TYPE_BITFIELD32: &struct nla_bitfield32 attribute
+ * @NL_ATTR_TYPE_BITMAP: array of 64-bit unsigned values (__{u,be,le}64)
+ * which form one big bitmap. Validated by an optional bitmask.
  */
 enum netlink_attribute_type {
 	NL_ATTR_TYPE_INVALID,
@@ -308,6 +310,7 @@ enum netlink_attribute_type {
 	NL_ATTR_TYPE_NESTED_ARRAY,
 
 	NL_ATTR_TYPE_BITFIELD32,
+	NL_ATTR_TYPE_BITMAP,
 };
 
 /**
@@ -337,6 +340,7 @@ enum netlink_attribute_type {
  *	bitfield32 type (U32)
  * @NL_POLICY_TYPE_ATTR_MASK: mask of valid bits for unsigned integers (U64)
  * @NL_POLICY_TYPE_ATTR_PAD: pad attribute for 64-bit alignment
+ * @NL_POLICY_TYPE_ATTR_BITMAP_MASK: mask of valid bits for bitmaps
  */
 enum netlink_policy_type_attr {
 	NL_POLICY_TYPE_ATTR_UNSPEC,
@@ -352,6 +356,7 @@ enum netlink_policy_type_attr {
 	NL_POLICY_TYPE_ATTR_BITFIELD32_MASK,
 	NL_POLICY_TYPE_ATTR_PAD,
 	NL_POLICY_TYPE_ATTR_MASK,
+	NL_POLICY_TYPE_ATTR_BITMAP_MASK,
 
 	/* keep last */
 	__NL_POLICY_TYPE_ATTR_MAX,
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 86029ad5ead4..ebff927cfe3a 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -81,6 +81,33 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
 	return 0;
 }
 
+static int nla_validate_bitmap_mask(const struct nla_policy *pt,
+				    const struct nlattr *nla,
+				    struct netlink_ext_ack *extack)
+{
+	unsigned long *bitmap;
+	size_t nbits;
+	bool res;
+
+	nbits = min_t(typeof(nbits), nla_len(nla) * BITS_PER_BYTE,
+		      nla_policy_bitmap_nbits(pt));
+
+	bitmap = bitmap_alloc(nbits, in_task() ? GFP_KERNEL : GFP_ATOMIC);
+	if (!bitmap)
+		return -ENOMEM;
+
+	__nla_get_bitmap(nla, bitmap, nbits, nla_policy_bitmap_type(pt));
+	res = bitmap_andnot(bitmap, bitmap, nla_policy_bitmap_mask(pt), nbits);
+	kfree(bitmap);
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
@@ -342,6 +369,8 @@ static int nla_validate_mask(const struct nla_policy *pt,
 	case NLA_U64:
 		value = nla_get_u64(nla);
 		break;
+	case NLA_BITMAP:
+		return nla_validate_bitmap_mask(pt, nla, extack);
 	default:
 		return -EINVAL;
 	}
@@ -422,6 +451,15 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			goto out_err;
 		break;
 
+	case NLA_BITMAP:
+		err = bitmap_validate_arr64_type(nla_data(nla), nla_len(nla),
+						 nla_policy_bitmap_nbits(pt),
+						 nla_policy_bitmap_type(pt));
+		if (err)
+			goto out_err;
+
+		break;
+
 	case NLA_NUL_STRING:
 		if (pt->len)
 			minlen = min_t(int, attrlen, pt->len + 1);
@@ -649,7 +687,10 @@ nla_policy_len(const struct nla_policy *p, int n)
 	int i, len = 0;
 
 	for (i = 0; i < n; i++, p++) {
-		if (p->len)
+		if (p->type == NLA_BITMAP)
+			len +=
+			    nla_total_size_bitmap(nla_policy_bitmap_nbits(p));
+		else if (p->len)
 			len += nla_total_size(p->len);
 		else if (nla_attr_len[p->type])
 			len += nla_total_size(nla_attr_len[p->type]);
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index 8d7c900e27f4..8a5a86fb1549 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -224,6 +224,10 @@ int netlink_policy_dump_attr_size_estimate(const struct nla_policy *pt)
 		       2 * (nla_attr_size(0) + nla_attr_size(sizeof(u64)));
 	case NLA_BITFIELD32:
 		return common + nla_attr_size(sizeof(u32));
+	case NLA_BITMAP:
+		/* maximum is common, aligned validation mask as u64 bitmap */
+		return common +
+		       nla_total_size_bitmap(nla_policy_bitmap_nbits(pt));
 	case NLA_STRING:
 	case NLA_NUL_STRING:
 	case NLA_BINARY:
@@ -237,6 +241,40 @@ int netlink_policy_dump_attr_size_estimate(const struct nla_policy *pt)
 	return 0;
 }
 
+static bool
+__netlink_policy_dump_write_attr_bitmap(struct sk_buff *skb,
+					const struct nla_policy *pt)
+{
+	if (pt->validation_type == NLA_VALIDATE_MASK) {
+		if (__nla_put_bitmap(skb, NL_POLICY_TYPE_ATTR_BITMAP_MASK,
+				     nla_policy_bitmap_mask(pt),
+				     nla_policy_bitmap_nbits(pt),
+				     nla_policy_bitmap_type(pt),
+				     NL_POLICY_TYPE_ATTR_PAD))
+			return false;
+	} else {
+		unsigned long *mask;
+		int ret;
+
+		mask = bitmap_zalloc(nla_policy_bitmap_nbits(pt),
+				     in_task() ? GFP_KERNEL : GFP_ATOMIC);
+		if (!mask)
+			return false;
+
+		bitmap_set(mask, 0, nla_policy_bitmap_nbits(pt));
+		ret = __nla_put_bitmap(skb, NL_POLICY_TYPE_ATTR_BITMAP_MASK,
+				       mask, nla_policy_bitmap_nbits(pt),
+				       nla_policy_bitmap_type(pt),
+				       NL_POLICY_TYPE_ATTR_PAD);
+		kfree(mask);
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
@@ -336,6 +374,12 @@ __netlink_policy_dump_write_attr(struct netlink_policy_dump_state *state,
 				pt->bitfield32_valid))
 			goto nla_put_failure;
 		break;
+	case NLA_BITMAP:
+		if (!__netlink_policy_dump_write_attr_bitmap(skb, pt))
+			goto nla_put_failure;
+
+		type = NL_ATTR_TYPE_BITMAP;
+		break;
 	case NLA_STRING:
 	case NLA_NUL_STRING:
 	case NLA_BINARY:
-- 
2.36.1

