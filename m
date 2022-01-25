Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800E649B3FB
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 13:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383378AbiAYM2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 07:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383196AbiAYMZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 07:25:52 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B207BC06173B;
        Tue, 25 Jan 2022 04:25:46 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 475EAFF811;
        Tue, 25 Jan 2022 12:25:43 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next v3 1/3] net: ieee802154: hwsim: Ensure frame checksum are valid
Date:   Tue, 25 Jan 2022 13:25:38 +0100
Message-Id: <20220125122540.855604-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220125122540.855604-1-miquel.raynal@bootlin.com>
References: <20220125122540.855604-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no point in accepting frames with a wrong or missing checksum,
at least not outside of a promiscuous setting. Set the right flag by
default in the hwsim driver to ensure checksums are not ignored.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 00ec188a3257..be77f489be13 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -791,7 +791,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 	phy->idx = idx;
 	INIT_LIST_HEAD(&phy->edges);
 
-	hw->flags = IEEE802154_HW_PROMISCUOUS;
+	hw->flags = IEEE802154_HW_PROMISCUOUS | IEEE802154_HW_RX_DROP_BAD_CKSUM;
 	hw->parent = dev;
 
 	err = ieee802154_register_hw(hw);
-- 
2.27.0

