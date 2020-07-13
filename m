Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93C321DB78
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgGMQRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:17:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730190AbgGMQRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:17:50 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06DGFl9c020531
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:17:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=R3e1vilAyBP9xKORneDXNUD69wbKezTPAabVLSmv4YM=;
 b=jg8hKF4GLDU7AVLEf4nN4xXLSIVBLH6fpRmlvSI3F5BotBdyZpf0Nug5UBgJK5Hbqjjz
 zupkFMm+yb2O1tU2EwvCil9I3aH7d3Iv3cEx4uagS3O8tFGNCKHCPW03PZhAaGBvxxNZ
 bopE4f7QNCGseSb1FihJkC678ljBSTtF0/M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3278x08syd-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:17:48 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 13 Jul 2020 09:17:47 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 826153701B4A; Mon, 13 Jul 2020 09:17:42 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 03/13] bpf: support readonly buffer in verifier
Date:   Mon, 13 Jul 2020 09:17:42 -0700
Message-ID: <20200713161742.3076597-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200713161739.3076283-1-yhs@fb.com>
References: <20200713161739.3076283-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_15:2020-07-13,2020-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501
 mlxscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two new readonly buffer PTR_TO_RDONLY_BUF or
PTR_TO_RDONLY_BUF_OR_NULL register states
are introduced. These new register states will be used
by later bpf map element iterator.

New register states share some similarity to
PTR_TO_TP_BUFFER as it will calculate accessed buffer
size during verification time. The accessed buffer
size will be later compared to other metrics during
later attach/link_create time.

Two differences between PTR_TO_TP_BUFFER and
PTR_TO_RDONLY_BUF[_OR_NULL].
PTR_TO_TP_BUFFER is for write only
and PTR_TO_RDONLY_BUF[_OR_NULL] is for read only.
In addition, a rdonly_buf_seq_id is also added to the
register state since it is possible for the same program
there could be two PTR_TO_RDONLY_BUF[_OR_NULL] ctx arguments.
For example, for bpf later map element iterator,
both key and value may be PTR_TO_TP_BUFFER_OR_NULL.

Similar to reg_state PTR_TO_BTF_ID_OR_NULL in bpf
iterator programs, PTR_TO_RDONLY_BUF_OR_NULL reg_type and
its rdonly_buf_seq_id can be set at
prog->aux->bpf_ctx_arg_aux, and bpf verifier will
retrieve the values during btf_ctx_access().
Later bpf map element iterator implementation
will show how such information will be assigned
during target registeration time.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h          |  7 ++++
 include/linux/bpf_verifier.h |  2 +
 kernel/bpf/btf.c             | 13 +++++++
 kernel/bpf/verifier.c        | 74 +++++++++++++++++++++++++++++++-----
 4 files changed, 87 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 97c6e2605978..8f708d51733b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -352,6 +352,8 @@ enum bpf_reg_type {
 	PTR_TO_BTF_ID_OR_NULL,	 /* reg points to kernel struct or NULL */
 	PTR_TO_MEM,		 /* reg points to valid memory region */
 	PTR_TO_MEM_OR_NULL,	 /* reg points to valid memory region or NULL */
+	PTR_TO_RDONLY_BUF,	 /* reg points to a readonly buffer */
+	PTR_TO_RDONLY_BUF_OR_NULL, /* reg points to a readonly buffer or NULL *=
/
 };
=20
 /* The information passed from prog-specific *_is_valid_access
@@ -362,6 +364,7 @@ struct bpf_insn_access_aux {
 	union {
 		int ctx_field_size;
 		u32 btf_id;
+		u32 rdonly_buf_seq_id;
 	};
 	struct bpf_verifier_log *log; /* for verbose logs */
 };
