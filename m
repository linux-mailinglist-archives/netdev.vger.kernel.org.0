Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42F7D1A62
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 23:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732531AbfJIVAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 17:00:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:51462 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732196AbfJIU7Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 16:59:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 37944B239;
        Wed,  9 Oct 2019 20:59:19 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D39BFE3785; Wed,  9 Oct 2019 22:59:18 +0200 (CEST)
Message-Id: <af208e79258e7e3c3af3860e6a8908a50dec095f.1570654310.git.mkubecek@suse.cz>
In-Reply-To: <cover.1570654310.git.mkubecek@suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v7 06/17] ethtool: netlink bitset handling
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Wed,  9 Oct 2019 22:59:18 +0200 (CEST)
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

Userspace requests can use either format; ETHTOOL_GFLAG_COMPACT_BITSETS
flag in request header tells kernel which format to use in reply.
Notifications always use compact format.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst |  68 ++
 include/uapi/linux/ethtool_netlink.h         |  35 +
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/bitset.c                         | 714 +++++++++++++++++++
 net/ethtool/bitset.h                         |  28 +
 net/ethtool/netlink.h                        |   9 +
 6 files changed, 855 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/bitset.c
 create mode 100644 net/ethtool/bitset.h

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 3e9680b63afa..8dda6efee060 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -79,6 +79,74 @@ clients not aware of the flag should be interpreted the way the client
 expects. A client must not set flags it does not understand.
 
 
