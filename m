Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE5C551E3E
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 16:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351224AbiFTOZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 10:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346283AbiFTOYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 10:24:39 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FBD2935F;
        Mon, 20 Jun 2022 06:40:26 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A1CD840018;
        Mon, 20 Jun 2022 13:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655732424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qj17BN/7WppT+0o0GMb5w8GWtm5f1wukI25dH7MZmJs=;
        b=iK1lO9eMBGFAgvLYbh6e0vwTIKZ+s5kNSq/NTOkwTmS8Qrmk5wZtOPIS6Dj7lzewX8N+4e
        QsHVZctJIhGRLDgqBbY1ooI+QBHwkUza+bwCMY1oKZ8UD36JPxrd0cMtIfqjs1YvdZJ8xL
        N5GZCYf735cfwugIM8rUF6XaPt2E4FjDGbs02V2Eebn3TozuC+vGb1auOeVgWJXqacCoZb
        71+gF2PiEvPJid+DO6xg+EqG0somw8uNo5aLXzlcT1KhpiEQpGe5h6IhznOeGTLjhHU9HO
        astMh4WqY0NQBh8TaGfFER1dhiI4TFxRoOiNDNhbgxja4S4KeYWQR04P5bZMCg==
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
Subject: [PATCH wpan-next v3 3/4] net: ieee802154: Give the user access to list of surrounding PANs
Date:   Mon, 20 Jun 2022 15:40:17 +0200
Message-Id: <20220620134018.62414-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220620134018.62414-1-miquel.raynal@bootlin.com>
References: <20220620134018.62414-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have support for registering PANs, give certain rights to
the user, such as listing asynchronously the PANs as well as flushing
the list.

The maximum number of PANs to list and their delay before expiration can
be configured. By default there is no limit. When these parameters are
set, PANs are automatically dropped from the list.

This change has the side effect of moving the following helpers out of
the experimental zone as they are now used by non-experimental security
functions:
- nl802154_prepare_wpan_dev_dump()
- nl802154_finish_wpan_dev_dump()

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/nl802154.h    |  49 ++++++++++
 net/ieee802154/nl802154.c | 199 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 246 insertions(+), 2 deletions(-)

diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index 145acb8f2509..5e2ccedd3826 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -58,6 +58,11 @@ enum nl802154_commands {
 
 	NL802154_CMD_SET_WPAN_PHY_NETNS,
 
+	NL802154_CMD_DUMP_PANS,
+	NL802154_CMD_FLUSH_PANS,
+	NL802154_CMD_SET_MAX_PAN_ENTRIES,
+	NL802154_CMD_SET_PANS_EXPIRATION,
+
 	/* add new commands above here */
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
@@ -133,6 +138,10 @@ enum nl802154_attrs {
 	NL802154_ATTR_PID,
 	NL802154_ATTR_NETNS_FD,
 
+	NL802154_ATTR_PAN,
+	NL802154_ATTR_MAX_PAN_ENTRIES,
+	NL802154_ATTR_PANS_EXPIRATION,
+
 	/* add attributes here, update the policy in nl802154.c */
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
@@ -218,6 +227,46 @@ enum nl802154_wpan_phy_capability_attr {
 	NL802154_CAP_ATTR_MAX = __NL802154_CAP_ATTR_AFTER_LAST - 1
 };
 
+/**
+ * enum nl802154_pan - Netlink attributes for a PAN
+ *
+ * @__NL802154_PAN_INVALID: invalid
+ * @NL802154_PAN_PANID: PANID of the PAN (2 bytes)
+ * @NL802154_PAN_COORD_ADDR: Coordinator address, (8 bytes or 2 bytes)
+ * @NL802154_PAN_CHANNEL: channel number, related to @NL802154_PAN_PAGE (u8)
+ * @NL802154_PAN_PAGE: channel page, related to @NL802154_PAN_CHANNEL (u8)
+ * @NL802154_PAN_PREAMBLE_CODE: Preamble code while the beacon was received,
+ *	this is PHY dependent and optional (4 bytes)
+ * @NL802154_PAN_SUPERFRAME_SPEC: superframe specification of the PAN (u16)
+ * @NL802154_PAN_LINK_QUALITY: signal quality of beacon in unspecified units,
+ *	scaled to 0..255 (u8)
+ * @NL802154_PAN_GTS_PERMIT: set to true if GTS is permitted on this PAN
+ * @NL802154_PAN_PAYLOAD_DATA: binary data containing the raw data from the
+ *	frame payload, (only if beacon or probe response had data)
+ * @NL802154_PAN_STATUS: status, if this PAN is "used"
+ * @NL802154_PAN_SEEN_MS_AGO: age of this PAN entry in ms
+ * @NL802154_PAN_PAD: attribute used for padding for 64-bit alignment
+ * @NL802154_PAN_MAX: highest PAN attribute
+ */
+enum nl802154_pan {
+	__NL802154_PAN_INVALID,
+	NL802154_PAN_PANID,
+	NL802154_PAN_COORD_ADDR,
+	NL802154_PAN_CHANNEL,
+	NL802154_PAN_PAGE,
+	NL802154_PAN_PREAMBLE_CODE,
+	NL802154_PAN_SUPERFRAME_SPEC,
+	NL802154_PAN_LINK_QUALITY,
+	NL802154_PAN_GTS_PERMIT,
+	NL802154_PAN_PAYLOAD_DATA,
+	NL802154_PAN_STATUS,
+	NL802154_PAN_SEEN_MS_AGO,
+	NL802154_PAN_PAD,
+
+	/* keep last */
+	NL802154_PAN_MAX,
+};
+
 /**
  * enum nl802154_cca_modes - cca modes
  *
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index e0b072aecf0f..2356e6893398 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -216,6 +216,11 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 
 	[NL802154_ATTR_PID] = { .type = NLA_U32 },
 	[NL802154_ATTR_NETNS_FD] = { .type = NLA_U32 },
+
+	[NL802154_ATTR_PAN] = { .type = NLA_NESTED },
+	[NL802154_ATTR_MAX_PAN_ENTRIES] = { .type = NLA_U32 },
+	[NL802154_ATTR_PANS_EXPIRATION] = { .type = NLA_U32 },
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	[NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
 	[NL802154_ATTR_SEC_OUT_LEVEL] = { .type = NLA_U32, },
@@ -229,7 +234,6 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 #endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
 };
 
-#ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static int
 nl802154_prepare_wpan_dev_dump(struct sk_buff *skb,
 			       struct netlink_callback *cb,
@@ -288,7 +292,6 @@ nl802154_finish_wpan_dev_dump(struct cfg802154_registered_device *rdev)
 {
 	rtnl_unlock();
 }
-#endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
 
 /* message building helper */
 static inline void *nl802154hdr_put(struct sk_buff *skb, u32 portid, u32 seq,
@@ -1281,6 +1284,172 @@ static int nl802154_wpan_phy_netns(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl802154_send_pan_info(struct sk_buff *msg,
+				  struct netlink_callback *cb,
+				  u32 seq, int flags,
+				  struct cfg802154_registered_device *rdev,
+				  struct wpan_dev *wpan_dev,
+				  struct cfg802154_internal_pan *intpan)
+{
+	struct ieee802154_pan_desc *pan = &intpan->desc;
+	struct nlattr *nla;
+	void *hdr;
+
+	ASSERT_RTNL();
+
+	hdr = nl802154hdr_put(msg, NETLINK_CB(cb->skb).portid, seq, flags,
+			      NL802154_CMD_DUMP_PANS);
+	if (!hdr)
+		return -ENOBUFS;
+
+	genl_dump_check_consistent(cb, hdr);
+
+	if (nla_put_u32(msg, NL802154_ATTR_GENERATION, rdev->pan_generation))
+		goto nla_put_failure;
+
+	if (wpan_dev->netdev &&
+	    nla_put_u32(msg, NL802154_ATTR_IFINDEX, wpan_dev->netdev->ifindex))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, NL802154_ATTR_WPAN_DEV, wpan_dev_id(wpan_dev),
+			      NL802154_ATTR_PAD))
+		goto nla_put_failure;
+
+	nla = nla_nest_start_noflag(msg, NL802154_ATTR_PAN);
+	if (!nla)
+		goto nla_put_failure;
+
+	if (nla_put(msg, NL802154_PAN_PANID, IEEE802154_PAN_ID_LEN,
+		    &pan->coord->pan_id))
+		goto nla_put_failure;
+
+	if (pan->coord->mode == IEEE802154_ADDR_SHORT) {
+		if (nla_put(msg, NL802154_PAN_COORD_ADDR,
+			    IEEE802154_SHORT_ADDR_LEN,
+			    &pan->coord->short_addr))
+			goto nla_put_failure;
+	} else {
+		if (nla_put(msg, NL802154_PAN_COORD_ADDR,
+			    IEEE802154_EXTENDED_ADDR_LEN,
+			    &pan->coord->extended_addr))
+			goto nla_put_failure;
+	}
+
+	if (nla_put_u8(msg, NL802154_PAN_CHANNEL, pan->channel))
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, NL802154_PAN_PAGE, pan->page))
+		goto nla_put_failure;
+
+	if (nla_put_u16(msg, NL802154_PAN_SUPERFRAME_SPEC,
+			pan->superframe_spec))
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, NL802154_PAN_LINK_QUALITY, pan->link_quality))
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL802154_PAN_SEEN_MS_AGO,
+			jiffies_to_msecs(jiffies - intpan->discovery_ts)))
+		goto nla_put_failure;
+
+	if (pan->gts_permit && nla_put_flag(msg, NL802154_PAN_GTS_PERMIT))
+		goto nla_put_failure;
+
+	/* TODO: NL802154_PAN_PAYLOAD_DATA if any */
+
+	nla_nest_end(msg, nla);
+	genlmsg_end(msg, hdr);
+
+	return 0;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static int nl802154_dump_pans(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct cfg802154_registered_device *rdev;
+	struct cfg802154_internal_pan *pan;
+	struct wpan_dev *wpan_dev;
+	int err;
+
+	err = nl802154_prepare_wpan_dev_dump(skb, cb, &rdev, &wpan_dev);
+	if (err)
+		return err;
+
+	spin_lock_bh(&rdev->pan_lock);
+
+	if (cb->args[2])
+		goto out;
+
+	cb->seq = rdev->pan_generation;
+
+	ieee802154_for_each_pan(pan, rdev) {
+		err = nl802154_send_pan_info(skb, cb, cb->nlh->nlmsg_seq,
+					     NLM_F_MULTI, rdev, wpan_dev, pan);
+		if (err < 0)
+			goto out_err;
+	}
+
+	cb->args[2] = 1;
+out:
+	err = skb->len;
+out_err:
+	spin_unlock_bh(&rdev->pan_lock);
+
+	nl802154_finish_wpan_dev_dump(rdev);
+
+	return err;
+}
+
+static int nl802154_flush_pans(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg802154_registered_device *rdev = info->user_ptr[0];
+
+	spin_lock_bh(&rdev->pan_lock);
+	cfg802154_flush_pans(rdev);
+	spin_unlock_bh(&rdev->pan_lock);
+
+	return 0;
+}
+
+static int nl802154_set_max_pan_entries(struct sk_buff *skb,
+					struct genl_info *info)
+{
+	struct cfg802154_registered_device *rdev = info->user_ptr[0];
+	unsigned int max_entries;
+
+	if (!info->attrs[NL802154_ATTR_MAX_PAN_ENTRIES])
+		return -EINVAL;
+
+	max_entries = nla_get_u32(info->attrs[NL802154_ATTR_MAX_PAN_ENTRIES]);
+
+	spin_lock_bh(&rdev->pan_lock);
+	cfg802154_set_max_pan_entries(rdev, max_entries);
+	spin_unlock_bh(&rdev->pan_lock);
+
+	return 0;
+}
+
+static int nl802154_set_pans_expiration(struct sk_buff *skb,
+					struct genl_info *info)
+{
+	struct cfg802154_registered_device *rdev = info->user_ptr[0];
+	unsigned int exp_time_s;
+
+	if (!info->attrs[NL802154_ATTR_PANS_EXPIRATION])
+		return -EINVAL;
+
+	exp_time_s = nla_get_u32(info->attrs[NL802154_ATTR_PANS_EXPIRATION]);
+
+	spin_lock_bh(&rdev->pan_lock);
+	cfg802154_set_pans_expiration(rdev, exp_time_s);
+	spin_unlock_bh(&rdev->pan_lock);
+
+	return 0;
+}
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static const struct nla_policy nl802154_dev_addr_policy[NL802154_DEV_ADDR_ATTR_MAX + 1] = {
 	[NL802154_DEV_ADDR_ATTR_PAN_ID] = { .type = NLA_U16 },
@@ -2369,6 +2538,32 @@ static const struct genl_ops nl802154_ops[] = {
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
 				  NL802154_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL802154_CMD_DUMP_PANS,
+		.dumpit = nl802154_dump_pans,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = NL802154_CMD_FLUSH_PANS,
+		.doit = nl802154_flush_pans,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL802154_FLAG_NEED_NETDEV |
+				  NL802154_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL802154_CMD_SET_MAX_PAN_ENTRIES,
+		.doit = nl802154_set_max_pan_entries,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL802154_FLAG_NEED_NETDEV |
+				  NL802154_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL802154_CMD_SET_PANS_EXPIRATION,
+		.doit = nl802154_set_pans_expiration,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL802154_FLAG_NEED_NETDEV |
+				  NL802154_FLAG_NEED_RTNL,
+	},
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	{
 		.cmd = NL802154_CMD_SET_SEC_PARAMS,
-- 
2.34.1

