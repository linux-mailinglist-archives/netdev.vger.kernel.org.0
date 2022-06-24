Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32BCD559B1F
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbiFXOGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiFXOGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:06:14 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA6F4EDE5;
        Fri, 24 Jun 2022 07:06:13 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LTzN42vQjzShJ0;
        Fri, 24 Jun 2022 22:02:44 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:10 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:09 +0800
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
Subject: [RFC v2 15/17] perf kwork: Add irq trace bpf support
Date:   Fri, 24 Jun 2022 22:03:47 +0800
Message-ID: <20220624140349.16964-16-yangjihong1@huawei.com>
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

Implements irq trace bpf function.

Test cases:
Trace irq without filter:

  # perf kwork -k irq rep -b
  Starting trace, Hit <Ctrl+C> to stop and report
  ^C
    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    virtio0-requests:25            | 0000 |     31.026 ms |       285 |      1.493 ms |     110326.049963 s |     110326.051456 s |
    eth0:10                        | 0002 |      7.875 ms |        96 |      1.429 ms |     110313.916835 s |     110313.918264 s |
    ata_piix:14                    | 0002 |      2.510 ms |        28 |      0.396 ms |     110331.367987 s |     110331.368383 s |
   --------------------------------------------------------------------------------------------------------------------------------

Trace irq with cpu filter:

  # perf kwork -k irq rep -b -C 0
  Starting trace, Hit <Ctrl+C> to stop and report
  ^C
    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    virtio0-requests:25            | 0000 |     34.288 ms |       282 |      2.061 ms |     110358.078968 s |     110358.081029 s |
   --------------------------------------------------------------------------------------------------------------------------------

Trace irq with name filter:

  # perf kwork -k irq rep -b -n eth0
  Starting trace, Hit <Ctrl+C> to stop and report
  ^C
    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    eth0:10                        | 0002 |      2.184 ms |        21 |      0.572 ms |     110386.541699 s |     110386.542271 s |
   --------------------------------------------------------------------------------------------------------------------------------

Trace irq with summary:

  # perf kwork -k irq rep -b -S
  Starting trace, Hit <Ctrl+C> to stop and report
  ^C
    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    virtio0-requests:25            | 0000 |     42.923 ms |       285 |      1.181 ms |     110418.128867 s |     110418.130049 s |
    eth0:10                        | 0002 |      2.085 ms |        20 |      0.668 ms |     110416.002935 s |     110416.003603 s |
    ata_piix:14                    | 0002 |      0.970 ms |         4 |      0.656 ms |     110424.034482 s |     110424.035138 s |
   --------------------------------------------------------------------------------------------------------------------------------
    Total count            :       309
    Total runtime   (msec) :    45.977 (0.003% load average)
    Total time span (msec) : 17017.655
   --------------------------------------------------------------------------------------------------------------------------------

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/perf/util/bpf_kwork.c                |  40 +++++-
 tools/perf/util/bpf_skel/kwork_trace.bpf.c | 150 +++++++++++++++++++++
 2 files changed, 189 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf_kwork.c b/tools/perf/util/bpf_kwork.c
index 433bfadd3af1..08252fcda1a4 100644
--- a/tools/perf/util/bpf_kwork.c
+++ b/tools/perf/util/bpf_kwork.c
@@ -62,9 +62,47 @@ void perf_kwork__trace_finish(void)
 	skel->bss->enabled = 0;
 }
 
