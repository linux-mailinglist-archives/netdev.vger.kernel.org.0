Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F10402975
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 15:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344702AbhIGNMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 09:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344579AbhIGNMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 09:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BC17610C8;
        Tue,  7 Sep 2021 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631020255;
        bh=Rz4hO5BCGbbFRWC2Nk/lcOLcGQGu2pIVCHJHZv8S3Gg=;
        h=From:To:Cc:Subject:Date:From;
        b=WKyM1BLcBEz+7Ut1+BSJQqK1I5IO+KSJ9+X/kL0LMyH1bC227Dbkq5bjr+285Ye+J
         K2TYwcAaxotF1zoc78dAE7KCT1/7lOrmoFo6D7RAErdq63oHgAceg3MxDt4kJMqPr+
         4Ml3GJf0jxhzH+8l/Nm3t6rb2F8hLpU0ysOqkVmJoICoNKVU4zQTOSAPKDh6G6juS0
         uxH95HR/fc7OaAibjJJd5PX4ZY0rGGTx7YRJyn6GBwbE9Oy1VKjIRc7p8UyMf3bHrG
         5xLSQmIRfNVXJtCGr6n1Bd2bUAOK7O8Sdh5XeJh67o6WdIBUcfAdJu46RWHC+bp28+
         5DstxAJsLOXxw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Armin Wolf <W_Armin@gmx.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ne2000: fix unused function warning
Date:   Tue,  7 Sep 2021 15:10:30 +0200
Message-Id: <20210907131046.117800-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Geert noticed a warning on MIPS TX49xx:

drivers/net/ethernet/8390/ne.c:909:20: warning: ‘ne_add_devices’ defined but not used [-Wunused-function]

Move the function into the #ifdef section that contains its
only caller.

Fixes: 4228c3942821 ("make legacy ISA probe optional")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/8390/ne.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.c
index 53660bc8d6ff..1f7525f55994 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -906,22 +906,6 @@ static struct platform_driver ne_driver = {
 	},
 };
 
-static void __init ne_add_devices(void)
-{
-	int this_dev;
-	struct platform_device *pdev;
-
-	for (this_dev = 0; this_dev < MAX_NE_CARDS; this_dev++) {
-		if (pdev_ne[this_dev])
-			continue;
-		pdev = platform_device_register_simple(
-			DRV_NAME, this_dev, NULL, 0);
-		if (IS_ERR(pdev))
-			continue;
-		pdev_ne[this_dev] = pdev;
-	}
-}
-
 #ifdef MODULE
 static int __init ne_init(void)
 {
@@ -953,6 +937,22 @@ static int __init ne_init(void)
 module_init(ne_init);
 
 #ifdef CONFIG_NETDEV_LEGACY_INIT
+static void __init ne_add_devices(void)
+{
+	int this_dev;
+	struct platform_device *pdev;
+
+	for (this_dev = 0; this_dev < MAX_NE_CARDS; this_dev++) {
+		if (pdev_ne[this_dev])
+			continue;
+		pdev = platform_device_register_simple(
+			DRV_NAME, this_dev, NULL, 0);
+		if (IS_ERR(pdev))
+			continue;
+		pdev_ne[this_dev] = pdev;
+	}
+}
+
 struct net_device * __init ne_probe(int unit)
 {
 	int this_dev;
-- 
2.29.2

