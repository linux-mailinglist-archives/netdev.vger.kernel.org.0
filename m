Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E35156F8
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 02:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfEGAhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 20:37:50 -0400
Received: from alln-iport-2.cisco.com ([173.37.142.89]:50779 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfEGAhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 20:37:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DtAgB90tBc/5JdJa1lHAEBAQQBAQc?=
 =?us-ascii?q?EAQGBZYIRgW0oshmBZxCEbQKCEyM4EwEDAQEEAQECAQJtKIVLBidSEFFXBxK?=
 =?us-ascii?q?DIoILrVIzhTeDOoFFFIEehniEVheBf4ERg1CEKAWFeQSSQIENk28JggtWkWc?=
 =?us-ascii?q?nbpRijB+VGYFmIYFWMxoIGxWCCIEfgkaOKx8DMJJaAQE?=
X-IronPort-AV: E=Sophos;i="5.60,439,1549929600"; 
   d="scan'208";a="270222088"
Received: from rcdn-core-10.cisco.com ([173.37.93.146])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 07 May 2019 00:37:48 +0000
Received: from tusi.cisco.com (tusi.cisco.com [172.24.98.27])
        by rcdn-core-10.cisco.com (8.15.2/8.15.2) with ESMTP id x470bjOH019352;
        Tue, 7 May 2019 00:37:47 GMT
From:   Ruslan Babayev <ruslan@babayev.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mika.westerberg@linux.intel.com,
        wsa@the-dreams.de
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, xe-linux-external@cisco.com
Subject: [PATCH RFC v2 net-next 2/2] net: phy: sfp: enable i2c-bus detection on ACPI based systems
Date:   Mon,  6 May 2019 17:35:57 -0700
Message-Id: <20190507003557.40648-3-ruslan@babayev.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190505220524.37266-2-ruslan@babayev.com>
References: <20190505220524.37266-2-ruslan@babayev.com>
Reply-To: 20190505220524.37266-2-ruslan@babayev.com
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 172.24.98.27, tusi.cisco.com
X-Outbound-Node: rcdn-core-10.cisco.com
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
2.17.1

