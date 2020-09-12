Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBC62677ED
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 06:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgILE73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 00:59:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43432 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbgILE71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 00:59:27 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08C4ueHE007730
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 21:59:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=fheqKiKSzLxfLJpAXXvwthdErv0sCLql5EP5R2O04yU=;
 b=AF0Q2Co97a4bxbkcAx4D/embqIzpg92rR9qlqL2jEA3V8vt9P2P5ngOb7WpFCB11+0ej
 D5EM/LR78XMKQwd9AL9UXsShTcoEFCnJaVPgGmg6YBMWoklk5HsI/DzCB80PNkJDuXzb
 46db8rPJEIG23TZM4QETXKzvZdKHaJjidWs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33f8bfn65j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 21:59:27 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 11 Sep 2020 21:59:25 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 0EA772945F51; Fri, 11 Sep 2020 21:59:24 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH RFC bpf-next 1/2] bpf: Move the PTR_TO_BTF_ID check to check_reg_type()
Date:   Fri, 11 Sep 2020 21:59:24 -0700
Message-ID: <20200912045924.2992997-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200912045917.2992578-1-kafai@fb.com>
References: <20200912045917.2992578-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-12_01:2020-09-10,2020-09-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=13 clxscore=1015
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009120048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

check_reg_type() checks whether a reg can be used as an arg of a
func_proto.  For PTR_TO_BTF_ID, the check is actually not
completely done until the reg->btf_id is pointing to a
kernel struct that is acceptable by the func_proto.

Thus, this patch moves the btf_id check into check_reg_type().
The compatible_reg_types[] usage is localized in check_reg_type()
now which I found it easier to reason in the next patch.

The "if (!btf_id) verbose(...); " is removed for now since it won't
happen.  It will be added back in the next patch with new error log
specific to mis-configured compatible_reg_types[].

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/verifier.c | 65 +++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8fdef5656e7f..3a5932bd7c22 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3981,20 +3981,29 @@ static const struct bpf_reg_types *compatible_reg=
_types[] =3D {
 	[__BPF_ARG_TYPE_MAX]		=3D NULL,
 };
=20
-static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
-			  const struct bpf_reg_types *compatible)
+static int check_reg_type(struct bpf_verifier_env *env, u32 arg,
+			  enum bpf_arg_type arg_type,
+			  const struct bpf_func_proto *fn)
 {
+	u32 regno =3D BPF_REG_1 + arg;
 	struct bpf_reg_state *regs =3D cur_regs(env), *reg =3D &regs[regno];
 	enum bpf_reg_type expected, type =3D reg->type;
+	const struct bpf_reg_types *compatible;
 	int i, j;
=20
+	compatible =3D compatible_reg_types[arg_type];
+	if (!compatible) {
+		verbose(env, "verifier internal error: unsupported arg type %d\n", arg=
_type);
+		return -EFAULT;
+	}
+
 	for (i =3D 0; i < ARRAY_SIZE(compatible->types); i++) {
 		expected =3D compatible->types[i];
 		if (expected =3D=3D NOT_INIT)
 			break;
=20
 		if (type =3D=3D expected)
-			return 0;
+			goto found;
 	}
=20
 	verbose(env, "R%d type=3D%s expected=3D", regno, reg_type_str[type]);
@@ -4002,6 +4011,27 @@ static int check_reg_type(struct bpf_verifier_env =
*env, u32 regno,
 		verbose(env, "%s, ", reg_type_str[compatible->types[j]]);
 	verbose(env, "%s\n", reg_type_str[compatible->types[j]]);
 	return -EACCES;
+
+found:
+	if (type =3D=3D PTR_TO_BTF_ID) {
+		u32 *expected_btf_id =3D fn->arg_btf_id[arg];
+
+		if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id,
+					  *expected_btf_id)) {
+			verbose(env, "R%d is a pointer to in-kernel struct %s but %s is expec=
ted instead\n",
+				regno, kernel_type_name(reg->btf_id),
+				kernel_type_name(*expected_btf_id));
+			return -EACCES;
+		}
+
+		if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
+			verbose(env, "R%d is a pointer to in-kernel struct with non-zero offs=
et\n",
+				regno);
+			return -EACCES;
+		}
+	}
+
+	return 0;
 }
=20
 static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
@@ -4011,7 +4041,6 @@ static int check_func_arg(struct bpf_verifier_env *=
env, u32 arg,
 	u32 regno =3D BPF_REG_1 + arg;
 	struct bpf_reg_state *regs =3D cur_regs(env), *reg =3D &regs[regno];
 	enum bpf_arg_type arg_type =3D fn->arg_type[arg];
-	const struct bpf_reg_types *compatible;
 	enum bpf_reg_type type =3D reg->type;
 	int err =3D 0;
=20
@@ -4051,35 +4080,11 @@ static int check_func_arg(struct bpf_verifier_env=
 *env, u32 arg,
 		 */
 		goto skip_type_check;
=20
-	compatible =3D compatible_reg_types[arg_type];
-	if (!compatible) {
-		verbose(env, "verifier internal error: unsupported arg type %d\n", arg=
_type);
-		return -EFAULT;
-	}
-
-	err =3D check_reg_type(env, regno, compatible);
+	err =3D check_reg_type(env, arg, arg_type, fn);
 	if (err)
 		return err;
=20
-	if (type =3D=3D PTR_TO_BTF_ID) {
-		const u32 *btf_id =3D fn->arg_btf_id[arg];
-
-		if (!btf_id) {
-			verbose(env, "verifier internal error: missing BTF ID\n");
-			return -EFAULT;
-		}
-
-		if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id, *btf_id)) =
{
-			verbose(env, "R%d has incompatible type %s\n", regno,
-				kernel_type_name(reg->btf_id));
-			return -EACCES;
-		}
-		if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
-			verbose(env, "R%d is a pointer to in-kernel struct with non-zero offs=
et\n",
-				regno);
-			return -EACCES;
-		}
-	} else if (type =3D=3D PTR_TO_CTX) {
+	if (type =3D=3D PTR_TO_CTX) {
 		err =3D check_ctx_reg(env, reg, regno);
 		if (err < 0)
 			return err;
--=20
2.24.1

