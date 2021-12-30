Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F3B481AE6
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 09:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237862AbhL3IxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 03:53:05 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:41496 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhL3IxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 03:53:04 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E2B511F37D;
        Thu, 30 Dec 2021 08:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1640854382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T3vjpe5wh37Ag5AnOi3WIBaJix43vROrMlLKQ5Y7MOM=;
        b=HYdkICGnEOe9BvUfM97pUxdpG3i3oD8XkNWLnl4/pNt/gbYCCNbGg/XuF07c+56V8Y71GX
        jI1PUBUDFW1TSANGTlHWJrSS2PwLtfBKVGA7NJn56sr4Z9k23/6vdzfC5Ihs4ofj/lEBZB
        ckxG9xl+tJ8Ug+TauAD8bdhYu44th7s=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4E011A3B83;
        Thu, 30 Dec 2021 08:53:02 +0000 (UTC)
Date:   Thu, 30 Dec 2021 09:53:01 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     syzbot <syzbot+864849a13d44b22de04d@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        changbin.du@intel.com, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, hawk@kernel.org, hkallweit1@gmail.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yajun.deng@linux.dev, yhs@fb.com,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [syzbot] general protection fault in mod_memcg_page_state
Message-ID: <Yc1zbYqVO/6b6Uhf@dhcp22.suse.cz>
References: <00000000000049f33f05d4535526@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000049f33f05d4535526@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Cc Shakeel]

On Wed 29-12-21 17:54:21, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ea586a076e8a Add linux-next specific files for 20211224
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16dc61edb00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a9c4e3dde2c568fb
> dashboard link: https://syzkaller.appspot.com/bug?extid=864849a13d44b22de04d
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17371b99b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14519ac3b00000
> 
> The issue was bisected to:
> 
> commit e4b8954074f6d0db01c8c97d338a67f9389c042f
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Tue Dec 7 01:30:37 2021 +0000
> 
>     netlink: add net device refcount tracker to struct ethnl_req_info
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14f00ddbb00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16f00ddbb00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=12f00ddbb00000

I am confused. The above log points to the following warning and
a consequent panic_on_warn
WARNING: CPU: 0 PID: 10 at lib/ref_tracker.c:38 ref_tracker_dir_exit.cold+0x163/0x1b4
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+864849a13d44b22de04d@syzkaller.appspotmail.com
> Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 1 PID: 3677 Comm: syz-executor257 Not tainted 5.16.0-rc6-next-20211224-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:_compound_head include/linux/page-flags.h:263 [inline]
> RIP: 0010:page_memcg include/linux/memcontrol.h:452 [inline]
> RIP: 0010:mod_memcg_page_state.part.0.constprop.0+0x28/0x5b0 include/linux/memcontrol.h:957

This might have something to do with http://lkml.kernel.org/r/20211222052457.1960701-1-shakeelb@google.com
which has added the accounting which is blowing up. The problem happens
when a memcg is retrieved from the allocated page. This should be NULL
as the reported commit doesn't really add any __GFP_ACCOUNT user AFAICS.
Anyway vm_area_alloc_pages can fail the allocation if the current
context has fatal signals pending. array->pages array is allocated with
__GFP_ZERO so the failed allocation should have kept the pages[0] NULL.
I haven't followed the page->memcg path to double check whether that
could lead to 0xdffffc0000000001 in the end.

I believe we need something like
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 9bf838817a47..d2e392cac909 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2627,7 +2627,8 @@ static void __vunmap(const void *addr, int deallocate_pages)
 		unsigned int page_order = vm_area_page_order(area);
 		int i;
 
