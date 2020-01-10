Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 678A713652F
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 03:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730761AbgAJCFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 21:05:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730596AbgAJCFM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 21:05:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A3402067D;
        Fri, 10 Jan 2020 02:05:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.3)
        (envelope-from <rostedt@goodmis.org>)
        id 1ipjfi-000YvL-3d; Thu, 09 Jan 2020 21:05:10 -0500
Message-Id: <20200110020509.983809718@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 09 Jan 2020 21:03:09 -0500
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
        Quentin Monnet <quentin.monnet@netronome.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/3] perf: Make struct ring_buffer less ambiguous
References: <20200110020308.977313200@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

eBPF requires needing to know the size of the perf ring buffer structure.
But it unfortunately has the same name as the generic ring buffer used by
tracing and oprofile. To make it less ambiguous, rename the perf ring buffer
structure to "perf_buffer".

As other parts of the ring buffer code has "perf_" as the prefix, it only
makes sense to give the ring buffer the "perf_" prefix as well.

Link: https://lore.kernel.org/r/20191213153553.GE20583@krava
Acked-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/linux/perf_event.h  |  6 ++---
 kernel/events/core.c        | 42 ++++++++++++++---------------
 kernel/events/internal.h    | 34 +++++++++++------------
 kernel/events/ring_buffer.c | 54 ++++++++++++++++++-------------------
 4 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6d4c22aee384..cf65763af0cb 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -582,7 +582,7 @@ struct swevent_hlist {
 #define PERF_ATTACH_ITRACE	0x10
 
 struct perf_cgroup;
-struct ring_buffer;
+struct perf_buffer;
 
 struct pmu_event_list {
 	raw_spinlock_t		lock;
@@ -694,7 +694,7 @@ struct perf_event {
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
 
-	struct ring_buffer		*rb;
+	struct perf_buffer		*rb;
 	struct list_head		rb_entry;
 	unsigned long			rcu_batches;
 	int				rcu_pending;
@@ -854,7 +854,7 @@ struct perf_cpu_context {
 
 struct perf_output_handle {
 	struct perf_event		*event;
-	struct ring_buffer		*rb;
+	struct perf_buffer		*rb;
 	unsigned long			wakeup;
 	unsigned long			size;
 	u64				aux_flags;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4ff86d57f9e5..2871c4d2bd53 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4373,7 +4373,7 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void ring_buffer_attach(struct perf_event *event,
-			       struct ring_buffer *rb);
+			       struct perf_buffer *rb);
 
 static void detach_sb_event(struct perf_event *event)
 {
@@ -5054,7 +5054,7 @@ perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 static __poll_t perf_poll(struct file *file, poll_table *wait)
 {
 	struct perf_event *event = file->private_data;
-	struct ring_buffer *rb;
+	struct perf_buffer *rb;
 	__poll_t events = EPOLLHUP;
 
 	poll_wait(file, &event->waitq, wait);
@@ -5296,7 +5296,7 @@ static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned lon
 		return perf_event_set_bpf_prog(event, arg);
 
 	case PERF_EVENT_IOC_PAUSE_OUTPUT: {
-		struct ring_buffer *rb;
+		struct perf_buffer *rb;
 
 		rcu_read_lock();
 		rb = rcu_dereference(event->rb);
@@ -5432,7 +5432,7 @@ static void calc_timer_values(struct perf_event *event,
 static void perf_event_init_userpage(struct perf_event *event)
 {
 	struct perf_event_mmap_page *userpg;
-	struct ring_buffer *rb;
+	struct perf_buffer *rb;
 
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
@@ -5464,7 +5464,7 @@ void __weak arch_perf_update_userpage(
 void perf_event_update_userpage(struct perf_event *event)
 {
 	struct perf_event_mmap_page *userpg;
-	struct ring_buffer *rb;
+	struct perf_buffer *rb;
 	u64 enabled, running, now;
 
 	rcu_read_lock();
@@ -5515,7 +5515,7 @@ EXPORT_SYMBOL_GPL(perf_event_update_userpage);
 static vm_fault_t perf_mmap_fault(struct vm_fault *vmf)
 {
 	struct perf_event *event = vmf->vma->vm_file->private_data;
-	struct ring_buffer *rb;
+	struct perf_buffer *rb;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
 	if (vmf->flags & FAULT_FLAG_MKWRITE) {
@@ -5548,9 +5548,9 @@ static vm_fault_t perf_mmap_fault(struct vm_fault *vmf)
 }
 
 static void ring_buffer_attach(struct perf_event *event,
-			       struct ring_buffer *rb)
+			       struct perf_buffer *rb)
 {
-	struct ring_buffer *old_rb = NULL;
+	struct perf_buffer *old_rb = NULL;
 	unsigned long flags;
 
 	if (event->rb) {
@@ -5608,7 +5608,7 @@ static void ring_buffer_attach(struct perf_event *event,
 
 static void ring_buffer_wakeup(struct perf_event *event)
 {
-	struct ring_buffer *rb;
+	struct perf_buffer *rb;
 
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
@@ -5619,9 +5619,9 @@ static void ring_buffer_wakeup(struct perf_event *event)
 	rcu_read_unlock();
 }
 
-struct ring_buffer *ring_buffer_get(struct perf_event *event)
+struct perf_buffer *ring_buffer_get(struct perf_event *event)
 {
-	struct ring_buffer *rb;
+	struct perf_buffer *rb;
 
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
@@ -5634,7 +5634,7 @@ struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	return rb;
 }
 
-void ring_buffer_put(struct ring_buffer *rb)
+void ring_buffer_put(struct perf_buffer *rb)
 {
 	if (!refcount_dec_and_test(&rb->refcount))
 		return;
@@ -5672,7 +5672,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
-	struct ring_buffer *rb = ring_buffer_get(event);
+	struct perf_buffer *rb = ring_buffer_get(event);
 	struct user_struct *mmap_user = rb->mmap_user;
 	int mmap_locked = rb->mmap_locked;
 	unsigned long size = perf_data_size(rb);
@@ -5790,8 +5790,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	struct perf_event *event = file->private_data;
 	unsigned long user_locked, user_lock_limit;
 	struct user_struct *user = current_user();
+	struct perf_buffer *rb = NULL;
 	unsigned long locked, lock_limit;
-	struct ring_buffer *rb = NULL;
 	unsigned long vma_size;
 	unsigned long nr_pages;
 	long user_extra = 0, extra = 0;
@@ -6266,7 +6266,7 @@ static unsigned long perf_prepare_sample_aux(struct perf_event *event,
 					  size_t size)
 {
 	struct perf_event *sampler = event->aux_event;
-	struct ring_buffer *rb;
+	struct perf_buffer *rb;
 
 	data->aux_size = 0;
 
@@ -6299,7 +6299,7 @@ static unsigned long perf_prepare_sample_aux(struct perf_event *event,
 	return data->aux_size;
 }
 
-long perf_pmu_snapshot_aux(struct ring_buffer *rb,
+long perf_pmu_snapshot_aux(struct perf_buffer *rb,
 			   struct perf_event *event,
 			   struct perf_output_handle *handle,
 			   unsigned long size)
@@ -6338,8 +6338,8 @@ static void perf_aux_sample_output(struct perf_event *event,
 				   struct perf_sample_data *data)
 {
 	struct perf_event *sampler = event->aux_event;
+	struct perf_buffer *rb;
 	unsigned long pad;
-	struct ring_buffer *rb;
 	long size;
 
 	if (WARN_ON_ONCE(!sampler || !data->aux_size))
@@ -6707,7 +6707,7 @@ void perf_output_sample(struct perf_output_handle *handle,
 		int wakeup_events = event->attr.wakeup_events;
 
 		if (wakeup_events) {
-			struct ring_buffer *rb = handle->rb;
+			struct perf_buffer *rb = handle->rb;
 			int events = local_inc_return(&rb->events);
 
 			if (events >= wakeup_events) {
@@ -7150,7 +7150,7 @@ void perf_event_exec(void)
 }
 
 struct remote_output {
-	struct ring_buffer	*rb;
+	struct perf_buffer	*rb;
 	int			err;
 };
 
@@ -7158,7 +7158,7 @@ static void __perf_event_output_stop(struct perf_event *event, void *data)
 {
 	struct perf_event *parent = event->parent;
 	struct remote_output *ro = data;
-	struct ring_buffer *rb = ro->rb;
+	struct perf_buffer *rb = ro->rb;
 	struct stop_event_data sd = {
 		.event	= event,
 	};
@@ -10998,7 +10998,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
-	struct ring_buffer *rb = NULL;
+	struct perf_buffer *rb = NULL;
 	int ret = -EINVAL;
 
 	if (!output_event)
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 747d67f130cb..f16f66b6b655 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -10,7 +10,7 @@
 
 #define RING_BUFFER_WRITABLE		0x01
 
-struct ring_buffer {
+struct perf_buffer {
 	refcount_t			refcount;
 	struct rcu_head			rcu_head;
 #ifdef CONFIG_PERF_USE_VMALLOC
@@ -58,17 +58,17 @@ struct ring_buffer {
 	void				*data_pages[0];
 };
 
-extern void rb_free(struct ring_buffer *rb);
+extern void rb_free(struct perf_buffer *rb);
 
 static inline void rb_free_rcu(struct rcu_head *rcu_head)
 {
-	struct ring_buffer *rb;
+	struct perf_buffer *rb;
 
-	rb = container_of(rcu_head, struct ring_buffer, rcu_head);
+	rb = container_of(rcu_head, struct perf_buffer, rcu_head);
 	rb_free(rb);
 }
 
-static inline void rb_toggle_paused(struct ring_buffer *rb, bool pause)
+static inline void rb_toggle_paused(struct perf_buffer *rb, bool pause)
 {
 	if (!pause && rb->nr_pages)
 		rb->paused = 0;
@@ -76,16 +76,16 @@ static inline void rb_toggle_paused(struct ring_buffer *rb, bool pause)
 		rb->paused = 1;
 }
 
-extern struct ring_buffer *
+extern struct perf_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags);
 extern void perf_event_wakeup(struct perf_event *event);
-extern int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
+extern int rb_alloc_aux(struct perf_buffer *rb, struct perf_event *event,
 			pgoff_t pgoff, int nr_pages, long watermark, int flags);
-extern void rb_free_aux(struct ring_buffer *rb);
-extern struct ring_buffer *ring_buffer_get(struct perf_event *event);
-extern void ring_buffer_put(struct ring_buffer *rb);
+extern void rb_free_aux(struct perf_buffer *rb);
+extern struct perf_buffer *ring_buffer_get(struct perf_event *event);
+extern void ring_buffer_put(struct perf_buffer *rb);
 
-static inline bool rb_has_aux(struct ring_buffer *rb)
+static inline bool rb_has_aux(struct perf_buffer *rb)
 {
 	return !!rb->aux_nr_pages;
 }
@@ -94,7 +94,7 @@ void perf_event_aux_event(struct perf_event *event, unsigned long head,
 			  unsigned long size, u64 flags);
 
 extern struct page *
-perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff);
+perf_mmap_to_page(struct perf_buffer *rb, unsigned long pgoff);
 
 #ifdef CONFIG_PERF_USE_VMALLOC
 /*
@@ -103,25 +103,25 @@ perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff);
  * Required for architectures that have d-cache aliasing issues.
  */
 
-static inline int page_order(struct ring_buffer *rb)
+static inline int page_order(struct perf_buffer *rb)
 {
 	return rb->page_order;
 }
 
 #else
 
-static inline int page_order(struct ring_buffer *rb)
+static inline int page_order(struct perf_buffer *rb)
 {
 	return 0;
 }
 #endif
 
-static inline unsigned long perf_data_size(struct ring_buffer *rb)
+static inline unsigned long perf_data_size(struct perf_buffer *rb)
 {
 	return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
 }
 
-static inline unsigned long perf_aux_size(struct ring_buffer *rb)
+static inline unsigned long perf_aux_size(struct perf_buffer *rb)
 {
 	return rb->aux_nr_pages << PAGE_SHIFT;
 }
@@ -141,7 +141,7 @@ static inline unsigned long perf_aux_size(struct ring_buffer *rb)
 			buf += written;					\
 		handle->size -= written;				\
 		if (!handle->size) {					\
-			struct ring_buffer *rb = handle->rb;		\
+			struct perf_buffer *rb = handle->rb;	\
 									\
 			handle->page++;					\
 			handle->page &= rb->nr_pages - 1;		\
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 7ffd5c763f93..192b8abc6330 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -35,7 +35,7 @@ static void perf_output_wakeup(struct perf_output_handle *handle)
  */
 static void perf_output_get_handle(struct perf_output_handle *handle)
 {
-	struct ring_buffer *rb = handle->rb;
+	struct perf_buffer *rb = handle->rb;
 
 	preempt_disable();
 
@@ -49,7 +49,7 @@ static void perf_output_get_handle(struct perf_output_handle *handle)
 
 static void perf_output_put_handle(struct perf_output_handle *handle)
 {
-	struct ring_buffer *rb = handle->rb;
+	struct perf_buffer *rb = handle->rb;
 	unsigned long head;
 	unsigned int nest;
 
@@ -150,7 +150,7 @@ __perf_output_begin(struct perf_output_handle *handle,
 		    struct perf_event *event, unsigned int size,
 		    bool backward)
 {
-	struct ring_buffer *rb;
+	struct perf_buffer *rb;
 	unsigned long tail, offset, head;
 	int have_lost, page_shift;
 	struct {
@@ -301,7 +301,7 @@ void perf_output_end(struct perf_output_handle *handle)
 }
 
 static void
-ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
+ring_buffer_init(struct perf_buffer *rb, long watermark, int flags)
 {
 	long max_size = perf_data_size(rb);
 
@@ -361,7 +361,7 @@ void *perf_aux_output_begin(struct perf_output_handle *handle,
 {
 	struct perf_event *output_event = event;
 	unsigned long aux_head, aux_tail;
-	struct ring_buffer *rb;
+	struct perf_buffer *rb;
 	unsigned int nest;
 
 	if (output_event->parent)
@@ -449,7 +449,7 @@ void *perf_aux_output_begin(struct perf_output_handle *handle,
 }
 EXPORT_SYMBOL_GPL(perf_aux_output_begin);
 
-static __always_inline bool rb_need_aux_wakeup(struct ring_buffer *rb)
+static __always_inline bool rb_need_aux_wakeup(struct perf_buffer *rb)
 {
 	if (rb->aux_overwrite)
 		return false;
@@ -475,7 +475,7 @@ static __always_inline bool rb_need_aux_wakeup(struct ring_buffer *rb)
 void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size)
 {
 	bool wakeup = !!(handle->aux_flags & PERF_AUX_FLAG_TRUNCATED);
-	struct ring_buffer *rb = handle->rb;
+	struct perf_buffer *rb = handle->rb;
 	unsigned long aux_head;
 
 	/* in overwrite mode, driver provides aux_head via handle */
@@ -532,7 +532,7 @@ EXPORT_SYMBOL_GPL(perf_aux_output_end);
  */
 int perf_aux_output_skip(struct perf_output_handle *handle, unsigned long size)
 {
-	struct ring_buffer *rb = handle->rb;
+	struct perf_buffer *rb = handle->rb;
 
 	if (size > handle->size)
 		return -ENOSPC;
@@ -569,8 +569,8 @@ long perf_output_copy_aux(struct perf_output_handle *aux_handle,
 			  struct perf_output_handle *handle,
 			  unsigned long from, unsigned long to)
 {
+	struct perf_buffer *rb = aux_handle->rb;
 	unsigned long tocopy, remainder, len = 0;
-	struct ring_buffer *rb = aux_handle->rb;
 	void *addr;
 
 	from &= (rb->aux_nr_pages << PAGE_SHIFT) - 1;
@@ -626,7 +626,7 @@ static struct page *rb_alloc_aux_page(int node, int order)
 	return page;
 }
 
-static void rb_free_aux_page(struct ring_buffer *rb, int idx)
+static void rb_free_aux_page(struct perf_buffer *rb, int idx)
 {
 	struct page *page = virt_to_page(rb->aux_pages[idx]);
 
@@ -635,7 +635,7 @@ static void rb_free_aux_page(struct ring_buffer *rb, int idx)
 	__free_page(page);
 }
 
-static void __rb_free_aux(struct ring_buffer *rb)
+static void __rb_free_aux(struct perf_buffer *rb)
 {
 	int pg;
 
@@ -662,7 +662,7 @@ static void __rb_free_aux(struct ring_buffer *rb)
 	}
 }
 
-int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
+int rb_alloc_aux(struct perf_buffer *rb, struct perf_event *event,
 		 pgoff_t pgoff, int nr_pages, long watermark, int flags)
 {
 	bool overwrite = !(flags & RING_BUFFER_WRITABLE);
@@ -753,7 +753,7 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 	return ret;
 }
 
-void rb_free_aux(struct ring_buffer *rb)
+void rb_free_aux(struct perf_buffer *rb)
 {
 	if (refcount_dec_and_test(&rb->aux_refcount))
 		__rb_free_aux(rb);
@@ -766,7 +766,7 @@ void rb_free_aux(struct ring_buffer *rb)
  */
 
 static struct page *
-__perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+__perf_mmap_to_page(struct perf_buffer *rb, unsigned long pgoff)
 {
 	if (pgoff > rb->nr_pages)
 		return NULL;
@@ -798,13 +798,13 @@ static void perf_mmap_free_page(void *addr)
 	__free_page(page);
 }
 
-struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
+struct perf_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
-	struct ring_buffer *rb;
+	struct perf_buffer *rb;
 	unsigned long size;
 	int i;
 
-	size = sizeof(struct ring_buffer);
+	size = sizeof(struct perf_buffer);
 	size += nr_pages * sizeof(void *);
 
 	if (order_base_2(size) >= PAGE_SHIFT+MAX_ORDER)
@@ -843,7 +843,7 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 	return NULL;
 }
 
-void rb_free(struct ring_buffer *rb)
+void rb_free(struct perf_buffer *rb)
 {
 	int i;
 
@@ -854,13 +854,13 @@ void rb_free(struct ring_buffer *rb)
 }
 
 #else
-static int data_page_nr(struct ring_buffer *rb)
+static int data_page_nr(struct perf_buffer *rb)
 {
 	return rb->nr_pages << page_order(rb);
 }
 
 static struct page *
-__perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+__perf_mmap_to_page(struct perf_buffer *rb, unsigned long pgoff)
 {
 	/* The '>' counts in the user page. */
 	if (pgoff > data_page_nr(rb))
@@ -878,11 +878,11 @@ static void perf_mmap_unmark_page(void *addr)
 
 static void rb_free_work(struct work_struct *work)
 {
-	struct ring_buffer *rb;
+	struct perf_buffer *rb;
 	void *base;
 	int i, nr;
 
-	rb = container_of(work, struct ring_buffer, work);
+	rb = container_of(work, struct perf_buffer, work);
 	nr = data_page_nr(rb);
 
 	base = rb->user_page;
@@ -894,18 +894,18 @@ static void rb_free_work(struct work_struct *work)
 	kfree(rb);
 }
 
-void rb_free(struct ring_buffer *rb)
+void rb_free(struct perf_buffer *rb)
 {
 	schedule_work(&rb->work);
 }
 
-struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
+struct perf_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 {
-	struct ring_buffer *rb;
+	struct perf_buffer *rb;
 	unsigned long size;
 	void *all_buf;
 
-	size = sizeof(struct ring_buffer);
+	size = sizeof(struct perf_buffer);
 	size += sizeof(void *);
 
 	rb = kzalloc(size, GFP_KERNEL);
@@ -939,7 +939,7 @@ struct ring_buffer *rb_alloc(int nr_pages, long watermark, int cpu, int flags)
 #endif
 
 struct page *
-perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+perf_mmap_to_page(struct perf_buffer *rb, unsigned long pgoff)
 {
 	if (rb->aux_nr_pages) {
 		/* above AUX space */
-- 
2.24.0


