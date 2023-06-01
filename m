Return-Path: <netdev+bounces-7123-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE28871A31E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:49:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B35EF2817BC
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B22B22D61;
	Thu,  1 Jun 2023 15:48:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6866E101D6
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:48:34 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B606219A;
	Thu,  1 Jun 2023 08:48:30 -0700 (PDT)
X-GND-Sasl: miquel.raynal@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685634509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EZe2/T8kPAkwouhlB17HaC1fAOuLxz7XbMujQ+AS4Sw=;
	b=MFqm4/4fgSLMmDWSdsYpSY8x30TMqwl/DEGQcXPi13n67y6CbuFiABbzuWWZPmfu6FJfw+
	9vxsbSTLlLMAQJG61m2IymrNFCbJNJGK7wB992z9Q04ViBzzXLu59vWvYFjZI8hHOsucZ2
	kgMvT8gtyQMaU/3X26Fuzd5HjrnpeF059/dqCjuFD6/W82eLDFj9bA1OjExgArvV4QYiaC
	8v+F5sAV0VBDQILunSCQCXSINFzogcqweIUBsVePQB1+Vdp6f8N0rBDRhVvuGDMS4RxBBo
	xOwCogPT7hEBa5vnOZlOFvfHlA4R0WPzV7wQXcNM1rZ30lhMdDr/5gO6iPVATg==
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
Received: by mail.gandi.net (Postfix) with ESMTPSA id 59DA7C000F;
	Thu,  1 Jun 2023 15:48:27 +0000 (UTC)
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
Subject: [PATCH wpan-next 03/11] ieee802154: Add support for user association requests
Date: Thu,  1 Jun 2023 17:48:09 +0200
Message-Id: <20230601154817.754519-4-miquel.raynal@bootlin.com>
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

Users may decide to associate with a peer, which becomes our parent
coordinator. Let's add the necessary netlink support for this.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h         |  4 +++
 include/net/ieee802154_netdev.h | 38 +++++++++++++++++++++++++++++
 include/net/nl802154.h          |  1 +
 net/ieee802154/nl802154.c       | 43 +++++++++++++++++++++++++++++++++
 net/ieee802154/rdev-ops.h       | 15 ++++++++++++
 net/ieee802154/trace.h          | 19 +++++++++++++++
 6 files changed, 120 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index c67adf584672..3b9d65455b9a 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -20,6 +20,7 @@ struct wpan_phy;
 struct wpan_phy_cca;
 struct cfg802154_scan_request;
 struct cfg802154_beacon_request;
+struct ieee802154_addr;
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 struct ieee802154_llsec_device_key;
@@ -77,6 +78,9 @@ struct cfg802154_ops {
 				struct cfg802154_beacon_request *request);
 	int	(*stop_beacons)(struct wpan_phy *wpan_phy,
 				struct wpan_dev *wpan_dev);
