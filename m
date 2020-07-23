Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0890822B5DE
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgGWSlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:41:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44818 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727043AbgGWSlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 14:41:17 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06NIWb9S029028
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 11:41:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=AIGSMY7Sv09YE52crNp3iE86ViN2fHQJ2dyqBFp4ovk=;
 b=Ab+/en/gR20GBxkOLWuT0MBXSx5PFnv9G9Q/dENvaZFfb/QaNESiB+wjtv79eEEMd5YL
 GmwllGGtAyeMubu4zEwRLfAbE8t6lxmijC1qlBcsOXrE+gyHjIq3VMXrPVhpo9FK1cQz
 cS0xndj15zCYvWnqX3Ih/J9LSgSZ/H5tLNs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 32er2feg3n-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 11:41:14 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 11:41:12 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 228A23702E12; Thu, 23 Jul 2020 11:41:09 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 01/13] bpf: refactor bpf_iter_reg to have separate seq_info member
Date:   Thu, 23 Jul 2020 11:41:09 -0700
Message-ID: <20200723184109.590030-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200723184108.589857-1-yhs@fb.com>
References: <20200723184108.589857-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_09:2020-07-23,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=847
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230134
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no functionality change for this patch.
Struct bpf_iter_reg is used to register a bpf_iter target,
which includes information for both prog_load, link_create
and seq_file creation.

