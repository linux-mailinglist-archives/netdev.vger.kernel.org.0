Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDF2445FB
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbfFMQsW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jun 2019 12:48:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34872 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730228AbfFMErw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 00:47:52 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D4kfvO012813
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 21:47:50 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2t3a7dgvrd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 21:47:50 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Jun 2019 21:47:49 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id D4FA9760C2A; Wed, 12 Jun 2019 21:47:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 5/9] bpf: fix callees pruning callers
Date:   Wed, 12 Jun 2019 21:47:34 -0700
Message-ID: <20190613044738.3858896-6-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190613044738.3858896-1-ast@kernel.org>
References: <20190613044738.3858896-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=322 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130038
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 7640ead93924 partially resolved the issue of callees
incorrectly pruning the callers.
With introduction of bounded loops and jmps_processed heuristic
single verifier state may contain multiple branches and calls.
It's possible that new verifier state (for future pruning) will be
allocated inside callee. Then callee will exit (still within the same
verifier state). It will go back to the caller and there R6-R9 registers
will be read and will trigger mark_reg_read. But the reg->live for all frames
but the top frame is not set to LIVE_NONE. Hence mark_reg_read will fail
to propagate liveness into parent and future walking will incorrectly
conclude that the states are equivalent because LIVE_READ is not set.
In other words the rule for parent/live should be:
whenever register parentage chain is set the reg->live should be set to LIVE_NONE.
is_state_visited logic already follows this rule for spilled registers.

Fixes: 7640ead93924 ("bpf: verifier: make sure callees don't prune with caller differences")
Fixes: f4d7e40a5b71 ("bpf: introduce function calls (verification)")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 55d5ab4ab83e..ef2b69b7bc01 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6835,17 +6835,18 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 	 * the state of the call instruction (with WRITTEN set), and r0 comes
 	 * from callee with its full parentage chain, anyway.
 	 */
-	for (j = 0; j <= cur->curframe; j++)
-		for (i = j < cur->curframe ? BPF_REG_6 : 0; i < BPF_REG_FP; i++)
-			cur->frame[j]->regs[i].parent = &new->frame[j]->regs[i];
 	/* clear write marks in current state: the writes we did are not writes
 	 * our child did, so they don't screen off its reads from us.
 	 * (There are no read marks in current state, because reads always mark
 	 * their parent and current state never has children yet.  Only
 	 * explored_states can get read marks.)
 	 */
-	for (i = 0; i < BPF_REG_FP; i++)
-		cur->frame[cur->curframe]->regs[i].live = REG_LIVE_NONE;
+	for (j = 0; j <= cur->curframe; j++) {
+		for (i = j < cur->curframe ? BPF_REG_6 : 0; i < BPF_REG_FP; i++)
+			cur->frame[j]->regs[i].parent = &new->frame[j]->regs[i];
+		for (i = 0; i < BPF_REG_FP; i++)
+			cur->frame[j]->regs[i].live = REG_LIVE_NONE;
+	}
 
 	/* all stack frames are accessible from callee, clear them all */
 	for (j = 0; j <= cur->curframe; j++) {
-- 
2.20.0

