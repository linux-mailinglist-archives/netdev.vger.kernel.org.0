Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FC953EF86
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 22:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbiFFUWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 16:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiFFUWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 16:22:34 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4066FDEAD
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 13:22:33 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id er5so20295221edb.12
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 13:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VUSdGLwnJ0Y/lNfZiFkctM/6S+/lIr4cXT4yYV5L0eg=;
        b=fyyHVyXBohzxlEcKJtNBA0J4PW/3kKJlkInCdkTTIOy0hCUdbc6wQLZdjnNKUKDiUq
         neoo5gxyaB/TmYq+WyXdo11Lh+xPQSr0h4H538Rs10wdiiPnzjFKnZTh4rqsHC9OK6fy
         P9bCMhASV6zjcr0aeBlMdsn52n2/CZv6gfwXw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VUSdGLwnJ0Y/lNfZiFkctM/6S+/lIr4cXT4yYV5L0eg=;
        b=r9BGCOHEuBoQkV7wGcd42UEcK5sne3uJEewo6BX+q127ebFJ97E5nzbEkjFMuDB1x5
         WQ36JlDP4NlzNDBZYHN28ehzXxh+XwnCU2aHc2rv4HHwAcZ5Ikw5XjoTtrn2H3yDWau/
         PoULTIzuS3k2PxmDV1mox+4AEXlUrUZaOcDuCLdNIyLvKwzlqC9aIC1crybJBBdHiIL3
         JGWmaElWmOO8dsvhjsKP1JQNbaD09TcM9IkN6esdD9BVguzz4qvW3FAOh83yCqNffX27
         TK0hufkFgVtN0UYwIp+nTRvMsiuFpYW6NQj1EyVDjQhe9OLLFVLvmuwd/zHSypUGT8tz
         2d0A==
X-Gm-Message-State: AOAM531K4ruxyqiXMDP8+jRi0xK18gvQoFWTOWXizh/eECNTBRIP+Num
        qe/pY2yb9vSo/DZkPlTgiGUh7YcUTF7NhQ==
X-Google-Smtp-Source: ABdhPJxhEaNa/rFWgmZj8irzos8l14CPgg7Dl5BaZLkXL9q5+PuuKp0icUIG5T5d33851ZBnt9yGXg==
X-Received: by 2002:a05:6402:4003:b0:42d:fb4d:dada with SMTP id d3-20020a056402400300b0042dfb4ddadamr29129905eda.183.1654546951582;
        Mon, 06 Jun 2022 13:22:31 -0700 (PDT)
Received: from prevas-ravi.tritech.se ([80.208.64.233])
        by smtp.gmail.com with ESMTPSA id d20-20020aa7ce14000000b0042dd4ccccf5sm9043789edv.82.2022.06.06.13.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 13:22:31 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Murphy <dmurphy@ti.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] net: phy: dp83867: implement support for io_impedance_ctrl nvmem cell
Date:   Mon,  6 Jun 2022 22:22:20 +0200
Message-Id: <20220606202220.1670714-4-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
References: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a board where measurements indicate that the current three
options - leaving IO_IMPEDANCE_CTRL at the (factory calibrated) reset
value or using one of the two boolean properties to set it to the
min/max value - are too coarse.

Implement support for the newly added binding allowing device tree to
specify an nvmem cell containing an appropriate value for this
specific board.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/phy/dp83867.c | 55 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 8561f2d4443b..45d8a9298251 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -14,6 +14,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/bitfield.h>
+#include <linux/nvmem-consumer.h>
 
 #include <dt-bindings/net/ti-dp83867.h>
 
@@ -521,6 +522,51 @@ static int dp83867_verify_rgmii_cfg(struct phy_device *phydev)
 }
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
+static int dp83867_of_init_io_impedance(struct phy_device *phydev)
+{
+	struct dp83867_private *dp83867 = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	struct device_node *of_node = dev->of_node;
+	struct nvmem_cell *cell;
+	u8 *buf, val;
+	int ret;
+
+	cell = of_nvmem_cell_get(of_node, "io_impedance_ctrl");
+	if (IS_ERR(cell)) {
+		ret = PTR_ERR(cell);
+		if (ret != -ENOENT)
+			return phydev_err_probe(phydev, ret,
+						"failed to get nvmem cell io_impedance_ctrl\n");
+
+		/* If no nvmem cell, check for the boolean properties. */
+		if (of_property_read_bool(of_node, "ti,max-output-impedance"))
+			dp83867->io_impedance = DP83867_IO_MUX_CFG_IO_IMPEDANCE_MAX;
+		else if (of_property_read_bool(of_node, "ti,min-output-impedance"))
+			dp83867->io_impedance = DP83867_IO_MUX_CFG_IO_IMPEDANCE_MIN;
+		else
+			dp83867->io_impedance = -1; /* leave at default */
+
+		return 0;
+	}
+
+	buf = nvmem_cell_read(cell, NULL);
+	nvmem_cell_put(cell);
+
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	val = *buf;
+	kfree(buf);
+
+	if ((val & DP83867_IO_MUX_CFG_IO_IMPEDANCE_MASK) != val) {
+		phydev_err(phydev, "nvmem cell 'io_impedance_ctrl' contents out of range\n");
+		return -ERANGE;
+	}
+	dp83867->io_impedance = val;
+
+	return 0;
+}
+
 static int dp83867_of_init(struct phy_device *phydev)
 {
 	struct dp83867_private *dp83867 = phydev->priv;
@@ -548,12 +594,9 @@ static int dp83867_of_init(struct phy_device *phydev)
 		}
 	}
 
-	if (of_property_read_bool(of_node, "ti,max-output-impedance"))
-		dp83867->io_impedance = DP83867_IO_MUX_CFG_IO_IMPEDANCE_MAX;
-	else if (of_property_read_bool(of_node, "ti,min-output-impedance"))
-		dp83867->io_impedance = DP83867_IO_MUX_CFG_IO_IMPEDANCE_MIN;
-	else
-		dp83867->io_impedance = -1; /* leave at default */
+	ret = dp83867_of_init_io_impedance(phydev);
+	if (ret)
+		return ret;
 
 	dp83867->rxctrl_strap_quirk = of_property_read_bool(of_node,
 							    "ti,dp83867-rxctrl-strap-quirk");
-- 
2.31.1

