Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB83748C970
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349996AbiALRdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:33:19 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:34129 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239618AbiALRdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:33:19 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id B8EDE20008;
        Wed, 12 Jan 2022 17:33:15 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-wireless@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next v2 01/27] net: mac802154: Split the set channel hook implementation
Date:   Wed, 12 Jan 2022 18:32:46 +0100
Message-Id: <20220112173312.764660-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173312.764660-1-miquel.raynal@bootlin.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it is currently designed, the set_channel() cfg802154 hook
implemented in the softMAC is doing a couple of checks before actually
performing the channel change. However, as we enhance the support for
automatically setting the symbol duration during channel changes, it
will also be needed to ensure that the corresponding channel as properly
be selected at probe time. In order to verify this, we will need to
separate the channel change from the previous checks. These checks are
actually here to speed up the process when the user request necessitates
no change, so we can safely bypass them.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/cfg.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
index fbeebe3bc31d..870e442bbff0 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -103,17 +103,13 @@ ieee802154_del_iface(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev)
 }
 
 static int
-ieee802154_set_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
+ieee802154_change_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
 {
 	struct ieee802154_local *local = wpan_phy_priv(wpan_phy);
 	int ret;
 
 	ASSERT_RTNL();
 
-	if (wpan_phy->current_page == page &&
-	    wpan_phy->current_channel == channel)
-		return 0;
-
 	ret = drv_set_channel(local, page, channel);
 	if (!ret) {
 		wpan_phy->current_page = page;
@@ -123,6 +119,18 @@ ieee802154_set_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
 	return ret;
 }
 
+static int
+ieee802154_set_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
+{
+	ASSERT_RTNL();
+
+	if (wpan_phy->current_page == page &&
+	    wpan_phy->current_channel == channel)
+		return 0;
+
+	return ieee802154_change_channel(wpan_phy, page, channel);
+}
+
 static int
 ieee802154_set_cca_mode(struct wpan_phy *wpan_phy,
 			const struct wpan_phy_cca *cca)
-- 
2.27.0

