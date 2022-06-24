Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA2C559B14
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbiFXOGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbiFXOGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:06:25 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A6D4EDEE;
        Fri, 24 Jun 2022 07:06:13 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LTzQd0FxNzkWjZ;
        Fri, 24 Jun 2022 22:04:57 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:11 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:10 +0800
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
Subject: [RFC v2 17/17] perf kwork: Add workqueue trace bpf support
Date:   Fri, 24 Jun 2022 22:03:49 +0800
Message-ID: <20220624140349.16964-18-yangjihong1@huawei.com>
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

Implements workqueue trace bpf function.

Test cases:

  # perf kwork -k workqueue lat -b
  Starting trace, Hit <Ctrl+C> to stop and report
  ^C
    Kwork Name                     | Cpu  | Avg delay     | Count     | Max delay     | Max delay start     | Max delay end       |
   --------------------------------------------------------------------------------------------------------------------------------
    (w)addrconf_verify_work        | 0002 |      5.856 ms |         1 |      5.856 ms |     111994.634313 s |     111994.640169 s |
    (w)vmstat_update               | 0001 |      1.247 ms |         1 |      1.247 ms |     111996.462651 s |     111996.463899 s |
    (w)neigh_periodic_work         | 0001 |      1.183 ms |         1 |      1.183 ms |     111996.462789 s |     111996.463973 s |
    (w)neigh_managed_work          | 0001 |      0.989 ms |         2 |      1.635 ms |     111996.462820 s |     111996.464455 s |
    (w)wb_workfn                   | 0000 |      0.667 ms |         1 |      0.667 ms |     111996.384273 s |     111996.384940 s |
    (w)bpf_prog_free_deferred      | 0001 |      0.495 ms |         1 |      0.495 ms |     111986.314201 s |     111986.314696 s |
    (w)mix_interrupt_randomness    | 0002 |      0.421 ms |         6 |      0.749 ms |     111995.927750 s |     111995.928499 s |
    (w)vmstat_shepherd             | 0000 |      0.374 ms |         2 |      0.385 ms |     111991.265242 s |     111991.265627 s |
    (w)e1000_watchdog              | 0002 |      0.356 ms |         5 |      0.390 ms |     111994.528380 s |     111994.528770 s |
    (w)vmstat_update               | 0000 |      0.231 ms |         2 |      0.365 ms |     111996.384407 s |     111996.384772 s |
    (w)flush_to_ldisc              | 0006 |      0.165 ms |         1 |      0.165 ms |     111995.930606 s |     111995.930771 s |
    (w)flush_to_ldisc              | 0000 |      0.094 ms |         2 |      0.095 ms |     111996.460453 s |     111996.460548 s |
   --------------------------------------------------------------------------------------------------------------------------------

  # perf kwork -k workqueue rep -b
  Starting trace, Hit <Ctrl+C> to stop and report
  ^C
    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    (w)e1000_watchdog              | 0002 |      0.627 ms |         2 |      0.324 ms |     112002.720665 s |     112002.720989 s |
    (w)flush_to_ldisc              | 0007 |      0.598 ms |         2 |      0.534 ms |     112000.875226 s |     112000.875761 s |
    (w)wq_barrier_func             | 0007 |      0.492 ms |         1 |      0.492 ms |     112000.876981 s |     112000.877473 s |
    (w)flush_to_ldisc              | 0007 |      0.281 ms |         1 |      0.281 ms |     112005.826882 s |     112005.827163 s |
    (w)mix_interrupt_randomness    | 0002 |      0.229 ms |         3 |      0.102 ms |     112005.825671 s |     112005.825774 s |
    (w)vmstat_shepherd             | 0000 |      0.202 ms |         1 |      0.202 ms |     112001.504511 s |     112001.504713 s |
    (w)bpf_prog_free_deferred      | 0001 |      0.181 ms |         1 |      0.181 ms |     112000.883251 s |     112000.883432 s |
    (w)wb_workfn                   | 0007 |      0.130 ms |         1 |      0.130 ms |     112001.505195 s |     112001.505325 s |
    (w)vmstat_update               | 0000 |      0.053 ms |         1 |      0.053 ms |     112001.504763 s |     112001.504815 s |
   --------------------------------------------------------------------------------------------------------------------------------

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/perf/util/bpf_kwork.c                | 22 +++++-
 tools/perf/util/bpf_skel/kwork_trace.bpf.c | 84 ++++++++++++++++++++++
 2 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf_kwork.c b/tools/perf/util/bpf_kwork.c
index 1d76ca499ff6..fe9b0bdbb947 100644
--- a/tools/perf/util/bpf_kwork.c
+++ b/tools/perf/util/bpf_kwork.c
@@ -120,11 +120,31 @@ static struct kwork_class_bpf kwork_softirq_bpf = {
 	.get_work_name = get_work_name_from_map,
 };
 
