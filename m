Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE321CC38F
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 20:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgEIR7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:59:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47248 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728365AbgEIR7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:59:10 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049HsvfI007973
        for <netdev@vger.kernel.org>; Sat, 9 May 2020 10:59:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8rJOB/D3gfwpTozLG/aw2r8gH788BQ5x0aWrNBQ3QnI=;
 b=NcjgVtHxeciHhErf0PdQBru5GLYt8T4Aboy4hjywUjGdFwJiT65jrSaRA4UMirDBP0ZX
 xrdVJR1HAU40qY/bHyn/zHsj16Yckr0O54a9cz/OKjqiwJadGcJ4OLq4WaVBm7tpXOFo
 3dZaYOSNBnK/9CLW8dZlWmXMbXSz3KG3qlg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30wsca1h87-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 10:59:08 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 10:59:08 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 7825237008E2; Sat,  9 May 2020 10:59:05 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 06/21] bpf: create anonymous bpf iterator
Date:   Sat, 9 May 2020 10:59:05 -0700
Message-ID: <20200509175905.2475770-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200509175859.2474608-1-yhs@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_06:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=2 spamscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new bpf command BPF_ITER_CREATE is added.

The anonymous bpf iterator is seq_file based.
The seq_file private data are referenced by targets.
The bpf_iter infrastructure allocated additional space
at seq_file->private before the space used by targets
to store some meta data, e.g.,
  prog:       prog to run
  session_id: an unique id for each opened seq_file
  seq_num:    how many times bpf programs are queried in this session
  done_stop:  an internal state to decide whether bpf program
              should be called in seq_ops->stop() or not

The seq_num will start from 0 for valid objects.
The bpf program may see the same seq_num more than once if
 - seq_file buffer overflow happens and the same object
   is retried by bpf_seq_read(), or
 - the bpf program explicitly requests a retry of the
   same object

Since module is not supported for bpf_iter, all target
registeration happens at __init time, so there is no
need to change bpf_iter_unreg_target() as it is used
mostly in error path of the init function at which time
no bpf iterators have been created yet.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h            |   1 +
 include/uapi/linux/bpf.h       |   6 ++
 kernel/bpf/bpf_iter.c          | 129 +++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |  26 +++++++
 tools/include/uapi/linux/bpf.h |   6 ++
 5 files changed, 168 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e93d2d33c82c..80b1b9d8a638 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1144,6 +1144,7 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_in=
fo);
 void bpf_iter_unreg_target(const char *target);
 bool bpf_iter_prog_supported(struct bpf_prog *prog);
 int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og);
+int bpf_iter_new_fd(struct bpf_link *link);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1e8dfff5d5d4..708763f702e1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -116,6 +116,7 @@ enum bpf_cmd {
 	BPF_LINK_GET_FD_BY_ID,
 	BPF_LINK_GET_NEXT_ID,
 	BPF_ENABLE_STATS,
+	BPF_ITER_CREATE,
 };
