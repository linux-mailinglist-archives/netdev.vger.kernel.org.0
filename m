Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D2F173FC5
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 19:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgB1SkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 13:40:00 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:20951 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1Sj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 13:39:59 -0500
Received: from redhouse.blr.asicdesginers.com ([10.193.187.72])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 01SIdlBC032397;
        Fri, 28 Feb 2020 10:39:51 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, varun@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net-next v2 1/6] cxgb4/chcr : Register to tls add and del callbacks
Date:   Sat, 29 Feb 2020 00:09:40 +0530
Message-Id: <20200228183945.11594-2-rohitm@chelsio.com>
X-Mailer: git-send-email 2.25.0.191.gde93cc1
In-Reply-To: <20200228183945.11594-1-rohitm@chelsio.com>
References: <20200228183945.11594-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new macro is defined to enable ktls tx offload support on Chelsio
T6 adapter. And if this macro is enabled, cxgb4 will send mailbox to
enable or disable ktls settings on HW.
In chcr, enabled tx offload flag in netdev and registered tls_dev_add
and tls_dev_del.

v1->v2:
- mark tcb state to close in tls_dev_del.
- u_ctx is now picked from adapter structure.
- clear atid in case of failure.
- corrected ULP_CRYPTO_KTLS_INLINE value.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/Kconfig                |  11 +
 drivers/crypto/chelsio/Makefile               |   3 +
 drivers/crypto/chelsio/chcr_common.h          |  32 ++
 drivers/crypto/chelsio/chcr_core.c            |  13 +
 drivers/crypto/chelsio/chcr_core.h            |   4 +
 drivers/crypto/chelsio/chcr_ktls.c            | 329 ++++++++++++++++++
 drivers/crypto/chelsio/chcr_ktls.h            |  66 ++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   1 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.c    |  31 ++
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h   |   5 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |   2 +
 11 files changed, 497 insertions(+)
 create mode 100644 drivers/crypto/chelsio/chcr_common.h
 create mode 100644 drivers/crypto/chelsio/chcr_ktls.c
 create mode 100644 drivers/crypto/chelsio/chcr_ktls.h

diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index f078b2686418..f2756836093f 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -42,3 +42,14 @@ config CRYPTO_DEV_CHELSIO_TLS
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called chtls.
+
+config CHELSIO_TLS_DEVICE
+	bool "Chelsio Inline KTLS Offload"
+	depends on CHELSIO_T4
+	depends on TLS_DEVICE
+	select CRYPTO_DEV_CHELSIO
+	default y
+	help
+	  This flag enables support for kernel tls offload over Chelsio T6
+	  crypto accelerator. CONFIG_CHELSIO_TLS_DEVICE flag can be enabled
+	  only if CONFIG_TLS and CONFIG_TLS_DEVICE flags are enabled.
diff --git a/drivers/crypto/chelsio/Makefile b/drivers/crypto/chelsio/Makefile
index a3c05e2f4562..0e9d035927e9 100644
--- a/drivers/crypto/chelsio/Makefile
+++ b/drivers/crypto/chelsio/Makefile
@@ -3,5 +3,8 @@ ccflags-y := -I $(srctree)/drivers/net/ethernet/chelsio/cxgb4
 
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chcr.o
 chcr-objs :=  chcr_core.o chcr_algo.o
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+chcr-objs += chcr_ktls.o
+#endif
 chcr-$(CONFIG_CHELSIO_IPSEC_INLINE) += chcr_ipsec.o
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO_TLS) += chtls/
diff --git a/drivers/crypto/chelsio/chcr_common.h b/drivers/crypto/chelsio/chcr_common.h
new file mode 100644
index 000000000000..c0b9a8806c23
--- /dev/null
+++ b/drivers/crypto/chelsio/chcr_common.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2020 Chelsio Communications.  All rights reserved. */
+
+#ifndef __CHCR_COMMON_H__
+#define __CHCR_COMMON_H__
+
+#include "cxgb4.h"
+
+enum chcr_state {
+	CHCR_INIT = 0,
+	CHCR_ATTACH,
+	CHCR_DETACH,
+};
+
+struct chcr_dev {
+	spinlock_t lock_chcr_dev; /* chcr dev structure lock */
+	enum chcr_state state;
+	atomic_t inflight;
+	int wqretry;
+	struct delayed_work detach_work;
+	struct completion detach_comp;
+	unsigned char tx_channel_id;
+};
+
+struct uld_ctx {
+	struct list_head entry;
+	struct cxgb4_lld_info lldi;
+	struct chcr_dev dev;
+};
+
+struct uld_ctx *assign_chcr_device(void);
+#endif /* __CHCR_COMMON_H__ */
diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index e937605670ac..16e16aa86808 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -205,6 +205,11 @@ static void *chcr_uld_add(const struct cxgb4_lld_info *lld)
 	if (lld->crypto & ULP_CRYPTO_IPSEC_INLINE)
 		chcr_add_xfrmops(lld);
 #endif /* CONFIG_CHELSIO_IPSEC_INLINE */
