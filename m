Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D9F50BB2E
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449206AbiDVPFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449202AbiDVPE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:04:28 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A11495C679
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:01:32 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id BEC61320133;
        Fri, 22 Apr 2022 16:01:31 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhump-0007CZ-I9; Fri, 22 Apr 2022 16:01:31 +0100
Subject: [PATCH net-next 21/28] sfc: Add a basic Siena module
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 16:01:31 +0100
Message-ID: <165063969142.27138.15318152784563247672.stgit@palantir17.mph.net>
In-Reply-To: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Habets <martinh@xilinx.com>

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/Kconfig        |    1 +
 drivers/net/ethernet/sfc/Makefile       |    1 +
 drivers/net/ethernet/sfc/siena/Kconfig  |   12 ++++++++++++
 drivers/net/ethernet/sfc/siena/Makefile |   11 +++++++++++
 4 files changed, 25 insertions(+)
 create mode 100644 drivers/net/ethernet/sfc/siena/Kconfig
 create mode 100644 drivers/net/ethernet/sfc/siena/Makefile

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index 846fff16fa48..98db551ba2b7 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -65,5 +65,6 @@ config SFC_MCDI_LOGGING
 	  a sysfs file 'mcdi_logging' under the PCI device.
 
 source "drivers/net/ethernet/sfc/falcon/Kconfig"
+source "drivers/net/ethernet/sfc/siena/Kconfig"
 
 endif # NET_VENDOR_SOLARFLARE
diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 838ee3cdc229..0f806ea68837 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -13,3 +13,4 @@ sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o
 obj-$(CONFIG_SFC)	+= sfc.o
 
 obj-$(CONFIG_SFC_FALCON) += falcon/
+obj-$(CONFIG_SFC_SIENA) += siena/
diff --git a/drivers/net/ethernet/sfc/siena/Kconfig b/drivers/net/ethernet/sfc/siena/Kconfig
new file mode 100644
index 000000000000..3d52aee50d5a
--- /dev/null
+++ b/drivers/net/ethernet/sfc/siena/Kconfig
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config SFC_SIENA
+	tristate "Solarflare SFC9000 support"
+	depends on PCI
+	select MDIO
+	select CRC32
+	help
+	  This driver supports 10-gigabit Ethernet cards based on
+	  the Solarflare SFC9000 controller.
+
+	  To compile this driver as a module, choose M here.  The module
+	  will be called sfc-siena.
diff --git a/drivers/net/ethernet/sfc/siena/Makefile b/drivers/net/ethernet/sfc/siena/Makefile
new file mode 100644
index 000000000000..74cb8b7d281e
--- /dev/null
+++ b/drivers/net/ethernet/sfc/siena/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+sfc-siena-y		+= farch.o siena.o \
+			   efx.o efx_common.o efx_channels.o nic.o \
+			   tx.o tx_common.o rx.o rx_common.o \
+			   selftest.o ethtool.o ethtool_common.o ptp.o \
+			   mcdi.o mcdi_port.o mcdi_port_common.o \
+			   mcdi_mon.o
+sfc-siena-$(CONFIG_SFC_MTD)	+= mtd.o
+sfc-siena-$(CONFIG_SFC_SRIOV)	+= siena_sriov.o
+
+obj-$(CONFIG_SFC_SIENA)	+= sfc-siena.o

