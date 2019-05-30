Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1064C304C9
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfE3W3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:29:36 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45204 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3W3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:29:35 -0400
Received: by mail-pf1-f195.google.com with SMTP id s11so4832048pfm.12;
        Thu, 30 May 2019 15:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XFIS/ATJWf8i+rx5RZgt8pFQOptsz9ozO1zSHeC1TwM=;
        b=jrtHBOj3ok1f/xowAmtE0Z0q/wl92RhCPkKm0zNzy3xyEh9KoBDXCQwtq+ffNwM/k0
         xoJfQDV6ndJ/UBTJuyqMXa+z0K6MM5T3+N/+z1g+DGaU46uWvI1oiRcDvOEOMVgVc4KM
         gg7XKnvGxbS9Gn8P9wYQeQnQ/t7kgrMlHgKyeFze4N91ZU5k8y2eLRCuvzHVSE5uqcqa
         o/i2fe+DLMrj7Z7iCtjRRi/q3L9YCgPNXe+necSyZ3DHkoo7NXRPgzpzit3YBFbzPmxD
         fB4WvBLELDFtrpCjuv08DBKQoJNaqjAYVwuH1DD0atxRgZlM1ze5Wq/3HKJ1blmcTpOx
         H40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XFIS/ATJWf8i+rx5RZgt8pFQOptsz9ozO1zSHeC1TwM=;
        b=gxueC7ugHyyR6iE0FNeYpVz//IiFc16KdipP1Lb2uQd51RGUn1pdU74cjYMP4wUMYa
         6Gv/AaQsDcI1/wtyfcH/gLd3Z3j43irI71ygyjjN14v3+Yt9+vS9nz/XSi1nyOFobqlF
         17/UxCWcjAhFU1x/2fLrGhfNTSLaeaw/xOKHR5yg2cdJ1p1hQ8l6cXrSg6i+apdthU0Q
         NIFA3lYb21WiMPTvCpVxgSTqyuEi53SvxAo5GiOqdzCcGMB98UhT278QCAmpEIdHMtsw
         ZNMlVfObT6UWl6XrbbFKtUBd7/7WW4jHA07uofUu0zn9bNUI+cgcAItlQ4WBEzW+swpM
         aXNQ==
X-Gm-Message-State: APjAAAUcHbOkv5ZuLT7BJbbzNsH4oCo2y8ixcayDcyhto2hCElBCktcW
        KDk/aPRvMMoRRcJEEwXvNJU=
X-Google-Smtp-Source: APXvYqw2EYd2FcvKbUNMNOciWItMzYs8P3TF+IEhZUZ3ULjwC7KuQfnSofumg0Xp/zG+s8Wy4IAb2g==
X-Received: by 2002:a62:7a8e:: with SMTP id v136mr5940404pfc.208.1559255375149;
        Thu, 30 May 2019 15:29:35 -0700 (PDT)
Received: from kaby.cs.washington.edu ([2607:4000:200:15:61cb:56f1:2c08:844e])
        by smtp.gmail.com with ESMTPSA id a5sm2310568pjo.29.2019.05.30.15.29.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 15:29:34 -0700 (PDT)
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
Subject: [PATCH bpf v2] bpf, riscv: clear high 32 bits for ALU32 add/sub/neg/lsh/rsh/arsh
Date:   Thu, 30 May 2019 15:29:22 -0700
Message-Id: <20190530222922.4269-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In BPF, 32-bit ALU operations should zero-extend their results into
the 64-bit registers.

The current BPF JIT on RISC-V emits incorrect instructions that perform
sign extension only (e.g., addw, subw) on 32-bit add, sub, lsh, rsh,
arsh, and neg. This behavior diverges from the interpreter and JITs
for other architectures.

This patch fixes the bugs by performing zero extension on the destination
register of 32-bit ALU operations.

Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
Cc: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
The original patch is
https://lkml.org/lkml/2019/5/30/1370

This version is rebased against the bpf tree.
---
 arch/riscv/net/bpf_jit_comp.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index e5c8d675bd6e..426d5c33ea90 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -751,10 +751,14 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
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
@@ -795,14 +799,20 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
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
@@ -810,6 +820,8 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU64 | BPF_NEG:
 		emit(is64 ? rv_sub(rd, RV_REG_ZERO, rd) :
 		     rv_subw(rd, RV_REG_ZERO, rd), ctx);
+		if (!is64)
+			emit_zext_32(rd, ctx);
 		break;
 
 	/* dst = BSWAP##imm(dst) */
@@ -964,14 +976,20 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
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

