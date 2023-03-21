Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30A36C3782
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCUQ6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjCUQ6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:58:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1A4298FF
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GzJYrO91ZX8KIsoClazcJ2vKadBJtISABB/uyQaRDBU=; b=OQeDNd6cY7mZfXSE4vuCiWryLI
        q+p3PyId1JgeRwGQQquQgeZ3FKcbhhb57YjC/iUsI9xRFaCPbONhMTVN0gOj2Vz7e+h7VXWDAGq+d
        WF+v9EszGapmNwtLEVCwHvOmWlCOSgFyYfVOuTJ3j34cHyB1Y+d0S9l0mBI6Vh7z5b//vxVPo1Lon
        GdSp4iSPZquk7PYHgF3P6OaPoyXeguLbQ50+m9gNtvBQ6Kpnur80p1/jvzukPsiIOAO1gJUki1p+E
        V58FmhVtuuG1byfOpQH7sdOFro+dh/+7bekQLjD/kgfcBXEgQ4oYaBrI/1REY5F7UyZa4ZQiXFef+
        dCgYeOWg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55150 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pefJv-0001aG-9C; Tue, 21 Mar 2023 16:58:47 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pefJu-00Dn4P-JK; Tue, 21 Mar 2023 16:58:46 +0000
In-Reply-To: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 1/2] net: sfp-bus: allow SFP quirks to override
 Autoneg and pause bits
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pefJu-00Dn4P-JK@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 21 Mar 2023 16:58:46 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow SFP quirks to override the Autoneg, Pause and Asym_Pause bits in
the support mask.

Some modules have an inaccessible PHY on which is only accessible via
2500base-X without Autonegotiation. We therefore want to be able to
clear the Autoneg bit. Rearrange sfp_parse_support() to allow a SFP
modes quirk to override this bit.

Tested-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp-bus.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index daac293e8ede..1dd50f2ca05d 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -151,6 +151,10 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	unsigned int br_min, br_nom, br_max;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(modes) = { 0, };
 
+	phylink_set(modes, Autoneg);
+	phylink_set(modes, Pause);
+	phylink_set(modes, Asym_Pause);
+
 	/* Decode the bitrate information to MBd */
 	br_min = br_nom = br_max = 0;
 	if (id->base.br_nominal) {
@@ -329,10 +333,6 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 		bus->sfp_quirk->modes(id, modes, interfaces);
 
 	linkmode_or(support, support, modes);
-
-	phylink_set(support, Autoneg);
-	phylink_set(support, Pause);
-	phylink_set(support, Asym_Pause);
 }
 EXPORT_SYMBOL_GPL(sfp_parse_support);
 
-- 
2.30.2

