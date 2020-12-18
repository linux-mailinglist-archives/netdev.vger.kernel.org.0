Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5892DE952
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 19:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgLRSvV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Dec 2020 13:51:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62898 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727297AbgLRSvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 13:51:19 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BIImoLk031023
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 10:50:37 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35g0vv127n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 10:50:37 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 10:50:36 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id B194259F2C86; Fri, 18 Dec 2020 10:50:32 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>
Subject: [PATCH 2/3 v4 bpf-next] bpf: Use thread_group_leader()
Date:   Fri, 18 Dec 2020 10:50:31 -0800
Message-ID: <20201218185032.2464558-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201218185032.2464558-1-jonathan.lemon@gmail.com>
References: <20201218185032.2464558-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_12:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 clxscore=1034 malwarescore=0 bulkscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=707 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012180127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Instead of directly comparing task->tgid and task->pid, use the
thread_group_leader() helper.  This helps with readability, and
there should be no functional change.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 kernel/bpf/task_iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 8033ab19138a..dc4007f1843b 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -37,7 +37,7 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
 		if (!task) {
 			++*tid;
 			goto retry;
-		} else if (skip_if_dup_files && task->tgid != task->pid &&
+		} else if (skip_if_dup_files && !thread_group_leader(task) &&
 			   task->files == task->group_leader->files) {
 			put_task_struct(task);
 			task = NULL;
-- 
2.24.1

