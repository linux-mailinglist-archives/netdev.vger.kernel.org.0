Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF9C47D47C
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343814AbhLVP5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:57:51 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42625 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343791AbhLVP5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:57:48 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id E421060006;
        Wed, 22 Dec 2021 15:57:45 +0000 (UTC)
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
Subject: [net-next 01/18] ieee802154: hwsim: Ensure proper channel selection at probe time
Date:   Wed, 22 Dec 2021 16:57:26 +0100
Message-Id: <20211222155743.256280-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155743.256280-1-miquel.raynal@bootlin.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A default channel is selected by default (13), let's clarify that this
is page 0 channel 13. Call the right helper to ensure the necessary
configuration for this channel has been applied.

So far there is very little configuration done in this helper but we
will soon add more information (like the symbol duration which is
missing) and having this helper called at probe time will prevent us to
this type of initialization at two different locations.

So far there is very little configuration done in this helper but thanks
to this improvement, future enhancements in this area (like setting a
symbol duration, which is missing) will be reflected automatically in
the default probe state.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 62ced7a30d92..b1a4ee7dceda 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -778,8 +778,6 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 
 	ieee802154_random_extended_addr(&hw->phy->perm_extended_addr);
 
-	/* hwsim phy channel 13 as default */
-	hw->phy->current_channel = 13;
 	pib = kzalloc(sizeof(*pib), GFP_KERNEL);
 	if (!pib) {
 		err = -ENOMEM;
@@ -793,6 +791,11 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 	hw->flags = IEEE802154_HW_PROMISCUOUS | IEEE802154_HW_RX_DROP_BAD_CKSUM;
 	hw->parent = dev;
 
+	/* Set page 0 / channel 13 as default */
+	hw->phy->current_page = 0;
+	hw->phy->current_channel = 13;
+	hwsim_hw_channel(hw, hw->phy->current_page, hw->phy->current_channel);
+
 	err = ieee802154_register_hw(hw);
 	if (err)
 		goto err_reg;
-- 
2.27.0

