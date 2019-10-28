Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D21BE6EC1
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 10:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387825AbfJ1JMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 05:12:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53316 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387596AbfJ1JMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 05:12:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GAgGAUJziIAZoCqHkKoD8AXS8jroyopvdOonwHmBT8Y=; b=Sby/GrYJpm26R/oCT4tElJP61
        P587ZlFbL4xuE8zYgZZAaEau4CM6TUWaan+j6TY5oif7drpbuzIQgBt7ZBU3fQ7lh0nEhCDqDji8S
        QZ80cMPJDjWcy73bObVjCfrqh2Qn4tkF5eRp74Cgvloj+2Rn6bVaV8LdB1fXiw6dY//5knI1H9aY5
        SVymgo39zXiXuRyKEgqy45Tu0Yy/llWcrIjAzhOoOhrziWnFnimqSzzcUHtrdruZfF7WURLmMkU/p
        8GuaT10CpEQF8C44C/za/NN6AovHxJeSR/m7ZW/xUjrtjDt/uXLV9mfF6MeObUsVO0vf0yLo04C8L
        BlFTJVRIg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iP14h-0002DE-S4; Mon, 28 Oct 2019 09:12:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8EFFC30025A;
        Mon, 28 Oct 2019 10:11:29 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9343D20AD6A3E; Mon, 28 Oct 2019 10:12:29 +0100 (CET)
Date:   Mon, 28 Oct 2019 10:12:29 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Daniel Xu <dxu@dxuuu.xyz>, bpf@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        mingo@redhat.com, acme@kernel.org, ast@fb.com,
        alexander.shishkin@linux.intel.com, namhyung@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/5] perf/core: Add PERF_FORMAT_LOST read_format
Message-ID: <20191028091229.GJ4131@hirez.programming.kicks-ass.net>
References: <20190917133056.5545-1-dxu@dxuuu.xyz>
 <20190917133056.5545-2-dxu@dxuuu.xyz>
 <20190924083342.GA21640@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924083342.GA21640@krava>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 10:33:42AM +0200, Jiri Olsa wrote:
