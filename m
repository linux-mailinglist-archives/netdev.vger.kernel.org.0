Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8565D1E23AD
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgEZOGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:06:43 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:32308 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgEZOGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:06:43 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04QE6aO2006798;
        Tue, 26 May 2020 07:06:36 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net v2] cxgb4/chcr: Enable ktls settings at run time
Date:   Tue, 26 May 2020 19:36:34 +0530
Message-Id: <20200526140634.21043-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current design enables ktls setting from start, which is not
efficient. Now the feature will be enabled when user demands
TLS offload on any interface.

v1->v2:
- taking ULD module refcount till any single connection exists.
- taking rtnl_lock() before clearing tls_devops.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chcr_core.c            |  1 +
 drivers/crypto/chelsio/chcr_ktls.c            | 20 +++++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  4 ++
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  2 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 19 ++++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.c    | 72 ++++++++++++++-----
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |  5 ++
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h | 10 ++-
 8 files changed, 110 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index ffd4ec0c7374..49edc1f46504 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -46,6 +46,7 @@ static chcr_handler_func work_handlers[NUM_CPL_CMDS] = {
 };
 
 static struct cxgb4_uld_info chcr_uld_info = {
+	.owner = THIS_MODULE,
 	.name = DRV_MODULE_NAME,
 	.nrxq = MAX_ULD_QSETS,
 	/* Max ntxq will be derived from fw config file*/
diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index 43d9e2420110..1c0f4bbb498e 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -409,6 +409,10 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 	}
 
 	atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_connection_close);
+	/* check if ktls settings are no more required. */
+	cxgb4_set_ktls_feature(tx_info->adap,
+			       FW_PARAMS_PARAM_DEV_KTLS_HW_DISABLE);
+
 	kvfree(tx_info);
 	tx_ctx->chcr_info = NULL;
 }
@@ -529,6 +533,9 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 		goto out2;
 
 	atomic64_inc(&adap->chcr_stats.ktls_tx_connection_open);
+
+	cxgb4_set_ktls_feature(tx_info->adap,
+			       FW_PARAMS_PARAM_DEV_KTLS_HW_ENABLE);
 	return 0;
 out2:
 	kvfree(tx_info);
@@ -550,11 +557,17 @@ void chcr_enable_ktls(struct adapter *adap)
 	struct net_device *netdev;
 	int i;
 
+	/* clear refcount */
+	refcount_set(&adap->chcr_ktls.ktls_refcount, 0);
+
 	for_each_port(adap, i) {
 		netdev = adap->port[i];
-		netdev->features |= NETIF_F_HW_TLS_TX;
+		rtnl_lock();
 		netdev->hw_features |= NETIF_F_HW_TLS_TX;
 		netdev->tlsdev_ops = &chcr_ktls_ops;
+
+		netdev_update_features(netdev);
+		rtnl_unlock();
 	}
 }
 
@@ -568,9 +581,12 @@ void chcr_disable_ktls(struct adapter *adap)
 
 	for_each_port(adap, i) {
 		netdev = adap->port[i];
-		netdev->features &= ~NETIF_F_HW_TLS_TX;
+
+		rtnl_lock();
 		netdev->hw_features &= ~NETIF_F_HW_TLS_TX;
 		netdev->tlsdev_ops = NULL;
+		netdev_update_features(netdev);
+		rtnl_unlock();
 	}
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 5a41801acb6a..cf69c6edcfec 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1099,6 +1099,7 @@ struct adapter {
 
 	/* TC u32 offload */
 	struct cxgb4_tc_u32_table *tc_u32;
+	struct chcr_ktls chcr_ktls;
 	struct chcr_stats_debug chcr_stats;
 
 	/* TC flower offload */
@@ -2060,4 +2061,7 @@ int cxgb_open(struct net_device *dev);
 int cxgb_close(struct net_device *dev);
 void cxgb4_enable_rx(struct adapter *adap, struct sge_rspq *q);
 void cxgb4_quiesce_rx(struct sge_rspq *q);
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+int cxgb4_set_ktls_feature(struct adapter *adap, bool enable);
+#endif
 #endif /* __CXGB4_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index c3dd50b45c48..41315712deb8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3491,6 +3491,8 @@ static int chcr_stats_show(struct seq_file *seq, void *v)
 		   atomic_read(&adap->chcr_stats.tls_key));
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
 	seq_puts(seq, "\nChelsio KTLS Crypto Accelerator Stats\n");
