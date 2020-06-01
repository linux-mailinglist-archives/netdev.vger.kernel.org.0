Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0471E9F60
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 09:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgFAHii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 03:38:38 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:61258 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgFAHih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 03:38:37 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0517cVS8030324;
        Mon, 1 Jun 2020 00:38:32 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net v4] cxgb4/chcr: Enable ktls settings at run time
Date:   Mon,  1 Jun 2020 13:08:29 +0530
Message-Id: <20200601073829.29024-1-rohitm@chelsio.com>
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

v2->v3:
- cxgb4 is now registering to tlsdev_ops.
- module refcount inc/dec in chcr.
- refcount is only for connections.
- removed new code from cxgb_set_feature().

v3->v4:
- fixed warning message.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chcr_core.c            | 23 +++--
 drivers/crypto/chelsio/chcr_core.h            | 10 ++-
 drivers/crypto/chelsio/chcr_ktls.c            | 59 ++++---------
 drivers/crypto/chelsio/chcr_ktls.h            |  9 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  4 +
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  2 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 85 ++++++++++++++++++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.c    | 71 +++++++++++-----
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |  7 ++
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h | 10 ++-
 10 files changed, 195 insertions(+), 85 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index ffd4ec0c7374..bd8dac806e7a 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -33,6 +33,13 @@ static int cpl_fw6_pld_handler(struct adapter *adap, unsigned char *input);
 static void *chcr_uld_add(const struct cxgb4_lld_info *lld);
 static int chcr_uld_state_change(void *handle, enum cxgb4_state state);
 
+#if defined(CONFIG_CHELSIO_TLS_DEVICE)
+static const struct tlsdev_ops chcr_ktls_ops = {
+	.tls_dev_add = chcr_ktls_dev_add,
+	.tls_dev_del = chcr_ktls_dev_del,
+};
+#endif
+
 #ifdef CONFIG_CHELSIO_IPSEC_INLINE
 static void update_netdev_features(void);
 #endif /* CONFIG_CHELSIO_IPSEC_INLINE */
@@ -56,6 +63,9 @@ static struct cxgb4_uld_info chcr_uld_info = {
 #if defined(CONFIG_CHELSIO_IPSEC_INLINE) || defined(CONFIG_CHELSIO_TLS_DEVICE)
 	.tx_handler = chcr_uld_tx_handler,
 #endif /* CONFIG_CHELSIO_IPSEC_INLINE || CONFIG_CHELSIO_TLS_DEVICE */
+#if defined(CONFIG_CHELSIO_TLS_DEVICE)
+	.tlsdev_ops = &chcr_ktls_ops,
+#endif
 };
 
 static void detach_work_fn(struct work_struct *work)
@@ -207,11 +217,6 @@ static void *chcr_uld_add(const struct cxgb4_lld_info *lld)
 	}
 	u_ctx->lldi = *lld;
 	chcr_dev_init(u_ctx);
-
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
-	if (lld->ulp_crypto & ULP_CRYPTO_KTLS_INLINE)
-		chcr_enable_ktls(padap(&u_ctx->dev));
-#endif
 out:
 	return u_ctx;
 }
@@ -348,20 +353,12 @@ static void __exit chcr_crypto_exit(void)
 	list_for_each_entry_safe(u_ctx, tmp, &drv_data.act_dev, entry) {
 		adap = padap(&u_ctx->dev);
 		memset(&adap->chcr_stats, 0, sizeof(adap->chcr_stats));
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
-		if (u_ctx->lldi.ulp_crypto & ULP_CRYPTO_KTLS_INLINE)
-			chcr_disable_ktls(adap);
-#endif
 		list_del(&u_ctx->entry);
 		kfree(u_ctx);
 	}
 	list_for_each_entry_safe(u_ctx, tmp, &drv_data.inact_dev, entry) {
 		adap = padap(&u_ctx->dev);
 		memset(&adap->chcr_stats, 0, sizeof(adap->chcr_stats));
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
-		if (u_ctx->lldi.ulp_crypto & ULP_CRYPTO_KTLS_INLINE)
-			chcr_disable_ktls(adap);
-#endif
 		list_del(&u_ctx->entry);
 		kfree(u_ctx);
 	}
diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index 2c09672e00a4..67d77abd6775 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -37,6 +37,7 @@
 #define __CHCR_CORE_H__
 
 #include <crypto/algapi.h>
+#include <net/tls.h>
 #include "t4_hw.h"
 #include "cxgb4.h"
 #include "t4_msg.h"
@@ -223,10 +224,15 @@ int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
 int chcr_ipsec_xmit(struct sk_buff *skb, struct net_device *dev);
 void chcr_add_xfrmops(const struct cxgb4_lld_info *lld);
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
-void chcr_enable_ktls(struct adapter *adap);
-void chcr_disable_ktls(struct adapter *adap);
 int chcr_ktls_cpl_act_open_rpl(struct adapter *adap, unsigned char *input);
 int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input);
 int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev);
+extern int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
+			     enum tls_offload_ctx_dir direction,
+			     struct tls_crypto_info *crypto_info,
+			     u32 start_offload_tcp_sn);
+extern void chcr_ktls_dev_del(struct net_device *netdev,
+			      struct tls_context *tls_ctx,
+			      enum tls_offload_ctx_dir direction);
 #endif
 #endif /* __CHCR_CORE_H__ */
diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index 43d9e2420110..f55b87152166 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -373,9 +373,9 @@ static int chcr_ktls_mark_tcb_close(struct chcr_ktls_info *tx_info)
  * @tls_cts - tls context.
  * @direction - TX/RX crypto direction
  */
-static void chcr_ktls_dev_del(struct net_device *netdev,
-			      struct tls_context *tls_ctx,
-			      enum tls_offload_ctx_dir direction)
+void chcr_ktls_dev_del(struct net_device *netdev,
+		       struct tls_context *tls_ctx,
+		       enum tls_offload_ctx_dir direction)
 {
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx =
 				chcr_get_ktls_tx_context(tls_ctx);
@@ -411,6 +411,8 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 	atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_connection_close);
 	kvfree(tx_info);
 	tx_ctx->chcr_info = NULL;
+	/* release module refcount */
+	module_put(THIS_MODULE);
 }
 
 /*
@@ -422,10 +424,10 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
  * @direction - TX/RX crypto direction
  * return: SUCCESS/FAILURE.
  */
-static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
-			     enum tls_offload_ctx_dir direction,
-			     struct tls_crypto_info *crypto_info,
-			     u32 start_offload_tcp_sn)
+int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
+		      enum tls_offload_ctx_dir direction,
+		      struct tls_crypto_info *crypto_info,
+		      u32 start_offload_tcp_sn)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
@@ -528,6 +530,12 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	if (ret)
 		goto out2;
 
+	/* Driver shouldn't be removed until any single connection exists */
+	if (!try_module_get(THIS_MODULE)) {
+		ret = -EINVAL;
+		goto out2;
+	}
+
 	atomic64_inc(&adap->chcr_stats.ktls_tx_connection_open);
 	return 0;
 out2:
@@ -537,43 +545,6 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	return ret;
 }
 
