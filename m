Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF075E6FFC
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 00:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiIVW4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 18:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiIVW4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 18:56:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA31D10FE3B
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:56:33 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MKigCt027103
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:56:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=h9D6nJwYPmU+FeFh90ooVRJBT3lkdMbR7mCWzwU2vow=;
 b=RWExcF7eM2xD1o0K3Tql+RHe1dZU48s4X4zvtK4K+T2aPDo1nExvddwYSauXJ6CYOMUu
 byLitfMaiw2VzS4zS6ck6UCwEky4WWrZzY25+izjoqwJrI7OpxuJ4HVbibS6kDu6Ts+x
 jiPgRrjD2dNPjTdCY3SiQRCVYNY7HfxR43Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jrenwfgb9-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:56:33 -0700
Received: from twshared5413.23.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 15:56:29 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id ACE27999DAFA; Thu, 22 Sep 2022 15:56:23 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH bpf-next 1/5] bpf: Add __bpf_prog_{enter,exit}_struct_ops for struct_ops trampoline
Date:   Thu, 22 Sep 2022 15:56:23 -0700
Message-ID: <20220922225623.3055902-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220922225616.3054840-1-kafai@fb.com>
References: <20220922225616.3054840-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: dREilJCYBTl_3OCvKbpwMxb5iJVCrVKP
X-Proofpoint-ORIG-GUID: dREilJCYBTl_3OCvKbpwMxb5iJVCrVKP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_15,2022-09-22_02,2022-06-22_01
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

The struct_ops prog is to allow using bpf to implement the functions in
a struct (eg. kernel module).  The current usage is to implement the
tcp_congestion.  The kernel does not call the tcp-cc's ops (ie.
the bpf prog) in a recursive way.

The struct_ops is sharing the tracing-trampoline's enter/exit
function which tracks prog->active to avoid recursion.  It is
needed for tracing prog.  However, it turns out the struct_ops
bpf prog will hit this prog->active and unnecessarily skipped
running the struct_ops prog.  eg.  The '.ssthresh' may run in_task()
and then interrupted by softirq that runs the same '.ssthresh'.
Skip running the '.ssthresh' will end up returning random value
to the caller.

The patch adds __bpf_prog_{enter,exit}_struct_ops for the
struct_ops trampoline.  They do not track the prog->active
to detect recursion.

One exception is when the tcp_congestion's '.init' ops is doing
bpf_setsockopt(TCP_CONGESTION) and then recurs to the same
'.init' ops.  This will be addressed in the following patches.

Fixes: ca06f55b9002 ("bpf: Add per-program recursion prevention mechanism=
")
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c |  3 +++
 include/linux/bpf.h         |  4 ++++
 kernel/bpf/trampoline.c     | 23 +++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index ae89f4143eb4..58a131dec954 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1836,6 +1836,9 @@ static int invoke_bpf_prog(const struct btf_func_mo=
del *m, u8 **pprog,
 	if (p->aux->sleepable) {
 		enter =3D __bpf_prog_enter_sleepable;
 		exit =3D __bpf_prog_exit_sleepable;
+	} else if (p->type =3D=3D BPF_PROG_TYPE_STRUCT_OPS) {
+		enter =3D __bpf_prog_enter_struct_ops;
+		exit =3D __bpf_prog_exit_struct_ops;
 	} else if (p->expected_attach_type =3D=3D BPF_LSM_CGROUP) {
 		enter =3D __bpf_prog_enter_lsm_cgroup;
 		exit =3D __bpf_prog_exit_lsm_cgroup;
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index edd43edb27d6..6fdbc1398b8a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -864,6 +864,10 @@ u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_p=
rog *prog,
 					struct bpf_tramp_run_ctx *run_ctx);
 void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start=
,
 					struct bpf_tramp_run_ctx *run_ctx);
+u64 notrace __bpf_prog_enter_struct_ops(struct bpf_prog *prog,
+					struct bpf_tramp_run_ctx *run_ctx);
+void notrace __bpf_prog_exit_struct_ops(struct bpf_prog *prog, u64 start=
,
+					struct bpf_tramp_run_ctx *run_ctx);
 void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr);
 void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
=20
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 41b67eb83ab3..e6551e4a6064 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -976,6 +976,29 @@ void notrace __bpf_prog_exit_sleepable(struct bpf_pr=
og *prog, u64 start,
 	rcu_read_unlock_trace();
 }
=20
+u64 notrace __bpf_prog_enter_struct_ops(struct bpf_prog *prog,
+					struct bpf_tramp_run_ctx *run_ctx)
+	__acquires(RCU)
+{
+	rcu_read_lock();
+	migrate_disable();
+
+	run_ctx->saved_run_ctx =3D bpf_set_run_ctx(&run_ctx->run_ctx);
+
+	return bpf_prog_start_time();
+}
+
+void notrace __bpf_prog_exit_struct_ops(struct bpf_prog *prog, u64 start=
,
+					struct bpf_tramp_run_ctx *run_ctx)
+	__releases(RCU)
+{
+	bpf_reset_run_ctx(run_ctx->saved_run_ctx);
+
+	update_prog_stats(prog, start);
+	migrate_enable();
+	rcu_read_unlock();
+}
+
 void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr)
 {
 	percpu_ref_get(&tr->pcref);
--=20
2.30.2

