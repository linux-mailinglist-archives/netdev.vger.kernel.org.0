Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A558949CF25
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236466AbiAZQGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236206AbiAZQF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:05:58 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07914C061751
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:05:58 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id z7so308241ljj.4
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=OzEeuZgMHaNDafKJqIpkWG17qaJ2UOqQemoazwwORiY=;
        b=nyPML2ccn1BWm+ZemB9S9F/SL44O3rVpa4RJVTcNeUjr8dIJ+7JvOcTax8PLfSQ2q7
         gTwTbXF1RbOWpdpmopsANH3R7kXmaE28Hn7zIPHX9Moa3DySziFLk1IRQUeQUaehmP8x
         sALLLaqXvNWZIYA+8BWMzlF+wheq5ir8EB506EZh1hMfkM1/VRZJxQm5iH4CiyyG40xk
         p6RVxAfADix1OtG8DI1lVcRxz/aX9ABIeaXYfuV8PD3eXpuzeyonAkk5kUqgyqbaXqPB
         h27KZ8SRN5a3HK7XnbrlB4wxZ2jhtjBeHErmEDqynEIYb5HuY1+T25bjzX5VTosGP9Ej
         7QoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=OzEeuZgMHaNDafKJqIpkWG17qaJ2UOqQemoazwwORiY=;
        b=c65PNrJK/Gbs7/LeodQvlRucC2Z3k2TLbBcEGTveSOxsHqZKyD6akgKUPAMK8RWuY/
         oFnZtvFDJRBg1PVeepZvHfTqKD32ooDTPEhCJu4aEeWIm0Y4UTbE6Pap15IsaZ6cO09e
         DJ4GBVzZuA1IFXRdGaGbSuyC916cSzmIaO8brkuH9LcAbY4L3sn/B8huGz0uxXvA7GdW
         b1WWoNO4OVizfviJ1jjmY0AG7cazmjsgmpcXyDB79iLPowDZTZxiPg2xgIY6xqEAKO7+
         TKx2NdFhP1gWxFHxB2dITkM9uh7E53nk0v+S4ri4qbAUNks2Nm+fRNS3U1EGl22Qg158
         FKTw==
X-Gm-Message-State: AOAM530+9fLqdgziqEehyJn2Kh0tZxBiIPcqObmU3itnF/6QntFd49SZ
        GBO4h1zwhbxz3gWqNTMTSjzOnw==
X-Google-Smtp-Source: ABdhPJzoDrGS/PwcauIWEQKhwDDjG1Zbxt3Lo0HXtei88G0uymG0KT2GIH3eN+QLFad+4IXEXyuUnA==
X-Received: by 2002:a2e:3305:: with SMTP id d5mr9996554ljc.184.1643213156240;
        Wed, 26 Jan 2022 08:05:56 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p6sm1869984lfa.241.2022.01.26.08.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 08:05:55 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Marcin Wojtas <mw@semihalf.com>,
        Markus Koch <markus@notsyncing.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 4/5] net/fsl: xgmac_mdio: Support setting the MDC frequency
Date:   Wed, 26 Jan 2022 17:05:42 +0100
Message-Id: <20220126160544.1179489-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126160544.1179489-1-tobias@waldekranz.com>
References: <20220126160544.1179489-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support the standard "clock-frequency" attribute to set the generated
MDC frequency. If not specified, the driver will leave the divisor
bits untouched.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 38 ++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 18bf2370d45a..d38d0c372585 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -14,6 +14,7 @@
 
 #include <linux/acpi.h>
 #include <linux/acpi_mdio.h>
+#include <linux/clk.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/mdio.h>
@@ -36,7 +37,7 @@ struct tgec_mdio_controller {
 } __packed;
 
 #define MDIO_STAT_ENC		BIT(6)
-#define MDIO_STAT_CLKDIV(x)	(((x>>1) & 0xff) << 8)
+#define MDIO_STAT_CLKDIV(x)	(((x) & 0x1ff) << 7)
 #define MDIO_STAT_BSY		BIT(0)
 #define MDIO_STAT_RD_ER		BIT(1)
 #define MDIO_STAT_PRE_DIS	BIT(5)
@@ -51,6 +52,8 @@ struct tgec_mdio_controller {
 
 struct mdio_fsl_priv {
 	struct	tgec_mdio_controller __iomem *mdio_base;
+	struct	clk *enet_clk;
+	u32	mdc_freq;
 	bool	is_little_endian;
 	bool	has_a009885;
 	bool	has_a011043;
@@ -255,6 +258,35 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 	return ret;
 }
 
+static int xgmac_mdio_set_mdc_freq(struct mii_bus *bus)
+{
+	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
+	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
+	struct device *dev = bus->parent;
+	u32 mdio_stat, div;
+
+	if (device_property_read_u32(dev, "clock-frequency", &priv->mdc_freq))
+		return 0;
+
+	priv->enet_clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(priv->enet_clk)) {
+		dev_err(dev, "Input clock unknown, not changing MDC frequency");
+		return PTR_ERR(priv->enet_clk);
+	}
+
+	div = ((clk_get_rate(priv->enet_clk) / priv->mdc_freq) - 1) / 2;
+	if (div < 5 || div > 0x1ff) {
+		dev_err(dev, "Requested MDC frequecy is out of range, ignoring");
+		return -EINVAL;
+	}
+
+	mdio_stat = xgmac_read32(&regs->mdio_stat, priv->is_little_endian);
+	mdio_stat &= ~MDIO_STAT_CLKDIV(0x1ff);
+	mdio_stat |= MDIO_STAT_CLKDIV(div);
+	xgmac_write32(mdio_stat, &regs->mdio_stat, priv->is_little_endian);
+	return 0;
+}
+
 static void xgmac_mdio_set_suppress_preamble(struct mii_bus *bus)
 {
 	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
@@ -319,6 +351,10 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 
 	xgmac_mdio_set_suppress_preamble(bus);
 
+	ret = xgmac_mdio_set_mdc_freq(bus);
+	if (ret)
+		return ret;
+
 	fwnode = pdev->dev.fwnode;
 	if (is_of_node(fwnode))
 		ret = of_mdiobus_register(bus, to_of_node(fwnode));
-- 
2.25.1

