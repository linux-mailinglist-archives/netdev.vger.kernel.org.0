Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993226311CD
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbiKSXIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbiKSXIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:08:49 -0500
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01151A229;
        Sat, 19 Nov 2022 15:08:44 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:08:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899323; x=1669158523;
        bh=6VdnaXou6NR0qAZ4WE3kmJZHL9lSgizWaAZ3d9S6Fq0=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=INXKOGkRr2fEvjSVnH7n1ELGTYSOahKgcJ1OEsqxDE12WVvYIATZ1d9ka42M9pldj
         vlkF9bLkDrDpSVKsRgceOF9oregCmZmEgKdy02ovi9AJLizJjDjrV4PXbXh2KjRZeB
         GxZKdTv7/ZNCfyKKWy2ynBIoTDaki2bxc3FGoE5b4R7DiuTQcG7dIwgbeD+NHp7ZV3
         8bBbypXTZ45UqlAPmE59QGuLxOFpIIclsEbniBv4dRGCwbc7kwmt1BVNN+fFpTUCav
         kGv+SbOKmyeJffXLU9ZxCaIzB+TmnZH/djqrpQVTNcnx79SZuj5dJIMv6OjmG08g/u
         sqy8nmjZNGQVA==
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
Subject: [PATCH 12/18] mtd: tests: fix object shared between several modules
Message-ID: <20221119225650.1044591-13-alobakin@pm.me>
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

mtd_test.o is linked to 8(!) different test modules:

> scripts/Makefile.build:252: ./drivers/mtd/tests/Makefile: mtd_test.o
> is added to multiple modules: mtd_nandbiterrs mtd_oobtest mtd_pagetest
> mtd_readtest mtd_speedtest mtd_stresstest mtd_subpagetest mtd_torturetest

Although all of them share one Kconfig option
(CONFIG_MTD_TESTS), it's better to not link one object file into
several modules (and/or vmlinux).
Under certain circumstances, such can lead to the situation fixed by
commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
In this particular case, there's also no need to duplicate the very
same object code 8 times.

Convert mtd_test.o to a standalone module which will export its
functions to the rest.

Fixes: a995c792280d ("mtd: tests: rename sources in order to link a helper =
object")
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/mtd/tests/Makefile      | 17 +++++++++--------
 drivers/mtd/tests/mtd_test.c    |  9 +++++++++
 drivers/mtd/tests/nandbiterrs.c |  2 ++
 drivers/mtd/tests/oobtest.c     |  2 ++
 drivers/mtd/tests/pagetest.c    |  2 ++
 drivers/mtd/tests/readtest.c    |  2 ++
 drivers/mtd/tests/speedtest.c   |  2 ++
 drivers/mtd/tests/stresstest.c  |  2 ++
 drivers/mtd/tests/subpagetest.c |  2 ++
 drivers/mtd/tests/torturetest.c |  2 ++
 10 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/tests/Makefile b/drivers/mtd/tests/Makefile
index 5de0378f90db..e3f86ed123ca 100644
--- a/drivers/mtd/tests/Makefile
+++ b/drivers/mtd/tests/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_MTD_TESTS) +=3D mtd_test.o
 obj-$(CONFIG_MTD_TESTS) +=3D mtd_oobtest.o
 obj-$(CONFIG_MTD_TESTS) +=3D mtd_pagetest.o
 obj-$(CONFIG_MTD_TESTS) +=3D mtd_readtest.o
@@ -9,11 +10,11 @@ obj-$(CONFIG_MTD_TESTS) +=3D mtd_torturetest.o
 obj-$(CONFIG_MTD_TESTS) +=3D mtd_nandecctest.o
 obj-$(CONFIG_MTD_TESTS) +=3D mtd_nandbiterrs.o

