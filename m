Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE3E3C26D
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387997AbfFKEky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:40:54 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45346 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391094AbfFKEkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:40:53 -0400
Received: by mail-qk1-f193.google.com with SMTP id s22so6825732qkj.12
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eOjREQ53UJhwhXazoMj2jHlf7JjYS4YusgJma0cfs/Q=;
        b=eIW0IYWD1edYuVigsM7hI/3gOUVjyVXMwCCXzHNAvXlv/sQJxUvnqMzfRft2GyCxhK
         IETplLtf13E+LEbich60JZRtoSUnbDmeQudWkOraXF2giZw5vv8mEApEqEvscNgdXFDI
         CZMXrFpPg2oeybOkVKqEyuwACtNwTs8aB6cmqX4QUyrT6WS2+HFghdhARaK0FyjzxpA2
         xZHkIYtGixPAZvP6U+EEGLt2dHw/IHXD3YG0UEkfudvCEuu8UXxF2Flt8QP1eYY8sZrb
         B7reCJYU3943n5emrIQuYzOWkxaaXaGXQI6+94L26qhI2ykqThOqeng9oUrJNXqUFZCK
         1Zug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eOjREQ53UJhwhXazoMj2jHlf7JjYS4YusgJma0cfs/Q=;
        b=hH3zoJfA7bRKa1d19sC7qrF3wDBw4c67z2BPiDYhELtDgx7gn81Vz9SQIuMSmmAv4N
         8JNzSnEDzNks0fhk7bpwmvfaqZM9ZxM4c1n5ND2v/XdawyrmIra/gfz/vga983F/45rA
         dhEn+9Zj+j6U+7Ybn49JvQSWylwriAs/97A494oXLag5Qv/x7OczQff4gRckLE8ehpSU
         7tZYgsUA9rBjzFKfhXr/pSQnfDRK8B+HyLHTUAiMzgkS+EYBD9EvX2f70dUaqttzBSR8
         XlAgv5XXgl6lK4PlPw+ra07HdziNpzY6tZHBsGuxGQIvWDCUEcvceindP8Bl6tyB0vik
         Zx6w==
X-Gm-Message-State: APjAAAV8pyWBTr3fu+1Cdfpm2UqD2P5/+iMFORZuZQ56bw/rXJZPT3vN
        ugU2SQ+WHt6bKZRNx9WjkaxH3g==
X-Google-Smtp-Source: APXvYqxgWrN2aA/phuWaXh9/LJnbL3cqrp1RH5BWWI4fWNVSB3nK25rNFhKMKBFw0oPahqRHnvPJVg==
X-Received: by 2002:a37:a30a:: with SMTP id m10mr11346417qke.288.1560228052049;
        Mon, 10 Jun 2019 21:40:52 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm2463375qtj.46.2019.06.10.21.40.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:40:51 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 02/12] net/tls: pass record number as a byte array
Date:   Mon, 10 Jun 2019 21:40:00 -0700
Message-Id: <20190611044010.29161-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611044010.29161-1-jakub.kicinski@netronome.com>
References: <20190611044010.29161-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS offload code casts record number to a u64.  The buffer
should be aligned to 8 bytes, but its actually a __be64, and
the rest of the TLS code treats it as big int.  Make the
offload callbacks take a byte array, drivers can make the
choice to do the ugly cast if they want to.

Prepare for copying the record number onto the stack by
defining a constant for max size of the byte array.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c   |  3 ++-
 include/net/tls.h                                    |  5 +++--
 net/tls/tls_device.c                                 | 12 +++++++++---
 net/tls/tls_sw.c                                     |  8 ++++----
 4 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index e88340e196f7..d65150aa8298 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -161,11 +161,12 @@ static void mlx5e_tls_del(struct net_device *netdev,
 }
 
 static void mlx5e_tls_resync_rx(struct net_device *netdev, struct sock *sk,
-				u32 seq, u64 rcd_sn)
+				u32 seq, u8 *rcd_sn_data)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_tls_offload_context_rx *rx_ctx;
+	u64 rcd_sn = *(u64 *)rcd_sn_data;
 
 	rx_ctx = mlx5e_get_tls_rx_context(tls_ctx);
 
