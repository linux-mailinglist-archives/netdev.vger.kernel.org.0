Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD22D46E205
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 06:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhLIFhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 00:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbhLIFhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 00:37:37 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E11C0617A1
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 21:34:05 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id r5so4097507pgi.6
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 21:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TEdQ7xqbUh9nZ2fpYSrjLmJge99wiwbPJrNcrQ2+9GU=;
        b=Cglcz+jiZOL3ZlvU9ShHERJBngWOh7gT0onZCe3CJOPB9uQwomxgEX9LHHDI66XdQ6
         Z83lfA5VDywJFMjFW6ydMk9qeYoNg6DIKR2fAgpK4IOJVILBxPeivDAYcrPonbr3gqou
         kGI3TbT/w9Y9ERpoCZdXvmAHkpaHSiYjr8n2I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TEdQ7xqbUh9nZ2fpYSrjLmJge99wiwbPJrNcrQ2+9GU=;
        b=vEAM0a9ilnrz+IWYJc3UGoY3SoXna55R+1cMj62/AeltMfzU8ZU5qzc4SOT037ZRZd
         fTGbuXUhmzjUZZwEg++RIbney/lUd6KcmqvjEQvyfdU7RHCaZRNHcq2ov+Usw+mrIA5T
         X6ax+gW0uq8xbTFL9bP8rq5LjpiwjD+Vl/RX7EFGIKpQ5eF297IkkBvh3ZGzol/W3F0q
         8/vyNboxuT87LjI7LhzJxosk153dHKMecTaEoNHOyX+Z+Vbz1EI38JqAUO+yripjKGPl
         ihyXkcYPIhzCqh3R3BVxxsAtNzEyePpZtCTwltNkk3FIgNgEXUgPBO+6LGePt9FfHkun
         MrPg==
X-Gm-Message-State: AOAM532Hu2t9yd5xRLa3Gais5Sr8URRyMsFuq4RKAiwyvX20hsxU4z3o
        UPK5kb+24xR19s58LWsWCnB/Fg==
X-Google-Smtp-Source: ABdhPJy/gv/9wFDJIqnWANj9Of3Dd3TIdKAwJAzw7FVWsOpzpQGelsoyMuALbUiFVB/qX9tASwUQUw==
X-Received: by 2002:a05:6a00:2349:b0:4a8:d87:e8ad with SMTP id j9-20020a056a00234900b004a80d87e8admr9860982pfj.15.1639028044328;
        Wed, 08 Dec 2021 21:34:04 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g7sm5447044pfv.159.2021.12.08.21.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 21:34:03 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2] net/mlx5e: Avoid field-overflowing memcpy()
Date:   Wed,  8 Dec 2021 21:34:02 -0800
Message-Id: <20211209053402.2202206-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6133; h=from:subject; bh=bv/kclJVqFfpYqF/u9SUVEA+zaU84TcD4WE+rVi9g7I=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhsZVJjU+25rXmRi5WzcuerZqRLJN3iCPc/8qQNiPO Nprb0GeJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYbGVSQAKCRCJcvTf3G3AJrCfEA CRXNU40blLLe6OTK0SA98KhXyyxeBIQuxWn0vrx/6plzA5pkFJU01hiWbzFzzrK44fIJx9ojwbWob/ 1PvJtG9DRazZ+DH/Tf1UsB1K9ok18bNmsgtep7WCRG3yDXzDX4Pa0u7GCeOm609BmybNZ2Atut04i/ YUVJiAXy4XeFqOYV95lmdprWo1SHHOdggJsYCYqGyvuB195O9jSugqNJc3nHrWcXJ2CWsp4MGPiqrM fd65E6vDnZbFB+pi69pum2aWs7poTUv/BwzBibVQoGlmsOHAyAs3LGEWX/5o/9waEp8UuLfIdC1xq6 jXouklbBXMHT+oIvzXDxFWmOhA/geM7gRNcIG3FAbtOdrpzKw3ztMYcYttAsqtjEEYgBUXgUSldLdR JH80zRFweQQJjOEwyBo33h+UiL8yGslJtqQIEm1c4XgGPg+AxpAivsqIwt+VTyy8GEXvlXrd2yjNpq t0ZMYnSc7obDLnCqETUtrRIDMHB+gSY9HmjGw262XlyT0R0HXTVo2k1j8KrTkykE+B5CWT02V3ZQSX /y3Sdb4trXXDZIioacxpz64YsJDPa9eyrl7xZSrrvJ9YXYEhiVi2t+MZFhKqLDYUQsihqI/pL7QAIm LC/BeDATgM79wa4G5wB9FVkpCMC5Xbue/KLqgoKOvH89a7ngoA72lHt7/JPg==
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

Signed-off-by: Kees Cook <keescook@chromium.org>
---
Hi, this is a rebase, and I can now address questions from
https://lore.kernel.org/lkml/b5f1c558fef468fe8550ebb5e77d36bf1d0971a7.camel@kernel.org/

- performance change? none: there is no executable code differences
  except that the compiler chooses different temporary registers.

- why aren't the other cases a problem? The others are dynamically sized
  copies, and the first phase of the memcpy tightening is only handling
  the constant expression sizes. The runtime size checking will come next,
  where those other cases will need to be handled as well. But one thing
  at a time. :)

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

