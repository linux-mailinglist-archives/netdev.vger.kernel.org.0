Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9020824A106
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 16:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgHSOCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:02:47 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:44350 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgHSOCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 10:02:13 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 07JE1bcQ027304;
        Wed, 19 Aug 2020 07:01:51 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 2/2] crypto/chcr: Moving chelsio's inline ipsec functionality to /drivers/net
Date:   Wed, 19 Aug 2020 19:31:21 +0530
Message-Id: <20200819140121.20175-3-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200819140121.20175-1-vinay.yadav@chelsio.com>
References: <20200819140121.20175-1-vinay.yadav@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch seperates inline ipsec functionality from coprocessor
driver chcr. Now inline ipsec is separate ULD, moved from
"drivers/crypto/chelsio/" to "drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/"

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/Kconfig                |  10 --
 drivers/crypto/chelsio/Makefile               |   1 -
 drivers/crypto/chelsio/chcr_core.c            |  42 +------
 drivers/crypto/chelsio/chcr_core.h            |  31 -----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   3 +
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |   7 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   8 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |   4 +-
 .../ethernet/chelsio/inline_crypto/Kconfig    |  12 ++
 .../ethernet/chelsio/inline_crypto/Makefile   |   1 +
 .../chelsio/inline_crypto/ch_ipsec/Makefile   |   8 ++
 .../inline_crypto/ch_ipsec}/chcr_ipsec.c      | 111 +++++++++++++++++-
 .../inline_crypto/ch_ipsec/chcr_ipsec.h       |  58 +++++++++
 13 files changed, 205 insertions(+), 91 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/Makefile
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto/ch_ipsec}/chcr_ipsec.c (88%)
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.h

diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index 89e1d030aada..af161dab49bd 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -22,16 +22,6 @@ config CRYPTO_DEV_CHELSIO
 	  To compile this driver as a module, choose M here: the module
 	  will be called chcr.
 
-config CHELSIO_IPSEC_INLINE
-	bool "Chelsio IPSec XFRM Tx crypto offload"
-	depends on CHELSIO_T4
-	depends on CRYPTO_DEV_CHELSIO
-	depends on XFRM_OFFLOAD
-	depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
-	default n
-	help
-	  Enable support for IPSec Tx Inline.
-
 config CHELSIO_TLS_DEVICE
 	bool "Chelsio Inline KTLS Offload"
 	depends on CHELSIO_T4
diff --git a/drivers/crypto/chelsio/Makefile b/drivers/crypto/chelsio/Makefile
index 8aeffde4bcde..f2e8e2fb4e60 100644
--- a/drivers/crypto/chelsio/Makefile
+++ b/drivers/crypto/chelsio/Makefile
@@ -6,4 +6,3 @@ chcr-objs :=  chcr_core.o chcr_algo.o
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
 chcr-objs += chcr_ktls.o
 #endif
-chcr-$(CONFIG_CHELSIO_IPSEC_INLINE) += chcr_ipsec.o
diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index bd8dac806e7a..b3570b41a737 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -40,10 +40,6 @@ static const struct tlsdev_ops chcr_ktls_ops = {
 };
 #endif
 
