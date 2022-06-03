Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98CF53D180
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346861AbiFCSeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347581AbiFCSeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:34:02 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A874D85;
        Fri,  3 Jun 2022 11:21:52 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E9F1D20007;
        Fri,  3 Jun 2022 18:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654280511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yvRpY8WrSPG4v8wr1O2U06FO5Xj0u6ZZscxy4wdTCnE=;
        b=j8EUrLtPCPyRVG4mgmUnHGUawtb7fhcnZbhYP/wfUHGP85GMVYgb+h3FW+w1Wmp85eI9Ih
        MPur0tUd7ixepis/L/PR/u6soyGmIBVgMtMWAwJQlvRcqY+/nGvZsTBc04sN5XIw2n5YPq
        Ny0Mx7uStOyFU7jRLIsED6o4U/WLNLBeMGCd+9AKjjwfdchIOKoTA8p99AtfLxtlR3EyWq
        U05C18Ji+ozZiXfg4IZYPeikQ4jmxguM2HpTLua530RtY7hLca4BiKp1Lr7+fgrOt6p17W
        VwA8haGqBVZ59/DBlEvwbitnCy69Rzh6vFGZK7rvzoAWakbsRJRvGNqlwFYUJA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 4/6] net: ieee802154: Add the PAN coordinator information
Date:   Fri,  3 Jun 2022 20:21:41 +0200
Message-Id: <20220603182143.692576-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220603182143.692576-1-miquel.raynal@bootlin.com>
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
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

We need to be able to differentiate between an FFD which acts as PAN
coordinator or not. For instance, in the former case, the device can
send beacons, otherwise not.

As no proper PAN creation exist yet, introduce a netlink command to
force that parameter. This could be dropped in the future when proper
PAN creation support gets added.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/nl802154.h    |  3 +++
 net/ieee802154/core.h     |  9 +++++++++
 net/ieee802154/nl802154.c | 31 ++++++++++++++++++++++++++++++-
 net/ieee802154/pan.c      | 12 ++++++++++++
 4 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index 8e4d8b7a6e24..bc545d1f6f13 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -58,6 +58,8 @@ enum nl802154_commands {
 
 	NL802154_CMD_SET_WPAN_PHY_NETNS,
 
+	NL802154_CMD_SET_PAN_COORDINATOR_ROLE,
+
 	/* add new commands above here */
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
@@ -134,6 +136,7 @@ enum nl802154_attrs {
 	NL802154_ATTR_NETNS_FD,
 
 	NL802154_ATTR_NODE_TYPE,
+	NL802154_ATTR_PAN_COORDINATOR,
 
 	/* add attributes here, update the policy in nl802154.c */
 
diff --git a/net/ieee802154/core.h b/net/ieee802154/core.h
index 019309d6a3bb..dc240a9f830d 100644
--- a/net/ieee802154/core.h
+++ b/net/ieee802154/core.h
@@ -24,6 +24,7 @@ struct cfg802154_registered_device {
 
 	/* PAN management */
 	enum nl802154_node_type node_type;
+	bool is_pan_coordinator;
 	spinlock_t pan_lock;
 	struct list_head pan_list;
 	unsigned int max_pan_entries;
@@ -73,6 +74,8 @@ void cfg802154_set_pans_expiration(struct cfg802154_registered_device *rdev,
 				   unsigned int exp_time_s);
 void cfg802154_expire_pans(struct cfg802154_registered_device *rdev);
 void cfg802154_flush_pans(struct cfg802154_registered_device *rdev);
+int cfg802154_set_pan_coordinator_role(struct cfg802154_registered_device *rdev,
+				       bool is_pan_coordinator);
 
 static inline bool
 cfg802154_is_ffd(struct cfg802154_registered_device *rdev)
@@ -80,4 +83,10 @@ cfg802154_is_ffd(struct cfg802154_registered_device *rdev)
 	return rdev->node_type == NL802154_NODE_TYPE_FFD;
 }
 
+static inline bool
+cfg802154_is_pan_coordinator(struct cfg802154_registered_device *rdev)
+{
+	return cfg802154_is_ffd(rdev) && rdev->is_pan_coordinator;
+}
+
 #endif /* __IEEE802154_CORE_H */
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 10767c3b25d7..1e4f9b1e7362 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -218,6 +218,7 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 	[NL802154_ATTR_NETNS_FD] = { .type = NLA_U32 },
 
 	[NL802154_ATTR_NODE_TYPE] = { .type = NLA_U8 },
+	[NL802154_ATTR_PAN_COORDINATOR] = { .type = NLA_U8 },
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	[NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
@@ -794,7 +795,9 @@ nl802154_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
 	    nla_put_u32(msg, NL802154_ATTR_GENERATION,
 			rdev->devlist_generation ^
 			(cfg802154_rdev_list_generation << 2)) ||
-	    nla_put_u8(msg, NL802154_ATTR_NODE_TYPE, rdev->node_type))
+	    nla_put_u8(msg, NL802154_ATTR_NODE_TYPE, rdev->node_type) ||
+	    nla_put_u8(msg, NL802154_ATTR_PAN_COORDINATOR,
+		       rdev->is_pan_coordinator))
 		goto nla_put_failure;
 
 	/* address settings */
@@ -1254,6 +1257,25 @@ nl802154_set_ackreq_default(struct sk_buff *skb, struct genl_info *info)
 	return rdev_set_ackreq_default(rdev, wpan_dev, ackreq);
 }
 
