Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19ED86ACD
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403798AbfHHTwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:52:22 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:52916 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729925AbfHHTwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:52:21 -0400
Received: from tux.wizards.de (p5DE2BA44.dip0.t-ipconnect.de [93.226.186.68])
        by mail02.iobjects.de (Postfix) with ESMTPSA id C8EB141626F4;
        Thu,  8 Aug 2019 21:52:18 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id DAB25F0160E;
        Thu,  8 Aug 2019 21:52:17 +0200 (CEST)
Subject: Re: [PATCH net-next] r8169: make use of xmit_more
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Eric Dumazet <edumazet@google.com>
References: <2950b2f7-7460-cce0-d964-ad654d897295@gmail.com>
 <acd65426-0c7e-8c5f-a002-a36286f09122@applied-asynchrony.com>
 <cfb9a1c7-57c8-db04-1081-ac1cb92bb447@applied-asynchrony.com>
 <a19bb3de-a866-d342-7cca-020fef219d03@gmail.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <868a1f4c-5fba-c64b-ea31-30a3770e6a2f@applied-asynchrony.com>
Date:   Thu, 8 Aug 2019 21:52:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a19bb3de-a866-d342-7cca-020fef219d03@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/19 8:17 PM, Heiner Kallweit wrote:
> On 08.08.2019 17:53, Holger Hoffstätte wrote:
>> On 8/8/19 4:37 PM, Holger Hoffstätte wrote:
>>>
>>> Hello Heiner -
>>>
>>> On 7/28/19 11:25 AM, Heiner Kallweit wrote:
>>>> There was a previous attempt to use xmit_more, but the change had to be
>>>> reverted because under load sometimes a transmit timeout occurred [0].
>>>> Maybe this was caused by a missing memory barrier, the new attempt
>>>> keeps the memory barrier before the call to netif_stop_queue like it
>>>> is used by the driver as of today. The new attempt also changes the
>>>> order of some calls as suggested by Eric.
>>>>
>>>> [0] https://lkml.org/lkml/2019/2/10/39
>>>>
>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>
>>> I decided to take one for the team and merged this into my 5.2.x tree (just
>>> fixing up the path) and it has been working fine for the last 2 weeks in two
>>> machines..until today, when for the first time in forever some random NFS traffic
>>> made this old friend come out from under the couch:
>>>
>>> [Aug 8 14:13] ------------[ cut here ]------------
>>> [  +0.000006] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
>>> [  +0.000021] WARNING: CPU: 3 PID: 0 at net/sched/sch_generic.c:442 dev_watchdog+0x21f/0x230
>>> [  +0.000001] Modules linked in: lz4 lz4_compress lz4_decompress nfsd auth_rpcgss oid_registry lockd grace sunrpc sch_fq_codel btrfs xor zstd_compress raid6_pq zstd_decompress bfq jitterentropy_rng nct6775 hwmon_vid coretemp hwmon x86_pkg_temp_thermal aesni_intel aes_x86_64 i915 glue_helper crypto_simd cryptd i2c_i801 intel_gtt i2c_algo_bit iosf_mbi drm_kms_helper syscopyarea usbhid sysfillrect r8169 sysimgblt fb_sys_fops realtek drm libphy drm_panel_orientation_quirks i2c_core video backlight mq_deadline
>>> [  +0.000026] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.2.7 #1
>>> [  +0.000001] Hardware name: System manufacturer System Product Name/P8Z68-V LX, BIOS 4105 07/01/2013
>>> [  +0.000004] RIP: 0010:dev_watchdog+0x21f/0x230
>>> [  +0.000002] Code: 3b 00 75 ea eb ad 4c 89 ef c6 05 1c 45 bd 00 01 e8 66 35 fc ff 44 89 e1 4c 89 ee 48 c7 c7 e8 5e fc 81 48 89 c2 e8 90 df 92 ff <0f> 0b eb 8e 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 66 66 66 90
>>> [  +0.000002] RSP: 0018:ffffc90000118e68 EFLAGS: 00010286
>>> [  +0.000002] RAX: 0000000000000000 RBX: ffff8887f7837600 RCX: 0000000000000303
>>> [  +0.000001] RDX: 0000000000000001 RSI: 0000000000000092 RDI: ffffffff827a488c
>>> [  +0.000001] RBP: ffff8887f9fbc440 R08: 0000000000000303 R09: 0000000000000003
>>> [  +0.000001] R10: 000000000001004c R11: 0000000000000001 R12: 0000000000000000
>>> [  +0.000009] R13: ffff8887f9fbc000 R14: ffffffff8173aa20 R15: dead000000000200
>>> [  +0.000001] FS:  0000000000000000(0000) GS:ffff8887ff580000(0000) knlGS:0000000000000000
>>> [  +0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  +0.000001] CR2: 00007f8d1c04d000 CR3: 0000000002209001 CR4: 00000000000606e0
>>> [  +0.000000] Call Trace:
>>> [  +0.000002]  <IRQ>
>>> [  +0.000005]  call_timer_fn+0x2b/0x120
>>> [  +0.000002]  expire_timers+0xa4/0x100
>>> [  +0.000001]  run_timer_softirq+0x8c/0x170
>>> [  +0.000002]  ? __hrtimer_run_queues+0x13a/0x290
>>> [  +0.000003]  ? sched_clock_cpu+0xe/0x130
>>> [  +0.000003]  __do_softirq+0xeb/0x2de
>>> [  +0.000003]  irq_exit+0x9d/0xe0
>>> [  +0.000002]  smp_apic_timer_interrupt+0x60/0x110
>>> [  +0.000003]  apic_timer_interrupt+0xf/0x20
>>> [  +0.000001]  </IRQ>
>>> [  +0.000003] RIP: 0010:cpuidle_enter_state+0xad/0x930
>>> [  +0.000001] Code: c5 66 66 66 66 90 31 ff e8 90 99 9e ff 80 7c 24 0b 00 74 12 9c 58 f6 c4 02 0f 85 39 08 00 00 31 ff e8 e7 26 a2 ff fb 45 85 e4 <0f> 88 34 02 00 00 49 63 cc 4c 2b 2c 24 48 8d 04 49 48 c1 e0 05 8b
>>> [  +0.000000] RSP: 0018:ffffc9000008be50 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
>>> [  +0.000001] RAX: ffff8887ff5a9180 RBX: ffffffff822b6c40 RCX: 000000000000001f
>>> [  +0.000001] RDX: 0000000000000000 RSI: 0000000033087154 RDI: 0000000000000000
>>> [  +0.000001] RBP: ffff8887ff5b1310 R08: 000030d021fae397 R09: ffff8887ff59c8c0
>>> [  +0.000000] R10: ffff8887ff59c8c0 R11: 0000000000000006 R12: 0000000000000004
>>> [  +0.000001] R13: 000030d021fae397 R14: 0000000000000004 R15: ffff8887fc281600
>>> [  +0.000001]  cpuidle_enter+0x29/0x40
>>> [  +0.000002]  do_idle+0x1e5/0x280
>>> [  +0.000001]  cpu_startup_entry+0x19/0x20
>>> [  +0.000002]  start_secondary+0x186/0x1c0
>>> [  +0.000001]  secondary_startup_64+0xa4/0xb0
>>> [  +0.000001] ---[ end trace 99493c768580f4fd ]---
>>>
>>> The device is:
>>>
>>> Aug  7 23:19:09 tux kernel: libphy: r8169: probed
>>> Aug  7 23:19:09 tux kernel: r8169 0000:04:00.0 eth0: RTL8168evl/8111evl, c8:60:00:68:33:cc, XID 2c9, IRQ 36
>>> Aug  7 23:19:09 tux kernel: r8169 0000:04:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
>>> Aug  7 23:19:12 tux kernel: RTL8211E Gigabit Ethernet r8169-400:00: attached PHY driver [RTL8211E Gigabit Ethernet] (mii_bus:phy_addr=r8169-400:00, irq=IGNORE)
>>> Aug  7 23:19:13 tux kernel: r8169 0000:04:00.0 eth0: No native access to PCI extended config space, falling back to CSI
>>>
>>> and using fq_codel, of course.
>>>
>>> This cpuidle hiccup used to be completely gone without xmit_more and this was
>>> the first (and so far only) time since merging it (regardless of load).
>>> Also, while I'm using BMQ as CPU scheduler, that hasn't made a difference for
>>> this particular problem in the past (with MuQSS/PDS) either; way back when I had
>>> Eric's previous attempt(s) it also hiccupped with CFS.
>>>
>>> Revert or wait for more reports when -next is merged in 5.4?
>>
>> Another question/data point: I've had the whole basket of offloads activated:
>>
>>    ethtool --offload eth0 rx on tx on gro on gso on sg on tso on
>>
>> and this caused zero problems without the xmit_more patch. However I just saw
>> that net-next has a patch where TSO is disabled due to a known HW defect in
>> RTL8168evl, which is of course what I have. Could this be the reason for the
>> stall/hiccup when xmit_more has its fingers in the pie? I kind of know what
>> xmit_more does, just not how it could interact with a possibly broken TSO that
>> nevertheless seems to work fine otherwise..
>>
> 
> I was about to ask exactly that, whether you have TSO enabled. I don't know what
> can trigger the HW issue, it was just confirmed by Realtek that this chip version
> has a problem with TSO. So the logical conclusion is: test w/o TSO, ideally the
> linux-next version.

