Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CD22DE94E
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 19:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgLRSvS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Dec 2020 13:51:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2704 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727207AbgLRSvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 13:51:16 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BIIjlRC011803
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 10:50:36 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35gwa89n2r-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 10:50:36 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 10:50:33 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id B671959F2C88; Fri, 18 Dec 2020 10:50:32 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>
Subject: [PATCH 3/3 v4 bpf-next] bpf: optimize task iteration
Date:   Fri, 18 Dec 2020 10:50:32 -0800
Message-ID: <20201218185032.2464558-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201218185032.2464558-1-jonathan.lemon@gmail.com>
References: <20201218185032.2464558-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_12:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=827 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 impostorscore=0 clxscore=1034 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Only obtain the task reference count at the end of the RCU section
instead of repeatedly obtaining/releasing it when iterating though
a thread group.

Jump to the correct branch when it is known that the task is NULL.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 kernel/bpf/task_iter.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index dc4007f1843b..598a8d7da5bf 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -33,7 +33,7 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
 	pid = find_ge_pid(*tid, ns);
 	if (pid) {
 		*tid = pid_nr_ns(pid, ns);
-		task = get_pid_task(pid, PIDTYPE_PID);
+		task = pid_task(pid, PIDTYPE_PID);
 		if (!task) {
 			++*tid;
 			goto retry;
@@ -44,6 +44,7 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
 			++*tid;
 			goto retry;
 		}
+		get_task_struct(task);
 	}
 	rcu_read_unlock();
 
@@ -148,12 +149,12 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
 	 * it held a reference to the task/files_struct/file.
 	 * Otherwise, it does not hold any reference.
 	 */
-again:
 	if (info->task) {
 		curr_task = info->task;
 		curr_files = info->files;
 		curr_fd = info->fd;
 	} else {
+again:
 		curr_task = task_seq_get_next(ns, &curr_tid, true);
 		if (!curr_task) {
 			info->task = NULL;
-- 
2.24.1

