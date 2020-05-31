Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A321E9A9C
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 23:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgEaVrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 17:47:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728395AbgEaVrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 17:47:49 -0400
Received: from lore-desk.lan (unknown [151.48.128.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38465206B6;
        Sun, 31 May 2020 21:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590961668;
        bh=AYTwty+A3SMZzGlgrDYlynHYNbtMF4MiJ8SBIUndzsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCVtfsopL1+OQ06KPop4degUJN8hnDlxkasFb95yatPxuMc+UGdz4Zrgo7rOdb+Jc
         cnFw8tPPoOiR1vzd0m9hQIIqecYfzQfYReGrisLcjhoWgrxYnXVzktxX8AmIdQFVAP
         MGaTNj+1m+8JFhlsFuKBs69WgSQkg6Hn+NxzFmUE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH bpf-next 5/6] bpf: cpumap: implement XDP_REDIRECT for eBPF programs attached to map entries
Date:   Sun, 31 May 2020 23:46:50 +0200
Message-Id: <605426d4fac4e5ae4e5d98afdafaf7e35625657c.1590960613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1590960613.git.lorenzo@kernel.org>
References: <cover.1590960613.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add XDP_REDIRECT support for eBPF programs attached to cpumap entries

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/trace/events/xdp.h | 12 ++++++++----
 kernel/bpf/cpumap.c        | 21 +++++++++++++++++----
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index 06ec557c6bf5..162ce06c6da0 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -177,9 +177,11 @@ DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map_err,
 TRACE_EVENT(xdp_cpumap_kthread,
 
 	TP_PROTO(int map_id, unsigned int processed,  unsigned int drops,
-		 int sched, unsigned int xdp_pass, unsigned int xdp_drop),
+		 int sched, unsigned int xdp_pass, unsigned int xdp_drop,
+		 unsigned int xdp_redirect),
 
-	TP_ARGS(map_id, processed, drops, sched, xdp_pass, xdp_drop),
+	TP_ARGS(map_id, processed, drops, sched, xdp_pass, xdp_drop,
+		xdp_redirect),
 
 	TP_STRUCT__entry(
 		__field(int, map_id)
@@ -190,6 +192,7 @@ TRACE_EVENT(xdp_cpumap_kthread,
 		__field(int, sched)
 		__field(unsigned int, xdp_pass)
 		__field(unsigned int, xdp_drop)
+		__field(unsigned int, xdp_redirect)
 	),
 
 	TP_fast_assign(
@@ -201,18 +204,19 @@ TRACE_EVENT(xdp_cpumap_kthread,
 		__entry->sched	= sched;
 		__entry->xdp_pass	= xdp_pass;
 		__entry->xdp_drop	= xdp_drop;
+		__entry->xdp_redirect	= xdp_redirect;
 	),
 
 	TP_printk("kthread"
 		  " cpu=%d map_id=%d action=%s"
 		  " processed=%u drops=%u"
 		  " sched=%d"
-		  " xdp_pass=%u xdp_drop=%u",
+		  " xdp_pass=%u xdp_drop=%u xdp_redirect=%u",
 		  __entry->cpu, __entry->map_id,
 		  __print_symbolic(__entry->act, __XDP_ACT_SYM_TAB),
 		  __entry->processed, __entry->drops,
 		  __entry->sched,
-		  __entry->xdp_pass, __entry->xdp_drop)
+		  __entry->xdp_pass, __entry->xdp_drop, __entry->xdp_redirect)
 );
 
 TRACE_EVENT(xdp_cpumap_enqueue,
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 24ab0a6b9772..a45157627fbc 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -248,7 +248,7 @@ static int cpu_map_kthread_run(void *data)
 	 * kthread_stop signal until queue is empty.
 	 */
 	while (!kthread_should_stop() || !__ptr_ring_empty(rcpu->queue)) {
-		unsigned int xdp_pass = 0, xdp_drop = 0;
+		unsigned int xdp_pass = 0, xdp_drop = 0, xdp_redirect = 0;
 		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
 		unsigned int drops = 0, sched = 0;
 		void *xdp_frames[CPUMAP_BATCH];
@@ -279,7 +279,7 @@ static int cpu_map_kthread_run(void *data)
 		n = ptr_ring_consume_batched(rcpu->queue, xdp_frames,
 					     CPUMAP_BATCH);
 
-		rcu_read_lock();
+		rcu_read_lock_bh();
 
 		prog = READ_ONCE(rcpu->prog);
 		for (i = 0; i < n; i++) {
@@ -315,6 +315,16 @@ static int cpu_map_kthread_run(void *data)
 					xdp_pass++;
 				}
 				break;
+			case XDP_REDIRECT:
+				err = xdp_do_redirect(xdpf->dev_rx, &xdp,
+						      prog);
+				if (unlikely(err)) {
+					xdp_return_frame(xdpf);
+					drops++;
+				} else {
+					xdp_redirect++;
+				}
+				break;
 			default:
 				bpf_warn_invalid_xdp_action(act);
 				/* fallthrough */
@@ -325,7 +335,10 @@ static int cpu_map_kthread_run(void *data)
 			}
 		}
 
-		rcu_read_unlock();
+		if (xdp_redirect)
+			xdp_do_flush_map();
+
+		rcu_read_unlock_bh();
 
 		m = kmem_cache_alloc_bulk(skbuff_head_cache, gfp,
 					  nframes, skbs);
@@ -354,7 +367,7 @@ static int cpu_map_kthread_run(void *data)
 		}
 		/* Feedback loop via tracepoint */
 		trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched,
-					 xdp_pass, xdp_drop);
+					 xdp_pass, xdp_drop, xdp_redirect);
 
 		local_bh_enable(); /* resched point, may call do_softirq() */
 	}
-- 
2.26.2

