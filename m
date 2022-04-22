Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6B050BB2B
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449219AbiDVPGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449189AbiDVPFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:05:30 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 642025D66B
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:02:21 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id AFFDE320133;
        Fri, 22 Apr 2022 16:02:20 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhunc-0007FM-GW; Fri, 22 Apr 2022 16:02:20 +0100
Subject: [PATCH net-next 25/28] siena: Make HWMON support specific for Siena
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 16:02:20 +0100
Message-ID: <165063974036.27138.18446100885751511322.stgit@palantir17.mph.net>
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

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/Kconfig          |    2 +-
 drivers/net/ethernet/sfc/siena/Kconfig    |    7 +++++++
 drivers/net/ethernet/sfc/siena/mcdi.h     |    6 +++---
 drivers/net/ethernet/sfc/siena/mcdi_mon.c |    4 ++--
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index 4c85b26279c5..dac2f09702aa 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -40,7 +40,7 @@ config SFC_MTD
 	  (e.g. /dev/mtd1).  This is required to update the firmware or
 	  the boot configuration under Linux.
 config SFC_MCDI_MON
-	bool "Solarflare SFC9000/SFC9100-family hwmon support"
+	bool "Solarflare SFC9100-family hwmon support"
 	depends on SFC && HWMON && !(SFC=y && HWMON=m)
 	default y
 	help
diff --git a/drivers/net/ethernet/sfc/siena/Kconfig b/drivers/net/ethernet/sfc/siena/Kconfig
index 26a8cb838d47..4eb6801ff3c0 100644
--- a/drivers/net/ethernet/sfc/siena/Kconfig
+++ b/drivers/net/ethernet/sfc/siena/Kconfig
@@ -18,6 +18,13 @@ config SFC_SIENA_MTD
 	  This exposes the on-board flash and/or EEPROM as MTD devices
 	  (e.g. /dev/mtd1).  This is required to update the firmware or
 	  the boot configuration under Linux.
+config SFC_SIENA_MCDI_MON
+	bool "Solarflare SFC9000-family hwmon support"
+	depends on SFC_SIENA && HWMON && !(SFC_SIENA=y && HWMON=m)
+	default y
+	help
+	  This exposes the on-board firmware-managed sensors as a
+	  hardware monitor device.
 config SFC_SIENA_SRIOV
 	bool "Solarflare SFC9000-family SR-IOV support"
 	depends on SFC_SIENA && PCI_IOV
diff --git a/drivers/net/ethernet/sfc/siena/mcdi.h b/drivers/net/ethernet/sfc/siena/mcdi.h
index 64990f398e67..03810c570a33 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.h
+++ b/drivers/net/ethernet/sfc/siena/mcdi.h
@@ -118,7 +118,7 @@ struct efx_mcdi_mtd_partition {
  */
 struct efx_mcdi_data {
 	struct efx_mcdi_iface iface;
-#ifdef CONFIG_SFC_MCDI_MON
+#ifdef CONFIG_SFC_SIENA_MCDI_MON
 	struct efx_mcdi_mon hwmon;
 #endif
 	u32 fn_flags;
@@ -130,7 +130,7 @@ static inline struct efx_mcdi_iface *efx_mcdi(struct efx_nic *efx)
 	return &efx->mcdi->iface;
 }
 
-#ifdef CONFIG_SFC_MCDI_MON
+#ifdef CONFIG_SFC_SIENA_MCDI_MON
 static inline struct efx_mcdi_mon *efx_mcdi_mon(struct efx_nic *efx)
 {
 	EFX_WARN_ON_PARANOID(!efx->mcdi);
@@ -365,7 +365,7 @@ void efx_siena_mcdi_mac_pull_stats(struct efx_nic *efx);
 enum reset_type efx_siena_mcdi_map_reset_reason(enum reset_type reason);
 int efx_siena_mcdi_reset(struct efx_nic *efx, enum reset_type method);
 
-#ifdef CONFIG_SFC_MCDI_MON
+#ifdef CONFIG_SFC_SIENA_MCDI_MON
 int efx_siena_mcdi_mon_probe(struct efx_nic *efx);
 void efx_siena_mcdi_mon_remove(struct efx_nic *efx);
 #else
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_mon.c b/drivers/net/ethernet/sfc/siena/mcdi_mon.c
index d0c25dfda0d7..c7ea703c5d7a 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_mon.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi_mon.c
@@ -130,7 +130,7 @@ void efx_siena_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev)
 		  type, name, state_txt, value, unit);
 }
 
-#ifdef CONFIG_SFC_MCDI_MON
+#ifdef CONFIG_SFC_SIENA_MCDI_MON
 
 struct efx_mcdi_mon_attribute {
 	struct device_attribute dev_attr;
@@ -528,4 +528,4 @@ void efx_siena_mcdi_mon_remove(struct efx_nic *efx)
 	efx_siena_free_buffer(efx, &hwmon->dma_buf);
 }
 
-#endif /* CONFIG_SFC_MCDI_MON */
+#endif /* CONFIG_SFC_SIENA_MCDI_MON */

