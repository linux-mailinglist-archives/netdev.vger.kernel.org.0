Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D03490779
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbiAQLyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239270AbiAQLyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:54:49 -0500
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE3FC061574;
        Mon, 17 Jan 2022 03:54:48 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 0C25620000D;
        Mon, 17 Jan 2022 11:54:44 +0000 (UTC)
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
Subject: [PATCH v3 02/41] net: ieee802154: hwsim: Ensure proper channel selection at probe time
Date:   Mon, 17 Jan 2022 12:54:01 +0100
Message-Id: <20220117115440.60296-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers are expected to set the PHY current_channel and current_page
according to their default state. The hwsim driver is advertising being
configured on channel 13 by default but that is not reflected in its own
internal pib structure. In order to ensure that this driver consider the
current channel as being 13 internally, we can call hwsim_hw_channel()
instead of creating an empty pib structure.

We assume here that kvfree_rcu(NULL) is a valid call.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 8caa61ec718f..795f8eb5387b 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -732,7 +732,6 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 {
 	struct ieee802154_hw *hw;
 	struct hwsim_phy *phy;
-	struct hwsim_pib *pib;
 	int idx;
 	int err;
 
@@ -780,13 +779,8 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 
 	/* hwsim phy channel 13 as default */
 	hw->phy->current_channel = 13;
-	pib = kzalloc(sizeof(*pib), GFP_KERNEL);
-	if (!pib) {
-		err = -ENOMEM;
-		goto err_pib;
-	}
+	hwsim_hw_channel(hw, hw->phy->current_page, hw->phy->current_channel);
 
-	rcu_assign_pointer(phy->pib, pib);
 	phy->idx = idx;
 	INIT_LIST_HEAD(&phy->edges);
 
@@ -815,8 +809,6 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 err_subscribe:
 	ieee802154_unregister_hw(phy->hw);
 err_reg:
-	kfree(pib);
-err_pib:
 	ieee802154_free_hw(phy->hw);
 	return err;
 }
-- 
2.27.0

