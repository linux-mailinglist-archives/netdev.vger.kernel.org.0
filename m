Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0E26311AC
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbiKSXEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbiKSXE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:04:29 -0500
Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE78E13D59;
        Sat, 19 Nov 2022 15:04:27 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:04:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899066; x=1669158266;
        bh=2+sOxC40kt2h/1Sz9kRo5GxpGnAXAGHbxk3TUs+fmSg=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=jAjIY4B0YN1LB7N8qwiwUWlFcsxMt9pRvkXj5uAappI40qAbxYMLRmBS/xbgf6UFg
         8GP/4XFuSAiyX34JLKshx8QtDxyhLcwSg8dsUeAKR5DfHzJODZFz1SS7SFpqQWSE92
         kQkHtGjvsLiAqMdChUFKvytUa2fSL2QHtyEw3OxIuXIZ6zn3iVDmoDx/5VThDaHwLy
         U5vkbtRx4Hbwa65avysoi42FPMolv/YzFlQXS86B4CWA/9FQaxRSg3BNwMEp9QINq6
         E/CLZ0Sbuqy/cKsHn9Qrqq78W1vpYmSF+x1q3ltCWUp6CgeZTkZAX7neHMpso+F+82
         pVYfmgihEegcw==
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
Subject: [PATCH 01/18] block/rnbd: fix mixed module-builtin object
Message-ID: <20221119225650.1044591-2-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
References: <20221119225650.1044591-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

With CONFIG_BLK_DEV_RNBD_CLIENT=3Dm and CONFIG_BLK_DEV_RNBD_SERVER=3Dy
(or vice versa), rnbd-common.o is linked to a module and also to
vmlinux even though CFLAGS are different between builtins and modules.

This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
Fixing mixed module-builtin objects").

Turn rnbd_access_mode_str() into an inline function.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-and-tested-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/block/rnbd/Makefile      |  6 ++----
 drivers/block/rnbd/rnbd-common.c | 23 -----------------------
 drivers/block/rnbd/rnbd-proto.h  | 14 +++++++++++++-
 3 files changed, 15 insertions(+), 28 deletions(-)
 delete mode 100644 drivers/block/rnbd/rnbd-common.c

diff --git a/drivers/block/rnbd/Makefile b/drivers/block/rnbd/Makefile
index 40b31630822c..208e5f865497 100644
--- a/drivers/block/rnbd/Makefile
+++ b/drivers/block/rnbd/Makefile
@@ -3,13 +3,11 @@
 ccflags-y :=3D -I$(srctree)/drivers/infiniband/ulp/rtrs

 rnbd-client-y :=3D rnbd-clt.o \
-=09=09  rnbd-clt-sysfs.o \
-=09=09  rnbd-common.o
+=09=09  rnbd-clt-sysfs.o

 CFLAGS_rnbd-srv-trace.o =3D -I$(src)

-rnbd-server-y :=3D rnbd-common.o \
-=09=09  rnbd-srv.o \
+rnbd-server-y :=3D rnbd-srv.o \
 =09=09  rnbd-srv-sysfs.o \
 =09=09  rnbd-srv-trace.o

diff --git a/drivers/block/rnbd/rnbd-common.c b/drivers/block/rnbd/rnbd-com=
mon.c
deleted file mode 100644
index 596c3f732403..000000000000
--- a/drivers/block/rnbd/rnbd-common.c
+++ /dev/null
@@ -1,23 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * RDMA Network Block Driver
- *
- * Copyright (c) 2014 - 2018 ProfitBricks GmbH. All rights reserved.
- * Copyright (c) 2018 - 2019 1&1 IONOS Cloud GmbH. All rights reserved.
- * Copyright (c) 2019 - 2020 1&1 IONOS SE. All rights reserved.
- */
-#include "rnbd-proto.h"
-
-const char *rnbd_access_mode_str(enum rnbd_access_mode mode)
-{
-=09switch (mode) {
-=09case RNBD_ACCESS_RO:
-=09=09return "ro";
-=09case RNBD_ACCESS_RW:
-=09=09return "rw";
-=09case RNBD_ACCESS_MIGRATION:
-=09=09return "migration";
-=09default:
-=09=09return "unknown";
-=09}
-}
diff --git a/drivers/block/rnbd/rnbd-proto.h b/drivers/block/rnbd/rnbd-prot=
o.h
index ea7ac8bca63c..1849e7039fa1 100644
--- a/drivers/block/rnbd/rnbd-proto.h
+++ b/drivers/block/rnbd/rnbd-proto.h
@@ -300,6 +300,18 @@ static inline u32 rq_to_rnbd_flags(struct request *rq)
 =09return rnbd_opf;
 }

-const char *rnbd_access_mode_str(enum rnbd_access_mode mode);
+static inline const char *rnbd_access_mode_str(enum rnbd_access_mode mode)
+{
+=09switch (mode) {
+=09case RNBD_ACCESS_RO:
+=09=09return "ro";
+=09case RNBD_ACCESS_RW:
+=09=09return "rw";
+=09case RNBD_ACCESS_MIGRATION:
+=09=09return "migration";
+=09default:
+=09=09return "unknown";
+=09}
+}

 #endif /* RNBD_PROTO_H */
--
2.38.1