+
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+	if (lld->ulp_crypto & ULP_CRYPTO_KTLS_INLINE)
+		chcr_enable_ktls(padap(&u_ctx->dev));
+#endif
 out:
 	return u_ctx;
 }
@@ -304,12 +309,20 @@ static void __exit chcr_crypto_exit(void)
 	list_for_each_entry_safe(u_ctx, tmp, &drv_data.act_dev, entry) {
 		adap = padap(&u_ctx->dev);
 		memset(&adap->chcr_stats, 0, sizeof(adap->chcr_stats));
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+		if (u_ctx->lldi.ulp_crypto & ULP_CRYPTO_KTLS_INLINE)
+			chcr_disable_ktls(adap);
+#endif
 		list_del(&u_ctx->entry);
 		kfree(u_ctx);
 	}
 	list_for_each_entry_safe(u_ctx, tmp, &drv_data.inact_dev, entry) {
 		adap = padap(&u_ctx->dev);
 		memset(&adap->chcr_stats, 0, sizeof(adap->chcr_stats));
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+		if (u_ctx->lldi.ulp_crypto & ULP_CRYPTO_KTLS_INLINE)
+			chcr_disable_ktls(adap);
+#endif
 		list_del(&u_ctx->entry);
 		kfree(u_ctx);
 	}
diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index ad874d548aa5..48e3ddfdd9e2 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -222,4 +222,8 @@ int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
 		     int err);
 int chcr_ipsec_xmit(struct sk_buff *skb, struct net_device *dev);
 void chcr_add_xfrmops(const struct cxgb4_lld_info *lld);
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+void chcr_enable_ktls(struct adapter *adap);
+void chcr_disable_ktls(struct adapter *adap);
+#endif
 #endif /* __CHCR_CORE_H__ */
diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
new file mode 100644
index 000000000000..f1c361a83929
--- /dev/null
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -0,0 +1,329 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Chelsio Communications.  All rights reserved. */
+
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+#include "chcr_ktls.h"
+
+/*
+ * chcr_ktls_act_open_req: creates TCB entry for ipv4 connection.
+ * @sk - tcp socket.
+ * @tx_info - driver specific tls info.
+ * @atid - connection active tid.
+ * return - send success/failure.
+ */
+static int chcr_ktls_act_open_req(struct sock *sk,
+				  struct chcr_ktls_info *tx_info,
+				  int atid)
+{
+	struct inet_sock *inet = inet_sk(sk);
+	struct cpl_t6_act_open_req *cpl6;
+	struct cpl_act_open_req *cpl;
+	struct sk_buff *skb;
+	unsigned int len;
+	int qid_atid;
+	u64 options;
+
+	len = sizeof(*cpl6);
+	skb = alloc_skb(len, GFP_KERNEL);
+	if (unlikely(!skb))
+		return -ENOMEM;
+	/* mark it a control pkt */
+	set_wr_txq(skb, CPL_PRIORITY_CONTROL, tx_info->port_id);
+
+	cpl6 = __skb_put_zero(skb, len);
+	cpl = (struct cpl_act_open_req *)cpl6;
+	INIT_TP_WR(cpl6, 0);
+	qid_atid = TID_QID_V(tx_info->rx_qid) |
+		   TID_TID_V(atid);
+	OPCODE_TID(cpl) = htonl(MK_OPCODE_TID(CPL_ACT_OPEN_REQ, qid_atid));
+	cpl->local_port = inet->inet_sport;
+	cpl->peer_port = inet->inet_dport;
+	cpl->local_ip = inet->inet_rcv_saddr;
+	cpl->peer_ip = inet->inet_daddr;
+
+	/* fill first 64 bit option field. */
+	options = TCAM_BYPASS_F | ULP_MODE_V(ULP_MODE_NONE) | NON_OFFLOAD_F |
+		  SMAC_SEL_V(tx_info->smt_idx) | TX_CHAN_V(tx_info->tx_chan);
+	cpl->opt0 = cpu_to_be64(options);
+
+	/* next 64 bit option field. */
+	options =
+		TX_QUEUE_V(tx_info->adap->params.tp.tx_modq[tx_info->tx_chan]);
+	cpl->opt2 = htonl(options);
+
+	return cxgb4_l2t_send(tx_info->netdev, skb, tx_info->l2te);
+}
+
+/*
+ * chcr_setup_connection:  create a TCB entry so that TP will form tcp packets.
+ * @sk - tcp socket.
+ * @tx_info - driver specific tls info.
+ * return: NET_TX_OK/NET_XMIT_DROP
+ */
+static int chcr_setup_connection(struct sock *sk,
+				 struct chcr_ktls_info *tx_info)
+{
+	struct tid_info *t = &tx_info->adap->tids;
+	int atid, ret = 0;
+
+	atid = cxgb4_alloc_atid(t, tx_info);
+	if (atid == -1)
+		return -EINVAL;
+
+	tx_info->atid = atid;
+	tx_info->ip_family = sk->sk_family;
+
+	if (sk->sk_family == AF_INET ||
+	    (sk->sk_family == AF_INET6 && !sk->sk_ipv6only &&
+	     ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
+		tx_info->ip_family = AF_INET;
+		ret = chcr_ktls_act_open_req(sk, tx_info, atid);
+	} else {
+		tx_info->ip_family = AF_INET6;
+		ret = -EOPNOTSUPP;
+	}
+
+	/* if return type is NET_XMIT_CN, msg will be sent but delayed, mark ret
+	 * success, if any other return type clear atid and return that failure.
+	 */
+	if (ret) {
+		if (ret == NET_XMIT_CN)
+			ret = 0;
+		else
+			cxgb4_free_atid(t, atid);
+	}
+
+	return ret;
+}
+
+/*
+ * chcr_set_tcb_field: update tcb fields.
+ * @tx_info - driver specific tls info.
+ * @word - TCB word.
+ * @mask - TCB word related mask.
+ * @val - TCB word related value.
+ * @no_reply - set 1 if not looking for TP response.
+ */
+static int chcr_set_tcb_field(struct chcr_ktls_info *tx_info, u16 word,
+			      u64 mask, u64 val, int no_reply)
+{
+	struct cpl_set_tcb_field *req;
+	struct sk_buff *skb;
+
+	skb = alloc_skb(sizeof(struct cpl_set_tcb_field), GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	req = (struct cpl_set_tcb_field *)__skb_put_zero(skb, sizeof(*req));
+	INIT_TP_WR_CPL(req, CPL_SET_TCB_FIELD, tx_info->tid);
+	req->reply_ctrl = htons(QUEUENO_V(tx_info->rx_qid) |
+				NO_REPLY_V(no_reply));
+	req->word_cookie = htons(TCB_WORD_V(word));
+	req->mask = cpu_to_be64(mask);
+	req->val = cpu_to_be64(val);
+
+	set_wr_txq(skb, CPL_PRIORITY_CONTROL, tx_info->port_id);
+	return cxgb4_ofld_send(tx_info->netdev, skb);
+}
+
+/*
+ * chcr_ktls_mark_tcb_close: mark tcb state to CLOSE
+ * @tx_info - driver specific tls info.
+ * return: NET_TX_OK/NET_XMIT_DROP.
+ */
+static int chcr_ktls_mark_tcb_close(struct chcr_ktls_info *tx_info)
+{
+	return chcr_set_tcb_field(tx_info, TCB_T_STATE_W,
+				  TCB_T_STATE_V(TCB_T_STATE_M),
+				  CHCR_TCB_STATE_CLOSED, 1);
+}
+
+/*
+ * chcr_ktls_dev_del:  call back for tls_dev_del.
+ * Remove the tid and l2t entry and close the connection.
+ * it per connection basis.
+ * @netdev - net device.
+ * @tls_cts - tls context.
+ * @direction - TX/RX crypto direction
+ */
+static void chcr_ktls_dev_del(struct net_device *netdev,
+			      struct tls_context *tls_ctx,
+			      enum tls_offload_ctx_dir direction)
+{
+	struct chcr_ktls_ofld_ctx_tx *tx_ctx =
+				chcr_get_ktls_tx_context(tls_ctx);
+	struct chcr_ktls_info *tx_info = tx_ctx->chcr_info;
+
+	if (!tx_info)
+		return;
+
+	spin_lock(&tx_info->lock);
+	tx_info->connection_state = KTLS_CONN_CLOSED;
+	spin_unlock(&tx_info->lock);
+
+	if (tx_info->l2te)
+		cxgb4_l2t_release(tx_info->l2te);
+
+	if (tx_info->tid != -1) {
+		/* clear tcb state and then release tid */
+		chcr_ktls_mark_tcb_close(tx_info);
+		cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
+				 tx_info->tid, tx_info->ip_family);
+	}
+	kvfree(tx_info);
+	tx_ctx->chcr_info = NULL;
+}
+
+/*
+ * chcr_ktls_dev_add:  call back for tls_dev_add.
+ * Create a tcb entry for TP. Also add l2t entry for the connection. And
+ * generate keys & save those keys locally.
+ * @netdev - net device.
+ * @tls_cts - tls context.
+ * @direction - TX/RX crypto direction
+ * return: SUCCESS/FAILURE.
+ */
+static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
+			     enum tls_offload_ctx_dir direction,
+			     struct tls_crypto_info *crypto_info,
+			     u32 start_offload_tcp_sn)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
+	struct chcr_ktls_info *tx_info;
+	struct dst_entry *dst;
+	struct adapter *adap;
+	struct port_info *pi;
+	struct neighbour *n;
+	u8 daaddr[16];
+	int ret = -1;
+
+	tx_ctx = chcr_get_ktls_tx_context(tls_ctx);
+
+	pi = netdev_priv(netdev);
+	adap = pi->adapter;
+	if (direction == TLS_OFFLOAD_CTX_DIR_RX) {
+		pr_err("not expecting for RX direction\n");
+		ret = -EINVAL;
+		goto out;
+	}
+	if (tx_ctx->chcr_info) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	tx_info = kvzalloc(sizeof(*tx_info), GFP_KERNEL);
+	if (!tx_info) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	spin_lock_init(&tx_info->lock);
+
+	/* clear connection state */
+	spin_lock(&tx_info->lock);
+	tx_info->connection_state = KTLS_CONN_CLOSED;
+	spin_unlock(&tx_info->lock);
+
+	tx_info->sk = sk;
+	/* initialize tid and atid to -1, 0 is a also a valid id. */
+	tx_info->tid = -1;
+	tx_info->atid = -1;
+
+	tx_info->adap = adap;
+	tx_info->netdev = netdev;
+	tx_info->tx_chan = pi->tx_chan;
+	tx_info->smt_idx = pi->smt_idx;
+	tx_info->port_id = pi->port_id;
+
+	tx_info->rx_qid = chcr_get_first_rx_qid(adap);
+	if (unlikely(tx_info->rx_qid < 0))
+		goto out2;
+
+	tx_info->prev_seq = start_offload_tcp_sn;
+	tx_info->tcp_start_seq_number = start_offload_tcp_sn;
+
+	/* get peer ip */
+	if (sk->sk_family == AF_INET ||
+	    (sk->sk_family == AF_INET6 && !sk->sk_ipv6only &&
+	     ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
+		memcpy(daaddr, &sk->sk_daddr, 4);
+	} else {
+		goto out2;
+	}
+
+	/* get the l2t index */
+	dst = sk_dst_get(sk);
+	if (!dst) {
+		pr_err("DST entry not found\n");
+		goto out2;
+	}
+	n = dst_neigh_lookup(dst, daaddr);
+	if (!n || !n->dev) {
+		pr_err("neighbour not found\n");
+		dst_release(dst);
+		goto out2;
+	}
+	tx_info->l2te  = cxgb4_l2t_get(adap->l2t, n, n->dev, 0);
+
+	neigh_release(n);
+	dst_release(dst);
+
+	if (!tx_info->l2te) {
+		pr_err("l2t entry not found\n");
+		goto out2;
+	}
+
+	tx_ctx->chcr_info = tx_info;
+
+	/* create a filter and call cxgb4_l2t_send to send the packet out, which
+	 * will take care of updating l2t entry in hw if not already done.
+	 */
+	ret = chcr_setup_connection(sk, tx_info);
+	if (ret)
+		goto out2;
+
+	return 0;
+out2:
+	kvfree(tx_info);
+out:
+	return ret;
+}
+
+static const struct tlsdev_ops chcr_ktls_ops = {
+	.tls_dev_add = chcr_ktls_dev_add,
+	.tls_dev_del = chcr_ktls_dev_del,
+};
+
+/*
+ * chcr_enable_ktls:  add NETIF_F_HW_TLS_TX flag in all the ports.
+ */
+void chcr_enable_ktls(struct adapter *adap)
+{
+	struct net_device *netdev;
+	int i;
+
+	for_each_port(adap, i) {
+		netdev = adap->port[i];
+		netdev->features |= NETIF_F_HW_TLS_TX;
+		netdev->hw_features |= NETIF_F_HW_TLS_TX;
+		netdev->tlsdev_ops = &chcr_ktls_ops;
+	}
+}
+
+/*
+ * chcr_disable_ktls:  remove NETIF_F_HW_TLS_TX flag from all the ports.
+ */
+void chcr_disable_ktls(struct adapter *adap)
+{
+	struct net_device *netdev;
+	int i;
+
+	for_each_port(adap, i) {
+		netdev = adap->port[i];
+		netdev->features &= ~NETIF_F_HW_TLS_TX;
+		netdev->hw_features &= ~NETIF_F_HW_TLS_TX;
+		netdev->tlsdev_ops = NULL;
+	}
+}
+#endif /* CONFIG_CHELSIO_TLS_DEVICE */
diff --git a/drivers/crypto/chelsio/chcr_ktls.h b/drivers/crypto/chelsio/chcr_ktls.h
new file mode 100644
index 000000000000..06520841da58
--- /dev/null
+++ b/drivers/crypto/chelsio/chcr_ktls.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2020 Chelsio Communications.  All rights reserved. */
+
+#ifndef __CHCR_KTLS_H__
+#define __CHCR_KTLS_H__
+
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+#include <net/tls.h>
+#include "cxgb4.h"
+#include "t4_msg.h"
+#include "t4_tcb.h"
+#include "l2t.h"
+#include "chcr_common.h"
+
+#define CHCR_TCB_STATE_CLOSED	0
+enum chcr_ktls_conn_state {
+	KTLS_CONN_CLOSED,
+};
+
+struct chcr_ktls_info {
+	struct sock *sk;
+	spinlock_t lock; /* state machine lock */
+	struct adapter *adap;
+	struct l2t_entry *l2te;
+	struct net_device *netdev;
+	int tid;
+	int atid;
+	int rx_qid;
+	u32 prev_seq;
+	u32 tcp_start_seq_number;
+	enum chcr_ktls_conn_state connection_state;
+	u8 tx_chan;
+	u8 smt_idx;
+	u8 port_id;
+	u8 ip_family;
+};
+
+struct chcr_ktls_ofld_ctx_tx {
+	struct tls_offload_context_tx base;
+	struct chcr_ktls_info *chcr_info;
+};
+
+static inline struct chcr_ktls_ofld_ctx_tx *
+chcr_get_ktls_tx_context(struct tls_context *tls_ctx)
+{
+	BUILD_BUG_ON(sizeof(struct chcr_ktls_ofld_ctx_tx) >
+		     TLS_OFFLOAD_CONTEXT_SIZE_TX);
+	return container_of(tls_offload_ctx_tx(tls_ctx),
+			    struct chcr_ktls_ofld_ctx_tx,
+			    base);
+}
+
+static inline int chcr_get_first_rx_qid(struct adapter *adap)
+{
+	/* u_ctx is saved in adap, fetch it */
+	struct uld_ctx *u_ctx = adap->uld[CXGB4_ULD_CRYPTO].handle;
+
+	if (!u_ctx)
+		return -1;
+	return u_ctx->lldi.rxq_ids[0];
+}
+
+void chcr_enable_ktls(struct adapter *adap);
+void chcr_disable_ktls(struct adapter *adap);
+#endif /* CONFIG_CHELSIO_TLS_DEVICE */
+#endif /* __CHCR_KTLS_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 8b7d156f79d3..66ffc5efeb06 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -640,6 +640,7 @@ enum {                                 /* adapter flags */
 enum {
 	ULP_CRYPTO_LOOKASIDE = 1 << 0,
 	ULP_CRYPTO_IPSEC_INLINE = 1 << 1,
+	ULP_CRYPTO_KTLS_INLINE  = 1 << 3,
 };
 
 struct rx_sw_desc;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index cce33d279094..056a03d8b59a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -662,6 +662,24 @@ static int uld_attach(struct adapter *adap, unsigned int uld)
 	return 0;
 }
 
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+/* cxgb4_set_ktls_feature: request FW to enable/disable ktls settings.
+ * @adap: adapter info
+ * @enable: 1 to enable / 0 to disable ktls settings.
+ */
+static void cxgb4_set_ktls_feature(struct adapter *adap, bool enable)
+{
+	int ret = 0;
+	u32 params = (FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_DEV) |
+		      FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_KTLS_TX_HW) |
+		      FW_PARAMS_PARAM_Y_V(enable));
+	ret = t4_set_params(adap, adap->mbox, adap->pf, 0, 1, &params, &params);
+	/* if fw returns failure, clear the ktls flag */
+	if (ret)
+		adap->params.crypto &= ~ULP_CRYPTO_KTLS_INLINE;
+}
+#endif
+
 /* cxgb4_register_uld - register an upper-layer driver
  * @type: the ULD type
  * @p: the ULD methods
@@ -698,6 +716,12 @@ void cxgb4_register_uld(enum cxgb4_uld type,
 		}
 		if (adap->flags & CXGB4_FULL_INIT_DONE)
 			enable_rx_uld(adap, type);
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+		/* send mbox to enable ktls related settings. */
+		if (type == CXGB4_ULD_CRYPTO &&
+		    (adap->params.crypto & FW_CAPS_CONFIG_TX_TLS_HW))
+			cxgb4_set_ktls_feature(adap, 1);
+#endif
 		if (adap->uld[type].add)
 			goto free_irq;
 		ret = setup_sge_txq_uld(adap, type, p);
