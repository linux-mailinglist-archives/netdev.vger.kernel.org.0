Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C013B96F2
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhGAUKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:10:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35180 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232637AbhGAUKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 16:10:09 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 161JwkGw001234
        for <netdev@vger.kernel.org>; Thu, 1 Jul 2021 13:07:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Ap8YVgAcgu/KxsWY91n7EfLGNM9mcq/F/d875VaAW1Q=;
 b=dj4dTaL400B8uTC/nud9dNfW2Ur1kZdSkgcv1odjy53Kn1N9i0eWMgoczcV5Q+j+6uki
 OpqQoglFqlpIhTD+p5ukQag4nhq6y+QFdu9kOfmv2eRQ3rfEvX5tuTUXjgm/AjngjeU+
 icMOyd8n5oXgv8TTCR+6lwrvcrtJHvIrcEc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39h1wyxc2d-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 13:07:38 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 13:06:26 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 5B43D2940BCC; Thu,  1 Jul 2021 13:06:19 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH v2 bpf-next 7/8] bpf: tcp: Support bpf_(get|set)sockopt in bpf tcp iter
Date:   Thu, 1 Jul 2021 13:06:19 -0700
Message-ID: <20210701200619.1036715-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210701200535.1033513-1-kafai@fb.com>
References: <20210701200535.1033513-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Fx_p_3hec8WSef2sZp8tzmfV6TJC9RrF
X-Proofpoint-GUID: Fx_p_3hec8WSef2sZp8tzmfV6TJC9RrF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-01_12:2021-07-01,2021-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107010117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows bpf tcp iter to call bpf_(get|set)sockopt.
To allow a specific bpf iter (tcp here) to call a set of helpers,
get_func_proto function pointer is added to bpf_iter_reg.
The bpf iter is a tracing prog which currently requires
CAP_PERFMON  or CAP_SYS_ADMIN, so this patch does not
impose other capability checks for bpf_(get|set)sockopt.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h      |  8 ++++++++
 kernel/bpf/bpf_iter.c    | 22 ++++++++++++++++++++++
 kernel/trace/bpf_trace.c |  7 ++++++-
 net/core/filter.c        | 34 ++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c      | 15 +++++++++++++++
 5 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f309fc1509f2..b9a62b805a99 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1397,6 +1397,9 @@ typedef void (*bpf_iter_show_fdinfo_t) (const struc=
t bpf_iter_aux_info *aux,
 					struct seq_file *seq);
 typedef int (*bpf_iter_fill_link_info_t)(const struct bpf_iter_aux_info =
*aux,
 					 struct bpf_link_info *info);
+typedef const struct bpf_func_proto *
+(*bpf_iter_get_func_proto_t)(enum bpf_func_id func_id,
+			     const struct bpf_prog *prog);
=20
 enum bpf_iter_feature {
 	BPF_ITER_RESCHED	=3D BIT(0),
@@ -1409,6 +1412,7 @@ struct bpf_iter_reg {
 	bpf_iter_detach_target_t detach_target;
 	bpf_iter_show_fdinfo_t show_fdinfo;
 	bpf_iter_fill_link_info_t fill_link_info;
+	bpf_iter_get_func_proto_t get_func_proto;
 	u32 ctx_arg_info_size;
 	u32 feature;
 	struct bpf_ctx_arg_aux ctx_arg_info[BPF_ITER_CTX_ARG_MAX];
@@ -1431,6 +1435,8 @@ struct bpf_iter__bpf_map_elem {
 int bpf_iter_reg_target(const struct bpf_iter_reg *reg_info);
 void bpf_iter_unreg_target(const struct bpf_iter_reg *reg_info);
 bool bpf_iter_prog_supported(struct bpf_prog *prog);
+const struct bpf_func_proto *
+bpf_iter_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog =
*prog);
 int bpf_iter_link_attach(const union bpf_attr *attr, bpfptr_t uattr, str=
uct bpf_prog *prog);
 int bpf_iter_new_fd(struct bpf_link *link);
 bool bpf_link_is_iter(struct bpf_link *link);
@@ -1997,6 +2003,8 @@ extern const struct bpf_func_proto bpf_task_storage=
_get_proto;
 extern const struct bpf_func_proto bpf_task_storage_delete_proto;
 extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
 extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
+extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
+extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
=20
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 2d4fbdbb194e..2e9d47bb40ff 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -360,6 +360,28 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)
 	return supported;
 }
