Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE84A559B0B
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbiFXOGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiFXOGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:06:25 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099074EDDE;
        Fri, 24 Jun 2022 07:06:13 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LTzQ25kBgzkWSx;
        Fri, 24 Jun 2022 22:04:26 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
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
Subject: [RFC v2 16/17] perf kwork: Add softirq trace bpf support
Date:   Fri, 24 Jun 2022 22:03:48 +0800
Message-ID: <20220624140349.16964-17-yangjihong1@huawei.com>
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

Implements softirq trace bpf function.

Test cases:
Trace softirq latency without filter:

  # perf kwork -k softirq lat -b
  Starting trace, Hit <Ctrl+C> to stop and report
  ^C
    Kwork Name                     | Cpu  | Avg delay     | Count     | Max delay     | Max delay start     | Max delay end       |
   --------------------------------------------------------------------------------------------------------------------------------
    (s)RCU:9                       | 0005 |      0.281 ms |         3 |      0.338 ms |     111295.752222 s |     111295.752560 s |
    (s)RCU:9                       | 0002 |      0.262 ms |        24 |      1.400 ms |     111301.335986 s |     111301.337386 s |
    (s)SCHED:7                     | 0005 |      0.177 ms |        14 |      0.212 ms |     111295.752270 s |     111295.752481 s |
    (s)RCU:9                       | 0007 |      0.161 ms |        47 |      2.022 ms |     111295.402159 s |     111295.404181 s |
    (s)NET_RX:3                    | 0003 |      0.149 ms |        12 |      1.261 ms |     111301.192964 s |     111301.194225 s |
    (s)TIMER:1                     | 0001 |      0.105 ms |         9 |      0.198 ms |     111301.180191 s |     111301.180389 s |
    ... <SNIP> ...
    (s)NET_RX:3                    | 0002 |      0.098 ms |         6 |      0.124 ms |     111295.403760 s |     111295.403884 s |
    (s)SCHED:7                     | 0001 |      0.093 ms |        19 |      0.242 ms |     111301.180256 s |     111301.180498 s |
    (s)SCHED:7                     | 0007 |      0.078 ms |        15 |      0.188 ms |     111300.064226 s |     111300.064415 s |
    (s)SCHED:7                     | 0004 |      0.077 ms |        11 |      0.213 ms |     111301.361759 s |     111301.361973 s |
    (s)SCHED:7                     | 0000 |      0.063 ms |        33 |      0.805 ms |     111295.401811 s |     111295.402616 s |
    (s)SCHED:7                     | 0003 |      0.063 ms |        14 |      0.085 ms |     111301.192255 s |     111301.192340 s |
   --------------------------------------------------------------------------------------------------------------------------------

Trace softirq latency with cpu filter:

  # perf kwork -k softirq lat -b -C 1
  Starting trace, Hit <Ctrl+C> to stop and report
  ^C
    Kwork Name                     | Cpu  | Avg delay     | Count     | Max delay     | Max delay start     | Max delay end       |
   --------------------------------------------------------------------------------------------------------------------------------
    (s)RCU:9                       | 0001 |      0.178 ms |         5 |      0.572 ms |     111435.534135 s |     111435.534707 s |
   --------------------------------------------------------------------------------------------------------------------------------

Trace softirq latency with name filter:

  # perf kwork -k softirq lat -b -n SCHED
  Starting trace, Hit <Ctrl+C> to stop and report
  ^C
    Kwork Name                     | Cpu  | Avg delay     | Count     | Max delay     | Max delay start     | Max delay end       |
   --------------------------------------------------------------------------------------------------------------------------------
    (s)SCHED:7                     | 0001 |      0.295 ms |        15 |      2.183 ms |     111452.534950 s |     111452.537133 s |
    (s)SCHED:7                     | 0002 |      0.215 ms |        10 |      0.315 ms |     111460.000238 s |     111460.000553 s |
    (s)SCHED:7                     | 0005 |      0.190 ms |        29 |      0.338 ms |     111457.032538 s |     111457.032876 s |
    (s)SCHED:7                     | 0003 |      0.097 ms |        10 |      0.319 ms |     111452.434351 s |     111452.434670 s |
    (s)SCHED:7                     | 0006 |      0.089 ms |         1 |      0.089 ms |     111450.737450 s |     111450.737539 s |
    (s)SCHED:7                     | 0007 |      0.085 ms |        17 |      0.169 ms |     111452.471333 s |     111452.471502 s |
    (s)SCHED:7                     | 0004 |      0.071 ms |        15 |      0.221 ms |     111452.535252 s |     111452.535473 s |
    (s)SCHED:7                     | 0000 |      0.044 ms |        32 |      0.130 ms |     111460.001982 s |     111460.002112 s |
   --------------------------------------------------------------------------------------------------------------------------------

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/perf/util/bpf_kwork.c                | 22 ++++++-
 tools/perf/util/bpf_skel/kwork_trace.bpf.c | 73 ++++++++++++++++++++++
 2 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf_kwork.c b/tools/perf/util/bpf_kwork.c
