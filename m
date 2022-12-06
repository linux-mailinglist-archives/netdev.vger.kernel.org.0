Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1F3643B7B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbiLFCqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiLFCq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:46:27 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D84E25C63
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 18:46:10 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id j19-20020a056a00175300b00574ceff570bso12004744pfc.9
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 18:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ia7DIKmX9JSbNbPmMg/uLfRbMagYs3piuBVsBY5GsbI=;
        b=hBy0dfyLxpeAC2s9aWns69X19vb9f5p9NXp67TKaFyRZyzMmj1fxVKMLkGCkvIzons
         4exBgFkDSdDqT1NBeQOj2IrmrswQ2bt73/snCEGoqyZYJ25IRuHhC71EF9s1Amt8Om0l
         UOHo/R2IXYxtj6NE4WGJ3y6ZqBlI2w7tEpDy3XvjXGKOVxSk+izZxQK+Oo2dMTQ7VFOp
         0YpmNQMY3x+DDCnxgm/ar+WFsqDXuKFVBIlHB060P1mTRvBnUBy5q2o3+BklNrEPUJJI
         nTFB56fdokTUxtI3UWPuFqkzWeU/5V+m551nW4SxF9jIZeG71A8O2/pSDnY6J0CHq7/r
         mWmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ia7DIKmX9JSbNbPmMg/uLfRbMagYs3piuBVsBY5GsbI=;
        b=e3ax2iMXvJx33lQdgfADqVOqdPnC/RUk1B87lFAlQY15CATjvrYC1MlZTolOE4RkhS
         MPaAzQHH7y/jsrkvpTZYTEcyS7pDuUs1/oH0jljk5jfHHHSjNxiNkHtr1kszEpBvjoBL
         khtaSUddOFabin2DLh+7tdy2YWinBE8XnPVMnGXHJV2iohJnhzr8eldI4x4TAH4daUNT
         M31/A2mj0lv7aeFr2B3mYJeN0TESZ0yEydlbjNXmN9bjbbNCBbTbLXhxda85Kmi+waT1
         SKCqDFpuNJUIHfSyXjnkcdFzne1vpONepRKXO5he0bKW3cEj1rWdh2fsW/kBbWeHaCYr
         8vpA==
X-Gm-Message-State: ANoB5pn5tBfR1ok5ppegFgVGpMThGNvXPB5Fxt3uNob/fFR05RINW3mE
        Br8jzE4NiE/VHphTIVBBw3h4mYw=
X-Google-Smtp-Source: AA0mqf4ohs3UixNtQTcvpZoYUVkcVF5ytV+WA7e6Y1jYakNOfIkdxGVZph+y/o//LJs/kE2iSDKDEsA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:e949:b0:189:7a15:1336 with SMTP id
 b9-20020a170902e94900b001897a151336mr46473860pll.122.1670294769622; Mon, 05
 Dec 2022 18:46:09 -0800 (PST)
Date:   Mon,  5 Dec 2022 18:45:50 -0800
In-Reply-To: <20221206024554.3826186-1-sdf@google.com>
Mime-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206024554.3826186-9-sdf@google.com>
Subject: [PATCH bpf-next v3 08/12] mxl4: Support RX XDP metadata
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RX timestamp and hash for now. Tested using the prog from the next
patch.

Also enabling xdp metadata support; don't see why it's disabled,
there is enough headroom..

Cc: Tariq Toukan <tariqt@nvidia.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_clock.c | 13 +++++--
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 10 +++++
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    | 38 ++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |  1 +
 include/linux/mlx4/device.h                   |  7 ++++
 5 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
index 98b5ffb4d729..9e3b76182088 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
@@ -58,9 +58,7 @@ u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
 	return hi | lo;
 }
 
-void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
-			    struct skb_shared_hwtstamps *hwts,
-			    u64 timestamp)
+u64 mlx4_en_get_hwtstamp(struct mlx4_en_dev *mdev, u64 timestamp)
 {
 	unsigned int seq;
 	u64 nsec;
@@ -70,8 +68,15 @@ void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
 		nsec = timecounter_cyc2time(&mdev->clock, timestamp);
 	} while (read_seqretry(&mdev->clock_lock, seq));
 
