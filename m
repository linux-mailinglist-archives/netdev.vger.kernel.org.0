Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3B562EE85
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 08:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241261AbiKRHhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 02:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241257AbiKRHhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 02:37:11 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961AD85A3E;
        Thu, 17 Nov 2022 23:37:09 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ud5so11008278ejc.4;
        Thu, 17 Nov 2022 23:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XtXs5KLfz7LH2f95HhbLW/HSSAQlufomWIu2ZxZAG1Y=;
        b=mfROCCJK3Yv/jZ4CHvImW+bLB2Tut6xN3wQPTAWkY7Yc+Plbrr/qpD6AjymbXguk3Y
         HMlGBGsaGicOgBUjsxsuvBUxN32WaEUKlji/9K/a/cLbYChaHIzSFAqTzdSkmqYCz2V8
         gCRNSN+9LWeKOlM8FqW/BOglgp3rnPXm3WfQKwPdFhR8hvl+4jGRJmh71RTG5977pghy
         gk50kN8IMmhT4liYjKDnrNSZuVwUzyPrasTGrPwuzD+hv3bym7iiqUIeJl/MSfvRW5u5
         LNSSbQgDnwn4lH4KlLwYujRK7vgPuMcK/2T5ZCkf2Lm34xu0DQq39zmT3JSfjjtU9UP2
         O52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XtXs5KLfz7LH2f95HhbLW/HSSAQlufomWIu2ZxZAG1Y=;
        b=ZzyRqsNEedYAA09+vdnp/iI2Pv2XQ/9o2ecXUL21FvvYJ3671N71Bdc2xHm6Olj2W5
         Qm6+p6tOuXVQZ7NDTkFgBWbqoSXw5LVKIpaQF8H7eY2jJ6z8e9OTuTKjhVlYIb2xCQ3/
         RwGP7+q8OQqm/2qs2ylcs31UrvhULIJKXUapRF5RWLz2+O1WIkCYphBwtVSyHLdlVPuQ
         fTvTCxVmE3T0VAhM2bUNoz6BMTFAHEf72DmKIyYsCzew44raHS5aVm23s/fOWKTyr5PR
         8iQYR+LpUEgzAvRrFTwFQJz3apBbBcuBl/bWIhCYAhfZTT0EzsFfOcXfgBb3rimtTGcP
         rxng==
X-Gm-Message-State: ANoB5plkEoDt+VxRowx0A/yFExyKHMinUy0oC1ZJP0rEgPI3BJr7bOWb
        wgJK+ewOjypj4owvlRxYsULNydzhNkgO6ze5mKY=
X-Google-Smtp-Source: AA0mqf58GZxOxO6RNN+bgUop+WZSzXGXI30+uCQSqAWINJZ1K5idJYQDr5xTn2dJP1Vxp6FAjykKt+Ix0kxgpuKDkHs=
X-Received: by 2002:a17:906:b29a:b0:78d:b695:1d68 with SMTP id
 q26-20020a170906b29a00b0078db6951d68mr5027924ejz.235.1668757027892; Thu, 17
 Nov 2022 23:37:07 -0800 (PST)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Fri, 18 Nov 2022 15:36:34 +0800
Message-ID: <CAO4mrfdb1UdjQxr0zLH9J8b6T+8kn4UOm-sO6nZ2aKErKg7i0A@mail.gmail.com>
Subject: KASAN: double-free in kfree
To:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, trix@redhat.com
Cc:     syzkaller-bugs@googlegroups.com, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux Developer,

Recently when using our tool to fuzz kernel, the following crash was triggered:

HEAD commit: 4fe89d07 Linux v6.0
git tree: upstream
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1_CdtSwaMJZmN-4dQw1mmZT0Ijq28X8aC/view?usp=share_link
kernel config: https://drive.google.com/file/d/1ZHRxVTXHL9mENdAPmQYS1DtgbflZ9XsD/view?usp=sharing

Unfortunately, I didn't have a reproducer for this bug yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

==================================================================
BUG: KASAN: double-free in slab_free mm/slub.c:3539 [inline]
BUG: KASAN: double-free in kfree+0xda/0x350 mm/slub.c:4567

CPU: 1 PID: 23425 Comm: syz-executor.0 Not tainted 6.0.0+ #39
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1b1/0x28e lib/dump_stack.c:106
 print_address_description+0x65/0x4b0 mm/kasan/report.c:317
 print_report+0x108/0x1f0 mm/kasan/report.c:433
 kasan_report_invalid_free+0x8f/0xb0 mm/kasan/report.c:462
 ____kasan_slab_free+0xfd/0x120
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1759 [inline]
 slab_free_freelist_hook+0x12e/0x1a0 mm/slub.c:1785
 slab_free mm/slub.c:3539 [inline]
 kfree+0xda/0x350 mm/slub.c:4567
 tcp_disconnect+0x9b9/0x19a0 net/ipv4/tcp.c:3144
 __mptcp_close_ssk+0x228/0x690 net/mptcp/protocol.c:2292
 mptcp_pm_nl_rm_addr_or_subflow+0x43d/0xa40 net/mptcp/pm_netlink.c:817
 mptcp_pm_nl_rm_subflow_received net/mptcp/pm_netlink.c:848 [inline]
 mptcp_nl_remove_id_zero_address net/mptcp/pm_netlink.c:1484 [inline]
 mptcp_nl_cmd_del_addr+0xa10/0x1470 net/mptcp/pm_netlink.c:1514
 genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0xf23/0x13f0 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2501
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7e7/0x9c0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0xb10/0xeb0 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x558/0x8a0 net/socket.c:2482
 ___sys_sendmsg net/socket.c:2536 [inline]
 __sys_sendmsg+0x23b/0x330 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f7a69e8bded
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7a6afcec58 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f7a69fabf80 RCX: 00007f7a69e8bded
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 00007f7a69ef8ce0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f7a69fabf80
R13: 00007ffe8d22030f R14: 00007ffe8d2204b0 R15: 00007f7a6afcedc0
 </TASK>

