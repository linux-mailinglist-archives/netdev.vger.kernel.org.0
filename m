Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DF94F7C72
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbiDGKLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244138AbiDGKL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:11:26 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36A7236B85;
        Thu,  7 Apr 2022 03:09:19 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D5DE76000B;
        Thu,  7 Apr 2022 10:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649326158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KkAfHbGQOvWKwZLtgQkDyXRAGYrqwKyHMzoOL4c5uOo=;
        b=fgx0bY2er88H/PHpW3SnreMFEG/EyQqrzEjvcNHjh58WeXJNUK3To9Ql2XxJ9NMzRE8A98
        tpy2O4A3BfQYAxfoeWZJ8YVy5cLfcuQZ5lGlLoHM1L2xKHeotRapGXr2RhEfyhiMDb6hLE
        nnmteJjizuO3OB7+gMQbbVsKXXhj39x5YAoD73qVA/4FhCh+FgQodl6R5zsHB9HqOAKoun
        7EuLic/JjjA0rCBLA/64lIDMHnUZu58tLhRERnfR+RUbLl5gwQNsLVx6swx9cXtQBif3Ef
        TC0lj1oR4JiFnreT1BbbIlgk+NWlytLgkn4TAYSX3Lbyx43L1/gmCtgLWa0qGQ==
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
Subject: [PATCH v6 08/10] net: ieee802154: atusb: Call _xmit_hw_error() upon transmission error
Date:   Thu,  7 Apr 2022 12:09:01 +0200
Message-Id: <20220407100903.1695973-9-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
References: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee802154_xmit_hw_error() is the right helper to call when a transmission
has failed for a non-determined (and probably not IEEE802.15.4 specific)
reason. Let's use this helper instead of open-coding it.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/atusb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index f27a5f535808..46a63646f2a0 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -271,9 +271,7 @@ static void atusb_tx_done(struct atusb *atusb, u8 seq)
 		 * unlikely case now that seq == expect is then true, but can
 		 * happen and fail with a tx_skb = NULL;
 		 */
-		ieee802154_wake_queue(atusb->hw);
-		if (atusb->tx_skb)
-			dev_kfree_skb_irq(atusb->tx_skb);
+		ieee802154_xmit_hw_error(atusb->hw, atusb->tx_skb);
 	}
 }
 
-- 
2.27.0

