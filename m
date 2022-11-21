Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6265B632C14
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiKUS0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiKUS0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:26:21 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4F9D06FB
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:26:06 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x8-20020a17090a6b4800b00218ae9b2a47so1839395pjl.6
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pgA8r6q+vHqw+YrYOl3aP+dNQ95F67luBXwFSR2T9OY=;
        b=hbR+Vdv0kdy8wD7qfjR+qjrEvtkWb5nrEFaFlg28TgCv4WVOMdFGkmCXsEn/M+HnOz
         ncaJfwM2yKCRhfmoQZ3IeagvNaNrnjSoB8O4PxgEvS4DkTBVPaYJoMnQspR9PPga21zm
         1Wi/+eN6rz26LJkaMY63IIWuNJBXRb4AU6kKZwMqUDr5A8htVNKHRuAoBtCSXbhZUwIY
         oDyc5KyTIWFCoPRiLEbvz4MRH/up9wZ8fI6lvIGokdb8elM/fPnQLEZcLFagO628craY
         BGfqcIGoeAuEL5+CUJgHXbtNLGCJPPOrKFvcirLDNX78dWvV69yLu4wXotUmJiAVXLQM
         IlrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pgA8r6q+vHqw+YrYOl3aP+dNQ95F67luBXwFSR2T9OY=;
        b=p2fxG22wOXMRK8hu1Hq4Onkwp2Uumd3O1JTPOGXRaXeadMl+1nImyRBAGGv4wO3f1C
         j7KMGE2vhGbUR9HV78/I0NuM0LNGSSEm3iBktix7BCGUhbIOUrwvLVm0D7mqYK/kUyKk
         CVpoLInsYrtCuUrdZ6oaKEk9jGQu5j5ZiNljA8hSw5uTy3MnD+6wg4U+fKS0wB604JO+
         1XBw8tp572ISvGhlSJssk5ngIpnDACPdEC8UlIG58Bcu+SrA2H11ApiS4XZ2JMsNS1ng
         LWW9y6GQqGvh1WaySfulB6dJv6VboGm2IeKPHFfV4RWdDJf33t0WjBWhd9XPwdjvE+jV
         x2ug==
X-Gm-Message-State: ANoB5pkzs7DwQo8W+nismryovbHzl3TaqoFZXwjlDSsjbDi1FISPKb0I
        3oLpiSR8DBQxA6V6iFsY8BEqsBk=
X-Google-Smtp-Source: AA0mqf7n2thXFA68LqvTVLbekOytw+rcf5+iC2F8qRSb4JAMHqx5uoXQ/b2Fe+aTVqOn2NwBeTq8XCE=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:aa7:8709:0:b0:572:2189:84ef with SMTP id
 b9-20020aa78709000000b00572218984efmr923589pfo.28.1669055166038; Mon, 21 Nov
 2022 10:26:06 -0800 (PST)
Date:   Mon, 21 Nov 2022 10:25:51 -0800
In-Reply-To: <20221121182552.2152891-1-sdf@google.com>
Mime-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221121182552.2152891-8-sdf@google.com>
Subject: [PATCH bpf-next v2 7/8] mxl4: Support RX XDP metadata
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
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 10 ++++
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    | 48 ++++++++++++++++++-
 include/linux/mlx4/device.h                   |  7 +++
 3 files changed, 64 insertions(+), 1 deletion(-)

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
index 467356633172..fd14d59f6cbf 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -663,8 +663,50 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
 
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
+	unsigned int seq;
+	u64 timestamp;
+	u64 nsec;
+
+	timestamp = mlx4_en_get_cqe_ts(_ctx->cqe);
+
+	do {
+		seq = read_seqbegin(&_ctx->mdev->clock_lock);
+		nsec = timecounter_cyc2time(&_ctx->mdev->clock, timestamp);
+	} while (read_seqretry(&_ctx->mdev->clock_lock, seq));
+
+	return ns_to_ktime(nsec);
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
@@ -781,8 +823,12 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
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

