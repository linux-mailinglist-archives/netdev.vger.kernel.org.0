Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998AFA9E52
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 11:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732010AbfIEJ1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 05:27:33 -0400
Received: from mga17.intel.com ([192.55.52.151]:61744 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730633AbfIEJ1d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 05:27:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 02:27:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,470,1559545200"; 
   d="scan'208";a="177249564"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by orsmga008.jf.intel.com with ESMTP; 05 Sep 2019 02:27:30 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next] i40e: fix xdp handle calculations
Date:   Thu,  5 Sep 2019 01:11:44 +0000
Message-Id: <20190905011144.3513-1-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we don't add headroom to the handle in i40e_zca_free,
i40e_alloc_buffer_slow_zc and i40e_alloc_buffer_zc. The addition of the
headroom to the handle was removed in
commit 2f86c806a8a8 ("i40e: modify driver for handling offsets"), which
will break things when headroom is non-zero. This patch fixes this and uses
xsk_umem_adjust_offset to add it appropritely based on the mode being run.

Fixes: 2f86c806a8a8 ("i40e: modify driver for handling offsets")
Reported-by: Bjorn Topel <bjorn.topel@intel.com>
Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index eaca6162a6e6..0373bc6c7e61 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -267,7 +267,7 @@ static bool i40e_alloc_buffer_zc(struct i40e_ring *rx_ring,
 	bi->addr = xdp_umem_get_data(umem, handle);
 	bi->addr += hr;
 
-	bi->handle = handle;
+	bi->handle = xsk_umem_adjust_offset(umem, handle, umem->headroom);
 
 	xsk_umem_discard_addr(umem);
 	return true;
@@ -304,7 +304,7 @@ static bool i40e_alloc_buffer_slow_zc(struct i40e_ring *rx_ring,
 	bi->addr = xdp_umem_get_data(umem, handle);
 	bi->addr += hr;
 
-	bi->handle = handle;
+	bi->handle = xsk_umem_adjust_offset(umem, handle, umem->headroom);
 
 	xsk_umem_discard_addr_rq(umem);
 	return true;
@@ -469,7 +469,8 @@ void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long handle)
 	bi->addr = xdp_umem_get_data(rx_ring->xsk_umem, handle);
 	bi->addr += hr;
 
-	bi->handle = (u64)handle;
+	bi->handle = xsk_umem_adjust_offset(rx_ring->xsk_umem, (u64)handle,
+					    rx_ring->xsk_umem->headroom);
 }
 
 /**
-- 
2.17.1

