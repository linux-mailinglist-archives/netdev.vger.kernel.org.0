Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02E85BBD19
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiIRJuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiIRJt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:56 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6369C12612
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:49 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjbr1DtfzlVlL;
        Sun, 18 Sep 2022 17:45:44 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:47 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 04/55] net: sfc: replace const features initialization with DECLARE_NETDEV_FEATURE_SET
Date:   Sun, 18 Sep 2022 09:42:45 +0000
Message-ID: <20220918094336.28958-5-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sfc driver uses netdev features in global structure
initialization. Changed the netdev_features_t memeber to
netdev_features_t *, and make it refer to a global constant
netdev_features_t variable.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/sfc/ef10.c              | 11 ++-----
 drivers/net/ethernet/sfc/ef100_netdev.c      |  6 ++--
 drivers/net/ethernet/sfc/ef100_nic.c         |  9 ++----
 drivers/net/ethernet/sfc/efx.c               | 31 ++++++++++++++++++--
 drivers/net/ethernet/sfc/falcon/efx.c        | 19 ++++++++++--
 drivers/net/ethernet/sfc/falcon/efx.h        |  3 ++
 drivers/net/ethernet/sfc/falcon/falcon.c     |  4 +--
 drivers/net/ethernet/sfc/falcon/net_driver.h |  2 +-
 drivers/net/ethernet/sfc/net_driver.h        |  2 +-
 drivers/net/ethernet/sfc/rx_common.c         |  2 +-
 drivers/net/ethernet/sfc/rx_common.h         |  4 +++
 drivers/net/ethernet/sfc/siena/efx.c         | 17 +++++++++--
 drivers/net/ethernet/sfc/siena/efx.h         |  2 ++
 drivers/net/ethernet/sfc/siena/net_driver.h  |  2 +-
 drivers/net/ethernet/sfc/siena/rx_common.c   |  2 +-
 drivers/net/ethernet/sfc/siena/siena.c       |  3 +-
 16 files changed, 85 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 74f3af39f132..fdc5f6450072 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -4030,13 +4030,6 @@ static unsigned int efx_ef10_recycle_ring_size(const struct efx_nic *efx)
 	return ret;
 }
 
-#define EF10_OFFLOAD_FEATURES		\
-	(NETIF_F_IP_CSUM |		\
-	 NETIF_F_HW_VLAN_CTAG_FILTER |	\
-	 NETIF_F_IPV6_CSUM |		\
-	 NETIF_F_RXHASH |		\
-	 NETIF_F_NTUPLE)
-
 const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.is_vf = true,
 	.mem_bar = efx_ef10_vf_mem_bar,
@@ -4137,7 +4130,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.always_rx_scatter = true,
 	.min_interrupt_mode = EFX_INT_MODE_MSIX,
 	.timer_period_max = 1 << ERF_DD_EVQ_IND_TIMER_VAL_WIDTH,
-	.offload_features = EF10_OFFLOAD_FEATURES,
+	.offload_features = &ef10_offload_features,
 	.mcdi_max_ver = 2,
 	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
 	.hwtstamp_filters = 1 << HWTSTAMP_FILTER_NONE |
@@ -4275,7 +4268,7 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.option_descriptors = true,
 	.min_interrupt_mode = EFX_INT_MODE_LEGACY,
 	.timer_period_max = 1 << ERF_DD_EVQ_IND_TIMER_VAL_WIDTH,
-	.offload_features = EF10_OFFLOAD_FEATURES,
+	.offload_features = &ef10_offload_features,
 	.mcdi_max_ver = 2,
 	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
 	.hwtstamp_filters = 1 << HWTSTAMP_FILTER_NONE |
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 7568230083e8..787e69216303 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -367,9 +367,9 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	efx->net_dev = net_dev;
 	SET_NETDEV_DEV(net_dev, &efx->pci_dev->dev);
 
-	net_dev->features |= efx->type->offload_features;
-	net_dev->hw_features |= efx->type->offload_features;
-	net_dev->hw_enc_features |= efx->type->offload_features;
+	net_dev->features |= *efx->type->offload_features;
+	net_dev->hw_features |= *efx->type->offload_features;
+	net_dev->hw_enc_features |= *efx->type->offload_features;
 	net_dev->vlan_features |= NETIF_F_ALL_TSO;
 	netdev_vlan_features_set_set(net_dev, NETIF_F_HW_CSUM_BIT,
 				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT);
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 2c8ecb2fdf98..346de672cb34 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1169,16 +1169,11 @@ void ef100_remove(struct efx_nic *efx)
 
 /*	NIC level access functions
  */
