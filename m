Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549FF1167C2
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 08:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfLIH5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 02:57:00 -0500
Received: from mga05.intel.com ([192.55.52.43]:35290 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727211AbfLIH47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 02:56:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Dec 2019 23:56:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,294,1571727600"; 
   d="scan'208";a="362846890"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.32.126])
  by orsmga004.jf.intel.com with ESMTP; 08 Dec 2019 23:56:54 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next 04/12] xsk: simplify detection of empty and full rings
Date:   Mon,  9 Dec 2019 08:56:21 +0100
Message-Id: <1575878189-31860-5-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
References: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to set the correct return flags for poll, the xsk code has to
check if the Rx queue is empty and if the Tx queue is full. This code
was unnecessarily large and complex as it used the functions that are
used to update the local state from the global state (xskq_nb_free and
xskq_nb_avail). Since we are not doing this nor updating any data
dependent on this state, we can simplify the functions. Another
benefit from this is that we can also simplify the xskq_nb_free and
xskq_nb_avail functions in a later commit.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c       |  4 ++--
 net/xdp/xsk_queue.h | 10 ++++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 76013f0..dbeb4e4 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -471,9 +471,9 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			__xsk_sendmsg(sk);
 	}
 
-	if (xs->rx && !xskq_empty_desc(xs->rx))
+	if (xs->rx && !xskq_prod_is_empty(xs->rx))
 		mask |= EPOLLIN | EPOLLRDNORM;
-	if (xs->tx && !xskq_full_desc(xs->tx))
+	if (xs->tx && !xskq_cons_is_full(xs->tx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
 	return mask;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 202d402..85358af 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -351,14 +351,16 @@ static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 	return 0;
 }
 
-static inline bool xskq_full_desc(struct xsk_queue *q)
+static inline bool xskq_cons_is_full(struct xsk_queue *q)
 {
-	return xskq_nb_avail(q, q->nentries) == q->nentries;
+	/* No barriers needed since data is not accessed */
+	return READ_ONCE(q->ring->producer) - q->cons_tail == q->nentries;
 }
 
-static inline bool xskq_empty_desc(struct xsk_queue *q)
+static inline bool xskq_prod_is_empty(struct xsk_queue *q)
 {
-	return xskq_nb_free(q, q->nentries) == q->nentries;
+	/* No barriers needed since data is not accessed */
+	return READ_ONCE(q->ring->consumer) == q->cached_prod;
 }
 
 void xskq_set_umem(struct xsk_queue *q, u64 size, u64 chunk_mask);
-- 
2.7.4

