Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDAA50D86E
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 06:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241055AbiDYEmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 00:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241046AbiDYElu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 00:41:50 -0400
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453111EEE4;
        Sun, 24 Apr 2022 21:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding:
         in-reply-to:references;
        bh=2mjX0OzZBY3rlbKbLExUJUebHgkF1v+WvCOVbppC/gU=;
        b=OygH9PCITUQEoEaTSc6Yjj5xDiAx/MxNAz0WU3ze51Pd+3WFd1nADfrLWbJQVkKzUJ9xUsXzXKKXX
         OiLN1UOdM2+VGz4xoN/V4mhlBoZyL2LWJiW+8L1VH9QntKsJzi22XD22pXuzaXmCE/wHYiA803fVzb
         hYNowahRmfy/qz4rKSzbdwr9tlE1eSOrjgfop84iDobML9Fxmxl6r2maTiAetwZGTFAUpehPYET+hA
         3hMHfWgppyrTaNhfXPZ/Bd9r18kYakr9+q/G1ssyKqpy0cBkhUqYpOTpT65l7ckyACBMsbR3Wxj83v
         TAVf7mR1iB6Z4eS5YK0R6/QP7Fz1h8Q==
X-Kerio-Anti-Spam:  Build: [Engines: 2.16.2.1410, Stamp: 3], Multi: [Enabled, t: (0.000014,0.006138)], BW: [Enabled, t: (0.000016,0.000001), skipping (From == To)], RTDA: [Enabled, t: (0.096440), Hit: No, Details: v2.36.0; Id: 15.52k65u.1g1fg6bp9.30mfi; mclb], total: 0(700)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([178.70.36.174])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Mon, 25 Apr 2022 07:38:04 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     i.bornyakov@metrotek.ru
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, system@metrotek.ru
Subject: [PATCH net-next RESEND] net: phy: marvell-88x2222: set proper phydev->port
Date:   Mon, 25 Apr 2022 07:16:37 +0300
Message-Id: <20220425041637.5946-1-i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405150305.151573-1-i.bornyakov@metrotek.ru>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phydev->port was not set and always reported as PORT_TP.
Set phydev->port according to inserted SFP module.

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
---
 drivers/net/phy/marvell-88x2222.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
index ec4f1407a78c..9f971b37ec35 100644
--- a/drivers/net/phy/marvell-88x2222.c
+++ b/drivers/net/phy/marvell-88x2222.c
@@ -603,6 +603,7 @@ static int mv2222_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 	dev = &phydev->mdio.dev;
 
 	sfp_parse_support(phydev->sfp_bus, id, sfp_supported);
+	phydev->port = sfp_parse_port(phydev->sfp_bus, id, sfp_supported);
 	sfp_interface = sfp_select_interface(phydev->sfp_bus, sfp_supported);
 
 	dev_info(dev, "%s SFP module inserted\n", phy_modes(sfp_interface));
@@ -639,6 +640,7 @@ static void mv2222_sfp_remove(void *upstream)
 
 	priv->line_interface = PHY_INTERFACE_MODE_NA;
 	linkmode_zero(priv->supported);
+	phydev->port = PORT_OTHER;
 }
 
 static void mv2222_sfp_link_up(void *upstream)
-- 
2.25.1