+Bit sets
+========
+
+For short bitmaps of (reasonably) fixed length, standard ``NLA_BITFIELD32``
+type is used. For arbitrary length bitmaps, ethtool netlink uses a nested
+attribute with contents of one of two forms: compact (two binary bitmaps
+representing bit values and mask of affected bits) and bit-by-bit (list of
+bits identified by either index or name).
+
+Compact form: nested (bitset) atrribute contents:
+
+  ============================  ======  ============================
+  ``ETHTOOL_A_BITSET_LIST``     flag    no mask, only a list
+  ``ETHTOOL_A_BITSET_SIZE``     u32     number of significant bits
+  ``ETHTOOL_A_BITSET_VALUE``    binary  bitmap of bit values
+  ``ETHTOOL_A_BITSET_MASK``     binary  bitmap of valid bits
+  ============================  ======  ============================
+
+Value and mask must have length at least ``ETHTOOL_A_BITSET_SIZE`` bits
+rounded up to a multiple of 32 bits. They consist of 32-bit words in host byte
+order, words ordered from least significant to most significant (i.e. the same
+way as bitmaps are passed with ioctl interface).
+
+For compact form, ``ETHTOOL_A_BITSET_SIZE`` and ``ETHTOOL_A_BITSET_VALUE`` are
+mandatory.  Similar to ``NLA_BITFIELD32``, a compact form bit set requests to
+set bits in the mask to 1 (if the bit is set in value) or 0 (if not) and
+preserve the rest. If ``ETHTOOL_A_BITSET_LIST`` is present, there is no mask
+and bitset represents a simple list of bits.
+
+Kernel bit set length may differ from userspace length if older application is
+used on newer kernel or vice versa. If userspace bitmap is longer, an error is
+issued only if the request actually tries to set values of some bits not
+recognized by kernel.
+
+Bit-by-bit form: nested (bitset) attribute contents:
+
+ +---------------------------------+--------+-----------------------------+
+ | ``ETHTOOL_A_BITSET_LIST``       | flag   | no mask, only a list        |
+ +---------------------------------+--------+-----------------------------+
+ | ``ETHTOOL_A_BITSET_SIZE``       | u32    | number of significant bits  |
+ +---------------------------------+--------+-----------------------------+
+ | ``ETHTOOL_A_BITSET_BIT``        | nested | array of bits               |
+ +-+-------------------------------+--------+-----------------------------+
+ |   ``ETHTOOL_A_BITSET_BIT+``     | nested | one bit                     |
+ +-+-+-----------------------------+--------+-----------------------------+
+ | | | ``ETHTOOL_A_BIT_INDEX``     | u32    | bit index (0 for LSB)       |
+ +-+-+-----------------------------+--------+-----------------------------+
+ | | | ``ETHTOOL_A_BIT_NAME``      | string | bit name                    |
+ +-+-+-----------------------------+--------+-----------------------------+
+ | | | ``ETHTOOL_A_BIT_VALUE``     | flag   | present if bit is set       |
+ +-+-+-----------------------------+--------+-----------------------------+
+
+Bit size is optional for bit-by-bit form. ``ETHTOOL_A_BITSET_BITS`` nest can
+only contain ``ETHTOOL_A_BITS_BIT`` attributes but there can be an arbitrary
+number of them.  A bit may be identified by its index or by its name. When
+used in requests, listed bits are set to 0 or 1 according to
+``ETHTOOL_A_BIT_VALUE``, the rest is preserved. A request fails if index
+exceeds kernel bit length or if name is not recognized.
+
+When ``ETHTOOL_A_BITSET_LIST`` flag is present, bitset is interpreted as a
+simple bit list. ``ETHTOOL_A_BIT_VALUE`` attributes are not used in such case.
+Bit list represents a bitmap with listed bits set and the rest zero.
+
+In requests, application can use either form. Form used by kernel in reply is
+determined by a flag in flags field of request header. Semantics of value and
+mask depends on the attribute.
+
+
 List of message types
 =====================
 
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index c58d9fd52ffc..418f28965a04 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -51,6 +51,41 @@ enum {
 	ETHTOOL_A_HEADER_MAX = __ETHTOOL_A_HEADER_CNT - 1
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
+	ETHTOOL_A_BIT_MAX = __ETHTOOL_A_BIT_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_BITS_UNSPEC,
+	ETHTOOL_A_BITS_BIT,
+
+	/* add new constants above here */
+	__ETHTOOL_A_BITS_CNT,
+	ETHTOOL_A_BITS_MAX = __ETHTOOL_A_BITS_CNT - 1
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
+	ETHTOOL_A_BITSET_MAX = __ETHTOOL_A_BITSET_CNT - 1
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
index 000000000000..aff6413d6bcc
--- /dev/null
+++ b/net/ethtool/bitset.c
@@ -0,0 +1,714 @@
+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
+
+#include <linux/ethtool_netlink.h>
+#include <linux/bitmap.h>
+#include "netlink.h"
+#include "bitset.h"
+
+/* To reduce the number of slab allocations, the wrappers use fixed size local
+ * variables for bitmaps up to __SMALL_BITMAP_BITS bits which is the majority
+ * of bitmaps used by ethtool.
+ */
+#define __SMALL_BITMAP_BITS 128
+#define __SMALL_BITMAP_WORDS DIV_ROUND_UP(__SMALL_BITMAP_BITS, 32)
+
+static u32 __lower_bits(unsigned int n)
+{
+	return ~(u32)0 >> (32 - n % 32);
+}
+
+static u32 __upper_bits(unsigned int n)
+{
+	return ~(u32)0 << (n % 32);
+}
+
+/**
+ * __bitmap32_clear() - Clear u32 based bitmap
+ * @dst:   bitmap to clear
+ * @start: beginning of the interval
+ * @end:   end of the interval
+ * @mod:   set if bitmap was modified
+ *
+ * Clear @nbits bits of a bitmap with indices @start <= i < @end
+ */
+static void __bitmap32_clear(u32 *dst, unsigned int start, unsigned int end,
+			     bool *mod)
+{
+	unsigned int start_word = start / 32;
+	unsigned int end_word = end / 32;
+	unsigned int i;
+	u32 mask;
+
+	if (end <= start)
+		return;
+
+	if (start % 32) {
+		mask = __upper_bits(start);
+		if (end_word == start_word) {
+			mask &= __lower_bits(end);
+			if (dst[start_word] & mask) {
+				dst[start_word] &= ~mask;
+				*mod = true;
+			}
+			return;
+		}
+		if (dst[start_word] & mask) {
+			dst[start_word] &= ~mask;
+			*mod = true;
+		}
+		start_word++;
+	}
+
+	for (i = start_word; i < end_word; i++) {
+		if (dst[i]) {
+			dst[i] = 0;
+			*mod = true;
+		}
+	}
+	if (end % 32) {
+		mask = __lower_bits(end);
+		if (dst[end_word] & mask) {
+			dst[end_word] &= ~mask;
+			*mod = true;
+		}
+	}
+}
+
+/**
+ * __bitmap32_no_zero() - Check if any bit is set in an interval
+ * @map:   bitmap to test
+ * @start: beginning of the interval
+ * @end:   end of the interval
+ *
+ * Return: true if there is non-zero bit with  index @start <= i < @end,
+ *         false if the whole interval is zero
+ */
+static bool __bitmap32_not_zero(const u32 *map, unsigned int start,
+				unsigned int end)
+{
+	unsigned int start_word = start / 32;
+	unsigned int end_word = end / 32;
+	u32 mask;
+
+	if (end <= start)
+		return true;
+
+	if (start % 32) {
+		mask = __upper_bits(start);
+		if (end_word == start_word) {
+			mask &= __lower_bits(end);
+			return map[start_word] & mask;
+		}
+		if (map[start_word] & mask)
+			return true;
+		start_word++;
+	}
+
+	if (!memchr_inv(map + start_word, '\0',
+			(end_word - start_word) * sizeof(u32)))
+		return true;
+	if (end % 32 == 0)
+		return true;
+	return map[end_word] & __lower_bits(end);
+}
+
+/**
+ * __bitmap32_update() - Modify u32 based bitmap according to value/mask pair
+ * @dst:   bitmap to update
+ * @nbits: bit size of the bitmap
+ * @value: values to set
+ * @mask:  mask of bits to set
+ * @mod:   set to true if bitmap is modified, preserve if not
+ *
+ * Set bits in @dst bitmap which are set in @mask to values from @value, leave
+ * the rest untouched. If destination bitmap was modified, set @mod to true,
+ * leave as it is if not.
+ */
+static void __bitmap32_update(u32 *dst, unsigned int nbits, const u32 *value,
+			      const u32 *mask, bool *mod)
+{
+	while (nbits > 0) {
+		u32 real_mask = mask ? *mask : ~(u32)0;
+		u32 new_value;
+
+		if (nbits < 32)
+			real_mask &= __lower_bits(nbits);
+		new_value = (*dst & ~real_mask) | (*value & real_mask);
+		if (new_value != *dst) {
+			*dst = new_value;
+			*mod = true;
+		}
+
+		if (nbits <= 32)
+			break;
+		dst++;
+		nbits -= 32;
+		value++;
+		if (mask)
+			mask++;
+	}
+}
+
+static bool __bitmap32_test_bit(const u32 *map, unsigned int index)
+{
+	return map[index / 32] & (1U << (index % 32));
+}
+
+/**
+ * ethnl_bitset32_size() - Calculate size of bitset nested attribute
+ * @val:     value bitmap (u32 based)
+ * @mask:    mask bitmap (u32 based, optional)
+ * @nbits:   bit length of the bitset
+ * @names:   array of bit names (optional)
+ * @compact: assume compact format for output
+ *
+ * Estimate length of netlink attribute composed by a later call to
+ * ethnl_put_bitset32() call with the same arguments.
+ *
+ * Return: negative error code or attribute length estimate
+ */
+int ethnl_bitset32_size(const u32 *val, const u32 *mask, unsigned int nbits,
+			ethnl_string_array_t names, bool compact)
+{
+	unsigned int len = 0;
+
+	/* list flag */
+	if (!mask)
+		len += nla_total_size(sizeof(u32));
+	/* size */
+	len += nla_total_size(sizeof(u32));
+
+	if (compact) {
+		unsigned int nwords = DIV_ROUND_UP(nbits, 32);
+
+		/* value, mask */
+		len += (mask ? 2 : 1) * nla_total_size(nwords * sizeof(u32));
+	} else {
+		unsigned int bits_len = 0;
+		unsigned int bit_len, i;
+
+		for (i = 0; i < nbits; i++) {
+			const char *name = names ? names[i] : NULL;
+
+			if (!__bitmap32_test_bit(mask ?: val, i))
+				continue;
+			/* index */
+			bit_len = nla_total_size(sizeof(u32));
+			/* name */
+			if (name)
+				bit_len += ethnl_strz_size(name);
+			/* value */
+			if (mask && __bitmap32_test_bit(val, i))
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
+/**
+ * ethnl_put_bitset32() - Put a bitset nest into a message
+ * @skb:      skb with the message
+ * @attrtype: attribute type for the bitset nest
+ * @val:      value bitmap (u32 based)
+ * @mask:     mask bitmap (u32 based, optional)
+ * @nbits:    bit length of the bitset
+ * @names:    array of bit names (optional)
+ * @compact:  use compact format for the output
+ *
+ * Compose a nested attribute representing a bitset. If @mask is null, simple
+ * bitmap (bit list) is created, if @mask is provided, represent a value/mask
+ * pair. Bit names are only used in verbose mode and when provided by calller.
+ *
+ * Return:    0 on success, negative error value on error
+ */
+int ethnl_put_bitset32(struct sk_buff *skb, int attrtype, const u32 *val,
+		       const u32 *mask, unsigned int nbits,
+		       ethnl_string_array_t names, bool compact)
+{
+	struct nlattr *nest;
+	struct nlattr *attr;
+
+	nest = nla_nest_start(skb, attrtype);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (!mask && nla_put_flag(skb, ETHTOOL_A_BITSET_LIST))
+		goto nla_put_failure;
+	if (nla_put_u32(skb, ETHTOOL_A_BITSET_SIZE, nbits))
+		goto nla_put_failure;
+	if (compact) {
+		unsigned int nwords = DIV_ROUND_UP(nbits, 32);
+		unsigned int nbytes = nwords * sizeof(u32);
+		u32 *dst;
+
+		attr = nla_reserve(skb, ETHTOOL_A_BITSET_VALUE, nbytes);
+		if (!attr)
+			goto nla_put_failure;
+		dst = nla_data(attr);
+		memcpy(dst, val, nbytes);
+		if (nbits % 32)
+			dst[nwords - 1] &= __lower_bits(nbits);
+
+		if (mask) {
+			attr = nla_reserve(skb, ETHTOOL_A_BITSET_MASK, nbytes);
+			if (!attr)
+				goto nla_put_failure;
+			dst = nla_data(attr);
+			memcpy(dst, mask, nbytes);
+			if (nbits % 32)
+				dst[nwords - 1] &= __lower_bits(nbits);
+		}
+	} else {
+		struct nlattr *bits;
+		unsigned int i;
+
+		bits = nla_nest_start(skb, ETHTOOL_A_BITSET_BITS);
+		if (!bits)
+			goto nla_put_failure;
+		for (i = 0; i < nbits; i++) {
+			const char *name = names ? names[i] : NULL;
+
+			if (!__bitmap32_test_bit(mask ?: val, i))
+				continue;
+			attr = nla_nest_start(skb, ETHTOOL_A_BITS_BIT);
+			if (!attr ||
+			    nla_put_u32(skb, ETHTOOL_A_BIT_INDEX, i))
+				goto nla_put_failure;
+			if (name &&
+			    ethnl_put_strz(skb, ETHTOOL_A_BIT_NAME, name))
+				goto nla_put_failure;
+			if (mask && __bitmap32_test_bit(val, i) &&
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
+/**
+ * ethnl_bitset_is_compact() - check if bitset attribute represents a compact
+ *			       bitset
+ * @bitset  - nested attribute representing a bitset
+ * @compact - pointer for return value
+ *
+ * Return: 0 on success, negative error code on failure
+ */
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
+static int ethnl_name_to_idx(ethnl_string_array_t names, unsigned int n_names,
+			     const char *name, unsigned int name_len)
+{
+	unsigned int i;
+
+	if (!names)
+		return n_names;
+
+	for (i = 0; i < n_names; i++) {
+		const char *bname = names[i];
+
+		if (!strncmp(bname, name, name_len) &&
+		    strlen(bname) <= name_len)
+			return i;
+	}
+
+	return n_names;
+}
+
+static int ethnl_parse_bit(unsigned int *index, bool *val, unsigned int nbits,
+			   const struct nlattr *bit_attr, bool is_list,
+			   ethnl_string_array_t names,
+			   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[ETHTOOL_A_BIT_MAX + 1];
+	int ret, idx;
+
+	if (nla_type(bit_attr) != ETHTOOL_A_BITS_BIT) {
+		NL_SET_ERR_MSG_ATTR(extack, bit_attr,
+				    "only ETHTOOL_A_BITS_BIT allowed in ETHTOOL_A_BITSET_BITS");
+		return -EINVAL;
+	}
+	ret = nla_parse_nested(tb, ETHTOOL_A_BIT_MAX, bit_attr, bit_policy,
+			       extack);
+	if (ret < 0)
+		return ret;
+
+	if (tb[ETHTOOL_A_BIT_INDEX]) {
+		const char *name;
+
+		idx = nla_get_u32(tb[ETHTOOL_A_BIT_INDEX]);
+		if (idx >= nbits) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[ETHTOOL_A_BIT_INDEX],
+					    "bit index too high");
+			return -EOPNOTSUPP;
+		}
+		name = names ? names[idx] : NULL;
+		if (tb[ETHTOOL_A_BIT_NAME] && name &&
+		    strncmp(nla_data(tb[ETHTOOL_A_BIT_NAME]), name,
+			    nla_len(tb[ETHTOOL_A_BIT_NAME]))) {
+			NL_SET_ERR_MSG_ATTR(extack, bit_attr,
+					    "bit index and name mismatch");
+			return -EINVAL;
+		}
+	} else if (tb[ETHTOOL_A_BIT_NAME]) {
+		idx = ethnl_name_to_idx(names, nbits,
+					nla_data(tb[ETHTOOL_A_BIT_NAME]),
+					nla_len(tb[ETHTOOL_A_BIT_NAME]));
+		if (idx >= nbits) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[ETHTOOL_A_BIT_NAME],
+					    "bit name not found");
+			return -EOPNOTSUPP;
+		}
+	} else {
+		NL_SET_ERR_MSG_ATTR(extack, bit_attr,
+				    "neither bit index nor name specified");
+		return -EINVAL;
+	}
+
+	*index = idx;
+	*val = is_list || tb[ETHTOOL_A_BIT_VALUE];
+	return 0;
+}
+
+static int
+ethnl_update_bitset32_verbose(u32 *bitmap, unsigned int nbits,
+			      const struct nlattr *attr, struct nlattr **tb,
+			      ethnl_string_array_t names,
+			      struct netlink_ext_ack *extack, bool *mod)
+{
+	struct nlattr *bit_attr;
+	bool is_list;
+	int rem;
+	int ret;
+
+	if (tb[ETHTOOL_A_BITSET_VALUE]) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_BITSET_VALUE],
+				    "value only allowed in compact bitset");
+		return -EINVAL;
+	}
+	if (tb[ETHTOOL_A_BITSET_MASK]) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_BITSET_MASK],
+				    "mask only allowed in compact bitset");
+		return -EINVAL;
+	}
+	is_list = (tb[ETHTOOL_A_BITSET_LIST] != NULL);
+
+	nla_for_each_nested(bit_attr, tb[ETHTOOL_A_BITSET_BITS], rem) {
+		bool old_val, new_val;
+		unsigned int idx;
+
+		ret = ethnl_parse_bit(&idx, &new_val, nbits, bit_attr, is_list,
+				      names, extack);
+		if (ret < 0)
+			return ret;
+		old_val = bitmap[idx / 32] & ((u32)1 << (idx % 32));
+		if (new_val != old_val) {
+			if (new_val)
+				bitmap[idx / 32] |= ((u32)1 << (idx % 32));
+			else
+				bitmap[idx / 32] &= ~((u32)1 << (idx % 32));
+			*mod = true;
+		}
+	}
+
+	return 0;
+}
+
+static int ethnl_compact_sanity_checks(unsigned int nbits,
+				       const struct nlattr *nest,
+				       struct nlattr **tb,
+				       struct netlink_ext_ack *extack)
+{
+	bool is_list = (tb[ETHTOOL_A_BITSET_LIST] != NULL);
+	unsigned int attr_nbits, attr_nwords;
+	const struct nlattr *test_attr;
+
+	if (is_list && tb[ETHTOOL_A_BITSET_MASK]) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_BITSET_MASK],
+				    "mask not allowed in list bitset");
+		return -EINVAL;
+	}
+	if (!tb[ETHTOOL_A_BITSET_SIZE]) {
+		NL_SET_ERR_MSG_ATTR(extack, nest,
+				    "missing size in compact bitset");
+		return -EINVAL;
+	}
+	if (!tb[ETHTOOL_A_BITSET_VALUE]) {
+		NL_SET_ERR_MSG_ATTR(extack, nest,
+				    "missing value in compact bitset");
+		return -EINVAL;
+	}
+	if (!is_list && !tb[ETHTOOL_A_BITSET_MASK]) {
+		NL_SET_ERR_MSG_ATTR(extack, nest,
+				    "missing mask in compact nonlist bitset");
+		return -EINVAL;
+	}
+
+	attr_nbits = nla_get_u32(tb[ETHTOOL_A_BITSET_SIZE]);
+	attr_nwords = DIV_ROUND_UP(attr_nbits, 32);
+	if (nla_len(tb[ETHTOOL_A_BITSET_VALUE]) != attr_nwords * sizeof(u32)) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_BITSET_VALUE],
+				    "bitset value length does not match size");
+		return -EINVAL;
+	}
+	if (tb[ETHTOOL_A_BITSET_MASK] &&
+	    nla_len(tb[ETHTOOL_A_BITSET_MASK]) != attr_nwords * sizeof(u32)) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_BITSET_MASK],
+				    "bitset mask length does not match size");
+		return -EINVAL;
+	}
+	if (attr_nbits <= nbits)
+		return 0;
+
+	test_attr = is_list ? tb[ETHTOOL_A_BITSET_VALUE] :
+			      tb[ETHTOOL_A_BITSET_MASK];
+	if (__bitmap32_not_zero(nla_data(test_attr), nbits, attr_nbits)) {
+		NL_SET_ERR_MSG_ATTR(extack, test_attr,
+				    "cannot modify bits past kernel bitset size");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ * ethnl_update_bitset32() - Apply a bitset nest to a u32 based bitmap
+ * @bitmap:  bitmap to update
+ * @nbits:   size of the updated bitmap in bits
+ * @attr:    nest attribute to parse and apply
+ * @names:   array of bit names; may be null for compact format
+ * @extack:  extack for error reporting
+ * @mod:     set this to true if bitmap is modified, leave as it is if not
+ *
+ * Apply bitset netsted attribute to a bitmap. If the attribute represents
+ * a bit list, @bitmap is set to its contents; otherwise, bits in mask are
+ * set to values from value. Bitmaps in the attribute may be longer than
+ * @nbits but the message must not request modifying any bits past @nbits.
+ *
+ * Return:   negative error code on failure, 0 on success
+ */
+int ethnl_update_bitset32(u32 *bitmap, unsigned int nbits,
+			  const struct nlattr *attr, ethnl_string_array_t names,
+			  struct netlink_ext_ack *extack, bool *mod)
+{
+	struct nlattr *tb[ETHTOOL_A_BITSET_MAX + 1];
+	unsigned int change_bits;
+	bool is_list;
+	int ret;
+
+	if (!attr)
+		return 0;
+	ret = nla_parse_nested(tb, ETHTOOL_A_BITSET_MAX, attr, bitset_policy,
+			       extack);
+	if (ret < 0)
+		return ret;
+
+	if (tb[ETHTOOL_A_BITSET_BITS])
+		return ethnl_update_bitset32_verbose(bitmap, nbits, attr, tb,
+						     names, extack, mod);
+	ret = ethnl_compact_sanity_checks(nbits, attr, tb, extack);
+	if (ret < 0)
+		return ret;
+
+	is_list = (tb[ETHTOOL_A_BITSET_LIST] != NULL);
+	change_bits = min_t(unsigned int,
+			    nla_get_u32(tb[ETHTOOL_A_BITSET_SIZE]), nbits);
+	__bitmap32_update(bitmap, change_bits,
+			  nla_data(tb[ETHTOOL_A_BITSET_VALUE]),
+			  is_list ? NULL : nla_data(tb[ETHTOOL_A_BITSET_MASK]),
+			  mod);
+	if (is_list && change_bits < nbits)
+		__bitmap32_clear(bitmap, change_bits, nbits, mod);
+
+	return 0;
+}
+
+/* 64-bit long endian architecture is the only case when u32 based bitmaps
+ * and unsigned long based bitmaps have different memory layout so that we
+ * cannot simply cast the latter to the former.
+ */
+#if BITS_PER_LONG == 64 && defined(__BIG_ENDIAN)
+
+int ethnl_bitset_size(const unsigned long *val, const unsigned long *mask,
+		      unsigned int nbits, ethnl_string_array_t names,
+		      bool compact)
+{
+	u32 small_mask32[__SMALL_BITMAP_WORDS];
+	u32 small_val32[__SMALL_BITMAP_WORDS];
+	u32 *mask32;
+	u32 *val32;
+	int ret;
+
+	if (nbits > __SMALL_BITMAP_BITS) {
+		unsigned int nwords = DIV_ROUND_UP(nbits, 32);
+
+		val32 = kmalloc_array(2 * nwords, sizeof(u32), GFP_KERNEL);
+		if (!val32)
+			return -ENOMEM;
+		mask32 = val32 + nwords;
+	} else {
+		val32 = small_val32;
+		mask32 = small_mask32;
+	}
+
+	bitmap_to_arr32(val32, val, nbits);
+	if (mask)
+		bitmap_to_arr32(mask32, mask, nbits);
+	else
+		mask32 = NULL;
+	ret = ethnl_bitset32_size(val32, mask32, nbits, names, compact);
+
+	if (nbits > __SMALL_BITMAP_BITS)
+		kfree(val32);
+
+	return ret;
+}
+
+int ethnl_put_bitset(struct sk_buff *skb, int attrtype,
+		     const unsigned long *val, const unsigned long *mask,
+		     unsigned int nbits, ethnl_string_array_t names,
+		     bool compact)
+{
+	u32 small_mask32[__SMALL_BITMAP_WORDS];
+	u32 small_val32[__SMALL_BITMAP_WORDS];
+	u32 *mask32;
+	u32 *val32;
+	int ret;
+
+	if (nbits > __SMALL_BITMAP_BITS) {
+		unsigned int nwords = DIV_ROUND_UP(nbits, 32);
+
+		val32 = kmalloc_array(2 * nwords, sizeof(u32), GFP_KERNEL);
+		if (!val32)
+			return -ENOMEM;
+		mask32 = val32 + nwords;
+	} else {
+		val32 = small_val32;
+		mask32 = small_mask32;
+	}
+
+	bitmap_to_arr32(val32, val, nbits);
+	if (mask)
+		bitmap_to_arr32(mask32, mask, nbits);
+	else
+		mask32 = NULL;
+	ret = ethnl_put_bitset32(skb, attrtype, val32, mask32, nbits, names,
+				 compact);
+
+	if (nbits > __SMALL_BITMAP_BITS)
+		kfree(val32);
+
+	return ret;
+}
+
+int ethnl_update_bitset(unsigned long *bitmap, unsigned int nbits,
+			const struct nlattr *attr, ethnl_string_array_t names,
+			struct netlink_ext_ack *extack, bool *mod)
+{
+	u32 small_bitmap32[__SMALL_BITMAP_WORDS];
+	u32 *bitmap32 = small_bitmap32;
+	bool u32_mod = false;
+	int ret;
+
+	if (nbits > __SMALL_BITMAP_BITS) {
+		unsigned int dst_words = DIV_ROUND_UP(nbits, 32);
+
+		bitmap32 = kmalloc_array(dst_words, sizeof(u32), GFP_KERNEL);
+		if (!bitmap32)
+			return -ENOMEM;
+	}
+
+	bitmap_to_arr32(bitmap32, bitmap, nbits);
+	ret = ethnl_update_bitset32(bitmap32, nbits, attr, names, extack,
+				    &u32_mod);
+	if (ulong_mod) {
+		bitmap_from_arr32(bitmap, bitmap32, nbits);
+		*mod = true;
+	}
+
+	if (size > __SMALL_BITMAP_BITS)
+		kfree(bitmask32);
+
+	return ret;
+}
+
+#else
+
+int ethnl_bitset_size(const unsigned long *val, const unsigned long *mask,
+		      unsigned int nbits, ethnl_string_array_t names,
+		      bool compact)
+{
+	return ethnl_bitset32_size((const u32 *)val, (const u32 *)mask, nbits,
+				   names, compact);
+}
+
+int ethnl_put_bitset(struct sk_buff *skb, int attrtype,
+		     const unsigned long *val, const unsigned long *mask,
+		     unsigned int nbits, ethnl_string_array_t names,
+		     bool compact)
+{
+	return ethnl_put_bitset32(skb, attrtype, (const u32 *)val,
+				  (const u32 *)mask, nbits, names, compact);
+}
+
+int ethnl_update_bitset(unsigned long *bitmap, unsigned int nbits,
+			const struct nlattr *attr, ethnl_string_array_t names,
+			struct netlink_ext_ack *extack, bool *mod)
+{
+	return ethnl_update_bitset32((u32 *)bitmap, nbits, attr, names, extack,
+				     mod);
+}
+
+#endif /* BITS_PER_LONG == 64 && defined(__BIG_ENDIAN) */
diff --git a/net/ethtool/bitset.h b/net/ethtool/bitset.h
new file mode 100644
index 000000000000..cd3d681b4524
--- /dev/null
+++ b/net/ethtool/bitset.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _NET_ETHTOOL_BITSET_H
+#define _NET_ETHTOOL_BITSET_H
+
+typedef const char (*const ethnl_string_array_t)[ETH_GSTRING_LEN];
+
+int ethnl_bitset_is_compact(const struct nlattr *bitset, bool *compact);
+int ethnl_bitset_size(const unsigned long *val, const unsigned long *mask,
+		      unsigned int nbits, ethnl_string_array_t names,
+		      bool compact);
+int ethnl_bitset32_size(const u32 *val, const u32 *mask, unsigned int nbits,
+			ethnl_string_array_t names, bool compact);
+int ethnl_put_bitset(struct sk_buff *skb, int attrtype,
+		     const unsigned long *val, const unsigned long *mask,
+		     unsigned int nbits, ethnl_string_array_t names,
+		     bool compact);
+int ethnl_put_bitset32(struct sk_buff *skb, int attrtype, const u32 *val,
+		       const u32 *mask, unsigned int nbits,
+		       ethnl_string_array_t names, bool compact);
+int ethnl_update_bitset(unsigned long *bitmap, unsigned int nbits,
+			const struct nlattr *attr, ethnl_string_array_t names,
+			struct netlink_ext_ack *extack, bool *mod);
+int ethnl_update_bitset32(u32 *bitmap, unsigned int nbits,
+			  const struct nlattr *attr, ethnl_string_array_t names,
+			  struct netlink_ext_ack *extack, bool *mod);
+
+#endif /* _NET_ETHTOOL_BITSET_H */
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index f7c0368a9fa0..4c0b5ca439f8 100644
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
 /**
  * ethnl_strz_size() - calculate attribute length for fixed size string
  * @s: ETH_GSTRING_LEN sized string (may not be null terminated)
-- 
2.23.0

