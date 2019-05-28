Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641132BDAA
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 05:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbfE1DW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 23:22:28 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43919 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728028AbfE1DWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 23:22:17 -0400
Received: by mail-pl1-f193.google.com with SMTP id gn7so7687263plb.10
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 20:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=babayev.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zwLDAOoAiJhJGWHnpjoGzTroKs7erV0/y81Ksl3GxMc=;
        b=MfCs7Q+Y8y+WP+HVnLCgKfYNMTsQ6xJsDW6nBwd3rFzhcpYIFsXYCoxB4JnBCXH8Ij
         rsBW0txsZp/KK3pYuAqVA6DRxJ7YPF31ahUgs5nmIv9cHM0NFVKSGVpYOadGvmzRL6j6
         +F0qRhAipJ//dsDtGs97S7/tbeAwQHFLzFvBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zwLDAOoAiJhJGWHnpjoGzTroKs7erV0/y81Ksl3GxMc=;
        b=o2F3Ojznp1aNAxDLYeWQfPlyjVn3Ily0PZpz179SIGujmBhOHB+JdmfDDIO0o5Z6St
         HTTw9mmbqSaEMCzPL2nLmc8OoLemEBizwTouIyszOFUk6GFrbbrLlO5Qtp4bGlCgJvOw
         +Xqfyd0h6mSQ7ly1LEwcuSE5jrMfQeq0ealquKERfvz7AxWnNr5H5G/PiPJcYJRsj3Y1
         Sqa1pYxsNjulSa78RJVVDmwVbtpiAXt7KhxQnb673tjA8mR8CZQuZO3fmyVoV/TDSze/
         X2UDqD/mRAiLNRo6yC34caNcm26HPbKWCPvIDuIuws44n7x+NHao9pTSrd3FbdelbFHu
         z0eA==
X-Gm-Message-State: APjAAAXJHlCJaoZ1+84CG/Gp0C2/YZuqwJ7nOMEmDS6lgwcEr1UCgxjd
        2JsTILBMiAheSTp2qLmXR/0AVg==
X-Google-Smtp-Source: APXvYqyyN46JsYQFB/LoW3Y4vQ7cOWzwH+r5JQT+xMzgGeypgdVJBIbYt62twwrP7frHfDEjWigD0Q==
X-Received: by 2002:a17:902:3064:: with SMTP id u91mr23397819plb.244.1559013737001;
        Mon, 27 May 2019 20:22:17 -0700 (PDT)
Received: from p50.cisco.com ([128.107.241.177])
        by smtp.gmail.com with ESMTPSA id h71sm933042pje.11.2019.05.27.20.22.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 20:22:16 -0700 (PDT)
From:   Ruslan Babayev <ruslan@babayev.com>
To:     mika.westerberg@linux.intel.com, wsa@the-dreams.de,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: [net-next,v3 2/2] net: phy: sfp: enable i2c-bus detection on ACPI based systems
Date:   Mon, 27 May 2019 20:22:13 -0700
Message-Id: <20190528032213.19839-3-ruslan@babayev.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190528032213.19839-1-ruslan@babayev.com>
References: <20190528032213.19839-1-ruslan@babayev.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lookup I2C adapter using the "i2c-bus" device property on ACPI based
systems similar to how it's done with DT.

An example DSD describing an SFP on an ACPI based system:

Device (SFP0)
{
    Name (_HID, "PRP0001")
    Name (_CRS, ResourceTemplate()
    {
        GpioIo(Exclusive, PullDefault, 0, 0, IoRestrictionNone,
               "\\_SB.PCI0.RP01.GPIO", 0, ResourceConsumer)
            { 0, 1, 2, 3, 4 }
    })
    Name (_DSD, Package ()
    {
        ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
        Package () {
            Package () { "compatible", "sff,sfp" },
            Package () { "i2c-bus", \_SB.PCI0.RP01.I2C.MUX.CH0 },
            Package () { "maximum-power-milliwatt", 1000 },
            Package () { "tx-disable-gpios", Package () { ^SFP0, 0, 0, 1} },
            Package () { "reset-gpio",       Package () { ^SFP0, 0, 1, 1} },
            Package () { "mod-def0-gpios",   Package () { ^SFP0, 0, 2, 1} },
            Package () { "tx-fault-gpios",   Package () { ^SFP0, 0, 3, 0} },
            Package () { "los-gpios",        Package () { ^SFP0, 0, 4, 1} },
        },
    })
}

Device (PHY0)
{
    Name (_HID, "PRP0001")
    Name (_DSD, Package ()
    {
        ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
        Package () {
            Package () { "compatible", "ethernet-phy-ieee802.3-c45" },
            Package () { "sfp", \_SB.PCI0.RP01.SFP0 },
            Package () { "managed", "in-band-status" },
            Package () { "phy-mode", "sgmii" },
        },
    })
}

Signed-off-by: Ruslan Babayev <ruslan@babayev.com>
Cc: xe-linux-external@cisco.com
---
 drivers/net/phy/sfp.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index d4635c2178d1..7a6c8df8899b 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/acpi.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/rtnetlink.h>
@@ -1783,6 +1784,7 @@ static int sfp_probe(struct platform_device *pdev)
 {
 	const struct sff_data *sff;
 	struct sfp *sfp;
+	struct i2c_adapter *i2c = NULL;
 	bool poll = false;
 	int irq, err, i;
 
@@ -1801,7 +1803,6 @@ static int sfp_probe(struct platform_device *pdev)
 	if (pdev->dev.of_node) {
 		struct device_node *node = pdev->dev.of_node;
 		const struct of_device_id *id;
-		struct i2c_adapter *i2c;
 		struct device_node *np;
 
 		id = of_match_node(sfp_of_match, node);
@@ -1818,14 +1819,30 @@ static int sfp_probe(struct platform_device *pdev)
 
 		i2c = of_find_i2c_adapter_by_node(np);
 		of_node_put(np);
-		if (!i2c)
-			return -EPROBE_DEFER;
-
-		err = sfp_i2c_configure(sfp, i2c);
-		if (err < 0) {
-			i2c_put_adapter(i2c);
-			return err;
+	} else if (ACPI_COMPANION(&pdev->dev)) {
+		struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
+		struct fwnode_handle *fw = acpi_fwnode_handle(adev);
+		struct fwnode_reference_args args;
+		struct acpi_handle *acpi_handle;
+		int ret;
+
+		ret = acpi_node_get_property_reference(fw, "i2c-bus", 0, &args);
+		if (ACPI_FAILURE(ret) || !is_acpi_device_node(args.fwnode)) {
+			dev_err(&pdev->dev, "missing 'i2c-bus' property\n");
+			return -ENODEV;
 		}
+
+		acpi_handle = ACPI_HANDLE_FWNODE(args.fwnode);
+		i2c = i2c_acpi_find_adapter_by_handle(acpi_handle);
+	}
+
+	if (!i2c)
+		return -EPROBE_DEFER;
+
+	err = sfp_i2c_configure(sfp, i2c);
+	if (err < 0) {
+		i2c_put_adapter(i2c);
+		return err;
 	}
 
 	for (i = 0; i < GPIO_MAX; i++)
-- 
2.19.2

