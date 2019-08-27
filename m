Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B51C9E5E6
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 12:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbfH0Kll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 06:41:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:38490 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfH0Kll (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 06:41:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 03:41:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,436,1559545200"; 
   d="scan'208";a="174509621"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by orsmga008.jf.intel.com with ESMTP; 27 Aug 2019 03:41:37 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com,
        saeedm@mellanox.com, maximmi@mellanox.com,
        stephen@networkplumber.org
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v6 07/12] net/mlx5e: Allow XSK frames smaller than a page
Date:   Tue, 27 Aug 2019 02:25:26 +0000
Message-Id: <20190827022531.15060-8-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190827022531.15060-1-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Relax the requirements to the XSK frame size to allow it to be smaller
than a page and even not a power of two. The current implementation can
work in this mode, both with Striding RQ and without it.

The code that checks `mtu + headroom <= XSK frame size` is modified
accordingly. Any frame size between 2048 and PAGE_SIZE is accepted.

Functions that worked with pages only now work with XSK frames, even if
their size is different from PAGE_SIZE.

With XSK queues, regardless of the frame size, Striding RQ uses the
stride size of PAGE_SIZE, and UMR MTTs are posted using starting
addresses of frames, but PAGE_SIZE as page size. MTU guarantees that no
packet data will overlap with other frames. UMR MTT size is made equal
to the stride size of the RQ, because UMEM frames may come in random
order, and we need to handle them one by one. PAGE_SIZE is just a power
of two that is bigger than any allowed XSK frame size, and also it
doesn't require making additional changes to the code.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   | 23 +++++++++++++++----
 .../ethernet/mellanox/mlx5/core/en/params.h   |  2 ++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  2 +-
 .../mellanox/mlx5/core/en/xsk/setup.c         | 15 ++++++++----
 4 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 79301d116667..eb2e1f2138e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -25,18 +25,33 @@ u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 	return headroom;
 }
 
-u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params,
-				struct mlx5e_xsk_param *xsk)
+u32 mlx5e_rx_get_min_frag_sz(struct mlx5e_params *params,
+			     struct mlx5e_xsk_param *xsk)
 {
 	u32 hw_mtu = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	u16 linear_rq_headroom = mlx5e_get_linear_rq_headroom(params, xsk);
-	u32 frag_sz = linear_rq_headroom + hw_mtu;
+
+	return linear_rq_headroom + hw_mtu;
+}
+
+u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params,
+				struct mlx5e_xsk_param *xsk)
+{
+	u32 frag_sz = mlx5e_rx_get_min_frag_sz(params, xsk);
 
 	/* AF_XDP doesn't build SKBs in place. */
 	if (!xsk)
 		frag_sz = MLX5_SKB_FRAG_SZ(frag_sz);
 
-	/* XDP in mlx5e doesn't support multiple packets per page. */
+	/* XDP in mlx5e doesn't support multiple packets per page. AF_XDP is a
+	 * special case. It can run with frames smaller than a page, as it
+	 * doesn't allocate pages dynamically. However, here we pretend that
+	 * fragments are page-sized: it allows to treat XSK frames like pages
+	 * by redirecting alloc and free operations to XSK rings and by using
+	 * the fact there are no multiple packets per "page" (which is a frame).
+	 * The latter is important, because frames may come in a random order,
+	 * and we will have trouble assemblying a real page of multiple frames.
+	 */
 	if (mlx5e_rx_is_xdp(params, xsk))
 		frag_sz = max_t(u32, frag_sz, PAGE_SIZE);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 3a615d663d84..989d8f429438 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -76,6 +76,8 @@ static inline bool mlx5e_qid_validate(const struct mlx5e_profile *profile,
 
 u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 				 struct mlx5e_xsk_param *xsk);
+u32 mlx5e_rx_get_min_frag_sz(struct mlx5e_params *params,
+			     struct mlx5e_xsk_param *xsk);
 u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params,
 				struct mlx5e_xsk_param *xsk);
 u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 7c49a66d28c9..475b6bd5d29b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -105,7 +105,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 
 	/* head_offset is not used in this function, because di->xsk.data and
 	 * di->addr point directly to the necessary place. Furthermore, in the
-	 * current implementation, one page = one packet = one frame, so
+	 * current implementation, UMR pages are mapped to XSK frames, so
 	 * head_offset should always be 0.
 	 */
 	WARN_ON_ONCE(head_offset);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index f701e4f3c076..d549f770cb4f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -4,18 +4,23 @@
 #include "setup.h"
 #include "en/params.h"
 
+/* It matches XDP_UMEM_MIN_CHUNK_SIZE, but as this constant is private and may
+ * change unexpectedly, and mlx5e has a minimum valid stride size for striding
+ * RQ, keep this check in the driver.
+ */
+#define MLX5E_MIN_XSK_CHUNK_SIZE 2048
+
 bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
 			      struct mlx5e_xsk_param *xsk,
 			      struct mlx5_core_dev *mdev)
 {
-	/* AF_XDP doesn't support frames larger than PAGE_SIZE, and the current
-	 * mlx5e XDP implementation doesn't support multiple packets per page.
-	 */
-	if (xsk->chunk_size != PAGE_SIZE)
+	/* AF_XDP doesn't support frames larger than PAGE_SIZE. */
+	if (xsk->chunk_size > PAGE_SIZE ||
+			xsk->chunk_size < MLX5E_MIN_XSK_CHUNK_SIZE)
 		return false;
 
 	/* Current MTU and XSK headroom don't allow packets to fit the frames. */
-	if (mlx5e_rx_get_linear_frag_sz(params, xsk) > xsk->chunk_size)
+	if (mlx5e_rx_get_min_frag_sz(params, xsk) > xsk->chunk_size)
 		return false;
 
 	/* frag_sz is different for regular and XSK RQs, so ensure that linear
-- 
2.17.1

