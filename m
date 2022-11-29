Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5A363C18A
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbiK2Nz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbiK2Nzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:55:53 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B6A51C28;
        Tue, 29 Nov 2022 05:55:45 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B8041FF813;
        Tue, 29 Nov 2022 13:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669730142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AUFisK7EaI28neJXwaUK5hRQk0bECcs063jYsXYwUAs=;
        b=PzlBontUkudeiS5gjnZqgSlZdkcQjRMjCQkmXQBI0kyLEPugY8Vvmf5J+1wz6P+Su+b5F0
        UuohmT+ASxuIGjqPdPhvuNR5Cp7f4/wZPheeHoJ8SdJv+s3AQvFp6fe5VSPCf8wcpiE/2p
        j8b3Y/ek4hrv9yxSwZuVW6ySg9pQaYneFZxgz1x436E9L0qTrBSAV3JAKTQn7heWAuubPb
        i4afgcoNAsUrxjR3fe1XLs+oWD42+OSFIjN3KuT0sh1K7jXfLG0ukQSKw9ww9w+1hzxhSm
        YY74bZ9kUuaHEl52YA9LU0slTU+KB3saTCfvVkF2V7YyOHZFjSm73xDgP17UyA==
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
Subject: [PATCH wpan-next v3 1/2] ieee802154: Advertize coordinators discovery
Date:   Tue, 29 Nov 2022 14:55:34 +0100
Message-Id: <20221129135535.532513-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129135535.532513-1-miquel.raynal@bootlin.com>
References: <20221129135535.532513-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's introduce the basics for advertizing discovered PANs and
coordinators, which is:
- A new "scan" netlink message group.
- A couple of netlink command/attribute.
- The main netlink helper to send a netlink message with all the
  necessary information to forward the main information to the user.

Two netlink attributes are proactively added to support future UWB
complex channels, but are not actually used yet.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h   |  18 +++++++
 include/net/nl802154.h    |  43 ++++++++++++++++
 net/ieee802154/nl802154.c | 103 ++++++++++++++++++++++++++++++++++++++
 net/ieee802154/nl802154.h |   2 +
 4 files changed, 166 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index e1481f9cf049..d09c393d229f 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -260,6 +260,24 @@ struct ieee802154_addr {
 	};
 };
 