-static const struct tlsdev_ops chcr_ktls_ops = {
-	.tls_dev_add = chcr_ktls_dev_add,
-	.tls_dev_del = chcr_ktls_dev_del,
-};
-
-/*
- * chcr_enable_ktls:  add NETIF_F_HW_TLS_TX flag in all the ports.
- */
-void chcr_enable_ktls(struct adapter *adap)
-{
-	struct net_device *netdev;
-	int i;
-
-	for_each_port(adap, i) {
-		netdev = adap->port[i];
-		netdev->features |= NETIF_F_HW_TLS_TX;
-		netdev->hw_features |= NETIF_F_HW_TLS_TX;
-		netdev->tlsdev_ops = &chcr_ktls_ops;
-	}
-}
-
-/*
- * chcr_disable_ktls:  remove NETIF_F_HW_TLS_TX flag from all the ports.
- */
-void chcr_disable_ktls(struct adapter *adap)
-{
-	struct net_device *netdev;
-	int i;
-
-	for_each_port(adap, i) {
-		netdev = adap->port[i];
-		netdev->features &= ~NETIF_F_HW_TLS_TX;
-		netdev->hw_features &= ~NETIF_F_HW_TLS_TX;
-		netdev->tlsdev_ops = NULL;
-	}
-}
-
 /*
  * chcr_init_tcb_fields:  Initialize tcb fields to handle TCP seq number
  *			  handling.
diff --git a/drivers/crypto/chelsio/chcr_ktls.h b/drivers/crypto/chelsio/chcr_ktls.h
index 5a7ae2ca446e..5cbd84b1da05 100644
--- a/drivers/crypto/chelsio/chcr_ktls.h
+++ b/drivers/crypto/chelsio/chcr_ktls.h
@@ -89,10 +89,15 @@ static inline int chcr_get_first_rx_qid(struct adapter *adap)
 	return u_ctx->lldi.rxq_ids[0];
 }
 
-void chcr_enable_ktls(struct adapter *adap);
-void chcr_disable_ktls(struct adapter *adap);
 int chcr_ktls_cpl_act_open_rpl(struct adapter *adap, unsigned char *input);
 int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input);
 int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev);
+int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
+		      enum tls_offload_ctx_dir direction,
+		      struct tls_crypto_info *crypto_info,
+		      u32 start_offload_tcp_sn);
+void chcr_ktls_dev_del(struct net_device *netdev,
+		       struct tls_context *tls_ctx,
+		       enum tls_offload_ctx_dir direction);
 #endif /* CONFIG_CHELSIO_TLS_DEVICE */
 #endif /* __CHCR_KTLS_H__ */
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
index 7a0414f379be..854b1717a70d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -66,6 +66,9 @@
 #include <linux/crash_dump.h>
 #include <net/udp_tunnel.h>
 #include <net/xfrm.h>
+#if defined(CONFIG_CHELSIO_TLS_DEVICE)
+#include <net/tls.h>
+#endif
 
 #include "cxgb4.h"
 #include "cxgb4_filter.h"
@@ -6064,6 +6067,79 @@ static int cxgb4_iov_configure(struct pci_dev *pdev, int num_vfs)
 }
 #endif /* CONFIG_PCI_IOV */
 
