Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96D61D1F26
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390679AbgEMT1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:27:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13406 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390670AbgEMT1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:27:20 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DJPSek012855
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:27:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=JzYMdtQC7/8hDWUtBW9qnms7f+V63ZCJhBMxXVtbMPY=;
 b=Vps3lxTbs8yFGqXYTaklN1HEkEf9OrAZEHn0hH4tPEDo3eUi7aoTBeu6Uu0GNd9uYm7f
 iHdmrvB2teupG0SdqJToxuTj+TH/tGBWmJ7FKa8X68dokVqinxFJVstnsFV+Bc48rtFB
 TUDjfh0lKp6LVB/0Oz2Ys+lWA9X3M/reBRk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x9xt7g-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:27:18 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 12:26:13 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B2F252EC3007; Wed, 13 May 2020 12:26:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 5/6] selftests/bpf: add BPF ringbuf selftests
Date:   Wed, 13 May 2020 12:25:31 -0700
Message-ID: <20200513192532.4058934-6-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200513192532.4058934-1-andriin@fb.com>
References: <20200513192532.4058934-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_09:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 impostorscore=0
 cotscore=-2147483648 suspectscore=25 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both singleton BPF ringbuf and BPF ringbuf with map-in-map use cases are =
tested.
Also reserve+submit/discards and output variants of API are validated.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/ringbuf.c        | 101 +++++++++++++++++
 .../selftests/bpf/prog_tests/ringbuf_multi.c  | 102 ++++++++++++++++++
 .../selftests/bpf/progs/test_ringbuf.c        |  63 +++++++++++
 .../selftests/bpf/progs/test_ringbuf_multi.c  |  77 +++++++++++++
 4 files changed, 343 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ringbuf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ringbuf_multi.=
c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ringbuf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ringbuf_multi.=
c

diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/tes=
ting/selftests/bpf/prog_tests/ringbuf.c
new file mode 100644
index 000000000000..2708cc791f1a
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <linux/compiler.h>
+#include <asm/barrier.h>
+#include <test_progs.h>
+#include <sys/mman.h>
+#include <sys/epoll.h>
+#include <time.h>
+#include <sched.h>
+#include <pthread.h>
+#include <sys/sysinfo.h>
+#include <linux/perf_event.h>
+#include <linux/ring_buffer.h>
+#include "test_ringbuf.skel.h"
+
+#define EDONE 7777
+
+static int duration =3D 0;
+
+struct sample {
+	int pid;
+	int seq;
+	long value;
+	char comm[16];
+};
+
+static int process_sample(void *ctx, void *data, size_t len)
+{
+	struct sample *s =3D data;
+
+	switch (s->seq) {
+	case 0:
+		CHECK(s->value !=3D 333, "sample1_value", "exp %ld, got %ld\n",
+		      333L, s->value);
+		break;
+	case 1:
+		CHECK(s->value !=3D 777, "sample2_value", "exp %ld, got %ld\n",
+		      777L, s->value);
+		return -EDONE;
+	default:
+		CHECK(false, "extra_sample", "unexpected sample\n");
+	}
+
+	return 0;
+}
+
+void test_ringbuf(void)
+{
+	struct test_ringbuf *skel;
+	struct ring_buffer *ringbuf;
+	int err;
+
+	skel =3D test_ringbuf__open_and_load();
+	if (CHECK(!skel, "skel_open_load", "skeleton open&load failed\n"))
+		return;
+
+	/* only trigger BPF program for current process */
+	skel->bss->pid =3D getpid();
+
+	ringbuf =3D ring_buffer__new(bpf_map__fd(skel->maps.ringbuf),
+				   process_sample, NULL, NULL);
+	if (CHECK(!ringbuf, "ringbuf_create", "failed to create ringbuf\n"))
+		goto cleanup;
+
+	err =3D test_ringbuf__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attachment failed: %d\n", err))
+		goto cleanup;
+
+	/* trigger exactly two samples */
+	skel->bss->value =3D 333;
+	syscall(__NR_getpgid);
+	skel->bss->value =3D 777;
+	syscall(__NR_getpgid);
+
+	/* poll for samples */
+	do {
+		err =3D ring_buffer__poll(ringbuf, -1);
+	} while (err >=3D 0);
+
+	/* -EDONE is used as an indicator that we are done */
+	if (CHECK(err !=3D -EDONE, "err_done", "done err: %d\n", err))
+		goto cleanup;
+
+	/* we expect extra polling to return nothing */
+	err =3D ring_buffer__poll(ringbuf, 0);
+	if (CHECK(err < 0, "extra_samples", "poll result: %d\n", err))
+		goto cleanup;
+
+	CHECK(skel->bss->dropped !=3D 0, "err_dropped", "exp %ld, got %ld\n",
+	      0L, skel->bss->dropped);
+	CHECK(skel->bss->total !=3D 2, "err_total", "exp %ld, got %ld\n",
+	      2L, skel->bss->total);
+	CHECK(skel->bss->discarded !=3D 1, "err_discarded", "exp %ld, got %ld\n=
",
+	      1L, skel->bss->discarded);
+
+	test_ringbuf__detach(skel);
+
+cleanup:
+	ring_buffer__free(ringbuf);
+	test_ringbuf__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c b/too=
ls/testing/selftests/bpf/prog_tests/ringbuf_multi.c
new file mode 100644
index 000000000000..f352f556bd34
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include <sys/epoll.h>
+#include "test_ringbuf_multi.skel.h"
+
+static int duration =3D 0;
+
+struct sample {
+	int pid;
+	int seq;
+	long value;
+	char comm[16];
+};
+
+static int process_sample(void *ctx, void *data, size_t len)
+{
+	int ring =3D (unsigned long)ctx;
+	struct sample *s =3D data;
+
+	switch (s->seq) {
+	case 0:
+		CHECK(ring !=3D 1, "sample1_ring", "exp %d, got %d\n", 1, ring);
+		CHECK(s->value !=3D 333, "sample1_value", "exp %ld, got %ld\n",
+		      333L, s->value);
+		break;
+	case 1:
+		CHECK(ring !=3D 2, "sample2_ring", "exp %d, got %d\n", 2, ring);
+		CHECK(s->value !=3D 777, "sample2_value", "exp %ld, got %ld\n",
+		      777L, s->value);
+		break;
+	default:
+		CHECK(true, "extra_sample", "unexpected sample seq %d, val %ld\n",
+		      s->seq, s->value);
+		return -1;
+	}
+
+	return 0;
+}
+
+void test_ringbuf_multi(void)
+{
+	struct test_ringbuf_multi *skel;
+	struct ring_buffer *ringbuf;
+	int err;
+
+	skel =3D test_ringbuf_multi__open_and_load();
+	if (CHECK(!skel, "skel_open_load", "skeleton open&load failed\n"))
+		return;
+
+	/* only trigger BPF program for current process */
+	skel->bss->pid =3D getpid();
+
+	ringbuf =3D ring_buffer__new(bpf_map__fd(skel->maps.ringbuf1),
+				   process_sample, (void *)(long)1, NULL);
+	if (CHECK(!ringbuf, "ringbuf_create", "failed to create ringbuf\n"))
+		goto cleanup;
+
+	err =3D ring_buffer__add(ringbuf, bpf_map__fd(skel->maps.ringbuf2),
+			      process_sample, (void *)(long)2);
+	if (CHECK(err, "ringbuf_add", "failed to add another ring\n"))
+		goto cleanup;
+
+	err =3D test_ringbuf_multi__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attachment failed: %d\n", err))
+		goto cleanup;
+
+	/* trigger few samples, some will be skipped */
+	skel->bss->target_ring =3D 0;
+	skel->bss->value =3D 333;
+	syscall(__NR_getpgid);
+
+	/* skipped, no ringbuf in slot 1 */
+	skel->bss->target_ring =3D 1;
+	skel->bss->value =3D 555;
+	syscall(__NR_getpgid);
+
+	skel->bss->target_ring =3D 2;
+	skel->bss->value =3D 777;
+	syscall(__NR_getpgid);
+
+	/* poll for samples, should get 2 ringbufs back */
+	err =3D ring_buffer__poll(ringbuf, -1);
+	if (CHECK(err !=3D 2, "poll_res", "expected 2 events, got %d\n", err))
+		goto cleanup;
+
+	/* expect extra polling to return nothing */
+	err =3D ring_buffer__poll(ringbuf, 0);
+	if (CHECK(err < 0, "extra_samples", "poll result: %d\n", err))
+		goto cleanup;
+
+	CHECK(skel->bss->dropped !=3D 0, "err_dropped", "exp %ld, got %ld\n",
+	      0L, skel->bss->dropped);
+	CHECK(skel->bss->skipped !=3D 1, "err_skipped", "exp %ld, got %ld\n",
+	      1L, skel->bss->skipped);
+	CHECK(skel->bss->total !=3D 2, "err_total", "exp %ld, got %ld\n",
+	      2L, skel->bss->total);
+
+cleanup:
+	ring_buffer__free(ringbuf);
+	test_ringbuf_multi__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ringbuf.c b/tools/tes=
ting/selftests/bpf/progs/test_ringbuf.c
new file mode 100644
index 000000000000..6084f17e17d8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ringbuf.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct sample {
+	int pid;
+	int seq;
+	long value;
+	char comm[16];
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_RINGBUF);
+	__uint(max_entries, 1 << 12);
+} ringbuf SEC(".maps");
+
+/* inputs */
+int pid =3D 0;
+long value =3D 0;
+
+/* outputs */
+long total =3D 0;
+long discarded =3D 0;
+long dropped =3D 0;
+
+SEC("tp/syscalls/sys_enter_getpgid")
+int test_ringbuf(void *ctx)
+{
+	int cur_pid =3D bpf_get_current_pid_tgid() >> 32;
+	struct sample *sample;
+	int zero =3D 0;
+
+	if (cur_pid !=3D pid)
+		return 0;
+
+	sample =3D bpf_ringbuf_reserve(&ringbuf, sizeof(*sample), 0);
+	if (!sample) {
+		__sync_fetch_and_add(&dropped, 1);
+		return 1;
+	}
+
+	sample->pid =3D pid;
+	bpf_get_current_comm(sample->comm, sizeof(sample->comm));
+	sample->value =3D value;
+
+	sample->seq =3D total;
+	__sync_fetch_and_add(&total, 1);
+
+	if (sample->seq & 1) {
+		/* copy from reserved sample to a new one... */
+		bpf_ringbuf_output(&ringbuf, sample, sizeof(*sample), 0);
+		/* ...and then discard reserved sample */
+		bpf_ringbuf_discard(sample);
+		__sync_fetch_and_add(&discarded, 1);
+	} else {
+		bpf_ringbuf_submit(sample);
+	}
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c b/too=
ls/testing/selftests/bpf/progs/test_ringbuf_multi.c
new file mode 100644
index 000000000000..b45291e77aa2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct sample {
+	int pid;
+	int seq;
+	long value;
+	char comm[16];
+};
+
+struct ringbuf_map {
+	__uint(type, BPF_MAP_TYPE_RINGBUF);
+	__uint(max_entries, 1 << 12);
+} ringbuf1 SEC(".maps"),
+  ringbuf2 SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
+	__uint(max_entries, 4);
+	__type(key, int);
+	__array(values, struct ringbuf_map);
+} ringbuf_arr SEC(".maps") =3D {
+	.values =3D {
+		[0] =3D &ringbuf1,
+		[2] =3D &ringbuf2,
+	},
+};
+
+/* inputs */
+int pid =3D 0;
+int target_ring =3D 0;
+long value =3D 0;
+
+/* outputs */
+long total =3D 0;
+long dropped =3D 0;
+long skipped =3D 0;
+
+SEC("tp/syscalls/sys_enter_getpgid")
+int test_ringbuf(void *ctx)
+{
+	int cur_pid =3D bpf_get_current_pid_tgid() >> 32;
+	struct sample *sample;
+	void *rb;
+	int zero =3D 0;
+
+	if (cur_pid !=3D pid)
+		return 0;
+
+	rb =3D bpf_map_lookup_elem(&ringbuf_arr, &target_ring);
+	if (!rb) {
+		skipped +=3D 1;
+		return 1;
+	}
+
+	sample =3D bpf_ringbuf_reserve(rb, sizeof(*sample), 0);
+	if (!sample) {
+		dropped +=3D 1;
+		return 1;
+	}
+
+	sample->pid =3D pid;
+	bpf_get_current_comm(sample->comm, sizeof(sample->comm));
+	sample->value =3D value;
+
+	sample->seq =3D total;
+	total +=3D 1;
+
+	bpf_ringbuf_submit(sample);
+
+	return 0;
+}
--=20
2.24.1

