Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF6C1F10B8
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 02:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgFHAgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 20:36:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16646 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727965AbgFHAgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 20:36:23 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0580UcjV010067
        for <netdev@vger.kernel.org>; Sun, 7 Jun 2020 17:36:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=pAzCA2kpyA3czVGvV+jHK/6wwisaOtSSG8JsrbSJiwc=;
 b=g6f9+2CuwoJ1gvQak6Xh3OKVxbLw44An3Vcv5scm6TbCcbmGufwrGIkyILbU+kTc5u7q
 53g2bksaSz3HSz6UyOHxFLVR0NJp4dh18KB+fF2EJX1Sr8EeIi6NwpnJhC8E3oYsrIrW
 DWkYLkmfsdutCxA2ZZJ7W3J3zE8BV4WzNCQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31gtucj5fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 17:36:23 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 7 Jun 2020 17:36:22 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BC9D12EC3971; Sun,  7 Jun 2020 17:36:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] selftests/bpf: fix ringbuf selftest sample counting undeterminism
Date:   Sun, 7 Jun 2020 17:36:15 -0700
Message-ID: <20200608003615.3549991-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-07_13:2020-06-04,2020-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 bulkscore=0 priorityscore=1501 cotscore=-2147483648 spamscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxlogscore=961
 clxscore=1015 phishscore=0 mlxscore=0 impostorscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix test race, in which background poll can get either 5 or 6 samples,
depending on timing of notification. Prevent this by open-coding sample
triggering and forcing notification for the very last sample only.

Also switch to using atomic increments and exchanges for more obviously
reliable counting and checking. Additionally, check expected processed sa=
mple
counters for single-threaded use cases as well.

Fixes: 9a5f25ad30e5 ("selftests/bpf: Fix sample_cnt shared between two th=
reads")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/ringbuf.c        | 42 +++++++++++++++----
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/tes=
ting/selftests/bpf/prog_tests/ringbuf.c
index 2bba908dfa63..c1650548433c 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -25,13 +25,23 @@ struct sample {
 	char comm[16];
 };
=20
-static volatile int sample_cnt;
+static int sample_cnt;
+
+static void atomic_inc(int *cnt)
+{
+	__atomic_add_fetch(cnt, 1, __ATOMIC_SEQ_CST);
+}
+
+static int atomic_xchg(int *cnt, int val)
+{
+	return __atomic_exchange_n(cnt, val, __ATOMIC_SEQ_CST);
+}
=20
 static int process_sample(void *ctx, void *data, size_t len)
 {
 	struct sample *s =3D data;
=20
-	sample_cnt++;
+	atomic_inc(&sample_cnt);
=20
 	switch (s->seq) {
 	case 0:
@@ -76,7 +86,7 @@ void test_ringbuf(void)
 	const size_t rec_sz =3D BPF_RINGBUF_HDR_SZ + sizeof(struct sample);
 	pthread_t thread;
 	long bg_ret =3D -1;
-	int err;
+	int err, cnt;
=20
 	skel =3D test_ringbuf__open_and_load();
 	if (CHECK(!skel, "skel_open_load", "skeleton open&load failed\n"))
@@ -116,11 +126,15 @@ void test_ringbuf(void)
 	/* -EDONE is used as an indicator that we are done */
 	if (CHECK(err !=3D -EDONE, "err_done", "done err: %d\n", err))
 		goto cleanup;
+	cnt =3D atomic_xchg(&sample_cnt, 0);
+	CHECK(cnt !=3D 2, "cnt", "exp %d samples, got %d\n", 2, cnt);
=20
 	/* we expect extra polling to return nothing */
 	err =3D ring_buffer__poll(ringbuf, 0);
 	if (CHECK(err !=3D 0, "extra_samples", "poll result: %d\n", err))
 		goto cleanup;
+	cnt =3D atomic_xchg(&sample_cnt, 0);
+	CHECK(cnt !=3D 0, "cnt", "exp %d samples, got %d\n", 0, cnt);
=20
 	CHECK(skel->bss->dropped !=3D 0, "err_dropped", "exp %ld, got %ld\n",
 	      0L, skel->bss->dropped);
@@ -136,6 +150,8 @@ void test_ringbuf(void)
 	      3L * rec_sz, skel->bss->cons_pos);
 	err =3D ring_buffer__poll(ringbuf, -1);
 	CHECK(err <=3D 0, "poll_err", "err %d\n", err);
+	cnt =3D atomic_xchg(&sample_cnt, 0);
+	CHECK(cnt !=3D 2, "cnt", "exp %d samples, got %d\n", 2, cnt);
=20
 	/* start poll in background w/ long timeout */
 	err =3D pthread_create(&thread, NULL, poll_thread, (void *)(long)10000)=
;
@@ -164,6 +180,8 @@ void test_ringbuf(void)
 	      2L, skel->bss->total);
 	CHECK(skel->bss->discarded !=3D 1, "err_discarded", "exp %ld, got %ld\n=
",
 	      1L, skel->bss->discarded);
+	cnt =3D atomic_xchg(&sample_cnt, 0);
+	CHECK(cnt !=3D 0, "cnt", "exp %d samples, got %d\n", 0, cnt);
=20
 	/* clear flags to return to "adaptive" notification mode */
 	skel->bss->flags =3D 0;
@@ -178,10 +196,20 @@ void test_ringbuf(void)
 	if (CHECK(err !=3D EBUSY, "try_join", "err %d\n", err))
 		goto cleanup;
=20
+	/* still no samples, because consumer is behind */
+	cnt =3D atomic_xchg(&sample_cnt, 0);
+	CHECK(cnt !=3D 0, "cnt", "exp %d samples, got %d\n", 0, cnt);
+
+	skel->bss->dropped =3D 0;
+	skel->bss->total =3D 0;
+	skel->bss->discarded =3D 0;
+
+	skel->bss->value =3D 333;
+	syscall(__NR_getpgid);
 	/* now force notifications */
 	skel->bss->flags =3D BPF_RB_FORCE_WAKEUP;
-	sample_cnt =3D 0;
-	trigger_samples();
+	skel->bss->value =3D 777;
+	syscall(__NR_getpgid);
=20
 	/* now we should get a pending notification */
 	usleep(50000);
@@ -193,8 +221,8 @@ void test_ringbuf(void)
 		goto cleanup;
=20
 	/* 3 rounds, 2 samples each */
-	CHECK(sample_cnt !=3D 6, "wrong_sample_cnt",
-	      "expected to see %d samples, got %d\n", 6, sample_cnt);
+	cnt =3D atomic_xchg(&sample_cnt, 0);
+	CHECK(cnt !=3D 6, "cnt", "exp %d samples, got %d\n", 6, cnt);
=20
 	/* BPF side did everything right */
 	CHECK(skel->bss->dropped !=3D 0, "err_dropped", "exp %ld, got %ld\n",
--=20
2.24.1

