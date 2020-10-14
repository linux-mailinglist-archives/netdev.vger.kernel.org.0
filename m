Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5800928E8BA
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 00:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgJNW04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 18:26:56 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:51141 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbgJNW0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 18:26:55 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 7c0c6b71;
        Wed, 14 Oct 2020 21:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=TU737/o0EBlcLX3vdsHaqc4TMtU=; b=KFFQLDq
        NiCP6gjEHZ77SHhxRlWBn4mmr+6Q+uPRmHyzXb/NsRF4megKkSkz1dLglJo4UYb4
        zwijaio2GOPrOswIStYlUSHg0W4awanYKL1mEmVIlTbVghEqpdfs2plKwbuuUpxS
        SjgjRk34BJL9m15bTLxRHueu4WjTztKWEwEgCcWIuePdkdps4sU2K2nQitqMqxj6
        EHK/Adq1/+QnTNNWSIl5y6ofF6LY5qNO1ZqXbdRI88U4yNX3SYkcDzL8c3EDUV1V
        jCt+LWD7QdAd+68vDK2/w6z0dPtJliAg0sau6duqa9ItNe9KegR1brJzmJY13g4o
        2QVonpWDolBSyrg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 21b9ed86 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 14 Oct 2020 21:53:18 +0000 (UTC)
Date:   Thu, 15 Oct 2020 00:26:50 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Al Viro <viro@ZenIV.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 20/20] ppc: propagate the calling conventions change
 down to csum_partial_copy_generic()
Message-ID: <20201014222650.GA390346@zx2c4.com>
References: <20200724012512.GK2786714@ZenIV.linux.org.uk>
 <20200724012546.302155-1-viro@ZenIV.linux.org.uk>
 <20200724012546.302155-20-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200724012546.302155-20-viro@ZenIV.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Al,

On Fri, Jul 24, 2020 at 02:25:46AM +0100, Al Viro wrote:
> From: Al Viro <viro@zeniv.linux.org.uk>
> 
> ... and get rid of the pointless fallback in the wrappers.  On error it used
> to zero the unwritten area and calculate the csum of the entire thing.  Not
> wanting to do it in assembler part had been very reasonable; doing that in
> the first place, OTOH...  In case of an error the caller discards the data
> we'd copied, along with whatever checksum it might've had.

This patch is causing crashes in WireGuard's CI over at
https://www.wireguard.com/build-status/ . Apparently sending a simple
network packet winds up triggering refcount_t's warn-on-saturate code. I
don't know if the new assembly failed to reset some flag or if something
else is up. I can start digging into it if you want, but I thought I
should let you know first about the issue. The splat follows below.

Thanks,
Jason