+	int	(*associate)(struct wpan_phy *wpan_phy,
+			     struct wpan_dev *wpan_dev,
+			     struct ieee802154_addr *coord);
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	void	(*get_llsec_table)(struct wpan_phy *wpan_phy,
 				   struct wpan_dev *wpan_dev,
diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index 063313df447d..ca8c827d0d7f 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -125,6 +125,30 @@ struct ieee802154_hdr_fc {
 #endif
 };
 
+struct ieee802154_assoc_req_pl {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	u8 reserved1:1,
+	   device_type:1,
+	   power_source:1,
+	   rx_on_when_idle:1,
+	   assoc_type:1,
+	   reserved2:1,
+	   security_cap:1,
+	   alloc_addr:1;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	u8 alloc_addr:1,
+	   security_cap:1,
+	   reserved2:1,
+	   assoc_type:1,
+	   rx_on_when_idle:1,
+	   power_source:1,
+	   device_type:1,
+	   reserved1:1;
+#else
+#error	"Please fix <asm/byteorder.h>"
+#endif
+} __packed;
+
 enum ieee802154_frame_version {
 	IEEE802154_2003_STD,
 	IEEE802154_2006_STD,
@@ -140,6 +164,14 @@ enum ieee802154_addressing_mode {
 	IEEE802154_EXTENDED_ADDRESSING,
 };
 
+enum ieee802154_association_status {
+	IEEE802154_ASSOCIATION_SUCCESSFUL = 0x00,
+	IEEE802154_PAN_AT_CAPACITY = 0x01,
+	IEEE802154_PAN_ACCESS_DENIED = 0x02,
+	IEEE802154_HOPPING_SEQUENCE_OFFSET_DUP = 0x03,
+	IEEE802154_FAST_ASSOCIATION_SUCCESSFUL = 0x80,
+};
+
 struct ieee802154_hdr {
 	struct ieee802154_hdr_fc fc;
 	u8 seq;
@@ -163,6 +195,12 @@ struct ieee802154_beacon_req_frame {
 	struct ieee802154_mac_cmd_pl mac_pl;
 };
 
+struct ieee802154_association_req_frame {
+	struct ieee802154_hdr mhr;
+	struct ieee802154_mac_cmd_pl mac_pl;
+	struct ieee802154_assoc_req_pl assoc_req_pl;
+};
+
 /* pushes hdr onto the skb. fields of hdr->fc that can be calculated from
  * the contents of hdr will be, and the actual value of those bits in
  * hdr->fc will be ignored. this includes the INTRA_PAN bit and the frame
diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index 8cd9d141f5af..830e1c51d3df 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -78,6 +78,7 @@ enum nl802154_commands {
 	NL802154_CMD_SCAN_DONE,
 	NL802154_CMD_SEND_BEACONS,
 	NL802154_CMD_STOP_BEACONS,
+	NL802154_CMD_ASSOCIATE,
 
 	/* add new commands above here */
 
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 46ac6f599fe1..2c28e0e9fdda 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1628,6 +1628,41 @@ nl802154_stop_beacons(struct sk_buff *skb, struct genl_info *info)
 	return rdev_stop_beacons(rdev, wpan_dev);
 }
 
+static int nl802154_associate(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg802154_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wpan_dev *wpan_dev;
+	struct wpan_phy *wpan_phy;
+	struct ieee802154_addr coord;
+	int err;
+
+	wpan_dev = dev->ieee802154_ptr;
+	wpan_phy = &rdev->wpan_phy;
+
+	if (wpan_phy->flags & WPAN_PHY_FLAG_DATAGRAMS_ONLY) {
+		NL_SET_ERR_MSG(info->extack, "PHY only supports datagrams");
+		return -EOPNOTSUPP;
+	}
+
+	if (!info->attrs[NL802154_ATTR_PAN_ID] ||
+	    !info->attrs[NL802154_ATTR_EXTENDED_ADDR])
+		return -EINVAL;
+
+	coord.pan_id = nla_get_le16(info->attrs[NL802154_ATTR_PAN_ID]);
+	coord.mode = IEEE802154_ADDR_LONG;
+	coord.extended_addr = nla_get_le64(info->attrs[NL802154_ATTR_EXTENDED_ADDR]);
+
+	mutex_lock(&wpan_dev->association_lock);
+	err = rdev_associate(rdev, wpan_dev, &coord);
+	mutex_unlock(&wpan_dev->association_lock);
+	if (err)
+		pr_err("Association with PAN ID 0x%x failed (%d)\n",
+		       le16_to_cpu(coord.pan_id), err);
+
+	return err;
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static const struct nla_policy nl802154_dev_addr_policy[NL802154_DEV_ADDR_ATTR_MAX + 1] = {
 	[NL802154_DEV_ADDR_ATTR_PAN_ID] = { .type = NLA_U16 },
@@ -2749,6 +2784,14 @@ static const struct genl_ops nl802154_ops[] = {
 				  NL802154_FLAG_CHECK_NETDEV_UP |
 				  NL802154_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL802154_CMD_ASSOCIATE,
+		.doit = nl802154_associate,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL802154_FLAG_NEED_NETDEV |
+				  NL802154_FLAG_CHECK_NETDEV_UP |
+				  NL802154_FLAG_NEED_RTNL,
+	},
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	{
 		.cmd = NL802154_CMD_SET_SEC_PARAMS,
diff --git a/net/ieee802154/rdev-ops.h b/net/ieee802154/rdev-ops.h
index 5eaae15c610e..4843d52f1ee0 100644
--- a/net/ieee802154/rdev-ops.h
+++ b/net/ieee802154/rdev-ops.h
@@ -265,6 +265,21 @@ static inline int rdev_stop_beacons(struct cfg802154_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_associate(struct cfg802154_registered_device *rdev,
+				 struct wpan_dev *wpan_dev,
+				 struct ieee802154_addr *coord)
+{
+	int ret;
+
+	if (!rdev->ops->associate)
+		return -EOPNOTSUPP;
+
+	trace_802154_rdev_associate(&rdev->wpan_phy, wpan_dev, coord);
+	ret = rdev->ops->associate(&rdev->wpan_phy, wpan_dev, coord);
+	trace_802154_rdev_return_int(&rdev->wpan_phy, ret);
+	return ret;
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 /* TODO this is already a nl802154, so move into ieee802154 */
 static inline void
diff --git a/net/ieee802154/trace.h b/net/ieee802154/trace.h
index e5d8439b9e45..fb24be6bfb03 100644
--- a/net/ieee802154/trace.h
+++ b/net/ieee802154/trace.h
@@ -356,6 +356,25 @@ DEFINE_EVENT(802154_wdev_template, 802154_rdev_stop_beacons,
 	TP_ARGS(wpan_phy, wpan_dev)
 );
 
+TRACE_EVENT(802154_rdev_associate,
+	TP_PROTO(struct wpan_phy *wpan_phy,
+		 struct wpan_dev *wpan_dev,
+		 struct ieee802154_addr *coord),
+	TP_ARGS(wpan_phy, wpan_dev, coord),
+	TP_STRUCT__entry(
+		WPAN_PHY_ENTRY
+		WPAN_DEV_ENTRY
+		__field(__le64, addr)
+	),
+	TP_fast_assign(
+		WPAN_PHY_ASSIGN;
+		WPAN_DEV_ASSIGN;
+		__entry->addr = coord->extended_addr;
+	),
+	TP_printk(WPAN_PHY_PR_FMT ", " WPAN_DEV_PR_FMT ", associating with: 0x%llx",
+		  WPAN_PHY_PR_ARG, WPAN_DEV_PR_ARG, __entry->addr)
+);
+
 TRACE_EVENT(802154_rdev_return_int,
 	TP_PROTO(struct wpan_phy *wpan_phy, int ret),
 	TP_ARGS(wpan_phy, ret),
-- 
2.34.1


