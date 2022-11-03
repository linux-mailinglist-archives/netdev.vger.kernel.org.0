Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D55618439
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 17:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbiKCQWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 12:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiKCQWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 12:22:43 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDCD1B1C3
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 09:22:42 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id n23-20020a056602341700b00689fc6dbfd6so1343050ioz.8
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 09:22:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PdS+lEEBebiSo5ay5p6Fn4AnE2FMKU6iakE+zDZEfZ4=;
        b=HD1/zS2gUi7cx7UuoZQciV2UkEbL3KX5t+mqelLAeMBPibPF+uerPE+ARGA2pzd4xy
         zfhFngSk7WrFyqSLJ1+a9yJdcF2K2ofTi92ER0qYM7xa0MUbbaSf5I99EealN/NvhH0I
         ZRWPgjhi1EIJ+v9PVDCsbCTTc0Srry9KQ8OnXJM8SKlDTe2CifJRRA0E6qdIaVI6gM1w
         PWiVIFpV+rmM2SRE4khba2VNrH7dCGe6Cv4duQxYo5B3KBfM3o5+DtNw8nAcZVsiEwBF
         rho9ukkUodzprM/dhEiuxqM9o2sYAguqoBcA8A0z5MCqCeBToX4/ai+MR1jtUlcMMP8B
         XGTw==
X-Gm-Message-State: ACrzQf17tM6moBqbvoJ+8JGyeiPSvEE1k7UotLehHG16moDNcxPaCwSS
        ry4edb9IdWYNkOv9Y7iUNiWTiRe9D7LuZMtkHsjEunhCZvtg
X-Google-Smtp-Source: AMsMyM4oyov1l3/KEhHs4Ya1tY2AXI4A2VcOLdnqwyIjxJKU4caA9EI+Pqbn+kpLgAfmrhu0dW6pCBUZPAl8QRlY7P/uVzJe3KCe
MIME-Version: 1.0
X-Received: by 2002:a02:ccab:0:b0:375:4a9b:1804 with SMTP id
 t11-20020a02ccab000000b003754a9b1804mr18559482jap.145.1667492561757; Thu, 03
 Nov 2022 09:22:41 -0700 (PDT)
Date:   Thu, 03 Nov 2022 09:22:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cf2ce705ec935d80@google.com>
Subject: [syzbot] KMSAN: uninit-value in can_send
From:   syzbot <syzbot+d168ec0caca4697e03b1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, glider@google.com,
        kernel@pengutronix.de, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rempel-privat.de,
        mkl@pengutronix.de, netdev@vger.kernel.org, pabeni@redhat.com,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4a3e741a3d6a x86: fortify: kmsan: fix KMSAN fortify builds
git tree:       https://github.com/google/kmsan.git master
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14247636880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c19210a0c25eebb
dashboard link: https://syzkaller.appspot.com/bug?extid=d168ec0caca4697e03b1
compiler:       clang version 15.0.0 (https://github.com/llvm/llvm-project.git 610139d2d9ce6746b3c617fb3e2f7886272d26ff), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e16e86880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1535a2f6880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fbb1997bc1e0/disk-4a3e741a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d5dd2e1efaa4/vmlinux-4a3e741a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d168ec0caca4697e03b1@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in can_is_canxl_skb include/linux/can/skb.h:128 [inline]
BUG: KMSAN: uninit-value in can_send+0x269/0x1100 net/can/af_can.c:205
 can_is_canxl_skb include/linux/can/skb.h:128 [inline]
 can_send+0x269/0x1100 net/can/af_can.c:205
 j1939_send_one+0x40f/0x4d0 net/can/j1939/main.c:352
 j1939_xtp_do_tx_ctl+0x69f/0x9e0 net/can/j1939/transport.c:664
 j1939_tp_tx_ctl net/can/j1939/transport.c:672 [inline]
 j1939_session_tx_rts net/can/j1939/transport.c:740 [inline]
 j1939_xtp_txnext_transmiter net/can/j1939/transport.c:880 [inline]
 j1939_tp_txtimer+0x35bb/0x4520 net/can/j1939/transport.c:1158
 __run_hrtimer+0x298/0x910 kernel/time/hrtimer.c:1685
 __hrtimer_run_queues kernel/time/hrtimer.c:1749 [inline]
 hrtimer_run_softirq+0x4b0/0x870 kernel/time/hrtimer.c:1766
 __do_softirq+0x1c5/0x7b9 kernel/softirq.c:571
 invoke_softirq+0x8f/0x100 kernel/softirq.c:445
 __irq_exit_rcu+0x5a/0x110 kernel/softirq.c:650
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x9a/0xc0 arch/x86/kernel/apic/apic.c:1107
 asm_sysvec_apic_timer_interrupt+0x1b/0x20 arch/x86/include/asm/idtentry.h:649
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
 _raw_spin_unlock_irqrestore+0x2f/0x50 kernel/locking/spinlock.c:194
 unlock_hrtimer_base kernel/time/hrtimer.c:1017 [inline]
 hrtimer_start_range_ns+0xaba/0xb50 kernel/time/hrtimer.c:1301
 hrtimer_start include/linux/hrtimer.h:418 [inline]
 j1939_tp_schedule_txtimer+0xbe/0x100 net/can/j1939/transport.c:697
 j1939_sk_send_loop net/can/j1939/socket.c:1143 [inline]
 j1939_sk_sendmsg+0x1c2c/0x25d0 net/can/j1939/socket.c:1256
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xa8e/0xe70 net/socket.c:2482
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2536
 __sys_sendmsg net/socket.c:2565 [inline]
 __do_sys_sendmsg net/socket.c:2574 [inline]
 __se_sys_sendmsg net/socket.c:2572 [inline]
 __x64_sys_sendmsg+0x367/0x540 net/socket.c:2572
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:742 [inline]
 slab_alloc_node mm/slub.c:3398 [inline]
 __kmem_cache_alloc_node+0x6ee/0xc90 mm/slub.c:3437
 __do_kmalloc_node mm/slab_common.c:954 [inline]
 __kmalloc_node_track_caller+0x117/0x3d0 mm/slab_common.c:975
 kmalloc_reserve net/core/skbuff.c:437 [inline]
 __alloc_skb+0x34a/0xca0 net/core/skbuff.c:509
 alloc_skb include/linux/skbuff.h:1267 [inline]
 j1939_tp_tx_dat_new net/can/j1939/transport.c:593 [inline]
 j1939_xtp_do_tx_ctl+0xa3/0x9e0 net/can/j1939/transport.c:654
 j1939_tp_tx_ctl net/can/j1939/transport.c:672 [inline]
 j1939_session_tx_rts net/can/j1939/transport.c:740 [inline]
 j1939_xtp_txnext_transmiter net/can/j1939/transport.c:880 [inline]
 j1939_tp_txtimer+0x35bb/0x4520 net/can/j1939/transport.c:1158
 __run_hrtimer+0x298/0x910 kernel/time/hrtimer.c:1685
 __hrtimer_run_queues kernel/time/hrtimer.c:1749 [inline]
 hrtimer_run_softirq+0x4b0/0x870 kernel/time/hrtimer.c:1766
 __do_softirq+0x1c5/0x7b9 kernel/softirq.c:571

CPU: 0 PID: 3506 Comm: syz-executor289 Not tainted 6.1.0-rc2-syzkaller-61955-g4a3e741a3d6a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
