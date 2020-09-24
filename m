Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67F5277C1A
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 01:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgIXXCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 19:02:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13836 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726703AbgIXXCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 19:02:48 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08OMxhjV012685
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 16:02:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=iNHTkSoWjaY8UvCGh6NYrqRluGParEjfsBWd9T//KjA=;
 b=PtFvsFR3gjWS1ZmvAhvVlTakg1XYCmgiXYhJ+qx6Sq6NxPLHCoZz85fZmpUiyaqcmFLo
 o/f2tMiDhzR08S8RGgMUa5GD6JghkFJAmLdGoNUlJsYKTumFxvLxsGfxDpSBksB4Kz+O
 dB7g3aFMExTbBn38In9coGQvcrCCLgCSTv4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp44nkc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 16:02:46 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 16:02:27 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 75A5862E542E; Thu, 24 Sep 2020 16:02:17 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v5 bpf-next 1/3] bpf: enable BPF_PROG_TEST_RUN for raw_tracepoint
Date:   Thu, 24 Sep 2020 16:02:07 -0700
Message-ID: <20200924230209.2561658-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200924230209.2561658-1-songliubraving@fb.com>
References: <20200924230209.2561658-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240166
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add .test_run for raw_tracepoint. Also, introduce a new feature that runs
the target program on a specific CPU. This is achieved by a new flag in
bpf_attr.test, BPF_F_TEST_RUN_ON_CPU. When this flag is set, the program
is triggered on cpu with id bpf_attr.test.cpu. This feature is needed for
BPF programs that handle perf_event and other percpu resources, as the
program can access these resource locally.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf.h            |  3 ++
 include/uapi/linux/bpf.h       |  7 +++
 kernel/bpf/syscall.c           |  2 +-
 kernel/trace/bpf_trace.c       |  1 +
 net/bpf/test_run.c             | 91 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 +++
 6 files changed, 110 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fc5c901c75421..efa7245ed76e0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1381,6 +1381,9 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog=
,
 int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 				     const union bpf_attr *kattr,
 				     union bpf_attr __user *uattr);
