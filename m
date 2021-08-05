Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B8B3E0D77
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 07:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbhHEFBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 01:01:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60112 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233118AbhHEFBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 01:01:44 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 1754wetP013785
        for <netdev@vger.kernel.org>; Wed, 4 Aug 2021 22:01:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0hHWxpxmASPIZoJuxEIQLBjGFGjKT0LOrg7nMlimlTM=;
 b=jLolNYkCc3JPTK8qvaXy8oe5Rzoq2icw145tEx8J3b4OCpH3h7gxeZUk7enC49onoYR3
 jb13UBYskKVS88GB49jz62gPsSS8bT6Vlba3ElGcwHJfIBB+Wny0RVY1FskcM9QLqrRb
 WMzPod844NBBT0o4JIH5Be4rXGdauZpde58= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3a71mp5jjf-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 22:01:30 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 22:01:28 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id B3938294203D; Wed,  4 Aug 2021 22:01:25 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 1/4] bpf: tcp: Allow bpf-tcp-cc to call bpf_(get|set)sockopt
Date:   Wed, 4 Aug 2021 22:01:25 -0700
Message-ID: <20210805050125.1349441-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210805050119.1349009-1-kafai@fb.com>
References: <20210805050119.1349009-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: M00Z3CSQTnbEVBd6MsTz1-SXLSx0j-b5
X-Proofpoint-GUID: M00Z3CSQTnbEVBd6MsTz1-SXLSx0j-b5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_01:2021-08-04,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 adultscore=0
 malwarescore=0 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=852 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108050028
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

bpf_getsockopt() is also added to have a symmetrical API, so
less usage surprise.

When the old bpf-tcp-cc is calling setsockopt(TCP_CONGESTION)
to switch to a new cc, the old bpf-tcp-cc will be released by
bpf_struct_ops_put().  Thus, this patch also puts the bpf_struct_ops_map
after a rcu grace period because the trampoline's image cannot be freed
while the old bpf-tcp-cc is still running.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/bpf_struct_ops.c | 22 +++++++++++++++++++++-
 net/ipv4/bpf_tcp_ca.c       | 26 +++++++++++++++++++++++---
 2 files changed, 44 insertions(+), 4 deletions(-)

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
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 9e41eff4a685..00db0ce3af43 100644
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
@@ -167,6 +170,10 @@ static const struct bpf_func_proto *
 bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
 			  const struct bpf_prog *prog)
 {
+	const struct btf_member *m;
+	const struct btf_type *t;
+	u32 moff, midx;
+
 	switch (func_id) {
 	case BPF_FUNC_tcp_send_ack:
 		return &bpf_tcp_send_ack_proto;
@@ -174,6 +181,22 @@ bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
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
+		midx =3D prog->expected_attach_type;
+		t =3D bpf_tcp_congestion_ops.type;
+		m =3D &btf_type_member(t)[midx];
+		moff =3D btf_member_bit_offset(t, m) / 8;
+		if (moff =3D=3D offsetof(struct tcp_congestion_ops, release))
+			return NULL;
+		return &bpf_sk_setsockopt_proto;
+	case BPF_FUNC_getsockopt:
+		return &bpf_sk_getsockopt_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -286,9 +309,6 @@ static void bpf_tcp_ca_unreg(void *kdata)
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

