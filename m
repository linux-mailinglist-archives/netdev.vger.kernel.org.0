Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0585E6FF7
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 00:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiIVW4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 18:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiIVW4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 18:56:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795D710F734
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:56:44 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MKiQgv001128
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:56:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=RqFL4vFtq4xcNAh9IUa9kzPBN7c/NmqbgQ+sYfefREs=;
 b=pHrzvTJRxAIFO+63+bl0P3og0gtwmjKRzwnTwZ1ggnlC6njx2mvFXjZqloFM4Zr5CBm+
 pXzo0cRqHMQVSyPdfEgPCCJpnEFRqUuxY+CgvcHJq+NohfBw3S268vWSEQuKqFPo2NGj
 dzhTXawVerHDHBwJ0+7uicVSJ9ScUP6KyrU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jrhjgps1g-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:56:44 -0700
Received: from twshared20273.14.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 15:56:42 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 7605F999DE7D; Thu, 22 Sep 2022 15:56:36 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH bpf-next 3/5] bpf: Add bpf_run_ctx_type
Date:   Thu, 22 Sep 2022 15:56:36 -0700
Message-ID: <20220922225636.3057567-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220922225616.3054840-1-kafai@fb.com>
References: <20220922225616.3054840-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: iRZALEdLytxiydXFOUaBnyiEY9MIXYJk
X-Proofpoint-ORIG-GUID: iRZALEdLytxiydXFOUaBnyiEY9MIXYJk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_14,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

This patch adds a bpf_run_ctx_type to the struct bpf_run_ctx.
The next patch needs to look at the previous run ctx saved at
tramp_run_ctx->saved_run_ctx and checks if it is also
changing the tcp-cc for the same sk (saved in bpf_cookie).
Thus, it needs to know if the saved_run_ctx is the bpf_run_ctx
type that it is looking for before looking into its members.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 include/linux/bpf.h      | 17 ++++++++++++++---
 kernel/bpf/bpf_iter.c    |  2 +-
 kernel/bpf/cgroup.c      |  2 +-
 kernel/bpf/trampoline.c  |  4 ++++
 kernel/trace/bpf_trace.c |  1 +
 net/bpf/test_run.c       |  2 +-
 6 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6fdbc1398b8a..902b1be047cf 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1517,7 +1517,18 @@ int bpf_prog_array_copy(struct bpf_prog_array *old=
_array,
 			u64 bpf_cookie,
 			struct bpf_prog_array **new_array);