-#ifdef CONFIG_CHELSIO_IPSEC_INLINE
-static void update_netdev_features(void);
-#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
-
 static chcr_handler_func work_handlers[NUM_CPL_CMDS] = {
 	[CPL_FW6_PLD] = cpl_fw6_pld_handler,
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
@@ -60,10 +56,8 @@ static struct cxgb4_uld_info chcr_uld_info = {
 	.add = chcr_uld_add,
 	.state_change = chcr_uld_state_change,
 	.rx_handler = chcr_uld_rx_handler,
-#if defined(CONFIG_CHELSIO_IPSEC_INLINE) || defined(CONFIG_CHELSIO_TLS_DEVICE)
-	.tx_handler = chcr_uld_tx_handler,
-#endif /* CONFIG_CHELSIO_IPSEC_INLINE || CONFIG_CHELSIO_TLS_DEVICE */
 #if defined(CONFIG_CHELSIO_TLS_DEVICE)
+	.tx_handler = chcr_uld_tx_handler,
 	.tlsdev_ops = &chcr_ktls_ops,
 #endif
 };
@@ -241,19 +235,11 @@ int chcr_uld_rx_handler(void *handle, const __be64 *rsp,
 	return 0;
 }
 
-#if defined(CONFIG_CHELSIO_IPSEC_INLINE) || defined(CONFIG_CHELSIO_TLS_DEVICE)
+#if defined(CONFIG_CHELSIO_TLS_DEVICE)
 int chcr_uld_tx_handler(struct sk_buff *skb, struct net_device *dev)
 {
-	/* In case if skb's decrypted bit is set, it's nic tls packet, else it's
-	 * ipsec packet.
-	 */
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
 	if (skb->decrypted)
 		return chcr_ktls_xmit(skb, dev);
-#endif
-#ifdef CONFIG_CHELSIO_IPSEC_INLINE
-	return chcr_ipsec_xmit(skb, dev);
-#endif
 	return 0;
 }
 #endif /* CONFIG_CHELSIO_IPSEC_INLINE || CONFIG_CHELSIO_TLS_DEVICE */
@@ -305,24 +291,6 @@ static int chcr_uld_state_change(void *handle, enum cxgb4_state state)
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
@@ -332,12 +300,6 @@ static int __init chcr_crypto_init(void)
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
index 73239aa3fc5f..81f6e61401e5 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -109,37 +109,6 @@ struct uld_ctx {
 	struct chcr_dev dev;
 };
 
-struct chcr_ipsec_req {
-	struct ulp_txpkt ulptx;
-	struct ulptx_idata sc_imm;
-	struct cpl_tx_sec_pdu sec_cpl;
-	struct _key_ctx key_ctx;
-};
-
-struct chcr_ipsec_wr {
-	struct fw_ulptx_wr wreq;
-	struct chcr_ipsec_req req;
-};
-
-#define ESN_IV_INSERT_OFFSET 12
-struct chcr_ipsec_aadiv {
-	__be32 spi;
-	u8 seq_no[8];
-	u8 iv[8];
-};
-
-struct ipsec_sa_entry {
-	int hmac_ctrl;
-	u16 esn;
-	u16 resv;
-	unsigned int enckey_len;
-	unsigned int kctx_len;
-	unsigned int authsize;
-	__be32 key_ctx_hdr;
-	char salt[MAX_SALT];
-	char key[2 * AES_MAX_KEY_SIZE];
-};
-
 /*
  *      sgl_len - calculates the size of an SGL of the given capacity
  *      @n: the number of SGL entries
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 9cb8b229c1b3..e5d5c0fb7f47 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1196,6 +1196,9 @@ struct adapter {
 	struct cxgb4_tc_u32_table *tc_u32;
 	struct chcr_ktls chcr_ktls;
 	struct chcr_stats_debug chcr_stats;
+#if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
+	struct ch_ipsec_stats_debug ch_ipsec_stats;
+#endif
 
 	/* TC flower offload */
 	bool tc_flower_initialized;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 05f33b7e3677..42112e8ad687 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3542,14 +3542,17 @@ static int chcr_stats_show(struct seq_file *seq, void *v)
 		   atomic_read(&adap->chcr_stats.error));
 	seq_printf(seq, "Fallback: %10u \n",
 		   atomic_read(&adap->chcr_stats.fallback));
