Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7BB17C974
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 01:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgCGAMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 19:12:01 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38789 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgCGAMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 19:12:01 -0500
Received: by mail-pg1-f196.google.com with SMTP id x7so1813577pgh.5;
        Fri, 06 Mar 2020 16:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=n3RywOP4ff5lmexdYb6TsPS53fayoT+oyuwrnNu93q8=;
        b=Wiehj06HsmckkYDvaOJVZIwKWPHw/GA8d8eyz+sMK5GCTnt4uXFiaqdA0ZsElul+ST
         4rFMVJjw/l9Rx8I5nnpPA8D+6nA3HmFTzxn8Vu/PsEs8TgtlZsAnF8nE3mzhARP1tl9m
         cAegmFppmSBGEcvcug7CGSqlVkU2dao1v7f8vGJ+X3CQodoOQpO0AOIcP/wcShTcP6Hv
         my5JzAY2FlzHpLmiwZNj1QMcfzmzwdzxP0UtmK/xF8KjsuPYqh8KtlVcnTwxEAlxXOld
         YeHvYLTGwWv954mp+67hKiJWsK+cbIxbVMmD1EV5vwCnT3NufEbZJ/YFRo7dLBk4oJfY
         48mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=n3RywOP4ff5lmexdYb6TsPS53fayoT+oyuwrnNu93q8=;
        b=stImd/9SJrorCKKGqFAo5q39PH0OUO1Tgv118z4aioOw/lJplXq3089wuHtC68k9dj
         GOV3/9Esqno4NZYifyVJrnPND3s3ruVYdU9V31tRnJjcKNp/ddopW9edfzZrAC6yVkHE
         YNzk7x6rdIhDsZb9iD25oXjPedY0MD3P1XsSImBRqOOeMGrFaNEIytTDpj/GWxyOERCx
         ssOrzRfOpoQmhjuHSDRh3CPaotdQloDRG2b7l9iJpH/87BhryqkgjB2BePXHO8Otovq7
         RMDt9pv8PreYS07rjHbuJagnVSHnESNOO/jCQqyFom+w0uViyeU5IQ4/53jzy61Cn8lY
         q+Dg==
X-Gm-Message-State: ANhLgQ2r0/jJlSxQjVrQ+eSCWCx5hhWwg8yocYbB0thDU819g86P7bzc
        KpNLHLz6EWi7B0HTIbvTQAA=
X-Google-Smtp-Source: ADFU+vutfgzfnnKVmXOi81wLEi3DvCV4EhegPLRU0z9Ukb8GxLHKLWdDBcainmJBe9s0tPKQ/gC7Sg==
X-Received: by 2002:aa7:8805:: with SMTP id c5mr6443365pfo.142.1583539919451;
        Fri, 06 Mar 2020 16:11:59 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l1sm10591326pjb.15.2020.03.06.16.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 16:11:59 -0800 (PST)
Subject: [RFC PATCH 4/4] bpf: selftests, bpf_get_stack return value add <0
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Sat, 07 Mar 2020 00:11:46 +0000
Message-ID: <158353990628.3451.13145705520880946721.stgit@ubuntu3-kvm2>
In-Reply-To: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
References: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With current ALU32 subreg handling and retval refine fix from last
patches we see an expected failure in test_verifier. With verbose
verifier state being printed at each step for clarity we have the
following relavent lines [I omit register states that are not
necessarily useful to see failure cause],

#101/p bpf_get_stack return R0 within range FAIL
Failed to load prog 'Success'!
[..]
14: (85) call bpf_get_stack#67
 R0_w=map_value(id=0,off=0,ks=8,vs=48,imm=0)
 R3_w=inv48
15:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
15: (b7) r1 = 0
16:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
16: (bf) r8 = r0
17:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
17: (67) r8 <<= 32
18:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smax_value=9223372032559808512,
               umax_value=18446744069414584320,
               var_off=(0x0; 0xffffffff00000000),
               s32_min_value=0,
               s32_max_value=0,
               u32_max_value=0,
               var32_off=(0x0; 0x0))
18: (c7) r8 s>>= 32
19
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smin_value=-2147483648,
               smax_value=2147483647,
               var32_off=(0x0; 0xffffffff))
19: (cd) if r1 s< r8 goto pc+16
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smin_value=-2147483648,
               smax_value=0,
               var32_off=(0x0; 0xffffffff))
20:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smin_value=-2147483648,
               smax_value=0,
 R9=inv48
20: (1f) r9 -= r8
21: (bf) r2 = r7
22:
 R2_w=map_value(id=0,off=0,ks=8,vs=48,imm=0)
22: (0f) r2 += r8
value -2147483648 makes map_value pointer be out of bounds

After call bpf_get_stack() on line 14 and some moves we have at line 16
an r8 bound with max_value 48 but an unknown min value. This is to be
expected bpf_get_stack call can only return a max of the input size but
is free to return any error in the u64 bit register space.

Lines 17 and 18 clear the top 32 bits with a left/right shift but use
ARSH so we still have work case min bound before line 19 of -2147483648.
At this point the signed check 'r1 s< r8' meant to protect the addition
on line 22 where dst reg is a map_value pointer may very well return
true with a large negative number. Then the final line 22 will detect
this as an invalid operatoin and fail the program.

To fix add a signed less than check to ensure r8 is greater than 0 at
line 19 so the bounds check works as expected.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/verifier/bpf_get_stack.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
index f24d50f09dbe..55a7c9a20dff 100644
--- a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
+++ b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
@@ -7,7 +7,7 @@
 	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
 	BPF_LD_MAP_FD(BPF_REG_1, 0),
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
-	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 28),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 29),
 	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
 	BPF_MOV64_IMM(BPF_REG_9, sizeof(struct test_val)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
@@ -16,6 +16,7 @@
 	BPF_MOV64_IMM(BPF_REG_4, 256),
 	BPF_EMIT_CALL(BPF_FUNC_get_stack),
 	BPF_MOV64_IMM(BPF_REG_1, 0),
+	BPF_JMP_REG(BPF_JSLT, BPF_REG_0, BPF_REG_1, 20),
 	BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
 	BPF_ALU64_IMM(BPF_LSH, BPF_REG_8, 32),
 	BPF_ALU64_IMM(BPF_ARSH, BPF_REG_8, 32),

