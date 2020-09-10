Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD941264882
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbgIJO5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:57:30 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:43579 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730336AbgIJO4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:56:45 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 08AELn05015648;
        Thu, 10 Sep 2020 07:21:50 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net-next] crypto/chcr: move nic TLS functionality to drivers/net
Date:   Thu, 10 Sep 2020 19:51:47 +0530
Message-Id: <20200910142147.21851-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves complete nic tls offload (kTLS) code from crypto
directory to drivers/net/ethernet/chelsio/inline_crypto/ch_ktls
directory. nic TLS is made a separate ULD of cxgb4.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/Kconfig                |  11 --
 drivers/crypto/chelsio/Makefile               |   3 -
 drivers/crypto/chelsio/chcr_core.c            |  24 ---
 drivers/crypto/chelsio/chcr_core.h            |  12 --
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   5 +-
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  35 ++--
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |   4 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  42 ++---
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.c    |   2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |  30 +--
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |   4 +-
 .../ethernet/chelsio/inline_crypto/Kconfig    |  13 ++
 .../ethernet/chelsio/inline_crypto/Makefile   |   1 +
 .../chelsio/inline_crypto/ch_ktls/Makefile    |   7 +
 .../inline_crypto/ch_ktls}/chcr_common.h      |  24 ---
 .../inline_crypto/ch_ktls}/chcr_ktls.c        | 174 +++++++++++++++---
 .../inline_crypto/ch_ktls}/chcr_ktls.h        |  26 ++-
 17 files changed, 245 insertions(+), 172 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/Makefile
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto/ch_ktls}/chcr_common.h (87%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto/ch_ktls}/chcr_ktls.c (92%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto/ch_ktls}/chcr_ktls.h (74%)

diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index af161dab49bd..f886401af13e 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -21,14 +21,3 @@ config CRYPTO_DEV_CHELSIO
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called chcr.
-
-config CHELSIO_TLS_DEVICE
-	bool "Chelsio Inline KTLS Offload"
-	depends on CHELSIO_T4
-	depends on TLS_DEVICE
-	select CRYPTO_DEV_CHELSIO
-	default y
-	help
-	  This flag enables support for kernel tls offload over Chelsio T6
-	  crypto accelerator. CONFIG_CHELSIO_TLS_DEVICE flag can be enabled
-	  only if CONFIG_TLS and CONFIG_TLS_DEVICE flags are enabled.
diff --git a/drivers/crypto/chelsio/Makefile b/drivers/crypto/chelsio/Makefile
index f2e8e2fb4e60..2e5df484ab01 100644
--- a/drivers/crypto/chelsio/Makefile
+++ b/drivers/crypto/chelsio/Makefile
@@ -3,6 +3,3 @@ ccflags-y := -I $(srctree)/drivers/net/ethernet/chelsio/cxgb4
 
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chcr.o
 chcr-objs :=  chcr_core.o chcr_algo.o
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
-chcr-objs += chcr_ktls.o
-#endif
diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index b3570b41a737..40d51d2bd935 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -33,19 +33,8 @@ static int cpl_fw6_pld_handler(struct adapter *adap, unsigned char *input);
 static void *chcr_uld_add(const struct cxgb4_lld_info *lld);
 static int chcr_uld_state_change(void *handle, enum cxgb4_state state);
 
