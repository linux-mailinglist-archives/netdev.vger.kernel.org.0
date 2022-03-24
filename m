Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F6B4E6666
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351477AbiCXP44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351374AbiCXP4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751EDAC93C
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KPVBP4kLkzfZlj;
        Thu, 24 Mar 2022 23:53:33 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:08 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 05/20] net: sfc: replace const features initialization with netdev features array
Date:   Thu, 24 Mar 2022 23:49:17 +0800
Message-ID: <20220324154932.17557-6-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220324154932.17557-1-shenjian15@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some drivers(e.g. sfc) use netdev_features in global
structure initialization. Changed the its netdev_features_t memeber
to netdev_features_t *, and make it prefer to a netdev_features_t
global variables.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/sfc/ef10.c              | 11 +----
 drivers/net/ethernet/sfc/ef100_nic.c         | 15 ++----
 drivers/net/ethernet/sfc/efx.c               | 52 +++++++++++++++++++-
 drivers/net/ethernet/sfc/falcon/efx.c        | 29 ++++++++++-
 drivers/net/ethernet/sfc/falcon/efx.h        |  3 ++
 drivers/net/ethernet/sfc/falcon/falcon.c     |  4 +-
 drivers/net/ethernet/sfc/falcon/net_driver.h |  2 +-
 drivers/net/ethernet/sfc/net_driver.h        |  2 +-
 drivers/net/ethernet/sfc/rx_common.c         |  2 +-
 drivers/net/ethernet/sfc/rx_common.h         |  4 ++
 drivers/net/ethernet/sfc/siena.c             |  3 +-
 11 files changed, 97 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 3e1876292141..84aaa4259eb7 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -4023,13 +4023,6 @@ static unsigned int efx_ef10_recycle_ring_size(const struct efx_nic *efx)
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
@@ -4130,7 +4123,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.always_rx_scatter = true,
 	.min_interrupt_mode = EFX_INT_MODE_MSIX,
 	.timer_period_max = 1 << ERF_DD_EVQ_IND_TIMER_VAL_WIDTH,
-	.offload_features = EF10_OFFLOAD_FEATURES,
+	.offload_features = &ef10_offload_features,
 	.mcdi_max_ver = 2,
 	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
 	.hwtstamp_filters = 1 << HWTSTAMP_FILTER_NONE |
@@ -4268,7 +4261,7 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.option_descriptors = true,
 	.min_interrupt_mode = EFX_INT_MODE_LEGACY,
 	.timer_period_max = 1 << ERF_DD_EVQ_IND_TIMER_VAL_WIDTH,
-	.offload_features = EF10_OFFLOAD_FEATURES,
+	.offload_features = &ef10_offload_features,
 	.mcdi_max_ver = 2,
 	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
 	.hwtstamp_filters = 1 << HWTSTAMP_FILTER_NONE |
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 50a5f37151f2..42d1d426fb4f 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -717,16 +717,11 @@ static unsigned int efx_ef100_recycle_ring_size(const struct efx_nic *efx)
 
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
 	.probe = ef100_probe_pf,
-	.offload_features = EF100_OFFLOAD_FEATURES,
+	.offload_features = &ef100_offload_features,
 	.mcdi_max_ver = 2,
 	.mcdi_request = ef100_mcdi_request,
 	.mcdi_poll_response = ef100_mcdi_poll_response,