index 08252fcda1a4..1d76ca499ff6 100644
--- a/tools/perf/util/bpf_kwork.c
+++ b/tools/perf/util/bpf_kwork.c
@@ -100,10 +100,30 @@ static struct kwork_class_bpf kwork_irq_bpf = {
 	.get_work_name = get_work_name_from_map,
 };
 
+static void softirq_load_prepare(struct perf_kwork *kwork)
+{
+	if (kwork->report == KWORK_REPORT_RUNTIME) {
+		bpf_program__set_autoload(
+			skel->progs.report_softirq_entry, true);
+		bpf_program__set_autoload(
+			skel->progs.report_softirq_exit, true);
+	} else if (kwork->report == KWORK_REPORT_LATENCY) {
+		bpf_program__set_autoload(
+			skel->progs.latency_softirq_raise, true);
+		bpf_program__set_autoload(
+			skel->progs.latency_softirq_entry, true);
+	}
+}
+
+static struct kwork_class_bpf kwork_softirq_bpf = {
+	.load_prepare  = softirq_load_prepare,
+	.get_work_name = get_work_name_from_map,
+};
+
 static struct kwork_class_bpf *
 kwork_class_bpf_supported_list[KWORK_CLASS_MAX] = {
 	[KWORK_CLASS_IRQ]       = &kwork_irq_bpf,
-	[KWORK_CLASS_SOFTIRQ]   = NULL,
+	[KWORK_CLASS_SOFTIRQ]   = &kwork_softirq_bpf,
 	[KWORK_CLASS_WORKQUEUE] = NULL,
 };
 
diff --git a/tools/perf/util/bpf_skel/kwork_trace.bpf.c b/tools/perf/util/bpf_skel/kwork_trace.bpf.c
index 1925407d1c16..a9afc64f2d67 100644
--- a/tools/perf/util/bpf_skel/kwork_trace.bpf.c
+++ b/tools/perf/util/bpf_skel/kwork_trace.bpf.c
@@ -221,4 +221,77 @@ int report_irq_handler_exit(struct trace_event_raw_irq_handler_exit *ctx)
 	return update_timeend(&perf_kwork_report, &perf_kwork_time, &key);
 }
 
+static char softirq_name_list[NR_SOFTIRQS][MAX_KWORKNAME] = {
+	{ "HI"       },
+	{ "TIMER"    },
+	{ "NET_TX"   },
+	{ "NET_RX"   },
+	{ "BLOCK"    },
+	{ "IRQ_POLL" },
+	{ "TASKLET"  },
+	{ "SCHED"    },
+	{ "HRTIMER"  },
+	{ "RCU"      },
+};
+
+SEC("tracepoint/irq/softirq_entry")
+int report_softirq_entry(struct trace_event_raw_softirq *ctx)
+{
+	unsigned int vec = ctx->vec;
+	struct work_key key = {
+		.type = KWORK_CLASS_SOFTIRQ,
+		.cpu  = bpf_get_smp_processor_id(),
+		.id   = (__u64)vec,
+	};
+
+	if (vec < NR_SOFTIRQS)
+		return update_timestart_and_name(&perf_kwork_time,
+						 &perf_kwork_names, &key,
+						 softirq_name_list[vec]);
+
+	return 0;
+}
+
+SEC("tracepoint/irq/softirq_exit")
+int report_softirq_exit(struct trace_event_raw_softirq *ctx)
+{
+	struct work_key key = {
+		.type = KWORK_CLASS_SOFTIRQ,
+		.cpu  = bpf_get_smp_processor_id(),
+		.id   = (__u64)ctx->vec,
+	};
+
+	return update_timeend(&perf_kwork_report, &perf_kwork_time, &key);
+}
+
+SEC("tracepoint/irq/softirq_raise")
+int latency_softirq_raise(struct trace_event_raw_softirq *ctx)
+{
+	unsigned int vec = ctx->vec;
+	struct work_key key = {
+		.type = KWORK_CLASS_SOFTIRQ,
+		.cpu  = bpf_get_smp_processor_id(),
+		.id   = (__u64)vec,
+	};
+
+	if (vec < NR_SOFTIRQS)
+		return update_timestart_and_name(&perf_kwork_time,
+						 &perf_kwork_names, &key,
+						 softirq_name_list[vec]);
+
+	return 0;
+}
+
+SEC("tracepoint/irq/softirq_entry")
+int latency_softirq_entry(struct trace_event_raw_softirq *ctx)
+{
+	struct work_key key = {
+		.type = KWORK_CLASS_SOFTIRQ,
+		.cpu  = bpf_get_smp_processor_id(),
+		.id   = (__u64)ctx->vec,
+	};
+
+	return update_timeend(&perf_kwork_report, &perf_kwork_time, &key);
+}
+
 char LICENSE[] SEC("license") = "Dual BSD/GPL";
-- 
2.30.GIT

