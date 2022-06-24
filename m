Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52869559AEC
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbiFXOGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiFXOGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:06:09 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0AE4EDEA;
        Fri, 24 Jun 2022 07:06:07 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LTzPx2HtwzkWTF;
        Fri, 24 Jun 2022 22:04:21 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:05 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:04 +0800
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
Subject: [RFC v2 08/17] perf kwork: Add softirq report support
Date:   Fri, 24 Jun 2022 22:03:40 +0800
Message-ID: <20220624140349.16964-9-yangjihong1@huawei.com>
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

Implements softirq kwork report function.

Test cases:

  # perf kwork -k softirq rep

    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    (s)TIMER:1                     | 0003 |    181.387 ms |      2476 |      1.240 ms |      44004.787960 s |      44004.789201 s |
    (s)RCU:9                       | 0003 |     91.573 ms |      2193 |      0.650 ms |      44004.790258 s |      44004.790908 s |
    (s)RCU:9                       | 0001 |     78.960 ms |      1619 |      1.195 ms |      44001.496553 s |      44001.497749 s |
    (s)SCHED:7                     | 0003 |     55.962 ms |      1255 |      0.954 ms |      44004.812008 s |      44004.812962 s |
    ... <SNIP> ...
    (s)RCU:9                       | 0004 |      0.830 ms |        26 |      0.058 ms |      43997.666418 s |      43997.666476 s |
    (s)TIMER:1                     | 0001 |      0.471 ms |         4 |      0.158 ms |      44007.834694 s |      44007.834852 s |
    (s)RCU:9                       | 0006 |      0.220 ms |         7 |      0.048 ms |      44004.833764 s |      44004.833812 s |
    (s)NET_RX:3                    | 0002 |      0.164 ms |         5 |      0.049 ms |      44005.012418 s |      44005.012466 s |
    (s)TIMER:1                     | 0005 |      0.164 ms |         1 |      0.164 ms |      44007.820474 s |      44007.820638 s |
    (s)TIMER:1                     | 0006 |      0.087 ms |         1 |      0.087 ms |      44000.830807 s |      44000.830894 s |
    (s)SCHED:7                     | 0006 |      0.080 ms |         2 |      0.044 ms |      43997.826145 s |      43997.826189 s |
   --------------------------------------------------------------------------------------------------------------------------------

  #
  # perf kwork -k softirq rep -S

    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    (s)TIMER:1                     | 0003 |    181.387 ms |      2476 |      1.240 ms |      44004.787960 s |      44004.789201 s |
    (s)RCU:9                       | 0003 |     91.573 ms |      2193 |      0.650 ms |      44004.790258 s |      44004.790908 s |
    (s)RCU:9                       | 0001 |     78.960 ms |      1619 |      1.195 ms |      44001.496553 s |      44001.497749 s |
    (s)SCHED:7                     | 0000 |     63.631 ms |       680 |      2.690 ms |      44006.721976 s |      44006.724666 s |
    ... <SNIP> ...
    (s)SCHED:7                     | 0003 |     55.962 ms |      1255 |      0.954 ms |      44004.812008 s |      44004.812962 s |
    (s)RCU:9                       | 0006 |      0.220 ms |         7 |      0.048 ms |      44004.833764 s |      44004.833812 s |
    (s)NET_RX:3                    | 0002 |      0.164 ms |         5 |      0.049 ms |      44005.012418 s |      44005.012466 s |
    (s)TIMER:1                     | 0005 |      0.164 ms |         1 |      0.164 ms |      44007.820474 s |      44007.820638 s |
    (s)TIMER:1                     | 0006 |      0.087 ms |         1 |      0.087 ms |      44000.830807 s |      44000.830894 s |
    (s)SCHED:7                     | 0006 |      0.080 ms |         2 |      0.044 ms |      43997.826145 s |      43997.826189 s |
   --------------------------------------------------------------------------------------------------------------------------------
    Total count            :     12748
    Total runtime   (msec) :   661.433 (0.065% load average)
    Total time span (msec) : 10176.441
   --------------------------------------------------------------------------------------------------------------------------------

  #
  # perf kwork -k softirq rep -s freq,max

    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    (s)TIMER:1                     | 0003 |    181.387 ms |      2476 |      1.240 ms |      44004.787960 s |      44004.789201 s |
    (s)RCU:9                       | 0003 |     91.573 ms |      2193 |      0.650 ms |      44004.790258 s |      44004.790908 s |
    (s)SCHED:7                     | 0002 |     50.039 ms |      1731 |      0.074 ms |      44005.009447 s |      44005.009521 s |
    (s)RCU:9                       | 0001 |     78.960 ms |      1619 |      1.195 ms |      44001.496553 s |      44001.497749 s |
    (s)SCHED:7                     | 0003 |     55.962 ms |      1255 |      0.954 ms |      44004.812008 s |      44004.812962 s |
    ... <SNIP> ...
    (s)RCU:9                       | 0002 |     35.241 ms |       932 |      0.407 ms |      44005.009541 s |      44005.009949 s |
    (s)RCU:9                       | 0000 |     45.710 ms |       702 |      1.144 ms |      44004.787023 s |      44004.788167 s |
    (s)SCHED:7                     | 0006 |      0.080 ms |         2 |      0.044 ms |      43997.826145 s |      43997.826189 s |
    (s)TIMER:1                     | 0005 |      0.164 ms |         1 |      0.164 ms |      44007.820474 s |      44007.820638 s |
    (s)TIMER:1                     | 0006 |      0.087 ms |         1 |      0.087 ms |      44000.830807 s |      44000.830894 s |
   --------------------------------------------------------------------------------------------------------------------------------

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/perf/builtin-kwork.c | 98 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 96 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kwork.c b/tools/perf/builtin-kwork.c
index b1993be0a20a..8680fe3795d4 100644
--- a/tools/perf/builtin-kwork.c
+++ b/tools/perf/builtin-kwork.c
@@ -550,17 +550,111 @@ static struct kwork_class kwork_irq = {
 	.work_name      = irq_work_name,
 };
 
