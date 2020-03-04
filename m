Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A143D1799BB
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbgCDUZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:25:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:33618 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbgCDUZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:25:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A39F7AD41;
        Wed,  4 Mar 2020 20:25:41 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 53101E037F; Wed,  4 Mar 2020 21:25:41 +0100 (CET)
Message-Id: <48a31badbefa340dad67752177a4057c6acb745c.1583347351.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 13/25] netlink: add bitset helpers
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed,  4 Mar 2020 21:25:41 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic functions for work with arbitrary length bitsets used in ethtool
netlink interface.

The most important function is walk_bitset() which iterates through bits of
a bitset (passed as pointer to the nest attribute) and calls provided
callback for each bit.

v2:
  - add bitset_is_compact() helper

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am      |   2 +-
 netlink/bitset.c | 218 +++++++++++++++++++++++++++++++++++++++++++++++
 netlink/bitset.h |  26 ++++++
 3 files changed, 245 insertions(+), 1 deletion(-)
 create mode 100644 netlink/bitset.c
 create mode 100644 netlink/bitset.h

diff --git a/Makefile.am b/Makefile.am
index 90723a49b591..2553cf727a36 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -29,7 +29,7 @@ ethtool_SOURCES += \
 		  netlink/netlink.c netlink/netlink.h netlink/extapi.h \
 		  netlink/msgbuff.c netlink/msgbuff.h netlink/nlsock.c \
 		  netlink/nlsock.h netlink/strset.c netlink/strset.h \
