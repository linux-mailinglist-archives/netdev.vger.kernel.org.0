Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47C01D1CDD
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390073AbgEMSCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:02:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15404 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390060AbgEMSCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:02:43 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DI1cum030512
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 11:02:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Lpip3l9/Raz8Y++Sbti5dvRHJT9oDaEiTvC9A9MCjBw=;
 b=AQ6i0Wrb6yssmaHgC0Y3pvyYwj1NznLTv752U8Us8YjXlarfUPv6XOeXGhdfrpLhjLzC
 orYHZRIt9tEJs/q8FSzUccWBKHVdxC7K/cFvbld7mRqxnzzm9p6PiZKGXvVp3uXMcfIQ
 /PtdCeIRazn4xXOwXb9tthc9S1D6DXfOH9U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3100xb6bpa-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 11:02:42 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 11:02:22 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 67C4737009B0; Wed, 13 May 2020 11:02:19 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 4/7] bpf: net: refactor bpf_iter target registration
Date:   Wed, 13 May 2020 11:02:19 -0700
Message-ID: <20200513180219.2949605-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200513180215.2949164-1-yhs@fb.com>
References: <20200513180215.2949164-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_08:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 adultscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently bpf_iter_reg_target takes parameters from target
and allocates memory to save them. This is really not
necessary, esp. in the future we may grow information
passed from targets to bpf_iter manager.

The patch refactors the code so target reg_info
becomes static and bpf_iter manager can just take
a reference to it.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h      |  2 +-
 kernel/bpf/bpf_iter.c    | 36 +++++++++++++++++-------------------
 kernel/bpf/map_iter.c    | 18 +++++++++---------
 kernel/bpf/task_iter.c   | 30 ++++++++++++++++--------------
 net/ipv6/route.c         | 18 +++++++++---------
 net/netlink/af_netlink.c | 18 +++++++++---------
 6 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ab94dfd8826f..6fa773e2d1bf 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1153,7 +1153,7 @@ struct bpf_iter_meta {
 	u64 seq_num;
 };
=20
-int bpf_iter_reg_target(struct bpf_iter_reg *reg_info);
+int bpf_iter_reg_target(const struct bpf_iter_reg *reg_info);
 void bpf_iter_unreg_target(const char *target);
 bool bpf_iter_prog_supported(struct bpf_prog *prog);
 int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og);
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 0a45a6cdfabd..051fb8cab62a 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -8,11 +8,7 @@
=20
 struct bpf_iter_target_info {
 	struct list_head list;
-	const char *target;
-	const struct seq_operations *seq_ops;
-	bpf_iter_init_seq_priv_t init_seq_private;
-	bpf_iter_fini_seq_priv_t fini_seq_private;
-	u32 seq_priv_size;
+	const struct bpf_iter_reg *reg_info;
 	u32 btf_id;	/* cached value */
 };
=20
@@ -222,8 +218,8 @@ static int iter_release(struct inode *inode, struct f=
ile *file)
 	iter_priv =3D container_of(seq->private, struct bpf_iter_priv_data,
 				 target_private);
=20
-	if (iter_priv->tinfo->fini_seq_private)
-		iter_priv->tinfo->fini_seq_private(seq->private);
+	if (iter_priv->tinfo->reg_info->fini_seq_private)
+		iter_priv->tinfo->reg_info->fini_seq_private(seq->private);
=20
 	bpf_prog_put(iter_priv->prog);
 	seq->private =3D iter_priv;
@@ -238,7 +234,12 @@ const struct file_operations bpf_iter_fops =3D {
 	.release	=3D iter_release,
 };
=20
-int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
+/* The argument reg_info will be cached in bpf_iter_target_info.
+ * The common practice is to declare target reg_info as
+ * a const static variable and passed as an argument to
+ * bpf_iter_reg_target().
+ */
+int bpf_iter_reg_target(const struct bpf_iter_reg *reg_info)
 {
 	struct bpf_iter_target_info *tinfo;
=20
@@ -246,11 +247,7 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_inf=
o)
 	if (!tinfo)
 		return -ENOMEM;
