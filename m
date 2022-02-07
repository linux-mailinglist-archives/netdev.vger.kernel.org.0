Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576924AC27F
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392409AbiBGPFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442262AbiBGOsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:48:11 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A354C0401C1;
        Mon,  7 Feb 2022 06:48:11 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0080C2000D;
        Mon,  7 Feb 2022 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644245288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SY+L3+slPcpKWWJh7GnVXx86tNNdeMS/KrYWUhmZKvM=;
        b=JQkBqzemwXIinqOfYHjTR0bOjiKe47RE1USmNq1ohRe/X1qopqo5RdNP7YhBsFh8OGrUbw
        h4xIYQW8emkbM5FWhlQLuX29+8jSenGX1Ux5YZpq8ybKsjIBk4l6DxZR2+f2Mid7kYPVl3
        UTw7nA/bcr5Aen1Dmp2uEEOpoS/2HeJm6eabxXvr0fsfaKOs+YNHQ0Js4x7duSbmwza+Ix
        WRiLD9x2NxcgA1cF2Z9KmuyGFcG9gnYsk639SGDsPJSVmzogZ4Jw4s+jK+cDJ66CUp8kY0
        dM7lytbZECMKwhSsOMwOr1ZtZ4MMqO4mFsMUaU9Smw4DS9JBPYne6lVPOwcLlA==
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
Subject: [PATCH wpan-next v2 01/14] net: ieee802154: Move the logic restarting the queue upon transmission
Date:   Mon,  7 Feb 2022 15:47:51 +0100
Message-Id: <20220207144804.708118-2-miquel.raynal@bootlin.com>
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

Create a new helper with the logic restarting the queue upon
transmission, so that we can create a second path for error conditions
which can reuse that code easily.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/util.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index f2078238718b..6f82418e9dec 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -55,8 +55,9 @@ enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
-			      bool ifs_handling)
+static void
+ieee802154_wakeup_after_xmit_done(struct ieee802154_hw *hw, bool ifs_handling,
+				  unsigned int skb_len)
 {
 	if (ifs_handling) {
 		struct ieee802154_local *local = hw_to_local(hw);
@@ -72,7 +73,7 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 		else
 			max_sifs_size = IEEE802154_MAX_SIFS_FRAME_SIZE;
 
-		if (skb->len > max_sifs_size)
+		if (skb_len > max_sifs_size)
 			hrtimer_start(&local->ifs_timer,
 				      hw->phy->lifs_period * NSEC_PER_USEC,
 				      HRTIMER_MODE_REL);
@@ -83,8 +84,21 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 	} else {
 		ieee802154_wake_queue(hw);
 	}
+}
+
+static void ieee802154_xmit_end(struct ieee802154_hw *hw, bool ifs_handling,
+				unsigned int skb_len)
+{
+	ieee802154_wakeup_after_xmit_done(hw, ifs_handling, skb_len);
+}
+
+void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
+			      bool ifs_handling)
+{
+	unsigned int skb_len = skb->len;
 
 	dev_consume_skb_any(skb);
+	ieee802154_xmit_end(hw, ifs_handling, skb_len);
 }
 EXPORT_SYMBOL(ieee802154_xmit_complete);
 
-- 
2.27.0

