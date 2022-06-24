Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D584559AF3
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiFXOGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiFXOGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:06:09 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798254EDE8;
        Fri, 24 Jun 2022 07:06:07 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LTzMy6FL4zShJD;
        Fri, 24 Jun 2022 22:02:38 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
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
Subject: [RFC v2 07/17] perf kwork: Add irq report support
Date:   Fri, 24 Jun 2022 22:03:39 +0800
Message-ID: <20220624140349.16964-8-yangjihong1@huawei.com>
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

Implements irq kwork report function.

Test cases:

  # perf kwork record -- sleep 10
  [ perf record: Woken up 0 times to write data ]
  [ perf record: Captured and wrote 6.134 MB perf.data ]

  # perf kwork report

    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    virtio0-requests:25            | 0000 |   1167.501 ms |     18284 |      1.096 ms |      44004.464905 s |      44004.466001 s |
    eth0:10                        | 0002 |      0.185 ms |         5 |      0.058 ms |      44005.012222 s |      44005.012280 s |
   --------------------------------------------------------------------------------------------------------------------------------

  # perf kwork report -C 2

    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    eth0:10                        | 0002 |      0.185 ms |         5 |      0.058 ms |      44005.012222 s |      44005.012280 s |
   --------------------------------------------------------------------------------------------------------------------------------

  # perf kwork report -C 3

    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
   --------------------------------------------------------------------------------------------------------------------------------

  # perf kwork report -i perf.data

    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    virtio0-requests:25            | 0000 |   1167.501 ms |     18284 |      1.096 ms |      44004.464905 s |      44004.466001 s |
    eth0:10                        | 0002 |      0.185 ms |         5 |      0.058 ms |      44005.012222 s |      44005.012280 s |
   --------------------------------------------------------------------------------------------------------------------------------

  # perf kwork report -s max,freq

    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    virtio0-requests:25            | 0000 |   1167.501 ms |     18284 |      1.096 ms |      44004.464905 s |      44004.466001 s |
    eth0:10                        | 0002 |      0.185 ms |         5 |      0.058 ms |      44005.012222 s |      44005.012280 s |
   --------------------------------------------------------------------------------------------------------------------------------

  # perf kwork report -S

    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    virtio0-requests:25            | 0000 |   1167.501 ms |     18284 |      1.096 ms |      44004.464905 s |      44004.466001 s |
    eth0:10                        | 0002 |      0.185 ms |         5 |      0.058 ms |      44005.012222 s |      44005.012280 s |
   --------------------------------------------------------------------------------------------------------------------------------
    Total count            :     18289
    Total runtime   (msec) :  1167.686 (0.115% load average)
    Total time span (msec) : 10159.155
   --------------------------------------------------------------------------------------------------------------------------------

  # perf kwork report --time 44005,

    Kwork Name                     | Cpu  | Total Runtime | Count     | Max runtime   | Max runtime start   | Max runtime end     |
   --------------------------------------------------------------------------------------------------------------------------------
    virtio0-requests:25            | 0000 |    402.173 ms |      4695 |      0.981 ms |      44007.831992 s |      44007.832973 s |
    eth0:10                        | 0002 |      0.089 ms |         2 |      0.058 ms |      44005.012222 s |      44005.012280 s |
   --------------------------------------------------------------------------------------------------------------------------------

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/perf/builtin-kwork.c | 63 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 61 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kwork.c b/tools/perf/builtin-kwork.c
index 9c488d647995..b1993be0a20a 100644
--- a/tools/perf/builtin-kwork.c
+++ b/tools/perf/builtin-kwork.c
@@ -479,16 +479,75 @@ static int report_exit_event(struct perf_kwork *kwork,
 	return 0;
 }
 
+static struct kwork_class kwork_irq;
+static int process_irq_handler_entry_event(struct perf_tool *tool,
+					   struct evsel *evsel,
+					   struct perf_sample *sample,
+					   struct machine *machine)
+{
+	struct perf_kwork *kwork = container_of(tool, struct perf_kwork, tool);
+
+	if (kwork->tp_handler->entry_event)
+		return kwork->tp_handler->entry_event(kwork, &kwork_irq,
+						      evsel, sample, machine);
+	return 0;
+}
+
+static int process_irq_handler_exit_event(struct perf_tool *tool,
+					  struct evsel *evsel,
+					  struct perf_sample *sample,
+					  struct machine *machine)
+{
+	struct perf_kwork *kwork = container_of(tool, struct perf_kwork, tool);
+
+	if (kwork->tp_handler->exit_event)
+		return kwork->tp_handler->exit_event(kwork, &kwork_irq,
+						     evsel, sample, machine);
+	return 0;
+}
+
 const struct evsel_str_handler irq_tp_handlers[] = {
-	{ "irq:irq_handler_entry", NULL, },
-	{ "irq:irq_handler_exit",  NULL, },
+	{ "irq:irq_handler_entry", process_irq_handler_entry_event, },
+	{ "irq:irq_handler_exit",  process_irq_handler_exit_event,  },
 };
 
+static int irq_class_init(struct kwork_class *class,
+			  struct perf_session *session)
+{
+	if (perf_session__set_tracepoints_handlers(session, irq_tp_handlers)) {
+		pr_err("Failed to set irq tracepoints handlers\n");
+		return -1;
+	}
+
+	class->work_root = RB_ROOT_CACHED;
+	return 0;
+}
+
+static void irq_work_init(struct kwork_class *class,
+			  struct kwork_work *work,
+			  struct evsel *evsel,
+			  struct perf_sample *sample,
+			  struct machine *machine __maybe_unused)
+{
+	work->class = class;
+	work->cpu = sample->cpu;
+	work->id = evsel__intval(evsel, sample, "irq");
+	work->name = evsel__strval(evsel, sample, "name");
+}
+
+static void irq_work_name(struct kwork_work *work, char *buf, int len)
+{
+	snprintf(buf, len, "%s:%" PRIu64 "", work->name, work->id);
+}
+
 static struct kwork_class kwork_irq = {
 	.name           = "irq",
 	.type           = KWORK_CLASS_IRQ,
 	.nr_tracepoints = 2,
 	.tp_handlers    = irq_tp_handlers,
+	.class_init     = irq_class_init,
+	.work_init      = irq_work_init,
+	.work_name      = irq_work_name,
 };
 
 const struct evsel_str_handler softirq_tp_handlers[] = {
-- 
2.30.GIT

