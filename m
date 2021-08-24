Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6629A3F6797
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239934AbhHXRgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:36:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25784 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241850AbhHXRa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 13:30:59 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17OHU10Q001203
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 10:30:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=2/7YEoOaFLaNT1hOty6dyIlZiLaKsNSIpD0Ys8xvk1o=;
 b=kY8gzOCnKgS4E/ve4YawkL0mLOZw2tO3+VLBnH4YCjPtXMuWPpueH1ydeXM6O9+5q4aR
 cDX3SYZhbBmnvzbVlc4S1FcGn/pgMvUhJ2XGdJwLYjW3NZ3403ub0ZMDfhJdGVeOW09b
 oFp2fo4Z17fpwZGYdCe3MGPUrNUSwXpFRTY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3amfqt7t7n-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 10:30:14 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 24 Aug 2021 10:30:09 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 3FF0E2940D05; Tue, 24 Aug 2021 10:30:07 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 1/4] bpf: tcp: Allow bpf-tcp-cc to call bpf_(get|set)sockopt
Date:   Tue, 24 Aug 2021 10:30:07 -0700
Message-ID: <20210824173007.3976921-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824173000.3976470-1-kafai@fb.com>
References: <20210824173000.3976470-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: NQm0ap2-_mOz6o2-6wjXLmWTPAnRUvnr
X-Proofpoint-ORIG-GUID: NQm0ap2-_mOz6o2-6wjXLmWTPAnRUvnr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-24_05:2021-08-24,2021-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108240115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows the bpf-tcp-cc to call bpf_setsockopt.  One use
case is to allow a bpf-tcp-cc switching to another cc during init().
For example, when the tcp flow is not ecn ready, the bpf_dctcp
can switch to another cc by calling setsockopt(TCP_CONGESTION).

During setsockopt(TCP_CONGESTION), the new tcp-cc's init() will be
called and this could cause a recursion but it is stopped by the
current trampoline's logic (in the prog->active counter).

While retiring a bpf-tcp-cc (e.g. in tcp_v[46]_destroy_sock()),
the tcp stack calls bpf-tcp-cc's release().  To avoid the retiring
bpf-tcp-cc making further changes to the sk, bpf_setsockopt is not
available to the bpf-tcp-cc's release().  This will avoid release()
making setsockopt() call that will potentially allocate new resources.

Although the bpf-tcp-cc already has a more powerful way to read tcp_sock
from the PTR_TO_BTF_ID, it is usually expected that bpf_getsockopt and
bpf_setsockopt are available together.  Thus, bpf_getsockopt() is also
added to all tcp_congestion_ops except release().

When the old bpf-tcp-cc is calling setsockopt(TCP_CONGESTION)
to switch to a new cc, the old bpf-tcp-cc will be released by
bpf_struct_ops_put().  Thus, this patch also puts the bpf_struct_ops_map
after a rcu grace period because the trampoline's image cannot be freed
while the old bpf-tcp-cc is still running.

bpf-tcp-cc can only access icsk_ca_priv as SCALAR.  All kernel's
tcp-cc is also accessing the icsk_ca_priv as SCALAR.   The size
of icsk_ca_priv has already been raised a few times to avoid
extra kmalloc and memory referencing.  The only exception is the
kernel's tcp_cdg.c that stores a kmalloc()-ed pointer in icsk_ca_priv.
To avoid the old bpf-tcp-cc accidentally overriding this tcp_cdg's pointe=
r
value stored in icsk_ca_priv after switching and without over-complicatin=
g
the bpf's verifier for this one exception in tcp_cdg, this patch does not
allow switching to tcp_cdg.  If there is a need, bpf_tcp_cdg can be
implemented and then use the bpf_sk_storage as the extended storage.

