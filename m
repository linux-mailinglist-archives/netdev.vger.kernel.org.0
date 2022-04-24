Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992D550CF13
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 06:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiDXEHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 00:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiDXEHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 00:07:18 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7ACA81498;
        Sat, 23 Apr 2022 21:04:18 -0700 (PDT)
Received: from fsav415.sakura.ne.jp (fsav415.sakura.ne.jp [133.242.250.114])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 23O3vohV084250;
        Sun, 24 Apr 2022 12:57:50 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav415.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp);
 Sun, 24 Apr 2022 12:57:50 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 23O3vob9084247
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 24 Apr 2022 12:57:50 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <5f90c2b8-283e-6ca5-65f9-3ea96df00984@I-love.SAKURA.ne.jp>
Date:   Sun, 24 Apr 2022 12:57:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [syzbot] KASAN: use-after-free Read in tcp_retransmit_timer (5)
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>
Cc:     syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        andrii@kernel.org, andriin@fb.com, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tpa@hlghospital.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org, bpf@vger.kernel.org
References: <00000000000045dc96059f4d7b02@google.com>
 <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
 <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
In-Reply-To: <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OK. I succeeded to reproduce this problem without BPF program.
Just dropping TCP packets is sufficient. That is, this bug should be fixed in RDS code.

------------------------------------------------------------
root@fuzz:~# unshare -n sh -c '
ip link set lo up
iptables -A OUTPUT -p tcp --sport 16385 --tcp-flags SYN NONE -m state --state ESTABLISHED,RELATED -j DROP
ip6tables -A OUTPUT -p tcp --sport 16385 --tcp-flags SYN NONE -m state --state ESTABLISHED,RELATED -j DROP
telnet 127.0.0.1 16385
dmesg -c
netstat -tanpe' < /dev/null
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.
Connection closed by foreign host.
[   54.922280] accepted family 10 tcp ::ffff:127.0.0.1:16385 -> ::ffff:127.0.0.1:58780 refcnt=0 sock_net=ffff888035c98000 init_net=ffffffff860d89c0
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name
tcp        0      1 127.0.0.1:58780         127.0.0.1:16385         FIN_WAIT1   0          0          -
tcp6       0      0 :::16385                :::*                    LISTEN      0          18301      -
tcp6       1      1 127.0.0.1:16385         127.0.0.1:58780         LAST_ACK    0          0          -
------------------------------------------------------------

