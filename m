Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CF245193B
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 00:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240054AbhKOXQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 18:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350089AbhKOXOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 18:14:31 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E19C04EFB8
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:16:16 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id h63so8900924pgc.12
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q5Q7mjWxHvomA4joFyHp8gbW0OzP0GYKgcSZNkWKQbw=;
        b=GfFI7XvVt8YFksskvqmrQ3qPuEuVeXEYjSmuZkGA5xMMXxFy564PrMeBNc7Y8WH5PL
         yt5GdFT0FW445phxmH69+fTSi0opmzSp0MKM1Su7LpWaODpHqJOvO/AjHDC3wXOmrXDe
         2wLMSbl2QDTBiMGmIPaGGEJJB0n0X5+1Qk2gI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q5Q7mjWxHvomA4joFyHp8gbW0OzP0GYKgcSZNkWKQbw=;
        b=Z/jgd9Gq8vMiRhEP+rOCUdJtAxKgkQ1sM9tTXMCBkNR8dR/O1gFYbxH60V8AsfVAd5
         oA6nCK/OsvgnJK4h7XF1k1ma4BlyQVLUH40Fee6POpHOqx69wTQ6X85lC4uP0iD7Gnmq
         iU0KCg+AZk3poy0iLTwVabC2lsfwj8X1PX+zDHgwuBt6n9mjlBD0GGpcXTz5v9KOQR+8
         4jnBuQMZoFdy9CJW6s79Ac/AeqwC7T/hBsXo1P5QIfl4bgCzdO1fkhBnkm0nHaKbN2+r
         LV3nhtsxA5O6Rwc82+Cmpr/JdVhnKSk/Q0l0Lanjrc9edyLqVbQRonnueYEfb4l0BJpK
         BziQ==
X-Gm-Message-State: AOAM531L8+d1yEVXU7u5tD0YFITeb0o2/9YI9tF6cgH7jhKenGeQ7ONY
        Tt1WRXNvfiqr6B5GrjOnCyA7vg==
X-Google-Smtp-Source: ABdhPJz3d1Fm6DVmJXDnQcSZ6XVqy1YGkg+bK+EhRM29LMp3+iWkEpRfouWPgP5TqiLJ0sYBVy/rdA==
X-Received: by 2002:a63:1d13:: with SMTP id d19mr1556417pgd.383.1637014576434;
        Mon, 15 Nov 2021 14:16:16 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id oc10sm293770pjb.26.2021.11.15.14.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 14:16:16 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] net/mlx5e: Avoid field-overflowing memcpy()
Date:   Mon, 15 Nov 2021 14:16:13 -0800
Message-Id: <20211115221613.2791637-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5948; h=from:subject; bh=0WIZ0LaG1CrIgiauMUryZqkW+d9Y9QkDjTEtreWu41w=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhktwsH+KBpNKg9y8K0YobbeqSLF6d2fuY7VTbl+5Z Uh4uM5yJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZLcLAAKCRCJcvTf3G3AJmobD/ 4yvXZ4YCp0KjHJMvrX51CQUEcJK+sRXEh/r1W+abkDL4ueQ+6QV3vWeVSrhqJESh+XpSxMLwszT+IF xrIH7gRb+kRPp3AXQaL8Eh4rC3NpFmtrhyo5tKR1FTkRViKY1ziXYvytN3tnVhL+btoLMt69UWKA4M rH0wA3BuMNWUIK1yxE7SHdVTs9H0FZ1M9qPaWt9a+uq6DLPTP3iJUKRM12850xYCvVzdFbbf7mIg+m pXUDLunfMEj2Vc3jg5LwpL/ow9rH2Q+9RU9Nx0hiUlNfQA+4m75yhlsDP81nmQv9aLkoHTuSvowmGT dGJOEUZep0TZp09tQJTgrb+6rJNPIQM5KD2uj/+6ks2FeGu1ADL6WQIlRJpKGRhZZFwJW9lDx4BuIk kK9RfAVMz9bw0QJSeX8iq7Wmx5cro599decAtm8SwF0Pku/UhCALalcV5AlXHgINCFYldUYDNTJ+KY RdLLm3HGfN22x6hoP7AqbCJvIYEsmf2qlBuzHH6vSD8PjHelqMKzw3F2d470UfxUDtlzI5lMNMsAj3 GYLomDbvaxl11/Z2MJeb0SnUHTnFzbHFeYkCZQylS9lAiycVZ9AkxDIch7PQTVW/TSO8uAtuTeXnDS 4oiEm5xtKVE2kUINM+5T3E6lXmFCmBmSV7z5qTKv6zt2wbuQPEOHPukS7IIQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use flexible arrays instead of zero-element arrays (which look like they
are always overflowing) and split the cross-field memcpy() into two halves
that can be appropriately bounds-checked by the compiler.

