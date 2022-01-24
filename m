Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20FD498679
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244426AbiAXRVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244347AbiAXRU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:20:58 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32661C061751
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:20:39 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 187so15760095pga.10
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uvbVlssiuOL2o7l4VGo9wAQ7yG1g9QxFoYPbSYFtdqo=;
        b=b8kkFS5/WqRt/uGkxgdO4EPtPACa7K4UyA5rdihYBP0zQfEvfu9Hc7L6wke4IFyhtQ
         9F3JxaZcx3rKTh3OX8pgIvYfgQCZqMuNZnRymYeySn88lJEFnMJ1FFqAGqDns740oe0g
         y5gJShOglcZEdDYr2VYR12OQOXlCAACHa0JQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uvbVlssiuOL2o7l4VGo9wAQ7yG1g9QxFoYPbSYFtdqo=;
        b=z26nhDFZKYIxQjdIfJrh4Xhqen4tsa73AGsi/RNaD7Uahq/V52AwQfXIw9Q08+L/ef
         k8qh/nwwPBOW3zcs+ACzkqmoJF7SGzaeW9h9Nb8hmj4CbhQ8LWG4mVVdxvq6sbCLXC2s
         JfZ6m12ty2GPjj3+219252pC8kk61R9SNojT08GH4Y+v3UasPm6refvkZ7ssch6iKJIT
         v3CCO6/yk7x329GLq23Qd33ymvLnBL3h59fAolYhLXNfhFGOsw+LYRlnHC3IesryJGMK
         fr8KNDKzqMwLEUuZyiJS2O/1mfz7TcZGbHdKNTQ04WsZrRz2ZhgNktTFWp62qtEbIeab
         2KnA==
X-Gm-Message-State: AOAM532iKeH3KJBZqdcw/YLtNeWFU9kkA28d9WgZLy2BCs7q6jM+TBHq
        DQfWi6cxqk5TGvZh7SaiVwCI0Q==
X-Google-Smtp-Source: ABdhPJwOxnazNMZcXd19bSVJ9MoN8ZvyCdEePmDJfQKMV6Sw4mYioXg78RY4Q74VmtnF7JqMgDdW1Q==
X-Received: by 2002:a63:204a:: with SMTP id r10mr12454750pgm.502.1643044838506;
        Mon, 24 Jan 2022 09:20:38 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l26sm12555173pgm.73.2022.01.24.09.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 09:20:38 -0800 (PST)
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
Subject: [PATCH v2 RESEND] net/mlx5e: Avoid field-overflowing memcpy()
Date:   Mon, 24 Jan 2022 09:20:28 -0800
Message-Id: <20220124172028.2410761-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6160; h=from:subject; bh=VQqeo576slnncrVuQigWvgwHbkmaogPwolkC5v46MpQ=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBh7t/bEEizP4HPXunI0lIL+G351adCgzYP8rg/gvyC Pv5SX/WJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYe7f2wAKCRCJcvTf3G3AJm6VD/ 9jlPxoUFcLSoP71xgroQBRupcIYrG31w6xXFGdiZs8oSKGJPTYGWEbRd+EcSiDEc0WILjMWRh5qlq3 xCKyFF0jgopugVAQ5bOoCAAuYlm+OxpDaV9qq3aU7ITc7dbSwgB36A/qFxX8fVBv9RisFb0iJPwZp6 5u/67EShGoip2rkulhk4qSkLBaqGB6x/lK4Jego5xxn3iMBBkNK2H3sAD+uTDqpDde44GHbvRK5O/w hG+d4vQSXKy9IotXNQTD0cak7N0d/KXigldG6jUkLX7PX1I95EQHO80E4YzUzE5PizdAPK0FoghAAq ThRukak3eD7WZwU+Ls8P+fL/3EDVFFb6z0mr9ZLs7lcAMbsy17qxZJgQw+p8X+/RMZwM9SZoE2IdHd AR1WKqub7atfYkCGBMCvRBjqaVtBPkU3v6ID9nnN+U67xPc8vedjC6qeHJ3A6aWMxV5qd9+0cWejQE 4iAqY3HzPuwttaOoYs1PUBReTmMmk8QfHBPNMGFurW8HBEfIhgg7j4cAo0mDFuNIYuCCf5Dqo9zFF6 5Z6gsWMiM+yN8zjJUDV/zYHO4grzBp/BUM1Wli/iGpuKUWg9DBmUbdd+en8GTGeghoCHAIk6D1aemY UjQkOLAF0Kyi3rp7rjcTWXjtBLEiPlGZCGnCGloSwEG0DUWTfSh34Ny1lSLQ==
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
Since this results in no binary differences, I will carry this in my tree
unless someone else wants to pick it up. It's one of the last remaining
clean-ups needed for the next step in memcpy() hardening.
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h     | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 812e6810cb3b..c14e06ca64d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -224,7 +224,7 @@ static inline int mlx5e_get_max_num_channels(struct mlx5_core_dev *mdev)
 struct mlx5e_tx_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
 	struct mlx5_wqe_eth_seg  eth;
-	struct mlx5_wqe_data_seg data[0];
+	struct mlx5_wqe_data_seg data[];
 };
 
 struct mlx5e_rx_wqe_ll {
@@ -241,8 +241,8 @@ struct mlx5e_umr_wqe {
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
index 338d65e2c9ce..56e10c84a706 100644
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

