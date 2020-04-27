Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445F81BAF20
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgD0UNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:13:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64946 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbgD0UMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:12:49 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RK4lGc019325
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=zeF3bWVTLMmZyxmWI1DbL/bF6GSTfL6p1fvJ851ajUM=;
 b=lIfPW+mOYpmUsTskwp0LWoaFhen7D0xzxDEPw0KPgWKh3maNzmlUh5ugnajluvwPyzsz
 fbHJHMCHkA8j56ZLvTJ7wJbkTtCW9xCVHK+ZSVZmmVl1J4pqT0dygzEGmnCCLa+FO0yt
 tXrIJsIFFPblKvwgcflqbe4+BF+2Yrsg/v8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30nq53mw3f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:48 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:44 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id D8E333700871; Mon, 27 Apr 2020 13:12:42 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 07/19] bpf: create anonymous bpf iterator
Date:   Mon, 27 Apr 2020 13:12:42 -0700
Message-ID: <20200427201242.2995160-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 suspectscore=2 impostorscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new bpf command BPF_ITER_CREATE is added.

The anonymous bpf iterator is seq_file based.
The seq_file private data are referenced by targets.
The bpf_iter infrastructure allocated additional space
at seq_file->private after the space used by targets
to store some meta data, e.g.,
  prog:       prog to run
  session_id: an unique id for each opened seq_file
  seq_num:    how many times bpf programs are queried in this session
  has_last:   indicate whether or not bpf_prog has been called after
              all valid objects have been processed

A map between file and prog/link is established to help
fops->release(). When fops->release() is called, just based on
inode and file, bpf program cannot be located since target
seq_priv_size not available. This map helps retrieve the prog
whose reference count needs to be decremented.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h            |   3 +
 include/uapi/linux/bpf.h       |   6 ++
 kernel/bpf/bpf_iter.c          | 162 ++++++++++++++++++++++++++++++++-
 kernel/bpf/syscall.c           |  27 ++++++
 tools/include/uapi/linux/bpf.h |   6 ++
 5 files changed, 203 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4fc39d9b5cd0..0f0cafc65a04 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1112,6 +1112,8 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
=20
+#define BPF_DUMP_SEQ_NET_PRIVATE	BIT(0)
+
 struct bpf_iter_reg {
 	const char *target;
 	const char *target_func_name;
@@ -1133,6 +1135,7 @@ int bpf_iter_run_prog(struct bpf_prog *prog, void *=
ctx);
 int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og);
 int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_pr=
og,
 			  struct bpf_prog *new_prog);
+int bpf_iter_new_fd(struct bpf_link *link);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f39b9fec37ab..576651110d16 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -113,6 +113,7 @@ enum bpf_cmd {
 	BPF_MAP_DELETE_BATCH,
 	BPF_LINK_CREATE,
 	BPF_LINK_UPDATE,
+	BPF_ITER_CREATE,
 };
=20
 enum bpf_map_type {
@@ -590,6 +591,11 @@ union bpf_attr {
 		__u32		old_prog_fd;
 	} link_update;
=20
+	struct { /* struct used by BPF_ITER_CREATE command */
+		__u32		link_fd;
+		__u32		flags;
+	} iter_create;
+
 } __attribute__((aligned(8)));
=20
 /* The description below is an attempt at providing documentation to eBP=
F
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index fc1ce5ee5c3f..1f4e778d1814 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2020 Facebook */
=20
 #include <linux/fs.h>
+#include <linux/anon_inodes.h>
 #include <linux/filter.h>
 #include <linux/bpf.h>
=20
@@ -19,6 +20,19 @@ struct bpf_iter_link {
 	struct bpf_iter_target_info *tinfo;
 };
=20
+struct extra_priv_data {
+	struct bpf_prog *prog;
+	u64 session_id;
+	u64 seq_num;
+	bool has_last;
+};
+
+struct anon_file_prog_assoc {
+	struct list_head list;
+	struct file *file;
+	struct bpf_prog *prog;
+};
+
 static struct list_head targets;
 static struct mutex targets_mutex;
 static bool bpf_iter_inited =3D false;
