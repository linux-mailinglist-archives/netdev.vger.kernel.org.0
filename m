Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC5030290
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfE3TIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:08:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34911 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfE3TIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:08:15 -0400
Received: by mail-pf1-f196.google.com with SMTP id d126so4567711pfd.2;
        Thu, 30 May 2019 12:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Aw1+sSYubK2kKTOgJMDkRGNmYcY/5tKHyrYGQqz2ZTA=;
        b=nLT9x3U8ygNPGsLe8NupTDwL4qRw/wJoLtkJo4u0VKNY3v9PwehT9s7PvINtSL1Fr9
         Y0zpNr5QxSXK6ECOHsA6BHFHengti/s8GVotb1wtmw04jP+wbRDnog8CGl7+BPCtpCpy
         rPDlXC6uAHWTqmaaYuxT/YbkELVIxEAB8nSMn0i0PoHql24c3esGeMK8LW8cKlRi5LEv
         /k8WNoyzjlpFX7B7wXOU7nEpZ4wzmQ/+YOO8ANPoJRhcwVNHUWx6le+XNBVhB/jZ/rp8
         1u8Grduyq7q3syrhcSImKA8Sxr4GTQFKMtYx7loWUsOI0+O/QdZRDNQY45g6uzvoCnkB
         vUTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Aw1+sSYubK2kKTOgJMDkRGNmYcY/5tKHyrYGQqz2ZTA=;
        b=nYunsc9ste3/b2vGzNnJNAJQZczvkybIxDKPBTXrIYc6CEy5QMM6odf9hTU8pT+Se4
         7hGGQRU20d9/JChRaae6kx1/bjoliKUEYm2AJHB3nBMDKAbxCXrG9ppCg/5kV+WDo4PV
         wylj8CV2knfjvVghBs7TeDS7g7GqWm/OPkcxWJmHqfdntqAWijO25wHfrNh9meh1U3yh
         UZBI0ZFHgfr9K7o0s2LaKCzmaJZLCpp/Rd1OVJ8Drp9VW6iboQ8uadJP0VWeZv3Ljwim
         klF03mBp2HWO8P6zDX3sTL8ocMPMM+g3hO0vAmqaiOpAA5viz4HaLGgypnio+i2/awwl
         D0cg==
X-Gm-Message-State: APjAAAVxXEaOcyqri1itKXxfQoVLMXskCluN3y8C96mh1DJUo2iREPFk
        7kyQjFK/BRiwIsh8mt9c8zc=
X-Google-Smtp-Source: APXvYqzSZhkQQcByjfuiX46oTYnBxfrMioBh7hahe5g9syL49KzcKXNe8X+WlpMhgB0TBdXGbfVYdQ==
X-Received: by 2002:a17:90a:2ec9:: with SMTP id h9mr5284774pjs.130.1559243295138;
        Thu, 30 May 2019 12:08:15 -0700 (PDT)
Received: from kaby.cs.washington.edu ([2607:4000:200:15:61cb:56f1:2c08:844e])
        by smtp.gmail.com with ESMTPSA id a8sm3927617pfk.14.2019.05.30.12.08.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 12:08:09 -0700 (PDT)
From:   Luke Nelson <luke.r.nels@gmail.com>
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] bpf, riscv: fix bugs in JIT for 32-bit ALU operations
Date:   Thu, 30 May 2019 12:07:59 -0700
Message-Id: <20190530190800.7633-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In BPF, 32-bit ALU operations should zero-extend their results into
the 64-bit registers.  The current BPF JIT on RISC-V emits incorrect
instructions that perform either sign extension only (e.g., addw/subw)
or no extension on 32-bit add, sub, and, or, xor, lsh, rsh, arsh,
and neg.  This behavior diverges from the interpreter and JITs for
other architectures.

This patch fixes the bugs by performing zero extension on the destination
register of 32-bit ALU operations.

Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
Cc: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/riscv/net/bpf_jit_comp.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index 80b12aa5e10d..426d5c33ea90 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -751,22 +751,32 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_ADD | BPF_X:
 	case BPF_ALU64 | BPF_ADD | BPF_X:
 		emit(is64 ? rv_add(rd, rd, rs) : rv_addw(rd, rd, rs), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_SUB | BPF_X:
 	case BPF_ALU64 | BPF_SUB | BPF_X:
 		emit(is64 ? rv_sub(rd, rd, rs) : rv_subw(rd, rd, rs), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_AND | BPF_X:
 	case BPF_ALU64 | BPF_AND | BPF_X:
 		emit(rv_and(rd, rd, rs), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_OR | BPF_X:
 	case BPF_ALU64 | BPF_OR | BPF_X:
 		emit(rv_or(rd, rd, rs), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_XOR | BPF_X:
 	case BPF_ALU64 | BPF_XOR | BPF_X:
 		emit(rv_xor(rd, rd, rs), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_MUL | BPF_X:
 	case BPF_ALU64 | BPF_MUL | BPF_X:
@@ -789,14 +799,20 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_LSH | BPF_X:
 	case BPF_ALU64 | BPF_LSH | BPF_X:
 		emit(is64 ? rv_sll(rd, rd, rs) : rv_sllw(rd, rd, rs), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_RSH | BPF_X:
 	case BPF_ALU64 | BPF_RSH | BPF_X:
 		emit(is64 ? rv_srl(rd, rd, rs) : rv_srlw(rd, rd, rs), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_ARSH | BPF_X:
 	case BPF_ALU64 | BPF_ARSH | BPF_X:
 		emit(is64 ? rv_sra(rd, rd, rs) : rv_sraw(rd, rd, rs), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 
 	/* dst = -dst */
@@ -804,6 +820,8 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU64 | BPF_NEG:
 		emit(is64 ? rv_sub(rd, RV_REG_ZERO, rd) :
 		     rv_subw(rd, RV_REG_ZERO, rd), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 
 	/* dst = BSWAP##imm(dst) */
@@ -958,14 +976,20 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_LSH | BPF_K:
 	case BPF_ALU64 | BPF_LSH | BPF_K:
 		emit(is64 ? rv_slli(rd, rd, imm) : rv_slliw(rd, rd, imm), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_RSH | BPF_K:
 	case BPF_ALU64 | BPF_RSH | BPF_K:
 		emit(is64 ? rv_srli(rd, rd, imm) : rv_srliw(rd, rd, imm), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_ARSH | BPF_K:
 	case BPF_ALU64 | BPF_ARSH | BPF_K:
 		emit(is64 ? rv_srai(rd, rd, imm) : rv_sraiw(rd, rd, imm), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 
 	/* JUMP off */
-- 
2.19.1

