Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD5567AFB0
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbjAYK3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbjAYK3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:29:32 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BE0A241;
        Wed, 25 Jan 2023 02:29:30 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 07CD724000B;
        Wed, 25 Jan 2023 10:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1674642568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aC/xGj9ciqITGbVmd8ttUJbgCEsC4gTNq7eorxRDc+M=;
        b=SIqz3vFIIRWGqnH+fBebFx0qktYBkIXsHb7LgnRrBFOPVy3oQlTAQXDnQ3b50n4ofJ9j6i
        EExTAvvOD3vaDKtda9gExkLvy2bYdGeSKZYV+qf1wNeH/6GCJph21pB/glmItki2Loj/Z5
        ud2Ca6g/bwzAiypALCaHL2B/v9denBi20OVu6RDS+xszhjRj7zQi4FQ8oXZJ95ny/01rbB
        DCoIz2PATDv7iAOmDhC7ET+H0pE097poyZPBrnkKmp7mp7Tou48w80T/MRUz8k13XlDzND
        7PaGxvZ1NpVEFLZEbZQpR1Kb2+AMShFsd2mgOVYKs3nsmPFnkbRRIwMcnXARpg==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 1/2] ieee802154: Add support for user beaconing requests
Date:   Wed, 25 Jan 2023 11:29:22 +0100
Message-Id: <20230125102923.135465-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230125102923.135465-1-miquel.raynal@bootlin.com>
References: <20230125102923.135465-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parse user requests for sending beacons, start sending beacons at a
regular pace. If needed, the pace can be updated with a new request. The
process can also be interrupted at any moment.

The page and channel must be changed beforehands if needed. Interval
orders above 14 are reserved to tell a device it must answer BEACON_REQ
coming from another device as part of an active scan procedure and this
is not yet supported.

A netlink "beacon request" structure is created to list the
requirements.

Mac layers may now implement the ->send_beacons() and
->stop_beacons() hooks.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h   | 23 ++++++++++
 include/net/nl802154.h    |  3 ++
 net/ieee802154/nl802154.c | 93 +++++++++++++++++++++++++++++++++++++++
 net/ieee802154/nl802154.h |  1 +
 net/ieee802154/rdev-ops.h | 28 ++++++++++++
 net/ieee802154/trace.h    | 21 +++++++++
 6 files changed, 169 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 0b0f81a945b6..0c2778a836db 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -19,6 +19,7 @@
 struct wpan_phy;
 struct wpan_phy_cca;
 struct cfg802154_scan_request;
+struct cfg802154_beacon_request;
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 struct ieee802154_llsec_device_key;
@@ -72,6 +73,10 @@ struct cfg802154_ops {
 				struct cfg802154_scan_request *request);
 	int	(*abort_scan)(struct wpan_phy *wpan_phy,
 			      struct wpan_dev *wpan_dev);
