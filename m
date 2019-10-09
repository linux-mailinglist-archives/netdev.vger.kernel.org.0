Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91BEFD1A43
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 23:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732193AbfJIU7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:59:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:51414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732074AbfJIU7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 16:59:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 338A8B237;
        Wed,  9 Oct 2019 20:59:16 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id CCC72E3785; Wed,  9 Oct 2019 22:59:15 +0200 (CEST)
Message-Id: <061af34c9f34205ed18a126cef9ebe1534de8bc7.1570654310.git.mkubecek@suse.cz>
In-Reply-To: <cover.1570654310.git.mkubecek@suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v7 05/17] ethtool: helper functions for netlink
 interface
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Wed,  9 Oct 2019 22:59:15 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add common request/reply header definition and helpers to parse request
header and fill reply header. Provide ethnl_update_* helpers to update
structure members from request attributes (to be used for *_SET requests).

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/uapi/linux/ethtool_netlink.h |  22 +++
 net/ethtool/netlink.c                | 172 ++++++++++++++++++++++
 net/ethtool/netlink.h                | 208 +++++++++++++++++++++++++++
 3 files changed, 402 insertions(+)

diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 468f5b00edcc..c58d9fd52ffc 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -29,6 +29,28 @@ enum {
 	ETHTOOL_MSG_KERNEL_MAX = __ETHTOOL_MSG_KERNEL_CNT - 1
 };
 
