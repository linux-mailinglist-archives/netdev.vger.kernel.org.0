Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892C3136537
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 03:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730827AbgAJCFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 21:05:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:32784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730604AbgAJCFP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 21:05:15 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 411AD2072E;
        Fri, 10 Jan 2020 02:05:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.3)
        (envelope-from <rostedt@goodmis.org>)
        id 1ipjfi-000Yvr-8u; Thu, 09 Jan 2020 21:05:10 -0500
Message-Id: <20200110020510.145282632@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 09 Jan 2020 21:03:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH 2/3] tracing: Rename trace_buffer to array_buffer
References: <20200110020308.977313200@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As we are working to remove the generic "ring_buffer" name that is used by
both tracing and perf, the ring_buffer name for tracing will be renamed to
trace_buffer, and perf's ring buffer will be renamed to perf_buffer.

As there already exists a trace_buffer that is used by the trace_arrays, it
needs to be first renamed to array_buffer.

Link: https://lore.kernel.org/r/20191213153553.GE20583@krava

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/linux/trace_events.h         |   4 +-
 kernel/trace/blktrace.c              |   4 +-
 kernel/trace/ftrace.c                |   8 +-
 kernel/trace/trace.c                 | 230 +++++++++++++--------------
 kernel/trace/trace.h                 |  16 +-
 kernel/trace/trace_branch.c          |   4 +-
 kernel/trace/trace_events.c          |  18 +--
 kernel/trace/trace_events_hist.c     |   2 +-
 kernel/trace/trace_functions.c       |   8 +-
 kernel/trace/trace_functions_graph.c |  14 +-
 kernel/trace/trace_hwlat.c           |   2 +-
 kernel/trace/trace_irqsoff.c         |   8 +-
 kernel/trace/trace_kdb.c             |   8 +-
 kernel/trace/trace_mmiotrace.c       |  12 +-
 kernel/trace/trace_output.c          |   2 +-
 kernel/trace/trace_sched_wakeup.c    |  20 +--
 kernel/trace/trace_selftest.c        |  26 +--
 kernel/trace/trace_syscalls.c        |   4 +-
 18 files changed, 195 insertions(+), 195 deletions(-)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 4c6e15605766..f70e5bc7e8db 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -11,7 +11,7 @@
 #include <linux/tracepoint.h>
 
 struct trace_array;
-struct trace_buffer;
+struct array_buffer;
 struct tracer;
 struct dentry;
 struct bpf_prog;
