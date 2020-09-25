Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD13277C9A
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgIYAEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:04:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27874 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726807AbgIYAEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:04:05 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P03Qsr012156
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=BgiMojMhFXloWdnXigmN42Pwpf5RcSPq0vx4UV8KFkU=;
 b=Ur/l8LkW1YHHGMrweslG5YnUhVHsvSiClHIjRdY4N4b4KSdPDnBbhtac8ZhC1A+mfpJW
 IzE5r/tG/Cbj1EAA3IulZpaLEDC1n9lXFjfP41ygk1X+mMl1AKq2a89nuFlwKq68o2W4
 u4uWL2Fc2CTjmOS80/KmVprCXoi571wFCQ8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp54t9n-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:03 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 17:03:51 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 56ACE2946606; Thu, 24 Sep 2020 17:03:50 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v4 bpf-next 02/13] bpf: Enable bpf_skc_to_* sock casting helper to networking prog type
Date:   Thu, 24 Sep 2020 17:03:50 -0700
Message-ID: <20200925000350.3855720-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200925000337.3853598-1-kafai@fb.com>
References: <20200925000337.3853598-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=1 bulkscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240174
X-FB-Internal: deliver
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

These helpers are also added to is_ptr_cast_function().
It ensures the returning reg (BPF_REF_0) will also carries the ref_obj_id=
.
That will keep the ref-tracking works properly.

The bpf_skc_to_* helpers are made available to most of the bpf prog
types in filter.c. The bpf_skc_to_* helpers will be limited by
perfmon cap.

This patch adds a ARG_PTR_TO_BTF_ID_SOCK_COMMON.  The helper accepting
this arg can accept a btf-id-ptr (PTR_TO_BTF_ID + &btf_sock_ids[BTF_SOCK_=
TYPE_SOCK_COMMON])
or a legacy-ctx-convert-skc-ptr (PTR_TO_SOCK_COMMON).  The bpf_skc_to_*()
helpers are changed to take ARG_PTR_TO_BTF_ID_SOCK_COMMON such that
they will accept pointer obtained from skb->sk.

Instead of specifying both arg_type and arg_btf_id in the same func_proto
which is how the current ARG_PTR_TO_BTF_ID does, the arg_btf_id of
the new ARG_PTR_TO_BTF_ID_SOCK_COMMON is specified in the
compatible_reg_types[] in verifier.c.  The reason is the arg_btf_id is
always the same.  Discussion in this thread:
https://lore.kernel.org/bpf/20200922070422.1917351-1-kafai@fb.com/

The ARG_PTR_TO_BTF_ID_ part gives a clear expectation that the helper is
expecting a PTR_TO_BTF_ID which could be NULL.  This is the same
behavior as the existing helper taking ARG_PTR_TO_BTF_ID.

The _SOCK_COMMON part means the helper is also expecting the legacy
SOCK_COMMON pointer.

By excluding the _OR_NULL part, the bpf prog cannot call helper
with a literal NULL which doesn't make sense in most cases.
e.g. bpf_skc_to_tcp_sock(NULL) will be rejected.  All PTR_TO_*_OR_NULL
reg has to do a NULL check first before passing into the helper or else
the bpf prog will be rejected.  This behavior is nothing new and
consistent with the current expectation during bpf-prog-load.

[ ARG_PTR_TO_BTF_ID_SOCK_COMMON will be used to replace
  ARG_PTR_TO_SOCK* of other existing helpers later such that
  those existing helpers can take the PTR_TO_BTF_ID returned by
  the bpf_skc_to_*() helpers.

  The only special case is bpf_sk_lookup_assign() which can accept a
  literal NULL ptr.  It has to be handled specially in another follow
  up patch if there is a need (e.g. by renaming ARG_PTR_TO_SOCKET_OR_NULL
  to ARG_PTR_TO_BTF_ID_SOCK_COMMON_OR_NULL). ]

