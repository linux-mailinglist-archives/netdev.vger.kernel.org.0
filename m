Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC5F12392F
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfLQWMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:12:46 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44752 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbfLQWMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:12:45 -0500
Received: by mail-lf1-f66.google.com with SMTP id v201so128557lfa.11
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 14:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QRibIqE0RwKltv9D7F0773HXANkeckaQQPHC4n7xEb8=;
        b=Q0XjNpzj4uT98ZWnPQTrkLrq3cvUn8n9EfWegYZqmDivPfRH0TyB/gFYu040QTw30J
         9c32z/VP473nyG1MwUgoGpt/K7+r4RS3yKgVubDOF7mbInlpgaq1k9e6/KyFQIiJhxaF
         TOJOozZF4EPdeWFV2aqimmumSq9kTttZNgTOUITMIzrjIt55LLqWT+kKUro9KVhji6/x
         NGTQheGRtU8IaS67hR3VT7gL5r5igFK0oSEhXdE8lN2DMPb3/3oyfY8yhmoaxoE8b9Ah
         div5bb6nh4qg+DfzyWgKCw5bD2iRu8TS1VzXI/I4sp05riVa7xmYJGYIRXupkNB0jXFq
         xenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QRibIqE0RwKltv9D7F0773HXANkeckaQQPHC4n7xEb8=;
        b=aU352R4cmkLnjoZK/Rmfl1MxiolQqsVuJRnYNwGbAi9RTmd7ndwYxZr8dS3IKLrTX7
         lYyg1ilr43uO6o2IfNGLIvsAANyESUKyOwpy8pQxSg2wW3eGxQUc/hKDmPkVq0mgRmbi
         y9xoSOm/ycaXyzN4fmhUIPzRI8/rJv/0D6V1lRViUv0+JlTytMHBYbmimRuLo8T0eM4f
         j68NN0laKSGkxu2vvusPRIx7VrRz1332wobPIWQpf2WFIzfKTn2cUWOkZgvFQt2KxqRj
         AbHwmKVvq9e1sJK9ZNt9Ma0E4U8mj6kGBLN4U1QEgMpqYRKcBX3k9aYpQvByzfYi+pGh
         1G/w==
X-Gm-Message-State: APjAAAWVJim1tUQC6QtEl0YkOYLfBJSpCg0+8H04go6mosSNAZDHLVJ/
        wWJFkGcvw/ZbDJMyStA2+mBkryZQ6Js=
X-Google-Smtp-Source: APXvYqze0jib5d5meu4GshZ/wmUXmuxpTJxkMcHOpH/7pMj0dFY5MMcaROD9xUXMoAhXNVHz04Gq8g==
X-Received: by 2002:a19:784:: with SMTP id 126mr4067031lfh.191.1576620762943;
        Tue, 17 Dec 2019 14:12:42 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u9sm13333440lju.95.2019.12.17.14.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:12:42 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 3/3] nfp: tls: implement the stream sync RX resync
Date:   Tue, 17 Dec 2019 14:12:02 -0800
Message-Id: <20191217221202.12611-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191217221202.12611-1-jakub.kicinski@netronome.com>
References: <20191217221202.12611-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The simple RX resync strategy controlled by the kernel does not
guarantee as good results as if the device helps by detecting
the potential record boundaries and keeping track of them.

We've called this strategy stream scan in the tls-offload doc.

Implement this strategy for the NFP. The device sends a request
for record boundary confirmation, which is then recorded in
per-TLS socket state and responded to once record is reached.
Because the device keeps track of records passing after the
request was sent the response is not as latency sensitive as
when kernel just tries to tell the device the information
about the next record.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/ccm.h      |  1 +
 .../ethernet/netronome/nfp/crypto/crypto.h    | 15 ++++
 .../net/ethernet/netronome/nfp/crypto/fw.h    |  8 ++
 .../net/ethernet/netronome/nfp/crypto/tls.c   | 89 +++++++++++++++++--
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  6 ++
 .../ethernet/netronome/nfp/nfp_net_common.c   | 11 ++-
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.c | 41 +++++++--
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  9 ++
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  8 +-
 9 files changed, 172 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/ccm.h b/drivers/net/ethernet/netronome/nfp/ccm.h