-#define EF100_OFFLOAD_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_RXCSUM |	\
-	NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_NTUPLE | \
-	NETIF_F_RXHASH | NETIF_F_RXFCS | NETIF_F_TSO_ECN | NETIF_F_RXALL | \
-	NETIF_F_HW_VLAN_CTAG_TX)
-
 const struct efx_nic_type ef100_pf_nic_type = {
 	.revision = EFX_REV_EF100,
 	.is_vf = false,
 	.probe = ef100_probe_main,
-	.offload_features = EF100_OFFLOAD_FEATURES,
+	.offload_features = &ef100_offload_features,
 	.mcdi_max_ver = 2,
 	.mcdi_request = ef100_mcdi_request,
 	.mcdi_poll_response = ef100_mcdi_poll_response,
@@ -1267,7 +1262,7 @@ const struct efx_nic_type ef100_vf_nic_type = {
 	.revision = EFX_REV_EF100,
 	.is_vf = true,
 	.probe = ef100_probe_vf,
-	.offload_features = EF100_OFFLOAD_FEATURES,
+	.offload_features = &ef100_offload_features,
 	.mcdi_max_ver = 2,
 	.mcdi_request = ef100_mcdi_request,
 	.mcdi_poll_response = ef100_mcdi_poll_response,
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index b16c6aeb9c38..a750d9588bf7 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1001,10 +1001,10 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= efx->type->offload_features;
+	net_dev->features |= *efx->type->offload_features;
 	netdev_active_features_set_set(net_dev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
 				       NETIF_F_RXCSUM_BIT, NETIF_F_RXALL_BIT);
-	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	if (*efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
 		net_dev->features |= NETIF_F_TSO6;
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
@@ -1299,6 +1299,31 @@ static struct pci_driver efx_pci_driver = {
 #endif
 };
 
+netdev_features_t ef10_offload_features __ro_after_init;
+netdev_features_t ef100_offload_features __ro_after_init;
+
+static void __init efx_features_init(void)
+{
+	netdev_features_set_set(ef10_offload_features,
+				NETIF_F_IP_CSUM_BIT,
+				NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_RXHASH_BIT,
+				NETIF_F_NTUPLE_BIT);
+	netdev_features_set_set(ef100_offload_features,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_RXCSUM_BIT,
+				NETIF_F_HIGHDMA_BIT,
+				NETIF_F_SG_BIT,
+				NETIF_F_FRAGLIST_BIT,
+				NETIF_F_NTUPLE_BIT,
+				NETIF_F_RXHASH_BIT,
+				NETIF_F_RXFCS_BIT,
+				NETIF_F_TSO_ECN_BIT,
+				NETIF_F_RXALL_BIT,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT);
+}
+
 /**************************************************************************
  *
  * Kernel module interface
@@ -1327,6 +1352,8 @@ static int __init efx_init_module(void)
 	if (rc < 0)
 		goto err_pci_ef100;
 
+	efx_features_init();
+
 	return 0;
 
  err_pci_ef100:
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 0a07a52fe180..60a552d78a83 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -1689,7 +1689,7 @@ static int ef4_probe_filters(struct ef4_nic *efx)
 		goto out_unlock;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (efx->type->offload_features & NETIF_F_NTUPLE) {
+	if (*efx->type->offload_features & NETIF_F_NTUPLE) {
 		struct ef4_channel *channel;
 		int i, success = 1;
 
@@ -2898,7 +2898,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto fail3;
 
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
+	net_dev->features |= (*efx->type->offload_features | NETIF_F_SG |
 			      NETIF_F_RXCSUM);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set_set(net_dev, NETIF_F_HW_CSUM_BIT,
@@ -3164,6 +3164,19 @@ static struct pci_driver ef4_pci_driver = {
 	.err_handler	= &ef4_err_handlers,
 };
 
+netdev_features_t falcon_b0_offload_features __ro_after_init;
+netdev_features_t falcon_a1_offload_features __ro_after_init;
+
+static void __init ef4_features_init(void)
+{
+	netdev_features_set_set(falcon_b0_offload_features,
+				NETIF_F_IP_CSUM_BIT,
+				NETIF_F_RXHASH_BIT,
+				NETIF_F_NTUPLE_BIT);
+	netdev_features_set_set(falcon_a1_offload_features,
+				NETIF_F_IP_CSUM_BIT);
+}
+
 /**************************************************************************
  *
  * Kernel module interface
@@ -3194,6 +3207,8 @@ static int __init ef4_init_module(void)
 	if (rc < 0)
 		goto err_pci;
 
+	ef4_features_init();
+
 	return 0;
 
  err_pci:
diff --git a/drivers/net/ethernet/sfc/falcon/efx.h b/drivers/net/ethernet/sfc/falcon/efx.h
index d3b4646545fa..f31b5c6e02bc 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.h
+++ b/drivers/net/ethernet/sfc/falcon/efx.h
@@ -271,4 +271,7 @@ static inline bool ef4_rwsem_assert_write_locked(struct rw_semaphore *sem)
 	return true;
 }
 
+extern netdev_features_t falcon_b0_offload_features __ro_after_init;
+extern netdev_features_t falcon_a1_offload_features __ro_after_init;
+
 #endif /* EF4_EFX_H */
diff --git a/drivers/net/ethernet/sfc/falcon/falcon.c b/drivers/net/ethernet/sfc/falcon/falcon.c
index 7a1c9337081b..046bc4522f96 100644
--- a/drivers/net/ethernet/sfc/falcon/falcon.c
+++ b/drivers/net/ethernet/sfc/falcon/falcon.c
@@ -2799,7 +2799,7 @@ const struct ef4_nic_type falcon_a1_nic_type = {
 	.can_rx_scatter = false,
 	.max_interrupt_mode = EF4_INT_MODE_MSI,
 	.timer_period_max =  1 << FRF_AB_TC_TIMER_VAL_WIDTH,
-	.offload_features = NETIF_F_IP_CSUM,
+	.offload_features = &falcon_a1_offload_features,
 };
 
 const struct ef4_nic_type falcon_b0_nic_type = {
@@ -2898,6 +2898,6 @@ const struct ef4_nic_type falcon_b0_nic_type = {
 	.can_rx_scatter = true,
 	.max_interrupt_mode = EF4_INT_MODE_MSIX,
 	.timer_period_max =  1 << FRF_AB_TC_TIMER_VAL_WIDTH,
-	.offload_features = NETIF_F_IP_CSUM | NETIF_F_RXHASH | NETIF_F_NTUPLE,
+	.offload_features = &falcon_b0_offload_features,
 	.max_rx_ip_filters = FR_BZ_RX_FILTER_TBL0_ROWS,
 };
diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index e876ac952cbc..3c51561e200e 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -1154,7 +1154,7 @@ struct ef4_nic_type {
 	bool always_rx_scatter;
 	unsigned int max_interrupt_mode;
 	unsigned int timer_period_max;
-	netdev_features_t offload_features;
+	const netdev_features_t *offload_features;
 	unsigned int max_rx_ip_filters;
 };
 
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 0f49fe683008..293af2027995 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1546,7 +1546,7 @@ struct efx_nic_type {
 	bool option_descriptors;
 	unsigned int min_interrupt_mode;
 	unsigned int timer_period_max;
-	netdev_features_t offload_features;
+	const netdev_features_t *offload_features;
 	int mcdi_max_ver;
 	unsigned int max_rx_ip_filters;
 	u32 hwtstamp_filters;
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 4826e6a7e4ce..ab83fd836031 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -798,7 +798,7 @@ int efx_probe_filters(struct efx_nic *efx)
 		goto out_unlock;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (efx->type->offload_features & NETIF_F_NTUPLE) {
+	if (*efx->type->offload_features & NETIF_F_NTUPLE) {
 		struct efx_channel *channel;
 		int i, success = 1;
 
diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/sfc/rx_common.h
index fbd2769307f9..09b38b0cb401 100644
--- a/drivers/net/ethernet/sfc/rx_common.h
+++ b/drivers/net/ethernet/sfc/rx_common.h
@@ -113,4 +113,8 @@ bool __efx_filter_rfs_expire(struct efx_channel *channel, unsigned int quota);
 int efx_probe_filters(struct efx_nic *efx);
 void efx_remove_filters(struct efx_nic *efx);
 
+extern netdev_features_t ef10_offload_features __ro_after_init;
+extern netdev_features_t ef100_offload_features __ro_after_init;
+extern netdev_features_t siena_offload_features __ro_after_init;
+
 #endif
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index ef3c5d16c4f5..b83e60f8ebbb 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -984,10 +984,10 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= efx->type->offload_features;
+	net_dev->features |= *efx->type->offload_features;
 	netdev_active_features_set_set(net_dev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
 				       NETIF_F_RXCSUM_BIT, NETIF_F_RXALL_BIT);
-	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	if (*efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
 		net_dev->features |= NETIF_F_TSO6;
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
@@ -1273,6 +1273,17 @@ static struct pci_driver efx_pci_driver = {
 #endif
 };
 
+netdev_features_t siena_offload_features __ro_after_init;
+
+static void __init efx_features_init(void)
+{
+	netdev_features_set_set(siena_offload_features,
+				NETIF_F_IP_CSUM_BIT,
+				NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_RXHASH_BIT,
+				  NETIF_F_NTUPLE_BIT);
+}
+
 /**************************************************************************
  *
  * Kernel module interface
@@ -1303,6 +1314,8 @@ static int __init efx_init_module(void)
 	if (rc < 0)
 		goto err_pci;
 
+	efx_features_init();
+
 	return 0;
 
  err_pci:
diff --git a/drivers/net/ethernet/sfc/siena/efx.h b/drivers/net/ethernet/sfc/siena/efx.h
index 27d1d3f19cae..6f1768a75ee8 100644
--- a/drivers/net/ethernet/sfc/siena/efx.h
+++ b/drivers/net/ethernet/sfc/siena/efx.h
@@ -12,6 +12,8 @@
 #include "net_driver.h"
 #include "filter.h"
 
+extern netdev_features_t siena_offload_features __ro_after_init;
+
 /* TX */
 void efx_siena_init_tx_queue_core_txq(struct efx_tx_queue *tx_queue);
 netdev_tx_t efx_siena_hard_start_xmit(struct sk_buff *skb,
diff --git a/drivers/net/ethernet/sfc/siena/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
index ff7bbc325952..331af932e56d 100644
--- a/drivers/net/ethernet/sfc/siena/net_driver.h
+++ b/drivers/net/ethernet/sfc/siena/net_driver.h
@@ -1473,7 +1473,7 @@ struct efx_nic_type {
 	bool option_descriptors;
 	unsigned int min_interrupt_mode;
 	unsigned int timer_period_max;
-	netdev_features_t offload_features;
+	netdev_features_t *offload_features;
 	int mcdi_max_ver;
 	unsigned int max_rx_ip_filters;
 	u32 hwtstamp_filters;
diff --git a/drivers/net/ethernet/sfc/siena/rx_common.c b/drivers/net/ethernet/sfc/siena/rx_common.c
index 4579f43484c3..be17b8676fff 100644
--- a/drivers/net/ethernet/sfc/siena/rx_common.c
+++ b/drivers/net/ethernet/sfc/siena/rx_common.c
@@ -805,7 +805,7 @@ int efx_siena_probe_filters(struct efx_nic *efx)
 		goto out_unlock;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (efx->type->offload_features & NETIF_F_NTUPLE) {
+	if (*efx->type->offload_features & NETIF_F_NTUPLE) {
 		struct efx_channel *channel;
 		int i, success = 1;
 
diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
index a44c8fa25748..a92cf1bef772 100644
--- a/drivers/net/ethernet/sfc/siena/siena.c
+++ b/drivers/net/ethernet/sfc/siena/siena.c
@@ -1099,8 +1099,7 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.option_descriptors = false,
 	.min_interrupt_mode = EFX_INT_MODE_LEGACY,
 	.timer_period_max = 1 << FRF_CZ_TC_TIMER_VAL_WIDTH,
-	.offload_features = (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			     NETIF_F_RXHASH | NETIF_F_NTUPLE),
+	.offload_features = &siena_offload_features,
 	.mcdi_max_ver = 1,
 	.max_rx_ip_filters = FR_BZ_RX_FILTER_TBL0_ROWS,
 	.hwtstamp_filters = (1 << HWTSTAMP_FILTER_NONE |
-- 
2.33.0