+static struct kwork_class kwork_softirq;
+static int process_softirq_entry_event(struct perf_tool *tool,
+				       struct evsel *evsel,
+				       struct perf_sample *sample,
+				       struct machine *machine)
+{
+	struct perf_kwork *kwork = container_of(tool, struct perf_kwork, tool);
+
+	if (kwork->tp_handler->entry_event)
+		return kwork->tp_handler->entry_event(kwork, &kwork_softirq,
+						      evsel, sample, machine);
+
+	return 0;
+}
+
+static int process_softirq_exit_event(struct perf_tool *tool,
+				      struct evsel *evsel,
+				      struct perf_sample *sample,
+				      struct machine *machine)
+{
+	struct perf_kwork *kwork = container_of(tool, struct perf_kwork, tool);
+
+	if (kwork->tp_handler->exit_event)
+		return kwork->tp_handler->exit_event(kwork, &kwork_softirq,
+						     evsel, sample, machine);
+
+	return 0;
+}
+
 const struct evsel_str_handler softirq_tp_handlers[] = {
 	{ "irq:softirq_raise", NULL, },
-	{ "irq:softirq_entry", NULL, },
-	{ "irq:softirq_exit",  NULL, },
+	{ "irq:softirq_entry", process_softirq_entry_event, },
+	{ "irq:softirq_exit",  process_softirq_exit_event,  },
 };
 
+static int softirq_class_init(struct kwork_class *class,
+			      struct perf_session *session)
+{
+	if (perf_session__set_tracepoints_handlers(session,
+						   softirq_tp_handlers)) {
+		pr_err("Failed to set softirq tracepoints handlers\n");
+		return -1;
+	}
+
+	class->work_root = RB_ROOT_CACHED;
+	return 0;
+}
+
+static char *evsel__softirq_name(struct evsel *evsel, u64 num)
+{
+	char *name = NULL;
+	bool found = false;
+	struct tep_print_flag_sym *sym = NULL;
+	struct tep_print_arg *args = evsel->tp_format->print_fmt.args;
+
+	if ((args == NULL) || (args->next == NULL))
+		return NULL;
+
+	/* skip softirq field: "REC->vec" */
+	for (sym = args->next->symbol.symbols; sym != NULL; sym = sym->next) {
+		if ((eval_flag(sym->value) == (unsigned long long)num) &&
+		    (strlen(sym->str) != 0)) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		return NULL;
+
+	name = strdup(sym->str);
+	if (name == NULL) {
+		pr_err("Failed to copy symbol name\n");
+		return NULL;
+	}
+	return name;
+}
+
+static void softirq_work_init(struct kwork_class *class,
+			      struct kwork_work *work,
+			      struct evsel *evsel,
+			      struct perf_sample *sample,
+			      struct machine *machine __maybe_unused)
+{
+	u64 num = evsel__intval(evsel, sample, "vec");
+
+	work->id = num;
+	work->class = class;
+	work->cpu = sample->cpu;
+	work->name = evsel__softirq_name(evsel, num);
+}
+
+static void softirq_work_name(struct kwork_work *work, char *buf, int len)
+{
+	snprintf(buf, len, "(s)%s:%" PRIu64 "", work->name, work->id);
+}
+
 static struct kwork_class kwork_softirq = {
 	.name           = "softirq",
 	.type           = KWORK_CLASS_SOFTIRQ,
 	.nr_tracepoints = 3,
 	.tp_handlers    = softirq_tp_handlers,
+	.class_init     = softirq_class_init,
+	.work_init      = softirq_work_init,
+	.work_name      = softirq_work_name,
 };
 
 const struct evsel_str_handler workqueue_tp_handlers[] = {
-- 
2.30.GIT

