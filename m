Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40402473795
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 23:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243770AbhLMWeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 17:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243563AbhLMWdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 17:33:38 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13ACAC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:33:38 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id x7so12930190pjn.0
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ihp5CRy/Mct75vl8qqmnl7/fdL4i3ULbXjqQXQ/vudA=;
        b=Ub4LX7pnzqa1jBOsVYiXylaibT0d5wxzfGRCCiOYG/cjJBZKKsPmxU2dJRAOkveZIh
         YONhE9WVJKNBCmseP0dUKS5rmGpjwPN32P8NvlEYgfkTuK/ukk2pFlvceKS5aZDewMhN
         UJAgYOljx4VNO9aqB6aoRn8UN4v7vTJ0Oz8Pc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ihp5CRy/Mct75vl8qqmnl7/fdL4i3ULbXjqQXQ/vudA=;
        b=iEuuUPzyEONwIk5DLyvNh9WQzQ3PZEIEcj3DYoFGcEqli+GGb2jf+4qa2jZ01JWEwl
         lXLB35ZfhzURXA1/SCoipK8Q3bCeM6dSXLdypGRv2kmb4EtFV983xS8vF8ToQwtv4Fa9
         dICkF3gpwO08a0uhSTKQWGMbok8lkkqVBVCmWey2p3x1BJor36pDetQ2+eDXYM9PE7ON
         oQTqTtyz82zxElESeKbvmP5HlqhwHo6i32KnepjwLT9IPCLOxSDvpxEUF8ZlonBoG79m
         1vGj98cTjMfmX0L36i1kkeeWSZ1I0K3FQKadA1CcLdME3knc6tapK3emKizcwyYmC1HL
         HeLA==
X-Gm-Message-State: AOAM533fu/Wj8aoLLUhybxYuS+pjAjAgUwjp7mVtgEeJWUXjjNLKoJck
        TON7WlvUjzYdSAkEslbOJ+CneQ==
X-Google-Smtp-Source: ABdhPJwhxrdBB2h33rTcK12u0mWcoIflHOAGX9D6Gs22nhszWXpdXJVeQBaPpAhnFz+WK81VEochVQ==
X-Received: by 2002:a17:902:e804:b0:142:1c0b:c2a6 with SMTP id u4-20020a170902e80400b001421c0bc2a6mr1025652plg.23.1639434817605;
        Mon, 13 Dec 2021 14:33:37 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g14sm11222856pgo.88.2021.12.13.14.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 14:33:36 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/17] net/mlx5e: Avoid field-overflowing memcpy()
Date:   Mon, 13 Dec 2021 14:33:16 -0800
Message-Id: <20211213223331.135412-3-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211213223331.135412-1-keescook@chromium.org>
References: <20211213223331.135412-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5948; h=from:subject; bh=EppcbcSPKk/Rd6MsdVLuv/qMCS6eKKFQ506lkSpOmRU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBht8o3POvClLvKHN/lynYrq7OpZm6VGeDuqqGw1AJE Ty8tY7KJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYbfKNwAKCRCJcvTf3G3AJtaMD/ 0R0sbrtwDATl2p4FnXCY0lXP3LfdvTHLLPHMDy9Nq7ZlgTZTwzQqUVm0LjNfkF+fbSbdcAMhSlr8rV qvqaLdvRPNFtz2D6GohM/GfKfoZ1UjJNiOvgfbJ0ilYRRRG4anuYYl1gMfZ3Ko6QO1EtU3Y1qU8YIa xB5f2mXDTs6OZHvPIDSqbTlxjeVSn5fJjvjtabbElOkFTLszEQ0UQnA0PBAS2UiOWbuthNCuaEt16N vA8qms5FddqfDqm5c9FAKCkAu8eNkspw7nIIiGoY5PqxV1TrhSUrnrsbrVvtTFFmOGxrTLGUdyHq0Q kFEJEgcTU72q9mnFGzW8TByHYgbW/8fYRA/kPyQVBpzI8m86xwBkTw4DNGmAhZcDV8veSnziKAJl8k HyC0qNQQYpe38vZ3NzMc7JGRX3fXdbgk449asLBRJE7Azx6MN89EkyuZBTJIQxL7tXBBWVTTWe/9su 6eT0b5aESPNrhJMR8xcGgkRFLbr6qI8oXVKS/06GOasghrwozIwW/jojcsEtdmB/RiWPRkXGNvez2j bt2cNM+2zXmFhtf0XPQJmUrYulpa0tiq5LQIvf0koDFyKxZ0JaA56ZdGBXzrQY9JMqXd1ueG6nE3Gh MimlG1ooMCxRn0fxoY4Nma91cdEOpRa+XeYuM9BQ7dGs8BEwVL4o7u8wFibw==
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
index e77c4159713f..5d8e0a712313 100644
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

