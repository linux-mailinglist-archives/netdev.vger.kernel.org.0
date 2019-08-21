Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC25C98646
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbfHUVHN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Aug 2019 17:07:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55146 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726828AbfHUVHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 17:07:13 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LL4Ipn003749
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 14:07:12 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uhadxgxh5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 14:07:11 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 21 Aug 2019 14:07:11 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 888EF760ACD; Wed, 21 Aug 2019 14:07:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: fix precision tracking in presence of bpf2bpf calls
Date:   Wed, 21 Aug 2019 14:07:10 -0700
Message-ID: <20190821210710.1276117-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While adding extra tests for precision tracking and extra infra
to adjust verifier heuristics the existing test
"calls: cross frame pruning - liveness propagation" started to fail.
The root cause is the same as described in verifer.c comment:

 * Also if parent's curframe > frame where backtracking started,
 * the verifier need to mark registers in both frames, otherwise callees
 * may incorrectly prune callers. This is similar to
 * commit 7640ead93924 ("bpf: verifier: make sure callees don't prune with caller differences")
 * For now backtracking falls back into conservative marking.

Turned out though that returning -ENOTSUPP from backtrack_insn() and
doing mark_all_scalars_precise() in the current parentage chain is not enough.
Depending on how is_state_visited() heuristic is creating parentage chain
it's possible that callee will incorrectly prune caller.
Fix the issue by setting precise=true earlier and more aggressively.
Before this fix the precision tracking _within_ functions that don't do
bpf2bpf calls would still work. Whereas now precision tracking is completely
disabled when bpf2bpf calls are present anywhere in the program.

No difference in cilium tests (they don't have bpf2bpf calls).
No difference in test_progs though some of them have bpf2bpf calls,
but precision tracking wasn't effective there.

Fixes: b5dc0163d8fd ("bpf: precise scalar_value tracking")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
Separate set of tests and infra for them will go into bpf-next.
---
 kernel/bpf/verifier.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c84d83f86141..b5c14c9d7b98 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -985,9 +985,6 @@ static void __mark_reg_unbounded(struct bpf_reg_state *reg)
 	reg->smax_value = S64_MAX;
 	reg->umin_value = 0;
 	reg->umax_value = U64_MAX;
-
-	/* constant backtracking is enabled for root only for now */
-	reg->precise = capable(CAP_SYS_ADMIN) ? false : true;
 }
 
 /* Mark a register as having a completely unknown (scalar) value. */
@@ -1014,7 +1011,11 @@ static void mark_reg_unknown(struct bpf_verifier_env *env,
 			__mark_reg_not_init(regs + regno);
 		return;
 	}
-	__mark_reg_unknown(regs + regno);
+	regs += regno;
+	__mark_reg_unknown(regs);
+	/* constant backtracking is enabled for root without bpf2bpf calls */
+	regs->precise = env->subprog_cnt > 1 || !env->allow_ptr_leaks ?
+			true : false;
 }
 
 static void __mark_reg_not_init(struct bpf_reg_state *reg)
-- 
2.20.0

