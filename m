Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ED6365AC9
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhDTOF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232359AbhDTOFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:05:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AAE3613BF;
        Tue, 20 Apr 2021 14:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618927523;
        bh=dcFZ5RXdSvd1Cq84RWLgDb0q1FTq2chrGJdKTEkn7zU=;
        h=From:To:Cc:Subject:Date:From;
        b=GtIrcWRFfuhKQHxJ5VmADVNoBI7CBKwfky6CD0pk0TyHW6+6LqVWTA8VOJ642fLSS
         hsneb5QYURFzrXSDFnk2x6eRXPC07I57yFw6ro+wjo/RB3EpAXm8TwI6kh/ZAl8xat
         r33M5VKNntcEGK3+hYw4HUpuF5yFc4s3l1S54sVBuMVlhYQhOpq3iNgngT85sutDh2
         OFbg63Gt4CFcmsDETZz0PEWEjDREuGgQsm4wT9ER4THarMCQEN6vroWVnjawvcp8Pk
         ujI6Wphi6bIiu9FuHNti+uw8fJeyVD6I3gBSybFEXr9zP3t0TMKJ9F28Rn4tltDScd
         Y+1si+SXlLxAg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, song@kernel.org,
        toke@redhat.com
Subject: [PATCH v3 bpf-next] cpumap: bulk skb using netif_receive_skb_list
Date:   Tue, 20 Apr 2021 16:05:14 +0200
Message-Id: <01cd8afa22786b2c8a4cd7250d165741e990a771.1618927173.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rely on netif_receive_skb_list routine to send skbs converted from
xdp_frames in cpu_map_kthread_run in order to improve i-cache usage.
The proposed patch has been tested running xdp_redirect_cpu bpf sample
available in the kernel tree that is used to redirect UDP frames from
ixgbe driver to a cpumap entry and then to the networking stack.
UDP frames are generated using pkt_gen. Packets are discarded by the
UDP layer.

$xdp_redirect_cpu  --cpu <cpu> --progname xdp_cpu_map0 --dev <eth>

bpf-next: ~2.35Mpps
bpf-next + cpumap skb-list: ~2.72Mpps

Since netif_receive_skb_list does not return number of discarded packets,
remove drop counter from xdp_cpumap_kthread tracepoint and update related
xdp samples.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v2:
- remove drop counter and update related xdp samples
- rebased on top of bpf-next

Changes since v1:
- fixed comment
- rebased on top of bpf-next tree
---
 include/trace/events/xdp.h          | 14 +++++---------
 kernel/bpf/cpumap.c                 | 16 +++++++---------
 samples/bpf/xdp_monitor_kern.c      |  6 ++----
 samples/bpf/xdp_monitor_user.c      | 14 ++++++--------
 samples/bpf/xdp_redirect_cpu_kern.c | 12 +++++-------
 samples/bpf/xdp_redirect_cpu_user.c | 10 ++++------
 6 files changed, 29 insertions(+), 43 deletions(-)

diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index fcad3645a70b..52ecfe9c7e25 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -184,16 +184,15 @@ DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map_err,
 
 TRACE_EVENT(xdp_cpumap_kthread,
 
-	TP_PROTO(int map_id, unsigned int processed,  unsigned int drops,
-		 int sched, struct xdp_cpumap_stats *xdp_stats),
+	TP_PROTO(int map_id, unsigned int processed, int sched,
+		 struct xdp_cpumap_stats *xdp_stats),
 
-	TP_ARGS(map_id, processed, drops, sched, xdp_stats),
+	TP_ARGS(map_id, processed, sched, xdp_stats),
 
 	TP_STRUCT__entry(
 		__field(int, map_id)
 		__field(u32, act)
 		__field(int, cpu)
-		__field(unsigned int, drops)
 		__field(unsigned int, processed)
 		__field(int, sched)
 		__field(unsigned int, xdp_pass)
@@ -205,7 +204,6 @@ TRACE_EVENT(xdp_cpumap_kthread,
 		__entry->map_id		= map_id;
 		__entry->act		= XDP_REDIRECT;
 		__entry->cpu		= smp_processor_id();
-		__entry->drops		= drops;
 		__entry->processed	= processed;
 		__entry->sched	= sched;
 		__entry->xdp_pass	= xdp_stats->pass;
@@ -215,13 +213,11 @@ TRACE_EVENT(xdp_cpumap_kthread,
 
 	TP_printk("kthread"
 		  " cpu=%d map_id=%d action=%s"
-		  " processed=%u drops=%u"
-		  " sched=%d"
+		  " processed=%u sched=%u"
 		  " xdp_pass=%u xdp_drop=%u xdp_redirect=%u",
 		  __entry->cpu, __entry->map_id,
 		  __print_symbolic(__entry->act, __XDP_ACT_SYM_TAB),
-		  __entry->processed, __entry->drops,
-		  __entry->sched,
+		  __entry->processed, __entry->sched,
 		  __entry->xdp_pass, __entry->xdp_drop, __entry->xdp_redirect)
 );
 
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 0cf2791d5099..1c22caadf78f 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -27,7 +27,7 @@
 #include <linux/capability.h>
 #include <trace/events/xdp.h>
 
-#include <linux/netdevice.h>   /* netif_receive_skb_core */
+#include <linux/netdevice.h>   /* netif_receive_skb_list */
 #include <linux/etherdevice.h> /* eth_type_trans */
 
 /* General idea: XDP packets getting XDP redirected to another CPU,
@@ -253,10 +253,11 @@ static int cpu_map_kthread_run(void *data)
 	while (!kthread_should_stop() || !__ptr_ring_empty(rcpu->queue)) {
 		struct xdp_cpumap_stats stats = {}; /* zero stats */
 		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
-		unsigned int drops = 0, sched = 0;
 		void *frames[CPUMAP_BATCH];
 		void *skbs[CPUMAP_BATCH];
+		unsigned int sched = 0;
 		int i, n, m, nframes;
+		LIST_HEAD(list);
 
 		/* Release CPU reschedule checks */
 		if (__ptr_ring_empty(rcpu->queue)) {
@@ -297,7 +298,6 @@ static int cpu_map_kthread_run(void *data)
 			if (unlikely(m == 0)) {
 				for (i = 0; i < nframes; i++)
 					skbs[i] = NULL; /* effect: xdp_return_frame */
-				drops += nframes;
 			}
 		}
 
@@ -305,7 +305,6 @@ static int cpu_map_kthread_run(void *data)
 		for (i = 0; i < nframes; i++) {
 			struct xdp_frame *xdpf = frames[i];
 			struct sk_buff *skb = skbs[i];
-			int ret;
 
 			skb = __xdp_build_skb_from_frame(xdpf, skb,
 							 xdpf->dev_rx);
@@ -314,13 +313,12 @@ static int cpu_map_kthread_run(void *data)
 				continue;
 			}
 
-			/* Inject into network stack */
-			ret = netif_receive_skb_core(skb);
-			if (ret == NET_RX_DROP)
-				drops++;
+			list_add_tail(&skb->list, &list);
 		}
+		netif_receive_skb_list(&list);
+
 		/* Feedback loop via tracepoint */
-		trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched, &stats);
+		trace_xdp_cpumap_kthread(rcpu->map_id, n, sched, &stats);
 
 		local_bh_enable(); /* resched point, may call do_softirq() */
 	}
diff --git a/samples/bpf/xdp_monitor_kern.c b/samples/bpf/xdp_monitor_kern.c
index 5c955b812c47..f7aeecfa046b 100644
--- a/samples/bpf/xdp_monitor_kern.c
+++ b/samples/bpf/xdp_monitor_kern.c
@@ -186,9 +186,8 @@ struct cpumap_kthread_ctx {
 	int map_id;		//	offset:8;  size:4; signed:1;
 	u32 act;		//	offset:12; size:4; signed:0;
 	int cpu;		//	offset:16; size:4; signed:1;
-	unsigned int drops;	//	offset:20; size:4; signed:0;
-	unsigned int processed;	//	offset:24; size:4; signed:0;
-	int sched;		//	offset:28; size:4; signed:1;
+	unsigned int processed;	//	offset:20; size:4; signed:0;
+	int sched;		//	offset:24; size:4; signed:1;
 };
 
 SEC("tracepoint/xdp/xdp_cpumap_kthread")
@@ -201,7 +200,6 @@ int trace_xdp_cpumap_kthread(struct cpumap_kthread_ctx *ctx)
 	if (!rec)
 		return 0;
 	rec->processed += ctx->processed;
-	rec->dropped   += ctx->drops;
 
 	/* Count times kthread yielded CPU via schedule call */
 	if (ctx->sched)