=20
-struct bpf_run_ctx {};
+enum bpf_run_ctx_type {
+	BPF_RUN_CTX_TYPE_NONE,
+	BPF_RUN_CTX_TYPE_CG,
+	BPF_RUN_CTX_TYPE_TRACE,
+	BPF_RUN_CTX_TYPE_TRAMP,
+	BPF_RUN_CTX_TYPE_KPROBE_MULTI,
+	BPF_RUN_CTX_TYPE_STRUCT_OPS,
+};
+
+struct bpf_run_ctx {
+	enum bpf_run_ctx_type type;
+};
=20
 struct bpf_cg_run_ctx {
 	struct bpf_run_ctx run_ctx;
@@ -1568,7 +1579,7 @@ bpf_prog_run_array(const struct bpf_prog_array *arr=
ay,
 	const struct bpf_prog_array_item *item;
 	const struct bpf_prog *prog;
 	struct bpf_run_ctx *old_run_ctx;
-	struct bpf_trace_run_ctx run_ctx;
+	struct bpf_trace_run_ctx run_ctx =3D { .run_ctx.type =3D BPF_RUN_CTX_TY=
PE_TRACE };
 	u32 ret =3D 1;
=20
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu lock held");
@@ -1607,7 +1618,7 @@ bpf_prog_run_array_sleepable(const struct bpf_prog_=
array __rcu *array_rcu,
 	const struct bpf_prog *prog;
 	const struct bpf_prog_array *array;
 	struct bpf_run_ctx *old_run_ctx;
-	struct bpf_trace_run_ctx run_ctx;
+	struct bpf_trace_run_ctx run_ctx =3D { .run_ctx.type =3D BPF_RUN_CTX_TY=
PE_TRACE };
 	u32 ret =3D 1;
=20
 	might_fault();
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 5dc307bdeaeb..65ff0c93b0ba 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -694,7 +694,7 @@ struct bpf_prog *bpf_iter_get_info(struct bpf_iter_me=
ta *meta, bool in_stop)
=20
 int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx)
 {
-	struct bpf_run_ctx run_ctx, *old_run_ctx;
+	struct bpf_run_ctx run_ctx =3D {}, *old_run_ctx;
 	int ret;
=20
 	if (prog->aux->sleepable) {
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 00c7f864900e..850fd6983b9a 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -37,7 +37,7 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
 	const struct bpf_prog *prog;
 	const struct bpf_prog_array *array;
 	struct bpf_run_ctx *old_run_ctx;
-	struct bpf_cg_run_ctx run_ctx;
+	struct bpf_cg_run_ctx run_ctx =3D { .run_ctx.type =3D BPF_RUN_CTX_TYPE_=
CG };
 	u32 func_ret;
=20
 	run_ctx.retval =3D retval;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index e6551e4a6064..313619012a59 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -882,6 +882,7 @@ u64 notrace __bpf_prog_enter(struct bpf_prog *prog, s=
truct bpf_tramp_run_ctx *ru
 	rcu_read_lock();
 	migrate_disable();
=20
+	run_ctx->run_ctx.type =3D BPF_RUN_CTX_TYPE_TRAMP;
 	run_ctx->saved_run_ctx =3D bpf_set_run_ctx(&run_ctx->run_ctx);
=20
 	if (unlikely(this_cpu_inc_return(*(prog->active)) !=3D 1)) {
@@ -934,6 +935,7 @@ u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_pr=
og *prog,
 	rcu_read_lock();
 	migrate_disable();
=20
+	run_ctx->run_ctx.type =3D BPF_RUN_CTX_TYPE_TRAMP;
 	run_ctx->saved_run_ctx =3D bpf_set_run_ctx(&run_ctx->run_ctx);
=20
 	return NO_START_TIME;
@@ -960,6 +962,7 @@ u64 notrace __bpf_prog_enter_sleepable(struct bpf_pro=
g *prog, struct bpf_tramp_r
 		return 0;
 	}
=20
+	run_ctx->run_ctx.type =3D BPF_RUN_CTX_TYPE_TRAMP;
 	run_ctx->saved_run_ctx =3D bpf_set_run_ctx(&run_ctx->run_ctx);
=20
 	return bpf_prog_start_time();
@@ -983,6 +986,7 @@ u64 notrace __bpf_prog_enter_struct_ops(struct bpf_pr=
og *prog,
 	rcu_read_lock();
 	migrate_disable();
=20
+	run_ctx->run_ctx.type =3D BPF_RUN_CTX_TYPE_STRUCT_OPS;
 	run_ctx->saved_run_ctx =3D bpf_set_run_ctx(&run_ctx->run_ctx);
=20
 	return bpf_prog_start_time();
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b05f0310dbd3..7670ca88b721 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2575,6 +2575,7 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_=
link *link,
 			   unsigned long entry_ip, struct pt_regs *regs)
 {
 	struct bpf_kprobe_multi_run_ctx run_ctx =3D {
+		.run_ctx.type =3D BPF_RUN_CTX_TYPE_KPROBE_MULTI,
 		.link =3D link,
 		.entry_ip =3D entry_ip,
 	};
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 13d578ce2a09..1f2a745e8641 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -374,7 +374,7 @@ static int bpf_test_run(struct bpf_prog *prog, void *=
ctx, u32 repeat,
 {
 	struct bpf_prog_array_item item =3D {.prog =3D prog};
 	struct bpf_run_ctx *old_ctx;
-	struct bpf_cg_run_ctx run_ctx;
+	struct bpf_cg_run_ctx run_ctx =3D { .run_ctx.type =3D BPF_RUN_CTX_TYPE_=
CG };
 	struct bpf_test_timer t =3D { NO_MIGRATE };
 	enum bpf_cgroup_storage_type stype;
 	int ret;
--=20
2.30.2

