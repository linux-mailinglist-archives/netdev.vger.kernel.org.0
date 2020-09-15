Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2848F26B43A
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgIOXTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:19:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20568 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727044AbgIOXTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 19:19:46 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FNJf9A026112
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 16:19:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=u/61+14Xz2eY0LUkVTrwXHYSEnULX6OCvJrykBMtI6c=;
 b=n9GDjDme1eB0Fdo99hZhK6fXP8Lhg8GsWdDWee4EKSCdoe+rY/K61KxuzY0LW3M5QIgy
 QEHvJbI8AlMiJuO4QaKjdcrA4q9WX4LeIT0fa1h5aRJUamAfxleLCIn+OK8/AlfVhr4e
 wmrIFc6buSFR6Y0DZmDIjPZqN0hoh+e60hE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33k5pegdw5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 16:19:42 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 16:19:11 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 084BD294612F; Tue, 15 Sep 2020 16:19:09 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH RFC v2 bpf-next 2/2] bpf: Enable bpf_skc_to_* sock casting helper to networking prog type
Date:   Tue, 15 Sep 2020 16:19:09 -0700
Message-ID: <20200915231909.1306930-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200915231857.1306320-1-kafai@fb.com>
References: <20200915231857.1306320-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_14:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=1 impostorscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 spamscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009150184
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a constant need to add more fields into the bpf_tcp_sock
for the bpf programs running at tc, sock_ops...etc.

A current workaround could be to use bpf_probe_read_kernel().  However,
other than making another helper call for reading each field and missing
CO-RE, it is also not as intuitive to use as directly reading
"tp->lsndtime" for example.  While already having perfmon cap to do
bpf_probe_read_kernel(), it will be much easier if the bpf prog can
directly read from the tcp_sock.

This patch tries to do that by using the existing casting-helpers
bpf_skc_to_*() whose func_proto returns a btf_id.  For example, the
func_proto of bpf_skc_to_tcp_sock returns the btf_id of the
kernel "struct tcp_sock".

This patch modifies the existing bpf_skc_to_* func_proto to take
ARG_PTR_TO_SOCK_COMMON_OR_NULL instead of taking
"ARG_PTR_TO_BTF_ID + &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON]".
That will allow tc, sock_ops,...etc to call these casting helpers
because they already hold the PTR_TO_SOCK_COMMON (or its
equivalent).  For example:

	sk =3D sock_ops->sk;
	if (!sk)
		return;
	tp =3D bpf_skc_to_tcp_sock(sk);
	if (!tp)
		return;
	/* Read tp as a PTR_TO_BTF_ID */
	lsndtime =3D tp->lsndtime;

To ensure the current bpf prog passing a PTR_TO_BTF_ID to
bpf_skc_to_*() still works as is, the verifier is modified such that
ARG_PTR_TO_SOCK_COMMON_OR_NULL can accept a reg with
reg->type =3D=3D PTR_TO_BTF_ID and reg->btf_id is
btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON]

To do that, an idea is borrowed from one of the Lorenz's patch:
https://lore.kernel.org/bpf/20200904112401.667645-12-lmb@cloudflare.com/ =
.
It adds PTR_TO_BTF_ID as one of the acceptable reg->type for
ARG_PTR_TO_SOCK_COMMON_OR_NULL and also specifies what btf_id it can take=
.
By doing this, the bpf_skc_to_* will work as before and can still
take PTR_TO_BTF_ID as the arg.  e.g. The bpf tcp iter will work
as is.

ARG_PTR_TO_SOCK_COMMON_OR_NULL is newly added.  The existing
helpers have to change to take this new arg type in order
to work with the PTR_TO_BTF_ID reg.  OR_NULL is needed because
PTR_TO_BTF_ID could be NULL.  For example,

	req_sk =3D bpf_skc_to_tcp_request_sock(sk);
	/* req_sk->sk is a PTR_TO_BTF_ID and it could be NULL */
	bpf_sk_cgroup_id(req_sk->sk);

[ Note:
  To handle PTR_TO_BTF_ID that could be NULL,
  one considered option is to introduce PTR_TO_BTF_ID_NOFAULT
  which will be used in the return value of the bpf_skc_to_*()
  helpers.  It is because the helper has verified the pointer can
  access the whole struct described by the btf_id and NULL check
  must have been done by the program.  However, the above req_sk->sk
  example will still have a PTR_TO_BTF_ID which may be NULL. ]

