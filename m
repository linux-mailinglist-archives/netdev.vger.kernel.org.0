Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6C14DDDA5
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238588AbiCRQGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238447AbiCRQFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:05:30 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA87A13FB5;
        Fri, 18 Mar 2022 09:03:29 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4201F40021;
        Fri, 18 Mar 2022 16:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647619408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dKFshFvhHLkkwMZS+Ktyvof/6+xmfHa5cEKRMGqTKV8=;
        b=ZbXFhziAPiThQHdr5bAZJMkzY4HcPYkap+GN4HndS5lSrez9GBmvP13xSHHE6rpo0Ebn1q
        dZSzTx6DOTZ3p8qq48zB8JyZdzBnrPIT79pG5BIB6GeVp6GwVbwi2vMaPr9tGw0hnT6Bgl
        AUU+n8E90/Da69nwfvmSO6BEanSnQ02WIB9BxilqIh0z3s0VYZKJHqG4viVIl5WJx/S9tH
        lnyh9ZtSZNwbOV+G4qNPJvpx9V+JgtLjD6/aV7/kCb6YW805vQfnaDpeaFf7s5gV7t5poe
        j3oVwN4ztgY8buimCygp/o3EzrDIBT4j/CbINUITECv+tbaLjEZ/O1UEMngsrQ==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "'Rafael J . Wysocki '" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [PATCH 4/6] i2c: mux: pinctrl: remove CONFIG_OF dependency and use fwnode API
Date:   Fri, 18 Mar 2022 17:00:57 +0100
Message-Id: <20220318160059.328208-12-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220318160059.328208-1-clement.leger@bootlin.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to use i2c muxes with software_node when added with a struct
mfd_cell, switch to fwnode API. The fwnode layer will allow to use this
with both device_node and software_node.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/i2c/muxes/Kconfig           |  1 -
 drivers/i2c/muxes/i2c-mux-pinctrl.c | 21 +++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/muxes/Kconfig b/drivers/i2c/muxes/Kconfig
index 1708b1a82da2..d9cb15cfba3e 100644
--- a/drivers/i2c/muxes/Kconfig
+++ b/drivers/i2c/muxes/Kconfig
@@ -77,7 +77,6 @@ config I2C_MUX_PCA954x
 config I2C_MUX_PINCTRL
 	tristate "pinctrl-based I2C multiplexer"
 	depends on PINCTRL
-	depends on OF || COMPILE_TEST
 	help
 	  If you say yes to this option, support will be included for an I2C
 	  multiplexer that uses the pinctrl subsystem, i.e. pin multiplexing.
diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index f1bb00a11ad6..200890d7a625 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -53,19 +53,20 @@ static struct i2c_adapter *i2c_mux_pinctrl_root_adapter(
 
 static struct i2c_adapter *i2c_mux_pinctrl_parent_adapter(struct device *dev)
 {
-	struct device_node *np = dev->of_node;
-	struct device_node *parent_np;
+	struct fwnode_handle *fwnode = dev_fwnode(dev);
+	struct fwnode_handle *parent_np;
 	struct i2c_adapter *parent;
 
-	parent_np = of_parse_phandle(np, "i2c-parent", 0);
+	parent_np = fwnode_find_reference(fwnode, "i2c-parent", 0);
 	if (!parent_np) {
 		dev_err(dev, "Cannot parse i2c-parent\n");
 		return ERR_PTR(-ENODEV);
 	}
-	parent = of_find_i2c_adapter_by_node(parent_np);
-	of_node_put(parent_np);
-	if (!parent)
+	parent = fwnode_find_i2c_adapter_by_node(parent_np);
+	if (!parent) {
+		dev_err(dev, "Cannot find i2c-parent\n");
 		return ERR_PTR(-EPROBE_DEFER);
+	}
 
 	return parent;
 }
@@ -73,7 +74,7 @@ static struct i2c_adapter *i2c_mux_pinctrl_parent_adapter(struct device *dev)
 static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
+	struct fwnode_handle *np = dev_fwnode(dev);
 	struct i2c_mux_core *muxc;
 	struct i2c_mux_pinctrl *mux;
 	struct i2c_adapter *parent;
@@ -81,7 +82,7 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 	int num_names, i, ret;
 	const char *name;
 
-	num_names = of_property_count_strings(np, "pinctrl-names");
+	num_names = fwnode_property_string_array_count(np, "pinctrl-names");
 	if (num_names < 0) {
 		dev_err(dev, "Cannot parse pinctrl-names: %d\n",
 			num_names);
@@ -111,8 +112,8 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < num_names; i++) {
-		ret = of_property_read_string_index(np, "pinctrl-names", i,
-						    &name);
+		ret = fwnode_property_read_string_index(np, "pinctrl-names", i,
+							&name);
 		if (ret < 0) {
 			dev_err(dev, "Cannot parse pinctrl-names: %d\n", ret);
 			goto err_put_parent;
-- 
2.34.1

