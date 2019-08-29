Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111B0A25CE
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbfH2Scg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbfH2SN7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D4F821874;
        Thu, 29 Aug 2019 18:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102437;
        bh=5y9dvtzLtnMSqUk9d8sNDkmgONsLAP0F782sRfpeUOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ru7PmfHqWAi1lwEjRb3KUNkUXUDpLzqPKT/BX+BwsVAksaBnD5LGm/DU5HDDT1imk
         CcQrI37cEdZj03MDI6iNH9wstr8ga/GvykyqEETh6RAvYrgjs7aeTQUH+Z+cIYjRNL
         meq18KxDy75HPB24vM+E0ag0znmBgCTsAArl5QdI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        syzbot+78e71c5bab4f76a6a719@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 26/76] rxrpc: Fix read-after-free in rxrpc_queue_local()
Date:   Thu, 29 Aug 2019 14:12:21 -0400
Message-Id: <20190829181311.7562-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 06d9532fa6b34f12a6d75711162d47c17c1add72 ]

rxrpc_queue_local() attempts to queue the local endpoint it is given and
then, if successful, prints a trace line.  The trace line includes the
current usage count - but we're not allowed to look at the local endpoint
at this point as we passed our ref on it to the workqueue.

Fix this by reading the usage count before queuing the work item.

Also fix the reading of local->debug_id for trace lines, which must be done
with the same consideration as reading the usage count.

Fixes: 09d2bf595db4 ("rxrpc: Add a tracepoint to track rxrpc_local refcounting")
Reported-by: syzbot+78e71c5bab4f76a6a719@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h |  6 +++---
 net/rxrpc/local_object.c     | 19 ++++++++++---------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index cc1d060cbf133..fa06b528c73c5 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -498,10 +498,10 @@ rxrpc_tx_points;
 #define E_(a, b)	{ a, b }
 
 TRACE_EVENT(rxrpc_local,
-	    TP_PROTO(struct rxrpc_local *local, enum rxrpc_local_trace op,
+	    TP_PROTO(unsigned int local_debug_id, enum rxrpc_local_trace op,
 		     int usage, const void *where),
 
-	    TP_ARGS(local, op, usage, where),
+	    TP_ARGS(local_debug_id, op, usage, where),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,	local		)
@@ -511,7 +511,7 @@ TRACE_EVENT(rxrpc_local,
 			     ),
 
 	    TP_fast_assign(
-		    __entry->local = local->debug_id;
+		    __entry->local = local_debug_id;
 		    __entry->op = op;
 		    __entry->usage = usage;
 		    __entry->where = where;
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 918bffca3ddb6..68e9342fd4335 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -93,7 +93,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		local->debug_id = atomic_inc_return(&rxrpc_debug_id);
 		memcpy(&local->srx, srx, sizeof(*srx));
 		local->srx.srx_service = 0;
-		trace_rxrpc_local(local, rxrpc_local_new, 1, NULL);
+		trace_rxrpc_local(local->debug_id, rxrpc_local_new, 1, NULL);
 	}
 
 	_leave(" = %p", local);
@@ -321,7 +321,7 @@ struct rxrpc_local *rxrpc_get_local(struct rxrpc_local *local)
 	int n;
 
 	n = atomic_inc_return(&local->usage);
-	trace_rxrpc_local(local, rxrpc_local_got, n, here);
+	trace_rxrpc_local(local->debug_id, rxrpc_local_got, n, here);
 	return local;
 }
 
@@ -335,7 +335,8 @@ struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *local)
 	if (local) {
 		int n = atomic_fetch_add_unless(&local->usage, 1, 0);
 		if (n > 0)
-			trace_rxrpc_local(local, rxrpc_local_got, n + 1, here);
+			trace_rxrpc_local(local->debug_id, rxrpc_local_got,
+					  n + 1, here);
 		else
 			local = NULL;
 	}
@@ -343,16 +344,16 @@ struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *local)
 }
 
 /*
- * Queue a local endpoint unless it has become unreferenced and pass the
- * caller's reference to the work item.
+ * Queue a local endpoint and pass the caller's reference to the work item.
  */
 void rxrpc_queue_local(struct rxrpc_local *local)
 {
 	const void *here = __builtin_return_address(0);
+	unsigned int debug_id = local->debug_id;
+	int n = atomic_read(&local->usage);
 
 	if (rxrpc_queue_work(&local->processor))
-		trace_rxrpc_local(local, rxrpc_local_queued,
-				  atomic_read(&local->usage), here);
+		trace_rxrpc_local(debug_id, rxrpc_local_queued, n, here);
 	else
 		rxrpc_put_local(local);
 }
@@ -367,7 +368,7 @@ void rxrpc_put_local(struct rxrpc_local *local)
 
 	if (local) {
 		n = atomic_dec_return(&local->usage);
-		trace_rxrpc_local(local, rxrpc_local_put, n, here);
+		trace_rxrpc_local(local->debug_id, rxrpc_local_put, n, here);
 
 		if (n == 0)
 			call_rcu(&local->rcu, rxrpc_local_rcu);
@@ -454,7 +455,7 @@ static void rxrpc_local_processor(struct work_struct *work)
 		container_of(work, struct rxrpc_local, processor);
 	bool again;
 
-	trace_rxrpc_local(local, rxrpc_local_processing,
+	trace_rxrpc_local(local->debug_id, rxrpc_local_processing,
 			  atomic_read(&local->usage), NULL);
 
 	do {
-- 
2.20.1