+/**
+ * struct ieee802154_coord_desc - Coordinator descriptor
+ * @addr: PAN ID and coordinator address
+ * @page: page this coordinator is using
+ * @channel: channel this coordinator is using
+ * @superframe_spec: SuperFrame specification as received
+ * @link_quality: link quality indicator at which the beacon was received
+ * @gts_permit: the coordinator accepts GTS requests
+ */
+struct ieee802154_coord_desc {
+	struct ieee802154_addr addr;
+	u8 page;
+	u8 channel;
+	u16 superframe_spec;
+	u8 link_quality;
+	bool gts_permit;
+};
+
 struct ieee802154_llsec_key_id {
 	u8 mode;
 	u8 id;
diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index f5850b569c52..b79a89d5207c 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -72,6 +72,8 @@ enum nl802154_commands {
 	NL802154_CMD_NEW_SEC_LEVEL,
 	NL802154_CMD_DEL_SEC_LEVEL,
 
+	NL802154_CMD_SCAN_EVENT,
+
 	/* add new commands above here */
 
 	/* used to define NL802154_CMD_MAX below */
@@ -131,6 +133,8 @@ enum nl802154_attrs {
 	NL802154_ATTR_PID,
 	NL802154_ATTR_NETNS_FD,
 
+	NL802154_ATTR_COORDINATOR,
+
 	/* add attributes here, update the policy in nl802154.c */
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
@@ -216,6 +220,45 @@ enum nl802154_wpan_phy_capability_attr {
 	NL802154_CAP_ATTR_MAX = __NL802154_CAP_ATTR_AFTER_LAST - 1
 };
 
+/**
+ * enum nl802154_coord - Netlink attributes for a coord
+ *
+ * @__NL802154_COORD_INVALID: invalid
+ * @NL802154_COORD_PANID: PANID of the coordinator (2 bytes)
+ * @NL802154_COORD_ADDR: coordinator address, (8 bytes or 2 bytes)
+ * @NL802154_COORD_CHANNEL: channel number, related to @NL802154_COORD_PAGE (u8)
+ * @NL802154_COORD_PAGE: channel page, related to @NL802154_COORD_CHANNEL (u8)
+ * @NL802154_COORD_PREAMBLE_CODE: Preamble code used when the beacon was received,
+ *	this is PHY dependent and optional (u8)
+ * @NL802154_COORD_MEAN_PRF: Mean PRF used when the beacon was received,
+ *     this is PHY dependent and optional (u8)
+ * @NL802154_COORD_SUPERFRAME_SPEC: superframe specification of the PAN (u16)
+ * @NL802154_COORD_LINK_QUALITY: signal quality of beacon in unspecified units,
+ *	scaled to 0..255 (u8)
+ * @NL802154_COORD_GTS_PERMIT: set to true if GTS is permitted on this PAN
+ * @NL802154_COORD_PAYLOAD_DATA: binary data containing the raw data from the
+ *	frame payload, (only if beacon or probe response had data)
+ * @NL802154_COORD_PAD: attribute used for padding for 64-bit alignment
+ * @NL802154_COORD_MAX: highest coordinator attribute
+ */
+enum nl802154_coord {
+	__NL802154_COORD_INVALID,
+	NL802154_COORD_PANID,
+	NL802154_COORD_ADDR,
+	NL802154_COORD_CHANNEL,
+	NL802154_COORD_PAGE,
+	NL802154_COORD_PREAMBLE_CODE,
+	NL802154_COORD_MEAN_PRF,
+	NL802154_COORD_SUPERFRAME_SPEC,
+	NL802154_COORD_LINK_QUALITY,
+	NL802154_COORD_GTS_PERMIT,
+	NL802154_COORD_PAYLOAD_DATA,
+	NL802154_COORD_PAD,
+
+	/* keep last */
+	NL802154_COORD_MAX,
+};
+
 /**
  * enum nl802154_cca_modes - cca modes
  *
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 38c4f3cb010e..80dc73182785 100644
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
@@ -216,6 +218,9 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 
 	[NL802154_ATTR_PID] = { .type = NLA_U32 },
 	[NL802154_ATTR_NETNS_FD] = { .type = NLA_U32 },
+
+	[NL802154_ATTR_COORDINATOR] = { .type = NLA_NESTED },
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	[NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
 	[NL802154_ATTR_SEC_OUT_LEVEL] = { .type = NLA_U32, },
@@ -1281,6 +1286,104 @@ static int nl802154_wpan_phy_netns(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl802154_prep_scan_event_msg(struct sk_buff *msg,
+					struct cfg802154_registered_device *rdev,
+					struct wpan_dev *wpan_dev,
+					u32 portid, u32 seq, int flags, u8 cmd,
+					struct ieee802154_coord_desc *desc)
+{
+	struct nlattr *nla;
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
+	nla = nla_nest_start_noflag(msg, NL802154_ATTR_COORDINATOR);
+	if (!nla)
+		goto nla_put_failure;
+
+	if (nla_put(msg, NL802154_COORD_PANID, IEEE802154_PAN_ID_LEN,
+		    &desc->addr.pan_id))
+		goto nla_put_failure;
+
+	if (desc->addr.mode == IEEE802154_ADDR_SHORT) {
+		if (nla_put(msg, NL802154_COORD_ADDR,
+			    IEEE802154_SHORT_ADDR_LEN,
+			    &desc->addr.short_addr))
+			goto nla_put_failure;
+	} else {
+		if (nla_put(msg, NL802154_COORD_ADDR,
+			    IEEE802154_EXTENDED_ADDR_LEN,
+			    &desc->addr.extended_addr))
+			goto nla_put_failure;
+	}
+
+	if (nla_put_u8(msg, NL802154_COORD_CHANNEL, desc->channel))
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, NL802154_COORD_PAGE, desc->page))
+		goto nla_put_failure;
+
+	if (nla_put_u16(msg, NL802154_COORD_SUPERFRAME_SPEC,
+			desc->superframe_spec))
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, NL802154_COORD_LINK_QUALITY, desc->link_quality))
+		goto nla_put_failure;
+
+	if (desc->gts_permit && nla_put_flag(msg, NL802154_COORD_GTS_PERMIT))
+		goto nla_put_failure;
+
+	/* TODO: NL802154_COORD_PAYLOAD_DATA if any */
+
+	nla_nest_end(msg, nla);
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
+int nl802154_scan_event(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev,
+			struct ieee802154_coord_desc *desc)
+{
+	struct cfg802154_registered_device *rdev = wpan_phy_to_rdev(wpan_phy);
+	struct sk_buff *msg;
+	int ret;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
+
+	ret = nl802154_prep_scan_event_msg(msg, rdev, wpan_dev, 0, 0, 0,
+					   NL802154_CMD_SCAN_EVENT,
+					   desc);
+	if (ret < 0) {
+		nlmsg_free(msg);
+		return ret;
+	}
+
+	return genlmsg_multicast_netns(&nl802154_fam, wpan_phy_net(wpan_phy),
+				       msg, 0, NL802154_MCGRP_SCAN, GFP_ATOMIC);
+}
+EXPORT_SYMBOL_GPL(nl802154_scan_event);
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static const struct nla_policy nl802154_dev_addr_policy[NL802154_DEV_ADDR_ATTR_MAX + 1] = {
 	[NL802154_DEV_ADDR_ATTR_PAN_ID] = { .type = NLA_U16 },
diff --git a/net/ieee802154/nl802154.h b/net/ieee802154/nl802154.h
index 8c4b6d08954c..89b805500032 100644
--- a/net/ieee802154/nl802154.h
+++ b/net/ieee802154/nl802154.h
@@ -4,5 +4,7 @@
 
 int nl802154_init(void);
 void nl802154_exit(void);
+int nl802154_scan_event(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev,
+			struct ieee802154_coord_desc *desc);
 
 #endif /* __IEEE802154_NL802154_H */
-- 
2.34.1

