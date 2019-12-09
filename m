Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57E961167C5
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 08:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfLIH5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 02:57:15 -0500
Received: from mga05.intel.com ([192.55.52.43]:35353 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbfLIH5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 02:57:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Dec 2019 23:57:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,294,1571727600"; 
   d="scan'208";a="362846901"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.32.126])
  by orsmga004.jf.intel.com with ESMTP; 08 Dec 2019 23:56:58 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next 05/12] xsk: eliminate the RX batch size
Date:   Mon,  9 Dec 2019 08:56:22 +0100
Message-Id: <1575878189-31860-6-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
References: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the xsk consumer ring code there is a variable call RX_BATCH_SIZE
that dictates the minimum number of entries that we try to grab from
the fill and Tx rings. In fact, the code always try to grab the
maximum amount of entries from these rings. The only thing this
variable does is to throw an error if there is less than 16 (as it is
defined) entries on the ring. There is no reason to do this and it
will just lead to weird behavior from user space's point of view. So
eliminate this variable.

With this change, we will be able to simplify the xskq_nb_free and
xskq_nb_avail code in the next commit.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_queue.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 85358af..e3ae62d 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -10,8 +10,6 @@
 #include <linux/if_xdp.h>
 #include <net/xdp_sock.h>
 
-#define RX_BATCH_SIZE 16
-
 struct xdp_ring {
 	u32 producer ____cacheline_aligned_in_smp;
 	u32 consumer ____cacheline_aligned_in_smp;
@@ -202,7 +200,7 @@ static inline u64 *xskq_peek_addr(struct xsk_queue *q, u64 *addr,
 	if (q->cons_tail == q->cons_head) {
 		smp_mb(); /* D, matches A */
 		WRITE_ONCE(q->ring->consumer, q->cons_tail);
-		q->cons_head = q->cons_tail + xskq_nb_avail(q, RX_BATCH_SIZE);
+		q->cons_head = q->cons_tail + xskq_nb_avail(q, 1);
 
 		/* Order consumer and data */
 		smp_rmb();
@@ -320,7 +318,7 @@ static inline struct xdp_desc *xskq_peek_desc(struct xsk_queue *q,
 	if (q->cons_tail == q->cons_head) {
 		smp_mb(); /* D, matches A */
 		WRITE_ONCE(q->ring->consumer, q->cons_tail);
-		q->cons_head = q->cons_tail + xskq_nb_avail(q, RX_BATCH_SIZE);
+		q->cons_head = q->cons_tail + xskq_nb_avail(q, 1);
 
 		/* Order consumer and data */
 		smp_rmb(); /* C, matches B */
-- 
2.7.4

