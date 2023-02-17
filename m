Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EA569A434
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjBQDQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjBQDQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:16:20 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D994C54D18
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=EXiIW2AAFxo0nJU7IRTzCCCtIral6EZe+CrBugakto0=; b=fhaG+EIdeB0K8oTN2lDC6NXvy+
        oZeGrrVdzlJFwWg8QBV3T3TnihyAgKSJIqeczOI82wdvwyeO8ttoBYTMXCJJkqg4Y8wT9G2Tqofkz
        q3d+j0giYjYN4taJ1KzGQER9X7g8Sr7Rru6hz63oHo1U/1TLDiMu/Dj5BCVQEq+3eLns=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSrEP-005Ez6-HG; Fri, 17 Feb 2023 04:16:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: phy: Read EEE abilities when using .features
Date:   Fri, 17 Feb 2023 04:15:20 +0100
Message-Id: <20230217031520.1249198-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A PHY driver can use a static integer value to indicate what link mode
features it supports, i.e, its abilities.. This is the old way, but
useful when dynamically determining the devices features does not
work, e.g. support of fibre.

EEE support has been moved into phydev->supported_eee. This needs to
be set otherwise the code assumes EEE is not supported. It is normally
set as part of reading the devices abilities. However if a static
integer value was used, the dynamic reading of the abilities is not
performed. Add a call to genphy_c45_read_eee_abilities() to read the
EEE abilities.

Fixes: 8b68710a3121 ("net: phy: start using genphy_c45_ethtool_get/set_eee()")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8d927c5e3bf8..71becceb8764 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3113,8 +3113,10 @@ static int phy_probe(struct device *dev)
 	 * a controller will attach, and may modify one
 	 * or both of these values
 	 */
-	if (phydrv->features)
+	if (phydrv->features) {
 		linkmode_copy(phydev->supported, phydrv->features);
+		genphy_c45_read_eee_abilities(phydev);
+	}
 	else if (phydrv->get_features)
 		err = phydrv->get_features(phydev);
 	else if (phydev->is_c45)
-- 
2.39.1

