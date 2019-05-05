Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82FDF1425F
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfEEVAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:00:48 -0400
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:38701 "EHLO
        rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfEEVAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 17:00:47 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 May 2019 17:00:47 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0D8AAAqTM9c/4wNJK1lGwEBAQEDAQE?=
 =?us-ascii?q?BBwMBAQGBZYIRgToBMiizfRCEbQKCBiM4EwEDAQEEAQECAQJtKIVLBidSEBk?=
 =?us-ascii?q?4VwYBEoMiggurCDOIY4FFFIEehniEVheBf4ERg1CKJgSSPYEMk2kJggtWkWM?=
 =?us-ascii?q?nbpRajBuVEYFmIYFWMxoIGxWDJ5BxHwMwkT8BAQ?=
X-IronPort-AV: E=Sophos;i="5.60,435,1549929600"; 
   d="scan'208";a="555191920"
Received: from alln-core-7.cisco.com ([173.36.13.140])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 05 May 2019 20:53:40 +0000
Received: from tusi.cisco.com (tusi.cisco.com [172.24.98.27])
        by alln-core-7.cisco.com (8.15.2/8.15.2) with ESMTP id x45Krdkh024395;
        Sun, 5 May 2019 20:53:40 GMT
From:   Ruslan Babayev <ruslan@babayev.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: phy: sfp: enable i2c-bus detection on ACPI based systems
Date:   Sun,  5 May 2019 13:51:40 -0700
Message-Id: <20190505205140.17052-2-ruslan@babayev.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190505193435.3248-1-ruslan@babayev.com>
References: <20190505193435.3248-1-ruslan@babayev.com>
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 172.24.98.27, tusi.cisco.com
X-Outbound-Node: alln-core-7.cisco.com
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
    Name (_DSD, Package ()
    {
        ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
        Package () {
            Package () { "compatible", "sff,sfp" },
            Package () { "i2c-bus", \_SB.PCI0.RP01.I2C.MUX.CH0 },
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
2.17.1

