Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3265262D56
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 12:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgIIKiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 06:38:06 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:43030 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgIIKiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 06:38:01 -0400
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 089Aan1s011317;
        Wed, 9 Sep 2020 03:36:50 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next] cxgb4/ch_ipsec: Registering xfrmdev_ops with cxgb4
Date:   Wed,  9 Sep 2020 16:06:20 +0530
Message-Id: <20200909103620.30210-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As ch_ipsec was removed without clearing xfrmdev_ops and netdev
feature(esp-hw-offload). When a recalculation of netdev feature is
triggered by changing tls feature(tls-hw-tx-offload) from user
request, it causes a page fault due to absence of valid xfrmdev_ops.

Fixes: 6dad4e8ab3ec ("chcr: Add support for Inline IPSec")
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   5 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 184 ++++++++++++++++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   3 +
 .../inline_crypto/ch_ipsec/chcr_ipsec.c       |  35 +---
 4 files changed, 172 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index e5d5c0fb7f47..abab82ad3f63 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -146,6 +146,11 @@ enum {
 	CXGB4_ETHTOOL_FLASH_BOOTCFG = 4
 };
 
+enum cxgb4_netdev_tls_ops {
+	CXGB4_TLSDEV_OPS  = 1,
+	CXGB4_XFRMDEV_OPS
+};
+
 struct cxgb4_bootcfg_data {
 	__le16 signature;
 	__u8 reserved[2];
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index de078a5bf23e..27530c0e2d14 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6396,6 +6396,49 @@ static int cxgb4_iov_configure(struct pci_dev *pdev, int num_vfs)
 }
 #endif /* CONFIG_PCI_IOV */
 
