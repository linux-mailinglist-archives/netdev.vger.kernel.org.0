Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7902C51297F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 04:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbiD1CeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 22:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241408AbiD1Cd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 22:33:57 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2807C80BD5
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 19:30:43 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id BD46F32010B;
        Thu, 28 Apr 2022 03:30:42 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1njtvW-0005Vi-IC; Thu, 28 Apr 2022 03:30:42 +0100
Subject: [PATCH net-next v2 01/13] sfc: Disable Siena support
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Thu, 28 Apr 2022 03:30:42 +0100
Message-ID: <165111304228.21042.3034463254070209402.stgit@palantir17.mph.net>
In-Reply-To: <165111298464.21042.9988060027860048966.stgit@palantir17.mph.net>
References: <165111298464.21042.9988060027860048966.stgit@palantir17.mph.net>
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

Disable the build of Siena code until later in this patch series.
Prevent sfc.ko from binding to Siena NICs.

efx_init_sriov/efx_fini_sriov is only used for Siena. Remove calls
to those.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/Kconfig  |    8 ++++----
 drivers/net/ethernet/sfc/Makefile |    4 ++--
 drivers/net/ethernet/sfc/efx.c    |   17 -----------------
 drivers/net/ethernet/sfc/nic.h    |    4 ----
 4 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index 97ce64079855..846fff16fa48 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -17,14 +17,14 @@ config NET_VENDOR_SOLARFLARE
 if NET_VENDOR_SOLARFLARE
 
 config SFC
-	tristate "Solarflare SFC9000/SFC9100/EF100-family support"
+	tristate "Solarflare SFC9100/EF100-family support"
 	depends on PCI
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select MDIO
 	select CRC32
 	help
 	  This driver supports 10/40-gigabit Ethernet cards based on
-	  the Solarflare SFC9000-family and SFC9100-family controllers.
+	  the Solarflare SFC9100-family controllers.
 
 	  It also supports 10/25/40/100-gigabit Ethernet cards based
 	  on the Solarflare EF100 networking IP in Xilinx FPGAs.
@@ -47,11 +47,11 @@ config SFC_MCDI_MON
 	  This exposes the on-board firmware-managed sensors as a
 	  hardware monitor device.
 config SFC_SRIOV
-	bool "Solarflare SFC9000-family SR-IOV support"
+	bool "Solarflare SFC9000/SFC9100-family SR-IOV support"
 	depends on SFC && PCI_IOV
 	default y
 	help
-	  This enables support for the SFC9000 I/O Virtualization
+	  This enables support for the Single Root I/O Virtualization
 	  features, allowing accelerated network performance in
 	  virtualized environments.
 config SFC_MCDI_LOGGING
diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 8bd01c429f91..838ee3cdc229 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
-			   farch.o siena.o ef10.o \
+			   ef10.o \
 			   tx.o tx_common.o tx_tso.o rx.o rx_common.o \
 			   selftest.o ethtool.o ethtool_common.o ptp.o \
 			   mcdi.o mcdi_port.o mcdi_port_common.o \
@@ -8,7 +8,7 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   ef100.o ef100_nic.o ef100_netdev.o \
 			   ef100_ethtool.o ef100_rx.o ef100_tx.o
 sfc-$(CONFIG_SFC_MTD)	+= mtd.o
-sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o siena_sriov.o ef10_sriov.o
+sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o
 
 obj-$(CONFIG_SFC)	+= sfc.o
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 302dc835ac3d..5e7fe75cb1d4 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -795,10 +795,6 @@ static void efx_unregister_netdev(struct efx_nic *efx)
 
 /* PCI device ID table */
 static const struct pci_device_id efx_pci_table[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x0803),	/* SFC9020 */
-	 .driver_data = (unsigned long) &siena_a0_nic_type},
-	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x0813),	/* SFL9021 */
-	 .driver_data = (unsigned long) &siena_a0_nic_type},
 	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x0903),  /* SFC9120 PF */
 	 .driver_data = (unsigned long) &efx_hunt_a0_nic_type},
 	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x1903),  /* SFC9120 VF */
@@ -1294,12 +1290,6 @@ static int __init efx_init_module(void)
 	if (rc)
 		goto err_notifier;
 
-#ifdef CONFIG_SFC_SRIOV
-	rc = efx_init_sriov();
-	if (rc)
-		goto err_sriov;
-#endif
-
 	rc = efx_create_reset_workqueue();
 	if (rc)
 		goto err_reset;
@@ -1319,10 +1309,6 @@ static int __init efx_init_module(void)
  err_pci:
 	efx_destroy_reset_workqueue();
  err_reset:
-#ifdef CONFIG_SFC_SRIOV
-	efx_fini_sriov();
- err_sriov:
-#endif
 	unregister_netdevice_notifier(&efx_netdev_notifier);
  err_notifier:
 	return rc;
@@ -1335,9 +1321,6 @@ static void __exit efx_exit_module(void)
 	pci_unregister_driver(&ef100_pci_driver);
 	pci_unregister_driver(&efx_pci_driver);
 	efx_destroy_reset_workqueue();
-#ifdef CONFIG_SFC_SRIOV
-	efx_fini_sriov();
-#endif
 	unregister_netdevice_notifier(&efx_netdev_notifier);
 
 }
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index 5c2fe3ce3f4d..251868235ae4 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -301,10 +301,6 @@ struct efx_ef10_nic_data {
 int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 			 bool *data_mapped);
 
-int efx_init_sriov(void);
-void efx_fini_sriov(void);
-
-extern const struct efx_nic_type siena_a0_nic_type;
 extern const struct efx_nic_type efx_hunt_a0_nic_type;
 extern const struct efx_nic_type efx_hunt_a0_vf_nic_type;
 