+	seq_printf(seq, "Tx TLS offload refcount:          %20u\n",
+		   refcount_read(&adap->chcr_ktls.ktls_refcount));
 	seq_printf(seq, "Tx HW offload contexts added:     %20llu\n",
 		   atomic64_read(&adap->chcr_stats.ktls_tx_ctx));
 	seq_printf(seq, "Tx connection created:            %20llu\n",
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7a0414f379be..b80891e8d352 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1256,10 +1256,27 @@ int cxgb4_set_rspq_intr_params(struct sge_rspq *q,
 
 static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 {
-	const struct port_info *pi = netdev_priv(dev);
 	netdev_features_t changed = dev->features ^ features;
+	const struct port_info *pi = netdev_priv(dev);
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+	bool enable;
+#endif
 	int err;
 
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+	/* tls offload will be enabled runtime on user request only, we are
+	 * going to inform the same to FW.
+	 */
+	enable = !!((features & NETIF_F_HW_TLS_TX) & dev->hw_features);
+
+	if ((changed & NETIF_F_HW_TLS_TX) &&
+	    (pi->adapter->params.crypto & FW_CAPS_CONFIG_TLS_HW)) {
+		err = cxgb4_set_ktls_feature(pi->adapter, enable);
+		if (err)
+			return err;
+	}
+#endif
+
 	if (!(changed & NETIF_F_HW_VLAN_CTAG_RX))
 		return 0;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 6b1d3df4b9ba..3402f41cae1f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -662,23 +662,72 @@ static int uld_attach(struct adapter *adap, unsigned int uld)
 	return 0;
 }
 
+static bool cxgb4_uld_in_use(struct adapter *adap)
+{
+	const struct tid_info *t = &adap->tids;
+
+	return (atomic_read(&t->conns_in_use) || t->stids_in_use);
+}
+
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
 /* cxgb4_set_ktls_feature: request FW to enable/disable ktls settings.
  * @adap: adapter info
  * @enable: 1 to enable / 0 to disable ktls settings.
  */
-static void cxgb4_set_ktls_feature(struct adapter *adap, bool enable)
+int cxgb4_set_ktls_feature(struct adapter *adap, bool enable)
 {
-	u32 params = (FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_DEV) |
-		      FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_KTLS_TX_HW) |
-		      FW_PARAMS_PARAM_Y_V(enable));
-	int ret = 0;
+	u32 params;
+	int ret;
+
+	params = FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_DEV) |
+		 FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_KTLS_HW) |
+		 FW_PARAMS_PARAM_Y_V(enable) |
+		 FW_PARAMS_PARAM_Z_V(FW_PARAMS_PARAM_DEV_KTLS_HW_USER_ENABLE);
+
+	if (enable) {
+		if (!refcount_read(&adap->chcr_ktls.ktls_refcount)) {
+			/* At this moment if ULD connection are up means, other
+			 * ULD is/are already active, return failure.
+			 */
+			if (cxgb4_uld_in_use(adap)) {
+				dev_warn(adap->pdev_dev,
+					 "ULD connections (tid/stid) active. Can't enable kTLS\n");
+				return -EINVAL;
+			}
+			refcount_set(&adap->chcr_ktls.ktls_refcount, 1);
+			pr_info("kTLS has been enabled. Restrictions placed on ULD support\n");
+		} else {
+			/* ktls settings already up, just increment refcount. */
+			refcount_inc(&adap->chcr_ktls.ktls_refcount);
+			return 0;
+		}
+		/* we shouldn't remove CRYPTO ULD driver until any single
+		 * connection exists. Get ULD module's ref-count.
+		 */
+		try_module_get(adap->uld[CXGB4_ULD_CRYPTO].owner);
+	} else {
+		/* return failure if refcount is already 0. */
+		if (!refcount_read(&adap->chcr_ktls.ktls_refcount))
+			return -EINVAL;
+		/* decrement refcount and test, if 0, disable ktls feature,
+		 * else return command success.
+		 */
+		if (refcount_dec_and_test(&adap->chcr_ktls.ktls_refcount))
+			pr_info("kTLS is disabled. Restrictions on ULD support removed\n");
+		else
+			return 0;
+		/* no more connecton exists, clear module ref count */
+		module_put(adap->uld[CXGB4_ULD_CRYPTO].owner);
+	}
 
 	ret = t4_set_params(adap, adap->mbox, adap->pf, 0, 1, &params, &params);
 	/* if fw returns failure, clear the ktls flag */
 	if (ret)
 		adap->params.crypto &= ~ULP_CRYPTO_KTLS_INLINE;
