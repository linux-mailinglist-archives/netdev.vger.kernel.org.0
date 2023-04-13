Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635CC6E060C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 06:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjDMEi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 00:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjDMEi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 00:38:28 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0F249E5;
        Wed, 12 Apr 2023 21:38:27 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id t16so1213025ybi.13;
        Wed, 12 Apr 2023 21:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681360706; x=1683952706;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MS/UxyC57lUwGz9QX871ec1zgDzFQgHjyyfwT7WS3A0=;
        b=WfQ0e1dVcV5OOpX+EpgBFfDPv42fe9OC1fUcGsVonNJVhHHYddIlXzbRyrfO7r3xvS
         HSc/MHnZ9TOWH5nGdmBkYAhoj5nwTydqfupv5/xPPcJYB3L7fuvKvlQwmfhYuWO6yEGW
         GAM0MYe1zfty0Jd33kin45JBy4Eb86y3nqaNh+Vt29NB5Av9Cgc9nciU70ejUhuFSYra
         c8mm9gM9hbWU9V1SirLtGECjO10gy/izM9Diz3whv4m5YRvR5BoXAohreQeaz8Mcrm99
         XFS5LoUj0t79o8C48QfjQVIRuHmwwQsJWj+dYGKbiI3GxBTiaMLRKiqWtSbWcvUu6TIX
         rCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681360706; x=1683952706;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MS/UxyC57lUwGz9QX871ec1zgDzFQgHjyyfwT7WS3A0=;
        b=XQd/YjLFuJ/ysjRdeA9P+u0NSzm1Lu1wLl5+jA9tf/wJN1ivijFh9glExmfMrkeW1p
         54hUjeoMQGbYRDbDbpagZl78pXrxGw+fOUT1OsavgxaXfbZoeLToxBRUSaTcNFvthBc7
         crC46pU0nSJDQuH4X98ATDu087bGcn1nPN1BJ7sTwvSwgffqZd24G31skD4n/0mtwWdh
         LgZBt4MwfaFl926hTzmAucqTK2pasKq/aTkCOiqD6D9C2lwkbOyBOrfxx9R3G4bGKXYj
         T23q3j7Ou3JFlgOZlalzbvuBzSd7toN2BLkdYaTlikRH+4HTFQREzJzYY26tUHeZmuVN
         4ILQ==
X-Gm-Message-State: AAQBX9f5LmFEGhjSsVHMNsbL+UhlZkswcB/65vhLAPXrvHu2nPbHVog2
        e1OhkJUu0xY/4XZHzgMzGQAPU/1+2LeVm5HwA0I=
X-Google-Smtp-Source: AKy350YolCBB7Db0rKSXSaEOhLqY+DmYXwdajO4gU1fQ7us7VC/RlPd67OmaLsysFgIAla6yvYvV+zei1TLX2Bd0nig=
X-Received: by 2002:a25:74c2:0:b0:b8f:1d90:e62a with SMTP id
 p185-20020a2574c2000000b00b8f1d90e62amr595626ybc.6.1681360705819; Wed, 12 Apr
 2023 21:38:25 -0700 (PDT)
MIME-Version: 1.0
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Wed, 12 Apr 2023 21:38:14 -0700
Message-ID: <CAGyP=7fgozOXe4p7GVouB5YHOuepQA5BD_npA_N6KGW=sEmFkw@mail.gmail.com>
Subject: KASAN: slab-out-of-bounds Read in taprio_dequeue_from_txq
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I found the following issue using syzkaller with enriched corpus on:
HEAD commit : 0bcc4025550403ae28d2984bddacafbca0a2f112
git tree: linux

C Reproducer : I do not have a C reproducer yet. I will update this
thread when I get one.
Kernel .config :
https://gist.github.com/oswalpalash/d9580b0bfce202b37445fa5fd426e41f

Console log :
==================================================================
BUG: KASAN: slab-out-of-bounds in taprio_dequeue_from_txq+0x7e3/0x8e0
Read of size 8 at addr ffff888110ad3380 by task syz-executor.1/18757

CPU: 1 PID: 18757 Comm: syz-executor.1 Not tainted
6.3.0-rc6-pasta-00035-g0bcc40255504 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0xd9/0x150
 print_address_description.constprop.0+0x2c/0x3c0
 kasan_report+0x11c/0x130
 taprio_dequeue_from_txq+0x7e3/0x8e0
 taprio_dequeue_tc_priority+0x272/0x440
 taprio_dequeue+0x12c/0x5e0
 __qdisc_run+0x1b2/0x1620
 net_tx_action+0x6e3/0xc20
 __do_softirq+0x1d4/0x905
 __irq_exit_rcu+0x114/0x190
 irq_exit_rcu+0x9/0x20
 sysvec_apic_timer_interrupt+0x97/0xc0
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20
RIP: 0010:__sanitizer_cov_trace_pc+0xb/0x70
Code: 0f 1e fa 48 8b be a8 01 00 00 e8 b0 ff ff ff 31 c0 c3 66 66 2e
0f 1f 84 00 00 00 00 00 66 90 f3 0f 1e fa 65 8b 05 fd c2 81 7e <89> c1
48 8b 34 24 81 e1 00 01 00 00 65 48 8b 14 25 c0 b8 03 00 a9
RSP: 0018:ffffc9000308fbf0 EFLAGS: 00000246
RAX: 0000000080000000 RBX: 000000000080ce08 RCX: ffffffff81713a44
RDX: ffff88811187e340 RSI: 0000000000000000 RDI: 0000000000000005
RBP: ffff888135c2b880 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc9000308fd98 R14: dffffc0000000000 R15: ffff88811187e340
 hrtimer_active+0xda/0x1f0
 hrtimer_try_to_cancel+0x25/0x4b0
 do_nanosleep+0x161/0x4f0
 hrtimer_nanosleep+0x19b/0x430
 common_nsleep+0xa6/0xd0
 __x64_sys_clock_nanosleep+0x32e/0x480
 do_syscall_64+0x39/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f5750abbe1f
