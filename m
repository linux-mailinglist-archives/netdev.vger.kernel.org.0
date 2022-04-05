Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD214F43DA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382342AbiDEUEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457250AbiDEQC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:02:59 -0400
X-Greylist: delayed 1831 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Apr 2022 08:35:25 PDT
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC98F13EA8
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 08:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding;
        bh=2mjX0OzZBY3rlbKbLExUJUebHgkF1v+WvCOVbppC/gU=;
        b=f1KXC0gbAa1Sl5wYmkACVrUj+W0Pyz2+qiG45PzK/KYG3AzFM/qjbCmrkozTnZFFrdWyCiODBitvp
         XwQ2l9EGHebaSkK13kVX6jVbPN3cw3Cz9be7wSYeyTUMJr7XIO2Eay1TDGzzNlHrHo4EkfiFeMHVZz
         SGBUoZLoZ591yvW5rqDKbwdsVuOHI0qN5BzsOmGEQe+4ZRODUNGF8BD41Umpom96LGx189Ywd50LBK
         hWnfnsLnCQ4I4g+aNX9peK02YPEfGsoRQs3Uv/4GnK8LXVyPljetSy6BoWtsQitpGXUG4JyiYe25PT
         zWjua6QcyjzI5eUMFPn3uRVU9l50nQw==
X-Kerio-Anti-Spam:  Build: [Engines: 2.16.2.1410, Stamp: 3], Multi: [Enabled, t: (0.000008,0.005307)], BW: [Enabled, t: (0.000013,0.000001)], RTDA: [Enabled, t: (0.070428), Hit: No, Details: v2.33.0; Id: 15.52k5sq.1fvt4228p.1g3j; mclb], total: 0(700)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from h-e2.ddg ([85.143.252.66])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Tue, 5 Apr 2022 18:03:59 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        system@metrotek.ru, Ivan Bornyakov <i.bornyakov@metrotek.ru>
Subject: [PATCH net] net: phy: marvell-88x2222: set proper phydev->port
Date:   Tue,  5 Apr 2022 18:03:05 +0300
Message-Id: <20220405150305.151573-1-i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
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


