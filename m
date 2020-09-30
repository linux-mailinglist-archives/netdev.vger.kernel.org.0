Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D6B27EC4E
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730897AbgI3PVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:21:18 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35282 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730791AbgI3PVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 11:21:17 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UF8SBQ019459
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 08:21:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=H49x1n7hvm5N2Cn6+ISKXooZGqZ3ZNp+X3yyn6ni5mY=;
 b=Ui+n+mjH7S/tj/BUMfEJN/6/grFzPmY8EVE2uqLEOqsUrlv+CWHqp81lI/AprXG/9JfF
 XZT2+aFxtsgGrqFBCJXQDrE2of4QuSsLjMw8PvL6HSGjzWBBWBAxhL1wmxYTEQBVWGMZ
 LB7yVDOOryUJnvSUTN0ogQ4nxwW2Z++AM7o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33vpwchtan-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 08:21:15 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 08:21:13 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9B7A762E4FEB; Wed, 30 Sep 2020 08:21:12 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 bpf-next 2/2] selftests/bpf: add tests for BPF_F_PRESERVE_ELEMS
Date:   Wed, 30 Sep 2020 08:20:58 -0700
Message-ID: <20200930152058.167985-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200930152058.167985-1-songliubraving@fb.com>
References: <20200930152058.167985-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_08:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 suspectscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=999 spamscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for perf event array with and without BPF_F_PRESERVE_ELEMS.

Add a perf event to array via fd mfd. Without BPF_F_PRESERVE_ELEMS, the
perf event is removed when mfd is closed. With BPF_F_PRESERVE_ELEMS, the
perf event is removed when the map is freed.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../bpf/prog_tests/pe_preserve_elems.c        | 66 +++++++++++++++++++
 .../bpf/progs/test_pe_preserve_elems.c        | 44 +++++++++++++
 2 files changed, 110 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/pe_preserve_el=
ems.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pe_preserve_el=
ems.c

diff --git a/tools/testing/selftests/bpf/prog_tests/pe_preserve_elems.c b=
/tools/testing/selftests/bpf/prog_tests/pe_preserve_elems.c
new file mode 100644
index 0000000000000..673d38395253b
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/pe_preserve_elems.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2019 Facebook */
+#include <test_progs.h>
+#include <linux/bpf.h>
+#include "test_pe_preserve_elems.skel.h"
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
+	close(pfd);
+	if (CHECK(err < 0, "bpf_map_update_elem", "failed\n"))
+		return;
+
+	err =3D bpf_prog_test_run_opts(bpf_program__fd(prog), &opts);
+	if (CHECK(err < 0, "bpf_prog_test_run_opts", "failed\n"))
+		return;
+	if (CHECK(opts.retval !=3D 0, "bpf_perf_event_read_value",
+		  "failed with %d\n", opts.retval))
+		return;
+
+	/* closing mfd, prog still holds a reference on map */
+	close(mfd);
+
+	err =3D bpf_prog_test_run_opts(bpf_program__fd(prog), &opts);
+	if (CHECK(err < 0, "bpf_prog_test_run_opts", "failed\n"))
+		return;
+
+	if (has_share_pe) {
+		CHECK(opts.retval !=3D 0, "bpf_perf_event_read_value",
+		      "failed with %d\n", opts.retval);
+	} else {
+		CHECK(opts.retval !=3D -ENOENT, "bpf_perf_event_read_value",
+		      "should have failed with %d, but got %d\n", -ENOENT,
+		      opts.retval);
+	}
+}
+
+void test_pe_preserve_elems(void)
+{
+	struct test_pe_preserve_elems *skel;
+
+	skel =3D test_pe_preserve_elems__open_and_load();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+
+	test_one_map(skel->maps.array_1, skel->progs.read_array_1, false);
+	test_one_map(skel->maps.array_2, skel->progs.read_array_2, true);
+
+	test_pe_preserve_elems__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_pe_preserve_elems.c b=
/tools/testing/selftests/bpf/progs/test_pe_preserve_elems.c
new file mode 100644
index 0000000000000..dc77e406de41f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_pe_preserve_elems.c
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
+	__uint(map_flags, BPF_F_PRESERVE_ELEMS);
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