=20
-	tinfo->target =3D reg_info->target;
-	tinfo->seq_ops =3D reg_info->seq_ops;
-	tinfo->init_seq_private =3D reg_info->init_seq_private;
-	tinfo->fini_seq_private =3D reg_info->fini_seq_private;
-	tinfo->seq_priv_size =3D reg_info->seq_priv_size;
+	tinfo->reg_info =3D reg_info;
 	INIT_LIST_HEAD(&tinfo->list);
=20
 	mutex_lock(&targets_mutex);
@@ -267,7 +264,7 @@ void bpf_iter_unreg_target(const char *target)
=20
 	mutex_lock(&targets_mutex);
 	list_for_each_entry(tinfo, &targets, list) {
-		if (!strcmp(target, tinfo->target)) {
+		if (!strcmp(target, tinfo->reg_info->target)) {
 			list_del(&tinfo->list);
 			kfree(tinfo);
 			found =3D true;
@@ -303,7 +300,7 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)
 			supported =3D true;
 			break;
 		}
-		if (!strcmp(attach_fname + prefix_len, tinfo->target)) {
+		if (!strcmp(attach_fname + prefix_len, tinfo->reg_info->target)) {
 			cache_btf_id(tinfo, prog);
 			supported =3D true;
 			break;
@@ -431,15 +428,16 @@ static int prepare_seq_file(struct file *file, stru=
ct bpf_iter_link *link)
=20
 	tinfo =3D link->tinfo;
 	total_priv_dsize =3D offsetof(struct bpf_iter_priv_data, target_private=
) +
-			   tinfo->seq_priv_size;
-	priv_data =3D __seq_open_private(file, tinfo->seq_ops, total_priv_dsize=
);
+			   tinfo->reg_info->seq_priv_size;
+	priv_data =3D __seq_open_private(file, tinfo->reg_info->seq_ops,
+				       total_priv_dsize);
 	if (!priv_data) {
 		err =3D -ENOMEM;
 		goto release_prog;
 	}
=20
-	if (tinfo->init_seq_private) {
-		err =3D tinfo->init_seq_private(priv_data->target_private);
+	if (tinfo->reg_info->init_seq_private) {
+		err =3D tinfo->reg_info->init_seq_private(priv_data->target_private);
 		if (err)
 			goto release_seq_file;
 	}
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index 8162e0c00b9f..c6216a5fe56e 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -81,17 +81,17 @@ static const struct seq_operations bpf_map_seq_ops =3D=
 {
 	.show	=3D bpf_map_seq_show,
 };
=20
+static const struct bpf_iter_reg bpf_map_reg_info =3D {
+	.target			=3D "bpf_map",
+	.seq_ops		=3D &bpf_map_seq_ops,
+	.init_seq_private	=3D NULL,
+	.fini_seq_private	=3D NULL,
+	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_map_info),
+};
+
 static int __init bpf_map_iter_init(void)
 {
-	struct bpf_iter_reg reg_info =3D {
-		.target			=3D "bpf_map",
-		.seq_ops		=3D &bpf_map_seq_ops,
-		.init_seq_private	=3D NULL,
-		.fini_seq_private	=3D NULL,
-		.seq_priv_size		=3D sizeof(struct bpf_iter_seq_map_info),
-	};
-
-	return bpf_iter_reg_target(&reg_info);
+	return bpf_iter_reg_target(&bpf_map_reg_info);
 }
=20
 late_initcall(bpf_map_iter_init);
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index aeed662d8451..bd7bfd83d9e0 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -306,22 +306,24 @@ static const struct seq_operations task_file_seq_op=
s =3D {
 	.show	=3D task_file_seq_show,
 };
=20
+static const struct bpf_iter_reg task_reg_info =3D {
+	.target			=3D "task",
+	.seq_ops		=3D &task_seq_ops,
+	.init_seq_private	=3D init_seq_pidns,
+	.fini_seq_private	=3D fini_seq_pidns,
+	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_info),
+};
+
+static const struct bpf_iter_reg task_file_reg_info =3D {
+	.target			=3D "task_file",
+	.seq_ops		=3D &task_file_seq_ops,
+	.init_seq_private	=3D init_seq_pidns,
+	.fini_seq_private	=3D fini_seq_pidns,
+	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_file_info),
+};
+
 static int __init task_iter_init(void)
 {
-	struct bpf_iter_reg task_file_reg_info =3D {
-		.target			=3D "task_file",
-		.seq_ops		=3D &task_file_seq_ops,
-		.init_seq_private	=3D init_seq_pidns,
-		.fini_seq_private	=3D fini_seq_pidns,
-		.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_file_info),
-	};
-	struct bpf_iter_reg task_reg_info =3D {
-		.target			=3D "task",
-		.seq_ops		=3D &task_seq_ops,
-		.init_seq_private	=3D init_seq_pidns,
-		.fini_seq_private	=3D fini_seq_pidns,
-		.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_info),
-	};
 	int ret;
