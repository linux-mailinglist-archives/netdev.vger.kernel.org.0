Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD604BE6A5
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380903AbiBUQj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:39:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380803AbiBUQjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:39:10 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262612408B;
        Mon, 21 Feb 2022 08:38:40 -0800 (PST)
Received: from relay9-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::229])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id BE46CD264A;
        Mon, 21 Feb 2022 16:30:03 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1B18BFF811;
        Mon, 21 Feb 2022 16:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645460963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ocoul7ljnoZTu5D9WXKfAGT93AKe2N6I6+O6VziLVXM=;
        b=GAlclXPXVSGlWfer2ykk3URw3VhDeJ7r2IeffYChhxQoPQAxRI919CYsW5yen8aODmGYyD
        qinWr8T9DMf9HwBxvnRZbt7hJ+KpQDVOsF+n5+K8uqwkqE4bfID/RkZcl0G+7fbW5boyLe
        crags0YEaxVRYwGPqYtBdQ8C2wfDXKvFGmWuK+Ot3JJ2F/K2p3Hh4JspEf49/0Ok8ycNbE
        1yVCnRhXAtfz5EhN4VxmEC8kg2y54D0Cy3B9KrY/DXOCSUlyUIADiuZbTo2alSlJJ5gDUI
        jmUHVP8K0CFx1zdYdp1vnTwHctW0NwN2NZqecly3POy6MAbISz1bTYBy1qscLg==
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
Subject: [RFC 09/10] i2c: mux: add support for fwnode
Date:   Mon, 21 Feb 2022 17:26:51 +0100
Message-Id: <20220221162652.103834-10-clement.leger@bootlin.com>
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

Modify i2c_mux_add_adapter() to use with fwnode API to allow creating
mux adapters with fwnode based devices. This allows to have a node
independent support for i2c muxes.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/i2c/i2c-mux.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index 774507b54b57..93c916220da5 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -24,7 +24,7 @@
 #include <linux/i2c-mux.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/of.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 
@@ -347,38 +347,35 @@ int i2c_mux_add_adapter(struct i2c_mux_core *muxc,
 	else
 		priv->adap.class = class;
 
-	/*
-	 * Try to populate the mux adapter's of_node, expands to
-	 * nothing if !CONFIG_OF.
-	 */
-	if (muxc->dev->of_node) {
-		struct device_node *dev_node = muxc->dev->of_node;
-		struct device_node *mux_node, *child = NULL;
+	/* Try to populate the mux adapter's device node */
+	if (dev_fwnode(muxc->dev) && !has_acpi_companion(muxc->dev)) {
+		struct fwnode_handle *dev_node = dev_fwnode(muxc->dev);
+		struct fwnode_handle *mux_node, *child = NULL;
 		u32 reg;
 
 		if (muxc->arbitrator)
-			mux_node = of_get_child_by_name(dev_node, "i2c-arb");
+			mux_node = fwnode_get_named_child_node(dev_node, "i2c-arb");
 		else if (muxc->gate)
-			mux_node = of_get_child_by_name(dev_node, "i2c-gate");
+			mux_node = fwnode_get_named_child_node(dev_node, "i2c-gate");
 		else
-			mux_node = of_get_child_by_name(dev_node, "i2c-mux");
+			mux_node = fwnode_get_named_child_node(dev_node, "i2c-mux");
 
 		if (mux_node) {
 			/* A "reg" property indicates an old-style DT entry */
-			if (!of_property_read_u32(mux_node, "reg", &reg)) {
-				of_node_put(mux_node);
+			if (!fwnode_property_read_u32(mux_node, "reg", &reg)) {
+				fwnode_handle_put(mux_node);
 				mux_node = NULL;
 			}
 		}
 
 		if (!mux_node)
-			mux_node = of_node_get(dev_node);
+			mux_node = fwnode_handle_get(dev_node);
 		else if (muxc->arbitrator || muxc->gate)
-			child = of_node_get(mux_node);
+			child = fwnode_handle_get(mux_node);
 
 		if (!child) {
-			for_each_child_of_node(mux_node, child) {
-				ret = of_property_read_u32(child, "reg", &reg);
+			fwnode_for_each_child_node(mux_node, child) {
+				ret = fwnode_property_read_u32(child, "reg", &reg);
 				if (ret)
 					continue;
 				if (chan_id == reg)
@@ -386,8 +383,8 @@ int i2c_mux_add_adapter(struct i2c_mux_core *muxc,
 			}
 		}
 
-		priv->adap.dev.of_node = child;
-		of_node_put(mux_node);
+		device_set_node(&priv->adap.dev, child);
+		fwnode_handle_put(mux_node);
 	}
 
 	/*
@@ -444,7 +441,7 @@ void i2c_mux_del_adapters(struct i2c_mux_core *muxc)
 	while (muxc->num_adapters) {
 		struct i2c_adapter *adap = muxc->adapter[--muxc->num_adapters];
 		struct i2c_mux_priv *priv = adap->algo_data;
-		struct device_node *np = adap->dev.of_node;
+		struct fwnode_handle *np = dev_fwnode(&adap->dev);
 
 		muxc->adapter[muxc->num_adapters] = NULL;
 
@@ -454,7 +451,7 @@ void i2c_mux_del_adapters(struct i2c_mux_core *muxc)
 
 		sysfs_remove_link(&priv->adap.dev.kobj, "mux_device");
 		i2c_del_adapter(adap);
-		of_node_put(np);
+		fwnode_handle_put(np);
 		kfree(priv);
 	}
 }
-- 
2.34.1

