Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE6AF1799C4
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388371AbgCDU0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:26:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:33890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387398AbgCDU0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:26:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D780BB2B4;
        Wed,  4 Mar 2020 20:26:21 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 87430E037F; Wed,  4 Mar 2020 21:26:21 +0100 (CET)
Message-Id: <54bf747aa2e8d890096c865d06414d3f7ec164a6.1583347351.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 21/25] netlink: support for pretty printing netlink
 messages
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed,  4 Mar 2020 21:26:21 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve message reporting and debugging, add support for displaying
netlink messages in human readable form, e.g.

    # ethtool --debug 0x10 -s eth0 msglvl drv on foo on probe off
    netlink error: bit name not found
    offending message and attribute:
        ETHTOOL_MSG_DEBUG_SET
            ETHTOOL_A_DEBUG_HEADER
                ETHTOOL_A_HEADER_DEV_NAME = "eth0"
            ETHTOOL_A_DEBUG_MSGMASK
                ETHTOOL_A_BITSET_BITS
                    ETHTOOL_A_BITSET_BITS_BIT
                        ETHTOOL_A_BITSET_BIT_NAME = "drv"
                        ETHTOOL_A_BITSET_BIT_VALUE = true
                    ETHTOOL_A_BITSET_BITS_BIT
    ===>                ETHTOOL_A_BITSET_BIT_NAME = "foo"
                        ETHTOOL_A_BITSET_BIT_VALUE = true
                    ETHTOOL_A_BITSET_BITS_BIT
                        ETHTOOL_A_BITSET_BIT_NAME = "probe"

This commit only adds support for parsing and displaying a message and
(optionally) highlighting an attribute on given offset (for extack error
reporting). To actually use it, one also needs message descriptions, i.e.
mapping of netlink attribute types to their symbolic names and payload
formats (depending on context).

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am         |   2 +-
 netlink/prettymsg.c | 193 ++++++++++++++++++++++++++++++++++++++++++++
 netlink/prettymsg.h | 102 +++++++++++++++++++++++
 3 files changed, 296 insertions(+), 1 deletion(-)
 create mode 100644 netlink/prettymsg.c
 create mode 100644 netlink/prettymsg.h

diff --git a/Makefile.am b/Makefile.am
index 38268932a955..baef0d20fa41 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -31,7 +31,7 @@ ethtool_SOURCES += \
 		  netlink/nlsock.h netlink/strset.c netlink/strset.h \
 		  netlink/monitor.c netlink/bitset.c netlink/bitset.h \
 		  netlink/settings.c netlink/parser.c netlink/parser.h \
