Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615A45F759B
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 10:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiJGIxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 04:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiJGIxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 04:53:37 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0A81162CB;
        Fri,  7 Oct 2022 01:53:32 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 827A61BF208;
        Fri,  7 Oct 2022 08:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1665132811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XMaavvy9ZLPs79IZwb/reQLhHU8ZXq4T8f0Cq0g2VLc=;
        b=EFTZHc/ihm9Q+Ye6yS+pw1/bDr+gEjmZWa+dVtuV4dD015WKNyLq2DKZeZc2nIaY/WxlY1
        o8DcxJbB+FN/AO8S+l3QTJTH3bpbVwAh4lqNW42mTzseUVu/iJrWZ9YCy7x+IyGu7/RyBF
        GgzOxGztNIYxL3BMJNCrTVZsl6hhb0VJh1D9faG2n03kZe5jTyKJQ59G+nkU5pgdZR0bK2
        yMdu/7RtrOjRl7u+cmAfcwIMKu/19k040yMm9Iwx6f/HNAP6ZRE0wxE/5yYn71EeVly62j
        GzCLV8RUlfUsrmPryz6gHwJHeaSmf/0E/Hua8/jM+Tc9WbtFnEc3V8xLWRkeKA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan/next v4 6/8] mac802154: Drop IEEE802154_HW_RX_DROP_BAD_CKSUM
Date:   Fri,  7 Oct 2022 10:53:08 +0200
Message-Id: <20221007085310.503366-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221007085310.503366-1-miquel.raynal@bootlin.com>
References: <20221007085310.503366-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This IEEE802154_HW_RX_DROP_BAD_CKSUM flag was only used by hwsim to
reflect the fact that it would not validate the checksum (FCS). So this
was only useful while the only filtering level hwsim was capable of was
"NONE". Now that the driver has been improved we no longer need this
flag.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 3 ++-
 include/net/mac802154.h                  | 4 ----
 net/mac802154/rx.c                       | 7 ++-----
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 84ee948f35bc..d98f62e9a97d 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -288,6 +288,7 @@ static int hwsim_hw_start(struct ieee802154_hw *hw)
 	struct hwsim_phy *phy = hw->priv;
 
 	phy->suspended = false;
+
 	return 0;
 }
 
@@ -934,7 +935,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 	phy->idx = idx;
 	INIT_LIST_HEAD(&phy->edges);
 
-	hw->flags = IEEE802154_HW_PROMISCUOUS | IEEE802154_HW_RX_DROP_BAD_CKSUM;
+	hw->flags = IEEE802154_HW_PROMISCUOUS;
 	hw->parent = dev;
 
 	err = ieee802154_register_hw(hw);
diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index 357d25ef627a..4a3a9de9da73 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -111,9 +111,6 @@ struct ieee802154_hw {
  *	promiscuous mode setting.
  *
  * @IEEE802154_HW_RX_OMIT_CKSUM: Indicates that receiver omits FCS.
- *
- * @IEEE802154_HW_RX_DROP_BAD_CKSUM: Indicates that receiver will not filter
- *	frames with bad checksum.
  */
 enum ieee802154_hw_flags {
 	IEEE802154_HW_TX_OMIT_CKSUM	= BIT(0),
@@ -123,7 +120,6 @@ enum ieee802154_hw_flags {
 	IEEE802154_HW_AFILT		= BIT(4),
 	IEEE802154_HW_PROMISCUOUS	= BIT(5),
 	IEEE802154_HW_RX_OMIT_CKSUM	= BIT(6),
-	IEEE802154_HW_RX_DROP_BAD_CKSUM	= BIT(7),
 };
 
 /* Indicates that receiver omits FCS and xmitter will add FCS on it's own. */
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index b68d62335f66..8438bdcd5042 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -279,11 +279,8 @@ void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb)
 	 * IEEE802154_FILTERING_NONE level during a scan.
 	 */
 
-	/* Check if transceiver doesn't validate the checksum.
-	 * If not we validate the checksum here.
-	 */
-	if (local->hw.flags & IEEE802154_HW_RX_DROP_BAD_CKSUM ||
-	    local->phy->filtering == IEEE802154_FILTERING_NONE) {
+	/* Level 1 filtering: Check the FCS by software when relevant */
+	if (local->hw.phy->filtering == IEEE802154_FILTERING_NONE) {
 		crc = crc_ccitt(0, skb->data, skb->len);
 		if (crc) {
 			rcu_read_unlock();
-- 
2.34.1

