Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86153C274
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391145AbfFKElF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:41:05 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37455 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391138AbfFKElE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:41:04 -0400
Received: by mail-qt1-f193.google.com with SMTP id y57so13038329qtk.4
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LdjZy9Dq4Lsk1p+6vF1Hh0+HGHCCMvmIbAatb5ZQnlg=;
        b=2JpzNJFPi1F9TYk38Cu/9QdZ7ziYGO1Hto5MpZWDW8ufJ3wcr6CyplvWhqVwQH6HYE
         zlIX3bKsBS98M4YXXKgLGAAc3j1yqL0wNLSoJQJu23rvHeIDSoAmodKTyoNG+ADDrM63
         rrMSN2j+yI3VQHjwh1y4gYMYrmZVU1zwkOViUfaQywCSLjtGmWZdFaBk37ocPlaiD0+0
         FzE3afOf72mmcdiq5MVX+3jdnb+olYdPGBaQy2PHp9VG/NS3gz/qCX6adm5lYjMLipdX
         grKwDDoEFPjuSdRTc4nenqoO1lzGd9X42q5JZgZjGJ8pyAiAZZKa8WUnqIwD+VJjjqaT
         8Ewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LdjZy9Dq4Lsk1p+6vF1Hh0+HGHCCMvmIbAatb5ZQnlg=;
        b=OX7GyJ4EGNXQhP+lnLuDn6NOFJIgVQC2Rr5ted8Rr8tjCaetSLOy0J1GBCjpgMBSSa
         DPCsEkm674rFgPoSJ1pc2MmpMb6RIo48aaSrVOrrKD7LHe3kJvVbzhbZ0FkZNsRoEypz
         57YZyX2jr0J1UemrTOchwPfrWG3+tE8iTOKgJavNgtqKM41Rqk8aWcHe3c3sfoN3aOLS
         MpDDTlhoMfdkvXWjaOIb+ToQfRJkPTQmCMbOlRLqUl+3i5/QrJyvveyhOq9WvX3bLII8
         N3ou5X1goB6Z3weRbYCFsqB6velgW4JdojIUpler7p1XHFS44IxFJeaNBohcK7tYV4c2
         O7Lg==
X-Gm-Message-State: APjAAAUafxEaeA1QRAcdIRzLFx9Li/asJN9VZQ7h5AuOcE2VSpGU7HXu
        GrSNdgU80sBal0XpYIoE7kTbRg==
X-Google-Smtp-Source: APXvYqx/v2YbxOcLBfp8zygR/3GlfsOwS69CFPf8XjuKrLX7jjjIeFXNDQdweafZbrB5z6bzjYFnqg==
X-Received: by 2002:a0c:89b7:: with SMTP id 52mr9513818qvr.199.1560228063208;
        Mon, 10 Jun 2019 21:41:03 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm2463375qtj.46.2019.06.10.21.41.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:41:02 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 09/12] nfp: tls: enable TLS RX offload
Date:   Mon, 10 Jun 2019 21:40:07 -0700
Message-Id: <20190611044010.29161-10-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611044010.29161-1-jakub.kicinski@netronome.com>
References: <20190611044010.29161-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool TLS RX feature based on NIC capabilities, and enable
TLS RX when connections are added for decryption.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 .../ethernet/netronome/nfp/crypto/crypto.h    |  5 ++++
 .../net/ethernet/netronome/nfp/crypto/tls.c   | 25 ++++++++++++++-----
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  2 ++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
index 1f97fb443134..591924ad920c 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
+++ b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
@@ -7,6 +7,11 @@
 struct nfp_net_tls_offload_ctx {
 	__be32 fw_handle[2];
 
+	u8 rx_end[0];
+	/* Tx only fields follow - Rx side does not have enough driver state
+	 * to fit these
+	 */
+
 	u32 next_seq;
 	bool out_of_sync;
 };
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index eebaf5e1621d..4427c1d42047 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -47,10 +47,16 @@ __nfp_net_tls_conn_cnt_changed(struct nfp_net *nn, int add,
 	u8 opcode;
 	int cnt;
 
-	opcode = NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_ENC;
-	nn->ktls_tx_conn_cnt += add;
-	cnt = nn->ktls_tx_conn_cnt;
-	nn->dp.ktls_tx = !!nn->ktls_tx_conn_cnt;
+	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
+		opcode = NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_ENC;
+		nn->ktls_tx_conn_cnt += add;
+		cnt = nn->ktls_tx_conn_cnt;
+		nn->dp.ktls_tx = !!nn->ktls_tx_conn_cnt;
+	} else {
+		opcode = NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_DEC;
+		nn->ktls_rx_conn_cnt += add;
+		cnt = nn->ktls_rx_conn_cnt;
+	}
 
 	/* Care only about 0 -> 1 and 1 -> 0 transitions */
 	if (cnt > 1)
@@ -228,7 +234,7 @@ nfp_net_cipher_supported(struct nfp_net *nn, u16 cipher_type,
 		if (direction == TLS_OFFLOAD_CTX_DIR_TX)
 			bit = NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_ENC;
 		else
-			return false;
+			bit = NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_DEC;
 		break;
 	default:
 		return false;
@@ -256,6 +262,8 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 
 	BUILD_BUG_ON(sizeof(struct nfp_net_tls_offload_ctx) >
 		     TLS_DRIVER_STATE_SIZE_TX);
+	BUILD_BUG_ON(offsetof(struct nfp_net_tls_offload_ctx, rx_end) >
+		     TLS_DRIVER_STATE_SIZE_RX);
 
 	if (!nfp_net_cipher_supported(nn, crypto_info->cipher_type, direction))
 		return -EOPNOTSUPP;
@@ -341,7 +349,8 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 
 	ntls = tls_driver_ctx(sk, direction);
 	memcpy(ntls->fw_handle, reply->handle, sizeof(ntls->fw_handle));
-	ntls->next_seq = start_offload_tcp_sn;
+	if (direction == TLS_OFFLOAD_CTX_DIR_TX)
+		ntls->next_seq = start_offload_tcp_sn;
 	dev_consume_skb_any(skb);
 
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX)
@@ -450,6 +459,10 @@ int nfp_net_tls_init(struct nfp_net *nn)
 	if (err)
 		return err;
 
+	if (nn->tlv_caps.crypto_ops & NFP_NET_TLS_OPCODE_MASK_RX) {
+		netdev->hw_features |= NETIF_F_HW_TLS_RX;
+		netdev->features |= NETIF_F_HW_TLS_RX;
+	}
 	if (nn->tlv_caps.crypto_ops & NFP_NET_TLS_OPCODE_MASK_TX) {
 		netdev->hw_features |= NETIF_F_HW_TLS_TX;
 		netdev->features |= NETIF_F_HW_TLS_TX;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 46305f181764..6bbd77ba56f2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -582,6 +582,7 @@ struct nfp_net_dp {
  * @rx_bar:             Pointer to mapped FL/RX queues
  * @tlv_caps:		Parsed TLV capabilities
  * @ktls_tx_conn_cnt:	Number of offloaded kTLS TX connections
+ * @ktls_rx_conn_cnt:	Number of offloaded kTLS RX connections
  * @ktls_no_space:	Counter of firmware rejecting kTLS connection due to
  *			lack of space
  * @mbox_cmsg:		Common Control Message via vNIC mailbox state
@@ -667,6 +668,7 @@ struct nfp_net {
 	struct nfp_net_tlv_caps tlv_caps;
 
 	unsigned int ktls_tx_conn_cnt;
+	unsigned int ktls_rx_conn_cnt;
 
 	atomic_t ktls_no_space;
 
-- 
2.21.0

