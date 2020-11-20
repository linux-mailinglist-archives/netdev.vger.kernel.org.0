Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08142B9F51
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgKTA2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:28:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62990 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726154AbgKTA2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 19:28:52 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK0Q4qK016672
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 16:28:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=kbH3ZmbbR7eue/JJn9A8RV6K2EMK4XV0e6KVQ9MkccU=;
 b=WAufQDpOJ0CGgB6TyZa93Hohr6wKERyTF/xHAzYEXJiET7vxinRbQz7mLsAvkecVYJ0l
 yXQ9gIkOMwO3fGMJao1Y+xK3epLrRgYe3AD80uGxIzV99/3IgD1hvlTDQrgY//OyIIPO
 pZ9JVGU8BOL1Czqmjt/CxYtRNXZ0S9vOIdQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34wjmxf4jp-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 16:28:50 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 16:28:50 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id D138262E589C; Thu, 19 Nov 2020 16:28:46 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kpsingh@chromium.org>,
        <john.fastabend@gmail.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next] bpf: simplify task_file_seq_get_next()
Date:   Thu, 19 Nov 2020 16:28:33 -0800
Message-ID: <20201120002833.2481110-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxlogscore=980 malwarescore=0 adultscore=0 clxscore=1015
 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=8
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify task_file_seq_get_next() by removing two in/out arguments: task
and fstruct. Use info->task and info->files instead.

Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/task_iter.c | 53 ++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 36 deletions(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 1fdb2fc196cd9..7e15ca802988a 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -136,8 +136,7 @@ struct bpf_iter_seq_task_file_info {
 };
=20
 static struct file *
-task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info,
-		       struct task_struct **task, struct files_struct **fstruct)
+task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
 {
 	struct pid_namespace *ns =3D info->common.ns;
 	u32 curr_tid =3D info->tid, max_fds;
@@ -150,14 +149,17 @@ task_file_seq_get_next(struct bpf_iter_seq_task_fil=
e_info *info,
 	 * Otherwise, it does not hold any reference.
 	 */
 again:
-	if (*task) {
-		curr_task =3D *task;
-		curr_files =3D *fstruct;
+	if (info->task) {
+		curr_task =3D info->task;
+		curr_files =3D info->files;
 		curr_fd =3D info->fd;
 	} else {
 		curr_task =3D task_seq_get_next(ns, &curr_tid, true);
-		if (!curr_task)
+		if (!curr_task) {
+			info->task =3D NULL;
+			info->files =3D NULL;
 			return NULL;
+		}
=20
 		curr_files =3D get_files_struct(curr_task);
 		if (!curr_files) {
@@ -168,8 +170,8 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_=
info *info,
 		}
=20
 		/* set *fstruct, *task and info->tid */
-		*fstruct =3D curr_files;
-		*task =3D curr_task;
+		info->files =3D curr_files;
+		info->task =3D curr_task;
 		if (curr_tid =3D=3D info->tid) {
 			curr_fd =3D info->fd;
 		} else {
@@ -199,8 +201,8 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_=
info *info,
 	rcu_read_unlock();
 	put_files_struct(curr_files);
 	put_task_struct(curr_task);
-	*task =3D NULL;
-	*fstruct =3D NULL;
+	info->task =3D NULL;
+	info->files =3D NULL;
 	info->fd =3D 0;
 	curr_tid =3D ++(info->tid);
 	goto again;
@@ -209,21 +211,13 @@ task_file_seq_get_next(struct bpf_iter_seq_task_fil=
e_info *info,
 static void *task_file_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct bpf_iter_seq_task_file_info *info =3D seq->private;
-	struct files_struct *files =3D NULL;
-	struct task_struct *task =3D NULL;
 	struct file *file;
=20
-	file =3D task_file_seq_get_next(info, &task, &files);
-	if (!file) {
-		info->files =3D NULL;
-		info->task =3D NULL;
-		return NULL;
-	}
-
-	if (*pos =3D=3D 0)
+	info->task =3D NULL;
+	info->files =3D NULL;
+	file =3D task_file_seq_get_next(info);
+	if (file && *pos =3D=3D 0)
 		++*pos;
-	info->task =3D task;
-	info->files =3D files;
=20
 	return file;
 }
@@ -231,24 +225,11 @@ static void *task_file_seq_start(struct seq_file *s=
eq, loff_t *pos)
 static void *task_file_seq_next(struct seq_file *seq, void *v, loff_t *p=
os)
 {
 	struct bpf_iter_seq_task_file_info *info =3D seq->private;
-	struct files_struct *files =3D info->files;
-	struct task_struct *task =3D info->task;
-	struct file *file;
=20
 	++*pos;
 	++info->fd;
 	fput((struct file *)v);
-	file =3D task_file_seq_get_next(info, &task, &files);
-	if (!file) {
-		info->files =3D NULL;
-		info->task =3D NULL;
-		return NULL;
-	}
-
-	info->task =3D task;
-	info->files =3D files;
-
-	return file;
+	return task_file_seq_get_next(info);
 }
=20
 struct bpf_iter__task_file {
--=20
2.24.1

