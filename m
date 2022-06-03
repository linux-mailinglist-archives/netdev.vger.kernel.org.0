Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EDC53D187
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242607AbiFCSe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347571AbiFCSeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:34:02 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F41384;
        Fri,  3 Jun 2022 11:21:51 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7480020008;
        Fri,  3 Jun 2022 18:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654280509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SRmpKPc0/wg89OR5CLRbBeTtA9U60d8ApWjgx2ea+Lg=;
        b=gTfkbK0Xr1TOlFAHXvS8S/ev9D1sVjrfX2U6v3vVvf7QpGmuk0ouC1zxb0HO2yxWEdUctz
        nqvIpd/xmOY9QosQoZ/XxtFT8cVAm1xB+I4P0TSPE6uVeUHLw7r3L5I51zZx0GkoepEuvY
        l2TmmL6V6s80+ZHPkfIGCV06pv3K0W/iLuT0WFr047sDRcG1lwBVOYuQiTtkdRadH4P2NM
        VTSkDnf+6MZgLPz9rf4y2U6W1sbUBkNStYBy6Hx8x7JSUxiDzIlB2yIHVJsWs8hT940ARf
        kaYoUK9xImYdPZJ1V3ICT9NRnwlPqD1T8Jz18CRnDVUvhxipzSvIkVgocvSdkQ==
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
Subject: [PATCH wpan-next 3/6] net: ieee802154: Create a node type
Date:   Fri,  3 Jun 2022 20:21:40 +0200
Message-Id: <20220603182143.692576-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220603182143.692576-1-miquel.raynal@bootlin.com>
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A device can be either a fully functioning device or a kind of reduced
functioning device. Let's create a node type member. Drivers will be in
charge of setting this value if they handle non-FFD devices, which can
be considered the default for now.

Provide this information in the interface get netlink command.

Create a helper just to check if an rdev is a FFD or not, which will
then be useful when bringing scan support.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/nl802154.h    | 9 +++++++++
 net/ieee802154/core.h     | 7 +++++++
 net/ieee802154/nl802154.c | 6 +++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/net/nl802154.h b/include/net/nl802154.h
index 0f508aaae126..8e4d8b7a6e24 100644
--- a/include/net/nl802154.h
+++ b/include/net/nl802154.h
@@ -133,6 +133,8 @@ enum nl802154_attrs {
 	NL802154_ATTR_PID,
 	NL802154_ATTR_NETNS_FD,
 
+	NL802154_ATTR_NODE_TYPE,
+
 	/* add attributes here, update the policy in nl802154.c */
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
@@ -162,6 +164,13 @@ enum nl802154_iftype {
 	NL802154_IFTYPE_MAX = NUM_NL802154_IFTYPES - 1
 };
 
+enum nl802154_node_type {
+	NL802154_NODE_TYPE_FFD,
+	NL802154_NODE_TYPE_RFD,
+	NL802154_NODE_TYPE_RFD_RX,
+	NL802154_NODE_TYPE_RFD_TX,
+};
+
 /**
  * enum nl802154_wpan_phy_capability_attr - wpan phy capability attributes
  *
diff --git a/net/ieee802154/core.h b/net/ieee802154/core.h
index cae071bede37..019309d6a3bb 100644
--- a/net/ieee802154/core.h
+++ b/net/ieee802154/core.h
@@ -23,6 +23,7 @@ struct cfg802154_registered_device {
 	int devlist_generation, wpan_dev_id;
 
 	/* PAN management */
+	enum nl802154_node_type node_type;
 	spinlock_t pan_lock;
 	struct list_head pan_list;
 	unsigned int max_pan_entries;
@@ -73,4 +74,10 @@ void cfg802154_set_pans_expiration(struct cfg802154_registered_device *rdev,
 void cfg802154_expire_pans(struct cfg802154_registered_device *rdev);
 void cfg802154_flush_pans(struct cfg802154_registered_device *rdev);
 
+static inline bool
+cfg802154_is_ffd(struct cfg802154_registered_device *rdev)
+{
+	return rdev->node_type == NL802154_NODE_TYPE_FFD;
+}
+
 #endif /* __IEEE802154_CORE_H */
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index e0b072aecf0f..10767c3b25d7 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -216,6 +216,9 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 
 	[NL802154_ATTR_PID] = { .type = NLA_U32 },
 	[NL802154_ATTR_NETNS_FD] = { .type = NLA_U32 },
+
+	[NL802154_ATTR_NODE_TYPE] = { .type = NLA_U8 },
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
+	    nla_put_u8(msg, NL802154_ATTR_NODE_TYPE, rdev->node_type))
 		goto nla_put_failure;
 
 	/* address settings */
-- 
2.34.1

