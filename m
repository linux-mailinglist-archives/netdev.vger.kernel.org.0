Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148EC3668A
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfFEVMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:23 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41759 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfFEVMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:21 -0400
Received: by mail-qt1-f196.google.com with SMTP id s57so223560qte.8
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wtjn18KGDSkMBtHgyLJiZkRqhJk2ccyxlrQk1FDA35Q=;
        b=eNcBOACoVXX2/8dFVE44W62umPs9shBSJ320mSSlVZ1r52Kth7OXa+EI6DUmOdv0Y6
         FuTdPt6bZ2XUdlWw0WschDhkDhrR3ATluiLfbr8hLM5G/4pRnb4CQQy+GYmeU5mkMoeJ
         EXyDu3hu11P8uMKrDhletoko8YmNEI8DbacFVqGkra95umAr7Ufvl0wyNhgSfLoZ7cZZ
         32I+T78x2JQJv45Yd0se4NlKgeWGk3hVPKjse2x4Yqz+PyjVu/qp6P/ZffbwfuAedII4
         m6+8puKXyh0p8fE1O6Nlh7+xzq8yc5VUnAn+2lFPO2gv+mik2McG6BrXs8xQe7IdK9mC
         b/9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wtjn18KGDSkMBtHgyLJiZkRqhJk2ccyxlrQk1FDA35Q=;
        b=p2OzU9xXRVHjIZoM2P/otdp2gxWxeJKQVMc1cpOjH+KlI7JHxvM/bvQO+x2BSEziYD
         3JEJuaLzW7/SkzSDS2lia5szBZnqnHeHKTdRsK6IZGIHXpjKDXbLyJ/BbNggf1EUNDjH
         6V/4ra1sDcnSTESsodYXrbFYJu+/gSISZXTb/8XQ5v6UwIIGw43aWC7wDbEaSexe9ejN
         /vY+eroya7ZJnkM2t/qh3JZV/wiejAr9L2kBgmh/2Q2YPii+3BLad7GGmeLeiwHMpTKD
         Q+XQy/SgCFwvwkWE962hj1i1uxredRU/0v/5APSOC+zlDCUoKjuXmLzhPApaZmtIBaO5
         Unww==
X-Gm-Message-State: APjAAAU72f1Q3ipsysFU71QYhREBSTupoHq77HA0NkOeVoJX7GOxVmJZ
        3oexCqEZ1NcKFKmN8G4YY2r+UA==
X-Google-Smtp-Source: APXvYqySR35F8SaKCQm2ggOP/xOQHJ8kszZH5WNVe9qX2Tf+diLOfP5R+jJwWAhYVLkRAtla+Vu8Ig==
X-Received: by 2002:ac8:2734:: with SMTP id g49mr9597099qtg.228.1559769140215;
        Wed, 05 Jun 2019 14:12:20 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.12.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:19 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 12/13] nfp: tls: add/delete TLS TX connections
Date:   Wed,  5 Jun 2019 14:11:42 -0700
Message-Id: <20190605211143.29689-13-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

This patch adds the functionality to add and delete TLS connections on
the NFP, received from the kernel TLS callbacks.

Make use of the common control message (CCM) infrastructure to propagate
the kernel state to firmware.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../net/ethernet/netronome/nfp/crypto/tls.c   | 300 +++++++++++++++++-
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   5 +-
 2 files changed, 303 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index c5909f069ee8..3e079c8469a2 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2019 Netronome Systems, Inc. */
 
+#include <linux/bitfield.h>
+#include <linux/ipv6.h>
 #include <linux/skbuff.h>
 #include <net/tls.h>
 
@@ -24,6 +26,71 @@
 #define NFP_NET_TLS_OPCODE_MASK						\
 	(NFP_NET_TLS_OPCODE_MASK_RX | NFP_NET_TLS_OPCODE_MASK_TX)
 