-#if defined(CONFIG_CHELSIO_TLS_DEVICE)
-static const struct tlsdev_ops chcr_ktls_ops = {
-	.tls_dev_add = chcr_ktls_dev_add,
-	.tls_dev_del = chcr_ktls_dev_del,
-};
-#endif
-
 static chcr_handler_func work_handlers[NUM_CPL_CMDS] = {
 	[CPL_FW6_PLD] = cpl_fw6_pld_handler,
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
-	[CPL_ACT_OPEN_RPL] = chcr_ktls_cpl_act_open_rpl,
-	[CPL_SET_TCB_RPL] = chcr_ktls_cpl_set_tcb_rpl,
-#endif
 };
 
 static struct cxgb4_uld_info chcr_uld_info = {
@@ -56,10 +45,6 @@ static struct cxgb4_uld_info chcr_uld_info = {
 	.add = chcr_uld_add,
 	.state_change = chcr_uld_state_change,
 	.rx_handler = chcr_uld_rx_handler,
-#if defined(CONFIG_CHELSIO_TLS_DEVICE)
-	.tx_handler = chcr_uld_tx_handler,
-	.tlsdev_ops = &chcr_ktls_ops,
-#endif
 };
 
 static void detach_work_fn(struct work_struct *work)
@@ -235,15 +220,6 @@ int chcr_uld_rx_handler(void *handle, const __be64 *rsp,
 	return 0;
 }
 
-#if defined(CONFIG_CHELSIO_TLS_DEVICE)
-int chcr_uld_tx_handler(struct sk_buff *skb, struct net_device *dev)
-{
-	if (skb->decrypted)
-		return chcr_ktls_xmit(skb, dev);
-	return 0;
-}
-#endif /* CONFIG_CHELSIO_IPSEC_INLINE || CONFIG_CHELSIO_TLS_DEVICE */
-
 static void chcr_detach_device(struct uld_ctx *u_ctx)
 {
 	struct chcr_dev *dev = &u_ctx->dev;
diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index 81f6e61401e5..bb092b6b36b2 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -139,16 +139,4 @@ int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
 		     int err);
 int chcr_ipsec_xmit(struct sk_buff *skb, struct net_device *dev);
 void chcr_add_xfrmops(const struct cxgb4_lld_info *lld);
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
-int chcr_ktls_cpl_act_open_rpl(struct adapter *adap, unsigned char *input);
-int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input);
-int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev);
-extern int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
-			     enum tls_offload_ctx_dir direction,
-			     struct tls_crypto_info *crypto_info,
-			     u32 start_offload_tcp_sn);
-extern void chcr_ktls_dev_del(struct net_device *netdev,
-			      struct tls_context *tls_ctx,
-			      enum tls_offload_ctx_dir direction);
-#endif
 #endif /* __CHCR_CORE_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index abab82ad3f63..f55550d3a429 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1201,6 +1201,9 @@ struct adapter {
 	struct cxgb4_tc_u32_table *tc_u32;
 	struct chcr_ktls chcr_ktls;
 	struct chcr_stats_debug chcr_stats;
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
+	struct ch_ktls_stats_debug ch_ktls_stats;
+#endif
 #if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
 	struct ch_ipsec_stats_debug ch_ipsec_stats;
 #endif
