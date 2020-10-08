Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56257287681
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 16:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730758AbgJHO4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 10:56:47 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:11691 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730641AbgJHO4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 10:56:47 -0400
X-Greylist: delayed 3350 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2020 10:56:47 EDT
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 098E0lSQ026559;
        Thu, 8 Oct 2020 07:00:48 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, secdev@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next] cxgb4/ch_ipsec: Replace the module name to ch_ipsec from chcr
Date:   Thu,  8 Oct 2020 19:30:15 +0530
Message-Id: <20201008140016.17918-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the module name to "ch_ipsec" and prepends
"ch_ipsec" string instead of "chcr" in all debug messages and
function names.

Fixes: 1b77be463929 ("crypto/chcr: Moving chelsio's inline ipsec functionality to /drivers/net")
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_core.h            |  2 -
 .../inline_crypto/ch_ipsec/chcr_ipsec.c       | 97 ++++++++++---------
 2 files changed, 49 insertions(+), 50 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index bb092b6b36b2..b02f981e7c32 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -137,6 +137,4 @@ int chcr_uld_rx_handler(void *handle, const __be64 *rsp,
 int chcr_uld_tx_handler(struct sk_buff *skb, struct net_device *dev);
 int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
 		     int err);
-int chcr_ipsec_xmit(struct sk_buff *skb, struct net_device *dev);
-void chcr_add_xfrmops(const struct cxgb4_lld_info *lld);
 #endif /* __CHCR_CORE_H__ */
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
index 0e7d25169407..76ce393d37d0 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
@@ -35,7 +35,7 @@
  *	Atul Gupta (atul.gupta@chelsio.com)
  */
 
-#define pr_fmt(fmt) "chcr:" fmt
+#define pr_fmt(fmt) "ch_ipsec: " fmt
 
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -72,20 +72,21 @@
 static LIST_HEAD(uld_ctx_list);
 static DEFINE_MUTEX(dev_mutex);
 
-static int chcr_xfrm_add_state(struct xfrm_state *x);
-static void chcr_xfrm_del_state(struct xfrm_state *x);
-static void chcr_xfrm_free_state(struct xfrm_state *x);
-static bool chcr_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
-static void chcr_advance_esn_state(struct xfrm_state *x);
+static bool ch_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
 static int ch_ipsec_uld_state_change(void *handle, enum cxgb4_state new_state);
+static int ch_ipsec_xmit(struct sk_buff *skb, struct net_device *dev);
 static void *ch_ipsec_uld_add(const struct cxgb4_lld_info *infop);
