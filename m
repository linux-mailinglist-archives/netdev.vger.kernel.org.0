Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5A04D8EC9
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 22:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245308AbiCNVd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 17:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245275AbiCNVdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 17:33:24 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB7833E2A
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 14:32:12 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 00B942C0C2A;
        Mon, 14 Mar 2022 21:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647293528;
        bh=fyeaQDUHhP/ZXergWd2lC+OvXrTtCNTg4n9clMIJ8Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHxbeSG2SUfHH0t7EG0pEueewAM0BHGhn2apaXbIOnCaLJ1fxDfwcDPfACU5DRiXj
         WR/je/TcJRDj2GduQn82nD4hlEGij6qw4J7vmGsrL+IgI7BjAHUBs6sYvDZuTRS0Li
         UP3tG4ZMDKG+zJK2jimN9XS0sR6QmIAIEY/HqVH77iBuiaIlIXze8G6W+SvCJllKNS
         HpazooKWLd9UwW5QpPLRd1m70k6G89EhWKM+WbKvq6dbLhTvKbUi+oiVAILCfqmgSz
         cwnT2e2uw425D6GFVI4/LFk45mrFrsz2zVD0G1XJ/MlieBgZueWDClpbIlrvAPzu/J
         4UgxnwoWxNWjg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B622fb4570004>; Tue, 15 Mar 2022 10:32:07 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 10FA313EEA1;
        Tue, 15 Mar 2022 10:32:07 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id EBE402A2678; Tue, 15 Mar 2022 10:32:03 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     huziji@marvell.com, ulf.hansson@linaro.org, robh+dt@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        catalin.marinas@arm.com, will@kernel.org, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        adrian.hunter@intel.com, thomas.petazzoni@bootlin.com,
        kostap@marvell.com, robert.marko@sartura.hr
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v2 4/8] pinctrl: mvebu: pinctrl driver for 98DX2530 SoC
Date:   Tue, 15 Mar 2022 10:31:39 +1300
Message-Id: <20220314213143.2404162-5-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Cfh2G4jl c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=o8Y5sQTvuykA:10 a=M5GUcnROAAAA:8 a=gBXrc1Pfy3FSj49WI4IA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This pinctrl driver supports the 98DX25xx and 98DX35xx family of chips
from Marvell. It is based on the Marvell SDK with additions for various
(non-gpio) pin configurations based on the datasheet.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---

Notes:
    Changes in v2:
    - Make pinctrl a child of a syscon node like the armada-7k-pinctrl

 drivers/pinctrl/mvebu/Kconfig       |   4 +
 drivers/pinctrl/mvebu/Makefile      |   1 +
 drivers/pinctrl/mvebu/pinctrl-ac5.c | 226 ++++++++++++++++++++++++++++
 3 files changed, 231 insertions(+)
 create mode 100644 drivers/pinctrl/mvebu/pinctrl-ac5.c

diff --git a/drivers/pinctrl/mvebu/Kconfig b/drivers/pinctrl/mvebu/Kconfi=
g
index 0d12894d3ee1..aa5883f09d7b 100644
--- a/drivers/pinctrl/mvebu/Kconfig
+++ b/drivers/pinctrl/mvebu/Kconfig
@@ -45,6 +45,10 @@ config PINCTRL_ORION
 	bool
 	select PINCTRL_MVEBU
=20
+config PINCTRL_AC5
+	bool
+	select PINCTRL_MVEBU
+
 config PINCTRL_ARMADA_37XX
 	bool
 	select GENERIC_PINCONF
diff --git a/drivers/pinctrl/mvebu/Makefile b/drivers/pinctrl/mvebu/Makef=
ile
index cd082dca4482..23458ab17c53 100644
--- a/drivers/pinctrl/mvebu/Makefile
+++ b/drivers/pinctrl/mvebu/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_PINCTRL_ARMADA_CP110) +=3D pinctrl-armada-=
cp110.o
 obj-$(CONFIG_PINCTRL_ARMADA_XP)  +=3D pinctrl-armada-xp.o
 obj-$(CONFIG_PINCTRL_ARMADA_37XX)  +=3D pinctrl-armada-37xx.o
 obj-$(CONFIG_PINCTRL_ORION)  +=3D pinctrl-orion.o
