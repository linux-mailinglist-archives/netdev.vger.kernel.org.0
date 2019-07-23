Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A10715D7
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 12:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388937AbfGWKPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 06:15:48 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:40657 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388924AbfGWKPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 06:15:48 -0400
Received: by mail-pl1-f202.google.com with SMTP id 91so21681500pla.7
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 03:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OnKPbl94vVh+VvHbMFFOkzGcpjhJxtsb+O1+2r/rSg8=;
        b=XYpJc1p8s+u2P+0doG/v++WGs+vUcbD7soscNcGUurYk3LLHhKjRCc5Xv46bUK45cR
         MjAQOUUwWVzOnjYCS0ztQa1xZuY8zrudmmBxTRzGFKM1ecsq6xM8+7wYavXVpDoY77uO
         0pKA2bfvMQvHUxIx5uCu24U4bSVpNrKwoJ8X/lIyN+IfWXRxu8gStHlTkn0QwTIP1DQI
         oi1G4nHb5SV3BZ8vCkPXVaql7962JuGvHZYjYY8HgkE+KHgWtkiFzEJ0Lp+qznuAu9yq
         HRjstY7SkP3Wm2Nlrdk6PnrP/RFBdpeANl4wVWl9urPTQs0tePHL/n+1IhYtlrOS9m/y
         8jtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OnKPbl94vVh+VvHbMFFOkzGcpjhJxtsb+O1+2r/rSg8=;
        b=ExoWbqXlzQ1ouiiddSjS2DXwRq/hLsPdn3GyLqkivfR3jB94dtcJAQa9Lp3Ay4zfYi
         t5KXD5IUR0+2WS3nlBM832qDU0a068LaIiFJhMTeCR+fELQTLXLH6Zhbv+v8Nghj+SnZ
         MuO9d2E9q54JxmB4zbpo/F2/ZWlpDnVuOoFyOmxzthrrLYlQMkgPdlsH2jIQ2T/8icti
         XddFSkpWyzno86QW5Gia+adPtmt/KVtEQXAOi6IjZX30jmAPoblA9/DL/9qKjw7rA/1U
         qIBtA1//D7HIYdMqkj5ueVqD8oHwpilumyBmVC13bEFz4TtYZ7jdK/YsHLlGATPK+D+a
         /e7A==
X-Gm-Message-State: APjAAAXkOZ0hstzXYo8pU0UqwnRYkhRlYrs27/6DjJvcjCvKD2c2sr8B
        cn87QXABzPgpwUVYtwmiYiC8bMFIDsw4cA==
X-Google-Smtp-Source: APXvYqyxd+1+riabN28Jm79t5uXtvtNynhCUjlIeLWDSSABRRBBdV6JiwhphYs0UJ7daP7X2HiI2034BQKaYqA==
X-Received: by 2002:a63:ec48:: with SMTP id r8mr879390pgj.387.1563876947240;
 Tue, 23 Jul 2019 03:15:47 -0700 (PDT)
Date:   Tue, 23 Jul 2019 03:15:37 -0700
In-Reply-To: <20190723101538.136328-1-edumazet@google.com>
Message-Id: <20190723101538.136328-2-edumazet@google.com>
Mime-Version: 1.0
References: <20190723101538.136328-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf 1/2] bpf: fix access to skb_shared_info->gso_segs
From:   Eric Dumazet <edumazet@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/core/filter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 4e2a79b2fd77f36ba2a31e9e43af1abc1207766e..7878f918b8c057b7b90ca0afcf2d5773cfb55e15 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7455,12 +7455,12 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
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
2.22.0.657.g960e92d24f-goog

