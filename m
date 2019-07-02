Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA135CEC3
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfGBLuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:50:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:38538 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbfGBLuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:50:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 89E2CAFB2;
        Tue,  2 Jul 2019 11:50:04 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 341FFE0159; Tue,  2 Jul 2019 13:50:04 +0200 (CEST)
Message-Id: <44957b13e8edbced71aca893908d184eb9e57341.1562067622.git.mkubecek@suse.cz>
In-Reply-To: <cover.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 05/15] ethtool: helper functions for netlink
 interface
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue,  2 Jul 2019 13:50:04 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add common request/reply header definition and helpers to parse request
header and fill reply header. Provide ethnl_update_* helpers to update
structure members from request attributes (to be used for *_SET requests).

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/uapi/linux/ethtool_netlink.h |  23 ++++
 net/ethtool/netlink.c                | 173 +++++++++++++++++++++++++++
 net/ethtool/netlink.h                | 145 ++++++++++++++++++++++
 3 files changed, 341 insertions(+)

diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 9a0fbd4f85d9..ffd7db0848ef 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -29,6 +29,29 @@ enum {
 	ETHTOOL_MSG_KERNEL_MAX = (__ETHTOOL_MSG_KERNEL_CNT - 1)
 };
 
+/* request header */
+
+/* use compact bitsets in reply */
+#define ETHTOOL_RF_COMPACT		(1 << 0)
+/* provide optional reply for SET or ACT requests */
+#define ETHTOOL_RF_REPLY		(1 << 1)
+
+#define ETHTOOL_RF_ALL (ETHTOOL_RF_COMPACT | \
+			ETHTOOL_RF_REPLY)
+
+enum {
+	ETHTOOL_A_HEADER_UNSPEC,
+	ETHTOOL_A_HEADER_DEV_INDEX,		/* u32 */
+	ETHTOOL_A_HEADER_DEV_NAME,		/* string */
+	ETHTOOL_A_HEADER_INFOMASK,		/* u32 */
+	ETHTOOL_A_HEADER_GFLAGS,		/* u32 - ETHTOOL_RF_* */
+	ETHTOOL_A_HEADER_RFLAGS,		/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_HEADER_CNT,
+	ETHTOOL_A_HEADER_MAX = (__ETHTOOL_A_HEADER_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 3c98b41f04e5..e13f29bbd625 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -1,8 +1,181 @@
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
+	[ETHTOOL_A_HEADER_INFOMASK]	= { .type = NLA_U32 },
+	[ETHTOOL_A_HEADER_GFLAGS]	= { .type = NLA_U32 },
+	[ETHTOOL_A_HEADER_RFLAGS]	= { .type = NLA_U32 },
+};
+
+/**
+ * ethnl_parse_header() - parse request header
+ * @req_info:    structure to put results into
+ * @nest:        nest attribute with request header
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
+		       const struct nlattr *nest, struct net *net,
+		       struct netlink_ext_ack *extack,
+		       const struct nla_policy *policy, bool require_dev)
+{
+	struct nlattr *tb[ETHTOOL_A_HEADER_MAX + 1];
+	const struct nlattr *devname_attr;
+	struct net_device *dev = NULL;
+	int ret;
+
+	if (!nest) {
+		NL_SET_ERR_MSG(extack, "request header missing");
+		return -EINVAL;
+	}
+	ret = nla_parse_nested(tb, ETHTOOL_A_HEADER_MAX, nest,
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
+			NL_SET_ERR_MSG_ATTR(extack, nest,
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
+		NL_SET_ERR_MSG_ATTR(extack, nest,
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
+	ethnl_update_u32(&req_info->req_mask, tb[ETHTOOL_A_HEADER_INFOMASK]);
+	ethnl_update_u32(&req_info->global_flags, tb[ETHTOOL_A_HEADER_GFLAGS]);
+	ethnl_update_u32(&req_info->req_flags, tb[ETHTOOL_A_HEADER_RFLAGS]);
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
+ * Clean up on error.
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
+			goto err;
+	}
+	return skb;
+
+err_free:
+	nlmsg_free(skb);
+	if (info)
+		GENL_SET_ERR_MSG(info, "failed to setup reply message");
+err:
+	return NULL;
+}
+
 /* genetlink setup */
 
 static const struct genl_ops ethtool_genl_ops[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 257ae55ccc82..5510eb7054b3 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -6,5 +6,150 @@
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
+static inline int ethnl_str_size(const char *s)
+{
+	return nla_total_size(strlen(s) + 1);
+}
+
+/* The ethnl_update_* helpers set value pointed to by @dst to the value of
+ * netlink attribute @attr (if attr is not null). They return true if *dst
+ * value was changed, false if not.
+ */
+static inline bool ethnl_update_u32(u32 *dst, struct nlattr *attr)
+{
+	u32 val;
+
+	if (!attr)
+		return false;
+	val = nla_get_u32(attr);
+	if (*dst == val)
+		return false;
+
+	*dst = val;
+	return true;
+}
+
+static inline bool ethnl_update_u8(u8 *dst, struct nlattr *attr)
+{
+	u8 val;
+
+	if (!attr)
+		return false;
+	val = nla_get_u8(attr);
+	if (*dst == val)
+		return false;
+
+	*dst = val;
+	return true;
+}
+
+/* update u32 value used as bool from NLA_U8 attribute */
+static inline bool ethnl_update_bool32(u32 *dst, struct nlattr *attr)
+{
+	u8 val;
+
+	if (!attr)
+		return false;
+	val = !!nla_get_u8(attr);
+	if (!!*dst == val)
+		return false;
+
+	*dst = val;
+	return true;
+}
+
+static inline bool ethnl_update_binary(u8 *dst, unsigned int len,
+				       struct nlattr *attr)
+{
+	if (!attr)
+		return false;
+	if (nla_len(attr) < len)
+		len = nla_len(attr);
+	if (!memcmp(dst, nla_data(attr), len))
+		return false;
+
+	memcpy(dst, nla_data(attr), len);
+	return true;
+}
+
+static inline bool ethnl_update_bitfield32(u32 *dst, struct nlattr *attr)
+{
+	struct nla_bitfield32 change;
+	u32 newval;
+
+	if (!attr)
+		return false;
+	change = nla_get_bitfield32(attr);
+	newval = (*dst & ~change.selector) | (change.value & change.selector);
+	if (*dst == newval)
+		return false;
+
+	*dst = newval;
+	return true;
+}
+
+/**
+ * ethnl_is_privileged() - check if request has sufficient privileges
+ * @skb: skb with client request
+ *
+ * Checks if client request has CAP_NET_ADMIN in its netns. Unlike the flags
+ * in genl_ops, this allows finer access control, e.g. allowing or denying
+ * the request based on its contents or witholding only part of the data
+ * from unprivileged users.
+ *
+ * Return: true if request is privileged, false if not
+ */
+static inline bool ethnl_is_privileged(struct sk_buff *skb)
+{
+	struct net *net = sock_net(skb->sk);
+
+	return netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN);
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
+ * @req_mask:     request mask, bitmap of requested information
+ * @global_flags: request flags common for all request types
+ * @req_flags:    request flags specific for each request type
+ * @privileged:   privileged request (CAP_NET_ADMIN in netns)
+ *
+ * This is a common base, additional members may follow after this structure.
+ */
+struct ethnl_req_info {
+	struct net_device		*dev;
+	u32				req_mask;
+	u32				global_flags;
+	u32				req_flags;
+	bool				privileged;
+};
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.22.0

