Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B177AF15
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbfG3RJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:09:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:33179 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbfG3RJ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 13:09:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jul 2019 10:09:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,327,1559545200"; 
   d="scan'208";a="183192633"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2019 10:09:55 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com,
        saeedm@mellanox.com, maximmi@mellanox.com,
        stephen@networkplumber.org
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next v4 07/11] mlx5e: modify driver for handling offsets
Date:   Tue, 30 Jul 2019 08:53:56 +0000
Message-Id: <20190730085400.10376-8-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190730085400.10376-1-kevin.laatz@intel.com>
References: <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190730085400.10376-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the addition of the unaligned chunks option, we need to make sure we
handle the offsets accordingly based on the mode we are currently running
in. This patch modifies the driver to appropriately mask the address for
each case.

Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>

---
v3:
  - Use new helper function to handle offset

v4:
  - fixed headroom addition to handle. Using xsk_umem_adjust_headroom()
    now.
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c    | 8 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c | 3 ++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index b0b982cf69bb..d5245893d2c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -122,6 +122,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		      void *va, u16 *rx_headroom, u32 *len, bool xsk)
 {
 	struct bpf_prog *prog = READ_ONCE(rq->xdp_prog);
+	struct xdp_umem *umem = rq->umem;
 	struct xdp_buff xdp;
 	u32 act;
 	int err;
@@ -138,8 +139,11 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 	xdp.rxq = &rq->xdp_rxq;
 
 	act = bpf_prog_run_xdp(prog, &xdp);
-	if (xsk)
-		xdp.handle += xdp.data - xdp.data_hard_start;
+	if (xsk) {
+		u64 off = xdp.data - xdp.data_hard_start;
+
+		xdp.handle = xsk_umem_handle_offset(umem, xdp.handle, off);
+	}
 	switch (act) {
 	case XDP_PASS:
 		*rx_headroom = xdp.data - xdp.data_hard_start;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 6a55573ec8f2..7c49a66d28c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -24,7 +24,8 @@ int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
 	if (!xsk_umem_peek_addr_rq(umem, &handle))
 		return -ENOMEM;
 
-	dma_info->xsk.handle = handle + rq->buff.umem_headroom;
+	dma_info->xsk.handle = xsk_umem_adjust_offset(umem, handle,
+						      rq->buff.umem_headroom);
 	dma_info->xsk.data = xdp_umem_get_data(umem, dma_info->xsk.handle);
 
 	/* No need to add headroom to the DMA address. In striding RQ case, we
-- 
2.17.1

