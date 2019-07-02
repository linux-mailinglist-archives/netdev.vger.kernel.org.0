Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4CD85CEC5
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfGBLuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:50:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:38570 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbfGBLuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:50:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 95251B117;
        Tue,  2 Jul 2019 11:50:09 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3AB0AE0159; Tue,  2 Jul 2019 13:50:09 +0200 (CEST)
Message-Id: <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
In-Reply-To: <cover.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 06/15] ethtool: netlink bitset handling
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue,  2 Jul 2019 13:50:09 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethtool netlink code uses common framework for passing arbitrary
length bit sets to allow future extensions. A bitset can be a list (only
one bitmap) or can consist of value and mask pair (used e.g. when client
want to modify only some bits). A bitset can use one of two formats:
verbose (bit by bit) or compact.

Verbose format consists of bitset size (number of bits), list flag and
an array of bit nests, telling which bits are part of the list or which
bits are in the mask and which of them are to be set. In requests, bits
can be identified by index (position) or by name. In replies, kernel
provides both index and name. Verbose format is suitable for "one shot"
applications like standard ethtool command as it avoids the need to
either keep bit names (e.g. link modes) in sync with kernel or having to
add an extra roundtrip for string set request (e.g. for private flags).

Compact format uses one (list) or two (value/mask) arrays of 32-bit
words to store the bitmap(s). It is more suitable for long running
applications (ethtool in monitor mode or network management daemons)
which can retrieve the names once and then pass only compact bitmaps to
save space.

Userspace requests can use either format and ETHTOOL_RF_COMPACT flag in
request header tells kernel which format to use in reply. Notifications
always use compact format.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.txt |  61 ++
 include/uapi/linux/ethtool_netlink.h         |  35 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/bitset.c                         | 606 +++++++++++++++++++
 net/ethtool/bitset.h                         |  40 ++
 net/ethtool/netlink.h                        |   9 +
 6 files changed, 752 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/bitset.c
 create mode 100644 net/ethtool/bitset.h

diff --git a/Documentation/networking/ethtool-netlink.txt b/Documentation/networking/ethtool-netlink.txt
index 97c369aa290b..4636682c551f 100644
--- a/Documentation/networking/ethtool-netlink.txt
+++ b/Documentation/networking/ethtool-netlink.txt
@@ -73,6 +73,67 @@ set, the behaviour is the same as (or closer to) the behaviour before it was
 introduced.
 
 
+Bit sets
+--------
+
+For short bitmaps of (reasonably) fixed length, standard NLA_BITFIELD32 type
+is used. For arbitrary length bitmaps, ethtool netlink uses a nested attribute
+with contents of one of two forms: compact (two binary bitmaps representing
+bit values and mask of affected bits) and bit-by-bit (list of bits identified
+by either index or name).
+
+Compact form: nested (bitset) atrribute contents:
+
+    ETHTOOL_A_BITSET_LIST	(flag)		no mask, only a list
+    ETHTOOL_A_BITSET_SIZE	(u32)		number of significant bits
+    ETHTOOL_A_BITSET_VALUE	(binary)	bitmap of bit values
+    ETHTOOL_A_BITSET_MASK	(binary)	bitmap of valid bits
+
+Value and mask must have length at least ETHTOOL_A_BITSET_SIZE bits rounded up
+to a multiple of 32 bits. They consist of 32-bit words in host byte order,
+words ordered from least significant to most significant (i.e. the same way as
+bitmaps are passed with ioctl interface).
+
+For compact form, ETHTOOL_A_BITSET_SIZE and ETHTOOL_A_BITSET_VALUE are
+mandatory.  Similar to BITFIELD32, a compact form bit set requests to set bits
+in the mask to 1 (if the bit is set in value) or 0 (if not) and preserve the
+rest. If ETHTOOL_A_BITSET_LIST is present, there is no mask and bitset
+represents a simple list of bits.
+
+Kernel bit set length may differ from userspace length if older application is
+used on newer kernel or vice versa. If userspace bitmap is longer, an error is
+issued only if the request actually tries to set values of some bits not
+recognized by kernel.
+
+Bit-by-bit form: nested (bitset) attribute contents:
+
+    ETHTOOL_A_BITSET_LIST	(flag)		no mask, only a list
+    ETHTOOL_A_BITSET_SIZE	(u32)		number of significant bits
+    ETHTOOL_A_BITSET_BIT	(nested)	array of bits
+	ETHTOOL_A_BITSET_BIT+   (nested)	one bit
+	    ETHTOOL_A_BIT_INDEX	(u32)		bit index (0 for LSB)
+	    ETHTOOL_A_BIT_NAME	(string)	bit name
+	    ETHTOOL_A_BIT_VALUE	(flag)		present if bit is set
+
+Bit size is optional for bit-by-bit form. ETHTOOL_A_BITSET_BITS nest can only
+contain ETHTOOL_A_BITS_BIT attributes but there can be an arbitrary number of
+them.  A bit may be identified by its index or by its name. When used in
+requests, listed bits are set to 0 or 1 according to ETHTOOL_A_BIT_VALUE, the
+rest is preserved. A request fails if index exceeds kernel bit length or if
+name is not recognized.
+
+When ETHTOOL_A_BITSET_LIST flag is present, bitset is interpreted as a simple
+bit list. ETHTOOL_A_BIT_VALUE attributes are not used in such case. Bit list
+represents a bitmap with listed bits set and the rest zero.
+
+In requests, application can use either form. Form used by kernel in reply is
+determined by a flag in flags field of request header. Semantics of value and
+mask depends on the attribute. General idea is that flags control request
+processing, info_mask control which parts of the information are returned in
+"get" request and index identifies a particular subcommand or an object to
+which the request applies.
+
+
 List of message types
 ---------------------
 
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index ffd7db0848ef..805f314f4454 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -52,6 +52,41 @@ enum {
 	ETHTOOL_A_HEADER_MAX = (__ETHTOOL_A_HEADER_CNT - 1)
 };
 
