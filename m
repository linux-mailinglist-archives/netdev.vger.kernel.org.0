Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59483194544
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 18:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgCZRTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 13:19:17 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:55791 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgCZRTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 13:19:17 -0400
Received: by mail-io1-f72.google.com with SMTP id k5so5805973ioa.22
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 10:19:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=89AASuIsuhq2TDnjrU3eDHxKk/9xmva/NohKkxqdSAA=;
        b=qV40svwqSQbFkXaDuX+bj8zn+6iA5WT+8AcjOdLH1OpXA3rfUTIfEQ+8xmn6JMJs4i
         1z89grSmvZWdHA0n/3x4gNOCoPdLkiCYBLrvrktN2Sur5eU+MjPGAiHx1Zqn7ik1p67f
         qIZT55YSi5uTLu+HTiPG+RlVkJUiECdG28v0IMKsRDsARO3QKI7tWw0o2yCpNugN+lqf
         5ObYetN9KX6TogeFoXVEP6dfEWt6O09TZmR1XZ5hkWj+wX94GvPrqDPxCszyCrBVUYTP
         ZGP6i+RsY33TF5bqYOupLqkMNmrDsnWiBYnAwOVOfXATgonYnnt/zroFv3VTcmPGdGU0
         mjQw==
X-Gm-Message-State: ANhLgQ3JJCnjgUaqMCWvECsVfbePjBxH5u4xES1HqBb6XsfKjZfty+Xg
        ujL5ifv+E1flWk53a0BVYHZVIEj4TzkLD5Dj1iODrsn4KTjg
X-Google-Smtp-Source: ADFU+vtgCXMrV1x/q2M3+wuvcIE1En+W91TuXhXYhJ2UHktcg8B/cDWeG3d/eunelo+KoKiVVOL84bsHeOR9XFS3l5pv3/hObVKD
MIME-Version: 1.0
X-Received: by 2002:a92:dcc6:: with SMTP id b6mr7549715ilr.113.1585243156443;
 Thu, 26 Mar 2020 10:19:16 -0700 (PDT)
Date:   Thu, 26 Mar 2020 10:19:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000038f92e05a1c52f43@google.com>
Subject: KMSAN: kernel-infoleak in copyout (2)
From:   syzbot <syzbot+fa5414772d5c445dac3c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, glider@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    686a4f77 kmsan: don't compile memmove
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=13235a31e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e10654781bc1f11c
dashboard link: https://syzkaller.appspot.com/bug?extid=fa5414772d5c445dac3c
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164789e9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1014a229e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fa5414772d5c445dac3c@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: kernel-infoleak in kmsan_copy_to_user+0x81/0x90 mm/kmsan/kmsan_hooks.c:253
CPU: 1 PID: 11522 Comm: syz-executor835 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 kmsan_internal_check_memory+0x238/0x3d0 mm/kmsan/kmsan.c:423
 kmsan_copy_to_user+0x81/0x90 mm/kmsan/kmsan_hooks.c:253
 copyout+0x15a/0x1e0 lib/iov_iter.c:145
 _copy_to_iter+0x34e/0x2420 lib/iov_iter.c:633
 copy_to_iter include/linux/uio.h:138 [inline]
 simple_copy_to_iter+0xd7/0x130 net/core/datagram.c:515
 __skb_datagram_iter+0x25f/0xfc0 net/core/datagram.c:423
 skb_copy_datagram_iter+0x292/0x2b0 net/core/datagram.c:529
 tun_put_user drivers/net/tun.c:2144 [inline]
 tun_do_read+0x2471/0x2df0 drivers/net/tun.c:2228
 tun_chr_read_iter+0x229/0x460 drivers/net/tun.c:2247
 call_read_iter include/linux/fs.h:1896 [inline]
 new_sync_read fs/read_write.c:414 [inline]
 __vfs_read+0xa64/0xc80 fs/read_write.c:427
 vfs_read+0x346/0x6a0 fs/read_write.c:461
 ksys_read+0x267/0x450 fs/read_write.c:587
 __do_sys_read fs/read_write.c:597 [inline]
 __se_sys_read+0x92/0xb0 fs/read_write.c:595
 __x64_sys_read+0x4a/0x70 fs/read_write.c:595
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x403f40
Code: 01 f0 ff ff 0f 83 a0 0d 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 83 3d 6d a0 2d 00 00 75 14 b8 00 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 74 0d 00 00 c3 48 83 ec 08 e8 da 02 00 00
RSP: 002b:00007ffe8e33e1d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000403f40
RDX: 00000000000003e8 RSI: 00007ffe8e33e1e0 RDI: 00000000000000f0
RBP: 000000000002640f R08: 0000000000000000 R09: 0000000000000004
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00000000004051d0 R14: 0000000000000000 R15: 0000000000000000

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 pskb_expand_head+0x38b/0x1b00 net/core/skbuff.c:1637
 __skb_cow include/linux/skbuff.h:3120 [inline]
 skb_cow_head include/linux/skbuff.h:3154 [inline]
 batadv_skb_head_push+0x234/0x350 net/batman-adv/soft-interface.c:74
 batadv_send_skb_packet+0x1a7/0x8c0 net/batman-adv/send.c:86
 batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:419 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0x97e/0xd50 net/batman-adv/bat_iv_ogm.c:1706
 process_one_work+0x1552/0x1ef0 kernel/workqueue.c:2264
 worker_thread+0xef6/0x2450 kernel/workqueue.c:2410
 kthread+0x4b5/0x4f0 kernel/kthread.c:256
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:353

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:307 [inline]
 kmsan_alloc_page+0x12a/0x310 mm/kmsan/kmsan_shadow.c:336
 __alloc_pages_nodemask+0x57f2/0x5f60 mm/page_alloc.c:4800
 __alloc_pages include/linux/gfp.h:498 [inline]
 __alloc_pages_node include/linux/gfp.h:511 [inline]
 alloc_pages_node include/linux/gfp.h:525 [inline]
 __page_frag_cache_refill mm/page_alloc.c:4875 [inline]
 page_frag_alloc+0x3ae/0x910 mm/page_alloc.c:4905
 __netdev_alloc_skb+0x703/0xbb0 net/core/skbuff.c:455
 __netdev_alloc_skb_ip_align include/linux/skbuff.h:2801 [inline]
 netdev_alloc_skb_ip_align include/linux/skbuff.h:2811 [inline]
 batadv_iv_ogm_aggregate_new net/batman-adv/bat_iv_ogm.c:558 [inline]
 batadv_iv_ogm_queue_add+0x10da/0x1900 net/batman-adv/bat_iv_ogm.c:670
 batadv_iv_ogm_schedule_buff net/batman-adv/bat_iv_ogm.c:845 [inline]
 batadv_iv_ogm_schedule+0x107b/0x13c0 net/batman-adv/bat_iv_ogm.c:865
 batadv_iv_send_outstanding_bat_ogm_packet+0xbae/0xd50 net/batman-adv/bat_iv_ogm.c:1718
 process_one_work+0x1552/0x1ef0 kernel/workqueue.c:2264
 worker_thread+0xef6/0x2450 kernel/workqueue.c:2410
 kthread+0x4b5/0x4f0 kernel/kthread.c:256
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:353

Bytes 52-53 of 146 are uninitialized
Memory access of size 146 starts at ffff9ecbf8eb0c40
Data copied to user address 00007ffe8e33e1e0
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