bpf_sk_release() is changed in this patch to take
ARG_PTR_TO_SOCK_COMMON_OR_NULL such that the following will work:

 	sk =3D bpf_skc_lookup_tcp(skb, tuple, tuplen, BPF_F_CURRENT_NETNS, 0);
	if (!sk)
		return;
	tp =3D bpf_skc_to_tcp_sock(sk);
	if (!tp) {
		bpf_sk_release(sk);
		return;
	}
	lsndtime =3D tp->lsndtime;
	/* Pass tp to bpf_sk_release() will also work */
	bpf_sk_release(tp);

Other helpers will be changed to take ARG_PTR_TO_SOCK_COMMONN_OR_NULL
later.

The BPF_FUNC_skc_to_* func_id is added to is_ptr_cast_function().
It ensures the returning reg (BPF_REF_0) which is a PTR_TO_BTF_ID_OR_NULL
also carries the ref_obj_id.  That will keep the ref-tracking works
properly.

The bpf_skc_to_* helpers are made available to most of the bpf prog
types in filter.c. They are limited by perfmon cap.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h   |  1 +
 kernel/bpf/verifier.c | 32 +++++++++++++++++--
 net/core/filter.c     | 73 ++++++++++++++++++++++++++++++-------------
 3 files changed, 82 insertions(+), 24 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7cf7e90f55bb..2e9baeaa6dae 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -284,6 +284,7 @@ enum bpf_arg_type {
 	ARG_ANYTHING,		/* any (initialized) argument is ok */
 	ARG_PTR_TO_SPIN_LOCK,	/* pointer to bpf_spin_lock */
 	ARG_PTR_TO_SOCK_COMMON,	/* pointer to sock_common */
+	ARG_PTR_TO_SOCK_COMMON_OR_NULL,	/* pointer to sock_common or NULL */
 	ARG_PTR_TO_INT,		/* pointer to int */
 	ARG_PTR_TO_LONG,	/* pointer to long */
 	ARG_PTR_TO_SOCKET,	/* pointer to bpf_sock (fullsock) */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3a5932bd7c22..a88841ed17a7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -432,7 +432,8 @@ static bool reg_type_may_be_refcounted_or_null(enum b=
pf_reg_type type)
=20
 static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
 {
-	return type =3D=3D ARG_PTR_TO_SOCK_COMMON;
+	return type =3D=3D ARG_PTR_TO_SOCK_COMMON ||
+		type =3D=3D ARG_PTR_TO_SOCK_COMMON_OR_NULL;
 }
=20
 static bool arg_type_may_be_null(enum bpf_arg_type type)
@@ -440,6 +441,7 @@ static bool arg_type_may_be_null(enum bpf_arg_type ty=
pe)
 	return type =3D=3D ARG_PTR_TO_MAP_VALUE_OR_NULL ||
 	       type =3D=3D ARG_PTR_TO_MEM_OR_NULL ||
 	       type =3D=3D ARG_PTR_TO_CTX_OR_NULL ||
+	       type =3D=3D ARG_PTR_TO_SOCK_COMMON_OR_NULL ||
 	       type =3D=3D ARG_PTR_TO_SOCKET_OR_NULL ||
 	       type =3D=3D ARG_PTR_TO_ALLOC_MEM_OR_NULL;
 }
