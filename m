Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127C448C9BC
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355676AbiALRev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:34:51 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:51011 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355716AbiALReC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:34:02 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 99EBF20002;
        Wed, 12 Jan 2022 17:33:55 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-wireless@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next v2 20/27] net: ieee802154: Add support for beacon requests
Date:   Wed, 12 Jan 2022 18:33:05 +0100
Message-Id: <20220112173312.764660-21-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173312.764660-1-miquel.raynal@bootlin.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
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
index 2118bfc02d7c..ab4d4b7461e6 100644
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
index 22af514dd339..20c46f15cef4 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -65,6 +65,8 @@ enum nl802154_commands {
 	NL802154_CMD_FLUSH_PANS,
 	NL802154_CMD_SET_MAX_PAN_ENTRIES,
 	NL802154_CMD_SET_PANS_EXPIRATION,
+	NL802154_CMD_SEND_BEACONS,
+	NL802154_CMD_STOP_BEACONS,
 
 	/* add new commands above here */
 
@@ -148,6 +150,7 @@ enum nl802154_attrs {
 	NL802154_ATTR_PAN,
 	NL802154_ATTR_MAX_PAN_ENTRIES,
 	NL802154_ATTR_PANS_EXPIRATION,
+	NL802154_ATTR_BEACON_INTERVAL,
 
 	/* add attributes here, update the policy in nl802154.c */
 
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 62591ba7ed44..a5dcc69f0899 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -226,6 +226,7 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 	[NL802154_ATTR_PAN] = { .type = NLA_NESTED },
 	[NL802154_ATTR_MAX_PAN_ENTRIES] = { .type = NLA_U32 },
 	[NL802154_ATTR_PANS_EXPIRATION] = { .type = NLA_U32 },
+	[NL802154_ATTR_BEACON_INTERVAL] = { .type = NLA_U8 },
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	[NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
@@ -1686,6 +1687,70 @@ static int nl802154_set_pans_expiration(struct sk_buff *skb,
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
+		if (request->interval > IEEE802154_ACTIVE_SCAN_DURATION) {
+			pr_err("Interval is out of range\n");
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
@@ -2816,6 +2881,22 @@ static const struct genl_ops nl802154_ops[] = {
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

