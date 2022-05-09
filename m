Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A52D51FF1E
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236556AbiEIOHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236551AbiEIOHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:07:07 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A910F218FFD
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:03:12 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:8886:2b92:63eb:2922])
        by xavier.telenet-ops.be with bizsmtp
        id Ue312700i0moLbn01e31NE; Mon, 09 May 2022 16:03:09 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1no3yX-003XrP-7E; Mon, 09 May 2022 16:03:01 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1no3yW-003Sj2-Mq; Mon, 09 May 2022 16:03:00 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] can: ctucanfd: Let users select instead of depend on CAN_CTUCANFD
Date:   Mon,  9 May 2022 16:02:59 +0200
Message-Id: <887b7440446b6244a20a503cc6e8dc9258846706.1652104941.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CTU CAN-FD IP core is only useful when used with one of the
corresponding PCI/PCIe or platform (FPGA, SoC) drivers, which depend on
PCI resp. OF.

Hence make the users select the core driver code, instead of letting
then depend on it.  Keep the core code config option visible when
compile-testing, to maintain compile-coverage.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/can/ctucanfd/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/ctucanfd/Kconfig b/drivers/net/can/ctucanfd/Kconfig
index 48963efc7f19955f..3c383612eb1764e2 100644
--- a/drivers/net/can/ctucanfd/Kconfig
+++ b/drivers/net/can/ctucanfd/Kconfig
@@ -1,5 +1,5 @@
 config CAN_CTUCANFD
-	tristate "CTU CAN-FD IP core"
+	tristate "CTU CAN-FD IP core" if COMPILE_TEST
 	help
 	  This driver adds support for the CTU CAN FD open-source IP core.
 	  More documentation and core sources at project page
@@ -13,8 +13,8 @@ config CAN_CTUCANFD
 
 config CAN_CTUCANFD_PCI
 	tristate "CTU CAN-FD IP core PCI/PCIe driver"
-	depends on CAN_CTUCANFD
 	depends on PCI
+	select CAN_CTUCANFD
 	help
 	  This driver adds PCI/PCIe support for CTU CAN-FD IP core.
 	  The project providing FPGA design for Intel EP4CGX15 based DB4CGX15
@@ -23,8 +23,8 @@ config CAN_CTUCANFD_PCI
 
 config CAN_CTUCANFD_PLATFORM
 	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
-	depends on CAN_CTUCANFD
 	depends on OF || COMPILE_TEST
+	select CAN_CTUCANFD
 	help
 	  The core has been tested together with OpenCores SJA1000
 	  modified to be CAN FD frames tolerant on MicroZed Zynq based
-- 
2.25.1

