Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1A247D48E
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343980AbhLVP6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:58:12 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56615 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241620AbhLVP6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:58:03 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 29FA260010;
        Wed, 22 Dec 2021 15:58:01 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <linux-kernel@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [net-next 11/18] net: ieee802154: Add support for scanning requests
Date:   Wed, 22 Dec 2021 16:57:36 +0100
Message-Id: <20211222155743.256280-12-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155743.256280-1-miquel.raynal@bootlin.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This involves processing triggering scan requests, abort scan requests,
as well as providing information about if the last scan was finished or
not.

A scan request structure is created to list the requirements.

A netlink multicast scan group is also created for the occasion so that
listeners can only focus on scan activity.

Mac layers may now implement the ->trigger_scan() and ->abort_scan()
hooks.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/linux/ieee802154.h |   2 +
 include/net/cfg802154.h    |  26 +++++
 include/net/nl802154.h     |  49 ++++++++
 net/ieee802154/core.h      |   3 +
 net/ieee802154/nl802154.c  | 234 +++++++++++++++++++++++++++++++++++++
 net/ieee802154/nl802154.h  |   4 +
 net/ieee802154/rdev-ops.h  |  28 +++++
 net/ieee802154/trace.h     |  40 +++++++
 8 files changed, 386 insertions(+)

diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
index 95c831162212..a9b09a9b8f70 100644
--- a/include/linux/ieee802154.h
+++ b/include/linux/ieee802154.h
@@ -44,6 +44,8 @@
 #define IEEE802154_SHORT_ADDR_LEN	2
 #define IEEE802154_PAN_ID_LEN		2
 
+/* Duration in superframe order */
+#define IEEE802154_MAX_SCAN_DURATION	14
 #define IEEE802154_LIFS_PERIOD		40
 #define IEEE802154_SIFS_PERIOD		12
 #define IEEE802154_MAX_SIFS_FRAME_SIZE	18
diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 4402f93cda32..292eaf280f01 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -66,6 +66,28 @@ struct ieee802154_pan_desc {
 	bool gts_permit;
 };
 
