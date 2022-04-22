Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1804C50BB24
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449148AbiDVPFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449169AbiDVPF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:05:28 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E4465D652
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:02:09 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 79828320133;
        Fri, 22 Apr 2022 16:02:08 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhunQ-0007F5-8l; Fri, 22 Apr 2022 16:02:08 +0100
Subject: [PATCH net-next 24/28] siena: Make SRIOV support specific for Siena
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 16:02:08 +0100
Message-ID: <165063972811.27138.9893350407091706083.stgit@palantir17.mph.net>
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
 drivers/net/ethernet/sfc/Kconfig              |    2 +-
 drivers/net/ethernet/sfc/siena/Kconfig        |    8 ++++++++
 drivers/net/ethernet/sfc/siena/Makefile       |    2 +-
 drivers/net/ethernet/sfc/siena/efx.c          |   12 ++++++------
 drivers/net/ethernet/sfc/siena/efx.h          |    2 +-
 drivers/net/ethernet/sfc/siena/efx_channels.c |    4 ++--
 drivers/net/ethernet/sfc/siena/efx_common.c   |    2 +-
 drivers/net/ethernet/sfc/siena/farch.c        |   18 +++++++++---------
 drivers/net/ethernet/sfc/siena/net_driver.h   |    2 +-
 drivers/net/ethernet/sfc/siena/nic.h          |    2 +-
 drivers/net/ethernet/sfc/siena/siena.c        |    4 ++--
 drivers/net/ethernet/sfc/siena/siena_sriov.h  |    6 +++---
 drivers/net/ethernet/sfc/siena/sriov.h        |    4 ++--
 13 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index 79b8ccaeee01..4c85b26279c5 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -47,7 +47,7 @@ config SFC_MCDI_MON
 	  This exposes the on-board firmware-managed sensors as a
 	  hardware monitor device.
 config SFC_SRIOV
-	bool "Solarflare SFC9000/SFC9100-family SR-IOV support"
+	bool "Solarflare SFC9100-family SR-IOV support"
 	depends on SFC && PCI_IOV
 	default y
 	help
diff --git a/drivers/net/ethernet/sfc/siena/Kconfig b/drivers/net/ethernet/sfc/siena/Kconfig
index 805b902f903d..26a8cb838d47 100644
--- a/drivers/net/ethernet/sfc/siena/Kconfig
+++ b/drivers/net/ethernet/sfc/siena/Kconfig
@@ -18,3 +18,11 @@ config SFC_SIENA_MTD
 	  This exposes the on-board flash and/or EEPROM as MTD devices
 	  (e.g. /dev/mtd1).  This is required to update the firmware or
 	  the boot configuration under Linux.
+config SFC_SIENA_SRIOV
+	bool "Solarflare SFC9000-family SR-IOV support"
+	depends on SFC_SIENA && PCI_IOV
+	default n
+	help
+	  This enables support for the Single Root I/O Virtualization
+	  features, allowing accelerated network performance in
+	  virtualized environments.
diff --git a/drivers/net/ethernet/sfc/siena/Makefile b/drivers/net/ethernet/sfc/siena/Makefile
index 3729095a51d9..f7384299667c 100644
--- a/drivers/net/ethernet/sfc/siena/Makefile
+++ b/drivers/net/ethernet/sfc/siena/Makefile
@@ -6,6 +6,6 @@ sfc-siena-y		+= farch.o siena.o \
 			   mcdi.o mcdi_port.o mcdi_port_common.o \
 			   mcdi_mon.o
 sfc-siena-$(CONFIG_SFC_SIENA_MTD)	+= mtd.o
