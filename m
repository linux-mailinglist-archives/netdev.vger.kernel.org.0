Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CFC1BAEFC
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgD0UMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:12:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21028 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726803AbgD0UMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:12:48 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RK1uKJ011217
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wO+JBRTWotYxL9fxETVJzPjhb1rYBFoXXP4rsMcoHUU=;
 b=jN2ffnAY4dcUJiNkBWEGu/5zc//uHNowjlFPXrdON+06UtMXPmlH3UJ+xGaJQ/vaDDKN
 Wrh8jYWtfGNnW7hlKbOxoH1mR8eO6ESH8JbHQsmsC70FyF/+ouAuQKJP1YtIeW0U9u/l
 6jjr4DoMFAlTwF2lb1ThQUaDIzGma0ohjaQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30mk1gdyeb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:47 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:46 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 659663700871; Mon, 27 Apr 2020 13:12:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 05/19] bpf: support bpf tracing/iter programs for BPF_LINK_CREATE
Date:   Mon, 27 Apr 2020 13:12:40 -0700
Message-ID: <20200427201240.2994985-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=2 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given a bpf program, the step to create an anonymous bpf iterator is:
  - create a bpf_iter_link, which combines bpf program and the target.
    In the future, there could be more information recorded in the link.
    A link_fd will be returned to the user space.
  - create an anonymous bpf iterator with the given link_fd.

The anonymous bpf iterator (and its underlying bpf_link) will be
used to create file based bpf iterator as well.

The benefit to use of bpf_iter_link:
  - for file based bpf iterator, bpf_iter_link provides a standard
    way to replace underlying bpf programs.
  - for both anonymous and free based iterators, bpf link query
    capability can be leveraged.

The patch added support of tracing/iter programs for  BPF_LINK_CREATE.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   |  2 ++
 kernel/bpf/bpf_iter.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c  | 15 ++++++++++++
 3 files changed, 71 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4ac8d61f7c3e..60ecb73d8f6d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1034,6 +1034,7 @@ extern const struct file_operations bpf_prog_fops;
 extern const struct bpf_prog_ops bpf_offload_prog_ops;
 extern const struct bpf_verifier_ops tc_cls_act_analyzer_ops;
 extern const struct bpf_verifier_ops xdp_analyzer_ops;
+extern const struct bpf_link_ops bpf_iter_link_lops;
=20
 struct bpf_prog *bpf_prog_get(u32 ufd);
 struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
@@ -1129,6 +1130,7 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_in=
fo);
 struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_s=
ize,
 				   u64 *session_id, u64 *seq_num, bool is_last);
 int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
+int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 284c95587803..9532e7bcb8e1 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -14,6 +14,11 @@ struct bpf_iter_target_info {
 	u32 target_feature;
 };
=20
+struct bpf_iter_link {
+	struct bpf_link link;
+	struct bpf_iter_target_info *tinfo;
+};
+
 static struct list_head targets;
 static struct mutex targets_mutex;
 static bool bpf_iter_inited =3D false;
@@ -67,3 +72,52 @@ int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx=
)
=20
 	return ret;
 }
+
+static void bpf_iter_link_release(struct bpf_link *link)
+{
+}
+
+static void bpf_iter_link_dealloc(struct bpf_link *link)
+{
+}
+
+const struct bpf_link_ops bpf_iter_link_lops =3D {
+	.release =3D bpf_iter_link_release,
+	.dealloc =3D bpf_iter_link_dealloc,
+};
+
+int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og)
+{
+	struct bpf_iter_target_info *tinfo;
+	struct bpf_iter_link *link;
+	const char *func_name;
+	bool existed =3D false;
+	int err;
+
+	if (attr->link_create.target_fd || attr->link_create.flags)
+		return -EINVAL;
+
+	func_name =3D prog->aux->attach_func_name;
+	mutex_lock(&targets_mutex);
+	list_for_each_entry(tinfo, &targets, list) {
+		if (!strcmp(tinfo->target_func_name, func_name)) {
+			existed =3D true;
+			break;
+		}
+	}
+	mutex_unlock(&targets_mutex);
+	if (!existed)
+		return -ENOENT;
+
+	link =3D kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);
+	if (!link)
+		return -ENOMEM;
+
+	bpf_link_init(&link->link, &bpf_iter_link_lops, prog);
+	link->tinfo =3D tinfo;
+
+	err =3D bpf_link_new_fd(&link->link);
+	if (err < 0)
+		kfree(link);
+	return err;
+}
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 022187640943..8741b5e11c85 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2269,6 +2269,8 @@ static void bpf_link_show_fdinfo(struct seq_file *m=
, struct file *filp)
 	else if (link->ops =3D=3D &bpf_cgroup_link_lops)
 		link_type =3D "cgroup";
 #endif
+	else if (link->ops =3D=3D &bpf_iter_link_lops)
+		link_type =3D "iter";
 	else
 		link_type =3D "unknown";
=20
@@ -2597,6 +2599,8 @@ attach_type_to_prog_type(enum bpf_attach_type attac=
h_type)
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
 		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
+	case BPF_TRACE_ITER:
+		return BPF_PROG_TYPE_TRACING;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
 	}
@@ -3571,6 +3575,14 @@ static int bpf_map_do_batch(const union bpf_attr *=
attr,
 	return err;
 }
=20
+static int tracing_bpf_link_attach(const union bpf_attr *attr, struct bp=
f_prog *prog)
+{
+	if (attr->link_create.attach_type =3D=3D BPF_TRACE_ITER)
+		return bpf_iter_link_attach(attr, prog);
+
+	return -EINVAL;
+}
+
 #define BPF_LINK_CREATE_LAST_FIELD link_create.flags
 static int link_create(union bpf_attr *attr)
 {
@@ -3607,6 +3619,9 @@ static int link_create(union bpf_attr *attr)
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 		ret =3D cgroup_bpf_link_attach(attr, prog);
 		break;
+	case BPF_PROG_TYPE_TRACING:
+		ret =3D tracing_bpf_link_attach(attr, prog);
+		break;
 	default:
 		ret =3D -EINVAL;
 	}
--=20
2.24.1

