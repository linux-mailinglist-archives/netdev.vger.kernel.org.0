Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BABC05FF01
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 02:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfGEASS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 20:18:18 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40239 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbfGEASS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 20:18:18 -0400
Received: by mail-pf1-f195.google.com with SMTP id p184so3493406pfp.7
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 17:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ieoRpUxmUXtlmske89JbAl6yE+PFtkjAQtUvuulFg8E=;
        b=des6ixjMKnQvR6ExT7KYukXvC/tI+2vPZSaFyTdpAPTJNVkpvPQ7HqA6Y28Z/irgkv
         TjB+EIIQVi1T4+phwGES6MvjooIJjsMlulce7MAbKVl8G3itteydm9TqE4jeO6Qbznvj
         BbKpB5UbOUNjobTmk9CUo8cmy1nCSHy8KYsaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ieoRpUxmUXtlmske89JbAl6yE+PFtkjAQtUvuulFg8E=;
        b=nwIG+xYfx80DLgrX36zdt0DIVtA6PiM1qkHBTn0WNMI4GXwsQi+xBOqZLuda9rvezg
         9QJvd+fzKIupeZfbfuGB2DNDgkKX5O9CnfOcGcRiwm+5YLVl0jBm5OEBUYIyYEXZ23f+
         aH58hJlHL2fau/tqDjZ60RIFjpAhvsFmvf1nX2DSMW7P6Q4a9fhR4Yooeaowjb0cX6NZ
         7HLCR6C93KwD3/UlcdDllTg9QGA7XujomT7JjKEWjisGU5esRqxAHO/40giBqbTY5Q6W
         PmNAVvnAx20VXZWCnkfmp/D8FpqiYzmkWiau3ia9b0T5GiLb4jbtD6Zik6HRoejfexFl
         9UMA==
X-Gm-Message-State: APjAAAUj+7IK9jYovX4pcQZT7Q5aNCb5v/qCxqcWNfZqyd7D8TCuZ4Cm
        rGJUju9prGlKIZOq/VyzwN2pdg==
X-Google-Smtp-Source: APXvYqzYqQYsnij9RBKsP2qGU6x1hHVuqBZ4VlRgngJa3AsE0s35Rkjntbz44duoTSCYeQYhJwoFPQ==
X-Received: by 2002:a17:90a:d3d4:: with SMTP id d20mr791957pjw.28.1562285897229;
        Thu, 04 Jul 2019 17:18:17 -0700 (PDT)
Received: from ryzen.cs.washington.edu ([2607:4000:200:11:882:19c3:2cb3:4b10])
        by smtp.gmail.com with ESMTPSA id q1sm11494168pfn.178.2019.07.04.17.18.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 17:18:16 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next] Enable zext optimization for more RV64G ALU ops
Date:   Thu,  4 Jul 2019 17:18:02 -0700
Message-Id: <20190705001803.30094-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 66d0d5a854a6 ("riscv: bpf: eliminate zero extension code-gen")
added the new zero-extension optimization for some BPF ALU operations.

Since then, bugs in the JIT that have been fixed in the bpf tree require
this optimization to be added to other operations: commit 1e692f09e091
("bpf, riscv: clear high 32 bits for ALU32 add/sub/neg/lsh/rsh/arsh"),
and commit fe121ee531d1 ("bpf, riscv: clear target register high 32-bits
for and/or/xor on ALU32")

Now that these have been merged to bpf-next, the zext optimization can
be enabled for the fixed operations.

Cc: Song Liu <liu.song.a23@gmail.com>
Cc: Jiong Wang <jiong.wang@netronome.com>
Cc: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/riscv/net/bpf_jit_comp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index 876cb9c705ce..5451ef3845f2 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -757,31 +757,31 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_ADD | BPF_X:
 	case BPF_ALU64 | BPF_ADD | BPF_X:
 		emit(is64 ? rv_add(rd, rd, rs) : rv_addw(rd, rd, rs), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_SUB | BPF_X:
 	case BPF_ALU64 | BPF_SUB | BPF_X:
 		emit(is64 ? rv_sub(rd, rd, rs) : rv_subw(rd, rd, rs), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_AND | BPF_X:
 	case BPF_ALU64 | BPF_AND | BPF_X:
 		emit(rv_and(rd, rd, rs), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_OR | BPF_X:
 	case BPF_ALU64 | BPF_OR | BPF_X:
 		emit(rv_or(rd, rd, rs), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_XOR | BPF_X:
 	case BPF_ALU64 | BPF_XOR | BPF_X:
 		emit(rv_xor(rd, rd, rs), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_MUL | BPF_X:
@@ -811,13 +811,13 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_RSH | BPF_X:
 	case BPF_ALU64 | BPF_RSH | BPF_X:
 		emit(is64 ? rv_srl(rd, rd, rs) : rv_srlw(rd, rd, rs), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_ARSH | BPF_X:
 	case BPF_ALU64 | BPF_ARSH | BPF_X:
 		emit(is64 ? rv_sra(rd, rd, rs) : rv_sraw(rd, rd, rs), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 
@@ -826,7 +826,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU64 | BPF_NEG:
 		emit(is64 ? rv_sub(rd, RV_REG_ZERO, rd) :
 		     rv_subw(rd, RV_REG_ZERO, rd), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 
-- 
2.20.1

