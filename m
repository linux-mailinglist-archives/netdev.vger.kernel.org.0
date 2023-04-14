Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B0D6E1A64
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 04:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjDNCll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 22:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjDNClk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 22:41:40 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E72F12E;
        Thu, 13 Apr 2023 19:41:39 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-54f21cdfadbso269304357b3.7;
        Thu, 13 Apr 2023 19:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681440098; x=1684032098;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uCQMt8cMs8DxFEFNrCKpJ5Bu3JvDPxBtqOh+eBAPKFQ=;
        b=QI/Y4ISS3uL12Lfe9mvKnWg0LCFpPXN5t1PCWKENs5OOcdYD1s7ztFAIghlNqV9jf5
         y5Rcyzy9Fe8p5WWc42w6R6XHx745pDyRxx5ziw0nSbZu+3jfzeEU4fSPQEsDwy5BQXde
         GFqFZ11B+3vo87nXnyrNvlKECHjGSU3j9FZFZ8aTb6r1yBmcaMSDFkJHF24LM/7r6JXV
         t4aDPurg/3/gNRo5/TFYD87+8HM6Lr9OZjRwS0+MhObanuHyZ2RQdIy0JJ0WjU7jfqEl
         63+X7Q9h+89xOZFnwq6IqTuwQPC3zo6IF3MPm8Yi2szgocXi8rfj61O+I9TjOKKujwV2
         eXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681440098; x=1684032098;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uCQMt8cMs8DxFEFNrCKpJ5Bu3JvDPxBtqOh+eBAPKFQ=;
        b=T94es5pTCI8nMAr5ftdaEqBjPWFwQ2nw+Jn0bpJ+FAt6iXkOTD3PG0XtrZn8YnlQzH
         sRDafwWtvIV7XPUTTilUP6dnh5rXbiSmzPDhpziBbpUOap5IupLn8l+qBnp6Na8hDNOX
         k8TDJNThOaZ1AHaN3PgJ7Exh5sOSXh6Q0Az3LZnQtLai1fUy82viFoO7u2vFOcZpsaro
         +LshWirfUtHOHyY/6FQvgObKNH9P2fMvQOVKvl3bxcO8LAZJpDoIwrYQ/jQ4vPF4dx3J
         pnMZxjuOPF06qGR/6FInlY8cZ5QGYl4R2nwWVIY1PacBYfHrodHAgZVeaGfxFi3SKbeL
         JbfQ==
X-Gm-Message-State: AAQBX9cufgNfUk7JVc7ht4O1mfjeEmScLrK0kIyETKyMCtDt7P/fUJLD
        yRlT59wylpQlVGaDRjcIZoRzwYe5XjCx6wLmYnQ=
X-Google-Smtp-Source: AKy350aTOEC3Y8J6cuTRQ+mv2DZ6j2Fb0A0LFbjHkw4guNAugI1FTviKUArZtv+PftMeAZ0sUf3BEWOnDXOWSYehW1Q=
X-Received: by 2002:a81:af1e:0:b0:54e:edf3:b48f with SMTP id
 n30-20020a81af1e000000b0054eedf3b48fmr2629038ywh.5.1681440098174; Thu, 13 Apr
 2023 19:41:38 -0700 (PDT)
MIME-Version: 1.0
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Thu, 13 Apr 2023 19:41:26 -0700
Message-ID: <CAGyP=7djcPOF6JHvVV6Zmpvtb_nHsDM7865C3e4A5F06kF8FsQ@mail.gmail.com>
Subject: KASAN: slab-use-after-free Read in tcf_action_destroy
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
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

C Reproducer : https://gist.github.com/oswalpalash/278b6fb713f37fa8d4625d6be703550d
Kernel .config :
https://gist.github.com/oswalpalash/d9580b0bfce202b37445fa5fd426e41f

syz-repro :
r0 = socket$nl_route(0x10, 0x3, 0x0)
r1 = socket(0x10, 0x3, 0x0)
r2 = socket(0x10, 0x3, 0x0)
sendmsg$nl_route_sched(r2, &(0x7f0000000180)={0x0, 0x0,
&(0x7f0000000140)={0x0, 0x140}}, 0x0)
getsockname$packet(r2, &(0x7f0000000080)={0x11, 0x0, <r3=>0x0, 0x1,
0x0, 0x6, @broadcast}, &(0x7f0000000100)=0xab)
sendmsg$nl_route_sched(r1, &(0x7f0000005840)={0x0, 0x0,
&(0x7f0000000780)={&(0x7f0000000240)=ANY=[@ANYBLOB="4800000024000b0e00"/20,
@ANYRES32=r3, @ANYBLOB="00000000ffffffff0000000008000100687462001c0002001800020003"],
0x48}}, 0x0)
sendmsg$nl_route_sched(r0, &(0x7f00000000c0)={0x0, 0x0,
&(0x7f0000000180)={&(0x7f00000007c0)=@newtfilter={0x40, 0x2c, 0xd27,
0x0, 0x0, {0x0, 0x0, 0x0, r3, {}, {}, {0xfff3}},
[@filter_kind_options=@f_flower={{0xb}, {0x10, 0x2,
[@TCA_FLOWER_KEY_ETH_DST={0xa, 0x4, @local}]}}]}, 0x40}}, 0x0)
(fail_nth: 19)


