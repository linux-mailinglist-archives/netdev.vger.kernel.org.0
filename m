Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68A1618A72
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbiKCVVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiKCVVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:21:31 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0111A04C;
        Thu,  3 Nov 2022 14:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1667510482;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:Cc:References:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=T6LgdNziiLAcLXgv0LQG8gtLNjq1GOoP1yxWXg/6qyo=;
    b=A52QsnMLfW6U4c2O/m+T9wYLv871vi/l4MzT16MfP2gkDbvqMJ/MFW3vBrSDthxKtg
    V3rG4SzxZ9X12SMvHBQ6mfWS5AHNQyv0+OfUUlYe83HrOllBmlS6TEXa0CMJKf2mD/cq
    OXlNOBegoqgWfcLKu3OyjxHvhL+8MDZYtaupjprJHEZ5xTAL4wnGzJu6TSR1yN414F2r
    ruAdJaWb4a++1ana0qYBy09Fb98HCIsO1bnHIoNdX4q7Q5HCJ+i6aS1wLZ53MPIB//44
    PDBGrtD39MTsimgk6KLVgwCtc4eNbjrZXMwb0r+0lt/H2yfhJr7lz6r3qzKxkGnOU/h3
    CMkw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytISr6hZqJAw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d104::923]
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783yA3LLLObr
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 3 Nov 2022 22:21:21 +0100 (CET)
Message-ID: <cc1a0240-2b51-0d97-3606-02e29d0346c1@hartkopp.net>
Date:   Thu, 3 Nov 2022 22:21:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [syzbot] KMSAN: uninit-value in can_send
To:     linux@rempel-privat.de,
        syzbot <syzbot+d168ec0caca4697e03b1@syzkaller.appspotmail.com>
References: <000000000000cf2ce705ec935d80@google.com>
Content-Language: en-US
Cc:     syzbot <syzbot+d168ec0caca4697e03b1@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, glider@google.com,
        kernel@pengutronix.de, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, pabeni@redhat.com, robin@protonic.nl,
        syzkaller-bugs@googlegroups.com
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <000000000000cf2ce705ec935d80@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good catch!

That's a correct issue caused by only filling the CAN frame header with 
can_id and len in j1939_send_one():

https://elixir.bootlin.com/linux/v6.0.6/source/net/can/j1939/main.c#L345

@Oleksij: Can you please (zero)initialize the unused elements in struct 
can_frame (namely __pad, __res0, len8_dlc) in j1939_send_one()?

Or do you want me to create a patch for it?

Thanks and best regards,
Oliver

