Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674AD63C48F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235944AbiK2QDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbiK2QC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:02:29 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D04663E8;
        Tue, 29 Nov 2022 08:01:02 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DFB8F1C000E;
        Tue, 29 Nov 2022 16:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669737660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Sv2XO/O55kb2J+uLPNufzqPe9J0HvFTZ/fLIsNSQxw=;
        b=Sy0uxXOUNPFidS9zMVnwwXJfcWnsxyAgAChAtxH/0yMcsPtLmNqg9A9JXpZINFgkoQhKud
        MNPGp4c77Q/oxLTI8vXAlhbClGSmpez650ezCaPaQ++5EHtnAjzV5nZG9bBBbGgI8zBAID
        P9GogcYr7WC1XtbAW+xKa6t+vaCGcqXI76StF2jKtNyBZexpKRntYLKJmoWDcYzAJXAQkE
        QFo2uEVW2sLldZJAmVfi82eni/C8BgW+mGMJux4sogYVghpTW/+r1zk6Pw7rmzbnGevf5o
        6YSP/BoStZQ5xBWYzLk5qK7b67LvQE+j+vWZy3KlrWRO3EVQpRYn92O7bmcXmg==
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
Subject: [PATCH wpan-next 4/6] mac802154: Prepare forcing specific symbol duration
Date:   Tue, 29 Nov 2022 17:00:44 +0100
Message-Id: <20221129160046.538864-5-miquel.raynal@bootlin.com>
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

The scan logic will bypass the whole ->set_channel() logic from the top
by calling the driver hook to just switch between channels when
required.

We can no longer rely on the "current" page/channel settings to set the
right symbol duration. Let's add these as new parameters to allow
providing the page/channel couple that we want.

There is no functional change.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h |  3 ++-
 net/mac802154/cfg.c     |  2 +-
 net/mac802154/main.c    | 20 +++++++++++---------
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 11bedfa96371..5d4750d24f13 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -483,6 +483,7 @@ static inline const char *wpan_phy_name(struct wpan_phy *phy)
 	return dev_name(&phy->dev);
 }
 
-void ieee802154_configure_durations(struct wpan_phy *phy);
+void ieee802154_configure_durations(struct wpan_phy *phy,
+				    unsigned int page, unsigned int channel);
 
 #endif /* __NET_CFG802154_H */
diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
index dc2d918fac68..469d6e8dd2dd 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -118,7 +118,7 @@ ieee802154_set_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
 	if (!ret) {
 		wpan_phy->current_page = page;
 		wpan_phy->current_channel = channel;
-		ieee802154_configure_durations(wpan_phy);
+		ieee802154_configure_durations(wpan_phy, page, channel);
 	}
 
 	return ret;
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 3ed31daf7b9c..12a13a850fdf 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -113,32 +113,33 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 }
 EXPORT_SYMBOL(ieee802154_alloc_hw);
 
-void ieee802154_configure_durations(struct wpan_phy *phy)
+void ieee802154_configure_durations(struct wpan_phy *phy,
+				    unsigned int page, unsigned int channel)
 {
 	u32 duration = 0;
 
-	switch (phy->current_page) {
+	switch (page) {
 	case 0:
-		if (BIT(phy->current_channel) & 0x1)
+		if (BIT(channel) & 0x1)
 			/* 868 MHz BPSK 802.15.4-2003: 20 ksym/s */
 			duration = 50 * NSEC_PER_USEC;
-		else if (BIT(phy->current_channel) & 0x7FE)
+		else if (BIT(channel) & 0x7FE)
 			/* 915 MHz BPSK	802.15.4-2003: 40 ksym/s */
 			duration = 25 * NSEC_PER_USEC;
-		else if (BIT(phy->current_channel) & 0x7FFF800)
+		else if (BIT(channel) & 0x7FFF800)
 			/* 2400 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
 			duration = 16 * NSEC_PER_USEC;
 		break;
 	case 2:
-		if (BIT(phy->current_channel) & 0x1)
+		if (BIT(channel) & 0x1)
 			/* 868 MHz O-QPSK 802.15.4-2006: 25 ksym/s */
 			duration = 40 * NSEC_PER_USEC;
-		else if (BIT(phy->current_channel) & 0x7FE)
+		else if (BIT(channel) & 0x7FE)
 			/* 915 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
 			duration = 16 * NSEC_PER_USEC;
 		break;
 	case 3:
-		if (BIT(phy->current_channel) & 0x3FFF)
+		if (BIT(channel) & 0x3FFF)
 			/* 2.4 GHz CSS 802.15.4a-2007: 1/6 Msym/s */
 			duration = 6 * NSEC_PER_USEC;
 		break;
@@ -201,7 +202,8 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
 
 	ieee802154_setup_wpan_phy_pib(local->phy);
 
-	ieee802154_configure_durations(local->phy);
+	ieee802154_configure_durations(local->phy, local->phy->current_page,
+				       local->phy->current_channel);
 
 	if (!(hw->flags & IEEE802154_HW_CSMA_PARAMS)) {
 		local->phy->supported.min_csma_backoffs = 4;
-- 
2.34.1

