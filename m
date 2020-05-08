Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7861CBB2E
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbgEHXUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:20:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16460 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728140AbgEHXUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 19:20:48 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048NFdTh017450
        for <netdev@vger.kernel.org>; Fri, 8 May 2020 16:20:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=FO7AVr1QnNoclHuHJMc+/AY2inC1AzFC3qF+Nzjrl6M=;
 b=gcVT/m/uwjUAMNPiK3v7c+i0UJl81ZpUNS2M2nyw84DSvK1YjjdWOXA/VZsjGeT8hMJM
 WVNVRK5rmsAdg9qYg+sv+nyUzW2keFto052PJjxcTdxDX0nvufLmhKv+eJJR9d0j+QF3
 3GxlBVXDnhhNvC592V42mZkdhMBa1zt1qKs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30wet48n4e-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 16:20:47 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 16:20:44 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5B5C22EC321F; Fri,  8 May 2020 16:20:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/3] selftest/bpf: fmod_ret prog and implement test_overhead as part of bench
Date:   Fri, 8 May 2020 16:20:31 -0700
Message-ID: <20200508232032.1974027-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200508232032.1974027-1-andriin@fb.com>
References: <20200508232032.1974027-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_20:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 mlxscore=0 malwarescore=0
 suspectscore=9 mlxlogscore=999 priorityscore=1501 bulkscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080195
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add fmod_ret BPF program to existing test_overhead selftest. Also re-impl=
ement
user-space benchmarking part into benchmark runner to compare results.  R=
esults
with ./bench are consistently somewhat lower than test_overhead's, but re=
lative
performance of various types of BPF programs stay consisten (e.g., kretpr=
obe is
noticeably slower).

run_bench_rename.sh script (in benchs/ directory) was used to produce the
following numbers:

  base      :    3.975 =C2=B1 0.065M/s
  kprobe    :    3.268 =C2=B1 0.095M/s
  kretprobe :    2.496 =C2=B1 0.040M/s
  rawtp     :    3.899 =C2=B1 0.078M/s
  fentry    :    3.836 =C2=B1 0.049M/s
  fexit     :    3.660 =C2=B1 0.082M/s
  fmodret   :    3.776 =C2=B1 0.033M/s

While running test_overhead gives:

  task_rename base        4457K events per sec
  task_rename kprobe      3849K events per sec
  task_rename kretprobe   2729K events per sec
  task_rename raw_tp      4506K events per sec
  task_rename fentry      4381K events per sec
  task_rename fexit       4349K events per sec
  task_rename fmod_ret    4130K events per sec

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile          |   4 +-
 tools/testing/selftests/bpf/bench.c           |  14 ++
 .../selftests/bpf/benchs/bench_rename.c       | 195 ++++++++++++++++++
 .../selftests/bpf/benchs/run_bench_rename.sh  |   9 +
 .../selftests/bpf/prog_tests/test_overhead.c  |  14 +-
 .../selftests/bpf/progs/test_overhead.c       |   6 +
 6 files changed, 240 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_rename.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_rename.s=
h

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 289fffbf975e..29a02abf81a3 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -409,10 +409,12 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_cor=
e_extern.skel.h $(BPFOBJ)
 $(OUTPUT)/bench_%.o: benchs/bench_%.c bench.h
 	$(call msg,CC,,$@)
 	$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
+$(OUTPUT)/bench_rename.o: $(OUTPUT)/test_overhead.skel.h
 $(OUTPUT)/bench.o: bench.h
 $(OUTPUT)/bench: LDLIBS +=3D -lm
 $(OUTPUT)/bench: $(OUTPUT)/bench.o \
