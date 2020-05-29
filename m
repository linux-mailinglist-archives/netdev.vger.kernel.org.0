Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF7C1E777E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 09:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgE2Hyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 03:54:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbgE2Hyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 03:54:53 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04T7nJ6J029201
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 00:54:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=BGP7lyv/JOcf+JOkkaBx+8GswzzS8L5TNl47yMlZrGA=;
 b=U3kvDfTD6/cotEAIZOL0yEDPhLTAC181jLW19ixHjkdtnIlmmKVlOkQjSmWd63U44lXc
 QO+WWxHYrRdUAL/ctc3U20OMjwrJMd0YIA+aEal4yzAhjtJ9vG6n337kh4tTyCGlTBkB
 em1qqG8Yxx1g9/eV17yO+MttBxl4bm8VZ2E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31a4ndnhqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 00:54:51 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 29 May 2020 00:54:50 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 49F722EC3747; Fri, 29 May 2020 00:54:43 -0700 (PDT)
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
Subject: [PATCH v4 bpf-next 3/5] selftests/bpf: add BPF ringbuf selftests
Date:   Fri, 29 May 2020 00:54:22 -0700
Message-ID: <20200529075424.3139988-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200529075424.3139988-1-andriin@fb.com>
References: <20200529075424.3139988-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-29_02:2020-05-28,2020-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 cotscore=-2147483648 mlxlogscore=999 spamscore=0 malwarescore=0
 clxscore=1015 phishscore=0 suspectscore=25 bulkscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290062
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
 .../selftests/bpf/prog_tests/ringbuf.c        | 211 ++++++++++++++++++
 .../selftests/bpf/prog_tests/ringbuf_multi.c  | 102 +++++++++
 .../selftests/bpf/progs/test_ringbuf.c        |  78 +++++++
 .../selftests/bpf/progs/test_ringbuf_multi.c  |  77 +++++++
 4 files changed, 468 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ringbuf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ringbuf_multi.=
c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ringbuf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ringbuf_multi.=
c

diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/tes=
ting/selftests/bpf/prog_tests/ringbuf.c
new file mode 100644
index 000000000000..bb8541f240e2
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <linux/compiler.h>
+#include <asm/barrier.h>
+#include <test_progs.h>
+#include <sys/mman.h>
+#include <sys/epoll.h>
+#include <time.h>
+#include <sched.h>
+#include <signal.h>
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
+static int sample_cnt;
+
+static int process_sample(void *ctx, void *data, size_t len)
+{
+	struct sample *s =3D data;
+
+	sample_cnt++;
+
+	switch (s->seq) {
+	case 0:
+		CHECK(s->value !=3D 333, "sample1_value", "exp %ld, got %ld\n",
+		      333L, s->value);
+		return 0;
+	case 1:
+		CHECK(s->value !=3D 777, "sample2_value", "exp %ld, got %ld\n",
+		      777L, s->value);
+		return -EDONE;
+	default:
+		/* we don't care about the rest */
+		return 0;
+	}
+}
+
+static struct test_ringbuf *skel;
+static struct ring_buffer *ringbuf;
+
+static void trigger_samples()
+{
+	skel->bss->dropped =3D 0;
+	skel->bss->total =3D 0;
+	skel->bss->discarded =3D 0;
+
+	/* trigger exactly two samples */
+	skel->bss->value =3D 333;
+	syscall(__NR_getpgid);
+	skel->bss->value =3D 777;
+	syscall(__NR_getpgid);
+}
+
+static void *poll_thread(void *input)
+{
+	long timeout =3D (long)input;
+
+	return (void *)(long)ring_buffer__poll(ringbuf, timeout);
+}
+
+void test_ringbuf(void)
+{
+	const size_t rec_sz =3D BPF_RINGBUF_HDR_SZ + sizeof(struct sample);
+	pthread_t thread;
+	long bg_ret =3D -1;
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
+	trigger_samples();
+
+	/* 2 submitted + 1 discarded records */
+	CHECK(skel->bss->avail_data !=3D 3 * rec_sz,
+	      "err_avail_size", "exp %ld, got %ld\n",
+	      3L * rec_sz, skel->bss->avail_data);
+	CHECK(skel->bss->ring_size !=3D 4096,
+	      "err_ring_size", "exp %ld, got %ld\n",
+	      4096L, skel->bss->ring_size);
+	CHECK(skel->bss->cons_pos !=3D 0,
+	      "err_cons_pos", "exp %ld, got %ld\n",
+	      0L, skel->bss->cons_pos);
+	CHECK(skel->bss->prod_pos !=3D 3 * rec_sz,
+	      "err_prod_pos", "exp %ld, got %ld\n",
+	      3L * rec_sz, skel->bss->prod_pos);
+
+	/* poll for samples */
+	err =3D ring_buffer__poll(ringbuf, -1);
+
+	/* -EDONE is used as an indicator that we are done */
+	if (CHECK(err !=3D -EDONE, "err_done", "done err: %d\n", err))
+		goto cleanup;
+
+	/* we expect extra polling to return nothing */
+	err =3D ring_buffer__poll(ringbuf, 0);
+	if (CHECK(err !=3D 0, "extra_samples", "poll result: %d\n", err))
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
+	/* now validate consumer position is updated and returned */
+	trigger_samples();
+	CHECK(skel->bss->cons_pos !=3D 3 * rec_sz,
+	      "err_cons_pos", "exp %ld, got %ld\n",
+	      3L * rec_sz, skel->bss->cons_pos);
+	err =3D ring_buffer__poll(ringbuf, -1);
+	CHECK(err <=3D 0, "poll_err", "err %d\n", err);
+
+	/* start poll in background w/ long timeout */
+	err =3D pthread_create(&thread, NULL, poll_thread, (void *)(long)10000)=
;
+	if (CHECK(err, "bg_poll", "pthread_create failed: %d\n", err))
+		goto cleanup;
+
+	/* turn off notifications now */
+	skel->bss->flags =3D BPF_RB_NO_WAKEUP;
+
+	/* give background thread a bit of a time */
+	usleep(50000);
+	trigger_samples();
+	/* sleeping arbitrarily is bad, but no better way to know that
+	 * epoll_wait() **DID NOT** unblock in background thread
+	 */
+	usleep(50000);
+	/* background poll should still be blocked */
+	err =3D pthread_tryjoin_np(thread, (void **)&bg_ret);
+	if (CHECK(err !=3D EBUSY, "try_join", "err %d\n", err))
+		goto cleanup;
+
+	/* BPF side did everything right */
+	CHECK(skel->bss->dropped !=3D 0, "err_dropped", "exp %ld, got %ld\n",
+	      0L, skel->bss->dropped);
+	CHECK(skel->bss->total !=3D 2, "err_total", "exp %ld, got %ld\n",
+	      2L, skel->bss->total);
+	CHECK(skel->bss->discarded !=3D 1, "err_discarded", "exp %ld, got %ld\n=
",
+	      1L, skel->bss->discarded);
+
+	/* clear flags to return to "adaptive" notification mode */
+	skel->bss->flags =3D 0;
+
+	/* produce new samples, no notification should be triggered, because
+	 * consumer is now behind
+	 */
+	trigger_samples();
+
+	/* background poll should still be blocked */
+	err =3D pthread_tryjoin_np(thread, (void **)&bg_ret);
+	if (CHECK(err !=3D EBUSY, "try_join", "err %d\n", err))
+		goto cleanup;
+
+	/* now force notifications */
+	skel->bss->flags =3D BPF_RB_FORCE_WAKEUP;
+	sample_cnt =3D 0;
+	trigger_samples();
+
+	/* now we should get a pending notification */
+	usleep(50000);
+	err =3D pthread_tryjoin_np(thread, (void **)&bg_ret);
+	if (CHECK(err, "join_bg", "err %d\n", err))
+		goto cleanup;
+
+	if (CHECK(bg_ret !=3D 1, "bg_ret", "epoll_wait result: %ld", bg_ret))
+		goto cleanup;
+
+	/* 3 rounds, 2 samples each */
+	CHECK(sample_cnt !=3D 6, "wrong_sample_cnt",
+	      "expected to see %d samples, got %d\n", 6, sample_cnt);
+
+	/* BPF side did everything right */
+	CHECK(skel->bss->dropped !=3D 0, "err_dropped", "exp %ld, got %ld\n",
+	      0L, skel->bss->dropped);
+	CHECK(skel->bss->total !=3D 2, "err_total", "exp %ld, got %ld\n",
+	      2L, skel->bss->total);
+	CHECK(skel->bss->discarded !=3D 1, "err_discarded", "exp %ld, got %ld\n=
",
+	      1L, skel->bss->discarded);
+
+	test_ringbuf__detach(skel);
+cleanup:
+	ring_buffer__free(ringbuf);
+	test_ringbuf__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c b/too=
ls/testing/selftests/bpf/prog_tests/ringbuf_multi.c
new file mode 100644
index 000000000000..78e450609803
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
+	if (CHECK(err !=3D 4, "poll_res", "expected 4 records, got %d\n", err))
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
index 000000000000..8ba9959b036b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ringbuf.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
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
+long flags =3D 0;
+
+/* outputs */
+long total =3D 0;
+long discarded =3D 0;
+long dropped =3D 0;
+
+long avail_data =3D 0;
+long ring_size =3D 0;
+long cons_pos =3D 0;
+long prod_pos =3D 0;
+
+/* inner state */
+long seq =3D 0;
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
+	sample->seq =3D seq++;
+	__sync_fetch_and_add(&total, 1);
+
+	if (sample->seq & 1) {
+		/* copy from reserved sample to a new one... */
+		bpf_ringbuf_output(&ringbuf, sample, sizeof(*sample), flags);
+		/* ...and then discard reserved sample */
+		bpf_ringbuf_discard(sample, flags);
+		__sync_fetch_and_add(&discarded, 1);
+	} else {
+		bpf_ringbuf_submit(sample, flags);
+	}
+
+	avail_data =3D bpf_ringbuf_query(&ringbuf, BPF_RB_AVAIL_DATA);
+	ring_size =3D bpf_ringbuf_query(&ringbuf, BPF_RB_RING_SIZE);
+	cons_pos =3D bpf_ringbuf_query(&ringbuf, BPF_RB_CONS_POS);
+	prod_pos =3D bpf_ringbuf_query(&ringbuf, BPF_RB_PROD_POS);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c b/too=
ls/testing/selftests/bpf/progs/test_ringbuf_multi.c
new file mode 100644
index 000000000000..edf3b6953533
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
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
+	bpf_ringbuf_submit(sample, 0);
+
+	return 0;
+}
--=20
2.24.1

