Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3254BDEF6
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380794AbiBUQj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:39:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380795AbiBUQjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:39:10 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B3423BC2;
        Mon, 21 Feb 2022 08:38:39 -0800 (PST)
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 1D871D002D;
        Mon, 21 Feb 2022 16:29:49 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0BF17FF80C;
        Mon, 21 Feb 2022 16:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645460958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6T8JMiVJYEhPc3/+R+YuyfEtX8+1W5M79oF4paVWi50=;
        b=LePMPR//Yb5TFldYIp1/MIM8cL0eDjZN0xbTUQr4DMj5rkhF1CLPLanLJuKweBXYtQO576
        nFABFf+h9o1wpTj5jU0wHBgQaG1NXMyw0WwFQAKCGpkUYsbVwKAXvWuy9iEV4XtIwMBQrx
        80V6DvULDcjxpCSnfG2MZNLZOfm4L7PREU/aB/m/7pF6yKlYOJRm5kBAZFsjQ9fDDdcJVu
        844hUuv445bYUylE+Hiu63CO0apgH7QZ0YbeZQsSZiwC2FY/n0OQLhMhhxg4K1xYriXXS9
        gIJmfcnc+x2c8Udc3kQf8F6A+8A49IK9by2KSmPrMgFzZiAdj5K6tElQO2TybQ==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [RFC 06/10] i2c: fwnode: add fwnode_find_i2c_adapter_by_node()
Date:   Mon, 21 Feb 2022 17:26:48 +0100
Message-Id: <20220221162652.103834-7-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220221162652.103834-1-clement.leger@bootlin.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add fwnode_find_i2c_adapter_by_node() which allows to retrieve a i2c
adapter using a fwnode. Since dev_fwnode() uses the fwnode provided by
the of_node member of the device, this will also work for devices were
the of_node has been set and not the fwnode field.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/i2c/Makefile          |  1 +
 drivers/i2c/i2c-core-fwnode.c | 40 +++++++++++++++++++++++++++++++++++
 include/linux/i2c.h           |  2 ++
 3 files changed, 43 insertions(+)
 create mode 100644 drivers/i2c/i2c-core-fwnode.c

diff --git a/drivers/i2c/Makefile b/drivers/i2c/Makefile
index c1d493dc9bac..c9c97675163e 100644
--- a/drivers/i2c/Makefile
+++ b/drivers/i2c/Makefile
@@ -6,6 +6,7 @@
 obj-$(CONFIG_I2C_BOARDINFO)	+= i2c-boardinfo.o
 obj-$(CONFIG_I2C)		+= i2c-core.o
 i2c-core-objs 			:= i2c-core-base.o i2c-core-smbus.o
+i2c-core-objs			+= i2c-core-fwnode.o
 i2c-core-$(CONFIG_ACPI)		+= i2c-core-acpi.o
 i2c-core-$(CONFIG_I2C_SLAVE) 	+= i2c-core-slave.o
 i2c-core-$(CONFIG_OF) 		+= i2c-core-of.o
diff --git a/drivers/i2c/i2c-core-fwnode.c b/drivers/i2c/i2c-core-fwnode.c
new file mode 100644
index 000000000000..d116aca3e2ec
--- /dev/null
+++ b/drivers/i2c/i2c-core-fwnode.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Linux I2C core fwnode support code
+ *
+ * Copyright (C) 2022 Microchip
+ */
+
+#include <linux/device.h>
+#include <linux/i2c.h>
+
+#include "i2c-core.h"
+
+static int fwnode_dev_or_parent_node_match(struct device *dev, const void *data)
+{
+	if (dev_fwnode(dev) == data)
+		return 1;
+
+	if (dev->parent)
+		return dev_fwnode(dev->parent) == data;
+
+	return 0;
+}
+
+struct i2c_adapter *fwnode_find_i2c_adapter_by_node(struct fwnode_handle *node)
+{
+	struct device *dev;
+	struct i2c_adapter *adapter;
+
+	dev = bus_find_device(&i2c_bus_type, NULL, node,
+			      fwnode_dev_or_parent_node_match);
+	if (!dev)
+		return NULL;
+
+	adapter = i2c_verify_adapter(dev);
+	if (!adapter)
+		put_device(dev);
+
+	return adapter;
+}
+EXPORT_SYMBOL(fwnode_find_i2c_adapter_by_node);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 7d4f52ceb7b5..9b480a8b0a76 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -967,6 +967,8 @@ int i2c_handle_smbus_host_notify(struct i2c_adapter *adap, unsigned short addr);
 
 #endif /* I2C */
 
+struct i2c_adapter *fwnode_find_i2c_adapter_by_node(struct fwnode_handle *node);
+
 #if IS_ENABLED(CONFIG_OF)
 /* must call put_device() when done with returned i2c_client device */
 struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
-- 
2.34.1

