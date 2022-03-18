Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA8D4DE174
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240265AbiCRS6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 14:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240269AbiCRS6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 14:58:12 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525EF22C6D7;
        Fri, 18 Mar 2022 11:56:53 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 77F63C0004;
        Fri, 18 Mar 2022 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647629811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KjQVyusI/NoALoNPcEIOjSAiTZnq5f6jB56z0p4Letc=;
        b=DUUBqZPpnOEHs7eNnLNw+aV838Ev+4EYkioDRr0ErEgfkk5qcIyXob5Kia7UZxM4xu6fSD
        UC5GdlEuWz16ncNWNHRq1TSApdukAAvm9KLx8bTPnoomxVUyAPLMGNtcFimkzccz8A6Ifq
        9B0IRCu7lFMol9N4tPu8T2sgmS/GsAlXdqJ/lCmicpNx0JYkFYoIHeGUzaLt6mH9BkINmC
        RtuYUuEe2F4cYvGDP5Yhd/eHTXIapUxIqN+zIW33+wYYCYxGRexPpBzLEZPKUfmHSl4J0y
        gIzAeKYA8NsATW0RmKyCS85Zbi5bNgHRbvAyfQuGFLHC7UTL1wZrsdzy+rqjug==
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
Subject: [PATCH wpan-next v4 03/11] net: mac802154: Save a global error code on transmissions
Date:   Fri, 18 Mar 2022 19:56:36 +0100
Message-Id: <20220318185644.517164-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220318185644.517164-1-miquel.raynal@bootlin.com>
References: <20220318185644.517164-1-miquel.raynal@bootlin.com>
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

So far no error is returned from a failing transmission. However it
might sometimes be useful, and particularly easy to use during sync
transfers (for certain MLME commands). Let's create an internal variable
for that, global to the device. Right now only success are registered,
which is rather useless, but soon we will have more situations filling
this field.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h | 2 ++
 net/mac802154/util.c         | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 702560acc8ce..1381e6a5e180 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -56,6 +56,8 @@ struct ieee802154_local {
 
 	struct sk_buff *tx_skb;
 	struct work_struct tx_work;
+	/* A negative Linux error code or a null/positive MLME error status */
+	int tx_result;
 };
 
 enum {
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index f2078238718b..0bf46f174de3 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -58,8 +58,11 @@ enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer)
 void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 			      bool ifs_handling)
 {
+	struct ieee802154_local *local = hw_to_local(hw);
+
+	local->tx_result = IEEE802154_SUCCESS;
+
 	if (ifs_handling) {
-		struct ieee802154_local *local = hw_to_local(hw);
 		u8 max_sifs_size;
 
 		/* If transceiver sets CRC on his own we need to use lifs
-- 
2.27.0

