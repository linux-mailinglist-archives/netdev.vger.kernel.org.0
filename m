Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B82F2CE142
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 23:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgLCV7v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Dec 2020 16:59:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36990 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728177AbgLCV7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 16:59:51 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3LrtMi016676
        for <netdev@vger.kernel.org>; Thu, 3 Dec 2020 13:59:09 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 356ajcmjdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 13:59:09 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 13:59:08 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 5F4754D64717; Thu,  3 Dec 2020 13:59:07 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH bpf-next] bpf: increment and use correct thread iterator
Date:   Thu, 3 Dec 2020 13:59:07 -0800
Message-ID: <20201203215907.975053-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_12:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=661 malwarescore=0
 bulkscore=0 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

If unable to obtain the file structure for the current task,
proceed to the next task number after the one returned from
task_seq_get_next(), instead of the next task number from the
original iterator.

Use thread_group_leader() instead of comparing tgid vs pid, which
might may be racy.

Only obtain the task reference count at the end of the RCU section
instead of repeatedly obtaining/releasing it when iterathing though
a thread group.

This patch fixes a recurring RCU stall seen from task_file_seq_next().

Fixes: a650da2ee52a ("bpf: Add task and task/file iterator targets")
Fixes: 67b6b863e6ab ("bpf: Avoid iterating duplicated files for task_file iterator")

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 kernel/bpf/task_iter.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 0458a40edf10..66a52fcf589a 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -33,17 +33,17 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
 	pid = find_ge_pid(*tid, ns);
 	if (pid) {
 		*tid = pid_nr_ns(pid, ns);
-		task = get_pid_task(pid, PIDTYPE_PID);
+		task = pid_task(pid, PIDTYPE_PID);
 		if (!task) {
 			++*tid;
 			goto retry;
-		} else if (skip_if_dup_files && task->tgid != task->pid &&
+		} else if (skip_if_dup_files && !thread_group_leader(task) &&
 			   task->files == task->group_leader->files) {
-			put_task_struct(task);
 			task = NULL;
 			++*tid;
 			goto retry;
 		}
+		get_task_struct(task);
 	}
 	rcu_read_unlock();
 
@@ -164,7 +164,7 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
 		curr_files = get_files_struct(curr_task);
 		if (!curr_files) {
 			put_task_struct(curr_task);
-			curr_tid = ++(info->tid);
+			curr_tid = curr_tid + 1;
 			info->fd = 0;
 			goto again;
 		}
-- 
2.24.1