$ ping -c 10 -f -W 1 192.168.241.1
PING 192.168.241.1 (192.168.241.1) 56(84) bytes of data.
[    1.432922] ------------[ cut here ]------------
[    1.433069] refcount_t: saturated; leaking memory.
[    1.433344] WARNING: CPU: 3 PID: 90 at refcount_warn_saturate+0x100/0x1bc
[    1.433646] CPU: 3 PID: 90 Comm: ping Not tainted 5.9.0+ #3
[    1.433797] NIP:  c01a6fa0 LR: c01a6fa0 CTR: c01ccbec
[    1.433964] REGS: cfacfb80 TRAP: 0700   Not tainted  (5.9.0+)
[    1.434102] MSR:  00029000 <CE,EE,ME>  CR: 28022404  XER: 00000000
[    1.434345]
[    1.434345] GPR00: c01a6fa0 cfacfc38 cf8eeae0 00000026 3fffefff cfacfa90 cfacfaa0 00021000
[    1.434345] GPR08: 0f4a1000 00000000 c08b4674 c0918704 42022404 00000000 cfa34180 00000000
[    1.434345] GPR16: 00000000 cf8ef004 00000000 00000000 00000040 00000000 00000000 cfbac230
[    1.434345] GPR24: cfacfce8 c02a802c 00000000 cfa34180 cfacfc58 c02aa53c 55c0a4ff 00000000
[    1.435471] NIP [c01a6fa0] refcount_warn_saturate+0x100/0x1bc
[    1.435615] LR [c01a6fa0] refcount_warn_saturate+0x100/0x1bc
[    1.435825] Call Trace:
[    1.435922] [cfacfc38] [c01a6fa0] refcount_warn_saturate+0x100/0x1bc (unreliable)
[    1.436149] [cfacfc48] [c02a7f14] __ip_append_data.isra.0+0x8a8/0xde0
[    1.436302] [cfacfce8] [c02a84e0] ip_append_data.part.0+0x94/0xf0
[    1.436438] [cfacfd18] [c02dffe0] raw_sendmsg+0x298/0xa84
[    1.436544] [cfacfe48] [c020b9ec] __sys_sendto+0xdc/0x13c
[    1.436641] [cfacff38] [c000f1dc] ret_from_syscall+0x0/0x38
[    1.436824] --- interrupt: c01 at 0xb7e44f00
[    1.436824]     LR = 0xb7e21ba0
[    1.437038] Instruction dump:
[    1.437239] 3d20c092 39291bc1 89490001 2c0a0000 4082ff64 3c60c040 7c0802a6 39400001
[    1.437439] 38633b74 90010014 99490001 4be9b6e1 <0fe00000> 80010014 7c0803a6 4bffff38
[    1.437753] ---[ end trace aaa4b4788958d0a6 ]---
[    1.440214] ------------[ cut here ]------------
[    1.440301] refcount_t: underflow; use-after-free.
[    1.440397] WARNING: CPU: 3 PID: 90 at refcount_warn_saturate+0x1ac/0x1bc
[    1.440587] CPU: 3 PID: 90 Comm: ping Tainted: G        W         5.9.0+ #3
[    1.440741] NIP:  c01a704c LR: c01a704c CTR: c01ccbec
[    1.440857] REGS: cfacfaa0 TRAP: 0700   Tainted: G        W          (5.9.0+)
[    1.441016] MSR:  00029000 <CE,EE,ME>  CR: 48022404  XER: 00000000
[    1.441176]
[    1.441176] GPR00: c01a704c cfacfb58 cf8eeae0 00000026 3fffefff cfacf9b0 cfacf9c0 00021000
[    1.441176] GPR08: 0f4a1000 00000400 c08b4674 c0918704 42022404 00000000 10020464 00000003
[    1.441176] GPR16: 7ff00000 10020000 00000080 cfb27000 cfb2704c c0930000 cfacfc54 c092d260
[    1.441176] GPR24: 0000058c cfa82120 cfa8212c cfa8212c 00000000 cfa82000 cfacfd44 cfacfc58
[    1.441995] NIP [c01a704c] refcount_warn_saturate+0x1ac/0x1bc
[    1.442125] LR [c01a704c] refcount_warn_saturate+0x1ac/0x1bc
[    1.442252] Call Trace:
[    1.442320] [cfacfb58] [c01a704c] refcount_warn_saturate+0x1ac/0x1bc (unreliable)
[    1.442726] [cfacfb68] [c020e7dc] sock_wfree+0x130/0x134
[    1.442877] [cfacfb78] [c01f1388] wg_packet_send_staged_packets+0x234/0x6b4
[    1.443061] [cfacfbb8] [c01eecf8] wg_xmit+0x2a0/0x46c
[    1.443204] [cfacfbf8] [c0232134] dev_hard_start_xmit+0x190/0x1c0
[    1.443369] [cfacfc38] [c0232f2c] __dev_queue_xmit+0x4d0/0x844
[    1.443527] [cfacfc88] [c02a7134] ip_finish_output2+0x180/0x6b8
[    1.443686] [cfacfcb8] [c02aa3e8] ip_output+0xf0/0x1c0
[    1.443829] [cfacfd08] [c02ab14c] ip_send_skb+0x24/0xe8
[    1.443975] [cfacfd18] [c02e04bc] raw_sendmsg+0x774/0xa84
[    1.444124] [cfacfe48] [c020b9ec] __sys_sendto+0xdc/0x13c
[    1.444274] [cfacff38] [c000f1dc] ret_from_syscall+0x0/0x38
[    1.444437] --- interrupt: c01 at 0xb7e44f00
[    1.444437]     LR = 0xb7e21ba0
[    1.444644] Instruction dump:
[    1.444736] 4be9b661 0fe00000 80010014 7c0803a6 4bfffeb8 3c60c040 7c0802a6 39400001
[    1.444989] 38633bd8 90010014 99490003 4be9b635 <0fe00000> 80010014 7c0803a6 4bfffe8c
[    1.445252] ---[ end trace aaa4b4788958d0a7 ]---
[    1.445583] BUG: Unable to handle kernel instruction fetch (NULL pointer?)
[    1.445767] Faulting instruction address: 0x00000000
[    1.446051] Oops: Kernel access of bad area, sig: 11 [#1]
[    1.446210] BE PAGE_SIZE=4K PREEMPT SMP NR_CPUS=4 QEMU e500
[    1.446379] CPU: 3 PID: 90 Comm: ping Tainted: G        W         5.9.0+ #3
[    1.446678] NIP:  00000000 LR: c020e758 CTR: 00000000
[    1.446812] REGS: cfacfab0 TRAP: 0400   Tainted: G        W          (5.9.0+)
[    1.446989] MSR:  00029000 <CE,EE,ME>  CR: 48022404  XER: 00000000
[    1.447183]
[    1.447183] GPR00: c020e7dc cfacfb68 cf8eeae0 cfacfc58 3fffefff cfacf9b0 cfacf9c0 00021000
[    1.447183] GPR08: 0f4a1000 00000000 c08b4674 c0918704 42022404 00000000 10020464 00000003
[    1.447183] GPR16: 7ff00000 10020000 00000080 cfb27000 cfb2704c c0930000 cfacfc54 c092d260
[    1.447183] GPR24: 0000058c cfa82120 cfa8212c cfa8212c 00000000 cfa82000 cfacfd44 cfacfc58
[    1.448144] NIP [00000000] 0x0
[    1.448236] LR [c020e758] sock_wfree+0xac/0x134
[    1.448351] Call Trace:
[    1.448425] [cfacfb68] [c020e7dc] sock_wfree+0x130/0x134 (unreliable)
[    1.448603] [cfacfb78] [c01f1388] wg_packet_send_staged_packets+0x234/0x6b4
[    1.448820] [cfacfbb8] [c01eecf8] wg_xmit+0x2a0/0x46c
[    1.448964] [cfacfbf8] [c0232134] dev_hard_start_xmit+0x190/0x1c0
[    1.449139] [cfacfc38] [c0232f2c] __dev_queue_xmit+0x4d0/0x844
[    1.449304] [cfacfc88] [c02a7134] ip_finish_output2+0x180/0x6b8
[    1.449475] [cfacfcb8] [c02aa3e8] ip_output+0xf0/0x1c0
[    1.449628] [cfacfd08] [c02ab14c] ip_send_skb+0x24/0xe8
[    1.449815] [cfacfd18] [c02e04bc] raw_sendmsg+0x774/0xa84
[    1.449983] [cfacfe48] [c020b9ec] __sys_sendto+0xdc/0x13c
[    1.450150] [cfacff38] [c000f1dc] ret_from_syscall+0x0/0x38
[    1.450320] --- interrupt: c01 at 0xb7e44f00
[    1.450320]     LR = 0xb7e21ba0
[    1.450794] Instruction dump:
[    1.450963] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
[    1.451209] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
[    1.451637] ---[ end trace aaa4b4788958d0a8 ]---
[    1.451785]
[    2.555288] Kernel panic - not syncing: Aiee, killing interrupt handler!