------------------------------------------------------------
fuzz login: [   54.849128][ T2718] ip (2718) used greatest stack depth: 11192 bytes left
[   54.922280][  T764] accepted family 10 tcp ::ffff:127.0.0.1:16385 -> ::ffff:127.0.0.1:58780 refcnt=0 sock_net=ffff888035c98000 init_net=ffffffff860d89c0
[  224.330990][    C0] general protection fault, probably for non-canonical address 0x6b6af3ebe92b6bc3: 0000 [#1] PREEMPT SMP
[  224.344491][    C0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.18.0-rc3-00016-gb253435746d9-dirty #767
[  224.355974][    C0] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  224.361184][    C0] RIP: 0010:__tcp_transmit_skb+0x5e5/0xbf0
[  224.364559][    C0] Code: 0f 84 33 05 00 00 4c 89 2c 24 49 89 c5 48 c7 40 10 00 00 00 00 e9 c0 fa ff ff 49 8b 46 30 41 0f b7 55 30 48 8b 80 b8 02 00 00 <65> 48 01 50 58 e9 8e fe ff ff 41 8b 86 fc 08 00 00 48 69 c0 e8 03
[  224.375318][    C0] RSP: 0018:ffffc90000003d38 EFLAGS: 00010297
[  224.378682][    C0] RAX: 6b6b6b6b6b6b6b6b RBX: 000000009e2a2659 RCX: ffff888104a39000
[  224.383253][    C0] RDX: 0000000000000001 RSI: ffff8881008054e0 RDI: ffff888035340000
[  224.387171][    C0] RBP: ffff888100805508 R08: 0000000000000000 R09: 0000000000000000
[  224.389612][    C0] R10: ffff888104a39140 R11: 0000000000000000 R12: 0000000000000001
[  224.392646][    C0] R13: ffff8881008054e0 R14: ffff888035340000 R15: 0000000000000020
[  224.395626][    C0] FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
[  224.398662][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  224.400880][    C0] CR2: 000056264812f99c CR3: 000000000a58e000 CR4: 00000000000506f0
[  224.403964][    C0] Call Trace:
[  224.405212][    C0]  <IRQ>
[  224.406355][    C0]  ? tcp_write_timer_handler+0x280/0x280
[  224.408259][    C0]  tcp_write_wakeup+0x112/0x160
[  224.409932][    C0]  ? ktime_get+0x1cb/0x260
[  224.411636][    C0]  tcp_send_probe0+0x13/0x150
[  224.413393][    C0]  tcp_write_timer_handler+0x248/0x280
[  224.415433][    C0]  tcp_write_timer+0xa5/0x110
[  224.417040][    C0]  ? tcp_write_timer_handler+0x280/0x280
[  224.419142][    C0]  call_timer_fn+0xa6/0x300
[  224.420949][    C0]  __run_timers.part.0+0x209/0x320
[  224.422915][    C0]  run_timer_softirq+0x2c/0x60
[  224.424791][    C0]  __do_softirq+0x174/0x53f
[  224.426462][    C0]  __irq_exit_rcu+0xcb/0x120
[  224.428188][    C0]  irq_exit_rcu+0x5/0x20
[  224.430176][    C0]  sysvec_apic_timer_interrupt+0x8e/0xc0
[  224.432301][    C0]  </IRQ>
[  224.433394][    C0]  <TASK>
[  224.434514][    C0]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[  224.436500][    C0] RIP: 0010:default_idle+0xb/0x10
[  224.438220][    C0] Code: 8b 04 25 40 af 01 00 f0 80 60 02 df c3 0f ae f0 0f ae 38 0f ae f0 eb b9 0f 1f 80 00 00 00 00 eb 07 0f 00 2d e3 b6 56 00 fb f4 <c3> cc cc cc cc 53 48 89 fb e8 67 fb fe ff 48 8b 15 a0 91 4e 02 89
[  224.444865][    C0] RSP: 0018:ffffffff83e03ea8 EFLAGS: 00000202
[  224.447077][    C0] RAX: 00000000000223b5 RBX: ffffffff83e61a00 RCX: 0000000000000001
[  224.449957][    C0] RDX: 0000000000000000 RSI: ffffffff832e9bf1 RDI: ffffffff83246666
[  224.452916][    C0] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
[  224.455677][    C0] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[  224.458458][    C0] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  224.461642][    C0]  default_idle_call+0x54/0x90
[  224.463888][    C0]  do_idle+0x1f3/0x240
[  224.465531][    C0]  cpu_startup_entry+0x14/0x20
[  224.467193][    C0]  start_kernel+0x69c/0x6c1
[  224.469040][    C0]  secondary_startup_64_no_verify+0xc3/0xcb
[  224.471179][    C0]  </TASK>
[  224.472438][    C0] Modules linked in:
[  224.474387][    C0] ---[ end trace 0000000000000000 ]---
[  224.476521][    C0] RIP: 0010:__tcp_transmit_skb+0x5e5/0xbf0
[  224.478893][    C0] Code: 0f 84 33 05 00 00 4c 89 2c 24 49 89 c5 48 c7 40 10 00 00 00 00 e9 c0 fa ff ff 49 8b 46 30 41 0f b7 55 30 48 8b 80 b8 02 00 00 <65> 48 01 50 58 e9 8e fe ff ff 41 8b 86 fc 08 00 00 48 69 c0 e8 03
[  224.485948][    C0] RSP: 0018:ffffc90000003d38 EFLAGS: 00010297
[  224.488110][    C0] RAX: 6b6b6b6b6b6b6b6b RBX: 000000009e2a2659 RCX: ffff888104a39000
[  224.491186][    C0] RDX: 0000000000000001 RSI: ffff8881008054e0 RDI: ffff888035340000
[  224.494378][    C0] RBP: ffff888100805508 R08: 0000000000000000 R09: 0000000000000000
[  224.497576][    C0] R10: ffff888104a39140 R11: 0000000000000000 R12: 0000000000000001
[  224.500600][    C0] R13: ffff8881008054e0 R14: ffff888035340000 R15: 0000000000000020
[  224.503814][    C0] FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
[  224.507136][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  224.509421][    C0] CR2: 000056264812f99c CR3: 000000000a58e000 CR4: 00000000000506f0
[  224.512699][    C0] Kernel panic - not syncing: Fatal exception in interrupt
[  224.515847][    C0] Kernel Offset: disabled
[  224.517636][    C0] Rebooting in 10 seconds..
------------------------------------------------------------

