Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D36B9E5E0
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 12:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbfH0Klc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 06:41:32 -0400
Received: from mga17.intel.com ([192.55.52.151]:38490 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfH0Klb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 06:41:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 03:41:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,436,1559545200"; 
   d="scan'208";a="174509579"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by orsmga008.jf.intel.com with ESMTP; 27 Aug 2019 03:41:27 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com,
        saeedm@mellanox.com, maximmi@mellanox.com,
        stephen@networkplumber.org
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next v6 04/12] i40e: modify driver for handling offsets
Date:   Tue, 27 Aug 2019 02:25:23 +0000
Message-Id: <20190827022531.15060-5-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190827022531.15060-1-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the addition of the unaligned chunks option, we need to make sure we
handle the offsets accordingly based on the mode we are currently running
in. This patch modifies the driver to appropriately mask the address for
each case.

Signed-off-by: Bruce Richardson <bruce.richardson@intel.com>
Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>

---
v3:
  - Use new helper function for handling the offset
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 2d6e82f72f48..eaca6162a6e6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -190,7 +190,9 @@ int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
  **/
 static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 {
+	struct xdp_umem *umem = rx_ring->xsk_umem;
 	int err, result = I40E_XDP_PASS;
+	u64 offset = umem->headroom;
 	struct i40e_ring *xdp_ring;
 	struct bpf_prog *xdp_prog;
 	u32 act;
@@ -201,7 +203,10 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	 */
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
-	xdp->handle += xdp->data - xdp->data_hard_start;
+	offset += xdp->data - xdp->data_hard_start;
+
+	xdp->handle = xsk_umem_adjust_offset(umem, xdp->handle, offset);
+
 	switch (act) {
 	case XDP_PASS:
 		break;
@@ -262,7 +267,7 @@ static bool i40e_alloc_buffer_zc(struct i40e_ring *rx_ring,
 	bi->addr = xdp_umem_get_data(umem, handle);
 	bi->addr += hr;
 
-	bi->handle = handle + umem->headroom;
+	bi->handle = handle;
 
 	xsk_umem_discard_addr(umem);
 	return true;
@@ -299,7 +304,7 @@ static bool i40e_alloc_buffer_slow_zc(struct i40e_ring *rx_ring,
 	bi->addr = xdp_umem_get_data(umem, handle);
 	bi->addr += hr;
 
-	bi->handle = handle + umem->headroom;
+	bi->handle = handle;
 
 	xsk_umem_discard_addr_rq(umem);
 	return true;
@@ -464,7 +469,7 @@ void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long handle)
 	bi->addr = xdp_umem_get_data(rx_ring->xsk_umem, handle);
 	bi->addr += hr;
 
-	bi->handle = (u64)handle + rx_ring->xsk_umem->headroom;
+	bi->handle = (u64)handle;
 }
 
 /**
-- 
2.17.1

