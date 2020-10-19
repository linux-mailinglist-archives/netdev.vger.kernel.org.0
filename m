Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E73292E9B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 21:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731305AbgJSTmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 15:42:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26126 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731233AbgJSTmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 15:42:33 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09JJccYO024938
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 12:42:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=MUFhgiqSi4z/uq5lpatzFCpQXq7FaX8srFh8v1wLOdc=;
 b=ISs6FC658dhy6Uw/+6eM1YvRKcyxVktLto/d5SJdS0u9UTEOmzsHJYxnRcuSSq+1uMAp
 pgPuErsXQWpnkWEwtbQlS7mxJF/chRdTyW3sDRXMXb9Tj+mb2pYK0ydaBa7OPjqH5hD7
 GKLnmr5Se/i2kJBGNd8OLHA/f95smntutco= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 347xef9dqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 12:42:31 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 19 Oct 2020 12:42:30 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 69F142946269; Mon, 19 Oct 2020 12:42:25 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hao Luo <haoluo@google.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf 3/3] bpf: selftest: Ensure the return value of the bpf_per_cpu_ptr() must be checked
Date:   Mon, 19 Oct 2020 12:42:25 -0700
Message-ID: <20201019194225.1051596-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201019194206.1050591-1-kafai@fb.com>
References: <20201019194206.1050591-1-kafai@fb.com>
MIME-Version: 1.0
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-19_10:2020-10-16,2020-10-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 suspectscore=38 bulkscore=0 mlxlogscore=754
 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010190132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch tests all pointers returned by bpf_per_cpu_ptr() must be
tested for NULL first before it can be accessed.

This patch adds a subtest "null_check", so it moves the ".data..percpu"
existence check to the very beginning and before doing any subtest.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 57 +++++++++++++------
 .../bpf/progs/test_ksyms_btf_null_check.c     | 31 ++++++++++
 2 files changed, 70 insertions(+), 18 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf_null=
_check.c

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/t=
esting/selftests/bpf/prog_tests/ksyms_btf.c
index 28e26bd3e0ca..b58b775d19f3 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -5,18 +5,17 @@
 #include <bpf/libbpf.h>
 #include <bpf/btf.h>
 #include "test_ksyms_btf.skel.h"
+#include "test_ksyms_btf_null_check.skel.h"
=20
 static int duration;
=20
-void test_ksyms_btf(void)
+static void test_basic(void)
 {
 	__u64 runqueues_addr, bpf_prog_active_addr;
 	__u32 this_rq_cpu;
 	int this_bpf_prog_active;
 	struct test_ksyms_btf *skel =3D NULL;
 	struct test_ksyms_btf__data *data;
-	struct btf *btf;
-	int percpu_datasec;
 	int err;
=20
 	err =3D kallsyms_find("runqueues", &runqueues_addr);
@@ -31,20 +30,6 @@ void test_ksyms_btf(void)
 	if (CHECK(err =3D=3D -ENOENT, "ksym_find", "symbol 'bpf_prog_active' no=
t found\n"))
 		return;
=20
-	btf =3D libbpf_find_kernel_btf();
-	if (CHECK(IS_ERR(btf), "btf_exists", "failed to load kernel BTF: %ld\n"=
,
-		  PTR_ERR(btf)))
-		return;
-
-	percpu_datasec =3D btf__find_by_name_kind(btf, ".data..percpu",
-						BTF_KIND_DATASEC);
-	if (percpu_datasec < 0) {
-		printf("%s:SKIP:no PERCPU DATASEC in kernel btf\n",
-		       __func__);
-		test__skip();
-		goto cleanup;
-	}
-
 	skel =3D test_ksyms_btf__open_and_load();
 	if (CHECK(!skel, "skel_open", "failed to open and load skeleton\n"))
 		goto cleanup;
@@ -83,6 +68,42 @@ void test_ksyms_btf(void)
 	      data->out__bpf_prog_active);
=20
 cleanup:
-	btf__free(btf);
 	test_ksyms_btf__destroy(skel);
 }
+
+static void test_null_check(void)
+{
+	struct test_ksyms_btf_null_check *skel;
+
+	skel =3D test_ksyms_btf_null_check__open_and_load();
+	CHECK(skel, "skel_open", "unexpected load of a prog missing null check\=
n");
+
+	test_ksyms_btf_null_check__destroy(skel);
+}
+
+void test_ksyms_btf(void)
+{
+	int percpu_datasec;
+	struct btf *btf;
+
+	btf =3D libbpf_find_kernel_btf();
+	if (CHECK(IS_ERR(btf), "btf_exists", "failed to load kernel BTF: %ld\n"=
,
+		  PTR_ERR(btf)))
+		return;
+
+	percpu_datasec =3D btf__find_by_name_kind(btf, ".data..percpu",
+						BTF_KIND_DATASEC);
+	btf__free(btf);
+	if (percpu_datasec < 0) {
+		printf("%s:SKIP:no PERCPU DATASEC in kernel btf\n",
+		       __func__);
+		test__skip();
+		return;
+	}
+
+	if (test__start_subtest("basic"))
+		test_basic();
+
+	if (test__start_subtest("null_check"))
+		test_null_check();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf_null_check.=
c b/tools/testing/selftests/bpf/progs/test_ksyms_btf_null_check.c
new file mode 100644
index 000000000000..8bc8f7c637bc
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf_null_check.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+extern const struct rq runqueues __ksym; /* struct type global var. */
+extern const int bpf_prog_active __ksym; /* int type global var. */
+
+SEC("raw_tp/sys_enter")
+int handler(const void *ctx)
+{
+	struct rq *rq;
+	int *active;
+	__u32 cpu;
+
+	cpu =3D bpf_get_smp_processor_id();
+	rq =3D (struct rq *)bpf_per_cpu_ptr(&runqueues, cpu);
+	active =3D (int *)bpf_per_cpu_ptr(&bpf_prog_active, cpu);
+	if (active) {
+		/* READ_ONCE */
+		*(volatile int *)active;
+		/* !rq has not been tested, so verifier should reject. */
+		*(volatile int *)(&rq->cpu);
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") =3D "GPL";
--=20
2.24.1

