Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92ADA50BB2C
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449136AbiDVPFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449145AbiDVPF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:05:26 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB4255D5C5
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:01:56 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 3B94A320215;
        Fri, 22 Apr 2022 16:01:56 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhunE-0007Er-11; Fri, 22 Apr 2022 16:01:56 +0100
Subject: [PATCH net-next 23/28] siena: Make MTD support specific for Siena
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 16:01:55 +0100
Message-ID: <165063971588.27138.2375274797489140212.stgit@palantir17.mph.net>
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
 drivers/net/ethernet/sfc/Kconfig            |    2 +-
 drivers/net/ethernet/sfc/siena/Kconfig      |    8 ++++++++
 drivers/net/ethernet/sfc/siena/Makefile     |    4 ++--
 drivers/net/ethernet/sfc/siena/efx.h        |    2 +-
 drivers/net/ethernet/sfc/siena/efx_common.c |    2 +-
 drivers/net/ethernet/sfc/siena/mcdi.c       |    4 ++--
 drivers/net/ethernet/sfc/siena/mcdi.h       |    2 +-
 drivers/net/ethernet/sfc/siena/net_driver.h |    4 ++--
 drivers/net/ethernet/sfc/siena/siena.c      |    6 +++---
 9 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index 98db551ba2b7..79b8ccaeee01 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -32,7 +32,7 @@ config SFC
 	  To compile this driver as a module, choose M here.  The module
 	  will be called sfc.
 config SFC_MTD
-	bool "Solarflare SFC9000/SFC9100-family MTD support"
+	bool "Solarflare SFC9100-family MTD support"
 	depends on SFC && MTD && !(SFC=y && MTD=m)
 	default y
 	help
diff --git a/drivers/net/ethernet/sfc/siena/Kconfig b/drivers/net/ethernet/sfc/siena/Kconfig
index 3d52aee50d5a..805b902f903d 100644
--- a/drivers/net/ethernet/sfc/siena/Kconfig
+++ b/drivers/net/ethernet/sfc/siena/Kconfig
@@ -10,3 +10,11 @@ config SFC_SIENA
 
 	  To compile this driver as a module, choose M here.  The module
 	  will be called sfc-siena.
+config SFC_SIENA_MTD
+	bool "Solarflare SFC9000-family MTD support"
+	depends on SFC_SIENA && MTD && !(SFC_SIENA=y && MTD=m)
+	default y
+	help
+	  This exposes the on-board flash and/or EEPROM as MTD devices
+	  (e.g. /dev/mtd1).  This is required to update the firmware or
+	  the boot configuration under Linux.
diff --git a/drivers/net/ethernet/sfc/siena/Makefile b/drivers/net/ethernet/sfc/siena/Makefile
index 74cb8b7d281e..3729095a51d9 100644
--- a/drivers/net/ethernet/sfc/siena/Makefile
+++ b/drivers/net/ethernet/sfc/siena/Makefile
@@ -5,7 +5,7 @@ sfc-siena-y		+= farch.o siena.o \
 			   selftest.o ethtool.o ethtool_common.o ptp.o \
 			   mcdi.o mcdi_port.o mcdi_port_common.o \
 			   mcdi_mon.o
-sfc-siena-$(CONFIG_SFC_MTD)	+= mtd.o
-sfc-siena-$(CONFIG_SFC_SRIOV)	+= siena_sriov.o
+sfc-siena-$(CONFIG_SFC_SIENA_MTD)	+= mtd.o
+sfc-siena-$(CONFIG_SFC_SRIOV)		+= siena_sriov.o
 
 obj-$(CONFIG_SFC_SIENA)	+= sfc-siena.o
