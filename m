Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55734174C37
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 09:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgCAILE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 03:11:04 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14224 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbgCAILD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 03:11:03 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02188gLE021723
        for <netdev@vger.kernel.org>; Sun, 1 Mar 2020 00:11:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=fqy/hMM69CswCof3fHjes4v9fTe0x9nkdHlxBwTVflM=;
 b=jCC3rIz3MLg3Mq6BOQnU4UgPw8kVOKPTZGicFsFfiG4a9HSxSRKrnB83gughmhV+kFzM
 5Or6son23isJdh60RII41IlTN72OSwjQ+tYtRRcZKBRmnWKx/U/Ub+BVfe30NwtjRl6d
 QYrgYCaAg1Xahlo+OqzrXVG6NzdlvfmUzW0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2yfmgukern-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 00:11:01 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 1 Mar 2020 00:11:00 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6A19F2EC2D1F; Sun,  1 Mar 2020 00:10:58 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <ethercflow@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/3] tools/runqslower: simplify BPF code by using raw_tp_xxx structs
Date:   Sun, 1 Mar 2020 00:10:45 -0800
Message-ID: <20200301081045.3491005-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200301081045.3491005-1-andriin@fb.com>
References: <20200301081045.3491005-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-01_02:2020-02-28,2020-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 malwarescore=0 suspectscore=8 impostorscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003010065
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert runqslower to utilize raw_tp_xxx structs for accessing raw tracepoint
arguments.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/runqslower/runqslower.bpf.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
index 48a39f72fadf..3931ef9c9a6c 100644
--- a/tools/bpf/runqslower/runqslower.bpf.c
+++ b/tools/bpf/runqslower/runqslower.bpf.c
@@ -40,41 +40,35 @@ static int trace_enqueue(u32 tgid, u32 pid)
 }
 
 SEC("tp_btf/sched_wakeup")
-int handle__sched_wakeup(u64 *ctx)
+int handle__sched_wakeup(struct raw_tp_sched_wakeup *ctx)
 {
 	/* TP_PROTO(struct task_struct *p) */
-	struct task_struct *p = (void *)ctx[0];
-
-	return trace_enqueue(p->tgid, p->pid);
+	return trace_enqueue(ctx->p->tgid, ctx->p->pid);
 }
 
 SEC("tp_btf/sched_wakeup_new")
-int handle__sched_wakeup_new(u64 *ctx)
+int handle__sched_wakeup_new(struct raw_tp_sched_wakeup_new *ctx)
 {
 	/* TP_PROTO(struct task_struct *p) */
-	struct task_struct *p = (void *)ctx[0];
-
-	return trace_enqueue(p->tgid, p->pid);
+	return trace_enqueue(ctx->p->tgid, ctx->p->pid);
 }
 
 SEC("tp_btf/sched_switch")
-int handle__sched_switch(u64 *ctx)
+int handle__sched_switch(struct raw_tp_sched_switch *ctx)
 {
 	/* TP_PROTO(bool preempt, struct task_struct *prev,
 	 *	    struct task_struct *next)
 	 */
-	struct task_struct *prev = (struct task_struct *)ctx[1];
-	struct task_struct *next = (struct task_struct *)ctx[2];
 	struct event event = {};
 	u64 *tsp, delta_us;
 	long state;
 	u32 pid;
 
 	/* ivcsw: treat like an enqueue event and store timestamp */
-	if (prev->state == TASK_RUNNING)
-		trace_enqueue(prev->tgid, prev->pid);
+	if (ctx->prev->state == TASK_RUNNING)
+		trace_enqueue(ctx->prev->tgid, ctx->prev->pid);
 
-	pid = next->pid;
+	pid = ctx->next->pid;
 
 	/* fetch timestamp and calculate delta */
 	tsp = bpf_map_lookup_elem(&start, &pid);
-- 
2.17.1

