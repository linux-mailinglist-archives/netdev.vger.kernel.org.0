Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E832D1DB
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 01:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfE1XCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 19:02:40 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40847 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbfE1XCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 19:02:37 -0400
Received: by mail-pg1-f193.google.com with SMTP id d30so100466pgm.7
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 16:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=babayev.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TApL13/IWHA6p9W6T8SV9xqxLEQgsxufxiO/2MDfUXk=;
        b=ZJOaWquNqgKZhJQs1PTXJ/31Y1TjjQ9lC9SHCR217UhvWrr4xvnjYN4WTtKJ2Nw7fc
         oMG1hpBNCnR1QJ5xZK0IarzmvhJG1zAVTZMoIecQ5gD3T4291/3xM8jhLP6dbHvQH2LC
         FPIFnrlGT5Vckw16/MfPBp5A2TPLouNKttnEs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TApL13/IWHA6p9W6T8SV9xqxLEQgsxufxiO/2MDfUXk=;
        b=eUNtKC2LaFezOQq4fZYQq0RSETGbF4ZU9JXghlKWWSWe+DmWkd9OF6VeZpBCxKSajb
         RAC5Py+bKbyf8oKPXOZTeAPzpdrDvtdCYhHsTv06O0kEHd4wTDtM1mmYvlAsGj1obtYB
         7hzhkrY6ByRrqpJlab+HDNDVQytkg/qny+wbzxexoqI85nh+4HqYhjsJ7TsTYsiv5Nb9
         7fEYBie2QyI2F1YCeq1oAe/kcDiTTyCBbUCZInpev3Pb9Pl1yg0DOJnKNyXKllIdGcjS
         Mc7C5N1PKku0R9uGHFm4O7gK5hPI7atYmVEZ+6X2HnOU2DM4Qp3TnbwOHelp3Efutjao
         nViw==
X-Gm-Message-State: APjAAAUKXL7qqRsLyb/EtHfPSj/7eSqNDZoevmebMsij9RpSL3pRV2dw
        LnbsxjEw4E5ZU25uxnLCP1yHhcTQOiQRZw==
X-Google-Smtp-Source: APXvYqy9yJ3BtjJVCvwuUdO32bTMEQjQdREbeUgAJAa4cyo80WRBRVUwmVf36AEon+bBBhIOd6wDhw==
X-Received: by 2002:aa7:8f16:: with SMTP id x22mr76577654pfr.202.1559084557329;
        Tue, 28 May 2019 16:02:37 -0700 (PDT)
Received: from p50.cisco.com ([128.107.241.183])
        by smtp.gmail.com with ESMTPSA id p16sm27028196pfq.153.2019.05.28.16.02.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 16:02:36 -0700 (PDT)
From:   Ruslan Babayev <ruslan@babayev.com>
To:     mika.westerberg@linux.intel.com, wsa@the-dreams.de,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: [net-next,v4 2/2] net: phy: sfp: enable i2c-bus detection on ACPI based systems
Date:   Tue, 28 May 2019 16:02:33 -0700
Message-Id: <20190528230233.26772-3-ruslan@babayev.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190528230233.26772-1-ruslan@babayev.com>
References: <20190528230233.26772-1-ruslan@babayev.com>
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
 drivers/net/phy/sfp.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index d4635c2178d1..554acc869c25 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/acpi.h>
 #include <linux/ctype.h>
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
@@ -1782,6 +1783,7 @@ static void sfp_cleanup(void *data)
 static int sfp_probe(struct platform_device *pdev)
 {
 	const struct sff_data *sff;
+	struct i2c_adapter *i2c;
 	struct sfp *sfp;
 	bool poll = false;
 	int irq, err, i;
@@ -1801,7 +1803,6 @@ static int sfp_probe(struct platform_device *pdev)
 	if (pdev->dev.of_node) {
 		struct device_node *node = pdev->dev.of_node;
 		const struct of_device_id *id;
-		struct i2c_adapter *i2c;
 		struct device_node *np;
 
 		id = of_match_node(sfp_of_match, node);
@@ -1818,14 +1819,32 @@ static int sfp_probe(struct platform_device *pdev)
 
 		i2c = of_find_i2c_adapter_by_node(np);
 		of_node_put(np);
-		if (!i2c)
-			return -EPROBE_DEFER;
-
-		err = sfp_i2c_configure(sfp, i2c);
-		if (err < 0) {
-			i2c_put_adapter(i2c);
-			return err;
+	} else if (has_acpi_companion(&pdev->dev)) {
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
+	} else {
+		return -EINVAL;
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

