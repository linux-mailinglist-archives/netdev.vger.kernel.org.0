Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA3A276331
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgIWVeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:34:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45102 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726672AbgIWVeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 17:34:04 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NLP3HR013413
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 14:34:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=c3k2PRa14yC1OOd+4W3VM+FzSbUrBfjmOe5TgW7cpo0=;
 b=WaQUDAGa6GlFbWLHBs82w1Zb1u3ywr8JIZ/9i+5QCkd3dlVKuqSFW+kaqPzNawm4hfwn
 K0xhTzqQDZtVr+sEM45d0ognkidpNr70Lvf2XTgxyXDXgS+6n5H3U3fSLOTDVMMjSGcT
 yuQUtUlrsfwkY+Bw9E5PYNW4wLwhVTSiwew= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp4x4wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 14:34:02 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 14:34:01 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9547862E5235; Wed, 23 Sep 2020 14:33:58 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 bpf-next 3/3] selftests/bpf: add raw_tp_test_run
Date:   Wed, 23 Sep 2020 14:33:37 -0700
Message-ID: <20200923213337.3432472-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200923213337.3432472-1-songliubraving@fb.com>
References: <20200923213337.3432472-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_16:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 suspectscore=2 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230162
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test runs test_run for raw_tracepoint program. The test covers ctx
input, retval output, and proper handling of cpu_plus field.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../bpf/prog_tests/raw_tp_test_run.c          | 75 +++++++++++++++++++
 .../bpf/progs/test_raw_tp_test_run.c          | 25 +++++++
 2 files changed, 100 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_test_ru=
n.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_raw_tp_test_ru=
n.c

diff --git a/tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c b/t=
ools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
new file mode 100644
index 0000000000000..492cd8a8c0e00
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2019 Facebook */
+#include <test_progs.h>
+#include "bpf/libbpf_internal.h"
+#include "test_raw_tp_test_run.skel.h"
+
+static int duration;
+
+void test_raw_tp_test_run(void)
+{
+	struct bpf_prog_test_run_attr test_attr =3D {};
+	__u64 args[2] =3D {0x1234ULL, 0x5678ULL};
+	int comm_fd =3D -1, err, nr_online, i;
+	int expected_retval =3D 0x1234 + 0x5678;
+	struct test_raw_tp_test_run *skel;
+	char buf[] =3D "new_name";
+	bool *online =3D NULL;
+
+	err =3D parse_cpu_mask_file("/sys/devices/system/cpu/online", &online,
+				  &nr_online);
+	if (CHECK(err, "parse_cpu_mask_file", "err %d\n", err))
+		return;
+
+	skel =3D test_raw_tp_test_run__open_and_load();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n")) {
+		free(online);
+		return;
+	}
+	err =3D test_raw_tp_test_run__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	comm_fd =3D open("/proc/self/comm", O_WRONLY|O_TRUNC);
+	if (CHECK(comm_fd < 0, "open /proc/self/comm", "err %d\n", errno))
+		goto cleanup;
+
+	err =3D write(comm_fd, buf, sizeof(buf));
+	CHECK(err < 0, "task rename", "err %d", errno);
+
+	CHECK(skel->bss->count =3D=3D 0, "check_count", "didn't increase\n");
+	CHECK(skel->data->on_cpu !=3D 0xffffffff, "check_on_cpu", "got wrong va=
lue\n");
+
+	test_attr.prog_fd =3D bpf_program__fd(skel->progs.rename);
+	test_attr.ctx_in =3D args;
+	test_attr.ctx_size_in =3D sizeof(__u64);
+
+	err =3D bpf_prog_test_run_xattr(&test_attr);
+	CHECK(err =3D=3D 0, "test_run", "should fail for too small ctx\n");
+
+	test_attr.ctx_size_in =3D sizeof(args);
+	err =3D bpf_prog_test_run_xattr(&test_attr);
+	CHECK(err < 0, "test_run", "err %d\n", errno);
+	CHECK(test_attr.retval !=3D expected_retval, "check_retval",
+	      "expect 0x%x, got 0x%x\n", expected_retval, test_attr.retval);
+
+	for (i =3D 0; i < nr_online; i++)
+		if (online[i]) {
+			DECLARE_LIBBPF_OPTS(bpf_prog_test_run_opts, opts,
+				.cpu_plus =3D i + 1,
+			);
+
+			test_attr.retval =3D 0;
+			err =3D bpf_prog_test_run_xattr_opts(&test_attr, &opts);
+			CHECK(err < 0, "test_run_with_opts", "err %d\n", errno);
+			CHECK(skel->data->on_cpu !=3D i, "check_on_cpu",
+			      "got wrong value\n");
+			CHECK(test_attr.retval !=3D expected_retval,
+			      "check_retval", "expect 0x%x, got 0x%x\n",
+			      expected_retval, test_attr.retval);
+		}
+cleanup:
+	close(comm_fd);
+	test_raw_tp_test_run__destroy(skel);
+	free(online);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c b/t=
ools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
new file mode 100644
index 0000000000000..6b356e003d16c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include <bpf/bpf_tracing.h>
+
+__u32 count =3D 0;
+__u32 on_cpu =3D 0xffffffff;
+
+SEC("raw_tp/task_rename")
+int BPF_PROG(rename, struct task_struct *task, char *comm)
+{
+
+	count++;
+	if ((__u64) task =3D=3D 0x1234ULL && (__u64) comm =3D=3D 0x5678ULL) {
+		on_cpu =3D bpf_get_smp_processor_id();
+		return (int)task + (int)comm;
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") =3D "GPL";
--=20
2.24.1

