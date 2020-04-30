Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF79A1BFC31
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgD3OEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbgD3NxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:53:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B765224955;
        Thu, 30 Apr 2020 13:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254800;
        bh=4bu4rfAJxuAOnrRC2ZlHCtAsDKCEP4KUPZLuuFxDVDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ptH+TACq5TkEMVNVy9xYMgmiP1zfYDG80p7x+AQRAISosl/h6YaXt5taA06SV8UOg
         9mNmZ2KImLtTsd6/594tr+eVPxw0slSOnDigYJSEXU0HX6rIyOnWmrwkFY/XRnPluT
         XWMSeOxwLIEsS2+l1noWnsXQOUvyHjq3pnNjqkDg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luke Nelson <lukenels@cs.washington.edu>,
        Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Wang YanQing <udknight@gmail.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 55/57] bpf, x86_32: Fix incorrect encoding in BPF_LDX zero-extension
Date:   Thu, 30 Apr 2020 09:52:16 -0400
Message-Id: <20200430135218.20372-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135218.20372-1-sashal@kernel.org>
References: <20200430135218.20372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luke Nelson <lukenels@cs.washington.edu>

[ Upstream commit 5fa9a98fb10380e48a398998cd36a85e4ef711d6 ]

The current JIT uses the following sequence to zero-extend into the
upper 32 bits of the destination register for BPF_LDX BPF_{B,H,W},
when the destination register is not on the stack:

  EMIT3(0xC7, add_1reg(0xC0, dst_hi), 0);

The problem is that C7 /0 encodes a MOV instruction that requires a 4-byte
immediate; the current code emits only 1 byte of the immediate. This
means that the first 3 bytes of the next instruction will be treated as
the rest of the immediate, breaking the stream of instructions.

This patch fixes the problem by instead emitting "xor dst_hi,dst_hi"
to clear the upper 32 bits. This fixes the problem and is more efficient
than using MOV to load a zero immediate.

This bug may not be currently triggerable as BPF_REG_AX is the only
register not stored on the stack and the verifier uses it in a limited
way, and the verifier implements a zero-extension optimization. But the
JIT should avoid emitting incorrect encodings regardless.

Fixes: 03f5781be2c7b ("bpf, x86_32: add eBPF JIT compiler for ia32")
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Acked-by: Wang YanQing <udknight@gmail.com>
Link: https://lore.kernel.org/bpf/20200422173630.8351-1-luke.r.nels@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp32.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 4d2a7a7646026..cc9ad3892ea6b 100644
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
2.20.1

