Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FDD402A11
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 15:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344864AbhIGNr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 09:47:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234939AbhIGNr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 09:47:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABB486105A;
        Tue,  7 Sep 2021 13:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631022381;
        bh=QFljL/tXuu3N1HI7DOzEzMpmHJdD1GvVQpEJe3tl4BI=;
        h=From:To:Cc:Subject:Date:From;
        b=uXw0xE+YiqviXG3ON0sQof9GpahLt7A+0ifjYfc/M9rz2+9mQp9G2fcYoUCjmC/nY
         xcmQLEBFJcHUW1OQws6kVUUXgPnTS+nyeGUac3XQV/uRsF2EW7GlXxcnQgAgrVvJmt
         SBV4mordirP1EONwm8LGbRsvtFmH+HxUEtEnBdWrVWxdQgU4nm3ZCNscXYNECAW95Y
         /uaFemB7NyDrPwUSz6+x9+taKyMhkJkZhJtxK+EnVqLtYsHz6zPyeEMHCIqP2Wyu4Z
         ZX9ggHUmQJ2EnD9+iErF6aSioF/1vAbSZmMSQz5jb+uXF3oXU9Iv0SSAF6yWfv9shz
         QhF4iaYxsB9DQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Armin Wolf <W_Armin@gmx.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] ne2000: fix unused function warning
Date:   Tue,  7 Sep 2021 15:46:10 +0200
Message-Id: <20210907134617.185601-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Geert noticed a warning on MIPS TX49xx, Atari and presuambly other
platforms when the driver is built-in but NETDEV_LEGACY_INIT is
disabled:

drivers/net/ethernet/8390/ne.c:909:20: warning: ‘ne_add_devices’ defined but not used [-Wunused-function]

Merge the two module init functions into a single one with an
IS_ENABLED() check to replace the incorrect #ifdef.

Fixes: 4228c3942821 ("make legacy ISA probe optional")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: do a larger rework to avoid introducing a different build error
---
 drivers/net/ethernet/8390/ne.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.c
index 53660bc8d6ff..9afc712f5948 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -922,13 +922,16 @@ static void __init ne_add_devices(void)
 	}
 }
 
-#ifdef MODULE
 static int __init ne_init(void)
 {
 	int retval;
-	ne_add_devices();
+
+	if (IS_MODULE(CONFIG_NE2000))
+		ne_add_devices();
+
 	retval = platform_driver_probe(&ne_driver, ne_drv_probe);
-	if (retval) {
+
+	if (IS_MODULE(CONFIG_NE2000) && retval) {
 		if (io[0] == 0)
 			pr_notice("ne.c: You must supply \"io=0xNNN\""
 			       " value(s) for ISA cards.\n");
@@ -941,18 +944,8 @@ static int __init ne_init(void)
 	return retval;
 }
 module_init(ne_init);
-#else /* MODULE */
-static int __init ne_init(void)
-{
-	int retval = platform_driver_probe(&ne_driver, ne_drv_probe);
-
-	/* Unregister unused platform_devices. */
-	ne_loop_rm_unreg(0);
-	return retval;
-}
-module_init(ne_init);
 
-#ifdef CONFIG_NETDEV_LEGACY_INIT
+#if !defined(MODULE) && defined(CONFIG_NETDEV_LEGACY_INIT)
 struct net_device * __init ne_probe(int unit)
 {
 	int this_dev;
@@ -994,7 +987,6 @@ struct net_device * __init ne_probe(int unit)
 	return ERR_PTR(-ENODEV);
 }
 #endif
-#endif /* MODULE */
 
 static void __exit ne_exit(void)
 {
-- 
2.29.2

