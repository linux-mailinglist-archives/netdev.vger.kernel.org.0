Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4DC64F575
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 01:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiLQACh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 19:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLQACf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 19:02:35 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1282EF4E;
        Fri, 16 Dec 2022 16:02:33 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E738760005;
        Sat, 17 Dec 2022 00:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1671235351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wO6fXzoGvaEFsAhVAPCTSqrkEopY8w2HMgLbzFt/tMU=;
        b=PLWwA8X5KpnyG6GXBsnLLQ8lWWp1rJtN8r3kkN/7Y6Yhe31U/oyHox4wNBiJhQHkKtxEEf
        V+RDtHR0xUdnx+WkdcqQl1LASKuQrbklfMdnIUGDj8bTNCpDzBH7zP8yUeICzN9HEdWvYr
        FhDUJG33h0ZKsXOztOP+oDIw7d4L8tMWkvsxvwtkh3RvHt+/dIjHk6wx/AUlNOhY6tb7Ey
        xP4Kk4MOYp1NG7zjpuCGZc3wKxIZTCV9WoM08Vbn6p+mVgb79LKsNkVNkd/OmHPTgOFNi+
        TD29AnGVPc/AG439MuWShoF686n6r9XpgZlTvXNmSin7k/nnyTsy+TQLcjk0CQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 1/6] ieee802154: Add support for user scanning requests
Date:   Sat, 17 Dec 2022 01:02:21 +0100
Message-Id: <20221217000226.646767-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221217000226.646767-1-miquel.raynal@bootlin.com>
References: <20221217000226.646767-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ieee802154 layer should be able to scan a set of channels in order
to look for beacons advertizing PANs. Supporting this involves adding
two user commands: triggering scans and aborting scans. The user should
also be notified when a new beacon is received and also upon scan
termination.

A scan request structure is created to list the requirements and to be
accessed asynchronously when changing channels or receiving beacons.

Mac layers may now implement the ->trigger_scan() and ->abort_scan()
hooks.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/linux/ieee802154.h |   3 +
 include/net/cfg802154.h    |  25 +++++
 include/net/nl802154.h     |  58 ++++++++++
 net/ieee802154/nl802154.c  | 220 +++++++++++++++++++++++++++++++++++++
 net/ieee802154/nl802154.h  |   3 +
 net/ieee802154/rdev-ops.h  |  28 +++++
 net/ieee802154/trace.h     |  40 +++++++
 7 files changed, 377 insertions(+)

diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
index 0303eb84d596..b22e4147d334 100644
--- a/include/linux/ieee802154.h
+++ b/include/linux/ieee802154.h
@@ -44,6 +44,9 @@
 #define IEEE802154_SHORT_ADDR_LEN	2
 #define IEEE802154_PAN_ID_LEN		2
 
+/* Duration in superframe order */
+#define IEEE802154_MAX_SCAN_DURATION	14
+#define IEEE802154_ACTIVE_SCAN_DURATION	15
 #define IEEE802154_LIFS_PERIOD		40
 #define IEEE802154_SIFS_PERIOD		12
 #define IEEE802154_MAX_SIFS_FRAME_SIZE	18
diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index d09c393d229f..76d4f95e9974 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -18,6 +18,7 @@
 
 struct wpan_phy;
 struct wpan_phy_cca;
