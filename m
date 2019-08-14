Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA8D78C5FD
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbfHNCLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727703AbfHNCLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CC6A21744;
        Wed, 14 Aug 2019 02:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748710;
        bh=YarHGKtBIijyaqXlWcY8Btnh31GnzALr+t2++I5/OJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMftjXHlxL/Yp6N7ugK/rh/OvgyaD/6CDfc3ct1xnLr3fkwpS28k49c2Ab4EPyyFS
         aE6+VYEFOUAdQdxwIUKMSjmDyeX2MrYuBD9jL8CcupftDyY2EyVt1KD7yMkWYeUko7
         JeMM9uSQOIghEPYJsy31Rr4c9qHjLTauq6z4hkGI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 034/123] bpf: fix access to skb_shared_info->gso_segs
Date:   Tue, 13 Aug 2019 22:09:18 -0400
Message-Id: <20190814021047.14828-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 06a22d897d82f12776d44dbf0850f5895469cb2a ]

It is possible we reach bpf_convert_ctx_access() with
si->dst_reg == si->src_reg

Therefore, we need to load BPF_REG_AX before eventually
mangling si->src_reg.

syzbot generated this x86 code :
   3:   55                      push   %rbp
   4:   48 89 e5                mov    %rsp,%rbp
   7:   48 81 ec 00 00 00 00    sub    $0x0,%rsp // Might be avoided ?
   e:   53                      push   %rbx
   f:   41 55                   push   %r13
  11:   41 56                   push   %r14
  13:   41 57                   push   %r15
  15:   6a 00                   pushq  $0x0
  17:   31 c0                   xor    %eax,%eax
  19:   48 8b bf c0 00 00 00    mov    0xc0(%rdi),%rdi
  20:   44 8b 97 bc 00 00 00    mov    0xbc(%rdi),%r10d
  27:   4c 01 d7                add    %r10,%rdi
  2a:   48 0f b7 7f 06          movzwq 0x6(%rdi),%rdi // Crash
  2f:   5b                      pop    %rbx
  30:   41 5f                   pop    %r15
  32:   41 5e                   pop    %r14
  34:   41 5d                   pop    %r13
  36:   5b                      pop    %rbx
  37:   c9                      leaveq
  38:   c3                      retq

Fixes: d9ff286a0f59 ("bpf: allow BPF programs access skb_shared_info->gso_segs field")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index f681fb772940c..534c310bb0893 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7325,12 +7325,12 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct __sk_buff, gso_segs):
 		/* si->dst_reg = skb_shinfo(SKB); */
 #ifdef NET_SKBUFF_DATA_USES_OFFSET
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, head),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct sk_buff, head));
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, end),
 				      BPF_REG_AX, si->src_reg,
 				      offsetof(struct sk_buff, end));
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, head),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct sk_buff, head));
 		*insn++ = BPF_ALU64_REG(BPF_ADD, si->dst_reg, BPF_REG_AX);
 #else
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, end),
-- 
2.20.1

