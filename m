Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8793E4AC264
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244739AbiBGPEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442264AbiBGOsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:48:13 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDA0C0401C1;
        Mon,  7 Feb 2022 06:48:12 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E358720002;
        Mon,  7 Feb 2022 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644245291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7vgHAxf85S2r5hBg/JVeDh49xgJmMDMYurxM/t95k3A=;
        b=j2w4uBzS7g1hvGdGKoDUbtxSyBE9wNlv5/aKKW7nZMQhUe6OfbkkwdXEQtm2fDs55Iwbks
        5sLrjFx3iDI8LoaRUcMryxNGcdSDkjQhYYYzrgd1JooBdehyUeJ2cyhu0bZSyzjqSgUpD/
        t5kOh0Kz3g1Y1lOmg3p3BvMcjYXTbFaRueki3MA72wUAiWRcIXoco3JPON2G93i6quXKWM
        0wABv9R57wTuk3kX+rAktxTiWxrl7rKBZh/SSTlL01V+YsOJWDQ8jtE3YFaPsCQ6p4rkzN
        2+2ue52Wg9ht7V8klttN4hncPQlgCeeWxUmOF2N/PQmuYLem5MVzNq2MepOtdw==
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
Subject: [PATCH wpan-next v2 03/14] net: ieee802154: at86rf230: Call _xmit_error() when a transmission fails
Date:   Mon,  7 Feb 2022 15:47:53 +0100
Message-Id: <20220207144804.708118-4-miquel.raynal@bootlin.com>
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

ieee802154_xmit_error() is the right helper to call when a transmission
has failed. Let's use it instead of open-coding it.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 563031ce76f0..5d714c6ec9b4 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -346,8 +346,7 @@ at86rf230_async_error_recover_complete(void *context)
 
 	if (lp->was_tx) {
 		lp->was_tx = 0;
-		dev_kfree_skb_any(lp->tx_skb);
-		ieee802154_wake_queue(lp->hw);
+		ieee802154_xmit_error(lp->hw, lp->tx_skb, false);
 	}
 }
 
-- 
2.27.0

