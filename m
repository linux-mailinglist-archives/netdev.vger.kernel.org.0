Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2626A6CDB1F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjC2NsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjC2Nr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:47:58 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FA32D44;
        Wed, 29 Mar 2023 06:47:47 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Pmnqk0gG5zKwMp;
        Wed, 29 Mar 2023 21:45:22 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 21:47:44 +0800
Subject: Re: [syzbot] [arm-msm?] [net?] WARNING: refcount bug in qrtr_recvmsg
 (2)
To:     syzbot <syzbot+a7492efaa5d61b51db23@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mani@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller-bugs@googlegroups.com>
References: <000000000000e3e09c05f78683a6@google.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <e4b73e85-d8e5-e785-7062-38a3a24d4d9f@huawei.com>
Date:   Wed, 29 Mar 2023 21:47:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <000000000000e3e09c05f78683a6@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=0.2 required=5.0 tests=NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9c1bec9c0b08 Merge tag 'linux-kselftest-fixes-6.3-rc3' of ..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17285724c80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6c84f77790aba2eb
> dashboard link: https://syzkaller.appspot.com/bug?extid=a7492efaa5d61b51db23
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c9f8a4c80000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e8fe2cc80000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/eee5724f97b4/disk-9c1bec9c.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/00ee10c4bc28/vmlinux-9c1bec9c.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/42cf9c3e67cd/bzImage-9c1bec9c.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a7492efaa5d61b51db23@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> refcount_t: addition on 0; use-after-free.
> WARNING: CPU: 0 PID: 46 at lib/refcount.c:25 refcount_warn_saturate+0x17c/0x1f0 lib/refcount.c:25
> Modules linked in:
> CPU: 0 PID: 46 Comm: kworker/u4:3 Not tainted 6.3.0-rc2-syzkaller-00050-g9c1bec9c0b08 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
> Workqueue: qrtr_ns_handler qrtr_ns_worker
> RIP: 0010:refcount_warn_saturate+0x17c/0x1f0 lib/refcount.c:25
> Code: 0a 31 ff 89 de e8 64 17 73 fd 84 db 0f 85 2e ff ff ff e8 47 1b 73 fd 48 c7 c7 e0 6a a6 8a c6 05 5d 73 52 0a 01 e8 e4 94 3b fd <0f> 0b e9 0f ff ff ff e8 28 1b 73 fd 0f b6 1d 47 73 52 0a 31 ff 89
> RSP: 0018:ffffc90000b779d8 EFLAGS: 00010086
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff888017d61d40 RSI: ffffffff814b6037 RDI: 0000000000000001
> RBP: ffff88802717ec98 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff888145178000
> R13: ffff88802717ec00 R14: ffff8880280b1030 R15: ffff8880280b1034
> FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffdb2009388 CR3: 0000000029dad000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __refcount_add include/linux/refcount.h:199 [inline]
>  __refcount_inc include/linux/refcount.h:250 [inline]
>  refcount_inc include/linux/refcount.h:267 [inline]
>  kref_get include/linux/kref.h:45 [inline]
>  qrtr_node_acquire net/qrtr/af_qrtr.c:202 [inline]
>  qrtr_node_lookup net/qrtr/af_qrtr.c:398 [inline]
>  qrtr_send_resume_tx net/qrtr/af_qrtr.c:1003 [inline]
>  qrtr_recvmsg+0x85f/0x990 net/qrtr/af_qrtr.c:1070
>  sock_recvmsg_nosec net/socket.c:1017 [inline]
>  sock_recvmsg+0xe2/0x160 net/socket.c:1038
>  qrtr_ns_worker+0x170/0x1700 net/qrtr/ns.c:688
>  process_one_work+0x991/0x15c0 kernel/workqueue.c:2390
>  worker_thread+0x669/0x1090 kernel/workqueue.c:2537
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>  </TASK>
> 
It occurs in the concurrent scenario of qrtr_recvmsg() and
qrtr_endpoint_unregister() as following:

    cpu0                                        cpu1
qrtr_recvmsg                            qrtr_endpoint_unregister
qrtr_send_resume_tx                     qrtr_node_release
qrtr_node_lookup                        mutex_lock(&qrtr_node_lock)
spin_lock_irqsave(&qrtr_nodes_lock, )   refcount_dec_and_test(&node->ref) [node->ref == 0]
qrtr_node_acquire [node != NULL]        spin_lock_irqsave(&qrtr_nodes_lock, )
kref_get(&node->ref) [WARNING]          __qrtr_node_release
                                        mutex_unlock(&qrtr_node_lock)

and I will give a fix later.

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
> .
> 