+static void nfp_net_crypto_set_op(struct nfp_net *nn, u8 opcode, bool on)
+{
+	u32 off, val;
+
+	off = nn->tlv_caps.crypto_enable_off + round_down(opcode / 8, 4);
+
+	val = nn_readl(nn, off);
+	if (on)
+		val |= BIT(opcode & 31);
+	else
+		val &= ~BIT(opcode & 31);
+	nn_writel(nn, off, val);
+}
+
+static bool
+__nfp_net_tls_conn_cnt_changed(struct nfp_net *nn, int add,
+			       enum tls_offload_ctx_dir direction)
+{
+	u8 opcode;
+	int cnt;
+
+	opcode = NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_ENC;
+	nn->ktls_tx_conn_cnt += add;
+	cnt = nn->ktls_tx_conn_cnt;
+	nn->dp.ktls_tx = !!nn->ktls_tx_conn_cnt;
+
+	/* Care only about 0 -> 1 and 1 -> 0 transitions */
+	if (cnt > 1)
+		return false;
+
+	nfp_net_crypto_set_op(nn, opcode, cnt);
+	return true;
+}
+
+static int
+nfp_net_tls_conn_cnt_changed(struct nfp_net *nn, int add,
+			     enum tls_offload_ctx_dir direction)
+{
+	int ret = 0;
+
+	/* Use the BAR lock to protect the connection counts */
+	nn_ctrl_bar_lock(nn);
+	if (__nfp_net_tls_conn_cnt_changed(nn, add, direction)) {
+		ret = __nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_CRYPTO);
+		/* Undo the cnt adjustment if failed */
+		if (ret)
+			__nfp_net_tls_conn_cnt_changed(nn, -add, direction);
+	}
+	nn_ctrl_bar_unlock(nn);
+
+	return ret;
+}
+
+static int
+nfp_net_tls_conn_add(struct nfp_net *nn, enum tls_offload_ctx_dir direction)
+{
+	return nfp_net_tls_conn_cnt_changed(nn, 1, direction);
+}
+
+static int
+nfp_net_tls_conn_remove(struct nfp_net *nn, enum tls_offload_ctx_dir direction)
+{
+	return nfp_net_tls_conn_cnt_changed(nn, -1, direction);
+}
+
 static struct sk_buff *
 nfp_net_tls_alloc_simple(struct nfp_net *nn, size_t req_sz, gfp_t flags)
 {
@@ -56,19 +123,245 @@ nfp_net_tls_communicate_simple(struct nfp_net *nn, struct sk_buff *skb,
 	return err;
 }
 
+static void nfp_net_tls_del_fw(struct nfp_net *nn, __be32 *fw_handle)
+{
+	struct nfp_crypto_req_del *req;
+	struct sk_buff *skb;
+
+	skb = nfp_net_tls_alloc_simple(nn, sizeof(*req), GFP_KERNEL);
+	if (!skb)
+		return;
+
+	req = (void *)skb->data;
+	req->ep_id = 0;
+	memcpy(req->handle, fw_handle, sizeof(req->handle));
+
+	nfp_net_tls_communicate_simple(nn, skb, "delete",
+				       NFP_CCM_TYPE_CRYPTO_DEL);
+}
+
+static struct nfp_crypto_req_add_back *
+nfp_net_tls_set_ipv4(struct nfp_crypto_req_add_v4 *req, struct sock *sk,
+		     int direction)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	req->front.key_len += sizeof(__be32) * 2;
+	req->front.ipver_vlan = cpu_to_be16(FIELD_PREP(NFP_NET_TLS_IPVER, 4) |
+					    FIELD_PREP(NFP_NET_TLS_VLAN,
+						       NFP_NET_TLS_VLAN_UNUSED));
+
+	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
+		req->src_ip = inet->inet_saddr;
+		req->dst_ip = inet->inet_daddr;
+	} else {
+		req->src_ip = inet->inet_daddr;
+		req->dst_ip = inet->inet_saddr;
+	}
+
+	return &req->back;
+}
+
+static struct nfp_crypto_req_add_back *
+nfp_net_tls_set_ipv6(struct nfp_crypto_req_add_v6 *req, struct sock *sk,
+		     int direction)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	struct ipv6_pinfo *np = inet6_sk(sk);
+
+	req->front.key_len += sizeof(struct in6_addr) * 2;
+	req->front.ipver_vlan = cpu_to_be16(FIELD_PREP(NFP_NET_TLS_IPVER, 6) |
+					    FIELD_PREP(NFP_NET_TLS_VLAN,
+						       NFP_NET_TLS_VLAN_UNUSED));
+
+	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
+		memcpy(req->src_ip, &np->saddr, sizeof(req->src_ip));
+		memcpy(req->dst_ip, &sk->sk_v6_daddr, sizeof(req->dst_ip));
+	} else {
+		memcpy(req->src_ip, &sk->sk_v6_daddr, sizeof(req->src_ip));
+		memcpy(req->dst_ip, &np->saddr, sizeof(req->dst_ip));
+	}
+
+#endif
+	return &req->back;
+}
+
+static void
+nfp_net_tls_set_l4(struct nfp_crypto_req_add_front *front,
+		   struct nfp_crypto_req_add_back *back, struct sock *sk,
+		   int direction)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	front->l4_proto = IPPROTO_TCP;
+
+	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
+		back->src_port = inet->inet_sport;
+		back->dst_port = inet->inet_dport;
+	} else {
+		back->src_port = inet->inet_dport;
+		back->dst_port = inet->inet_sport;
+	}
+}
+
+static u8 nfp_tls_1_2_dir_to_opcode(enum tls_offload_ctx_dir direction)
+{
+	switch (direction) {
+	case TLS_OFFLOAD_CTX_DIR_TX:
+		return NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_ENC;
+	case TLS_OFFLOAD_CTX_DIR_RX:
+		return NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_DEC;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+}
+
+static bool
+nfp_net_cipher_supported(struct nfp_net *nn, u16 cipher_type,
+			 enum tls_offload_ctx_dir direction)
+{
+	u8 bit;
+
+	switch (cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		if (direction == TLS_OFFLOAD_CTX_DIR_TX)
+			bit = NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_ENC;
+		else
+			return false;
+		break;
+	default:
+		return false;
+	}
+
+	return nn->tlv_caps.crypto_ops & BIT(bit);
+}
+
 static int
 nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 		enum tls_offload_ctx_dir direction,
 		struct tls_crypto_info *crypto_info,
 		u32 start_offload_tcp_sn)
 {
-	return -EOPNOTSUPP;
+	struct tls12_crypto_info_aes_gcm_128 *tls_ci;
+	struct nfp_net *nn = netdev_priv(netdev);
+	struct nfp_crypto_req_add_front *front;
+	struct nfp_net_tls_offload_ctx *ntls;
+	struct nfp_crypto_req_add_back *back;
+	struct nfp_crypto_reply_add *reply;
+	struct sk_buff *skb;
+	size_t req_sz;
+	bool ipv6;
+	int err;
+
+	BUILD_BUG_ON(sizeof(struct nfp_net_tls_offload_ctx) >
+		     TLS_DRIVER_STATE_SIZE_TX);
+
+	if (!nfp_net_cipher_supported(nn, crypto_info->cipher_type, direction))
+		return -EOPNOTSUPP;
+
+	switch (sk->sk_family) {
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		if (sk->sk_ipv6only ||
+		    ipv6_addr_type(&sk->sk_v6_daddr) != IPV6_ADDR_MAPPED) {
+			req_sz = sizeof(struct nfp_crypto_req_add_v6);
+			ipv6 = true;
+			break;
+		}
+#endif
+		/* fall through */
+	case AF_INET:
+		req_sz = sizeof(struct nfp_crypto_req_add_v4);
+		ipv6 = false;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	err = nfp_net_tls_conn_add(nn, direction);
+	if (err)
+		return err;
+
+	skb = nfp_ccm_mbox_alloc(nn, req_sz, sizeof(*reply), GFP_KERNEL);
+	if (!skb) {
+		err = -ENOMEM;
+		goto err_conn_remove;
+	}
+
+	front = (void *)skb->data;
+	front->ep_id = 0;
+	front->key_len = 8;
+	front->opcode = nfp_tls_1_2_dir_to_opcode(direction);
+	memset(front->resv, 0, sizeof(front->resv));
+
+	if (ipv6)
+		back = nfp_net_tls_set_ipv6((void *)skb->data, sk, direction);
+	else
+		back = nfp_net_tls_set_ipv4((void *)skb->data, sk, direction);
+
+	nfp_net_tls_set_l4(front, back, sk, direction);
+
+	back->counter = 0;
+	back->tcp_seq = cpu_to_be32(start_offload_tcp_sn);
+
+	tls_ci = (struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+	memcpy(back->key, tls_ci->key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	memset(&back->key[TLS_CIPHER_AES_GCM_128_KEY_SIZE / 4], 0,
+	       sizeof(back->key) - TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	memcpy(back->iv, tls_ci->iv, TLS_CIPHER_AES_GCM_128_IV_SIZE);
+	memcpy(&back->salt, tls_ci->salt, TLS_CIPHER_AES_GCM_128_SALT_SIZE);
+	memcpy(back->rec_no, tls_ci->rec_seq, sizeof(tls_ci->rec_seq));
+
+	err = nfp_ccm_mbox_communicate(nn, skb, NFP_CCM_TYPE_CRYPTO_ADD,
+				       sizeof(*reply), sizeof(*reply));
+	if (err) {
+		nn_dp_warn(&nn->dp, "failed to add TLS: %d\n", err);
+		/* communicate frees skb on error */
+		goto err_conn_remove;
+	}
+
+	reply = (void *)skb->data;
+	err = -be32_to_cpu(reply->error);
+	if (err) {
+		if (err != -ENOSPC)
+			nn_dp_warn(&nn->dp,
+				   "failed to add TLS, FW replied: %d\n", err);
+		goto err_free_skb;
+	}
+
+	if (!reply->handle[0] && !reply->handle[1]) {
+		nn_dp_warn(&nn->dp, "FW returned NULL handle\n");
+		goto err_fw_remove;
+	}
+
+	ntls = tls_driver_ctx(sk, direction);
+	memcpy(ntls->fw_handle, reply->handle, sizeof(ntls->fw_handle));
+	ntls->next_seq = start_offload_tcp_sn;
+	dev_consume_skb_any(skb);
+
+	return 0;
+
+err_fw_remove:
+	nfp_net_tls_del_fw(nn, reply->handle);
+err_free_skb:
+	dev_consume_skb_any(skb);
+err_conn_remove:
+	nfp_net_tls_conn_remove(nn, direction);
+	return err;
 }
 
 static void
 nfp_net_tls_del(struct net_device *netdev, struct tls_context *tls_ctx,
 		enum tls_offload_ctx_dir direction)
 {
+	struct nfp_net *nn = netdev_priv(netdev);
+	struct nfp_net_tls_offload_ctx *ntls;
+
+	nfp_net_tls_conn_remove(nn, direction);
+
+	ntls = __tls_driver_ctx(tls_ctx, direction);
+	nfp_net_tls_del_fw(nn, ntls->fw_handle);
 }
 
 static const struct tlsdev_ops nfp_net_tls_ops = {
@@ -121,6 +414,11 @@ int nfp_net_tls_init(struct nfp_net *nn)
 	if (err)
 		return err;
 
+	if (nn->tlv_caps.crypto_ops & NFP_NET_TLS_OPCODE_MASK_TX) {
+		netdev->hw_features |= NETIF_F_HW_TLS_TX;
+		netdev->features |= NETIF_F_HW_TLS_TX;
+	}
+
 	netdev->tlsdev_ops = &nfp_net_tls_ops;
 
 	return 0;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 689e9e1938c8..8c1639a83fd4 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -552,7 +552,7 @@ struct nfp_net_dp {
  * @reconfig_timer:	Timer for async reading of reconfig results
  * @reconfig_in_progress_update:	Update FW is processing now (debug only)
  * @bar_lock:		vNIC config BAR access lock, protects: update,
- *			mailbox area
+ *			mailbox area, crypto TLV
  * @link_up:            Is the link up?
  * @link_status_lock:	Protects @link_* and ensures atomicity with BAR reading
  * @rx_coalesce_usecs:      RX interrupt moderation usecs delay parameter
@@ -565,6 +565,7 @@ struct nfp_net_dp {
  * @tx_bar:             Pointer to mapped TX queues
  * @rx_bar:             Pointer to mapped FL/RX queues
  * @tlv_caps:		Parsed TLV capabilities
+ * @ktls_tx_conn_cnt:	Number of offloaded kTLS TX connections
  * @mbox_cmsg:		Common Control Message via vNIC mailbox state
  * @mbox_cmsg.queue:	CCM mbox queue of pending messages
  * @mbox_cmsg.wq:	CCM mbox wait queue of waiting processes
@@ -644,6 +645,8 @@ struct nfp_net {
 
 	struct nfp_net_tlv_caps tlv_caps;
 
+	unsigned int ktls_tx_conn_cnt;
+
 	struct {
 		struct sk_buff_head queue;
 		wait_queue_head_t wq;
-- 
2.21.0