-		  netlink/permaddr.c \
+		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/netlink/prettymsg.c b/netlink/prettymsg.c
new file mode 100644
index 000000000000..74fe6f2db7ed
--- /dev/null
+++ b/netlink/prettymsg.c
@@ -0,0 +1,193 @@
+/*
+ * prettymsg.c - human readable message dump
+ *
+ * Support for pretty print of an ethtool netlink message
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <stdint.h>
+#include <limits.h>
+#include <linux/genetlink.h>
+#include <linux/rtnetlink.h>
+#include <linux/if_link.h>
+#include <libmnl/libmnl.h>
+
+#include "prettymsg.h"
+
+#define __INDENT 4
+#define __DUMP_LINE 16
+#define __DUMP_BLOCK 4
+
+static void __print_binary_short(uint8_t *adata, unsigned int alen)
+{
+	unsigned int i;
+
+	if (!alen)
+		return;
+	printf("%02x", adata[0]);
+	for (i = 1; i < alen; i++)
+		printf("%c%02x", (i % __DUMP_BLOCK) ? ':' : ' ',  adata[i]);
+}
+
+static void __print_binary_long(uint8_t *adata, unsigned int alen,
+				unsigned int level)
+{
+	unsigned int i;
+
+	for (i = 0; i < alen; i++) {
+		if (i % __DUMP_LINE == 0)
+			printf("\n%*s", __INDENT * (level + 2), "");
+		else if (i % __DUMP_BLOCK == 0)
+			printf("  ");
+		else
+			putchar(' ');
+		printf("%02x", adata[i]);
+	}
+}
+
+static int pretty_print_attr(const struct nlattr *attr,
+			     const struct pretty_nla_desc *desc,
+			     unsigned int ndesc, unsigned int level,
+			     int err_offset, bool in_array)
+{
+	unsigned int alen = mnl_attr_get_payload_len(attr);
+	unsigned int atype = mnl_attr_get_type(attr);
+	unsigned int desc_idx = in_array ? 0 : atype;
+	void *adata = mnl_attr_get_payload(attr);
+	const struct pretty_nla_desc *adesc;
+	const char *prefix = "    ";
+	bool nested;
+
+	adesc = (desc && desc_idx < ndesc) ? &desc[desc_idx] : NULL;
+	nested = (adesc && (adesc->format == NLA_NESTED ||
+			    adesc->format == NLA_ARRAY)) ||
+		 (attr->nla_type & NLA_F_NESTED);
+	if (err_offset >= 0 &&
+	    err_offset < (nested ? NLA_HDRLEN : attr->nla_len)) {
+		prefix = "===>";
+		if (err_offset)
+			fprintf(stderr,
+				"ethtool: bad_attr inside an attribute (offset %d)\n",
+				err_offset);
+	}
+	if (adesc && adesc->name && !in_array)
+		printf("%s%*s%s", prefix, level * __INDENT, "", adesc->name);
+	else
+		printf("%s%*s[%u]", prefix, level * __INDENT, "", atype);
+
+	if (nested) {
+		struct nlattr *child;
+		int ret = 0;
+
+		putchar('\n');
+		mnl_attr_for_each_nested(child, attr) {
+			bool array = adesc && adesc->format == NLA_ARRAY;
+			unsigned int child_off;
+
+			child_off = (const char *)child - (const char *)attr;
+			ret = pretty_print_attr(child,
+						adesc ? adesc->children : NULL,
+						adesc ? adesc->n_children : 0,
+						level + 1,
+						err_offset - child_off, array);
+			if (ret < 0)
+				break;
+		}
+
+		return ret;
+	}
+
+	printf(" = ");
+	switch(adesc ? adesc->format : NLA_BINARY) {
+	case NLA_U8:
+		printf("%u", mnl_attr_get_u8(attr));
+		break;
+	case NLA_U16:
+		printf("%u", mnl_attr_get_u16(attr));
+		break;
+	case NLA_U32:
+		printf("%u", mnl_attr_get_u32(attr));
+		break;
+	case NLA_X8:
+		printf("0x%02x", mnl_attr_get_u8(attr));
+		break;
+	case NLA_X16:
+		printf("0x%04x", mnl_attr_get_u16(attr));
+		break;
+	case NLA_X32:
+		printf("0x%08x", mnl_attr_get_u32(attr));
+		break;
+	case NLA_S8:
+		printf("%d", (int)mnl_attr_get_u8(attr));
+		break;
+	case NLA_S16:
+		printf("%d", (int)mnl_attr_get_u16(attr));
+		break;
+	case NLA_S32:
+		printf("%d", (int)mnl_attr_get_u32(attr));
+		break;
+	case NLA_STRING:
+		printf("\"%.*s\"", alen, (const char *)adata);
+		break;
+	case NLA_FLAG:
+		printf("true");
+		break;
+	case NLA_BOOL:
+		printf("%s", mnl_attr_get_u8(attr) ? "on" : "off");
+		break;
+	default:
+		if (alen <= __DUMP_LINE)
+			__print_binary_short(adata, alen);
+		else
+			__print_binary_long(adata, alen, level);
+	}
+	putchar('\n');
+
+	return 0;
+}
+
+static int pretty_print_nlmsg(const struct nlmsghdr *nlhdr,
+			      unsigned int payload_offset,
+			      const struct pretty_nla_desc *desc,
+			      unsigned int ndesc, unsigned int err_offset)
+{
+	const struct nlattr *attr;
+	int attr_offset;
+	int ret;
+
+	mnl_attr_for_each(attr, nlhdr, payload_offset) {
+		attr_offset = (const char *)attr - (const char *)nlhdr;
+		ret = pretty_print_attr(attr, desc, ndesc, 1,
+					err_offset - attr_offset, false);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+int pretty_print_genlmsg(const struct nlmsghdr *nlhdr,
+			 const struct pretty_nlmsg_desc *desc,
+			 unsigned int ndesc, unsigned int err_offset)
+{
+	const struct pretty_nlmsg_desc *msg_desc;
+	const struct genlmsghdr *genlhdr;
+
+	if (mnl_nlmsg_get_payload_len(nlhdr) < GENL_HDRLEN) {
+		fprintf(stderr, "ethtool: message too short (%u bytes)\n",
+			nlhdr->nlmsg_len);
+		return -EINVAL;
+	}
+	genlhdr = mnl_nlmsg_get_payload(nlhdr);
+	msg_desc = (desc && genlhdr->cmd < ndesc) ? &desc[genlhdr->cmd] : NULL;
+	if (msg_desc && msg_desc->name)
+		printf("    %s\n", msg_desc->name);
+	else
+		printf("    [%u]\n", genlhdr->cmd);
+
+	return pretty_print_nlmsg(nlhdr, GENL_HDRLEN,
+				  msg_desc ? msg_desc->attrs : NULL,
+				  msg_desc ? msg_desc->n_attrs : 0, err_offset);
+}
diff --git a/netlink/prettymsg.h b/netlink/prettymsg.h
new file mode 100644
index 000000000000..68ec275a22f6
--- /dev/null
+++ b/netlink/prettymsg.h
@@ -0,0 +1,102 @@
+/*
+ * prettymsg.h - human readable message dump
+ *
+ * Support for pretty print of an ethtool netlink message
+ */
+
+#ifndef ETHTOOL_NETLINK_PRETTYMSG_H__
+#define ETHTOOL_NETLINK_PRETTYMSG_H__
+
+#include <linux/netlink.h>
+
+/* data structures for message format descriptions */
+
+enum pretty_nla_format {
+	NLA_INVALID,
+	NLA_BINARY,
+	NLA_U8,
+	NLA_U16,
+	NLA_U32,
+	NLA_X8,
+	NLA_X16,
+	NLA_X32,
+	NLA_S8,
+	NLA_S16,
+	NLA_S32,
+	NLA_STRING,
+	NLA_FLAG,
+	NLA_BOOL,
+	NLA_NESTED,
+	NLA_ARRAY,
+};
+
+struct pretty_nla_desc {
+	enum pretty_nla_format		format;
+	const char			*name;
+	const struct pretty_nla_desc	*children;
+	unsigned int			n_children;
+};
+
+struct pretty_nlmsg_desc {
+	const char			*name;
+	const struct pretty_nla_desc	*attrs;
+	unsigned int			n_attrs;
+};
+
+/* helper macros for message format descriptions */
+
+#define NLATTR_DESC(_name, _fmt) \
+	[_name] = { \
+		.format = _fmt, \
+		.name = #_name, \
+	}
+
+#define NLATTR_DESC_INVALID(_name)	NLATTR_DESC(_name, NLA_INVALID)
+#define NLATTR_DESC_U8(_name)		NLATTR_DESC(_name, NLA_U8)
+#define NLATTR_DESC_U16(_name)		NLATTR_DESC(_name, NLA_U16)
+#define NLATTR_DESC_U32(_name)		NLATTR_DESC(_name, NLA_U32)
+#define NLATTR_DESC_X8(_name)		NLATTR_DESC(_name, NLA_X8)
+#define NLATTR_DESC_X16(_name)		NLATTR_DESC(_name, NLA_X16)
+#define NLATTR_DESC_X32(_name)		NLATTR_DESC(_name, NLA_X32)
+#define NLATTR_DESC_S8(_name)		NLATTR_DESC(_name, NLA_U8)
+#define NLATTR_DESC_S16(_name)		NLATTR_DESC(_name, NLA_U16)
+#define NLATTR_DESC_S32(_name)		NLATTR_DESC(_name, NLA_U32)
+#define NLATTR_DESC_STRING(_name)	NLATTR_DESC(_name, NLA_STRING)
+#define NLATTR_DESC_FLAG(_name)		NLATTR_DESC(_name, NLA_FLAG)
+#define NLATTR_DESC_BOOL(_name)		NLATTR_DESC(_name, NLA_BOOL)
+#define NLATTR_DESC_BINARY(_name)	NLATTR_DESC(_name, NLA_BINARY)
+
+#define NLATTR_DESC_NESTED(_name, _children_desc) \
+	[_name] = { \
+		.format = NLA_NESTED, \
+		.name = #_name, \
+		.children = __ ## _children_desc ## _desc, \
+		.n_children = ARRAY_SIZE(__ ## _children_desc ## _desc), \
+	}
+#define NLATTR_DESC_NESTED_NODESC(_name) NLATTR_DESC(_name, NLA_NESTED)
+#define NLATTR_DESC_ARRAY(_name, _children_desc) \
+	[_name] = { \
+		.format = NLA_ARRAY, \
+		.name = #_name, \
+		.children = __ ## _children_desc ## _desc, \
+		.n_children = 1, \
+	}
+
+#define NLMSG_DESC(_name, _attrs) \
+	[_name] = { \
+		.name = #_name, \
+		.attrs = __ ## _attrs ## _desc, \
+		.n_attrs = ARRAY_SIZE(__ ## _attrs ## _desc), \
+	}
+
+#define NLMSG_DESC_INVALID(_name) \
+	[_name] = { \
+		.name = #_name, \
+	}
+
+/* function to pretty print a genetlink message */
+int pretty_print_genlmsg(const struct nlmsghdr *nlhdr,
+			 const struct pretty_nlmsg_desc *desc,
+			 unsigned int ndesc, unsigned int err_offset);
+
+#endif /* ETHTOOL_NETLINK_PRETTYMSG_H__ */
-- 
2.25.1

