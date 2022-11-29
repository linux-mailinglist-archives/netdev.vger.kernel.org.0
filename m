Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495E363C48D
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbiK2QDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbiK2QCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:02:20 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CEB64577;
        Tue, 29 Nov 2022 08:00:59 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 663271C0007;
        Tue, 29 Nov 2022 16:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669737658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZqVf5GiegObnHu2tH8XCQnLc7w6eelIqnh/044Qa8EU=;
        b=pKqBYMO9zmdrO3eFyor3b13gSmxb0tifdv7OiLLhPYUQuP8QME84tc2H2buyysVrL7PyVt
        NY9blVhZYUFh6iYHmk/1VAljqW8RKkR1XJBLe/RZ4h5XgF5PfAQLozst88T6xEsyr3AKok
        wFdYktXiJM95MEa6fBbg30ojSWDISELIT9aEGrU7ciQYqKErbCs7StRTK2jQVkTl73Vntq
        HWxRBSwkIYhp8Qeu5wbUuf25bZStraZjddzM0Q3iiqCIuZywlld/m7I8QfoUtj1eU+cdQ+
        jsP1JB8pDD8JInWu2S72hlW1P5GeXL7YgV/fNJLouctYLPYEq+7Ob5vJe2HmiQ==
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
Subject: [PATCH wpan-next 3/6] ieee802154: Introduce a helper to validate a channel
Date:   Tue, 29 Nov 2022 17:00:43 +0100
Message-Id: <20221129160046.538864-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129160046.538864-1-miquel.raynal@bootlin.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
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

This helper for now only checks if the page member and channel member
are valid (in the specification range) and supported (by checking the
device capabilities). Soon two new parameters will be introduced and
having this helper will let us only modify its content rather than
modifying the logic everywhere else in the subsystem.

There is not functional change.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h   | 11 +++++++++++
 net/ieee802154/nl802154.c |  3 +--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 76d4f95e9974..11bedfa96371 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -246,6 +246,17 @@ static inline void wpan_phy_net_set(struct wpan_phy *wpan_phy, struct net *net)
 	write_pnet(&wpan_phy->_net, net);
 }
 
+static inline bool ieee802154_chan_is_valid(struct wpan_phy *phy,
+                                            u8 page, u8 channel)
+{
+        if (page > IEEE802154_MAX_PAGE ||
+            channel > IEEE802154_MAX_CHANNEL ||
+            !(phy->supported.channels[page] & BIT(channel)))
+                return false;
+
+	return true;
+}
+
 /**
  * struct ieee802154_addr - IEEE802.15.4 device address
  * @mode: Address mode from frame header. Can be one of:
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index c497ffd8e897..d0c169e8b1b7 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -975,8 +975,7 @@ static int nl802154_set_channel(struct sk_buff *skb, struct genl_info *info)
 	channel = nla_get_u8(info->attrs[NL802154_ATTR_CHANNEL]);
 
 	/* check 802.15.4 constraints */
-	if (page > IEEE802154_MAX_PAGE || channel > IEEE802154_MAX_CHANNEL ||
-	    !(rdev->wpan_phy.supported.channels[page] & BIT(channel)))
+	if (!ieee802154_chan_is_valid(&rdev->wpan_phy, page, channel))
 		return -EINVAL;
 
 	return rdev_set_channel(rdev, page, channel);
-- 
2.34.1

