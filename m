Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA036311B7
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiKSXGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbiKSXF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:05:59 -0500
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 19 Nov 2022 15:05:57 PST
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5B819C35;
        Sat, 19 Nov 2022 15:05:57 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:05:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899155; x=1669158355;
        bh=os6z3ba01+YXEoGx1b8Zwzyato7B2D5Y3WgXf8vG8a0=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=euSIxToFxm3b5kV2z4QSpdEhp/M2qP87Z7/nF7qW0RbkUB18Qr5BvHy9d0Y9XHjDb
         3LrhPo2OmnhdnRrmFSIXxR+F0yBxPHvFeKwqUrQ4GLQcjDpoyiFYbhMwfDBeDMHGk7
         /TtkNpy4nCP8L7b/5h2XeR/9keyCzOnIpJcerLKDYt8JTnrwtBgBSkMXeRs2Mkd7J/
         KJDAzsJFsa/7pqnoPueRjCve9rg/EhL6hOScGKWZ4Xegm1l88FzlQ2a5L7iGoCySty
         QmeihC2zQKpjMJH9K3knmyWWs4OCWkELkv8M/vWege356kVN4dFtEs3Mog7LsPQ02J
         Sbt7yWJq9brVA==
To:     linux-kbuild@vger.kernel.org
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/18] mfd: rsmu: fix mixed module-builtin object
Message-ID: <20221119225650.1044591-6-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
References: <20221119225650.1044591-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

With CONFIG_MFD_RSMU_I2C=3Dm and CONFIG_MFD_RSMU_SPI=3Dy (or vice versa),
rsmu_core.o is linked to a module and also to vmlinux even though the
expected CFLAGS are different between builtins and modules.

This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
Fixing mixed module-builtin objects").

Split rsmu-core into a separate module.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-and-tested-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/mfd/Kconfig     | 8 ++++++--
 drivers/mfd/Makefile    | 6 ++++--
 drivers/mfd/rsmu_core.c | 3 +++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 8b93856de432..f52efa1a968d 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -2232,10 +2232,14 @@ config MFD_INTEL_M10_BMC
 =09  additional drivers must be enabled in order to use the functionality
 =09  of the device.

+config MFD_RSMU_CORE
+=09tristate
+=09select MFD_CORE
+
 config MFD_RSMU_I2C
 =09tristate "Renesas Synchronization Management Unit with I2C"
 =09depends on I2C && OF
-=09select MFD_CORE
+=09select MFD_RSMU_CORE
 =09select REGMAP_I2C
 =09help
 =09  Support for the Renesas Synchronization Management Unit, such as
@@ -2249,7 +2253,7 @@ config MFD_RSMU_I2C
 config MFD_RSMU_SPI
 =09tristate "Renesas Synchronization Management Unit with SPI"
 =09depends on SPI && OF
-=09select MFD_CORE
+=09select MFD_RSMU_CORE
 =09select REGMAP_SPI
 =09help
 =09  Support for the Renesas Synchronization Management Unit, such as
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 7ed3ef4a698c..d40d6619bacd 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -276,7 +276,9 @@ obj-$(CONFIG_MFD_INTEL_M10_BMC)   +=3D intel-m10-bmc.o
 obj-$(CONFIG_MFD_ATC260X)=09+=3D atc260x-core.o
 obj-$(CONFIG_MFD_ATC260X_I2C)=09+=3D atc260x-i2c.o

-rsmu-i2c-objs=09=09=09:=3D rsmu_core.o rsmu_i2c.o
-rsmu-spi-objs=09=09=09:=3D rsmu_core.o rsmu_spi.o
+rsmu-core-objs=09=09=09:=3D rsmu_core.o
+rsmu-i2c-objs=09=09=09:=3D rsmu_i2c.o
+rsmu-spi-objs=09=09=09:=3D rsmu_spi.o
+obj-$(CONFIG_MFD_RSMU_CORE)=09+=3D rsmu-core.o
 obj-$(CONFIG_MFD_RSMU_I2C)=09+=3D rsmu-i2c.o
 obj-$(CONFIG_MFD_RSMU_SPI)=09+=3D rsmu-spi.o
diff --git a/drivers/mfd/rsmu_core.c b/drivers/mfd/rsmu_core.c
index 29437fd0bd5b..5bf1e23a47e5 100644
--- a/drivers/mfd/rsmu_core.c
+++ b/drivers/mfd/rsmu_core.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2021 Integrated Device Technology, Inc., a Renesas Compan=
y.
  */

+#include <linux/export.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mfd/core.h>
@@ -78,11 +79,13 @@ int rsmu_core_init(struct rsmu_ddata *rsmu)

 =09return ret;
 }
+EXPORT_SYMBOL_GPL(rsmu_core_init);

 void rsmu_core_exit(struct rsmu_ddata *rsmu)
 {
 =09mutex_destroy(&rsmu->lock);
 }
+EXPORT_SYMBOL_GPL(rsmu_core_exit);

 MODULE_DESCRIPTION("Renesas SMU core driver");
 MODULE_LICENSE("GPL");
--
2.38.1


