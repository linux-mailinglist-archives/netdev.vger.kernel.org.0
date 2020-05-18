Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CC31D7367
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 11:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgERJAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 05:00:08 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:43244 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgERJAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 05:00:08 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04I8xKba007038;
        Mon, 18 May 2020 01:59:22 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net] cxgb4/chcr: Enable ktls settings at run time
Date:   Mon, 18 May 2020 14:29:18 +0530
Message-Id: <20200518085918.32262-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current design enables ktls setting from start, which is not
efficient. Now the feature will be enabled when user demands
TLS offload on any interface.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ktls.c            | 19 +++++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  4 ++
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  2 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 26 +++++++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.c    | 66 ++++++++++++++-----
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |  4 ++
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h | 10 ++-
 7 files changed, 109 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index 43d9e2420110..dd1b6dbe8ffb 100644
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
 		netdev->hw_features |= NETIF_F_HW_TLS_TX;
 		netdev->tlsdev_ops = &chcr_ktls_ops;
+
+		rtnl_lock();
+		netdev_update_features(netdev);
+		rtnl_unlock();
 	}
 }
 
@@ -571,6 +584,10 @@ void chcr_disable_ktls(struct adapter *adap)
 		netdev->features &= ~NETIF_F_HW_TLS_TX;
 		netdev->hw_features &= ~NETIF_F_HW_TLS_TX;
 		netdev->tlsdev_ops = NULL;
+
+		rtnl_lock();
+		netdev_update_features(netdev);
+		rtnl_unlock();
 	}
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 30d25a37fc3b..526f942008eb 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1091,6 +1091,7 @@ struct adapter {
 
 	/* TC u32 offload */
 	struct cxgb4_tc_u32_table *tc_u32;
+	struct chcr_ktls chcr_ktls;
 	struct chcr_stats_debug chcr_stats;
 
 	/* TC flower offload */
@@ -2050,4 +2051,7 @@ int cxgb_open(struct net_device *dev);
 int cxgb_close(struct net_device *dev);
 void cxgb4_enable_rx(struct adapter *adap, struct sge_rspq *q);
 void cxgb4_quiesce_rx(struct sge_rspq *q);
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+int cxgb4_set_ktls_feature(struct adapter *adap, bool enable);
+#endif
 #endif /* __CXGB4_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index ebed99f3d4cf..70718dd933e8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3411,6 +3411,8 @@ static int chcr_stats_show(struct seq_file *seq, void *v)
 		   atomic_read(&adap->chcr_stats.tls_key));
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
 	seq_puts(seq, "\nChelsio KTLS Crypto Accelerator Stats\n");
+	seq_printf(seq, "Tx TLS offload refcount:          %20u\n",
+		   refcount_read(&adap->chcr_ktls.ktls_refcount));
 	seq_printf(seq, "Tx HW offload contexts added:     %20llu\n",
 		   atomic64_read(&adap->chcr_stats.ktls_tx_ctx));
 	seq_printf(seq, "Tx connection created:            %20llu\n",
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index a70018f067aa..5e8761610b08 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1255,10 +1255,34 @@ int cxgb4_set_rspq_intr_params(struct sge_rspq *q,
 
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
+
+		/* if wanted_features has NETIF_F_HW_TLS_TX set, it will cause
+		 * feature flag also get set, though hw_features is not even
+		 * set, better return failure here.
+		 */
+		if (!(dev->hw_features & NETIF_F_HW_TLS_TX))
+			return -EINVAL;
+	}
+#endif
+
 	if (!(changed & NETIF_F_HW_VLAN_CTAG_RX))
 		return 0;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index e65b52375dd8..d26bdea5b4c9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -662,23 +662,66 @@ static int uld_attach(struct adapter *adap, unsigned int uld)
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
 
 /* cxgb4_register_uld - register an upper-layer driver
@@ -717,12 +760,6 @@ void cxgb4_register_uld(enum cxgb4_uld type,
 		}
 		if (adap->flags & CXGB4_FULL_INIT_DONE)
 			enable_rx_uld(adap, type);
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
-		/* send mbox to enable ktls related settings. */
-		if (type == CXGB4_ULD_CRYPTO &&
-		    (adap->params.crypto & FW_CAPS_CONFIG_TX_TLS_HW))
-			cxgb4_set_ktls_feature(adap, 1);
-#endif
 		if (adap->uld[type].add)
 			goto free_irq;
 		ret = setup_sge_txq_uld(adap, type, p);
@@ -775,13 +812,6 @@ int cxgb4_unregister_uld(enum cxgb4_uld type)
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
 	mutex_unlock(&uld_mutex);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index be831317520a..e066adac05c6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -263,6 +263,10 @@ struct filter_ctx {
 	u32 tid;			/* to store tid */
 };
 
+struct chcr_ktls {
+	refcount_t ktls_refcount;
+};
+
 struct ch_filter_specification;
 
 int cxgb4_get_free_ftid(struct net_device *dev, u8 family, bool hash_en,
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