[ When converting the older helpers that take ARG_PTR_TO_SOCK* in
  the later patch, if the kernel does not support BTF,
  ARG_PTR_TO_BTF_ID_SOCK_COMMON will behave like ARG_PTR_TO_SOCK_COMMON
  because no reg->type could have PTR_TO_BTF_ID in this case.

  It is not a concern for the newer-btf-only helper like the bpf_skc_to_*=
()
  here though because these helpers must require BTF vmlinux to begin
  with. ]

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h   |  1 +
 kernel/bpf/verifier.c | 34 +++++++++++++++++++--
 net/core/filter.c     | 69 ++++++++++++++++++++++++++++++-------------
 3 files changed, 82 insertions(+), 22 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fc5c901c7542..d0937f1d2980 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -292,6 +292,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
 	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memor=
y or NULL */
 	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
+	ARG_PTR_TO_BTF_ID_SOCK_COMMON,	/* pointer to in-kernel sock_common or b=
pf-mirrored bpf_sock */
 	__BPF_ARG_TYPE_MAX,
 };
=20
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 945fa2b4d096..d4ba29fb17a6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -486,7 +486,12 @@ static bool is_acquire_function(enum bpf_func_id fun=
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
@@ -3953,6 +3958,7 @@ static int resolve_map_arg_type(struct bpf_verifier=
_env *env,
=20
 struct bpf_reg_types {
 	const enum bpf_reg_type types[10];
+	u32 *btf_id;
 };
=20
 static const struct bpf_reg_types map_key_value_types =3D {
@@ -3973,6 +3979,17 @@ static const struct bpf_reg_types sock_types =3D {
 	},
 };
=20
+static const struct bpf_reg_types btf_id_sock_common_types =3D {
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
@@ -4014,6 +4031,7 @@ static const struct bpf_reg_types *compatible_reg_t=
ypes[__BPF_ARG_TYPE_MAX] =3D {
 	[ARG_PTR_TO_CTX]		=3D &context_types,
 	[ARG_PTR_TO_CTX_OR_NULL]	=3D &context_types,
 	[ARG_PTR_TO_SOCK_COMMON]	=3D &sock_types,
+	[ARG_PTR_TO_BTF_ID_SOCK_COMMON]	=3D &btf_id_sock_common_types,
 	[ARG_PTR_TO_SOCKET]		=3D &fullsock_types,
 	[ARG_PTR_TO_SOCKET_OR_NULL]	=3D &fullsock_types,
 	[ARG_PTR_TO_BTF_ID]		=3D &btf_ptr_types,
@@ -4059,6 +4077,14 @@ static int check_reg_type(struct bpf_verifier_env =
*env, u32 regno,
=20
 found:
 	if (type =3D=3D PTR_TO_BTF_ID) {
+		if (!arg_btf_id) {
+			if (!compatible->btf_id) {
+				verbose(env, "verifier internal error: missing arg compatible BTF ID=
\n");
+				return -EFAULT;
+			}
+			arg_btf_id =3D compatible->btf_id;
+		}
+
 		if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id,
 					  *arg_btf_id)) {
 			verbose(env, "R%d is of type %s but %s is expected\n",
@@ -4575,10 +4601,14 @@ static bool check_btf_id_ok(const struct bpf_func=
_proto *fn)
 {
 	int i;
=20
-	for (i =3D 0; i < ARRAY_SIZE(fn->arg_type); i++)
+	for (i =3D 0; i < ARRAY_SIZE(fn->arg_type); i++) {
 		if (fn->arg_type[i] =3D=3D ARG_PTR_TO_BTF_ID && !fn->arg_btf_id[i])
 			return false;
=20
+		if (fn->arg_type[i] !=3D ARG_PTR_TO_BTF_ID && fn->arg_btf_id[i])
+			return false;
+	}
+
 	return true;
 }
=20
diff --git a/net/core/filter.c b/net/core/filter.c
index 706f8db0ccf8..6d1864f2bd51 100644
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
@@ -6620,7 +6623,7 @@ sock_addr_func_proto(enum bpf_func_id func_id, cons=
t struct bpf_prog *prog)
 			return NULL;
 		}
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6639,7 +6642,7 @@ sk_filter_func_proto(enum bpf_func_id func_id, cons=
t struct bpf_prog *prog)
 	case BPF_FUNC_perf_event_output:
 		return &bpf_skb_event_output_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6800,7 +6803,7 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, con=
st struct bpf_prog *prog)
 		return &bpf_sk_assign_proto;
 #endif
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6841,7 +6844,7 @@ xdp_func_proto(enum bpf_func_id func_id, const stru=
ct bpf_prog *prog)
 		return &bpf_tcp_gen_syncookie_proto;
 #endif
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6883,7 +6886,7 @@ sock_ops_func_proto(enum bpf_func_id func_id, const=
 struct bpf_prog *prog)
 		return &bpf_tcp_sock_proto;
 #endif /* CONFIG_INET */
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6929,7 +6932,7 @@ sk_msg_func_proto(enum bpf_func_id func_id, const s=
truct bpf_prog *prog)
 		return &bpf_get_cgroup_classid_curr_proto;
 #endif
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6971,7 +6974,7 @@ sk_skb_func_proto(enum bpf_func_id func_id, const s=
truct bpf_prog *prog)
 		return &bpf_skc_lookup_tcp_proto;
 #endif
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -6982,7 +6985,7 @@ flow_dissector_func_proto(enum bpf_func_id func_id,=
 const struct bpf_prog *prog)
 	case BPF_FUNC_skb_load_bytes:
 		return &bpf_flow_dissector_load_bytes_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -7009,7 +7012,7 @@ lwt_out_func_proto(enum bpf_func_id func_id, const =
struct bpf_prog *prog)
 	case BPF_FUNC_skb_under_cgroup:
 		return &bpf_skb_under_cgroup_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -9746,7 +9749,7 @@ sk_lookup_func_proto(enum bpf_func_id func_id, cons=
t struct bpf_prog *prog)
 	case BPF_FUNC_sk_release:
 		return &bpf_sk_release_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_sk_base_func_proto(func_id);
 	}
 }
=20
@@ -9913,8 +9916,7 @@ const struct bpf_func_proto bpf_skc_to_tcp6_sock_pr=
oto =3D {
 	.func			=3D bpf_skc_to_tcp6_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
+	.arg1_type		=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP6],
 };
=20
@@ -9930,8 +9932,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_sock_pro=
to =3D {
 	.func			=3D bpf_skc_to_tcp_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
+	.arg1_type		=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP],
 };
=20
@@ -9954,8 +9955,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_timewait=
_sock_proto =3D {
 	.func			=3D bpf_skc_to_tcp_timewait_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
+	.arg1_type		=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP_TW],
 };