@@ -486,7 +488,12 @@ static bool is_acquire_function(enum bpf_func_id fun=
c_id,
 static bool is_ptr_cast_function(enum bpf_func_id func_id)
 {
 	return func_id =3D=3D BPF_FUNC_tcp_sock ||
-		func_id =3D=3D BPF_FUNC_sk_fullsock;
+		func_id =3D=3D BPF_FUNC_sk_fullsock ||
+		func_id =3D=3D BPF_FUNC_skc_to_tcp_sock ||
+		func_id =3D=3D BPF_FUNC_skc_to_tcp6_sock ||
+		func_id =3D=3D BPF_FUNC_skc_to_udp6_sock ||
+		func_id =3D=3D BPF_FUNC_skc_to_tcp_timewait_sock ||
+		func_id =3D=3D BPF_FUNC_skc_to_tcp_request_sock;
 }
=20
 /* string representation of 'enum bpf_reg_type' */
@@ -3906,6 +3913,7 @@ static int resolve_map_arg_type(struct bpf_verifier=
_env *env,
=20
 struct bpf_reg_types {
 	const enum bpf_reg_type types[10];
+	u32 *btf_id;
 };
=20
 static const struct bpf_reg_types map_key_value_types =3D {
@@ -3926,6 +3934,17 @@ static const struct bpf_reg_types sock_types =3D {
 	},
 };
=20
+static const struct bpf_reg_types sock_or_null_types =3D {
+	.types =3D {
+		PTR_TO_SOCK_COMMON,
+		PTR_TO_SOCKET,
+		PTR_TO_TCP_SOCK,
+		PTR_TO_XDP_SOCK,
+		PTR_TO_BTF_ID,
+	},
+	.btf_id =3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
+};
+
 static const struct bpf_reg_types mem_types =3D {
 	.types =3D {
 		PTR_TO_STACK,
@@ -3967,6 +3986,7 @@ static const struct bpf_reg_types *compatible_reg_t=
ypes[] =3D {
 	[ARG_PTR_TO_CTX]		=3D &context_types,
 	[ARG_PTR_TO_CTX_OR_NULL]	=3D &context_types,
 	[ARG_PTR_TO_SOCK_COMMON]	=3D &sock_types,
+	[ARG_PTR_TO_SOCK_COMMON_OR_NULL]=3D &sock_or_null_types,
 	[ARG_PTR_TO_SOCKET]		=3D &fullsock_types,
 	[ARG_PTR_TO_SOCKET_OR_NULL]	=3D &fullsock_types,
 	[ARG_PTR_TO_BTF_ID]		=3D &btf_ptr_types,
@@ -4016,6 +4036,14 @@ static int check_reg_type(struct bpf_verifier_env =
*env, u32 arg,
 	if (type =3D=3D PTR_TO_BTF_ID) {
 		u32 *expected_btf_id =3D fn->arg_btf_id[arg];
=20
+		if (!expected_btf_id) {
+			if (!compatible->btf_id) {
+				 verbose(env, "verifier internal error: missing arg compatible BTF I=
D\n");
+				 return -EFAULT;
+			}
+			expected_btf_id =3D compatible->btf_id;
+		}
+
 		if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id,
 					  *expected_btf_id)) {
 			verbose(env, "R%d is a pointer to in-kernel struct %s but %s is expec=
ted instead\n",
diff --git a/net/core/filter.c b/net/core/filter.c
index 9683466c19e8..0b56f49df939 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -77,6 +77,9 @@
 #include <net/transp_v6.h>
 #include <linux/btf_ids.h>
=20
+static const struct bpf_func_proto *
+bpf_sk_base_func_proto(enum bpf_func_id func_id);
+
 int copy_bpf_fprog_from_user(struct sock_fprog *dst, sockptr_t src, int =
len)
 {
 	if (in_compat_syscall()) {
@@ -5693,7 +5696,7 @@ static const struct bpf_func_proto bpf_sk_lookup_ud=
p_proto =3D {
=20
 BPF_CALL_1(bpf_sk_release, struct sock *, sk)
 {
-	if (sk_is_refcounted(sk))
+	if (sk && sk_is_refcounted(sk))
 		sock_gen_put(sk);
 	return 0;
 }
@@ -5702,7 +5705,7 @@ static const struct bpf_func_proto bpf_sk_release_p=
roto =3D {
 	.func		=3D bpf_sk_release,
 	.gpl_only	=3D false,
 	.ret_type	=3D RET_INTEGER,
-	.arg1_type	=3D ARG_PTR_TO_SOCK_COMMON,
+	.arg1_type	=3D ARG_PTR_TO_SOCK_COMMON_OR_NULL,
 };
=20
 BPF_CALL_5(bpf_xdp_sk_lookup_udp, struct xdp_buff *, ctx,
@@ -6619,7 +6622,7 @@ sock_addr_func_proto(enum bpf_func_id func_id, cons=
t struct bpf_prog *prog)
 			return NULL;
 		}
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6638,7 +6641,7 @@ sk_filter_func_proto(enum bpf_func_id func_id, cons=
t struct bpf_prog *prog)
 	case BPF_FUNC_perf_event_output:
 		return &bpf_skb_event_output_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6799,7 +6802,7 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, con=
st struct bpf_prog *prog)
 		return &bpf_sk_assign_proto;
 #endif
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6840,7 +6843,7 @@ xdp_func_proto(enum bpf_func_id func_id, const stru=
ct bpf_prog *prog)
 		return &bpf_tcp_gen_syncookie_proto;
 #endif
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6882,7 +6885,7 @@ sock_ops_func_proto(enum bpf_func_id func_id, const=
 struct bpf_prog *prog)
 		return &bpf_tcp_sock_proto;
 #endif /* CONFIG_INET */
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6928,7 +6931,7 @@ sk_msg_func_proto(enum bpf_func_id func_id, const s=
truct bpf_prog *prog)
 		return &bpf_get_cgroup_classid_curr_proto;
 #endif
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6970,7 +6973,7 @@ sk_skb_func_proto(enum bpf_func_id func_id, const s=
truct bpf_prog *prog)
 		return &bpf_skc_lookup_tcp_proto;
 #endif
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6981,7 +6984,7 @@ flow_dissector_func_proto(enum bpf_func_id func_id,=
 const struct bpf_prog *prog)
 	case BPF_FUNC_skb_load_bytes:
 		return &bpf_flow_dissector_load_bytes_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -7008,7 +7011,7 @@ lwt_out_func_proto(enum bpf_func_id func_id, const =
struct bpf_prog *prog)
 	case BPF_FUNC_skb_under_cgroup:
 		return &bpf_skb_under_cgroup_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -9745,7 +9748,7 @@ sk_lookup_func_proto(enum bpf_func_id func_id, cons=
t struct bpf_prog *prog)
 	case BPF_FUNC_sk_release:
 		return &bpf_sk_release_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -9912,8 +9915,7 @@ const struct bpf_func_proto bpf_skc_to_tcp6_sock_pr=
oto =3D {
 	.func			=3D bpf_skc_to_tcp6_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
+	.arg1_type		=3D ARG_PTR_TO_SOCK_COMMON_OR_NULL,
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP6],
 };
=20
@@ -9929,8 +9931,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_sock_pro=
to =3D {
 	.func			=3D bpf_skc_to_tcp_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
+	.arg1_type		=3D ARG_PTR_TO_SOCK_COMMON_OR_NULL,
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP],
 };
=20
@@ -9953,8 +9954,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_timewait=
_sock_proto =3D {
 	.func			=3D bpf_skc_to_tcp_timewait_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
+	.arg1_type		=3D ARG_PTR_TO_SOCK_COMMON_OR_NULL,
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP_TW],
 };
=20
@@ -9977,8 +9977,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_request_=
sock_proto =3D {
 	.func			=3D bpf_skc_to_tcp_request_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
+	.arg1_type		=3D ARG_PTR_TO_SOCK_COMMON_OR_NULL,
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP_REQ],
 };
=20
@@ -9999,7 +9998,37 @@ const struct bpf_func_proto bpf_skc_to_udp6_sock_p=
roto =3D {
 	.func			=3D bpf_skc_to_udp6_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
+	.arg1_type		=3D ARG_PTR_TO_SOCK_COMMON_OR_NULL,
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_UDP6],
 };
+
+static const struct bpf_func_proto *
+bpf_sk_base_func_proto(enum bpf_func_id func_id)
+{
+       const struct bpf_func_proto *func;
+
+       switch (func_id) {
+       case BPF_FUNC_skc_to_tcp6_sock:
+	       func =3D &bpf_skc_to_tcp6_sock_proto;
+	       break;
+       case BPF_FUNC_skc_to_tcp_sock:
+	       func =3D &bpf_skc_to_tcp_sock_proto;
+	       break;
+       case BPF_FUNC_skc_to_tcp_timewait_sock:
+	       func =3D &bpf_skc_to_tcp_timewait_sock_proto;
+	       break;
+       case BPF_FUNC_skc_to_tcp_request_sock:
+	       func =3D &bpf_skc_to_tcp_request_sock_proto;
+	       break;
+       case BPF_FUNC_skc_to_udp6_sock:
+	       func =3D &bpf_skc_to_udp6_sock_proto;
+	       break;
+       default:
+	       return bpf_base_func_proto(func_id);
+       }
+
+       if (!perfmon_capable())
+	       return NULL;
+
+       return func;
+}
--=20
2.24.1