+#if defined(CONFIG_CHELSIO_TLS_DEVICE) || IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
+
+static int chcr_offload_state(struct adapter *adap,
+			      enum cxgb4_netdev_tls_ops op_val)
+{
+	switch (op_val) {
+#if defined(CONFIG_CHELSIO_TLS_DEVICE)
+	case CXGB4_TLSDEV_OPS:
+		if (!adap->uld[CXGB4_ULD_CRYPTO].handle) {
+			dev_dbg(adap->pdev_dev, "chcr driver is not loaded\n");
+			return -EOPNOTSUPP;
+		}
+		if (!adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops) {
+			dev_dbg(adap->pdev_dev,
+				"chcr driver has no registered tlsdev_ops\n");
+			return -EOPNOTSUPP;
+		}
+		break;
+#endif /* CONFIG_CHELSIO_TLS_DEVICE */
+#if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
+	case CXGB4_XFRMDEV_OPS:
+		if (!adap->uld[CXGB4_ULD_IPSEC].handle) {
+			dev_dbg(adap->pdev_dev, "chipsec driver is not loaded\n");
+			return -EOPNOTSUPP;
+		}
+		if (!adap->uld[CXGB4_ULD_IPSEC].xfrmdev_ops) {
+			dev_dbg(adap->pdev_dev,
+				"chipsec driver has no registered xfrmdev_ops\n");
+			return -EOPNOTSUPP;
+		}
+		break;
+#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
+	default:
+		dev_dbg(adap->pdev_dev,
+			"driver has no support for offload %d\n", op_val);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+#endif /* CONFIG_CHELSIO_TLS_DEVICE || CONFIG_CHELSIO_IPSEC_INLINE */
+
 #if defined(CONFIG_CHELSIO_TLS_DEVICE)
 
 static int cxgb4_ktls_dev_add(struct net_device *netdev, struct sock *sk,
@@ -6404,21 +6447,12 @@ static int cxgb4_ktls_dev_add(struct net_device *netdev, struct sock *sk,
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
@@ -6444,25 +6478,125 @@ static void cxgb4_ktls_dev_del(struct net_device *netdev,
 	struct adapter *adap = netdev2adap(netdev);
 
 	mutex_lock(&uld_mutex);
-	if (!adap->uld[CXGB4_ULD_CRYPTO].handle) {
-		dev_err(adap->pdev_dev, "chcr driver is not loaded\n");
+	if (chcr_offload_state(adap, CXGB4_TLSDEV_OPS))
 		goto out_unlock;
+
+	adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops->tls_dev_del(netdev, tls_ctx,
+							    direction);
+	cxgb4_set_ktls_feature(adap, FW_PARAMS_PARAM_DEV_KTLS_HW_DISABLE);
+
+out_unlock:
+	mutex_unlock(&uld_mutex);
+}
+
+#if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
+
+static int cxgb4_xfrm_add_state(struct xfrm_state *x)
+{
+	struct adapter *adap = netdev2adap(x->xso.dev);
+	int ret;
+
+	if (!mutex_trylock(&uld_mutex)) {
+		dev_dbg(adap->pdev_dev,
+			"crypto uld critical resource is under use\n");
+		return -EBUSY;
 	}
+	ret = chcr_offload_state(adap, CXGB4_XFRMDEV_OPS);
+	if (ret)
+		goto out_unlock;
 
-	if (!adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops) {
-		dev_err(adap->pdev_dev,
-			"chcr driver has no registered tlsdev_ops\n");
+	ret = adap->uld[CXGB4_ULD_IPSEC].xfrmdev_ops->xdo_dev_state_add(x);
+
+out_unlock:
+	mutex_unlock(&uld_mutex);
+
+	return ret;
+}
+
+static void cxgb4_xfrm_del_state(struct xfrm_state *x)
+{
+	struct adapter *adap = netdev2adap(x->xso.dev);
+
+	if (!mutex_trylock(&uld_mutex)) {
+		dev_dbg(adap->pdev_dev,
+			"crypto uld critical resource is under use\n");
+		return;
+	}
+	if (chcr_offload_state(adap, CXGB4_XFRMDEV_OPS))
 		goto out_unlock;
+
+	adap->uld[CXGB4_ULD_IPSEC].xfrmdev_ops->xdo_dev_state_delete(x);
+
+out_unlock:
+	mutex_unlock(&uld_mutex);
+}
+
+static void cxgb4_xfrm_free_state(struct xfrm_state *x)
+{
+	struct adapter *adap = netdev2adap(x->xso.dev);
+
+	if (!mutex_trylock(&uld_mutex)) {
+		dev_dbg(adap->pdev_dev,
+			"crypto uld critical resource is under use\n");
+		return;
 	}
+	if (chcr_offload_state(adap, CXGB4_XFRMDEV_OPS))
+		goto out_unlock;
 
-	adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops->tls_dev_del(netdev, tls_ctx,
-							    direction);
-	cxgb4_set_ktls_feature(adap, FW_PARAMS_PARAM_DEV_KTLS_HW_DISABLE);
+	adap->uld[CXGB4_ULD_IPSEC].xfrmdev_ops->xdo_dev_state_free(x);
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
+	if (!mutex_trylock(&uld_mutex)) {
+		dev_dbg(adap->pdev_dev,
+			"crypto uld critical resource is under use\n");
+		return ret;
+	}
+	if (chcr_offload_state(adap, CXGB4_XFRMDEV_OPS))
+		goto out_unlock;
+
+	ret = adap->uld[CXGB4_ULD_IPSEC].xfrmdev_ops->xdo_dev_offload_ok(skb, x);
 
 out_unlock:
 	mutex_unlock(&uld_mutex);
+	return ret;
 }
 
+static void cxgb4_advance_esn_state(struct xfrm_state *x)
+{
+	struct adapter *adap = netdev2adap(x->xso.dev);
+
+	if (!mutex_trylock(&uld_mutex)) {
+		dev_dbg(adap->pdev_dev,
+			"crypto uld critical resource is under use\n");
+		return;
+	}
+	if (chcr_offload_state(adap, CXGB4_XFRMDEV_OPS))
+		goto out_unlock;
+
+	adap->uld[CXGB4_ULD_IPSEC].xfrmdev_ops->xdo_dev_state_advance_esn(x);
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
 static const struct tlsdev_ops cxgb4_ktls_ops = {
 	.tls_dev_add = cxgb4_ktls_dev_add,
 	.tls_dev_del = cxgb4_ktls_dev_del,
@@ -6728,7 +6862,15 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			/* initialize the refcount */
 			refcount_set(&pi->adapter->chcr_ktls.ktls_refcount, 0);
 		}
-#endif
+#endif /* CONFIG_CHELSIO_TLS_DEVICE */
+#if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
+		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_IPSEC_INLINE) {
+			netdev->hw_enc_features |= NETIF_F_HW_ESP;
+			netdev->features |= NETIF_F_HW_ESP;
+			netdev->xfrmdev_ops = &cxgb4_xfrmdev_ops;
+		}
+#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
+
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 
 		/* MTU range: 81 - 9600 */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 83c8189e4088..421ae87aa7db 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -479,6 +479,9 @@ struct cxgb4_uld_info {
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
 	const struct tlsdev_ops *tlsdev_ops;
 #endif
+#if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
+	const struct xfrmdev_ops *xfrmdev_ops;
+#endif
 };
 
 void cxgb4_uld_enable(struct adapter *adap);
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
index 276f8841becc..0e7d25169407 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
@@ -79,7 +79,6 @@ static bool chcr_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
 static void chcr_advance_esn_state(struct xfrm_state *x);
 static int ch_ipsec_uld_state_change(void *handle, enum cxgb4_state new_state);
 static void *ch_ipsec_uld_add(const struct cxgb4_lld_info *infop);
-static void update_netdev_features(void);
 
 static const struct xfrmdev_ops chcr_xfrmdev_ops = {
 	.xdo_dev_state_add      = chcr_xfrm_add_state,
@@ -89,23 +88,6 @@ static const struct xfrmdev_ops chcr_xfrmdev_ops = {
 	.xdo_dev_state_advance_esn = chcr_advance_esn_state,
 };
 
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
 static struct cxgb4_uld_info ch_ipsec_uld_info = {
 	.name = CHIPSEC_DRV_MODULE_NAME,
 	.nrxq = MAX_ULD_QSETS,
@@ -114,6 +96,7 @@ static struct cxgb4_uld_info ch_ipsec_uld_info = {
 	.add = ch_ipsec_uld_add,
 	.state_change = ch_ipsec_uld_state_change,
 	.tx_handler = chcr_ipsec_xmit,
+	.xfrmdev_ops = &chcr_xfrmdev_ops,
 };
 
 static void *ch_ipsec_uld_add(const struct cxgb4_lld_info *infop)
@@ -808,26 +791,10 @@ out_free:       dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 
-static void update_netdev_features(void)
-{
-	struct ipsec_uld_ctx *u_ctx, *tmp;
-
-	mutex_lock(&dev_mutex);
-	list_for_each_entry_safe(u_ctx, tmp, &uld_ctx_list, entry) {
-		if (u_ctx->lldi.crypto & ULP_CRYPTO_IPSEC_INLINE)
-			chcr_add_xfrmops(&u_ctx->lldi);
-	}
-	mutex_unlock(&dev_mutex);
-}
-
 static int __init chcr_ipsec_init(void)
 {
 	cxgb4_register_uld(CXGB4_ULD_IPSEC, &ch_ipsec_uld_info);
 
-	rtnl_lock();
-	update_netdev_features();
-	rtnl_unlock();
-
 	return 0;
 }
 
-- 
2.28.0.rc1.6.gae46588

