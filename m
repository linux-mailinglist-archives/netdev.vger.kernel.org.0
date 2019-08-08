Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE29864A7
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 16:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403813AbfHHOps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 10:45:48 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:52098 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403797AbfHHOps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 10:45:48 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2019 10:45:46 EDT
Received: from tux.wizards.de (p5DE2BA44.dip0.t-ipconnect.de [93.226.186.68])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 9353D4168DE9;
        Thu,  8 Aug 2019 16:37:55 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 4C6CAF0160E;
        Thu,  8 Aug 2019 16:37:55 +0200 (CEST)
Subject: Re: [PATCH net-next] r8169: make use of xmit_more
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Eric Dumazet <edumazet@google.com>
References: <2950b2f7-7460-cce0-d964-ad654d897295@gmail.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <acd65426-0c7e-8c5f-a002-a36286f09122@applied-asynchrony.com>
Date:   Thu, 8 Aug 2019 16:37:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2950b2f7-7460-cce0-d964-ad654d897295@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Heiner -

On 7/28/19 11:25 AM, Heiner Kallweit wrote:
> There was a previous attempt to use xmit_more, but the change had to be
> reverted because under load sometimes a transmit timeout occurred [0].
> Maybe this was caused by a missing memory barrier, the new attempt
> keeps the memory barrier before the call to netif_stop_queue like it
> is used by the driver as of today. The new attempt also changes the
> order of some calls as suggested by Eric.
> 
> [0] https://lkml.org/lkml/2019/2/10/39
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

I decided to take one for the team and merged this into my 5.2.x tree (just
fixing up the path) and it has been working fine for the last 2 weeks in two
machines..until today, when for the first time in forever some random NFS traffic
made this old friend come out from under the couch:

[Aug 8 14:13] ------------[ cut here ]------------
[  +0.000006] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
[  +0.000021] WARNING: CPU: 3 PID: 0 at net/sched/sch_generic.c:442 dev_watchdog+0x21f/0x230
[  +0.000001] Modules linked in: lz4 lz4_compress lz4_decompress nfsd auth_rpcgss oid_registry lockd grace sunrpc sch_fq_codel btrfs xor zstd_compress raid6_pq zstd_decompress bfq jitterentropy_rng nct6775 hwmon_vid coretemp hwmon x86_pkg_temp_thermal aesni_intel aes_x86_64 i915 glue_helper crypto_simd cryptd i2c_i801 intel_gtt i2c_algo_bit iosf_mbi drm_kms_helper syscopyarea usbhid sysfillrect r8169 sysimgblt fb_sys_fops realtek drm libphy drm_panel_orientation_quirks i2c_core video backlight mq_deadline
[  +0.000026] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.2.7 #1
[  +0.000001] Hardware name: System manufacturer System Product Name/P8Z68-V LX, BIOS 4105 07/01/2013
[  +0.000004] RIP: 0010:dev_watchdog+0x21f/0x230
[  +0.000002] Code: 3b 00 75 ea eb ad 4c 89 ef c6 05 1c 45 bd 00 01 e8 66 35 fc ff 44 89 e1 4c 89 ee 48 c7 c7 e8 5e fc 81 48 89 c2 e8 90 df 92 ff <0f> 0b eb 8e 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 66 66 66 90
[  +0.000002] RSP: 0018:ffffc90000118e68 EFLAGS: 00010286
[  +0.000002] RAX: 0000000000000000 RBX: ffff8887f7837600 RCX: 0000000000000303
[  +0.000001] RDX: 0000000000000001 RSI: 0000000000000092 RDI: ffffffff827a488c
[  +0.000001] RBP: ffff8887f9fbc440 R08: 0000000000000303 R09: 0000000000000003
[  +0.000001] R10: 000000000001004c R11: 0000000000000001 R12: 0000000000000000
[  +0.000009] R13: ffff8887f9fbc000 R14: ffffffff8173aa20 R15: dead000000000200
[  +0.000001] FS:  0000000000000000(0000) GS:ffff8887ff580000(0000) knlGS:0000000000000000
[  +0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0.000001] CR2: 00007f8d1c04d000 CR3: 0000000002209001 CR4: 00000000000606e0
[  +0.000000] Call Trace:
[  +0.000002]  <IRQ>
[  +0.000005]  call_timer_fn+0x2b/0x120
[  +0.000002]  expire_timers+0xa4/0x100
[  +0.000001]  run_timer_softirq+0x8c/0x170
[  +0.000002]  ? __hrtimer_run_queues+0x13a/0x290
[  +0.000003]  ? sched_clock_cpu+0xe/0x130
[  +0.000003]  __do_softirq+0xeb/0x2de
[  +0.000003]  irq_exit+0x9d/0xe0
[  +0.000002]  smp_apic_timer_interrupt+0x60/0x110
[  +0.000003]  apic_timer_interrupt+0xf/0x20
[  +0.000001]  </IRQ>
[  +0.000003] RIP: 0010:cpuidle_enter_state+0xad/0x930
[  +0.000001] Code: c5 66 66 66 66 90 31 ff e8 90 99 9e ff 80 7c 24 0b 00 74 12 9c 58 f6 c4 02 0f 85 39 08 00 00 31 ff e8 e7 26 a2 ff fb 45 85 e4 <0f> 88 34 02 00 00 49 63 cc 4c 2b 2c 24 48 8d 04 49 48 c1 e0 05 8b
[  +0.000000] RSP: 0018:ffffc9000008be50 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
[  +0.000001] RAX: ffff8887ff5a9180 RBX: ffffffff822b6c40 RCX: 000000000000001f
[  +0.000001] RDX: 0000000000000000 RSI: 0000000033087154 RDI: 0000000000000000
[  +0.000001] RBP: ffff8887ff5b1310 R08: 000030d021fae397 R09: ffff8887ff59c8c0
[  +0.000000] R10: ffff8887ff59c8c0 R11: 0000000000000006 R12: 0000000000000004
[  +0.000001] R13: 000030d021fae397 R14: 0000000000000004 R15: ffff8887fc281600
[  +0.000001]  cpuidle_enter+0x29/0x40
[  +0.000002]  do_idle+0x1e5/0x280
[  +0.000001]  cpu_startup_entry+0x19/0x20
[  +0.000002]  start_secondary+0x186/0x1c0
[  +0.000001]  secondary_startup_64+0xa4/0xb0
[  +0.000001] ---[ end trace 99493c768580f4fd ]---

The device is:

Aug  7 23:19:09 tux kernel: libphy: r8169: probed
Aug  7 23:19:09 tux kernel: r8169 0000:04:00.0 eth0: RTL8168evl/8111evl, c8:60:00:68:33:cc, XID 2c9, IRQ 36
Aug  7 23:19:09 tux kernel: r8169 0000:04:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
Aug  7 23:19:12 tux kernel: RTL8211E Gigabit Ethernet r8169-400:00: attached PHY driver [RTL8211E Gigabit Ethernet] (mii_bus:phy_addr=r8169-400:00, irq=IGNORE)
Aug  7 23:19:13 tux kernel: r8169 0000:04:00.0 eth0: No native access to PCI extended config space, falling back to CSI

and using fq_codel, of course.

This cpuidle hiccup used to be completely gone without xmit_more and this was
the first (and so far only) time since merging it (regardless of load).
Also, while I'm using BMQ as CPU scheduler, that hasn't made a difference for
this particular problem in the past (with MuQSS/PDS) either; way back when I had
Eric's previous attempt(s) it also hiccupped with CFS.

Revert or wait for more reports when -next is merged in 5.4?

thanks,
Holger
