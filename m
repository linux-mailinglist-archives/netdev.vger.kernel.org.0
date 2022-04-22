Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF81750BB15
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449238AbiDVPGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449193AbiDVPFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:05:30 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 990745D5CF
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:02:33 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id E7F06320133;
        Fri, 22 Apr 2022 16:02:32 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhuno-0007Fa-Nk; Fri, 22 Apr 2022 16:02:32 +0100
Subject: [PATCH net-next 26/28] sfc/siena: Make MCDI logging support
 specific for Siena
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 16:02:32 +0100
Message-ID: <165063975258.27138.10211437350765932492.stgit@palantir17.mph.net>
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

Add a Siena Kconfig option and use it in stead of the sfc one.
Rename the internal variable for the 'mcdi_logging_default' module
parameter to avoid a naming conflict with the one in sfc.ko.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/Kconfig            |    2 +-
 drivers/net/ethernet/sfc/siena/Kconfig      |   10 ++++++++++
 drivers/net/ethernet/sfc/siena/efx_common.c |    2 +-
 drivers/net/ethernet/sfc/siena/efx_common.h |    2 +-
 drivers/net/ethernet/sfc/siena/mcdi.c       |   23 ++++++++++++-----------
 drivers/net/ethernet/sfc/siena/mcdi.h       |    2 +-
 6 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index dac2f09702aa..0950e6b0508f 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -55,7 +55,7 @@ config SFC_SRIOV
 	  features, allowing accelerated network performance in
 	  virtualized environments.
 config SFC_MCDI_LOGGING
-	bool "Solarflare SFC9000/SFC9100-family MCDI logging support"
+	bool "Solarflare SFC9100-family MCDI logging support"
 	depends on SFC
 	default y
 	help
diff --git a/drivers/net/ethernet/sfc/siena/Kconfig b/drivers/net/ethernet/sfc/siena/Kconfig
index 4eb6801ff3c0..cb3c5cb42a53 100644
--- a/drivers/net/ethernet/sfc/siena/Kconfig
+++ b/drivers/net/ethernet/sfc/siena/Kconfig
@@ -33,3 +33,13 @@ config SFC_SIENA_SRIOV
 	  This enables support for the Single Root I/O Virtualization
 	  features, allowing accelerated network performance in
 	  virtualized environments.
+config SFC_SIENA_MCDI_LOGGING
+	bool "Solarflare SFC9000-family MCDI logging support"
+	depends on SFC_SIENA
+	default y
+	help
+	  This enables support for tracing of MCDI (Management-Controller-to-
+	  Driver-Interface) commands and responses, allowing debugging of
+	  driver/firmware interaction.  The tracing is actually enabled by
+	  a sysfs file 'mcdi_logging' under the PCI device, or via module
+	  parameter mcdi_logging_default.
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 3aef8d216f95..a615bffcbad4 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -1170,7 +1170,7 @@ void efx_siena_fini_io(struct efx_nic *efx)
 		pci_disable_device(efx->pci_dev);
 }
 
-#ifdef CONFIG_SFC_MCDI_LOGGING
+#ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
 static ssize_t mcdi_logging_show(struct device *dev,
 				 struct device_attribute *attr,
 				 char *buf)
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.h b/drivers/net/ethernet/sfc/siena/efx_common.h
index 470033611436..aeb92f4e34b7 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.h
+++ b/drivers/net/ethernet/sfc/siena/efx_common.h
@@ -88,7 +88,7 @@ static inline void efx_schedule_channel_irq(struct efx_channel *channel)
 	efx_schedule_channel(channel);
 }
 
-#ifdef CONFIG_SFC_MCDI_LOGGING
+#ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
 void efx_siena_init_mcdi_logging(struct efx_nic *efx);
 void efx_siena_fini_mcdi_logging(struct efx_nic *efx);
 #else
