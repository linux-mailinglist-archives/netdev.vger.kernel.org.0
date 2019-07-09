Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEC462E5B
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfGICxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:53:54 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40895 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbfGICxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:53:53 -0400
Received: by mail-qt1-f194.google.com with SMTP id a15so20158768qtn.7
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 19:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TjvXEgXOmt+wnqgwoP1vrxuNkLb40EhgYTMAZciwqzc=;
        b=HKcakBn88/0+w6k8CmKwb9Q1u/onPouNk4L2eZ4uPJGZHP6FRwMAPuPCmMmThsFsZ0
         hpGr0DcjL3nYlyFOevFf9vpHjzPI4pyaujDpxaUIRWP7Q6xasp2QxtvqJ3aUHouePxPb
         0EydvFDtjxkINPeOFScMx8MgSDLfansDMDDDCUyNC+uOo5Uzp6zhUrSJaTicOQlER05d
         kQjR98RlRHa9oZuR5bbz3BnkDU5d8QQQLFbAL8keaQiAT9Kft3ZS1utkt82/lrHme4d/
         h9C5CF2C6Z2ChI/NbKkJdCzVoehPylBrWV5pEEUxcU1NY89BO2TLs+Dn68UJae3PAZ0p
         oLAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TjvXEgXOmt+wnqgwoP1vrxuNkLb40EhgYTMAZciwqzc=;
        b=CfJiVlnbj3KLA3eZui4sAPxnXSO46gZYFskP3f1KW6gCnDJs/plzZhGalfmxL3ZzNr
         bqljxlNvSbn9z+nfqFgNwu3ac/p6AZau9g6aoaYd2ZJ9zVjDA8KBWWtNvppVjEwp3juB
         AapmWbP53HPRu+8JJVTx7dx5GlZ34CcS4RFGT5/2eORQ8sznKf8D5jYfaJnVa+jyy3ai
         bkyIzNc6CNqt7f4D3Q3CrgZY+wgeeVaEFdfpVZLufEnt/Znkt15KpedVCBLr0R3lciUd
         pJ4dvsIU1OjF9r6mZuAnzpp+64r2bvwPPQOfb6gyjUt4bbnGGdg7MMklh7FhhNrqSbU8
         Zk8g==
X-Gm-Message-State: APjAAAW3uU/8R21LdkiqAwAz6J9L/KAHHTPE8Eb6NUqo9NWZUGv9LyLD
        Y/KsQ95BP5DnpLvOl48Ehe9DaA==
X-Google-Smtp-Source: APXvYqzEThR8hN8aJqX55Od4y6qdMTwpbKaPvplQH76IPtenH92STL3Lu1hT2SPBNMu81/Dcwq391A==
X-Received: by 2002:aed:3461:: with SMTP id w88mr16828803qtd.13.1562640832700;
        Mon, 08 Jul 2019 19:53:52 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm8148837qkm.17.2019.07.08.19.53.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 19:53:52 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 06/11] net/tls: don't clear TX resync flag on error
Date:   Mon,  8 Jul 2019 19:53:13 -0700
Message-Id: <20190709025318.5534-7-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709025318.5534-1-jakub.kicinski@netronome.com>
References: <20190709025318.5534-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Introduce a return code for the tls_dev_resync callback.

When the driver TX resync fails, kernel can retry the resync again
until it succeeds.  This prevents drivers from attempting to offload
TLS packets if the connection is known to be out of sync.

We don't worry about the RX resync since they will be retried naturally
as more encrypted records get received.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c  |  8 +++++---
 drivers/net/ethernet/netronome/nfp/crypto/tls.c     | 13 +++++++++----
 include/net/tls.h                                   |  6 +++---
 net/tls/tls_device.c                                |  8 ++++++--
 4 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index f8b93b62a7d2..ca07c86427a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -160,9 +160,9 @@ static void mlx5e_tls_del(struct net_device *netdev,
 				direction == TLS_OFFLOAD_CTX_DIR_TX);
 }
 
