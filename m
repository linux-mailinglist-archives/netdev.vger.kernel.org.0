Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368B02F7CF2
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 14:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732005AbhAONnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 08:43:37 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:52185 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730880AbhAONnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 08:43:37 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DHMnK2bv7z1qsbH;
        Fri, 15 Jan 2021 14:42:45 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DHMnK23nvz1tYWJ;
        Fri, 15 Jan 2021 14:42:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id CpxX7i8XdQ_D; Fri, 15 Jan 2021 14:42:44 +0100 (CET)
X-Auth-Info: waurMa3pZFMXmzkPkApiKTCbC9ot5p6EVhPSPLRZRFo=
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 15 Jan 2021 14:42:43 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH net-next] net: ks8851: Fix mixed module/builtin build
Date:   Fri, 15 Jan 2021 14:42:39 +0100
Message-Id: <20210115134239.126152-1-marex@denx.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When either the SPI or PAR variant is compiled as module AND the other
variant is compiled as built-in, the following build error occurs:

arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
ks8851_common.c:(.text+0x1564): undefined reference to `__this_module'

Fix this by including the ks8851_common.c in both ks8851_spi.c and
ks8851_par.c. The DEBUG macro is defined in ks8851_common.c, so it
does not have to be defined again.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Lukas Wunner <lukas@wunner.de>
---
NOTE: Maybe there is a better way?
---
 drivers/net/ethernet/micrel/Makefile     | 4 ++--
 drivers/net/ethernet/micrel/ks8851_par.c | 2 +-
 drivers/net/ethernet/micrel/ks8851_spi.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/micrel/Makefile b/drivers/net/ethernet/micrel/Makefile
index 5cc00d22c708..1aedfe0ecaf1 100644
--- a/drivers/net/ethernet/micrel/Makefile
+++ b/drivers/net/ethernet/micrel/Makefile
@@ -5,7 +5,7 @@
 
 obj-$(CONFIG_KS8842) += ks8842.o
 obj-$(CONFIG_KS8851) += ks8851.o
-ks8851-objs = ks8851_common.o ks8851_spi.o
+ks8851-objs = ks8851_spi.o
 obj-$(CONFIG_KS8851_MLL) += ks8851_mll.o
-ks8851_mll-objs = ks8851_common.o ks8851_par.o
+ks8851_mll-objs = ks8851_par.o
 obj-$(CONFIG_KSZ884X_PCI) += ksz884x.o
diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
index 3bab0cb2b1a5..e9131cc8a57b 100644
--- a/drivers/net/ethernet/micrel/ks8851_par.c
+++ b/drivers/net/ethernet/micrel/ks8851_par.c
@@ -8,7 +8,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#define DEBUG
+#include "ks8851_common.c"
 
 #include <linux/interrupt.h>
 #include <linux/module.h>
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
index 4ec7f1615977..53779d66f747 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -8,7 +8,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#define DEBUG
+#include "ks8851_common.c"
 
 #include <linux/interrupt.h>
 #include <linux/module.h>
-- 
2.29.2