+	int	(*send_beacons)(struct wpan_phy *wpan_phy,
+				struct cfg802154_beacon_request *request);
+	int	(*stop_beacons)(struct wpan_phy *wpan_phy,
+				struct wpan_dev *wpan_dev);
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	void	(*get_llsec_table)(struct wpan_phy *wpan_phy,
 				   struct wpan_dev *wpan_dev,
@@ -314,6 +319,24 @@ struct cfg802154_scan_request {
 	struct wpan_phy *wpan_phy;
 };
 
+/**
+ * struct cfg802154_beacon_request - Beacon request descriptor
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
+struct cfg802154_beacon_request {
+	u8 interval;
+	struct wpan_dev *wpan_dev;
+	struct wpan_phy *wpan_phy;
+};
+
 /**
  * struct cfg802154_mac_pkt - MAC packet descriptor (beacon/command)
  * @node: MAC packets to process list member
diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index c267fa1c5aac..8cd9d141f5af 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -76,6 +76,8 @@ enum nl802154_commands {
 	NL802154_CMD_TRIGGER_SCAN,
 	NL802154_CMD_ABORT_SCAN,
 	NL802154_CMD_SCAN_DONE,
+	NL802154_CMD_SEND_BEACONS,
+	NL802154_CMD_STOP_BEACONS,
 
 	/* add new commands above here */
 
@@ -144,6 +146,7 @@ enum nl802154_attrs {
 	NL802154_ATTR_SCAN_MEAN_PRF,
 	NL802154_ATTR_SCAN_DURATION,
 	NL802154_ATTR_SCAN_DONE_REASON,
+	NL802154_ATTR_BEACON_INTERVAL,
 
 	/* add attributes here, update the policy in nl802154.c */
 
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 1d703251f74a..0d9becd678e3 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -227,6 +227,7 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 	[NL802154_ATTR_SCAN_MEAN_PRF] = { .type = NLA_U8 },
 	[NL802154_ATTR_SCAN_DURATION] = { .type = NLA_U8 },
 	[NL802154_ATTR_SCAN_DONE_REASON] = { .type = NLA_U8 },
+	[NL802154_ATTR_BEACON_INTERVAL] = { .type = NLA_U8 },
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	[NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
@@ -1587,6 +1588,82 @@ static int nl802154_abort_scan(struct sk_buff *skb, struct genl_info *info)
 	return rdev_abort_scan(rdev, wpan_dev);
 }
 
+static int
+nl802154_send_beacons(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg802154_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
+	struct wpan_phy *wpan_phy = &rdev->wpan_phy;
+	struct cfg802154_beacon_request *request;
+	int err;
+
+	/* Only coordinators can send beacons */
+	if (wpan_dev->iftype != NL802154_IFTYPE_COORD)
+		return -EOPNOTSUPP;
+
+	if (wpan_dev->pan_id == cpu_to_le16(IEEE802154_PANID_BROADCAST)) {
+		pr_err("Device is not part of any PAN\n");
+		return -EPERM;
+	}
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
+			pr_err("Interval is out of range\n");
+			err = -EINVAL;
+			goto free_request;
+		}
+	} else {
+		/* Use maximum duration order by default */
+		request->interval = IEEE802154_MAX_SCAN_DURATION;
+	}
+
+	if (wpan_dev->netdev)
+		dev_hold(wpan_dev->netdev);
+
+	err = rdev_send_beacons(rdev, request);
+	if (err) {
+		pr_err("Failure starting sending beacons (%d)\n", err);
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
+void nl802154_beaconing_done(struct wpan_dev *wpan_dev)
+{
+	if (wpan_dev->netdev)
+		dev_put(wpan_dev->netdev);
+}
+EXPORT_SYMBOL_GPL(nl802154_beaconing_done);
+
+static int
+nl802154_stop_beacons(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg802154_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
+
+	/* Resources are released in the notification helper above */
+	return rdev_stop_beacons(rdev, wpan_dev);
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static const struct nla_policy nl802154_dev_addr_policy[NL802154_DEV_ADDR_ATTR_MAX + 1] = {
 	[NL802154_DEV_ADDR_ATTR_PAN_ID] = { .type = NLA_U16 },
@@ -2691,6 +2768,22 @@ static const struct genl_ops nl802154_ops[] = {
 				  NL802154_FLAG_CHECK_NETDEV_UP |
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
diff --git a/net/ieee802154/nl802154.h b/net/ieee802154/nl802154.h
index cfa7134be747..d69d950f9a6a 100644
--- a/net/ieee802154/nl802154.h
+++ b/net/ieee802154/nl802154.h
@@ -9,5 +9,6 @@ int nl802154_scan_event(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev,
 int nl802154_scan_started(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev);
 int nl802154_scan_done(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev,
 		       enum nl802154_scan_done_reasons reason);
+void nl802154_beaconing_done(struct wpan_dev *wpan_dev);
 
 #endif /* __IEEE802154_NL802154_H */
diff --git a/net/ieee802154/rdev-ops.h b/net/ieee802154/rdev-ops.h
index e171d74c3251..5eaae15c610e 100644
--- a/net/ieee802154/rdev-ops.h
+++ b/net/ieee802154/rdev-ops.h
@@ -237,6 +237,34 @@ static inline int rdev_abort_scan(struct cfg802154_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_send_beacons(struct cfg802154_registered_device *rdev,
+				    struct cfg802154_beacon_request *request)
+{
+	int ret;
+
+	if (!rdev->ops->send_beacons)
+		return -EOPNOTSUPP;
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
+	if (!rdev->ops->stop_beacons)
+		return -EOPNOTSUPP;
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
index e5405f737ded..e5d8439b9e45 100644
--- a/net/ieee802154/trace.h
+++ b/net/ieee802154/trace.h
@@ -315,6 +315,22 @@ TRACE_EVENT(802154_rdev_trigger_scan,
 		  WPAN_PHY_PR_ARG, __entry->page, __entry->channels, __entry->duration)
 );
 
+TRACE_EVENT(802154_rdev_send_beacons,
+	TP_PROTO(struct wpan_phy *wpan_phy,
+		 struct cfg802154_beacon_request *request),
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
2.34.1

