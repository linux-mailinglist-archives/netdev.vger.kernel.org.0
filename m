Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458E133CABD
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 02:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhCPBPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 21:15:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52324 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234263AbhCPBPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 21:15:13 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G1ApWd016485
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:15:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=DYrqcQQpzTMDIPeeijN+UI2y6v0Uo1s6H4h/RZofrtE=;
 b=p1D9ZjoERtatyXmRl/M/BvyTR4gkRBS4WF+62aCawtlrco57BsTkEb0QaNux1G4CNx2+
 05sXfIR23CJH+uAzI6tY19fOQEnqBUO4/A377FhwqTkpugqkDrGJ32UKv/zFZHLWdLHO
 wclCSHV9qzSNqYEIbibNKdu+aThGoUP6jFM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 379e3ursw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:15:13 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 18:15:11 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 240CA2942B58; Mon, 15 Mar 2021 18:15:10 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 15/15] bpf: selftest: Add kfunc_call test
Date:   Mon, 15 Mar 2021 18:15:10 -0700
Message-ID: <20210316011510.4181765-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316011336.4173585-1-kafai@fb.com>
References: <20210316011336.4173585-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_15:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds two kernel function bpf_kfunc_call_test[12]() for the
selftest's test_run purpose.  They will be allowed for tc_cls prog.

The selftest calling the kernel function bpf_kfunc_call_test[12]()
is also added in this patch.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/bpf/test_run.c                            | 11 ++++
 net/core/filter.c                             | 11 ++++
 .../selftests/bpf/prog_tests/kfunc_call.c     | 61 +++++++++++++++++++
 .../selftests/bpf/progs/kfunc_call_test.c     | 48 +++++++++++++++
 .../bpf/progs/kfunc_call_test_subprog.c       | 31 ++++++++++
 5 files changed, 162 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kfunc_call.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_sub=
prog.c

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 0abdd67f44b1..c1baab0c7d96 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -209,6 +209,17 @@ int noinline bpf_modify_return_test(int a, int *b)
 	*b +=3D 1;
 	return a + *b;
 }
+
+u64 noinline bpf_kfunc_call_test1(struct sock *sk, u32 a, u64 b, u32 c, =
u64 d)
+{
+	return a + b + c + d;
+}
+
+int noinline bpf_kfunc_call_test2(struct sock *sk, u32 a, u32 b)
+{
+	return a + b;
+}
+
 __diag_pop();
=20
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
diff --git a/net/core/filter.c b/net/core/filter.c
index 10dac9dd5086..605fbbdd694b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9799,12 +9799,23 @@ const struct bpf_prog_ops sk_filter_prog_ops =3D =
{
 	.test_run		=3D bpf_prog_test_run_skb,
 };
=20
+BTF_SET_START(bpf_tc_cls_kfunc_ids)
+BTF_ID(func, bpf_kfunc_call_test1)
+BTF_ID(func, bpf_kfunc_call_test2)
+BTF_SET_END(bpf_tc_cls_kfunc_ids)
+
+static bool tc_cls_check_kern_func_call(u32 kfunc_id)
+{
+	return btf_id_set_contains(&bpf_tc_cls_kfunc_ids, kfunc_id);
+}
+
 const struct bpf_verifier_ops tc_cls_act_verifier_ops =3D {
 	.get_func_proto		=3D tc_cls_act_func_proto,
 	.is_valid_access	=3D tc_cls_act_is_valid_access,
 	.convert_ctx_access	=3D tc_cls_act_convert_ctx_access,
 	.gen_prologue		=3D tc_cls_act_prologue,
 	.gen_ld_abs		=3D bpf_gen_ld_abs,
+	.check_kern_func_call	=3D tc_cls_check_kern_func_call,
 };