+
+	return ret;
 }
+EXPORT_SYMBOL(cxgb4_set_ktls_feature);
 #endif
 
 static void cxgb4_uld_alloc_resources(struct adapter *adap,
@@ -705,12 +754,6 @@ static void cxgb4_uld_alloc_resources(struct adapter *adap,
 	}
 	if (adap->flags & CXGB4_FULL_INIT_DONE)
 		enable_rx_uld(adap, type);
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
-	/* send mbox to enable ktls related settings. */
-	if (type == CXGB4_ULD_CRYPTO &&
-	    (adap->params.crypto & FW_CAPS_CONFIG_TX_TLS_HW))
-		cxgb4_set_ktls_feature(adap, 1);
-#endif
 	if (adap->uld[type].add)
 		goto free_irq;
 	ret = setup_sge_txq_uld(adap, type, p);
@@ -804,13 +847,6 @@ int cxgb4_unregister_uld(enum cxgb4_uld type)
 			continue;
 
 		cxgb4_shutdown_uld_adapter(adap, type);
-
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
-		/* send mbox to disable ktls related settings. */
-		if (type == CXGB4_ULD_CRYPTO &&
-		    (adap->params.crypto & FW_CAPS_CONFIG_TX_TLS_HW))
-			cxgb4_set_ktls_feature(adap, 0);
-#endif
 	}
 
 	list_for_each_entry_safe(uld_entry, tmp, &uld_list, list_node) {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 085fa1424f9a..8af6ba12fe57 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -268,6 +268,10 @@ struct filter_ctx {
 	u32 tid;			/* to store tid */
 };
 
+struct chcr_ktls {
+	refcount_t ktls_refcount;
+};
+
 struct ch_filter_specification;
 
 int cxgb4_get_free_ftid(struct net_device *dev, u8 family, bool hash_en,
@@ -446,6 +450,7 @@ struct cxgb4_lld_info {
 };
 
 struct cxgb4_uld_info {
+	struct module *owner;
 	char name[IFNAMSIZ];
 	void *handle;
 	unsigned int nrxq;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index 68fe734b9b37..0a326c054707 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -1205,7 +1205,7 @@ enum fw_caps_config_crypto {
 	FW_CAPS_CONFIG_CRYPTO_LOOKASIDE = 0x00000001,
 	FW_CAPS_CONFIG_TLS_INLINE = 0x00000002,
 	FW_CAPS_CONFIG_IPSEC_INLINE = 0x00000004,
-	FW_CAPS_CONFIG_TX_TLS_HW = 0x00000008,
+	FW_CAPS_CONFIG_TLS_HW = 0x00000008,
 };
 
 enum fw_caps_config_fcoe {
@@ -1329,7 +1329,7 @@ enum fw_params_param_dev {
 	FW_PARAMS_PARAM_DEV_DBQ_TIMERTICK = 0x2A,
 	FW_PARAMS_PARAM_DEV_NUM_TM_CLASS = 0x2B,
 	FW_PARAMS_PARAM_DEV_FILTER = 0x2E,
-	FW_PARAMS_PARAM_DEV_KTLS_TX_HW = 0x31,
+	FW_PARAMS_PARAM_DEV_KTLS_HW = 0x31,
 };
 
 /*
@@ -1412,6 +1412,12 @@ enum fw_params_param_dmaq {
 	FW_PARAMS_PARAM_DMAQ_CONM_CTXT = 0x20,
 };
 
+enum fw_params_param_dev_ktls_hw {
+	FW_PARAMS_PARAM_DEV_KTLS_HW_DISABLE      = 0x00,
+	FW_PARAMS_PARAM_DEV_KTLS_HW_ENABLE       = 0x01,
+	FW_PARAMS_PARAM_DEV_KTLS_HW_USER_ENABLE  = 0x01,
+};
+
 enum fw_params_param_dev_phyfw {
 	FW_PARAMS_PARAM_DEV_PHYFW_DOWNLOAD = 0x00,
 	FW_PARAMS_PARAM_DEV_PHYFW_VERSION = 0x01,
-- 
2.18.1

