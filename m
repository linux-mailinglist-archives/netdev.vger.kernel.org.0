Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1103B25A307
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 04:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgIBCbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 22:31:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6982 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbgIBCbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 22:31:23 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0822UDpV026137
        for <netdev@vger.kernel.org>; Tue, 1 Sep 2020 19:31:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=mq0ef9jOqeU3dqaAcGpJaqz/OttVubZ/GMgdk24nemU=;
 b=o4Zj6EorNZ8UeAlGKIuwyxMpuzkzJk9wyKsdNvU49bth+yHZ+KO6tnQSquxEFDt2OaIQ
 040pzK9o04llFZlISGxbHTwL9CFmzn/9UavjIBw7AhRpdnThIbDfmuCRlLWCf5O57ms8
 ARQp87fL3RygKoorXnO6jIzsnfzHzwSEjYE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 339ws49d88-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 19:31:22 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Sep 2020 19:31:22 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 604C937054B8; Tue,  1 Sep 2020 19:31:12 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH bpf-next v4 1/2] bpf: avoid iterating duplicated files for task_file iterator
Date:   Tue, 1 Sep 2020 19:31:12 -0700
Message-ID: <20200902023112.1672792-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200902023112.1672735-1-yhs@fb.com>
References: <20200902023112.1672735-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_02:2020-09-01,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 suspectscore=8 bulkscore=0 priorityscore=1501 mlxlogscore=999
 phishscore=0 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020022
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
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/task_iter.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 99af4cea1102..5b6af30bfbcd 100644
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
@@ -36,6 +37,12 @@ static struct task_struct *task_seq_get_next(struct pi=
d_namespace *ns,
 		if (!task) {
 			++*tid;
 			goto retry;
+		} else if (skip_if_dup_files && task->tgid !=3D task->pid &&
+			   task->files =3D=3D task->group_leader->files) {
+			put_task_struct(task);
+			task =3D NULL;
+			++*tid;
+			goto retry;
 		}
 	}
 	rcu_read_unlock();
@@ -48,7 +55,7 @@ static void *task_seq_start(struct seq_file *seq, loff_=
t *pos)
 	struct bpf_iter_seq_task_info *info =3D seq->private;
 	struct task_struct *task;
=20
-	task =3D task_seq_get_next(info->common.ns, &info->tid);
+	task =3D task_seq_get_next(info->common.ns, &info->tid, false);
 	if (!task)
 		return NULL;
=20
@@ -65,7 +72,7 @@ static void *task_seq_next(struct seq_file *seq, void *=
v, loff_t *pos)
 	++*pos;
 	++info->tid;
 	put_task_struct((struct task_struct *)v);
-	task =3D task_seq_get_next(info->common.ns, &info->tid);
+	task =3D task_seq_get_next(info->common.ns, &info->tid, false);
 	if (!task)
 		return NULL;
=20
@@ -148,7 +155,7 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_=
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

