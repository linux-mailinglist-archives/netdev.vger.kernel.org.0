Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0055A1A3AA6
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 21:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgDITgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 15:36:18 -0400
Received: from mail.efficios.com ([167.114.26.124]:47182 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgDITgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 15:36:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id BDEB528109B;
        Thu,  9 Apr 2020 15:35:59 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id WDzszhGAcDZT; Thu,  9 Apr 2020 15:35:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id EB0A828097D;
        Thu,  9 Apr 2020 15:35:58 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com EB0A828097D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1586460959;
        bh=EHJTpZNwmXluZM9tJ0paz0S+w/SyA8cPGMPnFdU4nVg=;
        h=From:To:Date:Message-Id;
        b=Hg/urOQpvU32K5RZgS22WfDNNMnSLMkqzgQXsmAFmKXDHU+cZuMNLdfmffqnynXMY
         v3X3Et1ys6H7xdZLL8yA7596mBLf7Zr2IwPzHZrdmIgwyjCKWauXEG4fLJaOIFfp9f
         v1fe37a8vE84wyQSRTVos68E7Hl10/AlstIDGEDs/6tB9ZDRiZXBLrpRfdvU4eOc5P
         JtBODCm3D3bEYg4ULA2G/dGNODFr0HPYaI81xg6BdgrjaTfzYvM5AgO7PCC2atorGR
         o95CoH++uSmyS1fXQ9RFj3dERWesrpc6nGU0C30rE2nI9XEGCHxUYA6zJE9wsL6eH1
         Hux8TDIXRlzLA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id D4ck5yx4Fpqa; Thu,  9 Apr 2020 15:35:58 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 20139280D6B;
        Thu,  9 Apr 2020 15:35:58 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "K . Prasad" <prasad@linux.vnet.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, rostedt@goodmis.org,
        Alexei Starovoitov <ast@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC PATCH 3/9] writeback: tracing: pass global_wb_domain as tracepoint parameter
Date:   Thu,  9 Apr 2020 15:35:37 -0400
Message-Id: <20200409193543.18115-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200409193543.18115-1-mathieu.desnoyers@efficios.com>
References: <20200409193543.18115-1-mathieu.desnoyers@efficios.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The symbol global_wb_domain is not GPL-exported to modules. In order
to allow kernel tracers implemented as GPL modules to access the
global writeback domain dirty limit, as used within the
global_dirty_state and balance_dirty_pages trace events, pass
a pointer to the global writeback domain as a new parameter for
those tracepoints.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 include/trace/events/writeback.h | 17 ++++++++++-------
 mm/page-writeback.c              |  9 +++++----
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index d94def25e4dc..8fd774108c9c 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -531,11 +531,13 @@ TRACE_EVENT(writeback_queue_io,
 
 TRACE_EVENT(global_dirty_state,
 
-	TP_PROTO(unsigned long background_thresh,
+	TP_PROTO(struct wb_domain *domain,
+		 unsigned long background_thresh,
 		 unsigned long dirty_thresh
 	),
 
-	TP_ARGS(background_thresh,
+	TP_ARGS(domain,
+		background_thresh,
 		dirty_thresh
 	),
 
@@ -558,7 +560,7 @@ TRACE_EVENT(global_dirty_state,
 		__entry->nr_written	= global_node_page_state(NR_WRITTEN);
 		__entry->background_thresh = background_thresh;
 		__entry->dirty_thresh	= dirty_thresh;
-		__entry->dirty_limit	= global_wb_domain.dirty_limit;
+		__entry->dirty_limit	= domain->dirty_limit;
 	),
 
 	TP_printk("dirty=%lu writeback=%lu unstable=%lu "
@@ -625,7 +627,8 @@ TRACE_EVENT(bdi_dirty_ratelimit,
 
 TRACE_EVENT(balance_dirty_pages,
 
-	TP_PROTO(struct bdi_writeback *wb,
+	TP_PROTO(struct wb_domain *domain,
+		 struct bdi_writeback *wb,
 		 unsigned long thresh,
 		 unsigned long bg_thresh,
 		 unsigned long dirty,
@@ -638,7 +641,7 @@ TRACE_EVENT(balance_dirty_pages,
 		 long pause,
 		 unsigned long start_time),
 
-	TP_ARGS(wb, thresh, bg_thresh, dirty, bdi_thresh, bdi_dirty,
+	TP_ARGS(domain, wb, thresh, bg_thresh, dirty, bdi_thresh, bdi_dirty,
 		dirty_ratelimit, task_ratelimit,
 		dirtied, period, pause, start_time),
 
@@ -664,8 +667,8 @@ TRACE_EVENT(balance_dirty_pages,
 		unsigned long freerun = (thresh + bg_thresh) / 2;
 		strscpy_pad(__entry->bdi, bdi_dev_name(wb->bdi), 32);
 
-		__entry->limit		= global_wb_domain.dirty_limit;
-		__entry->setpoint	= (global_wb_domain.dirty_limit +
+		__entry->limit		= domain->dirty_limit;
+		__entry->setpoint	= (domain->dirty_limit +
 						freerun) / 2;
 		__entry->dirty		= dirty;
 		__entry->bdi_setpoint	= __entry->setpoint *
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7326b54ab728..c76aae305360 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -443,9 +443,8 @@ static void domain_dirty_limits(struct dirty_throttle_control *dtc)
 	dtc->thresh = thresh;
 	dtc->bg_thresh = bg_thresh;
 
-	/* we should eventually report the domain in the TP */
 	if (!gdtc)
-		trace_global_dirty_state(bg_thresh, thresh);
+		trace_global_dirty_state(&global_wb_domain, bg_thresh, thresh);
 }
 
 /**
@@ -1736,7 +1735,8 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
 		 * do a reset, as it may be a light dirtier.
 		 */
 		if (pause < min_pause) {
-			trace_balance_dirty_pages(wb,
+			trace_balance_dirty_pages(&global_wb_domain,
+						  wb,
 						  sdtc->thresh,
 						  sdtc->bg_thresh,
 						  sdtc->dirty,
@@ -1765,7 +1765,8 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
 		}
 
 pause:
-		trace_balance_dirty_pages(wb,
+		trace_balance_dirty_pages(&global_wb_domain,
+					  wb,
 					  sdtc->thresh,
 					  sdtc->bg_thresh,
 					  sdtc->dirty,
-- 
2.17.1

