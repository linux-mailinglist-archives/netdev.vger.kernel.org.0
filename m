Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3781CF9CD
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730847AbgELPwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:52:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56558 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730904AbgELPwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:52:43 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CFpKZ2016580
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:52:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=1ThjblOOIvxz5YYT9JIN4hcQolPVl+mMQ2+ovzHqiEI=;
 b=JxX56Y6376NNu/t9PlQs+AT0ww1YyQKfSIH9nMu2tMKZoB6z/fOQx8uwfdssEJhwNlh0
 lpkw7VTGM7q1U5vZsS3fmyTaghDi3unvD4+c1jFW1C7lKL6n6ST3rTaT0zQ4EHJ2Ytih
 /kkRkxH9215lklZeMx/pynq0nCWCq4iJb4Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30xcc3w21q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:52:43 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 08:52:41 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 46E963700839; Tue, 12 May 2020 08:52:37 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 5/8] bpf: net: refactor bpf_iter target registration
Date:   Tue, 12 May 2020 08:52:37 -0700
Message-ID: <20200512155237.1080552-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200512155232.1080167-1-yhs@fb.com>
References: <20200512155232.1080167-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_05:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120120
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
 kernel/bpf/bpf_iter.c    | 29 +++++++++++------------------
 kernel/bpf/map_iter.c    | 18 +++++++++---------
 kernel/bpf/task_iter.c   | 30 ++++++++++++++++--------------
 net/ipv6/route.c         | 18 +++++++++---------
 net/netlink/af_netlink.c | 18 +++++++++---------
 5 files changed, 54 insertions(+), 59 deletions(-)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index b0c8b3bdf3b0..1d203dc7afe2 100644
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
+	struct bpf_iter_reg *reg_info;
 	u32 btf_id;	/* cached value */
 };
=20
@@ -224,8 +220,8 @@ static int iter_release(struct inode *inode, struct f=
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
@@ -248,11 +244,7 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_inf=
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
@@ -269,7 +261,7 @@ void bpf_iter_unreg_target(const char *target)
=20
 	mutex_lock(&targets_mutex);
 	list_for_each_entry(tinfo, &targets, list) {
-		if (!strcmp(target, tinfo->target)) {
+		if (!strcmp(target, tinfo->reg_info->target)) {
 			list_del(&tinfo->list);
 			kfree(tinfo);
 			found =3D true;
@@ -305,7 +297,7 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)
 			supported =3D true;
 			break;
 		}
-		if (!strcmp(attach_fname + prefix_len, tinfo->target)) {
+		if (!strcmp(attach_fname + prefix_len, tinfo->reg_info->target)) {
 			cache_btf_id(tinfo, prog);
 			supported =3D true;
 			break;
@@ -433,15 +425,16 @@ static int prepare_seq_file(struct file *file, stru=
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
index 8162e0c00b9f..545c7dbb13c9 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -81,17 +81,17 @@ static const struct seq_operations bpf_map_seq_ops =3D=
 {
 	.show	=3D bpf_map_seq_show,
 };
=20
+static struct bpf_iter_reg bpf_map_reg_info =3D {
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
index aeed662d8451..ed0b1d6ce688 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -306,22 +306,24 @@ static const struct seq_operations task_file_seq_op=
s =3D {
 	.show	=3D task_file_seq_show,
 };
=20
+static struct bpf_iter_reg task_reg_info =3D {
+	.target			=3D "task",
+	.seq_ops		=3D &task_seq_ops,
+	.init_seq_private	=3D init_seq_pidns,
+	.fini_seq_private	=3D fini_seq_pidns,
+	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_info),
+};
+
+static struct bpf_iter_reg task_file_reg_info =3D {
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
index 25f6d3e619d0..48e8752d9ad9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6397,17 +6397,17 @@ void __init ip6_route_init_special_entries(void)
 #if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
 DEFINE_BPF_ITER_FUNC(ipv6_route, struct bpf_iter_meta *meta, struct fib6=
_info *rt)
=20
+static struct bpf_iter_reg ipv6_route_reg_info =3D {
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
index 33cda9baa979..1e2f5ab8c7d7 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2803,17 +2803,17 @@ static const struct rhashtable_params netlink_rha=
shtable_params =3D {
 };
=20
 #if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+static struct bpf_iter_reg netlink_reg_info =3D {
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