+/**
+ * struct cfg802154_scan_req - Scan request
+ *
+ * @type: type of scan to be performed
+ * @flags: flags bitfield controlling the operation
+ * @page: page on which to perform the scan
+ * @channels: channels in te %page to be scanned
+ * @duration: time spent on each channel, calculated with:
+ *            aBaseSuperframeDuration * (2 ^ duration + 1)
+ * @wpan_dev: the wpan device on which to perform the scan
+ * @wpan_phy: the wpan phy on which to perform the scan
+ */
+struct cfg802154_scan_request {
+	enum nl802154_scan_types type;
+	u32 flags;
+	u8 page;
+	u32 channels;
+	u8 duration;
+	struct wpan_dev *wpan_dev;
+	struct wpan_phy *wpan_phy;
+};
+
 struct cfg802154_ops {
 	struct net_device * (*add_virtual_intf_deprecated)(struct wpan_phy *wpan_phy,
 							   const char *name,
@@ -104,6 +126,10 @@ struct cfg802154_ops {
 				struct wpan_dev *wpan_dev, bool mode);
 	int	(*set_ackreq_default)(struct wpan_phy *wpan_phy,
 				      struct wpan_dev *wpan_dev, bool ackreq);
+	int	(*trigger_scan)(struct wpan_phy *wpan_phy,
+				struct cfg802154_scan_request *request);
+	int	(*abort_scan)(struct wpan_phy *wpan_phy,
+			      struct wpan_dev *wpan_dev);
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	void	(*get_llsec_table)(struct wpan_phy *wpan_phy,
 				   struct wpan_dev *wpan_dev,
diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index 145acb8f2509..51eca3a2b14e 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -58,6 +58,10 @@ enum nl802154_commands {
 
 	NL802154_CMD_SET_WPAN_PHY_NETNS,
 
+	NL802154_CMD_TRIGGER_SCAN,
+	NL802154_CMD_ABORT_SCAN,
+	NL802154_CMD_SCAN_DONE,
+
 	/* add new commands above here */
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
@@ -133,6 +137,11 @@ enum nl802154_attrs {
 	NL802154_ATTR_PID,
 	NL802154_ATTR_NETNS_FD,
 
+	NL802154_ATTR_SCAN_TYPE,
+	NL802154_ATTR_SCAN_FLAGS,
+	NL802154_ATTR_SCAN_CHANNELS,
+	NL802154_ATTR_SCAN_DURATION,
+
 	/* add attributes here, update the policy in nl802154.c */
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
@@ -218,6 +227,46 @@ enum nl802154_wpan_phy_capability_attr {
 	NL802154_CAP_ATTR_MAX = __NL802154_CAP_ATTR_AFTER_LAST - 1
 };
 
+/**
+ * enum nl802154_scan_types - Scan types
+ *
+ * @__NL802154_SCAN_INVALID: scan type number 0 is reserved
+ * @NL802154_SCAN_ED: An ED scan allows a device to obtain a measure of the peak
+ *	energy in each requested channel
+ * @NL802154_SCAN_ACTIVE: Locate any coordinator transmitting Beacon frames using
+ *	a Beacon Request command
+ * @NL802154_SCAN_PASSIVE: Locate any coordinator transmitting Beacon frames
+ * @NL802154_SCAN_ORPHAN: Relocate coordinator following a loss of synchronisation
+ * @NL802154_SCAN_ENHANCED_ACTIVE: Same as Active using Enhanced Beacon Request
+ *	command instead of Beacon Request command
+ * @NL802154_SCAN_RIT_PASSIVE: Passive scan for RIT Data Request command frames
+ *	instead of Beacon frames
+ * @NL802154_SCAN_ATTR_MAX: Maximum SCAN attribute number
+ */
+enum nl802154_scan_types {
+	__NL802154_SCAN_INVALID,
+	NL802154_SCAN_ED,
+	NL802154_SCAN_ACTIVE,
+	NL802154_SCAN_PASSIVE,
+	NL802154_SCAN_ORPHAN,
+	NL802154_SCAN_ENHANCED_ACTIVE,
+	NL802154_SCAN_RIT_PASSIVE,
+
+	/* keep last */
+	NL802154_SCAN_ATTR_MAX,
+};
+
+/**
+ * enum nl802154_scan_flags - Scan request control flags
+ *
+ * @NL802154_SCAN_FLAG_RANDOM_ADDR: use a random MAC address for this scan (ie.
+ *	a different one for every scan iteration). When the flag is set, full
+ *	randomisation is assumed.
+ */
+enum nl802154_scan_flags {
+	NL802154_SCAN_FLAG_RANDOM_ADDR = BIT(0),
+};
+
 /**
  * enum nl802154_cca_modes - cca modes
  *
diff --git a/net/ieee802154/core.h b/net/ieee802154/core.h
index dea1d6f70489..190513ee4b51 100644
--- a/net/ieee802154/core.h
+++ b/net/ieee802154/core.h
@@ -28,6 +28,9 @@ struct cfg802154_registered_device {
 	int pan_entries;
 	int pan_generation;
 
+	/* scanning */
+	struct cfg802154_scan_request *scan_req;
+
 	/* must be last because of the way we do wpan_phy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN
 	 */
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index e0b072aecf0f..d59de9812721 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -26,10 +26,12 @@ static struct genl_family nl802154_fam;
 /* multicast groups */
 enum nl802154_multicast_groups {
 	NL802154_MCGRP_CONFIG,
+	NL802154_MCGRP_SCAN,
 };
 
 static const struct genl_multicast_group nl802154_mcgrps[] = {
 	[NL802154_MCGRP_CONFIG] = { .name = "config", },
+	[NL802154_MCGRP_SCAN] = { .name = "scan", },
 };
 
 /* returns ERR_PTR values */
@@ -216,6 +218,12 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 
 	[NL802154_ATTR_PID] = { .type = NLA_U32 },
 	[NL802154_ATTR_NETNS_FD] = { .type = NLA_U32 },
+
+	[NL802154_ATTR_SCAN_TYPE] = { .type = NLA_U8, },
+	[NL802154_ATTR_SCAN_FLAGS] = { .type = NLA_U32, },
+	[NL802154_ATTR_SCAN_CHANNELS] = { .type = NLA_U32, },
+	[NL802154_ATTR_SCAN_DURATION] = { .type = NLA_U8, },
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	[NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
 	[NL802154_ATTR_SEC_OUT_LEVEL] = { .type = NLA_U32, },
@@ -1281,6 +1289,216 @@ static int nl802154_wpan_phy_netns(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg802154_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
+	struct wpan_phy *wpan_phy = &rdev->wpan_phy;
+	struct cfg802154_scan_request *request;
+	u8 type;
+	int err;
+
+	/* Test iftype and avoid scanning if monitor type. */
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
+	request = kzalloc(sizeof(*request), GFP_KERNEL);
+	if (!request)
+		return -ENOMEM;
+
+	request->wpan_dev = wpan_dev;
+	request->wpan_phy = wpan_phy;
+
+	type = nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE]);
+	switch (type) {
+	case NL802154_SCAN_ACTIVE:
+	case NL802154_SCAN_PASSIVE:
+		request->type = type;
+		break;
+	default:
+		pr_err("Invalid scan type: %d\n", type);
+		err = -EINVAL;
+		goto free_request;
+	}
+
+	if (info->attrs[NL802154_ATTR_SCAN_FLAGS])
+		request->flags = nla_get_u32(info->attrs[NL802154_ATTR_SCAN_FLAGS]);
+
+	if (info->attrs[NL802154_ATTR_PAGE]) {
+		request->page = nla_get_u8(info->attrs[NL802154_ATTR_PAGE]);
+		if (request->page > IEEE802154_MAX_PAGE) {
+			pr_err("Invalid page %d > %d\n",
+			       request->page, IEEE802154_MAX_PAGE);
+			err = -EINVAL;
+			goto free_request;
+		}
+	} else {
+		/* Use current page by default */
+		request->page = wpan_phy->current_page;
+	}
+
+	if (info->attrs[NL802154_ATTR_SCAN_CHANNELS]) {
+		request->channels = nla_get_u32(info->attrs[NL802154_ATTR_SCAN_CHANNELS]);
+		if (request->channels >= BIT(IEEE802154_MAX_CHANNEL + 1)) {
+			pr_err("Invalid channels bitfield %x ≥ %lx\n",
+			       request->channels,
+			       BIT(IEEE802154_MAX_CHANNEL + 1));
+			err = -EINVAL;
+			goto free_request;
+		}
+	} else {
+		/* Scan all supported channels by default */
+		request->channels = rdev->wpan_phy.supported.channels[request->page];
+	}
+
+	if (info->attrs[NL802154_ATTR_SCAN_DURATION]) {
+		request->duration = nla_get_u8(info->attrs[NL802154_ATTR_SCAN_DURATION]);
+		if (request->duration > IEEE802154_MAX_SCAN_DURATION) {
+			pr_err("Invalid duration %d > %d\n",
+			       request->duration, IEEE802154_MAX_SCAN_DURATION);
+			err = -EINVAL;
+			goto free_request;
+		}
+	} else {
+		/* Use maximum duration order by default */
+		request->duration = IEEE802154_MAX_SCAN_DURATION;
+	}
+
+	err = rdev_trigger_scan(rdev, request);
+	if (err) {
+		pr_err("Failure starting scanning (%d)\n", err);
+		goto free_request;
+	}
+
+	rdev->scan_req = request;
+
+	if (wpan_dev->netdev)
+		dev_hold(wpan_dev->netdev);
+
+	return 0;
+
+free_request:
+	kfree(request);
+
+	return err;
+}
+
+static int nl802154_add_scan_req(struct sk_buff *msg,
+				 struct cfg802154_scan_request *req)
+{
+	if (req->type &&
+	    nla_put_u8(msg, NL802154_ATTR_SCAN_TYPE, req->type))
+		goto nla_put_failure;
+
+	if (req->flags &&
+	    nla_put_u32(msg, NL802154_ATTR_SCAN_FLAGS, req->flags))
+		goto nla_put_failure;
+
+	if (req->page &&
+	    nla_put_u8(msg, NL802154_ATTR_PAGE, req->page))
+		goto nla_put_failure;
+
+	if (req->channels &&
+	    nla_put_u32(msg, NL802154_ATTR_SCAN_CHANNELS, req->channels))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -ENOBUFS;
+}
+
+static int nl802154_prep_scan_msg(struct sk_buff *msg,
+				  struct cfg802154_registered_device *rdev,
+				  struct wpan_dev *wpan_dev,
+				  u32 portid, u32 seq, int flags, u8 cmd)
+{
+	void *hdr;
+
+	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
+	if (!hdr)
+		return -ENOBUFS;
+
+	if (nla_put_u32(msg, NL802154_ATTR_WPAN_PHY, rdev->wpan_phy_idx))
+		goto nla_put_failure;
+
+	if (wpan_dev->netdev &&
+	    nla_put_u32(msg, NL802154_ATTR_IFINDEX, wpan_dev->netdev->ifindex))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, NL802154_ATTR_WPAN_DEV,
+			      wpan_dev_id(wpan_dev), NL802154_ATTR_PAD))
+		goto nla_put_failure;
+
+	if (nl802154_add_scan_req(msg, rdev->scan_req))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	return 0;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+
+	return -EMSGSIZE;
+}
+
+static int nl802154_send_scan_done_msg(struct cfg802154_registered_device *rdev,
+				       struct wpan_dev *wpan_dev)
+{
+	struct sk_buff *msg;
+	int ret;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	ret = nl802154_prep_scan_msg(msg, rdev, wpan_dev, 0, 0, 0,
+				     NL802154_CMD_SCAN_DONE);
+	if (ret < 0) {
+		nlmsg_free(msg);
+		return ret;
+	}
+
+	return genlmsg_multicast_netns(&nl802154_fam,
+				       wpan_phy_net(&rdev->wpan_phy), msg, 0,
+				       NL802154_MCGRP_SCAN, GFP_KERNEL);
+}
+
+int nl802154_send_scan_done(struct cfg802154_registered_device *rdev,
+			    struct wpan_dev *wpan_dev)
+{
+	int err;
+
+	err = nl802154_send_scan_done_msg(rdev, wpan_dev);
+
+	/* Ignore errors when there are no listeners */
+	if (err == -ESRCH)
+		err = 0;
+
+	if (wpan_dev->netdev)
+		dev_put(wpan_dev->netdev);
+
+	kfree(rdev->scan_req);
+	rdev->scan_req = NULL;
+
+	return err;
+}
+EXPORT_SYMBOL(nl802154_send_scan_done);
+
+static int nl802154_abort_scan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg802154_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
+
+	/* Resources will be released in the notification helper above when we
+	 * are sure all actions have ended.
+	 */
+	return rdev_abort_scan(rdev, wpan_dev);
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static const struct nla_policy nl802154_dev_addr_policy[NL802154_DEV_ADDR_ATTR_MAX + 1] = {
 	[NL802154_DEV_ADDR_ATTR_PAN_ID] = { .type = NLA_U16 },
@@ -2369,6 +2587,22 @@ static const struct genl_ops nl802154_ops[] = {
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
 				  NL802154_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL802154_CMD_TRIGGER_SCAN,
+		.doit = nl802154_trigger_scan,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL802154_FLAG_NEED_NETDEV |
+				  NL802154_FLAG_CHECK_NETDEV_UP |
+				  NL802154_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL802154_CMD_ABORT_SCAN,
+		.doit = nl802154_abort_scan,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL802154_FLAG_NEED_NETDEV |
+				  NL802154_FLAG_CHECK_NETDEV_UP |
+				  NL802154_FLAG_NEED_RTNL,
+	},
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	{
 		.cmd = NL802154_CMD_SET_SEC_PARAMS,
diff --git a/net/ieee802154/nl802154.h b/net/ieee802154/nl802154.h
index 8c4b6d08954c..84567cd4ea83 100644
--- a/net/ieee802154/nl802154.h
+++ b/net/ieee802154/nl802154.h
@@ -2,7 +2,11 @@
 #ifndef __IEEE802154_NL802154_H
 #define __IEEE802154_NL802154_H
 
+#include "core.h"
+
 int nl802154_init(void);
 void nl802154_exit(void);
+int nl802154_send_scan_done(struct cfg802154_registered_device *rdev,
+			    struct wpan_dev *wpan_dev);
 
 #endif /* __IEEE802154_NL802154_H */
diff --git a/net/ieee802154/rdev-ops.h b/net/ieee802154/rdev-ops.h
index 598f5af49775..e171d74c3251 100644
--- a/net/ieee802154/rdev-ops.h
+++ b/net/ieee802154/rdev-ops.h
@@ -209,6 +209,34 @@ rdev_set_ackreq_default(struct cfg802154_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_trigger_scan(struct cfg802154_registered_device *rdev,
+				    struct cfg802154_scan_request *request)
+{
+	int ret;
+
+	if (!rdev->ops->trigger_scan)
+		return -EOPNOTSUPP;
+
+	trace_802154_rdev_trigger_scan(&rdev->wpan_phy, request);
+	ret = rdev->ops->trigger_scan(&rdev->wpan_phy, request);
+	trace_802154_rdev_return_int(&rdev->wpan_phy, ret);
+	return ret;
+}
+
+static inline int rdev_abort_scan(struct cfg802154_registered_device *rdev,
+				  struct wpan_dev *wpan_dev)
+{
+	int ret;
+
+	if (!rdev->ops->abort_scan)
+		return -EOPNOTSUPP;
+
+	trace_802154_rdev_abort_scan(&rdev->wpan_phy, wpan_dev);
+	ret = rdev->ops->abort_scan(&rdev->wpan_phy, wpan_dev);
+	trace_802154_rdev_return_int(&rdev->wpan_phy, ret);
+	return ret;
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 /* TODO this is already a nl802154, so move into ieee802154 */
 static inline void
diff --git a/net/ieee802154/trace.h b/net/ieee802154/trace.h
index 19c2e5d60e76..e5405f737ded 100644
--- a/net/ieee802154/trace.h
+++ b/net/ieee802154/trace.h
@@ -295,6 +295,46 @@ TRACE_EVENT(802154_rdev_set_ackreq_default,
 		WPAN_DEV_PR_ARG, BOOL_TO_STR(__entry->ackreq))
 );
 
+TRACE_EVENT(802154_rdev_trigger_scan,
+	TP_PROTO(struct wpan_phy *wpan_phy,
+		 struct cfg802154_scan_request *request),
+	TP_ARGS(wpan_phy, request),
+	TP_STRUCT__entry(
+		WPAN_PHY_ENTRY
+		__field(u8, page)
+		__field(u32, channels)
+		__field(u8, duration)
+	),
+	TP_fast_assign(
+		WPAN_PHY_ASSIGN;
+		__entry->page = request->page;
+		__entry->channels = request->channels;
+		__entry->duration = request->duration;
+	),
+	TP_printk(WPAN_PHY_PR_FMT ", scan, page: %d, channels: %x, duration %d",
+		  WPAN_PHY_PR_ARG, __entry->page, __entry->channels, __entry->duration)
+);
+
+DECLARE_EVENT_CLASS(802154_wdev_template,
+	TP_PROTO(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev),
+	TP_ARGS(wpan_phy, wpan_dev),
+	TP_STRUCT__entry(
+		WPAN_PHY_ENTRY
+		WPAN_DEV_ENTRY
+	),
+	TP_fast_assign(
+		WPAN_PHY_ASSIGN;
+		WPAN_DEV_ASSIGN;
+	),
+	TP_printk(WPAN_PHY_PR_FMT ", " WPAN_DEV_PR_FMT,
+		  WPAN_PHY_PR_ARG, WPAN_DEV_PR_ARG)
+);
+
+DEFINE_EVENT(802154_wdev_template, 802154_rdev_abort_scan,
+	TP_PROTO(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev),
+	TP_ARGS(wpan_phy, wpan_dev)
+);
+
 TRACE_EVENT(802154_rdev_return_int,
 	TP_PROTO(struct wpan_phy *wpan_phy, int ret),
 	TP_ARGS(wpan_phy, ret),
-- 
2.27.0

