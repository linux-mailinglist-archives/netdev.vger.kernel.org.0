Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FBD1C81B9
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 07:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgEGFjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 01:39:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40914 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727032AbgEGFjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 01:39:48 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0475djSM007940
        for <netdev@vger.kernel.org>; Wed, 6 May 2020 22:39:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=NRBFSlaOIXV8Srgd1YextbQTQ0AyV95Ep+FzbYiK9hs=;
 b=Jz9h6Y7/yUCtIwsQgtdTZeojkp+rqd5bh41GcsqT+pLHlSBV6Et6aIgQpsAFzt6qQ914
 Azk8UdbDuLenowAfxkbD9BeSAJv1qcCIAepJ2VZeS2ijXI08cndHJ0OjRh+wRByYUiar
 LG3ffZfDhD6f8NCbCrjXP0tJb6w+tJO3CvQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30v0hp3gww-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 22:39:47 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 22:39:32 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 417033701B99; Wed,  6 May 2020 22:39:29 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 12/21] bpf: add PTR_TO_BTF_ID_OR_NULL support
Date:   Wed, 6 May 2020 22:39:29 -0700
Message-ID: <20200507053929.1543800-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200507053915.1542140-1-yhs@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_02:2020-05-05,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_reg_type PTR_TO_BTF_ID_OR_NULL support.
For tracing/iter program, the bpf program context
definition, e.g., for previous bpf_map target, looks like
  struct bpf_iter__bpf_map {
    struct bpf_iter_meta *meta;
    struct bpf_map *map;
  };

The kernel guarantees that meta is not NULL, but
map pointer maybe NULL. The NULL map indicates that all
objects have been traversed, so bpf program can take
proper action, e.g., do final aggregation and/or send
final report to user space.

Add btf_id_or_null_non0_off to prog->aux structure, to
indicate that if the context access offset is not 0,
set to PTR_TO_BTF_ID_OR_NULL instead of PTR_TO_BTF_ID.
This bit is set for tracing/iter program.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   |  2 ++
 kernel/bpf/btf.c      |  5 ++++-
 kernel/bpf/verifier.c | 16 ++++++++++++----
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 363ab0751967..cf4b6e44f2bc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -320,6 +320,7 @@ enum bpf_reg_type {
 	PTR_TO_TP_BUFFER,	 /* reg points to a writable raw tp's buffer */
 	PTR_TO_XDP_SOCK,	 /* reg points to struct xdp_sock */
 	PTR_TO_BTF_ID,		 /* reg points to kernel struct */
+	PTR_TO_BTF_ID_OR_NULL,	 /* reg points to kernel struct or NULL */
 };
=20
 /* The information passed from prog-specific *_is_valid_access
@@ -658,6 +659,7 @@ struct bpf_prog_aux {
 	bool offload_requested;
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
 	bool func_proto_unreliable;
+	bool btf_id_or_null_non0_off;
 	enum bpf_tramp_prog_type trampoline_prog_type;
 	struct bpf_trampoline *trampoline;
 	struct hlist_node tramp_hlist;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index a2cfba89a8e1..c490fbde22d4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3790,7 +3790,10 @@ bool btf_ctx_access(int off, int size, enum bpf_ac=
cess_type type,
 		return true;
=20
 	/* this is a pointer to another type */
-	info->reg_type =3D PTR_TO_BTF_ID;
+	if (off !=3D 0 && prog->aux->btf_id_or_null_non0_off)
+		info->reg_type =3D PTR_TO_BTF_ID_OR_NULL;
+	else
+		info->reg_type =3D PTR_TO_BTF_ID;
=20
 	if (tgt_prog) {
 		ret =3D btf_translate_to_vmlinux(log, btf, t, tgt_prog->type, arg);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d725ff7d11db..36b2a38a06fe 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -398,7 +398,8 @@ static bool reg_type_may_be_null(enum bpf_reg_type ty=
pe)
 	return type =3D=3D PTR_TO_MAP_VALUE_OR_NULL ||
 	       type =3D=3D PTR_TO_SOCKET_OR_NULL ||
 	       type =3D=3D PTR_TO_SOCK_COMMON_OR_NULL ||
-	       type =3D=3D PTR_TO_TCP_SOCK_OR_NULL;
+	       type =3D=3D PTR_TO_TCP_SOCK_OR_NULL ||
+	       type =3D=3D PTR_TO_BTF_ID_OR_NULL;
 }
