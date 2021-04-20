Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38119365611
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 12:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhDTKW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 06:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhDTKW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 06:22:56 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F12C06174A;
        Tue, 20 Apr 2021 03:22:25 -0700 (PDT)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A1E2E22249;
        Tue, 20 Apr 2021 12:22:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1618914141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VXJRy9VzNsHT9ZmGp3xAw1tC+n20lg5dvIivLVfnwRY=;
        b=q7NG8HRIdNbiyrn/dEJEJDRSw2slKBPuzfLRMs3ewyHrVaVx3hEuxsKClDw/j4cLJKZAbl
        4eKkQ0bCAtKxxkYUFJs+4VSSmCwd7BcM0zQ38ivwJulzKyQZNBDH7cOQqosdItwImbMbpL
        K45Mg4G0cYXO0rCgpqDG0EUvGVCE6dY=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Bauer <mail@david-bauer.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: phy: at803x: fix probe error if copper page is selected
Date:   Tue, 20 Apr 2021 12:22:08 +0200
Message-Id: <20210420102208.5834-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit c329e5afb42f ("net: phy: at803x: select correct page on
config init") selects the copper page during probe. This fails if the
copper page was already selected. In this case, the value of the copper
page (which is 1) is propagated through phy_restore_page() and is
finally returned for at803x_probe(). Fix it, by just using the
at803x_page_write() directly.

Also in case of an error, the regulator is not disabled and leads to a
WARN_ON() when the probe fails. This couldn't happen before, because
at803x_parse_dt() was the last call in at803x_probe(). It is hard to
see, that the parse_dt() actually enables the regulator. Thus move the
regulator_enable() to the probe function and undo it in case of an
error.

Fixes: c329e5afb42f ("net: phy: at803x: select correct page on config init")
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/at803x.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index e0f56850edc5..5bec200f2132 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -554,10 +554,6 @@ static int at803x_parse_dt(struct phy_device *phydev)
 			phydev_err(phydev, "failed to get VDDIO regulator\n");
 			return PTR_ERR(priv->vddio);
 		}
-
-		ret = regulator_enable(priv->vddio);
-		if (ret < 0)
-			return ret;
 	}
 
 	return 0;
@@ -579,15 +575,28 @@ static int at803x_probe(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	if (priv->vddio) {
+		ret = regulator_enable(priv->vddio);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* Some bootloaders leave the fiber page selected.
 	 * Switch to the copper page, as otherwise we read
 	 * the PHY capabilities from the fiber side.
 	 */
 	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
-		ret = phy_select_page(phydev, AT803X_PAGE_COPPER);
-		ret = phy_restore_page(phydev, AT803X_PAGE_COPPER, ret);
+		ret = at803x_write_page(phydev, AT803X_PAGE_COPPER);
+		if (ret)
+			goto err;
 	}
 
+	return 0;
+
+err:
+	if (priv->vddio)
+		regulator_disable(priv->vddio);
+
 	return ret;
 }
 
-- 
2.20.1

