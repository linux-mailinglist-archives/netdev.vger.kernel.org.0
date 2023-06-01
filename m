Return-Path: <netdev+bounces-7125-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C2D71A323
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F4CA1C21086
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8654078E;
	Thu,  1 Jun 2023 15:48:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFFE101D6
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:48:40 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559721BE;
	Thu,  1 Jun 2023 08:48:35 -0700 (PDT)
X-GND-Sasl: miquel.raynal@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685634514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aPwJeHjLrbeUM9Jvmot+I8opqGze9XZUNAsjyVR03Tk=;
	b=hTBp7ySad1MEGLS4qoAH9UaC7GvtmMugqdLqpLTAaqlgsPkaFEmP6fewSMu7Pxo/fKlQvl
	K2XLyp1XnwvvV3oVVLfpnNHAPBiaru3i3XWvdlgS+DslKmKi9Qsf0xEhHNeDNazekILko6
	xyGgSME5TJlA1Tr4Wmc8wcoeR5uGlLzmBfIrp4zbFeNQM98BIsszUMHqLCgHt/w6B2soN3
	92V+UO5d8Z6LGa5boPH4dadsTS4AyQapRVszDbEFQK03uRlhs+Ce9+Y7gT5VNiDWNdXx52
	u5pc+WGStimveoSLgSXLg0wcyX0HAfMMtGRdBsSVzpGhr7ODXw+9UefqQ6QdDg==
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id E9C50C0013;
	Thu,  1 Jun 2023 15:48:31 +0000 (UTC)
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	linux-wpan@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org,
	David Girault <david.girault@qorvo.com>,
	Romuald Despres <romuald.despres@qorvo.com>,
	Frederic Blain <frederic.blain@qorvo.com>,
	Nicolas Schodet <nico@ni.fr.eu.org>,
	Guilhem Imberton <guilhem.imberton@qorvo.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 05/11] ieee802154: Add support for user disassociation requests
