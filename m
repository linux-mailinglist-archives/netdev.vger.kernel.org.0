Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54DF253AD9
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 02:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgH0AGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 20:06:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39892 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbgH0AG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 20:06:27 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R05Whu032129
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:06:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZCRr2uHYbaNACCigjH5orYMe3ngORjEcy/ZuvQdfQDM=;
 b=mRc6ahy2u7AVlJd7QCBTBu4T0dLG31yf26cYeTThbinLCF47VYEIqYCGJHYQOhwFpi4q
 oA06GC7NASIN13KxBZLjgLfU3mlWh5r7UIKmG20bgEQDYCZUP5BZr1D9lyTnp4rtOXIi
 hqAcseuklyV77ITKKZmYp1AZunVBg9q9JLE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 335up8jbxu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:06:26 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 26 Aug 2020 17:06:25 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 900C637052E0; Wed, 26 Aug 2020 17:06:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/5] bpf: add main_thread_only customization for task/task_file iterators
Date:   Wed, 26 Aug 2020 17:06:20 -0700
Message-ID: <20200827000620.2711963-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200827000618.2711826-1-yhs@fb.com>
References: <20200827000618.2711826-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-26_14:2020-08-26,2020-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, task and task_file by default iterates through
all tasks. For task_file, by default, all files from all tasks
will be traversed.

But for a user process, the file_table is shared by all threads
of that process. So traversing the main thread per process should
be enough to traverse all files and this can save a lot of cpu
time if some process has large number of threads and each thread
has lots of open files.

This patch implemented a customization for task/task_file iterator,
permitting to traverse only the kernel task where its pid equal
to tgid in the kernel. This includes some kernel threads, and
main threads of user processes. This will solve the above potential
performance issue for task_file. This customization may be useful
for task iterator too if only traversing main threads is enough.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h            |  3 ++-
 include/uapi/linux/bpf.h       |  5 ++++
 kernel/bpf/task_iter.c         | 46 +++++++++++++++++++++++-----------
 tools/include/uapi/linux/bpf.h |  5 ++++
 4 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a6131d95e31e..058eb9b0ba78 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1220,7 +1220,8 @@ int bpf_obj_get_user(const char __user *pathname, i=
nt flags);
 	int __init bpf_iter_ ## target(args) { return 0; }
=20
 struct bpf_iter_aux_info {
-	struct bpf_map *map;
+	struct bpf_map *map;	/* for iterator traversing map elements */
+	bool main_thread_only;	/* for task/task_file iterator */
 };
=20
 typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ef7af384f5ee..af5c600bf673 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -85,6 +85,11 @@ union bpf_iter_link_info {
 	struct {
 		__u32	map_fd;
 	} map;
+
+	struct {
+		__u32	main_thread_only:1;
+		__u32	:31;
+	} task;
 };
=20
 /* BPF syscall commands, see bpf(2) man-page for details. */
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 232df29793e9..362bf2dda63a 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -11,19 +11,22 @@
=20
 struct bpf_iter_seq_task_common {
 	struct pid_namespace *ns;
+	bool main_thread_only;
 };
=20
 struct bpf_iter_seq_task_info {
 	/* The first field must be struct bpf_iter_seq_task_common.
-	 * this is assumed by {init, fini}_seq_pidns() callback functions.
+	 * this is assumed by {init, fini}_seq_task_common() callback functions=
.
 	 */
 	struct bpf_iter_seq_task_common common;
 	u32 tid;
 };
