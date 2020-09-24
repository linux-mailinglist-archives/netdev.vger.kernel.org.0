Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49A3277C1D
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 01:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgIXXDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 19:03:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34242 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726704AbgIXXDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 19:03:08 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08ON2rd4026803
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 16:03:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=BNmy/GHPThnlKx1netK5oCSDUBSMKw/V+zBkR+CLIbk=;
 b=m0oKr2ddmUhLimjCJVhX1HgBFgTJ0dtS0lUQsX3HOAHJ+cfO5hHSxtg09mCBNlSwQgNs
 l8RkopVaPkGduh0BCJ8VfASPsarp7w9tASdpgn6VKsH2KWeXtPp8woJAXz0z/TJZ/lGG
 Nns/hMkwf7CIy6bgCXvADmucW9ghgEdhkww= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 33qsp7mnqc-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 16:03:07 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 16:02:30 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id C53ED62E542E; Thu, 24 Sep 2020 16:02:27 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v5 bpf-next 3/3] selftests/bpf: add raw_tp_test_run
Date:   Thu, 24 Sep 2020 16:02:09 -0700
Message-ID: <20200924230209.2561658-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200924230209.2561658-1-songliubraving@fb.com>
References: <20200924230209.2561658-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240167
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test runs test_run for raw_tracepoint program. The test covers ctx
input, retval output, and running on correct cpu.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../bpf/prog_tests/raw_tp_test_run.c          | 98 +++++++++++++++++++
 .../bpf/progs/test_raw_tp_test_run.c          | 24 +++++
 2 files changed, 122 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_test_ru=
n.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_raw_tp_test_ru=
n.c

diff --git a/tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c b/t=
ools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
new file mode 100644
index 0000000000000..5b07259781610
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2019 Facebook */
+#include <test_progs.h>
+#include <linux/bpf.h>
+#include "bpf/libbpf_internal.h"
+#include "test_raw_tp_test_run.skel.h"
+
+static int duration;
+
+void test_raw_tp_test_run(void)
+{
+	struct bpf_prog_test_run_attr test_attr =3D {};
+	int comm_fd =3D -1, err, nr_online, i, prog_fd;
+	__u64 args[2] =3D {0x1234ULL, 0x5678ULL};
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
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		goto cleanup;
+
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
+	prog_fd =3D bpf_program__fd(skel->progs.rename);
+	test_attr.prog_fd =3D prog_fd;
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
+	for (i =3D 0; i < nr_online; i++) {
+		if (online[i]) {
+			DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
+				.ctx_in =3D args,
+				.ctx_size_in =3D sizeof(args),
+				.flags =3D BPF_F_TEST_RUN_ON_CPU,
+				.retval =3D 0,
+				.cpu =3D i,
+			);
+
+			err =3D bpf_prog_test_run_opts(prog_fd, &opts);
+			CHECK(err < 0, "test_run_opts", "err %d\n", errno);
+			CHECK(skel->data->on_cpu !=3D i, "check_on_cpu",
+			      "expect %d got %d\n", i, skel->data->on_cpu);
+			CHECK(opts.retval !=3D expected_retval,
+			      "check_retval", "expect 0x%x, got 0x%x\n",
+			      expected_retval, opts.retval);
+
+			if (i =3D=3D 0) {
+				/* invalid cpu ID should fail with ENXIO */
+				opts.cpu =3D 0xffffffff;
+				err =3D bpf_prog_test_run_opts(prog_fd, &opts);
+				CHECK(err !=3D -1 || errno !=3D ENXIO,
+				      "test_run_opts_fail",
+				      "should failed with ENXIO\n");
+			} else {
+				/* non-zero cpu w/o BPF_F_TEST_RUN_ON_CPU
+				 * should fail with EINVAL
+				 */
+				opts.flags =3D 0;
+				err =3D bpf_prog_test_run_opts(prog_fd, &opts);
+				CHECK(err !=3D -1 || errno !=3D EINVAL,
+				      "test_run_opts_fail",
+				      "should failed with EINVAL\n");
+			}
+		}
+	}
+cleanup:
+	close(comm_fd);
+	test_raw_tp_test_run__destroy(skel);
+	free(online);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c b/t=
ools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
new file mode 100644
index 0000000000000..1521853597d70
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
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