-sfc-siena-$(CONFIG_SFC_SRIOV)		+= siena_sriov.o
+sfc-siena-$(CONFIG_SFC_SIENA_SRIOV)	+= siena_sriov.o
 
 obj-$(CONFIG_SFC_SIENA)	+= sfc-siena.o
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 18ba1d6ff16a..718b07b1ed28 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -359,7 +359,7 @@ static int efx_probe_all(struct efx_nic *efx)
 		goto fail3;
 	}
 
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	rc = efx->type->vswitching_probe(efx);
 	if (rc) /* not fatal; the PF will still work fine */
 		netif_warn(efx, probe, efx->net_dev,
@@ -383,7 +383,7 @@ static int efx_probe_all(struct efx_nic *efx)
  fail5:
 	efx_siena_remove_filters(efx);
  fail4:
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	efx->type->vswitching_remove(efx);
 #endif
  fail3:
@@ -402,7 +402,7 @@ static void efx_remove_all(struct efx_nic *efx)
 
 	efx_siena_remove_channels(efx);
 	efx_siena_remove_filters(efx);
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	efx->type->vswitching_remove(efx);
 #endif
 	efx_remove_port(efx);
@@ -592,7 +592,7 @@ static const struct net_device_ops efx_netdev_ops = {
 	.ndo_features_check	= efx_siena_features_check,
 	.ndo_vlan_rx_add_vid	= efx_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= efx_vlan_rx_kill_vid,
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	.ndo_set_vf_mac		= efx_sriov_set_vf_mac,
 	.ndo_set_vf_vlan	= efx_sriov_set_vf_vlan,
 	.ndo_set_vf_spoofchk	= efx_sriov_set_vf_spoofchk,
@@ -1108,7 +1108,7 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 /* efx_pci_sriov_configure returns the actual number of Virtual Functions
  * enabled on success
  */
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 static int efx_pci_sriov_configure(struct pci_dev *dev, int num_vfs)
 {
 	int rc;
@@ -1250,7 +1250,7 @@ static struct pci_driver efx_pci_driver = {
 	.remove		= efx_pci_remove,
 	.driver.pm	= &efx_pm_ops,
 	.err_handler	= &efx_siena_err_handlers,
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	.sriov_configure = efx_pci_sriov_configure,
 #endif
 };
diff --git a/drivers/net/ethernet/sfc/siena/efx.h b/drivers/net/ethernet/sfc/siena/efx.h
index 1d9755e59d75..27d1d3f19cae 100644
--- a/drivers/net/ethernet/sfc/siena/efx.h
+++ b/drivers/net/ethernet/sfc/siena/efx.h
@@ -177,7 +177,7 @@ static inline void efx_siena_mtd_rename(struct efx_nic *efx) {}
 static inline void efx_siena_mtd_remove(struct efx_nic *efx) {}
 #endif
 
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 static inline unsigned int efx_vf_size(struct efx_nic *efx)
 {
 	return 1 << efx->vi_scale;
diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index 36ad1cf9f550..d973c299f436 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -110,7 +110,7 @@ static unsigned int efx_wanted_parallelism(struct efx_nic *efx)
 	/* If RSS is requested for the PF *and* VFs then we can't write RSS
 	 * table entries that are inaccessible to VFs
 	 */
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	if (efx->type->sriov_wanted) {
 		if (efx->type->sriov_wanted(efx) && efx_vf_size(efx) > 1 &&
 		    count > efx_vf_size(efx)) {
@@ -348,7 +348,7 @@ int efx_siena_probe_interrupts(struct efx_nic *efx)
 
 	rss_spread = efx->n_rx_channels;
 	/* RSS might be usable on VFs even if it is disabled on the PF */
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	if (efx->type->sriov_wanted) {
 		efx->rss_spread = ((rss_spread > 1 ||
 				    !efx->type->sriov_wanted(efx)) ?
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 7c400fd590f5..3aef8d216f95 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -778,7 +778,7 @@ int efx_siena_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
 	if (rc)
 		goto fail;
 
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	rc = efx->type->vswitching_restore(efx);
 	if (rc) /* not fatal; the PF will still work fine */
 		netif_warn(efx, probe, efx->net_dev,
diff --git a/drivers/net/ethernet/sfc/siena/farch.c b/drivers/net/ethernet/sfc/siena/farch.c
index a24ba23fd19f..cce23803c652 100644
--- a/drivers/net/ethernet/sfc/siena/farch.c
+++ b/drivers/net/ethernet/sfc/siena/farch.c
@@ -228,7 +228,7 @@ static int efx_alloc_special_buffer(struct efx_nic *efx,
 				    struct efx_special_buffer *buffer,
 				    unsigned int len)
 {
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	struct siena_nic_data *nic_data = efx->nic_data;
 #endif
 	len = ALIGN(len, EFX_BUF_SIZE);
@@ -241,7 +241,7 @@ static int efx_alloc_special_buffer(struct efx_nic *efx,
 	/* Select new buffer ID */
 	buffer->index = efx->next_buffer_table;
 	efx->next_buffer_table += buffer->entries;
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	BUG_ON(efx_siena_sriov_enabled(efx) &&
 	       nic_data->vf_buftbl_base < efx->next_buffer_table);
 #endif
@@ -1187,7 +1187,7 @@ efx_farch_handle_driver_event(struct efx_channel *channel, efx_qword_t *event)
 		netif_vdbg(efx, hw, efx->net_dev, "channel %d TXQ %d flushed\n",
 			   channel->channel, ev_sub_data);
 		efx_farch_handle_tx_flush_done(efx, event);
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 		efx_siena_sriov_tx_flush_done(efx, event);
 #endif
 		break;
@@ -1195,7 +1195,7 @@ efx_farch_handle_driver_event(struct efx_channel *channel, efx_qword_t *event)
 		netif_vdbg(efx, hw, efx->net_dev, "channel %d RXQ %d flushed\n",
 			   channel->channel, ev_sub_data);
 		efx_farch_handle_rx_flush_done(efx, event);
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 		efx_siena_sriov_rx_flush_done(efx, event);
 #endif
 		break;
@@ -1233,7 +1233,7 @@ efx_farch_handle_driver_event(struct efx_channel *channel, efx_qword_t *event)
 				  ev_sub_data);
 			efx_siena_schedule_reset(efx, RESET_TYPE_DMA_ERROR);
 		}
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 		else
 			efx_siena_sriov_desc_fetch_err(efx, ev_sub_data);
 #endif
@@ -1246,7 +1246,7 @@ efx_farch_handle_driver_event(struct efx_channel *channel, efx_qword_t *event)
 				  ev_sub_data);
 			efx_siena_schedule_reset(efx, RESET_TYPE_DMA_ERROR);
 		}
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 		else
 			efx_siena_sriov_desc_fetch_err(efx, ev_sub_data);
 #endif
@@ -1307,7 +1307,7 @@ int efx_farch_ev_process(struct efx_channel *channel, int budget)
 		case FSE_AZ_EV_CODE_DRIVER_EV:
 			efx_farch_handle_driver_event(channel, &event);
 			break;
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 		case FSE_CZ_EV_CODE_USER_EV:
 			efx_siena_sriov_event(channel, &event);
 			break;
@@ -1671,7 +1671,7 @@ void efx_farch_rx_pull_indir_table(struct efx_nic *efx)
 void efx_farch_dimension_resources(struct efx_nic *efx, unsigned sram_lim_qw)
 {
 	unsigned vi_count, total_tx_channels;
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	struct siena_nic_data *nic_data;
 	unsigned buftbl_min;
 #endif
@@ -1679,7 +1679,7 @@ void efx_farch_dimension_resources(struct efx_nic *efx, unsigned sram_lim_qw)
 	total_tx_channels = efx->n_tx_channels + efx->n_extra_tx_channels;
 	vi_count = max(efx->n_channels, total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL);
 
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	nic_data = efx->nic_data;
 	/* Account for the buffer table entries backing the datapath channels
 	 * and the descriptor caches for those channels.
diff --git a/drivers/net/ethernet/sfc/siena/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
index 6af172fb0b10..a8f6c3699c8b 100644
--- a/drivers/net/ethernet/sfc/siena/net_driver.h
+++ b/drivers/net/ethernet/sfc/siena/net_driver.h
@@ -1096,7 +1096,7 @@ struct efx_nic {
 	atomic_t rxq_flush_outstanding;
 	wait_queue_head_t flush_wq;
 
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	unsigned vf_count;
 	unsigned vf_init_count;
 	unsigned vi_scale;
diff --git a/drivers/net/ethernet/sfc/siena/nic.h b/drivers/net/ethernet/sfc/siena/nic.h
index 935cb0ab5ec0..6def31070edb 100644
--- a/drivers/net/ethernet/sfc/siena/nic.h
+++ b/drivers/net/ethernet/sfc/siena/nic.h
@@ -104,7 +104,7 @@ struct siena_nic_data {
 	struct efx_nic *efx;
 	int wol_filter_id;
 	u64 stats[SIENA_STAT_COUNT];
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	struct siena_vf *vf;
 	struct efx_channel *vfdi_channel;
 	unsigned vf_buftbl_base;
diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
index 9fe8ffc3a8d3..a44c8fa25748 100644
--- a/drivers/net/ethernet/sfc/siena/siena.c
+++ b/drivers/net/ethernet/sfc/siena/siena.c
@@ -328,7 +328,7 @@ static int siena_probe_nic(struct efx_nic *efx)
 	if (rc)
 		goto fail5;
 
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	efx_siena_sriov_probe(efx);
 #endif
 	efx_siena_ptp_defer_probe_with_channel(efx);
@@ -1068,7 +1068,7 @@ const struct efx_nic_type siena_a0_nic_type = {
 #endif
 	.ptp_write_host_time = siena_ptp_write_host_time,
 	.ptp_set_ts_config = siena_ptp_set_ts_config,
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 	.sriov_configure = efx_siena_sriov_configure,
 	.sriov_init = efx_siena_sriov_init,
 	.sriov_fini = efx_siena_sriov_fini,
diff --git a/drivers/net/ethernet/sfc/siena/siena_sriov.h b/drivers/net/ethernet/sfc/siena/siena_sriov.h
index e548c4daf189..69a7a18e9ba0 100644
--- a/drivers/net/ethernet/sfc/siena/siena_sriov.h
+++ b/drivers/net/ethernet/sfc/siena/siena_sriov.h
@@ -54,18 +54,18 @@ int efx_siena_sriov_set_vf_spoofchk(struct efx_nic *efx, int vf,
 int efx_siena_sriov_get_vf_config(struct efx_nic *efx, int vf,
 				  struct ifla_vf_info *ivf);
 
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 
 static inline bool efx_siena_sriov_enabled(struct efx_nic *efx)
 {
 	return efx->vf_init_count != 0;
 }
-#else /* !CONFIG_SFC_SRIOV */
+#else /* !CONFIG_SFC_SIENA_SRIOV */
 static inline bool efx_siena_sriov_enabled(struct efx_nic *efx)
 {
 	return false;
 }
-#endif /* CONFIG_SFC_SRIOV */
+#endif /* CONFIG_SFC_SIENA_SRIOV */
 
 void efx_siena_sriov_probe(struct efx_nic *efx);
 void efx_siena_sriov_tx_flush_done(struct efx_nic *efx, efx_qword_t *event);
diff --git a/drivers/net/ethernet/sfc/siena/sriov.h b/drivers/net/ethernet/sfc/siena/sriov.h
index fbde67319d87..a6981bad7621 100644
--- a/drivers/net/ethernet/sfc/siena/sriov.h
+++ b/drivers/net/ethernet/sfc/siena/sriov.h
@@ -9,7 +9,7 @@
 
 #include "net_driver.h"
 
-#ifdef CONFIG_SFC_SRIOV
+#ifdef CONFIG_SFC_SIENA_SRIOV
 
 static inline
 int efx_sriov_set_vf_mac(struct net_device *net_dev, int vf_i, u8 *mac)
@@ -78,6 +78,6 @@ int efx_sriov_set_vf_link_state(struct net_device *net_dev, int vf_i,
 	else
 		return -EOPNOTSUPP;
 }
-#endif /* CONFIG_SFC_SRIOV */
+#endif /* CONFIG_SFC_SIENA_SRIOV */
 
 #endif /* EFX_SRIOV_H */

