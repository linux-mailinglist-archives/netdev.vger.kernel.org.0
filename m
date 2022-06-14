Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20CC54AC67
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 10:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240921AbiFNIqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 04:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242244AbiFNIq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 04:46:27 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B64B42A0A
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 01:46:22 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id c30so8908396ljr.9
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 01:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VUSdGLwnJ0Y/lNfZiFkctM/6S+/lIr4cXT4yYV5L0eg=;
        b=ds3Ls87l3/RTps8cjzbiCoEtfAT/UNTYNbmZ3vxsR0hnyRIM4JISzsT8HkoR+6+4eP
         3Cqfb+JGxyWAcNqNoxVve8rYObAC8MnNPQ+zdDSbT547/eFDUrPgC4XCC1yhvfm7wVDs
         gBoQe8fxIVPWmwyvCxK0peaqzLKc2z/XRjO1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VUSdGLwnJ0Y/lNfZiFkctM/6S+/lIr4cXT4yYV5L0eg=;
        b=h6G7UBo+v73QdvaICsJMaCnHupD4McQrks/hNWXP5P+hQl8OnGVLBbqMW+P6BzoOm7
         JGZ/0+Xnfu7XQMDileIy81fhTpjDJ5+aGFIvFMiAEd1DMBvd7UyAVMgZfNRMcEQ0PHql
         j4LDBcCy33ZrXUzRuVuhmCAAMJ5Sr8ZMzc2uFJF+shFYoam8YzTTxv0GDorIb/VLJkrf
         cF6xhc9chpwpwqjB1B6HQL9BZh3LcztR35DzDlWQYeBpeljtd3zYK7VJEuA8rTL+4Pe8
         XUyr53iBL5PEWSkL0zRHqTcjv4A6+6xBXr2RM5Sm1yg1BiA199YPwKi/MxwOxvYN5/+I
         oopw==
X-Gm-Message-State: AJIora9Fml4aZlbXckrjQVmewomLF5J7IAty1ybN+PG9s+td3kklTV8r
        UzuXMgF257JoNtXZXgYKrLHFaLW1XakgfzUL
X-Google-Smtp-Source: AGRyM1uPQusPCcTNkLDd/2DQXmi8U8XilZO13Hy3ENCammmq5MEL9OxcbgTxh2SVU/vHcJkV+z5GGA==
X-Received: by 2002:a2e:3a17:0:b0:255:772a:e9e2 with SMTP id h23-20020a2e3a17000000b00255772ae9e2mr1859147lja.440.1655196380110;
        Tue, 14 Jun 2022 01:46:20 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id g1-20020ac24d81000000b0047255d2118fsm1306116lfe.190.2022.06.14.01.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 01:46:19 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH net-next v2 3/3] net: phy: dp83867: implement support for io_impedance_ctrl nvmem cell
Date:   Tue, 14 Jun 2022 10:46:12 +0200
Message-Id: <20220614084612.325229-4-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220614084612.325229-1-linux@rasmusvillemoes.dk>
References: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
 <20220614084612.325229-1-linux@rasmusvillemoes.dk>
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