-	seq_printf(seq, "IPSec PDU: %10u\n",
-		   atomic_read(&adap->chcr_stats.ipsec_cnt));
 	seq_printf(seq, "TLS PDU Tx: %10u\n",
 		   atomic_read(&adap->chcr_stats.tls_pdu_tx));
 	seq_printf(seq, "TLS PDU Rx: %10u\n",
 		   atomic_read(&adap->chcr_stats.tls_pdu_rx));
 	seq_printf(seq, "TLS Keys (DDR) Count: %10u\n",
 		   atomic_read(&adap->chcr_stats.tls_key));
+#if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
+	seq_puts(seq, "\nChelsio Inline IPsec Crypto Accelerator Stats\n");
+	seq_printf(seq, "IPSec PDU: %10u\n",
+		   atomic_read(&adap->ch_ipsec_stats.ipsec_cnt));
+#endif
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
 	seq_puts(seq, "\nChelsio KTLS Crypto Accelerator Stats\n");
 	seq_printf(seq, "Tx TLS offload refcount:          %20u\n",
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index a963fd0b4540..83c8189e4088 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -302,6 +302,7 @@ enum cxgb4_uld {
 	CXGB4_ULD_ISCSI,
 	CXGB4_ULD_ISCSIT,
 	CXGB4_ULD_CRYPTO,
+	CXGB4_ULD_IPSEC,
 	CXGB4_ULD_TLS,
 	CXGB4_ULD_MAX
 };
@@ -368,7 +369,6 @@ struct chcr_stats_debug {
 	atomic_t complete;
 	atomic_t error;
 	atomic_t fallback;
-	atomic_t ipsec_cnt;
 	atomic_t tls_pdu_tx;
 	atomic_t tls_pdu_rx;
 	atomic_t tls_key;
@@ -394,6 +394,12 @@ struct chcr_stats_debug {
 #endif
 };
 
+#if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
+struct ch_ipsec_stats_debug {
+	atomic_t ipsec_cnt;
+};
+#endif
+
 #define OCQ_WIN_OFFSET(pdev, vres) \
 	(pci_resource_len((pdev), 2) - roundup_pow_of_two((vres)->ocq.size))
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index d2b587d1670a..022b1058b7b3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1416,9 +1416,9 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	pi = netdev_priv(dev);
 	adap = pi->adapter;
 	ssi = skb_shinfo(skb);
-#ifdef CONFIG_CHELSIO_IPSEC_INLINE
+#if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
 	if (xfrm_offload(skb) && !ssi->gso_size)
-		return adap->uld[CXGB4_ULD_CRYPTO].tx_handler(skb, dev);
+		return adap->uld[CXGB4_ULD_IPSEC].tx_handler(skb, dev);
 #endif /* CHELSIO_IPSEC_INLINE */
 
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/Kconfig b/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
index cbe9f1b69e3f..a3ef057031e4 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
+++ b/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
@@ -23,4 +23,16 @@ config CRYPTO_DEV_CHELSIO_TLS
 	  To compile this driver as a module, choose M here: the module
 	  will be called chtls.
 
+config CHELSIO_IPSEC_INLINE
+       tristate "Chelsio IPSec XFRM Tx crypto offload"
+       depends on CHELSIO_T4
+       depends on XFRM_OFFLOAD
+       depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
+       help
+        Support Chelsio Inline IPsec with Chelsio crypto accelerator.
+        Enable inline IPsec support for Tx.
+
+        To compile this driver as a module, choose M here: the module
+        will be called ch_ipsec.
+
 endif # CHELSIO_INLINE_CRYPTO
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/Makefile b/drivers/net/ethernet/chelsio/inline_crypto/Makefile
index 8c1fb2cc9835..9a86ee8f1f38 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/Makefile
+++ b/drivers/net/ethernet/chelsio/inline_crypto/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO_TLS) += chtls/
+obj-$(CONFIG_CHELSIO_IPSEC_INLINE) += ch_ipsec/
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/Makefile b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/Makefile
new file mode 100644
index 000000000000..efdcaaebc455
--- /dev/null
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+ccflags-y := -I $(srctree)/drivers/net/ethernet/chelsio/cxgb4 \
+             -I $(srctree)/drivers/crypto/chelsio
+
+obj-$(CONFIG_CHELSIO_IPSEC_INLINE) += ch_ipsec.o
+ch_ipsec-objs := chcr_ipsec.o
+
+
diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
similarity index 88%
rename from drivers/crypto/chelsio/chcr_ipsec.c
rename to drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
index 967babd67a51..276f8841becc 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
@@ -60,9 +60,7 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/hash.h>
 
-#include "chcr_core.h"
-#include "chcr_algo.h"
-#include "chcr_crypto.h"
+#include "chcr_ipsec.h"
 
 /*
  * Max Tx descriptor space we allow for an Ethernet packet to be inlined
@@ -71,11 +69,17 @@
 #define MAX_IMM_TX_PKT_LEN 256
 #define GCM_ESP_IV_SIZE     8
 
+static LIST_HEAD(uld_ctx_list);
+static DEFINE_MUTEX(dev_mutex);
+
 static int chcr_xfrm_add_state(struct xfrm_state *x);
 static void chcr_xfrm_del_state(struct xfrm_state *x);
 static void chcr_xfrm_free_state(struct xfrm_state *x);
 static bool chcr_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
 static void chcr_advance_esn_state(struct xfrm_state *x);
+static int ch_ipsec_uld_state_change(void *handle, enum cxgb4_state new_state);
+static void *ch_ipsec_uld_add(const struct cxgb4_lld_info *infop);
+static void update_netdev_features(void);
 
 static const struct xfrmdev_ops chcr_xfrmdev_ops = {
 	.xdo_dev_state_add      = chcr_xfrm_add_state,
@@ -102,6 +106,57 @@ void chcr_add_xfrmops(const struct cxgb4_lld_info *lld)
 	}
 }
 
+static struct cxgb4_uld_info ch_ipsec_uld_info = {
+	.name = CHIPSEC_DRV_MODULE_NAME,
+	.nrxq = MAX_ULD_QSETS,
+	/* Max ntxq will be derived from fw config file*/
+	.rxq_size = 1024,
+	.add = ch_ipsec_uld_add,
+	.state_change = ch_ipsec_uld_state_change,
+	.tx_handler = chcr_ipsec_xmit,
+};
+
+static void *ch_ipsec_uld_add(const struct cxgb4_lld_info *infop)
+{
+	struct ipsec_uld_ctx *u_ctx;
+
+	pr_info_once("%s - version %s\n", CHIPSEC_DRV_DESC,
+		     CHIPSEC_DRV_VERSION);
+	u_ctx = kzalloc(sizeof(*u_ctx), GFP_KERNEL);
+	if (!u_ctx) {
+		u_ctx = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+	u_ctx->lldi = *infop;
+out:
+	return u_ctx;
+}
+
+static int ch_ipsec_uld_state_change(void *handle, enum cxgb4_state new_state)
+{
+	struct ipsec_uld_ctx *u_ctx = handle;
+
+	pr_info("new_state %u\n", new_state);
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
+		list_del(&u_ctx->entry);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static inline int chcr_ipsec_setauthsize(struct xfrm_state *x,
 					 struct ipsec_sa_entry *sa_entry)
 {
@@ -538,7 +593,7 @@ inline void *chcr_crypto_wreq(struct sk_buff *skb,
 	unsigned int kctx_len = sa_entry->kctx_len;
 	int qid = q->q.cntxt_id;
 
-	atomic_inc(&adap->chcr_stats.ipsec_cnt);
+	atomic_inc(&adap->ch_ipsec_stats.ipsec_cnt);
 
 	flits = calc_tx_sec_flits(skb, sa_entry, &immediate);
 	ndesc = DIV_ROUND_UP(flits, 2);
@@ -752,3 +807,51 @@ out_free:       dev_kfree_skb_any(skb);
 	cxgb4_ring_tx_db(adap, &q->q, ndesc);
 	return NETDEV_TX_OK;
 }
+
+static void update_netdev_features(void)
+{
+	struct ipsec_uld_ctx *u_ctx, *tmp;
+
+	mutex_lock(&dev_mutex);
+	list_for_each_entry_safe(u_ctx, tmp, &uld_ctx_list, entry) {
+		if (u_ctx->lldi.crypto & ULP_CRYPTO_IPSEC_INLINE)
+			chcr_add_xfrmops(&u_ctx->lldi);
+	}
+	mutex_unlock(&dev_mutex);
+}
+
+static int __init chcr_ipsec_init(void)
+{
+	cxgb4_register_uld(CXGB4_ULD_IPSEC, &ch_ipsec_uld_info);
+
+	rtnl_lock();
+	update_netdev_features();
+	rtnl_unlock();
+
+	return 0;
+}
+
+static void __exit chcr_ipsec_exit(void)
+{
+	struct ipsec_uld_ctx *u_ctx, *tmp;
+	struct adapter *adap;
+
+	mutex_lock(&dev_mutex);
+	list_for_each_entry_safe(u_ctx, tmp, &uld_ctx_list, entry) {
+		adap = pci_get_drvdata(u_ctx->lldi.pdev);
+		atomic_set(&adap->ch_ipsec_stats.ipsec_cnt, 0);
+		list_del(&u_ctx->entry);
+		kfree(u_ctx);
+	}
+	mutex_unlock(&dev_mutex);
+	cxgb4_unregister_uld(CXGB4_ULD_IPSEC);
+}
+
+module_init(chcr_ipsec_init);
+module_exit(chcr_ipsec_exit);
+
+MODULE_DESCRIPTION("Crypto IPSEC for Chelsio Terminator cards.");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Chelsio Communications");
+MODULE_VERSION(CHIPSEC_DRV_VERSION);
+
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.h b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.h
new file mode 100644
index 000000000000..1d110d2edd64
--- /dev/null
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2018 Chelsio Communications, Inc. */
+
+#ifndef __CHCR_IPSEC_H__
+#define __CHCR_IPSEC_H__
+
+#include <crypto/algapi.h>
+#include "t4_hw.h"
+#include "cxgb4.h"
+#include "t4_msg.h"
+#include "cxgb4_uld.h"
+
+#include "chcr_core.h"
+#include "chcr_algo.h"
+#include "chcr_crypto.h"
+
+#define CHIPSEC_DRV_MODULE_NAME "ch_ipsec"
+#define CHIPSEC_DRV_VERSION "1.0.0.0-ko"
+#define CHIPSEC_DRV_DESC "Chelsio T6 Crypto Ipsec offload Driver"
+
+struct ipsec_uld_ctx {
+	struct list_head entry;
+	struct cxgb4_lld_info lldi;
+};
+
+struct chcr_ipsec_req {
+	struct ulp_txpkt ulptx;
+	struct ulptx_idata sc_imm;
+	struct cpl_tx_sec_pdu sec_cpl;
+	struct _key_ctx key_ctx;
+};
+
+struct chcr_ipsec_wr {
+	struct fw_ulptx_wr wreq;
+	struct chcr_ipsec_req req;
+};
+
+#define ESN_IV_INSERT_OFFSET 12
+struct chcr_ipsec_aadiv {
+	__be32 spi;
+	u8 seq_no[8];
+	u8 iv[8];
+};
+
+struct ipsec_sa_entry {
+	int hmac_ctrl;
+	u16 esn;
+	u16 resv;
+	unsigned int enckey_len;
+	unsigned int kctx_len;
+	unsigned int authsize;
+	__be32 key_ctx_hdr;
+	char salt[MAX_SALT];
+	char key[2 * AES_MAX_KEY_SIZE];
+};
+
+#endif /* __CHCR_IPSEC_H__ */
+
-- 
2.18.1