diff --git a/drivers/net/ethernet/sfc/siena/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
index b767e29cfe92..3df0f0eca3b7 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi.c
@@ -51,9 +51,10 @@ static int efx_mcdi_drv_attach(struct efx_nic *efx, bool driver_operating,
 static bool efx_mcdi_poll_once(struct efx_nic *efx);
 static void efx_mcdi_abandon(struct efx_nic *efx);
 
-#ifdef CONFIG_SFC_MCDI_LOGGING
-static bool mcdi_logging_default;
-module_param(mcdi_logging_default, bool, 0644);
+#ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
+static bool efx_siena_mcdi_logging_default;
+module_param_named(mcdi_logging_default, efx_siena_mcdi_logging_default,
+		   bool, 0644);
 MODULE_PARM_DESC(mcdi_logging_default,
 		 "Enable MCDI logging on newly-probed functions");
 #endif
@@ -70,12 +71,12 @@ int efx_siena_mcdi_init(struct efx_nic *efx)
 
 	mcdi = efx_mcdi(efx);
 	mcdi->efx = efx;
-#ifdef CONFIG_SFC_MCDI_LOGGING
+#ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
 	/* consuming code assumes buffer is page-sized */
 	mcdi->logging_buffer = (char *)__get_free_page(GFP_KERNEL);
 	if (!mcdi->logging_buffer)
 		goto fail1;
-	mcdi->logging_enabled = mcdi_logging_default;
+	mcdi->logging_enabled = efx_siena_mcdi_logging_default;
 #endif
 	init_waitqueue_head(&mcdi->wq);
 	init_waitqueue_head(&mcdi->proxy_rx_wq);
@@ -114,7 +115,7 @@ int efx_siena_mcdi_init(struct efx_nic *efx)
 
 	return 0;
 fail2:
-#ifdef CONFIG_SFC_MCDI_LOGGING
+#ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
 	free_page((unsigned long)mcdi->logging_buffer);
 fail1:
 #endif
@@ -140,7 +141,7 @@ void efx_siena_mcdi_fini(struct efx_nic *efx)
 	if (!efx->mcdi)
 		return;
 
-#ifdef CONFIG_SFC_MCDI_LOGGING
+#ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
 	free_page((unsigned long)efx->mcdi->iface.logging_buffer);
 #endif
 
@@ -151,7 +152,7 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
 				  const efx_dword_t *inbuf, size_t inlen)
 {
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
-#ifdef CONFIG_SFC_MCDI_LOGGING
+#ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
 	char *buf = mcdi->logging_buffer; /* page-sized */
 #endif
 	efx_dword_t hdr[2];
@@ -198,7 +199,7 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
 		hdr_len = 8;
 	}
 
-#ifdef CONFIG_SFC_MCDI_LOGGING
+#ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
 	if (mcdi->logging_enabled && !WARN_ON_ONCE(!buf)) {
 		int bytes = 0;
 		int i;
@@ -266,7 +267,7 @@ static void efx_mcdi_read_response_header(struct efx_nic *efx)
 {
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
 	unsigned int respseq, respcmd, error;
-#ifdef CONFIG_SFC_MCDI_LOGGING
+#ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
 	char *buf = mcdi->logging_buffer; /* page-sized */
 #endif
 	efx_dword_t hdr;
@@ -286,7 +287,7 @@ static void efx_mcdi_read_response_header(struct efx_nic *efx)
 			EFX_DWORD_FIELD(hdr, MC_CMD_V2_EXTN_IN_ACTUAL_LEN);
 	}
 
-#ifdef CONFIG_SFC_MCDI_LOGGING
+#ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
 	if (mcdi->logging_enabled && !WARN_ON_ONCE(!buf)) {
 		size_t hdr_len, data_len;
 		int bytes = 0;
diff --git a/drivers/net/ethernet/sfc/siena/mcdi.h b/drivers/net/ethernet/sfc/siena/mcdi.h
index 03810c570a33..06f38e5e6832 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.h
+++ b/drivers/net/ethernet/sfc/siena/mcdi.h
@@ -80,7 +80,7 @@ struct efx_mcdi_iface {
 	spinlock_t async_lock;
 	struct list_head async_list;
 	struct timer_list async_timer;
-#ifdef CONFIG_SFC_MCDI_LOGGING
+#ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
 	char *logging_buffer;
 	bool logging_enabled;
 #endif

