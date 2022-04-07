Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9FD4F7C77
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244157AbiDGKLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244129AbiDGKLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:11:33 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDB2237FCA;
        Thu,  7 Apr 2022 03:09:23 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 710EE60009;
        Thu,  7 Apr 2022 10:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649326162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ciS+k9VChIU4H5lHgCsYF4iRcuri5PAr+qW7SczT23g=;
        b=ddJ1QyAEYMuFQmzcQsiFXJxEXtaRqomeq89oujvWk+O8ULPdeGS+RCBQ6+Dlz308O2AEtu
        8BDslUIz5X3rgAjWR2xWxkutGB4oVOD3IOWKWPjZhpsgp39d9kQ0qYN8VyMryO7V+zJT6B
        0oq3KViTXdzzJ835LD+23twJovmbmxJ3hs3jqqfIs8TzYmVrABMYJz22CH7grkd9UIiEUv
        RZtplSvx3XzTN9towugfBNzvvmfxhGbIh6/fyi2ujg5ZwImJ3n36D8m5DQJyAZFkz6hO+R
        +9K+2bIPS4NDKUg9NJEQTiuyCM/PICcgTz2p236TJd7rq5C9ANewzYeTcWSRnw==
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
Subject: [PATCH v6 10/10] net: ieee802154: ca8210: Call _xmit_error() when a transmission fails
Date:   Thu,  7 Apr 2022 12:09:03 +0200
Message-Id: <20220407100903.1695973-11-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
References: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee802154_xmit_error() is the right helper to call when a transmission
has failed. Let's use it instead of open-coding it.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/ca8210.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 116aece191cd..3c00310d26e8 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1729,8 +1729,7 @@ static int ca8210_async_xmit_complete(
 			status
 		);
 		if (status != IEEE802154_TRANSACTION_OVERFLOW) {
-			dev_kfree_skb_any(priv->tx_skb);
-			ieee802154_wake_queue(priv->hw);
+			ieee802154_xmit_error(priv->hw, priv->tx_skb, status);
 			return 0;
 		}
 	}
-- 
2.27.0

