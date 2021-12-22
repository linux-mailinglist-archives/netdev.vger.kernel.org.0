Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72C447D4A1
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344085AbhLVP63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:58:29 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36505 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343943AbhLVP6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:58:09 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 0612860013;
        Wed, 22 Dec 2021 15:58:06 +0000 (UTC)
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
Subject: [net-next 15/18] net: ieee802154: Add support for beacon requests
Date:   Wed, 22 Dec 2021 16:57:40 +0100
Message-Id: <20211222155743.256280-16-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155743.256280-1-miquel.raynal@bootlin.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This involves processing beacons requests: starting or stopping
the flow of beacons sent passively on a specific interface. The page and
channel must be changed beforehands if needed. Interval orders above 14
are reserved to tell a device it must answer BEACON_REQ coming from an
active scan procedure (this is not supported yet).

A beacons request structure is created to list the requirements.

Mac layers may now implement the ->send_beacons() and
->stop_beacons() hooks.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h   | 22 +++++++++++
 include/net/nl802154.h    |  3 ++
 net/ieee802154/nl802154.c | 81 +++++++++++++++++++++++++++++++++++++++
 net/ieee802154/rdev-ops.h | 24 ++++++++++++
 net/ieee802154/trace.h    | 21 ++++++++++
 5 files changed, 151 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 292eaf280f01..e4132bd2b636 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -88,6 +88,24 @@ struct cfg802154_scan_request {
 	struct wpan_phy *wpan_phy;
 };
 
