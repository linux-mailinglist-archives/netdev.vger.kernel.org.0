Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D5433CA98
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 02:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhCPBNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 21:13:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43362 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231531AbhCPBNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 21:13:50 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G19ebt028898
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:13:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=QJlv/864J5t8+zuxWYWLvg63mNfUwWQPwofIJoHa8z4=;
 b=Vke4v4FWMtbcbf4JqZKg3p3CBmoCafW/UptISmjIiqyjwjD6lizwFbTmNi8LLOlkBRaT
 RlLVaf5ZTP7XWC7339BqFyVJCBkcPD37j6dmcBNkfyeAB7RWRqqkUfvoqWMnFNA+Pgmh
 XZSpFqr4DqG/Ta6gedrFbILOx67zAdvB6Yk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 379dx7guek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:13:49 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 18:13:48 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 94DD52942B4F; Mon, 15 Mar 2021 18:13:42 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 01/15] bpf: Simplify freeing logic in linfo and jited_linfo
Date:   Mon, 15 Mar 2021 18:13:42 -0700
Message-ID: <20210316011342.4174104-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316011336.4173585-1-kafai@fb.com>
References: <20210316011336.4173585-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_15:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch simplifies the linfo freeing logic by combining
"bpf_prog_free_jited_linfo()" and "bpf_prog_free_unused_jited_linfo()"
into the new "bpf_prog_jit_attempt_done()".
It is a prep work for the kernel function call support.  In a later
patch, freeing the kernel function call descriptors will also
be done in the "bpf_prog_jit_attempt_done()".

"bpf_prog_free_linfo()" is removed since it is only called by
"__bpf_prog_put_noref()".  The kvfree() are directly called
instead.

It also takes this chance to s/kcalloc/kvcalloc/ for the jited_linfo
allocation.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/filter.h |  3 +--
 kernel/bpf/core.c      | 35 ++++++++++++-----------------------
 kernel/bpf/syscall.c   |  3 ++-
 kernel/bpf/verifier.c  |  4 ++--
 4 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index b2b85b2cad8e..0d9c710eb050 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -877,8 +877,7 @@ void bpf_prog_free_linfo(struct bpf_prog *prog);
 void bpf_prog_fill_jited_linfo(struct bpf_prog *prog,
 			       const u32 *insn_to_jit_off);
 int bpf_prog_alloc_jited_linfo(struct bpf_prog *prog);
-void bpf_prog_free_jited_linfo(struct bpf_prog *prog);
-void bpf_prog_free_unused_jited_linfo(struct bpf_prog *prog);
+void bpf_prog_jit_attempt_done(struct bpf_prog *prog);
=20
 struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags=
);
 struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_ex=
tra_flags);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 3a283bf97f2f..4a6dd327446b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -143,25 +143,22 @@ int bpf_prog_alloc_jited_linfo(struct bpf_prog *pro=
g)
 	if (!prog->aux->nr_linfo || !prog->jit_requested)
 		return 0;
=20
-	prog->aux->jited_linfo =3D kcalloc(prog->aux->nr_linfo,
-					 sizeof(*prog->aux->jited_linfo),
-					 GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
+	prog->aux->jited_linfo =3D kvcalloc(prog->aux->nr_linfo,
+					  sizeof(*prog->aux->jited_linfo),
+					  GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (!prog->aux->jited_linfo)
 		return -ENOMEM;
=20
 	return 0;
 }
=20
-void bpf_prog_free_jited_linfo(struct bpf_prog *prog)
+void bpf_prog_jit_attempt_done(struct bpf_prog *prog)
 {
-	kfree(prog->aux->jited_linfo);
-	prog->aux->jited_linfo =3D NULL;
-}
-
-void bpf_prog_free_unused_jited_linfo(struct bpf_prog *prog)
-{
-	if (prog->aux->jited_linfo && !prog->aux->jited_linfo[0])
-		bpf_prog_free_jited_linfo(prog);
+	if (prog->aux->jited_linfo &&
+	    (!prog->jited || !prog->aux->jited_linfo[0])) {
+		kvfree(prog->aux->jited_linfo);
+		prog->aux->jited_linfo =3D NULL;
+	}
 }
=20
 /* The jit engine is responsible to provide an array
@@ -217,12 +214,6 @@ void bpf_prog_fill_jited_linfo(struct bpf_prog *prog=
,
 			insn_to_jit_off[linfo[i].insn_off - insn_start - 1];
 }
=20
-void bpf_prog_free_linfo(struct bpf_prog *prog)
-{
-	bpf_prog_free_jited_linfo(prog);
-	kvfree(prog->aux->linfo);
-}
-
 struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int =
size,
 				  gfp_t gfp_extra_flags)
 {
@@ -1866,15 +1857,13 @@ struct bpf_prog *bpf_prog_select_runtime(struct b=
pf_prog *fp, int *err)
 			return fp;
=20
 		fp =3D bpf_int_jit_compile(fp);
-		if (!fp->jited) {
-			bpf_prog_free_jited_linfo(fp);
+		bpf_prog_jit_attempt_done(fp);
 #ifdef CONFIG_BPF_JIT_ALWAYS_ON
+		if (!fp->jited) {
 			*err =3D -ENOTSUPP;
 			return fp;
-#endif
-		} else {
-			bpf_prog_free_unused_jited_linfo(fp);
 		}
+#endif
 	} else {
 		*err =3D bpf_prog_offload_compile(fp);
 		if (*err)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c859bc46d06c..78a653e25df0 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1689,7 +1689,8 @@ static void __bpf_prog_put_noref(struct bpf_prog *p=
rog, bool deferred)
 {
 	bpf_prog_kallsyms_del_all(prog);
 	btf_put(prog->aux->btf);
-	bpf_prog_free_linfo(prog);
+	kvfree(prog->aux->jited_linfo);
+	kvfree(prog->aux->linfo);
 	if (prog->aux->attach_btf)
 		btf_put(prog->aux->attach_btf);
=20
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f9096b049cd6..0647454a0c8e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11742,7 +11742,7 @@ static int jit_subprogs(struct bpf_verifier_env *=
env)
 	prog->bpf_func =3D func[0]->bpf_func;
 	prog->aux->func =3D func;
 	prog->aux->func_cnt =3D env->subprog_cnt;
-	bpf_prog_free_unused_jited_linfo(prog);
+	bpf_prog_jit_attempt_done(prog);
 	return 0;
 out_free:
 	for (i =3D 0; i < env->subprog_cnt; i++) {
@@ -11765,7 +11765,7 @@ static int jit_subprogs(struct bpf_verifier_env *=
env)
 		insn->off =3D 0;
 		insn->imm =3D env->insn_aux_data[i].call_imm;
 	}
-	bpf_prog_free_jited_linfo(prog);
+	bpf_prog_jit_attempt_done(prog);
 	return err;
 }
=20
--=20
2.30.2