index a460c75522be..d81d450be50e 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm.h
+++ b/drivers/net/ethernet/netronome/nfp/ccm.h
@@ -26,6 +26,7 @@ enum nfp_ccm_type {
 	NFP_CCM_TYPE_CRYPTO_ADD		= 10,
 	NFP_CCM_TYPE_CRYPTO_DEL		= 11,
 	NFP_CCM_TYPE_CRYPTO_UPDATE	= 12,
+	NFP_CCM_TYPE_CRYPTO_RESYNC	= 13,
 	__NFP_CCM_TYPE_MAX,
 };
 
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
index 60372ddf69f0..bffe58bb2f27 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
+++ b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
@@ -4,6 +4,10 @@
 #ifndef NFP_CRYPTO_H
 #define NFP_CRYPTO_H 1
 
+struct net_device;
+struct nfp_net;
+struct nfp_net_tls_resync_req;
+
 struct nfp_net_tls_offload_ctx {
 	__be32 fw_handle[2];
 
@@ -17,11 +21,22 @@ struct nfp_net_tls_offload_ctx {
 
 #ifdef CONFIG_TLS_DEVICE
 int nfp_net_tls_init(struct nfp_net *nn);
+int nfp_net_tls_rx_resync_req(struct net_device *netdev,
+			      struct nfp_net_tls_resync_req *req,
+			      void *pkt, unsigned int pkt_len);
 #else
 static inline int nfp_net_tls_init(struct nfp_net *nn)
 {
 	return 0;
 }
+
+static inline int
+nfp_net_tls_rx_resync_req(struct net_device *netdev,
+			  struct nfp_net_tls_resync_req *req,
+			  void *pkt, unsigned int pkt_len)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/fw.h b/drivers/net/ethernet/netronome/nfp/crypto/fw.h
index 67413d946c4a..8d1458896bcb 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/fw.h
+++ b/drivers/net/ethernet/netronome/nfp/crypto/fw.h
@@ -9,6 +9,14 @@
 #define NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_ENC	0
 #define NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_DEC	1
 
+struct nfp_net_tls_resync_req {
+	__be32 fw_handle[2];
+	__be32 tcp_seq;
+	u8 l3_offset;
+	u8 l4_offset;
+	u8 resv[2];
+};
+
 struct nfp_crypto_reply_simple {
 	struct nfp_ccm_hdr hdr;
 	__be32 error;
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index 96a96b35c0ca..7c50e3dfb9d5 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -5,6 +5,7 @@
 #include <linux/ipv6.h>
 #include <linux/skbuff.h>
 #include <linux/string.h>
+#include <net/inet6_hashtables.h>
 #include <net/tls.h>
 
 #include "../ccm.h"
@@ -391,8 +392,9 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX)
 		return 0;
 
-	tls_offload_rx_resync_set_type(sk,
-				       TLS_OFFLOAD_SYNC_TYPE_CORE_NEXT_HINT);
+	if (!nn->tlv_caps.tls_resync_ss)
+		tls_offload_rx_resync_set_type(sk, TLS_OFFLOAD_SYNC_TYPE_CORE_NEXT_HINT);
+
 	return 0;
 
 err_fw_remove:
@@ -424,6 +426,7 @@ nfp_net_tls_resync(struct net_device *netdev, struct sock *sk, u32 seq,
 	struct nfp_net *nn = netdev_priv(netdev);
 	struct nfp_net_tls_offload_ctx *ntls;
 	struct nfp_crypto_req_update *req;
+	enum nfp_ccm_type type;
 	struct sk_buff *skb;
 	gfp_t flags;
 	int err;
@@ -442,15 +445,18 @@ nfp_net_tls_resync(struct net_device *netdev, struct sock *sk, u32 seq,
 	req->tcp_seq = cpu_to_be32(seq);
 	memcpy(req->rec_no, rcd_sn, sizeof(req->rec_no));
 
+	type = NFP_CCM_TYPE_CRYPTO_UPDATE;
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
-		err = nfp_net_tls_communicate_simple(nn, skb, "sync",
-						     NFP_CCM_TYPE_CRYPTO_UPDATE);
+		err = nfp_net_tls_communicate_simple(nn, skb, "sync", type);
 		if (err)
 			return err;
 		ntls->next_seq = seq;
 	} else {
-		nfp_ccm_mbox_post(nn, skb, NFP_CCM_TYPE_CRYPTO_UPDATE,
+		if (nn->tlv_caps.tls_resync_ss)
+			type = NFP_CCM_TYPE_CRYPTO_RESYNC;
+		nfp_ccm_mbox_post(nn, skb, type,
 				  sizeof(struct nfp_crypto_reply_simple));
+		atomic_inc(&nn->ktls_rx_resync_sent);
 	}
 
 	return 0;
@@ -462,6 +468,79 @@ static const struct tlsdev_ops nfp_net_tls_ops = {
 	.tls_dev_resync = nfp_net_tls_resync,
 };
 
+int nfp_net_tls_rx_resync_req(struct net_device *netdev,
+			      struct nfp_net_tls_resync_req *req,
+			      void *pkt, unsigned int pkt_len)
+{
+	struct nfp_net *nn = netdev_priv(netdev);
+	struct nfp_net_tls_offload_ctx *ntls;
+	struct ipv6hdr *ipv6h;
+	struct tcphdr *th;
+	struct iphdr *iph;
+	struct sock *sk;
+	__be32 tcp_seq;
+	int err;
+
+	iph = pkt + req->l3_offset;
+	ipv6h = pkt + req->l3_offset;
+	th = pkt + req->l4_offset;
+
+	if ((u8 *)&th[1] > (u8 *)pkt + pkt_len) {
+		netdev_warn_once(netdev, "invalid TLS RX resync request (l3_off: %hhu l4_off: %hhu pkt_len: %u)\n",
+				 req->l3_offset, req->l4_offset, pkt_len);
+		err = -EINVAL;
+		goto err_cnt_ign;
+	}
+
+	switch (iph->version) {
+	case 4:
+		sk = inet_lookup_established(dev_net(netdev), &tcp_hashinfo,
+					     iph->saddr, th->source, iph->daddr,
+					     th->dest, netdev->ifindex);
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case 6:
+		sk = __inet6_lookup_established(dev_net(netdev), &tcp_hashinfo,
+						&ipv6h->saddr, th->source,
+						&ipv6h->daddr, ntohs(th->dest),
+						netdev->ifindex, 0);
+		break;
+#endif
+	default:
+		netdev_warn_once(netdev, "invalid TLS RX resync request (l3_off: %hhu l4_off: %hhu ipver: %u)\n",
+				 req->l3_offset, req->l4_offset, iph->version);
+		err = -EINVAL;
+		goto err_cnt_ign;
+	}
+
+	err = 0;
+	if (!sk)
+		goto err_cnt_ign;
+	if (!tls_is_sk_rx_device_offloaded(sk) ||
+	    sk->sk_shutdown & RCV_SHUTDOWN)
+		goto err_put_sock;
+
+	ntls = tls_driver_ctx(sk, TLS_OFFLOAD_CTX_DIR_RX);
+	/* some FW versions can't report the handle and report 0s */
+	if (memchr_inv(&req->fw_handle, 0, sizeof(req->fw_handle)) &&
+	    memcmp(&req->fw_handle, &ntls->fw_handle, sizeof(ntls->fw_handle)))
+		goto err_put_sock;
+
+	/* copy to ensure alignment */
+	memcpy(&tcp_seq, &req->tcp_seq, sizeof(tcp_seq));
+	tls_offload_rx_resync_request(sk, tcp_seq);
+	atomic_inc(&nn->ktls_rx_resync_req);
+
+	sock_gen_put(sk);
+	return 0;
+
+err_put_sock:
+	sock_gen_put(sk);
+err_cnt_ign:
+	atomic_inc(&nn->ktls_rx_resync_ign);
+	return err;
+}
+
 static int nfp_net_tls_reset(struct nfp_net *nn)
 {
 	struct nfp_crypto_req_reset *req;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 250f510b1d21..ff4438478ea9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -586,6 +586,9 @@ struct nfp_net_dp {
  * @ktls_conn_id_gen:	Trivial generator for kTLS connection ids (for TX)
  * @ktls_no_space:	Counter of firmware rejecting kTLS connection due to
  *			lack of space
+ * @ktls_rx_resync_req:	Counter of TLS RX resync requested
+ * @ktls_rx_resync_ign:	Counter of TLS RX resync requests ignored
+ * @ktls_rx_resync_sent:    Counter of TLS RX resync completed
  * @mbox_cmsg:		Common Control Message via vNIC mailbox state
  * @mbox_cmsg.queue:	CCM mbox queue of pending messages
  * @mbox_cmsg.wq:	CCM mbox wait queue of waiting processes
@@ -674,6 +677,9 @@ struct nfp_net {
 	atomic64_t ktls_conn_id_gen;
 
 	atomic_t ktls_no_space;
+	atomic_t ktls_rx_resync_req;
+	atomic_t ktls_rx_resync_ign;
+	atomic_t ktls_rx_resync_sent;
 
 	struct {
 		struct sk_buff_head queue;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 780bd1daa601..9bfb3b077bc1 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -47,6 +47,7 @@
 #include "nfp_net_sriov.h"
 #include "nfp_port.h"
 #include "crypto/crypto.h"
+#include "crypto/fw.h"
 
 /**
  * nfp_net_get_fw_version() - Read and parse the FW version
@@ -1663,7 +1664,7 @@ nfp_net_set_hash_desc(struct net_device *netdev, struct nfp_meta_parsed *meta,
 
 static bool
 nfp_net_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
-		   void *data, void *pkt, int meta_len)
+		   void *data, void *pkt, unsigned int pkt_len, int meta_len)
 {
 	u32 meta_info;
 
@@ -1693,6 +1694,12 @@ nfp_net_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 				(__force __wsum)__get_unaligned_cpu32(data);
 			data += 4;
 			break;
+		case NFP_NET_META_RESYNC_INFO:
+			if (nfp_net_tls_rx_resync_req(netdev, data, pkt,
+						      pkt_len))
+				return NULL;
+			data += sizeof(struct nfp_net_tls_resync_req);
+			break;
 		default:
 			return true;
 		}
@@ -1888,7 +1895,7 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			if (unlikely(nfp_net_parse_meta(dp->netdev, &meta,
 							rxbuf->frag + meta_off,
 							rxbuf->frag + pkt_off,
-							meta_len))) {
+							pkt_len, meta_len))) {
 				nn_dp_warn(dp, "invalid RX packet metadata\n");
 				nfp_net_rx_drop(dp, r_vec, rx_ring, rxbuf,
 						NULL);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
index 45756648a85c..c3a763134e79 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
@@ -17,6 +17,30 @@ static void nfp_net_tlv_caps_reset(struct nfp_net_tlv_caps *caps)
 	caps->mbox_len = NFP_NET_CFG_MBOX_VAL_MAX_SZ;
 }
 
+static bool
+nfp_net_tls_parse_crypto_ops(struct device *dev, struct nfp_net_tlv_caps *caps,
+			     u8 __iomem *ctrl_mem, u8 __iomem *data,
+			     unsigned int length, unsigned int offset,
+			     bool rx_stream_scan)
+{
+	/* Ignore the legacy TLV if new one was already parsed */
+	if (caps->tls_resync_ss && !rx_stream_scan)
+		return true;
+
+	if (length < 32) {
+		dev_err(dev,
+			"CRYPTO OPS TLV should be at least 32B, is %dB offset:%u\n",
+			length, offset);
+		return false;
+	}
+
+	caps->crypto_ops = readl(data);
+	caps->crypto_enable_off = data - ctrl_mem + 16;
+	caps->tls_resync_ss = rx_stream_scan;
+
+	return true;
+}
+
 int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
 			   struct nfp_net_tlv_caps *caps)
 {
@@ -104,15 +128,10 @@ int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
 				caps->mbox_cmsg_types = readl(data);
 			break;
 		case NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS:
-			if (length < 32) {
-				dev_err(dev,
-					"CRYPTO OPS TLV should be at least 32B, is %dB offset:%u\n",
-					length, offset);
+			if (!nfp_net_tls_parse_crypto_ops(dev, caps, ctrl_mem,
+							  data, length, offset,
+							  false))
 				return -EINVAL;
-			}
-
-			caps->crypto_ops = readl(data);
-			caps->crypto_enable_off = data - ctrl_mem + 16;
 			break;
 		case NFP_NET_CFG_TLV_TYPE_VNIC_STATS:
 			if ((data - ctrl_mem) % 8) {
@@ -123,6 +142,12 @@ int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
 			caps->vnic_stats_off = data - ctrl_mem;
 			caps->vnic_stats_cnt = length / 10;
 			break;
+		case NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS_RX_SCAN:
+			if (!nfp_net_tls_parse_crypto_ops(dev, caps, ctrl_mem,
+							  data, length, offset,
+							  true))
+				return -EINVAL;
+			break;
 		default:
 			if (!FIELD_GET(NFP_NET_CFG_TLV_HEADER_REQUIRED, hdr))
 				break;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index c38cc36a2a70..3d61a8cb60b0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -45,6 +45,7 @@
 #define NFP_NET_META_PORTID		5
 #define NFP_NET_META_CSUM		6 /* checksum complete type */
 #define NFP_NET_META_CONN_HANDLE	7
+#define NFP_NET_META_RESYNC_INFO	8 /* RX resync info request */
 
 #define NFP_META_PORT_ID_CTRL		~0U
 
@@ -479,6 +480,7 @@
  * 8 words, bitmaps of supported and enabled crypto operations.
  * First 16B (4 words) contains a bitmap of supported crypto operations,
  * and next 16B contain the enabled operations.
+ * This capability is made obsolete by ones with better sync methods.
  *
  * %NFP_NET_CFG_TLV_TYPE_VNIC_STATS:
  * Variable, per-vNIC statistics, data should be 8B aligned (FW should insert
@@ -490,6 +492,10 @@
  * This TLV overwrites %NFP_NET_CFG_STATS_* values (statistics in this TLV
  * duplicate the old ones, so driver should be careful not to unnecessarily
  * render both).
+ *
+ * %NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS_RX_SCAN:
+ * Same as %NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS, but crypto TLS does stream scan
+ * RX sync, rather than kernel-assisted sync.
  */
 #define NFP_NET_CFG_TLV_TYPE_UNKNOWN		0
 #define NFP_NET_CFG_TLV_TYPE_RESERVED		1
@@ -502,6 +508,7 @@
 #define NFP_NET_CFG_TLV_TYPE_MBOX_CMSG_TYPES	10
 #define NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS		11 /* see crypto/fw.h */
 #define NFP_NET_CFG_TLV_TYPE_VNIC_STATS		12
+#define NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS_RX_SCAN	13
 
 struct device;
 
@@ -516,6 +523,7 @@ struct device;
  * @crypto_enable_off:	offset of crypto ops enable region
  * @vnic_stats_off:	offset of vNIC stats area
  * @vnic_stats_cnt:	number of vNIC stats
+ * @tls_resync_ss:	TLS resync will be performed via stream scan
  */
 struct nfp_net_tlv_caps {
 	u32 me_freq_mhz;
@@ -527,6 +535,7 @@ struct nfp_net_tlv_caps {
 	unsigned int crypto_enable_off;
 	unsigned int vnic_stats_off;
 	unsigned int vnic_stats_cnt;
+	unsigned int tls_resync_ss:1;
 };
 
 int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index b386a221c599..d648e32c0520 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -174,7 +174,7 @@ static const char nfp_tlv_stat_names[][ETH_GSTRING_LEN] = {
 #define NN_ET_SWITCH_STATS_LEN 9
 #define NN_RVEC_GATHER_STATS	13
 #define NN_RVEC_PER_Q_STATS	3
-#define NN_CTRL_PATH_STATS	1
+#define NN_CTRL_PATH_STATS	4
 
 #define SFP_SFF_REV_COMPLIANCE	1
 
@@ -476,6 +476,9 @@ static u8 *nfp_vnic_get_sw_stats_strings(struct net_device *netdev, u8 *data)
 	data = nfp_pr_et(data, "tx_tls_drop_no_sync_data");
 
 	data = nfp_pr_et(data, "hw_tls_no_space");
+	data = nfp_pr_et(data, "rx_tls_resync_req_ok");
+	data = nfp_pr_et(data, "rx_tls_resync_req_ign");
+	data = nfp_pr_et(data, "rx_tls_resync_sent");
 
 	return data;
 }
@@ -524,6 +527,9 @@ static u64 *nfp_vnic_get_sw_stats(struct net_device *netdev, u64 *data)
 		*data++ = gathered_stats[j];
 
 	*data++ = atomic_read(&nn->ktls_no_space);
+	*data++ = atomic_read(&nn->ktls_rx_resync_req);
+	*data++ = atomic_read(&nn->ktls_rx_resync_ign);
+	*data++ = atomic_read(&nn->ktls_rx_resync_sent);
 
 	return data;
 }
-- 
2.23.0

