Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F0E4EBF7A
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 13:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245734AbiC3LEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 07:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245723AbiC3LED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 07:04:03 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59005C5584;
        Wed, 30 Mar 2022 04:02:18 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id DCD822223B;
        Wed, 30 Mar 2022 13:02:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648638136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aLnrtpnRAiL6v+cP9y7rKdCDomkZu1ScIOGwNkz3rpE=;
        b=e83Xv7idZD4OnNsV+VrMu6XrTQuf5d3s1LWZQAj6+tGeCCObB8yIO+5KJrUlrfkpi0yXtj
        LN63YG92vbxwjwG6je2p84wy6hPi7DTSmkcpNZsD5gw8m9kRr4J40YAbO0KUI2cousBH+P
        5EWhEx5xvgguXDL6kJzbrmnhqoUYA5Y=
From:   Michael Walle <michael@walle.cc>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next] net: lan966x: make PHY reset support optional
Date:   Wed, 30 Mar 2022 13:02:10 +0200
Message-Id: <20220330110210.3374165-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHY subsystem as well as the MIIM mdio driver (in case of the
integrated PHYs) will already take care of the resets of any external
and internal PHY. There is no need for this reset anymore, so mark it
optionally to be backwards compatible.

Signed-off-by: Michael Walle <michael@walle.cc>
---

Horatiu, what do you think, should it be removed altogether? There is
no user for that in mainline and I don't know about downstream but the
reset driver doesn't really work (as it also resets the GPIO/SGPIO)
and conceptionally the property is on the wrong DT node. All of the
drawbacks should have been addressed by my patches for the miim [1]
and the pinctrl driver [2].

[1] https://lore.kernel.org/netdev/20220318201324.1647416-1-michael@walle.cc/
[2] https://lore.kernel.org/linux-gpio/20220313154640.63813-1-michael@walle.cc/

 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1f8c67f0261b..0765064d2845 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -916,7 +916,7 @@ static int lan966x_reset_switch(struct lan966x *lan966x)
 		return dev_err_probe(lan966x->dev, PTR_ERR(switch_reset),
 				     "Could not obtain switch reset");
 
-	phy_reset = devm_reset_control_get_shared(lan966x->dev, "phy");
+	phy_reset = devm_reset_control_get_optional_shared(lan966x->dev, "phy");
 	if (IS_ERR(phy_reset))
 		return dev_err_probe(lan966x->dev, PTR_ERR(phy_reset),
 				     "Could not obtain phy reset\n");
-- 
2.30.2

