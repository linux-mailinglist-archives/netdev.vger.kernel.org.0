Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4F26458E1
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiLGLWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiLGLWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:22:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BB52B18A;
        Wed,  7 Dec 2022 03:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=u54gIGhUJ+tNdq6xLif948p5v+I6bWPMXz1MarK3CEg=; b=MA10EUON8da+ZK02MNWeWsWReS
        OZql7XZJIHjODI3hbQFyiI6iaPiDmLx2UpI8mXR2WH3BdOp47HuqW2mXB6a9oWa6AU+cXdObDjzF/
        Ndf39UfhhcNqKqglJNj2NJ3vomwHktXsjjMWa8BdQGPaJX46doj7PNmir2W1Iu8ioVTerP4RComNC
        qWht7r+Q2X86pewjF+/XfoVxcY5vIS50xon9jjWPCpPYJoIIDcPy5tZjCD7x/ADojOX3LypdH7nqT
        vNnXIvUQeJ6i1oo19mL5rc91WBR+WjdlhGt76BHmDYofjgtGziKPh0vgCzNi0QfLhPLD39hWYCE5W
        Y6ND2Aig==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60788 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1p2sVN-0000Zo-Jb; Wed, 07 Dec 2022 11:22:25 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1p2sVM-009tqA-Vq; Wed, 07 Dec 2022 11:22:25 +0000
In-Reply-To: <Y5B3S6KZTrYlIH8g@shell.armlinux.org.uk>
References: <Y5B3S6KZTrYlIH8g@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>, Wolfram Sang <wsa@kernel.org>
Subject: [PATCH RFC 1/2] i2c: add fwnode APIs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1p2sVM-009tqA-Vq@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 07 Dec 2022 11:22:24 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add fwnode APIs for finding and getting I2C adapters, which will be
used by the SFP code. These are passed the fwnode corresponding to
the adapter, and return the I2C adapter. It is the responsibility of
the caller to find the appropriate fwnode.

We keep the DT and ACPI interfaces, but where appropriate, recode them
to use the fwnode interfaces internally.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/i2c/i2c-core-acpi.c | 13 +------
 drivers/i2c/i2c-core-base.c | 72 +++++++++++++++++++++++++++++++++++++
 drivers/i2c/i2c-core-of.c   | 51 ++------------------------
 include/linux/i2c.h         |  9 +++++
 4 files changed, 85 insertions(+), 60 deletions(-)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index 4dd777cc0c89..d6037a328669 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -442,18 +442,7 @@ EXPORT_SYMBOL_GPL(i2c_acpi_find_adapter_by_handle);
 
 static struct i2c_client *i2c_acpi_find_client_by_adev(struct acpi_device *adev)
 {
-	struct device *dev;
-	struct i2c_client *client;
-
-	dev = bus_find_device_by_acpi_dev(&i2c_bus_type, adev);
-	if (!dev)
-		return NULL;
-
-	client = i2c_verify_client(dev);
-	if (!client)
-		put_device(dev);
-
-	return client;
+	return i2c_find_device_by_fwnode(acpi_fwnode_handle(adev));
 }
 
 static int i2c_acpi_notify(struct notifier_block *nb, unsigned long value,
diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 9aa7b9d9a485..254ec043ce90 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1011,6 +1011,27 @@ void i2c_unregister_device(struct i2c_client *client)
 }
 EXPORT_SYMBOL_GPL(i2c_unregister_device);
 
+/* must call put_device() when done with returned i2c_client device */
+struct i2c_client *i2c_find_device_by_fwnode(struct fwnode_handle *fwnode)
+{
+	struct i2c_client *client;
+	struct device *dev;
+
+	if (!fwnode)
+		return NULL;
+
+	dev = bus_find_device_by_fwnode(&i2c_bus_type, fwnode);
+	if (!dev)
+		return NULL;
+
+	client = i2c_verify_client(dev);
+	if (!client)
+		put_device(dev);
+
+	return client;
+}
+EXPORT_SYMBOL(i2c_find_device_by_fwnode);
+
 
 static const struct i2c_device_id dummy_id[] = {
 	{ "dummy", 0 },
@@ -1761,6 +1782,57 @@ int devm_i2c_add_adapter(struct device *dev, struct i2c_adapter *adapter)
 }
 EXPORT_SYMBOL_GPL(devm_i2c_add_adapter);
 
