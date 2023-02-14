Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABEA369656C
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbjBNNxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbjBNNxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:53:18 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BCA28D23;
        Tue, 14 Feb 2023 05:52:37 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 075E640016;
        Tue, 14 Feb 2023 13:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676382643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ttQT6PrK+hAQq43MOEP7Y9u/hPR5qx2x6Cro9K6qgG4=;
        b=Oy9L80i9DKsoQY4y14r1kAazDNb8IX8mpenXBBc5Aru16NsAUcwx0lhNosAGh87B1BX4PS
        w+ICqKV1JaavTtx47wIF7/KrAmKHxXMOq+PfO1VAHT/gSf8/Mn5g0/MNfCiuy2k5ivueVv
        ppb4LTXXj3pJt+s9pWRxSkvFkqpdO7EPNlf6cWQdoRxtZT3MCNmHL36WxUqLZ3lqJUNk/p
        v/AR9+PIHgacqjuJLuGDVvwjODEI05WeTn424xAYn3upy//Tzcee4PEKZo8Y91a80+Evlp
        XkzfDLXiwBisDK6wXvv8LUKrWNq18BZ+AtF4DlLiw+Q0szxrkNRfhssoiJdlig==
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
Subject: [PATCH wpan v2 2/6] ieee802154: Convert scan error messages to extack
Date:   Tue, 14 Feb 2023 14:50:31 +0100
Message-Id: <20230214135035.1202471-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
References: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of printing error messages in the kernel log, let's use extack.
When there is a netlink error returned that could be further specified
with a string, use extack as well.

Apply this logic to the very recent scan/beacon infrastructure.

Fixes: ed3557c947e1 ("ieee802154: Add support for user scanning requests")
Fixes: 9bc114504b07 ("ieee802154: Add support for user beaconing requests")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/ieee802154/nl802154.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 64fa811e1f0b..d3b6e9e80941 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1407,9 +1407,15 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	u8 type;
 	int err;
 
-	/* Monitors are not allowed to perform scans */
-	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR) {
+		NL_SET_ERR_MSG(info->extack, "Monitors are not allowed to perform scans");
 		return -EPERM;
+	}
+
+	if (!nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
+		NL_SET_ERR_MSG(info->extack, "Malformed request, missing scan type");
+		return -EINVAL;
+	}
 
 	request = kzalloc(sizeof(*request), GFP_KERNEL);
 	if (!request)
@@ -1424,7 +1430,7 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		request->type = type;
 		break;
 	default:
-		pr_err("Unsupported scan type: %d\n", type);
+		NL_SET_ERR_MSG_FMT(info->extack, "Unsupported scan type: %d", type);
 		err = -EINVAL;
 		goto free_request;
 	}
@@ -1576,12 +1582,13 @@ nl802154_send_beacons(struct sk_buff *skb, struct genl_info *info)
 	struct cfg802154_beacon_request *request;
 	int err;
 
-	/* Only coordinators can send beacons */
-	if (wpan_dev->iftype != NL802154_IFTYPE_COORD)
+	if (wpan_dev->iftype != NL802154_IFTYPE_COORD) {
+		NL_SET_ERR_MSG(info->extack, "Only coordinators can send beacons");
 		return -EOPNOTSUPP;
+	}
 
 	if (wpan_dev->pan_id == cpu_to_le16(IEEE802154_PANID_BROADCAST)) {
-		pr_err("Device is not part of any PAN\n");
+		NL_SET_ERR_MSG(info->extack, "Device is not part of any PAN");
 		return -EPERM;
 	}
 
-- 
2.34.1

