Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE174907CD
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239514AbiAQL4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:56:08 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:39685 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239395AbiAQLzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:46 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 0CE2320001A;
        Mon, 17 Jan 2022 11:55:43 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v3 34/41] net: ieee802154: Full PAN management
Date:   Mon, 17 Jan 2022 12:54:33 +0100
Message-Id: <20220117115440.60296-35-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that scanning is supported and PANs properly registered, give
certain rights to the user, such as listing asynchronously the listed
PANs as well as flushing the list.

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
 include/net/nl802154.h    |  47 +++++++++
 net/ieee802154/nl802154.c | 197 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 242 insertions(+), 2 deletions(-)

diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index 51eca3a2b14e..22af514dd339 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -61,6 +61,10 @@ enum nl802154_commands {
 	NL802154_CMD_TRIGGER_SCAN,
 	NL802154_CMD_ABORT_SCAN,
 	NL802154_CMD_SCAN_DONE,
+	NL802154_CMD_DUMP_PANS,
+	NL802154_CMD_FLUSH_PANS,
+	NL802154_CMD_SET_MAX_PAN_ENTRIES,
+	NL802154_CMD_SET_PANS_EXPIRATION,
 
 	/* add new commands above here */
 
@@ -141,6 +145,9 @@ enum nl802154_attrs {
 	NL802154_ATTR_SCAN_FLAGS,
 	NL802154_ATTR_SCAN_CHANNELS,
 	NL802154_ATTR_SCAN_DURATION,
+	NL802154_ATTR_PAN,
+	NL802154_ATTR_MAX_PAN_ENTRIES,
+	NL802154_ATTR_PANS_EXPIRATION,
 
 	/* add attributes here, update the policy in nl802154.c */
 
@@ -267,6 +274,46 @@ enum nl802154_scan_flags {
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
index 99cbad1f1381..07bac1ae2cd2 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -223,6 +223,9 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 	[NL802154_ATTR_SCAN_FLAGS] = { .type = NLA_U32 },
 	[NL802154_ATTR_SCAN_CHANNELS] = { .type = NLA_U32 },
 	[NL802154_ATTR_SCAN_DURATION] = { .type = NLA_U8 },
+	[NL802154_ATTR_PAN] = { .type = NLA_NESTED },
+	[NL802154_ATTR_MAX_PAN_ENTRIES] = { .type = NLA_U32 },
+	[NL802154_ATTR_PANS_EXPIRATION] = { .type = NLA_U32 },
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	[NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
@@ -237,7 +240,6 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 #endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
 };
 
-#ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 static int
 nl802154_prepare_wpan_dev_dump(struct sk_buff *skb,
 			       struct netlink_callback *cb,
@@ -296,7 +298,6 @@ nl802154_finish_wpan_dev_dump(struct cfg802154_registered_device *rdev)
 {
 	rtnl_unlock();
 }
-#endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
 
 /* message building helper */
 static inline void *nl802154hdr_put(struct sk_buff *skb, u32 portid, u32 seq,
@@ -1517,6 +1518,172 @@ static int nl802154_abort_scan(struct sk_buff *skb, struct genl_info *info)
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
@@ -2621,6 +2788,32 @@ static const struct genl_ops nl802154_ops[] = {
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
2.27.0