+static void workqueue_load_prepare(struct perf_kwork *kwork)
+{
+	if (kwork->report == KWORK_REPORT_RUNTIME) {
+		bpf_program__set_autoload(
+			skel->progs.report_workqueue_execute_start, true);
+		bpf_program__set_autoload(
+			skel->progs.report_workqueue_execute_end, true);
+	} else if (kwork->report == KWORK_REPORT_LATENCY) {
+		bpf_program__set_autoload(
+			skel->progs.latency_workqueue_activate_work, true);
+		bpf_program__set_autoload(
+			skel->progs.latency_workqueue_execute_start, true);
+	}
+}
+
+static struct kwork_class_bpf kwork_workqueue_bpf = {
+	.load_prepare  = workqueue_load_prepare,
+	.get_work_name = get_work_name_from_map,
+};
+
 static struct kwork_class_bpf *
 kwork_class_bpf_supported_list[KWORK_CLASS_MAX] = {
 	[KWORK_CLASS_IRQ]       = &kwork_irq_bpf,
 	[KWORK_CLASS_SOFTIRQ]   = &kwork_softirq_bpf,
-	[KWORK_CLASS_WORKQUEUE] = NULL,
+	[KWORK_CLASS_WORKQUEUE] = &kwork_workqueue_bpf,
 };
 
 static bool valid_kwork_class_type(enum kwork_class_type type)
diff --git a/tools/perf/util/bpf_skel/kwork_trace.bpf.c b/tools/perf/util/bpf_skel/kwork_trace.bpf.c
index a9afc64f2d67..238b03f9ea2b 100644
--- a/tools/perf/util/bpf_skel/kwork_trace.bpf.c
+++ b/tools/perf/util/bpf_skel/kwork_trace.bpf.c
@@ -167,6 +167,15 @@ static __always_inline void do_update_name(void *map,
 		bpf_map_update_elem(map, key, name, BPF_ANY);
 }
 
+static __always_inline int update_timestart(void *map, struct work_key *key)
+{
+	if (!trace_event_match(key, NULL))
+		return 0;
+
+	do_update_timestart(map, key);
+	return 0;
+}
+
 static __always_inline int update_timestart_and_name(void *time_map,
 						     void *names_map,
 						     struct work_key *key,
@@ -192,6 +201,21 @@ static __always_inline int update_timeend(void *report_map,
 	return 0;
 }
 
+static __always_inline int update_timeend_and_name(void *report_map,
+						   void *time_map,
+						   void *names_map,
+						   struct work_key *key,
+						   char *name)
+{
+	if (!trace_event_match(key, name))
+		return 0;
+
+	do_update_timeend(report_map, time_map, key);
+	do_update_name(names_map, key, name);
+
+	return 0;
+}
+
 SEC("tracepoint/irq/irq_handler_entry")
 int report_irq_handler_entry(struct trace_event_raw_irq_handler_entry *ctx)
 {
@@ -294,4 +318,64 @@ int latency_softirq_entry(struct trace_event_raw_softirq *ctx)
 	return update_timeend(&perf_kwork_report, &perf_kwork_time, &key);
 }
 
+SEC("tracepoint/workqueue/workqueue_execute_start")
+int report_workqueue_execute_start(struct trace_event_raw_workqueue_execute_start *ctx)
+{
+	struct work_key key = {
+		.type = KWORK_CLASS_WORKQUEUE,
+		.cpu  = bpf_get_smp_processor_id(),
+		.id   = (__u64)ctx->work,
+	};
+
+	return update_timestart(&perf_kwork_time, &key);
+}
+
+SEC("tracepoint/workqueue/workqueue_execute_end")
+int report_workqueue_execute_end(struct trace_event_raw_workqueue_execute_end *ctx)
+{
+	char name[MAX_KWORKNAME];
+	struct work_key key = {
+		.type = KWORK_CLASS_WORKQUEUE,
+		.cpu  = bpf_get_smp_processor_id(),
+		.id   = (__u64)ctx->work,
+	};
+	unsigned long long func_addr = (unsigned long long)ctx->function;
+
+	__builtin_memset(name, 0, sizeof(name));
+	bpf_snprintf(name, sizeof(name), "%ps", &func_addr, sizeof(func_addr));
+
+	return update_timeend_and_name(&perf_kwork_report, &perf_kwork_time,
+				       &perf_kwork_names, &key, name);
+}
+
+SEC("tracepoint/workqueue/workqueue_activate_work")
+int latency_workqueue_activate_work(struct trace_event_raw_workqueue_activate_work *ctx)
+{
+	struct work_key key = {
+		.type = KWORK_CLASS_WORKQUEUE,
+		.cpu  = bpf_get_smp_processor_id(),
+		.id   = (__u64)ctx->work,
+	};
+
+	return update_timestart(&perf_kwork_time, &key);
+}
+
+SEC("tracepoint/workqueue/workqueue_execute_start")
+int latency_workqueue_execute_start(struct trace_event_raw_workqueue_execute_start *ctx)
+{
+	char name[MAX_KWORKNAME];
+	struct work_key key = {
+		.type = KWORK_CLASS_WORKQUEUE,
+		.cpu  = bpf_get_smp_processor_id(),
+		.id   = (__u64)ctx->work,
+	};
+	unsigned long long func_addr = (unsigned long long)ctx->function;
+
+	__builtin_memset(name, 0, sizeof(name));
+	bpf_snprintf(name, sizeof(name), "%ps", &func_addr, sizeof(func_addr));
+
+	return update_timeend_and_name(&perf_kwork_report, &perf_kwork_time,
+				       &perf_kwork_names, &key, name);
+}
+
 char LICENSE[] SEC("license") = "Dual BSD/GPL";
-- 
2.30.GIT