-static void mlx5e_tls_resync(struct net_device *netdev, struct sock *sk,
-			     u32 seq, u8 *rcd_sn_data,
-			     enum tls_offload_ctx_dir direction)
+static int mlx5e_tls_resync(struct net_device *netdev, struct sock *sk,
+			    u32 seq, u8 *rcd_sn_data,
+			    enum tls_offload_ctx_dir direction)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -177,6 +177,8 @@ static void mlx5e_tls_resync(struct net_device *netdev, struct sock *sk,
 		    be64_to_cpu(rcd_sn));
 	mlx5_accel_tls_resync_rx(priv->mdev, rx_ctx->handle, seq, rcd_sn);
 	atomic64_inc(&priv->tls->sw_stats.rx_tls_resync_reply);
+
+	return 0;
 }
 
 static const struct tlsdev_ops mlx5e_tls_ops = {
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index b49405b4af55..d448c6de8ea4 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -403,7 +403,7 @@ nfp_net_tls_del(struct net_device *netdev, struct tls_context *tls_ctx,
 	nfp_net_tls_del_fw(nn, ntls->fw_handle);
 }
 
-static void
+static int
 nfp_net_tls_resync(struct net_device *netdev, struct sock *sk, u32 seq,
 		   u8 *rcd_sn, enum tls_offload_ctx_dir direction)
 {
@@ -412,11 +412,12 @@ nfp_net_tls_resync(struct net_device *netdev, struct sock *sk, u32 seq,
 	struct nfp_crypto_req_update *req;
 	struct sk_buff *skb;
 	gfp_t flags;
+	int err;
 
 	flags = direction == TLS_OFFLOAD_CTX_DIR_TX ? GFP_KERNEL : GFP_ATOMIC;
 	skb = nfp_net_tls_alloc_simple(nn, sizeof(*req), flags);
 	if (!skb)
-		return;
+		return -ENOMEM;
 
 	ntls = tls_driver_ctx(sk, direction);
 	req = (void *)skb->data;
@@ -428,13 +429,17 @@ nfp_net_tls_resync(struct net_device *netdev, struct sock *sk, u32 seq,
 	memcpy(req->rec_no, rcd_sn, sizeof(req->rec_no));
 
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
-		nfp_net_tls_communicate_simple(nn, skb, "sync",
-					       NFP_CCM_TYPE_CRYPTO_UPDATE);
+		err = nfp_net_tls_communicate_simple(nn, skb, "sync",
+						     NFP_CCM_TYPE_CRYPTO_UPDATE);
+		if (err)
+			return err;
 		ntls->next_seq = seq;
 	} else {
 		nfp_ccm_mbox_post(nn, skb, NFP_CCM_TYPE_CRYPTO_UPDATE,
 				  sizeof(struct nfp_crypto_reply_simple));
 	}
+
+	return 0;
 }
 
 static const struct tlsdev_ops nfp_net_tls_ops = {
diff --git a/include/net/tls.h b/include/net/tls.h
index 0279938386ab..0e4b9624361b 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -304,9 +304,9 @@ struct tlsdev_ops {
 	void (*tls_dev_del)(struct net_device *netdev,
 			    struct tls_context *ctx,
 			    enum tls_offload_ctx_dir direction);
-	void (*tls_dev_resync)(struct net_device *netdev,
-			       struct sock *sk, u32 seq, u8 *rcd_sn,
-			       enum tls_offload_ctx_dir direction);
+	int (*tls_dev_resync)(struct net_device *netdev,
+			      struct sock *sk, u32 seq, u8 *rcd_sn,
+			      enum tls_offload_ctx_dir direction);
 };
 
 enum tls_offload_sync_type {
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 40076f423dcb..56135f3ff4ff 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -214,6 +214,7 @@ static void tls_device_resync_tx(struct sock *sk, struct tls_context *tls_ctx,
 {
 	struct net_device *netdev;
 	struct sk_buff *skb;
+	int err = 0;
 	u8 *rcd_sn;
 
 	skb = tcp_write_queue_tail(sk);
@@ -225,9 +226,12 @@ static void tls_device_resync_tx(struct sock *sk, struct tls_context *tls_ctx,
 	down_read(&device_offload_lock);
 	netdev = tls_ctx->netdev;
 	if (netdev)
-		netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq, rcd_sn,
-						   TLS_OFFLOAD_CTX_DIR_TX);
+		err = netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq,
+							 rcd_sn,
+							 TLS_OFFLOAD_CTX_DIR_TX);
 	up_read(&device_offload_lock);
+	if (err)
+		return;
 
 	clear_bit_unlock(TLS_TX_SYNC_SCHED, &tls_ctx->flags);
 }
-- 
2.21.0

