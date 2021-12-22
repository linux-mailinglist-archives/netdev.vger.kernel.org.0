Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B7047D481
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343818AbhLVP54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:57:56 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43853 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343806AbhLVP5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:57:50 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 4CD4660011;
        Wed, 22 Dec 2021 15:57:47 +0000 (UTC)
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
Subject: [net-next 02/18] ieee802154: hwsim: Provide a symbol duration
Date:   Wed, 22 Dec 2021 16:57:27 +0100
Message-Id: <20211222155743.256280-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155743.256280-1-miquel.raynal@bootlin.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the symbol duration in the softMAC hwsim driver. The symbol
durations are provided in micro-seconds and are extracted from the IEEE
802.15.4 specification thanks to the other parameters and comments from
this driver.

Some of these durations are hard to find/derive, so they are left to 1
in order to avoid null values (for the upcoming changes related to
scanning). In this case a comment is stating that the value in unknown.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 70 ++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index b1a4ee7dceda..38be88db5f7a 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -92,6 +92,7 @@ static int hwsim_hw_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
 {
 	struct hwsim_phy *phy = hw->priv;
 	struct hwsim_pib *pib, *pib_old;
+	int ret = 0;
 
 	pib = kzalloc(sizeof(*pib), GFP_KERNEL);
 	if (!pib)
@@ -99,6 +100,75 @@ static int hwsim_hw_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
 
 	pib->page = page;
 	pib->channel = channel;
+	switch (page) {
+	case 0:
+		if (BIT(channel) & 0x1)
+			/* 868 MHz BPSK	802.15.4-2003: 20 ksym/s */
+			hw->phy->symbol_duration = 50;
+		else if (BIT(channel) & 0x7fe)
+			/* 915 MHz BPSK	802.15.4-2003: 40 ksym/s */
+			hw->phy->symbol_duration = 25;
+		else if (BIT(channel) & 0x7FFF800)
+			/* 2.4 GHz O-QPSK 802.15.4-2003: 62.5 ksym/s */
+			hw->phy->symbol_duration = 16;
+		else
+			ret = -EINVAL;
+		break;
+	case 1:
+		if (BIT(channel) & (0x1 | 0x7fe))
+			/* unknown rate */
+			hw->phy->symbol_duration = 1;
+		else
+			ret = -EINVAL;
+		break;
+	case 2:
+		if (BIT(channel) & 0x1)
+			/* 868 MHz O-QPSK 802.15.4-2006: 25 ksym/s */
+			hw->phy->symbol_duration = 40;
+		else if (BIT(channel) & 0x7fe)
+			/* 915 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
+			hw->phy->symbol_duration = 16;
+		else
+			ret = -EINVAL;
+		break;
+	case 3:
+		if (BIT(channel) & 0x3fff)
+			/* 2.4 GHz CSS 802.15.4a-2007: 1/6 Msym/s */
+			hw->phy->symbol_duration = 6;
+		else
+			ret = -EINVAL;
+		break;
+	case 4:
+		if (BIT(channel) & (0x1 | 0x1e | 0xffe0))
+			/* UWB 802.15.4a-2007: 993.6 or 1017.6 or 3974.4 us */
+			hw->phy->symbol_duration = 1;
+		else
+			ret = -EINVAL;
+		break;
+	case 5:
+		if (BIT(channel) & (0xf | 0xf0))
+			/* unknown rate */
+			hw->phy->symbol_duration = 1;
+		else
+			ret = -EINVAL;
+		break;
+	case 6:
+		if (BIT(channel) & (0x3ff | 0x3ffc00))
+			/* unknown rate */
+			hw->phy->symbol_duration = 1;
+		else
+			ret = -EINVAL;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret) {
+		dev_err(hw->parent, "Invalid channel %d on page %d\n",
+			page, channel);
+		kfree(pib);
+		return ret;
+	}
 
 	pib_old = rtnl_dereference(phy->pib);
 	rcu_assign_pointer(phy->pib, pib);
-- 
2.27.0

