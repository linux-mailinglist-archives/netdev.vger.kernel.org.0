Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BFC4907E5
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239431AbiAQL4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:56:20 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:36365 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236730AbiAQLz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:56 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 06231200009;
        Mon, 17 Jan 2022 11:55:53 +0000 (UTC)
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
Subject: [PATCH v3 40/41] net: ieee802154: Handle limited devices with only datagram support
Date:   Mon, 17 Jan 2022 12:54:39 +0100
Message-Id: <20220117115440.60296-41-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices, like hardMAC ones can be a bit limited in the way they
handle mac commands. In particular, they might just not support it at
all and instead only be able to transmit and receive regular data
packets. In this case, they cannot be used for any of the internal
management commands that we have introduced so far and must be flagged
accordingly.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h   | 3 +++
 net/ieee802154/nl802154.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 57bbc7eb22df..98a202e0e626 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -301,11 +301,14 @@ wpan_phy_cca_cmp(const struct wpan_phy_cca *a, const struct wpan_phy_cca *b)
  *	level setting.
  * @WPAN_PHY_FLAG_CCA_MODE: Indicates that transceiver will support cca mode
  *	setting.
+ * @WPAN_PHY_FLAG_DATAGRAMS_ONLY: Indicates that transceiver is only able to
+ *	send/receive datagrams.
  */
 enum wpan_phy_flags {
 	WPAN_PHY_FLAG_TXPOWER		= BIT(1),
 	WPAN_PHY_FLAG_CCA_ED_LEVEL	= BIT(2),
 	WPAN_PHY_FLAG_CCA_MODE		= BIT(3),
+	WPAN_PHY_FLAG_DATAGRAMS_ONLY	= BIT(4),
 };
 
 struct wpan_phy {
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 1a0ce95625ec..443e5aba1aa9 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1323,6 +1323,9 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
 		return -EOPNOTSUPP;
 
+	if (wpan_phy->flags & WPAN_PHY_FLAG_DATAGRAMS_ONLY)
+		return -EOPNOTSUPP;
+
 	request = kzalloc(sizeof(*request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
@@ -1699,6 +1702,9 @@ nl802154_send_beacons(struct sk_buff *skb, struct genl_info *info)
 	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
 		return -EOPNOTSUPP;
 
+	if (wpan_phy->flags & WPAN_PHY_FLAG_DATAGRAMS_ONLY)
+		return -EOPNOTSUPP;
+
 	request = kzalloc(sizeof(*request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
-- 
2.27.0

