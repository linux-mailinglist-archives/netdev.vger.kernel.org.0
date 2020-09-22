Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BD1273C0C
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgIVHcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:32:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61324 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729894AbgIVHcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:32:45 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08M71MxS025767
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:04:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Dd/vVaiblO9snO9K19DZI9P7jxx+FmFizupXFsCsIQI=;
 b=k/2AW8Rt5lV9tu81cnAawWhwc12eRcFTHSzp6Rcz8wjhY91Jzv/q2GfZw116nu5oiBCc
 zP6lpdznwCvlcmvpHvIJ0ybynCCnc6RxGc0XE2k5oJ7m6QFoO5isRU6fiIdv5EmXZvFz
 QO4Os4s9ej9reh3uG5Q5xJozMOUlzHYbmeQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33p226hbq2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:04:28 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Sep 2020 00:04:26 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 24222294641C; Tue, 22 Sep 2020 00:04:22 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v3 bpf-next 02/11] bpf: Enable bpf_skc_to_* sock casting helper to networking prog type
Date:   Tue, 22 Sep 2020 00:04:22 -0700
Message-ID: <20200922070422.1917351-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200922070409.1914988-1-kafai@fb.com>
References: <20200922070409.1914988-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_05:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 suspectscore=13 spamscore=0 impostorscore=0 bulkscore=0 mlxlogscore=993
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220056
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
types in filter.c. They are limited by perfmon cap.

This patch adds a ARG_PTR_TO_BTF_ID_SOCK_COMMON.  The helper accepting
this arg can accept a btf-id-ptr (PTR_TO_BTF_ID + &btf_sock_ids[BTF_SOCK_=
TYPE_SOCK_COMMON])
or a legacy-ctx-convert-skc-ptr (PTR_TO_SOCK_COMMON).  The bpf_skc_to_*()
helpers are changed to take ARG_PTR_TO_BTF_ID_SOCK_COMMON such that
they will accept pointer obtained from skb->sk.

PTR_TO_*_OR_NULL is not accepted as an ARG_PTR_TO_BTF_ID_SOCK_COMMON
at verification time.  All PTR_TO_*_OR_NULL reg has to do a NULL check
first before passing into the helper or else the bpf prog will be
rejected by the verifier.

[ ARG_PTR_TO_SOCK_COMMON_OR_NULL was attempted earlier.  The _OR_NULL was
  needed because the PTR_TO_BTF_ID could be NULL but note that a could be=
 NULL
  PTR_TO_BTF_ID is not a scalar NULL to the verifier.  "_OR_NULL" implici=
tly
  gives an expectation that the helper can take a scalar NULL which does
  not make sense in most (except one) helpers.  Passing scalar NULL
  should be rejected at the verification time.

  Thus, this patch uses ARG_PTR_TO_BTF_ID_SOCK_COMMON to specify that the
  helper can take both the btf-id ptr or the legacy PTR_TO_SOCK_COMMON bu=
t
  not scalar NULL.  It requires the func_proto to explicitly specify the
  arg_btf_id such that there is a very clear expectation that the helper
  can handle a NULL PTR_TO_BTF_ID. ]

[ ARG_PTR_TO_BTF_ID_SOCK_COMMON will be used to replace
  ARG_PTR_TO_SOCK* of other existing helpers later such that
  those existing helpers can take the PTR_TO_BTF_ID returned by
  the bpf_skc_to_*() helpers.

  The only special case is bpf_sk_lookup_assign() which can accept a
  scalar NULL ptr.  It has to be handled specially in another follow
  up patch (e.g. by renaming ARG_PTR_TO_SOCKET_OR_NULL to
  ARG_PTR_TO_BTF_ID_SOCK_COMMON_OR_NULL). ]

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
 kernel/bpf/verifier.c | 28 ++++++++++++++++---
 net/core/filter.c     | 64 +++++++++++++++++++++++++++++++++----------
 3 files changed, 74 insertions(+), 19 deletions(-)

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
index 3ce61c412ea0..2468533bc4a1 100644
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
@@ -3973,6 +3978,16 @@ static const struct bpf_reg_types sock_types =3D {
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
+};
+
 static const struct bpf_reg_types mem_types =3D {
 	.types =3D {
 		PTR_TO_STACK,
@@ -4014,6 +4029,7 @@ static const struct bpf_reg_types *compatible_reg_t=
ypes[] =3D {
 	[ARG_PTR_TO_CTX]		=3D &context_types,
 	[ARG_PTR_TO_CTX_OR_NULL]	=3D &context_types,
 	[ARG_PTR_TO_SOCK_COMMON]	=3D &sock_types,
+	[ARG_PTR_TO_BTF_ID_SOCK_COMMON]	=3D &btf_id_sock_common_types,
 	[ARG_PTR_TO_SOCKET]		=3D &fullsock_types,
 	[ARG_PTR_TO_SOCKET_OR_NULL]	=3D &fullsock_types,
 	[ARG_PTR_TO_BTF_ID]		=3D &btf_ptr_types,
@@ -4579,9 +4595,13 @@ static bool check_btf_id_ok(const struct bpf_func_=
proto *fn)
 {
 	int i;
=20
-	for (i =3D 0; i < ARRAY_SIZE(fn->arg_type); i++)
-		if (fn->arg_type[i] =3D=3D ARG_PTR_TO_BTF_ID && !fn->arg_btf_id[i])
-			return false;
+	for (i =3D 0; i < ARRAY_SIZE(fn->arg_type); i++) {
+		if (fn->arg_type[i] =3D=3D ARG_PTR_TO_BTF_ID ||
+		    fn->arg_type[i] =3D=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON) {
+			if (!fn->arg_btf_id[i])
+				return false;
+		}
+	}
=20
 	return true;
 }
diff --git a/net/core/filter.c b/net/core/filter.c
index 6014e5f40c58..54b338de4bb8 100644
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
@@ -9912,7 +9915,7 @@ const struct bpf_func_proto bpf_skc_to_tcp6_sock_pr=
oto =3D {
 	.func			=3D bpf_skc_to_tcp6_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
+	.arg1_type		=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP6],
 };
@@ -9929,7 +9932,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_sock_pro=
to =3D {
 	.func			=3D bpf_skc_to_tcp_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
+	.arg1_type		=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP],
 };
@@ -9953,7 +9956,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_timewait=
_sock_proto =3D {
 	.func			=3D bpf_skc_to_tcp_timewait_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
+	.arg1_type		=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP_TW],
 };
@@ -9977,7 +9980,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_request_=
sock_proto =3D {
 	.func			=3D bpf_skc_to_tcp_request_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
+	.arg1_type		=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP_REQ],
 };
@@ -9999,7 +10002,38 @@ const struct bpf_func_proto bpf_skc_to_udp6_sock_=
proto =3D {
 	.func			=3D bpf_skc_to_udp6_sock,
 	.gpl_only		=3D false,
 	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
-	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
+	.arg1_type		=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
 	.arg1_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
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

