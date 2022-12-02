Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EAE64047A
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbiLBKVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbiLBKU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:20:58 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C310CCFE6
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 02:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SE3cSdvYq32T9Nlo2AAaP4s2sAGFsQhM1UwdwX0snqE=; b=l3w2/tz1feFbdRDCshyyb1fjJE
        REs6wSCrzxyBi7pGHo+vtHqejPnZ6mpmgoMIdqUh86k5mO45haIme76xECXofaxDc2HO9yuoh5pg5
        XgsEedwqAOCjH4WsxhdrwcbJuCIlMuvJWcPuoqZoSPBLQALewsDCdZlg7A60zYhU0X6cYEgGnxAV+
        dm3PqfGwBruGuAVQbSq7xOFTwQzOAX4/ACzmtbt4tApYKPqAvuNLATtDkHEhe1+G8UNtr5xHmfDLQ
        ZKxkzoIpK4jgYd/bZWIehWLvIXtVobbiRztMOKo14rfEeLk41KkMHWTBXTB2apR7ocVSkwJPvfPbV
        RlJGW6aQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43846 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1p13A5-0003uh-Ix; Fri, 02 Dec 2022 10:20:53 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1p13A4-0096Qh-TW; Fri, 02 Dec 2022 10:20:52 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] net: sfp: clean up i2c-bus property parsing
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1p13A4-0096Qh-TW@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 02 Dec 2022 10:20:52 +0000
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
 drivers/net/phy/sfp.c | 74 +++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 34 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 39fd1811375c..a62f3df63978 100644
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
+		acpi_handle = ACPI_HANDLE_FWNODE(args.fwnode);
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
@@ -2665,49 +2701,19 @@ static int sfp_probe(struct platform_device *pdev)
 	if (pdev->dev.of_node) {
 		struct device_node *node = pdev->dev.of_node;
 		const struct of_device_id *id;
-		struct device_node *np;
 
 		id = of_match_node(sfp_of_match, node);
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

