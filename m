Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAC4559AF5
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbiFXOGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiFXOGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:06:10 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC474EDE1;
        Fri, 24 Jun 2022 07:06:06 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LTzRD4zf8zDsNj;
        Fri, 24 Jun 2022 22:05:28 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:04 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:03 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <mark.rutland@arm.com>, <alexander.shishkin@linux.intel.com>,
        <jolsa@kernel.org>, <namhyung@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <irogers@google.com>,
        <davemarchevsky@fb.com>, <adrian.hunter@intel.com>,
        <alexandre.truong@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <yangjihong1@huawei.com>
Subject: [RFC v2 06/17] perf kwork: Implement perf kwork report
Date:   Fri, 24 Jun 2022 22:03:38 +0800
Message-ID: <20220624140349.16964-7-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
In-Reply-To: <20220624140349.16964-1-yangjihong1@huawei.com>
References: <20220624140349.16964-1-yangjihong1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implements framework of perf kwork report, which is used to report time
properties such as run time and frequency:

Test cases:

  # perf kwork

   Usage: perf kwork [<options>] {record|report}

      -D, --dump-raw-trace  dump raw trace in ASCII
      -f, --force           don't complain, do it
      -k, --kwork <kwork>   list of kwork to profile (irq, softirq, workqueue, etc)
      -v, --verbose         be more verbose (show symbol address, etc)

  # perf kwork report -h

   Usage: perf kwork report [<options>]

      -C, --cpu <cpu>       list of cpus to profile
      -i, --input <file>    input file name
      -n, --name <name>     event name to profile
      -s, --sort <key[,key2...]>
                            sort by key(s): runtime, max, count
      -S, --with-summary    Show summary with statistics
          --time <str>      Time span for analysis (start,stop)

  # perf kwork report

    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
   --------------------------------------------------------------------------------------------------------------------------------

  # perf kwork report -S

    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
   --------------------------------------------------------------------------------------------------------------------------------
    Total count            :         0
    Total runtime   (msec) :     0.000 (0.000% load average)
    Total time span (msec) :     0.000
   --------------------------------------------------------------------------------------------------------------------------------

  # perf kwork report -C 0,100
  Requested CPU 100 too large. Consider raising MAX_NR_CPUS
  Invalid cpu bitmap

  # perf kwork report -s runtime1
    Error: Unknown --sort key: `runtime1'

   Usage: perf kwork report [<options>]

      -C, --cpu <cpu>       list of cpus to profile
      -i, --input <file>    input file name
      -n, --name <name>     event name to profile
      -s, --sort <key[,key2...]>
                            sort by key(s): runtime, max, count
      -S, --with-summary    Show summary with statistics
          --time <str>      Time span for analysis (start,stop)

  # perf kwork report -i perf_no_exist.data
  failed to open perf_no_exist.data: No such file or directory

  # perf kwork report --time 00FFF,
  Invalid time span

Since there are no report supported events, the output is empty.

Briefly describe the data structure:
1. "class" indicates event type. For example, irq and softiq correspond
to different types.
2. "cluster" refers to a specific event corresponding to a type. For
example, RCU and TIMER in softirq correspond to different clusters,
which contains three types of events: raise, entry, and exit.
3. "atom" includes time of each sample and sample of the previous phase.
(For example, exit corresponds to entry, which is used for timehist.)

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/perf/Documentation/perf-kwork.txt |  33 +
 tools/perf/builtin-kwork.c              | 859 +++++++++++++++++++++++-
 tools/perf/util/kwork.h                 | 161 +++++
 3 files changed, 1051 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-kwork.txt b/tools/perf/Documentation/perf-kwork.txt
index c5b52f61da99..b79b2c0d047e 100644
--- a/tools/perf/Documentation/perf-kwork.txt
+++ b/tools/perf/Documentation/perf-kwork.txt
@@ -17,8 +17,11 @@ There are several variants of 'perf kwork':
   'perf kwork record <command>' to record the kernel work
   of an arbitrary workload.
 
+  'perf kwork report' to report the per kwork runtime.
+
     Example usage:
         perf kwork record -- sleep 1
+        perf kwork report
 
 OPTIONS
 -------
@@ -38,6 +41,36 @@ OPTIONS
 --verbose::
 	Be more verbose. (show symbol address, etc)
 
+OPTIONS for 'perf kwork report'
+----------------------------
+
+-C::
+--cpu::
+	Only show events for the given CPU(s) (comma separated list).
+
+-i::
+--input::
+	Input file name. (default: perf.data unless stdin is a fifo)
+
+-n::
+--name::
+	Only show events for the given name.
+
+-s::
+--sort::
+	Sort by key(s): runtime, max, count
+
+-S::
+--with-summary::
+	Show summary with statistics
+
+--time::
+	Only analyze samples within given time window: <start>,<stop>. Times
+	have the format seconds.microseconds. If start is not given (i.e., time
+	string is ',x.y') then analysis starts at the beginning of the file. If
+	stop time is not given (i.e, time string is 'x.y,') then analysis goes
+	to end of file.
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/builtin-kwork.c b/tools/perf/builtin-kwork.c
index 8086236b7513..9c488d647995 100644
--- a/tools/perf/builtin-kwork.c
+++ b/tools/perf/builtin-kwork.c
@@ -25,6 +25,460 @@
 #include <linux/time64.h>
 #include <linux/zalloc.h>
 
+/*
+ * report header elements width
+ */
+#define PRINT_CPU_WIDTH 4
+#define PRINT_COUNT_WIDTH 9
+#define PRINT_RUNTIME_WIDTH 10
+#define PRINT_TIMESTAMP_WIDTH 17
+#define PRINT_KWORK_NAME_WIDTH 30
+#define RPINT_DECIMAL_WIDTH 3
+#define PRINT_TIME_UNIT_SEC_WIDTH 2
+#define PRINT_TIME_UNIT_MESC_WIDTH 3
+#define PRINT_RUNTIME_HEADER_WIDTH (PRINT_RUNTIME_WIDTH + PRINT_TIME_UNIT_MESC_WIDTH)
+#define PRINT_TIMESTAMP_HEADER_WIDTH (PRINT_TIMESTAMP_WIDTH + PRINT_TIME_UNIT_SEC_WIDTH)
+
+struct sort_dimension {
+	const char      *name;
+	int             (*cmp)(struct kwork_work *l, struct kwork_work *r);
+	struct          list_head list;
+};
+
+static int id_cmp(struct kwork_work *l, struct kwork_work *r)
+{
+	if (l->cpu > r->cpu)
+		return 1;
+	if (l->cpu < r->cpu)
+		return -1;
+
+	if (l->id > r->id)
+		return 1;
+	if (l->id < r->id)
+		return -1;
+
+	return 0;
+}
+
+static int count_cmp(struct kwork_work *l, struct kwork_work *r)
+{
+	if (l->nr_atoms > r->nr_atoms)
+		return 1;
+	if (l->nr_atoms < r->nr_atoms)
+		return -1;
+
+	return 0;
+}
+
+static int runtime_cmp(struct kwork_work *l, struct kwork_work *r)
+{
+	if (l->total_runtime > r->total_runtime)
+		return 1;
+	if (l->total_runtime < r->total_runtime)
+		return -1;
+
+	return 0;
+}
+
+static int max_runtime_cmp(struct kwork_work *l, struct kwork_work *r)
+{
+	if (l->max_runtime > r->max_runtime)
+		return 1;
+	if (l->max_runtime < r->max_runtime)
+		return -1;
+
+	return 0;
+}
+
+static int sort_dimension__add(struct perf_kwork *kwork __maybe_unused,
+			       const char *tok, struct list_head *list)
+{
+	size_t i;
+	static struct sort_dimension max_sort_dimension = {
+		.name = "max",
+		.cmp  = max_runtime_cmp,
+	};
+	static struct sort_dimension id_sort_dimension = {
+		.name = "id",
+		.cmp  = id_cmp,
+	};
+	static struct sort_dimension runtime_sort_dimension = {
+		.name = "runtime",
+		.cmp  = runtime_cmp,
+	};
+	static struct sort_dimension count_sort_dimension = {
+		.name = "count",
+		.cmp  = count_cmp,
+	};
+	struct sort_dimension *available_sorts[] = {
+		&id_sort_dimension,
+		&max_sort_dimension,
+		&count_sort_dimension,
+		&runtime_sort_dimension,
+	};
+
+	for (i = 0; i < ARRAY_SIZE(available_sorts); i++) {
+		if (!strcmp(available_sorts[i]->name, tok)) {
+			list_add_tail(&available_sorts[i]->list, list);
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static void setup_sorting(struct perf_kwork *kwork,
+			  const struct option *options,
+			  const char * const usage_msg[])
+{
+	char *tmp, *tok, *str = strdup(kwork->sort_order);
+
+	for (tok = strtok_r(str, ", ", &tmp);
+	     tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		if (sort_dimension__add(kwork, tok, &kwork->sort_list) < 0)
+			usage_with_options_msg(usage_msg, options,
+					       "Unknown --sort key: `%s'", tok);
+	}
+
+	pr_debug("Sort order: %s\n", kwork->sort_order);
+	free(str);
+}
+
+static struct kwork_atom *atom_new(struct perf_kwork *kwork,
+				   struct perf_sample *sample)
+{
+	unsigned long i;
+	struct kwork_atom_page *page;
+	struct kwork_atom *atom = NULL;
+
+	list_for_each_entry(page, &kwork->atom_page_list, list) {
+		if (!bitmap_full(page->bitmap, NR_ATOM_PER_PAGE)) {
+			i = find_first_zero_bit(page->bitmap, NR_ATOM_PER_PAGE);
+			BUG_ON(i >= NR_ATOM_PER_PAGE);
+			atom = &page->atoms[i];
+			goto found_atom;
+		}
+	}
+
+	/*
+	 * new page
+	 */
+	page = zalloc(sizeof(*page));
+	if (page == NULL) {
+		pr_err("Failed to zalloc kwork atom page\n");
+		return NULL;
+	}
+
+	i = 0;
+	atom = &page->atoms[0];
+	list_add_tail(&page->list, &kwork->atom_page_list);
+
+found_atom:
+	set_bit(i, page->bitmap);
+	atom->time = sample->time;
+	atom->prev = NULL;
+	atom->page_addr = page;
+	atom->bit_inpage = i;
+	return atom;
+}
+
+static void atom_free(struct kwork_atom *atom)
+{
+	if (atom->prev != NULL)
+		atom_free(atom->prev);
+
+	clear_bit(atom->bit_inpage,
+		  ((struct kwork_atom_page *)atom->page_addr)->bitmap);
+}
+
+static void atom_del(struct kwork_atom *atom)
+{
+	list_del(&atom->list);
+	atom_free(atom);
+}
+
+static int work_cmp(struct list_head *list,
+		    struct kwork_work *l, struct kwork_work *r)
+{
+	int ret = 0;
+	struct sort_dimension *sort;
+
+	BUG_ON(list_empty(list));
+
+	list_for_each_entry(sort, list, list) {
+		ret = sort->cmp(l, r);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+static struct kwork_work *work_search(struct rb_root_cached *root,
+				      struct kwork_work *key,
+				      struct list_head *sort_list)
+{
+	int cmp;
+	struct kwork_work *work;
+	struct rb_node *node = root->rb_root.rb_node;
+
+	while (node) {
+		work = container_of(node, struct kwork_work, node);
+		cmp = work_cmp(sort_list, key, work);
+		if (cmp > 0)
+			node = node->rb_left;
+		else if (cmp < 0)
+			node = node->rb_right;
+		else {
+			if (work->name == NULL)
+				work->name = key->name;
+			return work;
+		}
+	}
+	return NULL;
+}
+
+static void work_insert(struct rb_root_cached *root,
+			struct kwork_work *key, struct list_head *sort_list)
+{
+	int cmp;
+	bool leftmost = true;
+	struct kwork_work *cur;
+	struct rb_node **new = &(root->rb_root.rb_node), *parent = NULL;
+
+	while (*new) {
+		cur = container_of(*new, struct kwork_work, node);
+		parent = *new;
+		cmp = work_cmp(sort_list, key, cur);
+
+		if (cmp > 0)
+			new = &((*new)->rb_left);
+		else {
+			new = &((*new)->rb_right);
+			leftmost = false;
+		}
+	}
+
+	rb_link_node(&key->node, parent, new);
+	rb_insert_color_cached(&key->node, root, leftmost);
+}
+
+static struct kwork_work *work_new(struct kwork_work *key)
+{
+	int i;
+	struct kwork_work *work = zalloc(sizeof(*work));
+
+	if (work == NULL) {
+		pr_err("Failed to zalloc kwork work\n");
+		return NULL;
+	}
+
+	for (i = 0; i < KWORK_TRACE_MAX; i++)
+		INIT_LIST_HEAD(&work->atom_list[i]);
+
+	work->id = key->id;
+	work->cpu = key->cpu;
+	work->name = key->name;
+	work->class = key->class;
+	return work;
+}
+
+static struct kwork_work *work_findnew(struct rb_root_cached *root,
+				       struct kwork_work *key,
+				       struct list_head *sort_list)
+{
+	struct kwork_work *work = NULL;
+
+	work = work_search(root, key, sort_list);
+	if (work != NULL)
+		return work;
+
+	work = work_new(key);
+	if (work == NULL)
+		return NULL;
+
+	work_insert(root, work, sort_list);
+	return work;
+}
+
+static void profile_update_timespan(struct perf_kwork *kwork,
+				    struct perf_sample *sample)
+{
+	if (!kwork->summary)
+		return;
+
+	if ((kwork->timestart == 0) || (kwork->timestart > sample->time))
+		kwork->timestart = sample->time;
+
+	if (kwork->timeend < sample->time)
+		kwork->timeend = sample->time;
+}
+
+static bool profile_event_match(struct perf_kwork *kwork,
+				struct kwork_work *work,
+				struct perf_sample *sample)
+{
+	int cpu = work->cpu;
+	u64 time = sample->time;
+	struct perf_time_interval *ptime = &kwork->ptime;
+
+	if ((kwork->cpu_list != NULL) && !test_bit(cpu, kwork->cpu_bitmap))
+		return false;
+
+	if (((ptime->start != 0) && (ptime->start > time)) ||
+	    ((ptime->end != 0) && (ptime->end < time)))
+		return false;
+
+	if ((kwork->profile_name != NULL) &&
+	    (work->name != NULL) &&
+	    (strcmp(work->name, kwork->profile_name) != 0))
+		return false;
+
+	profile_update_timespan(kwork, sample);
+	return true;
+}
+
+static int work_push_atom(struct perf_kwork *kwork,
+			  struct kwork_class *class,
+			  enum kwork_trace_type src_type,
+			  enum kwork_trace_type dst_type,
+			  struct evsel *evsel,
+			  struct perf_sample *sample,
+			  struct machine *machine,
+			  struct kwork_work **ret_work)
+{
+	struct kwork_atom *atom, *dst_atom;
+	struct kwork_work *work, key;
+
+	BUG_ON(class->work_init == NULL);
+	class->work_init(class, &key, evsel, sample, machine);
+
+	atom = atom_new(kwork, sample);
+	if (atom == NULL)
+		return -1;
+
+	work = work_findnew(&class->work_root, &key, &kwork->cmp_id);
+	if (work == NULL) {
+		free(atom);
+		return -1;
+	}
+
+	if (!profile_event_match(kwork, work, sample))
+		return 0;
+
+	if ((dst_type >= 0) && (dst_type < KWORK_TRACE_MAX)) {
+		dst_atom = list_last_entry_or_null(&work->atom_list[dst_type],
+						   struct kwork_atom, list);
+		if (dst_atom != NULL) {
+			atom->prev = dst_atom;
+			list_del(&dst_atom->list);
+		}
+	}
+
+	if (ret_work != NULL)
+		*ret_work = work;
+
+	list_add_tail(&atom->list, &work->atom_list[src_type]);
+
+	return 0;
+}
+
+static struct kwork_atom *work_pop_atom(struct perf_kwork *kwork,
+					struct kwork_class *class,
+					enum kwork_trace_type src_type,
+					enum kwork_trace_type dst_type,
+					struct evsel *evsel,
+					struct perf_sample *sample,
+					struct machine *machine,
+					struct kwork_work **ret_work)
+{
+	struct kwork_atom *atom, *src_atom;
+	struct kwork_work *work, key;
+
+	BUG_ON(class->work_init == NULL);
+	class->work_init(class, &key, evsel, sample, machine);
+
+	work = work_findnew(&class->work_root, &key, &kwork->cmp_id);
+	if (ret_work != NULL)
+		*ret_work = work;
+
+	if (work == NULL)
+		return NULL;
+
+	if (!profile_event_match(kwork, work, sample))
+		return NULL;
+
+	atom = list_last_entry_or_null(&work->atom_list[dst_type],
+				       struct kwork_atom, list);
+	if (atom != NULL)
+		return atom;
+
+	src_atom = atom_new(kwork, sample);
+	if (src_atom != NULL)
+		list_add_tail(&src_atom->list, &work->atom_list[src_type]);
+	else {
+		if (ret_work != NULL)
+			*ret_work = NULL;
+	}
+
+	return NULL;
+}
+
+static void report_update_exit_event(struct kwork_work *work,
+				     struct kwork_atom *atom,
+				     struct perf_sample *sample)
+{
+	u64 delta;
+	u64 exit_time = sample->time;
+	u64 entry_time = atom->time;
+
+	if ((entry_time != 0) && (exit_time >= entry_time)) {
+		delta = exit_time - entry_time;
+		if ((delta > work->max_runtime) ||
+		    (work->max_runtime == 0)) {
+			work->max_runtime = delta;
+			work->max_runtime_start = entry_time;
+			work->max_runtime_end = exit_time;
+		}
+		work->total_runtime += delta;
+		work->nr_atoms++;
+	}
+}
+
+static int report_entry_event(struct perf_kwork *kwork,
+			      struct kwork_class *class,
+			      struct evsel *evsel,
+			      struct perf_sample *sample,
+			      struct machine *machine)
+{
+	return work_push_atom(kwork, class, KWORK_TRACE_ENTRY,
+			      KWORK_TRACE_MAX, evsel, sample,
+			      machine, NULL);
+}
+
+static int report_exit_event(struct perf_kwork *kwork,
+			     struct kwork_class *class,
+			     struct evsel *evsel,
+			     struct perf_sample *sample,
+			     struct machine *machine)
+{
+	struct kwork_atom *atom = NULL;
+	struct kwork_work *work = NULL;
+
+	atom = work_pop_atom(kwork, class, KWORK_TRACE_EXIT,
+			     KWORK_TRACE_ENTRY, evsel, sample,
+			     machine, &work);
+	if (work == NULL)
+		return -1;
+
+	if (atom != NULL) {
+		report_update_exit_event(work, atom, sample);
+		atom_del(atom);
+	}
+
+	return 0;
+}
+
 const struct evsel_str_handler irq_tp_handlers[] = {
 	{ "irq:irq_handler_entry", NULL, },
 	{ "irq:irq_handler_exit",  NULL, },
@@ -69,6 +523,351 @@ static struct kwork_class *kwork_class_supported_list[KWORK_CLASS_MAX] = {
 	[KWORK_CLASS_WORKQUEUE] = &kwork_workqueue,
 };
 
+static void print_separator(int len)
+{
+	printf(" %.*s\n", len, graph_dotted_line);
+}
+
+static void report_print_work(struct perf_kwork *kwork,
+			      struct kwork_work *work)
+{
+	int ret = 0;
+	char kwork_name[PRINT_KWORK_NAME_WIDTH];
+	char max_runtime_start[32], max_runtime_end[32];
+
+	printf(" ");
+
+	/*
+	 * kwork name
+	 */
+	if (work->class && work->class->work_name) {
+		work->class->work_name(work, kwork_name,
+				       PRINT_KWORK_NAME_WIDTH);
+		ret += printf(" %-*s |", PRINT_KWORK_NAME_WIDTH, kwork_name);
+	} else
+		ret += printf(" %-*s |", PRINT_KWORK_NAME_WIDTH, "");
+
+	/*
+	 * cpu
+	 */
+	ret += printf(" %0*d |", PRINT_CPU_WIDTH, work->cpu);
+
+	/*
+	 * total runtime
+	 */
+	if (kwork->report == KWORK_REPORT_RUNTIME)
+		ret += printf(" %*.*f ms |",
+			      PRINT_RUNTIME_WIDTH, RPINT_DECIMAL_WIDTH,
+			      (double)work->total_runtime / NSEC_PER_MSEC);
+
+	/*
+	 * count
+	 */
+	ret += printf(" %*" PRIu64 " |", PRINT_COUNT_WIDTH, work->nr_atoms);
+
+	/*
+	 * max runtime, max runtime start, max runtime end
+	 */
+	if (kwork->report == KWORK_REPORT_RUNTIME) {
+
+		timestamp__scnprintf_usec(work->max_runtime_start,
+					  max_runtime_start,
+					  sizeof(max_runtime_start));
+		timestamp__scnprintf_usec(work->max_runtime_end,
+					  max_runtime_end,
+					  sizeof(max_runtime_end));
+		ret += printf(" %*.*f ms | %*s s | %*s s |",
+			      PRINT_RUNTIME_WIDTH, RPINT_DECIMAL_WIDTH,
+			      (double)work->max_runtime / NSEC_PER_MSEC,
+			      PRINT_TIMESTAMP_WIDTH, max_runtime_start,
+			      PRINT_TIMESTAMP_WIDTH, max_runtime_end);
+	}
+
+	printf("\n");
+}
+
+static int report_print_header(struct perf_kwork *kwork)
+{
+	int ret;
+
+	printf("\n ");
+	ret = printf(" %-*s | %-*s |",
+		     PRINT_KWORK_NAME_WIDTH, "Kwork Name",
+		     PRINT_CPU_WIDTH, "Cpu");
+
+	if (kwork->report == KWORK_REPORT_RUNTIME)
+		ret += printf(" %-*s |",
+			      PRINT_RUNTIME_HEADER_WIDTH, "Total Runtime");
+
+	ret += printf(" %-*s |", PRINT_COUNT_WIDTH, "Count");
+
+	if (kwork->report == KWORK_REPORT_RUNTIME)
+		ret += printf(" %-*s | %-*s | %-*s |",
+			      PRINT_RUNTIME_HEADER_WIDTH, "Max runtime",
+			      PRINT_TIMESTAMP_HEADER_WIDTH, "Max runtime start",
+			      PRINT_TIMESTAMP_HEADER_WIDTH, "Max runtime end");
+
+	printf("\n");
+	print_separator(ret);
+	return ret;
+}
+
+static void print_summary(struct perf_kwork *kwork)
+{
+	u64 time = kwork->timeend - kwork->timestart;
+
+	printf("  Total count            : %9" PRIu64 "\n", kwork->all_count);
+	printf("  Total runtime   (msec) : %9.3f (%.3f%% load average)\n",
+	       (double)kwork->all_runtime / NSEC_PER_MSEC,
+	       time == 0 ? 0 : (double)kwork->all_runtime / time);
+	printf("  Total time span (msec) : %9.3f\n",
+	       (double)time / NSEC_PER_MSEC);
+}
+
+static unsigned long long nr_list_entry(struct list_head *head)
+{
+	struct list_head *pos;
+	unsigned long long n = 0;
+
+	list_for_each(pos, head)
+		n++;
+
+	return n;
+}
+
+static void print_skipped_events(struct perf_kwork *kwork)
+{
+	int i;
+	const char *const kwork_event_str[] = {
+		[KWORK_TRACE_ENTRY] = "entry",
+		[KWORK_TRACE_EXIT]  = "exit",
+	};
+
+	if ((kwork->nr_skipped_events[KWORK_TRACE_MAX] != 0) &&
+	    (kwork->nr_events != 0)) {
+		printf("  INFO: %.3f%% skipped events (%" PRIu64 " including ",
+		       (double)kwork->nr_skipped_events[KWORK_TRACE_MAX] /
+		       (double)kwork->nr_events * 100.0,
+		       kwork->nr_skipped_events[KWORK_TRACE_MAX]);
+
+		for (i = 0; i < KWORK_TRACE_MAX; i++)
+			printf("%" PRIu64 " %s%s",
+			       kwork->nr_skipped_events[i],
+			       kwork_event_str[i],
+			       (i == KWORK_TRACE_MAX - 1) ? ")\n" : ", ");
+	}
+
+	if (verbose > 0)
+		printf("  INFO: use %lld atom pages\n",
+		       nr_list_entry(&kwork->atom_page_list));
+}
+
+static void print_bad_events(struct perf_kwork *kwork)
+{
+	if ((kwork->nr_lost_events != 0) && (kwork->nr_events != 0))
+		printf("  INFO: %.3f%% lost events (%ld out of %ld, in %ld chunks)\n",
+		       (double)kwork->nr_lost_events /
+		       (double)kwork->nr_events * 100.0,
+		       kwork->nr_lost_events, kwork->nr_events,
+		       kwork->nr_lost_chunks);
+}
+
+static void work_sort(struct perf_kwork *kwork, struct kwork_class *class)
+{
+	struct rb_node *node;
+	struct kwork_work *data;
+	struct rb_root_cached *root = &class->work_root;
+
+	pr_debug("Sorting %s ...\n", class->name);
+	for (;;) {
+		node = rb_first_cached(root);
+		if (!node)
+			break;
+
+		rb_erase_cached(node, root);
+		data = rb_entry(node, struct kwork_work, node);
+		work_insert(&kwork->sorted_work_root,
+			       data, &kwork->sort_list);
+	}
+}
+
+static void perf_kwork__sort(struct perf_kwork *kwork)
+{
+	struct kwork_class *class;
+
+	list_for_each_entry(class, &kwork->class_list, list)
+		work_sort(kwork, class);
+}
+
+static int perf_kwork__check_config(struct perf_kwork *kwork,
+				    struct perf_session *session)
+{
+	int ret;
+	struct kwork_class *class;
+
+	static struct trace_kwork_handler report_ops = {
+		.entry_event = report_entry_event,
+		.exit_event  = report_exit_event,
+	};
+
+	switch (kwork->report) {
+	case KWORK_REPORT_RUNTIME:
+		kwork->tp_handler = &report_ops;
+		break;
+	default:
+		pr_debug("Invalid report type %d\n", kwork->report);
+		return -1;
+	}
+
+	list_for_each_entry(class, &kwork->class_list, list)
+		if ((class->class_init != NULL) &&
+		    (class->class_init(class, session) != 0))
+			return -1;
+
+	if (kwork->cpu_list != NULL) {
+		ret = perf_session__cpu_bitmap(session,
+					       kwork->cpu_list,
+					       kwork->cpu_bitmap);
+		if (ret < 0) {
+			pr_err("Invalid cpu bitmap\n");
+			return -1;
+		}
+	}
+
+	if (kwork->time_str != NULL) {
+		ret = perf_time__parse_str(&kwork->ptime, kwork->time_str);
+		if (ret != 0) {
+			pr_err("Invalid time span\n");
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+static int perf_kwork__read_events(struct perf_kwork *kwork)
+{
+	int ret = -1;
+	struct perf_session *session = NULL;
+
+	struct perf_data data = {
+		.path  = input_name,
+		.mode  = PERF_DATA_MODE_READ,
+		.force = kwork->force,
+	};
+
+	session = perf_session__new(&data, &kwork->tool);
+	if (IS_ERR(session)) {
+		pr_debug("Error creating perf session\n");
+		return PTR_ERR(session);
+	}
+
+	symbol__init(&session->header.env);
+
+	if (perf_kwork__check_config(kwork, session) != 0)
+		goto out_delete;
+
+	if (session->tevent.pevent &&
+	    tep_set_function_resolver(session->tevent.pevent,
+				      machine__resolve_kernel_addr,
+				      &session->machines.host) < 0) {
+		pr_err("Failed to set libtraceevent function resolver\n");
+		goto out_delete;
+	}
+
+	ret = perf_session__process_events(session);
+	if (ret) {
+		pr_debug("Failed to process events, error %d\n", ret);
+		goto out_delete;
+	}
+
+	kwork->nr_events      = session->evlist->stats.nr_events[0];
+	kwork->nr_lost_events = session->evlist->stats.total_lost;
+	kwork->nr_lost_chunks = session->evlist->stats.nr_events[PERF_RECORD_LOST];
+
+out_delete:
+	perf_session__delete(session);
+	return ret;
+}
+
+static void process_skipped_events(struct perf_kwork *kwork,
+				   struct kwork_work *work)
+{
+	int i;
+	unsigned long long count;
+
+	for (i = 0; i < KWORK_TRACE_MAX; i++) {
+		count = nr_list_entry(&work->atom_list[i]);
+		kwork->nr_skipped_events[i] += count;
+		kwork->nr_skipped_events[KWORK_TRACE_MAX] += count;
+	}
+}
+
+static int perf_kwork__report(struct perf_kwork *kwork)
+{
+	int ret;
+	struct rb_node *next;
+	struct kwork_work *work;
+
+	ret = perf_kwork__read_events(kwork);
+	if (ret != 0)
+		return -1;
+
+	perf_kwork__sort(kwork);
+
+	setup_pager();
+
+	ret = report_print_header(kwork);
+	next = rb_first_cached(&kwork->sorted_work_root);
+	while (next) {
+		work = rb_entry(next, struct kwork_work, node);
+		process_skipped_events(kwork, work);
+
+		if (work->nr_atoms != 0) {
+			report_print_work(kwork, work);
+			if (kwork->summary) {
+				kwork->all_runtime += work->total_runtime;
+				kwork->all_count += work->nr_atoms;
+			}
+		}
+		next = rb_next(next);
+	}
+	print_separator(ret);
+
+	if (kwork->summary) {
+		print_summary(kwork);
+		print_separator(ret);
+	}
+
+	print_bad_events(kwork);
+	print_skipped_events(kwork);
+	printf("\n");
+
+	return 0;
+}
+
+typedef int (*tracepoint_handler)(struct perf_tool *tool,
+				  struct evsel *evsel,
+				  struct perf_sample *sample,
+				  struct machine *machine);
+
+static int perf_kwork__process_tracepoint_sample(struct perf_tool *tool,
+						 union perf_event *event __maybe_unused,
+						 struct perf_sample *sample,
+						 struct evsel *evsel,
+						 struct machine *machine)
+{
+	int err = 0;
+
+	if (evsel->handler != NULL) {
+		tracepoint_handler f = evsel->handler;
+
+		err = f(tool, evsel, sample, machine);
+	}
+
+	return err;
+}
+
 static void setup_event_list(struct perf_kwork *kwork,
 			     const struct option *options,
 			     const char * const usage_msg[])
@@ -161,11 +960,37 @@ static int perf_kwork__record(struct perf_kwork *kwork,
 int cmd_kwork(int argc, const char **argv)
 {
 	static struct perf_kwork kwork = {
+		.tool = {
+			.mmap    = perf_event__process_mmap,
+			.mmap2   = perf_event__process_mmap2,
+			.sample  = perf_kwork__process_tracepoint_sample,
+		},
+
 		.class_list          = LIST_HEAD_INIT(kwork.class_list),
+		.atom_page_list      = LIST_HEAD_INIT(kwork.atom_page_list),
+		.sort_list           = LIST_HEAD_INIT(kwork.sort_list),
+		.cmp_id              = LIST_HEAD_INIT(kwork.cmp_id),
+		.sorted_work_root    = RB_ROOT_CACHED,
+		.tp_handler          = NULL,
 
+		.profile_name        = NULL,
+		.cpu_list            = NULL,
+		.time_str            = NULL,
 		.force               = false,
 		.event_list_str      = NULL,
+		.summary             = false,
+		.sort_order          = NULL,
+
+		.timestart           = 0,
+		.timeend             = 0,
+		.nr_events           = 0,
+		.nr_lost_chunks      = 0,
+		.nr_lost_events      = 0,
+		.all_runtime         = 0,
+		.all_count           = 0,
+		.nr_skipped_events   = { 0 },
 	};
+	static const char default_report_sort_order[] = "runtime, max, count";
 
 	const struct option kwork_options[] = {
 	OPT_INCR('v', "verbose", &verbose,
@@ -177,13 +1002,32 @@ int cmd_kwork(int argc, const char **argv)
 	OPT_BOOLEAN('f', "force", &kwork.force, "don't complain, do it"),
 	OPT_END()
 	};
+	const struct option report_options[] = {
+	OPT_STRING('s', "sort", &kwork.sort_order, "key[,key2...]",
+		   "sort by key(s): runtime, max, count"),
+	OPT_STRING('C', "cpu", &kwork.cpu_list, "cpu",
+		   "list of cpus to profile"),
+	OPT_STRING('n', "name", &kwork.profile_name, "name",
+		   "event name to profile"),
+	OPT_STRING(0, "time", &kwork.time_str, "str",
+		   "Time span for analysis (start,stop)"),
+	OPT_STRING('i', "input", &input_name, "file",
+		   "input file name"),
+	OPT_BOOLEAN('S', "with-summary", &kwork.summary,
+		    "Show summary with statistics"),
+	OPT_PARENT(kwork_options)
+	};
 
 	const char *kwork_usage[] = {
 		NULL,
 		NULL
 	};
+	const char * const report_usage[] = {
+		"perf kwork report [<options>]",
+		NULL
+	};
 	const char *const kwork_subcommands[] = {
-		"record", NULL
+		"record", "report", NULL
 	};
 
 	argc = parse_options_subcommand(argc, argv, kwork_options,
@@ -193,10 +1037,21 @@ int cmd_kwork(int argc, const char **argv)
 		usage_with_options(kwork_usage, kwork_options);
 
 	setup_event_list(&kwork, kwork_options, kwork_usage);
+	sort_dimension__add(&kwork, "id", &kwork.cmp_id);
 
 	if (strlen(argv[0]) > 2 && strstarts("record", argv[0]))
 		return perf_kwork__record(&kwork, argc, argv);
-	else
+	else if (strlen(argv[0]) > 2 && strstarts("report", argv[0])) {
+		kwork.sort_order = default_report_sort_order;
+		if (argc > 1) {
+			argc = parse_options(argc, argv, report_options, report_usage, 0);
+			if (argc)
+				usage_with_options(report_usage, report_options);
+		}
+		kwork.report = KWORK_REPORT_RUNTIME;
+		setup_sorting(&kwork, report_options, report_usage);
+		return perf_kwork__report(&kwork);
+	} else
 		usage_with_options(kwork_usage, kwork_options);
 
 	return 0;
diff --git a/tools/perf/util/kwork.h b/tools/perf/util/kwork.h
index 03203c4deb34..0a86bf47c74d 100644
--- a/tools/perf/util/kwork.h
+++ b/tools/perf/util/kwork.h
@@ -19,6 +19,105 @@ enum kwork_class_type {
 	KWORK_CLASS_MAX,
 };
 
+enum kwork_report_type {
+	KWORK_REPORT_RUNTIME,
+};
+
+enum kwork_trace_type {
+	KWORK_TRACE_ENTRY,
+	KWORK_TRACE_EXIT,
+	KWORK_TRACE_MAX,
+};
+
+/*
+ * data structure:
+ *
+ *                 +==================+ +============+ +======================+
+ *                 |      class       | |    work    | |         atom         |
+ *                 +==================+ +============+ +======================+
+ * +------------+  |  +-----+         | |  +------+  | |  +-------+   +-----+ |
+ * | perf_kwork | +-> | irq | --------|+-> | eth0 | --+-> | raise | - | ... | --+   +-----------+
+ * +-----+------+ ||  +-----+         |||  +------+  |||  +-------+   +-----+ | |   |           |
+ *       |        ||                  |||            |||                      | +-> | atom_page |
+ *       |        ||                  |||            |||  +-------+   +-----+ |     |           |
+ *       |  class_list                |||            |+-> | entry | - | ... | ----> |           |
+ *       |        ||                  |||            |||  +-------+   +-----+ |     |           |
+ *       |        ||                  |||            |||                      | +-> |           |
+ *       |        ||                  |||            |||  +-------+   +-----+ | |   |           |
+ *       |        ||                  |||            |+-> | exit  | - | ... | --+   +-----+-----+
+ *       |        ||                  |||            | |  +-------+   +-----+ |           |
+ *       |        ||                  |||            | |                      |           |
+ *       |        ||                  |||  +-----+   | |                      |           |
+ *       |        ||                  |+-> | ... |   | |                      |           |
+ *       |        ||                  | |  +-----+   | |                      |           |
+ *       |        ||                  | |            | |                      |           |
+ *       |        ||  +---------+     | |  +-----+   | |  +-------+   +-----+ |           |
+ *       |        +-> | softirq | -------> | RCU | ---+-> | raise | - | ... | --+   +-----+-----+
+ *       |        ||  +---------+     | |  +-----+   |||  +-------+   +-----+ | |   |           |
+ *       |        ||                  | |            |||                      | +-> | atom_page |
+ *       |        ||                  | |            |||  +-------+   +-----+ |     |           |
+ *       |        ||                  | |            |+-> | entry | - | ... | ----> |           |
+ *       |        ||                  | |            |||  +-------+   +-----+ |     |           |
+ *       |        ||                  | |            |||                      | +-> |           |
+ *       |        ||                  | |            |||  +-------+   +-----+ | |   |           |
+ *       |        ||                  | |            |+-> | exit  | - | ... | --+   +-----+-----+
+ *       |        ||                  | |            | |  +-------+   +-----+ |           |
+ *       |        ||                  | |            | |                      |           |
+ *       |        ||  +-----------+   | |  +-----+   | |                      |           |
+ *       |        +-> | workqueue | -----> | ... |   | |                      |           |
+ *       |         |  +-----------+   | |  +-----+   | |                      |           |
+ *       |         +==================+ +============+ +======================+           |
+ *       |                                                                                |
+ *       +---->  atom_page_list  ---------------------------------------------------------+
+ *
+ */
+
+struct kwork_atom {
+	struct list_head list;
+	u64 time;
+	struct kwork_atom *prev;
+
+	void *page_addr;
+	unsigned long bit_inpage;
+};
+
+#define NR_ATOM_PER_PAGE 128
+struct kwork_atom_page {
+	struct list_head list;
+	struct kwork_atom atoms[NR_ATOM_PER_PAGE];
+	DECLARE_BITMAP(bitmap, NR_ATOM_PER_PAGE);
+};
+
+struct kwork_class;
+struct kwork_work {
+	/*
+	 * class field
+	 */
+	struct rb_node node;
+	struct kwork_class *class;
+
+	/*
+	 * work field
+	 */
+	u64 id;
+	int cpu;
+	char *name;
+
+	/*
+	 * atom field
+	 */
+	u64 nr_atoms;
+	struct list_head atom_list[KWORK_TRACE_MAX];
+
+	/*
+	 * runtime report
+	 */
+	u64 max_runtime;
+	u64 max_runtime_start;
+	u64 max_runtime_end;
+	u64 total_runtime;
+};
+
 struct kwork_class {
 	struct list_head list;
 	const char *name;
@@ -26,19 +125,81 @@ struct kwork_class {
 
 	unsigned int nr_tracepoints;
 	const struct evsel_str_handler *tp_handlers;
+
+	struct rb_root_cached work_root;
+
+	int (*class_init)(struct kwork_class *class,
+			  struct perf_session *session);
+
+	void (*work_init)(struct kwork_class *class,
+			  struct kwork_work *work,
+			  struct evsel *evsel,
+			  struct perf_sample *sample,
+			  struct machine *machine);
+
+	void (*work_name)(struct kwork_work *work,
+			  char *buf, int len);
+};
+
+struct perf_kwork;
+struct trace_kwork_handler {
+	int (*entry_event)(struct perf_kwork *kwork,
+			   struct kwork_class *class, struct evsel *evsel,
+			   struct perf_sample *sample, struct machine *machine);
+
+	int (*exit_event)(struct perf_kwork *kwork,
+			  struct kwork_class *class, struct evsel *evsel,
+			  struct perf_sample *sample, struct machine *machine);
 };
 
 struct perf_kwork {
 	/*
 	 * metadata
 	 */
+	struct perf_tool tool;
 	struct list_head class_list;
+	struct list_head atom_page_list;
+	struct list_head sort_list, cmp_id;
+	struct rb_root_cached sorted_work_root;
+	const struct trace_kwork_handler *tp_handler;
+
+	/*
+	 * profile filters
+	 */
+	const char *profile_name;
+
+	const char *cpu_list;
+	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+
+	const char *time_str;
+	struct perf_time_interval ptime;
 
 	/*
 	 * options for command
 	 */
 	bool force;
 	const char *event_list_str;
+	enum kwork_report_type report;
+
+	/*
+	 * options for subcommand
+	 */
+	bool summary;
+	const char *sort_order;
+
+	/*
+	 * statistics
+	 */
+	u64 timestart;
+	u64 timeend;
+
+	unsigned long nr_events;
+	unsigned long nr_lost_chunks;
+	unsigned long nr_lost_events;
+
+	u64 all_runtime;
+	u64 all_count;
+	u64 nr_skipped_events[KWORK_TRACE_MAX + 1];
 };
 
 #endif  /* PERF_UTIL_KWORK_H */
-- 
2.30.GIT

