Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9678FD611D
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 13:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbfJNLSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 07:18:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:33532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726351AbfJNLSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 07:18:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C230BAF62;
        Mon, 14 Oct 2019 11:18:49 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D8CF2E3935; Mon, 14 Oct 2019 13:18:47 +0200 (CEST)
Date:   Mon, 14 Oct 2019 13:18:47 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 06/17] ethtool: netlink bitset handling
Message-ID: <20191014111847.GB8493@unicorn.suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <af208e79258e7e3c3af3860e6a8908a50dec095f.1570654310.git.mkubecek@suse.cz>
 <20191011133429.GA3056@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011133429.GA3056@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 03:34:29PM +0200, Jiri Pirko wrote:
> Wed, Oct 09, 2019 at 10:59:18PM CEST, mkubecek@suse.cz wrote:
> >+Bit sets
> >+========
> >+
> >+For short bitmaps of (reasonably) fixed length, standard ``NLA_BITFIELD32``
> >+type is used. For arbitrary length bitmaps, ethtool netlink uses a nested
> >+attribute with contents of one of two forms: compact (two binary bitmaps
> >+representing bit values and mask of affected bits) and bit-by-bit (list of
> >+bits identified by either index or name).
> >+
> >+Compact form: nested (bitset) atrribute contents:
> >+
> >+  ============================  ======  ============================
> >+  ``ETHTOOL_A_BITSET_LIST``     flag    no mask, only a list
> 
> I find "list" a bit confusing name of a flag. Perhaps better to stick
> with the "compact" terminology and make this "ETHTOOL_A_BITSET_COMPACT"?
> Then in the code you can have var "is_compact", which makes the code a
> bit easier to read I believe.

This is not the same as "compact", "list" flag means that the bit set
does not represent a value/mask pair but only a single bitmap (which can
be understood as a list or subset of possible values).

This saves some space in kernel replies where there is no natural mask
so that we would have to invent one (usually all possible bits) but it
is more important in request where some request want to modify a subset
of bits (set some, unset some) while some requests pass a list of bits
to be set after the operation (i.e. "I want exactly these to be
enabled").

The flag could be omitted for compact form where we could simply say
that if there is no mask, it's a list, but we need it for verbose form.

> >+  ``ETHTOOL_A_BITSET_SIZE``     u32     number of significant bits
> >+  ``ETHTOOL_A_BITSET_VALUE``    binary  bitmap of bit values
> >+  ``ETHTOOL_A_BITSET_MASK``     binary  bitmap of valid bits
> 
> Couple of times the NLA_BITFIELD32 limitation was discussed, so isn't
> this the time to introduce generic NLA_BITFIELD with variable len and
> use it here? This is exactly job for it. As this is UAPI, I believe it
> should be done now cause later won't work.

As discussed before, we would lose the option to omit mask when it's not
needed.

> >+Bit-by-bit form: nested (bitset) attribute contents:
> >+
> >+ +---------------------------------+--------+-----------------------------+
> >+ | ``ETHTOOL_A_BITSET_LIST``       | flag   | no mask, only a list        |
> >+ +---------------------------------+--------+-----------------------------+
> >+ | ``ETHTOOL_A_BITSET_SIZE``       | u32    | number of significant bits  |
> >+ +---------------------------------+--------+-----------------------------+
> >+ | ``ETHTOOL_A_BITSET_BIT``        | nested | array of bits               |
> 
> "ETHTOOL_A_BITSET_BIT" does not exist in the code. I believe you ment
> "ETHTOOL_A_BITSET_BITS"
> 
> 
> >+ +-+-------------------------------+--------+-----------------------------+
> >+ |   ``ETHTOOL_A_BITSET_BIT+``     | nested | one bit                     |
> 
> You seem to be missing "|" here.
> Also "ETHTOOL_A_BITSET_BIT" does not exist. I believe you ment
> "ETHTOOL_A_BITS_BIT"

Yes on both, thanks.

> >+/* bit sets */
> >+
> >+enum {
> >+	ETHTOOL_A_BIT_UNSPEC,
> >+	ETHTOOL_A_BIT_INDEX,			/* u32 */
> >+	ETHTOOL_A_BIT_NAME,			/* string */
> >+	ETHTOOL_A_BIT_VALUE,			/* flag */
> >+
> >+	/* add new constants above here */
> >+	__ETHTOOL_A_BIT_CNT,
> >+	ETHTOOL_A_BIT_MAX = __ETHTOOL_A_BIT_CNT - 1
> >+};
> >+
> >+enum {
> >+	ETHTOOL_A_BITS_UNSPEC,
> >+	ETHTOOL_A_BITS_BIT,
> >+
> >+	/* add new constants above here */
> >+	__ETHTOOL_A_BITS_CNT,
> >+	ETHTOOL_A_BITS_MAX = __ETHTOOL_A_BITS_CNT - 1
> >+};
> 
> I think it would be good to have this named with "_BITSET_" in it so it
> is crystal clear this is part of the bitset UAPI.

I guess we can add "_BITSET" (e.g. ETHTOOL_A_BITSET_BIT_VALUE). These
constants shouldn't be used outside bitset.c (and some isolated part of
the userspace code) so the length is not so much of an issue.