+int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
+			     const union bpf_attr *kattr,
+			     union bpf_attr __user *uattr);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a22812561064a..05e480f66f475 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -424,6 +424,11 @@ enum {
  */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
=20
+/* Flags for BPF_PROG_TEST_RUN */
+
+/* If set, run the test on the cpu specified by bpf_attr.test.cpu */
+#define BPF_F_TEST_RUN_ON_CPU	(1U << 0)
+
 /* type for BPF_ENABLE_STATS */
 enum bpf_stats_type {
 	/* enabled run_time_ns and run_cnt */
@@ -566,6 +571,8 @@ union bpf_attr {
 						 */
 		__aligned_u64	ctx_in;
 		__aligned_u64	ctx_out;
+		__u32		flags;
+		__u32		cpu;
 	} test;
=20
 	struct { /* anonymous struct used by BPF_*_GET_*_ID */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2740df19f55e9..3bc2ed2e171be 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2979,7 +2979,7 @@ static int bpf_prog_query(const union bpf_attr *att=
r,
 	}
 }
=20
-#define BPF_PROG_TEST_RUN_LAST_FIELD test.ctx_out
+#define BPF_PROG_TEST_RUN_LAST_FIELD test.cpu
=20
 static int bpf_prog_test_run(const union bpf_attr *attr,
 			     union bpf_attr __user *uattr)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 36508f46a8dbf..2834866d379ae 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1678,6 +1678,7 @@ const struct bpf_verifier_ops raw_tracepoint_verifi=
er_ops =3D {
 };
=20
 const struct bpf_prog_ops raw_tracepoint_prog_ops =3D {
+	.test_run =3D bpf_prog_test_run_raw_tp,
 };
=20
 const struct bpf_verifier_ops tracing_verifier_ops =3D {
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index a66f211726e7c..fde5db93507c4 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -11,6 +11,7 @@
 #include <net/sock.h>
 #include <net/tcp.h>
 #include <linux/error-injection.h>
+#include <linux/smp.h>
=20
 #define CREATE_TRACE_POINTS
 #include <trace/events/bpf_test_run.h>
@@ -204,6 +205,9 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog,
 	int b =3D 2, err =3D -EFAULT;
 	u32 retval =3D 0;
=20
+	if (kattr->test.flags || kattr->test.cpu)
+		return -EINVAL;
+
 	switch (prog->expected_attach_type) {
 	case BPF_TRACE_FENTRY:
 	case BPF_TRACE_FEXIT:
@@ -236,6 +240,87 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog,
 	return err;
 }
=20
+struct bpf_raw_tp_test_run_info {
+	struct bpf_prog *prog;
+	void *ctx;
+	u32 retval;
+};
+
+static void
+__bpf_prog_test_run_raw_tp(void *data)
+{
+	struct bpf_raw_tp_test_run_info *info =3D data;
+
+	rcu_read_lock();
+	migrate_disable();
+	info->retval =3D BPF_PROG_RUN(info->prog, info->ctx);
+	migrate_enable();
+	rcu_read_unlock();
+}
+
+int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
+			     const union bpf_attr *kattr,
+			     union bpf_attr __user *uattr)
+{
+	void __user *ctx_in =3D u64_to_user_ptr(kattr->test.ctx_in);
+	__u32 ctx_size_in =3D kattr->test.ctx_size_in;
+	struct bpf_raw_tp_test_run_info info;
+	int cpu =3D kattr->test.cpu, err =3D 0;
+
+	/* doesn't support data_in/out, ctx_out, duration, or repeat */
+	if (kattr->test.data_in || kattr->test.data_out ||
+	    kattr->test.ctx_out || kattr->test.duration ||
+	    kattr->test.repeat)
+		return -EINVAL;
+
+	if (ctx_size_in < prog->aux->max_ctx_offset)
+		return -EINVAL;
+
+	if ((kattr->test.flags & BPF_F_TEST_RUN_ON_CPU) =3D=3D 0 && cpu !=3D 0)
+		return -EINVAL;
+
+	if (ctx_size_in) {
+		info.ctx =3D kzalloc(ctx_size_in, GFP_USER);
+		if (!info.ctx)
+			return -ENOMEM;
+		if (copy_from_user(info.ctx, ctx_in, ctx_size_in)) {
+			err =3D -EFAULT;
+			goto out;
+		}
+	} else {
+		info.ctx =3D NULL;
+	}
+
+	info.prog =3D prog;
+
+	if ((kattr->test.flags & BPF_F_TEST_RUN_ON_CPU) =3D=3D 0 ||
+	    cpu =3D=3D smp_processor_id()) {
+		__bpf_prog_test_run_raw_tp(&info);
+	} else {
+		/* smp_call_function_single() also checks cpu_online()
+		 * after csd_lock(). However, since cpu is from user
+		 * space, let's do an extra quick check to filter out
+		 * invalid value before smp_call_function_single().
+		 */
+		if (cpu >=3D nr_cpu_ids || !cpu_online(cpu)) {
+			err =3D -ENXIO;
+			goto out;
+		}
+
+		err =3D smp_call_function_single(cpu, __bpf_prog_test_run_raw_tp,
+					       &info, 1);
+		if (err)
+			goto out;
+	}
+
+	if (copy_to_user(&uattr->test.retval, &info.retval, sizeof(u32)))
+		err =3D -EFAULT;
+
+out:
+	kfree(info.ctx);
+	return err;
+}
+
 static void *bpf_ctx_init(const union bpf_attr *kattr, u32 max_size)
 {
 	void __user *data_in =3D u64_to_user_ptr(kattr->test.ctx_in);
@@ -410,6 +495,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, cons=
t union bpf_attr *kattr,
 	void *data;
 	int ret;
=20
+	if (kattr->test.flags || kattr->test.cpu)
+		return -EINVAL;
+
 	data =3D bpf_test_init(kattr, size, NET_SKB_PAD + NET_IP_ALIGN,
 			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
 	if (IS_ERR(data))
@@ -607,6 +695,9 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog =
*prog,
 	if (prog->type !=3D BPF_PROG_TYPE_FLOW_DISSECTOR)
 		return -EINVAL;
=20
+	if (kattr->test.flags || kattr->test.cpu)
+		return -EINVAL;
+
 	if (size < ETH_HLEN)
 		return -EINVAL;
=20
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index a22812561064a..05e480f66f475 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -424,6 +424,11 @@ enum {
  */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
=20
+/* Flags for BPF_PROG_TEST_RUN */
+
+/* If set, run the test on the cpu specified by bpf_attr.test.cpu */
+#define BPF_F_TEST_RUN_ON_CPU	(1U << 0)
+
 /* type for BPF_ENABLE_STATS */
 enum bpf_stats_type {
 	/* enabled run_time_ns and run_cnt */
@@ -566,6 +571,8 @@ union bpf_attr {
 						 */
 		__aligned_u64	ctx_in;
 		__aligned_u64	ctx_out;
+		__u32		flags;
+		__u32		cpu;
 	} test;
=20
 	struct { /* anonymous struct used by BPF_*_GET_*_ID */
--=20
2.24.1

