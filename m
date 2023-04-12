Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFB56DECE6
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 09:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjDLHtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 03:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjDLHtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 03:49:00 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40B455BB;
        Wed, 12 Apr 2023 00:48:58 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7F04B4000E;
        Wed, 12 Apr 2023 07:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1681285737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CO47OM0miczfYcaLLJYgDjAY1lPzp2g2IISvLCCABNc=;
        b=P8YtNKGxa0ZteNm/HSo7UkplEN7TLavuugUsieYDZskuQgqyp6Ja97SogaYUcP2L8xSyBG
        qiB/c+iO6BHoZmha1EkOU0nqyUpXBxcNyrVIm+j68l6aFYhGAQIq5T/BZYDkwheVp5W10/
        y4RuDXZUDf6yt2VcIIE0b1c2OknnwFY0Z9wEbvxXWkc4R+xTWGIe6YL+H6WqYTpvO2Op5a
        iMZjWcf0D1BVml4jZC3DDEcJYEiFl5z4579iaC6aYCuqEv2ouvvYHFoWgex6ybiOoF5HVj
        OewvemiOr+4AaS6Xgh1XopLYg0nWkiqCk9GDyQuGjq2XrR5v4d9hhFJozmGOhA==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net,
        Sit Michael Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32 @ st-md-mailman . stormreply . com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "alexis . lothore @ bootlin . com" <alexis.lothore@bootlin.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net] net: phylink: check for SFP bus presence in phylink_expects_phy
Date:   Wed, 12 Apr 2023 09:48:50 +0200
Message-Id: <20230412074850.41260-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an SFP bus is present, we don't expect a PHY to be attached
directly from the MAC driver, it will be handled by phylink at SFP
attach time.

Fixes: 653a180957a8 ("net: phylink: add phylink_expects_phy() method")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
This was tested on dwmac_socfpga, following discussion here [1]

[1] : https://lore.kernel.org/netdev/PH0PR11MB758766370DD16A5107B1FAB69D9B9@PH0PR11MB7587.namprd11.prod.outlook.com/

 drivers/net/phy/phylink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a4111f1be375..334018f1028d 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1594,7 +1594,8 @@ EXPORT_SYMBOL_GPL(phylink_destroy);
  */
 bool phylink_expects_phy(struct phylink *pl)
 {
-	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
+	if (pl->sfp_bus ||
+	    pl->cfg_link_an_mode == MLO_AN_FIXED ||
 	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
 	     phy_interface_mode_is_8023z(pl->link_config.interface)))
 		return false;
-- 
2.39.2