This patch puts fields related seq_file creation into
a different structure. This will be useful for map
elements iterator where one iterator covers different
map types and different map types may have different
seq_ops, init/fini private_data function and
private_data size.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h      | 17 ++++++++++-------
 kernel/bpf/bpf_iter.c    | 12 ++++++------
 kernel/bpf/map_iter.c    |  8 ++++++--
 kernel/bpf/prog_iter.c   |  8 ++++++--
 kernel/bpf/task_iter.c   | 16 ++++++++++++----
 net/ipv4/tcp_ipv4.c      |  8 ++++++--
 net/ipv4/udp.c           |  8 ++++++--
 net/ipv6/route.c         |  8 ++++++--
 net/netlink/af_netlink.c |  8 ++++++--
 9 files changed, 64 insertions(+), 29 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 72221aea1c60..127067f71fd4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -37,6 +37,15 @@ struct seq_operations;
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
=20
+typedef int (*bpf_iter_init_seq_priv_t)(void *private_data);
+typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
+struct bpf_iter_seq_info {
+	const struct seq_operations *seq_ops;
+	bpf_iter_init_seq_priv_t init_seq_private;
+	bpf_iter_fini_seq_priv_t fini_seq_private;
+	u32 seq_priv_size;
+};
+
 /* map is generic key/value storage optionally accesible by eBPF program=
s */
 struct bpf_map_ops {
 	/* funcs callable from userspace (via syscall) */
@@ -1189,18 +1198,12 @@ int bpf_obj_get_user(const char __user *pathname,=
 int flags);
 	extern int bpf_iter_ ## target(args);			\
 	int __init bpf_iter_ ## target(args) { return 0; }
=20
-typedef int (*bpf_iter_init_seq_priv_t)(void *private_data);
-typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
-
 #define BPF_ITER_CTX_ARG_MAX 2
 struct bpf_iter_reg {
 	const char *target;
-	const struct seq_operations *seq_ops;
-	bpf_iter_init_seq_priv_t init_seq_private;
-	bpf_iter_fini_seq_priv_t fini_seq_private;
-	u32 seq_priv_size;
 	u32 ctx_arg_info_size;
 	struct bpf_ctx_arg_aux ctx_arg_info[BPF_ITER_CTX_ARG_MAX];
+	const struct bpf_iter_seq_info *seq_info;
 };
=20
 struct bpf_iter_meta {
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index dd612b80b9fe..5b2387d6aa1f 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -218,8 +218,8 @@ static int iter_release(struct inode *inode, struct f=
ile *file)
 	iter_priv =3D container_of(seq->private, struct bpf_iter_priv_data,
 				 target_private);
=20
-	if (iter_priv->tinfo->reg_info->fini_seq_private)
-		iter_priv->tinfo->reg_info->fini_seq_private(seq->private);
+	if (iter_priv->tinfo->reg_info->seq_info->fini_seq_private)
+		iter_priv->tinfo->reg_info->seq_info->fini_seq_private(seq->private);
=20
 	bpf_prog_put(iter_priv->prog);
 	seq->private =3D iter_priv;
@@ -433,16 +433,16 @@ static int prepare_seq_file(struct file *file, stru=
ct bpf_iter_link *link)
=20
 	tinfo =3D link->tinfo;
 	total_priv_dsize =3D offsetof(struct bpf_iter_priv_data, target_private=
) +
-			   tinfo->reg_info->seq_priv_size;
-	priv_data =3D __seq_open_private(file, tinfo->reg_info->seq_ops,
+			   tinfo->reg_info->seq_info->seq_priv_size;
+	priv_data =3D __seq_open_private(file, tinfo->reg_info->seq_info->seq_o=
ps,
 				       total_priv_dsize);
 	if (!priv_data) {
 		err =3D -ENOMEM;
 		goto release_prog;
 	}
=20
-	if (tinfo->reg_info->init_seq_private) {
-		err =3D tinfo->reg_info->init_seq_private(priv_data->target_private);
+	if (tinfo->reg_info->seq_info->init_seq_private) {
+		err =3D tinfo->reg_info->seq_info->init_seq_private(priv_data->target_=
private);
 		if (err)
 			goto release_seq_file;
 	}
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index 5926c76d854e..1a69241fb1e2 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -81,17 +81,21 @@ static const struct seq_operations bpf_map_seq_ops =3D=
 {
 BTF_ID_LIST(btf_bpf_map_id)
 BTF_ID(struct, bpf_map)
=20
-static struct bpf_iter_reg bpf_map_reg_info =3D {
-	.target			=3D "bpf_map",
+static const struct bpf_iter_seq_info bpf_map_seq_info =3D {
 	.seq_ops		=3D &bpf_map_seq_ops,
 	.init_seq_private	=3D NULL,
 	.fini_seq_private	=3D NULL,
 	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_map_info),
+};
+
+static struct bpf_iter_reg bpf_map_reg_info =3D {
+	.target			=3D "bpf_map",
 	.ctx_arg_info_size	=3D 1,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__bpf_map, map),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
+	.seq_info		=3D &bpf_map_seq_info,
 };
=20
 static int __init bpf_map_iter_init(void)
diff --git a/kernel/bpf/prog_iter.c b/kernel/bpf/prog_iter.c
index 6541b577d69f..53a73c841c13 100644
--- a/kernel/bpf/prog_iter.c
+++ b/kernel/bpf/prog_iter.c
@@ -81,17 +81,21 @@ static const struct seq_operations bpf_prog_seq_ops =3D=
 {
 BTF_ID_LIST(btf_bpf_prog_id)
 BTF_ID(struct, bpf_prog)
=20
-static struct bpf_iter_reg bpf_prog_reg_info =3D {
-	.target			=3D "bpf_prog",
+static const struct bpf_iter_seq_info bpf_prog_seq_info =3D {
 	.seq_ops		=3D &bpf_prog_seq_ops,
 	.init_seq_private	=3D NULL,
 	.fini_seq_private	=3D NULL,
 	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_prog_info),
+};
+
+static struct bpf_iter_reg bpf_prog_reg_info =3D {
+	.target			=3D "bpf_prog",
 	.ctx_arg_info_size	=3D 1,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__bpf_prog, prog),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
+	.seq_info		=3D &bpf_prog_seq_info,
 };
=20
 static int __init bpf_prog_iter_init(void)
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 1039e52ebd8b..6d9cd23869bf 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -319,25 +319,32 @@ BTF_ID_LIST(btf_task_file_ids)
 BTF_ID(struct, task_struct)
 BTF_ID(struct, file)
=20
-static struct bpf_iter_reg task_reg_info =3D {
-	.target			=3D "task",
+static const struct bpf_iter_seq_info task_seq_info =3D {
 	.seq_ops		=3D &task_seq_ops,
 	.init_seq_private	=3D init_seq_pidns,
 	.fini_seq_private	=3D fini_seq_pidns,
 	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_info),
+};
+
+static struct bpf_iter_reg task_reg_info =3D {
+	.target			=3D "task",
 	.ctx_arg_info_size	=3D 1,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__task, task),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
+	.seq_info		=3D &task_seq_info,
 };
=20
-static struct bpf_iter_reg task_file_reg_info =3D {
-	.target			=3D "task_file",
+static const struct bpf_iter_seq_info task_file_seq_info =3D {
 	.seq_ops		=3D &task_file_seq_ops,
 	.init_seq_private	=3D init_seq_pidns,
 	.fini_seq_private	=3D fini_seq_pidns,
 	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_file_info),
+};
+
+static struct bpf_iter_reg task_file_reg_info =3D {
+	.target			=3D "task_file",
 	.ctx_arg_info_size	=3D 2,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__task_file, task),
@@ -345,6 +352,7 @@ static struct bpf_iter_reg task_file_reg_info =3D {
 		{ offsetof(struct bpf_iter__task_file, file),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
+	.seq_info		=3D &task_file_seq_info,
 };
=20
 static int __init task_iter_init(void)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index daa39d33702b..5e029c0c0907 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2947,17 +2947,21 @@ static void bpf_iter_fini_tcp(void *priv_data)
 	bpf_iter_fini_seq_net(priv_data);
 }
=20
-static struct bpf_iter_reg tcp_reg_info =3D {
-	.target			=3D "tcp",
+static const struct bpf_iter_seq_info tcp_seq_info =3D {
 	.seq_ops		=3D &bpf_iter_tcp_seq_ops,
 	.init_seq_private	=3D bpf_iter_init_tcp,
 	.fini_seq_private	=3D bpf_iter_fini_tcp,
 	.seq_priv_size		=3D sizeof(struct tcp_iter_state),
+};
+
+static struct bpf_iter_reg tcp_reg_info =3D {
+	.target			=3D "tcp",
 	.ctx_arg_info_size	=3D 1,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__tcp, sk_common),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
+	.seq_info		=3D &tcp_seq_info,
 };
=20
 static void __init bpf_iter_register(void)
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index bb07b20b5ca9..6879ff80c3d0 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3206,17 +3206,21 @@ static void bpf_iter_fini_udp(void *priv_data)
 	bpf_iter_fini_seq_net(priv_data);
 }
=20
-static struct bpf_iter_reg udp_reg_info =3D {
-	.target			=3D "udp",
+static const struct bpf_iter_seq_info udp_seq_info =3D {
 	.seq_ops		=3D &bpf_iter_udp_seq_ops,
 	.init_seq_private	=3D bpf_iter_init_udp,
 	.fini_seq_private	=3D bpf_iter_fini_udp,
 	.seq_priv_size		=3D sizeof(struct udp_iter_state),
+};
+
+static struct bpf_iter_reg udp_reg_info =3D {
+	.target			=3D "udp",
 	.ctx_arg_info_size	=3D 1,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__udp, udp_sk),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
+	.seq_info		=3D &udp_seq_info,
 };
=20
 static void __init bpf_iter_register(void)
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 33f5efbad0a9..8bfc57b0802a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6427,17 +6427,21 @@ DEFINE_BPF_ITER_FUNC(ipv6_route, struct bpf_iter_=
meta *meta, struct fib6_info *r
 BTF_ID_LIST(btf_fib6_info_id)
 BTF_ID(struct, fib6_info)
=20
-static struct bpf_iter_reg ipv6_route_reg_info =3D {
-	.target			=3D "ipv6_route",
+static const struct bpf_iter_seq_info ipv6_route_seq_info =3D {
 	.seq_ops		=3D &ipv6_route_seq_ops,
 	.init_seq_private	=3D bpf_iter_init_seq_net,
 	.fini_seq_private	=3D bpf_iter_fini_seq_net,
 	.seq_priv_size		=3D sizeof(struct ipv6_route_iter),
+};
+
+static struct bpf_iter_reg ipv6_route_reg_info =3D {
+	.target			=3D "ipv6_route",
 	.ctx_arg_info_size	=3D 1,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__ipv6_route, rt),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
+	.seq_info		=3D &ipv6_route_seq_info,
 };
=20
 static int __init bpf_iter_register(void)
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 3cd58f0c2de4..19ec8cdd7a2f 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2807,17 +2807,21 @@ static const struct rhashtable_params netlink_rha=
shtable_params =3D {
 BTF_ID_LIST(btf_netlink_sock_id)
 BTF_ID(struct, netlink_sock)
=20
-static struct bpf_iter_reg netlink_reg_info =3D {
-	.target			=3D "netlink",
+static const struct bpf_iter_seq_info netlink_seq_info =3D {
 	.seq_ops		=3D &netlink_seq_ops,
 	.init_seq_private	=3D bpf_iter_init_seq_net,
 	.fini_seq_private	=3D bpf_iter_fini_seq_net,
 	.seq_priv_size		=3D sizeof(struct nl_seq_iter),
+};
+
+static struct bpf_iter_reg netlink_reg_info =3D {
+	.target			=3D "netlink",
 	.ctx_arg_info_size	=3D 1,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__netlink, sk),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
+	.seq_info		=3D &netlink_seq_info,
 };
=20
 static int __init bpf_iter_register(void)
--=20
2.24.1

