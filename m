Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF7D5ADA44
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 22:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiIEUeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 16:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbiIEUeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 16:34:31 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3207ABC9D;
        Mon,  5 Sep 2022 13:34:27 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0E7D4FF80D;
        Mon,  5 Sep 2022 20:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662410066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/e293u4SAALQGFw2YMCR7A1y/RTvMly0aNfu43ICJMU=;
        b=JGxS9e1pyjStB26Q+drkPY9ybTCC7nsoW4GtESNzWqYc09ifNlsheHQJwX6pQFiw0NxGYZ
        sev7D/bDHXD/ZCnWh+VNufECACvWGT7w6P5Nu3mYtEqvoxM1sqYurc/k8Op0RV+PAsAIY3
        3nVdGSWXYX0P7D15TVstonrwFGpQsGKT8FauOebXBeORM37NpulEnlO9YT55Lict1zMrAK
        MejU4UijXbqLOpRKay3gqeCB7XM7FsPMwkCdoxsXcyqaYHkEeeqAmrfabc5fzlMmE6+LaO
        UVmfLi4/j/4PUASjpYeUWbStdGEKVevsCuh+9RSeNZQmVuYNWrqirPeKPmqJnQ==
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
Subject: [PATCH wpan/next v3 5/9] net: mac802154: Drop IEEE802154_HW_RX_DROP_BAD_CKSUM
Date:   Mon,  5 Sep 2022 22:34:08 +0200
Message-Id: <20220905203412.1322947-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This IEEE802154_HW_RX_DROP_BAD_CKSUM flag was only used by hwsim to
reflect the fact that it would not validate the checksum (FCS). In other
words, the filtering level of hwsim is always "NONE" while the core
expects it to be higher.

Now that we have access to real filtering levels, we can actually use
them and always enforce the "NONE" level in hwsim. This case is already
correctly handled in the receive so we can drop the flag.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 3 ++-
 include/net/mac802154.h                  | 4 ----
 net/mac802154/rx.c                       | 7 ++-----
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 38c217bd7c82..d18a1391b61f 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -148,6 +148,7 @@ static int hwsim_hw_start(struct ieee802154_hw *hw)
 	struct hwsim_phy *phy = hw->priv;
 
 	phy->suspended = false;
+	hw->phy->filtering = IEEE802154_FILTERING_NONE;
 	return 0;
 }
 
@@ -791,7 +792,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
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
index 26df79911f3e..bd1a92fceef7 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -270,15 +270,12 @@ void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb)
 
 	ieee802154_monitors_rx(local, skb);
 
-	/* Check if transceiver doesn't validate the checksum.
-	 * If not we validate the checksum here.
-	 */
+	/* Level 1 filtering: Check the FCS by software when relevant */
 	/* TODO do whatever you want here if necessary to filter by
 	 * check on IEEE802154_FILTERING_NONE. And upcomming receive
 	 * path in which state the phy is e.g. scanning.
 	 */
-	if (local->hw.flags & IEEE802154_HW_RX_DROP_BAD_CKSUM ||
-	    local->phy->filtering == IEEE802154_FILTERING_NONE) {
+	if (local->hw.phy->filtering == IEEE802154_FILTERING_NONE) {
 		crc = crc_ccitt(0, skb->data, skb->len);
 		if (crc) {
 			rcu_read_unlock();
-- 
2.34.1

