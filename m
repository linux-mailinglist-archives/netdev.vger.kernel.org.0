Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45364DDD83
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbiCRQFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbiCRQE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:04:58 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5850C1275F;
        Fri, 18 Mar 2022 09:03:20 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3917440025;
        Fri, 18 Mar 2022 16:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647619399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hkT3kxdBeyWxML9PLamI62loW/3vgqU0z8FJV3BD28o=;
        b=kNvOi6EATLgSqKXnMWrlPMk7/BcKZmBbzxRfGyehpI9Epj0ormYcWZpz/4ifFYkhjdPANp
        jZppFt7fzG6Tkk3zzSnHo71zfBhnTIgoBaD3NSflqJUAVfaq43FkrZuuPqG7KStRonlg8Y
        3y85yjIlgLlQDeBOh5tDkjwk9orxe6m2gsLhhO3U+RuuN8KmqYc15nS6R22WzALGbe+T2J
        c+ClbGhnC37WaprN3+TH16p4VbdbuAK8n8V/GspxTWAnt6JpUxTKBJeF8pFLZ74Fztlb25
        KpIpjOz4K4+LX2TVuqtvuloU20z6WbMFH0p2YuIiVDOvxSj+NXdPTZ7UOKDbpg==
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
Subject: [PATCH 6/6] net: sfp: add support for fwnode
Date:   Fri, 18 Mar 2022 17:00:52 +0100
Message-Id: <20220318160059.328208-7-clement.leger@bootlin.com>
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

Add support to retrieve a i2c bus in sfp with a fwnode. This support
is using the fwnode API which also works with device-tree and ACPI.
For this purpose, the device-tree and ACPI code handling the i2c
adapter retrieval was factorized with the new code. This also allows
i2c devices using a software_node description to be used by sfp code.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/phy/sfp.c | 46 +++++++++++++------------------------------
 1 file changed, 14 insertions(+), 32 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 4720b24ca51b..3f57b1fbf413 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2483,7 +2483,7 @@ static void sfp_cleanup(void *data)
 static int sfp_probe(struct platform_device *pdev)
 {
 	const struct sff_data *sff;
-	struct i2c_adapter *i2c;
+	struct i2c_adapter *i2c = NULL;
 	char *sfp_irq_name;
 	struct sfp *sfp;
 	int err, i;
@@ -2499,43 +2499,25 @@ static int sfp_probe(struct platform_device *pdev)
 		return err;
 
 	sff = sfp->type = &sfp_data;
+	if (dev_fwnode(&pdev->dev)) {
+		struct fwnode_handle *fwnode = dev_fwnode(&pdev->dev);
+		struct fwnode_handle *np;
 
-	if (pdev->dev.of_node) {
-		struct device_node *node = pdev->dev.of_node;
-		const struct of_device_id *id;
-		struct device_node *np;
-
-		id = of_match_node(sfp_of_match, node);
-		if (WARN_ON(!id))
-			return -EINVAL;
+		if (!is_acpi_device_node(fwnode)) {
+			sff = device_get_match_data(&pdev->dev);
+			if (WARN_ON(!sff))
+				return -EINVAL;
 
-		sff = sfp->type = id->data;
-
-		np = of_parse_phandle(node, "i2c-bus", 0);
-		if (!np) {
-			dev_err(sfp->dev, "missing 'i2c-bus' property\n");
-			return -ENODEV;
+			sfp->type = sff;
 		}
 
-		i2c = of_find_i2c_adapter_by_node(np);
-		of_node_put(np);
-	} else if (has_acpi_companion(&pdev->dev)) {
-		struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
-		struct fwnode_handle *fw = acpi_fwnode_handle(adev);
-		struct fwnode_reference_args args;
-		struct acpi_handle *acpi_handle;
-		int ret;
-
-		ret = acpi_node_get_property_reference(fw, "i2c-bus", 0, &args);
-		if (ret || !is_acpi_device_node(args.fwnode)) {
-			dev_err(&pdev->dev, "missing 'i2c-bus' property\n");
+		np = fwnode_find_reference(fwnode, "i2c-bus", 0);
+		if (!np) {
+			dev_err(&pdev->dev, "Cannot parse i2c-bus\n");
 			return -ENODEV;
 		}
-
-		acpi_handle = ACPI_HANDLE_FWNODE(args.fwnode);
-		i2c = i2c_acpi_find_adapter_by_handle(acpi_handle);
-	} else {
-		return -EINVAL;
+		i2c = fwnode_find_i2c_adapter_by_node(np);
+		fwnode_handle_put(np);
 	}
 
 	if (!i2c)
-- 
2.34.1

