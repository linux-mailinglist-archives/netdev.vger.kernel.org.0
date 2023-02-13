Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16693694D7A
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjBMQzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjBMQy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:54:57 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DDA72B2;
        Mon, 13 Feb 2023 08:54:20 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 73145240009;
        Mon, 13 Feb 2023 16:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676307258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UCfsIjm+4SX0CmTBbneMgRbbsxRe5MO/1rVyIJO8ItE=;
        b=CjwCasMJFLvnh+cEjTOvJsVDBJjKx9gE0P5pIeupGugc3J6Zg8edP8H+52ZLdmA9juW3ed
        29+t82gYHQ6SK4ZdSGx2M90M/7xpd4H7fS93SSwxt4W7mS1hm4XZ6vY2LxizyJJRVKObIB
        mckMM/AbP1/1A1TkCFhbBQDg7ZEWgN7VmC+TZe1Zob6006vHlxT0k41CNAM5zYr+fKYqu3
        7HjwxmHpwyXjOeVDGsy+ExO6Xtw7mchBGR/GeJJY/zOgfn6F51lhe7rvR5TMsidoh0n3to
        F3Q4aKo7yFd10FxiKiHq/BbZ0hmI25W+qAZvg1p7Up93EEEqP4WLXG0yGbgbBA==
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
Subject: [PATCH wpan 1/6] ieee802154: Use netlink policies when relevant on scan parameters
Date:   Mon, 13 Feb 2023 17:54:09 +0100
Message-Id: <20230213165414.1168401-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230213165414.1168401-1-miquel.raynal@bootlin.com>
References: <20230213165414.1168401-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of open-coding scan parameters (page, channels, duration, etc),
let's use the existing NLA_POLICY* macros. This help greatly reducing
the error handling and clarifying the overall logic.

