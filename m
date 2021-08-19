Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EFA3F21A5
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 22:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbhHSU3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 16:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbhHSU3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 16:29:06 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210CEC061757
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:28:29 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id c17so6992981pgc.0
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LmJ99teUGdinNbfoKjiCNsrT2KdowhAH1C31uHkGRNA=;
        b=Dj15yo21NCrkIvM7NC1lrgzKnXjpR6Ran1CaUSVIc7SDs+XJQu4+4SIyboeBH2p0+3
         N8nGdctdwQHRXi+AuCSq4u8lcVPv+/dBJ6wSYJ3XdJGosYQ6TiqS0KWc1gyWYzhKmmYw
         3lPlg0n+jRA26KK/nvtftN5I3bOswZf505Pqk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LmJ99teUGdinNbfoKjiCNsrT2KdowhAH1C31uHkGRNA=;
        b=iLcYK0i9sNJKieqKFNzmE6YVhN+mSXvzM6upuc+7CsDl45g1sA4EPtnXxy+iPl7pe+
         W+7+1qPhbehqHHwYKHckrVYfh/JDDLKqyWByAMub9NnCNzswnHQuUUJNtPAJyvkpauEl
         eltjOEz82BY2l7nWc6s7S6Px/9F5mNBV+fttwMzHxgiJmRcYqYwM+yL38I8an1WhdO77
         958CuVz3ub4/AXIrF8eNNBNBS5WSSDn0VyJ6HPgQ39czZb/dA3i7aWgJ+hY8J8QQ9dEK
         VHkFx+tNJ6tBnFyYa01SZnqbWhkWaBIWEJrfS4swAZDJ0FRHVIN6/jAJFFPO1qNxNHNx
         /GWw==
X-Gm-Message-State: AOAM533Da7dxxzYtSDNTQMHjmpTeyVF09+IpFzzur9GKTJ5n1s266NE4
        HF3hcHajVxIEw0jo4iLzyvN+FQ==
X-Google-Smtp-Source: ABdhPJyDdCH7kBGcDAaf55svTOs4FrH/0oEtzY2oPb1XFGfb9dMJOJHOnZ1x6JELh6d01qnrUV728Q==
X-Received: by 2002:a65:468c:: with SMTP id h12mr15916127pgr.423.1629404908650;
        Thu, 19 Aug 2021 13:28:28 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x14sm4439825pfa.127.2021.08.19.13.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 13:28:27 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     netdev@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH 2/3] net/mlx5e: Avoid field-overflowing memcpy()
Date:   Thu, 19 Aug 2021 13:28:24 -0700
Message-Id: <20210819202825.3545692-3-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210819202825.3545692-1-keescook@chromium.org>
References: <20210819202825.3545692-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5945; h=from:subject; bh=aAhXgOvjd8fFl6HHAOH2dNe1RpxfNiJeVAevXZn1G1s=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHr7os55xLZsomlfyqNbHN963vbWsu6lq/7sGdDVv bsZ6eIyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYR6+6AAKCRCJcvTf3G3AJt4zD/ sHmmUuEJhefcu1/BIWauiIG3HeHJeUZKq/wb8kvLmppRsA5tE5R8SCtTbNOLGdb5P1FZoq/2nSAtlB Jg3AjDzmiNAVMiF+TmElADQXKuoGQE4qy+GV4RXJEJZ8U03o4eHw0KWWg4elHpCA4WPUveev5SI5gW WrW9hq4yscbuASX4gRfrp8EuwinBveG0xhjB1TZh7qb4u8TAW5OOIovOFIzxYOz6A9Zb98Gx1Vu7ZN 3/BpRrAPSKgKoBB6yMWoLMCugPVDG0Cn4PQRUfW+KwNZDUsLpZube9hmCXe0Ujs/f0H97jfVvaX1bz 7hWcaE5rWoSBj63Uqom5NIHhwPjvg54h4KPCNDZ9KLmG0ToxwmqDhk7F798BIs7estEA2YpZTEsyOR +9tYFwDtPOb7EOG9e5Y8x/BswkIyutAAGkGMd9c9LUiHu5zV2nbF/yiPGECcAhVL8uldcIBzDwJPE9 goDkibmTjyrsaa4i4Vept+fpSjR3D7fg8nMtlneYdzSN9ZL+L8RofiQtRy+8aj/1/dJ/oFim9ddoBz e17OLMyoVP9lixwQZxCqQN4wH+9Cu3H2zsTeY7pVhBnqYpoXOB2WcWa2CoK8TV0dj8DEoTOPX1NwFi sfWnuW/PQPEQP7GSt52LOkvFLNkl5tPpWq5cqouM4sWlz9Q0n5dzRvYdx39w==
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
 drivers/net/ethernet/mellanox/mlx5/core/en.h     | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 4f6897c1ea8d..8997476c20cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -200,7 +200,7 @@ static inline int mlx5e_get_max_num_channels(struct mlx5_core_dev *mdev)
 struct mlx5e_tx_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
 	struct mlx5_wqe_eth_seg  eth;
-	struct mlx5_wqe_data_seg data[0];
+	struct mlx5_wqe_data_seg data[];
 };
 
 struct mlx5e_rx_wqe_ll {
@@ -216,7 +216,7 @@ struct mlx5e_umr_wqe {
 	struct mlx5_wqe_ctrl_seg       ctrl;
 	struct mlx5_wqe_umr_ctrl_seg   uctrl;
 	struct mlx5_mkey_seg           mkc;
-	struct mlx5_mtt                inline_mtts[0];
+	struct mlx5_mtt                inline_mtts[];
 };
 
 extern const char mlx5e_self_tests[][ETH_GSTRING_LEN];
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

