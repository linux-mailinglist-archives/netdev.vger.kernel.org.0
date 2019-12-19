Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80ECF126264
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 13:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLSMkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 07:40:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:27930 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbfLSMkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 07:40:09 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 04:40:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,331,1571727600"; 
   d="scan'208";a="366062668"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.49.245])
  by orsmga004.jf.intel.com with ESMTP; 19 Dec 2019 04:40:06 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next v2 10/12] xsk: remove unnecessary READ_ONCE of data
Date:   Thu, 19 Dec 2019 13:39:29 +0100
Message-Id: <1576759171-28550-11-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576759171-28550-1-git-send-email-magnus.karlsson@intel.com>
References: <1576759171-28550-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two unnecessary READ_ONCE of descriptor data. These are not
needed since the data is written by the producer before it signals
that the data is available by incrementing the producer pointer. As the
access to this producer pointer is serialized and the consumer always
reads the descriptor after it has read and synchronized with the
producer counter, the write of the descriptor will have fully
completed and it does not matter if the consumer has any read tearing.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_queue.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 6d04a96..4c049ca 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -183,7 +183,7 @@ static inline bool xskq_cons_read_addr(struct xsk_queue *q, u64 *addr,
 	while (q->cached_cons != q->cached_prod) {
 		u32 idx = q->cached_cons & q->ring_mask;
 
-		*addr = READ_ONCE(ring->desc[idx]) & q->chunk_mask;
+		*addr = ring->desc[idx] & q->chunk_mask;
 
 		if (umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG) {
 			if (xskq_cons_is_valid_unaligned(q, *addr,
@@ -308,7 +308,7 @@ static inline bool xskq_cons_read_desc(struct xsk_queue *q,
 		struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
 		u32 idx = q->cached_cons & q->ring_mask;
 
-		*desc = READ_ONCE(ring->desc[idx]);
+		*desc = ring->desc[idx];
 		if (xskq_cons_is_valid_desc(q, desc, umem))
 			return true;
 
-- 
2.7.4