@@ -26,6 +40,50 @@ static bool bpf_iter_inited =3D false;
 /* protect bpf_iter_link.link->prog upddate */
 static struct mutex bpf_iter_mutex;
=20
+/* Since at anon seq_file release function, the prog cannot
+ * be retrieved since target seq_priv_size is not available.
+ * Keep a list of <anon_file, prog> mapping, so that
+ * at file release stage, the prog can be released properly.
+ */
+static struct list_head anon_iter_info;
+static struct mutex anon_iter_info_mutex;
+
+/* incremented on every opened seq_file */
+static atomic64_t session_id;
+
+static u32 get_total_priv_dsize(u32 old_size)
+{
+	return roundup(old_size, 8) + sizeof(struct extra_priv_data);
+}
+
+static void *get_extra_priv_dptr(void *old_ptr, u32 old_size)
+{
+	return old_ptr + roundup(old_size, 8);
+}
+
+static int anon_iter_release(struct inode *inode, struct file *file)
+{
+	struct anon_file_prog_assoc *finfo;
+
+	mutex_lock(&anon_iter_info_mutex);
+	list_for_each_entry(finfo, &anon_iter_info, list) {
+		if (finfo->file =3D=3D file) {
+			bpf_prog_put(finfo->prog);
+			list_del(&finfo->list);
+			kfree(finfo);
+			break;
+		}
+	}
+	mutex_unlock(&anon_iter_info_mutex);
+
+	return seq_release_private(inode, file);
+}
+
+static const struct file_operations anon_bpf_iter_fops =3D {
+	.read		=3D seq_read,
+	.release	=3D anon_iter_release,
+};
+
 int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
 {
 	struct bpf_iter_target_info *tinfo;
@@ -37,6 +95,8 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
 		INIT_LIST_HEAD(&targets);
 		mutex_init(&targets_mutex);
 		mutex_init(&bpf_iter_mutex);
+		INIT_LIST_HEAD(&anon_iter_info);
+		mutex_init(&anon_iter_info_mutex);
 		bpf_iter_inited =3D true;
 	}
=20
@@ -61,7 +121,20 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info=
)
 struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_s=
ize,
 				   u64 *session_id, u64 *seq_num, bool is_last)
 {
-	return NULL;
+	struct extra_priv_data *extra_data;
+
+	if (seq->file->f_op !=3D &anon_bpf_iter_fops)
+		return NULL;
+
+	extra_data =3D get_extra_priv_dptr(seq->private, priv_data_size);
+	if (extra_data->has_last)
+		return NULL;
+
+	*session_id =3D extra_data->session_id;
+	*seq_num =3D extra_data->seq_num++;
+	extra_data->has_last =3D is_last;
+
+	return extra_data->prog;
 }
=20
 int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx)
@@ -150,3 +223,90 @@ int bpf_iter_link_replace(struct bpf_link *link, str=
uct bpf_prog *old_prog,
 	mutex_unlock(&bpf_iter_mutex);
 	return ret;
 }