=20
 	ret =3D bpf_iter_reg_target(&task_reg_info);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 25f6d3e619d0..6ad2fa51a23a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6397,17 +6397,17 @@ void __init ip6_route_init_special_entries(void)
 #if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
 DEFINE_BPF_ITER_FUNC(ipv6_route, struct bpf_iter_meta *meta, struct fib6=
_info *rt)
=20
+static const struct bpf_iter_reg ipv6_route_reg_info =3D {
+	.target			=3D "ipv6_route",
+	.seq_ops		=3D &ipv6_route_seq_ops,
+	.init_seq_private	=3D bpf_iter_init_seq_net,
+	.fini_seq_private	=3D bpf_iter_fini_seq_net,
+	.seq_priv_size		=3D sizeof(struct ipv6_route_iter),
+};
+
 static int __init bpf_iter_register(void)
 {
-	struct bpf_iter_reg reg_info =3D {
-		.target			=3D "ipv6_route",
-		.seq_ops		=3D &ipv6_route_seq_ops,
-		.init_seq_private	=3D bpf_iter_init_seq_net,
-		.fini_seq_private	=3D bpf_iter_fini_seq_net,
-		.seq_priv_size		=3D sizeof(struct ipv6_route_iter),
-	};
-
-	return bpf_iter_reg_target(&reg_info);
+	return bpf_iter_reg_target(&ipv6_route_reg_info);
 }
=20
 static void bpf_iter_unregister(void)
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 33cda9baa979..839827227e98 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2803,17 +2803,17 @@ static const struct rhashtable_params netlink_rha=
shtable_params =3D {
 };
=20
 #if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+static const struct bpf_iter_reg netlink_reg_info =3D {
+	.target			=3D "netlink",
+	.seq_ops		=3D &netlink_seq_ops,
+	.init_seq_private	=3D bpf_iter_init_seq_net,
+	.fini_seq_private	=3D bpf_iter_fini_seq_net,
+	.seq_priv_size		=3D sizeof(struct nl_seq_iter),
+};
+
 static int __init bpf_iter_register(void)
 {
-	struct bpf_iter_reg reg_info =3D {
-		.target			=3D "netlink",
-		.seq_ops		=3D &netlink_seq_ops,
-		.init_seq_private	=3D bpf_iter_init_seq_net,
-		.fini_seq_private	=3D bpf_iter_fini_seq_net,
-		.seq_priv_size		=3D sizeof(struct nl_seq_iter),
-	};
-
-	return bpf_iter_reg_target(&reg_info);
+	return bpf_iter_reg_target(&netlink_reg_info);
 }
 #endif
=20
--=20
2.24.1

