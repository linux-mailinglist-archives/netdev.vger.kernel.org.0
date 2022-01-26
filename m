Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4A449C73A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239742AbiAZKOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbiAZKOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 05:14:52 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAAAC061744
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 02:14:52 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id p27so62125004lfa.1
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 02:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=/mvM51A5cZB1/LP8bxdtukBhEKxdmFmIE0WYJdIBCJA=;
        b=mvIP15AWvQg1ZCiSg0C3i/x1fq4RgGtsbSqHGugR8AvKBMBhnyQpIvYdTa0Q1lSPf9
         4rI0oX+gyII5WDvROn/rYgWLGUEkOOeVq+2PN9wQ1m3SQWOXPkYqFU1VTMstSvYYveCj
         H2yYU0GNO/jwjQRZg5P9ux025ZhnUCBYVTIsdRWKVdc+j9dwPfsIGx/Y6ClttcDRVsMu
         ShkjLCwfwlDESlOcUrMr4QmsUFqYcJCRJcD1UbnXBwrD5KYNfZup3CxAEgEZ+u375Mjl
         gtS1T6Bfu43yUZAXYZ+jVMxGjPIJOIvURAGvzRg4KfqzK76meuahOnSz7vUWritSnzDd
         yp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=/mvM51A5cZB1/LP8bxdtukBhEKxdmFmIE0WYJdIBCJA=;
        b=l9fO+TvYV72xMT+FW62vHHbiGI/+ofw61/hN8S1n256JmGG6pONj47GyqWb5j1e+1B
         TEJ0R5JmsATnxiVyuHcNETtAw3jXeyXCKpKIutCQ9Tcd0dE64umTIo8Ord3fHSp+6lXX
         hWi9ZZUR0N+T8TWbMc56VIjk9SEZt4WOmrITTuXwz5AfHDIsPbPHEv7rSRu/dIDi8UTR
         biEfaYK+m0Ewl7y09rkHDQnHsIqH8Ir4J/1564NF5cIWEChlrGNtn9cPKhgMSrJs+lMY
         pzgyCPY/2HPQs2Uwghx6sOWWVs2qXCqyCShLMm8Q4stNB/q4rMrRWsnkR3V3ujetutxI
         606g==
X-Gm-Message-State: AOAM532ivnfEPnO9qMq+6QLMoMLhYK4UwPeayvNOcUQ2CrB5M2/lUPiO
        Zhe4BBQb00dmllBgcaeRz9lCbA==
X-Google-Smtp-Source: ABdhPJyvELxIdfcM95tWre+Zw7gqfURABlf0U53dRmWPEok32iFeh0sYdUrHcb/83tLAAdRaV6JSXw==
X-Received: by 2002:a05:6512:3406:: with SMTP id i6mr19581169lfr.637.1643192090820;
        Wed, 26 Jan 2022 02:14:50 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id h13sm1351906lfv.100.2022.01.26.02.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 02:14:50 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/5] net/fsl: xgmac_mdio: Use managed device resources
Date:   Wed, 26 Jan 2022 11:14:29 +0100
Message-Id: <20220126101432.822818-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126101432.822818-1-tobias@waldekranz.com>
References: <20220126101432.822818-1-tobias@waldekranz.com>
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