+static int get_work_name_from_map(struct work_key *key, char **ret_name)
+{
+	char name[MAX_KWORKNAME] = { 0 };
+	int fd = bpf_map__fd(skel->maps.perf_kwork_names);
+
+	*ret_name = NULL;
+
+	if (fd < 0) {
+		pr_debug("Invalid names map fd\n");
+		return 0;
+	}
+
+	if ((bpf_map_lookup_elem(fd, key, name) == 0) && (strlen(name) != 0)) {
+		*ret_name = strdup(name);
+		if (*ret_name == NULL) {
+			pr_err("Failed to copy work name\n");
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+static void irq_load_prepare(struct perf_kwork *kwork)
+{
+	if (kwork->report == KWORK_REPORT_RUNTIME) {
+		bpf_program__set_autoload(
+			skel->progs.report_irq_handler_entry, true);
+		bpf_program__set_autoload(
+			skel->progs.report_irq_handler_exit, true);
+	}
+}
+
+static struct kwork_class_bpf kwork_irq_bpf = {
+	.load_prepare  = irq_load_prepare,
+	.get_work_name = get_work_name_from_map,
+};
+
 static struct kwork_class_bpf *
 kwork_class_bpf_supported_list[KWORK_CLASS_MAX] = {
-	[KWORK_CLASS_IRQ]       = NULL,
+	[KWORK_CLASS_IRQ]       = &kwork_irq_bpf,
 	[KWORK_CLASS_SOFTIRQ]   = NULL,
 	[KWORK_CLASS_WORKQUEUE] = NULL,
 };
diff --git a/tools/perf/util/bpf_skel/kwork_trace.bpf.c b/tools/perf/util/bpf_skel/kwork_trace.bpf.c
index 36112be831e3..1925407d1c16 100644
--- a/tools/perf/util/bpf_skel/kwork_trace.bpf.c
+++ b/tools/perf/util/bpf_skel/kwork_trace.bpf.c
@@ -71,4 +71,154 @@ int enabled = 0;
 int has_cpu_filter = 0;
 int has_name_filter = 0;
 
+static __always_inline int local_strncmp(const char *s1,
+					 unsigned int sz, const char *s2)
+{
+	int ret = 0;
+	unsigned int i;
+
+	for (i = 0; i < sz; i++) {
+		ret = (unsigned char)s1[i] - (unsigned char)s2[i];
+		if (ret || !s1[i] || !s2[i])
+			break;
+	}
+
+	return ret;
+}
+
+static __always_inline int trace_event_match(struct work_key *key, char *name)
+{
+	__u8 *cpu_val;
+	char *name_val;
+	__u32 zero = 0;
+	__u32 cpu = bpf_get_smp_processor_id();
+
+	if (!enabled)
+		return 0;
+
+	if (has_cpu_filter) {
+		cpu_val = bpf_map_lookup_elem(&perf_kwork_cpu_filter, &cpu);
+		if (!cpu_val)
+			return 0;
+	}
+
+	if (has_name_filter && (name != NULL)) {
+		name_val = bpf_map_lookup_elem(&perf_kwork_name_filter, &zero);
+		if (name_val &&
+		    (local_strncmp(name_val, MAX_KWORKNAME, name) != 0)) {
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+static __always_inline void do_update_time(void *map, struct work_key *key,
+					   __u64 time_start, __u64 time_end)
+{
+	struct report_data zero, *data;
+	__s64 delta = time_end - time_start;
+
+	if (delta < 0)
+		return;
+
+	data = bpf_map_lookup_elem(map, key);
+	if (!data) {
+		__builtin_memset(&zero, 0, sizeof(zero));
+		bpf_map_update_elem(map, key, &zero, BPF_NOEXIST);
+		data = bpf_map_lookup_elem(map, key);
+		if (!data)
+			return;
+	}
+
+	if ((delta > data->max_time) ||
+	    (data->max_time == 0)) {
+		data->max_time       = delta;
+		data->max_time_start = time_start;
+		data->max_time_end   = time_end;
+	}
+
+	data->total_time += delta;
+	data->nr++;
+}
+
+static __always_inline void do_update_timestart(void *map, struct work_key *key)
+{
+	__u64 ts = bpf_ktime_get_ns();
+
+	bpf_map_update_elem(map, key, &ts, BPF_ANY);
+}
+
+static __always_inline void do_update_timeend(void *report_map, void *time_map,
+					      struct work_key *key)
+{
+	__u64 *time = bpf_map_lookup_elem(time_map, key);
+
+	if (time) {
+		bpf_map_delete_elem(time_map, key);
+		do_update_time(report_map, key, *time, bpf_ktime_get_ns());
+	}
+}
+
+static __always_inline void do_update_name(void *map,
+					   struct work_key *key, char *name)
+{
+	if (!bpf_map_lookup_elem(map, key))
+		bpf_map_update_elem(map, key, name, BPF_ANY);
+}
+
+static __always_inline int update_timestart_and_name(void *time_map,
+						     void *names_map,
+						     struct work_key *key,
+						     char *name)
+{
+	if (!trace_event_match(key, name))
+		return 0;
+
+	do_update_timestart(time_map, key);
+	do_update_name(names_map, key, name);
+
+	return 0;
+}
+
+static __always_inline int update_timeend(void *report_map,
+					  void *time_map, struct work_key *key)
+{
+	if (!trace_event_match(key, NULL))
+		return 0;
+
+	do_update_timeend(report_map, time_map, key);
+
+	return 0;
+}
+
+SEC("tracepoint/irq/irq_handler_entry")
+int report_irq_handler_entry(struct trace_event_raw_irq_handler_entry *ctx)
+{
+	char name[MAX_KWORKNAME];
+	struct work_key key = {
+		.type = KWORK_CLASS_IRQ,
+		.cpu  = bpf_get_smp_processor_id(),
+		.id   = (__u64)ctx->irq,
+	};
+	void *name_addr = (void *)ctx + (ctx->__data_loc_name & 0xffff);
+
+	bpf_probe_read_kernel_str(name, sizeof(name), name_addr);
+
+	return update_timestart_and_name(&perf_kwork_time,
+					 &perf_kwork_names, &key, name);
+}
+
+SEC("tracepoint/irq/irq_handler_exit")
+int report_irq_handler_exit(struct trace_event_raw_irq_handler_exit *ctx)
+{
+	struct work_key key = {
+		.type = KWORK_CLASS_IRQ,
+		.cpu  = bpf_get_smp_processor_id(),
+		.id   = (__u64)ctx->irq,
+	};
+
+	return update_timeend(&perf_kwork_report, &perf_kwork_time, &key);
+}
+
 char LICENSE[] SEC("license") = "Dual BSD/GPL";
-- 
2.30.GIT