-
-static const struct xfrmdev_ops chcr_xfrmdev_ops = {
-	.xdo_dev_state_add      = chcr_xfrm_add_state,
-	.xdo_dev_state_delete   = chcr_xfrm_del_state,
-	.xdo_dev_state_free     = chcr_xfrm_free_state,
-	.xdo_dev_offload_ok     = chcr_ipsec_offload_ok,
-	.xdo_dev_state_advance_esn = chcr_advance_esn_state,
+static void ch_ipsec_advance_esn_state(struct xfrm_state *x);
+static void ch_ipsec_xfrm_free_state(struct xfrm_state *x);
+static void ch_ipsec_xfrm_del_state(struct xfrm_state *x);
+static int ch_ipsec_xfrm_add_state(struct xfrm_state *x);
+
+static const struct xfrmdev_ops ch_ipsec_xfrmdev_ops = {
+	.xdo_dev_state_add      = ch_ipsec_xfrm_add_state,
+	.xdo_dev_state_delete   = ch_ipsec_xfrm_del_state,
+	.xdo_dev_state_free     = ch_ipsec_xfrm_free_state,
+	.xdo_dev_offload_ok     = ch_ipsec_offload_ok,
+	.xdo_dev_state_advance_esn = ch_ipsec_advance_esn_state,
 };
 
 static struct cxgb4_uld_info ch_ipsec_uld_info = {
@@ -95,8 +96,8 @@ static struct cxgb4_uld_info ch_ipsec_uld_info = {
 	.rxq_size = 1024,
 	.add = ch_ipsec_uld_add,
 	.state_change = ch_ipsec_uld_state_change,
-	.tx_handler = chcr_ipsec_xmit,
-	.xfrmdev_ops = &chcr_xfrmdev_ops,
+	.tx_handler = ch_ipsec_xmit,
+	.xfrmdev_ops = &ch_ipsec_xfrmdev_ops,
 };
 
 static void *ch_ipsec_uld_add(const struct cxgb4_lld_info *infop)
@@ -119,7 +120,7 @@ static int ch_ipsec_uld_state_change(void *handle, enum cxgb4_state new_state)
 {
 	struct ipsec_uld_ctx *u_ctx = handle;
 
-	pr_info("new_state %u\n", new_state);
+	pr_debug("new_state %u\n", new_state);
 	switch (new_state) {
 	case CXGB4_STATE_UP:
 		pr_info("%s: Up\n", pci_name(u_ctx->lldi.pdev));
@@ -140,8 +141,8 @@ static int ch_ipsec_uld_state_change(void *handle, enum cxgb4_state new_state)
 	return 0;
 }
 
-static inline int chcr_ipsec_setauthsize(struct xfrm_state *x,
-					 struct ipsec_sa_entry *sa_entry)
+static inline int ch_ipsec_setauthsize(struct xfrm_state *x,
+				       struct ipsec_sa_entry *sa_entry)
 {
 	int hmac_ctrl;
 	int authsize = x->aead->alg_icv_len / 8;
@@ -164,8 +165,8 @@ static inline int chcr_ipsec_setauthsize(struct xfrm_state *x,
 	return hmac_ctrl;
 }
 
-static inline int chcr_ipsec_setkey(struct xfrm_state *x,
-				    struct ipsec_sa_entry *sa_entry)
+static inline int ch_ipsec_setkey(struct xfrm_state *x,
+				  struct ipsec_sa_entry *sa_entry)
 {
 	int keylen = (x->aead->alg_key_len + 7) / 8;
 	unsigned char *key = x->aead->alg_key;
@@ -223,65 +224,65 @@ static inline int chcr_ipsec_setkey(struct xfrm_state *x,
 }
 
 /*
- * chcr_xfrm_add_state
+ * ch_ipsec_xfrm_add_state
  * returns 0 on success, negative error if failed to send message to FPGA
  * positive error if FPGA returned a bad response
  */
-static int chcr_xfrm_add_state(struct xfrm_state *x)
+static int ch_ipsec_xfrm_add_state(struct xfrm_state *x)
 {
 	struct ipsec_sa_entry *sa_entry;
 	int res = 0;
 
 	if (x->props.aalgo != SADB_AALG_NONE) {
-		pr_debug("CHCR: Cannot offload authenticated xfrm states\n");
+		pr_debug("CH_IPSEC: Cannot offload authenticated xfrm states\n");
 		return -EINVAL;
 	}
 	if (x->props.calgo != SADB_X_CALG_NONE) {
-		pr_debug("CHCR: Cannot offload compressed xfrm states\n");
+		pr_debug("CH_IPSEC: Cannot offload compressed xfrm states\n");
 		return -EINVAL;
 	}
 	if (x->props.family != AF_INET &&
 	    x->props.family != AF_INET6) {
-		pr_debug("CHCR: Only IPv4/6 xfrm state offloaded\n");
+		pr_debug("CH_IPSEC: Only IPv4/6 xfrm state offloaded\n");
 		return -EINVAL;
 	}
 	if (x->props.mode != XFRM_MODE_TRANSPORT &&
 	    x->props.mode != XFRM_MODE_TUNNEL) {
-		pr_debug("CHCR: Only transport and tunnel xfrm offload\n");
+		pr_debug("CH_IPSEC: Only transport and tunnel xfrm offload\n");
 		return -EINVAL;
 	}
 	if (x->id.proto != IPPROTO_ESP) {
-		pr_debug("CHCR: Only ESP xfrm state offloaded\n");
+		pr_debug("CH_IPSEC: Only ESP xfrm state offloaded\n");
 		return -EINVAL;
 	}
 	if (x->encap) {
-		pr_debug("CHCR: Encapsulated xfrm state not offloaded\n");
+		pr_debug("CH_IPSEC: Encapsulated xfrm state not offloaded\n");
 		return -EINVAL;
 	}
 	if (!x->aead) {
-		pr_debug("CHCR: Cannot offload xfrm states without aead\n");
+		pr_debug("CH_IPSEC: Cannot offload xfrm states without aead\n");
 		return -EINVAL;
 	}
 	if (x->aead->alg_icv_len != 128 &&
 	    x->aead->alg_icv_len != 96) {
-		pr_debug("CHCR: Cannot offload xfrm states with AEAD ICV length other than 96b & 128b\n");
+		pr_debug("CH_IPSEC: Cannot offload xfrm states with AEAD ICV length other than 96b & 128b\n");
 	return -EINVAL;
 	}
 	if ((x->aead->alg_key_len != 128 + 32) &&
 	    (x->aead->alg_key_len != 256 + 32)) {
-		pr_debug("CHCR: Cannot offload xfrm states with AEAD key length other than 128/256 bit\n");
+		pr_debug("CH_IPSEC: Cannot offload xfrm states with AEAD key length other than 128/256 bit\n");
 		return -EINVAL;
 	}
 	if (x->tfcpad) {
-		pr_debug("CHCR: Cannot offload xfrm states with tfc padding\n");
+		pr_debug("CH_IPSEC: Cannot offload xfrm states with tfc padding\n");
 		return -EINVAL;
 	}
 	if (!x->geniv) {
-		pr_debug("CHCR: Cannot offload xfrm states without geniv\n");
+		pr_debug("CH_IPSEC: Cannot offload xfrm states without geniv\n");
 		return -EINVAL;
 	}
 	if (strcmp(x->geniv, "seqiv")) {
-		pr_debug("CHCR: Cannot offload xfrm states with geniv other than seqiv\n");
+		pr_debug("CH_IPSEC: Cannot offload xfrm states with geniv other than seqiv\n");
 		return -EINVAL;
 	}
 
@@ -291,24 +292,24 @@ static int chcr_xfrm_add_state(struct xfrm_state *x)
 		goto out;
 	}
 
-	sa_entry->hmac_ctrl = chcr_ipsec_setauthsize(x, sa_entry);
+	sa_entry->hmac_ctrl = ch_ipsec_setauthsize(x, sa_entry);
 	if (x->props.flags & XFRM_STATE_ESN)
 		sa_entry->esn = 1;
-	chcr_ipsec_setkey(x, sa_entry);
+	ch_ipsec_setkey(x, sa_entry);
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	try_module_get(THIS_MODULE);
 out:
 	return res;
 }
 
-static void chcr_xfrm_del_state(struct xfrm_state *x)
+static void ch_ipsec_xfrm_del_state(struct xfrm_state *x)
 {
 	/* do nothing */
 	if (!x->xso.offload_handle)
 		return;
 }
 
-static void chcr_xfrm_free_state(struct xfrm_state *x)
+static void ch_ipsec_xfrm_free_state(struct xfrm_state *x)
 {
 	struct ipsec_sa_entry *sa_entry;
 
@@ -320,7 +321,7 @@ static void chcr_xfrm_free_state(struct xfrm_state *x)
 	module_put(THIS_MODULE);
 }
 
-static bool chcr_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
+static bool ch_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 {
 	if (x->props.family == AF_INET) {
 		/* Offload with IP options is not supported yet */
@@ -334,7 +335,7 @@ static bool chcr_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 	return true;
 }
 
-static void chcr_advance_esn_state(struct xfrm_state *x)
+static void ch_ipsec_advance_esn_state(struct xfrm_state *x)
 {
 	/* do nothing */
 	if (!x->xso.offload_handle)
@@ -549,7 +550,7 @@ inline void *copy_key_cpltx_pktxt(struct sk_buff *skb,
 	return pos;
 }
 
-inline void *chcr_crypto_wreq(struct sk_buff *skb,
+inline void *ch_ipsec_crypto_wreq(struct sk_buff *skb,
 			       struct net_device *dev,
 			       void *pos,
 			       int credits,
@@ -700,9 +701,9 @@ static inline void txq_advance(struct sge_txq *q, unsigned int n)
 }
 
 /*
- *      chcr_ipsec_xmit called from ULD Tx handler
+ *      ch_ipsec_xmit called from ULD Tx handler
  */
-int chcr_ipsec_xmit(struct sk_buff *skb, struct net_device *dev)
+int ch_ipsec_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct xfrm_state *x = xfrm_input_state(skb);
 	unsigned int last_desc, ndesc, flits = 0;
@@ -763,7 +764,7 @@ out_free:       dev_kfree_skb_any(skb);
 	before = (u64 *)pos;
 	end = (u64 *)pos + flits;
 	/* Setup IPSec CPL */
-	pos = (void *)chcr_crypto_wreq(skb, dev, (void *)pos,
+	pos = (void *)ch_ipsec_crypto_wreq(skb, dev, (void *)pos,
 				       credits, sa_entry);
 	if (before > (u64 *)pos) {
 		left = (u8 *)end - (u8 *)q->q.stat;
@@ -791,14 +792,14 @@ out_free:       dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 
-static int __init chcr_ipsec_init(void)
+static int __init ch_ipsec_init(void)
 {
 	cxgb4_register_uld(CXGB4_ULD_IPSEC, &ch_ipsec_uld_info);
 
 	return 0;
 }
 
-static void __exit chcr_ipsec_exit(void)
+static void __exit ch_ipsec_exit(void)
 {
 	struct ipsec_uld_ctx *u_ctx, *tmp;
 	struct adapter *adap;
@@ -814,8 +815,8 @@ static void __exit chcr_ipsec_exit(void)
 	cxgb4_unregister_uld(CXGB4_ULD_IPSEC);
 }
 
-module_init(chcr_ipsec_init);
-module_exit(chcr_ipsec_exit);
+module_init(ch_ipsec_init);
+module_exit(ch_ipsec_exit);
 
 MODULE_DESCRIPTION("Crypto IPSEC for Chelsio Terminator cards.");
 MODULE_LICENSE("GPL");
-- 
2.28.0.rc1.6.gae46588

