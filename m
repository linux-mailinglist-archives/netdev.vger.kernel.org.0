Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF60825540F
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 07:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgH1FiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 01:38:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1302 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbgH1FiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 01:38:25 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07S5YbPd017950
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 22:38:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7peYEjyhnzMmgxG5vYKz2iizvXpy1AzyrGz0onw9ewc=;
 b=KyITV6mgOAz/gotSuhKSP5E8xfk6gMrRR1r0tWAxA95v9tEW0c3N7VwtTu4ye415amcO
 wPeerTsOfSYabnkQ8l9czE1KYJ7nvImvY/jCiPXVd5JRfproBeMBVByxw8w2d4rrHyYl
 e99L2+ugBO3618YDEX30Qx3re7aX3ivId88= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 335up7sd4c-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 22:38:22 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 27 Aug 2020 22:38:20 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id E1306370587B; Thu, 27 Aug 2020 22:38:15 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 1/2] bpf: avoid iterating duplicated files for task_file iterator
Date:   Thu, 27 Aug 2020 22:38:15 -0700
Message-ID: <20200828053815.817806-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200828053815.817726-1-yhs@fb.com>
References: <20200828053815.817726-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-28_03:2020-08-27,2020-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 suspectscore=8 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008280046
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, task_file iterator iterates all files from all tasks.
This may potentially visit a lot of duplicated files if there are
many tasks sharing the same files, e.g., typical pthreads
where these pthreads and the main thread are sharing the same files.

This patch changed task_file iterator to skip a particular task
if that task shares the same files as its group_leader (the task
having the same tgid and also task->tgid =3D=3D task->pid).
This will preserve the same result, visiting all files from all
tasks, and will reduce runtime cost significantl, e.g., if there are
a lot of pthreads and the process has a lot of open files.

Suggested-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/task_iter.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

It would be good if somebody familar with sched code can help check
whether I missed anything or not (e.g., locks, etc.)
for the code change
  task->files =3D=3D task->group_leader->files

Note the change in this patch might have conflicts with
e60572b8d4c3 ("bpf: Avoid visit same object multiple times")
which is merged into bpf/net sometimes back.

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 232df29793e9..0c5c96bb6964 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -22,7 +22,8 @@ struct bpf_iter_seq_task_info {
 };
=20
 static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
-					     u32 *tid)
+					     u32 *tid,
+					     bool skip_if_dup_files)
 {
 	struct task_struct *task =3D NULL;
 	struct pid *pid;
@@ -32,7 +33,10 @@ static struct task_struct *task_seq_get_next(struct pi=
d_namespace *ns,
 	pid =3D idr_get_next(&ns->idr, tid);
 	if (pid) {
 		task =3D get_pid_task(pid, PIDTYPE_PID);
-		if (!task) {
+		if (!task ||
+		    (skip_if_dup_files &&
+		     task->tgid !=3D task->pid &&
+		     task->files =3D=3D task->group_leader->files)) {
 			++*tid;
 			goto retry;
 		}
@@ -47,7 +51,7 @@ static void *task_seq_start(struct seq_file *seq, loff_=
t *pos)
 	struct bpf_iter_seq_task_info *info =3D seq->private;
 	struct task_struct *task;
=20
-	task =3D task_seq_get_next(info->common.ns, &info->tid);
+	task =3D task_seq_get_next(info->common.ns, &info->tid, false);
 	if (!task)
 		return NULL;
=20
@@ -64,7 +68,7 @@ static void *task_seq_next(struct seq_file *seq, void *=
v, loff_t *pos)
 	++*pos;
 	++info->tid;
 	put_task_struct((struct task_struct *)v);
-	task =3D task_seq_get_next(info->common.ns, &info->tid);
+	task =3D task_seq_get_next(info->common.ns, &info->tid, false);
 	if (!task)
 		return NULL;
=20
@@ -147,7 +151,7 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_=
info *info,
 		curr_files =3D *fstruct;
 		curr_fd =3D info->fd;
 	} else {
-		curr_task =3D task_seq_get_next(ns, &curr_tid);
+		curr_task =3D task_seq_get_next(ns, &curr_tid, true);
 		if (!curr_task)
 			return NULL;
=20
--=20
2.24.1

