Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA25A9E56
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 11:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731942AbfIEJ2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 05:28:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:44290 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727900AbfIEJ2B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 05:28:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 02:28:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,470,1559545200"; 
   d="scan'208";a="212720546"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by fmsmga002.fm.intel.com with ESMTP; 05 Sep 2019 02:27:57 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next] ixgbe: fix xdp handle calculations
Date:   Thu,  5 Sep 2019 01:12:17 +0000
Message-Id: <20190905011217.3567-1-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we don't add headroom to the handle in ixgbe_zca_free,
ixgbe_alloc_buffer_slow_zc and ixgbe_alloc_buffer_zc. The addition of the
headroom to the handle was removed in
commit d8c3061e5edd ("ixgbe: modify driver for handling offsets"), which
will break things when headroom isvnon-zero. This patch fixes this and uses
xsk_umem_adjust_offset to add it appropritely based on the mode being run.

Fixes: d8c3061e5edd ("ixgbe: modify driver for handling offsets")
Reported-by: Bjorn Topel <bjorn.topel@intel.com>
Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 17061c799f72..ad802a8909e0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -248,7 +248,8 @@ void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long handle)
 	bi->addr = xdp_umem_get_data(rx_ring->xsk_umem, handle);
 	bi->addr += hr;
 
-	bi->handle = (u64)handle;
+	bi->handle = xsk_umem_adjust_offset(rx_ring->xsk_umem, (u64)handle,
+					    rx_ring->xsk_umem->headroom);
 }
 
 static bool ixgbe_alloc_buffer_zc(struct ixgbe_ring *rx_ring,
@@ -274,7 +275,7 @@ static bool ixgbe_alloc_buffer_zc(struct ixgbe_ring *rx_ring,
 	bi->addr = xdp_umem_get_data(umem, handle);
 	bi->addr += hr;
 
-	bi->handle = handle;
+	bi->handle = xsk_umem_adjust_offset(umem, handle, umem->headroom);
 
 	xsk_umem_discard_addr(umem);
 	return true;
@@ -301,7 +302,7 @@ static bool ixgbe_alloc_buffer_slow_zc(struct ixgbe_ring *rx_ring,
 	bi->addr = xdp_umem_get_data(umem, handle);
 	bi->addr += hr;
 
-	bi->handle = handle;
+	bi->handle = xsk_umem_adjust_offset(umem, handle, umem->headroom);
 
 	xsk_umem_discard_addr_rq(umem);
 	return true;
-- 
2.17.1

