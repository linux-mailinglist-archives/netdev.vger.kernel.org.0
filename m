Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0CF4AC273
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380812AbiBGPFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442263AbiBGOsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:48:12 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F73C0401C2;
        Mon,  7 Feb 2022 06:48:11 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 81D332000B;
        Mon,  7 Feb 2022 14:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644245289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vDrO3Tw9p4ErYkEAD53kXKEoAP/91adCzTKGwaYTCW8=;
        b=VGX00/Vm5BDswDYKP7TX/wNl9Y7+cHgIgOK/2JvI4RHpvu+yx8nuNfLLztEwIe/QL6um/Y
        4lJipH7R0KRte9ksBzGsbwMpBpW/ecmAkidWFUSFvRfLOOTK57FEc/siUTkUVv/ndFoRnB
        tYA3oiwYXO6DK6LuuVLOm4g9daOexdZNut7ZiOstaizXjQpb7GIfISxqV3xvoURw5odU7S
        QnkNrwBWk3ePgPJI9tr9sp6Hf0+nbGB6ZOvCu9AYo+Z3lqAG4IJ4YepMEOY85s4UhRT6Ft
        6QkGdgAVwMdok0OG7X04aJJr0BD6eYqNrxd5yznBuqxdrii/xAtLRmqj1Eqh3w==
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
Subject: [PATCH wpan-next v2 02/14] net: mac802154: Create a transmit error helper
Date:   Mon,  7 Feb 2022 15:47:52 +0100
Message-Id: <20220207144804.708118-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220207144804.708118-1-miquel.raynal@bootlin.com>
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 net/mac802154/util.c    | 10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index 2c3bbc6645ba..9fe8cfef1ba0 100644
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
index 6f82418e9dec..9016f634efba 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -102,6 +102,16 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(ieee802154_xmit_complete);
 
+void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
+			   bool ifs_handling)
+{
+	unsigned int skb_len = skb->len;
+
+	dev_kfree_skb_any(skb);
+	ieee802154_xmit_end(hw, ifs_handling, skb_len);
+}
+EXPORT_SYMBOL(ieee802154_xmit_error);
+
 void ieee802154_stop_device(struct ieee802154_local *local)
 {
 	flush_workqueue(local->workqueue);
-- 
2.27.0

