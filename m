Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CC83E3162
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 23:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245335AbhHFVu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 17:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235641AbhHFVuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 17:50:23 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C390C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 14:50:07 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i10so8881668pla.3
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 14:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gUraSkyrsAFaSY8vAulmKjK0D4+3OOrGidTEIITk1eo=;
        b=GSvN543bPKhIK1/VBr27ma7W3pkmJTDziVDbKx6nLAjCtDC/ehiZ9JOsj7z6lqSHJ8
         IEOKsaCojcFPOZnl6C2vV7yN51EgstGQpoIXr/0fHnejdpEqGnEpXnpHznS9GlWD1piM
         3ohPvYVp9IUF/Rrc8YGRd1gxDX9Cg6qjXsqIU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gUraSkyrsAFaSY8vAulmKjK0D4+3OOrGidTEIITk1eo=;
        b=r7cSqhwyrnqzlsJpy3It9o+HhLOBP9n4b//LyKCoMLBtV1nL+FzG1zdkNOIY0EOBIF
         ue+iBMjdwugg3gk39h4yFzFSH/UXBGHH4TRPZZH2Lq6E6SEJMOv3dS+9cCiredkypq8w
         FvM9NGONGNOC71ghQXWOnovf9+dpwJJG3ewwDB9rYwm9rZmAyfg8lFpq8lRmwBg7VmXp
         BRNiY6GyNCNB9HB/rDLQFlTYZof1YGBKfSqA69TjNJL3H6lG3HZ2w8KJUb++Q+3f4APv
         YM/hh0dWIW/WDVemrkim26YtijQb0fP7ATP3u38h0LAnDQYcB0yPY/EN3iNkhRalZat0
         0u1w==
X-Gm-Message-State: AOAM5329anOr5PTRsQ/5bE41S+auehP9vdFuX7KqCbUQa0pkIn2co3ol
        eZB2KfMLI/WtG+VXsnR+TsR0gg==
X-Google-Smtp-Source: ABdhPJy+Kf7w5KI+XVSjt2FRNsyGEVYPhSvhEaOPRhbq81cdArt7SKdqZQl0wkZFCGqq39jvuqcP6A==
X-Received: by 2002:a05:6a00:2150:b029:399:711c:826f with SMTP id o16-20020a056a002150b0290399711c826fmr12556355pfk.14.1628286606720;
        Fri, 06 Aug 2021 14:50:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d65sm9570610pjk.45.2021.08.06.14.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:50:06 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] net/mlx5e: Avoid field-overflowing memcpy()
Date:   Fri,  6 Aug 2021 14:50:03 -0700
Message-Id: <20210806215003.2874554-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5742; h=from:subject; bh=cNvlrfIsT1+CpfN0obpPhHEUYJYVuyHpzp3wiLEFNWY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhDa6Lh9EgIloqfj+/VgCfcSonsAQDYPZHBgpoEloD KYt3DsWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQ2uiwAKCRCJcvTf3G3AJnYvD/ 46bzI0R7MoSLbJUL279MLp9QvSKekQ5AU6B8TL3gvQCC0+AndVvPGLMApL4SjdqpWEP/xLTA4NAgd8 TwofoWZpghQUnERjXPWKrfAjpv85TiEavVzg+rL2xBQFDJaH+6uD2dY5ixrf6RZl0yxTQiqARGzoUl Hzd62Un2FAdrFIbWmwVnhi2BYW45O+GQD6QrswwFzAOsuxjxqQ0yuEZOt8e6tpp2KgQ25ax1Bx1FtQ U9cpPuzkV8TxVLlLyLRQOuu2g/BbbdJC9EBygPYsL2a6+sqRJWYu9fEonuPIiD1usOfaIhNnJ2RO10 FS4YpWMtGALnc/oBChPKuAQ22XFzyDVT+xOAkZEeZF5TUccm+j+357Dl1z/2DJO14INhyP40ADTrx/ hiD0Fassaskv+ktJZObYWplbSaagAD1wRHQW2ptAPJVjkr14QfUa5Z13gWnIEA88XIt5RHLuGHiCFQ HdKMCjuBX/6546bFr5enEtYZmiC02XtEMbovzMsmLYGPK9n43ypS9F9p3v+zighMrbISJ5GTioVb8a Tu/9N1yGPGfwb4caiDgVwSiTPzho318vT4MvoMSQFClrLIet9toEDfMYwaHhUm1TIsl/4Xd3/qfOX9 U8H6Ne/VTSWPNc7Qc/xtGU5OZRqSNBUC2NFAtFyN7zljXkJDUcZGWniJ2A5w==
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
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h     | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 35668986878a..40af561c98d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -201,7 +201,7 @@ static inline int mlx5e_get_max_num_channels(struct mlx5_core_dev *mdev)
 struct mlx5e_tx_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
 	struct mlx5_wqe_eth_seg  eth;
-	struct mlx5_wqe_data_seg data[0];
+	struct mlx5_wqe_data_seg data[];
 };
 
 struct mlx5e_rx_wqe_ll {
@@ -217,7 +217,7 @@ struct mlx5e_umr_wqe {
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