@@ -2177,7 +2180,7 @@ void cxgb4_enable_rx(struct adapter *adap, struct sge_rspq *q);
 void cxgb4_quiesce_rx(struct sge_rspq *q);
 int cxgb4_port_mirror_alloc(struct net_device *dev);
 void cxgb4_port_mirror_free(struct net_device *dev);
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 int cxgb4_set_ktls_feature(struct adapter *adap, bool enable);
 #endif
 #endif /* __CXGB4_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 42112e8ad687..5491a41fd1be 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3553,44 +3553,43 @@ static int chcr_stats_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "IPSec PDU: %10u\n",
 		   atomic_read(&adap->ch_ipsec_stats.ipsec_cnt));
 #endif
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 	seq_puts(seq, "\nChelsio KTLS Crypto Accelerator Stats\n");
 	seq_printf(seq, "Tx TLS offload refcount:          %20u\n",
 		   refcount_read(&adap->chcr_ktls.ktls_refcount));
 	seq_printf(seq, "Tx HW offload contexts added:     %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_ctx));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_ctx));
 	seq_printf(seq, "Tx connection created:            %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_connection_open));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_connection_open));
 	seq_printf(seq, "Tx connection failed:             %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_connection_fail));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_connection_fail));
 	seq_printf(seq, "Tx connection closed:             %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_connection_close));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_connection_close));
 	seq_printf(seq, "Packets passed for encryption :   %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_encrypted_packets));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_encrypted_packets));
 	seq_printf(seq, "Bytes passed for encryption :     %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_encrypted_bytes));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_encrypted_bytes));
 	seq_printf(seq, "Tx records send:                  %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_send_records));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_send_records));
 	seq_printf(seq, "Tx partial start of records:      %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_start_pkts));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_start_pkts));
 	seq_printf(seq, "Tx partial middle of records:     %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_middle_pkts));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_middle_pkts));
 	seq_printf(seq, "Tx partial end of record:         %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_end_pkts));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_end_pkts));
 	seq_printf(seq, "Tx complete records:              %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_complete_pkts));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_complete_pkts));
 	seq_printf(seq, "TX trim pkts :                    %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_trimmed_pkts));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_trimmed_pkts));
 	seq_printf(seq, "Tx out of order packets:          %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_ooo));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_ooo));
 	seq_printf(seq, "Tx drop pkts before HW offload:   %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_skip_no_sync_data));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_skip_no_sync_data));
 	seq_printf(seq, "Tx drop not synced packets:       %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_drop_no_sync_data));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_drop_no_sync_data));
 	seq_printf(seq, "Tx drop bypass req:               %20llu\n",
-		   atomic64_read(&adap->chcr_stats.ktls_tx_drop_bypass_req));
+		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_drop_bypass_req));
 #endif
-
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(chcr_stats);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 9f3173f86eed..8c6c9bedcba1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -125,7 +125,7 @@ static char adapter_stats_strings[][ETH_GSTRING_LEN] = {
 	"db_empty               ",
 	"write_coal_success     ",
 	"write_coal_fail        ",
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
+#if  IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 	"tx_tls_encrypted_packets",
 	"tx_tls_encrypted_bytes  ",
 	"tx_tls_ctx              ",
@@ -265,7 +265,7 @@ struct adapter_stats {
 	u64 db_empty;
 	u64 wc_success;
 	u64 wc_fail;
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 	u64 tx_tls_encrypted_packets;
 	u64 tx_tls_encrypted_bytes;
 	u64 tx_tls_ctx;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 27530c0e2d14..a952fe198eb9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -66,7 +66,7 @@
 #include <linux/crash_dump.h>
 #include <net/udp_tunnel.h>
 #include <net/xfrm.h>
-#if defined(CONFIG_CHELSIO_TLS_DEVICE)
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 #include <net/tls.h>
 #endif
 
@@ -6396,21 +6396,21 @@ static int cxgb4_iov_configure(struct pci_dev *pdev, int num_vfs)
 }
 #endif /* CONFIG_PCI_IOV */
 
-#if defined(CONFIG_CHELSIO_TLS_DEVICE) || IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE) || IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
 
 static int chcr_offload_state(struct adapter *adap,
 			      enum cxgb4_netdev_tls_ops op_val)
 {
 	switch (op_val) {
-#if defined(CONFIG_CHELSIO_TLS_DEVICE)
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 	case CXGB4_TLSDEV_OPS:
-		if (!adap->uld[CXGB4_ULD_CRYPTO].handle) {
-			dev_dbg(adap->pdev_dev, "chcr driver is not loaded\n");
+		if (!adap->uld[CXGB4_ULD_KTLS].handle) {
+			dev_dbg(adap->pdev_dev, "ch_ktls driver is not loaded\n");
 			return -EOPNOTSUPP;
 		}
-		if (!adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops) {
+		if (!adap->uld[CXGB4_ULD_KTLS].tlsdev_ops) {
 			dev_dbg(adap->pdev_dev,
-				"chcr driver has no registered tlsdev_ops\n");
+				"ch_ktls driver has no registered tlsdev_ops\n");
 			return -EOPNOTSUPP;
 		}
 		break;
@@ -6439,7 +6439,7 @@ static int chcr_offload_state(struct adapter *adap,
 
 #endif /* CONFIG_CHELSIO_TLS_DEVICE || CONFIG_CHELSIO_IPSEC_INLINE */
 
-#if defined(CONFIG_CHELSIO_TLS_DEVICE)
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 
 static int cxgb4_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 			      enum tls_offload_ctx_dir direction,
@@ -6458,10 +6458,10 @@ static int cxgb4_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	if (ret)
 		goto out_unlock;
 
-	ret = adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops->tls_dev_add(netdev, sk,
-								  direction,
-								  crypto_info,
-								  tcp_sn);
+	ret = adap->uld[CXGB4_ULD_KTLS].tlsdev_ops->tls_dev_add(netdev, sk,
+								direction,
+								crypto_info,
+								tcp_sn);
 	/* if there is a failure, clear the refcount */
 	if (ret)
 		cxgb4_set_ktls_feature(adap,
@@ -6481,14 +6481,20 @@ static void cxgb4_ktls_dev_del(struct net_device *netdev,
 	if (chcr_offload_state(adap, CXGB4_TLSDEV_OPS))
 		goto out_unlock;
 
-	adap->uld[CXGB4_ULD_CRYPTO].tlsdev_ops->tls_dev_del(netdev, tls_ctx,
-							    direction);
+	adap->uld[CXGB4_ULD_KTLS].tlsdev_ops->tls_dev_del(netdev, tls_ctx,
+							  direction);
 	cxgb4_set_ktls_feature(adap, FW_PARAMS_PARAM_DEV_KTLS_HW_DISABLE);
 
 out_unlock:
 	mutex_unlock(&uld_mutex);
 }
 
+static const struct tlsdev_ops cxgb4_ktls_ops = {
+	.tls_dev_add = cxgb4_ktls_dev_add,
+	.tls_dev_del = cxgb4_ktls_dev_del,
+};
+#endif /* CONFIG_CHELSIO_TLS_DEVICE */
+
 #if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
 
 static int cxgb4_xfrm_add_state(struct xfrm_state *x)
@@ -6597,12 +6603,6 @@ static const struct xfrmdev_ops cxgb4_xfrmdev_ops = {
 
 #endif /* CONFIG_CHELSIO_IPSEC_INLINE */
 
-static const struct tlsdev_ops cxgb4_ktls_ops = {
-	.tls_dev_add = cxgb4_ktls_dev_add,
-	.tls_dev_del = cxgb4_ktls_dev_del,
-};
-#endif /* CONFIG_CHELSIO_TLS_DEVICE */
-
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct net_device *netdev;
@@ -6855,7 +6855,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			netdev->hw_features |= NETIF_F_HIGHDMA;
 		netdev->features |= netdev->hw_features;
 		netdev->vlan_features = netdev->features & VLAN_FEAT;
-#if defined(CONFIG_CHELSIO_TLS_DEVICE)
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_TLS_HW) {
 			netdev->hw_features |= NETIF_F_HW_TLS_TX;
 			netdev->tlsdev_ops = &cxgb4_ktls_ops;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 08439e215efe..b154190e1ee2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -663,7 +663,7 @@ static int uld_attach(struct adapter *adap, unsigned int uld)
 	return 0;
 }
 
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 static bool cxgb4_uld_in_use(struct adapter *adap)
 {
 	const struct tid_info *t = &adap->tids;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 421ae87aa7db..ea2fabbdd934 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -40,6 +40,7 @@
 #include <linux/skbuff.h>
 #include <linux/inetdevice.h>
 #include <linux/atomic.h>
+#include <net/tls.h>
 #include "cxgb4.h"
 
 #define MAX_ULD_QSETS 16
@@ -304,6 +305,7 @@ enum cxgb4_uld {
 	CXGB4_ULD_CRYPTO,
 	CXGB4_ULD_IPSEC,
 	CXGB4_ULD_TLS,
+	CXGB4_ULD_KTLS,
 	CXGB4_ULD_MAX
 };
 
@@ -362,17 +364,8 @@ struct cxgb4_virt_res {                      /* virtualized HW resources */
 	struct cxgb4_range ppod_edram;
 };
 
-struct chcr_stats_debug {
-	atomic_t cipher_rqst;
-	atomic_t digest_rqst;
-	atomic_t aead_rqst;
-	atomic_t complete;
-	atomic_t error;
-	atomic_t fallback;
-	atomic_t tls_pdu_tx;
-	atomic_t tls_pdu_rx;
-	atomic_t tls_key;
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
+struct ch_ktls_stats_debug {
 	atomic64_t ktls_tx_connection_open;
 	atomic64_t ktls_tx_connection_fail;
 	atomic64_t ktls_tx_connection_close;
@@ -390,8 +383,19 @@ struct chcr_stats_debug {
 	atomic64_t ktls_tx_skip_no_sync_data;
 	atomic64_t ktls_tx_drop_no_sync_data;
 	atomic64_t ktls_tx_drop_bypass_req;
-
+};
 #endif
+
+struct chcr_stats_debug {
+	atomic_t cipher_rqst;
+	atomic_t digest_rqst;
+	atomic_t aead_rqst;
+	atomic_t complete;
+	atomic_t error;
+	atomic_t fallback;
+	atomic_t tls_pdu_tx;
+	atomic_t tls_pdu_rx;
+	atomic_t tls_key;
 };
 
 #if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
@@ -476,7 +480,7 @@ struct cxgb4_uld_info {
 			      struct napi_struct *napi);
 	void (*lro_flush)(struct t4_lro_mgr *);
 	int (*tx_handler)(struct sk_buff *skb, struct net_device *dev);
-#if IS_ENABLED(CONFIG_TLS_DEVICE)
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 	const struct tlsdev_ops *tlsdev_ops;
 #endif
 #if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index fddd70ee6436..437c054ef749 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1421,9 +1421,9 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 		return adap->uld[CXGB4_ULD_IPSEC].tx_handler(skb, dev);
 #endif /* CHELSIO_IPSEC_INLINE */
 
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 	if (skb->decrypted)
-		return adap->uld[CXGB4_ULD_CRYPTO].tx_handler(skb, dev);
+		return adap->uld[CXGB4_ULD_KTLS].tx_handler(skb, dev);
 #endif /* CHELSIO_TLS_DEVICE */
 
 	qidx = skb_get_queue_mapping(skb);
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/Kconfig b/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
index be70b59b6f80..1923e713b53a 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
+++ b/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
@@ -34,4 +34,17 @@ config CHELSIO_IPSEC_INLINE
         To compile this driver as a module, choose M here: the module
         will be called ch_ipsec.
 
+config CHELSIO_TLS_DEVICE
+        tristate "Chelsio Inline KTLS Offload"
+        depends on CHELSIO_T4
+        depends on TLS
+        depends on TLS_DEVICE
+        help
+          This flag enables support for kernel tls offload over Chelsio T6
+          crypto accelerator. CONFIG_CHELSIO_TLS_DEVICE flag can be enabled
+          only if CONFIG_TLS and CONFIG_TLS_DEVICE flags are enabled.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called ch_ktls.
+
 endif # CHELSIO_INLINE_CRYPTO
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/Makefile b/drivers/net/ethernet/chelsio/inline_crypto/Makefile
index 9a86ee8f1f38..27e6d7e2f1eb 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/Makefile
+++ b/drivers/net/ethernet/chelsio/inline_crypto/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO_TLS) += chtls/
 obj-$(CONFIG_CHELSIO_IPSEC_INLINE) += ch_ipsec/
+obj-$(CONFIG_CHELSIO_TLS_DEVICE) += ch_ktls/
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/Makefile b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/Makefile
new file mode 100644
index 000000000000..aee3ee884799
--- /dev/null
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+ccflags-y := -I $(srctree)/drivers/net/ethernet/chelsio/cxgb4
+
+obj-$(CONFIG_CHELSIO_TLS_DEVICE) += ch_ktls.o
+ch_ktls-objs := chcr_ktls.o
+
+
diff --git a/drivers/crypto/chelsio/chcr_common.h b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_common.h
similarity index 87%
rename from drivers/crypto/chelsio/chcr_common.h
rename to drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_common.h
index 33f589cbfba1..38319f4c3121 100644
--- a/drivers/crypto/chelsio/chcr_common.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_common.h
@@ -18,28 +18,6 @@
 #define CHCR_SCMD_AUTH_MODE_GHASH          4
 #define AES_BLOCK_LEN                      16
 
-enum chcr_state {
-	CHCR_INIT = 0,
-	CHCR_ATTACH,
-	CHCR_DETACH,
-};
-
-struct chcr_dev {
-	spinlock_t lock_chcr_dev; /* chcr dev structure lock */
-	enum chcr_state state;
-	atomic_t inflight;
-	int wqretry;
-	struct delayed_work detach_work;
-	struct completion detach_comp;
-	unsigned char tx_channel_id;
-};
-
-struct uld_ctx {
-	struct list_head entry;
-	struct cxgb4_lld_info lldi;
-	struct chcr_dev dev;
-};
-
 struct ktls_key_ctx {
 	__be32 ctx_hdr;
 	u8 salt[CHCR_MAX_SALT];
@@ -77,8 +55,6 @@ struct ktls_key_ctx {
 		      KEY_CONTEXT_SALT_PRESENT_F | \
 		      KEY_CONTEXT_CTX_LEN_V((ctx_len)))
 
-struct uld_ctx *assign_chcr_device(void);
-
 static inline void *chcr_copy_to_txd(const void *src, const struct sge_txq *q,
 				     void *pos, int length)
 {
diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
similarity index 92%
rename from drivers/crypto/chelsio/chcr_ktls.c
rename to drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index c5cce024886a..4609f1f78426 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1,10 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (C) 2020 Chelsio Communications.  All rights reserved. */
 
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/skbuff.h>
+#include <linux/module.h>
 #include <linux/highmem.h>
+#include <linux/ip.h>
+#include <net/ipv6.h>
+#include <linux/netdevice.h>
 #include "chcr_ktls.h"
-#include "clip_tbl.h"
+
+static LIST_HEAD(uld_ctx_list);
+static DEFINE_MUTEX(dev_mutex);
 
 static int chcr_init_tcb_fields(struct chcr_ktls_info *tx_info);
 /*
@@ -155,7 +163,7 @@ static int chcr_ktls_update_connection_state(struct chcr_ktls_info *tx_info,
 		/* Check if l2t state is valid, then move to ready state. */
 		if (cxgb4_check_l2t_valid(tx_info->l2te)) {
 			tx_info->connection_state = KTLS_CONN_TX_READY;
-			atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_ctx);
+			atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_ctx);
 		}
 		break;
 
@@ -381,9 +389,9 @@ static int chcr_ktls_mark_tcb_close(struct chcr_ktls_info *tx_info)
  * @tls_cts - tls context.
  * @direction - TX/RX crypto direction
  */
-void chcr_ktls_dev_del(struct net_device *netdev,
-		       struct tls_context *tls_ctx,
-		       enum tls_offload_ctx_dir direction)
+static void chcr_ktls_dev_del(struct net_device *netdev,
+			      struct tls_context *tls_ctx,
+			      enum tls_offload_ctx_dir direction)
 {
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx =
 				chcr_get_ktls_tx_context(tls_ctx);
@@ -418,7 +426,7 @@ void chcr_ktls_dev_del(struct net_device *netdev,
 				 tx_info->tid, tx_info->ip_family);
 	}
 
-	atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_connection_close);
+	atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_connection_close);
 	kvfree(tx_info);
 	tx_ctx->chcr_info = NULL;
 	/* release module refcount */
@@ -434,10 +442,10 @@ void chcr_ktls_dev_del(struct net_device *netdev,
  * @direction - TX/RX crypto direction
  * return: SUCCESS/FAILURE.
  */
-int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
-		      enum tls_offload_ctx_dir direction,
-		      struct tls_crypto_info *crypto_info,
-		      u32 start_offload_tcp_sn)
+static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
+			     enum tls_offload_ctx_dir direction,
+			     struct tls_crypto_info *crypto_info,
+			     u32 start_offload_tcp_sn)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
@@ -550,12 +558,12 @@ int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 		goto out2;
 	}
 
-	atomic64_inc(&adap->chcr_stats.ktls_tx_connection_open);
+	atomic64_inc(&adap->ch_ktls_stats.ktls_tx_connection_open);
 	return 0;
 out2:
 	kvfree(tx_info);
 out:
-	atomic64_inc(&adap->chcr_stats.ktls_tx_connection_fail);
+	atomic64_inc(&adap->ch_ktls_stats.ktls_tx_connection_fail);
 	return ret;
 }
 
@@ -603,7 +611,8 @@ static int chcr_init_tcb_fields(struct chcr_ktls_info *tx_info)
 /*
  * chcr_ktls_cpl_act_open_rpl: connection reply received from TP.
  */
-int chcr_ktls_cpl_act_open_rpl(struct adapter *adap, unsigned char *input)
+static int chcr_ktls_cpl_act_open_rpl(struct adapter *adap,
+				      unsigned char *input)
 {
 	const struct cpl_act_open_rpl *p = (void *)input;
 	struct chcr_ktls_info *tx_info = NULL;
@@ -638,7 +647,7 @@ int chcr_ktls_cpl_act_open_rpl(struct adapter *adap, unsigned char *input)
 /*
  * chcr_ktls_cpl_set_tcb_rpl: TCB reply received from TP.
  */
-int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input)
+static int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input)
 {
 	const struct cpl_set_tcb_rpl *p = (void *)input;
 	struct chcr_ktls_info *tx_info = NULL;
@@ -794,7 +803,7 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 						 TCB_SND_UNA_RAW_V
 						 (TCB_SND_UNA_RAW_M),
 						 TCB_SND_UNA_RAW_V(0), 0);
-		atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_ooo);
+		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_ooo);
 		cpl++;
 	}
 	/* update ack */
@@ -1222,7 +1231,7 @@ static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
 
 	chcr_txq_advance(&q->q, ndesc);
 	cxgb4_ring_tx_db(adap, &q->q, ndesc);
-	atomic64_inc(&adap->chcr_stats.ktls_tx_send_records);
+	atomic64_inc(&adap->ch_ktls_stats.ktls_tx_send_records);
 
 	return 0;
 }
@@ -1633,7 +1642,7 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 	/* check if it is a complete record */
 	if (tls_end_offset == record->len) {
 		nskb = skb;
-		atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_complete_pkts);
+		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_complete_pkts);
 	} else {
 		dev_kfree_skb_any(skb);
 
@@ -1651,7 +1660,7 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 		 */
 		if (chcr_ktls_update_snd_una(tx_info, q))
 			goto out;
-		atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_end_pkts);
+		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_end_pkts);
 	}
 
 	if (chcr_ktls_xmit_wr_complete(nskb, tx_info, q, tcp_seq,
@@ -1722,7 +1731,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 		/* free the last trimmed portion */
 		dev_kfree_skb_any(skb);
 		skb = tmp_skb;
-		atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_trimmed_pkts);
+		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_trimmed_pkts);
 	}
 	data_len = skb->data_len;
 	/* check if the middle record's start point is 16 byte aligned. CTR
@@ -1794,7 +1803,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 		 */
 		if (chcr_ktls_update_snd_una(tx_info, q))
 			goto out;
-		atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_middle_pkts);
+		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_middle_pkts);
 	} else {
 		/* Else means, its a partial first part of the record. Check if
 		 * its only the header, don't need to send for encryption then.
@@ -1809,7 +1818,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 			}
 			return 0;
 		}
-		atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_start_pkts);
+		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_start_pkts);
 	}
 
 	if (chcr_ktls_xmit_wr_short(skb, tx_info, q, tcp_seq, tcp_push_no_fin,
@@ -1825,13 +1834,13 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 }
 
 /* nic tls TX handler */
-int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
+static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
+	struct ch_ktls_stats_debug *stats;
 	struct tcphdr *th = tcp_hdr(skb);
 	int data_len, qidx, ret = 0, mss;
 	struct tls_record_info *record;
-	struct chcr_stats_debug *stats;
 	struct chcr_ktls_info *tx_info;
 	u32 tls_end_offset, tcp_seq;
 	struct tls_context *tls_ctx;
@@ -1877,7 +1886,7 @@ int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 
 	adap = tx_info->adap;
-	stats = &adap->chcr_stats;
+	stats = &adap->ch_ktls_stats;
 
 	qidx = skb->queue_mapping;
 	q = &adap->sge.ethtxq[qidx + tx_info->first_qset];
@@ -2014,4 +2023,117 @@ int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
-#endif /* CONFIG_CHELSIO_TLS_DEVICE */
+
+static void *chcr_ktls_uld_add(const struct cxgb4_lld_info *lldi)
+{
+	struct chcr_ktls_uld_ctx *u_ctx;
+
+	pr_info_once("%s - version %s\n", CHCR_KTLS_DRV_DESC,
+		     CHCR_KTLS_DRV_VERSION);
+	u_ctx = kzalloc(sizeof(*u_ctx), GFP_KERNEL);
+	if (!u_ctx) {
+		u_ctx = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+	u_ctx->lldi = *lldi;
+out:
+	return u_ctx;
+}
+
+static const struct tlsdev_ops chcr_ktls_ops = {
+	.tls_dev_add = chcr_ktls_dev_add,
+	.tls_dev_del = chcr_ktls_dev_del,
+};
+
+static chcr_handler_func work_handlers[NUM_CPL_CMDS] = {
+	[CPL_ACT_OPEN_RPL] = chcr_ktls_cpl_act_open_rpl,
+	[CPL_SET_TCB_RPL] = chcr_ktls_cpl_set_tcb_rpl,
+};
+
+static int chcr_ktls_uld_rx_handler(void *handle, const __be64 *rsp,
+				    const struct pkt_gl *pgl)
+{
+	const struct cpl_act_open_rpl *rpl = (struct cpl_act_open_rpl *)rsp;
+	struct chcr_ktls_uld_ctx *u_ctx = handle;
+	u8 opcode = rpl->ot.opcode;
+	struct adapter *adap;
+
+	adap = pci_get_drvdata(u_ctx->lldi.pdev);
+
+	if (!work_handlers[opcode]) {
+		pr_err("Unsupported opcode %d received\n", opcode);
+		return 0;
+	}
+
+	work_handlers[opcode](adap, (unsigned char *)&rsp[1]);
+	return 0;
+}
+
+static int chcr_ktls_uld_state_change(void *handle, enum cxgb4_state new_state)
+{
+	struct chcr_ktls_uld_ctx *u_ctx = handle;
+
+	switch (new_state) {
+	case CXGB4_STATE_UP:
+		pr_info("%s: Up\n", pci_name(u_ctx->lldi.pdev));
+		mutex_lock(&dev_mutex);
+		list_add_tail(&u_ctx->entry, &uld_ctx_list);
+		mutex_unlock(&dev_mutex);
+		break;
+	case CXGB4_STATE_START_RECOVERY:
+	case CXGB4_STATE_DOWN:
+	case CXGB4_STATE_DETACH:
+		pr_info("%s: Down\n", pci_name(u_ctx->lldi.pdev));
+		mutex_lock(&dev_mutex);
+		list_del(&u_ctx->entry);
+		mutex_unlock(&dev_mutex);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static struct cxgb4_uld_info chcr_ktls_uld_info = {
+	.name = CHCR_KTLS_DRV_MODULE_NAME,
+	.nrxq = 1,
+	.rxq_size = 1024,
+	.add = chcr_ktls_uld_add,
+	.tx_handler = chcr_ktls_xmit,
+	.rx_handler = chcr_ktls_uld_rx_handler,
+	.state_change = chcr_ktls_uld_state_change,
+	.tlsdev_ops = &chcr_ktls_ops,
+};
+
+static int __init chcr_ktls_init(void)
+{
+	cxgb4_register_uld(CXGB4_ULD_KTLS, &chcr_ktls_uld_info);
+	return 0;
+}
+
+static void __exit chcr_ktls_exit(void)
+{
+	struct chcr_ktls_uld_ctx *u_ctx, *tmp;
+	struct adapter *adap;
+
+	pr_info("driver unloaded\n");
+
+	mutex_lock(&dev_mutex);
+	list_for_each_entry_safe(u_ctx, tmp, &uld_ctx_list, entry) {
+		adap = pci_get_drvdata(u_ctx->lldi.pdev);
+		memset(&adap->ch_ktls_stats, 0, sizeof(adap->ch_ktls_stats));
+		list_del(&u_ctx->entry);
+		kfree(u_ctx);
+	}
+	mutex_unlock(&dev_mutex);
+	cxgb4_unregister_uld(CXGB4_ULD_KTLS);
+}
+
+module_init(chcr_ktls_init);
+module_exit(chcr_ktls_exit);
+
+MODULE_DESCRIPTION("Chelsio NIC TLS ULD driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Chelsio Communications");
+MODULE_VERSION(CHCR_KTLS_DRV_VERSION);
diff --git a/drivers/crypto/chelsio/chcr_ktls.h b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h
similarity index 74%
rename from drivers/crypto/chelsio/chcr_ktls.h
rename to drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h
index 5cbd84b1da05..4ae6ae38c406 100644
--- a/drivers/crypto/chelsio/chcr_ktls.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h
@@ -4,14 +4,17 @@
 #ifndef __CHCR_KTLS_H__
 #define __CHCR_KTLS_H__
 
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
-#include <net/tls.h>
 #include "cxgb4.h"
 #include "t4_msg.h"
 #include "t4_tcb.h"
 #include "l2t.h"
 #include "chcr_common.h"
 #include "cxgb4_uld.h"
+#include "clip_tbl.h"
+
+#define CHCR_KTLS_DRV_MODULE_NAME "ch_ktls"
+#define CHCR_KTLS_DRV_VERSION "1.0.0.0-ko"
+#define CHCR_KTLS_DRV_DESC "Chelsio NIC TLS ULD Driver"
 
 #define CHCR_TCB_STATE_CLOSED	0
 #define CHCR_KTLS_KEY_CTX_LEN	16
@@ -69,6 +72,11 @@ struct chcr_ktls_ofld_ctx_tx {
 	struct chcr_ktls_info *chcr_info;
 };
 
+struct chcr_ktls_uld_ctx {
+	struct list_head entry;
+	struct cxgb4_lld_info lldi;
+};
+
 static inline struct chcr_ktls_ofld_ctx_tx *
 chcr_get_ktls_tx_context(struct tls_context *tls_ctx)
 {
@@ -82,22 +90,12 @@ chcr_get_ktls_tx_context(struct tls_context *tls_ctx)
 static inline int chcr_get_first_rx_qid(struct adapter *adap)
 {
 	/* u_ctx is saved in adap, fetch it */
-	struct uld_ctx *u_ctx = adap->uld[CXGB4_ULD_CRYPTO].handle;
+	struct chcr_ktls_uld_ctx *u_ctx = adap->uld[CXGB4_ULD_KTLS].handle;
 
 	if (!u_ctx)
 		return -1;
 	return u_ctx->lldi.rxq_ids[0];
 }
 
-int chcr_ktls_cpl_act_open_rpl(struct adapter *adap, unsigned char *input);
-int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input);
-int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev);
-int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
-		      enum tls_offload_ctx_dir direction,
-		      struct tls_crypto_info *crypto_info,
-		      u32 start_offload_tcp_sn);
-void chcr_ktls_dev_del(struct net_device *netdev,
-		       struct tls_context *tls_ctx,
-		       enum tls_offload_ctx_dir direction);
-#endif /* CONFIG_CHELSIO_TLS_DEVICE */
+typedef int (*chcr_handler_func)(struct adapter *adap, unsigned char *input);
 #endif /* __CHCR_KTLS_H__ */
-- 
2.18.1