-		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
+		if (area->pages[0])
+			mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
 				     -area->nr_pages);
 
 		for (i = 0; i < area->nr_pages; i += 1U << page_order) {
@@ -2968,7 +2969,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
-	mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC, area->nr_pages);
+	if (area->pages[0])
+		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC, area->nr_pages);
 
 	/*
 	 * If not enough pages were obtained to accomplish an

Or to account each page separately so that we do not have to rely on
pages[0].

> Code: 00 90 41 56 41 55 41 54 41 89 f4 55 48 89 fd 53 4c 8d 6d 08 e8 49 dd c1 ff 4c 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 11 05 00 00 4c 8b 75 08 31 ff 4c 89 f3 83 e3 01
> RSP: 0018:ffffc900028bf5c0 EFLAGS: 00010202
> 
> RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: ffffffff81b62737 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff81b745c0 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000008 R14: ffff88807ee9b628 R15: ffff88807ee9b600
> FS:  00007f8d769be700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffe642c4960 CR3: 000000006fc65000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  mod_memcg_page_state mm/vmalloc.c:2971 [inline]
>  __vmalloc_area_node mm/vmalloc.c:2971 [inline]
>  __vmalloc_node_range+0x678/0xf80 mm/vmalloc.c:3106
>  __vmalloc_node mm/vmalloc.c:3156 [inline]
>  vmalloc+0x67/0x80 mm/vmalloc.c:3197
>  bpf_prog_calc_tag+0xc9/0x6c0 kernel/bpf/core.c:279
>  resolve_pseudo_ldimm64 kernel/bpf/verifier.c:11925 [inline]
>  bpf_check+0x1c86/0xbac0 kernel/bpf/verifier.c:14279
>  bpf_prog_load+0xf55/0x21f0 kernel/bpf/syscall.c:2344
>  __sys_bpf+0x68a/0x5970 kernel/bpf/syscall.c:4634
>  __do_sys_bpf kernel/bpf/syscall.c:4738 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:4736 [inline]
>  __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4736
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f8d76a0cd09
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f8d769be2f8 EFLAGS: 00000246
>  ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f8d76a954a8 RCX: 00007f8d76a0cd09
> RDX: 0000000000000080 RSI: 0000000020000200 RDI: 0000000000000005
> RBP: 00007f8d76a954a0 R08: 0000000000000002 R09: 0000000000003032
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
> R13: 00007f8d769be300 R14: 00007f8d769be400 R15: 0000000000022000
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:_compound_head include/linux/page-flags.h:263 [inline]
> RIP: 0010:page_memcg include/linux/memcontrol.h:452 [inline]
> RIP: 0010:mod_memcg_page_state.part.0.constprop.0+0x28/0x5b0 include/linux/memcontrol.h:957
> Code: 00 90 41 56 41 55 41 54 41 89 f4 55 48 89 fd 53 4c 8d 6d 08 e8 49 dd c1 ff 4c 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 11 05 00 00 4c 8b 75 08 31 ff 4c 89 f3 83 e3 01
> RSP: 0018:ffffc900028bf5c0 EFLAGS: 00010202
> 
> RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: ffffffff81b62737 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff81b745c0 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000008 R14: ffff88807ee9b628 R15: ffff88807ee9b600
> FS:  00007f8d769be700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f8d76a76e84 CR3: 000000006fc65000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:	00 90 41 56 41 55    	add    %dl,0x55415641(%rax)
>    6:	41 54                	push   %r12
>    8:	41 89 f4             	mov    %esi,%r12d
>    b:	55                   	push   %rbp
>    c:	48 89 fd             	mov    %rdi,%rbp
>    f:	53                   	push   %rbx
>   10:	4c 8d 6d 08          	lea    0x8(%rbp),%r13
>   14:	e8 49 dd c1 ff       	callq  0xffc1dd62
>   19:	4c 89 ea             	mov    %r13,%rdx
>   1c:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>   23:	fc ff df
>   26:	48 c1 ea 03          	shr    $0x3,%rdx
> * 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
>   2e:	0f 85 11 05 00 00    	jne    0x545
>   34:	4c 8b 75 08          	mov    0x8(%rbp),%r14
>   38:	31 ff                	xor    %edi,%edi
>   3a:	4c 89 f3             	mov    %r14,%rbx
>   3d:	83 e3 01             	and    $0x1,%ebx
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

-- 
Michal Hocko
SUSE Labs