-mtd_oobtest-objs :=3D oobtest.o mtd_test.o
-mtd_pagetest-objs :=3D pagetest.o mtd_test.o
-mtd_readtest-objs :=3D readtest.o mtd_test.o
-mtd_speedtest-objs :=3D speedtest.o mtd_test.o
-mtd_stresstest-objs :=3D stresstest.o mtd_test.o
-mtd_subpagetest-objs :=3D subpagetest.o mtd_test.o
-mtd_torturetest-objs :=3D torturetest.o mtd_test.o
-mtd_nandbiterrs-objs :=3D nandbiterrs.o mtd_test.o
+mtd_oobtest-objs :=3D oobtest.o
+mtd_pagetest-objs :=3D pagetest.o
+mtd_readtest-objs :=3D readtest.o
+mtd_speedtest-objs :=3D speedtest.o
+mtd_stresstest-objs :=3D stresstest.o
+mtd_subpagetest-objs :=3D subpagetest.o
+mtd_torturetest-objs :=3D torturetest.o
+mtd_nandbiterrs-objs :=3D nandbiterrs.o
diff --git a/drivers/mtd/tests/mtd_test.c b/drivers/mtd/tests/mtd_test.c
index c84250beffdc..93920a714315 100644
--- a/drivers/mtd/tests/mtd_test.c
+++ b/drivers/mtd/tests/mtd_test.c
@@ -25,6 +25,7 @@ int mtdtest_erase_eraseblock(struct mtd_info *mtd, unsign=
ed int ebnum)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(mtdtest_erase_eraseblock, MTD_TESTS);

 static int is_block_bad(struct mtd_info *mtd, unsigned int ebnum)
 {
@@ -57,6 +58,7 @@ int mtdtest_scan_for_bad_eraseblocks(struct mtd_info *mtd=
, unsigned char *bbt,

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(mtdtest_scan_for_bad_eraseblocks, MTD_TESTS);

 int mtdtest_erase_good_eraseblocks(struct mtd_info *mtd, unsigned char *bb=
t,
 =09=09=09=09unsigned int eb, int ebcnt)
@@ -75,6 +77,7 @@ int mtdtest_erase_good_eraseblocks(struct mtd_info *mtd, =
unsigned char *bbt,

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(mtdtest_erase_good_eraseblocks, MTD_TESTS);

 int mtdtest_read(struct mtd_info *mtd, loff_t addr, size_t size, void *buf=
)
 {
@@ -92,6 +95,7 @@ int mtdtest_read(struct mtd_info *mtd, loff_t addr, size_=
t size, void *buf)

 =09return err;
 }
+EXPORT_SYMBOL_NS_GPL(mtdtest_read, MTD_TESTS);

 int mtdtest_write(struct mtd_info *mtd, loff_t addr, size_t size,
 =09=09const void *buf)
@@ -107,3 +111,8 @@ int mtdtest_write(struct mtd_info *mtd, loff_t addr, si=
ze_t size,

 =09return err;
 }
+EXPORT_SYMBOL_NS_GPL(mtdtest_write, MTD_TESTS);
+
+MODULE_DESCRIPTION("MTD test common module");
+MODULE_AUTHOR("Adrian Hunter");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mtd/tests/nandbiterrs.c b/drivers/mtd/tests/nandbiterr=
s.c
index 98d7508f95b1..acf44edfca53 100644
--- a/drivers/mtd/tests/nandbiterrs.c
+++ b/drivers/mtd/tests/nandbiterrs.c
@@ -414,6 +414,8 @@ static void __exit mtd_nandbiterrs_exit(void)
 module_init(mtd_nandbiterrs_init);
 module_exit(mtd_nandbiterrs_exit);

+MODULE_IMPORT_NS(MTD_TESTS);
+
 MODULE_DESCRIPTION("NAND bit error recovery test");
 MODULE_AUTHOR("Iwo Mergler");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mtd/tests/oobtest.c b/drivers/mtd/tests/oobtest.c
index 13fed398937e..da4efcdd59b2 100644
--- a/drivers/mtd/tests/oobtest.c
+++ b/drivers/mtd/tests/oobtest.c
@@ -728,6 +728,8 @@ static void __exit mtd_oobtest_exit(void)
 }
 module_exit(mtd_oobtest_exit);

+MODULE_IMPORT_NS(MTD_TESTS);
+
 MODULE_DESCRIPTION("Out-of-band test module");
 MODULE_AUTHOR("Adrian Hunter");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mtd/tests/pagetest.c b/drivers/mtd/tests/pagetest.c
index 8eb40b6e6dfa..ac2bcc76b402 100644
--- a/drivers/mtd/tests/pagetest.c
+++ b/drivers/mtd/tests/pagetest.c
@@ -456,6 +456,8 @@ static void __exit mtd_pagetest_exit(void)
 }
 module_exit(mtd_pagetest_exit);

+MODULE_IMPORT_NS(MTD_TESTS);
+
 MODULE_DESCRIPTION("NAND page test");
 MODULE_AUTHOR("Adrian Hunter");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mtd/tests/readtest.c b/drivers/mtd/tests/readtest.c
index 99670ef91f2b..7e01dbc1e8ca 100644
--- a/drivers/mtd/tests/readtest.c
+++ b/drivers/mtd/tests/readtest.c
@@ -210,6 +210,8 @@ static void __exit mtd_readtest_exit(void)
 }
 module_exit(mtd_readtest_exit);