+	return ns_to_ktime(nsec);
+}
+
+void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
+			    struct skb_shared_hwtstamps *hwts,
+			    u64 timestamp)
+{
 	memset(hwts, 0, sizeof(struct skb_shared_hwtstamps));
-	hwts->hwtstamp = ns_to_ktime(nsec);
+	hwts->hwtstamp = mlx4_en_get_hwtstamp(mdev, timestamp);
 }
 
 /**
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 8800d3f1f55c..1cb63746a851 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2855,6 +2855,11 @@ static const struct net_device_ops mlx4_netdev_ops = {
 	.ndo_features_check	= mlx4_en_features_check,
 	.ndo_set_tx_maxrate	= mlx4_en_set_tx_maxrate,
 	.ndo_bpf		= mlx4_xdp,
+
+	.ndo_xdp_rx_timestamp_supported = mlx4_xdp_rx_timestamp_supported,
+	.ndo_xdp_rx_timestamp	= mlx4_xdp_rx_timestamp,
+	.ndo_xdp_rx_hash_supported = mlx4_xdp_rx_hash_supported,
+	.ndo_xdp_rx_hash	= mlx4_xdp_rx_hash,
 };
 
 static const struct net_device_ops mlx4_netdev_ops_master = {
@@ -2887,6 +2892,11 @@ static const struct net_device_ops mlx4_netdev_ops_master = {
 	.ndo_features_check	= mlx4_en_features_check,
 	.ndo_set_tx_maxrate	= mlx4_en_set_tx_maxrate,
 	.ndo_bpf		= mlx4_xdp,
+
+	.ndo_xdp_rx_timestamp_supported = mlx4_xdp_rx_timestamp_supported,
+	.ndo_xdp_rx_timestamp	= mlx4_xdp_rx_timestamp,
+	.ndo_xdp_rx_hash_supported = mlx4_xdp_rx_hash_supported,
+	.ndo_xdp_rx_hash	= mlx4_xdp_rx_hash,
 };
 
 struct mlx4_en_bond {
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 9c114fc723e3..1b8e1b2d8729 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -663,8 +663,40 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
 
 struct mlx4_xdp_buff {
 	struct xdp_buff xdp;
+	struct mlx4_cqe *cqe;
+	struct mlx4_en_dev *mdev;
+	struct mlx4_en_rx_ring *ring;
+	struct net_device *dev;
 };
 
+bool mlx4_xdp_rx_timestamp_supported(const struct xdp_md *ctx)
+{
+	struct mlx4_xdp_buff *_ctx = (void *)ctx;
+
+	return _ctx->ring->hwtstamp_rx_filter == HWTSTAMP_FILTER_ALL;
+}
+
+u64 mlx4_xdp_rx_timestamp(const struct xdp_md *ctx)
+{
+	struct mlx4_xdp_buff *_ctx = (void *)ctx;
+
+	return mlx4_en_get_hwtstamp(_ctx->mdev, mlx4_en_get_cqe_ts(_ctx->cqe));
+}
+
+bool mlx4_xdp_rx_hash_supported(const struct xdp_md *ctx)
+{
+	struct mlx4_xdp_buff *_ctx = (void *)ctx;
+
+	return _ctx->dev->features & NETIF_F_RXHASH;
+}
+
+u32 mlx4_xdp_rx_hash(const struct xdp_md *ctx)
+{
+	struct mlx4_xdp_buff *_ctx = (void *)ctx;
+
+	return be32_to_cpu(_ctx->cqe->immed_rss_invalid);
+}
+
 int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
@@ -781,8 +813,12 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 						DMA_FROM_DEVICE);
 
 			xdp_prepare_buff(&mxbuf.xdp, va - frags[0].page_offset,
-					 frags[0].page_offset, length, false);
+					 frags[0].page_offset, length, true);
 			orig_data = mxbuf.xdp.data;
+			mxbuf.cqe = cqe;
+			mxbuf.mdev = priv->mdev;
+			mxbuf.ring = ring;
+			mxbuf.dev = dev;
 
 			act = bpf_prog_run_xdp(xdp_prog, &mxbuf.xdp);
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index e132ff4c82f2..b7c0d4899ad7 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -792,6 +792,7 @@ int mlx4_en_netdev_event(struct notifier_block *this,
  * Functions for time stamping
  */
 u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe);
+u64 mlx4_en_get_hwtstamp(struct mlx4_en_dev *mdev, u64 timestamp);
 void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
 			    struct skb_shared_hwtstamps *hwts,
 			    u64 timestamp);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 6646634a0b9d..d5904da1d490 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1585,4 +1585,11 @@ static inline int mlx4_get_num_reserved_uar(struct mlx4_dev *dev)
 	/* The first 128 UARs are used for EQ doorbells */
 	return (128 >> (PAGE_SHIFT - dev->uar_page_shift));
 }
+
+struct xdp_md;
+bool mlx4_xdp_rx_timestamp_supported(const struct xdp_md *ctx);
+u64 mlx4_xdp_rx_timestamp(const struct xdp_md *ctx);
+bool mlx4_xdp_rx_hash_supported(const struct xdp_md *ctx);
+u32 mlx4_xdp_rx_hash(const struct xdp_md *ctx);
+
 #endif /* MLX4_DEVICE_H */
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

