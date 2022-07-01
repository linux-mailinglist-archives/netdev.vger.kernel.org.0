Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1D35635CB
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiGAOgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiGAOfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:35:47 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C312A70C;
        Fri,  1 Jul 2022 07:31:22 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3CC24FF814;
        Fri,  1 Jul 2022 14:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m+RNUVD1Oo2744JVgueAisSytygO/FBP/lUp2LA+8f8=;
        b=jVtqoKht2tfnOBxYhYFrJVpEtZh0USBTOGPGgRCjaJ/yut97SzG1Bx/gxg2DehBmcHqyc+
        tKbBfHq5QlXGJl6uiGymL4bXP6rWJXlUZgncoIW2faZfy3BUHYv5RTKb0vcgRmwr+18cws
        aq09ytPFY5L7OSQOhA4JPrOr9/DIJY9hauVszf/0sj4wJQv3jeafcgENvKC4wscESoDq6J
        tY++XTnImO+ZiElTjfXM/Po0CGgk1Hdjqi8Xk5Z5XPNBpa87Lv4HCc/xdSf8+6o/5e3cQI
        ktJePQvLOZqctDDzlD8HH8ps0ad35G6RHxyBh+1UUcwQ393LmfryOk0Lw8P32A==
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 11/20] net: ieee802154: Add support for user beaconing requests
Date:   Fri,  1 Jul 2022 16:30:43 +0200
Message-Id: <20220701143052.1267509-12-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 net/ieee802154/nl802154.c | 96 +++++++++++++++++++++++++++++++++++++++
 net/ieee802154/nl802154.h |  2 +
 net/ieee802154/rdev-ops.h | 28 ++++++++++++
 net/ieee802154/trace.h    | 21 +++++++++
 6 files changed, 173 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 206283fd4b72..d6ff60d900a9 100644
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
@@ -300,6 +305,24 @@ struct cfg802154_scan_request {
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
index 0e5934494990..244852bc65e0 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -62,6 +62,8 @@ enum nl802154_commands {
 	NL802154_CMD_TRIGGER_SCAN,
 	NL802154_CMD_ABORT_SCAN,
 	NL802154_CMD_SCAN_DONE,
+	NL802154_CMD_SEND_BEACONS,
+	NL802154_CMD_STOP_BEACONS,
 
 	/* add new commands above here */
 
@@ -143,6 +145,7 @@ enum nl802154_attrs {
 	NL802154_ATTR_SCAN_FLAGS,
 	NL802154_ATTR_SCAN_CHANNELS,
 	NL802154_ATTR_SCAN_DURATION,
+	NL802154_ATTR_BEACON_INTERVAL,
 
 	/* add attributes here, update the policy in nl802154.c */
 
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 19b97bc9ddeb..ff8069415e67 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -224,6 +224,7 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 	[NL802154_ATTR_SCAN_TYPE] = { .type = NLA_U8 },
 	[NL802154_ATTR_SCAN_CHANNELS] = { .type = NLA_U32 },
 	[NL802154_ATTR_SCAN_DURATION] = { .type = NLA_U8 },
+	[NL802154_ATTR_BEACON_INTERVAL] = { .type = NLA_U8 },
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	[NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
@@ -1564,6 +1565,85 @@ static int nl802154_abort_scan(struct sk_buff *skb, struct genl_info *info)
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
+void nl802154_end_beaconing(struct wpan_dev *wpan_dev,
+			    struct cfg802154_beacon_request *request)
+{
+	kfree(request);
+
+	if (wpan_dev->netdev)
+		dev_put(wpan_dev->netdev);
+}
+EXPORT_SYMBOL_GPL(nl802154_end_beaconing);
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
@@ -2668,6 +2748,22 @@ static const struct genl_ops nl802154_ops[] = {
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
index 961e2ac86c8c..5ae96fe89138 100644
--- a/net/ieee802154/nl802154.h
+++ b/net/ieee802154/nl802154.h
@@ -9,5 +9,7 @@ int nl802154_advertise_new_coordinator(struct wpan_phy *wpan_phy,
 				       struct ieee802154_coord_desc *desc);
 int nl802154_send_scan_done(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev,
 			    struct cfg802154_scan_request *request);
+void nl802154_end_beaconing(struct wpan_dev *wpan_dev,
+			    struct cfg802154_beacon_request *request);
 
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
index d193f66ae0c7..68a1f6e66a93 100644
--- a/net/ieee802154/trace.h
+++ b/net/ieee802154/trace.h
@@ -340,6 +340,22 @@ TRACE_EVENT(802154_rdev_trigger_scan,
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
@@ -360,6 +376,11 @@ DEFINE_EVENT(802154_wdev_template, 802154_rdev_abort_scan,
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

