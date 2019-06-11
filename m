Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D09F3C275
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391150AbfFKElH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:41:07 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44458 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391143AbfFKElG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:41:06 -0400
Received: by mail-qk1-f194.google.com with SMTP id w187so6815628qkb.11
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rpEG4LLGUMXTlMHw5B6wNzUxyBl7iCK4HJKVZDJ52gQ=;
        b=uToZ7uxV2137Xmney5po/rMJ+MwP2OgpmknW4hOnv9ncYfEByrL8wFGXA0N4fTwysQ
         r+P4MD8goZHehAkhhWkz80E202VZ9ju8kH02wJFAVyjz0Vxv/2cpCMDKOwsNqEmzJGku
         wIjwwdCLki7CUk3xRAkb85IflHkNGamDS3C0+6qjvqgs1P1l9s6C/0yRfQfqVUIAo7aq
         S9rqpmFj/EC8f9JMvvC2LcJthNloc+WJTvvMYEDzSZiR7uX0l9JJ8NJ8dAF215f9QK5l
         hEYFXXyK509Sgr5r4jCqxaVvrG5KWQlHqrjlxjoGGR9KjUsG45np3UJh2vTXKBRMSvjb
         cYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rpEG4LLGUMXTlMHw5B6wNzUxyBl7iCK4HJKVZDJ52gQ=;
        b=kDQ+bp3s8SNf1udns+tFyWfcXkuOzYmwK7zy6cfShN+UWfqvApXdslA7qotCeLlWDH
         vSgloiYpH8oiJ4y6sg7m6E+hYYJYeXOcqPbDqHoZeHHIrr20xLsAbnF7TMfjfCcE8yY9
         psGUNhJSueVTMKy6AUxZdqggA44TRDHilOj+wquV+09z3fq/ET0Xpg8IFlguz7MC2nLc
         L6ae+bf6XBvGd95Y3sQ4g9FJBVZ0X7/h+0t8JiftqHjTGs3CXvOZNuZQKq2ybFJuj73h
         moCtHXYmkwrCPC1muLngU5r05qANQq2C5n+gUfL0K1XzDzOvmNbkrVRme7hHf7vGWVlw
         luUg==
X-Gm-Message-State: APjAAAXy0Uq++0REvhsI7CoZfgs8jn1Dl2nckn2QGDKGui7ueN17TN/0
        ARwvlOYsKgVsUeHEGIb/hZWHzA==
X-Google-Smtp-Source: APXvYqxQJIMi9Z7kusksz59cgfX2WKC57eDNKImtsaHEWtTK+8an6m13LzQuCRKw7zGGcSLA8IWCGw==
X-Received: by 2002:a37:de13:: with SMTP id h19mr56518411qkj.59.1560228064819;
        Mon, 10 Jun 2019 21:41:04 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm2463375qtj.46.2019.06.10.21.41.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:41:04 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 10/12] net/tls: generalize the resync callback
Date:   Mon, 10 Jun 2019 21:40:08 -0700
Message-Id: <20190611044010.29161-11-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611044010.29161-1-jakub.kicinski@netronome.com>
References: <20190611044010.29161-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently only RX direction is ever resynced, however, TX may
also get out of sequence if packets get dropped on the way to
the driver.  Rename the resync callback and add a direction
parameter.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c | 9 ++++++---
 drivers/net/ethernet/netronome/nfp/crypto/tls.c        | 9 ++++++---
 include/net/tls.h                                      | 5 +++--
 net/tls/tls_device.c                                   | 5 +++--
 4 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index d65150aa8298..dc15c5c9e557 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -160,14 +160,17 @@ static void mlx5e_tls_del(struct net_device *netdev,
 				direction == TLS_OFFLOAD_CTX_DIR_TX);
 }
 
-static void mlx5e_tls_resync_rx(struct net_device *netdev, struct sock *sk,
-				u32 seq, u8 *rcd_sn_data)
+static void mlx5e_tls_resync(struct net_device *netdev, struct sock *sk,
+			     u32 seq, u8 *rcd_sn_data,
+			     enum tls_offload_ctx_dir direction)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_tls_offload_context_rx *rx_ctx;
 	u64 rcd_sn = *(u64 *)rcd_sn_data;
 