=20
@@ -9978,8 +9978,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_request_=
sock_proto =3D {
 	.func			=3D bpf_skc_to_tcp_request_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
+	.arg1_type		=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP_REQ],
 };
=20
@@ -10000,7 +9999,37 @@ const struct bpf_func_proto bpf_skc_to_udp6_sock_=
proto =3D {
 	.func			=3D bpf_skc_to_udp6_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
-	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
+	.arg1_type		=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_UDP6],
 };
+
+static const struct bpf_func_proto *
+bpf_sk_base_func_proto(enum bpf_func_id func_id)
+{
+	const struct bpf_func_proto *func;
+
+	switch (func_id) {
+	case BPF_FUNC_skc_to_tcp6_sock:
+		func =3D &bpf_skc_to_tcp6_sock_proto;
+		break;
+	case BPF_FUNC_skc_to_tcp_sock:
+		func =3D &bpf_skc_to_tcp_sock_proto;
+		break;
+	case BPF_FUNC_skc_to_tcp_timewait_sock:
+		func =3D &bpf_skc_to_tcp_timewait_sock_proto;
+		break;
+	case BPF_FUNC_skc_to_tcp_request_sock:
+		func =3D &bpf_skc_to_tcp_request_sock_proto;
+		break;
+	case BPF_FUNC_skc_to_udp6_sock:
+		func =3D &bpf_skc_to_udp6_sock_proto;
+		break;
+	default:
+		return bpf_base_func_proto(func_id);
+	}
+
+	if (!perfmon_capable())
+		return NULL;
+
+	return func;
+}
--=20
2.24.1

