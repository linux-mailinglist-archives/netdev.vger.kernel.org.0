Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A962559AEB
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbiFXOGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbiFXOGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:06:11 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CF14EDD8;
        Fri, 24 Jun 2022 07:06:10 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LTzPT2d6lzdZNt;
        Fri, 24 Jun 2022 22:03:57 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:07 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:06 +0800
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
Subject: [RFC v2 11/17] perf kwork: Add softirq latency support
Date:   Fri, 24 Jun 2022 22:03:43 +0800
Message-ID: <20220624140349.16964-12-yangjihong1@huawei.com>
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

Implements softirq latency function.

Test cases:

  # perf kwork -k softirq lat

    Kwork Name                     | Cpu  | Avg delay     | Count     | Max delay     | Max delay start     | Max delay end       |
   --------------------------------------------------------------------------------------------------------------------------------
    (s)TIMER:1                     | 0006 |      1.048 ms |         1 |      1.048 ms |      44000.829759 s |      44000.830807 s |
    (s)TIMER:1                     | 0001 |      1.008 ms |         4 |      3.434 ms |      43997.662069 s |      43997.665503 s |
    (s)RCU:9                       | 0006 |      0.675 ms |         7 |      1.328 ms |      43997.670304 s |      43997.671632 s |
    (s)RCU:9                       | 0000 |      0.414 ms |       701 |      3.996 ms |      43997.661170 s |      43997.665167 s |
    (s)RCU:9                       | 0005 |      0.245 ms |        88 |      1.866 ms |      43997.683105 s |      43997.684971 s |
    (s)SCHED:7                     | 0000 |      0.158 ms |       677 |      2.639 ms |      44004.785716 s |      44004.788355 s |
    ... <SNIP> ...
    (s)RCU:9                       | 0002 |      0.141 ms |       932 |      1.662 ms |      44005.010206 s |      44005.011868 s |
    (s)RCU:9                       | 0003 |      0.129 ms |      2193 |      1.507 ms |      44006.010208 s |      44006.011715 s |
    (s)TIMER:1                     | 0005 |      0.128 ms |         1 |      0.128 ms |      44007.820346 s |      44007.820474 s |
    (s)SCHED:7                     | 0002 |      0.040 ms |      1731 |      0.211 ms |      44005.009237 s |      44005.009447 s |
   --------------------------------------------------------------------------------------------------------------------------------

  # perf kwork -k softirq lat -C 1,2

    Kwork Name                     | Cpu  | Avg delay     | Count     | Max delay     | Max delay start     | Max delay end       |
   --------------------------------------------------------------------------------------------------------------------------------
    (s)TIMER:1                     | 0001 |      1.008 ms |         4 |      3.434 ms |      43997.662069 s |      43997.665503 s |
    (s)RCU:9                       | 0001 |      0.216 ms |      1619 |      3.659 ms |      43997.662069 s |      43997.665727 s |
    (s)RCU:9                       | 0002 |      0.141 ms |       932 |      1.662 ms |      44005.010206 s |      44005.011868 s |
    (s)NET_RX:3                    | 0002 |      0.106 ms |         5 |      0.163 ms |      44005.012255 s |      44005.012418 s |
    (s)TIMER:1                     | 0002 |      0.084 ms |         9 |      0.114 ms |      44005.009168 s |      44005.009282 s |
    (s)SCHED:7                     | 0001 |      0.049 ms |       655 |      0.837 ms |      44005.707998 s |      44005.708835 s |
    (s)SCHED:7                     | 0002 |      0.040 ms |      1731 |      0.211 ms |      44005.009237 s |      44005.009447 s |
   --------------------------------------------------------------------------------------------------------------------------------

  # perf kwork -k softirq lat -n RCU

    Kwork Name                     | Cpu  | Avg delay     | Count     | Max delay     | Max delay start     | Max delay end       |
   --------------------------------------------------------------------------------------------------------------------------------
    (s)RCU:9                       | 0006 |      0.675 ms |         7 |      1.328 ms |      43997.670304 s |      43997.671632 s |
    (s)RCU:9                       | 0000 |      0.414 ms |       701 |      3.996 ms |      43997.661170 s |      43997.665167 s |
    (s)RCU:9                       | 0005 |      0.245 ms |        88 |      1.866 ms |      43997.683105 s |      43997.684971 s |
    (s)RCU:9                       | 0004 |      0.237 ms |        26 |      0.792 ms |      43997.683018 s |      43997.683810 s |
    (s)RCU:9                       | 0007 |      0.217 ms |       140 |      1.335 ms |      43997.671080 s |      43997.672415 s |
    (s)RCU:9                       | 0001 |      0.216 ms |      1619 |      3.659 ms |      43997.662069 s |      43997.665727 s |
    (s)RCU:9                       | 0002 |      0.141 ms |       932 |      1.662 ms |      44005.010206 s |      44005.011868 s |
    (s)RCU:9                       | 0003 |      0.129 ms |      2193 |      1.507 ms |      44006.010208 s |      44006.011715 s |
   --------------------------------------------------------------------------------------------------------------------------------

  # perf kwork -k softirq lat -s freq,avg -n RCU

    Kwork Name                     | Cpu  | Avg delay     | Count     | Max delay     | Max delay start     | Max delay end       |
   --------------------------------------------------------------------------------------------------------------------------------
    (s)RCU:9                       | 0003 |      0.129 ms |      2193 |      1.507 ms |      44006.010208 s |      44006.011715 s |
    (s)RCU:9                       | 0001 |      0.216 ms |      1619 |      3.659 ms |      43997.662069 s |      43997.665727 s |
    (s)RCU:9                       | 0002 |      0.141 ms |       932 |      1.662 ms |      44005.010206 s |      44005.011868 s |
    (s)RCU:9                       | 0000 |      0.414 ms |       701 |      3.996 ms |      43997.661170 s |      43997.665167 s |
    (s)RCU:9                       | 0007 |      0.217 ms |       140 |      1.335 ms |      43997.671080 s |      43997.672415 s |
    (s)RCU:9                       | 0005 |      0.245 ms |        88 |      1.866 ms |      43997.683105 s |      43997.684971 s |
    (s)RCU:9                       | 0004 |      0.237 ms |        26 |      0.792 ms |      43997.683018 s |      43997.683810 s |
    (s)RCU:9                       | 0006 |      0.675 ms |         7 |      1.328 ms |      43997.670304 s |      43997.671632 s |
   --------------------------------------------------------------------------------------------------------------------------------

  # perf kwork -k softirq lat --time 43997,

    Kwork Name                     | Cpu  | Avg delay     | Count     | Max delay     | Max delay start     | Max delay end       |
   --------------------------------------------------------------------------------------------------------------------------------
    (s)TIMER:1                     | 0006 |      1.048 ms |         1 |      1.048 ms |      44000.829759 s |      44000.830807 s |
    (s)TIMER:1                     | 0001 |      1.008 ms |         4 |      3.434 ms |      43997.662069 s |      43997.665503 s |
    (s)RCU:9                       | 0006 |      0.675 ms |         7 |      1.328 ms |      43997.670304 s |      43997.671632 s |
    (s)RCU:9                       | 0000 |      0.414 ms |       701 |      3.996 ms |      43997.661170 s |      43997.665167 s |
    (s)TIMER:1                     | 0004 |      0.083 ms |        21 |      0.127 ms |      44004.969171 s |      44004.969298 s |
    ... <SNIP> ...
    (s)SCHED:7                     | 0005 |      0.050 ms |         4 |      0.086 ms |      43997.684852 s |      43997.684938 s |
    (s)SCHED:7                     | 0001 |      0.049 ms |       655 |      0.837 ms |      44005.707998 s |      44005.708835 s |
    (s)SCHED:7                     | 0007 |      0.044 ms |       171 |      0.077 ms |      43997.943265 s |      43997.943342 s |
    (s)SCHED:7                     | 0002 |      0.040 ms |      1731 |      0.211 ms |      44005.009237 s |      44005.009447 s |
   --------------------------------------------------------------------------------------------------------------------------------

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/perf/builtin-kwork.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-kwork.c b/tools/perf/builtin-kwork.c
index cc2c090fc2f0..fa09d4eea913 100644
--- a/tools/perf/builtin-kwork.c
+++ b/tools/perf/builtin-kwork.c
@@ -646,6 +646,20 @@ static struct kwork_class kwork_irq = {
 };
 
 static struct kwork_class kwork_softirq;
+static int process_softirq_raise_event(struct perf_tool *tool,
+				       struct evsel *evsel,
+				       struct perf_sample *sample,
+				       struct machine *machine)
+{
+	struct perf_kwork *kwork = container_of(tool, struct perf_kwork, tool);
+
+	if (kwork->tp_handler->raise_event)
+		return kwork->tp_handler->raise_event(kwork, &kwork_softirq,
+						      evsel, sample, machine);
+
+	return 0;
+}
+
 static int process_softirq_entry_event(struct perf_tool *tool,
 				       struct evsel *evsel,
 				       struct perf_sample *sample,
@@ -675,7 +689,7 @@ static int process_softirq_exit_event(struct perf_tool *tool,
 }
 
 const struct evsel_str_handler softirq_tp_handlers[] = {
-	{ "irq:softirq_raise", NULL, },
+	{ "irq:softirq_raise", process_softirq_raise_event, },
 	{ "irq:softirq_entry", process_softirq_entry_event, },
 	{ "irq:softirq_exit",  process_softirq_exit_event,  },
 };
-- 
2.30.GIT

