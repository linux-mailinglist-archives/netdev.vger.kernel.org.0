Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D78017B255
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 00:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgCEXoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 18:44:21 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42413 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgCEXoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 18:44:21 -0500
Received: by mail-pl1-f194.google.com with SMTP id u3so61192plr.9
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 15:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aODloWMH+16G+jblYOYaP3wMYDm9EtGNGFqttSX2s+c=;
        b=DLRMzf7h4mpOskip4ouIPR0SHCDuIPqH5OncwsmFJzBEKqHKjlJmeE2yLIz5+a+nez
         z1CihklS33zvnR8+UsqoMQpolFyiH/grjxX2KwacBuA4ve8c3cTN43i+meX3/mUdfZur
         JwZ9Gpo/sdNhdNq4WzQ70/nSHFX2JJGGQ2oeM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aODloWMH+16G+jblYOYaP3wMYDm9EtGNGFqttSX2s+c=;
        b=t2uWPnWSzw/9AD5HLJqdzLVx8Hc5Qq0oheifse07xtrYeKUIS4xeaev5AIlGpQWMnL
         +OomxaofyvyljoafMWPGioLMIFiRmE0Z5O2Z/h+e3pcWFgsV8x4Ta+nuoNMYAmCjkNw4
         V5pV8zuoEflTXMhGQRmirApRXNALuKeMuD1dBPDQh9Xu46/0c2UmIR0MHQnc3pJJj4w3
         FYato6Ukw/JsBWuYAgke0WallS9qHHvVaR++x730a7bq8igC8rClZBYyn4nKAkc3pV0V
         lvg8rYv7AB1O795yZj4ZuXQXyz8foFFKd2TyD07NK3ATRKpFfgtGCPAaxIWrcQjN5sb5
         Xb5A==
X-Gm-Message-State: ANhLgQ02hDYD0pSySNlvdBrfSmRt348QsAgO2Jrpl1HviS/ARNETlnh0
        DhOsDxYQEzIY8AeynYiusPT5Dg==
X-Google-Smtp-Source: ADFU+vso9fE7zT/rV4B3bXR5NWkoobXDHEh3h6d5W3kgqFGDXSuUEjPGN9nvGO5Gfot1rEhID2VWzQ==
X-Received: by 2002:a17:902:bc88:: with SMTP id bb8mr224807plb.274.1583451859886;
        Thu, 05 Mar 2020 15:44:19 -0800 (PST)
Received: from ryzen.cs.washington.edu ([2607:4000:200:11:60e4:c000:39d0:c5af])
        by smtp.gmail.com with ESMTPSA id s123sm30103856pfs.21.2020.03.05.15.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 15:44:19 -0800 (PST)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Wang YanQing <udknight@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Jiong Wang <jiong.wang@netronome.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf 1/2] bpf, x32: fix bug with JMP32 JSET BPF_X checking upper bits
Date:   Thu,  5 Mar 2020 15:44:12 -0800
Message-Id: <20200305234416.31597-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current x32 BPF JIT is incorrect for JMP32 JSET BPF_X when the upper
32 bits of operand registers are non-zero in certain situations.

The problem is in the following code:

  case BPF_JMP | BPF_JSET | BPF_X:
  case BPF_JMP32 | BPF_JSET | BPF_X:
  ...

  /* and dreg_lo,sreg_lo */
  EMIT2(0x23, add_2reg(0xC0, sreg_lo, dreg_lo));
  /* and dreg_hi,sreg_hi */
  EMIT2(0x23, add_2reg(0xC0, sreg_hi, dreg_hi));
  /* or dreg_lo,dreg_hi */
  EMIT2(0x09, add_2reg(0xC0, dreg_lo, dreg_hi));

This code checks the upper bits of the operand registers regardless if
the BPF instruction is BPF_JMP32 or BPF_JMP64. Registers dreg_hi and
dreg_lo are not loaded from the stack for BPF_JMP32, however, they can
still be polluted with values from previous instructions.

The following BPF program demonstrates the bug. The jset64 instruction
loads the temporary registers and performs the jump, since ((u64)r7 &
(u64)r8) is non-zero. The jset32 should _not_ be taken, as the lower
32 bits are all zero, however, the current JIT will take the branch due
the pollution of temporary registers from the earlier jset64.

  mov64    r0, 0
  ld64     r7, 0x8000000000000000
  ld64     r8, 0x8000000000000000
  jset64   r7, r8, 1
  exit
  jset32   r7, r8, 1
  mov64    r0, 2
  exit

The expected return value of this program is 2; under the buggy x32 JIT
it returns 0. The fix is to skip using the upper 32 bits for jset32 and
compare the upper 32 bits for jset64 only.

All tests in test_bpf.ko and selftests/bpf/test_verifier continue to
pass with this change.

We found this bug using our automated verification tool, Serval.

Fixes: 69f827eb6e14 ("x32: bpf: implement jitting of JMP32")
Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/x86/net/bpf_jit_comp32.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 393d251798c0..4d2a7a764602 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -2039,10 +2039,12 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			}
 			/* and dreg_lo,sreg_lo */
 			EMIT2(0x23, add_2reg(0xC0, sreg_lo, dreg_lo));
-			/* and dreg_hi,sreg_hi */
-			EMIT2(0x23, add_2reg(0xC0, sreg_hi, dreg_hi));
-			/* or dreg_lo,dreg_hi */
-			EMIT2(0x09, add_2reg(0xC0, dreg_lo, dreg_hi));
+			if (is_jmp64) {
+				/* and dreg_hi,sreg_hi */
+				EMIT2(0x23, add_2reg(0xC0, sreg_hi, dreg_hi));
+				/* or dreg_lo,dreg_hi */
+				EMIT2(0x09, add_2reg(0xC0, dreg_lo, dreg_hi));
+			}
 			goto emit_cond_jmp;
 		}
 		case BPF_JMP | BPF_JSET | BPF_K:
-- 
2.20.1