diff --git a/drivers/net/ethernet/sfc/siena/efx.h b/drivers/net/ethernet/sfc/siena/efx.h
index f91f3c94a275..1d9755e59d75 100644
--- a/drivers/net/ethernet/sfc/siena/efx.h
+++ b/drivers/net/ethernet/sfc/siena/efx.h
@@ -162,7 +162,7 @@ void efx_siena_get_irq_moderation(struct efx_nic *efx, unsigned int *tx_usecs,
 void efx_siena_update_sw_stats(struct efx_nic *efx, u64 *stats);
 
 /* MTD */
-#ifdef CONFIG_SFC_MTD
+#ifdef CONFIG_SFC_SIENA_MTD
 int efx_siena_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
 		      size_t n_parts, size_t sizeof_part);
 static inline int efx_mtd_probe(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index b44a7114e319..7c400fd590f5 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -997,7 +997,7 @@ int efx_siena_init_struct(struct efx_nic *efx,
 	INIT_LIST_HEAD(&efx->node);
 	INIT_LIST_HEAD(&efx->secondary_list);
 	spin_lock_init(&efx->biu_lock);
-#ifdef CONFIG_SFC_MTD
+#ifdef CONFIG_SFC_SIENA_MTD
 	INIT_LIST_HEAD(&efx->mtd_list);
 #endif
 	INIT_WORK(&efx->reset_work, efx_reset_work);
diff --git a/drivers/net/ethernet/sfc/siena/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
index eb13aa59fe50..b767e29cfe92 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi.c
@@ -2014,7 +2014,7 @@ int efx_siena_mcdi_wol_filter_reset(struct efx_nic *efx)
 	return rc;
 }
 
-#ifdef CONFIG_SFC_MTD
+#ifdef CONFIG_SFC_SIENA_MTD
 
 #define EFX_MCDI_NVRAM_LEN_MAX 128
 
@@ -2256,4 +2256,4 @@ void efx_siena_mcdi_mtd_rename(struct efx_mtd_partition *part)
 		 efx->name, part->type_name, mcdi_part->fw_subtype);
 }
 
-#endif /* CONFIG_SFC_MTD */
+#endif /* CONFIG_SFC_SIENA_MTD */
diff --git a/drivers/net/ethernet/sfc/siena/mcdi.h b/drivers/net/ethernet/sfc/siena/mcdi.h
index dcebdbf956ce..64990f398e67 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.h
+++ b/drivers/net/ethernet/sfc/siena/mcdi.h
@@ -373,7 +373,7 @@ static inline int efx_siena_mcdi_mon_probe(struct efx_nic *efx) { return 0; }
 static inline void efx_siena_mcdi_mon_remove(struct efx_nic *efx) {}
 #endif
 
-#ifdef CONFIG_SFC_MTD
+#ifdef CONFIG_SFC_SIENA_MTD
 int efx_siena_mcdi_mtd_read(struct mtd_info *mtd, loff_t start, size_t len,
 			    size_t *retlen, u8 *buffer);
 int efx_siena_mcdi_mtd_erase(struct mtd_info *mtd, loff_t start, size_t len);
diff --git a/drivers/net/ethernet/sfc/siena/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
index 7e0659be4348..6af172fb0b10 100644
--- a/drivers/net/ethernet/sfc/siena/net_driver.h
+++ b/drivers/net/ethernet/sfc/siena/net_driver.h
@@ -1031,7 +1031,7 @@ struct efx_nic {
 	unsigned irq_level;
 	struct delayed_work selftest_work;
 
-#ifdef CONFIG_SFC_MTD
+#ifdef CONFIG_SFC_SIENA_MTD
 	struct list_head mtd_list;
 #endif
 
@@ -1411,7 +1411,7 @@ struct efx_nic_type {
 	bool (*filter_rfs_expire_one)(struct efx_nic *efx, u32 flow_id,
 				      unsigned int index);
 #endif
-#ifdef CONFIG_SFC_MTD
+#ifdef CONFIG_SFC_SIENA_MTD
 	int (*mtd_probe)(struct efx_nic *efx);
 	void (*mtd_rename)(struct efx_mtd_partition *part);
 	int (*mtd_read)(struct mtd_info *mtd, loff_t start, size_t len,
diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
index 741313aff1d1..9fe8ffc3a8d3 100644
--- a/drivers/net/ethernet/sfc/siena/siena.c
+++ b/drivers/net/ethernet/sfc/siena/siena.c
@@ -830,7 +830,7 @@ static int siena_mcdi_poll_reboot(struct efx_nic *efx)
  **************************************************************************
  */
 
-#ifdef CONFIG_SFC_MTD
+#ifdef CONFIG_SFC_SIENA_MTD
 
 struct siena_nvram_type_info {
 	int port;
@@ -954,7 +954,7 @@ static int siena_mtd_probe(struct efx_nic *efx)
 	return rc;
 }
 
-#endif /* CONFIG_SFC_MTD */
+#endif /* CONFIG_SFC_SIENA_MTD */
 
 static unsigned int siena_check_caps(const struct efx_nic *efx,
 				     u8 flag, u32 offset)
@@ -1058,7 +1058,7 @@ const struct efx_nic_type siena_a0_nic_type = {
 #ifdef CONFIG_RFS_ACCEL
 	.filter_rfs_expire_one = efx_farch_filter_rfs_expire_one,
 #endif
-#ifdef CONFIG_SFC_MTD
+#ifdef CONFIG_SFC_SIENA_MTD
 	.mtd_probe = siena_mtd_probe,
 	.mtd_rename = efx_siena_mcdi_mtd_rename,
 	.mtd_read = efx_siena_mcdi_mtd_read,

