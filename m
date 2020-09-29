Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A4127BFF8
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbgI2IsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:48:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3356 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgI2IsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:48:15 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T8dmgo020572
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:48:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=f1DRt8DSh7xvwsbLwZtA/reljbesfZWQwqhLxzP0MJY=;
 b=iuH70HO4HlPxk8dd7EZ+wP1NRWtlHsW+aXTzKUjr99w2M9RnwVTKHGj2jAycU09EUsau
 MIv8SdtzeNHf82riPBxfN46hx5X0wWg6vU6zC6mwWrbl9p0Fj8zy6W1TKAUY2FMNLRiz
 /3PB7tuTtesLoAqU5AN839e5cjkNDCR/4cQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33t3cpbv3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:48:14 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 01:48:13 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 165DB62E5765; Tue, 29 Sep 2020 01:48:06 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next 2/2] selftests/bpf: add tests for BPF_F_SHARE_PE
Date:   Tue, 29 Sep 2020 01:47:50 -0700
Message-ID: <20200929084750.419168-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200929084750.419168-1-songliubraving@fb.com>
References: <20200929084750.419168-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009290080
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for perf event array with and without BPF_F_SHARE_PE.

Add a perf event to array via fd mfd. Without BPF_F_SHARE_PE, the perf
event is removed when mfd is closed. With BPF_F_SHARE_PE, the perf event
is removed when the map is freed.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../bpf/prog_tests/perf_event_share.c         | 68 +++++++++++++++++++
 .../bpf/progs/test_perf_event_share.c         | 44 ++++++++++++
 2 files changed, 112 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_event_sha=
re.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_perf_event_sha=
re.c

diff --git a/tools/testing/selftests/bpf/prog_tests/perf_event_share.c b/=
tools/testing/selftests/bpf/prog_tests/perf_event_share.c
new file mode 100644
index 0000000000000..a37cfdd047ea6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/perf_event_share.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2019 Facebook */
+#include <test_progs.h>
+#include <linux/bpf.h>
+#include "test_perf_event_share.skel.h"
+
+static int duration;
+
+static void test_one_map(struct bpf_map *map, struct bpf_program *prog,
+			 bool has_share_pe)
+{
+	int err, key =3D 0, pfd =3D -1, mfd =3D bpf_map__fd(map);
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts);
+	struct perf_event_attr attr =3D {
+		.size =3D sizeof(struct perf_event_attr),
+		.type =3D PERF_TYPE_SOFTWARE,
+		.config =3D PERF_COUNT_SW_CPU_CLOCK,
+	};
+
+	pfd =3D syscall(__NR_perf_event_open, &attr, 0 /* pid */,
+		      -1 /* cpu 0 */, -1 /* group id */, 0 /* flags */);
+	if (CHECK(pfd < 0, "perf_event_open", "failed\n"))
+		return;
+
+	err =3D bpf_map_update_elem(mfd, &key, &pfd, BPF_ANY);
+	if (CHECK(err < 0, "bpf_map_update_elem", "failed\n"))
+		goto cleanup;
+
+	err =3D bpf_prog_test_run_opts(bpf_program__fd(prog), &opts);
+	if (CHECK(err < 0, "bpf_prog_test_run_opts", "failed\n"))
+		goto cleanup;
+	if (CHECK(opts.retval !=3D 0, "bpf_perf_event_read_value",
+		  "failed with %d\n", opts.retval))
+		goto cleanup;
+
+	/* closing mfd, prog still holds a reference on map */
+	close(mfd);
+
+	err =3D bpf_prog_test_run_opts(bpf_program__fd(prog), &opts);
+	if (CHECK(err < 0, "bpf_prog_test_run_opts", "failed\n"))
+		goto cleanup;
+
+	if (has_share_pe) {
+		CHECK(opts.retval !=3D 0, "bpf_perf_event_read_value",
+		      "failed with %d\n", opts.retval);
+	} else {
+		CHECK(opts.retval !=3D -ENOENT, "bpf_perf_event_read_value",
+		      "should have failed with %d, but got %d\n", -ENOENT,
+		      opts.retval);
+	}
+
+cleanup:
+	close(pfd);
+}
+
+void test_perf_event_share(void)
+{
+	struct test_perf_event_share *skel;
+
+	skel =3D test_perf_event_share__open_and_load();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+
+	test_one_map(skel->maps.array_1, skel->progs.read_array_1, false);
+	test_one_map(skel->maps.array_2, skel->progs.read_array_2, true);
+
+	test_perf_event_share__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_perf_event_share.c b/=
tools/testing/selftests/bpf/progs/test_perf_event_share.c
new file mode 100644
index 0000000000000..005bfe375352f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_perf_event_share.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+} array_1 SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(map_flags, BPF_F_SHARE_PE);  /* array_2 has BPF_F_SHARE_PE */
+} array_2 SEC(".maps");
+
+SEC("raw_tp/sched_switch")
+int BPF_PROG(read_array_1)
+{
+	struct bpf_perf_event_value val;
+	long ret;
+
+	ret =3D bpf_perf_event_read_value(&array_1, 0, &val, sizeof(val));
+	bpf_printk("read_array_1 returns %ld", ret);
+	return ret;
+}
+
+SEC("raw_tp/task_rename")
+int BPF_PROG(read_array_2)
+{
+	struct bpf_perf_event_value val;
+	long ret;
+
+	ret =3D bpf_perf_event_read_value(&array_2, 0, &val, sizeof(val));
+	bpf_printk("read_array_2 returns %ld", ret);
+	return ret;
+}
+
+char LICENSE[] SEC("license") =3D "GPL";
--=20
2.24.1

