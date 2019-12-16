Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9DF1200B0
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfLPJOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:14:05 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34819 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbfLPJOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:14:04 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so1574194plt.2;
        Mon, 16 Dec 2019 01:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gJMg0Q8sOUthYx3cFqSRyerb3CBS/OU8cO8MoQc4pJM=;
        b=XPQz4evg0VbB6K1XDWp53Kbjm0ht98HVwNnW6mJQ1O+P9za2E0H0FBgIUI4lWGSRmm
         e47U7DRE05fU6Jm6GfUqHCUwTBjRBlkDzzGQkB/DDfc2zpuYuKZ51M9IYgRfKC/Vcb4E
         MbgHbf51mM7VdA+w/D8ywHwabtqnyU83pOt//xx4hy/5KAp87GRUUrFHEHxo6j6KtoQS
         VAaQOfZtMIdTLWUWXhSzLv/lZt6BI5JCeVpu/c6z2o0hdLLPZYw4+23KzAND93vM5VNH
         1SKhLVSBAuozBMnV9W4mMBhf+lfFjwkaPGr4bUiqm9eg1I2Rbt51W+L15oMr8AXf+/Ou
         a9IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gJMg0Q8sOUthYx3cFqSRyerb3CBS/OU8cO8MoQc4pJM=;
        b=jbbOViK6Ta8397wcr1RCeMHmMtVghSIKyPQlNFXqd2E9HyZowlqcwg8AQqXSkHmMvy
         AVFxmSS07pzjpUfJdmznvxTzkb/iSCbenREybOtLUBj2I0hew5aQkxCgw7WB/B2tDAnf
         /tGFlhnBbxblSbeNl891ItUMDMcjKpQ5G8FDj7qDD33texir5OFCDoOkmkSvu+rW12iG
         IsWfDlA7jDSIo5C8qHutVAvjPbNctQ1iXcnWJCO5VpjQFjPGntOoVtB4y780rSPiRoIm
         NNi4FzdajOagBelHM18EpczdhVhTWQv8aVMZ9rvw7mGI+3SSz5RD2m7BvdccWtjkjUn2
         GVzQ==
X-Gm-Message-State: APjAAAWyiRlmHiHK6a1Zw/mrEPuftm/n0BjCCNPFyLNt8UbcZcYXBzDH
        YLGo+4Vjp1q5sswDuF5cPZ8=
X-Google-Smtp-Source: APXvYqxc8umv14WzkAH/BRhw9GggK6mAxe2lkuZid3gzCbuWbXlbEx2Br/c0kwVybokpglnbQOzepQ==
X-Received: by 2002:a17:90b:85:: with SMTP id bb5mr16072485pjb.22.1576487643481;
        Mon, 16 Dec 2019 01:14:03 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id x21sm12505033pfn.164.2019.12.16.01.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:14:03 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org,
        Luke Nelson <lukenels@cs.washington.edu>,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH bpf-next v2 4/9] riscv, bpf: add support for far jumps and exits
Date:   Mon, 16 Dec 2019 10:13:38 +0100
Message-Id: <20191216091343.23260-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191216091343.23260-1-bjorn.topel@gmail.com>
References: <20191216091343.23260-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit add support for far (offset > 21b) jumps and exits.

Reviewed-by: Luke Nelson <lukenels@cs.washington.edu>
Cc: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 arch/riscv/net/bpf_jit_comp.c | 37 ++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index c38c95df3440..2fc0f24ad30f 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -496,16 +496,6 @@ static int is_12b_check(int off, int insn)
 	return 0;
 }
 
-static int is_21b_check(int off, int insn)
-{
-	if (!is_21b_int(off)) {
-		pr_err("bpf-jit: insn=%d 21b < offset=%d not supported yet!\n",
-		       insn, (int)off);
-		return -1;
-	}
-	return 0;
-}
-
 static void emit_imm(u8 rd, s64 val, struct rv_jit_context *ctx)
 {
 	/* Note that the immediate from the add is sign-extended,
@@ -820,6 +810,21 @@ static void emit_sext_32_rd(u8 *rd, struct rv_jit_context *ctx)
 	*rd = RV_REG_T2;
 }
 
+static void emit_jump_and_link(u8 rd, int rvoff, struct rv_jit_context *ctx)
+{
+	s64 upper, lower;
+
+	if (is_21b_int(rvoff)) {
+		emit(rv_jal(rd, rvoff >> 1), ctx);
+		return;
+	}
+
+	upper = (rvoff + (1 << 11)) >> 12;
+	lower = rvoff & 0xfff;
+	emit(rv_auipc(RV_REG_T1, upper), ctx);
+	emit(rv_jalr(rd, RV_REG_T1, lower), ctx);
+}
+
 static bool is_signed_bpf_cond(u8 cond)
 {
 	return cond == BPF_JSGT || cond == BPF_JSLT ||
@@ -1101,13 +1106,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	/* JUMP off */
 	case BPF_JMP | BPF_JA:
 		rvoff = rv_offset(i, off, ctx);
-		if (!is_21b_int(rvoff)) {
-			pr_err("bpf-jit: insn=%d offset=%d not supported yet!\n",
-			       i, rvoff);
-			return -1;
-		}
-
-		emit(rv_jal(RV_REG_ZERO, rvoff >> 1), ctx);
+		emit_jump_and_link(RV_REG_ZERO, rvoff, ctx);
 		break;
 
 	/* IF (dst COND src) JUMP off */
@@ -1245,9 +1244,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			break;
 
 		rvoff = epilogue_offset(ctx);
-		if (is_21b_check(rvoff, i))
-			return -1;
-		emit(rv_jal(RV_REG_ZERO, rvoff >> 1), ctx);
+		emit_jump_and_link(RV_REG_ZERO, rvoff, ctx);
 		break;
 
 	/* dst = imm64 */
-- 
2.20.1