bpf_sk_setsockopt proto has only been recently added and used
in bpf-sockopt and bpf-iter-tcp, so impose the tcp_cdg limitation in the
same proto instead of adding a new proto specifically for bpf-tcp-cc.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/bpf_struct_ops.c | 22 +++++++++++++++++++-
 net/core/filter.c           |  6 ++++++
 net/ipv4/bpf_tcp_ca.c       | 41 ++++++++++++++++++++++++++++++++++---
 3 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 70f6fd4fa305..d6731c32864e 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -28,6 +28,7 @@ struct bpf_struct_ops_value {
=20
 struct bpf_struct_ops_map {
 	struct bpf_map map;
+	struct rcu_head rcu;
 	const struct bpf_struct_ops *st_ops;
 	/* protect map_update */
 	struct mutex lock;
@@ -622,6 +623,14 @@ bool bpf_struct_ops_get(const void *kdata)
 	return refcount_inc_not_zero(&kvalue->refcnt);
 }
=20
+static void bpf_struct_ops_put_rcu(struct rcu_head *head)
+{
+	struct bpf_struct_ops_map *st_map;
+
+	st_map =3D container_of(head, struct bpf_struct_ops_map, rcu);
+	bpf_map_put(&st_map->map);
+}
+
 void bpf_struct_ops_put(const void *kdata)
 {
 	struct bpf_struct_ops_value *kvalue;
@@ -632,6 +641,17 @@ void bpf_struct_ops_put(const void *kdata)
=20
 		st_map =3D container_of(kvalue, struct bpf_struct_ops_map,
 				      kvalue);
-		bpf_map_put(&st_map->map);
+		/* The struct_ops's function may switch to another struct_ops.
+		 *
+		 * For example, bpf_tcp_cc_x->init() may switch to
+		 * another tcp_cc_y by calling
+		 * setsockopt(TCP_CONGESTION, "tcp_cc_y").
+		 * During the switch,  bpf_struct_ops_put(tcp_cc_x) is called
+		 * and its map->refcnt may reach 0 which then free its
+		 * trampoline image while tcp_cc_x is still running.
+		 *
+		 * Thus, a rcu grace period is needed here.
+		 */
+		call_rcu(&st_map->rcu, bpf_struct_ops_put_rcu);
 	}
 }
diff --git a/net/core/filter.c b/net/core/filter.c
index 59b8f5050180..a863fd6d9b9b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5039,6 +5039,12 @@ static int _bpf_getsockopt(struct sock *sk, int le=
vel, int optname,
 BPF_CALL_5(bpf_sk_setsockopt, struct sock *, sk, int, level,
 	   int, optname, char *, optval, int, optlen)
 {
+	if (level =3D=3D SOL_TCP && optname =3D=3D TCP_CONGESTION) {
+		if (optlen >=3D sizeof("cdg") - 1 &&
+		    !strncmp("cdg", optval, optlen))
+			return -ENOTSUPP;
+	}
+
 	return _bpf_setsockopt(sk, level, optname, optval, optlen);
 }
=20
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 9e41eff4a685..0dcee9df1326 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -10,6 +10,9 @@
 #include <net/tcp.h>
 #include <net/bpf_sk_storage.h>
=20
+/* "extern" is to avoid sparse warning.  It is only used in bpf_struct_o=
ps.c. */
+extern struct bpf_struct_ops bpf_tcp_congestion_ops;
+
 static u32 optional_ops[] =3D {
 	offsetof(struct tcp_congestion_ops, init),
 	offsetof(struct tcp_congestion_ops, release),
@@ -163,6 +166,19 @@ static const struct bpf_func_proto bpf_tcp_send_ack_=
proto =3D {
 	.arg2_type	=3D ARG_ANYTHING,
 };
=20
+static u32 prog_ops_moff(const struct bpf_prog *prog)
+{
+	const struct btf_member *m;
+	const struct btf_type *t;
+	u32 midx;
+
+	midx =3D prog->expected_attach_type;
+	t =3D bpf_tcp_congestion_ops.type;
+	m =3D &btf_type_member(t)[midx];
+
+	return btf_member_bit_offset(t, m) / 8;
+}
+
 static const struct bpf_func_proto *
 bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
 			  const struct bpf_prog *prog)
@@ -174,6 +190,28 @@ bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
 		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
+	case BPF_FUNC_setsockopt:
+		/* Does not allow release() to call setsockopt.
+		 * release() is called when the current bpf-tcp-cc
+		 * is retiring.  It is not allowed to call
+		 * setsockopt() to make further changes which
+		 * may potentially allocate new resources.
+		 */
+		if (prog_ops_moff(prog) !=3D
+		    offsetof(struct tcp_congestion_ops, release))
+			return &bpf_sk_setsockopt_proto;
+		return NULL;
+	case BPF_FUNC_getsockopt:
+		/* Since get/setsockopt is usually expected to
+		 * be available together, disable getsockopt for
+		 * release also to avoid usage surprise.
+		 * The bpf-tcp-cc already has a more powerful way
+		 * to read tcp_sock from the PTR_TO_BTF_ID.
+		 */
+		if (prog_ops_moff(prog) !=3D
+		    offsetof(struct tcp_congestion_ops, release))
+			return &bpf_sk_getsockopt_proto;
+		return NULL;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -286,9 +324,6 @@ static void bpf_tcp_ca_unreg(void *kdata)
 	tcp_unregister_congestion_control(kdata);
 }
=20
-/* Avoid sparse warning.  It is only used in bpf_struct_ops.c. */
-extern struct bpf_struct_ops bpf_tcp_congestion_ops;
-
 struct bpf_struct_ops bpf_tcp_congestion_ops =3D {
 	.verifier_ops =3D &bpf_tcp_ca_verifier_ops,
 	.reg =3D bpf_tcp_ca_reg,
--=20
2.30.2