@@ -678,8 +681,11 @@ struct bpf_jit_poke_descriptor {
 struct bpf_ctx_arg_aux {
 	u32 offset;
 	enum bpf_reg_type reg_type;
+	u32 rdonly_buf_seq_id;
 };
=20
+#define BPF_MAX_RDONLY_BUF	2
+
 struct bpf_prog_aux {
 	atomic64_t refcnt;
 	u32 used_map_cnt;
@@ -693,6 +699,7 @@ struct bpf_prog_aux {
 	u32 attach_btf_id; /* in-kernel BTF type id to attach to */
 	u32 ctx_arg_info_size;
 	const struct bpf_ctx_arg_aux *ctx_arg_info;
+	u32 max_rdonly_access[BPF_MAX_RDONLY_BUF];
 	struct bpf_prog *linked_prog;
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. *=
/
 	bool offload_requested;
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 53c7bd568c5d..063e4ab2dd77 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -56,6 +56,8 @@ struct bpf_reg_state {
=20
 		u32 mem_size; /* for PTR_TO_MEM | PTR_TO_MEM_OR_NULL */
=20
+		u32 rdonly_buf_seq_id; /* for PTR_TO_RDONLY_BUF */
+
 		/* Max size from any of the above. */
 		unsigned long raw;
 	};
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 4c3007f428b1..895de2b21385 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3809,6 +3809,19 @@ bool btf_ctx_access(int off, int size, enum bpf_ac=
cess_type type,
 			btf_kind_str[BTF_INFO_KIND(t->info)]);
 		return false;
 	}
+
+	/* check for PTR_TO_RDONLY_BUF_OR_NULL */
+	for (i =3D 0; i < prog->aux->ctx_arg_info_size; i++) {
+		const struct bpf_ctx_arg_aux *ctx_arg_info =3D &prog->aux->ctx_arg_inf=
o[i];
+
+		if (ctx_arg_info->offset =3D=3D off &&
+		    ctx_arg_info->reg_type =3D=3D PTR_TO_RDONLY_BUF_OR_NULL) {
+			info->reg_type =3D ctx_arg_info->reg_type;
+			info->rdonly_buf_seq_id =3D ctx_arg_info->rdonly_buf_seq_id;
+			return true;
+		}
+	}
+
 	if (t->type =3D=3D 0)
 		/* This is a pointer to void.
 		 * It is the same as scalar from the verifier safety pov.
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b608185e1ffd..87801afa26fc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -410,7 +410,8 @@ static bool reg_type_may_be_null(enum bpf_reg_type ty=
pe)
 	       type =3D=3D PTR_TO_SOCK_COMMON_OR_NULL ||
 	       type =3D=3D PTR_TO_TCP_SOCK_OR_NULL ||
 	       type =3D=3D PTR_TO_BTF_ID_OR_NULL ||
-	       type =3D=3D PTR_TO_MEM_OR_NULL;
+	       type =3D=3D PTR_TO_MEM_OR_NULL ||
+	       type =3D=3D PTR_TO_RDONLY_BUF_OR_NULL;
 }
=20
 static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
@@ -504,6 +505,8 @@ static const char * const reg_type_str[] =3D {
 	[PTR_TO_BTF_ID_OR_NULL]	=3D "ptr_or_null_",
 	[PTR_TO_MEM]		=3D "mem",
 	[PTR_TO_MEM_OR_NULL]	=3D "mem_or_null",
+	[PTR_TO_RDONLY_BUF]	=3D "rdonly_buf",
+	[PTR_TO_RDONLY_BUF_OR_NULL] =3D "rdonly_buf_or_null",
 };
=20
 static char slot_type_char[] =3D {
@@ -579,6 +582,9 @@ static void print_verifier_state(struct bpf_verifier_=
env *env,
 				verbose(env, ",ks=3D%d,vs=3D%d",
 					reg->map_ptr->key_size,
 					reg->map_ptr->value_size);
+			else if (t =3D=3D PTR_TO_RDONLY_BUF ||
+				 t =3D=3D PTR_TO_RDONLY_BUF_OR_NULL)
+				verbose(env, ",seq_id=3D%u", reg->rdonly_buf_seq_id);
 			if (tnum_is_const(reg->var_off)) {
 				/* Typically an immediate SCALAR_VALUE, but
 				 * could be a pointer whose offset is too big
@@ -2174,6 +2180,8 @@ static bool is_spillable_regtype(enum bpf_reg_type =
type)
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
 	case PTR_TO_BTF_ID_OR_NULL:
+	case PTR_TO_RDONLY_BUF:
+	case PTR_TO_RDONLY_BUF_OR_NULL:
 		return true;
 	default:
 		return false;
@@ -2699,7 +2707,7 @@ static int check_packet_access(struct bpf_verifier_=
env *env, u32 regno, int off,
 /* check access to 'struct bpf_context' fields.  Supports fixed offsets =
only */
 static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, =
int off, int size,
 			    enum bpf_access_type t, enum bpf_reg_type *reg_type,
-			    u32 *btf_id)
+			    u32 *btf_id, u32 *rdonly_buf_seq_id)
 {
 	struct bpf_insn_access_aux info =3D {
 		.reg_type =3D *reg_type,
@@ -2719,6 +2727,8 @@ static int check_ctx_access(struct bpf_verifier_env=
 *env, int insn_idx, int off,
=20
 		if (*reg_type =3D=3D PTR_TO_BTF_ID || *reg_type =3D=3D PTR_TO_BTF_ID_O=
R_NULL)
 			*btf_id =3D info.btf_id;
+		else if (*reg_type =3D=3D PTR_TO_RDONLY_BUF_OR_NULL)
+			*rdonly_buf_seq_id =3D info.rdonly_buf_seq_id;
 		else
 			env->insn_aux_data[insn_idx].ctx_field_size =3D info.ctx_field_size;
 		/* remember the offset of last byte accessed in ctx */
@@ -3053,14 +3063,15 @@ int check_ctx_reg(struct bpf_verifier_env *env,
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
@@ -3072,12 +3083,43 @@ static int check_tp_buffer_access(struct bpf_veri=
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
+static int check_rdonly_buf_access(struct bpf_verifier_env *env,
+				   const struct bpf_reg_state *reg,
+				   int regno, int off, int size)
+{
+	u32 seq_id =3D reg->rdonly_buf_seq_id;
+	int err;
+
+	err =3D __check_buffer_access(env, "readonly", reg, regno, off, size);
+	if (err)
+		return err;
+
+	if (off + size > env->prog->aux->max_rdonly_access[seq_id])
+		env->prog->aux->max_rdonly_access[seq_id] =3D off + size;
+
+	return 0;
+}
+
 /* BPF architecture zero extends alu32 ops into 64-bit registesr */
 static void zext_32_to_64(struct bpf_reg_state *reg)
 {
@@ -3327,7 +3369,7 @@ static int check_mem_access(struct bpf_verifier_env=
 *env, int insn_idx, u32 regn
 			mark_reg_unknown(env, regs, value_regno);
 	} else if (reg->type =3D=3D PTR_TO_CTX) {
 		enum bpf_reg_type reg_type =3D SCALAR_VALUE;
-		u32 btf_id =3D 0;
+		u32 btf_id =3D 0, rdonly_buf_seq_id =3D 0;
=20
 		if (t =3D=3D BPF_WRITE && value_regno >=3D 0 &&
 		    is_pointer_value(env, value_regno)) {
@@ -3339,7 +3381,8 @@ static int check_mem_access(struct bpf_verifier_env=
 *env, int insn_idx, u32 regn
 		if (err < 0)
 			return err;
=20
-		err =3D check_ctx_access(env, insn_idx, off, size, t, &reg_type, &btf_=
id);
+		err =3D check_ctx_access(env, insn_idx, off, size, t, &reg_type, &btf_=
id,
+				       &rdonly_buf_seq_id);
 		if (err)
 			verbose_linfo(env, insn_idx, "; ");
 		if (!err && t =3D=3D BPF_READ && value_regno >=3D 0) {
@@ -3363,6 +3406,8 @@ static int check_mem_access(struct bpf_verifier_env=
 *env, int insn_idx, u32 regn
 				if (reg_type =3D=3D PTR_TO_BTF_ID ||
 				    reg_type =3D=3D PTR_TO_BTF_ID_OR_NULL)
 					regs[value_regno].btf_id =3D btf_id;
+				else if (reg_type =3D=3D PTR_TO_RDONLY_BUF_OR_NULL)
+					regs[value_regno].rdonly_buf_seq_id =3D rdonly_buf_seq_id;
 			}
 			regs[value_regno].type =3D reg_type;
 		}
@@ -3428,6 +3473,15 @@ static int check_mem_access(struct bpf_verifier_en=
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
+		err =3D check_rdonly_buf_access(env, reg, regno, off, size);
+		if (!err && value_regno >=3D 0)
+			mark_reg_unknown(env, regs, value_regno);
 	} else {
 		verbose(env, "R%d invalid mem access '%s'\n", regno,
 			reg_type_str[reg->type]);
@@ -6803,6 +6857,8 @@ static void mark_ptr_or_null_reg(struct bpf_func_st=
ate *state,
 			reg->type =3D PTR_TO_BTF_ID;
 		} else if (reg->type =3D=3D PTR_TO_MEM_OR_NULL) {
 			reg->type =3D PTR_TO_MEM;
+		} else if (reg->type =3D=3D PTR_TO_RDONLY_BUF_OR_NULL) {
+			reg->type =3D PTR_TO_RDONLY_BUF;
 		}
 		if (is_null) {
 			/* We don't need id and ref_obj_id from this point
--=20
2.24.1