+	if (WARN_ON_ONCE(direction != TLS_OFFLOAD_CTX_DIR_RX))
+		return;
 	rx_ctx = mlx5e_get_tls_rx_context(tls_ctx);
 
 	netdev_info(netdev, "resyncing seq %d rcd %lld\n", seq,
@@ -179,7 +182,7 @@ static void mlx5e_tls_resync_rx(struct net_device *netdev, struct sock *sk,
 static const struct tlsdev_ops mlx5e_tls_ops = {
 	.tls_dev_add = mlx5e_tls_add,
 	.tls_dev_del = mlx5e_tls_del,
-	.tls_dev_resync_rx = mlx5e_tls_resync_rx,
+	.tls_dev_resync = mlx5e_tls_resync,
 };
 
 void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index 4427c1d42047..93f87b7633b1 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -383,14 +383,17 @@ nfp_net_tls_del(struct net_device *netdev, struct tls_context *tls_ctx,
 }
 
 static void
-nfp_net_tls_resync_rx(struct net_device *netdev, struct sock *sk, u32 seq,
-		      u8 *rcd_sn)
+nfp_net_tls_resync(struct net_device *netdev, struct sock *sk, u32 seq,
+		   u8 *rcd_sn, enum tls_offload_ctx_dir direction)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 	struct nfp_net_tls_offload_ctx *ntls;
 	struct nfp_crypto_req_update *req;
 	struct sk_buff *skb;
 
+	if (WARN_ON_ONCE(direction != TLS_OFFLOAD_CTX_DIR_RX))
+		return;
+
 	skb = nfp_net_tls_alloc_simple(nn, sizeof(*req), GFP_ATOMIC);
 	if (!skb)
 		return;
@@ -411,7 +414,7 @@ nfp_net_tls_resync_rx(struct net_device *netdev, struct sock *sk, u32 seq,
 static const struct tlsdev_ops nfp_net_tls_ops = {
 	.tls_dev_add = nfp_net_tls_add,
 	.tls_dev_del = nfp_net_tls_del,
-	.tls_dev_resync_rx = nfp_net_tls_resync_rx,
+	.tls_dev_resync = nfp_net_tls_resync,
 };
 
 static int nfp_net_tls_reset(struct nfp_net *nn)
diff --git a/include/net/tls.h b/include/net/tls.h
index 28eca6a3b615..9b49baecc4a8 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -299,8 +299,9 @@ struct tlsdev_ops {
 	void (*tls_dev_del)(struct net_device *netdev,
 			    struct tls_context *ctx,
 			    enum tls_offload_ctx_dir direction);
-	void (*tls_dev_resync_rx)(struct net_device *netdev,
-				  struct sock *sk, u32 seq, u8 *rcd_sn);
+	void (*tls_dev_resync)(struct net_device *netdev,
+			       struct sock *sk, u32 seq, u8 *rcd_sn,
+			       enum tls_offload_ctx_dir direction);
 };
 
 enum tls_offload_sync_type {
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 477c869c69c8..b35a3b902bfa 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -559,7 +559,8 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
 		return;
 	netdev = READ_ONCE(tls_ctx->netdev);
 	if (netdev)
-		netdev->tlsdev_ops->tls_dev_resync_rx(netdev, sk, seq, rcd_sn);
+		netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq, rcd_sn,
+						   TLS_OFFLOAD_CTX_DIR_RX);
 	clear_bit_unlock(TLS_RX_SYNC_RUNNING, &tls_ctx->flags);
 }
 
@@ -1105,7 +1106,7 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
 	case NETDEV_REGISTER:
 	case NETDEV_FEAT_CHANGE:
 		if ((dev->features & NETIF_F_HW_TLS_RX) &&
-		    !dev->tlsdev_ops->tls_dev_resync_rx)
+		    !dev->tlsdev_ops->tls_dev_resync)
 			return NOTIFY_BAD;
 
 		if  (dev->tlsdev_ops &&
-- 
2.21.0

