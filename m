Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272944EB69F
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 01:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239806AbiC2XVA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Mar 2022 19:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238110AbiC2XU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 19:20:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB6543ECC
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 16:19:15 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 22TMcv5C023845
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 16:19:14 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3f3ta8xvyt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 16:19:14 -0700
Received: from twshared5730.23.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 29 Mar 2022 16:19:13 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 4850045F368E; Tue, 29 Mar 2022 16:19:05 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <song@kernel.org>
Subject: [PATCH bpf] tools/runqslower: fix handle__sched_switch for updated tp sched_switch
Date:   Tue, 29 Mar 2022 16:18:54 -0700
Message-ID: <20220329231854.3188647-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tXFN2lXNr1XFAaJccNUzL69DmACQRrl1
X-Proofpoint-GUID: tXFN2lXNr1XFAaJccNUzL69DmACQRrl1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-29_10,2022-03-29_01,2022-02-23_01
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TP_PROTO of sched_switch is updated with a new arg prev_state, which
causes runqslower load failure:

libbpf: prog 'handle__sched_switch': BPF program load failed: Permission denied
libbpf: prog 'handle__sched_switch': -- BEGIN PROG LOAD LOG --
R1 type=ctx expected=fp
0: R1=ctx(off=0,imm=0) R10=fp0
; int handle__sched_switch(u64 *ctx)
0: (bf) r7 = r1                       ; R1=ctx(off=0,imm=0) R7_w=ctx(off=0,imm=0)
; struct task_struct *next = (struct task_struct *)ctx[2];
1: (79) r6 = *(u64 *)(r7 +16)
func 'sched_switch' arg2 has btf_id 186 type STRUCT 'task_struct'
2: R6_w=ptr_task_struct(off=0,imm=0) R7_w=ctx(off=0,imm=0)
; struct task_struct *prev = (struct task_struct *)ctx[1];
2: (79) r2 = *(u64 *)(r7 +8)          ; R2_w=scalar() R7_w=ctx(off=0,imm=0)
3: (b7) r1 = 0                        ; R1_w=0
; struct runq_event event = {};
4: (7b) *(u64 *)(r10 -8) = r1         ; R1_w=P0 R10=fp0 fp-8_w=00000000
5: (7b) *(u64 *)(r10 -16) = r1        ; R1_w=P0 R10=fp0 fp-16_w=00000000
6: (7b) *(u64 *)(r10 -24) = r1        ; R1_w=P0 R10=fp0 fp-24_w=00000000
7: (7b) *(u64 *)(r10 -32) = r1        ; R1_w=P0 R10=fp0 fp-32_w=00000000
; if (prev->__state == TASK_RUNNING)
8: (61) r1 = *(u32 *)(r2 +24)
R2 invalid mem access 'scalar'
processed 9 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
-- END PROG LOAD LOG --
libbpf: failed to load program 'handle__sched_switch'
libbpf: failed to load object 'runqslower_bpf'
libbpf: failed to load BPF skeleton 'runqslower_bpf': -13
failed to load BPF object: -13

Update runqslower to fix this issue. Also, as we are on this, use BPF_PROG
in runqslower for cleaner code.

Fixes: fa2c3254d7cf ("sched/tracing: Don't re-read p->state when emitting sched_switch event")
Signed-off-by: Song Liu <song@kernel.org>
---
 tools/bpf/runqslower/runqslower.bpf.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
index 9a5c1f008fe6..30e491d8308f 100644
--- a/tools/bpf/runqslower/runqslower.bpf.c
+++ b/tools/bpf/runqslower/runqslower.bpf.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2019 Facebook
 #include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
 #include "runqslower.h"
 
 #define TASK_RUNNING 0
@@ -43,31 +44,21 @@ static int trace_enqueue(struct task_struct *t)
 }
 
 SEC("tp_btf/sched_wakeup")
-int handle__sched_wakeup(u64 *ctx)
+int BPF_PROG(handle__sched_wakeup, struct task_struct *p)
 {
-	/* TP_PROTO(struct task_struct *p) */
-	struct task_struct *p = (void *)ctx[0];
-
 	return trace_enqueue(p);
 }
 
 SEC("tp_btf/sched_wakeup_new")
-int handle__sched_wakeup_new(u64 *ctx)
+int BPF_PROG(handle__sched_wakeup_new, struct task_struct *p)
 {
-	/* TP_PROTO(struct task_struct *p) */
-	struct task_struct *p = (void *)ctx[0];
-
 	return trace_enqueue(p);
 }
 
 SEC("tp_btf/sched_switch")
-int handle__sched_switch(u64 *ctx)
+int BPF_PROG(handle__sched_switch, bool preempt, unsigned long prev_state,
+	     struct task_struct *prev, struct task_struct *next)
 {
-	/* TP_PROTO(bool preempt, struct task_struct *prev,
-	 *	    struct task_struct *next)
-	 */
-	struct task_struct *prev = (struct task_struct *)ctx[1];
-	struct task_struct *next = (struct task_struct *)ctx[2];
 	struct runq_event event = {};
 	u64 *tsp, delta_us;
 	long state;
-- 
2.30.2

