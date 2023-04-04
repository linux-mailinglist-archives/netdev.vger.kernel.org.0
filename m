Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBDE6D5FBF
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbjDDL7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbjDDL7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:59:12 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F74F35B3
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 04:59:10 -0700 (PDT)
Received: from ramsan.of.borg ([84.195.187.55])
        by xavier.telenet-ops.be with bizsmtp
        id gbz42900P1C8whw01bz4yR; Tue, 04 Apr 2023 13:59:08 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pjfIm-00FxwM-QC;
        Tue, 04 Apr 2023 13:59:04 +0200
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pjfJY-000xCe-KW;
        Tue, 04 Apr 2023 13:59:04 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] can: CAN_BXCAN should depend on ARCH_STM32
Date:   Tue,  4 Apr 2023 13:59:00 +0200
Message-Id: <40095112efd1b2214e4223109fd9f0c6d0158a2d.1680609318.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The STMicroelectronics STM32 basic extended CAN Controller (bxCAN) is
only present on STM32 SoCs.  Hence drop the "|| OF" part from its
dependency rule, to prevent asking the user about this driver when
configuring a kernel without STM32 SoC support.

Fixes: f00647d8127be4d3 ("can: bxcan: add support for ST bxCAN controller")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Until v3[1], BXCAN depended on "(ARCH_STM32 || COMPILE_TEST) && OF".
v4[2] changed this from "&& OF" to "|| OF", for no apparent reason, and
without mentioning this in the changelog.

[1] https://lore.kernel.org/all/20220828133329.793324-5-dario.binacchi@amarulasolutions.com
[2] https://lore.kernel.org/all/20220925175209.1528960-6-dario.binacchi@amarulasolutions.com
---
 drivers/net/can/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 3ceccafd701b2a31..b190007c01bec5f4 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -95,7 +95,7 @@ config CAN_AT91
 
 config CAN_BXCAN
 	tristate "STM32 Basic Extended CAN (bxCAN) devices"
-	depends on OF || ARCH_STM32 || COMPILE_TEST
+	depends on ARCH_STM32 || COMPILE_TEST
 	depends on HAS_IOMEM
 	select CAN_RX_OFFLOAD
 	help
-- 
2.34.1

