Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD20747D49E
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344059AbhLVP6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:58:25 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49907 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343918AbhLVP6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:58:08 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 8E3DA60007;
        Wed, 22 Dec 2021 15:58:05 +0000 (UTC)
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
Subject: [net-next 14/18] net: ieee802154: Full PAN management
Date:   Wed, 22 Dec 2021 16:57:39 +0100
Message-Id: <20211222155743.256280-15-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155743.256280-1-miquel.raynal@bootlin.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that scanning is supported and PANs properly registered, give
certain rights to the user, such as listing asynchronously the listed
PANs as well as flushing the list. By default, the list gets
automatically updated every time users request the list of pans. Too old
PANs are automatically dropped from the list. The expiration time is
configurable with a module parameter.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/nl802154.h    |  43 ++++++++++++
 net/ieee802154/nl802154.c | 143 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 186 insertions(+)

diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index 51eca3a2b14e..e185e92d29d6 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -61,6 +61,8 @@ enum nl802154_commands {
 	NL802154_CMD_TRIGGER_SCAN,
 	NL802154_CMD_ABORT_SCAN,
 	NL802154_CMD_SCAN_DONE,
+	NL802154_CMD_DUMP_PANS,
+	NL802154_CMD_FLUSH_PANS,
 
 	/* add new commands above here */
 
@@ -141,6 +143,7 @@ enum nl802154_attrs {
 	NL802154_ATTR_SCAN_FLAGS,
 	NL802154_ATTR_SCAN_CHANNELS,
 	NL802154_ATTR_SCAN_DURATION,
+	NL802154_ATTR_PAN,
 
 	/* add attributes here, update the policy in nl802154.c */
 
@@ -267,6 +270,46 @@ enum nl802154_scan_flags {
 	NL802154_SCAN_FLAG_RANDOM_ADDR = BIT(0),
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
index d59de9812721..8de8f7c31bfe 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -223,6 +223,7 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 	[NL802154_ATTR_SCAN_FLAGS] = { .type = NLA_U32, },
 	[NL802154_ATTR_SCAN_CHANNELS] = { .type = NLA_U32, },
 	[NL802154_ATTR_SCAN_DURATION] = { .type = NLA_U8, },
+	[NL802154_ATTR_PAN] = { .type = NLA_NESTED },
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	[NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
@@ -1499,6 +1500,136 @@ static int nl802154_abort_scan(struct sk_buff *skb, struct genl_info *info)
 	return rdev_abort_scan(rdev, wpan_dev);
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
+			      NL802154_CMD_SCAN_DONE);
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
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static const struct nla_policy nl802154_dev_addr_policy[NL802154_DEV_ADDR_ATTR_MAX + 1] = {
 	[NL802154_DEV_ADDR_ATTR_PAN_ID] = { .type = NLA_U16 },
@@ -2603,6 +2734,18 @@ static const struct genl_ops nl802154_ops[] = {
 				  NL802154_FLAG_CHECK_NETDEV_UP |
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
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	{
 		.cmd = NL802154_CMD_SET_SEC_PARAMS,
-- 
2.27.0