+struct cfg802154_scan_request;
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 struct ieee802154_llsec_device_key;
@@ -67,6 +68,10 @@ struct cfg802154_ops {
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
@@ -278,6 +283,26 @@ struct ieee802154_coord_desc {
 	bool gts_permit;
 };
 
+/**
+ * struct cfg802154_scan_request - Scan request
+ *
+ * @type: type of scan to be performed
+ * @page: page on which to perform the scan
+ * @channels: channels in te %page to be scanned
+ * @duration: time spent on each channel, calculated with:
+ *            aBaseSuperframeDuration * (2 ^ duration + 1)
+ * @wpan_dev: the wpan device on which to perform the scan
+ * @wpan_phy: the wpan phy on which to perform the scan
+ */
+struct cfg802154_scan_request {
+	enum nl802154_scan_types type;
+	u8 page;
+	u32 channels;
+	u8 duration;
+	struct wpan_dev *wpan_dev;
+	struct wpan_phy *wpan_phy;
+};
+
 struct ieee802154_llsec_key_id {
 	u8 mode;
 	u8 id;
diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index b79a89d5207c..c267fa1c5aac 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -73,6 +73,9 @@ enum nl802154_commands {
 	NL802154_CMD_DEL_SEC_LEVEL,
 
 	NL802154_CMD_SCAN_EVENT,
+	NL802154_CMD_TRIGGER_SCAN,
+	NL802154_CMD_ABORT_SCAN,
+	NL802154_CMD_SCAN_DONE,
 
 	/* add new commands above here */
 
@@ -134,6 +137,13 @@ enum nl802154_attrs {
 	NL802154_ATTR_NETNS_FD,
 
 	NL802154_ATTR_COORDINATOR,
+	NL802154_ATTR_SCAN_TYPE,
+	NL802154_ATTR_SCAN_FLAGS,
+	NL802154_ATTR_SCAN_CHANNELS,
+	NL802154_ATTR_SCAN_PREAMBLE_CODES,
+	NL802154_ATTR_SCAN_MEAN_PRF,
+	NL802154_ATTR_SCAN_DURATION,
+	NL802154_ATTR_SCAN_DONE_REASON,
 
 	/* add attributes here, update the policy in nl802154.c */
 
@@ -259,6 +269,54 @@ enum nl802154_coord {
 	NL802154_COORD_MAX,
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
+ * enum nl802154_scan_done_reasons - End of scan reasons
+ *
+ * @__NL802154_SCAN_DONE_REASON_INVALID: scan done reason number 0 is reserved.
+ * @NL802154_SCAN_DONE_REASON_FINISHED: The scan just finished naturally after
+ *	going through all the requested and possible (complex) channels.
+ * @NL802154_SCAN_DONE_REASON_ABORTED: The scan was aborted upon user request.
+ *	a Beacon Request command
+ * @NL802154_SCAN_DONE_REASON_MAX: Maximum scan done reason attribute number.
+ */
+enum nl802154_scan_done_reasons {
+	__NL802154_SCAN_DONE_REASON_INVALID,
+	NL802154_SCAN_DONE_REASON_FINISHED,
+	NL802154_SCAN_DONE_REASON_ABORTED,
+
+	/* keep last */
+	NL802154_SCAN_DONE_REASON_MAX,
+};
+
 /**
  * enum nl802154_cca_modes - cca modes
  *
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 80dc73182785..64c6c33b28a9 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -221,6 +221,13 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 
 	[NL802154_ATTR_COORDINATOR] = { .type = NLA_NESTED },
 
+	[NL802154_ATTR_SCAN_TYPE] = { .type = NLA_U8 },
+	[NL802154_ATTR_SCAN_CHANNELS] = { .type = NLA_U32 },
+	[NL802154_ATTR_SCAN_PREAMBLE_CODES] = { .type = NLA_U64 },
+	[NL802154_ATTR_SCAN_MEAN_PRF] = { .type = NLA_U8 },
+	[NL802154_ATTR_SCAN_DURATION] = { .type = NLA_U8 },
+	[NL802154_ATTR_SCAN_DONE_REASON] = { .type = NLA_U8 },
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	[NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
 	[NL802154_ATTR_SEC_OUT_LEVEL] = { .type = NLA_U32, },
@@ -1384,6 +1391,203 @@ int nl802154_scan_event(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev,
 }
 EXPORT_SYMBOL_GPL(nl802154_scan_event);
 
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
+	/* Monitors are not allowed to perform scans */
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EPERM;
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
+	case NL802154_SCAN_PASSIVE:
+		request->type = type;
+		break;
+	default:
+		pr_err("Unsupported scan type: %d\n", type);
+		err = -EINVAL;
+		goto free_request;
+	}
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
+		request->channels = wpan_phy->supported.channels[request->page];
+	}
+
+	if (info->attrs[NL802154_ATTR_SCAN_PREAMBLE_CODES] ||
+	    info->attrs[NL802154_ATTR_SCAN_MEAN_PRF]) {
+		pr_err("Preamble codes and mean PRF not supported yet\n");
+		err = -EINVAL;
+		goto free_request;
+	}
+
+	if (info->attrs[NL802154_ATTR_SCAN_DURATION]) {
+		request->duration = nla_get_u8(info->attrs[NL802154_ATTR_SCAN_DURATION]);
+		if (request->duration > IEEE802154_MAX_SCAN_DURATION) {
+			pr_err("Duration is out of range\n");
+			err = -EINVAL;
+			goto free_request;
+		}
+	} else {
+		/* Use maximum duration order by default */
+		request->duration = IEEE802154_MAX_SCAN_DURATION;
+	}
+
+	if (wpan_dev->netdev)
+		dev_hold(wpan_dev->netdev);
+
+	err = rdev_trigger_scan(rdev, request);
+	if (err) {
+		pr_err("Failure starting scanning (%d)\n", err);
+		goto free_device;
+	}
+
+	return 0;
+
+free_device:
+	if (wpan_dev->netdev)
+		dev_put(wpan_dev->netdev);
+free_request:
+	kfree(request);
+
+	return err;
+}
+
+static int nl802154_prep_scan_msg(struct sk_buff *msg,
+				  struct cfg802154_registered_device *rdev,
+				  struct wpan_dev *wpan_dev, u32 portid,
+				  u32 seq, int flags, u8 cmd, u8 arg)
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
+	if (cmd == NL802154_CMD_SCAN_DONE &&
+	    nla_put_u8(msg, NL802154_ATTR_SCAN_DONE_REASON, arg))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+
+	return -EMSGSIZE;
+}
+
+static int nl802154_send_scan_msg(struct cfg802154_registered_device *rdev,
+				  struct wpan_dev *wpan_dev, u8 cmd, u8 arg)
+{
+	struct sk_buff *msg;
+	int ret;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	ret = nl802154_prep_scan_msg(msg, rdev, wpan_dev, 0, 0, 0, cmd, arg);
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
+int nl802154_scan_started(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev)
+{
+	struct cfg802154_registered_device *rdev = wpan_phy_to_rdev(wpan_phy);
+	int err;
+
+	/* Ignore errors when there are no listeners */
+	err = nl802154_send_scan_msg(rdev, wpan_dev, NL802154_CMD_TRIGGER_SCAN, 0);
+	if (err == -ESRCH)
+		err = 0;
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(nl802154_scan_started);
+
+int nl802154_scan_done(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev,
+		       enum nl802154_scan_done_reasons reason)
+{
+	struct cfg802154_registered_device *rdev = wpan_phy_to_rdev(wpan_phy);
+	int err;
+
+	/* Ignore errors when there are no listeners */
+	err = nl802154_send_scan_msg(rdev, wpan_dev, NL802154_CMD_SCAN_DONE, reason);
+	if (err == -ESRCH)
+		err = 0;
+
+	if (wpan_dev->netdev)
+		dev_put(wpan_dev->netdev);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(nl802154_scan_done);
+
+static int nl802154_abort_scan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg802154_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
+
+	/* Resources are released in the notification helper above */
+	return rdev_abort_scan(rdev, wpan_dev);
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static const struct nla_policy nl802154_dev_addr_policy[NL802154_DEV_ADDR_ATTR_MAX + 1] = {
 	[NL802154_DEV_ADDR_ATTR_PAN_ID] = { .type = NLA_U16 },
@@ -2472,6 +2676,22 @@ static const struct genl_ops nl802154_ops[] = {
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
index 89b805500032..cfa7134be747 100644
--- a/net/ieee802154/nl802154.h
+++ b/net/ieee802154/nl802154.h
@@ -6,5 +6,8 @@ int nl802154_init(void);
 void nl802154_exit(void);
 int nl802154_scan_event(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev,
 			struct ieee802154_coord_desc *desc);
+int nl802154_scan_started(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev);
+int nl802154_scan_done(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev,
+		       enum nl802154_scan_done_reasons reason);
 
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
2.34.1