=20
 const struct bpf_prog_ops tc_cls_act_prog_ops =3D {
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/=
testing/selftests/bpf/prog_tests/kfunc_call.c
new file mode 100644
index 000000000000..3850e6cc0a7d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "kfunc_call_test.skel.h"
+#include "kfunc_call_test_subprog.skel.h"
+
+static __u32 duration;
+
+static void test_main(void)
+{
+	struct kfunc_call_test *skel;
+	int prog_fd, retval, err;
+
+	skel =3D kfunc_call_test__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel"))
+		return;
+
+	prog_fd =3D bpf_program__fd(skel->progs.kfunc_call_test1);
+	err =3D bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, (__u32 *)&retval, &duration);
+
+	if (ASSERT_OK(err, "bpf_prog_test_run(test1)"))
+		ASSERT_EQ(retval, 12, "test1-retval");
+
+	prog_fd =3D bpf_program__fd(skel->progs.kfunc_call_test2);
+	err =3D bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, (__u32 *)&retval, &duration);
+	if (ASSERT_OK(err, "bpf_prog_test_run(test2)"))
+		ASSERT_EQ(retval, 3, "test2-retval");
+
+	kfunc_call_test__destroy(skel);
+}
+
+static void test_subprog(void)
+{
+	struct kfunc_call_test_subprog *skel;
+	int prog_fd, retval, err;
+
+	skel =3D kfunc_call_test_subprog__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel"))
+		return;
+
+	prog_fd =3D bpf_program__fd(skel->progs.kfunc_call_test1);
+	err =3D bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, (__u32 *)&retval, &duration);
+
+	if (ASSERT_OK(err, "bpf_prog_test_run(test1)"))
+		ASSERT_EQ(retval, 10, "test1-retval");
+
+	kfunc_call_test_subprog__destroy(skel);
+}
+
+void test_kfunc_call(void)
+{
+	if (test__start_subtest("main"))
+		test_main();
+
+	if (test__start_subtest("subprog"))
+		test_subprog();
+}
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/=
testing/selftests/bpf/progs/kfunc_call_test.c
new file mode 100644
index 000000000000..ea8c5266efd8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_tcp_helpers.h"
+
+extern __u64 bpf_kfunc_call_test1(struct sock *sk, __u32 a, __u64 b,
+				  __u32 c, __u64 d) __ksym;
+extern int bpf_kfunc_call_test2(struct sock *sk, __u32 a, __u32 b) __ksy=
m;
+
+SEC("classifier/test2")
+int kfunc_call_test2(struct __sk_buff *skb)
+{
+	struct bpf_sock *sk =3D skb->sk;
+
+	if (!sk)
+		return -1;
+
+	sk =3D bpf_sk_fullsock(sk);
+	if (!sk)
+		return -1;
+
+	return bpf_kfunc_call_test2((struct sock *)sk, 1, 2);
+}
+
+SEC("classifier/test1")
+int kfunc_call_test1(struct __sk_buff *skb)
+{
+	struct bpf_sock *sk =3D skb->sk;
+	__u64 a =3D 1ULL << 32;
+	__u32 ret;
+
+	if (!sk)
+		return -1;
+
+	sk =3D bpf_sk_fullsock(sk);
+	if (!sk)
+		return -1;
+
+	a =3D bpf_kfunc_call_test1((struct sock *)sk, 1, a | 2, 3, a | 4);
+
+	ret =3D a >> 32;   /* ret should be 2 */
+	ret +=3D (__u32)a; /* ret should be 12 */
+
+	return ret;
+}
+
+char _license[] SEC("license") =3D "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c =
b/tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c
new file mode 100644
index 000000000000..9bf66f8c826e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_tcp_helpers.h"
+
+extern __u64 bpf_kfunc_call_test1(struct sock *sk, __u32 a, __u64 b,
+				  __u32 c, __u64 d) __ksym;
+
+__attribute__ ((noinline))
+int f1(struct __sk_buff *skb)
+{
+	struct bpf_sock *sk =3D skb->sk;
+
+	if (!sk)
+		return -1;
+
+	sk =3D bpf_sk_fullsock(sk);
+	if (!sk)
+		return -1;
+
+	return (__u32)bpf_kfunc_call_test1((struct sock *)sk, 1, 2, 3, 4);
+}
+
+SEC("classifier/test1_subprog")
+int kfunc_call_test1(struct __sk_buff *skb)
+{
+	return f1(skb);
+}
+
+char _license[] SEC("license") =3D "GPL";
--=20
2.30.2

