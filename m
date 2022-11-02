Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674F9616512
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 15:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiKBOZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 10:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKBOZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 10:25:32 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFB728E1F;
        Wed,  2 Nov 2022 07:25:30 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N2TZ64JlKzRntV;
        Wed,  2 Nov 2022 22:20:30 +0800 (CST)
Received: from dggpemm500011.china.huawei.com (7.185.36.110) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 22:25:28 +0800
Received: from [10.136.114.193] (10.136.114.193) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 22:25:27 +0800
Message-ID: <7033694f-a4a5-d571-3eec-eec74aaa3e7c@huawei.com>
Date:   Wed, 2 Nov 2022 22:25:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <linux-sctp@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <caowangbao@huawei.com>, <yanan@huawei.com>
From:   Zhen Chen <chenzhen126@huawei.com>
Subject: BUG: kernel NULL pointer dereference in sctp_sched_dequeue_common
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.193]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,all

We found the following crash when running fuzz tests on stable-5.10. 

------------[ cut here ]------------
list_del corruption, ffffa035ddf01c18->next is NULL
WARNING: CPU: 1 PID: 250682 at lib/list_debug.c:49 __list_del_entry_valid+0x59/0xe0
CPU: 1 PID: 250682 Comm: syz-executor.7 Kdump: loaded Tainted: G           O
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-g5f4c7b1-20181220_000000-szxrtosci10000 04/01/2014
RIP: 0010:__list_del_entry_valid+0x59/0xe0
Code: c0 74 5a 4d 8b 00 49 39 f0 75 6a 48 8b 52 08 4c 39 c2 75 79 b8 01 00 00 00 c3 cc cc cc cc 48 c7 c7 68 ae 78 8b e8 d2 3d 4e 00 <0f> 0b 31 c0 c3 cc cc cc cc 48 c7 c7 90 ae 78 8b e8 bd 3d 4e 00 0f
RSP: 0018:ffffaf7d84a57930 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffffa035ddf01c18 RCX: 0000000000000000
RDX: ffffa035facb0820 RSI: ffffa035faca0410 RDI: ffffa035faca0410
RBP: ffffa035dddff6f8 R08: 0000000000000000 R09: ffffaf7d84a57770
R10: ffffaf7d84a57768 R11: ffffffff8bddc248 R12: ffffa035ddf01c18
R13: ffffaf7d84a57af8 R14: ffffaf7d84a57c28 R15: 0000000000000000
FS:  00007fb7353ae700(0000) GS:ffffa035fac80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f509a3d0ee8 CR3: 000000010f7c2001 CR4: 00000000001706e0
Call Trace:
 sctp_sched_dequeue_common+0x17/0x70 [sctp]
 sctp_sched_fcfs_dequeue+0x37/0x50 [sctp]
 sctp_outq_flush_data+0x85/0x360 [sctp]
 sctp_outq_uncork+0x77/0xa0 [sctp]
 sctp_cmd_interpreter.constprop.0+0x164/0x1450 [sctp]
 sctp_side_effects+0x37/0xe0 [sctp]
 sctp_do_sm+0xd0/0x230 [sctp]
 sctp_primitive_SEND+0x2f/0x40 [sctp]
 sctp_sendmsg_to_asoc+0x3fa/0x5c0 [sctp]
 sctp_sendmsg+0x3d5/0x440 [sctp]
 sock_sendmsg+0x5b/0x70
 sock_write_iter+0x97/0x100
 new_sync_write+0x1a1/0x1b0
 vfs_write+0x1b7/0x250
 ksys_write+0xab/0xe0
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x61/0xc6
RIP: 0033:0x461e3d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb7353adc08 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000058c1d0 RCX: 0000000000461e3d
RDX: 000000000000001e RSI: 0000000020002640 RDI: 0000000000000004
RBP: 000000000058c1d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb7353ae700 R14: 00007ffc4c20ce00 R15: 0000000000000fff
---[ end trace 332cf75246d5ba68 ]---
BUG: kernel NULL pointer dereference, address: 0000000000000070
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 800000010c0d4067 P4D 800000010c0d4067 PUD 10f275067 PMD 0
Oops: 0000 [#1] SMP PTI
CPU: 1 PID: 250682 Comm: syz-executor.7 Kdump: loaded Tainted: G        W  O
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-g5f4c7b1-20181220_000000-szxrtosci10000 04/01/2014
RIP: 0010:sctp_sched_dequeue_common+0x5c/0x70 [sctp]
Code: 5b 08 4c 89 e7 e8 44 c5 cc c9 84 c0 74 0f 48 8b 53 18 48 8b 43 20 48 89 42 08 48 89 10 48 8b 43 38 4c 89 63 18 4c 89 63 20 5b <8b> 40 70 29 45 20 5d 41 5c c3 cc cc cc cc 66 0f 1f 44 00 00 0f 1f
RSP: 0018:ffffaf7d84a57940 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffaf7d84a579a0 RCX: 0000000000000000
RDX: ffffa035ddf01c30 RSI: ffffa035ddf01c30 RDI: ffffa035ddf01c30
RBP: ffffa035dddff6f8 R08: ffffa035ddf01c30 R09: ffffaf7d84a57770
R10: ffffaf7d84a57768 R11: ffffffff8bddc248 R12: ffffa035ddf01c30
R13: ffffaf7d84a57af8 R14: ffffaf7d84a57c28 R15: 0000000000000000
FS:  00007fb7353ae700(0000) GS:ffffa035fac80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000070 CR3: 000000010f7c2001 CR4: 00000000001706e0
Call Trace:
 sctp_sched_fcfs_dequeue+0x37/0x50 [sctp]
 sctp_outq_flush_data+0x85/0x360 [sctp]
 sctp_outq_uncork+0x77/0xa0 [sctp]
 sctp_cmd_interpreter.constprop.0+0x164/0x1450 [sctp]
 sctp_side_effects+0x37/0xe0 [sctp]
 sctp_do_sm+0xd0/0x230 [sctp]
 sctp_primitive_SEND+0x2f/0x40 [sctp]
 sctp_sendmsg_to_asoc+0x3fa/0x5c0 [sctp]
 sctp_sendmsg+0x3d5/0x440 [sctp]
 sock_sendmsg+0x5b/0x70
 sock_write_iter+0x97/0x100
 new_sync_write+0x1a1/0x1b0
 vfs_write+0x1b7/0x250
 ksys_write+0xab/0xe0
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x61/0xc6
RIP: 0033:0x461e3d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb7353adc08 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000058c1d0 RCX: 0000000000461e3d
RDX: 000000000000001e RSI: 0000000020002640 RDI: 0000000000000004
RBP: 000000000058c1d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb7353ae700 R14: 00007ffc4c20ce00 R15: 0000000000000fff


It is quite similar to the issue (See https://lore.kernel.org/all/CAO4mrfcB0d+qbwtfndzqcrL+QEQgfOmJYQMAdzwxRePmP8TY1A@mail.gmail.com/ ) , which was addressed by 181d8d2066c0 (sctp: leave the err path free in sctp_stream_init to sctp_stream_free), but unfortunately the patch do not work with this bug :(

It will be welcomed if anyone have any ideas.

Thanks!