+/* request header */
+
+/* use compact bitsets in reply */
+#define ETHTOOL_GFLAG_COMPACT_BITSETS	(1 << 0)
+/* provide optional reply for SET or ACT requests */
+#define ETHTOOL_GFLAG_OMIT_REPLY	(1 << 1)
+
+#define ETHTOOL_GFLAG_ALL (ETHTOOL_GFLAG_COMPACT_BITSETS | \
+			   ETHTOOL_GFLAG_OMIT_REPLY)
+
+enum {
+	ETHTOOL_A_HEADER_UNSPEC,
+	ETHTOOL_A_HEADER_DEV_INDEX,		/* u32 */
+	ETHTOOL_A_HEADER_DEV_NAME,		/* string */
+	ETHTOOL_A_HEADER_GFLAGS,		/* u32 - ETHTOOL_GFLAG_* */
+	ETHTOOL_A_HEADER_RFLAGS,		/* u32 - ETHTOOL_RFLAG_*_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_HEADER_CNT,
+	ETHTOOL_A_HEADER_MAX = __ETHTOOL_A_HEADER_CNT - 1
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 3c98b41f04e5..71145dace79a 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -1,8 +1,180 @@
 // SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
 
+#include <net/sock.h>
 #include <linux/ethtool_netlink.h>
 #include "netlink.h"
 
+static struct genl_family ethtool_genl_family;
+
+static const struct nla_policy dflt_header_policy[ETHTOOL_A_HEADER_MAX + 1] = {
+	[ETHTOOL_A_HEADER_UNSPEC]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
+	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
+					    .len = IFNAMSIZ - 1 },
+	[ETHTOOL_A_HEADER_GFLAGS]	= { .type = NLA_U32 },
+	[ETHTOOL_A_HEADER_RFLAGS]	= { .type = NLA_U32 },
+};
+
+/**
+ * ethnl_parse_header() - parse request header
+ * @req_info:    structure to put results into
+ * @header:      nest attribute with request header
+ * @net:         request netns
+ * @extack:      netlink extack for error reporting
+ * @policy:      netlink attribute policy to validate header; use
+ *               @dflt_header_policy (all attributes allowed) if null
+ * @require_dev: fail if no device identiified in header
+ *
+ * Parse request header in nested attribute @nest and puts results into
+ * the structure pointed to by @req_info. Extack from @info is used for error
+ * reporting. If req_info->dev is not null on return, reference to it has
+ * been taken. If error is returned, *req_info is null initialized and no
+ * reference is held.
+ *
+ * Return: 0 on success or negative error code
+ */
+int ethnl_parse_header(struct ethnl_req_info *req_info,
+		       const struct nlattr *header, struct net *net,
+		       struct netlink_ext_ack *extack,
+		       const struct nla_policy *policy, bool require_dev)
+{
+	struct nlattr *tb[ETHTOOL_A_HEADER_MAX + 1];
+	const struct nlattr *devname_attr;
+	struct net_device *dev = NULL;
+	int ret;
+
+	if (!header) {
+		NL_SET_ERR_MSG(extack, "request header missing");
+		return -EINVAL;
+	}
+	ret = nla_parse_nested(tb, ETHTOOL_A_HEADER_MAX, header,
+			       policy ?: dflt_header_policy, extack);
+	if (ret < 0)
+		return ret;
+	devname_attr = tb[ETHTOOL_A_HEADER_DEV_NAME];
+
+	if (tb[ETHTOOL_A_HEADER_DEV_INDEX]) {
+		u32 ifindex = nla_get_u32(tb[ETHTOOL_A_HEADER_DEV_INDEX]);
+
+		dev = dev_get_by_index(net, ifindex);
+		if (!dev) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[ETHTOOL_A_HEADER_DEV_INDEX],
+					    "no device matches ifindex");
+			return -ENODEV;
+		}
+		/* if both ifindex and ifname are passed, they must match */
+		if (devname_attr &&
+		    strncmp(dev->name, nla_data(devname_attr), IFNAMSIZ)) {
+			dev_put(dev);
+			NL_SET_ERR_MSG_ATTR(extack, header,
+					    "ifindex and name do not match");
+			return -ENODEV;
+		}
+	} else if (devname_attr) {
+		dev = dev_get_by_name(net, nla_data(devname_attr));
+		if (!dev) {
+			NL_SET_ERR_MSG_ATTR(extack, devname_attr,
+					    "no device matches name");
+			return -ENODEV;
+		}
+	} else if (require_dev) {
+		NL_SET_ERR_MSG_ATTR(extack, header,
+				    "neither ifindex nor name specified");
+		return -EINVAL;
+	}
+
+	if (dev && !netif_device_present(dev)) {
+		dev_put(dev);
+		NL_SET_ERR_MSG(extack, "device not present");
+		return -ENODEV;
+	}
+
+	req_info->dev = dev;
+	if (tb[ETHTOOL_A_HEADER_GFLAGS])
+		req_info->global_flags = nla_get_u32(tb[ETHTOOL_A_HEADER_GFLAGS]);
+	if (tb[ETHTOOL_A_HEADER_RFLAGS])
+		req_info->req_flags = nla_get_u32(tb[ETHTOOL_A_HEADER_RFLAGS]);
+
+	return 0;
+}
+
+/**
+ * ethnl_fill_reply_header() - Put standard header into a reply message
+ * @skb:      skb with the message
+ * @dev:      network device to describe in header
+ * @attrtype: attribute type to use for the nest
+ *
+ * Create a nested attribute with attributes describing given network device.
+ *
+ * Return: 0 on success, error value (-EMSGSIZE only) on error
+ */
+int ethnl_fill_reply_header(struct sk_buff *skb, struct net_device *dev,
+			    u16 attrtype)
+{
+	struct nlattr *nest;
+
+	if (!dev)
+		return 0;
+	nest = nla_nest_start(skb, attrtype);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, ETHTOOL_A_HEADER_DEV_INDEX, (u32)dev->ifindex) ||
+	    nla_put_string(skb, ETHTOOL_A_HEADER_DEV_NAME, dev->name))
+		goto nla_put_failure;
+	/* If more attributes are put into reply header, ethnl_header_size()
+	 * must be updated to account for them.
+	 */
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+/**
+ * ethnl_reply_init() - Create skb for a reply and fill device identification
+ * @payload: payload length (without netlink and genetlink header)
+ * @dev:     device the reply is about (may be null)
+ * @cmd:     ETHTOOL_MSG_* message type for reply
+ * @info:    genetlink info of the received packet we respond to
+ * @ehdrp:   place to store payload pointer returned by genlmsg_new()
+ *
+ * Return: pointer to allocated skb on success, NULL on error
+ */
+struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
+				 u16 hdr_attrtype, struct genl_info *info,
+				 void **ehdrp)
+{
+	struct sk_buff *skb;
+
+	skb = genlmsg_new(payload, GFP_KERNEL);
+	if (!skb)
+		goto err;
+	*ehdrp = genlmsg_put_reply(skb, info, &ethtool_genl_family, 0, cmd);
+	if (!*ehdrp)
+		goto err_free;
+
+	if (dev) {
+		int ret;
+
+		ret = ethnl_fill_reply_header(skb, dev, hdr_attrtype);
+		if (ret < 0)
+			goto err_free;
+	}
+	return skb;
+
+err_free:
+	nlmsg_free(skb);
+err:
+	if (info)
+		GENL_SET_ERR_MSG(info, "failed to setup reply message");
+	return NULL;
+}
+
 /* genetlink setup */
 
 static const struct genl_ops ethtool_genl_ops[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 257ae55ccc82..f7c0368a9fa0 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -6,5 +6,213 @@
 #include <linux/ethtool_netlink.h>
 #include <linux/netdevice.h>
 #include <net/genetlink.h>
+#include <net/sock.h>
+
+struct ethnl_req_info;
+
+int ethnl_parse_header(struct ethnl_req_info *req_info,
+		       const struct nlattr *nest, struct net *net,
+		       struct netlink_ext_ack *extack,
+		       const struct nla_policy *policy, bool require_dev);
+int ethnl_fill_reply_header(struct sk_buff *skb, struct net_device *dev,
+			    u16 attrtype);
+struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
+				 u16 hdr_attrtype, struct genl_info *info,
+				 void **ehdrp);
+
+/**
+ * ethnl_strz_size() - calculate attribute length for fixed size string
+ * @s: ETH_GSTRING_LEN sized string (may not be null terminated)
+ *
+ * Return: total length of an attribute with null terminated string from @s
+ */
+static inline int ethnl_strz_size(const char *s)
+{
+	return nla_total_size(strnlen(s, ETH_GSTRING_LEN) + 1);
+}
+
+/**
+ * ethnl_put_strz() - put string attribute with fixed size string
+ * @skb:     skb with the message
+ * @attrype: attribute type
+ * @s:       ETH_GSTRING_LEN sized string (may not be null terminated)
+ *
+ * Puts an attribute with null terminated string from @s into the message.
+ *
+ * Return: 0 on success, negative error code on failure
+ */
+static inline int ethnl_put_strz(struct sk_buff *skb, u16 attrtype,
+				 const char *s)
+{
+	unsigned int len = strnlen(s, ETH_GSTRING_LEN);
+	struct nlattr *attr;
+
+	attr = nla_reserve(skb, attrtype, len + 1);
+	if (!attr)
+		return -EMSGSIZE;
+
+	memcpy(nla_data(attr), s, len);
+	((char *)nla_data(attr))[len] = '\0';
+	return 0;
+}
+
+/**
+ * ethnl_update_u32() - update u32 value from NLA_U32 attribute
+ * @dst:  value to update
+ * @attr: netlink attribute with new value or null
+ * @mod:  pointer to bool for modification tracking
+ *
+ * Copy the u32 value from NLA_U32 netlink attribute @attr into variable
+ * pointed to by @dst; do nothing if @attr is null. Bool pointed to by @mod
+ * is set to true if this function changed the value of *dst, otherwise it
+ * is left as is.
+ */
+static inline void ethnl_update_u32(u32 *dst, const struct nlattr *attr,
+				    bool *mod)
+{
+	u32 val;
+
+	if (!attr)
+		return;
+	val = nla_get_u32(attr);
+	if (*dst == val)
+		return;
+
+	*dst = val;
+	*mod = true;
+}
+
+/**
+ * ethnl_update_u8() - update u8 value from NLA_U8 attribute
+ * @dst:  value to update
+ * @attr: netlink attribute with new value or null
+ * @mod:  pointer to bool for modification tracking
+ *
+ * Copy the u8 value from NLA_U8 netlink attribute @attr into variable
+ * pointed to by @dst; do nothing if @attr is null. Bool pointed to by @mod
+ * is set to true if this function changed the value of *dst, otherwise it
+ * is left as is.
+ */
+static inline void ethnl_update_u8(u8 *dst, const struct nlattr *attr,
+				   bool *mod)
+{
+	u8 val;
+
+	if (!attr)
+		return;
+	val = nla_get_u32(attr);
+	if (*dst == val)
+		return;
+
+	*dst = val;
+	*mod = true;
+}
+
+/**
+ * ethnl_update_bool32() - update u32 used as bool from NLA_U8 attribute
+ * @dst:  value to update
+ * @attr: netlink attribute with new value or null
+ * @mod:  pointer to bool for modification tracking
+ *
+ * Use the u8 value from NLA_U8 netlink attribute @attr to set u32 variable
+ * pointed to by @dst to 0 (if zero) or 1 (if not); do nothing if @attr is
+ * null. Bool pointed to by @mod is set to true if this function changed the
+ * logical value of *dst, otherwise it is left as is.
+ */
+static inline void ethnl_update_bool32(u32 *dst, const struct nlattr *attr,
+				       bool *mod)
+{
+	u8 val;
+
+	if (!attr)
+		return;
+	val = !!nla_get_u8(attr);
+	if (!!*dst == val)
+		return;
+
+	*dst = val;
+	*mod = true;
+}
+
+/**
+ * ethnl_update_binary() - update binary data from NLA_BINARY atribute
+ * @dst:  value to update
+ * @len:  destination buffer length
+ * @attr: netlink attribute with new value or null
+ * @mod:  pointer to bool for modification tracking
+ *
+ * Use the u8 value from NLA_U8 netlink attribute @attr to rewrite data block
+ * of length @len at @dst by attribute payload; do nothing if @attr is null.
+ * Bool pointed to by @mod is set to true if this function changed the logical
+ * value of *dst, otherwise it is left as is.
+ */
+static inline void ethnl_update_binary(void *dst, unsigned int len,
+				       const struct nlattr *attr, bool *mod)
+{
+	if (!attr)
+		return;
+	if (nla_len(attr) < len)
+		len = nla_len(attr);
+	if (!memcmp(dst, nla_data(attr), len))
+		return;
+
+	memcpy(dst, nla_data(attr), len);
+	*mod = true;
+}
+
+/**
+ * ethnl_update_bitfield32() - update u32 value from NLA_BITFIELD32 attribute
+ * @dst:  value to update
+ * @attr: netlink attribute with new value or null
+ * @mod:  pointer to bool for modification tracking
+ *
+ * Update bits in u32 value which are set in attribute's mask to values from
+ * attribute's value. Do nothing if @attr is null or the value wouldn't change;
+ * otherwise, set bool pointed to by @mod to true.
+ */
+static inline void ethnl_update_bitfield32(u32 *dst, const struct nlattr *attr,
+					   bool *mod)
+{
+	struct nla_bitfield32 change;
+	u32 newval;
+
+	if (!attr)
+		return;
+	change = nla_get_bitfield32(attr);
+	newval = (*dst & ~change.selector) | (change.value & change.selector);
+	if (*dst == newval)
+		return;
+
+	*dst = newval;
+	*mod = true;
+}
+
+/**
+ * ethnl_reply_header_size() - total size of reply header
+ *
+ * This is an upper estimate so that we do not need to hold RTNL lock longer
+ * than necessary (to prevent rename between size estimate and composing the
+ * message). Accounts only for device ifindex and name as those are the only
+ * attributes ethnl_fill_reply_header() puts into the reply header.
+ */
+static inline unsigned int ethnl_reply_header_size(void)
+{
+	return nla_total_size(nla_total_size(sizeof(u32)) +
+			      nla_total_size(IFNAMSIZ));
+}
+
+/**
+ * struct ethnl_req_info - base type of request information for GET requests
+ * @dev:          network device the request is for (may be null)
+ * @global_flags: request flags common for all request types
+ * @req_flags:    request flags specific for each request type
+ *
+ * This is a common base, additional members may follow after this structure.
+ */
+struct ethnl_req_info {
+	struct net_device		*dev;
+	u32				global_flags;
+	u32				req_flags;
+};
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.23.0