> >+/**
> >+ * ethnl_put_bitset32() - Put a bitset nest into a message
> >+ * @skb:      skb with the message
> >+ * @attrtype: attribute type for the bitset nest
> >+ * @val:      value bitmap (u32 based)
> >+ * @mask:     mask bitmap (u32 based, optional)
> >+ * @nbits:    bit length of the bitset
> >+ * @names:    array of bit names (optional)
> >+ * @compact:  use compact format for the output
> >+ *
> >+ * Compose a nested attribute representing a bitset. If @mask is null, simple
> >+ * bitmap (bit list) is created, if @mask is provided, represent a value/mask
> >+ * pair. Bit names are only used in verbose mode and when provided by calller.
> >+ *
> >+ * Return:    0 on success, negative error value on error
> 
> Remove the spaces.

OK

> >+ */
> >+int ethnl_put_bitset32(struct sk_buff *skb, int attrtype, const u32 *val,
> >+		       const u32 *mask, unsigned int nbits,
> >+		       ethnl_string_array_t names, bool compact)
> >+{
> >+	struct nlattr *nest;
> >+	struct nlattr *attr;
> >+
> >+	nest = nla_nest_start(skb, attrtype);
> >+	if (!nest)
> >+		return -EMSGSIZE;
> >+
> >+	if (!mask && nla_put_flag(skb, ETHTOOL_A_BITSET_LIST))
> 
> Wait, shouldn't you rather check "!compact" ?
> 
> and WARN_ON in case compact == true && mask == NULL?

The "compact" and "list" flags are orthogonal. In this function, caller
passes null @mask if it wants to generated a list (as documented in the
function description above). In some older version I had "bool is_list"
which was set to "!mask" but I felt it didn't really make the code any
simpler; I can return to that if you think it will make the code easier
to read.

> 
> 
> >+		goto nla_put_failure;
> >+	if (nla_put_u32(skb, ETHTOOL_A_BITSET_SIZE, nbits))
> >+		goto nla_put_failure;
> >+	if (compact) {
> >+		unsigned int nwords = DIV_ROUND_UP(nbits, 32);
> >+		unsigned int nbytes = nwords * sizeof(u32);
> >+		u32 *dst;
> >+
> >+		attr = nla_reserve(skb, ETHTOOL_A_BITSET_VALUE, nbytes);
> >+		if (!attr)
> >+			goto nla_put_failure;
> >+		dst = nla_data(attr);
> >+		memcpy(dst, val, nbytes);
> >+		if (nbits % 32)
> >+			dst[nwords - 1] &= __lower_bits(nbits);
> >+
> >+		if (mask) {
> >+			attr = nla_reserve(skb, ETHTOOL_A_BITSET_MASK, nbytes);
> >+			if (!attr)
> >+				goto nla_put_failure;
> >+			dst = nla_data(attr);
> >+			memcpy(dst, mask, nbytes);
> >+			if (nbits % 32)
> >+				dst[nwords - 1] &= __lower_bits(nbits);
> >+		}
> >+	} else {
> >+		struct nlattr *bits;
> >+		unsigned int i;
> >+
> >+		bits = nla_nest_start(skb, ETHTOOL_A_BITSET_BITS);
> >+		if (!bits)
> >+			goto nla_put_failure;
> >+		for (i = 0; i < nbits; i++) {
> >+			const char *name = names ? names[i] : NULL;
> >+
> >+			if (!__bitmap32_test_bit(mask ?: val, i))
> 
> A) this __bitmap32_test_bit() looks like something generic, yet it is
>    not. Perhaps you would want to add this helper to
>    include/linux/bitmap.h?

I'm not sure it would be appreciated there as the whole header file is
for functions handling unsigned long based bitmaps. I'll rename it to
make it obvious it's a local helper.

> B) Why don't you do bitmap_to_arr32 conversion in this function just
>    before val/mask put. Then you can use normal test_bit() here.

This relates to the question (below) why we need two versions of the
functions, one for unsigned long based bitmaps, one for u32 based ones.
The reason is that both are used internally by existing code. So if we
had only one set of bitset functions, callers using the other format
would have to do the wrapping themselves.

There are two reasons why u32 versions are implemented directly and
usingned long ones as wrappers. First, u32 based bitmaps are more
frequent in existing code. Second, when we can get away with a cast
(i.e. anywhere exect 64-bit big endian), unsigned long based bitmap can
be always interpreted as u32 based bitmap but if we tried it the other
way, we would need a special handling of the last word when the number
of 32-bit words is odd.

> >+				continue;
> >+			attr = nla_nest_start(skb, ETHTOOL_A_BITS_BIT);
> >+			if (!attr ||
> >+			    nla_put_u32(skb, ETHTOOL_A_BIT_INDEX, i))
> 
> You mix these 2 in 1 if which are not related. Better keep them separate
> in two ifs.
> Or you can put the rest of the puts in the same if too.

OK

> >+				goto nla_put_failure;
> >+			if (name &&
> >+			    ethnl_put_strz(skb, ETHTOOL_A_BIT_NAME, name))
> >+				goto nla_put_failure;
> >+			if (mask && __bitmap32_test_bit(val, i) &&
> >+			    nla_put_flag(skb, ETHTOOL_A_BIT_VALUE))
> >+				goto nla_put_failure;
> >+			nla_nest_end(skb, attr);
> >+		}
> >+		nla_nest_end(skb, bits);
> >+	}
> >+
> >+	nla_nest_end(skb, nest);
> >+	return 0;
> >+
> >+nla_put_failure:
> >+	nla_nest_cancel(skb, nest);
> >+	return -EMSGSIZE;
> >+}
> >+
> >+static const struct nla_policy bitset_policy[ETHTOOL_A_BITSET_MAX + 1] = {
> >+	[ETHTOOL_A_BITSET_UNSPEC]	= { .type = NLA_REJECT },
> >+	[ETHTOOL_A_BITSET_LIST]		= { .type = NLA_FLAG },
> >+	[ETHTOOL_A_BITSET_SIZE]		= { .type = NLA_U32 },
> >+	[ETHTOOL_A_BITSET_BITS]		= { .type = NLA_NESTED },
> >+	[ETHTOOL_A_BITSET_VALUE]	= { .type = NLA_BINARY },
> >+	[ETHTOOL_A_BITSET_MASK]		= { .type = NLA_BINARY },
> >+};
> >+
> >+static const struct nla_policy bit_policy[ETHTOOL_A_BIT_MAX + 1] = {
> >+	[ETHTOOL_A_BIT_UNSPEC]		= { .type = NLA_REJECT },
> >+	[ETHTOOL_A_BIT_INDEX]		= { .type = NLA_U32 },
> >+	[ETHTOOL_A_BIT_NAME]		= { .type = NLA_NUL_STRING },
> >+	[ETHTOOL_A_BIT_VALUE]		= { .type = NLA_FLAG },
> >+};
> >+
> >+/**
> >+ * ethnl_bitset_is_compact() - check if bitset attribute represents a compact
> >+ *			       bitset
> >+ * @bitset  - nested attribute representing a bitset
> >+ * @compact - pointer for return value
> 
> In the rest of the code, you use
> @name: description

Right, I'll fix this.

> >+ *
> >+ * Return: 0 on success, negative error code on failure
> >+ */
> >+int ethnl_bitset_is_compact(const struct nlattr *bitset, bool *compact)
> >+{
> >+	struct nlattr *tb[ETHTOOL_A_BITSET_MAX + 1];
> >+	int ret;
> >+
> >+	ret = nla_parse_nested(tb, ETHTOOL_A_BITSET_MAX, bitset,
> >+			       bitset_policy, NULL);
> >+	if (ret < 0)
> >+		return ret;
> >+
> >+	if (tb[ETHTOOL_A_BITSET_BITS]) {
> >+		if (tb[ETHTOOL_A_BITSET_VALUE] || tb[ETHTOOL_A_BITSET_MASK])
> >+			return -EINVAL;
> >+		*compact = false;
> >+		return 0;
> >+	}
> >+	if (!tb[ETHTOOL_A_BITSET_SIZE] || !tb[ETHTOOL_A_BITSET_VALUE])
> >+		return -EINVAL;
> >+
> >+	*compact = true;
> >+	return 0;
> >+}
> >+
> >+static int ethnl_name_to_idx(ethnl_string_array_t names, unsigned int n_names,
> >+			     const char *name, unsigned int name_len)
> >+{
> >+	unsigned int i;
> >+
> >+	if (!names)
> >+		return n_names;
> >+
> >+	for (i = 0; i < n_names; i++) {
> >+		const char *bname = names[i];
> >+
> >+		if (!strncmp(bname, name, name_len) &&
> >+		    strlen(bname) <= name_len)
> >+			return i;
> >+	}
> >+
> >+	return n_names;
> 
> Maybe bettet to stick with -ERRNO?

OK

> >+}
> >+
> >+static int ethnl_parse_bit(unsigned int *index, bool *val, unsigned int nbits,
> >+			   const struct nlattr *bit_attr, bool is_list,
> >+			   ethnl_string_array_t names,
> >+			   struct netlink_ext_ack *extack)
> >+{
> >+	struct nlattr *tb[ETHTOOL_A_BIT_MAX + 1];
> >+	int ret, idx;
> >+
> >+	if (nla_type(bit_attr) != ETHTOOL_A_BITS_BIT) {
> >+		NL_SET_ERR_MSG_ATTR(extack, bit_attr,
> >+				    "only ETHTOOL_A_BITS_BIT allowed in ETHTOOL_A_BITSET_BITS");
> >+		return -EINVAL;
> >+	}
> 
> Probably it makes sense the caller does this check. Later on, if there
> is another possible value, the check would have to go there anyway.

OK

> >+	ret = nla_parse_nested(tb, ETHTOOL_A_BIT_MAX, bit_attr, bit_policy,
> >+			       extack);
> >+	if (ret < 0)
> >+		return ret;
> >+
> >+	if (tb[ETHTOOL_A_BIT_INDEX]) {
> >+		const char *name;
> >+
> >+		idx = nla_get_u32(tb[ETHTOOL_A_BIT_INDEX]);
> >+		if (idx >= nbits) {
> >+			NL_SET_ERR_MSG_ATTR(extack,
> >+					    tb[ETHTOOL_A_BIT_INDEX],
> >+					    "bit index too high");
> >+			return -EOPNOTSUPP;
> >+		}
> >+		name = names ? names[idx] : NULL;
> >+		if (tb[ETHTOOL_A_BIT_NAME] && name &&
> >+		    strncmp(nla_data(tb[ETHTOOL_A_BIT_NAME]), name,
> >+			    nla_len(tb[ETHTOOL_A_BIT_NAME]))) {
> >+			NL_SET_ERR_MSG_ATTR(extack, bit_attr,
> >+					    "bit index and name mismatch");
> >+			return -EINVAL;
> >+		}
> >+	} else if (tb[ETHTOOL_A_BIT_NAME]) {
> >+		idx = ethnl_name_to_idx(names, nbits,
> >+					nla_data(tb[ETHTOOL_A_BIT_NAME]),
> >+					nla_len(tb[ETHTOOL_A_BIT_NAME]));
> 
> It's a string? Policy validation should take care if it is correctly
> terminated by '\0'. Then you don't need to pass len down. Anyone who is
> interested in length can use strlen().

OK

> >+	is_list = (tb[ETHTOOL_A_BITSET_LIST] != NULL);
> 
> just:
> 	is_list = tb[ETHTOOL_A_BITSET_LIST]
> is enough.

Assignment from pointer to a bool felt a bit weird but if you find it
acceptable, I have no problem with it.

> >+int ethnl_bitset_is_compact(const struct nlattr *bitset, bool *compact);
> >+int ethnl_bitset_size(const unsigned long *val, const unsigned long *mask,
> >+		      unsigned int nbits, ethnl_string_array_t names,
> >+		      bool compact);
> >+int ethnl_bitset32_size(const u32 *val, const u32 *mask, unsigned int nbits,
> >+			ethnl_string_array_t names, bool compact);
> >+int ethnl_put_bitset(struct sk_buff *skb, int attrtype,
> >+		     const unsigned long *val, const unsigned long *mask,
> >+		     unsigned int nbits, ethnl_string_array_t names,
> >+		     bool compact);
> >+int ethnl_put_bitset32(struct sk_buff *skb, int attrtype, const u32 *val,
> >+		       const u32 *mask, unsigned int nbits,
> >+		       ethnl_string_array_t names, bool compact);
> >+int ethnl_update_bitset(unsigned long *bitmap, unsigned int nbits,
> >+			const struct nlattr *attr, ethnl_string_array_t names,
> >+			struct netlink_ext_ack *extack, bool *mod);
> >+int ethnl_update_bitset32(u32 *bitmap, unsigned int nbits,
> >+			  const struct nlattr *attr, ethnl_string_array_t names,
> >+			  struct netlink_ext_ack *extack, bool *mod);
> 
> Hmm, I wonder why user needs to work with the 32 variants..

See above.

Michal