Date: Thu,  1 Jun 2023 17:48:11 +0200
Message-Id: <20230601154817.754519-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230601154817.754519-1-miquel.raynal@bootlin.com>
References: <20230601154817.754519-1-miquel.raynal@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A device may decide at some point to disassociate from a PAN, let's
introduce a netlink command for this purpose.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h         |  3 +++
 include/net/ieee802154_netdev.h | 11 +++++++++
 include/net/nl802154.h          |  1 +
 net/ieee802154/nl802154.c       | 41 +++++++++++++++++++++++++++++++++
 net/ieee802154/rdev-ops.h       | 15 ++++++++++++
 net/ieee802154/trace.h          | 19 +++++++++++++++
 6 files changed, 90 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index dd0964d351cd..01bc6c2da7b9 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -81,6 +81,9 @@ struct cfg802154_ops {
 	int	(*associate)(struct wpan_phy *wpan_phy,
 			     struct wpan_dev *wpan_dev,
 			     struct ieee802154_addr *coord);
+	int	(*disassociate)(struct wpan_phy *wpan_phy,
+				struct wpan_dev *wpan_dev,
+				struct ieee802154_addr *target);
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	void	(*get_llsec_table)(struct wpan_phy *wpan_phy,
 				   struct wpan_dev *wpan_dev,
diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index e26ffd079556..16194356cfe7 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -177,6 +177,11 @@ enum ieee802154_association_status {
 	IEEE802154_FAST_ASSOCIATION_SUCCESSFUL = 0x80,
 };
 
+enum ieee802154_disassociation_reason {
+	IEEE802154_COORD_WISHES_DEVICE_TO_LEAVE = 0x1,
+	IEEE802154_DEVICE_WISHES_TO_LEAVE = 0x2,
+};
+
 struct ieee802154_hdr {
 	struct ieee802154_hdr_fc fc;
 	u8 seq;
@@ -206,6 +211,12 @@ struct ieee802154_association_req_frame {
 	struct ieee802154_assoc_req_pl assoc_req_pl;
 };
 
+struct ieee802154_disassociation_notif_frame {
+	struct ieee802154_hdr mhr;
+	struct ieee802154_mac_cmd_pl mac_pl;
+	u8 disassoc_pl;
+};
+
 /* pushes hdr onto the skb. fields of hdr->fc that can be calculated from
  * the contents of hdr will be, and the actual value of those bits in
  * hdr->fc will be ignored. this includes the INTRA_PAN bit and the frame
diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index 830e1c51d3df..8a47c14c72f0 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -79,6 +79,7 @@ enum nl802154_commands {
 	NL802154_CMD_SEND_BEACONS,
 	NL802154_CMD_STOP_BEACONS,
 	NL802154_CMD_ASSOCIATE,
+	NL802154_CMD_DISASSOCIATE,
 
 	/* add new commands above here */
 
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 2c28e0e9fdda..5820fe425ddd 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1663,6 +1663,39 @@ static int nl802154_associate(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl802154_disassociate(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg802154_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
+	struct wpan_phy *wpan_phy = &rdev->wpan_phy;
+	struct ieee802154_addr target;
+
+	if (wpan_phy->flags & WPAN_PHY_FLAG_DATAGRAMS_ONLY) {
+		NL_SET_ERR_MSG(info->extack, "PHY only supports datagrams");
+		return -EOPNOTSUPP;
+	}
+
+	target.pan_id = wpan_dev->pan_id;
+
+	if (info->attrs[NL802154_ATTR_EXTENDED_ADDR]) {
+		target.mode = IEEE802154_ADDR_LONG;
+		target.extended_addr = nla_get_le64(info->attrs[NL802154_ATTR_EXTENDED_ADDR]);
+	} else if (info->attrs[NL802154_ATTR_SHORT_ADDR]) {
+		target.mode = IEEE802154_ADDR_SHORT;
+		target.short_addr = nla_get_le16(info->attrs[NL802154_ATTR_SHORT_ADDR]);
+	} else {
+		NL_SET_ERR_MSG(info->extack, "Device address is missing");
+		return -EINVAL;
+	}
+
+	mutex_lock(&wpan_dev->association_lock);
+	rdev_disassociate(rdev, wpan_dev, &target);
+	mutex_unlock(&wpan_dev->association_lock);
+
+	return 0;
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static const struct nla_policy nl802154_dev_addr_policy[NL802154_DEV_ADDR_ATTR_MAX + 1] = {
 	[NL802154_DEV_ADDR_ATTR_PAN_ID] = { .type = NLA_U16 },
@@ -2792,6 +2825,14 @@ static const struct genl_ops nl802154_ops[] = {
 				  NL802154_FLAG_CHECK_NETDEV_UP |
 				  NL802154_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL802154_CMD_DISASSOCIATE,
+		.doit = nl802154_disassociate,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL802154_FLAG_NEED_NETDEV |
+				  NL802154_FLAG_CHECK_NETDEV_UP |
+				  NL802154_FLAG_NEED_RTNL,
+	},
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	{
 		.cmd = NL802154_CMD_SET_SEC_PARAMS,
diff --git a/net/ieee802154/rdev-ops.h b/net/ieee802154/rdev-ops.h
index 4843d52f1ee0..64071ef6f57b 100644
--- a/net/ieee802154/rdev-ops.h
+++ b/net/ieee802154/rdev-ops.h
@@ -280,6 +280,21 @@ static inline int rdev_associate(struct cfg802154_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_disassociate(struct cfg802154_registered_device *rdev,
+				    struct wpan_dev *wpan_dev,
+				    struct ieee802154_addr *target)
+{
+	int ret;
+
+	if (!rdev->ops->disassociate)
+		return -EOPNOTSUPP;
+
+	trace_802154_rdev_disassociate(&rdev->wpan_phy, wpan_dev, target);
+	ret = rdev->ops->disassociate(&rdev->wpan_phy, wpan_dev, target);
+	trace_802154_rdev_return_int(&rdev->wpan_phy, ret);
+	return ret;
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 /* TODO this is already a nl802154, so move into ieee802154 */
 static inline void
diff --git a/net/ieee802154/trace.h b/net/ieee802154/trace.h
index fb24be6bfb03..cd1e4a0ff275 100644
--- a/net/ieee802154/trace.h
+++ b/net/ieee802154/trace.h
@@ -375,6 +375,25 @@ TRACE_EVENT(802154_rdev_associate,
 		  WPAN_PHY_PR_ARG, WPAN_DEV_PR_ARG, __entry->addr)
 );
 
+TRACE_EVENT(802154_rdev_disassociate,
+	TP_PROTO(struct wpan_phy *wpan_phy,
+		 struct wpan_dev *wpan_dev,
+		 struct ieee802154_addr *target),
+	TP_ARGS(wpan_phy, wpan_dev, target),
+	TP_STRUCT__entry(
+		WPAN_PHY_ENTRY
+		WPAN_DEV_ENTRY
+		__field(__le64, addr)
+	),
+	TP_fast_assign(
+		WPAN_PHY_ASSIGN;
+		WPAN_DEV_ASSIGN;
+		__entry->addr = target->extended_addr;
+	),
+	TP_printk(WPAN_PHY_PR_FMT ", " WPAN_DEV_PR_FMT ", disassociating with: 0x%llx",
+		  WPAN_PHY_PR_ARG, WPAN_DEV_PR_ARG, __entry->addr)
+);
+
 TRACE_EVENT(802154_rdev_return_int,
 	TP_PROTO(struct wpan_phy *wpan_phy, int ret),
 	TP_ARGS(wpan_phy, ret),
-- 
2.34.1


