Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B6949302F
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349626AbiARVvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiARVvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:51:10 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B99C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 13:51:10 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id p27so1011253lfa.1
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 13:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=zCzfaUBZlnSSUo3UCXDV+58rEZH0xND460lZC6VQ+x8=;
        b=fr442tV30SPPVvNjAJ+6tm6MiDMwOazAaLg67MwH9+7ljvQ3L5qKhW+jYlzbdKVWLX
         K3ZVTBXEKFrpdt5aOGc2ZyT03uEDbvbW/IN5VayV3XFufPzAHQTwOVN0JbzPksQKF/eq
         OTmRbWoRp2Qa95RZx0agz2gP2BAk10WI++OelkFnyaUz4+BvWakgmEMKwwRD8brp6IZN
         DhmnryEr5NSQcPieiCW/WGE+f7tWE5bbOFlf9KJBnGJNBzENL+lSKgYECSTrYsEnw33r
         Y9lQKFnW19NFURl1IXH2ZLPNGmcWtDjhaRTuIbMEZn/QK5UIcA2mnjvdTsYbYpd3At6b
         /OkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=zCzfaUBZlnSSUo3UCXDV+58rEZH0xND460lZC6VQ+x8=;
        b=a74M/NUdNSq4fLRM2cuT1dmZyrP9oEb1HCr7IQNp/mG8kGhl4xGEycCB4JWbOXT4NU
         p2cdI0ePnsjfSjAve4UDnB2bSRsWJFRJyuBa53fth0R3p+X9eLj9Ppc00bUjSyo+LeNO
         wptxZmDsooQKNFiB6n+1eA1hPX7zcrbk0vQ8KYxfKQGj9PTiJriy4IhJyEKTEPCAMGVM
         RoT2KR3fSv8cd9Lh7DZw4xAXjMojsUAjmuhuZP7Kav5aCHBSBwlN9KF2BQIo69I0lbjR
         lIJcOttEz+5yyBzZvUVXQCczrakFH8DXt8pp8pWZxaCtoHOYSYeJ4Tkc79dR02FupelM
         hgKQ==
X-Gm-Message-State: AOAM532mVRkS+MbaC8TfR+GwTLc5BMt1E/kAdStgLFmwPRcXqS0Shdj/
        //ofjKGC/3iIdr5zeZIeOSvrPw==
X-Google-Smtp-Source: ABdhPJx8F/qHg4qYSzsPl0mr7Mwad+xTfKkS+TZF/uCxuSb6aG+L14Ml/MPRTFKeEasSt39iP32ybQ==
X-Received: by 2002:a05:6512:10d2:: with SMTP id k18mr22808024lfg.640.1642542668486;
        Tue, 18 Jan 2022 13:51:08 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w5sm1704808ljm.55.2022.01.18.13.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 13:51:08 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@Freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Igal Liberman <Igal.Liberman@freescale.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 1/4] net/fsl: xgmac_mdio: Add workaround for erratum A-009885
Date:   Tue, 18 Jan 2022 22:50:50 +0100
Message-Id: <20220118215054.2629314-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220118215054.2629314-1-tobias@waldekranz.com>
References: <20220118215054.2629314-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once an MDIO read transaction is initiated, we must read back the data
register within 16 MDC cycles after the transaction completes. Outside
of this window, reads may return corrupt data.

Therefore, disable local interrupts in the critical section, to
maximize the probability that we can satisfy this requirement.

Fixes: d55ad2967d89 ("powerpc/mpc85xx: Create dts components for the FSL QorIQ DPAA FMan")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 25 ++++++++++++++++-----
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 5b8b9bcf41a2..bf566ac3195b 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -51,6 +51,7 @@ struct tgec_mdio_controller {
 struct mdio_fsl_priv {
 	struct	tgec_mdio_controller __iomem *mdio_base;
 	bool	is_little_endian;
+	bool	has_a009885;
 	bool	has_a011043;
 };
 
@@ -186,10 +187,10 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 {
 	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
 	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
+	unsigned long flags;
 	uint16_t dev_addr;
 	uint32_t mdio_stat;
 	uint32_t mdio_ctl;
-	uint16_t value;
 	int ret;
 	bool endian = priv->is_little_endian;
 
@@ -221,12 +222,18 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 			return ret;
 	}
 
+	if (priv->has_a009885)
+		/* Once the operation completes, i.e. MDIO_STAT_BSY clears, we
+		 * must read back the data register within 16 MDC cycles.
+		 */
+		local_irq_save(flags);
+
 	/* Initiate the read */
 	xgmac_write32(mdio_ctl | MDIO_CTL_READ, &regs->mdio_ctl, endian);
 
 	ret = xgmac_wait_until_done(&bus->dev, regs, endian);
 	if (ret)
-		return ret;
+		goto irq_restore;
 
 	/* Return all Fs if nothing was there */
 	if ((xgmac_read32(&regs->mdio_stat, endian) & MDIO_STAT_RD_ER) &&
@@ -234,13 +241,17 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 		dev_dbg(&bus->dev,
 			"Error while reading PHY%d reg at %d.%hhu\n",
 			phy_id, dev_addr, regnum);
-		return 0xffff;
+		ret = 0xffff;
+	} else {
+		ret = xgmac_read32(&regs->mdio_data, endian) & 0xffff;
+		dev_dbg(&bus->dev, "read %04x\n", ret);
 	}
 
-	value = xgmac_read32(&regs->mdio_data, endian) & 0xffff;
-	dev_dbg(&bus->dev, "read %04x\n", value);
+irq_restore:
+	if (priv->has_a009885)
+		local_irq_restore(flags);
 
-	return value;
+	return ret;
 }
 
 static int xgmac_mdio_probe(struct platform_device *pdev)
@@ -287,6 +298,8 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	priv->is_little_endian = device_property_read_bool(&pdev->dev,
 							   "little-endian");
 
+	priv->has_a009885 = device_property_read_bool(&pdev->dev,
+						      "fsl,erratum-a009885");
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 
-- 
2.25.1

