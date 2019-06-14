Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148064563A
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 09:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfFNH0L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jun 2019 03:26:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39190 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726442AbfFNH0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 03:26:11 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5E7PCVM019557
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 00:26:10 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t3mtdum5q-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 00:26:10 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 14 Jun 2019 00:26:08 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 7307F760F47; Fri, 14 Jun 2019 00:26:07 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 5/9] bpf: fix callees pruning callers
Date:   Fri, 14 Jun 2019 00:25:53 -0700
Message-ID: <20190614072557.196239-6-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190614072557.196239-1-ast@kernel.org>
References: <20190614072557.196239-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-14_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=320 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906140059
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
index 25baa3c8cdd2..870c8f19ce80 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6834,17 +6834,18 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
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

