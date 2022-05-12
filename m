Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEFA525014
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355345AbiELOdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355333AbiELOda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:33:30 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45246212F;
        Thu, 12 May 2022 07:33:28 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4B640FF810;
        Thu, 12 May 2022 14:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652366007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=clOTNfcav5e2Rl56dshE0pUuBaw8a/+j0I57ckwZwNI=;
        b=KUznLL3JWBXA1cCf0G4MGqy488vkLYyf6sTzDpEPJZjO9Kklism7FV/NKFtSn8TGt6cTZS
        8UKUGI+d0YzC22ZGYsbKRunUQN5ZUGvOaZp9miJYEzQAKlh9BGFH+7k9Xmc0rUXWO6NO9m
        FZjLqhudksJ7gYFo9v7lgNB/4q6hkxPRanmwmLNO45j1RUWumVMP9wbZyre121gDM19VLx
        YcuFR/o+udkJJpSRh74Thh4ustfEjZHwWDPh9KAMNqQT1vN8lljesDhym/AXezYG0qJw8u
        wcLL1/689E/EBtKKq+IImQboXBe1uAtv5tjRnQ41r0XK+P28HqF8tvr9MEqj3g==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 06/11] net: mac802154: Create a hot tx path
Date:   Thu, 12 May 2022 16:33:09 +0200
Message-Id: <20220512143314.235604-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220512143314.235604-1-miquel.raynal@bootlin.com>
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
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

Let's rename the current Tx path to show that this is the "hot" Tx
path. We will soon introduce a slower Tx path for MLME commands.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/tx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 6a53c83cf039..607019b8f8ab 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -106,6 +106,12 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
+static netdev_tx_t
+ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
+{
+	return ieee802154_tx(local, skb);
+}
+
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
@@ -113,7 +119,7 @@ ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb->skb_iif = dev->ifindex;
 
-	return ieee802154_tx(sdata->local, skb);
+	return ieee802154_hot_tx(sdata->local, skb);
 }
 
 netdev_tx_t
@@ -135,5 +141,5 @@ ieee802154_subif_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb->skb_iif = dev->ifindex;
 
-	return ieee802154_tx(sdata->local, skb);
+	return ieee802154_hot_tx(sdata->local, skb);
 }
-- 
2.27.0

