Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169F422A8C2
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgGWGQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:16:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63630 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726649AbgGWGPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:15:41 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06N69n1O020018
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 23:15:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ER3+aEAZ+WGbdNGCFkmP7iOgMt3PHmLwbfOJINHbeOA=;
 b=XuFv3PV7diiEZ2rgBlScaZmBZG5EmJyiQOUW3QJ5JGE/m88U23ZOULfsjdyzQQxRrZ6L
 BnnLfNxzCyRz8zOePW++AsPN975LhbNZ+tHYLw/mpb5mQqjQSKDHEnRxP+UHHUHV4zho
 Vv71dgtTD+8O4AXM8ujf5brK0D0yj4xYax4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32et5ktrtj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 23:15:39 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 23:15:38 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 60B0A3705266; Wed, 22 Jul 2020 23:15:36 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 03/13] bpf: support readonly/readwrite buffers in verifier
Date:   Wed, 22 Jul 2020 23:15:36 -0700
Message-ID: <20200723061536.2100082-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200723061533.2099842-1-yhs@fb.com>
References: <20200723061533.2099842-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_02:2020-07-22,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 phishscore=0 adultscore=0 priorityscore=1501
 suspectscore=8 malwarescore=0 bulkscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 mlxlogscore=964 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007230050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Readonly and readwrite buffer register states
are introduced. Totally four states,
PTR_TO_RDONLY_BUF[_OR_NULL] and PTR_TO_RDWR_BUF[_OR_NULL]
are supported. As suggested by their respective
names, PTR_TO_RDONLY_BUF[_OR_NULL] are for
readonly buffers and PTR_TO_RDWR_BUF[_OR_NULL]
for read/write buffers.

These new register states will be used
by later bpf map element iterator.

New register states share some similarity to
PTR_TO_TP_BUFFER as it will calculate accessed buffer
size during verification time. The accessed buffer
size will be later compared to other metrics during
later attach/link_create time.

Similar to reg_state PTR_TO_BTF_ID_OR_NULL in bpf
iterator programs, PTR_TO_RDONLY_BUF_OR_NULL or
PTR_TO_RDWR_BUF_OR_NULL reg_types can be set at
prog->aux->bpf_ctx_arg_aux, and bpf verifier will
retrieve the values during btf_ctx_access().
Later bpf map element iterator implementation
will show how such information will be assigned
during target registeration time.

The verifier is also enhanced such that PTR_TO_RDONLY_BUF
can be passed to ARG_PTR_TO_MEM[_OR_NULL] helper argument, and
PTR_TO_RDWR_BUF can be passed to ARG_PTR_TO_MEM[_OR_NULL] or
ARG_PTR_TO_UNINIT_MEM.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   |  6 +++
 kernel/bpf/btf.c      | 13 +++++++
 kernel/bpf/verifier.c | 91 ++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 104 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ef52717336cf..f9c4bb08f616 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -353,6 +353,10 @@ enum bpf_reg_type {
 	PTR_TO_BTF_ID_OR_NULL,	 /* reg points to kernel struct or NULL */
 	PTR_TO_MEM,		 /* reg points to valid memory region */
 	PTR_TO_MEM_OR_NULL,	 /* reg points to valid memory region or NULL */
+	PTR_TO_RDONLY_BUF,	 /* reg points to a readonly buffer */
+	PTR_TO_RDONLY_BUF_OR_NULL, /* reg points to a readonly buffer or NULL *=
/
+	PTR_TO_RDWR_BUF,	 /* reg points to a read/write buffer */
+	PTR_TO_RDWR_BUF_OR_NULL, /* reg points to a read/write buffer or NULL *=
/
 };
=20
 /* The information passed from prog-specific *_is_valid_access
@@ -694,6 +698,8 @@ struct bpf_prog_aux {
 	u32 func_idx; /* 0 for non-func prog, the index in func array for func =
prog */
 	u32 attach_btf_id; /* in-kernel BTF type id to attach to */
 	u32 ctx_arg_info_size;
+	u32 max_rdonly_access;
+	u32 max_rdwr_access;
 	const struct bpf_ctx_arg_aux *ctx_arg_info;
 	struct bpf_prog *linked_prog;
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. *=
/
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ee36b7f60936..0fd6bb62be3a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3806,6 +3806,19 @@ bool btf_ctx_access(int off, int size, enum bpf_ac=
cess_type type,
 			btf_kind_str[BTF_INFO_KIND(t->info)]);
 		return false;
 	}
