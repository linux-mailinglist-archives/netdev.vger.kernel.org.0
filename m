Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C10D157EBF
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 16:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgBJP1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 10:27:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:11685 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbgBJP1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 10:27:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Feb 2020 07:27:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,425,1574150400"; 
   d="scan'208";a="380134638"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.39.223])
  by orsmga004.jf.intel.com with ESMTP; 10 Feb 2020 07:27:15 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, maximmi@mellanox.com,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     rgoodfel@isi.edu, bpf@vger.kernel.org,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf] xsk: publish global consumer pointers when NAPI is finished
Date:   Mon, 10 Feb 2020 16:27:12 +0100
Message-Id: <1581348432-6747-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 4b638f13bab4 ("xsk: Eliminate the RX batch size")
introduced a much more lazy way of updating the global consumer
pointers from the kernel side, by only doing so when running out of
entries in the fill or Tx rings (the rings consumed by the
kernel). This can result in a deadlock with the user application if
the kernel requires more than one entry to proceed and the application
cannot put these entries in the fill ring because the kernel has not
updated the global consumer pointer since the ring is not empty.

Fix this by publishing the local kernel side consumer pointer whenever
we have completed Rx or Tx processing in the kernel. This way, user
space will have an up-to-date view of the consumer pointers whenever it
gets to execute in the one core case (application and driver on the
same core), or after a certain number of packets have been processed
in the two core case (application and driver on different cores).

A side effect of this patch is that the one core case gets better
performance, but the two core case gets worse. The reason that the one
core case improves is that updating the global consumer pointer is
relatively cheap since the application by definition is not running
when the kernel is (they are on the same core) and it is beneficial
for the application, once it gets to run, to have pointers that are
as up to date as possible since it then can operate on more packets
and buffers. In the two core case, the most important performance
aspect is to minimize the number of accesses to the global pointers
since they are shared between two cores and bounces between the caches
of those cores. This patch results in more updates to global state,
which means lower performance in the two core case.

Fixes: 4b638f13bab4 ("xsk: Eliminate the RX batch size")
Reported-by: Ryan Goodfellow <rgoodfel@isi.edu>
Reported-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c       | 2 ++
 net/xdp/xsk_queue.h | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index df60048..356f90e 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -217,6 +217,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 static void xsk_flush(struct xdp_sock *xs)
 {
 	xskq_prod_submit(xs->rx);
+	__xskq_cons_release(xs->umem->fq);
 	sock_def_readable(&xs->sk);
 }
 
@@ -304,6 +305,7 @@ void xsk_umem_consume_tx_done(struct xdp_umem *umem)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
+		__xskq_cons_release(xs->tx);
 		xs->sk.sk_write_space(&xs->sk);
 	}
 	rcu_read_unlock();
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index bec2af1..89a01ac 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -271,7 +271,8 @@ static inline void xskq_cons_release(struct xsk_queue *q)
 {
 	/* To improve performance, only update local state here.
 	 * Reflect this to global state when we get new entries
-	 * from the ring in xskq_cons_get_entries().
+	 * from the ring in xskq_cons_get_entries() and whenever
+	 * Rx or Tx processing are completed in the NAPI loop.
 	 */
 	q->cached_cons++;
 }
-- 
2.7.4

