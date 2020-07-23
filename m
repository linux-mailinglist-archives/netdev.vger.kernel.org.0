Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AB022B377
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgGWQ1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:27:00 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:25618 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgGWQ07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 12:26:59 -0400
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06NGQlZm013025;
        Thu, 23 Jul 2020 09:26:48 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, secdev@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net] Crypto/chcr: Registering cxgb4 to xfrmdev_ops
Date:   Thu, 23 Jul 2020 21:53:51 +0530
Message-Id: <20200723162351.12207-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As chcr was removed without clearing xfrmdev_ops and netdev
feature(esp-hw-offload). When a recalculation of netdev feature is
triggered by changing tls feature(tls-hw-tx-offload) from user request,
it causes a page fault due to absence of valid xfrmdev_ops.

So fixing this by registering chcr_xfrmdev_ops with cxgb4.

Fixes: 6dad4e8ab3ec ("chcr: Add support for Inline IPSec")
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_core.c            |  35 ++--
 drivers/crypto/chelsio/chcr_core.h            |   7 +
 drivers/crypto/chelsio/chcr_ipsec.c           |  41 +----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   5 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 150 +++++++++++++++---
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   3 +
 6 files changed, 160 insertions(+), 81 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index bd8dac806e7a..c8aa2d1a5664 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -41,7 +41,13 @@ static const struct tlsdev_ops chcr_ktls_ops = {
 #endif
 
 #ifdef CONFIG_CHELSIO_IPSEC_INLINE
-static void update_netdev_features(void);
+static const struct xfrmdev_ops chcr_xfrmdev_ops = {
+	.xdo_dev_state_add      = chcr_xfrm_add_state,
+	.xdo_dev_state_delete   = chcr_xfrm_del_state,
+	.xdo_dev_state_free     = chcr_xfrm_free_state,
+	.xdo_dev_offload_ok     = chcr_ipsec_offload_ok,
+	.xdo_dev_state_advance_esn = chcr_advance_esn_state,
+};
 #endif /* CONFIG_CHELSIO_IPSEC_INLINE */
 
 static chcr_handler_func work_handlers[NUM_CPL_CMDS] = {
@@ -66,6 +72,9 @@ static struct cxgb4_uld_info chcr_uld_info = {
 #if defined(CONFIG_CHELSIO_TLS_DEVICE)
 	.tlsdev_ops = &chcr_ktls_ops,
 #endif
+#if defined(CONFIG_CHELSIO_IPSEC_INLINE)
+	.xfrmdev_ops = &chcr_xfrmdev_ops,
+#endif
 };
 
 static void detach_work_fn(struct work_struct *work)
@@ -305,24 +314,6 @@ static int chcr_uld_state_change(void *handle, enum cxgb4_state state)
 	return ret;
 }
 
-#ifdef CONFIG_CHELSIO_IPSEC_INLINE
-static void update_netdev_features(void)
-{
-	struct uld_ctx *u_ctx, *tmp;
-
-	mutex_lock(&drv_data.drv_mutex);
-	list_for_each_entry_safe(u_ctx, tmp, &drv_data.inact_dev, entry) {
-		if (u_ctx->lldi.crypto & ULP_CRYPTO_IPSEC_INLINE)
-			chcr_add_xfrmops(&u_ctx->lldi);
-	}
-	list_for_each_entry_safe(u_ctx, tmp, &drv_data.act_dev, entry) {
-		if (u_ctx->lldi.crypto & ULP_CRYPTO_IPSEC_INLINE)
-			chcr_add_xfrmops(&u_ctx->lldi);
-	}
-	mutex_unlock(&drv_data.drv_mutex);
-}
-#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
-
 static int __init chcr_crypto_init(void)
 {
 	INIT_LIST_HEAD(&drv_data.act_dev);
@@ -332,12 +323,6 @@ static int __init chcr_crypto_init(void)
 	drv_data.last_dev = NULL;
 	cxgb4_register_uld(CXGB4_ULD_CRYPTO, &chcr_uld_info);
 
-	#ifdef CONFIG_CHELSIO_IPSEC_INLINE
-	rtnl_lock();
-	update_netdev_features();
-	rtnl_unlock();
-	#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
-
 	return 0;
 }
 
diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index 67d77abd6775..098017b5bb9f 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -235,4 +235,11 @@ extern void chcr_ktls_dev_del(struct net_device *netdev,
 			      struct tls_context *tls_ctx,
 			      enum tls_offload_ctx_dir direction);
 #endif
+#ifdef CONFIG_CHELSIO_IPSEC_INLINE
+int chcr_xfrm_add_state(struct xfrm_state *x);
+void chcr_xfrm_del_state(struct xfrm_state *x);
+void chcr_xfrm_free_state(struct xfrm_state *x);
+bool chcr_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
+void chcr_advance_esn_state(struct xfrm_state *x);
+#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
 #endif /* __CHCR_CORE_H__ */
diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index 967babd67a51..9f2e3cf2c4b3 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -71,37 +71,6 @@
 #define MAX_IMM_TX_PKT_LEN 256
 #define GCM_ESP_IV_SIZE     8
 
-static int chcr_xfrm_add_state(struct xfrm_state *x);
-static void chcr_xfrm_del_state(struct xfrm_state *x);
-static void chcr_xfrm_free_state(struct xfrm_state *x);
-static bool chcr_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
-static void chcr_advance_esn_state(struct xfrm_state *x);
-
-static const struct xfrmdev_ops chcr_xfrmdev_ops = {
-	.xdo_dev_state_add      = chcr_xfrm_add_state,
-	.xdo_dev_state_delete   = chcr_xfrm_del_state,
-	.xdo_dev_state_free     = chcr_xfrm_free_state,
-	.xdo_dev_offload_ok     = chcr_ipsec_offload_ok,
-	.xdo_dev_state_advance_esn = chcr_advance_esn_state,
-};
-
-/* Add offload xfrms to Chelsio Interface */
-void chcr_add_xfrmops(const struct cxgb4_lld_info *lld)
-{
-	struct net_device *netdev = NULL;
-	int i;
-
-	for (i = 0; i < lld->nports; i++) {
-		netdev = lld->ports[i];
-		if (!netdev)
-			continue;
-		netdev->xfrmdev_ops = &chcr_xfrmdev_ops;
-		netdev->hw_enc_features |= NETIF_F_HW_ESP;
-		netdev->features |= NETIF_F_HW_ESP;
-		netdev_change_features(netdev);
-	}
-}
-
 static inline int chcr_ipsec_setauthsize(struct xfrm_state *x,
 					 struct ipsec_sa_entry *sa_entry)
 {
@@ -189,7 +158,7 @@ static inline int chcr_ipsec_setkey(struct xfrm_state *x,
  * returns 0 on success, negative error if failed to send message to FPGA
  * positive error if FPGA returned a bad response
  */
-static int chcr_xfrm_add_state(struct xfrm_state *x)
+int chcr_xfrm_add_state(struct xfrm_state *x)
 {
 	struct ipsec_sa_entry *sa_entry;
 	int res = 0;
@@ -263,14 +232,14 @@ static int chcr_xfrm_add_state(struct xfrm_state *x)
 	return res;
 }
 
-static void chcr_xfrm_del_state(struct xfrm_state *x)
+void chcr_xfrm_del_state(struct xfrm_state *x)
 {
 	/* do nothing */
 	if (!x->xso.offload_handle)
 		return;
 }
 
-static void chcr_xfrm_free_state(struct xfrm_state *x)
+void chcr_xfrm_free_state(struct xfrm_state *x)
 {
 	struct ipsec_sa_entry *sa_entry;
 
@@ -282,7 +251,7 @@ static void chcr_xfrm_free_state(struct xfrm_state *x)
 	module_put(THIS_MODULE);
 }
 
-static bool chcr_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
+bool chcr_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 {
 	if (x->props.family == AF_INET) {
 		/* Offload with IP options is not supported yet */
@@ -296,7 +265,7 @@ static bool chcr_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 	return true;
 }
 
-static void chcr_advance_esn_state(struct xfrm_state *x)
+void chcr_advance_esn_state(struct xfrm_state *x)
 {
 	/* do nothing */
 	if (!x->xso.offload_handle)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index cf69c6edcfec..9e947d64d146 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -139,6 +139,11 @@ enum cc_fec {
 	FEC_BASER_RS  = 1 << 2   /* BaseR/Reed-Solomon */
 };
 
+enum cxgb4_netdev_tls_ops {
+	CXGB4_TLSDEV_OPS  = 1,
+	CXGB4_XFRMDEV_OPS
+};
+
 struct port_stats {
 	u64 tx_octets;            /* total # of octets in good frames */
 	u64 tx_frames;            /* all good frames */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 0329a6b52087..9dd9f25cfd53 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6068,6 +6068,38 @@ static int cxgb4_iov_configure(struct pci_dev *pdev, int num_vfs)
 }
 #endif /* CONFIG_PCI_IOV */
 
+static int chcr_offload_state(struct adapter *adap,
+			      enum cxgb4_netdev_tls_ops op_val)
+{
+	if (!adap->uld[CXGB4_ULD_CRYPTO].handle) {
+		dev_dbg(adap->pdev_dev, "chcr driver is not loaded\n");
+			return -EOPNOTSUPP;
+	}
+
+	switch (op_val) {
+	case CXGB4_TLSDEV_OPS:
+		if (!adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops) {
+			dev_dbg(adap->pdev_dev,
+				"chcr driver has no registered tlsdev_ops\n");
+			return -EOPNOTSUPP;
+		}
+		break;
+	case CXGB4_XFRMDEV_OPS:
+		if (!adap->uld[CXGB4_ULD_CRYPTO].xfrmdev_ops) {
+			dev_dbg(adap->pdev_dev,
+				"chcr driver has no registered xfrmdev_ops\n");
+			return -EOPNOTSUPP;
+		}
+		break;
+	default:
+		dev_dbg(adap->pdev_dev,
+			"chcr driver has no support for offload %d\n", op_val);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 #if defined(CONFIG_CHELSIO_TLS_DEVICE)
 
 static int cxgb4_ktls_dev_add(struct net_device *netdev, struct sock *sk,
@@ -6076,21 +6108,12 @@ static int cxgb4_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 			      u32 tcp_sn)
 {
 	struct adapter *adap = netdev2adap(netdev);
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&uld_mutex);
-	if (!adap->uld[CXGB4_ULD_CRYPTO].handle) {
-		dev_err(adap->pdev_dev, "chcr driver is not loaded\n");
-		ret = -EOPNOTSUPP;
-		goto out_unlock;
-	}
-
-	if (!adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops) {
-		dev_err(adap->pdev_dev,
-			"chcr driver has no registered tlsdev_ops()\n");
-		ret = -EOPNOTSUPP;
+	ret = chcr_offload_state(adap, CXGB4_TLSDEV_OPS);
+	if (ret)
 		goto out_unlock;
-	}
 
 	ret = cxgb4_set_ktls_feature(adap, FW_PARAMS_PARAM_DEV_KTLS_HW_ENABLE);
 	if (ret)
@@ -6116,16 +6139,9 @@ static void cxgb4_ktls_dev_del(struct net_device *netdev,
 	struct adapter *adap = netdev2adap(netdev);
 
 	mutex_lock(&uld_mutex);
-	if (!adap->uld[CXGB4_ULD_CRYPTO].handle) {
-		dev_err(adap->pdev_dev, "chcr driver is not loaded\n");
-		goto out_unlock;
-	}
 
-	if (!adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops) {
-		dev_err(adap->pdev_dev,
-			"chcr driver has no registered tlsdev_ops\n");
+	if (chcr_offload_state(adap, CXGB4_TLSDEV_OPS))
 		goto out_unlock;
-	}
 
 	adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops->tls_dev_del(netdev, tls_ctx,
 							    direction);
@@ -6141,6 +6157,93 @@ static const struct tlsdev_ops cxgb4_ktls_ops = {
 };
 #endif /* CONFIG_CHELSIO_TLS_DEVICE */
 
+#if defined(CONFIG_CHELSIO_IPSEC_INLINE)
+
+static int cxgb4_xfrm_add_state(struct xfrm_state *x)
+{
+	struct adapter *adap = netdev2adap(x->xso.dev);
+	int ret;
+
+	mutex_lock(&uld_mutex);
+	ret = chcr_offload_state(adap, CXGB4_XFRMDEV_OPS);
+	if (ret)
+		goto out_unlock;
+
+	ret = adap->uld[CXGB4_ULD_CRYPTO].xfrmdev_ops->xdo_dev_state_add(x);
+
+out_unlock:
+	mutex_unlock(&uld_mutex);
+	return ret;
+}
+
+static void cxgb4_xfrm_del_state(struct xfrm_state *x)
+{
+	struct adapter *adap = netdev2adap(x->xso.dev);
+
+	mutex_lock(&uld_mutex);
+	if (chcr_offload_state(adap, CXGB4_XFRMDEV_OPS))
+		goto out_unlock;
+
+	adap->uld[CXGB4_ULD_CRYPTO].xfrmdev_ops->xdo_dev_state_delete(x);
+
+out_unlock:
+	mutex_unlock(&uld_mutex);
+}
+
+static void cxgb4_xfrm_free_state(struct xfrm_state *x)
+{
+	struct adapter *adap = netdev2adap(x->xso.dev);
+
+	mutex_lock(&uld_mutex);
+	if (chcr_offload_state(adap, CXGB4_XFRMDEV_OPS))
+		goto out_unlock;
+
+	adap->uld[CXGB4_ULD_CRYPTO].xfrmdev_ops->xdo_dev_state_free(x);
+
+out_unlock:
+	mutex_unlock(&uld_mutex);
+}
+
+static bool cxgb4_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
+{
+	struct adapter *adap = netdev2adap(x->xso.dev);
+	bool ret = false;
+
+	mutex_lock(&uld_mutex);
+	if (chcr_offload_state(adap, CXGB4_XFRMDEV_OPS))
+		goto out_unlock;
+
+	ret = adap->uld[CXGB4_ULD_CRYPTO].xfrmdev_ops->xdo_dev_offload_ok(skb, x);
+
+out_unlock:
+	mutex_unlock(&uld_mutex);
+	return ret;
+}
+
+static void cxgb4_advance_esn_state(struct xfrm_state *x)
+{
+	struct adapter *adap = netdev2adap(x->xso.dev);
+
+	mutex_lock(&uld_mutex);
+	if (chcr_offload_state(adap, CXGB4_XFRMDEV_OPS))
+		goto out_unlock;
+
+	adap->uld[CXGB4_ULD_CRYPTO].xfrmdev_ops->xdo_dev_state_advance_esn(x);
+
+out_unlock:
+	mutex_unlock(&uld_mutex);
+}
+
+static const struct xfrmdev_ops cxgb4_xfrmdev_ops = {
+	.xdo_dev_state_add      = cxgb4_xfrm_add_state,
+	.xdo_dev_state_delete   = cxgb4_xfrm_del_state,
+	.xdo_dev_state_free     = cxgb4_xfrm_free_state,
+	.xdo_dev_offload_ok     = cxgb4_ipsec_offload_ok,
+	.xdo_dev_state_advance_esn = cxgb4_advance_esn_state,
+};
+
+#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
+
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct net_device *netdev;
@@ -6397,6 +6500,13 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			/* initialize the refcount */
 			refcount_set(&pi->adapter->chcr_ktls.ktls_refcount, 0);
 		}
+#endif
+#if defined(CONFIG_CHELSIO_IPSEC_INLINE)
+		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_IPSEC_INLINE) {
+			netdev->hw_enc_features |= NETIF_F_HW_ESP;
+			netdev->features |= NETIF_F_HW_ESP;
+			netdev->xfrmdev_ops = &cxgb4_xfrmdev_ops;
+		}
 #endif
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index dbce99b209d6..db8d71e7652f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -471,6 +471,9 @@ struct cxgb4_uld_info {
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
 	const struct tlsdev_ops *tlsdev_ops;
 #endif
+#if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
+	const struct xfrmdev_ops *xfrmdev_ops;
+#endif
 };
 
 void cxgb4_uld_enable(struct adapter *adap);
-- 
2.28.0.rc1.6.gae46588

