Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7504D174424
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 02:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgB2BYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 20:24:48 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:19829 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB2BYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 20:24:48 -0500
Received: from redhouse.blr.asicdesginers.com ([10.193.187.72])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 01T1OSpO000731;
        Fri, 28 Feb 2020 17:24:37 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, varun@chelsio.com, borisp@mellanox.com,
        kuba@kernel.org, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net-next v3 2/6] cxgb4/chcr: Save tx keys and handle HW response
Date:   Sat, 29 Feb 2020 06:54:22 +0530
Message-Id: <20200229012426.30981-3-rohitm@chelsio.com>
X-Mailer: git-send-email 2.25.0.191.gde93cc1
In-Reply-To: <20200229012426.30981-1-rohitm@chelsio.com>
References: <20200229012426.30981-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of this patch generated and saved crypto keys, handled HW
response of act_open_req and set_tcb_req. Defined connection state
update.

v1->v2:
- optimized tcb update using control queue.
- state machine handling when earlier states received.

v2->v3:
- Added one empty line after function declaration.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chcr_common.h        |  64 +++++
 drivers/crypto/chelsio/chcr_core.c          |  20 +-
 drivers/crypto/chelsio/chcr_core.h          |   2 +
 drivers/crypto/chelsio/chcr_ktls.c          | 246 ++++++++++++++++++++
 drivers/crypto/chelsio/chcr_ktls.h          |  15 ++
 drivers/net/ethernet/chelsio/cxgb4/l2t.c    |  11 +
 drivers/net/ethernet/chelsio/cxgb4/l2t.h    |   1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |   8 +
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h |  37 ++-
 9 files changed, 391 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_common.h b/drivers/crypto/chelsio/chcr_common.h
index c0b9a8806c23..852f64322326 100644
--- a/drivers/crypto/chelsio/chcr_common.h
+++ b/drivers/crypto/chelsio/chcr_common.h
@@ -6,6 +6,10 @@
 
 #include "cxgb4.h"
 
