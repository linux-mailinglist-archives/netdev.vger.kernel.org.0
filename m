Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF8F1AB1D3
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633828AbgDOTcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:32:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49934 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406837AbgDOT2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:05 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FJPWtk012507
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=JWAzTd+P58psYE7ONSEpWZ26DbHYU9vCEH/x2x6Kkzo=;
 b=HRK2ePCrQv6IA7TEeX8HI7GEN6x85FNDlOg5fsIR0qtjrOFUVTTWiNwwHmceerb4OfyU
 S8xYIcWuPxcPekZu4YdtehIf3dxUCIf1BFHOGuqKD8aSo/746SSBcvZmSlKkXif+K94U
 cZ8F6nCF5j1eTW1TqdkiU77AQzVeO/uVZY0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn82qtc1-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:04 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:27:49 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id F00173700AF5; Wed, 15 Apr 2020 12:27:46 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 06/17] bpf: add PTR_TO_BTF_ID_OR_NULL support
Date:   Wed, 15 Apr 2020 12:27:46 -0700
Message-ID: <20200415192746.4083161-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 impostorscore=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=962
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_reg_type PTR_TO_BTF_ID_OR_NULL support.
For tracing/dump program, the bpf program context
definition, e.g., for ipv6_route target, looks like
   struct bpfdump__ipv6_route {
     struct bpf_dump_meta *meta;
     struct fib6_info *rt;
   };

The kernel guarantees that meta is not NULL, but
rt maybe NULL. The NULL rt indicates the data structure
traversal has done. So bpf program can take proper action.

Add btf_id_or_null_non0_off to prog->aux structure, to
indicate that for tracing programs, if the context access
offset is not 0, set to PTR_TO_BTF_ID_OR_NULL instead of
PTR_TO_BTF_ID. This bit is set for tracing/dump program.
---
 include/linux/bpf.h   |  2 ++
 kernel/bpf/btf.c      |  5 ++++-
 kernel/bpf/dump.c     |  1 +
 kernel/bpf/verifier.c | 18 +++++++++++++-----
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3cc16991c287..1179ca3d0230 100644
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
index d65c6912bdaf..2c098e6b1acc 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3788,7 +3788,10 @@ bool btf_ctx_access(int off, int size, enum bpf_ac=
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
diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
index f39b82430977..c6d4d64aaa8e 100644
--- a/kernel/bpf/dump.c
+++ b/kernel/bpf/dump.c
@@ -244,6 +244,7 @@ int bpf_dump_set_target_info(u32 target_fd, struct bp=
f_prog *prog)
=20
 	prog->aux->dump_target =3D tinfo->target;
 	prog->aux->attach_btf_id =3D btf_id;
+	prog->aux->btf_id_or_null_non0_off =3D true;
=20
 done:
 	fdput(tfd);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f531cee24fc5..af711dd15e08 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -382,7 +382,8 @@ static bool reg_type_may_be_null(enum bpf_reg_type ty=
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
@@ -396,7 +397,8 @@ static bool reg_type_may_be_refcounted_or_null(enum b=
pf_reg_type type)
 	return type =3D=3D PTR_TO_SOCKET ||
 		type =3D=3D PTR_TO_SOCKET_OR_NULL ||
 		type =3D=3D PTR_TO_TCP_SOCK ||
-		type =3D=3D PTR_TO_TCP_SOCK_OR_NULL;
+		type =3D=3D PTR_TO_TCP_SOCK_OR_NULL ||
+		type =3D=3D PTR_TO_BTF_ID_OR_NULL;
 }
=20
 static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
@@ -448,6 +450,7 @@ static const char * const reg_type_str[] =3D {
 	[PTR_TO_TP_BUFFER]	=3D "tp_buffer",
 	[PTR_TO_XDP_SOCK]	=3D "xdp_sock",
 	[PTR_TO_BTF_ID]		=3D "ptr_",
+	[PTR_TO_BTF_ID_OR_NULL]	=3D "null_or_ptr_",
 };
=20
 static char slot_type_char[] =3D {
@@ -508,7 +511,7 @@ static void print_verifier_state(struct bpf_verifier_=
env *env,
 			/* reg->off should be 0 for SCALAR_VALUE */
 			verbose(env, "%lld", reg->var_off.value + reg->off);
 		} else {
-			if (t =3D=3D PTR_TO_BTF_ID)
+			if (t =3D=3D PTR_TO_BTF_ID || t =3D=3D PTR_TO_BTF_ID_OR_NULL)
 				verbose(env, "%s", kernel_type_name(reg->btf_id));
 			verbose(env, "(id=3D%d", reg->id);
 			if (reg_type_may_be_refcounted_or_null(t))
@@ -2102,6 +2105,7 @@ static bool is_spillable_regtype(enum bpf_reg_type =
type)
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
+	case PTR_TO_BTF_ID_OR_NULL:
 		return true;
 	default:
 		return false;
@@ -2603,7 +2607,7 @@ static int check_ctx_access(struct bpf_verifier_env=
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
@@ -3196,7 +3200,8 @@ static int check_mem_access(struct bpf_verifier_env=
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
@@ -6521,6 +6526,8 @@ static void mark_ptr_or_null_reg(struct bpf_func_st=
ate *state,
 			reg->type =3D PTR_TO_SOCK_COMMON;
 		} else if (reg->type =3D=3D PTR_TO_TCP_SOCK_OR_NULL) {
 			reg->type =3D PTR_TO_TCP_SOCK;
+		} else if (reg->type =3D=3D PTR_TO_BTF_ID_OR_NULL) {
+			reg->type =3D PTR_TO_BTF_ID;
 		}
 		if (is_null) {
 			/* We don't need id and ref_obj_id from this point
@@ -8374,6 +8381,7 @@ static bool reg_type_mismatch_ok(enum bpf_reg_type =
type)
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
+	case PTR_TO_BTF_ID_OR_NULL:
 		return false;
 	default:
 		return true;
--=20
2.24.1