+
+static void init_seq_file(void *priv_data, struct bpf_iter_target_info *=
tinfo,
+			  struct bpf_prog *prog)
+{
+	struct extra_priv_data *extra_data;
+
+	if (tinfo->target_feature & BPF_DUMP_SEQ_NET_PRIVATE)
+		set_seq_net_private((struct seq_net_private *)priv_data,
+				    current->nsproxy->net_ns);
+
+	extra_data =3D get_extra_priv_dptr(priv_data, tinfo->seq_priv_size);
+	extra_data->session_id =3D atomic64_add_return(1, &session_id);
+	extra_data->prog =3D prog;
+	extra_data->seq_num =3D 0;
+	extra_data->has_last =3D false;
+}
+
+static int prepare_seq_file(struct file *file, struct bpf_iter_link *lin=
k)
+{
+	struct anon_file_prog_assoc *finfo;
+	struct bpf_iter_target_info *tinfo;
+	struct bpf_prog *prog;
+	u32 total_priv_dsize;
+	void *priv_data;
+
+	finfo =3D kmalloc(sizeof(*finfo), GFP_USER | __GFP_NOWARN);
+	if (!finfo)
+		return -ENOMEM;
+
+	mutex_lock(&bpf_iter_mutex);
+	prog =3D link->link.prog;
+	bpf_prog_inc(prog);
+	mutex_unlock(&bpf_iter_mutex);
+
+	tinfo =3D link->tinfo;
+	total_priv_dsize =3D get_total_priv_dsize(tinfo->seq_priv_size);
+	priv_data =3D __seq_open_private(file, tinfo->seq_ops, total_priv_dsize=
);
+	if (!priv_data) {
+		bpf_prog_sub(prog, 1);
+		kfree(finfo);
+		return -ENOMEM;
+	}
+
+	init_seq_file(priv_data, tinfo, prog);
+
+	finfo->file =3D file;
+	finfo->prog =3D prog;
+
+	mutex_lock(&anon_iter_info_mutex);
+	list_add(&finfo->list, &anon_iter_info);
+	mutex_unlock(&anon_iter_info_mutex);
+	return 0;
+}
+
+int bpf_iter_new_fd(struct bpf_link *link)
+{
+	struct file *file;
+	int err, fd;
+
+	if (link->ops !=3D &bpf_iter_link_lops)
+		return -EINVAL;
+
+	fd =3D get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	file =3D anon_inode_getfile("bpf_iter", &anon_bpf_iter_fops,
+				  NULL, O_CLOEXEC);
+	if (IS_ERR(file)) {
+		err =3D PTR_ERR(file);
+		goto free_fd;
+	}
+
+	err =3D prepare_seq_file(file,
+			       container_of(link, struct bpf_iter_link, link));
+	if (err)
+		goto free_file;
+
+	fd_install(fd, file);
+	return fd;
+
+free_file:
+	fput(file);
+free_fd:
+	put_unused_fd(fd);
+	return err;
+}
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b7af4f006f2e..458f7000887a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3696,6 +3696,30 @@ static int link_update(union bpf_attr *attr)
 	return ret;
 }
=20
+#define BPF_ITER_CREATE_LAST_FIELD iter_create.flags
+
+static int bpf_iter_create(union bpf_attr *attr)
+{
+	struct bpf_link *link;
+	int err;
+
+	if (CHECK_ATTR(BPF_ITER_CREATE))
+		return -EINVAL;
+
+	if (attr->iter_create.flags)
+		return -EINVAL;
+
+	link =3D bpf_link_get_from_fd(attr->iter_create.link_fd);
+	if (IS_ERR(link))
+		return PTR_ERR(link);
+
+	err =3D bpf_iter_new_fd(link);
+	if (err < 0)
+		bpf_link_put(link);
+
+	return err;
+}
+
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned =
int, size)
 {
 	union bpf_attr attr;
@@ -3813,6 +3837,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __use=
r *, uattr, unsigned int, siz
 	case BPF_LINK_UPDATE:
 		err =3D link_update(&attr);
 		break;
+	case BPF_ITER_CREATE:
+		err =3D bpf_iter_create(&attr);
+		break;
 	default:
 		err =3D -EINVAL;
 		break;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index f39b9fec37ab..576651110d16 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -113,6 +113,7 @@ enum bpf_cmd {
 	BPF_MAP_DELETE_BATCH,
 	BPF_LINK_CREATE,
 	BPF_LINK_UPDATE,
+	BPF_ITER_CREATE,
 };
=20
 enum bpf_map_type {
@@ -590,6 +591,11 @@ union bpf_attr {
 		__u32		old_prog_fd;
 	} link_update;
=20
+	struct { /* struct used by BPF_ITER_CREATE command */
+		__u32		link_fd;
+		__u32		flags;
+	} iter_create;
+
 } __attribute__((aligned(8)));
=20
 /* The description below is an attempt at providing documentation to eBP=
F
--=20
2.24.1