+
+	/* check for PTR_TO_RDONLY_BUF_OR_NULL or PTR_TO_RDWR_BUF_OR_NULL */
+	for (i =3D 0; i < prog->aux->ctx_arg_info_size; i++) {
+		const struct bpf_ctx_arg_aux *ctx_arg_info =3D &prog->aux->ctx_arg_inf=
o[i];
+
+		if (ctx_arg_info->offset =3D=3D off &&
+		    (ctx_arg_info->reg_type =3D=3D PTR_TO_RDONLY_BUF_OR_NULL ||
+		     ctx_arg_info->reg_type =3D=3D PTR_TO_RDWR_BUF_OR_NULL)) {
+			info->reg_type =3D ctx_arg_info->reg_type;
+			return true;
+		}
+	}
+
 	if (t->type =3D=3D 0)
 		/* This is a pointer to void.
 		 * It is the same as scalar from the verifier safety pov.
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9a6703bc3f36..8d6979db48d8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -409,7 +409,9 @@ static bool reg_type_may_be_null(enum bpf_reg_type ty=
pe)
 	       type =3D=3D PTR_TO_SOCK_COMMON_OR_NULL ||
 	       type =3D=3D PTR_TO_TCP_SOCK_OR_NULL ||
 	       type =3D=3D PTR_TO_BTF_ID_OR_NULL ||
-	       type =3D=3D PTR_TO_MEM_OR_NULL;
+	       type =3D=3D PTR_TO_MEM_OR_NULL ||
+	       type =3D=3D PTR_TO_RDONLY_BUF_OR_NULL ||
+	       type =3D=3D PTR_TO_RDWR_BUF_OR_NULL;
 }
=20
 static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
@@ -503,6 +505,10 @@ static const char * const reg_type_str[] =3D {
 	[PTR_TO_BTF_ID_OR_NULL]	=3D "ptr_or_null_",
 	[PTR_TO_MEM]		=3D "mem",
 	[PTR_TO_MEM_OR_NULL]	=3D "mem_or_null",
+	[PTR_TO_RDONLY_BUF]	=3D "rdonly_buf",
+	[PTR_TO_RDONLY_BUF_OR_NULL] =3D "rdonly_buf_or_null",
+	[PTR_TO_RDWR_BUF]	=3D "rdwr_buf",
+	[PTR_TO_RDWR_BUF_OR_NULL] =3D "rdwr_buf_or_null",
 };
=20
 static char slot_type_char[] =3D {
@@ -2173,6 +2179,10 @@ static bool is_spillable_regtype(enum bpf_reg_type=
 type)
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
 	case PTR_TO_BTF_ID_OR_NULL:
+	case PTR_TO_RDONLY_BUF:
+	case PTR_TO_RDONLY_BUF_OR_NULL:
+	case PTR_TO_RDWR_BUF:
+	case PTR_TO_RDWR_BUF_OR_NULL:
 		return true;
 	default:
 		return false;
@@ -3052,14 +3062,15 @@ int check_ctx_reg(struct bpf_verifier_env *env,
 	return 0;
 }
=20
-static int check_tp_buffer_access(struct bpf_verifier_env *env,
-				  const struct bpf_reg_state *reg,
-				  int regno, int off, int size)
+static int __check_buffer_access(struct bpf_verifier_env *env,
+				 const char *buf_info,
+				 const struct bpf_reg_state *reg,
+				 int regno, int off, int size)
 {
 	if (off < 0) {
 		verbose(env,
-			"R%d invalid tracepoint buffer access: off=3D%d, size=3D%d",
-			regno, off, size);
+			"R%d invalid %s buffer access: off=3D%d, size=3D%d",
+			regno, buf_info, off, size);
 		return -EACCES;
 	}
 	if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
@@ -3071,12 +3082,45 @@ static int check_tp_buffer_access(struct bpf_veri=
fier_env *env,
 			regno, off, tn_buf);
 		return -EACCES;
 	}
+
+	return 0;
+}
+
+static int check_tp_buffer_access(struct bpf_verifier_env *env,
+				  const struct bpf_reg_state *reg,
+				  int regno, int off, int size)
+{
+	int err;
+
+	err =3D __check_buffer_access(env, "tracepoint", reg, regno, off, size)=
;
+	if (err)
+		return err;
+
 	if (off + size > env->prog->aux->max_tp_access)
 		env->prog->aux->max_tp_access =3D off + size;
=20
 	return 0;
 }
=20
+static int check_buffer_access(struct bpf_verifier_env *env,
+			       const struct bpf_reg_state *reg,
+			       int regno, int off, int size,
+			       bool zero_size_allowed,
+			       const char *buf_info,
+			       u32 *max_access)
+{
+	int err;
+
+	err =3D __check_buffer_access(env, buf_info, reg, regno, off, size);
+	if (err)
+		return err;
+
+	if (off + size > *max_access)
+		*max_access =3D off + size;
+
+	return 0;
+}
+
 /* BPF architecture zero extends alu32 ops into 64-bit registesr */
 static void zext_32_to_64(struct bpf_reg_state *reg)
 {
@@ -3427,6 +3471,23 @@ static int check_mem_access(struct bpf_verifier_en=
v *env, int insn_idx, u32 regn
 	} else if (reg->type =3D=3D CONST_PTR_TO_MAP) {
 		err =3D check_ptr_to_map_access(env, regs, regno, off, size, t,
 					      value_regno);
+	} else if (reg->type =3D=3D PTR_TO_RDONLY_BUF) {
+		if (t =3D=3D BPF_WRITE) {
+			verbose(env, "R%d cannot write into %s\n",
+				regno, reg_type_str[reg->type]);
+			return -EACCES;
+		}
+		err =3D check_buffer_access(env, reg, regno, off, size, "rdonly",
+					  false,
+					  &env->prog->aux->max_rdonly_access);
+		if (!err && value_regno >=3D 0)
+			mark_reg_unknown(env, regs, value_regno);
+	} else if (reg->type =3D=3D PTR_TO_RDWR_BUF) {
+		err =3D check_buffer_access(env, reg, regno, off, size, "rdwr",
+					  false,
+					  &env->prog->aux->max_rdwr_access);
+		if (!err && t =3D=3D BPF_READ && value_regno >=3D 0)
+			mark_reg_unknown(env, regs, value_regno);
 	} else {
 		verbose(env, "R%d invalid mem access '%s'\n", regno,
 			reg_type_str[reg->type]);
@@ -3668,6 +3729,18 @@ static int check_helper_mem_access(struct bpf_veri=
fier_env *env, int regno,
 		return check_mem_region_access(env, regno, reg->off,
 					       access_size, reg->mem_size,
 					       zero_size_allowed);
+	case PTR_TO_RDONLY_BUF:
+		if (meta && meta->raw_mode)
+			return -EACCES;
+		return check_buffer_access(env, reg, regno, reg->off,
+					   access_size, zero_size_allowed,
+					   "rdonly",
+					   &env->prog->aux->max_rdonly_access);
+	case PTR_TO_RDWR_BUF:
+		return check_buffer_access(env, reg, regno, reg->off,
+					   access_size, zero_size_allowed,
+					   "rdwr",
+					   &env->prog->aux->max_rdwr_access);
 	default: /* scalar_value|ptr_to_stack or invalid ptr */
 		return check_stack_boundary(env, regno, access_size,
 					    zero_size_allowed, meta);
@@ -3933,6 +4006,8 @@ static int check_func_arg(struct bpf_verifier_env *=
env, u32 arg,
 		else if (!type_is_pkt_pointer(type) &&
 			 type !=3D PTR_TO_MAP_VALUE &&
 			 type !=3D PTR_TO_MEM &&
+			 type !=3D PTR_TO_RDONLY_BUF &&
+			 type !=3D PTR_TO_RDWR_BUF &&
 			 type !=3D expected_type)
 			goto err_type;
 		meta->raw_mode =3D arg_type =3D=3D ARG_PTR_TO_UNINIT_MEM;
@@ -6806,6 +6881,10 @@ static void mark_ptr_or_null_reg(struct bpf_func_s=
tate *state,
 			reg->type =3D PTR_TO_BTF_ID;
 		} else if (reg->type =3D=3D PTR_TO_MEM_OR_NULL) {
 			reg->type =3D PTR_TO_MEM;
+		} else if (reg->type =3D=3D PTR_TO_RDONLY_BUF_OR_NULL) {
+			reg->type =3D PTR_TO_RDONLY_BUF;
+		} else if (reg->type =3D=3D PTR_TO_RDWR_BUF_OR_NULL) {
+			reg->type =3D PTR_TO_RDWR_BUF;
 		}
 		if (is_null) {
 			/* We don't need id and ref_obj_id from this point
--=20
2.24.1