-		  netlink/monitor.c \
+		  netlink/monitor.c netlink/bitset.c netlink/bitset.h \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/netlink/bitset.c b/netlink/bitset.c
new file mode 100644
index 000000000000..ed109ec1d2c0
--- /dev/null
+++ b/netlink/bitset.c
@@ -0,0 +1,218 @@
+/*
+ * bitset.h - netlink bitset helpers
+ *
+ * Functions for easier handling of ethtool netlink bitset attributes.
+ */
+
+#include <stdio.h>
+#include <errno.h>
+
+#include "../common.h"
+#include "netlink.h"
+#include "bitset.h"
+
+uint32_t bitset_get_count(const struct nlattr *bitset, int *retptr)
+{
+	const struct nlattr *attr;
+
+	mnl_attr_for_each_nested(attr, bitset) {
+		if (mnl_attr_get_type(attr) != ETHTOOL_A_BITSET_SIZE)
+			continue;
+		*retptr = 0;
+		return mnl_attr_get_u32(attr);
+	}
+
+	*retptr = -EFAULT;
+	return 0;
+}
+
+bool bitset_is_compact(const struct nlattr *bitset)
+{
+	const struct nlattr *attr;
+
+	mnl_attr_for_each_nested(attr, bitset) {
+		switch(mnl_attr_get_type(attr)) {
+		case ETHTOOL_A_BITSET_BITS:
+			return 0;
+		case ETHTOOL_A_BITSET_VALUE:
+		case ETHTOOL_A_BITSET_MASK:
+			return 1;
+		}
+	}
+
+	return false;
+}
+
+bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
+		    int *retptr)
+{
+	const struct nlattr *bitset_tb[ETHTOOL_A_BITSET_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(bitset_tb);
+	const struct nlattr *bits;
+	const struct nlattr *bit;
+	int ret;
+
+	*retptr = 0;
+	ret = mnl_attr_parse_nested(bitset, attr_cb, &bitset_tb_info);
+	if (ret < 0)
+		goto err;
+
+	bits = mask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
+		      bitset_tb[ETHTOOL_A_BITSET_VALUE];
+	if (bits) {
+		const uint32_t *bitmap =
+			(const uint32_t *)mnl_attr_get_payload(bits);
+
+		if (idx >= 8 * mnl_attr_get_payload_len(bits))
+			return false;
+		return bitmap[idx / 32] & (1U << (idx % 32));
+	}
+
+	bits = bitset_tb[ETHTOOL_A_BITSET_BITS];
+	if (!bits)
+		goto err;
+	mnl_attr_for_each_nested(bit, bits) {
+		const struct nlattr *tb[ETHTOOL_A_BITSET_BIT_MAX + 1] = {};
+		DECLARE_ATTR_TB_INFO(tb);
+		unsigned int my_idx;
+
+		if (mnl_attr_get_type(bit) != ETHTOOL_A_BITSET_BITS_BIT)
+			continue;
+		ret = mnl_attr_parse_nested(bit, attr_cb, &tb_info);
+		if (ret < 0)
+			goto err;
+		ret = -EFAULT;
+		if (!tb[ETHTOOL_A_BITSET_BIT_INDEX])
+			goto err;
+
+		my_idx = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
+		if (my_idx == idx)
+			return mask || tb[ETHTOOL_A_BITSET_BIT_VALUE];
+	}
+
+	return false;
+err:
+	fprintf(stderr, "malformed netlink message (bitset)\n");
+	*retptr = ret;
+	return false;
+}
+
+bool bitset_is_empty(const struct nlattr *bitset, bool mask, int *retptr)
+{
+	const struct nlattr *bitset_tb[ETHTOOL_A_BITSET_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(bitset_tb);
+	const struct nlattr *bits;
+	const struct nlattr *bit;
+	int ret;
+
+	*retptr = 0;
+	ret = mnl_attr_parse_nested(bitset, attr_cb, &bitset_tb_info);
+	if (ret < 0)
+		goto err;
+
+	bits = mask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
+		      bitset_tb[ETHTOOL_A_BITSET_VALUE];
+	if (bits) {
+		const uint32_t *bitmap =
+			(const uint32_t *)mnl_attr_get_payload(bits);
+		unsigned int n = mnl_attr_get_payload_len(bits);
+		unsigned int i;
+
+		ret = -EFAULT;
+		if (n % 4)
+			goto err;
+		for (i = 0; i < n / 4; i++)
+			if (bitmap[i])
+				return false;
+		return true;
+	}
+
+	bits = bitset_tb[ETHTOOL_A_BITSET_BITS];
+	if (!bits)
+		goto err;
+	mnl_attr_for_each_nested(bit, bits) {
+		const struct nlattr *tb[ETHTOOL_A_BITSET_BIT_MAX + 1] = {};
+		DECLARE_ATTR_TB_INFO(tb);
+
+		if (mnl_attr_get_type(bit) != ETHTOOL_A_BITSET_BITS_BIT)
+			continue;
+		if (mask || bitset_tb[ETHTOOL_A_BITSET_NOMASK])
+			return false;
+
+		ret = mnl_attr_parse_nested(bit, attr_cb, &tb_info);
+		if (ret < 0)
+			goto err;
+		if (tb[ETHTOOL_A_BITSET_BIT_VALUE])
+			return false;
+	}
+
+	return true;
+err:
+	fprintf(stderr, "malformed netlink message (bitset)\n");
+	*retptr = ret;
+	return true;
+}
+
+int walk_bitset(const struct nlattr *bitset, const struct stringset *labels,
+		bitset_walk_callback cb, void *data)
+{
+	const struct nlattr *bitset_tb[ETHTOOL_A_BITSET_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(bitset_tb);
+	const struct nlattr *bits;
+	const struct nlattr *bit;
+	bool is_list;
+	int ret;
+
+	ret = mnl_attr_parse_nested(bitset, attr_cb, &bitset_tb_info);
+	if (ret < 0)
+		return ret;
+	is_list = bitset_tb[ETHTOOL_A_BITSET_NOMASK];
+
+	bits = bitset_tb[ETHTOOL_A_BITSET_VALUE];
+	if (bits) {
+		const struct nlattr *mask = bitset_tb[ETHTOOL_A_BITSET_MASK];
+		unsigned int count, nwords, idx;
+		uint32_t *val_bm;
+		uint32_t *mask_bm;
+
+		if (!bitset_tb[ETHTOOL_A_BITSET_SIZE])
+			return -EFAULT;
+		count = mnl_attr_get_u32(bitset_tb[ETHTOOL_A_BITSET_SIZE]);
+		nwords = (count + 31) / 32;
+		if ((mnl_attr_get_payload_len(bits) / 4 < nwords) ||
+		    (mask && mnl_attr_get_payload_len(mask) / 4 < nwords))
+			return -EFAULT;
+
+		val_bm = mnl_attr_get_payload(bits);
+		mask_bm = mask ? mnl_attr_get_payload(mask) : NULL;
+		for (idx = 0; idx < count; idx++)
+			if (!mask_bm || (mask_bm[idx / 32] & (1 << (idx % 32))))
+				cb(idx, get_string(labels, idx),
+				   val_bm[idx / 32] & (1 << (idx % 32)), data);
+		return 0;
+	}
+
+	bits = bitset_tb[ETHTOOL_A_BITSET_BITS];
+	if (!bits)
+		return -EFAULT;
+	mnl_attr_for_each_nested(bit, bits) {
+		const struct nlattr *tb[ETHTOOL_A_BITSET_BIT_MAX + 1] = {};
+		DECLARE_ATTR_TB_INFO(tb);
+		const char *name;
+		unsigned int idx;
+
+		if (mnl_attr_get_type(bit) != ETHTOOL_A_BITSET_BITS_BIT)
+			continue;
+
+		ret = mnl_attr_parse_nested(bit, attr_cb, &tb_info);
+		if (ret < 0 || !tb[ETHTOOL_A_BITSET_BIT_INDEX] ||
+		    !tb[ETHTOOL_A_BITSET_BIT_NAME])
+			return -EFAULT;
+
+		idx = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
+		name = mnl_attr_get_str(tb[ETHTOOL_A_BITSET_BIT_NAME]);
+		cb(idx, name, is_list || tb[ETHTOOL_A_BITSET_BIT_VALUE], data);
+	}
+
+	return 0;
+}
diff --git a/netlink/bitset.h b/netlink/bitset.h
new file mode 100644
index 000000000000..4b587d2c8a04
--- /dev/null
+++ b/netlink/bitset.h
@@ -0,0 +1,26 @@
+/*
+ * bitset.h - netlink bitset helpers
+ *
+ * Declarations of helpers for handling ethtool netlink bitsets.
+ */
+
+#ifndef ETHTOOL_NETLINK_BITSET_H__
+#define ETHTOOL_NETLINK_BITSET_H__
+
+#include <libmnl/libmnl.h>
+#include <linux/netlink.h>
+#include <linux/genetlink.h>
+#include <linux/ethtool_netlink.h>
+#include "strset.h"
+
+typedef void (*bitset_walk_callback)(unsigned int, const char *, bool, void *);
+
+uint32_t bitset_get_count(const struct nlattr *bitset, int *retptr);
+bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
+		    int *retptr);
+bool bitset_is_compact(const struct nlattr *bitset);
+bool bitset_is_empty(const struct nlattr *bitset, bool mask, int *retptr);
+int walk_bitset(const struct nlattr *bitset, const struct stringset *labels,
+		bitset_walk_callback cb, void *data);
+
+#endif /* ETHTOOL_NETLINK_BITSET_H__ */
-- 
2.25.1

