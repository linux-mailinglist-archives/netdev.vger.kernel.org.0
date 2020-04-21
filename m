Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9018A1B2E0E
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbgDURQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729373AbgDURQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 13:16:08 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E59C0610D6
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 10:16:07 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g2so5481525plo.3
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 10:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id;
        bh=ljRvWFcGm52XgUtMD9But5MqOn9lfvTXOY7h72QTuF4=;
        b=LgOv8iFo7ZZEXlbneCiwfho6goWloKWgxGo/Rz0rGHn1OF9OjCxjdtBD93lWXc2ryS
         oC+ZeG30GjIplDDTb5rlY3sS+29v6Xjreempc3mY7THUY0mn/sCkhG+akNtQspI4YGMi
         +eOjxBC8WDg43qS9kBWyj0nmuDk5bJie4voxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ljRvWFcGm52XgUtMD9But5MqOn9lfvTXOY7h72QTuF4=;
        b=TIW3ZX2nlEe6TYkYwFcmO5PPSkeVuiMp/+5Knwe1nISqaQ37XGQtqqd2Ww3bwiVvNc
         ITT8eVb9lYhwvDw/iSHOweMN6lB3w9iC3XS6rtmUveHBxZw9OA0luC4NVZPq3EFVp96q
         LxDjy6e/y9k6EUmi3r+/ojcEoipjtOx94c5nPTemtTTV5OqOpBKY7NkpFOM89GtlPWVf
         d0v/hwlvY8NnQZTwxTh8U+05c6kABcwrnL47iMaShjbgqFRV/hIIlSiq2M0Zmm+yPAO8
         3XApZc+q8bGIuVSER8JjEn/nu1VRes9TWSW6mpcyLbWQXggCDfSkAD/72fu/mFWfs1YR
         btjw==
X-Gm-Message-State: AGi0PubEdqTr8RefBnQDfXsimKRcmD6xZVudn1ek3jLF2DwAsVx5F/1W
        K17HvVu+M8T89K14zWO5mliqgQ==
X-Google-Smtp-Source: APiQypIiAshAlC23+kzaiUR/PvrllP1bebPd0TXXGjN+cCqgMI61CKL5fooN6QGFbYm7X73pWxgNnw==
X-Received: by 2002:a17:90a:1946:: with SMTP id 6mr5214874pjh.42.1587489367134;
        Tue, 21 Apr 2020 10:16:07 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id mn1sm2911459pjb.24.2020.04.21.10.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 10:16:06 -0700 (PDT)
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
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf 1/2] bpf, x32: Fix invalid instruction in BPF_LDX zero-extension
Date:   Tue, 21 Apr 2020 10:15:51 -0700
Message-Id: <20200421171552.28393-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current JIT uses the following sequence to zero-extend into the
upper 32 bits of the destination register for BPF_LDX BPF_{B,H,W},
when the destination register is not on the stack:

  EMIT3(0xC7, add_1reg(0xC0, dst_hi), 0);

However, this is not a valid instruction on x86.

This patch fixes the problem by instead emitting "xor dst_hi,dst_hi"
to clear the upper 32 bits.

This bug may not be currently triggerable as BPF_REG_AX is the only
register not stored on the stack and the verifier uses it in a limited
way, and the verifier implements a zero-extension optimization. But the
JIT should avoid emitting invalid instructions regardless.

Fixes: 03f5781be2c7b ("bpf, x86_32: add eBPF JIT compiler for ia32")
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/x86/net/bpf_jit_comp32.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 4d2a7a764602..cc9ad3892ea6 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1854,7 +1854,9 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 					      STACK_VAR(dst_hi));
 					EMIT(0x0, 4);
 				} else {
-					EMIT3(0xC7, add_1reg(0xC0, dst_hi), 0);
+					/* xor dst_hi,dst_hi */
+					EMIT2(0x33,
+					      add_2reg(0xC0, dst_hi, dst_hi));
 				}
 				break;
 			case BPF_DW:
-- 
2.17.1

