Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EB55635B5
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiGAOfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiGAOfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:35:33 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B3B6F37E;
        Fri,  1 Jul 2022 07:31:02 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5C57CFF80C;
        Fri,  1 Jul 2022 14:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y0ifMPMPQOBHGseT2lZWhMANusf33IX8WYklgLPB8fk=;
        b=F3ZSouYOaxuWbUhI/oguZy8dulRdbDw1MHwM97eKbUxSDeQHjAV+g6BVnwEqd59lvuxrMt
        9M3qm8F0yYftCEwV1XKWoxmHFJbV3hJL8mCkaYz5jeq21sM9qOoTyXfbpeqse2vMnMSAXg
        kyk8BWeoxIF92/Vr7kREM+TwHjuQPjSmQBKLN3XbfEKyhBDIOi8hIkvs6tWy6ZC23mRe+C
        rZ+hvcfmv8peUWaUa1o0qczDDfbXgNX58o99xkIVgvbzdue9FkET0PZCvszzZ7M2P9rc/C
        pC9Y0MxGATK8ltEJfsp3gVsbZ1WtfNKRYmv9BJdnn+0IHllIhb0M8s/t8ZwlxA==
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
Subject: [PATCH wpan-next 02/20] net: ieee802154: Advertize coordinators discovery
Date:   Fri,  1 Jul 2022 16:30:34 +0200
Message-Id: <20220701143052.1267509-3-miquel.raynal@bootlin.com>
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

Let's introduce the basics for advertizing discovered PANs and
coordinators, which is:
- A new "scan" netlink message group.
- A couple of netlink command/attribute.
- The main netlink helper to send a netlink message with all the
  necessary information to forward the main information to the user.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h   |  20 ++++++++
 include/net/nl802154.h    |  43 ++++++++++++++++
 net/ieee802154/nl802154.c | 102 ++++++++++++++++++++++++++++++++++++++
 net/ieee802154/nl802154.h |   3 ++
 4 files changed, 168 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 04b996895fc1..1f1b275dcabd 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -255,6 +255,26 @@ struct ieee802154_addr {
 	};
 };
 
+/**
+ * struct ieee802154_coord_desc - Coordinator descriptor
+ * @coord: PAN ID and coordinator address
+ * @page: page this coordinator is using
+ * @channel: channel this coordinator is using
+ * @superframe_spec: SuperFrame specification as received
+ * @link_quality: link quality indicator at which the beacon was received
+ * @gts_permit: the coordinator accepts GTS requests
+ * @node: list item
+ */
+struct ieee802154_coord_desc {
+	struct ieee802154_addr *addr;
+	u8 page;
+	u8 channel;
+	u16 superframe_spec;
+	u8 link_quality;
+	bool gts_permit;
+	struct list_head node;
+};
+
 struct ieee802154_llsec_key_id {
 	u8 mode;
 	u8 id;
diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index 145acb8f2509..dba05553d106 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -58,6 +58,8 @@ enum nl802154_commands {
 
 	NL802154_CMD_SET_WPAN_PHY_NETNS,
 
+	NL802154_CMD_NEW_COORDINATOR,
+
 	/* add new commands above here */
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
@@ -133,6 +135,8 @@ enum nl802154_attrs {
 	NL802154_ATTR_PID,
 	NL802154_ATTR_NETNS_FD,
 
+	NL802154_ATTR_COORDINATOR,
+
 	/* add attributes here, update the policy in nl802154.c */
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
@@ -218,6 +222,45 @@ enum nl802154_wpan_phy_capability_attr {
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
index e0b072aecf0f..7c0aec10ef7f 100644
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
@@ -1281,6 +1286,103 @@ static int nl802154_wpan_phy_netns(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl802154_prep_new_coord_msg(struct sk_buff *msg,
+				       struct cfg802154_registered_device *rdev,
+				       struct wpan_dev *wpan_dev,
+				       u32 portid, u32 seq, int flags, u8 cmd,
+				       struct ieee802154_coord_desc *desc)
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
+		    &desc->addr->pan_id))
+		goto nla_put_failure;
+
+	if (desc->addr->mode == IEEE802154_ADDR_SHORT) {
+		if (nla_put(msg, NL802154_COORD_ADDR,
+			    IEEE802154_SHORT_ADDR_LEN,
+			    &desc->addr->short_addr))
+			goto nla_put_failure;
+	} else {
+		if (nla_put(msg, NL802154_COORD_ADDR,
+			    IEEE802154_EXTENDED_ADDR_LEN,
+			    &desc->addr->extended_addr))
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
+int nl802154_advertise_new_coordinator(struct wpan_phy *wpan_phy,
+				       struct wpan_dev *wpan_dev,
+				       struct ieee802154_coord_desc *desc)
+{
+	struct cfg802154_registered_device *rdev = wpan_phy_to_rdev(wpan_phy);
+	struct sk_buff *msg;
+	int ret;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
+
+	ret = nl802154_prep_new_coord_msg(msg, rdev, wpan_dev, 0, 0, 0,
+					  NL802154_CMD_NEW_COORDINATOR, desc);
+	if (ret < 0) {
+		nlmsg_free(msg);
+		return ret;
+	}
+
+	return genlmsg_multicast_netns(&nl802154_fam, wpan_phy_net(wpan_phy),
+				       msg, 0, NL802154_MCGRP_SCAN, GFP_ATOMIC);
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static const struct nla_policy nl802154_dev_addr_policy[NL802154_DEV_ADDR_ATTR_MAX + 1] = {
 	[NL802154_DEV_ADDR_ATTR_PAN_ID] = { .type = NLA_U16 },
diff --git a/net/ieee802154/nl802154.h b/net/ieee802154/nl802154.h
index 8c4b6d08954c..97600c6ee055 100644
--- a/net/ieee802154/nl802154.h
+++ b/net/ieee802154/nl802154.h
@@ -4,5 +4,8 @@
 
 int nl802154_init(void);
 void nl802154_exit(void);
+int nl802154_advertise_new_coordinator(struct wpan_phy *wpan_phy,
+				       struct wpan_dev *wpan_dev,
+				       struct ieee802154_coord_desc *desc);
 
 #endif /* __IEEE802154_NL802154_H */
-- 
2.34.1

