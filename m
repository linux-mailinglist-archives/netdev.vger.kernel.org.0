Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69645494CC3
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiATLV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:21:29 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:52347 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiATLVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:21:23 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8CCA3C000B;
        Thu, 20 Jan 2022 11:21:20 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next v2 2/9] net: ieee802154: hwsim: Ensure frame checksum are valid
Date:   Thu, 20 Jan 2022 12:21:08 +0100
Message-Id: <20220120112115.448077-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120112115.448077-1-miquel.raynal@bootlin.com>
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
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
index 795f8eb5387b..5324d0eda223 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -784,7 +784,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 	phy->idx = idx;
 	INIT_LIST_HEAD(&phy->edges);
 
-	hw->flags = IEEE802154_HW_PROMISCUOUS;
+	hw->flags = IEEE802154_HW_PROMISCUOUS | IEEE802154_HW_RX_DROP_BAD_CKSUM;
 	hw->parent = dev;
 
 	err = ieee802154_register_hw(hw);
-- 
2.27.0