@@ -79,7 +79,7 @@ struct trace_entry {
 struct trace_iterator {
 	struct trace_array	*tr;
 	struct tracer		*trace;
-	struct trace_buffer	*trace_buffer;
+	struct array_buffer	*array_buffer;
 	void			*private;
 	int			cpu_file;
 	struct mutex		mutex;
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 475e29498bca..3b926f62ed83 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -75,7 +75,7 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 	ssize_t cgid_len = cgid ? sizeof(cgid) : 0;
 
 	if (blk_tracer) {
-		buffer = blk_tr->trace_buffer.buffer;
+		buffer = blk_tr->array_buffer.buffer;
 		pc = preempt_count();
 		event = trace_buffer_lock_reserve(buffer, TRACE_BLK,
 						  sizeof(*t) + len + cgid_len,
@@ -248,7 +248,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	if (blk_tracer) {
 		tracing_record_cmdline(current);
 
-		buffer = blk_tr->trace_buffer.buffer;
+		buffer = blk_tr->array_buffer.buffer;
 		pc = preempt_count();
 		event = trace_buffer_lock_reserve(buffer, TRACE_BLK,
 						  sizeof(*t) + pdu_len + cgid_len,
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9bf1f2cd515e..3f0ae07e72ef 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -146,7 +146,7 @@ static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip,
 {
 	struct trace_array *tr = op->private;
 
-	if (tr && this_cpu_read(tr->trace_buffer.data->ftrace_ignore_pid))
+	if (tr && this_cpu_read(tr->array_buffer.data->ftrace_ignore_pid))
 		return;
 
 	op->saved_func(ip, parent_ip, op, regs);
@@ -6922,7 +6922,7 @@ ftrace_filter_pid_sched_switch_probe(void *data, bool preempt,
 
 	pid_list = rcu_dereference_sched(tr->function_pids);
 
-	this_cpu_write(tr->trace_buffer.data->ftrace_ignore_pid,
+	this_cpu_write(tr->array_buffer.data->ftrace_ignore_pid,
 		       trace_ignore_this_task(pid_list, next));
 }
 
@@ -6976,7 +6976,7 @@ static void clear_ftrace_pids(struct trace_array *tr)
 	unregister_trace_sched_switch(ftrace_filter_pid_sched_switch_probe, tr);
 
 	for_each_possible_cpu(cpu)
-		per_cpu_ptr(tr->trace_buffer.data, cpu)->ftrace_ignore_pid = false;
+		per_cpu_ptr(tr->array_buffer.data, cpu)->ftrace_ignore_pid = false;
 
 	rcu_assign_pointer(tr->function_pids, NULL);
 
@@ -7100,7 +7100,7 @@ static void ignore_task_cpu(void *data)
 	pid_list = rcu_dereference_protected(tr->function_pids,
 					     mutex_is_locked(&ftrace_lock));
 
-	this_cpu_write(tr->trace_buffer.data->ftrace_ignore_pid,
+	this_cpu_write(tr->array_buffer.data->ftrace_ignore_pid,
 		       trace_ignore_this_task(pid_list, current));
 }
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ddb7e7f5fe8d..67084b7945ff 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -603,7 +603,7 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
 	return read;
 }
 
-static u64 buffer_ftrace_now(struct trace_buffer *buf, int cpu)
+static u64 buffer_ftrace_now(struct array_buffer *buf, int cpu)
 {
 	u64 ts;
 
@@ -619,7 +619,7 @@ static u64 buffer_ftrace_now(struct trace_buffer *buf, int cpu)
 
 u64 ftrace_now(int cpu)
 {
-	return buffer_ftrace_now(&global_trace.trace_buffer, cpu);
+	return buffer_ftrace_now(&global_trace.array_buffer, cpu);
 }
 
 /**
@@ -796,8 +796,8 @@ __trace_buffer_lock_reserve(struct ring_buffer *buffer,
 
 void tracer_tracing_on(struct trace_array *tr)
 {
-	if (tr->trace_buffer.buffer)
-		ring_buffer_record_on(tr->trace_buffer.buffer);
+	if (tr->array_buffer.buffer)
+		ring_buffer_record_on(tr->array_buffer.buffer);
 	/*
 	 * This flag is looked at when buffers haven't been allocated
 	 * yet, or by some tracers (like irqsoff), that just want to
@@ -865,7 +865,7 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	alloc = sizeof(*entry) + size + 2; /* possible \n added */
 
 	local_save_flags(irq_flags);
-	buffer = global_trace.trace_buffer.buffer;
+	buffer = global_trace.array_buffer.buffer;
 	event = __trace_buffer_lock_reserve(buffer, TRACE_PRINT, alloc, 
 					    irq_flags, pc);
 	if (!event)
@@ -913,7 +913,7 @@ int __trace_bputs(unsigned long ip, const char *str)
 		return 0;
 
 	local_save_flags(irq_flags);
-	buffer = global_trace.trace_buffer.buffer;
+	buffer = global_trace.array_buffer.buffer;
 	event = __trace_buffer_lock_reserve(buffer, TRACE_BPUTS, size,
 					    irq_flags, pc);
 	if (!event)
@@ -1036,9 +1036,9 @@ void *tracing_cond_snapshot_data(struct trace_array *tr)
 }
 EXPORT_SYMBOL_GPL(tracing_cond_snapshot_data);
 
-static int resize_buffer_duplicate_size(struct trace_buffer *trace_buf,
-					struct trace_buffer *size_buf, int cpu_id);
-static void set_buffer_entries(struct trace_buffer *buf, unsigned long val);
+static int resize_buffer_duplicate_size(struct array_buffer *trace_buf,
+					struct array_buffer *size_buf, int cpu_id);
+static void set_buffer_entries(struct array_buffer *buf, unsigned long val);
 
 int tracing_alloc_snapshot_instance(struct trace_array *tr)
 {
@@ -1048,7 +1048,7 @@ int tracing_alloc_snapshot_instance(struct trace_array *tr)
 
 		/* allocate spare buffer */
 		ret = resize_buffer_duplicate_size(&tr->max_buffer,
-				   &tr->trace_buffer, RING_BUFFER_ALL_CPUS);
+				   &tr->array_buffer, RING_BUFFER_ALL_CPUS);
 		if (ret < 0)
 			return ret;
 
@@ -1251,8 +1251,8 @@ EXPORT_SYMBOL_GPL(tracing_snapshot_cond_disable);
 
 void tracer_tracing_off(struct trace_array *tr)
 {
-	if (tr->trace_buffer.buffer)
-		ring_buffer_record_off(tr->trace_buffer.buffer);
+	if (tr->array_buffer.buffer)
+		ring_buffer_record_off(tr->array_buffer.buffer);
 	/*
 	 * This flag is looked at when buffers haven't been allocated
 	 * yet, or by some tracers (like irqsoff), that just want to
@@ -1294,8 +1294,8 @@ void disable_trace_on_warning(void)
  */
 bool tracer_tracing_is_on(struct trace_array *tr)
 {
-	if (tr->trace_buffer.buffer)
-		return ring_buffer_record_is_on(tr->trace_buffer.buffer);
+	if (tr->array_buffer.buffer)
+		return ring_buffer_record_is_on(tr->array_buffer.buffer);
 	return !tr->buffer_disabled;
 }
 
@@ -1590,8 +1590,8 @@ void latency_fsnotify(struct trace_array *tr)
 static void
 __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct trace_buffer *trace_buf = &tr->trace_buffer;
-	struct trace_buffer *max_buf = &tr->max_buffer;
+	struct array_buffer *trace_buf = &tr->array_buffer;
+	struct array_buffer *max_buf = &tr->max_buffer;
 	struct trace_array_cpu *data = per_cpu_ptr(trace_buf->data, cpu);
 	struct trace_array_cpu *max_data = per_cpu_ptr(max_buf->data, cpu);
 
@@ -1649,8 +1649,8 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu,
 
 	arch_spin_lock(&tr->max_lock);
 
-	/* Inherit the recordable setting from trace_buffer */
-	if (ring_buffer_record_is_set_on(tr->trace_buffer.buffer))
+	/* Inherit the recordable setting from array_buffer */
+	if (ring_buffer_record_is_set_on(tr->array_buffer.buffer))
 		ring_buffer_record_on(tr->max_buffer.buffer);
 	else
 		ring_buffer_record_off(tr->max_buffer.buffer);
@@ -1659,7 +1659,7 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu,
 	if (tr->cond_snapshot && !tr->cond_snapshot->update(tr, cond_data))
 		goto out_unlock;
 #endif
-	swap(tr->trace_buffer.buffer, tr->max_buffer.buffer);
+	swap(tr->array_buffer.buffer, tr->max_buffer.buffer);
 
 	__update_max_tr(tr, tsk, cpu);
 
@@ -1692,7 +1692,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 
 	arch_spin_lock(&tr->max_lock);
 
-	ret = ring_buffer_swap_cpu(tr->max_buffer.buffer, tr->trace_buffer.buffer, cpu);
+	ret = ring_buffer_swap_cpu(tr->max_buffer.buffer, tr->array_buffer.buffer, cpu);
 
 	if (ret == -EBUSY) {
 		/*
@@ -1718,7 +1718,7 @@ static int wait_on_pipe(struct trace_iterator *iter, int full)
 	if (trace_buffer_iter(iter, iter->cpu_file))
 		return 0;
 
-	return ring_buffer_wait(iter->trace_buffer->buffer, iter->cpu_file,
+	return ring_buffer_wait(iter->array_buffer->buffer, iter->cpu_file,
 				full);
 }
 
@@ -1769,7 +1769,7 @@ static int run_tracer_selftest(struct tracer *type)
 	 * internal tracing to verify that everything is in order.
 	 * If we fail, we do not register this tracer.
 	 */
-	tracing_reset_online_cpus(&tr->trace_buffer);
+	tracing_reset_online_cpus(&tr->array_buffer);
 
 	tr->current_trace = type;
 
@@ -1795,7 +1795,7 @@ static int run_tracer_selftest(struct tracer *type)
 		return -1;
 	}
 	/* Only reset on passing, to avoid touching corrupted buffers */
-	tracing_reset_online_cpus(&tr->trace_buffer);
+	tracing_reset_online_cpus(&tr->array_buffer);
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 	if (type->use_max_tr) {
@@ -1962,7 +1962,7 @@ int __init register_tracer(struct tracer *type)
 	return ret;
 }
 
-static void tracing_reset_cpu(struct trace_buffer *buf, int cpu)
+static void tracing_reset_cpu(struct array_buffer *buf, int cpu)
 {
 	struct ring_buffer *buffer = buf->buffer;
 
@@ -1978,7 +1978,7 @@ static void tracing_reset_cpu(struct trace_buffer *buf, int cpu)
 	ring_buffer_record_enable(buffer);
 }
 
-void tracing_reset_online_cpus(struct trace_buffer *buf)
+void tracing_reset_online_cpus(struct array_buffer *buf)
 {
 	struct ring_buffer *buffer = buf->buffer;
 	int cpu;
@@ -2008,7 +2008,7 @@ void tracing_reset_all_online_cpus(void)
 		if (!tr->clear_trace)
 			continue;
 		tr->clear_trace = false;
-		tracing_reset_online_cpus(&tr->trace_buffer);
+		tracing_reset_online_cpus(&tr->array_buffer);
 #ifdef CONFIG_TRACER_MAX_TRACE
 		tracing_reset_online_cpus(&tr->max_buffer);
 #endif
@@ -2117,7 +2117,7 @@ void tracing_start(void)
 	/* Prevent the buffers from switching */
 	arch_spin_lock(&global_trace.max_lock);
 
-	buffer = global_trace.trace_buffer.buffer;
+	buffer = global_trace.array_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_enable(buffer);
 
@@ -2156,7 +2156,7 @@ static void tracing_start_tr(struct trace_array *tr)
 		goto out;
 	}
 
-	buffer = tr->trace_buffer.buffer;
+	buffer = tr->array_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_enable(buffer);
 
@@ -2182,7 +2182,7 @@ void tracing_stop(void)
 	/* Prevent the buffers from switching */
 	arch_spin_lock(&global_trace.max_lock);
 
-	buffer = global_trace.trace_buffer.buffer;
+	buffer = global_trace.array_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_disable(buffer);
 
@@ -2211,7 +2211,7 @@ static void tracing_stop_tr(struct trace_array *tr)
 	if (tr->stop_count++)
 		goto out;
 
-	buffer = tr->trace_buffer.buffer;
+	buffer = tr->array_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_disable(buffer);
 
@@ -2572,7 +2572,7 @@ trace_event_buffer_lock_reserve(struct ring_buffer **current_rb,
 	struct ring_buffer_event *entry;
 	int val;
 
-	*current_rb = trace_file->tr->trace_buffer.buffer;
+	*current_rb = trace_file->tr->array_buffer.buffer;
 
 	if (!ring_buffer_time_stamp_abs(*current_rb) && (trace_file->flags &
 	     (EVENT_FILE_FL_SOFT_DISABLED | EVENT_FILE_FL_FILTERED)) &&
@@ -2845,7 +2845,7 @@ trace_function(struct trace_array *tr,
 	       int pc)
 {
 	struct trace_event_call *call = &event_function;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct ring_buffer *buffer = tr->array_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct ftrace_entry *entry;
 
@@ -2971,7 +2971,7 @@ static inline void ftrace_trace_stack(struct trace_array *tr,
 void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 		   int pc)
 {
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct ring_buffer *buffer = tr->array_buffer.buffer;
 
 	if (rcu_is_watching()) {
 		__ftrace_trace_stack(buffer, flags, skip, pc, NULL);
@@ -3009,7 +3009,7 @@ void trace_dump_stack(int skip)
 	/* Skip 1 to skip this function. */
 	skip++;
 #endif
-	__ftrace_trace_stack(global_trace.trace_buffer.buffer,
+	__ftrace_trace_stack(global_trace.array_buffer.buffer,
 			     flags, skip, preempt_count(), NULL);
 }
 EXPORT_SYMBOL_GPL(trace_dump_stack);
@@ -3154,7 +3154,7 @@ void trace_printk_init_buffers(void)
 	 * directly here. If the global_trace.buffer is already
 	 * allocated here, then this was called by module code.
 	 */
-	if (global_trace.trace_buffer.buffer)
+	if (global_trace.array_buffer.buffer)
 		tracing_start_cmdline_record();
 }
 EXPORT_SYMBOL_GPL(trace_printk_init_buffers);
@@ -3217,7 +3217,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 
 	local_save_flags(flags);
 	size = sizeof(*entry) + sizeof(u32) * len;
-	buffer = tr->trace_buffer.buffer;
+	buffer = tr->array_buffer.buffer;
 	event = __trace_buffer_lock_reserve(buffer, TRACE_BPRINT, size,
 					    flags, pc);
 	if (!event)
@@ -3302,7 +3302,7 @@ __printf(3, 0)
 int trace_array_vprintk(struct trace_array *tr,
 			unsigned long ip, const char *fmt, va_list args)
 {
-	return __trace_array_vprintk(tr->trace_buffer.buffer, ip, fmt, args);
+	return __trace_array_vprintk(tr->array_buffer.buffer, ip, fmt, args);
 }
 
 __printf(3, 0)
@@ -3367,7 +3367,7 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts,
 	if (buf_iter)
 		event = ring_buffer_iter_peek(buf_iter, ts);
 	else
-		event = ring_buffer_peek(iter->trace_buffer->buffer, cpu, ts,
+		event = ring_buffer_peek(iter->array_buffer->buffer, cpu, ts,
 					 lost_events);
 
 	if (event) {
@@ -3382,7 +3382,7 @@ static struct trace_entry *
 __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
 		  unsigned long *missing_events, u64 *ent_ts)
 {
-	struct ring_buffer *buffer = iter->trace_buffer->buffer;
+	struct ring_buffer *buffer = iter->array_buffer->buffer;
 	struct trace_entry *ent, *next = NULL;
 	unsigned long lost_events = 0, next_lost = 0;
 	int cpu_file = iter->cpu_file;
@@ -3459,7 +3459,7 @@ void *trace_find_next_entry_inc(struct trace_iterator *iter)
 
 static void trace_consume(struct trace_iterator *iter)
 {
-	ring_buffer_consume(iter->trace_buffer->buffer, iter->cpu, &iter->ts,
+	ring_buffer_consume(iter->array_buffer->buffer, iter->cpu, &iter->ts,
 			    &iter->lost_events);
 }
 
@@ -3497,7 +3497,7 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 	unsigned long entries = 0;
 	u64 ts;
 
-	per_cpu_ptr(iter->trace_buffer->data, cpu)->skipped_entries = 0;
+	per_cpu_ptr(iter->array_buffer->data, cpu)->skipped_entries = 0;
 
 	buf_iter = trace_buffer_iter(iter, cpu);
 	if (!buf_iter)
@@ -3511,13 +3511,13 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 	 * by the timestamp being before the start of the buffer.
 	 */
 	while ((event = ring_buffer_iter_peek(buf_iter, &ts))) {
-		if (ts >= iter->trace_buffer->time_start)
+		if (ts >= iter->array_buffer->time_start)
 			break;
 		entries++;
 		ring_buffer_read(buf_iter, NULL);
 	}
 
-	per_cpu_ptr(iter->trace_buffer->data, cpu)->skipped_entries = entries;
+	per_cpu_ptr(iter->array_buffer->data, cpu)->skipped_entries = entries;
 }
 
 /*
@@ -3602,7 +3602,7 @@ static void s_stop(struct seq_file *m, void *p)
 }
 
 static void
-get_total_entries_cpu(struct trace_buffer *buf, unsigned long *total,
+get_total_entries_cpu(struct array_buffer *buf, unsigned long *total,
 		      unsigned long *entries, int cpu)
 {
 	unsigned long count;
@@ -3624,7 +3624,7 @@ get_total_entries_cpu(struct trace_buffer *buf, unsigned long *total,
 }
 
 static void
-get_total_entries(struct trace_buffer *buf,
+get_total_entries(struct array_buffer *buf,
 		  unsigned long *total, unsigned long *entries)
 {
 	unsigned long t, e;
@@ -3647,7 +3647,7 @@ unsigned long trace_total_entries_cpu(struct trace_array *tr, int cpu)
 	if (!tr)
 		tr = &global_trace;
 
-	get_total_entries_cpu(&tr->trace_buffer, &total, &entries, cpu);
+	get_total_entries_cpu(&tr->array_buffer, &total, &entries, cpu);
 
 	return entries;
 }
@@ -3659,7 +3659,7 @@ unsigned long trace_total_entries(struct trace_array *tr)
 	if (!tr)
 		tr = &global_trace;
 
-	get_total_entries(&tr->trace_buffer, &total, &entries);
+	get_total_entries(&tr->array_buffer, &total, &entries);
 
 	return entries;
 }
@@ -3676,7 +3676,7 @@ static void print_lat_help_header(struct seq_file *m)
 		    "#     \\   /      |||||  \\    |   /         \n");
 }
 
-static void print_event_info(struct trace_buffer *buf, struct seq_file *m)
+static void print_event_info(struct array_buffer *buf, struct seq_file *m)
 {
 	unsigned long total;
 	unsigned long entries;
@@ -3687,7 +3687,7 @@ static void print_event_info(struct trace_buffer *buf, struct seq_file *m)
 	seq_puts(m, "#\n");
 }
 
-static void print_func_help_header(struct trace_buffer *buf, struct seq_file *m,
+static void print_func_help_header(struct array_buffer *buf, struct seq_file *m,
 				   unsigned int flags)
 {
 	bool tgid = flags & TRACE_ITER_RECORD_TGID;
@@ -3698,7 +3698,7 @@ static void print_func_help_header(struct trace_buffer *buf, struct seq_file *m,
 	seq_printf(m, "#              | |     %s    |       |         |\n",	 tgid ? "  |      " : "");
 }
 
-static void print_func_help_header_irq(struct trace_buffer *buf, struct seq_file *m,
+static void print_func_help_header_irq(struct array_buffer *buf, struct seq_file *m,
 				       unsigned int flags)
 {
 	bool tgid = flags & TRACE_ITER_RECORD_TGID;
@@ -3720,7 +3720,7 @@ void
 print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 {
 	unsigned long sym_flags = (global_trace.trace_flags & TRACE_ITER_SYM_MASK);
-	struct trace_buffer *buf = iter->trace_buffer;
+	struct array_buffer *buf = iter->array_buffer;
 	struct trace_array_cpu *data = per_cpu_ptr(buf->data, buf->cpu);
 	struct tracer *type = iter->trace;
 	unsigned long entries;
@@ -3795,7 +3795,7 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
 	    cpumask_test_cpu(iter->cpu, iter->started))
 		return;
 
-	if (per_cpu_ptr(iter->trace_buffer->data, iter->cpu)->skipped_entries)
+	if (per_cpu_ptr(iter->array_buffer->data, iter->cpu)->skipped_entries)
 		return;
 
 	if (cpumask_available(iter->started))
@@ -3929,7 +3929,7 @@ int trace_empty(struct trace_iterator *iter)
 			if (!ring_buffer_iter_empty(buf_iter))
 				return 0;
 		} else {
-			if (!ring_buffer_empty_cpu(iter->trace_buffer->buffer, cpu))
+			if (!ring_buffer_empty_cpu(iter->array_buffer->buffer, cpu))
 				return 0;
 		}
 		return 1;
@@ -3941,7 +3941,7 @@ int trace_empty(struct trace_iterator *iter)
 			if (!ring_buffer_iter_empty(buf_iter))
 				return 0;
 		} else {
-			if (!ring_buffer_empty_cpu(iter->trace_buffer->buffer, cpu))
+			if (!ring_buffer_empty_cpu(iter->array_buffer->buffer, cpu))
 				return 0;
 		}
 	}
@@ -4031,10 +4031,10 @@ void trace_default_header(struct seq_file *m)
 	} else {
 		if (!(trace_flags & TRACE_ITER_VERBOSE)) {
 			if (trace_flags & TRACE_ITER_IRQ_INFO)
-				print_func_help_header_irq(iter->trace_buffer,
+				print_func_help_header_irq(iter->array_buffer,
 							   m, trace_flags);
 			else
-				print_func_help_header(iter->trace_buffer, m,
+				print_func_help_header(iter->array_buffer, m,
 						       trace_flags);
 		}
 	}
@@ -4192,10 +4192,10 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 #ifdef CONFIG_TRACER_MAX_TRACE
 	/* Currently only the top directory has a snapshot */
 	if (tr->current_trace->print_max || snapshot)
-		iter->trace_buffer = &tr->max_buffer;
+		iter->array_buffer = &tr->max_buffer;
 	else
 #endif
-		iter->trace_buffer = &tr->trace_buffer;
+		iter->array_buffer = &tr->array_buffer;
 	iter->snapshot = snapshot;
 	iter->pos = -1;
 	iter->cpu_file = tracing_get_cpu(inode);
@@ -4206,7 +4206,7 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 		iter->trace->open(iter);
 
 	/* Annotate start of buffers if we had overruns */
-	if (ring_buffer_overruns(iter->trace_buffer->buffer))
+	if (ring_buffer_overruns(iter->array_buffer->buffer))
 		iter->iter_flags |= TRACE_FILE_ANNOTATE;
 
 	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
@@ -4220,7 +4220,7 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 	if (iter->cpu_file == RING_BUFFER_ALL_CPUS) {
 		for_each_tracing_cpu(cpu) {
 			iter->buffer_iter[cpu] =
-				ring_buffer_read_prepare(iter->trace_buffer->buffer,
+				ring_buffer_read_prepare(iter->array_buffer->buffer,
 							 cpu, GFP_KERNEL);
 		}
 		ring_buffer_read_prepare_sync();
@@ -4231,7 +4231,7 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 	} else {
 		cpu = iter->cpu_file;
 		iter->buffer_iter[cpu] =
-			ring_buffer_read_prepare(iter->trace_buffer->buffer,
+			ring_buffer_read_prepare(iter->array_buffer->buffer,
 						 cpu, GFP_KERNEL);
 		ring_buffer_read_prepare_sync();
 		ring_buffer_read_start(iter->buffer_iter[cpu]);
@@ -4357,7 +4357,7 @@ static int tracing_open(struct inode *inode, struct file *file)
 	/* If this file was open for write, then erase contents */
 	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC)) {
 		int cpu = tracing_get_cpu(inode);
-		struct trace_buffer *trace_buf = &tr->trace_buffer;
+		struct array_buffer *trace_buf = &tr->array_buffer;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 		if (tr->current_trace->print_max)
@@ -4578,13 +4578,13 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 		 */
 		if (cpumask_test_cpu(cpu, tr->tracing_cpumask) &&
 				!cpumask_test_cpu(cpu, tracing_cpumask_new)) {
-			atomic_inc(&per_cpu_ptr(tr->trace_buffer.data, cpu)->disabled);
-			ring_buffer_record_disable_cpu(tr->trace_buffer.buffer, cpu);
+			atomic_inc(&per_cpu_ptr(tr->array_buffer.data, cpu)->disabled);
+			ring_buffer_record_disable_cpu(tr->array_buffer.buffer, cpu);
 		}
 		if (!cpumask_test_cpu(cpu, tr->tracing_cpumask) &&
 				cpumask_test_cpu(cpu, tracing_cpumask_new)) {
-			atomic_dec(&per_cpu_ptr(tr->trace_buffer.data, cpu)->disabled);
-			ring_buffer_record_enable_cpu(tr->trace_buffer.buffer, cpu);
+			atomic_dec(&per_cpu_ptr(tr->array_buffer.data, cpu)->disabled);
+			ring_buffer_record_enable_cpu(tr->array_buffer.buffer, cpu);
 		}
 	}
 	arch_spin_unlock(&tr->max_lock);
@@ -4726,7 +4726,7 @@ int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 		ftrace_pid_follow_fork(tr, enabled);
 
 	if (mask == TRACE_ITER_OVERWRITE) {
-		ring_buffer_change_overwrite(tr->trace_buffer.buffer, enabled);
+		ring_buffer_change_overwrite(tr->array_buffer.buffer, enabled);
 #ifdef CONFIG_TRACER_MAX_TRACE
 		ring_buffer_change_overwrite(tr->max_buffer.buffer, enabled);
 #endif
@@ -5534,11 +5534,11 @@ tracing_set_trace_read(struct file *filp, char __user *ubuf,
 
 int tracer_init(struct tracer *t, struct trace_array *tr)
 {
-	tracing_reset_online_cpus(&tr->trace_buffer);
+	tracing_reset_online_cpus(&tr->array_buffer);
 	return t->init(tr);
 }
 
-static void set_buffer_entries(struct trace_buffer *buf, unsigned long val)
+static void set_buffer_entries(struct array_buffer *buf, unsigned long val)
 {
 	int cpu;
 
@@ -5548,8 +5548,8 @@ static void set_buffer_entries(struct trace_buffer *buf, unsigned long val)
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 /* resize @tr's buffer to the size of @size_tr's entries */
-static int resize_buffer_duplicate_size(struct trace_buffer *trace_buf,
-					struct trace_buffer *size_buf, int cpu_id)
+static int resize_buffer_duplicate_size(struct array_buffer *trace_buf,
+					struct array_buffer *size_buf, int cpu_id)
 {
 	int cpu, ret = 0;
 
@@ -5587,10 +5587,10 @@ static int __tracing_resize_ring_buffer(struct trace_array *tr,
 	ring_buffer_expanded = true;
 
 	/* May be called before buffers are initialized */
-	if (!tr->trace_buffer.buffer)
+	if (!tr->array_buffer.buffer)
 		return 0;
 
-	ret = ring_buffer_resize(tr->trace_buffer.buffer, size, cpu);
+	ret = ring_buffer_resize(tr->array_buffer.buffer, size, cpu);
 	if (ret < 0)
 		return ret;
 
@@ -5601,8 +5601,8 @@ static int __tracing_resize_ring_buffer(struct trace_array *tr,
 
 	ret = ring_buffer_resize(tr->max_buffer.buffer, size, cpu);
 	if (ret < 0) {
-		int r = resize_buffer_duplicate_size(&tr->trace_buffer,
-						     &tr->trace_buffer, cpu);
+		int r = resize_buffer_duplicate_size(&tr->array_buffer,
+						     &tr->array_buffer, cpu);
 		if (r < 0) {
 			/*
 			 * AARGH! We are left with different
@@ -5633,9 +5633,9 @@ static int __tracing_resize_ring_buffer(struct trace_array *tr,
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
 	if (cpu == RING_BUFFER_ALL_CPUS)
-		set_buffer_entries(&tr->trace_buffer, size);
+		set_buffer_entries(&tr->array_buffer, size);
 	else
-		per_cpu_ptr(tr->trace_buffer.data, cpu)->entries = size;
+		per_cpu_ptr(tr->array_buffer.data, cpu)->entries = size;
 
 	return ret;
 }
@@ -5979,7 +5979,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
 
 	iter->tr = tr;
-	iter->trace_buffer = &tr->trace_buffer;
+	iter->array_buffer = &tr->array_buffer;
 	iter->cpu_file = tracing_get_cpu(inode);
 	mutex_init(&iter->mutex);
 	filp->private_data = iter;
@@ -6039,7 +6039,7 @@ trace_poll(struct trace_iterator *iter, struct file *filp, poll_table *poll_tabl
 		 */
 		return EPOLLIN | EPOLLRDNORM;
 	else
-		return ring_buffer_poll_wait(iter->trace_buffer->buffer, iter->cpu_file,
+		return ring_buffer_poll_wait(iter->array_buffer->buffer, iter->cpu_file,
 					     filp, poll_table);
 }
 
@@ -6356,8 +6356,8 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
 		for_each_tracing_cpu(cpu) {
 			/* fill in the size from first enabled cpu */
 			if (size == 0)
-				size = per_cpu_ptr(tr->trace_buffer.data, cpu)->entries;
-			if (size != per_cpu_ptr(tr->trace_buffer.data, cpu)->entries) {
+				size = per_cpu_ptr(tr->array_buffer.data, cpu)->entries;
+			if (size != per_cpu_ptr(tr->array_buffer.data, cpu)->entries) {
 				buf_size_same = 0;
 				break;
 			}
@@ -6373,7 +6373,7 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
 		} else
 			r = sprintf(buf, "X\n");
 	} else
-		r = sprintf(buf, "%lu\n", per_cpu_ptr(tr->trace_buffer.data, cpu)->entries >> 10);
+		r = sprintf(buf, "%lu\n", per_cpu_ptr(tr->array_buffer.data, cpu)->entries >> 10);
 
 	mutex_unlock(&trace_types_lock);
 
@@ -6420,7 +6420,7 @@ tracing_total_entries_read(struct file *filp, char __user *ubuf,
 
 	mutex_lock(&trace_types_lock);
 	for_each_tracing_cpu(cpu) {
-		size += per_cpu_ptr(tr->trace_buffer.data, cpu)->entries >> 10;
+		size += per_cpu_ptr(tr->array_buffer.data, cpu)->entries >> 10;
 		if (!ring_buffer_expanded)
 			expanded_size += trace_buf_size >> 10;
 	}
@@ -6499,7 +6499,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	if (cnt < FAULTED_SIZE)
 		size += FAULTED_SIZE - cnt;
 
-	buffer = tr->trace_buffer.buffer;
+	buffer = tr->array_buffer.buffer;
 	event = __trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
 					    irq_flags, preempt_count());
 	if (unlikely(!event))
@@ -6579,7 +6579,7 @@ tracing_mark_raw_write(struct file *filp, const char __user *ubuf,
 	if (cnt < FAULT_SIZE_ID)
 		size += FAULT_SIZE_ID - cnt;
 
-	buffer = tr->trace_buffer.buffer;
+	buffer = tr->array_buffer.buffer;
 	event = __trace_buffer_lock_reserve(buffer, TRACE_RAW_DATA, size,
 					    irq_flags, preempt_count());
 	if (!event)
@@ -6634,13 +6634,13 @@ int tracing_set_clock(struct trace_array *tr, const char *clockstr)
 
 	tr->clock_id = i;
 
-	ring_buffer_set_clock(tr->trace_buffer.buffer, trace_clocks[i].func);
+	ring_buffer_set_clock(tr->array_buffer.buffer, trace_clocks[i].func);
 
 	/*
 	 * New clock may not be consistent with the previous clock.
 	 * Reset the buffer so that it doesn't have incomparable timestamps.
 	 */
-	tracing_reset_online_cpus(&tr->trace_buffer);
+	tracing_reset_online_cpus(&tr->array_buffer);
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 	if (tr->max_buffer.buffer)
@@ -6703,7 +6703,7 @@ static int tracing_time_stamp_mode_show(struct seq_file *m, void *v)
 
 	mutex_lock(&trace_types_lock);
 
-	if (ring_buffer_time_stamp_abs(tr->trace_buffer.buffer))
+	if (ring_buffer_time_stamp_abs(tr->array_buffer.buffer))
 		seq_puts(m, "delta [absolute]\n");
 	else
 		seq_puts(m, "[delta] absolute\n");
@@ -6748,7 +6748,7 @@ int tracing_set_time_stamp_abs(struct trace_array *tr, bool abs)
 			goto out;
 	}
 
-	ring_buffer_set_time_stamp_abs(tr->trace_buffer.buffer, abs);
+	ring_buffer_set_time_stamp_abs(tr->array_buffer.buffer, abs);
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 	if (tr->max_buffer.buffer)
@@ -6797,7 +6797,7 @@ static int tracing_snapshot_open(struct inode *inode, struct file *file)
 		ret = 0;
 
 		iter->tr = tr;
-		iter->trace_buffer = &tr->max_buffer;
+		iter->array_buffer = &tr->max_buffer;
 		iter->cpu_file = tracing_get_cpu(inode);
 		m->private = iter;
 		file->private_data = m;
@@ -6860,7 +6860,7 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 #endif
 		if (tr->allocated_snapshot)
 			ret = resize_buffer_duplicate_size(&tr->max_buffer,
-					&tr->trace_buffer, iter->cpu_file);
+					&tr->array_buffer, iter->cpu_file);
 		else
 			ret = tracing_alloc_snapshot_instance(tr);
 		if (ret < 0)
@@ -6935,7 +6935,7 @@ static int snapshot_raw_open(struct inode *inode, struct file *filp)
 	}
 
 	info->iter.snapshot = true;
-	info->iter.trace_buffer = &info->iter.tr->max_buffer;
+	info->iter.array_buffer = &info->iter.tr->max_buffer;
 
 	return ret;
 }
@@ -7310,7 +7310,7 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 	info->iter.tr		= tr;
 	info->iter.cpu_file	= tracing_get_cpu(inode);
 	info->iter.trace	= tr->current_trace;
-	info->iter.trace_buffer = &tr->trace_buffer;
+	info->iter.array_buffer = &tr->array_buffer;
 	info->spare		= NULL;
 	/* Force reading ring buffer for first read */
 	info->read		= (unsigned int)-1;
@@ -7355,7 +7355,7 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 #endif
 
 	if (!info->spare) {
-		info->spare = ring_buffer_alloc_read_page(iter->trace_buffer->buffer,
+		info->spare = ring_buffer_alloc_read_page(iter->array_buffer->buffer,
 							  iter->cpu_file);
 		if (IS_ERR(info->spare)) {
 			ret = PTR_ERR(info->spare);
@@ -7373,7 +7373,7 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 
  again:
 	trace_access_lock(iter->cpu_file);
-	ret = ring_buffer_read_page(iter->trace_buffer->buffer,
+	ret = ring_buffer_read_page(iter->array_buffer->buffer,
 				    &info->spare,
 				    count,
 				    iter->cpu_file, 0);
@@ -7423,7 +7423,7 @@ static int tracing_buffers_release(struct inode *inode, struct file *file)
 	__trace_array_put(iter->tr);
 
 	if (info->spare)
-		ring_buffer_free_read_page(iter->trace_buffer->buffer,
+		ring_buffer_free_read_page(iter->array_buffer->buffer,
 					   info->spare_cpu, info->spare);
 	kfree(info);
 
@@ -7528,7 +7528,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 
  again:
 	trace_access_lock(iter->cpu_file);
-	entries = ring_buffer_entries_cpu(iter->trace_buffer->buffer, iter->cpu_file);
+	entries = ring_buffer_entries_cpu(iter->array_buffer->buffer, iter->cpu_file);
 
 	for (i = 0; i < spd.nr_pages_max && len && entries; i++, len -= PAGE_SIZE) {
 		struct page *page;
@@ -7541,7 +7541,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		}
 
 		refcount_set(&ref->refcount, 1);
-		ref->buffer = iter->trace_buffer->buffer;
+		ref->buffer = iter->array_buffer->buffer;
 		ref->page = ring_buffer_alloc_read_page(ref->buffer, iter->cpu_file);
 		if (IS_ERR(ref->page)) {
 			ret = PTR_ERR(ref->page);
@@ -7569,7 +7569,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		spd.nr_pages++;
 		*ppos += PAGE_SIZE;
 
-		entries = ring_buffer_entries_cpu(iter->trace_buffer->buffer, iter->cpu_file);
+		entries = ring_buffer_entries_cpu(iter->array_buffer->buffer, iter->cpu_file);
 	}
 
 	trace_access_unlock(iter->cpu_file);
@@ -7613,7 +7613,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 {
 	struct inode *inode = file_inode(filp);
 	struct trace_array *tr = inode->i_private;
-	struct trace_buffer *trace_buf = &tr->trace_buffer;
+	struct array_buffer *trace_buf = &tr->array_buffer;
 	int cpu = tracing_get_cpu(inode);
 	struct trace_seq *s;
 	unsigned long cnt;
@@ -8272,7 +8272,7 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
 	struct trace_array *tr = filp->private_data;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct ring_buffer *buffer = tr->array_buffer.buffer;
 	unsigned long val;
 	int ret;
 
@@ -8362,7 +8362,7 @@ static void
 init_tracer_tracefs(struct trace_array *tr, struct dentry *d_tracer);
 
 static int
-allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size)
+allocate_trace_buffer(struct trace_array *tr, struct array_buffer *buf, int size)
 {
 	enum ring_buffer_flags rb_flags;
 
@@ -8382,8 +8382,8 @@ allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size
 	}
 
 	/* Allocate the first page for all buffers */
-	set_buffer_entries(&tr->trace_buffer,
-			   ring_buffer_size(tr->trace_buffer.buffer, 0));
+	set_buffer_entries(&tr->array_buffer,
+			   ring_buffer_size(tr->array_buffer.buffer, 0));
 
 	return 0;
 }
@@ -8392,7 +8392,7 @@ static int allocate_trace_buffers(struct trace_array *tr, int size)
 {
 	int ret;
 
-	ret = allocate_trace_buffer(tr, &tr->trace_buffer, size);
+	ret = allocate_trace_buffer(tr, &tr->array_buffer, size);
 	if (ret)
 		return ret;
 
@@ -8400,10 +8400,10 @@ static int allocate_trace_buffers(struct trace_array *tr, int size)
 	ret = allocate_trace_buffer(tr, &tr->max_buffer,
 				    allocate_snapshot ? size : 1);
 	if (WARN_ON(ret)) {
-		ring_buffer_free(tr->trace_buffer.buffer);
-		tr->trace_buffer.buffer = NULL;
-		free_percpu(tr->trace_buffer.data);
-		tr->trace_buffer.data = NULL;
+		ring_buffer_free(tr->array_buffer.buffer);
+		tr->array_buffer.buffer = NULL;
+		free_percpu(tr->array_buffer.data);
+		tr->array_buffer.data = NULL;
 		return -ENOMEM;
 	}
 	tr->allocated_snapshot = allocate_snapshot;
@@ -8417,7 +8417,7 @@ static int allocate_trace_buffers(struct trace_array *tr, int size)
 	return 0;
 }
 
-static void free_trace_buffer(struct trace_buffer *buf)
+static void free_trace_buffer(struct array_buffer *buf)
 {
 	if (buf->buffer) {
 		ring_buffer_free(buf->buffer);
@@ -8432,7 +8432,7 @@ static void free_trace_buffers(struct trace_array *tr)
 	if (!tr)
 		return;
 
-	free_trace_buffer(&tr->trace_buffer);
+	free_trace_buffer(&tr->array_buffer);
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 	free_trace_buffer(&tr->max_buffer);
@@ -9036,13 +9036,13 @@ void trace_init_global_iter(struct trace_iterator *iter)
 	iter->tr = &global_trace;
 	iter->trace = iter->tr->current_trace;
 	iter->cpu_file = RING_BUFFER_ALL_CPUS;
-	iter->trace_buffer = &global_trace.trace_buffer;
+	iter->array_buffer = &global_trace.array_buffer;
 
 	if (iter->trace && iter->trace->open)
 		iter->trace->open(iter);
 
 	/* Annotate start of buffers if we had overruns */
-	if (ring_buffer_overruns(iter->trace_buffer->buffer))
+	if (ring_buffer_overruns(iter->array_buffer->buffer))
 		iter->iter_flags |= TRACE_FILE_ANNOTATE;
 
 	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
@@ -9083,7 +9083,7 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 	trace_init_global_iter(&iter);
 
 	for_each_tracing_cpu(cpu) {
-		atomic_inc(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
+		atomic_inc(&per_cpu_ptr(iter.array_buffer->data, cpu)->disabled);
 	}
 
 	old_userobj = tr->trace_flags & TRACE_ITER_SYM_USEROBJ;
@@ -9151,7 +9151,7 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 	tr->trace_flags |= old_userobj;
 
 	for_each_tracing_cpu(cpu) {
-		atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
+		atomic_dec(&per_cpu_ptr(iter.array_buffer->data, cpu)->disabled);
 	}
 	atomic_dec(&dump_running);
 	printk_nmi_direct_exit();
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 63bf60f79398..fd679fe92c1f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -176,7 +176,7 @@ struct trace_array_cpu {
 struct tracer;
 struct trace_option_dentry;
 
-struct trace_buffer {
+struct array_buffer {
 	struct trace_array		*tr;
 	struct ring_buffer		*buffer;
 	struct trace_array_cpu __percpu	*data;
@@ -249,7 +249,7 @@ struct cond_snapshot {
 struct trace_array {
 	struct list_head	list;
 	char			*name;
-	struct trace_buffer	trace_buffer;
+	struct array_buffer	array_buffer;
 #ifdef CONFIG_TRACER_MAX_TRACE
 	/*
 	 * The max_buffer is used to snapshot the trace when a maximum
@@ -257,12 +257,12 @@ struct trace_array {
 	 * Some tracers will use this to store a maximum trace while
 	 * it continues examining live traces.
 	 *
-	 * The buffers for the max_buffer are set up the same as the trace_buffer
+	 * The buffers for the max_buffer are set up the same as the array_buffer
 	 * When a snapshot is taken, the buffer of the max_buffer is swapped
-	 * with the buffer of the trace_buffer and the buffers are reset for
-	 * the trace_buffer so the tracing can continue.
+	 * with the buffer of the array_buffer and the buffers are reset for
+	 * the array_buffer so the tracing can continue.
 	 */
-	struct trace_buffer	max_buffer;
+	struct array_buffer	max_buffer;
 	bool			allocated_snapshot;
 #endif
 #if defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER)
@@ -685,7 +685,7 @@ trace_buffer_iter(struct trace_iterator *iter, int cpu)
 
 int tracer_init(struct tracer *t, struct trace_array *tr);
 int tracing_is_enabled(void);
-void tracing_reset_online_cpus(struct trace_buffer *buf);
+void tracing_reset_online_cpus(struct array_buffer *buf);
 void tracing_reset_current(int cpu);
 void tracing_reset_all_online_cpus(void);
 int tracing_open_generic(struct inode *inode, struct file *filp);
@@ -1057,7 +1057,7 @@ struct ftrace_func_command {
 extern bool ftrace_filter_param __initdata;
 static inline int ftrace_trace_task(struct trace_array *tr)
 {
-	return !this_cpu_read(tr->trace_buffer.data->ftrace_ignore_pid);
+	return !this_cpu_read(tr->array_buffer.data->ftrace_ignore_pid);
 }
 extern int ftrace_is_dead(void);
 int ftrace_create_function_files(struct trace_array *tr,
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 88e158d27965..d5989284a99a 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -55,12 +55,12 @@ probe_likely_condition(struct ftrace_likely_data *f, int val, int expect)
 
 	raw_local_irq_save(flags);
 	current->trace_recursion |= TRACE_BRANCH_BIT;
-	data = this_cpu_ptr(tr->trace_buffer.data);
+	data = this_cpu_ptr(tr->array_buffer.data);
 	if (atomic_read(&data->disabled))
 		goto out;
 
 	pc = preempt_count();
-	buffer = tr->trace_buffer.buffer;
+	buffer = tr->array_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_BRANCH,
 					  sizeof(*entry), flags, pc);
 	if (!event)
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a5b614cc3887..ac557f685f0b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -237,7 +237,7 @@ bool trace_event_ignore_this_pid(struct trace_event_file *trace_file)
 	if (!pid_list)
 		return false;
 
-	data = this_cpu_ptr(tr->trace_buffer.data);
+	data = this_cpu_ptr(tr->array_buffer.data);
 
 	return data->ignore_pid;
 }
@@ -546,7 +546,7 @@ event_filter_pid_sched_switch_probe_pre(void *data, bool preempt,
 
 	pid_list = rcu_dereference_sched(tr->filtered_pids);
 
-	this_cpu_write(tr->trace_buffer.data->ignore_pid,
+	this_cpu_write(tr->array_buffer.data->ignore_pid,
 		       trace_ignore_this_task(pid_list, prev) &&
 		       trace_ignore_this_task(pid_list, next));
 }
@@ -560,7 +560,7 @@ event_filter_pid_sched_switch_probe_post(void *data, bool preempt,
 
 	pid_list = rcu_dereference_sched(tr->filtered_pids);
 
-	this_cpu_write(tr->trace_buffer.data->ignore_pid,
+	this_cpu_write(tr->array_buffer.data->ignore_pid,
 		       trace_ignore_this_task(pid_list, next));
 }
 
@@ -571,12 +571,12 @@ event_filter_pid_sched_wakeup_probe_pre(void *data, struct task_struct *task)
 	struct trace_pid_list *pid_list;
 
 	/* Nothing to do if we are already tracing */
-	if (!this_cpu_read(tr->trace_buffer.data->ignore_pid))
+	if (!this_cpu_read(tr->array_buffer.data->ignore_pid))
 		return;
 
 	pid_list = rcu_dereference_sched(tr->filtered_pids);
 
-	this_cpu_write(tr->trace_buffer.data->ignore_pid,
+	this_cpu_write(tr->array_buffer.data->ignore_pid,
 		       trace_ignore_this_task(pid_list, task));
 }
 
@@ -587,13 +587,13 @@ event_filter_pid_sched_wakeup_probe_post(void *data, struct task_struct *task)
 	struct trace_pid_list *pid_list;
 
 	/* Nothing to do if we are not tracing */
-	if (this_cpu_read(tr->trace_buffer.data->ignore_pid))
+	if (this_cpu_read(tr->array_buffer.data->ignore_pid))
 		return;
 
 	pid_list = rcu_dereference_sched(tr->filtered_pids);
 
 	/* Set tracing if current is enabled */
-	this_cpu_write(tr->trace_buffer.data->ignore_pid,
+	this_cpu_write(tr->array_buffer.data->ignore_pid,
 		       trace_ignore_this_task(pid_list, current));
 }
 
@@ -625,7 +625,7 @@ static void __ftrace_clear_event_pids(struct trace_array *tr)
 	}
 
 	for_each_possible_cpu(cpu)
-		per_cpu_ptr(tr->trace_buffer.data, cpu)->ignore_pid = false;
+		per_cpu_ptr(tr->array_buffer.data, cpu)->ignore_pid = false;
 
 	rcu_assign_pointer(tr->filtered_pids, NULL);
 
@@ -1594,7 +1594,7 @@ static void ignore_task_cpu(void *data)
 	pid_list = rcu_dereference_protected(tr->filtered_pids,
 					     mutex_is_locked(&event_mutex));
 
-	this_cpu_write(tr->trace_buffer.data->ignore_pid,
+	this_cpu_write(tr->array_buffer.data->ignore_pid,
 		       trace_ignore_this_task(pid_list, current));
 }
 
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index f62de5f43e79..94c581c1a897 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -895,7 +895,7 @@ static notrace void trace_event_raw_event_synth(void *__data,
 	 * Avoid ring buffer recursion detection, as this event
 	 * is being performed within another event.
 	 */
-	buffer = trace_file->tr->trace_buffer.buffer;
+	buffer = trace_file->tr->array_buffer.buffer;
 	ring_buffer_nest_start(buffer);
 
 	entry = trace_event_buffer_reserve(&fbuffer, trace_file,
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index b611cd36e22d..8a4c8d5c2c98 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -101,7 +101,7 @@ static int function_trace_init(struct trace_array *tr)
 
 	ftrace_init_array_ops(tr, func);
 
-	tr->trace_buffer.cpu = get_cpu();
+	tr->array_buffer.cpu = get_cpu();
 	put_cpu();
 
 	tracing_start_cmdline_record();
@@ -118,7 +118,7 @@ static void function_trace_reset(struct trace_array *tr)
 
 static void function_trace_start(struct trace_array *tr)
 {
-	tracing_reset_online_cpus(&tr->trace_buffer);
+	tracing_reset_online_cpus(&tr->array_buffer);
 }
 
 static void
@@ -143,7 +143,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip,
 		goto out;
 
 	cpu = smp_processor_id();
-	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
+	data = per_cpu_ptr(tr->array_buffer.data, cpu);
 	if (!atomic_read(&data->disabled)) {
 		local_save_flags(flags);
 		trace_function(tr, ip, parent_ip, flags, pc);
@@ -192,7 +192,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
 	 */
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
+	data = per_cpu_ptr(tr->array_buffer.data, cpu);
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1)) {
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 78af97163147..79b2c2df00c5 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -101,7 +101,7 @@ int __trace_graph_entry(struct trace_array *tr,
 {
 	struct trace_event_call *call = &event_funcgraph_entry;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct ring_buffer *buffer = tr->array_buffer.buffer;
 	struct ftrace_graph_ent_entry *entry;
 
 	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_ENT,
@@ -171,7 +171,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
+	data = per_cpu_ptr(tr->array_buffer.data, cpu);
 	disabled = atomic_inc_return(&data->disabled);
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
@@ -221,7 +221,7 @@ void __trace_graph_return(struct trace_array *tr,
 {
 	struct trace_event_call *call = &event_funcgraph_exit;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct ring_buffer *buffer = tr->array_buffer.buffer;
 	struct ftrace_graph_ret_entry *entry;
 
 	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_RET,
@@ -252,7 +252,7 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
+	data = per_cpu_ptr(tr->array_buffer.data, cpu);
 	disabled = atomic_inc_return(&data->disabled);
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
@@ -444,9 +444,9 @@ get_return_for_leaf(struct trace_iterator *iter,
 			 * We need to consume the current entry to see
 			 * the next one.
 			 */
-			ring_buffer_consume(iter->trace_buffer->buffer, iter->cpu,
+			ring_buffer_consume(iter->array_buffer->buffer, iter->cpu,
 					    NULL, NULL);
-			event = ring_buffer_peek(iter->trace_buffer->buffer, iter->cpu,
+			event = ring_buffer_peek(iter->array_buffer->buffer, iter->cpu,
 						 NULL, NULL);
 		}
 
@@ -503,7 +503,7 @@ print_graph_rel_time(struct trace_iterator *iter, struct trace_seq *s)
 {
 	unsigned long long usecs;
 
-	usecs = iter->ts - iter->trace_buffer->time_start;
+	usecs = iter->ts - iter->array_buffer->time_start;
 	do_div(usecs, NSEC_PER_USEC);
 
 	trace_seq_printf(s, "%9llu us |  ", usecs);
diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index 6638d63f0921..fc62a6049bd3 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -104,7 +104,7 @@ static void trace_hwlat_sample(struct hwlat_sample *sample)
 {
 	struct trace_array *tr = hwlat_trace;
 	struct trace_event_call *call = &event_hwlat;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct ring_buffer *buffer = tr->array_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct hwlat_entry *entry;
 	unsigned long flags;
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index a745b0cee5d3..10bbb0f381d5 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -122,7 +122,7 @@ static int func_prolog_dec(struct trace_array *tr,
 	if (!irqs_disabled_flags(*flags) && !preempt_count())
 		return 0;
 
-	*data = per_cpu_ptr(tr->trace_buffer.data, cpu);
+	*data = per_cpu_ptr(tr->array_buffer.data, cpu);
 	disabled = atomic_inc_return(&(*data)->disabled);
 
 	if (likely(disabled == 1))
@@ -167,7 +167,7 @@ static int irqsoff_display_graph(struct trace_array *tr, int set)
 		per_cpu(tracing_cpu, cpu) = 0;
 
 	tr->max_latency = 0;
-	tracing_reset_online_cpus(&irqsoff_trace->trace_buffer);
+	tracing_reset_online_cpus(&irqsoff_trace->array_buffer);
 
 	return start_irqsoff_tracer(irqsoff_trace, set);
 }
@@ -382,7 +382,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip, int pc)
 	if (per_cpu(tracing_cpu, cpu))
 		return;
 
-	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
+	data = per_cpu_ptr(tr->array_buffer.data, cpu);
 
 	if (unlikely(!data) || atomic_read(&data->disabled))
 		return;
@@ -420,7 +420,7 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip, int pc)
 	if (!tracer_enabled || !tracing_is_enabled())
 		return;
 
-	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
+	data = per_cpu_ptr(tr->array_buffer.data, cpu);
 
 	if (unlikely(!data) ||
 	    !data->critical_start || atomic_read(&data->disabled))
diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index cca65044c14c..9da76104f7a2 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -43,7 +43,7 @@ static void ftrace_dump_buf(int skip_entries, long cpu_file)
 	if (cpu_file == RING_BUFFER_ALL_CPUS) {
 		for_each_tracing_cpu(cpu) {
 			iter.buffer_iter[cpu] =
-			ring_buffer_read_prepare(iter.trace_buffer->buffer,
+			ring_buffer_read_prepare(iter.array_buffer->buffer,
 						 cpu, GFP_ATOMIC);
 			ring_buffer_read_start(iter.buffer_iter[cpu]);
 			tracing_iter_reset(&iter, cpu);
@@ -51,7 +51,7 @@ static void ftrace_dump_buf(int skip_entries, long cpu_file)
 	} else {
 		iter.cpu_file = cpu_file;
 		iter.buffer_iter[cpu_file] =
-			ring_buffer_read_prepare(iter.trace_buffer->buffer,
+			ring_buffer_read_prepare(iter.array_buffer->buffer,
 						 cpu_file, GFP_ATOMIC);
 		ring_buffer_read_start(iter.buffer_iter[cpu_file]);
 		tracing_iter_reset(&iter, cpu_file);
@@ -124,7 +124,7 @@ static int kdb_ftdump(int argc, const char **argv)
 	iter.buffer_iter = buffer_iter;
 
 	for_each_tracing_cpu(cpu) {
-		atomic_inc(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
+		atomic_inc(&per_cpu_ptr(iter.array_buffer->data, cpu)->disabled);
 	}
 
 	/* A negative skip_entries means skip all but the last entries */
@@ -139,7 +139,7 @@ static int kdb_ftdump(int argc, const char **argv)
 	ftrace_dump_buf(skip_entries, cpu_file);
 
 	for_each_tracing_cpu(cpu) {
-		atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
+		atomic_dec(&per_cpu_ptr(iter.array_buffer->data, cpu)->disabled);
 	}
 
 	kdb_trap_printk--;
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index b0388016b687..c30137148759 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -32,7 +32,7 @@ static void mmio_reset_data(struct trace_array *tr)
 	overrun_detected = false;
 	prev_overruns = 0;
 
-	tracing_reset_online_cpus(&tr->trace_buffer);
+	tracing_reset_online_cpus(&tr->array_buffer);
 }
 
 static int mmio_trace_init(struct trace_array *tr)
@@ -122,7 +122,7 @@ static void mmio_close(struct trace_iterator *iter)
 static unsigned long count_overruns(struct trace_iterator *iter)
 {
 	unsigned long cnt = atomic_xchg(&dropped_count, 0);
-	unsigned long over = ring_buffer_overruns(iter->trace_buffer->buffer);
+	unsigned long over = ring_buffer_overruns(iter->array_buffer->buffer);
 
 	if (over > prev_overruns)
 		cnt += over - prev_overruns;
@@ -297,7 +297,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 				struct mmiotrace_rw *rw)
 {
 	struct trace_event_call *call = &event_mmiotrace_rw;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct ring_buffer *buffer = tr->array_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_rw *entry;
 	int pc = preempt_count();
@@ -318,7 +318,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 void mmio_trace_rw(struct mmiotrace_rw *rw)
 {
 	struct trace_array *tr = mmio_trace_array;
-	struct trace_array_cpu *data = per_cpu_ptr(tr->trace_buffer.data, smp_processor_id());
+	struct trace_array_cpu *data = per_cpu_ptr(tr->array_buffer.data, smp_processor_id());
 	__trace_mmiotrace_rw(tr, data, rw);
 }
 
@@ -327,7 +327,7 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 				struct mmiotrace_map *map)
 {
 	struct trace_event_call *call = &event_mmiotrace_map;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct ring_buffer *buffer = tr->array_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_map *entry;
 	int pc = preempt_count();
@@ -351,7 +351,7 @@ void mmio_trace_mapping(struct mmiotrace_map *map)
 	struct trace_array_cpu *data;
 
 	preempt_disable();
-	data = per_cpu_ptr(tr->trace_buffer.data, smp_processor_id());
+	data = per_cpu_ptr(tr->array_buffer.data, smp_processor_id());
 	__trace_mmiotrace_map(tr, data, map);
 	preempt_enable();
 }
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index d9b4b7c22db4..b4909082f6a4 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -538,7 +538,7 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
 	struct trace_array *tr = iter->tr;
 	unsigned long verbose = tr->trace_flags & TRACE_ITER_VERBOSE;
 	unsigned long in_ns = iter->iter_flags & TRACE_FILE_TIME_IN_NS;
-	unsigned long long abs_ts = iter->ts - iter->trace_buffer->time_start;
+	unsigned long long abs_ts = iter->ts - iter->array_buffer->time_start;
 	unsigned long long rel_ts = next_ts - iter->ts;
 	struct trace_seq *s = &iter->seq;
 
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 617e297f46dc..510fda2fcd24 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -82,7 +82,7 @@ func_prolog_preempt_disable(struct trace_array *tr,
 	if (cpu != wakeup_current_cpu)
 		goto out_enable;
 
-	*data = per_cpu_ptr(tr->trace_buffer.data, cpu);
+	*data = per_cpu_ptr(tr->array_buffer.data, cpu);
 	disabled = atomic_inc_return(&(*data)->disabled);
 	if (unlikely(disabled != 1))
 		goto out;
@@ -378,7 +378,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
 			   unsigned long flags, int pc)
 {
 	struct trace_event_call *call = &event_context_switch;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct ring_buffer *buffer = tr->array_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
 
@@ -408,7 +408,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	struct trace_event_call *call = &event_wakeup;
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
+	struct ring_buffer *buffer = tr->array_buffer.buffer;
 
 	event = trace_buffer_lock_reserve(buffer, TRACE_WAKE,
 					  sizeof(*entry), flags, pc);
@@ -459,7 +459,7 @@ probe_wakeup_sched_switch(void *ignore, bool preempt,
 
 	/* disable local data, not wakeup_cpu data */
 	cpu = raw_smp_processor_id();
-	disabled = atomic_inc_return(&per_cpu_ptr(wakeup_trace->trace_buffer.data, cpu)->disabled);
+	disabled = atomic_inc_return(&per_cpu_ptr(wakeup_trace->array_buffer.data, cpu)->disabled);
 	if (likely(disabled != 1))
 		goto out;
 
@@ -471,7 +471,7 @@ probe_wakeup_sched_switch(void *ignore, bool preempt,
 		goto out_unlock;
 
 	/* The task we are waiting for is waking up */
-	data = per_cpu_ptr(wakeup_trace->trace_buffer.data, wakeup_cpu);
+	data = per_cpu_ptr(wakeup_trace->array_buffer.data, wakeup_cpu);
 
 	__trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
 	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
@@ -494,7 +494,7 @@ probe_wakeup_sched_switch(void *ignore, bool preempt,
 	arch_spin_unlock(&wakeup_lock);
 	local_irq_restore(flags);
 out:
-	atomic_dec(&per_cpu_ptr(wakeup_trace->trace_buffer.data, cpu)->disabled);
+	atomic_dec(&per_cpu_ptr(wakeup_trace->array_buffer.data, cpu)->disabled);
 }
 
 static void __wakeup_reset(struct trace_array *tr)
@@ -513,7 +513,7 @@ static void wakeup_reset(struct trace_array *tr)
 {
 	unsigned long flags;
 
-	tracing_reset_online_cpus(&tr->trace_buffer);
+	tracing_reset_online_cpus(&tr->array_buffer);
 
 	local_irq_save(flags);
 	arch_spin_lock(&wakeup_lock);
@@ -551,7 +551,7 @@ probe_wakeup(void *ignore, struct task_struct *p)
 		return;
 
 	pc = preempt_count();
-	disabled = atomic_inc_return(&per_cpu_ptr(wakeup_trace->trace_buffer.data, cpu)->disabled);
+	disabled = atomic_inc_return(&per_cpu_ptr(wakeup_trace->array_buffer.data, cpu)->disabled);
 	if (unlikely(disabled != 1))
 		goto out;
 
@@ -583,7 +583,7 @@ probe_wakeup(void *ignore, struct task_struct *p)
 
 	local_save_flags(flags);
 
-	data = per_cpu_ptr(wakeup_trace->trace_buffer.data, wakeup_cpu);
+	data = per_cpu_ptr(wakeup_trace->array_buffer.data, wakeup_cpu);
 	data->preempt_timestamp = ftrace_now(cpu);
 	tracing_sched_wakeup_trace(wakeup_trace, p, current, flags, pc);
 	__trace_stack(wakeup_trace, flags, 0, pc);
@@ -598,7 +598,7 @@ probe_wakeup(void *ignore, struct task_struct *p)
 out_locked:
 	arch_spin_unlock(&wakeup_lock);
 out:
-	atomic_dec(&per_cpu_ptr(wakeup_trace->trace_buffer.data, cpu)->disabled);
+	atomic_dec(&per_cpu_ptr(wakeup_trace->array_buffer.data, cpu)->disabled);
 }
 
 static void start_wakeup_tracer(struct trace_array *tr)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 69ee8ef12cee..b5e3496cf803 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -23,7 +23,7 @@ static inline int trace_valid_entry(struct trace_entry *entry)
 	return 0;
 }
 
-static int trace_test_buffer_cpu(struct trace_buffer *buf, int cpu)
+static int trace_test_buffer_cpu(struct array_buffer *buf, int cpu)
 {
 	struct ring_buffer_event *event;
 	struct trace_entry *entry;
@@ -60,7 +60,7 @@ static int trace_test_buffer_cpu(struct trace_buffer *buf, int cpu)
  * Test the trace buffer to see if all the elements
  * are still sane.
  */
-static int __maybe_unused trace_test_buffer(struct trace_buffer *buf, unsigned long *count)
+static int __maybe_unused trace_test_buffer(struct array_buffer *buf, unsigned long *count)
 {
 	unsigned long flags, cnt = 0;
 	int cpu, ret = 0;
@@ -362,7 +362,7 @@ static int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	msleep(100);
 
 	/* we should have nothing in the buffer */
-	ret = trace_test_buffer(&tr->trace_buffer, &count);
+	ret = trace_test_buffer(&tr->array_buffer, &count);
 	if (ret)
 		goto out;
 
@@ -383,7 +383,7 @@ static int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	ftrace_enabled = 0;
 
 	/* check the trace buffer */
-	ret = trace_test_buffer(&tr->trace_buffer, &count);
+	ret = trace_test_buffer(&tr->array_buffer, &count);
 
 	ftrace_enabled = 1;
 	tracing_start();
@@ -682,7 +682,7 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 	ftrace_enabled = 0;
 
 	/* check the trace buffer */
-	ret = trace_test_buffer(&tr->trace_buffer, &count);
+	ret = trace_test_buffer(&tr->array_buffer, &count);
 
 	ftrace_enabled = 1;
 	trace->reset(tr);
@@ -768,7 +768,7 @@ trace_selftest_startup_function_graph(struct tracer *trace,
 	 * Simulate the init() callback but we attach a watchdog callback
 	 * to detect and recover from possible hangs
 	 */
-	tracing_reset_online_cpus(&tr->trace_buffer);
+	tracing_reset_online_cpus(&tr->array_buffer);
 	set_graph_array(tr);
 	ret = register_ftrace_graph(&fgraph_ops);
 	if (ret) {
@@ -790,7 +790,7 @@ trace_selftest_startup_function_graph(struct tracer *trace,
 	tracing_stop();
 
 	/* check the trace buffer */
-	ret = trace_test_buffer(&tr->trace_buffer, &count);
+	ret = trace_test_buffer(&tr->array_buffer, &count);
 
 	/* Need to also simulate the tr->reset to remove this fgraph_ops */
 	tracing_stop_cmdline_record();
@@ -848,7 +848,7 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 	/* stop the tracing. */
 	tracing_stop();
 	/* check both trace buffers */
-	ret = trace_test_buffer(&tr->trace_buffer, NULL);
+	ret = trace_test_buffer(&tr->array_buffer, NULL);
 	if (!ret)
 		ret = trace_test_buffer(&tr->max_buffer, &count);
 	trace->reset(tr);
@@ -910,7 +910,7 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 	/* stop the tracing. */
 	tracing_stop();
 	/* check both trace buffers */
-	ret = trace_test_buffer(&tr->trace_buffer, NULL);
+	ret = trace_test_buffer(&tr->array_buffer, NULL);
 	if (!ret)
 		ret = trace_test_buffer(&tr->max_buffer, &count);
 	trace->reset(tr);
@@ -976,7 +976,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	/* stop the tracing. */
 	tracing_stop();
 	/* check both trace buffers */
-	ret = trace_test_buffer(&tr->trace_buffer, NULL);
+	ret = trace_test_buffer(&tr->array_buffer, NULL);
 	if (ret)
 		goto out;
 
@@ -1006,7 +1006,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	/* stop the tracing. */
 	tracing_stop();
 	/* check both trace buffers */
-	ret = trace_test_buffer(&tr->trace_buffer, NULL);
+	ret = trace_test_buffer(&tr->array_buffer, NULL);
 	if (ret)
 		goto out;
 
@@ -1136,7 +1136,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	/* stop the tracing. */
 	tracing_stop();
 	/* check both trace buffers */
-	ret = trace_test_buffer(&tr->trace_buffer, NULL);
+	ret = trace_test_buffer(&tr->array_buffer, NULL);
 	if (!ret)
 		ret = trace_test_buffer(&tr->max_buffer, &count);
 
@@ -1177,7 +1177,7 @@ trace_selftest_startup_branch(struct tracer *trace, struct trace_array *tr)
 	/* stop the tracing. */
 	tracing_stop();
 	/* check the trace buffer */
-	ret = trace_test_buffer(&tr->trace_buffer, &count);
+	ret = trace_test_buffer(&tr->array_buffer, &count);
 	trace->reset(tr);
 	tracing_start();
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 16fa218556fa..bd92843c2b0e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -345,7 +345,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	buffer = tr->trace_buffer.buffer;
+	buffer = tr->array_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer,
 			sys_data->enter_event->event.type, size, irq_flags, pc);
 	if (!event)
@@ -391,7 +391,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	buffer = tr->trace_buffer.buffer;
+	buffer = tr->array_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer,
 			sys_data->exit_event->event.type, sizeof(*entry),
 			irq_flags, pc);
-- 
2.24.0