Console log :

==================================================================
BUG: KASAN: slab-use-after-free in tcf_action_destroy+0x17f/0x1b0
Read of size 8 at addr ffff88811024d800 by task kworker/u4:1/11

CPU: 1 PID: 11 Comm: kworker/u4:1 Not tainted
6.3.0-rc6-pasta-00035-g0bcc40255504 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: tc_filter_workqueue fl_destroy_filter_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xd9/0x150
 print_address_description.constprop.0+0x2c/0x3c0
 kasan_report+0x11c/0x130
 tcf_action_destroy+0x17f/0x1b0
 tcf_exts_destroy+0xc5/0x160
 __fl_destroy_filter+0x1a/0x100
 process_one_work+0x991/0x15c0
 worker_thread+0x669/0x1090
 kthread+0x2e8/0x3a0
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 9570:
 kasan_save_stack+0x22/0x40
 kasan_set_track+0x25/0x30
 __kasan_kmalloc+0xa3/0xb0
 tcf_exts_init_ex+0xe4/0x5a0
 fl_change+0x56f/0x4a20
 tc_new_tfilter+0x995/0x22a0
 rtnetlink_rcv_msg+0x996/0xd50
 netlink_rcv_skb+0x165/0x440
 netlink_unicast+0x547/0x7f0
 netlink_sendmsg+0x926/0xe30
 sock_sendmsg+0xde/0x190
 ____sys_sendmsg+0x71c/0x900
 ___sys_sendmsg+0x110/0x1b0
 __sys_sendmsg+0xf7/0x1c0
 do_syscall_64+0x39/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 9570:
 kasan_save_stack+0x22/0x40
 kasan_set_track+0x25/0x30
 kasan_save_free_info+0x2b/0x40
 ____kasan_slab_free+0x13b/0x1a0
 __kmem_cache_free+0xcd/0x2c0
 tcf_exts_destroy+0xe5/0x160
 tcf_exts_init_ex+0x484/0x5a0
 fl_change+0x56f/0x4a20
 tc_new_tfilter+0x995/0x22a0
 rtnetlink_rcv_msg+0x996/0xd50
 netlink_rcv_skb+0x165/0x440
 netlink_unicast+0x547/0x7f0
 netlink_sendmsg+0x926/0xe30
 sock_sendmsg+0xde/0x190
 ____sys_sendmsg+0x71c/0x900
 ___sys_sendmsg+0x110/0x1b0
 __sys_sendmsg+0xf7/0x1c0
 do_syscall_64+0x39/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88811024d800
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 0 bytes inside of
 freed 256-byte region [ffff88811024d800, ffff88811024d900)

The buggy address belongs to the physical page:
page:ffffea0004409340 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x11024d
flags: 0x57ff00000000200(slab|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000000200 ffff888012440500 ffffea000436ea10 ffffea00041aec10
raw: 0000000000000000 ffff88811024d000 0000000100000008 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask
0x2420c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_THISNODE),
pid 8017, tgid 8017 (syz-executor.0), ts 60719725774, free_ts
60718847244
 get_page_from_freelist+0x1190/0x2e20
 __alloc_pages+0x1cb/0x4a0
 cache_grow_begin+0x9b/0x3b0
 cache_alloc_refill+0x27f/0x380
 __kmem_cache_alloc_node+0x360/0x3f0
 __kmalloc+0x4e/0x190
 security_sb_alloc+0x105/0x240
 alloc_super+0x236/0xb60
 sget_fc+0x142/0x7c0
 vfs_get_super+0x2d/0x280
 vfs_get_tree+0x8d/0x350
 path_mount+0x1342/0x1e40
 __x64_sys_mount+0x283/0x300
 do_syscall_64+0x39/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 free_pcp_prepare+0x5d5/0xa50
 free_unref_page+0x1d/0x490
 vfree+0x180/0x7e0
 delayed_vfree_work+0x57/0x70
 process_one_work+0x991/0x15c0
 worker_thread+0x669/0x1090
 kthread+0x2e8/0x3a0
 ret_from_fork+0x1f/0x30

Memory state around the buggy address:
 ffff88811024d700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88811024d780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88811024d800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88811024d880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88811024d900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
