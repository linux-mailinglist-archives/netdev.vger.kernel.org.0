Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F000B49451C
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357963AbiATAvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357947AbiATAva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:51:30 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E28C06161C;
        Wed, 19 Jan 2022 16:51:29 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 33876100006;
        Thu, 20 Jan 2022 00:51:27 +0000 (UTC)
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
Subject: [wpan-next 02/14] net: mac802154: Create a transmit error helper
Date:   Thu, 20 Jan 2022 01:51:10 +0100
Message-Id: <20220120005122.309104-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120005122.309104-1-miquel.raynal@bootlin.com>
References: <20220120005122.309104-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far there is only a helper for successful transmission, which led
device drivers to implement their own handling in case of
error. Unfortunately, we really need all the drivers to give the hand
back to the core once they are done in order to be able to build a
proper synchronous API. So let's create a _xmit_error() helper.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/mac802154.h | 10 ++++++++++
 net/mac802154/util.c    |  9 +++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index 94b2e3008e77..e7443e1acde8 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -498,4 +498,14 @@ void ieee802154_stop_queue(struct ieee802154_hw *hw);
 void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 			      bool ifs_handling);
 
+/**
+ * ieee802154_xmit_error - frame transmission failed
+ *
+ * @hw: pointer as obtained from ieee802154_alloc_hw().
+ * @skb: buffer for transmission
+ * @ifs_handling: indicate interframe space handling
+ */
+void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
+			   bool ifs_handling);
+
 #endif /* NET_MAC802154_H */
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 4c06a6bd391a..8e7e4cf16fc3 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -94,6 +94,15 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(ieee802154_xmit_complete);
 
+
+void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
+			   bool ifs_handling)
+{
+	ieee802154_wakeup_after_xmit_done(hw, skb, ifs_handling);
+	dev_kfree_skb_any(skb);
+}
+EXPORT_SYMBOL(ieee802154_xmit_error);
+
 void ieee802154_stop_device(struct ieee802154_local *local)
 {
 	flush_workqueue(local->workqueue);
-- 
2.27.0

