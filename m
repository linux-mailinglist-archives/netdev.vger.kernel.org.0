Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA13A76C4
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfICWQW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 3 Sep 2019 18:16:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726567AbfICWQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:16:21 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83MFUTr025545
        for <netdev@vger.kernel.org>; Tue, 3 Sep 2019 15:16:20 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2usubphp7w-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:16:20 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 3 Sep 2019 15:16:19 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 5BCB4760919; Tue,  3 Sep 2019 15:16:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: fix precision tracking of stack slots
Date:   Tue, 3 Sep 2019 15:16:17 -0700
Message-ID: <20190903221617.635375-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-03_05:2019-09-03,2019-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 priorityscore=1501 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=816 suspectscore=1 impostorscore=0
 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909030221
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The problem can be seen in the following two tests:
0: (bf) r3 = r10
1: (55) if r3 != 0x7b goto pc+0
2: (7a) *(u64 *)(r3 -8) = 0
3: (79) r4 = *(u64 *)(r10 -8)
..
0: (85) call bpf_get_prandom_u32#7
1: (bf) r3 = r10
2: (55) if r3 != 0x7b goto pc+0
3: (7b) *(u64 *)(r3 -8) = r0
4: (79) r4 = *(u64 *)(r10 -8)

When backtracking need to mark R4 it will mark slot fp-8.
But ST or STX into fp-8 could belong to the same block of instructions.
When backtracing is done the parent state may have fp-8 slot
as "unallocated stack". Which will cause verifier to warn
and incorrectly reject such programs.

Writes into stack via non-R10 register are rare. llvm always
generates canonical stack spill/fill.
For such pathological case fall back to conservative precision
tracking instead of rejecting.

Reported-by: syzbot+c8d66267fd2b5955287e@syzkaller.appspotmail.com
Fixes: b5dc0163d8fd ("bpf: precise scalar_value tracking")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
tests will be submitted to bpf-next.

 kernel/bpf/verifier.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b5c14c9d7b98..c36a719fee6d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1772,16 +1772,21 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
 		bitmap_from_u64(mask, stack_mask);
 		for_each_set_bit(i, mask, 64) {
 			if (i >= func->allocated_stack / BPF_REG_SIZE) {
-				/* This can happen if backtracking
-				 * is propagating stack precision where
-				 * caller has larger stack frame
-				 * than callee, but backtrack_insn() should
-				 * have returned -ENOTSUPP.
+				/* the sequence of instructions:
+				 * 2: (bf) r3 = r10
+				 * 3: (7b) *(u64 *)(r3 -8) = r0
+				 * 4: (79) r4 = *(u64 *)(r10 -8)
+				 * doesn't contain jmps. It's backtracked
+				 * as a single block.
+				 * During backtracking insn 3 is not recognized as
+				 * stack access, so at the end of backtracking
+				 * stack slot fp-8 is still marked in stack_mask.
+				 * However the parent state may not have accessed
+				 * fp-8 and it's "unallocated" stack space.
+				 * In such case fallback to conservative.
 				 */
-				verbose(env, "BUG spi %d stack_size %d\n",
-					i, func->allocated_stack);
-				WARN_ONCE(1, "verifier backtracking bug");
-				return -EFAULT;
+				mark_all_scalars_precise(env, st);
+				return 0;
 			}
 
 			if (func->stack[i].slot_type[0] != STACK_SPILL) {
-- 
2.20.0

