Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2B860EE8
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 06:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfGFEfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 00:35:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26724 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbfGFEfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 00:35:36 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x664Y3bX003702
        for <netdev@vger.kernel.org>; Fri, 5 Jul 2019 21:35:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=9KN4Zeh2CbHl7d0xXD7GMMMjfV5LdC26AU5gC4FU9SU=;
 b=NnyUTt/i3eXPGNkemUWYxIyZ08vlK8S9wgy8U2ZrYtLRW7PgJpvvsHzA/g9F45VS/K/0
 xwhF1XCBis0Ix+An0nG0McNsKBQuTSd1DInCIJ5jvIbVIMeaeecYs8678l/LZa24kSg1
 0KJqvIYiQllmdSogTfj+u/g6bbcr0/vw6+A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2thxs5c6qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 21:35:36 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 5 Jul 2019 21:35:34 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id D49D786163A; Fri,  5 Jul 2019 21:35:32 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v5 bpf-next 3/5] selftests/bpf: test perf buffer API
Date:   Fri, 5 Jul 2019 21:35:20 -0700
Message-ID: <20190706043522.1559005-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190706043522.1559005-1-andriin@fb.com>
References: <20190706043522.1559005-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907060058
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test verifying perf buffer API functionality.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/perf_buffer.c    | 94 +++++++++++++++++++
 .../selftests/bpf/progs/test_perf_buffer.c    | 25 +++++
 2 files changed, 119 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_buffer.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_perf_buffer.c

diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
new file mode 100644
index 000000000000..64556ab0d1a9
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <pthread.h>
+#include <sched.h>
+#include <sys/socket.h>
+#include <test_progs.h>
+
+static void on_sample(void *ctx, int cpu, void *data, __u32 size)
+{
+	int cpu_data = *(int *)data, duration = 0;
+	cpu_set_t *cpu_seen = ctx;
+
+	if (cpu_data != cpu)
+		CHECK(cpu_data != cpu, "check_cpu_data",
+		      "cpu_data %d != cpu %d\n", cpu_data, cpu);
+
+	CPU_SET(cpu, cpu_seen);
+}
+
+void test_perf_buffer(void)
+{
+	int err, prog_fd, nr_cpus, i, duration = 0;
+	const char *prog_name = "kprobe/sys_nanosleep";
+	const char *file = "./test_perf_buffer.o";
+	struct perf_buffer_opts pb_opts = {};
+	struct bpf_map *perf_buf_map;
+	cpu_set_t cpu_set, cpu_seen;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	struct perf_buffer *pb;
+	struct bpf_link *link;
+
+	nr_cpus = libbpf_num_possible_cpus();
+	if (CHECK(nr_cpus < 0, "nr_cpus", "err %d\n", nr_cpus))
+		return;
+
+	/* load program */
+	err = bpf_prog_load(file, BPF_PROG_TYPE_KPROBE, &obj, &prog_fd);
+	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
+		return;
+
+	prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!prog, "find_probe", "prog '%s' not found\n", prog_name))
+		goto out_close;
+
+	/* load map */
+	perf_buf_map = bpf_object__find_map_by_name(obj, "perf_buf_map");
+	if (CHECK(!perf_buf_map, "find_perf_buf_map", "not found\n"))
+		goto out_close;
+
+	/* attach kprobe */
+	link = bpf_program__attach_kprobe(prog, false /* retprobe */,
+					      "sys_nanosleep");
+	if (CHECK(IS_ERR(link), "attach_kprobe", "err %ld\n", PTR_ERR(link)))
+		goto out_close;
+
+	/* set up perf buffer */
+	pb_opts.sample_cb = on_sample;
+	pb_opts.ctx = &cpu_seen;
+	pb = perf_buffer__new(bpf_map__fd(perf_buf_map), 1, &pb_opts);
+	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
+		goto out_detach;
+
+	/* trigger kprobe on every CPU */
+	CPU_ZERO(&cpu_seen);
+	for (i = 0; i < nr_cpus; i++) {
+		CPU_ZERO(&cpu_set);
+		CPU_SET(i, &cpu_set);
+
+		err = pthread_setaffinity_np(pthread_self(), sizeof(cpu_set),
+					     &cpu_set);
+		if (err && CHECK(err, "set_affinity", "cpu #%d, err %d\n",
+				 i, err))
+			goto out_detach;
+
+		usleep(1);
+	}
+
+	/* read perf buffer */
+	err = perf_buffer__poll(pb, 100);
+	if (CHECK(err < 0, "perf_buffer__poll", "err %d\n", err))
+		goto out_free_pb;
+
+	if (CHECK(CPU_COUNT(&cpu_seen) != nr_cpus, "seen_cpu_cnt",
+		  "expect %d, seen %d\n", nr_cpus, CPU_COUNT(&cpu_seen)))
+		goto out_free_pb;
+
+out_free_pb:
+	perf_buffer__free(pb);
+out_detach:
+	bpf_link__destroy(link);
+out_close:
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_perf_buffer.c b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
new file mode 100644
index 000000000000..876c27deb65a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/ptrace.h>
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+} perf_buf_map SEC(".maps");
+
+SEC("kprobe/sys_nanosleep")
+int handle_sys_nanosleep_entry(struct pt_regs *ctx)
+{
+	int cpu = bpf_get_smp_processor_id();
+
+	bpf_perf_event_output(ctx, &perf_buf_map, BPF_F_CURRENT_CPU,
+			      &cpu, sizeof(cpu));
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
-- 
2.17.1

