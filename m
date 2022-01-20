Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F7A494514
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357930AbiATAv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:51:29 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:42765 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357906AbiATAv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:51:28 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7B530100004;
        Thu, 20 Jan 2022 00:51:25 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next 01/14] net: ieee802154: Move the logic restarting the queue upon transmission
Date:   Thu, 20 Jan 2022 01:51:09 +0100
Message-Id: <20220120005122.309104-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120005122.309104-1-miquel.raynal@bootlin.com>
References: <20220120005122.309104-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new helper with the logic restarting the queue upon
transmission, so that we can create a second path for error conditions
which can reuse that code easily.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/util.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index f2078238718b..4c06a6bd391a 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -55,8 +55,9 @@ enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
-			      bool ifs_handling)
+static void
+ieee802154_wakeup_after_xmit_done(struct ieee802154_hw *hw, struct sk_buff *skb,
+				  bool ifs_handling)
 {
 	if (ifs_handling) {
 		struct ieee802154_local *local = hw_to_local(hw);
@@ -83,7 +84,12 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 	} else {
 		ieee802154_wake_queue(hw);
 	}
+}
 
+void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
+			      bool ifs_handling)
+{
+	ieee802154_wakeup_after_xmit_done(hw, skb, ifs_handling);
 	dev_consume_skb_any(skb);
 }
 EXPORT_SYMBOL(ieee802154_xmit_complete);
-- 
2.27.0