We were doing:

	#define ETH_HLEN  14
	#define VLAN_HLEN  4
	...
	#define MLX5E_XDP_MIN_INLINE (ETH_HLEN + VLAN_HLEN)
	...
        struct mlx5e_tx_wqe      *wqe  = mlx5_wq_cyc_get_wqe(wq, pi);
	...
        struct mlx5_wqe_eth_seg  *eseg = &wqe->eth;
        struct mlx5_wqe_data_seg *dseg = wqe->data;
	...
	memcpy(eseg->inline_hdr.start, xdptxd->data, MLX5E_XDP_MIN_INLINE);

target is wqe->eth.inline_hdr.start (which the compiler sees as being
2 bytes in size), but copying 18, intending to write across start
(really vlan_tci, 2 bytes). The remaining 16 bytes get written into
wqe->data[0], covering byte_count (4 bytes), lkey (4 bytes), and addr
(8 bytes).

struct mlx5e_tx_wqe {
        struct mlx5_wqe_ctrl_seg   ctrl;                 /*     0    16 */
        struct mlx5_wqe_eth_seg    eth;                  /*    16    16 */
        struct mlx5_wqe_data_seg   data[];               /*    32     0 */

        /* size: 32, cachelines: 1, members: 3 */
        /* last cacheline: 32 bytes */
};

struct mlx5_wqe_eth_seg {
        u8                         swp_outer_l4_offset;  /*     0     1 */
        u8                         swp_outer_l3_offset;  /*     1     1 */
        u8                         swp_inner_l4_offset;  /*     2     1 */
        u8                         swp_inner_l3_offset;  /*     3     1 */
        u8                         cs_flags;             /*     4     1 */
        u8                         swp_flags;            /*     5     1 */
        __be16                     mss;                  /*     6     2 */
        __be32                     flow_table_metadata;  /*     8     4 */
        union {
                struct {
                        __be16     sz;                   /*    12     2 */
                        u8         start[2];             /*    14     2 */
                } inline_hdr;                            /*    12     4 */
                struct {
                        __be16     type;                 /*    12     2 */
                        __be16     vlan_tci;             /*    14     2 */
                } insert;                                /*    12     4 */
                __be32             trailer;              /*    12     4 */
        };                                               /*    12     4 */

        /* size: 16, cachelines: 1, members: 9 */
        /* last cacheline: 16 bytes */
};

struct mlx5_wqe_data_seg {
        __be32                     byte_count;           /*     0     4 */
        __be32                     lkey;                 /*     4     4 */
        __be64                     addr;                 /*     8     8 */

        /* size: 16, cachelines: 1, members: 3 */
        /* last cacheline: 16 bytes */
};

So, split the memcpy() so the compiler can reason about the buffer
sizes.

"pahole" shows no size nor member offset changes to struct mlx5e_tx_wqe
nor struct mlx5e_umr_wqe. "objdump -d" shows no meaningful object
code changes (i.e. only source line number induced differences and
optimizations).

Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: bpf@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h     | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f0ac6b0d9653..0925092211ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -225,7 +225,7 @@ static inline int mlx5e_get_max_num_channels(struct mlx5_core_dev *mdev)
 struct mlx5e_tx_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
 	struct mlx5_wqe_eth_seg  eth;
-	struct mlx5_wqe_data_seg data[0];
+	struct mlx5_wqe_data_seg data[];
 };
 
 struct mlx5e_rx_wqe_ll {
@@ -242,8 +242,8 @@ struct mlx5e_umr_wqe {
 	struct mlx5_wqe_umr_ctrl_seg   uctrl;
 	struct mlx5_mkey_seg           mkc;
 	union {
-		struct mlx5_mtt inline_mtts[0];
-		struct mlx5_klm inline_klms[0];
+		DECLARE_FLEX_ARRAY(struct mlx5_mtt, inline_mtts);
+		DECLARE_FLEX_ARRAY(struct mlx5_klm, inline_klms);
 	};
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 2f0df5cc1a2d..efae2444c26f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -341,8 +341,10 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 
 	/* copy the inline part if required */
 	if (sq->min_inline_mode != MLX5_INLINE_MODE_NONE) {
-		memcpy(eseg->inline_hdr.start, xdptxd->data, MLX5E_XDP_MIN_INLINE);
+		memcpy(eseg->inline_hdr.start, xdptxd->data, sizeof(eseg->inline_hdr.start));
 		eseg->inline_hdr.sz = cpu_to_be16(MLX5E_XDP_MIN_INLINE);
+		memcpy(dseg, xdptxd->data + sizeof(eseg->inline_hdr.start),
+		       MLX5E_XDP_MIN_INLINE - sizeof(eseg->inline_hdr.start));
 		dma_len  -= MLX5E_XDP_MIN_INLINE;
 		dma_addr += MLX5E_XDP_MIN_INLINE;
 		dseg++;
-- 
2.30.2

