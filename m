Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF0C63C881
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 20:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiK2Tfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 14:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbiK2Tf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 14:35:27 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E4B4B748
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:35:06 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l4-20020a170903244400b00188c393fff1so14435802pls.7
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a1tnNrGYpSCeOnYtuUapfNCW6KKkKkqa0sSN/w1HvUM=;
        b=b8Hm8315X/DgTDNwVxD6Y2pfqvt+Ow2k99Fsnw7XmqXqHn4K1RafIYOIyyABiKrlbB
         G7YP1BIjl9Ju1djx/ilUB72s/V2LelOyYvwXEG/7vw0jodKrASdT7qmTcW1h4OjEuJ54
         Y/OJ9rekSfGu9CzRwv48UGfjydZGdxvjjs/1UPni2aMjv9oLg8ZMqjzl/R56p+Txym22
         nDL9tLcSJdW1moLhHgEaa5tbZH1m+UcgBvk383gS9dAUNkKG290HG35IH2qkkr/8+K/F
         +Wlv3VKT2bsIQHQL8XXuJIaYatRyGGmPoEtYTikVcdtViqEOqt91+EhWRhS0MvOZORkF
         8Uew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a1tnNrGYpSCeOnYtuUapfNCW6KKkKkqa0sSN/w1HvUM=;
        b=YlMEGl1pzzwMMLatcKlImYWZ9dROqzwEoeKRWopFSNpvXHkd/xpclDLCx3EvIjmIFB
         XqZaBa/yuaGd11gVxlXPRLdhpf5QTo7pYezxNMbc7xx4XJLr1nUdLpQoYhhlMaVF1l3F
         Otb5tgduQSeQzWkTKSBK31XeiGR+s6zmQFKHOiCvcrV2sF9mWODc5gmsEsGT3T4106PK
         Jdj6sRDOXR0FvFb45Esd6N/ivCu8lfcPRMCkU87/NQ27uT+0U7lYWm1C4JwVb6m7a3Xu
         UtKaNCmiekVVXq9Tu0wDSRvhFK3ZfuDIL77O83SC8f4lKV0kKVReHjH6juqiVpuwepDj
         HYig==
X-Gm-Message-State: ANoB5pnC/JH/X0JMumvml6TMGp8g3fhb+tMAoAwfYQSov982EA3vzIXe
        7Qb+OQozwHTHJziJI+1DxyQ521k=
X-Google-Smtp-Source: AA0mqf43J29tbBuhXUy5Pf25oij2I61cbbmcUASgkJMs9iMUYLd1nukMzlvwCw4Ad8l0vHiR8wQiNyA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:f08d:b0:189:6b32:27dc with SMTP id
 p13-20020a170902f08d00b001896b3227dcmr21816328pla.29.1669750505819; Tue, 29
 Nov 2022 11:35:05 -0800 (PST)
Date:   Tue, 29 Nov 2022 11:34:48 -0800
In-Reply-To: <20221129193452.3448944-1-sdf@google.com>
Mime-Version: 1.0
References: <20221129193452.3448944-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221129193452.3448944-8-sdf@google.com>
Subject: [PATCH bpf-next v3 07/11] mxl4: Support RX XDP metadata
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
2.38.1.584.g0f3c55d4c2-goog

