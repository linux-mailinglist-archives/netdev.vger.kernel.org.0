Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889F6559B16
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiFXOGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbiFXOGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:06:25 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA964EDD7;
        Fri, 24 Jun 2022 07:06:08 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LTzRC1vSPzDsC8;
        Fri, 24 Jun 2022 22:05:27 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:02 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:01 +0800
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
Subject: [RFC v2 04/17] perf kwork: Add workqueue kwork record support
Date:   Fri, 24 Jun 2022 22:03:36 +0800
Message-ID: <20220624140349.16964-5-yangjihong1@huawei.com>
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

Record workqueue events workqueue:workqueue_activate_work,
workqueue:workqueue_execute_start & workqueue:workqueue_execute_end

Tese cases:
Record all events:

  # perf kwork record -o perf_kwork.date -- sleep 1
  [ perf record: Woken up 0 times to write data ]
  [ perf record: Captured and wrote 0.857 MB perf_kwork.date ]
  #
  # perf evlist -i perf_kwork.date
  irq:irq_handler_entry
  irq:irq_handler_exit
  irq:softirq_raise
  irq:softirq_entry
  irq:softirq_exit
  workqueue:workqueue_activate_work
  workqueue:workqueue_execute_start
  workqueue:workqueue_execute_end
  dummy:HG
  # Tip: use 'perf evlist --trace-fields' to show fields for tracepoint events

Record workqueue events:

  # perf kwork -k workqueue record -o perf_kwork.date -- sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.081 MB perf_kwork.date ]
  #
  # perf evlist -i perf_kwork.date
  workqueue:workqueue_activate_work
  workqueue:workqueue_execute_start
  workqueue:workqueue_execute_end
  dummy:HG
  # Tip: use 'perf evlist --trace-fields' to show fields for tracepoint events

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/perf/Documentation/perf-kwork.txt |  2 +-
 tools/perf/builtin-kwork.c              | 16 +++++++++++++++-
 tools/perf/util/kwork.h                 |  1 +
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-kwork.txt b/tools/perf/Documentation/perf-kwork.txt
index abfdeca2ad39..c5b52f61da99 100644
--- a/tools/perf/Documentation/perf-kwork.txt
+++ b/tools/perf/Documentation/perf-kwork.txt
@@ -32,7 +32,7 @@ OPTIONS
 
 -k::
 --kwork::
-	List of kwork to profile (irq, softirq, etc)
+	List of kwork to profile (irq, softirq, workqueue, etc)
 
 -v::
 --verbose::
diff --git a/tools/perf/builtin-kwork.c b/tools/perf/builtin-kwork.c
index 2c492c8fd019..8086236b7513 100644
--- a/tools/perf/builtin-kwork.c
+++ b/tools/perf/builtin-kwork.c
@@ -50,9 +50,23 @@ static struct kwork_class kwork_softirq = {
 	.tp_handlers    = softirq_tp_handlers,
 };
 
+const struct evsel_str_handler workqueue_tp_handlers[] = {
+	{ "workqueue:workqueue_activate_work", NULL, },
+	{ "workqueue:workqueue_execute_start", NULL, },
+	{ "workqueue:workqueue_execute_end",   NULL, },
+};
+
+static struct kwork_class kwork_workqueue = {
+	.name           = "workqueue",
+	.type           = KWORK_CLASS_WORKQUEUE,
+	.nr_tracepoints = 3,
+	.tp_handlers    = workqueue_tp_handlers,
+};
+
 static struct kwork_class *kwork_class_supported_list[KWORK_CLASS_MAX] = {
 	[KWORK_CLASS_IRQ]       = &kwork_irq,
 	[KWORK_CLASS_SOFTIRQ]   = &kwork_softirq,
+	[KWORK_CLASS_WORKQUEUE] = &kwork_workqueue,
 };
 
 static void setup_event_list(struct perf_kwork *kwork,
@@ -159,7 +173,7 @@ int cmd_kwork(int argc, const char **argv)
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "kwork", &kwork.event_list_str, "kwork",
-		   "list of kwork to profile (irq, softirq, etc)"),
+		   "list of kwork to profile (irq, softirq, workqueue, etc)"),
 	OPT_BOOLEAN('f', "force", &kwork.force, "don't complain, do it"),
 	OPT_END()
 	};
diff --git a/tools/perf/util/kwork.h b/tools/perf/util/kwork.h
index 669a81626cb4..03203c4deb34 100644
--- a/tools/perf/util/kwork.h
+++ b/tools/perf/util/kwork.h
@@ -15,6 +15,7 @@
 enum kwork_class_type {
 	KWORK_CLASS_IRQ,
 	KWORK_CLASS_SOFTIRQ,
+	KWORK_CLASS_WORKQUEUE,
 	KWORK_CLASS_MAX,
 };
 
-- 
2.30.GIT

