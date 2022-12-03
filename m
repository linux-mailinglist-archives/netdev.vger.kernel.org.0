Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A22641816
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 18:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiLCRZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 12:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiLCRZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 12:25:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004311EC44
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 09:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=H8DP/UAd+ntJsvVkaIU200Z81c3IhL3jFjDwQCdenxs=; b=U/bqytPGP9J2vIypfqsC69bvji
        o/MgORN0BnpGQRMd95H37svclllCTUr1M8vSYryMPDSKKCE/eHXhok5Voq3QxCP90G80OMXnf2AsV
        8i1+a0OwufZtoKk8Qc4vkwOyUjrEcxjGiJFP43wWRbOcaGXuiXUIfWs8GmLgSC9H25hYLuN+rn2Ab
        oi6l/5Vp4E/L4DKufRGxFJ3pWHogIpEf04LnjDjLcjRWaaRu0xP6p1CL5NFPlvnCWv212HQ1ohdZA
        h2rif10bfn/5yg8EkOUaFcQwKTo3zakpp4IA9x4LgZ34UD5Bn1YtFjBPAMliEzZ2lH+bmmqY/ruVk
        XidfAimQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37228 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1p1WGJ-0005Gv-Nb; Sat, 03 Dec 2022 17:25:15 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1p1WGJ-0098wS-4w; Sat, 03 Dec 2022 17:25:15 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3] net: sfp: clean up i2c-bus property parsing
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1p1WGJ-0098wS-4w@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sat, 03 Dec 2022 17:25:15 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently have some complicated code in sfp_probe() which gets the
I2C bus depending on whether the sfp node is DT or ACPI, and we use
completely separate lookup functions.

This could do with being in a separate function to make the code more
readable, so move it to a new function, sfp_i2c_get(). We can also use
fwnode_find_reference() to lookup the I2C bus fwnode before then
decending into fwnode-type specific parsing.

A future cleanup would be to move the fwnode-type specific parsing into
the i2c layer, which is where it really should be.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 77 +++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 39fd1811375c..83b99d95b278 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2642,10 +2642,46 @@ static void sfp_cleanup(void *data)
 	kfree(sfp);
 }
 
+static int sfp_i2c_get(struct sfp *sfp)
+{
+	struct acpi_handle *acpi_handle;
+	struct fwnode_handle *h;
+	struct i2c_adapter *i2c;
+	struct device_node *np;
+	int err;
+
+	h = fwnode_find_reference(dev_fwnode(sfp->dev), "i2c-bus", 0);
+	if (IS_ERR(h)) {
+		dev_err(sfp->dev, "missing 'i2c-bus' property\n");
+		return -ENODEV;
+	}
+
+	if (is_acpi_device_node(h)) {
+		acpi_handle = ACPI_HANDLE_FWNODE(h);
+		i2c = i2c_acpi_find_adapter_by_handle(acpi_handle);
+	} else if ((np = to_of_node(h)) != NULL) {
+		i2c = of_find_i2c_adapter_by_node(np);
+	} else {
+		err = -EINVAL;
+		goto put;
+	}
+
+	if (!i2c) {
+		err = -EPROBE_DEFER;
+		goto put;
+	}
+
+	err = sfp_i2c_configure(sfp, i2c);
+	if (err)
+		i2c_put_adapter(i2c);
+put:
+	fwnode_handle_put(h);
+	return err;
+}
+
 static int sfp_probe(struct platform_device *pdev)
 {
 	const struct sff_data *sff;
-	struct i2c_adapter *i2c;
 	char *sfp_irq_name;
 	struct sfp *sfp;
 	int err, i;
@@ -2663,51 +2699,20 @@ static int sfp_probe(struct platform_device *pdev)
 	sff = sfp->type = &sfp_data;
 
 	if (pdev->dev.of_node) {
-		struct device_node *node = pdev->dev.of_node;
 		const struct of_device_id *id;
-		struct device_node *np;
 
-		id = of_match_node(sfp_of_match, node);
+		id = of_match_node(sfp_of_match, pdev->dev.of_node);
 		if (WARN_ON(!id))
 			return -EINVAL;
 
 		sff = sfp->type = id->data;
-
-		np = of_parse_phandle(node, "i2c-bus", 0);
-		if (!np) {
-			dev_err(sfp->dev, "missing 'i2c-bus' property\n");
-			return -ENODEV;
-		}
-
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
-			return -ENODEV;
-		}
-
-		acpi_handle = ACPI_HANDLE_FWNODE(args.fwnode);
-		i2c = i2c_acpi_find_adapter_by_handle(acpi_handle);
-	} else {
+	} else if (!has_acpi_companion(&pdev->dev)) {
 		return -EINVAL;
 	}
 
-	if (!i2c)
-		return -EPROBE_DEFER;
-
-	err = sfp_i2c_configure(sfp, i2c);
-	if (err < 0) {
-		i2c_put_adapter(i2c);
+	err = sfp_i2c_get(sfp);
+	if (err)
 		return err;
-	}
 
 	for (i = 0; i < GPIO_MAX; i++)
 		if (sff->gpios & BIT(i)) {
-- 
2.30.2

