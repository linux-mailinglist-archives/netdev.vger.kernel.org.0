Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C0B255DAC
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 17:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgH1PUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 11:20:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:13213 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgH1PUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 11:20:37 -0400
IronPort-SDR: Zy+357+bIlf846PYA8VKHi7HrWMyht9FIPvFs/FcEgfE/ejbXtrtQ3gCmR9AzXnEBSutd/gHdF
 oqo0rvmXovcg==
X-IronPort-AV: E=McAfee;i="6000,8403,9727"; a="136744421"
X-IronPort-AV: E=Sophos;i="5.76,364,1592895600"; 
   d="scan'208";a="136744421"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 08:20:34 -0700
IronPort-SDR: 0gXLrwgpWXtkB9mKzimsaRRA/x9TWapBhKVEG6GxRYvodddgTy41Q0uPtObzf/FY+rRbsu/O+N
 x4nVyPdZmGUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,364,1592895600"; 
   d="scan'208";a="444866264"
Received: from silpixa00400468.ir.intel.com ([10.237.214.28])
  by orsmga004.jf.intel.com with ESMTP; 28 Aug 2020 08:20:32 -0700
From:   Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, bpf@vger.kernel.org
Subject: [PATCH bpf-next]  0001-samples-bpf-fix-to-xdpsock-to-avoid-recycling-frames.patch
Date:   Fri, 28 Aug 2020 23:20:19 +0800
Message-Id: <20200828152019.42201-1-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
 ...to-xdpsock-to-avoid-recycling-frames.patch | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 0001-samples-bpf-fix-to-xdpsock-to-avoid-recycling-frames.patch

diff --git a/0001-samples-bpf-fix-to-xdpsock-to-avoid-recycling-frames.patch b/0001-samples-bpf-fix-to-xdpsock-to-avoid-recycling-frames.patch
new file mode 100644
index 000000000000..ae3b99b335e2
--- /dev/null
+++ b/0001-samples-bpf-fix-to-xdpsock-to-avoid-recycling-frames.patch
@@ -0,0 +1,62 @@
+From df0a23a79c9dca96c0059b4d766a613eba57200e Mon Sep 17 00:00:00 2001
+From: Weqaar Janjua <weqaar.a.janjua@intel.com>
+Date: Fri, 28 Aug 2020 13:36:32 +0100
+Subject: [PATCH bpf-next] samples/bpf: fix to xdpsock to avoid recycling
+ frames
+To: magnus.karlsson@intel.com
+
+The txpush program in the xdpsock sample application is supposed
+to send out all packets in the umem in a round-robin fashion.
+The problem is that it only cycled through the first BATCH_SIZE
+worth of packets. Fixed this so that it cycles through all buffers
+in the umem as intended.
+
+Fixes: 248c7f9c0e21 ("samples/bpf: convert xdpsock to use libbpf for AF_XDP access")
+Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
+---
+ samples/bpf/xdpsock_user.c | 10 +++++-----
+ 1 file changed, 5 insertions(+), 5 deletions(-)
+
+diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
+index 19c679456a0e..c821e9867139 100644
+--- a/samples/bpf/xdpsock_user.c
++++ b/samples/bpf/xdpsock_user.c
+@@ -1004,7 +1004,7 @@ static void rx_drop_all(void)
+ 	}
+ }
+ 
+-static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb, int batch_size)
++static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
+ {
+ 	u32 idx;
+ 	unsigned int i;
+@@ -1017,14 +1017,14 @@ static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb, int batch_size)
+ 	for (i = 0; i < batch_size; i++) {
+ 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx,
+ 								  idx + i);
+-		tx_desc->addr = (frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
++		tx_desc->addr = (*frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
+ 		tx_desc->len = PKT_SIZE;
+ 	}
+ 
+ 	xsk_ring_prod__submit(&xsk->tx, batch_size);
+ 	xsk->outstanding_tx += batch_size;
+-	frame_nb += batch_size;
+-	frame_nb %= NUM_FRAMES;
++	*frame_nb += batch_size;
++	*frame_nb %= NUM_FRAMES;
+ 	complete_tx_only(xsk, batch_size);
+ }
+ 
+@@ -1080,7 +1080,7 @@ static void tx_only_all(void)
+ 		}
+ 
+ 		for (i = 0; i < num_socks; i++)
+-			tx_only(xsks[i], frame_nb[i], batch_size);
++			tx_only(xsks[i], &frame_nb[i], batch_size);
+ 
+ 		pkt_cnt += batch_size;
+ 
+-- 
+2.20.1
+
-- 
2.20.1

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

