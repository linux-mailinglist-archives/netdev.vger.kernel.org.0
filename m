Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B894BDEBA
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380885AbiBUQjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:39:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380805AbiBUQjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:39:11 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5492408D;
        Mon, 21 Feb 2022 08:38:40 -0800 (PST)
Received: from relay9-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::229])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 62B7AD26C6;
        Mon, 21 Feb 2022 16:30:05 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B2FF4FF813;
        Mon, 21 Feb 2022 16:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645460965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IwJT7O+ycIIE2B/+I0PXXUOt4c+jLoAf67OAg4gFgvc=;
        b=Qwo8YWwLdfMsmfiY94ufBkAM9expN513dX5+VcMfJhaEjDPz+QL9DhWi7HCxyANoNo9jG5
        hfyRmusIiVsECh+6ve4bNOHBeq2T1FvaCx2xjaUJGSajuNXSa2XwCnyBDcAzxnCYfSlZXN
        56BGKVKQCkkfVh/LcJQyH51f0UXsl3K4juxlDsbotEDEn+DlP/tXwwrUQ/hObDQxyx9Bht
        qyV5m92oGiKLiJyY/FZFO7G5PRflHWEMe6+Cs5aK61Rtuj9cefSnIlkza1rb5xgt0kpQqh
        iLXH73CPxNLS9rVBejg0uYUDYO+utSOHCPl8t6Za764WxXqH/M7tebae7L2kXw==
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
Subject: [RFC 10/10] net: sfp: add support for fwnode
Date:   Mon, 21 Feb 2022 17:26:52 +0100
Message-Id: <20220221162652.103834-11-clement.leger@bootlin.com>
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

Add support to retrieve a i2c bus in sfp with a fwnode. This support
is using the fwnode API which also works with device-tree and ACPI.
For this purpose, the device-tree and ACPI code handling the i2c
adapter retrieval was factorized with the new code. This also allows
i2c devices using a software_node description to be used by sfp code.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/phy/sfp.c | 44 +++++++++++++------------------------------
 1 file changed, 13 insertions(+), 31 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 4720b24ca51b..9d9e3d209408 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
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
+		if (!is_acpi_device_node(fwnode)) {
+			sff = device_get_match_data(&pdev->dev);
+			if (WARN_ON(!sff))
+				return -EINVAL;
 
-		id = of_match_node(sfp_of_match, node);
-		if (WARN_ON(!id))
-			return -EINVAL;
-
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

