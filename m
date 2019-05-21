Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F37250F8
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 15:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbfEUNq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 09:46:57 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42403 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbfEUNq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 09:46:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id 13so9107623pfw.9;
        Tue, 21 May 2019 06:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lI/jv0cKdLTVm7f1etTSpFXRa1zlfZqLSdICL8eVFUw=;
        b=lCAUPhaIJyF7T7TW04duCQ1C/wP2Y+cJlgG5rd5N3NIcld0N4VZFJJQBQF7J++5d7Q
         2rZXu0V10I9YsLnYMN6RowqjmkCY7dQbFYhNXibShcrGu1X9bj8FzjyvVXsLeLCQEw54
         uPxXzxN3eUqWiAE++zFWF55PYe0XysKtlWzL7bPydyad26MOaK8mWoQ22ne18w2Y2cEt
         UnQkYn4qDcUsM7gDWPsL+8dowsHhrz5BHHuxEGcP/MR6FP0Sk2l5s4W3ZgijENMPbyPP
         d8gUXgVyE7ZjZJKDajKptNtxJ0B67G2pokldLIwaA1vWJVRYaP+VdA/Lzoa7NKOcm5k/
         wcoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lI/jv0cKdLTVm7f1etTSpFXRa1zlfZqLSdICL8eVFUw=;
        b=EfH5aGu2eX3c/fg7GKW6dF1IIv0V1uFH7/AWjs7wvxSbhMLpV6VYiJqkBrMtGMshar
         +VJLJI8IXnW9zEbS5mZZTwblhi39Md5QKOJhnLV/8l2/+IOJLZ9Lom54AmPSaraz4VjJ
         45XXLU9q81b+VK1C24JZ51oJ5bFVQOh8nxPXHlluAlYr+6tCW+xr2gbc93cTCeTtaZMo
         2PJz9PL8nIYE9f8v+dwdr606seab/xsc2bvNiJ/grXRS6ftkGKAF/JbcpHmaQdzQmXUm
         hviKtGwo5wwF5BJctS4hcSQxYSlCC/FWiZWJW9omMLb/f4u0eaY/Mui2Fxclw9HBarqS
         3atg==
X-Gm-Message-State: APjAAAXPMztbzlnPIjexMNsZNnp1s44waaYW0guyP+kUKLTgSl+pI60B
        twz6ONpx0yriaC0strcsXrE=
X-Google-Smtp-Source: APXvYqw2+j6d1zPFsjQLOI4MpHishChca1g7J1s/r/q2nqond5Z/8tIZ/+UrzhLBM0v/KnAAiounUg==
X-Received: by 2002:a63:d613:: with SMTP id q19mr47586203pgg.339.1558446416048;
        Tue, 21 May 2019 06:46:56 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.43])
        by smtp.gmail.com with ESMTPSA id i16sm8437701pfd.100.2019.05.21.06.46.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 06:46:55 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH bpf] bpf, riscv: clear target register high 32-bits for and/or/xor on ALU32
Date:   Tue, 21 May 2019 15:46:22 +0200
Message-Id: <20190521134622.18358-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using 32-bit subregisters (ALU32), the RISC-V JIT would not clear
the high 32-bits of the target register and therefore generate
incorrect code.

E.g., in the following code:

  $ cat test.c
  unsigned int f(unsigned long long a,
  	       unsigned int b)
  {
  	return (unsigned int)a & b;
  }

  $ clang-9 -target bpf -O2 -emit-llvm -S test.c -o - | \
  	llc-9 -mattr=+alu32 -mcpu=v3
  	.text
  	.file	"test.c"
  	.globl	f
  	.p2align	3
  	.type	f,@function
  f:
  	r0 = r1
  	w0 &= w2
  	exit
  .Lfunc_end0:
  	.size	f, .Lfunc_end0-f

The JIT would not clear the high 32-bits of r0 after the
and-operation, which in this case might give an incorrect return
value.

After this patch, that is not the case, and the upper 32-bits are
cleared.

Reported-by: Jiong Wang <jiong.wang@netronome.com>
Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 arch/riscv/net/bpf_jit_comp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index 80b12aa5e10d..e5c8d675bd6e 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -759,14 +759,20 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
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
-- 
2.20.1

