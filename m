Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAC0B1BB3
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 12:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387653AbfIMKmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 06:42:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:8384 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387512AbfIMKmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 06:42:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 03:42:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="187784052"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.223.65])
  by orsmga003.jf.intel.com with ESMTP; 13 Sep 2019 03:42:21 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Cc:     bruce.richardson@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, kevin.laatz@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v2 1/3] i40e: fix xdp handle calculations
Date:   Fri, 13 Sep 2019 10:39:46 +0000
Message-Id: <20190913103948.32053-2-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190913103948.32053-1-ciara.loftus@intel.com>
References: <20190913103948.32053-1-ciara.loftus@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 4c5d9a7fa149 ("i40e: fix xdp handle calculations") reintroduced
the addition of the umem headroom to the xdp handle in the i40e_zca_free,
i40e_alloc_buffer_slow_zc and i40e_alloc_buffer_zc functions. However,
the headroom is already added to the handle in the function i40_run_xdp_zc.
This commit removes the latter addition and fixes the case where the
headroom is non-zero.

Fixes: 4c5d9a7fa149 ("i40e: fix xdp handle calculations")
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 0373bc6c7e61..a05dfecdd9b4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -192,9 +192,9 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 {
 	struct xdp_umem *umem = rx_ring->xsk_umem;
 	int err, result = I40E_XDP_PASS;
-	u64 offset = umem->headroom;
 	struct i40e_ring *xdp_ring;
 	struct bpf_prog *xdp_prog;
+	u64 offset;
 	u32 act;
 
 	rcu_read_lock();
@@ -203,7 +203,7 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	 */
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
-	offset += xdp->data - xdp->data_hard_start;
+	offset = xdp->data - xdp->data_hard_start;
 
 	xdp->handle = xsk_umem_adjust_offset(umem, xdp->handle, offset);
 
-- 
2.17.1