Code: 44 00 00 b8 16 00 00 00 eb b2 90 89 7c 24 08 e8 77 e1 ff ff 8b
7c 24 08 4d 89 ea 4c 89 e2 41 89 c0 89 ee b8 e6 00 00 00 0f 05 <44> 89
c7 48 89 44 24 08 e8 b4 e1 ff ff 48 8b 44 24 08 e9 5e ff ff
RSP: 002b:00007ffc798ee300 EFLAGS: 00000293 ORIG_RAX: 00000000000000e6
RAX: ffffffffffffffda RBX: 0000000000000e01 RCX: 00007f5750abbe1f
RDX: 00007ffc798ee380 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffc79957080
R10: 0000000000000000 R11: 0000000000000293 R12: 00007ffc798ee380
R13: 0000000000000000 R14: 00007ffc798ee3fc R15: 0000000000000032
 </TASK>

Allocated by task 10073:
 kasan_save_stack+0x22/0x40
 kasan_set_track+0x25/0x30
 __kasan_kmalloc+0xa3/0xb0
 __kmalloc+0x5e/0x190
 taprio_init+0x319/0x8c0
 qdisc_create+0x4d1/0x1040
 tc_modify_qdisc+0x488/0x1a40
 rtnetlink_rcv_msg+0x43d/0xd50
 netlink_rcv_skb+0x165/0x440
 netlink_unicast+0x547/0x7f0
 netlink_sendmsg+0x926/0xe30
 sock_sendmsg+0xde/0x190
 ____sys_sendmsg+0x71c/0x900
 ___sys_sendmsg+0x110/0x1b0
 __sys_sendmsg+0xf7/0x1c0
 do_syscall_64+0x39/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888110ad3300
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 0 bytes to the right of
 allocated 128-byte region [ffff888110ad3300, ffff888110ad3380)

The buggy address belongs to the physical page:
page:ffffea000442b4c0 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x110ad3
flags: 0x57ff00000000200(slab|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000000200 ffff888012440400 ffffea0004432050 ffffea0004d34490
raw: 0000000000000000 ffff888110ad3000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask
0x242020(__GFP_HIGH|__GFP_NOWARN|__GFP_COMP|__GFP_THISNODE), pid
10056, tgid 10053 (syz-executor.0), ts 1299225545953, free_ts
1297773239495
 get_page_from_freelist+0x1190/0x2e20
 __alloc_pages+0x1cb/0x4a0
 cache_grow_begin+0x9b/0x3b0
 cache_alloc_refill+0x27f/0x380
 __kmem_cache_alloc_node+0x360/0x3f0
 kmalloc_trace+0x26/0xe0
 __hw_addr_add_ex+0x22d/0x7f0
 dev_addr_init+0x13e/0x220
 alloc_netdev_mqs+0x2f8/0x1250
 rtnl_create_link+0xbeb/0xee0
 __rtnl_newlink+0xfd2/0x1840
 rtnl_newlink+0x68/0xa0
 rtnetlink_rcv_msg+0x43d/0xd50
 netlink_rcv_skb+0x165/0x440
 netlink_unicast+0x547/0x7f0
 netlink_sendmsg+0x926/0xe30
page last free stack trace:
 free_pcp_prepare+0x5d5/0xa50
 free_unref_page+0x1d/0x490
 slabs_destroy+0x85/0xc0
 ___cache_free+0x204/0x3d0
 qlist_free_all+0x4f/0x1a0
 kasan_quarantine_reduce+0x192/0x220
 __kasan_slab_alloc+0x63/0x90
 kmem_cache_alloc+0x1bd/0x3f0
 __alloc_file+0x21/0x270
 alloc_empty_file+0x71/0x190
 alloc_file+0x5e/0x800
 alloc_file_pseudo+0x169/0x250
 sock_alloc_file+0x53/0x190
 __sys_socket+0x1a8/0x250
 __x64_sys_socket+0x73/0xb0
 do_syscall_64+0x39/0xb0

Memory state around the buggy address:
 ffff888110ad3280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888110ad3300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888110ad3380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff888110ad3400: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
 ffff888110ad3480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
----------------
Code disassembly (best guess):
   0:    0f 1e fa                 nop    %edx
   3:    48 8b be a8 01 00 00     mov    0x1a8(%rsi),%rdi
   a:    e8 b0 ff ff ff           callq  0xffffffbf
   f:    31 c0                    xor    %eax,%eax
  11:    c3                       retq
  12:    66 66 2e 0f 1f 84 00     data16 nopw %cs:0x0(%rax,%rax,1)
  19:    00 00 00 00
  1d:    66 90                    xchg   %ax,%ax
  1f:    f3 0f 1e fa              endbr64
  23:    65 8b 05 fd c2 81 7e     mov    %gs:0x7e81c2fd(%rip),%eax
   # 0x7e81c327
* 2a:    89 c1                    mov    %eax,%ecx <-- trapping instruction
  2c:    48 8b 34 24              mov    (%rsp),%rsi
  30:    81 e1 00 01 00 00        and    $0x100,%ecx
  36:    65 48 8b 14 25 c0 b8     mov    %gs:0x3b8c0,%rdx
  3d:    03 00
  3f:    a9                       .byte 0xa9