diff --git a/include/net/tls.h b/include/net/tls.h
index 3ecf45adb707..25641e2f5b96 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -62,6 +62,7 @@
 #define TLS_DEVICE_NAME_MAX		32
 
 #define MAX_IV_SIZE			16
+#define TLS_MAX_REC_SEQ_SIZE		8
 
 /* For AES-CCM, the full 16-bytes of IV is made of '4' fields of given sizes.
  *
@@ -299,7 +300,7 @@ struct tlsdev_ops {
 			    struct tls_context *ctx,
 			    enum tls_offload_ctx_dir direction);
 	void (*tls_dev_resync_rx)(struct net_device *netdev,
-				  struct sock *sk, u32 seq, u64 rcd_sn);
+				  struct sock *sk, u32 seq, u8 *rcd_sn);
 };
 
 struct tls_offload_context_rx {
@@ -607,6 +608,6 @@ int tls_sw_fallback_init(struct sock *sk,
 int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx);
 
 void tls_device_offload_cleanup_rx(struct sock *sk);
-void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn);
+void handle_device_resync(struct sock *sk, u32 seq);
 
 #endif /* _TLS_OFFLOAD_H */
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 59f0c8dacbcc..16635f0c829c 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -551,7 +551,7 @@ void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
 }
 
 static void tls_device_resync_rx(struct tls_context *tls_ctx,
-				 struct sock *sk, u32 seq, u64 rcd_sn)
+				 struct sock *sk, u32 seq, u8 *rcd_sn)
 {
 	struct net_device *netdev;
 
@@ -563,7 +563,7 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
 	clear_bit_unlock(TLS_RX_SYNC_RUNNING, &tls_ctx->flags);
 }
 
-void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn)
+void handle_device_resync(struct sock *sk, u32 seq)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_offload_context_rx *rx_ctx;
@@ -582,7 +582,7 @@ void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn)
 
 	if (unlikely(is_req_pending) && req_seq == seq &&
 	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
-		tls_device_resync_rx(tls_ctx, sk, seq, rcd_sn);
+		tls_device_resync_rx(tls_ctx, sk, seq, tls_ctx->rx.rec_seq);
 }
 
 static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
@@ -760,6 +760,12 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 		goto free_offload_ctx;
 	}
 
+	/* Sanity-check the rec_seq_size for stack allocations */
+	if (rec_seq_size > TLS_MAX_REC_SEQ_SIZE) {
+		rc = -EINVAL;
+		goto free_offload_ctx;
+	}
+
 	prot->prepend_size = TLS_HEADER_SIZE + nonce_size;
 	prot->tag_size = tag_size;
 	prot->overhead_size = prot->prepend_size + prot->tag_size;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index bef71e54fad0..c1d22290f1d0 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2015,8 +2015,7 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
 		goto read_failure;
 	}
 #ifdef CONFIG_TLS_DEVICE
-	handle_device_resync(strp->sk, TCP_SKB_CB(skb)->seq + rxm->offset,
-			     *(u64*)tls_ctx->rx.rec_seq);
+	handle_device_resync(strp->sk, TCP_SKB_CB(skb)->seq + rxm->offset);
 #endif
 	return data_len + TLS_HEADER_SIZE;
 
@@ -2283,8 +2282,9 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		goto free_priv;
 	}
 
-	/* Sanity-check the IV size for stack allocations. */
-	if (iv_size > MAX_IV_SIZE || nonce_size > MAX_IV_SIZE) {
+	/* Sanity-check the sizes for stack allocations. */
+	if (iv_size > MAX_IV_SIZE || nonce_size > MAX_IV_SIZE ||
+	    rec_seq_size > TLS_MAX_REC_SEQ_SIZE) {
 		rc = -EINVAL;
 		goto free_priv;
 	}
-- 
2.21.0