=20
+const struct bpf_func_proto *
+bpf_iter_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog =
*prog)
+{
+	const struct bpf_iter_target_info *tinfo;
+	const struct bpf_func_proto *fn =3D NULL;
+
+	mutex_lock(&targets_mutex);
+	list_for_each_entry(tinfo, &targets, list) {
+		if (tinfo->btf_id =3D=3D prog->aux->attach_btf_id) {
+			const struct bpf_iter_reg *reg_info;
+
+			reg_info =3D tinfo->reg_info;
+			if (reg_info->get_func_proto)
+				fn =3D reg_info->get_func_proto(func_id, prog);
+			break;
+		}
+	}
+	mutex_unlock(&targets_mutex);
+
+	return fn;
+}
+
 static void bpf_iter_link_release(struct bpf_link *link)
 {
 	struct bpf_iter_link *iter_link =3D
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 64bd2d84367f..a137494f2505 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1430,6 +1430,8 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, co=
nst struct bpf_prog *prog)
 const struct bpf_func_proto *
 tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog =
*prog)
 {
+	const struct bpf_func_proto *fn;
+
 	switch (func_id) {
 #ifdef CONFIG_NET
 	case BPF_FUNC_skb_output:
@@ -1470,7 +1472,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id, =
const struct bpf_prog *prog)
 	case BPF_FUNC_d_path:
 		return &bpf_d_path_proto;
 	default:
-		return raw_tp_prog_func_proto(func_id, prog);
+		fn =3D raw_tp_prog_func_proto(func_id, prog);
+		if (!fn && prog->expected_attach_type =3D=3D BPF_TRACE_ITER)
+			fn =3D bpf_iter_get_func_proto(func_id, prog);
+		return fn;
 	}
 }
=20
diff --git a/net/core/filter.c b/net/core/filter.c
index d70187ce851b..61f8121f205f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5012,6 +5012,40 @@ static int _bpf_getsockopt(struct sock *sk, int le=
vel, int optname,
 	return -EINVAL;
 }
=20
+BPF_CALL_5(bpf_sk_setsockopt, struct sock *, sk, int, level,
+	   int, optname, char *, optval, int, optlen)
+{
+	return _bpf_setsockopt(sk, level, optname, optval, optlen);
+}
+
+const struct bpf_func_proto bpf_sk_setsockopt_proto =3D {
+	.func		=3D bpf_sk_setsockopt,
+	.gpl_only	=3D false,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.arg2_type	=3D ARG_ANYTHING,
+	.arg3_type	=3D ARG_ANYTHING,
+	.arg4_type	=3D ARG_PTR_TO_MEM,
+	.arg5_type	=3D ARG_CONST_SIZE,
+};
+
+BPF_CALL_5(bpf_sk_getsockopt, struct sock *, sk, int, level,
+	   int, optname, char *, optval, int, optlen)
+{
+	return _bpf_getsockopt(sk, level, optname, optval, optlen);
+}
+
+const struct bpf_func_proto bpf_sk_getsockopt_proto =3D {
+	.func		=3D bpf_sk_getsockopt,
+	.gpl_only	=3D false,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.arg2_type	=3D ARG_ANYTHING,
+	.arg3_type	=3D ARG_ANYTHING,
+	.arg4_type	=3D ARG_PTR_TO_UNINIT_MEM,
+	.arg5_type	=3D ARG_CONST_SIZE,
+};
+
 BPF_CALL_5(bpf_sock_addr_setsockopt, struct bpf_sock_addr_kern *, ctx,
 	   int, level, int, optname, char *, optval, int, optlen)
 {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3e1afab26381..6ea47850e1fa 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3259,6 +3259,20 @@ static const struct bpf_iter_seq_info tcp_seq_info=
 =3D {
 	.seq_priv_size		=3D sizeof(struct bpf_tcp_iter_state),
 };
=20
+static const struct bpf_func_proto *
+bpf_iter_tcp_get_func_proto(enum bpf_func_id func_id,
+			    const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_setsockopt:
+		return &bpf_sk_setsockopt_proto;
+	case BPF_FUNC_getsockopt:
+		return &bpf_sk_getsockopt_proto;
+	default:
+		return NULL;
+	}
+}
+
 static struct bpf_iter_reg tcp_reg_info =3D {
 	.target			=3D "tcp",
 	.ctx_arg_info_size	=3D 1,
@@ -3266,6 +3280,7 @@ static struct bpf_iter_reg tcp_reg_info =3D {
 		{ offsetof(struct bpf_iter__tcp, sk_common),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
+	.get_func_proto		=3D bpf_iter_tcp_get_func_proto,
 	.seq_info		=3D &tcp_seq_info,
 };
=20
--=20
2.30.2

