Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59741F2EAA
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733244AbgFIAns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729036AbgFHXMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81405214D8;
        Mon,  8 Jun 2020 23:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657922;
        bh=FVGe8qaMruNT+7gpi3rEtG8gVXNp1V100Vai5EX7ITI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvEmzW5f5kwcespfbLpVWQiP9BnN0d+t2Hj4sDcwBH8OopnPsdH+gvs8kQ6KwxEqC
         SNlY0YPgTjaSeF3vVCHdksgZWdLx3mCWdmi097rNOmxLsGrmMgyxJAFPOuewnUfRqe
         6iafYs+cJurz/xJcrBJ/PNOBNAYabZCsEu5SGGDg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 271/274] s390/bpf: Maintain 8-byte stack alignment
Date:   Mon,  8 Jun 2020 19:06:04 -0400
Message-Id: <20200608230607.3361041-271-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit effe5be17706167ee968fa28afe40dec9c6f71db ]

Certain kernel functions (e.g. get_vtimer/set_vtimer) cause kernel
panic when the stack is not 8-byte aligned. Currently JITed BPF programs
may trigger this by allocating stack frames with non-rounded sizes and
then being interrupted. Fix by using rounded fp->aux->stack_depth.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20200602174339.2501066-1-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 8d2134136290..0f37a1b635f8 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -594,7 +594,7 @@ static void bpf_jit_epilogue(struct bpf_jit *jit, u32 stack_depth)
  * stack space for the large switch statement.
  */
 static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
-				 int i, bool extra_pass)
+				 int i, bool extra_pass, u32 stack_depth)
 {
 	struct bpf_insn *insn = &fp->insnsi[i];
 	u32 dst_reg = insn->dst_reg;
@@ -1207,7 +1207,7 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		 */
 
 		if (jit->seen & SEEN_STACK)
-			off = STK_OFF_TCCNT + STK_OFF + fp->aux->stack_depth;
+			off = STK_OFF_TCCNT + STK_OFF + stack_depth;
 		else
 			off = STK_OFF_TCCNT;
 		/* lhi %w0,1 */
@@ -1249,7 +1249,7 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		/*
 		 * Restore registers before calling function
 		 */
-		save_restore_regs(jit, REGS_RESTORE, fp->aux->stack_depth);
+		save_restore_regs(jit, REGS_RESTORE, stack_depth);
 
 		/*
 		 * goto *(prog->bpf_func + tail_call_start);
@@ -1519,7 +1519,7 @@ static int bpf_set_addr(struct bpf_jit *jit, int i)
  * Compile eBPF program into s390x code
  */
 static int bpf_jit_prog(struct bpf_jit *jit, struct bpf_prog *fp,
-			bool extra_pass)
+			bool extra_pass, u32 stack_depth)
 {
 	int i, insn_count, lit32_size, lit64_size;
 
@@ -1527,18 +1527,18 @@ static int bpf_jit_prog(struct bpf_jit *jit, struct bpf_prog *fp,
 	jit->lit64 = jit->lit64_start;
 	jit->prg = 0;
 
-	bpf_jit_prologue(jit, fp->aux->stack_depth);
+	bpf_jit_prologue(jit, stack_depth);
 	if (bpf_set_addr(jit, 0) < 0)
 		return -1;
 	for (i = 0; i < fp->len; i += insn_count) {
-		insn_count = bpf_jit_insn(jit, fp, i, extra_pass);
+		insn_count = bpf_jit_insn(jit, fp, i, extra_pass, stack_depth);
 		if (insn_count < 0)
 			return -1;
 		/* Next instruction address */
 		if (bpf_set_addr(jit, i + insn_count) < 0)
 			return -1;
 	}
-	bpf_jit_epilogue(jit, fp->aux->stack_depth);
+	bpf_jit_epilogue(jit, stack_depth);
 
 	lit32_size = jit->lit32 - jit->lit32_start;
 	lit64_size = jit->lit64 - jit->lit64_start;
@@ -1569,6 +1569,7 @@ struct s390_jit_data {
  */
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 {
+	u32 stack_depth = round_up(fp->aux->stack_depth, 8);
 	struct bpf_prog *tmp, *orig_fp = fp;
 	struct bpf_binary_header *header;
 	struct s390_jit_data *jit_data;
@@ -1621,7 +1622,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	 *   - 3:   Calculate program size and addrs arrray
 	 */
 	for (pass = 1; pass <= 3; pass++) {
-		if (bpf_jit_prog(&jit, fp, extra_pass)) {
+		if (bpf_jit_prog(&jit, fp, extra_pass, stack_depth)) {
 			fp = orig_fp;
 			goto free_addrs;
 		}
@@ -1635,7 +1636,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		goto free_addrs;
 	}
 skip_init_ctx:
-	if (bpf_jit_prog(&jit, fp, extra_pass)) {
+	if (bpf_jit_prog(&jit, fp, extra_pass, stack_depth)) {
 		bpf_jit_binary_free(header);
 		fp = orig_fp;
 		goto free_addrs;
-- 
2.25.1

