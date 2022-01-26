Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968CA49CF22
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiAZQFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbiAZQFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:05:54 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B26EC061749
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:05:54 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id p27so63964037lfa.1
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=vp/RrG3HNFLZAg53k5k+rblIG0BzeIXw2SDJ/K9MM7I=;
        b=AadczuGOdmIfMErobjfbUlq5lT6s8R0/ftYqm3te+j4K40ZUUKe99eeP/FcDUhIZp+
         If+r2WNodEDjNJGaU6eaJ+O4WUoSenZIlRBhkKiYrU5ArFG0Xp/qrpx/THLyrCL5onTO
         lt5zZH/2ythjIw/tmq+g02ccUfawO+jR7iFXJEtpAP//uzibJUnvA4/h42gzowlLyleB
         vuLTtKniI4HZZBRf2H6rx9W4mnSMa8xPBwOOG7J8ZjUWkOvRm3GujqguVBuH4WSRjQN0
         JYn5ndjBUBXpUaiNftOiZqKZ0fQPEAtvZ42ojqWlW9GJzRmu8ZoCDkHZEZmu1z+OXdUG
         Dy8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=vp/RrG3HNFLZAg53k5k+rblIG0BzeIXw2SDJ/K9MM7I=;
        b=VSuP3KwxvS9vMmhahD07nWcyXVouSAYD44GGqWhFl+0IJuNkcyA+Ul4WhexqU0oapX
         uPx9HSfsPc+TUEqKS4xj9EoWQ1WiegJGPEpr6pOejBXXbE1MfdqyuSxwE+8Q1Jb/IJsm
         yZ1FcDq68eVirZu7c1CzdqJ5LWSanH4CErxWJKBaCTsRVvdZEY8QfgHJexpqTqzr2b9Y
         cOR9+HxN34Do5RKZRp2v88k0gc++rJtY1yYHJRAERumPsToXLQgrJD7Wwa6g3LELNccC
         k+VdY+odqDcwph1OIBNJk6z4YSJ8k+RXN1MAkATOYkCZjTTclp6vdmcI6N17QkjjUTde
         PHQw==
X-Gm-Message-State: AOAM532bRHQClCtVQdYAgTOR1uVsilj6Gpxlfn7o9K31bt99bBI28Fru
        egRDWsJs+ophaJxM9KNCJo0gDKuEhqb5lQ==
X-Google-Smtp-Source: ABdhPJzD20ZQr5PDVElM4/D1WpDFY+AeY5pjJk7+SvCSRbdFTN7FywhuK2pIF2l6ylhVnMT9NzFlVQ==
X-Received: by 2002:a05:6512:3c97:: with SMTP id h23mr10553390lfv.211.1643213152569;
        Wed, 26 Jan 2022 08:05:52 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p6sm1869984lfa.241.2022.01.26.08.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 08:05:52 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 2/5] net/fsl: xgmac_mdio: Use managed device resources
Date:   Wed, 26 Jan 2022 17:05:40 +0100
Message-Id: <20220126160544.1179489-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126160544.1179489-1-tobias@waldekranz.com>
References: <20220126160544.1179489-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All of the resources used by this driver has managed interfaces, so
use them. Heed the warning in the comment before platform_get_resource
and use a bare devm_ioremap to allow for non-exclusive access to the
IO memory.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 35 ++++-----------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 266e562bd67a..40442d64a247 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -273,7 +273,7 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	bus = mdiobus_alloc_size(sizeof(struct mdio_fsl_priv));
+	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(struct mdio_fsl_priv));
 	if (!bus)
 		return -ENOMEM;
 
@@ -284,13 +284,11 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	bus->probe_capabilities = MDIOBUS_C22_C45;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%pa", &res->start);
 
-	/* Set the PHY base address */
 	priv = bus->priv;
-	priv->mdio_base = ioremap(res->start, resource_size(res));
-	if (!priv->mdio_base) {
-		ret = -ENOMEM;
-		goto err_ioremap;
-	}
+	priv->mdio_base = devm_ioremap(&pdev->dev, res->start,
+				       resource_size(res));
+	if (IS_ERR(priv->mdio_base))
+		return PTR_ERR(priv->mdio_base);
 
 	/* For both ACPI and DT cases, endianness of MDIO controller
 	 * needs to be specified using "little-endian" property.
@@ -312,31 +310,11 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 		ret = -EINVAL;
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register MDIO bus\n");
-		goto err_registration;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, bus);
 
-	return 0;
-
-err_registration:
-	iounmap(priv->mdio_base);
-
-err_ioremap:
-	mdiobus_free(bus);
-
-	return ret;
-}
-
-static int xgmac_mdio_remove(struct platform_device *pdev)
-{
-	struct mii_bus *bus = platform_get_drvdata(pdev);
-	struct mdio_fsl_priv *priv = bus->priv;
-
-	mdiobus_unregister(bus);
-	iounmap(priv->mdio_base);
-	mdiobus_free(bus);
-
 	return 0;
 }
 
@@ -364,7 +342,6 @@ static struct platform_driver xgmac_mdio_driver = {
 		.acpi_match_table = xgmac_acpi_match,
 	},
 	.probe = xgmac_mdio_probe,
-	.remove = xgmac_mdio_remove,
 };
 
 module_platform_driver(xgmac_mdio_driver);
-- 
2.25.1