On 03.11.22 17:22, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4a3e741a3d6a x86: fortify: kmsan: fix KMSAN fortify builds
> git tree:       https://github.com/google/kmsan.git master
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=14247636880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c19210a0c25eebb
> dashboard link: https://syzkaller.appspot.com/bug?extid=d168ec0caca4697e03b1
> compiler:       clang version 15.0.0 (https://github.com/llvm/llvm-project.git 610139d2d9ce6746b3c617fb3e2f7886272d26ff), GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e16e86880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1535a2f6880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/fbb1997bc1e0/disk-4a3e741a.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d5dd2e1efaa4/vmlinux-4a3e741a.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d168ec0caca4697e03b1@syzkaller.appspotmail.com
> 
> =====================================================
> BUG: KMSAN: uninit-value in can_is_canxl_skb include/linux/can/skb.h:128 [inline]
> BUG: KMSAN: uninit-value in can_send+0x269/0x1100 net/can/af_can.c:205
>   can_is_canxl_skb include/linux/can/skb.h:128 [inline]
>   can_send+0x269/0x1100 net/can/af_can.c:205
>   j1939_send_one+0x40f/0x4d0 net/can/j1939/main.c:352
>   j1939_xtp_do_tx_ctl+0x69f/0x9e0 net/can/j1939/transport.c:664
>   j1939_tp_tx_ctl net/can/j1939/transport.c:672 [inline]
>   j1939_session_tx_rts net/can/j1939/transport.c:740 [inline]
>   j1939_xtp_txnext_transmiter net/can/j1939/transport.c:880 [inline]
>   j1939_tp_txtimer+0x35bb/0x4520 net/can/j1939/transport.c:1158
>   __run_hrtimer+0x298/0x910 kernel/time/hrtimer.c:1685
>   __hrtimer_run_queues kernel/time/hrtimer.c:1749 [inline]
>   hrtimer_run_softirq+0x4b0/0x870 kernel/time/hrtimer.c:1766
>   __do_softirq+0x1c5/0x7b9 kernel/softirq.c:571
>   invoke_softirq+0x8f/0x100 kernel/softirq.c:445
>   __irq_exit_rcu+0x5a/0x110 kernel/softirq.c:650
>   irq_exit_rcu+0xe/0x10 kernel/softirq.c:662
>   sysvec_apic_timer_interrupt+0x9a/0xc0 arch/x86/kernel/apic/apic.c:1107
>   asm_sysvec_apic_timer_interrupt+0x1b/0x20 arch/x86/include/asm/idtentry.h:649
>   __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
>   _raw_spin_unlock_irqrestore+0x2f/0x50 kernel/locking/spinlock.c:194
>   unlock_hrtimer_base kernel/time/hrtimer.c:1017 [inline]
>   hrtimer_start_range_ns+0xaba/0xb50 kernel/time/hrtimer.c:1301
>   hrtimer_start include/linux/hrtimer.h:418 [inline]
>   j1939_tp_schedule_txtimer+0xbe/0x100 net/can/j1939/transport.c:697
>   j1939_sk_send_loop net/can/j1939/socket.c:1143 [inline]
>   j1939_sk_sendmsg+0x1c2c/0x25d0 net/can/j1939/socket.c:1256
>   sock_sendmsg_nosec net/socket.c:714 [inline]
>   sock_sendmsg net/socket.c:734 [inline]
>   ____sys_sendmsg+0xa8e/0xe70 net/socket.c:2482
>   ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2536
>   __sys_sendmsg net/socket.c:2565 [inline]
>   __do_sys_sendmsg net/socket.c:2574 [inline]
>   __se_sys_sendmsg net/socket.c:2572 [inline]
>   __x64_sys_sendmsg+0x367/0x540 net/socket.c:2572
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Uninit was created at:
>   slab_post_alloc_hook mm/slab.h:742 [inline]
>   slab_alloc_node mm/slub.c:3398 [inline]
>   __kmem_cache_alloc_node+0x6ee/0xc90 mm/slub.c:3437
>   __do_kmalloc_node mm/slab_common.c:954 [inline]
>   __kmalloc_node_track_caller+0x117/0x3d0 mm/slab_common.c:975
>   kmalloc_reserve net/core/skbuff.c:437 [inline]
>   __alloc_skb+0x34a/0xca0 net/core/skbuff.c:509
>   alloc_skb include/linux/skbuff.h:1267 [inline]
>   j1939_tp_tx_dat_new net/can/j1939/transport.c:593 [inline]
>   j1939_xtp_do_tx_ctl+0xa3/0x9e0 net/can/j1939/transport.c:654
>   j1939_tp_tx_ctl net/can/j1939/transport.c:672 [inline]
>   j1939_session_tx_rts net/can/j1939/transport.c:740 [inline]
>   j1939_xtp_txnext_transmiter net/can/j1939/transport.c:880 [inline]
>   j1939_tp_txtimer+0x35bb/0x4520 net/can/j1939/transport.c:1158
>   __run_hrtimer+0x298/0x910 kernel/time/hrtimer.c:1685
>   __hrtimer_run_queues kernel/time/hrtimer.c:1749 [inline]
>   hrtimer_run_softirq+0x4b0/0x870 kernel/time/hrtimer.c:1766
>   __do_softirq+0x1c5/0x7b9 kernel/softirq.c:571
> 
> CPU: 0 PID: 3506 Comm: syz-executor289 Not tainted 6.1.0-rc2-syzkaller-61955-g4a3e741a3d6a #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
> =====================================================
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
