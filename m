Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E843486B5
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239821AbhCYBxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:53:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52492 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236026AbhCYBw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 21:52:58 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P1m4WO000879
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wGR0kgmfrZuC7LIuwDqMcaIrrKpdBc6lGFTJDlJYubI=;
 b=oXAODE0kHiavMe9cxGyKYrqCSX9UZOvBEogA4yKRtxn1x83Ot4F3WgxXO4rGMdIANRy0
 HE1KeY8ybynLvvZnrnB/smXSg3MaVaAUXwuEE23jBqXL883S8Og4zCC4Jwg+1FN6qlJB
 kO7kXevheqemhJiDaq9OBw6yqNUCrUNVppg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37fn33sjd2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:58 -0700
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 18:52:57 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id CB91529429DE; Wed, 24 Mar 2021 18:52:52 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 14/14] bpf: selftests: Add kfunc_call test
Date:   Wed, 24 Mar 2021 18:52:52 -0700
Message-ID: <20210325015252.1551395-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325015124.1543397-1-kafai@fb.com>
References: <20210325015124.1543397-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_14:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a few kernel function bpf_kfunc_call_test*() for the
selftest's test_run purpose.  They will be allowed for tc_cls prog.

The selftest calling the kernel function bpf_kfunc_call_test*()
is also added in this patch.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h                           |  6 ++
 net/bpf/test_run.c                            | 28 +++++++++
 net/core/filter.c                             |  1 +
 .../selftests/bpf/prog_tests/kfunc_call.c     | 59 +++++++++++++++++++
 .../selftests/bpf/progs/kfunc_call_test.c     | 47 +++++++++++++++
 .../bpf/progs/kfunc_call_test_subprog.c       | 42 +++++++++++++
 6 files changed, 183 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kfunc_call.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_sub=
prog.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c6439e96fa4a..4b31b30c4961 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1501,6 +1501,7 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
 int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
 				const union bpf_attr *kattr,
 				union bpf_attr __user *uattr);
+bool bpf_prog_test_check_kfunc_call(u32 kfunc_id);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
@@ -1700,6 +1701,11 @@ static inline int bpf_prog_test_run_sk_lookup(stru=
ct bpf_prog *prog,
 	return -ENOTSUPP;
 }
=20
+static inline bool bpf_prog_test_check_kfunc_call(u32 kfunc_id)
+{
+	return false;
+}
+
 static inline void bpf_map_put(struct bpf_map *map)
 {
 }
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 0abdd67f44b1..7f3bce909b42 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2017 Facebook
  */
 #include <linux/bpf.h>
+#include <linux/btf_ids.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/etherdevice.h>
@@ -209,10 +210,37 @@ int noinline bpf_modify_return_test(int a, int *b)
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
+struct sock * noinline bpf_kfunc_call_test3(struct sock *sk)
+{
+	return sk;
+}
+
 __diag_pop();
=20
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
=20
+BTF_SET_START(test_sk_kfunc_ids)
+BTF_ID(func, bpf_kfunc_call_test1)
+BTF_ID(func, bpf_kfunc_call_test2)
+BTF_ID(func, bpf_kfunc_call_test3)
+BTF_SET_END(test_sk_kfunc_ids)
+
+bool bpf_prog_test_check_kfunc_call(u32 kfunc_id)
+{
+	return btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id);
+}
+
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
 			   u32 headroom, u32 tailroom)
 {
diff --git a/net/core/filter.c b/net/core/filter.c
index 10dac9dd5086..8a7d23c75ee3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9805,6 +9805,7 @@ const struct bpf_verifier_ops tc_cls_act_verifier_o=
ps =3D {
 	.convert_ctx_access	=3D tc_cls_act_convert_ctx_access,
 	.gen_prologue		=3D tc_cls_act_prologue,
 	.gen_ld_abs		=3D bpf_gen_ld_abs,
+	.check_kfunc_call	=3D bpf_prog_test_check_kfunc_call,
 };
=20
 const struct bpf_prog_ops tc_cls_act_prog_ops =3D {
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/=
testing/selftests/bpf/prog_tests/kfunc_call.c
new file mode 100644
index 000000000000..7fc0951ee75f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "kfunc_call_test.skel.h"
+#include "kfunc_call_test_subprog.skel.h"
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
+				NULL, NULL, (__u32 *)&retval, NULL);
+	ASSERT_OK(err, "bpf_prog_test_run(test1)");
+	ASSERT_EQ(retval, 12, "test1-retval");
+
+	prog_fd =3D bpf_program__fd(skel->progs.kfunc_call_test2);
+	err =3D bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, (__u32 *)&retval, NULL);
+	ASSERT_OK(err, "bpf_prog_test_run(test2)");
+	ASSERT_EQ(retval, 3, "test2-retval");
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
+				NULL, NULL, (__u32 *)&retval, NULL);
+	ASSERT_OK(err, "bpf_prog_test_run(test1)");
+	ASSERT_EQ(retval, 10, "test1-retval");
+	ASSERT_NEQ(skel->data->active_res, -1, "active_res");
+	ASSERT_EQ(skel->data->sk_state, BPF_TCP_CLOSE, "sk_state");
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
index 000000000000..470f8723e463
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_tcp_helpers.h"
+
+extern int bpf_kfunc_call_test2(struct sock *sk, __u32 a, __u32 b) __ksy=
m;
+extern __u64 bpf_kfunc_call_test1(struct sock *sk, __u32 a, __u64 b,
+				  __u32 c, __u64 d) __ksym;
+
+SEC("classifier")
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
+SEC("classifier")
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
index 000000000000..b2dcb7d9cb03
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_tcp_helpers.h"
+
+extern const int bpf_prog_active __ksym;
+extern __u64 bpf_kfunc_call_test1(struct sock *sk, __u32 a, __u64 b,
+				  __u32 c, __u64 d) __ksym;
+extern struct sock *bpf_kfunc_call_test3(struct sock *sk) __ksym;
+int active_res =3D -1;
+int sk_state =3D -1;
+
+int __noinline f1(struct __sk_buff *skb)
+{
+	struct bpf_sock *sk =3D skb->sk;
+	int *active;
+
+	if (!sk)
+		return -1;
+
+	sk =3D bpf_sk_fullsock(sk);
+	if (!sk)
+		return -1;
+
+	active =3D (int *)bpf_per_cpu_ptr(&bpf_prog_active,
+					bpf_get_smp_processor_id());
+	if (active)
+		active_res =3D *active;
+
+	sk_state =3D bpf_kfunc_call_test3((struct sock *)sk)->__sk_common.skc_s=
tate;
+
+	return (__u32)bpf_kfunc_call_test1((struct sock *)sk, 1, 2, 3, 4);
+}
+
+SEC("classifier")
+int kfunc_call_test1(struct __sk_buff *skb)
+{
+	return f1(skb);
+}
+
+char _license[] SEC("license") =3D "GPL";
--=20
2.30.2

