Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F486311CA
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbiKSXIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiKSXId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:08:33 -0500
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBAB218B;
        Sat, 19 Nov 2022 15:08:31 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:08:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899309; x=1669158509;
        bh=zn0V2DT6W2z01KImfq/5Gwy2BxeJtWHzr6gc3StE15M=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=jYf7O9jFrMZeXW86EsQISked7sIdxcuiotjHFn14vuvXN15oH9ckmhTKoHHHrGKQS
         WvAioU9V+6jK57z4Mq64rCtQ+K9Wdh825pM/BqnKeUL0ICnc/hkml1iTi4Ux8d3Odr
         zNmoiTTy8aQX2/6G6LXG71gUrts2nho+vGldh9kYWzDltOUnPeM4FR4YCjT0VqzdK6
         0C68EUsI+/R45aOf+9HngV+zK7iGVzA+0C2Ya/ybkXF0neyLY1Ma+2lTbEPUJXEYBM
         efAguDDev0xXZs+X+cuV2DBj1TjV7AWM805c3JOyqvWvA9U7zH9rupP/pjtFj5XhKL
         lWeStGsiIStAw==
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
Subject: [PATCH 11/18] platform/x86: int3472: fix object shared between several modules
Message-ID: <20221119225650.1044591-12-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
References: <20221119225650.1044591-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

common.o is linked to both intel_skl_int3472_{discrete,tps68470}:

> scripts/Makefile.build:252: ./drivers/platform/x86/intel/int3472/Makefile=
:
> common.o is added to multiple modules: intel_skl_int3472_discrete
> intel_skl_int3472_tps68470

Although both drivers share one Kconfig option
(CONFIG_INTEL_SKL_INT3472), it's better to not link one object file
into several modules (and/or vmlinux).
Under certain circumstances, such can lead to the situation fixed by
commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").

Introduce the new module, intel_skl_int3472_common, to provide the
functions from common.o to both discrete and tps68470 drivers. This
adds only 3 exports and doesn't provide any changes to the actual
code.

Fixes: a2f9fbc247ee ("platform/x86: int3472: Split into 2 drivers")
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/platform/x86/intel/int3472/Makefile   | 8 +++++---
 drivers/platform/x86/intel/int3472/common.c   | 8 ++++++++
 drivers/platform/x86/intel/int3472/discrete.c | 2 ++
 drivers/platform/x86/intel/int3472/tps68470.c | 2 ++
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/Makefile b/drivers/platform=
/x86/intel/int3472/Makefile
index cfec7784c5c9..53cc0e7db749 100644
--- a/drivers/platform/x86/intel/int3472/Makefile
+++ b/drivers/platform/x86/intel/int3472/Makefile
@@ -1,4 +1,6 @@
-obj-$(CONFIG_INTEL_SKL_INT3472)=09=09+=3D intel_skl_int3472_discrete.o \
+obj-$(CONFIG_INTEL_SKL_INT3472)=09=09+=3D intel_skl_int3472_common.o \
+=09=09=09=09=09   intel_skl_int3472_discrete.o \
 =09=09=09=09=09   intel_skl_int3472_tps68470.o
-intel_skl_int3472_discrete-y=09=09:=3D discrete.o clk_and_regulator.o comm=
on.o
-intel_skl_int3472_tps68470-y=09=09:=3D tps68470.o tps68470_board_data.o co=
mmon.o
+intel_skl_int3472_common-y=09=09:=3D common.o
+intel_skl_int3472_discrete-y=09=09:=3D discrete.o clk_and_regulator.o
+intel_skl_int3472_tps68470-y=09=09:=3D tps68470.o tps68470_board_data.o
diff --git a/drivers/platform/x86/intel/int3472/common.c b/drivers/platform=
/x86/intel/int3472/common.c
index 9db2bb0bbba4..bd573ff46610 100644
--- a/drivers/platform/x86/intel/int3472/common.c
+++ b/drivers/platform/x86/intel/int3472/common.c
@@ -2,6 +2,7 @@
 /* Author: Dan Scally <djrscally@gmail.com> */

 #include <linux/acpi.h>
+#include <linux/module.h>
 #include <linux/slab.h>

 #include "common.h"
@@ -29,6 +30,7 @@ union acpi_object *skl_int3472_get_acpi_buffer(struct acp=
i_device *adev, char *i

 =09return obj;
 }
+EXPORT_SYMBOL_NS_GPL(skl_int3472_get_acpi_buffer, INTEL_SKL_INT3472);

 int skl_int3472_fill_cldb(struct acpi_device *adev, struct int3472_cldb *c=
ldb)
 {
@@ -52,6 +54,7 @@ int skl_int3472_fill_cldb(struct acpi_device *adev, struc=
t int3472_cldb *cldb)
 =09kfree(obj);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(skl_int3472_fill_cldb, INTEL_SKL_INT3472);

 /* sensor_adev_ret may be NULL, name_ret must not be NULL */
 int skl_int3472_get_sensor_adev_and_name(struct device *dev,
@@ -80,3 +83,8 @@ int skl_int3472_get_sensor_adev_and_name(struct device *d=
ev,

 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(skl_int3472_get_sensor_adev_and_name, INTEL_SKL_INT34=
72);
+
+MODULE_DESCRIPTION("Intel SkyLake INT3472 Common Module");
+MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/platform/x86/intel/int3472/discrete.c b/drivers/platfo=
rm/x86/intel/int3472/discrete.c
index 974a132db651..a1f3b593cea6 100644
--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -414,6 +414,8 @@ static struct platform_driver int3472_discrete =3D {
 };
 module_platform_driver(int3472_discrete);

+MODULE_IMPORT_NS(INTEL_SKL_INT3472);
+
 MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI Discrete Device Driver");
 MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/platform/x86/intel/int3472/tps68470.c b/drivers/platfo=
rm/x86/intel/int3472/tps68470.c
index 5b8d1a9620a5..3c983aa7731f 100644
--- a/drivers/platform/x86/intel/int3472/tps68470.c
+++ b/drivers/platform/x86/intel/int3472/tps68470.c
@@ -255,6 +255,8 @@ static struct i2c_driver int3472_tps68470 =3D {
 };
 module_i2c_driver(int3472_tps68470);

+MODULE_IMPORT_NS(INTEL_SKL_INT3472);
+
 MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI TPS68470 Device Driver");
 MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
 MODULE_LICENSE("GPL v2");
--
2.38.1


