Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CFE518656
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 16:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbiECOTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 10:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236884AbiECOTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 10:19:32 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A8924596
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 07:15:59 -0700 (PDT)
Received: from fsav315.sakura.ne.jp (fsav315.sakura.ne.jp [153.120.85.146])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 243E874T083479;
        Tue, 3 May 2022 23:08:07 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav315.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav315.sakura.ne.jp);
 Tue, 03 May 2022 23:08:07 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav315.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 243E87Pm083474
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 3 May 2022 23:08:07 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <7be0b6ae-08c8-59a6-7cc2-3caee827a7e6@I-love.SAKURA.ne.jp>
Date:   Tue, 3 May 2022 23:08:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>
References: <00000000000045dc96059f4d7b02@google.com>
 <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
 <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
 <5f90c2b8-283e-6ca5-65f9-3ea96df00984@I-love.SAKURA.ne.jp>
 <f8ae5dcd-a5ed-2d8b-dd7a-08385e9c3675@I-love.SAKURA.ne.jp>
 <CANn89iJukWcN9-fwk4HEH-StAjnTVJ34UiMsrN=mdRbwVpo8AA@mail.gmail.com>
 <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
 <3b6bc24c8cd3f896dcd480ff75715a2bf9b2db06.camel@redhat.com>
 <CANn89iK5WmzyPNyUzuoDyDZQWpbBaffEXxEvmOhz5wJ+9facFg@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CANn89iK5WmzyPNyUzuoDyDZQWpbBaffEXxEvmOhz5wJ+9facFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/05/03 22:45, Eric Dumazet wrote:
>> This looks equivalent to the fix presented here:
>>
>> https://lore.kernel.org/all/CANn89i+484ffqb93aQm1N-tjxxvb3WDKX0EbD7318RwRgsatjw@mail.gmail.com/

I retested the fix above using

unshare -n sh -c '
ip link set lo up
iptables -A OUTPUT -p tcp --sport 16385 --tcp-flags SYN NONE -m state --state ESTABLISHED,RELATED -j DROP
ip6tables -A OUTPUT -p tcp --sport 16385 --tcp-flags SYN NONE -m state --state ESTABLISHED,RELATED -j DROP
telnet 127.0.0.1 16385
dmesg -c
netstat -tanpe' < /dev/null

as a test case, but it seems racy; sometimes timer function is called again and crashes.

[  426.086565][    C2] general protection fault, probably for non-canonical address 0x6b6af3ebcc3b6bc3: 0000 [#1] PREEMPT SMP KASAN
[  426.096339][    C2] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 5.18.0-rc5-dirty #807
[  426.103769][    C2] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  426.111851][    C2] RIP: 0010:__tcp_transmit_skb+0xe72/0x1b80
[  426.117512][    C2] Code: e8 b3 ea dc fd 48 8d 7d 30 45 0f b7 77 30 e8 95 ec dc fd 48 8b 5d 30 48 8d bb b8 02 00 00 e8 85 ec dc fd 48 8b 83 b8 02 00 00 <65> 4c 01 70 58 e9 67 fd ff ff e8 ef 56 ac fd 48 8d bd d0 09 00 00
[  426.124692][    C2] RSP: 0018:ffff888060d09ac8 EFLAGS: 00010246
[  426.126845][    C2] RAX: 6b6b6b6b6b6b6b6b RBX: ffff8880145c8000 RCX: ffffffff838cc28b
[  426.129616][    C2] RDX: dffffc0000000000 RSI: 0000000000000001 RDI: ffff8880145c82b8
[  426.132374][    C2] RBP: ffff8880129f8000 R08: 0000000000000000 R09: 0000000000000007
[  426.135077][    C2] R10: ffffffff838cbfd4 R11: 0000000000000001 R12: ffff8880129f8760
[  426.137793][    C2] R13: ffff88800f6e0118 R14: 0000000000000001 R15: ffff88800f6e00e8
[  426.140489][    C2] FS:  0000000000000000(0000) GS:ffff888060d00000(0000) knlGS:0000000000000000
[  426.143525][    C2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  426.145792][    C2] CR2: 000055b5bb0adabc CR3: 000000000e003000 CR4: 00000000000506e0
[  426.148509][    C2] Call Trace:
[  426.149442][    C2]  <IRQ>
[  426.150183][    C2]  ? __tcp_select_window+0x710/0x710
[  426.151457][    C2]  ? __sanitizer_cov_trace_cmp4+0x1c/0x70
[  426.153007][    C2]  ? tcp_current_mss+0x165/0x280
[  426.154245][    C2]  ? tcp_trim_head+0x300/0x300
[  426.155396][    C2]  ? find_held_lock+0x85/0xa0
[  426.156734][    C2]  ? mark_held_locks+0x65/0x90
[  426.157967][    C2]  tcp_write_wakeup+0x2e2/0x340
[  426.159149][    C2]  tcp_send_probe0+0x2a/0x2c0
[  426.160368][    C2]  tcp_write_timer_handler+0x5cb/0x670
[  426.161740][    C2]  tcp_write_timer+0x86/0x250
[  426.162896][    C2]  ? tcp_write_timer_handler+0x670/0x670
[  426.164285][    C2]  call_timer_fn+0x15d/0x5f0
[  426.165481][    C2]  ? add_timer_on+0x2e0/0x2e0
[  426.166667][    C2]  ? lock_downgrade+0x3c0/0x3c0
[  426.167921][    C2]  ? mark_held_locks+0x24/0x90
[  426.169263][    C2]  ? _raw_spin_unlock_irq+0x1f/0x40
[  426.170564][    C2]  ? tcp_write_timer_handler+0x670/0x670
[  426.171920][    C2]  __run_timers.part.0+0x523/0x740
[  426.173181][    C2]  ? call_timer_fn+0x5f0/0x5f0
[  426.174321][    C2]  ? pvclock_clocksource_read+0xdc/0x1a0
[  426.175655][    C2]  run_timer_softirq+0x66/0xe0
[  426.176825][    C2]  __do_softirq+0x1c2/0x670
[  426.177944][    C2]  __irq_exit_rcu+0xf8/0x140
[  426.179120][    C2]  irq_exit_rcu+0x5/0x20
[  426.180150][    C2]  sysvec_apic_timer_interrupt+0x8e/0xc0
[  426.181486][    C2]  </IRQ>
[  426.182180][    C2]  <TASK>
[  426.182845][    C2]  asm_sysvec_apic_timer_interrupt+0x12/0x20

> 
> I think this is still needed for layers (NFS ?) that dismantle their
> TCP sockets whenever a netns
> is dismantled. But RDS case was different, only the listener is a kernel socket.

We can't apply the fix above.

I think that the fundamental problem is that we use net->ns.count for both
"avoiding use-after-free" purpose and "allowing dismantle from user event" purpose.
Why not to use separated counters?

