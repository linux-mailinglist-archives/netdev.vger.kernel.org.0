Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9253754FDC2
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 21:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236586AbiFQTdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 15:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbiFQTdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 15:33:02 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60162DE8F;
        Fri, 17 Jun 2022 12:33:01 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E6D76C0002;
        Fri, 17 Jun 2022 19:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655494379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dhh3OC83hkTq97PeB0N3TgltQMP4WZY8XBLUgsh6oYM=;
        b=DQC06kpVzEMZTo9do6uswwGWXs8X2BXedlEASt/z54+jEKhi0vwmcYa/1aO3ojH9oCxQFh
        naW15x/to0jUmMqO+GE70HJ/eEf5mwedSZYVrsgnkrOq3l3hUf9+BHdtGeEptthWKOdfG/
        8xD4Bbjhh02p6Jtipa7R51U/zfA2dTg6VCjhATgyWyOEvMNv03hOfq0ALprxlhwOTqFRXi
        nMez9plpoZL7pxX7Vc0Nffw8mSwKo+aNLO3w2t8tp7pSGYpAx/Llv/3GbKF0wkEPJpl8sC
        b9GioXa0u2hi1aXnHIrczIZccYgEWbNEPwOJ2eLcsY8nwFI4uFg2bKnQ6FnkoQ==
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
Subject: [PATCH wpan-next v2 1/6] net: ieee802154: Create a device type
Date:   Fri, 17 Jun 2022 21:32:49 +0200
Message-Id: <20220617193254.1275912-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220617193254.1275912-1-miquel.raynal@bootlin.com>
References: <20220617193254.1275912-1-miquel.raynal@bootlin.com>
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

A device can be either a fully functioning device or a kind of reduced
functioning device. Let's create a device type member. Drivers will be
in charge of setting this value if they handle non-FFD devices.

FFD are considered the default.

Provide this information in the interface get netlink command.

Create a helper just to check if a rdev is a FFD or not, which will
then be useful when bringing scan support.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/nl802154.h    | 9 +++++++++
 net/ieee802154/core.h     | 8 ++++++++
 net/ieee802154/nl802154.c | 6 +++++-
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index 145acb8f2509..5258785879e8 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -133,6 +133,8 @@ enum nl802154_attrs {
 	NL802154_ATTR_PID,
 	NL802154_ATTR_NETNS_FD,
 
+	NL802154_ATTR_DEV_TYPE,
+
 	/* add attributes here, update the policy in nl802154.c */
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
@@ -163,6 +165,13 @@ enum nl802154_iftype {
 	NL802154_IFTYPE_MAX = NUM_NL802154_IFTYPES - 1
 };
 
+enum nl802154_dev_type {
+	NL802154_DEV_TYPE_FFD = 0,
+	NL802154_DEV_TYPE_RFD,
+	NL802154_DEV_TYPE_RFD_RX,
+	NL802154_DEV_TYPE_RFD_TX,
+};
+
 /**
  * enum nl802154_wpan_phy_capability_attr - wpan phy capability attributes
  *
diff --git a/net/ieee802154/core.h b/net/ieee802154/core.h
index 1c19f575d574..d5a2f58b01cf 100644
--- a/net/ieee802154/core.h
+++ b/net/ieee802154/core.h
@@ -22,6 +22,8 @@ struct cfg802154_registered_device {
 	struct list_head wpan_dev_list;
 	int devlist_generation, wpan_dev_id;
 
+	enum nl802154_dev_type dev_type;
+
 	/* must be last because of the way we do wpan_phy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN
 	 */
@@ -47,4 +49,10 @@ struct cfg802154_registered_device *
 cfg802154_rdev_by_wpan_phy_idx(int wpan_phy_idx);
 struct wpan_phy *wpan_phy_idx_to_wpan_phy(int wpan_phy_idx);
 
+static inline bool
+cfg802154_is_ffd(struct cfg802154_registered_device *rdev)
+{
+	return rdev->dev_type == NL802154_DEV_TYPE_FFD;
+}
+
 #endif /* __IEEE802154_CORE_H */
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index e0b072aecf0f..638bf544f102 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -216,6 +216,9 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 
 	[NL802154_ATTR_PID] = { .type = NLA_U32 },
 	[NL802154_ATTR_NETNS_FD] = { .type = NLA_U32 },
+
+	[NL802154_ATTR_DEV_TYPE] = { .type = NLA_U8 },
+
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	[NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
 	[NL802154_ATTR_SEC_OUT_LEVEL] = { .type = NLA_U32, },
@@ -790,7 +793,8 @@ nl802154_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
 			      wpan_dev_id(wpan_dev), NL802154_ATTR_PAD) ||
 	    nla_put_u32(msg, NL802154_ATTR_GENERATION,
 			rdev->devlist_generation ^
-			(cfg802154_rdev_list_generation << 2)))
+			(cfg802154_rdev_list_generation << 2)) ||
+	    nla_put_u8(msg, NL802154_ATTR_DEV_TYPE, rdev->dev_type))
 		goto nla_put_failure;
 
 	/* address settings */
-- 
2.34.1