+static int i2c_dev_or_parent_fwnode_match(struct device *dev, const void *data)
+{
+	if (dev_fwnode(dev) == data)
+		return 1;
+
+	if (dev->parent && dev_fwnode(dev->parent) == data)
+		return 1;
+
+	return 0;
+}
+
+/* must call put_device() when done with returned i2c_adapter device */
+struct i2c_adapter *i2c_find_adapter_by_fwnode(struct fwnode_handle *fwnode)
+{
+	struct i2c_adapter *adapter;
+	struct device *dev;
+
+	if (!fwnode)
+		return NULL;
+
+	dev = bus_find_device(&i2c_bus_type, NULL, fwnode,
+			      i2c_dev_or_parent_fwnode_match);
+	if (!dev)
+		return NULL;
+
+	adapter = i2c_verify_adapter(dev);
+	if (!adapter)
+		put_device(dev);
+
+	return adapter;
+}
+EXPORT_SYMBOL(i2c_find_adapter_by_fwnode);
+
+/* must call i2c_put_adapter() when done with returned i2c_adapter device */
+struct i2c_adapter *i2c_get_adapter_by_fwnode(struct fwnode_handle *fwnode)
+{
+	struct i2c_adapter *adapter;
+
+	adapter = i2c_find_adapter_by_fwnode(fwnode);
+	if (!adapter)
+		return NULL;
+
+	if (!try_module_get(adapter->owner)) {
+		put_device(&adapter->dev);
+		adapter = NULL;
+	}
+
+	return adapter;
+}
+EXPORT_SYMBOL(i2c_get_adapter_by_fwnode);
+
 static void i2c_parse_timing(struct device *dev, char *prop_name, u32 *cur_val_p,
 			    u32 def_val, bool use_def)
 {
diff --git a/drivers/i2c/i2c-core-of.c b/drivers/i2c/i2c-core-of.c
index 3ed74aa4b44b..c3e565e4bddf 100644
--- a/drivers/i2c/i2c-core-of.c
+++ b/drivers/i2c/i2c-core-of.c
@@ -113,69 +113,24 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
 	of_node_put(bus);
 }
 
-static int of_dev_or_parent_node_match(struct device *dev, const void *data)
-{
-	if (dev->of_node == data)
-		return 1;
-
-	if (dev->parent)
-		return dev->parent->of_node == data;
-
-	return 0;
-}
-
 /* must call put_device() when done with returned i2c_client device */
 struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
 {
-	struct device *dev;
-	struct i2c_client *client;
-
-	dev = bus_find_device_by_of_node(&i2c_bus_type, node);
-	if (!dev)
-		return NULL;
-
-	client = i2c_verify_client(dev);
-	if (!client)
-		put_device(dev);
-
-	return client;
+	return i2c_find_device_by_fwnode(of_fwnode_handle(node));
 }
 EXPORT_SYMBOL(of_find_i2c_device_by_node);
 
 /* must call put_device() when done with returned i2c_adapter device */
 struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
 {
-	struct device *dev;
-	struct i2c_adapter *adapter;
-
-	dev = bus_find_device(&i2c_bus_type, NULL, node,
-			      of_dev_or_parent_node_match);
-	if (!dev)
-		return NULL;
-
-	adapter = i2c_verify_adapter(dev);
-	if (!adapter)
-		put_device(dev);
-
-	return adapter;
+	return i2c_find_adapter_by_fwnode(of_fwnode_handle(node));
 }
 EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
 
 /* must call i2c_put_adapter() when done with returned i2c_adapter device */
 struct i2c_adapter *of_get_i2c_adapter_by_node(struct device_node *node)
 {
-	struct i2c_adapter *adapter;
-
-	adapter = of_find_i2c_adapter_by_node(node);
-	if (!adapter)
-		return NULL;
-
-	if (!try_module_get(adapter->owner)) {
-		put_device(&adapter->dev);
-		adapter = NULL;
-	}
-
-	return adapter;
+	return i2c_get_adapter_by_fwnode(of_fwnode_handle(node));
 }
 EXPORT_SYMBOL(of_get_i2c_adapter_by_node);
 
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index d84e0e99f084..bcee9faaf2e6 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -965,6 +965,15 @@ int i2c_handle_smbus_host_notify(struct i2c_adapter *adap, unsigned short addr);
 
 #endif /* I2C */
 
+/* must call put_device() when done with returned i2c_client device */
+struct i2c_client *i2c_find_device_by_fwnode(struct fwnode_handle *fwnode);
+
+/* must call put_device() when done with returned i2c_adapter device */
+struct i2c_adapter *i2c_find_adapter_by_fwnode(struct fwnode_handle *fwnode);
+
+/* must call i2c_put_adapter() when done with returned i2c_adapter device */
+struct i2c_adapter *i2c_get_adapter_by_fwnode(struct fwnode_handle *fwnode);
+
 #if IS_ENABLED(CONFIG_OF)
 /* must call put_device() when done with returned i2c_client device */
 struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
-- 
2.30.2

