Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EC2650995
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 10:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbiLSJwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 04:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiLSJwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 04:52:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3D81DB;
        Mon, 19 Dec 2022 01:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0myAoUw7Waoa3eapJZLFYUxcDZzqzYU0F9XEV+RVtC8=; b=hutmH+fnwD+QcXncQc1AQ8M8VQ
        83RSKcaAPt3TNhHCbWDy7SzMAnjYRygqyYXZpQAxu7c25sz03qJnXu3eSfpr9cjgp2pNQxdyV+6J2
        5ruMKHUScRyRMb3enWQgnlNJTEUQ1TET3/tKnNmLjUD3q/fvAEzJrlD8vldy8GVHmP5i15xG9wUqx
        xdxXEjdf81akBA/Vhm0aDRK0LtYzgsxOUqegiXqOTRMH8D2fTvetFzem7MX4+q6EQc2WiqkZp0eyk
        TdSQInlQJuiY1f8av43IkylBwb9XrFkPL58FymiyuSnN5zaoVpDz/SvhmVUez1zpf+aFmgddsiw80
        aMFVbDEg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:35770 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1p7CoV-000067-A8; Mon, 19 Dec 2022 09:52:03 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1p7CoU-0012Ul-MM; Mon, 19 Dec 2022 09:52:02 +0000
In-Reply-To: <Y6Az235wsnRWFYWA@shell.armlinux.org.uk>
References: <Y6Az235wsnRWFYWA@shell.armlinux.org.uk>
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
Subject: [PATCH RFC net-next v2 1/2] i2c: add fwnode APIs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1p7CoU-0012Ul-MM@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 19 Dec 2022 09:52:02 +0000
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
v2: update docbook comments

 drivers/i2c/i2c-core-acpi.c | 13 +----
 drivers/i2c/i2c-core-base.c | 98 +++++++++++++++++++++++++++++++++++++
 drivers/i2c/i2c-core-of.c   | 51 ++-----------------
 include/linux/i2c.h         |  9 ++++
 4 files changed, 111 insertions(+), 60 deletions(-)

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
index 13fafb74bab8..1395a78d4a22 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1012,6 +1012,35 @@ void i2c_unregister_device(struct i2c_client *client)
 }
 EXPORT_SYMBOL_GPL(i2c_unregister_device);
 
+/**
+ * i2c_find_device_by_fwnode() - find an i2c_client for the fwnode
+ * @fwnode: &struct fwnode_handle corresponding to the &struct i2c_client
+ *
+ * Look up and return the &struct i2c_client corresponding to the @fwnode.
+ * If no client can be found, or @fwnode is NULL, this returns NULL.
+ *
+ * The user must call put_device(&client->dev) once done with the i2c client.
+ */
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
@@ -1762,6 +1791,75 @@ int devm_i2c_add_adapter(struct device *dev, struct i2c_adapter *adapter)
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
+/**
+ * i2c_find_adapter_by_fwnode() - find an i2c_adapter for the fwnode
+ * @fwnode: &struct fwnode_handle corresponding to the &struct i2c_adapter
+ *
+ * Look up and return the &struct i2c_adapter corresponding to the @fwnode.
+ * If no adapter can be found, or @fwnode is NULL, this returns NULL.
+ *
+ * The user must call put_device(&adapter->dev) once done with the i2c adapter.
+ */
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
+/**
+ * i2c_get_adapter_by_fwnode() - find an i2c_adapter for the fwnode
+ * @fwnode: &struct fwnode_handle corresponding to the &struct i2c_adapter
+ *
+ * Look up and return the &struct i2c_adapter corresponding to the @fwnode,
+ * and increment the adapter module's use count. If no adapter can be found,
+ * or @fwnode is NULL, this returns NULL.
+ *
+ * The user must call i2c_put_adapter(adapter) once done with the i2c adapter.
+ * Note that this is different from i2c_find_adapter_by_node().
+ */
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