=20
-static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
-					     u32 *tid)
+static struct task_struct *task_seq_get_next(
+	struct bpf_iter_seq_task_common *task_common, u32 *tid)
 {
+	bool main_thread_only =3D task_common->main_thread_only;
+	struct pid_namespace *ns =3D task_common->ns;
 	struct task_struct *task =3D NULL;
 	struct pid *pid;
=20
@@ -31,7 +34,10 @@ static struct task_struct *task_seq_get_next(struct pi=
d_namespace *ns,
 retry:
 	pid =3D idr_get_next(&ns->idr, tid);
 	if (pid) {
-		task =3D get_pid_task(pid, PIDTYPE_PID);
+		if (main_thread_only)
+			task =3D get_pid_task(pid, PIDTYPE_TGID);
+		else
+			task =3D get_pid_task(pid, PIDTYPE_PID);
 		if (!task) {
 			++*tid;
 			goto retry;
@@ -47,7 +53,7 @@ static void *task_seq_start(struct seq_file *seq, loff_=
t *pos)
 	struct bpf_iter_seq_task_info *info =3D seq->private;
 	struct task_struct *task;
=20
-	task =3D task_seq_get_next(info->common.ns, &info->tid);
+	task =3D task_seq_get_next(&info->common, &info->tid);
 	if (!task)
 		return NULL;
=20
@@ -64,7 +70,7 @@ static void *task_seq_next(struct seq_file *seq, void *=
v, loff_t *pos)
 	++*pos;
 	++info->tid;
 	put_task_struct((struct task_struct *)v);
-	task =3D task_seq_get_next(info->common.ns, &info->tid);
+	task =3D task_seq_get_next(&info->common, &info->tid);
 	if (!task)
 		return NULL;
=20
@@ -118,7 +124,7 @@ static const struct seq_operations task_seq_ops =3D {
=20
 struct bpf_iter_seq_task_file_info {
 	/* The first field must be struct bpf_iter_seq_task_common.
-	 * this is assumed by {init, fini}_seq_pidns() callback functions.
+	 * this is assumed by {init, fini}_seq_task_common() callback functions=
.
 	 */
 	struct bpf_iter_seq_task_common common;
 	struct task_struct *task;
@@ -131,7 +137,6 @@ static struct file *
 task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info,
 		       struct task_struct **task, struct files_struct **fstruct)
 {
-	struct pid_namespace *ns =3D info->common.ns;
 	u32 curr_tid =3D info->tid, max_fds;
 	struct files_struct *curr_files;
 	struct task_struct *curr_task;
@@ -147,7 +152,7 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_=
info *info,
 		curr_files =3D *fstruct;
 		curr_fd =3D info->fd;
 	} else {
-		curr_task =3D task_seq_get_next(ns, &curr_tid);
+		curr_task =3D task_seq_get_next(&info->common, &curr_tid);
 		if (!curr_task)
 			return NULL;
=20
@@ -293,15 +298,16 @@ static void task_file_seq_stop(struct seq_file *seq=
, void *v)
 	}
 }
=20
-static int init_seq_pidns(void *priv_data, struct bpf_iter_aux_info *aux=
)
+static int init_seq_task_common(void *priv_data, struct bpf_iter_aux_inf=
o *aux)
 {
 	struct bpf_iter_seq_task_common *common =3D priv_data;
=20
 	common->ns =3D get_pid_ns(task_active_pid_ns(current));
+	common->main_thread_only =3D aux->main_thread_only;
 	return 0;
 }
=20
-static void fini_seq_pidns(void *priv_data)
+static void fini_seq_task_common(void *priv_data)
 {
 	struct bpf_iter_seq_task_common *common =3D priv_data;
=20
@@ -315,19 +321,28 @@ static const struct seq_operations task_file_seq_op=
s =3D {
 	.show	=3D task_file_seq_show,
 };
=20
+static int bpf_iter_attach_task(struct bpf_prog *prog,
+				union bpf_iter_link_info *linfo,
+				struct bpf_iter_aux_info *aux)
+{
+	aux->main_thread_only =3D linfo->task.main_thread_only;
+	return 0;
+}
+
 BTF_ID_LIST(btf_task_file_ids)
 BTF_ID(struct, task_struct)
 BTF_ID(struct, file)
=20
 static const struct bpf_iter_seq_info task_seq_info =3D {
 	.seq_ops		=3D &task_seq_ops,
-	.init_seq_private	=3D init_seq_pidns,
-	.fini_seq_private	=3D fini_seq_pidns,
+	.init_seq_private	=3D init_seq_task_common,
+	.fini_seq_private	=3D fini_seq_task_common,
 	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_info),
 };
=20
 static struct bpf_iter_reg task_reg_info =3D {
 	.target			=3D "task",
+	.attach_target		=3D bpf_iter_attach_task,
 	.ctx_arg_info_size	=3D 1,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__task, task),
@@ -338,13 +353,14 @@ static struct bpf_iter_reg task_reg_info =3D {
=20
 static const struct bpf_iter_seq_info task_file_seq_info =3D {
 	.seq_ops		=3D &task_file_seq_ops,
-	.init_seq_private	=3D init_seq_pidns,
-	.fini_seq_private	=3D fini_seq_pidns,
+	.init_seq_private	=3D init_seq_task_common,
+	.fini_seq_private	=3D fini_seq_task_common,
 	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_file_info),
 };
=20
 static struct bpf_iter_reg task_file_reg_info =3D {
 	.target			=3D "task_file",
+	.attach_target		=3D bpf_iter_attach_task,
 	.ctx_arg_info_size	=3D 2,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__task_file, task),
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index ef7af384f5ee..af5c600bf673 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -85,6 +85,11 @@ union bpf_iter_link_info {
 	struct {
 		__u32	map_fd;
 	} map;
+
+	struct {
+		__u32	main_thread_only:1;
+		__u32	:31;
+	} task;
 };
=20
 /* BPF syscall commands, see bpf(2) man-page for details. */
--=20
2.24.1

