Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48B7162EFC
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfGIDcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:32:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13526 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727656AbfGIDcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 23:32:54 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x693WKeE013458
        for <netdev@vger.kernel.org>; Mon, 8 Jul 2019 20:32:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=CwSw5kzHxNro3mD+RGOAL5jIB/yvxuKNuE6bq7DXZ2M=;
 b=GLhEfC/eDlVm0hyPPESQ8/20G1hkb1unkePXK7SUZs0uXLeoBm8J/dmu2z9nBr6NDqsa
 1vajwkr1vjgVuQqzPAS1eF3jqJZNKtzWy8QPNuznHKhWtSsCk+gOzIW//G/90KoQjzaV
 qfpzPGYi8MfEYSXal6KA5Nx2xsTSUTVb/fs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tmg9trdmt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 20:32:53 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 8 Jul 2019 20:32:46 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 70BE086162B; Mon,  8 Jul 2019 20:32:46 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] bpf: fix precision bit propagation for BPF_ST instructions
Date:   Mon, 8 Jul 2019 20:32:44 -0700
Message-ID: <20190709033244.1596200-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=545 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090040
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When backtracking instructions to propagate precision bit for registers
and stack slots, one class of instructions (BPF_ST) weren't handled
causing extra stack slots to be propagated into parent state. Parent
state might not have that much stack allocated, though, which causes
warning on invalid stack slot usage.

This patch adds handling of BPF_ST instructions:

BPF_MEM | <size> | BPF_ST:   *(size *) (dst_reg + off) = imm32

Reported-by: syzbot+4da3ff23081bafe74fc2@syzkaller.appspotmail.com
Fixes: b5dc0163d8fd ("bpf: precise scalar_value tracking")
Cc: Alexei Starovoitov <ast@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/verifier.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a2e763703c30..def87e9cc9c7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1519,9 +1519,9 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx,
 			return -EFAULT;
 		}
 		*stack_mask |= 1ull << spi;
-	} else if (class == BPF_STX) {
+	} else if (class == BPF_STX || class == BPF_ST) {
 		if (*reg_mask & dreg)
-			/* stx shouldn't be using _scalar_ dst_reg
+			/* stx & st shouldn't be using _scalar_ dst_reg
 			 * to access memory. It means backtracking
 			 * encountered a case of pointer subtraction.
 			 */
@@ -1540,7 +1540,8 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx,
 		if (!(*stack_mask & (1ull << spi)))
 			return 0;
 		*stack_mask &= ~(1ull << spi);
-		*reg_mask |= sreg;
+		if (class == BPF_STX)
+			*reg_mask |= sreg;
 	} else if (class == BPF_JMP || class == BPF_JMP32) {
 		if (opcode == BPF_CALL) {
 			if (insn->src_reg == BPF_PSEUDO_CALL)
@@ -1569,10 +1570,6 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx,
 		if (mode == BPF_IND || mode == BPF_ABS)
 			/* to be analyzed */
 			return -ENOTSUPP;
-	} else if (class == BPF_ST) {
-		if (*reg_mask & dreg)
-			/* likely pointer subtraction */
-			return -ENOTSUPP;
 	}
 	return 0;
 }
-- 
2.17.1