+/* bit sets */
+
+enum {
+	ETHTOOL_A_BIT_UNSPEC,
+	ETHTOOL_A_BIT_INDEX,			/* u32 */
+	ETHTOOL_A_BIT_NAME,			/* string */
+	ETHTOOL_A_BIT_VALUE,			/* flag */
+
+	/* add new constants above here */
+	__ETHTOOL_A_BIT_CNT,
+	ETHTOOL_A_BIT_MAX = (__ETHTOOL_A_BIT_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_BITS_UNSPEC,
+	ETHTOOL_A_BITS_BIT,
+
+	/* add new constants above here */
+	__ETHTOOL_A_BITS_CNT,
+	ETHTOOL_A_BITS_MAX = (__ETHTOOL_A_BITS_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_BITSET_UNSPEC,
+	ETHTOOL_A_BITSET_LIST,			/* flag */
+	ETHTOOL_A_BITSET_SIZE,			/* u32 */
+	ETHTOOL_A_BITSET_BITS,			/* nest - _A_BITS_* */
+	ETHTOOL_A_BITSET_VALUE,			/* binary */
+	ETHTOOL_A_BITSET_MASK,			/* binary */
+
+	/* add new constants above here */
+	__ETHTOOL_A_BITSET_CNT,
+	ETHTOOL_A_BITSET_MAX = (__ETHTOOL_A_BITSET_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index f30e0da88be5..482fdb9380fa 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -4,4 +4,4 @@ obj-y				+= ioctl.o
 
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
-ethtool_nl-y	:= netlink.o
+ethtool_nl-y	:= netlink.o bitset.o
diff --git a/net/ethtool/bitset.c b/net/ethtool/bitset.c
new file mode 100644
index 000000000000..80bb6fbb1268
--- /dev/null
+++ b/net/ethtool/bitset.c
@@ -0,0 +1,606 @@
+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
+
+#include <linux/ethtool_netlink.h>
+#include <linux/bitmap.h>
+#include "netlink.h"
+#include "bitset.h"
+
+static bool ethnl_test_bit(const void *val, unsigned int index, bool is_u32)
+{
+	if (!val)
+		return true;
+	else if (is_u32)
+		return ((const u32 *)val)[index / 32] & (1U << (index % 32));
+	else
+		return test_bit(index, val);
+}
+
+static void __bitmap_to_u32(u32 *dst, const void *src, unsigned int size,
+			    bool is_u32)
+{
+	unsigned int full_words = size / 32;
+	const u32 *src32 = src;
+
+	if (!is_u32) {
+		bitmap_to_arr32(dst, src, size);
+		return;
+	}
+
+	memcpy(dst, src32, full_words * sizeof(u32));
+	if (size % 32 != 0)
+		dst[full_words] = src32[full_words] & ((1U << (size % 32)) - 1);
+}
+
+/* convert standard kernel bitmap (long sized words) to ethtool one (u32 words)
+ * bitmap_to_arr32() is not guaranteed to do "in place" conversion correctly;
+ * moreover, we can use the fact that the conversion is no-op except for 64-bit
+ * big endian architectures
+ */
+#if BITS_PER_LONG == 64 && defined(__BIG_ENDIAN)
+void ethnl_bitmap_to_u32(unsigned long *bitmap, unsigned int nwords)
+{
+	u32 *dst = (u32 *)bitmap;
+	unsigned int i;
+
+	for (i = 0; i < nwords; i++) {
+		unsigned long tmp = READ_ONCE(bitmap[i]);
+
+		dst[2 * i] = tmp & 0xffffffff;
+		dst[2 * i + 1] = tmp >> 32;
+	}
+}
+#endif
+
+static const char *bit_name(const void *const names, bool legacy,
+			    unsigned int idx)
+{
+	const char (*const legacy_names)[ETH_GSTRING_LEN] =
+	       (const char (*const)[ETH_GSTRING_LEN])names;
+	const char *const *simple_names = names;
+
+	return legacy ? legacy_names[idx] : simple_names[idx];
+}
+
+/* calculate size for a bitset attribute
+ * see ethnl_put_bitset() for arguments
+ */
+static int __ethnl_bitset_size(unsigned int size, const void *val,
+			       const void *mask, const void *names,
+			       unsigned int flags)
+{
+	const bool legacy = flags & ETHNL_BITSET_LEGACY_NAMES;
+	const bool compact = flags & ETHNL_BITSET_COMPACT;
+	const bool is_list = flags & ETHNL_BITSET_LIST;
+	const bool is_u32 = flags & ETHNL_BITSET_U32;
+	unsigned int nwords = DIV_ROUND_UP(size, 32);
+	unsigned int len = 0;
+
+	if (WARN_ON(!compact && !names))
+		return -EINVAL;
+	/* list flag */
+	if (flags & ETHNL_BITSET_LIST)
+		len += nla_total_size(sizeof(u32));
+	/* size */
+	len += nla_total_size(sizeof(u32));
+
+	if (compact) {
+		/* values, mask */
+		len += 2 * nla_total_size(nwords * sizeof(u32));
+	} else {
+		unsigned int bits_len = 0;
+		unsigned int bit_len, i;
+
+		for (i = 0; i < size; i++) {
+			const char *name = bit_name(names, legacy, i) ?: "";
+
+			if ((is_list || mask) &&
+			    !ethnl_test_bit(is_list ? val : mask, i, is_u32))
+				continue;
+			/* index */
+			bit_len = nla_total_size(sizeof(u32));
+			/* name */
+			bit_len += ethnl_str_size(name);
+			/* value */
+			if (!is_list && ethnl_test_bit(val, i, is_u32))
+				bit_len += nla_total_size(0);
+
+			/* bit nest */
+			bits_len += nla_total_size(bit_len);
+		}
+		/* bits nest */
+		len += nla_total_size(bits_len);
+	}
+
+	/* outermost nest */
+	return nla_total_size(len);
+}
+
+int ethnl_bitset_size(unsigned int size, const unsigned long *val,
+		      const unsigned long *mask, const void *names,
+		      unsigned int flags)
+{
+	return __ethnl_bitset_size(size, val, mask, names,
+				   flags & ~ETHNL_BITSET_U32);
+}
+
+int ethnl_bitset32_size(unsigned int size, const u32 *val, const u32 *mask,
+			const void *names, unsigned int flags)
+{
+	return __ethnl_bitset_size(size, val, mask, names,
+				   flags | ETHNL_BITSET_U32);
+}
+
+/**
+ * __ethnl_put_bitset() - Put a bitset nest into a message
+ * @skb:      skb with the message
+ * @attrtype: attribute type for the bitset nest
+ * @size:     size of the set in bits
+ * @val:      bitset values
+ * @mask:     mask of valid bits; NULL is interpreted as "all bits"
+ * @names:    bit names (only used for verbose format)
+ * @flags:    combination of ETHNL_BITSET_* flags
+ *
+ * This is the actual implementation of putting a bitset nested attribute into
+ * a netlink message but callers are supposed to use either ethnl_put_bitset()
+ * for unsigned long based bitmaps or ethnl_put_bitset32() for u32 based ones.
+ * Cleans the nest up on error.
+ *
+ * Return:    0 on success, negative error value on error
+ */
+static int __ethnl_put_bitset(struct sk_buff *skb, int attrtype,
+			      unsigned int size, const void *val,
+			      const void *mask, const void *names,
+			      unsigned int flags)
+{
+	const bool legacy = flags & ETHNL_BITSET_LEGACY_NAMES;
+	const bool compact = flags & ETHNL_BITSET_COMPACT;
+	const bool is_list = flags & ETHNL_BITSET_LIST;
+	const bool is_u32 = flags & ETHNL_BITSET_U32;
+	struct nlattr *nest;
+	struct nlattr *attr;
+
+	if (WARN_ON(!compact && !names))
+		return -EINVAL;
+	nest = nla_nest_start(skb, attrtype);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (is_list && nla_put_flag(skb, ETHTOOL_A_BITSET_LIST))
+		goto nla_put_failure;
+	if (nla_put_u32(skb, ETHTOOL_A_BITSET_SIZE, size))
+		goto nla_put_failure;
+	if (compact) {
+		unsigned int bytesize = DIV_ROUND_UP(size, 32) * sizeof(u32);
+
+		attr = nla_reserve(skb, ETHTOOL_A_BITSET_VALUE, bytesize);
+		if (!attr)
+			goto nla_put_failure;
+		__bitmap_to_u32(nla_data(attr), val, size, is_u32);
+		if (mask) {
+			attr = nla_reserve(skb, ETHTOOL_A_BITSET_MASK,
+					   bytesize);
+			if (!attr)
+				goto nla_put_failure;
+			__bitmap_to_u32(nla_data(attr), mask, size, is_u32);
+		}
+	} else {
+		struct nlattr *bits;
+		unsigned int i;
+
+		bits = nla_nest_start(skb, ETHTOOL_A_BITSET_BITS);
+		if (!bits)
+			goto nla_put_failure;
+		for (i = 0; i < size; i++) {
+			const char *name = bit_name(names, legacy, i) ?: "";
+
+			if ((is_list || mask) &&
+			    !ethnl_test_bit(is_list ? val : mask, i, is_u32))
+				continue;
+			attr = nla_nest_start(skb, ETHTOOL_A_BITS_BIT);
+			if (!attr ||
+			    nla_put_u32(skb, ETHTOOL_A_BIT_INDEX, i) ||
+			    nla_put_string(skb, ETHTOOL_A_BIT_NAME, name))
+				goto nla_put_failure;
+			if (!is_list && ethnl_test_bit(val, i, is_u32) &&
+			    nla_put_flag(skb, ETHTOOL_A_BIT_VALUE))
+				goto nla_put_failure;
+			nla_nest_end(skb, attr);
+		}
+		nla_nest_end(skb, bits);
+	}
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+int ethnl_put_bitset(struct sk_buff *skb, int attrtype, unsigned int size,
+		     const unsigned long *val, const unsigned long *mask,
+		     const void *names, unsigned int flags)
+{
+	return __ethnl_put_bitset(skb, attrtype, size, val, mask, names,
+				  flags & ~ETHNL_BITSET_U32);
+}
+
+int ethnl_put_bitset32(struct sk_buff *skb, int attrtype, unsigned int size,
+		       const u32 *val, const u32 *mask, const void *names,
+		       unsigned int flags)
+{
+	return __ethnl_put_bitset(skb, attrtype, size, val, mask, names,
+				  flags | ETHNL_BITSET_U32);
+}
+
+static const struct nla_policy bitset_policy[ETHTOOL_A_BITSET_MAX + 1] = {
+	[ETHTOOL_A_BITSET_UNSPEC]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_BITSET_LIST]		= { .type = NLA_FLAG },
+	[ETHTOOL_A_BITSET_SIZE]		= { .type = NLA_U32 },
+	[ETHTOOL_A_BITSET_BITS]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_BITSET_VALUE]	= { .type = NLA_BINARY },
+	[ETHTOOL_A_BITSET_MASK]		= { .type = NLA_BINARY },
+};
+
+static const struct nla_policy bit_policy[ETHTOOL_A_BIT_MAX + 1] = {
+	[ETHTOOL_A_BIT_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_BIT_INDEX]		= { .type = NLA_U32 },
+	[ETHTOOL_A_BIT_NAME]		= { .type = NLA_NUL_STRING },
+	[ETHTOOL_A_BIT_VALUE]		= { .type = NLA_FLAG },
+};
+
+static int ethnl_name_to_idx(const void *names, bool legacy,
+			     unsigned int n_names, const char *name,
+			     unsigned int name_len)
+{
+	unsigned int i;
+
+	for (i = 0; i < n_names; i++) {
+		const char *bname = bit_name(names, legacy, i);
+
+		if (bname && !strncmp(bname, name, name_len) &&
+		    strlen(bname) <= name_len)
+			return i;
+	}
+
+	return n_names;
+}
+
+static int ethnl_update_bit(unsigned long *bitmap, unsigned long *bitmask,
+			    unsigned int nbits, const struct nlattr *bit_attr,
+			    bool is_list, const void *names, bool legacy,
+			    struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_BIT_MAX + 1];
+	int ret, idx;
+
+	if (nla_type(bit_attr) != ETHTOOL_A_BITS_BIT) {
+		NL_SET_ERR_MSG_ATTR(info->extack, bit_attr,
+				    "ETHTOOL_A_BITSET_BITS can contain only ETHTOOL_A_BITS_BIT");
+		return -EINVAL;
+	}
+	ret = nla_parse_nested(tb, ETHTOOL_A_BIT_MAX, bit_attr, bit_policy,
+			       info->extack);
+	if (ret < 0)
+		return ret;
+
+	if (tb[ETHTOOL_A_BIT_INDEX]) {
+		const char *name;
+
+		idx = nla_get_u32(tb[ETHTOOL_A_BIT_INDEX]);
+		if (idx >= nbits) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[ETHTOOL_A_BIT_INDEX],
+					    "bit index too high");
+			return -EOPNOTSUPP;
+		}
+		name = bit_name(names, legacy, idx);
+		if (tb[ETHTOOL_A_BIT_NAME] && name &&
+		    strncmp(nla_data(tb[ETHTOOL_A_BIT_NAME]), name,
+			    nla_len(tb[ETHTOOL_A_BIT_NAME]))) {
+			NL_SET_ERR_MSG_ATTR(info->extack, bit_attr,
+					    "bit index and name mismatch");
+			return -EINVAL;
+		}
+	} else if (tb[ETHTOOL_A_BIT_NAME]) {
+		idx = ethnl_name_to_idx(names, legacy, nbits,
+					nla_data(tb[ETHTOOL_A_BIT_NAME]),
+					nla_len(tb[ETHTOOL_A_BIT_NAME]));
+		if (idx >= nbits) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[ETHTOOL_A_BIT_NAME],
+					    "bit name not found");
+			return -EOPNOTSUPP;
+		}
+	} else {
+		NL_SET_ERR_MSG_ATTR(info->extack, bit_attr,
+				    "neither bit index nor name specified");
+		return -EINVAL;
+	}
+
+	if (is_list || tb[ETHTOOL_A_BIT_VALUE])
+		set_bit(idx, bitmap);
+	else
+		clear_bit(idx, bitmap);
+	if (!is_list || bitmask)
+		set_bit(idx, bitmask);
+	return 0;
+}
+
+int ethnl_bitset_is_compact(const struct nlattr *bitset, bool *compact)
+{
+	struct nlattr *tb[ETHTOOL_A_BITSET_MAX + 1];
+	int ret;
+
+	ret = nla_parse_nested(tb, ETHTOOL_A_BITSET_MAX, bitset,
+			       bitset_policy, NULL);
+	if (ret < 0)
+		return ret;
+
+	if (tb[ETHTOOL_A_BITSET_BITS]) {
+		if (tb[ETHTOOL_A_BITSET_VALUE] || tb[ETHTOOL_A_BITSET_MASK])
+			return -EINVAL;
+		*compact = false;
+		return 0;
+	}
+	if (!tb[ETHTOOL_A_BITSET_SIZE] || !tb[ETHTOOL_A_BITSET_VALUE])
+		return -EINVAL;
+
+	*compact = true;
+	return 0;
+}
+
+/* 64-bit long endian is the only case when u32 based bitmap and unsigned long
+ * based bitmap layouts differ
+ */
+#if BITS_PER_LONG == 64 && defined(__BIG_ENDIAN)
+/* dst &= src */
+static void __bitmap_and_u32(unsigned long *dst, const u32 *src,
+			     unsigned int nbits)
+{
+	unsigned long op;
+
+	while (nbits >= BITS_PER_LONG) {
+		op = src[0] | ((unsigned long)src[1] << 32);
+		*dst &= op;
+
+		dst++;
+		src += 2;
+		nbits -= BITS_PER_LONG;
+	}
+
+	if (!nbits)
+		return;
+	op = src[0];
+	if (nbits > 32)
+		op |= ((unsigned long)src[1] << 32);
+	*dst = (op & BITMAP_LAST_WORD_MASK(nbits));
+}
+
+/* map1 == map2 */
+static bool __bitmap_equal_u32(const unsigned long *map1, const u32 *map2,
+			       unsigned int nbits)
+{
+	unsigned long dword;
+
+	while (nbits >= BITS_PER_LONG) {
+		dword = map2[0] | ((unsigned long)map2[1] << 32);
+		if (*map1 != dword)
+			return false;
+
+		map1++;
+		map2 += 2;
+		nbits -= BITS_PER_LONG;
+	}
+
+	if (!nbits)
+		return true;
+	dword = map2[0];
+	if (nbits > 32)
+		dword |= ((unsigned long)map2[1] << 32);
+	return !((*map1 ^ dword) & BITMAP_LAST_WORD_MASK(nbits));
+}
+#else
+/* On 32-bit and 64-bit LE, unsigned long and u32 bitmap layout is the same
+ * but we must not write past dst buffer if the number of words is odd.
+ */
+static void __bitmap_and_u32(unsigned long *dst, const u32 *src,
+			     unsigned int nbits)
+{
+	u32 *dst32 = (u32 *)dst;
+
+	while (nbits >= 32) {
+		*dst32++ &= *src++;
+		nbits -= 32;
+	}
+	if (!nbits)
+		return;
+	*dst32 &= (*src & ((1U << nbits) - 1));
+}
+
+static bool __bitmap_equal_u32(const unsigned long *map1, const u32 *map2,
+			       unsigned int nbits)
+{
+	unsigned int full_words = nbits / 32;
+	u32 last_word_mask;
+	u32 *map1_32 = (u32 *)map1;
+
+	if (memcmp(map1, map2, full_words * BITS_PER_BYTE))
+		return false;
+	if (!(nbits % 32))
+		return true;
+	last_word_mask = (1U << (nbits % 32)) - 1;
+	return !((map1_32[full_words] ^ map2[full_words]) & last_word_mask);
+}
+#endif
+
+/* copy unsigned long bitmap to unsigned long or u32 */
+static void __bitmap_to_any(void *dst, const unsigned long *src,
+			    unsigned int nbits, bool dst_is_u32)
+{
+	if (dst_is_u32)
+		bitmap_to_arr32(dst, src, nbits);
+	else
+		bitmap_copy(dst, src, nbits);
+}
+
+static bool __bitmap_equal_any(const unsigned long *map1, const void *map2,
+			       unsigned int nbits, bool is_u32)
+{
+	if (!is_u32)
+		return bitmap_equal(map1, map2, nbits);
+	else
+		return __bitmap_equal_u32(map1, map2, nbits);
+}
+
+/**
+ * __ethnl_update_bitset() - Apply a bitset nest to a bitmap
+ * @bitmap:  bitmap to update
+ * @bitmask: if not, mask from the nest is copied here
+ * @nbits:   size of the updated bitmap in bits
+ * @attr:    nest attribute to parse and apply
+ * @err:     pointer to variable to put error value (or 0 on success) to
+ * @names:   array of bit names; may be null for compact format
+ * @legacy:  true if @names is ioctl style array of char[32], false if it is
+ *           a simple array of (char *) strings
+ * @info:    genetlink info (also used for extack error reporting)
+ * @is_u32:  false: bitmaps are unsigned long based, true: u32 based bitmaps
+ *
+ * This is the actual implementation of bitset nested attribute parser but
+ * callers are supposed to use ethnl_update_bitset() for unsigned long based
+ * bitmaps or ethnl_update_bitset32() for u32 based ones.
+ *
+ * Return:   true if the bitmap contents was modified, false if not
+ */
+static bool __ethnl_update_bitset(void *bitmap, void *bitmask,
+				  unsigned int nbits, const struct nlattr *attr,
+				  int *err, const void *names, bool legacy,
+				  struct genl_info *info, bool is_u32)
+{
+	struct nlattr *tb[ETHTOOL_A_BITSET_MAX + 1];
+	unsigned int change_bits = 0;
+	unsigned int max_bits = 0;
+	unsigned long *val, *mask;
+	bool mod = false;
+	bool is_list;
+
+	*err = 0;
+	if (!attr)
+		return mod;
+	*err = nla_parse_nested(tb, ETHTOOL_A_BITSET_MAX, attr, bitset_policy,
+				info->extack);
+	if (*err < 0)
+		return mod;
+	*err = -EINVAL;
+	if (tb[ETHTOOL_A_BITSET_BITS] &&
+	    (tb[ETHTOOL_A_BITSET_VALUE] || tb[ETHTOOL_A_BITSET_MASK]))
+		return mod;
+	if (!tb[ETHTOOL_A_BITSET_BITS] &&
+	    (!tb[ETHTOOL_A_BITSET_SIZE] || !tb[ETHTOOL_A_BITSET_VALUE]))
+		return mod;
+	is_list = (tb[ETHTOOL_A_BITSET_LIST] != NULL);
+	if (is_list && tb[ETHTOOL_A_BITSET_MASK])
+		return mod;
+
+	/* To let new userspace to work with old kernel, we allow bitmaps
+	 * from userspace to be longer than kernel ones and only issue an
+	 * error if userspace actually tries to change a bit not existing
+	 * in kernel.
+	 */
+	if (tb[ETHTOOL_A_BITSET_SIZE])
+		change_bits = nla_get_u32(tb[ETHTOOL_A_BITSET_SIZE]);
+	max_bits = max_t(unsigned int, nbits, change_bits);
+	mask = bitmap_zalloc(max_bits, GFP_KERNEL);
+	val = bitmap_zalloc(max_bits, GFP_KERNEL);
+
+	if (tb[ETHTOOL_A_BITSET_BITS]) {
+		struct nlattr *bit_attr;
+		int rem;
+
+		if (is_list)
+			bitmap_fill(mask, nbits);
+		else if (is_u32)
+			bitmap_from_arr32(val, bitmap, nbits);
+		else
+			bitmap_copy(val, bitmap, nbits);
+		nla_for_each_nested(bit_attr, tb[ETHTOOL_A_BITSET_BITS], rem) {
+			*err = ethnl_update_bit(val, mask, nbits, bit_attr,
+						is_list, names, legacy, info);
+			if (*err < 0)
+				goto out;
+		}
+		if (bitmask)
+			__bitmap_to_any(bitmask, mask, nbits, is_u32);
+	} else {
+		unsigned int change_words = DIV_ROUND_UP(change_bits, 32);
+
+		*err = 0;
+		if (change_bits == 0 && tb[ETHTOOL_A_BITSET_MASK])
+			goto out;
+		*err = -EINVAL;
+		if (nla_len(tb[ETHTOOL_A_BITSET_VALUE]) <
+		    change_words * sizeof(u32))
+			goto out;
+		if (tb[ETHTOOL_A_BITSET_MASK] &&
+		    nla_len(tb[ETHTOOL_A_BITSET_MASK]) <
+		    change_words * sizeof(u32))
+			goto out;
+
+		bitmap_from_arr32(val, nla_data(tb[ETHTOOL_A_BITSET_VALUE]),
+				  change_bits);
+		if (tb[ETHTOOL_A_BITSET_MASK])
+			bitmap_from_arr32(mask,
+					  nla_data(tb[ETHTOOL_A_BITSET_MASK]),
+					  change_bits);
+		else
+			bitmap_fill(mask, nbits);
+
+		if (nbits < change_bits) {
+			unsigned int idx = find_next_bit(mask, max_bits, nbits);
+
+			*err = -EINVAL;
+			if (idx < max_bits)
+				goto out;
+		}
+
+		if (bitmask)
+			__bitmap_to_any(bitmask, mask, nbits, is_u32);
+		if (!is_list) {
+			bitmap_and(val, val, mask, nbits);
+			bitmap_complement(mask, mask, nbits);
+			if (is_u32)
+				__bitmap_and_u32(mask, bitmap, nbits);
+			else
+				bitmap_and(mask, mask, bitmap, nbits);
+			bitmap_or(val, val, mask, nbits);
+		}
+	}
+
+	mod = !__bitmap_equal_any(val, bitmap, nbits, is_u32);
+	if (mod)
+		__bitmap_to_any(bitmap, val, nbits, is_u32);
+
+	*err = 0;
+out:
+	bitmap_free(val);
+	bitmap_free(mask);
+	return mod;
+}
+
+bool ethnl_update_bitset(unsigned long *bitmap, unsigned long *bitmask,
+			 unsigned int nbits, const struct nlattr *attr,
+			 int *err, const void *names, bool legacy,
+			 struct genl_info *info)
+{
+	return __ethnl_update_bitset(bitmap, bitmask, nbits, attr, err, names,
+				     legacy, info, false);
+}
+
+bool ethnl_update_bitset32(u32 *bitmap, u32 *bitmask, unsigned int nbits,
+			   const struct nlattr *attr, int *err,
+			   const void *names, bool legacy,
+			   struct genl_info *info)
+{
+	return __ethnl_update_bitset(bitmap, bitmask, nbits, attr, err, names,
+				     legacy, info, true);
+}
diff --git a/net/ethtool/bitset.h b/net/ethtool/bitset.h
new file mode 100644
index 000000000000..761d0c47fe23
--- /dev/null
+++ b/net/ethtool/bitset.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _NET_ETHTOOL_BITSET_H
+#define _NET_ETHTOOL_BITSET_H
+
+/* when set, value and mask bitmaps are arrays of u32, when not, arrays of
+ * unsigned long
+ */
+#define ETHNL_BITSET_U32		BIT(0)
+/* generate a compact format bitset */
+#define ETHNL_BITSET_COMPACT		BIT(1)
+/* generate a bit list */
+#define ETHNL_BITSET_LIST		BIT(2)
+/* when set, names are interpreted as legacy string set (an array of
+ * char[ETH_GSTRING_LEN]), when not, as a simple array of char *
+ */
+#define ETHNL_BITSET_LEGACY_NAMES	BIT(3)
+
+int ethnl_bitset_is_compact(const struct nlattr *bitset, bool *compact);
+int ethnl_bitset_size(unsigned int size, const unsigned long *val,
+		      const unsigned long *mask, const void *names,
+		      unsigned int flags);
+int ethnl_bitset32_size(unsigned int size, const u32 *val, const u32 *mask,
+			const void *names, unsigned int flags);
+int ethnl_put_bitset(struct sk_buff *skb, int attrtype, unsigned int size,
+		     const unsigned long *val, const unsigned long *mask,
+		     const void *names, unsigned int flags);
+int ethnl_put_bitset32(struct sk_buff *skb, int attrtype, unsigned int size,
+		       const u32 *val, const u32 *mask, const void *names,
+		       unsigned int flags);
+bool ethnl_update_bitset(unsigned long *bitmap, unsigned long *bitmask,
+			 unsigned int nbits, const struct nlattr *attr,
+			 int *err, const void *names, bool legacy,
+			 struct genl_info *info);
+bool ethnl_update_bitset32(u32 *bitmap, u32 *bitmask, unsigned int nbits,
+			   const struct nlattr *attr, int *err,
+			   const void *names, bool legacy,
+			   struct genl_info *info);
+
+#endif /* _NET_ETHTOOL_BITSET_H */
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 5510eb7054b3..7f1b9ec1ace7 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -20,6 +20,15 @@ struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
 				 u16 hdr_attrtype, struct genl_info *info,
 				 void **ehdrp);
 
+#if BITS_PER_LONG == 64 && defined(__BIG_ENDIAN)
+void ethnl_bitmap_to_u32(unsigned long *bitmap, unsigned int nwords);
+#else
+static inline void ethnl_bitmap_to_u32(unsigned long *bitmap,
+				       unsigned int nwords)
+{
+}
+#endif
+
 static inline int ethnl_str_size(const char *s)
 {
 	return nla_total_size(strlen(s) + 1);
-- 
2.22.0

