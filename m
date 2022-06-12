Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80CE5547BAE
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 21:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbiFLTNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 15:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234051AbiFLTNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 15:13:30 -0400
X-Greylist: delayed 1831 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Jun 2022 12:13:27 PDT
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE412E99
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 12:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding:
         in-reply-to:references;
        bh=guMf6OcVsQo+fLPJ8fpWWk/lWDBt604Wog1wB5emRic=;
        b=AY+hPgxsiVnrj94ILi8pKd69FPYAd0XK3/azrmP4QWByfXS/WWxRi9MttWwGwgGSZWfRAhJaB4g4J
         5urGIKO1NzIzqKajwwCEL1O72G+8lGeGT4WOXFo1MuVyMTsut6A+VybRpPIw5Kn14ebaQTguuLmCHe
         UUYJfPq/vfQct/4NNW7Ua0WigFYSOIgjLp36BdvtA8KMDy5+ItTaSZsXPLmryNPbpLm0GsbbPT92Qf
         r6QRqLcyZSIV/TEPxjsRBPbJU/v/OaornsmqNB04FwNdd1hPF/h500EPQgEubFVAos2NBCNoud7bpI
         hyoiHyMfb00ZJKMOuM6JdFlTdGrixwQ==
X-Kerio-Anti-Spam:  Build: [Engines: 2.16.3.1424, Stamp: 3], Multi: [Enabled, t: (0.000008,0.006650)], BW: [Enabled, t: (0.000026,0.000001), skipping (From == To)], RTDA: [Enabled, t: (0.117134), Hit: No, Details: v2.40.0; Id: 15.52k031.1g5cjj1ha.dhp1; mclb], total: 0(700)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([178.70.36.174])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Sun, 12 Jun 2022 21:42:27 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     i.bornyakov@metrotek.ru
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, system@metrotek.ru
Subject: [PATCH v2 net-next] net: phy: marvell-88x2222: set proper phydev->port
Date:   Sun, 12 Jun 2022 21:19:34 +0300
Message-Id: <20220612181934.665-1-i.bornyakov@metrotek.ru>
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
Changelog:
  v1 -> v2: set port as PORT_NONE on SFP removal, instead of PORT_OTHER

 drivers/net/phy/marvell-88x2222.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
index d8b31d4d2a73..f070776ca904 100644
--- a/drivers/net/phy/marvell-88x2222.c
+++ b/drivers/net/phy/marvell-88x2222.c
@@ -490,6 +490,7 @@ static int mv2222_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 	dev = &phydev->mdio.dev;
 
 	sfp_parse_support(phydev->sfp_bus, id, sfp_supported);
+	phydev->port = sfp_parse_port(phydev->sfp_bus, id, sfp_supported);
 	sfp_interface = sfp_select_interface(phydev->sfp_bus, sfp_supported);
 
 	dev_info(dev, "%s SFP module inserted\n", phy_modes(sfp_interface));
@@ -526,6 +527,7 @@ static void mv2222_sfp_remove(void *upstream)
 
 	priv->line_interface = PHY_INTERFACE_MODE_NA;
 	linkmode_zero(priv->supported);
+	phydev->port = PORT_NONE;
 }
 
 static void mv2222_sfp_link_up(void *upstream)
-- 
2.35.1


