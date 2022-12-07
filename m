Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3BB264547F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 08:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiLGHVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 02:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiLGHUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 02:20:44 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398FE3B9FE;
        Tue,  6 Dec 2022 23:20:09 -0800 (PST)
Received: from dggpemm500015.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NRpYy0D6xzJqHW;
        Wed,  7 Dec 2022 15:19:18 +0800 (CST)
Received: from [10.174.177.133] (10.174.177.133) by
 dggpemm500015.china.huawei.com (7.185.36.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Dec 2022 15:19:53 +0800
Subject: Re: [syzbot] memory leak in tcindex_set_parms (3)
To:     syzbot <syzbot+2f9183cb6f89b0e16586@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <jhs@mojatatu.com>,
        <jiri@resnulli.us>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>,
        <xiyou.wangcong@gmail.com>, "liwei (GF)" <liwei391@huawei.com>
References: <000000000000e0df2d05ef2d8b91@google.com>
From:   "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>
Message-ID: <1ad68075-c293-bdb4-950b-5d4c138e5ff5@huawei.com>
Date:   Wed, 7 Dec 2022 15:19:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <000000000000e0df2d05ef2d8b91@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.133]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500015.china.huawei.com (7.185.36.181)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it looks like a invalid problem,
as tc_new_tfilter->...tcf_exts_change() will destroy and free former action.