diff --git a/samples/bpf/xdp_monitor_user.c b/samples/bpf/xdp_monitor_user.c
index 49ebc49aefc3..f31796809cce 100644
--- a/samples/bpf/xdp_monitor_user.c
+++ b/samples/bpf/xdp_monitor_user.c
@@ -432,11 +432,11 @@ static void stats_print(struct stats_record *stats_rec,
 
 	/* cpumap kthread stats */
 	{
-		char *fmt1 = "%-15s %-7d %'-12.0f %'-12.0f %'-10.0f %s\n";
-		char *fmt2 = "%-15s %-7s %'-12.0f %'-12.0f %'-10.0f %s\n";
+		char *fmt1 = "%-15s %-7d %'-12.0f %-12s %'-10.0f %s\n";
+		char *fmt2 = "%-15s %-7s %'-12.0f %-12s %'-10.0f %s\n";
 		struct record *rec, *prev;
-		double drop, info;
 		char *i_str = "";
+		double info;
 
 		rec  =  &stats_rec->xdp_cpumap_kthread;
 		prev = &stats_prev->xdp_cpumap_kthread;
@@ -446,20 +446,18 @@ static void stats_print(struct stats_record *stats_rec,
 			struct datarec *p = &prev->cpu[i];
 
 			pps  = calc_pps(r, p, t);
-			drop = calc_drop(r, p, t);
 			info = calc_info(r, p, t);
 			if (info > 0)
 				i_str = "sched";
-			if (pps > 0 || drop > 0)
+			if (pps > 0)
 				printf(fmt1, "cpumap-kthread",
-				       i, pps, drop, info, i_str);
+				       i, pps, "-", info, i_str);
 		}
 		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop(&rec->total, &prev->total, t);
 		info = calc_info(&rec->total, &prev->total, t);
 		if (info > 0)
 			i_str = "sched-sum";
-		printf(fmt2, "cpumap-kthread", "total", pps, drop, info, i_str);
+		printf(fmt2, "cpumap-kthread", "total", pps, "-", info, i_str);
 	}
 
 	/* devmap ndo_xdp_xmit stats */
diff --git a/samples/bpf/xdp_redirect_cpu_kern.c b/samples/bpf/xdp_redirect_cpu_kern.c
index 8255025dea97..34332b0b7020 100644
--- a/samples/bpf/xdp_redirect_cpu_kern.c
+++ b/samples/bpf/xdp_redirect_cpu_kern.c
@@ -699,12 +699,11 @@ struct cpumap_kthread_ctx {
 	int map_id;			//	offset:8;  size:4; signed:1;
 	u32 act;			//	offset:12; size:4; signed:0;
 	int cpu;			//	offset:16; size:4; signed:1;
-	unsigned int drops;		//	offset:20; size:4; signed:0;
-	unsigned int processed;		//	offset:24; size:4; signed:0;
-	int sched;			//	offset:28; size:4; signed:1;
-	unsigned int xdp_pass;		//	offset:32; size:4; signed:0;
-	unsigned int xdp_drop;		//	offset:36; size:4; signed:0;
-	unsigned int xdp_redirect;	//	offset:40; size:4; signed:0;
+	unsigned int processed;		//	offset:20; size:4; signed:0;
+	int sched;			//	offset:24; size:4; signed:1;
+	unsigned int xdp_pass;		//	offset:28; size:4; signed:0;
+	unsigned int xdp_drop;		//	offset:32; size:4; signed:0;
+	unsigned int xdp_redirect;	//	offset:36; size:4; signed:0;
 };
 
 SEC("tracepoint/xdp/xdp_cpumap_kthread")
@@ -717,7 +716,6 @@ int trace_xdp_cpumap_kthread(struct cpumap_kthread_ctx *ctx)
 	if (!rec)
 		return 0;
 	rec->processed += ctx->processed;
-	rec->dropped   += ctx->drops;
 	rec->xdp_pass  += ctx->xdp_pass;
 	rec->xdp_drop  += ctx->xdp_drop;
 	rec->xdp_redirect  += ctx->xdp_redirect;
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 576411612523..76346647fd5b 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -436,8 +436,8 @@ static void stats_print(struct stats_record *stats_rec,
 
 	/* cpumap kthread stats */
 	{
-		char *fmt_k = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f %s\n";
-		char *fm2_k = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f %s\n";
+		char *fmt_k = "%-15s %-7d %'-14.0f %-11s %'-10.0f %s\n";
+		char *fm2_k = "%-15s %-7s %'-14.0f %-11s %'-10.0f %s\n";
 		char *e_str = "";
 
 		rec  = &stats_rec->kthread;
@@ -448,20 +448,18 @@ static void stats_print(struct stats_record *stats_rec,
 			struct datarec *p = &prev->cpu[i];
 
 			pps  = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
 			err  = calc_errs_pps(r, p, t);
 			if (err > 0)
 				e_str = "sched";
 			if (pps > 0)
 				printf(fmt_k, "cpumap_kthread",
-				       i, pps, drop, err, e_str);
+				       i, pps, "-", err, e_str);
 		}
 		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop_pps(&rec->total, &prev->total, t);
 		err  = calc_errs_pps(&rec->total, &prev->total, t);
 		if (err > 0)
 			e_str = "sched-sum";
-		printf(fm2_k, "cpumap_kthread", "total", pps, drop, err, e_str);
+		printf(fm2_k, "cpumap_kthread", "total", pps, "-", err, e_str);
 	}
 
 	/* XDP redirect err tracepoints (very unlikely) */
-- 
2.30.2

