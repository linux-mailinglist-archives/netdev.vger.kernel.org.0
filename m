Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F8248FF02
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 22:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236182AbiAPVQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 16:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbiAPVQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 16:16:00 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BA5C06161C
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 13:15:59 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id d18-20020a05600c251200b0034974323cfaso19828250wma.4
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 13:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=PHk1aD/4El+ognxt4Ln9ghxHgBZDWsxupIrwsqWIzL0=;
        b=d1ha2+4cMc+x6oyVstELvpTRB1yu/umWD4RZCIZY/Q4RZhnCSOAcN8GmNAjE72Ajs/
         yFC1jKcFPgXT2ytcbLf7ES1xKcTQEfKIU7NsRa+YZoSjmHqETVezdLkKM6+wPv/9Uymj
         Y8LujmNoBzvlG0xO5xzjCtZNdh4vRy2O/tB+tVnXs1G5Rc8F8lYegJDnSVOYxcvTnNG0
         9hJxypntzwKpFEKCLLCS5rFbf+MxzQtkOGHAgRfW5Kyl9Ibt166bZRhmciq4kh8lIVcp
         /HDnSfUGHGDcChNXrgjH1VmNor/MFm1PQ5UYrhdqQrQ58U70ZyKHDJPQkstAYZi79Jx1
         ZmfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=PHk1aD/4El+ognxt4Ln9ghxHgBZDWsxupIrwsqWIzL0=;
        b=Ieir/OSjE4aeL0BHioDS/uf7YbfvflaxQr1wBaxswYWxIihDsY2L5Kuq3GmqxC4nJZ
         y0RoIbR5IEQcEueo65akwN0ZIALDMJ9wyg6I4b4M1H5PZOkKe2MTah9MYpMJyED5nKQ/
         h2ClMwOOE0RwAoHtC51yZUx6WwlwuqnE7OZ+OXVTTImzqZqrXfTfH8U3Re1u7K00goZJ
         RtyyRqJKCZabo/DSqmQK/LVBgWAm38U5Kg09do5I+6axC6rodLjxQjy7SNOzFy8Pkvwk
         z0ds7wSPZEBbF0MJ0l6wQmKpt6xwDG3awr+omRWf7iI0LD+/nvJOuezKLpFf+7mcLFRn
         7NOA==
X-Gm-Message-State: AOAM531M2L+w3kzyLw/Rptua7FC1IIdi6WqE95i1+ERcRqe34kXNxkjY
        SQR+M/96ryodMlHCaC9RY3Ymmw==
X-Google-Smtp-Source: ABdhPJyMNUUF4jYuBp45XsHq3CgLjCrJdCwUWVN/OhCa1VZdb89n+IrValiv5eDAfuzUiaOp4P9c+Q==
X-Received: by 2002:a1c:f70f:: with SMTP id v15mr17157582wmh.117.1642367758317;
        Sun, 16 Jan 2022 13:15:58 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id l12sm8820445wrz.15.2022.01.16.13.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 13:15:57 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     madalin.bucur@nxp.com, robh+dt@kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net 1/4] net/fsl: xgmac_mdio: Add workaround for erratum A-009885
Date:   Sun, 16 Jan 2022 22:15:26 +0100
Message-Id: <20220116211529.25604-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220116211529.25604-1-tobias@waldekranz.com>
References: <20220116211529.25604-1-tobias@waldekranz.com>
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

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
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