+static int nl802154_set_pan_coordinator_role(struct sk_buff *skb,
+					     struct genl_info *info)
+{
+	struct cfg802154_registered_device *rdev = info->user_ptr[0];
+	bool is_pan_coordinator;
+	int ret;
+
+	if (!info->attrs[NL802154_ATTR_PAN_COORDINATOR])
+		return -EINVAL;
+
+	is_pan_coordinator = nla_get_u8(info->attrs[NL802154_ATTR_PAN_COORDINATOR]);
+
+	spin_lock_bh(&rdev->pan_lock);
+	ret = cfg802154_set_pan_coordinator_role(rdev, is_pan_coordinator);
+	spin_unlock_bh(&rdev->pan_lock);
+
+	return ret;
+}
+
 static int nl802154_wpan_phy_netns(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg802154_registered_device *rdev = info->user_ptr[0];
@@ -2373,6 +2395,13 @@ static const struct genl_ops nl802154_ops[] = {
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
 				  NL802154_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL802154_CMD_SET_PAN_COORDINATOR_ROLE,
+		.doit = nl802154_set_pan_coordinator_role,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL802154_FLAG_NEED_NETDEV |
+				  NL802154_FLAG_NEED_RTNL,
+	},
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	{
 		.cmd = NL802154_CMD_SET_SEC_PARAMS,
diff --git a/net/ieee802154/pan.c b/net/ieee802154/pan.c
index b9f50f785960..7f48e3547b2f 100644
--- a/net/ieee802154/pan.c
+++ b/net/ieee802154/pan.c
@@ -19,6 +19,18 @@
 #include "ieee802154.h"
 #include "core.h"
 
+int cfg802154_set_pan_coordinator_role(struct cfg802154_registered_device *rdev,
+				       bool is_pan_coordinator)
+{
+	if (rdev->node_type != NL802154_NODE_TYPE_FFD)
+		return -EOPNOTSUPP;
+
+	rdev->is_pan_coordinator = is_pan_coordinator;
+
+	return 0;
+}
+EXPORT_SYMBOL(cfg802154_set_pan_coordinator_role);
+
 static struct cfg802154_internal_pan *
 cfg802154_alloc_pan(struct ieee802154_pan_desc *desc)
 {
-- 
2.34.1