> On Tue, Sep 17, 2019 at 06:30:52AM -0700, Daniel Xu wrote:
> 
> SNIP
> 
> > +	PERF_FORMAT_MAX = 1U << 5,		/* non-ABI */
> >  };
> >  
> >  #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 0463c1151bae..ee08d3ed6299 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -1715,6 +1715,9 @@ static void __perf_event_read_size(struct perf_event *event, int nr_siblings)
> >  	if (event->attr.read_format & PERF_FORMAT_ID)
> >  		entry += sizeof(u64);
> >  
> > +	if (event->attr.read_format & PERF_FORMAT_LOST)
> > +		entry += sizeof(u64);
> > +
> >  	if (event->attr.read_format & PERF_FORMAT_GROUP) {
> >  		nr += nr_siblings;
> >  		size += sizeof(u64);
> > @@ -4734,6 +4737,24 @@ u64 perf_event_read_value(struct perf_event *event, u64 *enabled, u64 *running)
> >  }
> >  EXPORT_SYMBOL_GPL(perf_event_read_value);
> >  
> > +static struct pmu perf_kprobe;
> > +static u64 perf_event_lost(struct perf_event *event)
> > +{
> > +	struct ring_buffer *rb;
> > +	u64 lost = 0;
> > +
> > +	rcu_read_lock();
> > +	rb = rcu_dereference(event->rb);
> > +	if (likely(!!rb))
> > +		lost += local_read(&rb->lost);
> > +	rcu_read_unlock();
> > +
> > +	if (event->attr.type == perf_kprobe.type)
> > +		lost += perf_kprobe_missed(event);
> 
> not sure what was the peterz's suggestion, but here you are mixing
> ring buffer's lost count with kprobes missed count, seems wrong

Jiri is right, this isn't quite what I meant.

The below is what I was thinking of (I also renamed everything to
missing, to avoid confusion).

But now that I wrote it, I'm a little scared of what I had to do for
__perf_sw_event(). Let me ponder that a little bit more.

---
 include/linux/perf_event.h      |  1 +
 include/linux/trace_events.h    |  1 +
 include/uapi/linux/perf_event.h |  5 ++++-
 kernel/events/core.c            | 42 +++++++++++++++++++++++++++++++++--------
 kernel/trace/trace_event_perf.c |  4 +++-
 kernel/trace/trace_kprobe.c     |  8 ++++++++
 6 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index a9ef8be8c83a..ec6c867203c3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -625,6 +625,7 @@ struct perf_event {
 	unsigned int			attach_state;
 	local64_t			count;
 	atomic64_t			child_count;
+	local64_t			missed;
 
 	/*
 	 * These are the total time in nanoseconds that the event
diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index a379255c14a9..18d315a0f0f9 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -603,6 +603,7 @@ extern int bpf_get_kprobe_info(const struct perf_event *event,
 			       u32 *fd_type, const char **symbol,
 			       u64 *probe_offset, u64 *probe_addr,
 			       bool perf_type_tracepoint);
+extern u64 perf_kprobe_missed(const struct perf_event *event);
 #endif
 #ifdef CONFIG_UPROBE_EVENTS
 extern int  perf_uprobe_init(struct perf_event *event,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index bb7b271397a6..2dd3c3f21087 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -273,6 +273,7 @@ enum {
  *	  { u64		time_enabled; } && PERF_FORMAT_TOTAL_TIME_ENABLED
  *	  { u64		time_running; } && PERF_FORMAT_TOTAL_TIME_RUNNING
  *	  { u64		id;           } && PERF_FORMAT_ID
+ *	  { u64		missed;       } && PERF_FORMAT_MISSED
  *	} && !PERF_FORMAT_GROUP
  *
  *	{ u64		nr;
@@ -280,6 +281,7 @@ enum {
  *	  { u64		time_running; } && PERF_FORMAT_TOTAL_TIME_RUNNING
  *	  { u64		value;
  *	    { u64	id;           } && PERF_FORMAT_ID
+ *	    { u64	missed;       } && PERF_FORMAT_MISSED
  *	  }		cntr[nr];
  *	} && PERF_FORMAT_GROUP
  * };
@@ -289,8 +291,9 @@ enum perf_event_read_format {
 	PERF_FORMAT_TOTAL_TIME_RUNNING		= 1U << 1,
 	PERF_FORMAT_ID				= 1U << 2,
 	PERF_FORMAT_GROUP			= 1U << 3,
+	PERF_FORMAT_MISSED			= 1U << 4,
 
-	PERF_FORMAT_MAX = 1U << 4,		/* non-ABI */
+	PERF_FORMAT_MAX = 1U << 5,		/* non-ABI */
 };
 
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d8b9034857d7..7e72f919d2e7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1817,6 +1817,9 @@ static void __perf_event_read_size(struct perf_event *event, int nr_siblings)
 	if (event->attr.read_format & PERF_FORMAT_ID)
 		entry += sizeof(u64);
 
+	if (event->attr.read_format & PERF_FORMAT_MISSED)
+		entry += sizeof(u64);
+
 	if (event->attr.read_format & PERF_FORMAT_GROUP) {
 		nr += nr_siblings;
 		size += sizeof(u64);
@@ -4994,6 +4997,15 @@ u64 perf_event_read_value(struct perf_event *event, u64 *enabled, u64 *running)
 }
 EXPORT_SYMBOL_GPL(perf_event_read_value);
 
+static struct pmu perf_kprobe;
+static u64 perf_event_missed(struct perf_event *event)
+{
+	if (event->attr.type == perf_kprobe.type)
+		return perf_kprobe_missed(event);
+
+	return local64_read(&event->missed);
+}
+
 static int __perf_read_group_add(struct perf_event *leader,
 					u64 read_format, u64 *values)
 {
@@ -5030,11 +5042,15 @@ static int __perf_read_group_add(struct perf_event *leader,
 	values[n++] += perf_event_count(leader);
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(leader);
+	if (read_format & PERF_FORMAT_MISSED)
+		values[n++] = perf_event_missed(leader);
 
 	for_each_sibling_event(sub, leader) {
 		values[n++] += perf_event_count(sub);
 		if (read_format & PERF_FORMAT_ID)
 			values[n++] = primary_event_id(sub);
+		if (read_format & PERF_FORMAT_MISSED)
+			values[n++] = perf_event_missed(sub);
 	}
 
 	raw_spin_unlock_irqrestore(&ctx->lock, flags);
@@ -5091,7 +5107,7 @@ static int perf_read_one(struct perf_event *event,
 				 u64 read_format, char __user *buf)
 {
 	u64 enabled, running;
-	u64 values[4];
+	u64 values[5];
 	int n = 0;
 
 	values[n++] = __perf_event_read_value(event, &enabled, &running);
@@ -5101,6 +5117,8 @@ static int perf_read_one(struct perf_event *event,
 		values[n++] = running;
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(event);
+	if (read_format & PERF_FORMAT_MISSED)
+		values[n++] = perf_event_lost(event);
 
 	if (copy_to_user(buf, values, n * sizeof(u64)))
 		return -EFAULT;
@@ -6427,7 +6445,7 @@ static void perf_output_read_one(struct perf_output_handle *handle,
 				 u64 enabled, u64 running)
 {
 	u64 read_format = event->attr.read_format;
-	u64 values[4];
+	u64 values[5];
 	int n = 0;
 
 	values[n++] = perf_event_count(event);
@@ -6441,6 +6459,8 @@ static void perf_output_read_one(struct perf_output_handle *handle,
 	}
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(event);
+	if (read_format & PERF_FORMAT_MISSED)
+		values[n++] = perf_event_lost(event);
 
 	__output_copy(handle, values, n * sizeof(u64));
 }
@@ -6451,7 +6471,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 {
 	struct perf_event *leader = event->group_leader, *sub;
 	u64 read_format = event->attr.read_format;
-	u64 values[5];
+	u64 values[6];
 	int n = 0;
 
 	values[n++] = 1 + leader->nr_siblings;
@@ -6469,6 +6489,8 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 	values[n++] = perf_event_count(leader);
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(leader);
+	if (read_format & PERF_FORMAT_MISSED)
+		values[n++] = perf_event_lost(leader);
 
 	__output_copy(handle, values, n * sizeof(u64));
 
@@ -6482,6 +6504,8 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 		values[n++] = perf_event_count(sub);
 		if (read_format & PERF_FORMAT_ID)
 			values[n++] = primary_event_id(sub);
+		if (read_format & PERF_FORMAT_MISSED)
+			values[n++] = perf_event_lost(sub);
 
 		__output_copy(handle, values, n * sizeof(u64));
 	}
@@ -8500,7 +8524,6 @@ static int perf_exclude_event(struct perf_event *event,
 static int perf_swevent_match(struct perf_event *event,
 				enum perf_type_id type,
 				u32 event_id,
-				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
 	if (event->attr.type != type)
@@ -8579,8 +8602,12 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
 		goto end;
 
 	hlist_for_each_entry_rcu(event, head, hlist_entry) {
-		if (perf_swevent_match(event, type, event_id, data, regs))
-			perf_swevent_event(event, nr, data, regs);
+		if (perf_swevent_match(event, type, event_id, regs)) {
+			if (nr == ~0ULL)
+				local64_inc(&event->missed);
+			else
+				perf_swevent_event(event, nr, data, regs);
+		}
 	}
 end:
 	rcu_read_unlock();
@@ -8621,12 +8648,11 @@ void __perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 	preempt_disable_notrace();
 	rctx = perf_swevent_get_recursion_context();
 	if (unlikely(rctx < 0))
-		goto fail;
+		nr = ~0ULL;
 
 	___perf_sw_event(event_id, nr, regs, addr);
 
 	perf_swevent_put_recursion_context(rctx);
-fail:
 	preempt_enable_notrace();
 }
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 0917fee6ee7c..73a0de204d7a 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -458,8 +458,10 @@ perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
 	perf_fetch_caller_regs(&regs);
 
 	entry = perf_trace_buf_alloc(ENTRY_SIZE, NULL, &rctx);
-	if (!entry)
+	if (!entry) {
+		local64_inc(&event->missed);
 		return;
+	}
 
 	entry->ip = ip;
 	entry->parent_ip = parent_ip;
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 66e0a8ff1c01..5e1889c161e3 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -233,6 +233,14 @@ bool trace_kprobe_error_injectable(struct trace_event_call *call)
 	       false;
 }
 
+u64 perf_kprobe_missed(const struct perf_event *event)
+{
+	struct trace_event_call *call = event->tp_event;
+	struct trace_kprobe *tk = (struct trace_kprobe *)call->data;
+
+	return tk->rp.kp.nmissed;
+}
+
 static int register_kprobe_event(struct trace_kprobe *tk);
 static int unregister_kprobe_event(struct trace_kprobe *tk);
 
