Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FF027632E
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgIWVdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:33:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43150 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726599AbgIWVdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 17:33:55 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08NLOtCA017663
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 14:33:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+LoeIH/NJHPwo3Cmc0JGpNX9imjK1oviPWLZDx71LMY=;
 b=YGK9HL6Men6I45JfjwG4mSyjwgeN0L6H3sRtW9EVOHTG9sbmSIgq97k6K0Ga7pfQRSm5
 mkDD4aX4Vy04F2amBqrlapgha/F/za9JRSyiLU196j8+NLh+7lTBsRkV4lGe63/syli3
 h/YqorBRQNgpX5UkC4COyjxTFi3ps9FkoLY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 33qsp4x5x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 14:33:53 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 14:33:51 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id BDD8062E5235; Wed, 23 Sep 2020 14:33:50 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 bpf-next 1/3] bpf: enable BPF_PROG_TEST_RUN for raw_tracepoint
Date:   Wed, 23 Sep 2020 14:33:35 -0700
Message-ID: <20200923213337.3432472-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200923213337.3432472-1-songliubraving@fb.com>
References: <20200923213337.3432472-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_16:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009230162
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add .test_run for raw_tracepoint. Also, introduce a new feature that runs
the target program on a specific CPU. This is achieved by a new flag in
bpf_attr.test, cpu_plus. For compatibility, cpu_plus =3D=3D 0 means run t=
he
program on current cpu, cpu_plus > 0 means run the program on cpu with id
(cpu_plus - 1). This feature is needed for BPF programs that handle
perf_event and other percpu resources, as the program can access these
resource locally.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf.h            |  3 ++
 include/uapi/linux/bpf.h       |  5 ++
 kernel/bpf/syscall.c           |  2 +-
 kernel/trace/bpf_trace.c       |  1 +
 net/bpf/test_run.c             | 88 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  5 ++
 6 files changed, 103 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d7c5a6ed87e30..23758c282eb4b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1376,6 +1376,9 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog=
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
index a22812561064a..89acf41913e70 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -566,6 +566,11 @@ union bpf_attr {
 						 */
 		__aligned_u64	ctx_in;
 		__aligned_u64	ctx_out;
+		__u32		cpu_plus;	/* run this program on cpu
+						 * (cpu_plus - 1).
+						 * If cpu_plus =3D=3D 0, run on
+						 * current cpu.
+						 */
 	} test;
=20
 	struct { /* anonymous struct used by BPF_*_GET_*_ID */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ec68d3a23a2b7..4664531ff92ea 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2975,7 +2975,7 @@ static int bpf_prog_query(const union bpf_attr *att=
r,
 	}
 }
=20
-#define BPF_PROG_TEST_RUN_LAST_FIELD test.ctx_out
+#define BPF_PROG_TEST_RUN_LAST_FIELD test.cpu_plus
=20
 static int bpf_prog_test_run(const union bpf_attr *attr,
 			     union bpf_attr __user *uattr)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b2a5380eb1871..4553aebf53862 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1675,6 +1675,7 @@ const struct bpf_verifier_ops raw_tracepoint_verifi=
er_ops =3D {
 };
=20
 const struct bpf_prog_ops raw_tracepoint_prog_ops =3D {
+	.test_run =3D bpf_prog_test_run_raw_tp,
 };
=20
 const struct bpf_verifier_ops tracing_verifier_ops =3D {
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 99eb8c6c0fbcc..b32e22f0ee16f 100644
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
+	if (kattr->test.cpu_plus)
+		return -EINVAL;
+
 	switch (prog->expected_attach_type) {
 	case BPF_TRACE_FENTRY:
 	case BPF_TRACE_FEXIT:
@@ -236,6 +240,84 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog,
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
+	int cpu, err =3D 0;
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
+	cpu =3D kattr->test.cpu_plus - 1;
+
+	if (!kattr->test.cpu_plus || cpu =3D=3D smp_processor_id()) {
+		__bpf_prog_test_run_raw_tp(&info);
+	} else {
+		/* smp_call_function_single() also checks cpu_online()
+		 * after csd_lock(). However, since cpu_plus is from user
+		 * space, let's do an extra quick check to filter out
+		 * invalid value before smp_call_function_single().
+		 */
+		if (!cpu_online(cpu)) {
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
@@ -410,6 +492,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, cons=
t union bpf_attr *kattr,
 	void *data;
 	int ret;
=20
+	if (kattr->test.cpu_plus)
+		return -EINVAL;
+
 	data =3D bpf_test_init(kattr, size, NET_SKB_PAD + NET_IP_ALIGN,
 			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
 	if (IS_ERR(data))
@@ -607,6 +692,9 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog =
*prog,
 	if (prog->type !=3D BPF_PROG_TYPE_FLOW_DISSECTOR)
 		return -EINVAL;
=20
+	if (kattr->test.cpu_plus)
+		return -EINVAL;
+
 	if (size < ETH_HLEN)
 		return -EINVAL;
=20
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index a22812561064a..89acf41913e70 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -566,6 +566,11 @@ union bpf_attr {
 						 */
 		__aligned_u64	ctx_in;
 		__aligned_u64	ctx_out;
+		__u32		cpu_plus;	/* run this program on cpu
+						 * (cpu_plus - 1).
+						 * If cpu_plus =3D=3D 0, run on
+						 * current cpu.
+						 */
 	} test;
=20
 	struct { /* anonymous struct used by BPF_*_GET_*_ID */
--=20
2.24.1