=20
 enum bpf_map_type {
@@ -614,6 +615,11 @@ union bpf_attr {
 		__u32		type;
 	} enable_stats;
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
index 832973ee80fa..e7129b57865f 100644
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
@@ -20,12 +21,24 @@ struct bpf_iter_link {
 	struct bpf_iter_target_info *tinfo;
 };
=20
+struct bpf_iter_priv_data {
+	struct bpf_iter_target_info *tinfo;
+	struct bpf_prog *prog;
+	u64 session_id;
+	u64 seq_num;
+	bool done_stop;
+	u8 target_private[] __aligned(8);
+};
+
 static struct list_head targets =3D LIST_HEAD_INIT(targets);
 static DEFINE_MUTEX(targets_mutex);
=20
 /* protect bpf_iter_link changes */
 static DEFINE_MUTEX(link_mutex);
=20
+/* incremented on every opened seq_file */
+static atomic64_t session_id;
+
 /* bpf_seq_read, a customized and simpler version for bpf iterator.
  * no_llseek is assumed for this file.
  * The following are differences from seq_read():
@@ -149,6 +162,33 @@ static ssize_t bpf_seq_read(struct file *file, char =
__user *buf, size_t size,
 	return copied;
 }
=20
+static int iter_release(struct inode *inode, struct file *file)
+{
+	struct bpf_iter_priv_data *iter_priv;
+	struct seq_file *seq;
+
+	seq =3D file->private_data;
+	if (!seq)
+		return 0;
+
+	iter_priv =3D container_of(seq->private, struct bpf_iter_priv_data,
+				 target_private);
+
+	if (iter_priv->tinfo->fini_seq_private)
+		iter_priv->tinfo->fini_seq_private(seq->private);
+
+	bpf_prog_put(iter_priv->prog);
+	seq->private =3D iter_priv;
+
+	return seq_release_private(inode, file);
+}
+
+static const struct file_operations bpf_iter_fops =3D {
+	.llseek		=3D no_llseek,
+	.read		=3D bpf_seq_read,
+	.release	=3D iter_release,
+};
+
 int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
 {
 	struct bpf_iter_target_info *tinfo;
@@ -309,3 +349,92 @@ int bpf_iter_link_attach(const union bpf_attr *attr,=
 struct bpf_prog *prog)
=20
 	return bpf_link_settle(&link_primer);
 }
+
+static void init_seq_meta(struct bpf_iter_priv_data *priv_data,
+			  struct bpf_iter_target_info *tinfo,
+			  struct bpf_prog *prog)
+{
+	priv_data->tinfo =3D tinfo;
+	priv_data->prog =3D prog;
+	priv_data->session_id =3D atomic64_inc_return(&session_id);
+	priv_data->seq_num =3D 0;
+	priv_data->done_stop =3D false;
+}
+
+static int prepare_seq_file(struct file *file, struct bpf_iter_link *lin=
k)
+{
+	struct bpf_iter_priv_data *priv_data;
+	struct bpf_iter_target_info *tinfo;
+	struct bpf_prog *prog;
+	u32 total_priv_dsize;
+	struct seq_file *seq;
+	int err =3D 0;
+
+	mutex_lock(&link_mutex);
+	prog =3D link->link.prog;
+	bpf_prog_inc(prog);
+	mutex_unlock(&link_mutex);
+
+	tinfo =3D link->tinfo;
+	total_priv_dsize =3D offsetof(struct bpf_iter_priv_data, target_private=
) +
+			   tinfo->seq_priv_size;
+	priv_data =3D __seq_open_private(file, tinfo->seq_ops, total_priv_dsize=
);
+	if (!priv_data) {
+		err =3D -ENOMEM;
+		goto release_prog;
+	}
+
+	if (tinfo->init_seq_private) {
+		err =3D tinfo->init_seq_private(priv_data->target_private);
+		if (err)
+			goto release_seq_file;
+	}
+
+	init_seq_meta(priv_data, tinfo, prog);
+	seq =3D file->private_data;
+	seq->private =3D priv_data->target_private;
+
+	return 0;
+
+release_seq_file:
+	seq_release_private(file->f_inode, file);
+	file->private_data =3D NULL;
+release_prog:
+	bpf_prog_put(prog);
+	return err;
+}
+
+int bpf_iter_new_fd(struct bpf_link *link)
+{
+	struct file *file;
+	unsigned int flags;
+	int err, fd;
+
+	if (link->ops !=3D &bpf_iter_link_lops)
+		return -EINVAL;
+
+	flags =3D O_RDONLY | O_CLOEXEC;
+	fd =3D get_unused_fd_flags(flags);
+	if (fd < 0)
+		return fd;
+
+	file =3D anon_inode_getfile("bpf_iter", &bpf_iter_fops, NULL, flags);
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
index 6ffe2d8fb6c7..a293e88ee01a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3941,6 +3941,29 @@ static int bpf_enable_stats(union bpf_attr *attr)
 	return -EINVAL;
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
+	bpf_link_put(link);
+
+	return err;
+}
+
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned =
int, size)
 {
 	union bpf_attr attr;
@@ -4068,6 +4091,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __use=
r *, uattr, unsigned int, siz
 	case BPF_ENABLE_STATS:
 		err =3D bpf_enable_stats(&attr);
 		break;
+	case BPF_ITER_CREATE:
+		err =3D bpf_iter_create(&attr);
+		break;
 	default:
 		err =3D -EINVAL;
 		break;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 1e8dfff5d5d4..708763f702e1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -116,6 +116,7 @@ enum bpf_cmd {
 	BPF_LINK_GET_FD_BY_ID,
 	BPF_LINK_GET_NEXT_ID,
 	BPF_ENABLE_STATS,
+	BPF_ITER_CREATE,
 };
=20
 enum bpf_map_type {
@@ -614,6 +615,11 @@ union bpf_attr {
 		__u32		type;
 	} enable_stats;
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

