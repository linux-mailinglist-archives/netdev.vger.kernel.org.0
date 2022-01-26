Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E3649CF24
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbiAZQF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236225AbiAZQF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:05:56 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291FBC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:05:56 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id t7so262353ljc.10
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=DKVSdC4qECIU2JwQ746MX/kDKwKhoierwoEybkVx8Ro=;
        b=pqtPSS+5XTYyIPFKvC3zu1ZSjTFT4ZciZmckIJighy+OyMb1cv9L2ZgemJf+uPaUq4
         Wu7fOSw5Q3cheSqIyj1iNG2czR3vw+KCTBajaS9FkXGhevVoXnj4yZq9L3dCixiooUO0
         aRjOnerU/CCQMomM6bqfpmwaYt/SYBc9tdzkFQ3Pcc0attNs+/7wyneXt57tp8OAYKTp
         50O9Svb9QVPw5m86Rl3M2mHHga+bK7Wv4T3XOcK7trHIn2ixurapSrT7FnF2Dv5USm5X
         DvVO2zN1ZWla2d48xNwSNnwrsePjhR3Htf4L53fsbDWRF9nGY1rVjwkxiGNrnsCJwoIB
         lsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=DKVSdC4qECIU2JwQ746MX/kDKwKhoierwoEybkVx8Ro=;
        b=vblAXQasBlc8vdru8u2d/KwRPtUnKiKgWoUOhLz0opWju7YApsEMV/cmtF9aoHjfCO
         hwNLt5WDs3PZ+S1QQxtjWhAIrbGQqFLi1Z3peaUV8BTWgGw1PvU29pvE0bzg+OTMyV5G
         tnpLmiPGewAEpoezAdHxZAgePmOncu3Rp8hjcva1ZR/k/HW68we5d5fjEUNDephXvWMn
         b+zahM2W0EvVTFOY1BYDc1ZB20GJ1lQYIrpv9rrIcN+GrTFwa+vJMHb83hOujjEFr8H4
         RptVr8LpOpKV/p4icaeUrJwCzZKyA0+lYxZaOUyDGMJxXHUA7gXrp03PrIxC8dr4Jd96
         Qeow==
X-Gm-Message-State: AOAM533h8qMObwAHYzdDmm2mNFZAw7FE193Dmg/QBhp7hp0bfbWTiNIk
        +t43wUQGV+D8sjcCs5rGrvU1Fg==
X-Google-Smtp-Source: ABdhPJz9PZ33WyBsJQCu9MCgq4W3w1XBgp+BABOq0UX8+QuiSnuy+JnQsazzZKkDq6vRlvMxsNvhCw==
X-Received: by 2002:a2e:9c10:: with SMTP id s16mr18190178lji.280.1643213154416;
        Wed, 26 Jan 2022 08:05:54 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p6sm1869984lfa.241.2022.01.26.08.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 08:05:54 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 3/5] net/fsl: xgmac_mdio: Support preamble suppression
Date:   Wed, 26 Jan 2022 17:05:41 +0100
Message-Id: <20220126160544.1179489-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126160544.1179489-1-tobias@waldekranz.com>
References: <20220126160544.1179489-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support the standard "suppress-preamble" attribute to disable preamble
generation.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 40442d64a247..18bf2370d45a 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -39,6 +39,7 @@ struct tgec_mdio_controller {
 #define MDIO_STAT_CLKDIV(x)	(((x>>1) & 0xff) << 8)
 #define MDIO_STAT_BSY		BIT(0)
 #define MDIO_STAT_RD_ER		BIT(1)
+#define MDIO_STAT_PRE_DIS	BIT(5)
 #define MDIO_CTL_DEV_ADDR(x) 	(x & 0x1f)
 #define MDIO_CTL_PORT_ADDR(x)	((x & 0x1f) << 5)
 #define MDIO_CTL_PRE_DIS	BIT(10)
@@ -254,6 +255,21 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 	return ret;
 }
 
+static void xgmac_mdio_set_suppress_preamble(struct mii_bus *bus)
+{
+	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
+	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
+	struct device *dev = bus->parent;
+	u32 mdio_stat;
+
+	if (!device_property_read_bool(dev, "suppress-preamble"))
+		return;
+
+	mdio_stat = xgmac_read32(&regs->mdio_stat, priv->is_little_endian);
+	mdio_stat |= MDIO_STAT_PRE_DIS;
+	xgmac_write32(mdio_stat, &regs->mdio_stat, priv->is_little_endian);
+}
+
 static int xgmac_mdio_probe(struct platform_device *pdev)
 {
 	struct fwnode_handle *fwnode;
@@ -301,6 +317,8 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 
+	xgmac_mdio_set_suppress_preamble(bus);
+
 	fwnode = pdev->dev.fwnode;
 	if (is_of_node(fwnode))
 		ret = of_mdiobus_register(bus, to_of_node(fwnode));
-- 
2.25.1

