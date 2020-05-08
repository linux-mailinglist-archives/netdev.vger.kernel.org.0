Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F661CBB32
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgEHXUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:20:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15406 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727110AbgEHXUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 19:20:50 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048NEQOd005334
        for <netdev@vger.kernel.org>; Fri, 8 May 2020 16:20:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=ztVEm21APc/fosbQ/TajSxS5qcr0EFSdvknqAl5HY2w=;
 b=qqe8YsCKelO1GZMbAU6ZhRWEmLxiUbXyt2YGcHI1X34zwcBD1G8bqbakXB5/MKjLpwiY
 j2WukeKfmWqvnVR1lXsm8ACPA+pqlHmsCVfjhtTrA3My8Xm/KZYwGNDQLcxsa+E8Z+W/
 /QvRTL8pX6n7i3X85lj1FBENZ3pYSsY8+7Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30vtdf6ngs-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 16:20:48 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 16:20:46 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8D0892EC321F; Fri,  8 May 2020 16:20:42 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/3] selftest/bpf: add BPF triggering benchmark
Date:   Fri, 8 May 2020 16:20:32 -0700
Message-ID: <20200508232032.1974027-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200508232032.1974027-1-andriin@fb.com>
References: <20200508232032.1974027-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_20:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=9
 impostorscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080195
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is sometimes desirable to be able to trigger BPF program from user-spa=
ce
with minimal overhead. sys_enter would seem to be a good candidate, yet i=
n
a lot of cases there will be a lot of noise from syscalls triggered by ot=
her
processes on the system. So while searching for low-overhead alternative,=
 I've
stumbled upon getpgid() syscall, which seems to be specific enough to not
suffer from accidental syscall by other apps.

This set of benchmarks compares tp, raw_tp w/ filtering by syscall ID, kp=
robe,
fentry and fmod_ret with returning error (so that syscall would not be
executed), to determine the lowest-overhead way. Here are results on my
machine (using benchs/run_bench_trigger.sh script):

  base      :    9.200 =C2=B1 0.319M/s
  tp        :    6.690 =C2=B1 0.125M/s
  rawtp     :    8.571 =C2=B1 0.214M/s
  kprobe    :    6.431 =C2=B1 0.048M/s
  fentry    :    8.955 =C2=B1 0.241M/s
  fmodret   :    8.903 =C2=B1 0.135M/s

So it seems like fmodret doesn't give much benefit for such lightweight
syscall. Raw tracepoint is pretty decent despite additional filtering log=
ic,
but it will be called for any other syscall in the system, which rules it=
 out.
Fentry, though, seems to be adding the least amoung of overhead and achie=
ves
97.3% of performance of baseline no-BPF-attached syscall.

Using getpgid() seems to be preferable to set_task_comm() approach from
test_overhead, as it's about 2.35x faster in a baseline performance.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile          |   4 +-
 tools/testing/selftests/bpf/bench.c           |  12 ++
 .../selftests/bpf/benchs/bench_trigger.c      | 167 ++++++++++++++++++
 .../selftests/bpf/benchs/run_bench_trigger.sh |   9 +
 .../selftests/bpf/progs/trigger_bench.c       |  47 +++++
 5 files changed, 238 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_trigger.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_trigger.=
sh
 create mode 100644 tools/testing/selftests/bpf/progs/trigger_bench.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 29a02abf81a3..45c68111fb48 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -410,11 +410,13 @@ $(OUTPUT)/bench_%.o: benchs/bench_%.c bench.h
 	$(call msg,CC,,$@)
 	$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
 $(OUTPUT)/bench_rename.o: $(OUTPUT)/test_overhead.skel.h
+$(OUTPUT)/bench_trigger.o: $(OUTPUT)/trigger_bench.skel.h
 $(OUTPUT)/bench.o: bench.h
 $(OUTPUT)/bench: LDLIBS +=3D -lm
 $(OUTPUT)/bench: $(OUTPUT)/bench.o \
 		 $(OUTPUT)/bench_count.o \
