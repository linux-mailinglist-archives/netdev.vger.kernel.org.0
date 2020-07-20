Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B952E226A76
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388994AbgGTQeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:34:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17411 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389003AbgGTQeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:34:19 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KGY1KC019021
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:34:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kh9NuHr/OY8Djt/qZUAJ0IkhaPVniRodAoG7YeHHwpI=;
 b=Cq4dV5Z56mVe90VZ6gYAp7HWYL7EnZMVa4WgM/LxnJs4pTU+w4ruHzYQlALNDQvqhXWH
 OtxfkBMClYckiNRWfiQOjRkZshrT4KyISvkDWMjp8vOAZ3DU48hB0FxleTCNlZlKTwIC
 WNCHmq9tSNOSI4lqCPgOaXasF/FQdoPrezE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32bxwfqg1h-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:34:17 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Jul 2020 09:34:14 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 8AF4F370209A; Mon, 20 Jul 2020 09:34:03 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 5/5] bpf: net: use precomputed btf_id for bpf iterators
Date:   Mon, 20 Jul 2020 09:34:03 -0700
Message-ID: <20200720163403.1393551-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200720163358.1392964-1-yhs@fb.com>
References: <20200720163358.1392964-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200111
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One additional field btf_id is added to struct
bpf_ctx_arg_aux to store the precomputed btf_ids.
The btf_id is computed at build time with
BTF_ID_LIST or BTF_ID_LIST_GLOBAL macro definitions.
All existing bpf iterators are changed to used
pre-compute btf_ids.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h      |  1 +
 kernel/bpf/btf.c         |  5 +++--
 kernel/bpf/map_iter.c    |  7 ++++++-
 kernel/bpf/task_iter.c   | 12 ++++++++++--
 net/ipv4/tcp_ipv4.c      |  4 +++-
 net/ipv4/udp.c           |  4 +++-
 net/ipv6/route.c         |  7 ++++++-
 net/netlink/af_netlink.c |  7 ++++++-
 8 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1df1c0fd3f28..bae557ff2da8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -668,6 +668,7 @@ struct bpf_jit_poke_descriptor {
 struct bpf_ctx_arg_aux {
 	u32 offset;
 	enum bpf_reg_type reg_type;
+	u32 btf_id;
 };
=20
 struct bpf_prog_aux {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 315cde73421b..ee36b7f60936 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3817,16 +3817,17 @@ bool btf_ctx_access(int off, int size, enum bpf_a=
ccess_type type,
 		return true;
=20
 	/* this is a pointer to another type */
-	info->reg_type =3D PTR_TO_BTF_ID;
 	for (i =3D 0; i < prog->aux->ctx_arg_info_size; i++) {
 		const struct bpf_ctx_arg_aux *ctx_arg_info =3D &prog->aux->ctx_arg_inf=
o[i];
=20
 		if (ctx_arg_info->offset =3D=3D off) {
 			info->reg_type =3D ctx_arg_info->reg_type;
-			break;
+			info->btf_id =3D ctx_arg_info->btf_id;
+			return true;
 		}
 	}
=20
+	info->reg_type =3D PTR_TO_BTF_ID;
 	if (tgt_prog) {
 		ret =3D btf_translate_to_vmlinux(log, btf, t, tgt_prog->type, arg);
 		if (ret > 0) {
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index c69071e334bf..8a7af11b411f 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -4,6 +4,7 @@
 #include <linux/fs.h>
 #include <linux/filter.h>
 #include <linux/kernel.h>
+#include <linux/btf_ids.h>
=20
 struct bpf_iter_seq_map_info {
 	u32 mid;
@@ -81,7 +82,10 @@ static const struct seq_operations bpf_map_seq_ops =3D=
 {
 	.show	=3D bpf_map_seq_show,
 };
=20
-static const struct bpf_iter_reg bpf_map_reg_info =3D {
+BTF_ID_LIST(btf_bpf_map_id)
+BTF_ID(struct, bpf_map)
+
+static struct bpf_iter_reg bpf_map_reg_info =3D {
 	.target			=3D "bpf_map",
 	.seq_ops		=3D &bpf_map_seq_ops,
 	.init_seq_private	=3D NULL,
@@ -96,6 +100,7 @@ static const struct bpf_iter_reg bpf_map_reg_info =3D =
{
=20
 static int __init bpf_map_iter_init(void)
 {
+	bpf_map_reg_info.ctx_arg_info[0].btf_id =3D *btf_bpf_map_id;
 	return bpf_iter_reg_target(&bpf_map_reg_info);
 }
=20
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 4dbf2b6035f8..2feecf095609 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -7,6 +7,7 @@
 #include <linux/fs.h>
 #include <linux/fdtable.h>
 #include <linux/filter.h>
+#include <linux/btf_ids.h>
=20
 struct bpf_iter_seq_task_common {
 	struct pid_namespace *ns;
@@ -312,7 +313,11 @@ static const struct seq_operations task_file_seq_ops=
 =3D {
 	.show	=3D task_file_seq_show,
 };
=20
-static const struct bpf_iter_reg task_reg_info =3D {
+BTF_ID_LIST(btf_task_file_ids)
+BTF_ID(struct, task_struct)
+BTF_ID(struct, file)
+
+static struct bpf_iter_reg task_reg_info =3D {
 	.target			=3D "task",
 	.seq_ops		=3D &task_seq_ops,
 	.init_seq_private	=3D init_seq_pidns,
@@ -325,7 +330,7 @@ static const struct bpf_iter_reg task_reg_info =3D {
 	},
 };
=20
-static const struct bpf_iter_reg task_file_reg_info =3D {
+static struct bpf_iter_reg task_file_reg_info =3D {
 	.target			=3D "task_file",
 	.seq_ops		=3D &task_file_seq_ops,
 	.init_seq_private	=3D init_seq_pidns,
@@ -344,10 +349,13 @@ static int __init task_iter_init(void)
 {
 	int ret;
=20
+	task_reg_info.ctx_arg_info[0].btf_id =3D btf_task_file_ids[0];
 	ret =3D bpf_iter_reg_target(&task_reg_info);
 	if (ret)
 		return ret;
=20
+	task_file_reg_info.ctx_arg_info[0].btf_id =3D btf_task_file_ids[0];
+	task_file_reg_info.ctx_arg_info[1].btf_id =3D btf_task_file_ids[1];
 	return bpf_iter_reg_target(&task_file_reg_info);
 }
 late_initcall(task_iter_init);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 116c11a0aaed..a7f1b41482f8 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -76,6 +76,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/inetdevice.h>
+#include <linux/btf_ids.h>
=20
 #include <crypto/hash.h>
 #include <linux/scatterlist.h>
@@ -2954,7 +2955,7 @@ static void bpf_iter_fini_tcp(void *priv_data)
 	bpf_iter_fini_seq_net(priv_data);
 }
=20
-static const struct bpf_iter_reg tcp_reg_info =3D {
+static struct bpf_iter_reg tcp_reg_info =3D {
 	.target			=3D "tcp",
 	.seq_ops		=3D &bpf_iter_tcp_seq_ops,
 	.init_seq_private	=3D bpf_iter_init_tcp,
@@ -2969,6 +2970,7 @@ static const struct bpf_iter_reg tcp_reg_info =3D {
=20
 static void __init bpf_iter_register(void)
 {
+	tcp_reg_info.ctx_arg_info[0].btf_id =3D btf_sock_ids[BTF_SOCK_TYPE_SOCK=
_COMMON];
 	if (bpf_iter_reg_target(&tcp_reg_info))
 		pr_warn("Warning: could not register bpf iterator tcp\n");
 }
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index b738c63d7a77..b5231ab350e0 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -106,6 +106,7 @@
 #include <net/xfrm.h>
 #include <trace/events/udp.h>
 #include <linux/static_key.h>
+#include <linux/btf_ids.h>
 #include <trace/events/skb.h>
 #include <net/busy_poll.h>
 #include "udp_impl.h"
@@ -3232,7 +3233,7 @@ static void bpf_iter_fini_udp(void *priv_data)
 	bpf_iter_fini_seq_net(priv_data);
 }
=20
-static const struct bpf_iter_reg udp_reg_info =3D {
+static struct bpf_iter_reg udp_reg_info =3D {
 	.target			=3D "udp",
 	.seq_ops		=3D &bpf_iter_udp_seq_ops,
 	.init_seq_private	=3D bpf_iter_init_udp,
@@ -3247,6 +3248,7 @@ static const struct bpf_iter_reg udp_reg_info =3D {
=20
 static void __init bpf_iter_register(void)
 {
+	udp_reg_info.ctx_arg_info[0].btf_id =3D btf_sock_ids[BTF_SOCK_TYPE_UDP]=
;
 	if (bpf_iter_reg_target(&udp_reg_info))
 		pr_warn("Warning: could not register bpf iterator udp\n");
 }
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 427b81cbc164..33f5efbad0a9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -61,6 +61,7 @@
 #include <net/l3mdev.h>
 #include <net/ip.h>
 #include <linux/uaccess.h>
+#include <linux/btf_ids.h>
=20
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
@@ -6423,7 +6424,10 @@ void __init ip6_route_init_special_entries(void)
 #if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
 DEFINE_BPF_ITER_FUNC(ipv6_route, struct bpf_iter_meta *meta, struct fib6=
_info *rt)
=20
-static const struct bpf_iter_reg ipv6_route_reg_info =3D {
+BTF_ID_LIST(btf_fib6_info_id)
+BTF_ID(struct, fib6_info)
+
+static struct bpf_iter_reg ipv6_route_reg_info =3D {
 	.target			=3D "ipv6_route",
 	.seq_ops		=3D &ipv6_route_seq_ops,
 	.init_seq_private	=3D bpf_iter_init_seq_net,
@@ -6438,6 +6442,7 @@ static const struct bpf_iter_reg ipv6_route_reg_inf=
o =3D {
=20
 static int __init bpf_iter_register(void)
 {
+	ipv6_route_reg_info.ctx_arg_info[0].btf_id =3D *btf_fib6_info_id;
 	return bpf_iter_reg_target(&ipv6_route_reg_info);
 }
=20
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4f2c3b14ddbf..3cd58f0c2de4 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -60,6 +60,7 @@
 #include <linux/genetlink.h>
 #include <linux/net_namespace.h>
 #include <linux/nospec.h>
+#include <linux/btf_ids.h>
=20
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
@@ -2803,7 +2804,10 @@ static const struct rhashtable_params netlink_rhas=
htable_params =3D {
 };
=20
 #if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
-static const struct bpf_iter_reg netlink_reg_info =3D {
+BTF_ID_LIST(btf_netlink_sock_id)
+BTF_ID(struct, netlink_sock)
+
+static struct bpf_iter_reg netlink_reg_info =3D {
 	.target			=3D "netlink",
 	.seq_ops		=3D &netlink_seq_ops,
 	.init_seq_private	=3D bpf_iter_init_seq_net,
@@ -2818,6 +2822,7 @@ static const struct bpf_iter_reg netlink_reg_info =3D=
 {
=20
 static int __init bpf_iter_register(void)
 {
+	netlink_reg_info.ctx_arg_info[0].btf_id =3D *btf_netlink_sock_id;
 	return bpf_iter_reg_target(&netlink_reg_info);
 }
 #endif
--=20
2.24.1