@@ -750,6 +774,13 @@ int cxgb4_unregister_uld(enum cxgb4_uld type)
 			continue;
 
 		cxgb4_shutdown_uld_adapter(adap, type);
+
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+		/* send mbox to disable ktls related settings. */
+		if (type == CXGB4_ULD_CRYPTO &&
+		    (adap->params.crypto & FW_CAPS_CONFIG_TX_TLS_HW))
+			cxgb4_set_ktls_feature(adap, 0);
+#endif
 	}
 	mutex_unlock(&uld_mutex);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
index 1b9afb192f7f..1df93a35dfa0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
@@ -59,6 +59,11 @@
 #define TCB_RSS_INFO_M		0x3ffULL
 #define TCB_RSS_INFO_V(x)	((x) << TCB_RSS_INFO_S)
 
+#define TCB_T_STATE_W		3
+#define TCB_T_STATE_S		16
+#define TCB_T_STATE_M		0xfULL
+#define TCB_T_STATE_V(x)	((x) << TCB_T_STATE_S)
+
 #define TCB_TIMESTAMP_W		5
 #define TCB_TIMESTAMP_S		0
 #define TCB_TIMESTAMP_M		0xffffffffULL
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index accad1101ad1..dc0c2b79e8ee 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -1205,6 +1205,7 @@ enum fw_caps_config_crypto {
 	FW_CAPS_CONFIG_CRYPTO_LOOKASIDE = 0x00000001,
 	FW_CAPS_CONFIG_TLS_INLINE = 0x00000002,
 	FW_CAPS_CONFIG_IPSEC_INLINE = 0x00000004,
+	FW_CAPS_CONFIG_TX_TLS_HW = 0x00000008,
 };
 
 enum fw_caps_config_fcoe {
@@ -1328,6 +1329,7 @@ enum fw_params_param_dev {
 	FW_PARAMS_PARAM_DEV_DBQ_TIMERTICK = 0x2A,
 	FW_PARAMS_PARAM_DEV_NUM_TM_CLASS = 0x2B,
 	FW_PARAMS_PARAM_DEV_FILTER = 0x2E,
+	FW_PARAMS_PARAM_DEV_KTLS_TX_HW = 0x31,
 };
 
 /*
-- 
2.25.0.191.gde93cc1

