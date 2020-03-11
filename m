Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A32EE1823FF
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 22:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbgCKVk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 17:40:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:46396 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729418AbgCKVk0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 17:40:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E1035AD46;
        Wed, 11 Mar 2020 21:40:23 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 4AB57E0C0A; Wed, 11 Mar 2020 22:40:23 +0100 (CET)
Message-Id: <70fe704ddd961de7250e2cb7800369509ed6e1d8.1583962006.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583962006.git.mkubecek@suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 04/15] ethtool: add ethnl_parse_bitset() helper
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Wed, 11 Mar 2020 22:40:23 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike other SET type commands, modifying netdev features is required to
provide a reply telling userspace what was actually changed, compared to
what was requested. For that purpose, the "modified" flag provided by
ethnl_update_bitset() is not sufficient, we need full information which
bits were requested to change.

Therefore provide ethnl_parse_bitset() returning effective value and mask
bitmaps equivalent to the contents of a bitset nested attribute.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/bitset.c | 94 ++++++++++++++++++++++++++++++++++++++++++++
 net/ethtool/bitset.h |  4 ++
 2 files changed, 98 insertions(+)

diff --git a/net/ethtool/bitset.c b/net/ethtool/bitset.c
index ef9197541cb3..db2935206f3d 100644
--- a/net/ethtool/bitset.c
+++ b/net/ethtool/bitset.c
@@ -588,6 +588,100 @@ int ethnl_update_bitset32(u32 *bitmap, unsigned int nbits,
 	return 0;
 }
 
+/**
+ * ethnl_parse_bitset() - Compute effective value and mask from bitset nest
+ * @val:     unsigned long based bitmap to put value into
+ * @mask:    unsigned long based bitmap to put mask into
+ * @nbits:   size of @val and @mask bitmaps
+ * @attr:    nest attribute to parse and apply
+ * @names:   array of bit names; may be null for compact format
+ * @extack:  extack for error reporting
+ *
+ * Provide @nbits size long bitmaps for value and mask so that
+ * x = (val & mask) | (x & ~mask) would modify any @nbits sized bitmap x
+ * the same way ethnl_update_bitset() with the same bitset attribute would.
+ *
+ * Return:   negative error code on failure, 0 on success
+ */
+int ethnl_parse_bitset(unsigned long *val, unsigned long *mask,
+		       unsigned int nbits, const struct nlattr *attr,
+		       ethnl_string_array_t names,
+		       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[ETHTOOL_A_BITSET_MAX + 1];
+	const struct nlattr *bit_attr;
+	bool no_mask;
+	int rem;
+	int ret;
+
+	if (!attr)
+		return 0;
+	ret = nla_parse_nested(tb, ETHTOOL_A_BITSET_MAX, attr, bitset_policy,
+			       extack);
+	if (ret < 0)
+		return ret;
+	no_mask = tb[ETHTOOL_A_BITSET_NOMASK];
+
+	if (!tb[ETHTOOL_A_BITSET_BITS]) {
+		unsigned int change_bits;
+
+		ret = ethnl_compact_sanity_checks(nbits, attr, tb, extack);
+		if (ret < 0)
+			return ret;
+
+		change_bits = nla_get_u32(tb[ETHTOOL_A_BITSET_SIZE]);
+		bitmap_from_arr32(val, nla_data(tb[ETHTOOL_A_BITSET_VALUE]),
+				  change_bits);
+		if (change_bits < nbits)
+			bitmap_clear(val, change_bits, nbits - change_bits);
+		if (no_mask) {
+			bitmap_fill(mask, nbits);
+		} else {
+			bitmap_from_arr32(mask,
+					  nla_data(tb[ETHTOOL_A_BITSET_MASK]),
+					  change_bits);
+			if (change_bits < nbits)
+				bitmap_clear(mask, change_bits,
+					     nbits - change_bits);
+		}
+
+		return 0;
+	}
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
+
+	bitmap_zero(val, nbits);
+	if (no_mask)
+		bitmap_fill(mask, nbits);
+	else
+		bitmap_zero(mask, nbits);
+
+	nla_for_each_nested(bit_attr, tb[ETHTOOL_A_BITSET_BITS], rem) {
+		unsigned int idx;
+		bool bit_val;
+
+		ret = ethnl_parse_bit(&idx, &bit_val, nbits, bit_attr, no_mask,
+				      names, extack);
+		if (ret < 0)
+			return ret;
+		if (bit_val)
+			set_bit(idx, val);
+		if (!no_mask)
+			set_bit(idx, mask);
+	}
+
+	return 0;
+}
+
 #if BITS_PER_LONG == 64 && defined(__BIG_ENDIAN)
 
 /* 64-bit big endian architectures are the only case when u32 based bitmaps
diff --git a/net/ethtool/bitset.h b/net/ethtool/bitset.h
index b849f9d19676..c2c2e0051d00 100644
--- a/net/ethtool/bitset.h
+++ b/net/ethtool/bitset.h
@@ -26,5 +26,9 @@ int ethnl_update_bitset(unsigned long *bitmap, unsigned int nbits,
 int ethnl_update_bitset32(u32 *bitmap, unsigned int nbits,
 			  const struct nlattr *attr, ethnl_string_array_t names,
 			  struct netlink_ext_ack *extack, bool *mod);
+int ethnl_parse_bitset(unsigned long *val, unsigned long *mask,
+		       unsigned int nbits, const struct nlattr *attr,
+		       ethnl_string_array_t names,
+		       struct netlink_ext_ack *extack);
 
 #endif /* _NET_ETHTOOL_BITSET_H */
-- 
2.25.1

