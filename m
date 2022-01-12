Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB8548C975
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355628AbiALRda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:33:30 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:48927 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355606AbiALRdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:33:23 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 9E37320004;
        Wed, 12 Jan 2022 17:33:17 +0000 (UTC)
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
Subject: [wpan-next v2 02/27] net: mac802154: Ensure proper channel selection at probe time
Date:   Wed, 12 Jan 2022 18:32:47 +0100
Message-Id: <20220112173312.764660-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173312.764660-1-miquel.raynal@bootlin.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now device drivers are encouraged to just set the ->current_page
and ->current_channel to indicate about the current state of the
hardware but this is far from ideal given the fact that we might want to
configure a few things internally, such as the symbol duration.

Call the ieee802154_change_channel() helper from the code section
registering the hardware to ensure proper channel selection and
configuration both on the device side and the core side.

This change somehow "fixes" the hwsim driver which advertises using page
0 channel 13, but does not actually update its own internal pib
structure to reflect that configuration.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/cfg.c          | 3 +--
 net/mac802154/ieee802154_i.h | 1 +
 net/mac802154/main.c         | 8 ++++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
index 870e442bbff0..6969f1330ccd 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -102,8 +102,7 @@ ieee802154_del_iface(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev)
 	return 0;
 }
 
-static int
-ieee802154_change_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
+int ieee802154_change_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
 {
 	struct ieee802154_local *local = wpan_phy_priv(wpan_phy);
 	int ret;
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 702560acc8ce..8a7f4c83c5b6 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -127,6 +127,7 @@ ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 netdev_tx_t
 ieee802154_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
 enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer);
+int ieee802154_change_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel);
 
 /* MIB callbacks */
 void mac802154_dev_set_page_channel(struct net_device *dev, u8 page, u8 chan);
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 520cedc594e1..12ab1545e871 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -157,6 +157,14 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
 
 	ieee802154_setup_wpan_phy_pib(local->phy);
 
+	/* Ensure proper channel selection */
+	rtnl_lock();
+	rc = ieee802154_change_channel(local->phy, local->phy->current_page,
+				       local->phy->current_channel);
+	rtnl_unlock();
+	if (rc)
+		goto out_wq;
+
 	if (!(hw->flags & IEEE802154_HW_CSMA_PARAMS)) {
 		local->phy->supported.min_csma_backoffs = 4;
 		local->phy->supported.max_csma_backoffs = 4;
-- 
2.27.0