+/**
+ * struct cfg802154_beacons_request - beacons request descriptor
+ *
+ * @interval: interval n between sendings, in multiple order of the super frame
+ *            duration: aBaseSuperframeDuration * (2^n) unless the interval
+ *            order is greater or equal to 15, in this case beacons won't be
+ *            passively sent out at a fixed rate but instead inform the device
+ *            that it should answer beacon requests as part of active scan
+ *            procedures
+ * @wpan_dev: the concerned wpan device
+ * @wpan_phy: the wpan phy this was for
+ */
+struct cfg802154_beacons_request {
+	u8 interval;
+	struct wpan_dev *wpan_dev;
+	struct wpan_phy *wpan_phy;
+};
+
 struct cfg802154_ops {
 	struct net_device * (*add_virtual_intf_deprecated)(struct wpan_phy *wpan_phy,
 							   const char *name,
@@ -130,6 +148,10 @@ struct cfg802154_ops {
 				struct cfg802154_scan_request *request);
 	int	(*abort_scan)(struct wpan_phy *wpan_phy,
 			      struct wpan_dev *wpan_dev);
+	int	(*send_beacons)(struct wpan_phy *wpan_phy,
+				struct cfg802154_beacons_request *request);
+	int	(*stop_beacons)(struct wpan_phy *wpan_phy,
+				struct wpan_dev *wpan_dev);
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	void	(*get_llsec_table)(struct wpan_phy *wpan_phy,
 				   struct wpan_dev *wpan_dev,
diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index e185e92d29d6..a20d19b6d0d4 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -63,6 +63,8 @@ enum nl802154_commands {
 	NL802154_CMD_SCAN_DONE,
 	NL802154_CMD_DUMP_PANS,
 	NL802154_CMD_FLUSH_PANS,
+	NL802154_CMD_SEND_BEACONS,
+	NL802154_CMD_STOP_BEACONS,
 
 	/* add new commands above here */
 
@@ -144,6 +146,7 @@ enum nl802154_attrs {
 	NL802154_ATTR_SCAN_CHANNELS,
 	NL802154_ATTR_SCAN_DURATION,
 	NL802154_ATTR_PAN,
+	NL802154_ATTR_BEACON_INTERVAL,
 
 	/* add attributes here, update the policy in nl802154.c */
 
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 8de8f7c31bfe..11112b515a82 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -224,6 +224,7 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 	[NL802154_ATTR_SCAN_CHANNELS] = { .type = NLA_U32, },
 	[NL802154_ATTR_SCAN_DURATION] = { .type = NLA_U8, },
 	[NL802154_ATTR_PAN] = { .type = NLA_NESTED },
+	[NL802154_ATTR_BEACON_INTERVAL] = { .type = NLA_U8, },
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	[NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
@@ -1630,6 +1631,70 @@ static int nl802154_flush_pans(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
+static int
+nl802154_send_beacons(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg802154_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
+	struct wpan_phy *wpan_phy = &rdev->wpan_phy;
+	struct cfg802154_beacons_request *request;
+	int err;
+
+	/* Avoid sending beacons on monitor interfaces */
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
+	if (info->attrs[NL802154_ATTR_BEACON_INTERVAL]) {
+		request->interval = nla_get_u8(info->attrs[NL802154_ATTR_BEACON_INTERVAL]);
+		if (request->interval > IEEE802154_MAX_SCAN_DURATION) {
+			pr_err("Answering active scan requests is not supported yet\n");
+			err = -EINVAL;
+			goto free_request;
+		}
+	} else {
+		/* Use maximum duration order by default */
+		request->interval = IEEE802154_MAX_SCAN_DURATION;
+	}
+
+	err = rdev_send_beacons(rdev, request);
+	if (err) {
+		pr_err("Failure starting sending beacons (%d)\n", err);
+		goto free_request;
+	}
+
+	if (wpan_dev->netdev)
+		dev_hold(wpan_dev->netdev);
+
+free_request:
+	kfree(request);
+
+	return err;
+}
+
+static int
+nl802154_stop_beacons(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg802154_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
+	int err;
+
+	err = rdev_stop_beacons(rdev, wpan_dev);
+
+	if (err != -ESRCH && wpan_dev->netdev)
+		dev_put(wpan_dev->netdev);
+
+	return err;
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static const struct nla_policy nl802154_dev_addr_policy[NL802154_DEV_ADDR_ATTR_MAX + 1] = {
 	[NL802154_DEV_ADDR_ATTR_PAN_ID] = { .type = NLA_U16 },
@@ -2746,6 +2811,22 @@ static const struct genl_ops nl802154_ops[] = {
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
 				  NL802154_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL802154_CMD_SEND_BEACONS,
+		.doit = nl802154_send_beacons,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL802154_FLAG_NEED_NETDEV |
+				  NL802154_FLAG_CHECK_NETDEV_UP |
+				  NL802154_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL802154_CMD_STOP_BEACONS,
+		.doit = nl802154_stop_beacons,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL802154_FLAG_NEED_NETDEV |
+				  NL802154_FLAG_CHECK_NETDEV_UP |
+				  NL802154_FLAG_NEED_RTNL,
+	},
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	{
 		.cmd = NL802154_CMD_SET_SEC_PARAMS,
diff --git a/net/ieee802154/rdev-ops.h b/net/ieee802154/rdev-ops.h
index e171d74c3251..fa85efeaa150 100644
--- a/net/ieee802154/rdev-ops.h
+++ b/net/ieee802154/rdev-ops.h
@@ -237,6 +237,30 @@ static inline int rdev_abort_scan(struct cfg802154_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_send_beacons(struct cfg802154_registered_device *rdev,
+				    struct cfg802154_beacons_request *request)
+{
+	int ret;
+
+	/* TODO: check if this is an FFD? */
+
+	trace_802154_rdev_send_beacons(&rdev->wpan_phy, request);
+	ret = rdev->ops->send_beacons(&rdev->wpan_phy, request);
+	trace_802154_rdev_return_int(&rdev->wpan_phy, ret);
+	return ret;
+}
+
+static inline int rdev_stop_beacons(struct cfg802154_registered_device *rdev,
+				    struct wpan_dev *wpan_dev)
+{
+	int ret;
+
+	trace_802154_rdev_stop_beacons(&rdev->wpan_phy, wpan_dev);
+	ret = rdev->ops->stop_beacons(&rdev->wpan_phy, wpan_dev);
+	trace_802154_rdev_return_int(&rdev->wpan_phy, ret);
+	return ret;
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 /* TODO this is already a nl802154, so move into ieee802154 */
 static inline void
diff --git a/net/ieee802154/trace.h b/net/ieee802154/trace.h
index e5405f737ded..353ba799244f 100644
--- a/net/ieee802154/trace.h
+++ b/net/ieee802154/trace.h
@@ -315,6 +315,22 @@ TRACE_EVENT(802154_rdev_trigger_scan,
 		  WPAN_PHY_PR_ARG, __entry->page, __entry->channels, __entry->duration)
 );
 
+TRACE_EVENT(802154_rdev_send_beacons,
+	TP_PROTO(struct wpan_phy *wpan_phy,
+		 struct cfg802154_beacons_request *request),
+	TP_ARGS(wpan_phy, request),
+	TP_STRUCT__entry(
+		WPAN_PHY_ENTRY
+		__field(u8, interval)
+	),
+	TP_fast_assign(
+		WPAN_PHY_ASSIGN;
+		__entry->interval = request->interval;
+	),
+	TP_printk(WPAN_PHY_PR_FMT ", sending beacons (interval order: %d)",
+		  WPAN_PHY_PR_ARG, __entry->interval)
+);
+
 DECLARE_EVENT_CLASS(802154_wdev_template,
 	TP_PROTO(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev),
 	TP_ARGS(wpan_phy, wpan_dev),
@@ -335,6 +351,11 @@ DEFINE_EVENT(802154_wdev_template, 802154_rdev_abort_scan,
 	TP_ARGS(wpan_phy, wpan_dev)
 );
 
+DEFINE_EVENT(802154_wdev_template, 802154_rdev_stop_beacons,
+	TP_PROTO(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev),
+	TP_ARGS(wpan_phy, wpan_dev)
+);
+
 TRACE_EVENT(802154_rdev_return_int,
 	TP_PROTO(struct wpan_phy *wpan_phy, int ret),
 	TP_ARGS(wpan_phy, ret),
-- 
2.27.0

