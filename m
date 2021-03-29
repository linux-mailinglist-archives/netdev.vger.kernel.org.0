Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8178D34DA37
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhC2WWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231589AbhC2WVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:21:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE10661976;
        Mon, 29 Mar 2021 22:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056500;
        bh=ALZntVy1v1vL5fjHnSHVJHDyzRcy059K9dkGBMFzF44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKnPYFB1LVHiablOKooLlgLTtUHTy3GJgopaFELQzq6CXOtQOMO0p/S8vITJ2FMAO
         sJyc88BEoNZ8IgKR7x2aN0iGw0+62w8XYYRckIVJYW01aQLbiMvBwizViSy8R98Y4s
         oO3trWvdfpKWRqZf2ytciCFRfX2b69pwLnzld7pF9vYoQ+xSpmxoU4+JVUTozPXY6Y
         bOrePrv+97dj9Gx5iO0Rb2D1jvTgykJ7hvIUybt1WY1frQkRKwbkh10ABXu4JQvoo0
         ZSG1/VECVT09L0bUBLnx7r8UrrTAhK+NZzzuWm9AkOsGHhhE68oIQlnUnntYSf7gNC
         yOzFdegdYHqtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 05/38] bpf, x86: Use kvmalloc_array instead kmalloc_array in bpf_jit_comp
Date:   Mon, 29 Mar 2021 18:21:00 -0400
Message-Id: <20210329222133.2382393-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit de920fc64cbaa031f947e9be964bda05fd090380 ]

x86 bpf_jit_comp.c used kmalloc_array to store jited addresses
for each bpf insn. With a large bpf program, we have see the
following allocation failures in our production server:

    page allocation failure: order:5, mode:0x40cc0(GFP_KERNEL|__GFP_COMP),
                             nodemask=(null),cpuset=/,mems_allowed=0"
    Call Trace:
    dump_stack+0x50/0x70
    warn_alloc.cold.120+0x72/0xd2
    ? __alloc_pages_direct_compact+0x157/0x160
    __alloc_pages_slowpath+0xcdb/0xd00
    ? get_page_from_freelist+0xe44/0x1600
    ? vunmap_page_range+0x1ba/0x340
    __alloc_pages_nodemask+0x2c9/0x320
    kmalloc_order+0x18/0x80
    kmalloc_order_trace+0x1d/0xa0
    bpf_int_jit_compile+0x1e2/0x484
    ? kmalloc_order_trace+0x1d/0xa0
    bpf_prog_select_runtime+0xc3/0x150
    bpf_prog_load+0x480/0x720
    ? __mod_memcg_lruvec_state+0x21/0x100
    __do_sys_bpf+0xc31/0x2040
    ? close_pdeo+0x86/0xe0
    do_syscall_64+0x42/0x110
    entry_SYSCALL_64_after_hwframe+0x44/0xa9
    RIP: 0033:0x7f2f300f7fa9
    Code: Bad RIP value.

Dumped assembly:

    ffffffff810b6d70 <bpf_int_jit_compile>:
    ; {
    ffffffff810b6d70: e8 eb a5 b4 00        callq   0xffffffff81c01360 <__fentry__>
    ffffffff810b6d75: 41 57                 pushq   %r15
    ...
    ffffffff810b6f39: e9 72 fe ff ff        jmp     0xffffffff810b6db0 <bpf_int_jit_compile+0x40>
    ;       addrs = kmalloc_array(prog->len + 1, sizeof(*addrs), GFP_KERNEL);
    ffffffff810b6f3e: 8b 45 0c              movl    12(%rbp), %eax
    ;       return __kmalloc(bytes, flags);
    ffffffff810b6f41: be c0 0c 00 00        movl    $3264, %esi
    ;       addrs = kmalloc_array(prog->len + 1, sizeof(*addrs), GFP_KERNEL);
    ffffffff810b6f46: 8d 78 01              leal    1(%rax), %edi
    ;       if (unlikely(check_mul_overflow(n, size, &bytes)))
    ffffffff810b6f49: 48 c1 e7 02           shlq    $2, %rdi
    ;       return __kmalloc(bytes, flags);
    ffffffff810b6f4d: e8 8e 0c 1d 00        callq   0xffffffff81287be0 <__kmalloc>
    ;       if (!addrs) {
    ffffffff810b6f52: 48 85 c0              testq   %rax, %rax

Change kmalloc_array() to kvmalloc_array() to avoid potential
allocation error for big bpf programs.

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210309015647.3657852-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 796506dcfc42..49a506583e0c 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2019,7 +2019,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		extra_pass = true;
 		goto skip_init_addrs;
 	}
-	addrs = kmalloc_array(prog->len + 1, sizeof(*addrs), GFP_KERNEL);
+	addrs = kvmalloc_array(prog->len + 1, sizeof(*addrs), GFP_KERNEL);
 	if (!addrs) {
 		prog = orig_prog;
 		goto out_addrs;
@@ -2109,7 +2109,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		if (image)
 			bpf_prog_fill_jited_linfo(prog, addrs + 1);
 out_addrs:
-		kfree(addrs);
+		kvfree(addrs);
 		kfree(jit_data);
 		prog->aux->jit_data = NULL;
 	}
-- 
2.30.1