=20
 static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
@@ -483,6 +484,7 @@ static const char * const reg_type_str[] =3D {
 	[PTR_TO_TP_BUFFER]	=3D "tp_buffer",
 	[PTR_TO_XDP_SOCK]	=3D "xdp_sock",
 	[PTR_TO_BTF_ID]		=3D "ptr_",
+	[PTR_TO_BTF_ID_OR_NULL]	=3D "ptr_or_null_",
 };
=20
 static char slot_type_char[] =3D {
@@ -543,7 +545,7 @@ static void print_verifier_state(struct bpf_verifier_=
env *env,
 			/* reg->off should be 0 for SCALAR_VALUE */
 			verbose(env, "%lld", reg->var_off.value + reg->off);
 		} else {
-			if (t =3D=3D PTR_TO_BTF_ID)
+			if (t =3D=3D PTR_TO_BTF_ID || t =3D=3D PTR_TO_BTF_ID_OR_NULL)
 				verbose(env, "%s", kernel_type_name(reg->btf_id));
 			verbose(env, "(id=3D%d", reg->id);
 			if (reg_type_may_be_refcounted_or_null(t))
@@ -2139,6 +2141,7 @@ static bool is_spillable_regtype(enum bpf_reg_type =
type)
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
+	case PTR_TO_BTF_ID_OR_NULL:
 		return true;
 	default:
 		return false;
@@ -2659,7 +2662,7 @@ static int check_ctx_access(struct bpf_verifier_env=
 *env, int insn_idx, int off,
 		 */
 		*reg_type =3D info.reg_type;
=20
-		if (*reg_type =3D=3D PTR_TO_BTF_ID)
+		if (*reg_type =3D=3D PTR_TO_BTF_ID || *reg_type =3D=3D PTR_TO_BTF_ID_O=
R_NULL)
 			*btf_id =3D info.btf_id;
 		else
 			env->insn_aux_data[insn_idx].ctx_field_size =3D info.ctx_field_size;
@@ -3243,7 +3246,8 @@ static int check_mem_access(struct bpf_verifier_env=
 *env, int insn_idx, u32 regn
 				 * a sub-register.
 				 */
 				regs[value_regno].subreg_def =3D DEF_NOT_SUBREG;
-				if (reg_type =3D=3D PTR_TO_BTF_ID)
+				if (reg_type =3D=3D PTR_TO_BTF_ID ||
+				    reg_type =3D=3D PTR_TO_BTF_ID_OR_NULL)
 					regs[value_regno].btf_id =3D btf_id;
 			}
 			regs[value_regno].type =3D reg_type;
@@ -6572,6 +6576,8 @@ static void mark_ptr_or_null_reg(struct bpf_func_st=
ate *state,
 			reg->type =3D PTR_TO_SOCK_COMMON;
 		} else if (reg->type =3D=3D PTR_TO_TCP_SOCK_OR_NULL) {
 			reg->type =3D PTR_TO_TCP_SOCK;
+		} else if (reg->type =3D=3D PTR_TO_BTF_ID_OR_NULL) {
+			reg->type =3D PTR_TO_BTF_ID;
 		}
 		if (is_null) {
 			/* We don't need id and ref_obj_id from this point
@@ -8429,6 +8435,7 @@ static bool reg_type_mismatch_ok(enum bpf_reg_type =
type)
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
+	case PTR_TO_BTF_ID_OR_NULL:
 		return false;
 	default:
 		return true;
@@ -10640,6 +10647,7 @@ static int check_attach_btf_id(struct bpf_verifie=
r_env *env)
 		prog->aux->attach_func_proto =3D t;
 		if (!bpf_iter_prog_supported(prog))
 			return -EINVAL;
+		prog->aux->btf_id_or_null_non0_off =3D true;
 		ret =3D btf_distill_func_proto(&env->log, btf, t,
 					     tname, &fmodel);
 		return ret;
--=20
2.24.1