+#if defined(CONFIG_CHELSIO_TLS_DEVICE)
+
+static int cxgb4_ktls_dev_add(struct net_device *netdev, struct sock *sk,
+			      enum tls_offload_ctx_dir direction,
+			      struct tls_crypto_info *crypto_info,
+			      u32 tcp_sn)
+{
+	struct adapter *adap = netdev2adap(netdev);
+	int ret = 0;
+
+	mutex_lock(&uld_mutex);
+	if (!adap->uld[CXGB4_ULD_CRYPTO].handle) {
+		dev_err(adap->pdev_dev, "chcr driver is not loaded\n");
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
+	if (!adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops) {
+		dev_err(adap->pdev_dev,
+			"chcr driver has no registered tlsdev_ops()\n");
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
+	ret = cxgb4_set_ktls_feature(adap, FW_PARAMS_PARAM_DEV_KTLS_HW_ENABLE);
+	if (ret)
+		goto out_unlock;
+
+	ret = adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops->tls_dev_add(netdev, sk,
+								  direction,
+								  crypto_info,
+								  tcp_sn);
+	/* if there is a failure, clear the refcount */
+	if (ret)
+		cxgb4_set_ktls_feature(adap,
+				       FW_PARAMS_PARAM_DEV_KTLS_HW_DISABLE);
+out_unlock:
+	mutex_unlock(&uld_mutex);
+	return ret;
+}
+
+static void cxgb4_ktls_dev_del(struct net_device *netdev,
+			       struct tls_context *tls_ctx,
+			       enum tls_offload_ctx_dir direction)
+{
+	struct adapter *adap = netdev2adap(netdev);
+
+	mutex_lock(&uld_mutex);
+	if (!adap->uld[CXGB4_ULD_CRYPTO].handle) {
+		dev_err(adap->pdev_dev, "chcr driver is not loaded\n");
+		goto out_unlock;
+	}
+
+	if (!adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops) {
+		dev_err(adap->pdev_dev,
+			"chcr driver has no registered tlsdev_ops\n");
+		goto out_unlock;
+	}
+
+	adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops->tls_dev_del(netdev, tls_ctx,
+							    direction);
+	cxgb4_set_ktls_feature(adap, FW_PARAMS_PARAM_DEV_KTLS_HW_DISABLE);
+
+out_unlock:
+	mutex_unlock(&uld_mutex);
+}
+
+static const struct tlsdev_ops cxgb4_ktls_ops = {
+	.tls_dev_add = cxgb4_ktls_dev_add,
+	.tls_dev_del = cxgb4_ktls_dev_del,
+};
+#endif /* CONFIG_CHELSIO_TLS_DEVICE */
+
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct net_device *netdev;
@@ -6313,7 +6389,14 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			netdev->hw_features |= NETIF_F_HIGHDMA;
 		netdev->features |= netdev->hw_features;
 		netdev->vlan_features = netdev->features & VLAN_FEAT;
-
+#if defined(CONFIG_CHELSIO_TLS_DEVICE)
+		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_TLS_HW) {
+			netdev->hw_features |= NETIF_F_HW_TLS_TX;
+			netdev->tlsdev_ops = &cxgb4_ktls_ops;
+			/* initialize the refcount */
+			refcount_set(&pi->adapter->chcr_ktls.ktls_refcount, 0);
+		}
+#endif
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 
 		/* MTU range: 81 - 9600 */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 6b1d3df4b9ba..d93fdabe3f0a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -662,22 +662,64 @@ static int uld_attach(struct adapter *adap, unsigned int uld)
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
 	int ret = 0;
+	u32 params =
+		FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_DEV) |
+		FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_KTLS_HW) |
+		FW_PARAMS_PARAM_Y_V(enable) |
+		FW_PARAMS_PARAM_Z_V(FW_PARAMS_PARAM_DEV_KTLS_HW_USER_ENABLE);
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
+			ret = t4_set_params(adap, adap->mbox, adap->pf,
+					    0, 1, &params, &params);
+			if (ret)
+				return ret;
+			refcount_set(&adap->chcr_ktls.ktls_refcount, 1);
+			pr_info("kTLS has been enabled. Restrictions placed on ULD support\n");
+		} else {
+			/* ktls settings already up, just increment refcount. */
+			refcount_inc(&adap->chcr_ktls.ktls_refcount);
+		}
+	} else {
+		/* return failure if refcount is already 0. */
+		if (!refcount_read(&adap->chcr_ktls.ktls_refcount))
+			return -EINVAL;
+		/* decrement refcount and test, if 0, disable ktls feature,
+		 * else return command success.
+		 */
+		if (refcount_dec_and_test(&adap->chcr_ktls.ktls_refcount)) {
+			ret = t4_set_params(adap, adap->mbox, adap->pf,
+					    0, 1, &params, &params);
+			if (ret)
+				return ret;
+			pr_info("kTLS is disabled. Restrictions on ULD support removed\n");
+		}
+	}
 
-	ret = t4_set_params(adap, adap->mbox, adap->pf, 0, 1, &params, &params);
-	/* if fw returns failure, clear the ktls flag */
-	if (ret)
-		adap->params.crypto &= ~ULP_CRYPTO_KTLS_INLINE;
+	return ret;
 }
 #endif
 
@@ -705,12 +747,6 @@ static void cxgb4_uld_alloc_resources(struct adapter *adap,
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
@@ -804,13 +840,6 @@ int cxgb4_unregister_uld(enum cxgb4_uld type)
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
index 085fa1424f9a..dbce99b209d6 100644
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
@@ -464,6 +468,9 @@ struct cxgb4_uld_info {
 			      struct napi_struct *napi);
 	void (*lro_flush)(struct t4_lro_mgr *);
 	int (*tx_handler)(struct sk_buff *skb, struct net_device *dev);
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	const struct tlsdev_ops *tlsdev_ops;
+#endif
 };
 
 void cxgb4_uld_enable(struct adapter *adap);
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