Allocated by task 23202:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:437 [inline]
 ____kasan_kmalloc+0xcd/0x100 mm/kasan/common.c:516
 kasan_kmalloc include/linux/kasan.h:234 [inline]
 __kmalloc+0x250/0x380 mm/slub.c:4429
 kmalloc include/linux/slab.h:605 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 tomoyo_encode2+0x266/0x550 security/tomoyo/realpath.c:45
 tomoyo_encode security/tomoyo/realpath.c:80 [inline]
 tomoyo_realpath_from_path+0x5c3/0x610 security/tomoyo/realpath.c:288
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x227/0x670 security/tomoyo/file.c:822
 security_inode_getattr+0xc0/0x140 security/security.c:1345
 vfs_getattr+0x26/0x360 fs/stat.c:157
 vfs_fstat fs/stat.c:182 [inline]
 __do_sys_newfstat fs/stat.c:435 [inline]
 __se_sys_newfstat+0xc6/0x810 fs/stat.c:432
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 23202:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x3d/0x60 mm/kasan/common.c:45
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:370
 ____kasan_slab_free+0xd8/0x120 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1759 [inline]
 slab_free_freelist_hook+0x12e/0x1a0 mm/slub.c:1785
 slab_free mm/slub.c:3539 [inline]
 kfree+0xda/0x350 mm/slub.c:4567
 tomoyo_path_perm+0x50c/0x670 security/tomoyo/file.c:842
 security_inode_getattr+0xc0/0x140 security/security.c:1345
 vfs_getattr+0x26/0x360 fs/stat.c:157
 vfs_fstat fs/stat.c:182 [inline]
 __do_sys_newfstat fs/stat.c:435 [inline]
 __se_sys_newfstat+0xc6/0x810 fs/stat.c:432
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Last potentially related work creation:
 kasan_save_stack+0x2b/0x50 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:348
 kvfree_call_rcu+0x117/0x7a0 kernel/rcu/tree.c:3322
 sctp_bind_addr_clean net/sctp/bind_addr.c:125 [inline]
 sctp_bind_addr_free+0x14b/0x1a0 net/sctp/bind_addr.c:134
 sctp_association_free+0x284/0x7b0 net/sctp/associola.c:358
 sctp_cmd_delete_tcb net/sctp/sm_sideeffect.c:944 [inline]
 sctp_cmd_interpreter+0x4099/0x5860 net/sctp/sm_sideeffect.c:1328
 sctp_side_effects+0x6c/0x1f0 net/sctp/sm_sideeffect.c:1199
 sctp_do_sm+0x220/0x530 net/sctp/sm_sideeffect.c:1170
 sctp_assoc_bh_rcv+0x42a/0x680 net/sctp/associola.c:1053
 sctp_backlog_rcv+0x16e/0x4c0 net/sctp/input.c:346
 sk_backlog_rcv include/net/sock.h:1100 [inline]
 __release_sock+0x106/0x3a0 net/core/sock.c:2852
 release_sock+0x5d/0x1c0 net/core/sock.c:3408
 sctp_wait_for_connect+0x3bc/0x6d0 net/sctp/socket.c:9310
 sctp_sendmsg_to_asoc+0x1359/0x13d0 net/sctp/socket.c:1879
 sctp_sendmsg+0x15ce/0x2bb0 net/sctp/socket.c:2025
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 __sys_sendto+0x46e/0x5f0 net/socket.c:2117
 __do_sys_sendto net/socket.c:2129 [inline]
 __se_sys_sendto net/socket.c:2125 [inline]
 __x64_sys_sendto+0xda/0xf0 net/socket.c:2125
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Second to last potentially related work creation:
 kasan_save_stack+0x2b/0x50 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:348
 kvfree_call_rcu+0x117/0x7a0 kernel/rcu/tree.c:3322
 sctp_bind_addr_clean net/sctp/bind_addr.c:125 [inline]
 sctp_bind_addr_free+0x14b/0x1a0 net/sctp/bind_addr.c:134
 sctp_association_free+0x284/0x7b0 net/sctp/associola.c:358
 sctp_cmd_delete_tcb net/sctp/sm_sideeffect.c:944 [inline]
 sctp_cmd_interpreter+0x4099/0x5860 net/sctp/sm_sideeffect.c:1328
 sctp_side_effects+0x6c/0x1f0 net/sctp/sm_sideeffect.c:1199
 sctp_do_sm+0x220/0x530 net/sctp/sm_sideeffect.c:1170
 sctp_assoc_bh_rcv+0x42a/0x680 net/sctp/associola.c:1053
 sctp_backlog_rcv+0x16e/0x4c0 net/sctp/input.c:346
 sk_backlog_rcv include/net/sock.h:1100 [inline]
 __release_sock+0x106/0x3a0 net/core/sock.c:2852
 release_sock+0x5d/0x1c0 net/core/sock.c:3408
 sctp_wait_for_connect+0x3bc/0x6d0 net/sctp/socket.c:9310
 sctp_sendmsg_to_asoc+0x1359/0x13d0 net/sctp/socket.c:1879
 sctp_sendmsg+0x15ce/0x2bb0 net/sctp/socket.c:2025
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 __sys_sendto+0x46e/0x5f0 net/socket.c:2117
 __do_sys_sendto net/socket.c:2129 [inline]
 __se_sys_sendto net/socket.c:2125 [inline]
 __x64_sys_sendto+0xda/0xf0 net/socket.c:2125
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888020aa8b00
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes inside of
 64-byte region [ffff888020aa8b00, ffff888020aa8b40)