-		 $(OUTPUT)/bench_count.o
+		 $(OUTPUT)/bench_count.o \
+		 $(OUTPUT)/bench_rename.o
 	$(call msg,BINARY,,$@)
 	$(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
=20
diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftest=
s/bpf/bench.c
index dddc97cd4db6..650697df47af 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -254,10 +254,24 @@ const struct bench *bench =3D NULL;
=20
 extern const struct bench bench_count_global;
 extern const struct bench bench_count_local;
+extern const struct bench bench_rename_base;
+extern const struct bench bench_rename_kprobe;
+extern const struct bench bench_rename_kretprobe;
+extern const struct bench bench_rename_rawtp;
+extern const struct bench bench_rename_fentry;
+extern const struct bench bench_rename_fexit;
+extern const struct bench bench_rename_fmodret;
=20
 static const struct bench *benchs[] =3D {
 	&bench_count_global,
 	&bench_count_local,
+	&bench_rename_base,
+	&bench_rename_kprobe,
+	&bench_rename_kretprobe,
+	&bench_rename_rawtp,
+	&bench_rename_fentry,
+	&bench_rename_fexit,
+	&bench_rename_fmodret,
 };
=20
 static void setup_benchmark()
diff --git a/tools/testing/selftests/bpf/benchs/bench_rename.c b/tools/te=
sting/selftests/bpf/benchs/bench_rename.c
new file mode 100644
index 000000000000..e74cff40f4fe
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/bench_rename.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <fcntl.h>
+#include "bench.h"
+#include "test_overhead.skel.h"
+
+/* BPF triggering benchmarks */
+static struct ctx {
+	struct test_overhead *skel;
+	struct counter hits;
+	int fd;
+} ctx;
+
+static void validate()
+{
+	if (env.producer_cnt !=3D 1) {
+		fprintf(stderr, "benchmark doesn't support multi-producer!\n");
+		exit(1);
+	}
+	if (env.consumer_cnt !=3D 1) {
+		fprintf(stderr, "benchmark doesn't support multi-consumer!\n");
+		exit(1);
+	}
+}
+
+static void *producer(void *input)
+{
+	char buf[] =3D "test_overhead";
+	int err;
+
+	while (true) {
+		err =3D write(ctx.fd, buf, sizeof(buf));
+		if (err < 0) {
+			fprintf(stderr, "write failed\n");
+			exit(1);
+		}
+		atomic_inc(&ctx.hits.value);
+	}
+}
+
+static void measure(struct bench_res *res)
+{
+	res->hits =3D atomic_swap(&ctx.hits.value, 0);
+}
+
+static void setup_ctx()
+{
+	setup_libbpf();
+
+	ctx.skel =3D test_overhead__open_and_load();
+	if (!ctx.skel) {
+		fprintf(stderr, "failed to open skeleton\n");
+		exit(1);
+	}
+
+	ctx.fd =3D open("/proc/self/comm", O_WRONLY|O_TRUNC);
+	if (ctx.fd < 0) {
+		fprintf(stderr, "failed to open /proc/self/comm: %d\n", -errno);
+		exit(1);
+	}
+}
+
+static void attach_bpf(struct bpf_program *prog)
+{
+	struct bpf_link *link;
+
+	link =3D bpf_program__attach(prog);
+	if (IS_ERR(link)) {
+		fprintf(stderr, "failed to attach program!\n");
+		exit(1);
+	}
+}
+
+static void setup_base()
+{
+	setup_ctx();
+}
+
+static void setup_kprobe()
+{
+	setup_ctx();
+	attach_bpf(ctx.skel->progs.prog1);
+}
+
+static void setup_kretprobe()
+{
+	setup_ctx();
+	attach_bpf(ctx.skel->progs.prog2);
+}
+
+static void setup_rawtp()
+{
+	setup_ctx();
+	attach_bpf(ctx.skel->progs.prog3);
+}
+
+static void setup_fentry()
+{
+	setup_ctx();
+	attach_bpf(ctx.skel->progs.prog4);
+}
+
+static void setup_fexit()
+{
+	setup_ctx();
+	attach_bpf(ctx.skel->progs.prog5);
+}
+
+static void setup_fmodret()
+{
+	setup_ctx();
+	attach_bpf(ctx.skel->progs.prog6);
+}
+
+static void *consumer(void *input)
+{
+	return NULL;
+}
+
+const struct bench bench_rename_base =3D {
+	.name =3D "rename-base",
+	.validate =3D validate,
+	.setup =3D setup_base,
+	.producer_thread =3D producer,
+	.consumer_thread =3D consumer,
+	.measure =3D measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_rename_kprobe =3D {
+	.name =3D "rename-kprobe",
+	.validate =3D validate,
+	.setup =3D setup_kprobe,
+	.producer_thread =3D producer,
+	.consumer_thread =3D consumer,
+	.measure =3D measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_rename_kretprobe =3D {
+	.name =3D "rename-kretprobe",
+	.validate =3D validate,
+	.setup =3D setup_kretprobe,
+	.producer_thread =3D producer,
+	.consumer_thread =3D consumer,
+	.measure =3D measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_rename_rawtp =3D {
+	.name =3D "rename-rawtp",
+	.validate =3D validate,
+	.setup =3D setup_rawtp,
+	.producer_thread =3D producer,
+	.consumer_thread =3D consumer,
+	.measure =3D measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_rename_fentry =3D {
+	.name =3D "rename-fentry",
+	.validate =3D validate,
+	.setup =3D setup_fentry,
+	.producer_thread =3D producer,
+	.consumer_thread =3D consumer,
+	.measure =3D measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_rename_fexit =3D {
+	.name =3D "rename-fexit",
+	.validate =3D validate,
+	.setup =3D setup_fexit,
+	.producer_thread =3D producer,
+	.consumer_thread =3D consumer,
+	.measure =3D measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_rename_fmodret =3D {
+	.name =3D "rename-fmodret",
+	.validate =3D validate,
+	.setup =3D setup_fmodret,
+	.producer_thread =3D producer,
+	.consumer_thread =3D consumer,
+	.measure =3D measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
diff --git a/tools/testing/selftests/bpf/benchs/run_bench_rename.sh b/too=
ls/testing/selftests/bpf/benchs/run_bench_rename.sh
new file mode 100755
index 000000000000..16f774b1cdbe
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/run_bench_rename.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -eufo pipefail
+
+for i in base kprobe kretprobe rawtp fentry fexit fmodret
+do
+	summary=3D$(sudo ./bench -w2 -d5 -a rename-$i | tail -n1 | cut -d'(' -f=
1 | cut -d' ' -f3-)
+	printf "%-10s: %s\n" $i "$summary"
+done
diff --git a/tools/testing/selftests/bpf/prog_tests/test_overhead.c b/too=
ls/testing/selftests/bpf/prog_tests/test_overhead.c
index 465b371a561d..2702df2b2343 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_overhead.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_overhead.c
@@ -61,9 +61,10 @@ void test_test_overhead(void)
 	const char *raw_tp_name =3D "raw_tp/task_rename";
 	const char *fentry_name =3D "fentry/__set_task_comm";
 	const char *fexit_name =3D "fexit/__set_task_comm";
+	const char *fmodret_name =3D "fmod_ret/__set_task_comm";
 	const char *kprobe_func =3D "__set_task_comm";
 	struct bpf_program *kprobe_prog, *kretprobe_prog, *raw_tp_prog;
-	struct bpf_program *fentry_prog, *fexit_prog;
+	struct bpf_program *fentry_prog, *fexit_prog, *fmodret_prog;
 	struct bpf_object *obj;
 	struct bpf_link *link;
 	int err, duration =3D 0;
@@ -96,6 +97,10 @@ void test_test_overhead(void)
 	if (CHECK(!fexit_prog, "find_probe",
 		  "prog '%s' not found\n", fexit_name))
 		goto cleanup;
+	fmodret_prog =3D bpf_object__find_program_by_title(obj, fmodret_name);
+	if (CHECK(!fmodret_prog, "find_probe",
+		  "prog '%s' not found\n", fmodret_name))
+		goto cleanup;
=20
 	err =3D bpf_object__load(obj);
 	if (CHECK(err, "obj_load", "err %d\n", err))
@@ -142,6 +147,13 @@ void test_test_overhead(void)
 		goto cleanup;
 	test_run("fexit");
 	bpf_link__destroy(link);
+
+	/* attach fmod_ret */
+	link =3D bpf_program__attach_trace(fmodret_prog);
+	if (CHECK(IS_ERR(link), "attach fmod_ret", "err %ld\n", PTR_ERR(link)))
+		goto cleanup;
+	test_run("fmod_ret");
+	bpf_link__destroy(link);
 cleanup:
 	prctl(PR_SET_NAME, comm, 0L, 0L, 0L);
 	bpf_object__close(obj);
diff --git a/tools/testing/selftests/bpf/progs/test_overhead.c b/tools/te=
sting/selftests/bpf/progs/test_overhead.c
index 56a50b25cd33..450bf819beac 100644
--- a/tools/testing/selftests/bpf/progs/test_overhead.c
+++ b/tools/testing/selftests/bpf/progs/test_overhead.c
@@ -39,4 +39,10 @@ int BPF_PROG(prog5, struct task_struct *tsk, const cha=
r *buf, bool exec)
 	return !tsk;
 }
=20
+SEC("fmod_ret/__set_task_comm")
+int BPF_PROG(prog6, struct task_struct *tsk, const char *buf, bool exec)
+{
+	return !tsk;
+}
+
 char _license[] SEC("license") =3D "GPL";
--=20
2.24.1

