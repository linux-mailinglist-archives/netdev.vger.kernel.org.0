Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2B7255EA9
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 18:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgH1QRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 12:17:41 -0400
Received: from mga18.intel.com ([134.134.136.126]:56807 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbgH1QRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 12:17:40 -0400
IronPort-SDR: wN+BCUMXoveesFK6daxSFzFYw6xK7lL7xkkcPZtozHKl0w4rUEzCIwXiAVxwGdajaa/GwvRXmW
 gE/Bec4RK28w==
X-IronPort-AV: E=McAfee;i="6000,8403,9727"; a="144367231"
X-IronPort-AV: E=Sophos;i="5.76,364,1592895600"; 
   d="scan'208";a="144367231"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 09:17:37 -0700
IronPort-SDR: q1dKrj5XCXMuRh7qeYQ7u+0OU6PBJApKE4iqNsiOytAgbRUGI91sQXTy8RSsp/095Fsh5SpqKa
 0zR1U3vcgHGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,364,1592895600"; 
   d="scan'208";a="444883827"
Received: from silpixa00400468.ir.intel.com ([10.237.214.28])
  by orsmga004.jf.intel.com with ESMTP; 28 Aug 2020 09:17:35 -0700
From:   Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, bpf@vger.kernel.org
Subject: [PATCH bpf-next] samples/bpf: fix to xdpsock to avoid recycling frames
Date:   Sat, 29 Aug 2020 00:17:17 +0800
Message-Id: <20200828161717.42705-1-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The txpush program in the xdpsock sample application is supposed
to send out all packets in the umem in a round-robin fashion.
The problem is that it only cycled through the first BATCH_SIZE
worth of packets. Fixed this so that it cycles through all buffers
in the umem as intended.

Fixes: 248c7f9c0e21 ("samples/bpf: convert xdpsock to use libbpf for AF_XDP access")
Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
---
 samples/bpf/xdpsock_user.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 19c679456a0e..c821e9867139 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1004,7 +1004,7 @@ static void rx_drop_all(void)
 	}
 }
 
-static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb, int batch_size)
+static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 {
 	u32 idx;
 	unsigned int i;
@@ -1017,14 +1017,14 @@ static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb, int batch_size)
 	for (i = 0; i < batch_size; i++) {
 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx,
 								  idx + i);
-		tx_desc->addr = (frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
+		tx_desc->addr = (*frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
 		tx_desc->len = PKT_SIZE;
 	}
 
 	xsk_ring_prod__submit(&xsk->tx, batch_size);
 	xsk->outstanding_tx += batch_size;
-	frame_nb += batch_size;
-	frame_nb %= NUM_FRAMES;
+	*frame_nb += batch_size;
+	*frame_nb %= NUM_FRAMES;
 	complete_tx_only(xsk, batch_size);
 }
 
@@ -1080,7 +1080,7 @@ static void tx_only_all(void)
 		}
 
 		for (i = 0; i < num_socks; i++)
-			tx_only(xsks[i], frame_nb[i], batch_size);
+			tx_only(xsks[i], &frame_nb[i], batch_size);
 
 		pkt_cnt += batch_size;
 
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

