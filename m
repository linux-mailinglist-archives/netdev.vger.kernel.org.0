Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07D90A4F1F
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 08:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbfIBGPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 02:15:01 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22448 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729415AbfIBGPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 02:15:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8264pmb026548;
        Sun, 1 Sep 2019 23:14:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=G+tb34DLVI/GaywJTNbYC1jeXErBz+Ms/6koVGt7RTU=;
 b=K3syjr2bCax7AufTwpWHSbhbUxU5VYIwQEGesdU+fjDriqoSzEFdkr2JUq977PDcmeX7
 uuc14vje7aiqve851BL7WogZtLYTz0XWArF5xGzBtOTHm80fceTgWCY1i7TJDxdLR7b6
 aQY2phvHAnpFQvujyc1ht8rSzxumpnnrgGexiwo+0sAxrDgW+277R4zSow83oGnV1nPm
 n5ZqLh6CVeEy1Z2ukXY74mOeELiVxKdof9BJYbxbnBJJCtbuNk4cHveoXOVAI/8v+L69
 5KyB0KUP69rHZi7jXrl8CNGPgOIVe4M9ILgvYaNvF6rzGe4VoN50GIuCpyvOKgDZ7C2b 6g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uqrdm52ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 01 Sep 2019 23:14:30 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 1 Sep
 2019 23:14:27 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Sun, 1 Sep 2019 23:14:27 -0700
Received: from jerin-lab.marvell.com (jerin-lab.marvell.com [10.28.34.14])
        by maili.marvell.com (Postfix) with ESMTP id BA3533F703F;
        Sun,  1 Sep 2019 23:14:23 -0700 (PDT)
From:   <jerinj@marvell.com>
To:     <netdev@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "open list:BPF JIT for ARM64" <bpf@vger.kernel.org>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     Jerin Jacob <jerinj@marvell.com>
Subject: [PATCH bpf-next] arm64: bpf: optimize modulo operation
Date:   Mon, 2 Sep 2019 11:44:48 +0530
Message-ID: <20190902061448.28252-1-jerinj@marvell.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-02_02:2019-08-29,2019-09-02 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jerin Jacob <jerinj@marvell.com>

Optimize modulo operation instruction generation by
using single MSUB instruction vs MUL followed by SUB
instruction scheme.

Signed-off-by: Jerin Jacob <jerinj@marvell.com>
---
 arch/arm64/net/bpf_jit.h      | 3 +++
 arch/arm64/net/bpf_jit_comp.c | 6 ++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
index cb7ab50b7657..eb73f9f72c46 100644
--- a/arch/arm64/net/bpf_jit.h
+++ b/arch/arm64/net/bpf_jit.h
@@ -171,6 +171,9 @@
 /* Rd = Ra + Rn * Rm */
 #define A64_MADD(sf, Rd, Ra, Rn, Rm) aarch64_insn_gen_data3(Rd, Ra, Rn, Rm, \
 	A64_VARIANT(sf), AARCH64_INSN_DATA3_MADD)
+/* Rd = Ra - Rn * Rm */
+#define A64_MSUB(sf, Rd, Ra, Rn, Rm) aarch64_insn_gen_data3(Rd, Ra, Rn, Rm, \
+	A64_VARIANT(sf), AARCH64_INSN_DATA3_MSUB)
 /* Rd = Rn * Rm */
 #define A64_MUL(sf, Rd, Rn, Rm) A64_MADD(sf, Rd, A64_ZR, Rn, Rm)
 
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index f5b437f8a22b..cdc79de0c794 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -409,8 +409,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			break;
 		case BPF_MOD:
 			emit(A64_UDIV(is64, tmp, dst, src), ctx);
-			emit(A64_MUL(is64, tmp, tmp, src), ctx);
-			emit(A64_SUB(is64, dst, dst, tmp), ctx);
+			emit(A64_MSUB(is64, dst, dst, tmp, src), ctx);
 			break;
 		}
 		break;
@@ -516,8 +515,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_ALU64 | BPF_MOD | BPF_K:
 		emit_a64_mov_i(is64, tmp2, imm, ctx);
 		emit(A64_UDIV(is64, tmp, dst, tmp2), ctx);
-		emit(A64_MUL(is64, tmp, tmp, tmp2), ctx);
-		emit(A64_SUB(is64, dst, dst, tmp), ctx);
+		emit(A64_MSUB(is64, dst, dst, tmp, tmp2), ctx);
 		break;
 	case BPF_ALU | BPF_LSH | BPF_K:
 	case BPF_ALU64 | BPF_LSH | BPF_K:
-- 
2.23.0

