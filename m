Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D719B72FE4
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfGXN0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:26:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:14367 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfGXN0l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 09:26:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 06:26:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,303,1559545200"; 
   d="scan'208";a="369295202"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by fmsmga006.fm.intel.com with ESMTP; 24 Jul 2019 06:26:38 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com,
        saeedm@mellanox.com, maximmi@mellanox.com,
        stephen@networkplumber.org
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next v3 09/11] samples/bpf: add buffer recycling for unaligned chunks to xdpsock
Date:   Wed, 24 Jul 2019 05:10:41 +0000
Message-Id: <20190724051043.14348-10-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190724051043.14348-1-kevin.laatz@intel.com>
References: <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190724051043.14348-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds buffer recycling support for unaligned buffers. Since we
don't mask the addr to 2k at umem_reg in unaligned mode, we need to make
sure we give back the correct (original) addr to the fill queue. We achieve
this using the new descriptor format and associated masks. The new format
uses the upper 16-bits for the offset and the lower 48-bits for the addr.
Since we have a field for the offset, we no longer need to modify the
actual address. As such, all we have to do to get back the original address
is mask for the lower 48 bits (i.e. strip the offset and we get the address
on it's own).

Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
Signed-off-by: Bruce Richardson <bruce.richardson@intel.com>

---
v2:
  - Removed unused defines
  - Fix buffer recycling for unaligned case
  - Remove --buf-size (--frame-size merged before this)
  - Modifications to use the new descriptor format for buffer recycling
---
 samples/bpf/xdpsock_user.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 26ba1a1fd582..f824fa3b5021 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -474,6 +474,7 @@ static void kick_tx(struct xsk_socket_info *xsk)
 
 static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
 {
+	struct xsk_umem_info *umem = xsk->umem;
 	u32 idx_cq = 0, idx_fq = 0;
 	unsigned int rcvd;
 	size_t ndescs;
@@ -486,22 +487,21 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
 		xsk->outstanding_tx;
 
 	/* re-add completed Tx buffers */
-	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, ndescs, &idx_cq);
+	rcvd = xsk_ring_cons__peek(&umem->cq, ndescs, &idx_cq);
 	if (rcvd > 0) {
 		unsigned int i;
 		int ret;
 
-		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
+		ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
 		while (ret != rcvd) {
 			if (ret < 0)
 				exit_with_error(-ret);
-			ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
-						     &idx_fq);
+			ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
 		}
+
 		for (i = 0; i < rcvd; i++)
-			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
-				*xsk_ring_cons__comp_addr(&xsk->umem->cq,
-							  idx_cq++);
+			*xsk_ring_prod__fill_addr(&umem->fq, idx_fq++) =
+				*xsk_ring_cons__comp_addr(&umem->cq, idx_cq++);
 
 		xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
 		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
@@ -548,7 +548,11 @@ static void rx_drop(struct xsk_socket_info *xsk)
 	for (i = 0; i < rcvd; i++) {
 		u64 addr = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx)->addr;
 		u32 len = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++)->len;
-		char *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
+		u64 offset = addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
+
+		addr &= XSK_UNALIGNED_BUF_ADDR_MASK;
+		char *pkt = xsk_umem__get_data(xsk->umem->buffer,
+				addr + offset);
 
 		hex_dump(pkt, len, addr);
 		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = addr;
@@ -654,7 +658,9 @@ static void l2fwd(struct xsk_socket_info *xsk)
 							  idx_rx)->addr;
 			u32 len = xsk_ring_cons__rx_desc(&xsk->rx,
 							 idx_rx++)->len;
-			char *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
+			u64 offset = addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
+			char *pkt = xsk_umem__get_data(xsk->umem->buffer,
+				(addr & XSK_UNALIGNED_BUF_ADDR_MASK) + offset);
 
 			swap_mac_addresses(pkt);
 
-- 
2.17.1

