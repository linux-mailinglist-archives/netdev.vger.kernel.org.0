Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26E0310D379
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 10:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfK2JvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 04:51:21 -0500
Received: from mga07.intel.com ([134.134.136.100]:24278 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfK2JvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Nov 2019 04:51:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Nov 2019 01:51:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,257,1571727600"; 
   d="scan'208";a="360026881"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.32.245])
  by orsmga004.jf.intel.com with ESMTP; 29 Nov 2019 01:51:17 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     maximmi@mellanox.com, bpf@vger.kernel.org
Subject: [PATCH bpf] xsk: add missing memory barrier in xskq_has_addrs()
Date:   Fri, 29 Nov 2019 10:51:10 +0100
Message-Id: <1575021070-28873-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rings in AF_XDP between user space and kernel space have the
following semantics:

producer                         consumer

if (LOAD ->consumer) {           LOAD ->producer
                   (A)           smp_rmb()       (C)
   STORE $data                   LOAD $data
   smp_wmb()       (B)           smp_mb()        (D)
   STORE ->producer              STORE ->consumer
}

The consumer function xskq_has_addrs() below loads the producer
pointer and updates the locally cached copy of it. However, it does
not issue the smp_rmb() operation required by the lockless ring. This
would have been ok had the function not updated the locally cached
copy, as that could not have resulted in new data being read from the
ring. But as it updates the local producer pointer, a subsequent peek
operation, such as xskq_peek_addr(), might load data from the ring
without issuing the required smp_rmb() memory barrier.

static inline bool xskq_has_addrs(struct xsk_queue *q, u32 cnt)
{
        u32 entries = q->prod_tail - q->cons_tail;

        if (entries >= cnt)
                return true;

        /* Refresh the local pointer. */
        q->prod_tail = READ_ONCE(q->ring->producer);
	*** MISSING MEMORY BARRIER ***
        entries = q->prod_tail - q->cons_tail;

        return entries >= cnt;
}

Fix this by adding the missing memory barrier at the indicated point
above.

Fixes: d57d76428ae9 ("Add API to check for available entries in FQ")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_queue.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index eddae46..b5492c3 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -127,6 +127,7 @@ static inline bool xskq_has_addrs(struct xsk_queue *q, u32 cnt)
 
 	/* Refresh the local pointer. */
 	q->prod_tail = READ_ONCE(q->ring->producer);
+	smp_rmb(); /* C, matches B */
 	entries = q->prod_tail - q->cons_tail;
 
 	return entries >= cnt;
-- 
2.7.4

