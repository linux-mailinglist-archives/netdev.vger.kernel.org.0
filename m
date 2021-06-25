Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AB83B49A5
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 22:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFYUIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 16:08:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13042 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229954AbhFYUIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 16:08:01 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PK5eBV023613
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:05:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=KzAP4i8LUIb74pSh25a6Kd1ypWtRJzZfK/iNf/FUH5Y=;
 b=MOHkeMPSmSdNhfVRFig0GLr9z2dRM9p4vQ1qK6M/cTxKxQBnp8MSan0Nw7eRi/zP1vdE
 qKjjuDLeqxyjSghpj+cGAdtYXPt7FyDcOKiHbD6IoC0W9/qS1MofuqY5QFJz3noa/tz5
 iRhNjtEZVD/pUGBxc/c6rOffz6jZhQjyBDU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39d24nxkua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:05:40 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 13:05:39 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 1540529422B0; Fri, 25 Jun 2021 13:05:30 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH bpf-next 7/8] bpf: tcp: Support bpf_setsockopt in bpf tcp iter
Date:   Fri, 25 Jun 2021 13:05:30 -0700
Message-ID: <20210625200530.727573-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210625200446.723230-1-kafai@fb.com>
References: <20210625200446.723230-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: oyctN2nEBuuIxdYUYeBNBQQzIAVD7xHB
X-Proofpoint-ORIG-GUID: oyctN2nEBuuIxdYUYeBNBQQzIAVD7xHB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_07:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 adultscore=0 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows bpf tcp iter with netadmin cap to call bpf_setsockopt.
To allow a specific bpf iter (tcp here) to call a set of helpers,
get_func_proto function pointer is added to bpf_iter_reg.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h      |  7 +++++++
 kernel/bpf/bpf_iter.c    | 22 ++++++++++++++++++++++
 kernel/trace/bpf_trace.c |  7 ++++++-
 net/core/filter.c        | 17 +++++++++++++++++
 net/ipv4/tcp_ipv4.c      | 15 +++++++++++++++
 5 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f309fc1509f2..31f51a601925 100644
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
@@ -1997,6 +2003,7 @@ extern const struct bpf_func_proto bpf_task_storage=
_get_proto;
 extern const struct bpf_func_proto bpf_task_storage_delete_proto;
 extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
 extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
+extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
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
index 7a52bc172841..11e69734d67b 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1428,6 +1428,8 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, co=
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
@@ -1468,7 +1470,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id, =
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
index d22895caa164..ab4d60c043d4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5063,6 +5063,23 @@ static const struct bpf_func_proto bpf_sock_ops_se=
tsockopt_proto =3D {
 	.arg5_type	=3D ARG_CONST_SIZE,
 };
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
 static int bpf_sock_ops_get_syn(struct bpf_sock_ops_kern *bpf_sock,
 				int optname, const u8 **start)
 {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 856144d33f52..5bfa6233fff1 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3258,6 +3258,20 @@ static const struct bpf_iter_seq_info tcp_seq_info=
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
+		if (capable(CAP_NET_ADMIN))
+			return &bpf_sk_setsockopt_proto;
+		fallthrough;
+	default:
+		return NULL;
+	}
+}
+
 static struct bpf_iter_reg tcp_reg_info =3D {
 	.target			=3D "tcp",
 	.ctx_arg_info_size	=3D 1,
@@ -3265,6 +3279,7 @@ static struct bpf_iter_reg tcp_reg_info =3D {
 		{ offsetof(struct bpf_iter__tcp, sk_common),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
+	.get_func_proto		=3D bpf_iter_tcp_get_func_proto,
 	.seq_info		=3D &tcp_seq_info,
 };
=20
--=20
2.30.2