@@ -812,7 +807,7 @@ const struct efx_nic_type ef100_vf_nic_type = {
 	.revision = EFX_REV_EF100,
 	.is_vf = true,
 	.probe = ef100_probe_vf,
-	.offload_features = EF100_OFFLOAD_FEATURES,
+	.offload_features = &ef100_offload_features,
 	.mcdi_max_ver = 2,
 	.mcdi_request = ef100_mcdi_request,
 	.mcdi_poll_response = ef100_mcdi_poll_response,
@@ -1141,9 +1136,9 @@ static int ef100_probe_main(struct efx_nic *efx)
 		return -ENOMEM;
 	efx->nic_data = nic_data;
 	nic_data->efx = efx;
-	net_dev->active_features |= efx->type->offload_features;
-	net_dev->hw_features |= efx->type->offload_features;
-	net_dev->hw_enc_features |= efx->type->offload_features;
+	net_dev->active_features |= *efx->type->offload_features;
+	net_dev->hw_features |= *efx->type->offload_features;
+	net_dev->hw_enc_features |= *efx->type->offload_features;
 	net_dev->vlan_features |= NETIF_F_ALL_TSO;
 	netdev_vlan_features_set_array(net_dev, ef100_vlan_features_array,
 				       ARRAY_SIZE(ef100_vlan_features_array));
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 9f4b6e483e72..607347332bb8 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1018,10 +1018,10 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->active_features |= efx->type->offload_features;
+	net_dev->active_features |= *efx->type->offload_features;
 	netdev_active_features_set_array(net_dev, efx_active_features_array,
 					 ARRAY_SIZE(efx_active_features_array));
-	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	if (*efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
 		net_dev->active_features |= NETIF_F_TSO6;
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
@@ -1293,6 +1293,52 @@ static struct pci_driver efx_pci_driver = {
 #endif
 };
 
+static const int ef10_offload_features_array[] = {
+	NETIF_F_IP_CSUM_BIT,
+	NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+	NETIF_F_IPV6_CSUM_BIT,
+	NETIF_F_RXHASH_BIT,
+	NETIF_F_NTUPLE_BIT
+};
+
+static const int ef100_offload_features_array[] = {
+	NETIF_F_HW_CSUM_BIT,
+	NETIF_F_RXCSUM_BIT,
+	NETIF_F_HIGHDMA_BIT,
+	NETIF_F_SG_BIT,
+	NETIF_F_FRAGLIST_BIT,
+	NETIF_F_NTUPLE_BIT,
+	NETIF_F_RXHASH_BIT,
+	NETIF_F_RXFCS_BIT,
+	NETIF_F_TSO_ECN_BIT,
+	NETIF_F_RXALL_BIT,
+	NETIF_F_HW_VLAN_CTAG_TX_BIT
+};
+
+static const int siena_offload_features_array[] = {
+	NETIF_F_IP_CSUM_BIT,
+	NETIF_F_IPV6_CSUM_BIT,
+	NETIF_F_RXHASH_BIT,
+	NETIF_F_NTUPLE_BIT
+};
+
+netdev_features_t ef10_offload_features __ro_after_init;
+netdev_features_t ef100_offload_features __ro_after_init;
+netdev_features_t siena_offload_features __ro_after_init;
+
+static void efx_features_init(void)
+{
+	netdev_features_set_array(ef10_offload_features_array,
+				  ARRAY_SIZE(ef10_offload_features_array),
+				  &ef10_offload_features);
+	netdev_features_set_array(ef100_offload_features_array,
+				  ARRAY_SIZE(ef100_offload_features_array),
+				  &ef100_offload_features);
+	netdev_features_set_array(siena_offload_features_array,
+				  ARRAY_SIZE(siena_offload_features_array),
+				  &siena_offload_features);
+}
+
 /**************************************************************************
  *
  * Kernel module interface
@@ -1327,6 +1373,8 @@ static int __init efx_init_module(void)
 	if (rc < 0)
 		goto err_pci_ef100;
 
+	efx_features_init();
+
 	return 0;
 
  err_pci_ef100:
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 177ef78fb652..4631706f157f 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -1694,7 +1694,7 @@ static int ef4_probe_filters(struct ef4_nic *efx)
 		goto out_unlock;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (efx->type->offload_features & NETIF_F_NTUPLE) {
+	if (*efx->type->offload_features & NETIF_F_NTUPLE) {
 		struct ef4_channel *channel;
 		int i, success = 1;
 
@@ -2911,7 +2911,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto fail3;
 
-	net_dev->active_features |= (efx->type->offload_features | NETIF_F_SG |
+	net_dev->active_features |= (*efx->type->offload_features | NETIF_F_SG |
 			      NETIF_F_RXCSUM);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set_array(net_dev, efx_vlan_features_array,
@@ -3176,6 +3176,29 @@ static struct pci_driver ef4_pci_driver = {
 	.err_handler	= &ef4_err_handlers,
 };
 
+static const int falcon_b0_offload_features_array[] = {
+	NETIF_F_IP_CSUM_BIT,
+	NETIF_F_RXHASH_BIT,
+	NETIF_F_NTUPLE_BIT
+};
+
+static const int falcon_a1_offload_features_array[] = {
+	NETIF_F_IP_CSUM_BIT
+};
+
+netdev_features_t falcon_b0_offload_features __ro_after_init;
+netdev_features_t falcon_a1_offload_features __ro_after_init;
+
+static void ef4_features_init(void)
+{
+	netdev_features_set_array(falcon_b0_offload_features_array,
+				  ARRAY_SIZE(falcon_b0_offload_features_array),
+				  &falcon_b0_offload_features);
+	netdev_features_set_array(falcon_a1_offload_features_array,
+				  ARRAY_SIZE(falcon_a1_offload_features_array),
+				  &falcon_a1_offload_features);
+}
+
 /**************************************************************************
  *
  * Kernel module interface
@@ -3206,6 +3229,8 @@ static int __init ef4_init_module(void)
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
index 3324a6219a09..fda25f3f8e66 100644
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
index 48fca3bccd1b..88d73fd078b9 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -1153,7 +1153,7 @@ struct ef4_nic_type {
 	bool always_rx_scatter;
 	unsigned int max_interrupt_mode;
 	unsigned int timer_period_max;
-	netdev_features_t offload_features;
+	const netdev_features_t *offload_features;
 	unsigned int max_rx_ip_filters;
 };
 
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 5aa4437a5768..1b6c4f29337b 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1479,7 +1479,7 @@ struct efx_nic_type {
 	bool option_descriptors;
 	unsigned int min_interrupt_mode;
 	unsigned int timer_period_max;
-	netdev_features_t offload_features;
+	const netdev_features_t *offload_features;
 	int mcdi_max_ver;
 	unsigned int max_rx_ip_filters;
 	u32 hwtstamp_filters;
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index c93e47f2d5bf..1c550b6178e2 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -796,7 +796,7 @@ int efx_probe_filters(struct efx_nic *efx)
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
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index ce3060e15b54..74e3db5ccb53 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -1095,8 +1095,7 @@ const struct efx_nic_type siena_a0_nic_type = {
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