Fixes: 45755ce4bf46 ("ieee802154: Add support for user scanning requests")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/ieee802154/nl802154.c | 84 +++++++++++++--------------------------
 1 file changed, 28 insertions(+), 56 deletions(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 0d9becd678e3..64fa811e1f0b 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -187,8 +187,8 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 
 	[NL802154_ATTR_WPAN_DEV] = { .type = NLA_U64 },
 
-	[NL802154_ATTR_PAGE] = { .type = NLA_U8, },
-	[NL802154_ATTR_CHANNEL] = { .type = NLA_U8, },
+	[NL802154_ATTR_PAGE] = NLA_POLICY_MAX(NLA_U8, IEEE802154_MAX_PAGE),
+	[NL802154_ATTR_CHANNEL] = NLA_POLICY_MAX(NLA_U8, IEEE802154_MAX_CHANNEL),
 
 	[NL802154_ATTR_TX_POWER] = { .type = NLA_S32, },
 
@@ -221,13 +221,19 @@ static const struct nla_policy nl802154_policy[NL802154_ATTR_MAX+1] = {
 
 	[NL802154_ATTR_COORDINATOR] = { .type = NLA_NESTED },
 
-	[NL802154_ATTR_SCAN_TYPE] = { .type = NLA_U8 },
-	[NL802154_ATTR_SCAN_CHANNELS] = { .type = NLA_U32 },
-	[NL802154_ATTR_SCAN_PREAMBLE_CODES] = { .type = NLA_U64 },
-	[NL802154_ATTR_SCAN_MEAN_PRF] = { .type = NLA_U8 },
-	[NL802154_ATTR_SCAN_DURATION] = { .type = NLA_U8 },
-	[NL802154_ATTR_SCAN_DONE_REASON] = { .type = NLA_U8 },
-	[NL802154_ATTR_BEACON_INTERVAL] = { .type = NLA_U8 },
+	[NL802154_ATTR_SCAN_TYPE] =
+		NLA_POLICY_RANGE(NLA_U8, NL802154_SCAN_ED, NL802154_SCAN_RIT_PASSIVE),
+	[NL802154_ATTR_SCAN_CHANNELS] =
+		NLA_POLICY_MASK(NLA_U32, GENMASK(IEEE802154_MAX_CHANNEL, 0)),
+	[NL802154_ATTR_SCAN_PREAMBLE_CODES] = { .type = NLA_REJECT },
+	[NL802154_ATTR_SCAN_MEAN_PRF] = { .type = NLA_REJECT },
+	[NL802154_ATTR_SCAN_DURATION] =
+		NLA_POLICY_MAX(NLA_U8, IEEE802154_MAX_SCAN_DURATION),
+	[NL802154_ATTR_SCAN_DONE_REASON] =
+		NLA_POLICY_RANGE(NLA_U8, NL802154_SCAN_DONE_REASON_FINISHED,
+				 NL802154_SCAN_DONE_REASON_ABORTED),
+	[NL802154_ATTR_BEACON_INTERVAL] =
+		NLA_POLICY_MAX(NLA_U8, IEEE802154_MAX_SCAN_DURATION),
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	[NL802154_ATTR_SEC_ENABLED] = { .type = NLA_U8, },
@@ -1423,51 +1429,23 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		goto free_request;
 	}
 
-	if (info->attrs[NL802154_ATTR_PAGE]) {
+	/* Use current page by default */
+	if (info->attrs[NL802154_ATTR_PAGE])
 		request->page = nla_get_u8(info->attrs[NL802154_ATTR_PAGE]);
-		if (request->page > IEEE802154_MAX_PAGE) {
-			pr_err("Invalid page %d > %d\n",
-			       request->page, IEEE802154_MAX_PAGE);
-			err = -EINVAL;
-			goto free_request;
-		}
-	} else {
-		/* Use current page by default */
+	else
 		request->page = wpan_phy->current_page;
-	}
 
-	if (info->attrs[NL802154_ATTR_SCAN_CHANNELS]) {
+	/* Scan all supported channels by default */
+	if (info->attrs[NL802154_ATTR_SCAN_CHANNELS])
 		request->channels = nla_get_u32(info->attrs[NL802154_ATTR_SCAN_CHANNELS]);
-		if (request->channels >= BIT(IEEE802154_MAX_CHANNEL + 1)) {
-			pr_err("Invalid channels bitfield %x ≥ %lx\n",
-			       request->channels,
-			       BIT(IEEE802154_MAX_CHANNEL + 1));
-			err = -EINVAL;
-			goto free_request;
-		}
-	} else {
-		/* Scan all supported channels by default */
+	else
 		request->channels = wpan_phy->supported.channels[request->page];
-	}
 
-	if (info->attrs[NL802154_ATTR_SCAN_PREAMBLE_CODES] ||
-	    info->attrs[NL802154_ATTR_SCAN_MEAN_PRF]) {
-		pr_err("Preamble codes and mean PRF not supported yet\n");
-		err = -EINVAL;
-		goto free_request;
-	}
-
-	if (info->attrs[NL802154_ATTR_SCAN_DURATION]) {
+	/* Use maximum duration order by default */
+	if (info->attrs[NL802154_ATTR_SCAN_DURATION])
 		request->duration = nla_get_u8(info->attrs[NL802154_ATTR_SCAN_DURATION]);
-		if (request->duration > IEEE802154_MAX_SCAN_DURATION) {
-			pr_err("Duration is out of range\n");
-			err = -EINVAL;
-			goto free_request;
-		}
-	} else {
-		/* Use maximum duration order by default */
+	else
 		request->duration = IEEE802154_MAX_SCAN_DURATION;
-	}
 
 	if (wpan_dev->netdev)
 		dev_hold(wpan_dev->netdev);
@@ -1614,17 +1592,11 @@ nl802154_send_beacons(struct sk_buff *skb, struct genl_info *info)
 	request->wpan_dev = wpan_dev;
 	request->wpan_phy = wpan_phy;
 
-	if (info->attrs[NL802154_ATTR_BEACON_INTERVAL]) {
+	/* Use maximum duration order by default */
+	if (info->attrs[NL802154_ATTR_BEACON_INTERVAL])
 		request->interval = nla_get_u8(info->attrs[NL802154_ATTR_BEACON_INTERVAL]);
-		if (request->interval > IEEE802154_MAX_SCAN_DURATION) {
-			pr_err("Interval is out of range\n");
-			err = -EINVAL;
-			goto free_request;
-		}
-	} else {
-		/* Use maximum duration order by default */
+	else
 		request->interval = IEEE802154_MAX_SCAN_DURATION;
-	}
 
 	if (wpan_dev->netdev)
 		dev_hold(wpan_dev->netdev);
@@ -1640,7 +1612,7 @@ nl802154_send_beacons(struct sk_buff *skb, struct genl_info *info)
 free_device:
 	if (wpan_dev->netdev)
 		dev_put(wpan_dev->netdev);
-free_request:
+
 	kfree(request);
 
 	return err;
-- 
2.34.1

