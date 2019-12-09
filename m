Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 715D11167D3
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 08:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfLIH52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 02:57:28 -0500
Received: from mga05.intel.com ([192.55.52.43]:35363 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727286AbfLIH5Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 02:57:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Dec 2019 23:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,294,1571727600"; 
   d="scan'208";a="362846972"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.32.126])
  by orsmga004.jf.intel.com with ESMTP; 08 Dec 2019 23:57:22 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next 12/12] xsk: use struct_size() helper
Date:   Mon,  9 Dec 2019 08:56:29 +0100
Message-Id: <1575878189-31860-13-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
References: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve readability and maintainability by using the struct_size()
helper when allocating the AF_XDP rings.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_queue.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/xdp/xsk_queue.c b/net/xdp/xsk_queue.c
index b665045..c90e9c1 100644
--- a/net/xdp/xsk_queue.c
+++ b/net/xdp/xsk_queue.c
@@ -18,14 +18,14 @@ void xskq_set_umem(struct xsk_queue *q, u64 size, u64 chunk_mask)
 	q->chunk_mask = chunk_mask;
 }
 
-static u32 xskq_umem_get_ring_size(struct xsk_queue *q)
+static size_t xskq_get_ring_size(struct xsk_queue *q, bool umem_queue)
 {
-	return sizeof(struct xdp_umem_ring) + q->nentries * sizeof(u64);
-}
+	struct xdp_umem_ring *umem_ring;
+	struct xdp_rxtx_ring *rxtx_ring;
 
-static u32 xskq_rxtx_get_ring_size(struct xsk_queue *q)
-{
-	return sizeof(struct xdp_ring) + q->nentries * sizeof(struct xdp_desc);
+	if (umem_queue)
+		return struct_size(umem_ring, desc, q->nentries);
+	return struct_size(rxtx_ring, desc, q->nentries);
 }
 
 struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
@@ -43,8 +43,7 @@ struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
 
 	gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN |
 		    __GFP_COMP  | __GFP_NORETRY;
-	size = umem_queue ? xskq_umem_get_ring_size(q) :
-	       xskq_rxtx_get_ring_size(q);
+	size = xskq_get_ring_size(q, umem_queue);
 
 	q->ring = (struct xdp_ring *)__get_free_pages(gfp_flags,
 						      get_order(size));
-- 
2.7.4

