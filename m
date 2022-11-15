Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FE462906E
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237668AbiKODEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237673AbiKODDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:03:22 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351A9DE8F
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:30 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id q10-20020a170902f34a00b00186c5448b01so10321506ple.4
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NHpPVwYWmY+x6hcd+ABfU57UeOB/gPiQsU+3Z5UY1i0=;
        b=B9GEj8ItHuvei7OLJh6liahQyF41gxO9r0YmDRezNhhJW0B4LRqBdiIpdLtKSAKJ03
         bck/3wtWk9S5kVmWsH1Y/X/cO55m8mCUy9roh3KrjHhfMgHjKHanRgEUDFk2hXS5o9HD
         T8fiPRw91w2DPpiCdHicSzCzSb3G90FEfXhpXam1H0h7gV4eGPTn+EOnXOEgX/GyCRnA
         MUzwph2rjV5NPKaRb6/QcBwQOGAYqRKmEh5sGsOaS4N884wBgVzWhF4znQ0gEyOvKWEn
         QbLQn9i+uKTBoSekSpaVAi9Ju+3QijVzSMDS3wQw1Wf3627H4hTfa4y79GUxuh6l2TJ9
         dD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NHpPVwYWmY+x6hcd+ABfU57UeOB/gPiQsU+3Z5UY1i0=;
        b=VflUhidn4Npw3I6dBysBwZBrANCiv8Sxn3i2U+bGRMgDNB98egpkdXBdAlJWlyOQMt
         yEc0hpWcVAb3LEzFTmQ/fQ1NFrJM7Ni8VAAhn4G3AYWlGZoEYu2F/q3s3lgNXMLvmAp6
         3r8sbhfpP7TOq5XJNe0nL74YPe32stxfNlhv81JOZCHUwde+D1BEKTqNUFNmAEjHWpt3
         Wka968JumtJlxE6HTCn+tFe7c3YpbDPrGrJggusTriH73QNnSdQz1vikPGldd55cLnLn
         qIyfImP77c81VrhzryPRj0QenoD0OK+huD7ZGL845bhsm5tr92f2aLDbtmyky/Bxo+Su
         sR3Q==
X-Gm-Message-State: ANoB5pkYO1ASfw4w0OormTILUDbjAQkT17EX8SYY/W1ymATJ0ywqpfjC
        7C6N2dV1u/uw57a6N/rAwOJySs0=
X-Google-Smtp-Source: AA0mqf6ORNAZumHiasQNZjxf2BgibiTbhO3jBp4ygnQ4Uev1N2egl3O8Td8sJSlKU+ljI8s3RHruyz4=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:9a81:b0:218:499b:bee9 with SMTP id
 e1-20020a17090a9a8100b00218499bbee9mr62315pjp.171.1668481349692; Mon, 14 Nov
 2022 19:02:29 -0800 (PST)
Date:   Mon, 14 Nov 2022 19:02:09 -0800
In-Reply-To: <20221115030210.3159213-1-sdf@google.com>
Mime-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115030210.3159213-11-sdf@google.com>
Subject: [PATCH bpf-next 10/11] mxl4: Support rx timestamp metadata for xdp
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
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

Support rx timestamp metadata. Also use xdp_skb metadata upon XDP_PASS
when available (to avoid double work; but note, this supports
rx_timestamp only for now).

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
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  2 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    | 42 ++++++++++++++++++-
 include/linux/mlx4/device.h                   |  7 ++++
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 8800d3f1f55c..9489476bab8f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2855,6 +2855,7 @@ static const struct net_device_ops mlx4_netdev_ops = {
 	.ndo_features_check	= mlx4_en_features_check,
 	.ndo_set_tx_maxrate	= mlx4_en_set_tx_maxrate,
 	.ndo_bpf		= mlx4_xdp,
+	.ndo_unroll_kfunc	= mlx4_unroll_kfunc,
 };
 
 static const struct net_device_ops mlx4_netdev_ops_master = {
@@ -2887,6 +2888,7 @@ static const struct net_device_ops mlx4_netdev_ops_master = {
 	.ndo_features_check	= mlx4_en_features_check,
 	.ndo_set_tx_maxrate	= mlx4_en_set_tx_maxrate,
 	.ndo_bpf		= mlx4_xdp,
+	.ndo_unroll_kfunc	= mlx4_unroll_kfunc,
 };
 
 struct mlx4_en_bond {
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 467356633172..722a4d56e0b0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -33,6 +33,7 @@
 
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <linux/bpf_patch.h>
 #include <linux/mlx4/cq.h>
 #include <linux/slab.h>
 #include <linux/mlx4/qp.h>
@@ -663,8 +664,39 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
 
 struct mlx4_xdp_buff {
 	struct xdp_buff xdp;
+	struct mlx4_cqe *cqe;
+	struct mlx4_en_dev *mdev;
 };
 
+u64 mxl4_xdp_rx_timestamp(struct mlx4_xdp_buff *ctx)
+{
+	unsigned int seq;
+	u64 timestamp;
+	u64 nsec;
+
+	timestamp = mlx4_en_get_cqe_ts(ctx->cqe);
+
+	do {
+		seq = read_seqbegin(&ctx->mdev->clock_lock);
+		nsec = timecounter_cyc2time(&ctx->mdev->clock, timestamp);
+	} while (read_seqretry(&ctx->mdev->clock_lock, seq));
+
+	return ns_to_ktime(nsec);
+}
+
+void mlx4_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
+		       struct bpf_patch *patch)
+{
+	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_EXPORT_TO_SKB)) {
+		return xdp_metadata_export_to_skb(prog, patch);
+	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
+		/* return true; */
+		bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
+	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
+		bpf_patch_append(patch, BPF_EMIT_CALL(mxl4_xdp_rx_timestamp));
+	}
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
+			if (unlikely(ring->hwtstamp_rx_filter == HWTSTAMP_FILTER_ALL)) {
+				mxbuf.cqe = cqe;
+				mxbuf.mdev = priv->mdev;
+			}
 
 			act = bpf_prog_run_xdp(xdp_prog, &mxbuf.xdp);
 
@@ -835,6 +871,9 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 		if (unlikely(!skb))
 			goto next;
 
+		if (xdp_convert_skb_metadata(&mxbuf.xdp, skb))
+			goto skip_metadata;
+
 		if (unlikely(ring->hwtstamp_rx_filter == HWTSTAMP_FILTER_ALL)) {
 			u64 timestamp = mlx4_en_get_cqe_ts(cqe);
 
@@ -895,6 +934,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021AD),
 					       be16_to_cpu(cqe->sl_vid));
 
+skip_metadata:
 		nr = mlx4_en_complete_rx_desc(priv, frags, skb, length);
 		if (likely(nr)) {
 			skb_shinfo(skb)->nr_frags = nr;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 6646634a0b9d..a0e4d490b2fb 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1585,4 +1585,11 @@ static inline int mlx4_get_num_reserved_uar(struct mlx4_dev *dev)
 	/* The first 128 UARs are used for EQ doorbells */
 	return (128 >> (PAGE_SHIFT - dev->uar_page_shift));
 }
+
+struct bpf_prog;
+struct bpf_insn;
+struct bpf_patch;
+
+void mlx4_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
+		       struct bpf_patch *patch);
 #endif /* MLX4_DEVICE_H */
-- 
2.38.1.431.g37b22c650d-goog

