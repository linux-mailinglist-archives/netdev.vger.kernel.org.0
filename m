Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79393FF7EE
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345950AbhIBXhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:37:25 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:55970 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345889AbhIBXhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 19:37:24 -0400
Received: by mail-il1-f200.google.com with SMTP id c16-20020a92cf500000b02902243aec7e27so2313147ilr.22
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 16:36:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JOY88l9jkqjrk7r59YqYH4McD3EoA2sjEyU/prp079A=;
        b=lQhFPH93K+0dWV1Is1pdhmQpX/5ZrSOJyy6crWJdZbRaE/0qpD/768zM/cVRqSpN+7
         F/FcIa7RgMAUsKYek24qBdltguuKJMUr8rQPc+nKb45PplO7kbSGLsPtRh6bdgoC3u1i
         Z+Iy6dD8ihqeH44oXm55zkRIAbbNCwMtSCQf6sh7yIeeyzJMEyu0dJPJ2kOUnTKLL6WP
         Y8dDZl0nyWX2apmyQaIDkddzLzJdmdUGQLVUuw+ow0n1sCuxD71gDR2gZwiFsS7aZ7hE
         K4mcpg3i09TvRxYPekmhgbSnm4F1U83hN9bkmV+nYUBxE10EAW4rHuJ0dL4GA3JRt43I
         bmYg==
X-Gm-Message-State: AOAM533gfYhZ8gvDl/EwJhcKsIjas2IOEA1FtfveZpuk+wIlAsiIRRmv
        ed73dQU9HuQTt88NAmuVdjSNN+QFf9T6M1ASuIj5rC4kkhSE
X-Google-Smtp-Source: ABdhPJynw0dSR8fm0oeFoXtZmtA9ZBTi0GTjBndFUXc+ukahli/YNsSKuGn5yfApT44UlGuvcOHZZZuxAMk7tn/FQuVt7xI/U0/P
MIME-Version: 1.0
X-Received: by 2002:a5d:8715:: with SMTP id u21mr700462iom.1.1630625785511;
 Thu, 02 Sep 2021 16:36:25 -0700 (PDT)
Date:   Thu, 02 Sep 2021 16:36:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b503bc05cb0ba623@google.com>
Subject: [syzbot] KASAN: use-after-free Read in __crypto_xor
From:   syzbot <syzbot+b187b77c8474f9648fae@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, daniel.m.jordan@oracle.com,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        josh@joshtriplett.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3e12361b6d23 bcm63xx_enet: delete a redundant assignment
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=160cec72300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=63a23a80f42a8989
dashboard link: https://syzkaller.appspot.com/bug?extid=b187b77c8474f9648fae
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144d07b6300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=171b7fca300000

The issue was bisected to:

commit 4611ce22468895acd61fee9ac1da810d60617d9a
Author: Daniel Jordan <daniel.m.jordan@oracle.com>
Date:   Wed Jun 3 22:59:39 2020 +0000

    padata: allocate work structures for parallel jobs from a pool

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=118dccae300000
console output: https://syzkaller.appspot.com/x/log.txt?x=158dccae300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b187b77c8474f9648fae@syzkaller.appspotmail.com
Fixes: 4611ce224688 ("padata: allocate work structures for parallel jobs from a pool")

==================================================================
BUG: KASAN: use-after-free in __crypto_xor+0x376/0x410 crypto/algapi.c:1001
Read of size 8 at addr ffff88803691a000 by task kworker/u4:1/10

CPU: 1 PID: 10 Comm: kworker/u4:1 Not tainted 5.14.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: pencrypt_parallel padata_parallel_worker
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
 __crypto_xor+0x376/0x410 crypto/algapi.c:1001
 crypto_xor include/crypto/algapi.h:160 [inline]
 crypto_ctr_crypt_segment crypto/ctr.c:60 [inline]
 crypto_ctr_crypt+0x256/0x550 crypto/ctr.c:114
 crypto_skcipher_encrypt+0xaa/0xf0 crypto/skcipher.c:630
 crypto_gcm_encrypt+0x38f/0x4b0 crypto/gcm.c:461
 crypto_aead_encrypt+0xaa/0xf0 crypto/aead.c:94
 pcrypt_aead_enc+0x13/0x70 crypto/pcrypt.c:82
 padata_parallel_worker+0x60/0xb0 kernel/padata.c:157
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the page:
page:ffffea0000da4680 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3691a
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 ffffea0000dafd48 ffffea0000dad888 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x400dc0(GFP_KERNEL_ACCOUNT|__GFP_ZERO), pid 8358, ts 60335781621, free_ts 60341472040
 prep_new_page mm/page_alloc.c:2433 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4166
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5388
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 __pte_alloc_one include/asm-generic/pgalloc.h:63 [inline]
 pte_alloc_one+0x16/0x230 arch/x86/mm/pgtable.c:33
 do_fault_around mm/memory.c:4136 [inline]
 do_read_fault mm/memory.c:4157 [inline]
 do_fault mm/memory.c:4291 [inline]
 handle_pte_fault mm/memory.c:4549 [inline]
 __handle_mm_fault+0x49de/0x5320 mm/memory.c:4684
 handle_mm_fault+0x1c8/0x790 mm/memory.c:4782
 do_user_addr_fault+0x48b/0x11c0 arch/x86/mm/fault.c:1390
 handle_page_fault arch/x86/mm/fault.c:1475 [inline]
 exc_page_fault+0x9e/0x180 arch/x86/mm/fault.c:1531
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:568
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1343 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1394
 free_unref_page_prepare mm/page_alloc.c:3329 [inline]
 free_unref_page_list+0x1a1/0x1050 mm/page_alloc.c:3445
 release_pages+0x824/0x20b0 mm/swap.c:972
 tlb_batch_pages_flush mm/mmu_gather.c:49 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:242 [inline]
 tlb_flush_mmu mm/mmu_gather.c:249 [inline]
 tlb_finish_mmu+0x165/0x8c0 mm/mmu_gather.c:340
 exit_mmap+0x1ea/0x620 mm/mmap.c:3203
 __mmput+0x122/0x470 kernel/fork.c:1101
 mmput+0x58/0x60 kernel/fork.c:1122
 exit_mm kernel/exit.c:501 [inline]
 do_exit+0xae2/0x2a60 kernel/exit.c:812
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff888036919f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888036919f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88803691a000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff88803691a080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88803691a100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