So disabling TSO alone didn't work - it leads to reduced throughout (~70 MB/s in iperf).
Instead I decided to backport 93681cd7d94f ("r8169: enable HW csum and TSO"), which
wasn't easy due to cleanups/renamings of dependencies, but I managed to backport
it and .. got the same problem of reduced throughout. wat?!

After lots of trial & error I started disabling all offloads and finally found
that sg (Scatter-Gather) enabled alone - without TSO - will lead to the throughput
drop. So the culprit seems 93681cd7d94f, which disabled TSO on my NIC, but left
sg on by default. This weas repeatable - switch on sg, throughput drop; turn it
off - smooth sailing, now with reduced buffers.

I modified the relevant bits to disable tso & sg like this:

	/* RTL8168e-vl has a HW issue with TSO */
	if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
+		dev->vlan_features &= ~(NETIF_F_ALL_TSO|NETIF_F_SG);
+		dev->hw_features &= ~(NETIF_F_ALL_TSO|NETIF_F_SG);
+		dev->features &= ~(NETIF_F_ALL_TSO|NETIF_F_SG);
	}

This seems to work since it restores performance without sg/tso by default
and without any additional offloads, yet with xmit_more in the mix.
We'll see whether that is stable over the next few days, but I strongly
suspect it will be good and that the hiccups were due to xmit_more/TSO
interaction.

thanks,
Holger