+MODULE_IMPORT_NS(MTD_TESTS);
+
 MODULE_DESCRIPTION("Read test module");
 MODULE_AUTHOR("Adrian Hunter");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mtd/tests/speedtest.c b/drivers/mtd/tests/speedtest.c
index 075bce32caa5..58f3701d65f2 100644
--- a/drivers/mtd/tests/speedtest.c
+++ b/drivers/mtd/tests/speedtest.c
@@ -413,6 +413,8 @@ static void __exit mtd_speedtest_exit(void)
 }
 module_exit(mtd_speedtest_exit);

+MODULE_IMPORT_NS(MTD_TESTS);
+
 MODULE_DESCRIPTION("Speed test module");
 MODULE_AUTHOR("Adrian Hunter");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mtd/tests/stresstest.c b/drivers/mtd/tests/stresstest.=
c
index 75b6ddc5dc4d..341d7cc86d89 100644
--- a/drivers/mtd/tests/stresstest.c
+++ b/drivers/mtd/tests/stresstest.c
@@ -227,6 +227,8 @@ static void __exit mtd_stresstest_exit(void)
 }
 module_exit(mtd_stresstest_exit);

+MODULE_IMPORT_NS(MTD_TESTS);
+
 MODULE_DESCRIPTION("Stress test module");
 MODULE_AUTHOR("Adrian Hunter");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mtd/tests/subpagetest.c b/drivers/mtd/tests/subpagetes=
t.c
index 05250a080139..87ee2a5c518a 100644
--- a/drivers/mtd/tests/subpagetest.c
+++ b/drivers/mtd/tests/subpagetest.c
@@ -432,6 +432,8 @@ static void __exit mtd_subpagetest_exit(void)
 }
 module_exit(mtd_subpagetest_exit);

+MODULE_IMPORT_NS(MTD_TESTS);
+
 MODULE_DESCRIPTION("Subpage test module");
 MODULE_AUTHOR("Adrian Hunter");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mtd/tests/torturetest.c b/drivers/mtd/tests/torturetes=
t.c
index 841689b4d86d..2de770f18724 100644
--- a/drivers/mtd/tests/torturetest.c
+++ b/drivers/mtd/tests/torturetest.c
@@ -475,6 +475,8 @@ static int countdiffs(unsigned char *buf, unsigned char=
 *check_buf,
 =09return first;
 }

+MODULE_IMPORT_NS(MTD_TESTS);
+
 MODULE_DESCRIPTION("Eraseblock torturing module");
 MODULE_AUTHOR("Artem Bityutskiy, Jarkko Lavinen, Adrian Hunter");
 MODULE_LICENSE("GPL");
--
2.38.1