-		 $(OUTPUT)/bench_rename.o
+		 $(OUTPUT)/bench_rename.o \
+		 $(OUTPUT)/bench_trigger.o
 	$(call msg,BINARY,,$@)
 	$(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
=20
diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftest=
s/bpf/bench.c
index 650697df47af..03ce436fee3e 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -261,6 +261,12 @@ extern const struct bench bench_rename_rawtp;
 extern const struct bench bench_rename_fentry;
 extern const struct bench bench_rename_fexit;
 extern const struct bench bench_rename_fmodret;
+extern const struct bench bench_trig_base;
+extern const struct bench bench_trig_tp;
+extern const struct bench bench_trig_rawtp;
+extern const struct bench bench_trig_kprobe;
+extern const struct bench bench_trig_fentry;
+extern const struct bench bench_trig_fmodret;
=20
 static const struct bench *benchs[] =3D {
 	&bench_count_global,
@@ -272,6 +278,12 @@ static const struct bench *benchs[] =3D {
 	&bench_rename_fentry,
 	&bench_rename_fexit,
 	&bench_rename_fmodret,
+	&bench_trig_base,
+	&bench_trig_tp,
+	&bench_trig_rawtp,
+	&bench_trig_kprobe,
+	&bench_trig_fentry,
+	&bench_trig_fmodret,
 };
=20
 static void setup_benchmark()
diff --git a/tools/testing/selftests/bpf/benchs/bench_trigger.c b/tools/t=
esting/selftests/bpf/benchs/bench_trigger.c
new file mode 100644
index 000000000000..49c22832f216
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/bench_trigger.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "bench.h"
+#include "trigger_bench.skel.h"
+
+/* BPF triggering benchmarks */
+static struct trigger_ctx {
+	struct trigger_bench *skel;
+} ctx;
+
+static struct counter base_hits;
+
+static void trigger_validate()
+{
+	if (env.consumer_cnt !=3D 1) {
+		fprintf(stderr, "benchmark doesn't support multi-consumer!\n");
+		exit(1);
+	}
+}
+
+static void *trigger_base_producer(void *input)
+{
+	while (true) {
+		(void)syscall(__NR_getpgid);
+		atomic_inc(&base_hits.value);
+	}
+	return NULL;
+}
+
+static void trigger_base_measure(struct bench_res *res)
+{
+	res->hits =3D atomic_swap(&base_hits.value, 0);
+}
+
+static void *trigger_producer(void *input)
+{
+	while (true)
+		(void)syscall(__NR_getpgid);
+	return NULL;
+}
+
+static void trigger_measure(struct bench_res *res)
+{
+	res->hits =3D atomic_swap(&ctx.skel->bss->hits, 0);
+}
+
+static void setup_ctx()
+{
+	setup_libbpf();
+
+	ctx.skel =3D trigger_bench__open_and_load();
+	if (!ctx.skel) {
+		fprintf(stderr, "failed to open skeleton\n");
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
+static void trigger_tp_setup()
+{
+	setup_ctx();
+	attach_bpf(ctx.skel->progs.bench_trigger_tp);
+}
+
+static void trigger_rawtp_setup()
+{
+	setup_ctx();
+	attach_bpf(ctx.skel->progs.bench_trigger_raw_tp);
+}
+
+static void trigger_kprobe_setup()
+{
+	setup_ctx();
+	attach_bpf(ctx.skel->progs.bench_trigger_kprobe);
+}
+
+static void trigger_fentry_setup()
+{
+	setup_ctx();
+	attach_bpf(ctx.skel->progs.bench_trigger_fentry);
+}
+
+static void trigger_fmodret_setup()
+{
+	setup_ctx();
+	attach_bpf(ctx.skel->progs.bench_trigger_fmodret);
+}
+
+static void *trigger_consumer(void *input)
+{
+	return NULL;
+}
+
+const struct bench bench_trig_base =3D {
+	.name =3D "trig-base",
+	.validate =3D trigger_validate,
+	.producer_thread =3D trigger_base_producer,
+	.consumer_thread =3D trigger_consumer,
+	.measure =3D trigger_base_measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_trig_tp =3D {
+	.name =3D "trig-tp",
+	.validate =3D trigger_validate,
+	.setup =3D trigger_tp_setup,
+	.producer_thread =3D trigger_producer,
+	.consumer_thread =3D trigger_consumer,
+	.measure =3D trigger_measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_trig_rawtp =3D {
+	.name =3D "trig-rawtp",
+	.validate =3D trigger_validate,
+	.setup =3D trigger_rawtp_setup,
+	.producer_thread =3D trigger_producer,
+	.consumer_thread =3D trigger_consumer,
+	.measure =3D trigger_measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_trig_kprobe =3D {
+	.name =3D "trig-kprobe",
+	.validate =3D trigger_validate,
+	.setup =3D trigger_kprobe_setup,
+	.producer_thread =3D trigger_producer,
+	.consumer_thread =3D trigger_consumer,
+	.measure =3D trigger_measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_trig_fentry =3D {
+	.name =3D "trig-fentry",
+	.validate =3D trigger_validate,
+	.setup =3D trigger_fentry_setup,
+	.producer_thread =3D trigger_producer,
+	.consumer_thread =3D trigger_consumer,
+	.measure =3D trigger_measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_trig_fmodret =3D {
+	.name =3D "trig-fmodret",
+	.validate =3D trigger_validate,
+	.setup =3D trigger_fmodret_setup,
+	.producer_thread =3D trigger_producer,
+	.consumer_thread =3D trigger_consumer,
+	.measure =3D trigger_measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
diff --git a/tools/testing/selftests/bpf/benchs/run_bench_trigger.sh b/to=
ols/testing/selftests/bpf/benchs/run_bench_trigger.sh
new file mode 100755
index 000000000000..78e83f243294
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/run_bench_trigger.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -eufo pipefail
+
+for i in base tp rawtp kprobe fentry fmodret
+do
+	summary=3D$(sudo ./bench -w2 -d5 -a trig-$i | tail -n1 | cut -d'(' -f1 =
| cut -d' ' -f3-)
+	printf "%-10s: %s\n" $i "$summary"
+done
diff --git a/tools/testing/selftests/bpf/progs/trigger_bench.c b/tools/te=
sting/selftests/bpf/progs/trigger_bench.c
new file mode 100644
index 000000000000..8b36b6640e7e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/trigger_bench.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+
+#include <linux/bpf.h>
+#include <asm/unistd.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+long hits =3D 0;
+
+SEC("tp/syscalls/sys_enter_getpgid")
+int bench_trigger_tp(void *ctx)
+{
+	__sync_add_and_fetch(&hits, 1);
+	return 0;
+}
+
+SEC("raw_tp/sys_enter")
+int BPF_PROG(bench_trigger_raw_tp, struct pt_regs *regs, long id)
+{
+	if (id =3D=3D __NR_getpgid)
+		__sync_add_and_fetch(&hits, 1);
+	return 0;
+}
+
+SEC("kprobe/__x64_sys_getpgid")
+int bench_trigger_kprobe(void *ctx)
+{
+	__sync_add_and_fetch(&hits, 1);
+	return 0;
+}
+
+SEC("fentry/__x64_sys_getpgid")
+int bench_trigger_fentry(void *ctx)
+{
+	__sync_add_and_fetch(&hits, 1);
+	return 0;
+}
+
+SEC("fmod_ret/__x64_sys_getpgid")
+int bench_trigger_fmodret(void *ctx)
+{
+	__sync_add_and_fetch(&hits, 1);
+	return -22;
+}
--=20
2.24.1