+#define CHCR_MAX_SALT                      4
+#define CHCR_KEYCTX_MAC_KEY_SIZE_128       0
+#define CHCR_KEYCTX_CIPHER_KEY_SIZE_128    0
+
 enum chcr_state {
 	CHCR_INIT = 0,
 	CHCR_ATTACH,
@@ -28,5 +32,65 @@ struct uld_ctx {
 	struct chcr_dev dev;
 };
 
+struct ktls_key_ctx {
+	__be32 ctx_hdr;
+	u8 salt[CHCR_MAX_SALT];
+	__be64 iv_to_auth;
+	unsigned char key[TLS_CIPHER_AES_GCM_128_KEY_SIZE +
+			  TLS_CIPHER_AES_GCM_256_TAG_SIZE];
+};
+
+/* Crypto key context */
+#define KEY_CONTEXT_CTX_LEN_S           24
+#define KEY_CONTEXT_CTX_LEN_V(x)        ((x) << KEY_CONTEXT_CTX_LEN_S)
+
+#define KEY_CONTEXT_SALT_PRESENT_S      10
+#define KEY_CONTEXT_SALT_PRESENT_V(x)   ((x) << KEY_CONTEXT_SALT_PRESENT_S)
+#define KEY_CONTEXT_SALT_PRESENT_F      KEY_CONTEXT_SALT_PRESENT_V(1U)
+
+#define KEY_CONTEXT_VALID_S     0
+#define KEY_CONTEXT_VALID_V(x)  ((x) << KEY_CONTEXT_VALID_S)
+#define KEY_CONTEXT_VALID_F     KEY_CONTEXT_VALID_V(1U)
+
+#define KEY_CONTEXT_CK_SIZE_S           6
+#define KEY_CONTEXT_CK_SIZE_V(x)        ((x) << KEY_CONTEXT_CK_SIZE_S)
+
+#define KEY_CONTEXT_MK_SIZE_S           2
+#define KEY_CONTEXT_MK_SIZE_V(x)        ((x) << KEY_CONTEXT_MK_SIZE_S)
+
+#define KEY_CONTEXT_OPAD_PRESENT_S      11
+#define KEY_CONTEXT_OPAD_PRESENT_V(x)   ((x) << KEY_CONTEXT_OPAD_PRESENT_S)
+#define KEY_CONTEXT_OPAD_PRESENT_F      KEY_CONTEXT_OPAD_PRESENT_V(1U)
+
+#define FILL_KEY_CTX_HDR(ck_size, mk_size, ctx_len) \
+		htonl(KEY_CONTEXT_MK_SIZE_V(mk_size) | \
+		      KEY_CONTEXT_CK_SIZE_V(ck_size) | \
+		      KEY_CONTEXT_VALID_F | \
+		      KEY_CONTEXT_SALT_PRESENT_F | \
+		      KEY_CONTEXT_CTX_LEN_V((ctx_len)))
+
 struct uld_ctx *assign_chcr_device(void);
+
+static inline void *chcr_copy_to_txd(const void *src, const struct sge_txq *q,
+				     void *pos, int length)
+{
+	int left = (void *)q->stat - pos;
+	u64 *p;
+
+	if (likely(length <= left)) {
+		memcpy(pos, src, length);
+		pos += length;
+	} else {
+		memcpy(pos, src, left);
+		memcpy(q->desc, src + left, length - left);
+		pos = (void *)q->desc + (length - left);
+	}
+	/* 0-pad to multiple of 16 */
+	p = PTR_ALIGN(pos, 8);
+	if ((uintptr_t)p & 8) {
+		*p = 0;
+		return p + 1;
+	}
+	return p;
+}
 #endif /* __CHCR_COMMON_H__ */
diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index 16e16aa86808..a52ce6fc9858 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -28,13 +28,17 @@
 
 static struct chcr_driver_data drv_data;
 
-typedef int (*chcr_handler_func)(struct chcr_dev *dev, unsigned char *input);
-static int cpl_fw6_pld_handler(struct chcr_dev *dev, unsigned char *input);
+typedef int (*chcr_handler_func)(struct adapter *adap, unsigned char *input);
+static int cpl_fw6_pld_handler(struct adapter *adap, unsigned char *input);
 static void *chcr_uld_add(const struct cxgb4_lld_info *lld);
 static int chcr_uld_state_change(void *handle, enum cxgb4_state state);
 
 static chcr_handler_func work_handlers[NUM_CPL_CMDS] = {
 	[CPL_FW6_PLD] = cpl_fw6_pld_handler,
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+	[CPL_ACT_OPEN_RPL] = chcr_ktls_cpl_act_open_rpl,
+	[CPL_SET_TCB_RPL] = chcr_ktls_cpl_set_tcb_rpl,
+#endif
 };
 
 static struct cxgb4_uld_info chcr_uld_info = {
@@ -150,14 +154,13 @@ static int chcr_dev_move(struct uld_ctx *u_ctx)
 	return 0;
 }
 
-static int cpl_fw6_pld_handler(struct chcr_dev *dev,
+static int cpl_fw6_pld_handler(struct adapter *adap,
 			       unsigned char *input)
 {
 	struct crypto_async_request *req;
 	struct cpl_fw6_pld *fw6_pld;
 	u32 ack_err_status = 0;
 	int error_status = 0;
-	struct adapter *adap = padap(dev);
 
 	fw6_pld = (struct cpl_fw6_pld *)input;
 	req = (struct crypto_async_request *)(uintptr_t)be64_to_cpu(
@@ -219,17 +222,18 @@ int chcr_uld_rx_handler(void *handle, const __be64 *rsp,
 {
 	struct uld_ctx *u_ctx = (struct uld_ctx *)handle;
 	struct chcr_dev *dev = &u_ctx->dev;
+	struct adapter *adap = padap(dev);
 	const struct cpl_fw6_pld *rpl = (struct cpl_fw6_pld *)rsp;
 
-	if (rpl->opcode != CPL_FW6_PLD) {
-		pr_err("Unsupported opcode\n");
+	if (!work_handlers[rpl->opcode]) {
+		pr_err("Unsupported opcode %d received\n", rpl->opcode);
 		return 0;
 	}
 
 	if (!pgl)
-		work_handlers[rpl->opcode](dev, (unsigned char *)&rsp[1]);
+		work_handlers[rpl->opcode](adap, (unsigned char *)&rsp[1]);
 	else
-		work_handlers[rpl->opcode](dev, pgl->va);
+		work_handlers[rpl->opcode](adap, pgl->va);
 	return 0;
 }
 
diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index 48e3ddfdd9e2..2dcbd188290a 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -225,5 +225,7 @@ void chcr_add_xfrmops(const struct cxgb4_lld_info *lld);
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
 void chcr_enable_ktls(struct adapter *adap);
 void chcr_disable_ktls(struct adapter *adap);
+int chcr_ktls_cpl_act_open_rpl(struct adapter *adap, unsigned char *input);
+int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input);
 #endif
 #endif /* __CHCR_CORE_H__ */
diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index f1c361a83929..f945b93a1bf0 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -4,6 +4,143 @@
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
 #include "chcr_ktls.h"
 
+static int chcr_init_tcb_fields(struct chcr_ktls_info *tx_info);
+/*
+ * chcr_ktls_save_keys: calculate and save crypto keys.
+ * @tx_info - driver specific tls info.
+ * @crypto_info - tls crypto information.
+ * @direction - TX/RX direction.
+ * return - SUCCESS/FAILURE.
+ */
+static int chcr_ktls_save_keys(struct chcr_ktls_info *tx_info,
+			       struct tls_crypto_info *crypto_info,
+			       enum tls_offload_ctx_dir direction)
+{
+	int ck_size, key_ctx_size, mac_key_size, keylen, ghash_size, ret;
+	unsigned char ghash_h[TLS_CIPHER_AES_GCM_256_TAG_SIZE];
+	struct tls12_crypto_info_aes_gcm_128 *info_128_gcm;
+	struct ktls_key_ctx *kctx = &tx_info->key_ctx;
+	struct crypto_cipher *cipher;
+	unsigned char *key, *salt;
+
+	switch (crypto_info->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		info_128_gcm =
+			(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+		keylen = TLS_CIPHER_AES_GCM_128_KEY_SIZE;
+		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_128;
+		tx_info->salt_size = TLS_CIPHER_AES_GCM_128_SALT_SIZE;
+		mac_key_size = CHCR_KEYCTX_MAC_KEY_SIZE_128;
+		tx_info->iv_size = TLS_CIPHER_AES_GCM_128_IV_SIZE;
+		tx_info->iv = be64_to_cpu(*(__be64 *)info_128_gcm->iv);
+
+		ghash_size = TLS_CIPHER_AES_GCM_128_TAG_SIZE;
+		key = info_128_gcm->key;
+		salt = info_128_gcm->salt;
+		tx_info->record_no = *(u64 *)info_128_gcm->rec_seq;
+
+		break;
+
+	default:
+		pr_err("GCM: cipher type 0x%x not supported\n",
+		       crypto_info->cipher_type);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	key_ctx_size = CHCR_KTLS_KEY_CTX_LEN +
+		       roundup(keylen, 16) + ghash_size;
+	/* Calculate the H = CIPH(K, 0 repeated 16 times).
+	 * It will go in key context
+	 */
+	cipher = crypto_alloc_cipher("aes", 0, 0);
+	if (IS_ERR(cipher)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = crypto_cipher_setkey(cipher, key, keylen);
+	if (ret)
+		goto out1;
+
+	memset(ghash_h, 0, ghash_size);
+	crypto_cipher_encrypt_one(cipher, ghash_h, ghash_h);
+
+	/* fill the Key context */
+	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
+		kctx->ctx_hdr = FILL_KEY_CTX_HDR(ck_size,
+						 mac_key_size,
+						 key_ctx_size >> 4);
+	} else {
+		ret = -EINVAL;
+		goto out1;
+	}
+
+	memcpy(kctx->salt, salt, tx_info->salt_size);
+	memcpy(kctx->key, key, keylen);
+	memcpy(kctx->key + keylen, ghash_h, ghash_size);
+	tx_info->key_ctx_len = key_ctx_size;
+
+out1:
+	crypto_free_cipher(cipher);
+out:
+	return ret;
+}
+
+static int chcr_ktls_update_connection_state(struct chcr_ktls_info *tx_info,
+					     int new_state)
+{
+	unsigned long flags;
+
+	/* This function can be called from both rx (interrupt context) and tx
+	 * queue contexts.
+	 */
+	spin_lock_irqsave(&tx_info->lock, flags);
+	switch (tx_info->connection_state) {
+	case KTLS_CONN_CLOSED:
+		tx_info->connection_state = new_state;
+		break;
+
+	case KTLS_CONN_ACT_OPEN_REQ:
+		/* only go forward if state is greater than current state. */
+		if (new_state <= tx_info->connection_state)
+			break;
+		/* update to the next state and also initialize TCB */
+		tx_info->connection_state = new_state;
+		/* FALLTHRU */
+	case KTLS_CONN_ACT_OPEN_RPL:
+		/* if we are stuck in this state, means tcb init might not
+		 * received by HW, try sending it again.
+		 */
+		if (!chcr_init_tcb_fields(tx_info))
+			tx_info->connection_state = KTLS_CONN_SET_TCB_REQ;
+		break;
+
+	case KTLS_CONN_SET_TCB_REQ:
+		/* only go forward if state is greater than current state. */
+		if (new_state <= tx_info->connection_state)
+			break;
+		/* update to the next state and check if l2t_state is valid  */
+		tx_info->connection_state = new_state;
+		/* FALLTHRU */
+	case KTLS_CONN_SET_TCB_RPL:
+		/* Check if l2t state is valid, then move to ready state. */
+		if (cxgb4_check_l2t_valid(tx_info->l2te))
+			tx_info->connection_state = KTLS_CONN_TX_READY;
+		break;
+
+	case KTLS_CONN_TX_READY:
+		/* nothing to be done here */
+		break;
+
+	default:
+		pr_err("unknown KTLS connection state\n");
+		break;
+	}
+	spin_unlock_irqrestore(&tx_info->lock, flags);
+
+	return tx_info->connection_state;
+}
 /*
  * chcr_ktls_act_open_req: creates TCB entry for ipv4 connection.
  * @sk - tcp socket.
@@ -91,8 +228,12 @@ static int chcr_setup_connection(struct sock *sk,
 			ret = 0;
 		else
 			cxgb4_free_atid(t, atid);
+		goto out;
 	}
 
+	/* update the connection state */
+	chcr_ktls_update_connection_state(tx_info, KTLS_CONN_ACT_OPEN_REQ);
+out:
 	return ret;
 }
 
@@ -243,6 +384,11 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	tx_info->prev_seq = start_offload_tcp_sn;
 	tx_info->tcp_start_seq_number = start_offload_tcp_sn;
 
+	/* save crypto keys */
+	ret = chcr_ktls_save_keys(tx_info, crypto_info, direction);
+	if (ret < 0)
+		goto out2;
+
 	/* get peer ip */
 	if (sk->sk_family == AF_INET ||
 	    (sk->sk_family == AF_INET6 && !sk->sk_ipv6only &&
@@ -326,4 +472,104 @@ void chcr_disable_ktls(struct adapter *adap)
 		netdev->tlsdev_ops = NULL;
 	}
 }
+
+/*
+ * chcr_init_tcb_fields:  Initialize tcb fields to handle TCP seq number
+ *			  handling.
+ * @tx_info - driver specific tls info.
+ * return: NET_TX_OK/NET_XMIT_DROP
+ */
+static int chcr_init_tcb_fields(struct chcr_ktls_info *tx_info)
+{
+	int  ret = 0;
+
+	/* set tcb in offload and bypass */
+	ret =
+	chcr_set_tcb_field(tx_info, TCB_T_FLAGS_W,
+			   TCB_T_FLAGS_V(TF_CORE_BYPASS_F | TF_NON_OFFLOAD_F),
+			   TCB_T_FLAGS_V(TF_CORE_BYPASS_F), 1);
+	if (ret)
+		return ret;
+	/* reset snd_una and snd_next fields in tcb */
+	ret = chcr_set_tcb_field(tx_info, TCB_SND_UNA_RAW_W,
+				 TCB_SND_NXT_RAW_V(TCB_SND_NXT_RAW_M) |
+				 TCB_SND_UNA_RAW_V(TCB_SND_UNA_RAW_M),
+				 0, 1);
+	if (ret)
+		return ret;
+
+	/* reset send max */
+	ret = chcr_set_tcb_field(tx_info, TCB_SND_MAX_RAW_W,
+				 TCB_SND_MAX_RAW_V(TCB_SND_MAX_RAW_M),
+				 0, 1);
+	if (ret)
+		return ret;
+
+	/* update l2t index and request for tp reply to confirm tcb is
+	 * initialised to handle tx traffic.
+	 */
+	ret = chcr_set_tcb_field(tx_info, TCB_L2T_IX_W,
+				 TCB_L2T_IX_V(TCB_L2T_IX_M),
+				 TCB_L2T_IX_V(tx_info->l2te->idx), 0);
+	return ret;
+}
+
+/*
+ * chcr_ktls_cpl_act_open_rpl: connection reply received from TP.
+ */
+int chcr_ktls_cpl_act_open_rpl(struct adapter *adap, unsigned char *input)
+{
+	const struct cpl_act_open_rpl *p = (void *)input;
+	struct chcr_ktls_info *tx_info = NULL;
+	unsigned int atid, tid, status;
+	struct tid_info *t;
+
+	tid = GET_TID(p);
+	status = AOPEN_STATUS_G(ntohl(p->atid_status));
+	atid = TID_TID_G(AOPEN_ATID_G(ntohl(p->atid_status)));
+
+	t = &adap->tids;
+	tx_info = lookup_atid(t, atid);
+
+	if (!tx_info || tx_info->atid != atid) {
+		pr_err("tx_info or atid is not correct\n");
+		return -1;
+	}
+
+	if (!status) {
+		tx_info->tid = tid;
+		cxgb4_insert_tid(t, tx_info, tx_info->tid, tx_info->ip_family);
+
+		cxgb4_free_atid(t, atid);
+		tx_info->atid = -1;
+		/* update the connection state */
+		chcr_ktls_update_connection_state(tx_info,
+						  KTLS_CONN_ACT_OPEN_RPL);
+	}
+	return 0;
+}
+
+/*
+ * chcr_ktls_cpl_set_tcb_rpl: TCB reply received from TP.
+ */
+int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input)
+{
+	const struct cpl_set_tcb_rpl *p = (void *)input;
+	struct chcr_ktls_info *tx_info = NULL;
+	struct tid_info *t;
+	u32 tid, status;
+
+	tid = GET_TID(p);
+	status = p->status;
+
+	t = &adap->tids;
+	tx_info = lookup_tid(t, tid);
+	if (!tx_info || tx_info->tid != tid) {
+		pr_err("tx_info or atid is not correct\n");
+		return -1;
+	}
+	/* update the connection state */
+	chcr_ktls_update_connection_state(tx_info, KTLS_CONN_SET_TCB_RPL);
+	return 0;
+}
 #endif /* CONFIG_CHELSIO_TLS_DEVICE */
diff --git a/drivers/crypto/chelsio/chcr_ktls.h b/drivers/crypto/chelsio/chcr_ktls.h
index f7b993c73424..15e79bdfb13c 100644
--- a/drivers/crypto/chelsio/chcr_ktls.h
+++ b/drivers/crypto/chelsio/chcr_ktls.h
@@ -13,21 +13,34 @@
 #include "chcr_common.h"
 
 #define CHCR_TCB_STATE_CLOSED	0
+#define CHCR_KTLS_KEY_CTX_LEN	16
+#define CHCR_SET_TCB_FIELD_LEN	sizeof(struct cpl_set_tcb_field)
 
 enum chcr_ktls_conn_state {
 	KTLS_CONN_CLOSED,
+	KTLS_CONN_ACT_OPEN_REQ,
+	KTLS_CONN_ACT_OPEN_RPL,
+	KTLS_CONN_SET_TCB_REQ,
+	KTLS_CONN_SET_TCB_RPL,
+	KTLS_CONN_TX_READY,
 };
 
 struct chcr_ktls_info {
 	struct sock *sk;
 	spinlock_t lock; /* state machine lock */
+	struct ktls_key_ctx key_ctx;
 	struct adapter *adap;
 	struct l2t_entry *l2te;
 	struct net_device *netdev;
+	u64 iv;
+	u64 record_no;
 	int tid;
 	int atid;
 	int rx_qid;
+	u32 iv_size;
 	u32 prev_seq;
+	u32 salt_size;
+	u32 key_ctx_len;
 	u32 tcp_start_seq_number;
 	enum chcr_ktls_conn_state connection_state;
 	u8 tx_chan;
@@ -63,5 +76,7 @@ static inline int chcr_get_first_rx_qid(struct adapter *adap)
 
 void chcr_enable_ktls(struct adapter *adap);
 void chcr_disable_ktls(struct adapter *adap);
+int chcr_ktls_cpl_act_open_rpl(struct adapter *adap, unsigned char *input);
+int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input);
 #endif /* CONFIG_CHELSIO_TLS_DEVICE */
 #endif /* __CHCR_KTLS_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/l2t.c b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
index 1a16449e9deb..b66e0332dbb3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/l2t.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
@@ -700,6 +700,17 @@ static char l2e_state(const struct l2t_entry *e)
 	}
 }
 
+bool cxgb4_check_l2t_valid(struct l2t_entry *e)
+{
+	bool valid;
+
+	spin_lock(&e->lock);
+	valid = (e->state == L2T_STATE_VALID);
+	spin_unlock(&e->lock);
+	return valid;
+}
+EXPORT_SYMBOL(cxgb4_check_l2t_valid);
+
 static int l2t_seq_show(struct seq_file *seq, void *v)
 {
 	if (v == SEQ_START_TOKEN)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/l2t.h b/drivers/net/ethernet/chelsio/cxgb4/l2t.h
index 79665bd8f881..340fecb28a13 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/l2t.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/l2t.h
@@ -122,6 +122,7 @@ struct l2t_entry *t4_l2t_alloc_switching(struct adapter *adap, u16 vlan,
 					 u8 port, u8 *dmac);
 struct l2t_data *t4_init_l2t(unsigned int l2t_start, unsigned int l2t_end);
 void do_l2t_write_rpl(struct adapter *p, const struct cpl_l2t_write_rpl *rpl);
+bool cxgb4_check_l2t_valid(struct l2t_entry *e);
 
 extern const struct file_operations t4_l2t_fops;
 #endif  /* __CXGB4_L2T_H */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
index 575c6abcdae7..e9c775f1dd3e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
@@ -705,6 +705,14 @@ struct cpl_set_tcb_field {
 	__be64 val;
 };
 
+struct cpl_set_tcb_field_core {
+	union opcode_tid ot;
+	__be16 reply_ctrl;
+	__be16 word_cookie;
+	__be64 mask;
+	__be64 val;
+};
+
 /* cpl_set_tcb_field.word_cookie fields */
 #define TCB_WORD_S	0
 #define TCB_WORD_V(x)	((x) << TCB_WORD_S)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
index 1df93a35dfa0..fc93389148c8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
@@ -35,6 +35,11 @@
 #ifndef __T4_TCB_H
 #define __T4_TCB_H
 
+#define TCB_L2T_IX_W		0
+#define TCB_L2T_IX_S		12
+#define TCB_L2T_IX_M		0xfffULL
+#define TCB_L2T_IX_V(x)		((x) << TCB_L2T_IX_S)
+
 #define TCB_SMAC_SEL_W		0
 #define TCB_SMAC_SEL_S		24
 #define TCB_SMAC_SEL_M		0xffULL
@@ -45,11 +50,6 @@
 #define TCB_T_FLAGS_M		0xffffffffffffffffULL
 #define TCB_T_FLAGS_V(x)	((__u64)(x) << TCB_T_FLAGS_S)
 
-#define TCB_RQ_START_W		30
-#define TCB_RQ_START_S		0
-#define TCB_RQ_START_M		0x3ffffffULL
-#define TCB_RQ_START_V(x)	((x) << TCB_RQ_START_S)
-
 #define TF_CCTRL_ECE_S		60
 #define TF_CCTRL_CWR_S		61
 #define TF_CCTRL_RFR_S		62
@@ -75,12 +75,39 @@
 #define TCB_RTT_TS_RECENT_AGE_V(x)	((x) << TCB_RTT_TS_RECENT_AGE_S)
 
 #define TCB_SND_UNA_RAW_W	10
+#define TCB_SND_UNA_RAW_S	0
+#define TCB_SND_UNA_RAW_M	0xfffffffULL
+#define TCB_SND_UNA_RAW_V(x)	((x) << TCB_SND_UNA_RAW_S)
+
+#define TCB_SND_NXT_RAW_W	10
+#define TCB_SND_NXT_RAW_S	28
+#define TCB_SND_NXT_RAW_M	0xfffffffULL
+#define TCB_SND_NXT_RAW_V(x)	((x) << TCB_SND_NXT_RAW_S)
+
+#define TCB_SND_MAX_RAW_W	11
+#define TCB_SND_MAX_RAW_S	24
+#define TCB_SND_MAX_RAW_M	0xfffffffULL
+#define TCB_SND_MAX_RAW_V(x)	((x) << TCB_SND_MAX_RAW_S)
+
 #define TCB_RX_FRAG2_PTR_RAW_W	27
 #define TCB_RX_FRAG3_LEN_RAW_W	29
 #define TCB_RX_FRAG3_START_IDX_OFFSET_RAW_W	30
 #define TCB_PDU_HDR_LEN_W	31
 
+#define TCB_RQ_START_W		30
+#define TCB_RQ_START_S		0
+#define TCB_RQ_START_M		0x3ffffffULL
+#define TCB_RQ_START_V(x)	((x) << TCB_RQ_START_S)
+
 #define TF_RX_PDU_OUT_S		49
 #define TF_RX_PDU_OUT_V(x)	((__u64)(x) << TF_RX_PDU_OUT_S)
 
+#define TF_CORE_BYPASS_S	63
+#define TF_CORE_BYPASS_V(x)	((__u64)(x) << TF_CORE_BYPASS_S)
+#define TF_CORE_BYPASS_F	TF_CORE_BYPASS_V(1)
+
+#define TF_NON_OFFLOAD_S	1
+#define TF_NON_OFFLOAD_V(x)	((x) << TF_NON_OFFLOAD_S)
+#define TF_NON_OFFLOAD_F	TF_NON_OFFLOAD_V(1)
+
 #endif /* __T4_TCB_H */
-- 
2.25.0.191.gde93cc1

