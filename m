Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E04618F0C
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiKDD1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiKDD0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:26:18 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0652CBA6
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:25:56 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id u18-20020a627912000000b0056d93d8b8bdso1687362pfc.16
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 20:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pr1ZhtWkdqKAJX2dVOWrymiTIfYnYJdAHUmQmBo7KU0=;
        b=pUb47nZCqHPch0ZbXm3RBYrl/S5kuOFKP6kAItBRXBXSGcxoSXXOLo6T+Paf/mFNZE
         zNxClCq49l4SloyIRcf/Fb/yMN6iyrMTVuFG8YWVj8Dk9QUdNZtl8e9nbk588mGXnm9X
         4B/wVVv3M45ezuqTVvsO40v4/mstlF8rATeitA7hmhEoV3ymn2H/qgBy2hWj4Se76OML
         4HgIvT544624ULyK9J/mgwuVfLeo9T6S1+m7ifgBND6YbcbTBpliimjv2QJnEDVUflCr
         mjq4T7yF0H4eHxC/xp5T1H00y+hJFw5NKKxfxGmfyLGe5cdD1e+yHoQyaIoTFCDgr7Kr
         j5Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pr1ZhtWkdqKAJX2dVOWrymiTIfYnYJdAHUmQmBo7KU0=;
        b=sqh3zFmnJW8rzjteEDo/tu2SnjMY7xbkyW8413Nke83AmG/4eAY/sEBZf8O8RAtnvo
         2uyXKtMnf1AS76OfWZfvP2i9kgiOFzGn72n5Mh6bsHIvwc8jANUHGZjdNeivN4/nyQpx
         BmR/TjIZfIHZqftd03OV2F4erOBrW04hjUodYb2tBzNjr5wKmUEbXrbNZvsLEejAL4VF
         OdJNGzT12lb8xPjLylWy+LEpYF0LhaHNjFD5/DeterIowwm6xRp9dSz0b9DNU9Z5dvTZ
         HwRM4CNk8dZTf3qcWtrlkxRbG/PKAOp6Vt+EXtUbVFlhi6Es7pOxf5SBvD4+NyQegnJN
         coZw==
X-Gm-Message-State: ACrzQf2dtGvdn+suUptqGgCbTqYE+wzcj1pmGKSDT5ohpHnDSXFsFgn7
        y6Qn504+CHPTvyV287yNDu6quTY=
X-Google-Smtp-Source: AMsMyM7KE3YzYg5J2ApCRH6vpkXFRIqTcblZWRYi2ncYtzIkrTYu4YQIPzmytaJD6ieO+JZ8yMA+1d8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:24d0:b0:56c:fa97:a91c with SMTP id
 d16-20020a056a0024d000b0056cfa97a91cmr33601318pfv.23.1667532355739; Thu, 03
 Nov 2022 20:25:55 -0700 (PDT)
Date:   Thu,  3 Nov 2022 20:25:30 -0700
In-Reply-To: <20221104032532.1615099-1-sdf@google.com>
Mime-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104032532.1615099-13-sdf@google.com>
Subject: [RFC bpf-next v2 12/14] mxl4: Support rx timestamp metadata for xdp
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

COMPILE-TESTED ONLY!

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
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  1 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    | 40 +++++++++++++++++++
 include/linux/mlx4/device.h                   |  7 ++++
 3 files changed, 48 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index ca4b93a01034..3ef7995950dc 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2890,6 +2890,7 @@ static const struct net_device_ops mlx4_netdev_ops_master = {
 	.ndo_features_check	= mlx4_en_features_check,
 	.ndo_set_tx_maxrate	= mlx4_en_set_tx_maxrate,
 	.ndo_bpf		= mlx4_xdp,
+	.ndo_unroll_kfunc	= mlx4_unroll_kfunc,
 };
 
 struct mlx4_en_bond {
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 467356633172..83c89a1db3b8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -33,6 +33,7 @@
 
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <linux/bpf_patch.h>
 #include <linux/mlx4/cq.h>
 #include <linux/slab.h>
 #include <linux/mlx4/qp.h>
@@ -663,8 +664,43 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
 
 struct mlx4_xdp_buff {
 	struct xdp_buff xdp;
+	struct mlx4_cqe *cqe;
+	struct mlx4_en_dev *mdev;
+	u64 r0;
 };
 
+struct mlx4_xdp_buff *mxl4_xdp_rx_timestamp(struct mlx4_xdp_buff *ctx)
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
+	ctx->r0 = (u64)ns_to_ktime(nsec);
+	return ctx;
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
+		xdp_kfunc_call_preserving_r1(patch,
+					     offsetof(struct mlx4_xdp_buff, r0),
+					     mxl4_xdp_rx_timestamp);
+	}
+}
+
 int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
@@ -783,6 +819,10 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 			xdp_prepare_buff(&mxbuf.xdp, va - frags[0].page_offset,
 					 frags[0].page_offset, length, false);
 			orig_data = mxbuf.xdp.data;
+			if (unlikely(ring->hwtstamp_rx_filter == HWTSTAMP_FILTER_ALL)) {
+				mxbuf.cqe = cqe;
+				mxbuf.mdev = priv->mdev;
+			}
 
 			act = bpf_prog_run_xdp(xdp_prog, &mxbuf.xdp);
 
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

