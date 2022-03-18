Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6834DDD74
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238407AbiCRQEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238378AbiCRQEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:04:37 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBD726571;
        Fri, 18 Mar 2022 09:03:16 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 59A334002C;
        Fri, 18 Mar 2022 16:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647619394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=URJAXhlDauk/l4yfi8v6pFwWxIgQSIBOv7Iyc/z2WsI=;
        b=HD8A8zZudux7YST/AR/1UzlHS80Dir45yH1+FXLMATteWo8NiWQD0e5u0RVgcOAxNTAg84
        7enAm4/7is9GAx4Jb0WWO7XR5ZluwWvWJaEqS96NnpLAcXkzeu7S+KP7+l52abA19cLXd1
        Tf3E4Ta2mDiyKRLHYsPhZJ9TjQUCQUGDSQuQXSnMknahrDH2Z4nkJDKJ+msfNo+2dLLu8q
        J+s+nos3Yl4U840FYlxUfromtZOqC4QOGnnM3qCJkL7J94ctpb9hNkuJJu9T/yk6lsTdUg
        C5TEYj3xtTIn304uukk/tLnEy2w4qmIIwCHg5c1H5cCa3EnXL6ev049wAB+KqQ==
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
Subject: [PATCH 3/6] i2c: of: use fwnode_get_i2c_adapter_by_node()
Date:   Fri, 18 Mar 2022 17:00:49 +0100
Message-Id: <20220318160059.328208-4-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220318160059.328208-1-clement.leger@bootlin.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the new fwnode function does the same check that was done by
of_get_i2c_adapter_by_node(), call this one to avoid code duplication.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/i2c/i2c-core-of.c | 30 ------------------------------
 include/linux/i2c.h       |  5 ++++-
 2 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/drivers/i2c/i2c-core-of.c b/drivers/i2c/i2c-core-of.c
index 3ed74aa4b44b..be7d66aa0f49 100644
--- a/drivers/i2c/i2c-core-of.c
+++ b/drivers/i2c/i2c-core-of.c
@@ -113,17 +113,6 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
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
@@ -142,25 +131,6 @@ struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
 }
 EXPORT_SYMBOL(of_find_i2c_device_by_node);
 
-/* must call put_device() when done with returned i2c_adapter device */
-struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
-{
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
-}
-EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
-
 /* must call i2c_put_adapter() when done with returned i2c_adapter device */
 struct i2c_adapter *of_get_i2c_adapter_by_node(struct device_node *node)
 {
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 9b480a8b0a76..d1f384b805ad 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -974,7 +974,10 @@ struct i2c_adapter *fwnode_find_i2c_adapter_by_node(struct fwnode_handle *node);
 struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
 
 /* must call put_device() when done with returned i2c_adapter device */
-struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node);
+static inline struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
+{
+	return fwnode_find_i2c_adapter_by_node(of_fwnode_handle(node));
+}
 
 /* must call i2c_put_adapter() when done with returned i2c_adapter device */
 struct i2c_adapter *of_get_i2c_adapter_by_node(struct device_node *node);
-- 
2.34.1