在 2022/12/7 3:09, syzbot 写道:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    355479c70a48 Merge tag 'efi-fixes-for-v6.1-4' of git://git..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16aef6bd880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=979161df0e247659
> dashboard link: https://syzkaller.appspot.com/bug?extid=2f9183cb6f89b0e16586
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d1ac47880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154f3bad880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/104ddf75422d/disk-355479c7.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d32483369fdb/vmlinux-355479c7.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f10fb444c08d/bzImage-355479c7.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2f9183cb6f89b0e16586@syzkaller.appspotmail.com
> 
> executing program
> BUG: memory leak
> unreferenced object 0xffff888107813900 (size 256):
>    comm "syz-executor147", pid 3623, jiffies 4294944130 (age 12.710s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff814eda10>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1045
>      [<ffffffff83c0dda7>] kmalloc include/linux/slab.h:553 [inline]
>      [<ffffffff83c0dda7>] kmalloc_array include/linux/slab.h:604 [inline]
>      [<ffffffff83c0dda7>] kcalloc include/linux/slab.h:636 [inline]
>      [<ffffffff83c0dda7>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
>      [<ffffffff83c0dda7>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
>      [<ffffffff83c0e9bf>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
>      [<ffffffff83b91842>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
>      [<ffffffff83ae1b6c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
>      [<ffffffff83c2fae7>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
>      [<ffffffff83c2ec07>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>      [<ffffffff83c2ec07>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
>      [<ffffffff83c2f0c6>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
>      [<ffffffff83a812f6>] sock_sendmsg_nosec net/socket.c:714 [inline]
>      [<ffffffff83a812f6>] sock_sendmsg+0x56/0x80 net/socket.c:734
>      [<ffffffff83a81668>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
>      [<ffffffff83a86218>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
>      [<ffffffff83a86565>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
>      [<ffffffff83a867b4>] __do_sys_sendmmsg net/socket.c:2651 [inline]
>      [<ffffffff83a867b4>] __se_sys_sendmmsg net/socket.c:2648 [inline]
>      [<ffffffff83a867b4>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
>      [<ffffffff8485b3b5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>      [<ffffffff8485b3b5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>      [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> BUG: memory leak
> unreferenced object 0xffff88810ea1af00 (size 256):
>    comm "syz-executor147", pid 3623, jiffies 4294944131 (age 12.700s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff814eda10>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1045
>      [<ffffffff83c0dda7>] kmalloc include/linux/slab.h:553 [inline]
>      [<ffffffff83c0dda7>] kmalloc_array include/linux/slab.h:604 [inline]
>      [<ffffffff83c0dda7>] kcalloc include/linux/slab.h:636 [inline]
>      [<ffffffff83c0dda7>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
>      [<ffffffff83c0dda7>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
>      [<ffffffff83c0e9bf>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
>      [<ffffffff83b91842>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
>      [<ffffffff83ae1b6c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
>      [<ffffffff83c2fae7>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
>      [<ffffffff83c2ec07>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>      [<ffffffff83c2ec07>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
>      [<ffffffff83c2f0c6>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
>      [<ffffffff83a812f6>] sock_sendmsg_nosec net/socket.c:714 [inline]
>      [<ffffffff83a812f6>] sock_sendmsg+0x56/0x80 net/socket.c:734
>      [<ffffffff83a81668>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
>      [<ffffffff83a86218>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
>      [<ffffffff83a86565>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
>      [<ffffffff83a867b4>] __do_sys_sendmmsg net/socket.c:2651 [inline]
>      [<ffffffff83a867b4>] __se_sys_sendmmsg net/socket.c:2648 [inline]
>      [<ffffffff83a867b4>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
>      [<ffffffff8485b3b5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>      [<ffffffff8485b3b5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>      [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> BUG: memory leak
> unreferenced object 0xffff88810a452680 (size 64):
>    comm "kworker/0:1", pid 42, jiffies 4294944576 (age 8.250s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      ff ff ff ff 00 00 00 00 00 00 00 00 30 30 00 00  ............00..
>    backtrace:
>      [<ffffffff814eda10>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1045
>      [<ffffffff842bb5c2>] kmalloc include/linux/slab.h:553 [inline]
>      [<ffffffff842bb5c2>] kzalloc include/linux/slab.h:689 [inline]
>      [<ffffffff842bb5c2>] regulatory_hint_core+0x22/0x60 net/wireless/reg.c:3248
>      [<ffffffff842c1720>] restore_regulatory_settings+0x690/0x910 net/wireless/reg.c:3582
>      [<ffffffff842c1aad>] crda_timeout_work+0x1d/0x30 net/wireless/reg.c:540
>      [<ffffffff8129197a>] process_one_work+0x2ba/0x5f0 kernel/workqueue.c:2289
>      [<ffffffff81292299>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2436
>      [<ffffffff8129c315>] kthread+0x125/0x160 kernel/kthread.c:376
>      [<ffffffff8100224f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
> 
> BUG: memory leak
> unreferenced object 0xffff88810e11c100 (size 256):
>    comm "syz-executor147", pid 3629, jiffies 4294944659 (age 7.420s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff814eda10>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1045
>      [<ffffffff83c0dda7>] kmalloc include/linux/slab.h:553 [inline]
>      [<ffffffff83c0dda7>] kmalloc_array include/linux/slab.h:604 [inline]
>      [<ffffffff83c0dda7>] kcalloc include/linux/slab.h:636 [inline]
>      [<ffffffff83c0dda7>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
>      [<ffffffff83c0dda7>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
>      [<ffffffff83c0e9bf>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
>      [<ffffffff83b91842>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
>      [<ffffffff83ae1b6c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
>      [<ffffffff83c2fae7>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
>      [<ffffffff83c2ec07>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>      [<ffffffff83c2ec07>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
>      [<ffffffff83c2f0c6>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
>      [<ffffffff83a812f6>] sock_sendmsg_nosec net/socket.c:714 [inline]
>      [<ffffffff83a812f6>] sock_sendmsg+0x56/0x80 net/socket.c:734
>      [<ffffffff83a81668>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
>      [<ffffffff83a86218>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
>      [<ffffffff83a86565>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
>      [<ffffffff83a867b4>] __do_sys_sendmmsg net/socket.c:2651 [inline]
>      [<ffffffff83a867b4>] __se_sys_sendmmsg net/socket.c:2648 [inline]
>      [<ffffffff83a867b4>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
>      [<ffffffff8485b3b5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>      [<ffffffff8485b3b5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>      [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 
> .
> 