+obj-$(CONFIG_PINCTRL_AC5) +=3D pinctrl-ac5.o
diff --git a/drivers/pinctrl/mvebu/pinctrl-ac5.c b/drivers/pinctrl/mvebu/=
pinctrl-ac5.c
new file mode 100644
index 000000000000..8bc0bbff7c1b
--- /dev/null
+++ b/drivers/pinctrl/mvebu/pinctrl-ac5.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Marvell ac5 pinctrl driver based on mvebu pinctrl core
+ *
+ * Copyright (C) 2021 Marvell
+ *
+ * Noam Liron <lnoam@marvell.com>
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/pinctrl/pinctrl.h>
+
+#include "pinctrl-mvebu.h"
+
+static struct mvebu_mpp_mode ac5_mpp_modes[] =3D {
+	MPP_MODE(0,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "sdio",  "d0"),
+		 MPP_FUNCTION(2, "nand",  "io4")),
+	MPP_MODE(1,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "sdio",  "d1"),
+		 MPP_FUNCTION(2, "nand",  "io3")),
+	MPP_MODE(2,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "sdio",  "d2"),
+		 MPP_FUNCTION(2, "nand",  "io2")),
+	MPP_MODE(3,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "sdio",  "d3"),
+		 MPP_FUNCTION(2, "nand",  "io7")),
+	MPP_MODE(4,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "sdio",  "d4"),
+		 MPP_FUNCTION(2, "nand",  "io6"),
+		 MPP_FUNCTION(3, "uart3", "txd"),
+		 MPP_FUNCTION(4, "uart2", "txd")),
+	MPP_MODE(5,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "sdio",  "d5"),
+		 MPP_FUNCTION(2, "nand",  "io5"),
+		 MPP_FUNCTION(3, "uart3", "rxd"),
+		 MPP_FUNCTION(4, "uart2", "rxd")),
+	MPP_MODE(6,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "sdio",  "d6"),
+		 MPP_FUNCTION(2, "nand",  "io0"),
+		 MPP_FUNCTION(3, "i2c1",  "sck")),
+	MPP_MODE(7,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "sdio",  "d7"),
+		 MPP_FUNCTION(2, "nand",  "io1"),
+		 MPP_FUNCTION(3, "i2c1",  "sda")),
+	MPP_MODE(8,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "sdio",  "clk"),
+		 MPP_FUNCTION(2, "nand",  "wen")),
+	MPP_MODE(9,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "sdio",  "cmd"),
+		 MPP_FUNCTION(2, "nand",  "ale")),
+	MPP_MODE(10,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "sdio",  "ds"),
+		 MPP_FUNCTION(2, "nand",  "cle")),
+	MPP_MODE(11,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "sdio",  "rst"),
+		 MPP_FUNCTION(2, "nand",  "cen")),
+	MPP_MODE(12,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "spi0",  "clk")),
+	MPP_MODE(13,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "spi0",  "csn")),
+	MPP_MODE(14,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "spi0",  "mosi")),
+	MPP_MODE(15,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "spi0",  "miso")),
+	MPP_MODE(16,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "spi0",  "wpn"),
+		 MPP_FUNCTION(2, "nand",  "ren"),
+		 MPP_FUNCTION(3, "uart1", "txd")),
+	MPP_MODE(17,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "spi0",  "hold"),
+		 MPP_FUNCTION(2, "nand",  "rb"),
+		 MPP_FUNCTION(3, "uart1", "rxd")),
+	MPP_MODE(18,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(2, "uart2", "rxd")),
+	MPP_MODE(19,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(2, "uart2", "txd")),
+	MPP_MODE(20,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(2, "i2c1",  "sck"),
+		 MPP_FUNCTION(3, "spi1",  "clk"),
+		 MPP_FUNCTION(4, "uart3", "txd")),
+	MPP_MODE(21,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(2, "i2c1",  "sda"),
+		 MPP_FUNCTION(3, "spi1",  "csn"),
+		 MPP_FUNCTION(4, "uart3", "rxd")),
+	MPP_MODE(22,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(3, "spi1",  "mosi")),
+	MPP_MODE(23,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(3, "spi1",  "miso")),
+	MPP_MODE(24,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(2, "uart2", "txd")),
+	MPP_MODE(25,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(2, "uart2", "rxd")),
+	MPP_MODE(26,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "i2c0",  "sck"),
+		 MPP_FUNCTION(3, "uart3", "txd")),
+	MPP_MODE(27,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "i2c0",  "sda"),
+		 MPP_FUNCTION(3, "uart3", "rxd")),
+	MPP_MODE(28,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(3, "uart3", "txd")),
+	MPP_MODE(29,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(3, "uart3", "rxd")),
+	MPP_MODE(30,
+		 MPP_FUNCTION(0, "gpio",  NULL)),
+	MPP_MODE(31,
+		 MPP_FUNCTION(0, "gpio",  NULL)),
+	MPP_MODE(32,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "uart0", "txd")),
+	MPP_MODE(33,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(1, "uart0", "rxd")),
+	MPP_MODE(34,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(2, "uart3", "rxd")),
+	MPP_MODE(35,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(2, "uart3", "txd")),
+	MPP_MODE(36,
+		 MPP_FUNCTION(0, "gpio",  NULL)),
+	MPP_MODE(37,
+		 MPP_FUNCTION(0, "gpio",  NULL)),
+	MPP_MODE(38,
+		 MPP_FUNCTION(0, "gpio",  NULL)),
+	MPP_MODE(39,
+		 MPP_FUNCTION(0, "gpio",  NULL)),
+	MPP_MODE(40,
+		 MPP_FUNCTION(0, "gpio",  NULL)),
+	MPP_MODE(41,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(4, "uart2", "txd"),
+		 MPP_FUNCTION(5, "i2c1",  "sck")),
+	MPP_MODE(42,
+		 MPP_FUNCTION(0, "gpio",  NULL),
+		 MPP_FUNCTION(4, "uart2", "rxd"),
+		 MPP_FUNCTION(5, "i2c1",  "sda")),
+	MPP_MODE(43,
+		 MPP_FUNCTION(0, "gpio",  NULL)),
+	MPP_MODE(44,
+		 MPP_FUNCTION(0, "gpio",  NULL)),
+	MPP_MODE(45,
+		 MPP_FUNCTION(0, "gpio",  NULL)),
+};
+
+static struct mvebu_pinctrl_soc_info ac5_pinctrl_info;
+
+static const struct of_device_id ac5_pinctrl_of_match[] =3D {
+	{
+		.compatible =3D "marvell,ac5-pinctrl",
+	},
+	{ },
+};
+
+static const struct mvebu_mpp_ctrl ac5_mpp_controls[] =3D {
+	MPP_FUNC_CTRL(0, 45, NULL, mvebu_regmap_mpp_ctrl), };
+
+static struct pinctrl_gpio_range ac5_mpp_gpio_ranges[] =3D {
+	MPP_GPIO_RANGE(0,   0,  0, 46), };
+
+static int ac5_pinctrl_probe(struct platform_device *pdev)
+{
+	struct mvebu_pinctrl_soc_info *soc =3D &ac5_pinctrl_info;
+	const struct of_device_id *match =3D
+		of_match_device(ac5_pinctrl_of_match, &pdev->dev);
+
+	if (!match || !pdev->dev.parent)
+		return -ENODEV;
+
+	soc->variant =3D 0; /* no variants for ac5 */
+	soc->controls =3D ac5_mpp_controls;
+	soc->ncontrols =3D ARRAY_SIZE(ac5_mpp_controls);
+	soc->gpioranges =3D ac5_mpp_gpio_ranges;
+	soc->ngpioranges =3D ARRAY_SIZE(ac5_mpp_gpio_ranges);
+	soc->modes =3D ac5_mpp_modes;
+	soc->nmodes =3D ac5_mpp_controls[0].npins;
+
+	pdev->dev.platform_data =3D soc;
+
+	return mvebu_pinctrl_simple_regmap_probe(pdev, pdev->dev.parent, 0);
+}
+
+static struct platform_driver ac5_pinctrl_driver =3D {
+	.driver =3D {
+		.name =3D "ac5-pinctrl",
+		.of_match_table =3D of_match_ptr(ac5_pinctrl_of_match),
+	},
+	.probe =3D ac5_pinctrl_probe,
+};
+
+builtin_platform_driver(ac5_pinctrl_driver);
--=20
2.35.1