The buggy address belongs to the physical page:
page:ffffea000082aa00 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x20aa8
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea0000627c00 dead000000000002 ffff888011841640
raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask
0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 16496, tgid 16495
(syz-executor.0), ts 410147424681, free_ts 410047997356
 prep_new_page mm/page_alloc.c:2532 [inline]
 get_page_from_freelist+0x739/0xab0 mm/page_alloc.c:4283
 __alloc_pages+0x283/0x5f0 mm/page_alloc.c:5549
 alloc_slab_page+0x70/0xf0 mm/slub.c:1829
 allocate_slab+0x5e/0x520 mm/slub.c:1974
 new_slab mm/slub.c:2034 [inline]
 ___slab_alloc+0x3de/0xc30 mm/slub.c:3036
 __slab_alloc mm/slub.c:3123 [inline]
 slab_alloc_node mm/slub.c:3214 [inline]
 slab_alloc mm/slub.c:3256 [inline]
 kmem_cache_alloc_trace+0x286/0x320 mm/slub.c:3287
 kmalloc include/linux/slab.h:600 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 register_ip_vs_proto_netns net/netfilter/ipvs/ip_vs_proto.c:70 [inline]
 ip_vs_protocol_net_init+0xc9/0x4d0 net/netfilter/ipvs/ip_vs_proto.c:318
 __ip_vs_init+0x271/0x3e0 net/netfilter/ipvs/ip_vs_core.c:2313
 ops_init+0x313/0x430 net/core/net_namespace.c:134
 setup_net+0x35b/0xa30 net/core/net_namespace.c:325
 copy_net_ns+0x359/0x5c0 net/core/net_namespace.c:471
 create_new_namespaces+0x4ce/0xa00 kernel/nsproxy.c:110
 copy_namespaces+0x333/0x390 kernel/nsproxy.c:178
 copy_process+0x2c2e/0x6130 kernel/fork.c:2257
 kernel_clone+0x21a/0x7d0 kernel/fork.c:2671
 __do_sys_clone3 kernel/fork.c:2963 [inline]
 __se_sys_clone3+0x357/0x400 kernel/fork.c:2947
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1449 [inline]
 free_pcp_prepare+0xd20/0xec0 mm/page_alloc.c:1499
 free_unref_page_prepare mm/page_alloc.c:3380 [inline]
 free_unref_page+0x8b/0x790 mm/page_alloc.c:3476
 free_slab mm/slub.c:2073 [inline]
 discard_slab mm/slub.c:2079 [inline]
 __unfreeze_partials+0x1ab/0x200 mm/slub.c:2553
 put_cpu_partial+0x106/0x170 mm/slub.c:2629
 qlist_free_all mm/kasan/quarantine.c:187 [inline]
 kasan_quarantine_reduce+0x128/0x190 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x2f/0xd0 mm/kasan/common.c:447
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:727 [inline]
 slab_alloc_node mm/slub.c:3248 [inline]
 slab_alloc mm/slub.c:3256 [inline]
 __kmalloc+0x1e9/0x380 mm/slub.c:4425
 kmalloc include/linux/slab.h:605 [inline]
 tomoyo_realpath_from_path+0xd8/0x610 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x227/0x670 security/tomoyo/file.c:822
 security_inode_getattr+0xc0/0x140 security/security.c:1345
 vfs_getattr+0x26/0x360 fs/stat.c:157
 vfs_fstat fs/stat.c:182 [inline]
 __do_sys_newfstat fs/stat.c:435 [inline]
 __se_sys_newfstat+0xc6/0x810 fs/stat.c:432
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff888020aa8a00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888020aa8a80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff888020aa8b00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                   ^
 ffff888020aa8b80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888020aa8c00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
==================================================================

Best,
Wei
