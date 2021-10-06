Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0514245EF
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhJFSXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhJFSXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 14:23:35 -0400
X-Greylist: delayed 560 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 Oct 2021 11:21:42 PDT
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD435C061746
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 11:21:42 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd741d.dip0.t-ipconnect.de [93.221.116.29])
        by mail.itouring.de (Postfix) with ESMTPSA id 0B62F103762;
        Wed,  6 Oct 2021 20:12:19 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id A47D2F01608;
        Wed,  6 Oct 2021 20:12:18 +0200 (CEST)
To:     Netdev <netdev@vger.kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: atlantic: Warning: need_resched with CONFIG_SCHED_DEBUG=y
Organization: Applied Asynchrony, Inc.
Message-ID: <4d102766-46c1-36e5-c4b3-1e9aa811522d@applied-asynchrony.com>
Date:   Wed, 6 Oct 2021 20:12:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I recently noticed a repeatable warning on every boot on both of my machines with
ACQ107 NICs:

--snip--
[  +0.000002] sched: CPU 2 need_resched set for > 103331686 ns (31 ticks) without schedule
[  +0.000004] WARNING: CPU: 2 PID: 1997 at kernel/sched/debug.c:1072 resched_latency_warn+0x52/0x60
[  +0.000004] Modules linked in: snd_hda_codec_realtek mq_deadline aesni_intel snd_hda_codec_generic snd_hda_codec_hdmi ledtrig_audio crypto_simd bfq cryptd radeon(+) i2c_algo_bit drm_ttm_helper ttm drm_kms_helper syscopyarea uvcvideo sysfillrect snd_hda_intel videobuf2_vmalloc sysimgblt snd_usb_audio fb_sys_fops videobuf2_memops snd_intel_dspcfg videobuf2_v4l2 snd_hwdep snd_hda_codec videobuf2_common snd_usbmidi_lib drm snd_rawmidi snd_hda_core snd_seq_device videodev drm_panel_orientation_quirks i2c_i801 backlight snd_pcm atlantic(+) i2c_smbus mc parport_pc snd_timer i2c_core usbhid(+) snd soundcore hwmon parport
[  +0.000038] CPU: 2 PID: 1997 Comm: systemd-udevd Not tainted 5.14.6 #1
[  +0.000002] Hardware name: Gigabyte Technology Co., Ltd. P67-DS3-B3/P67-DS3-B3, BIOS F1 05/06/2011
[  +0.000001] RIP: 0010:resched_latency_warn+0x52/0x60
[  +0.000002] Code: 48 63 d5 48 c7 c0 40 a6 02 00 89 ee 48 8b 14 d5 c0 e6 0f 82 48 c7 c7 78 bd 07 82 8b 8c 02 80 0c 00 00 4c 89 e2 e8 e2 26 74 00 <0f> 0b 5d 41 5c c3 cc cc cc cc cc cc cc cc 0f 1f 44 00 00 48 8b 05
[  +0.000002] RSP: 0000:ffffc90000130ea8 EFLAGS: 00010096
[  +0.000001] RAX: 000000000000004c RBX: ffff8886074aa640 RCX: 00000000ffff7fff
[  +0.000002] RDX: 00000000ffffffea RSI: 0000000000000001 RDI: 00000000ffff7fff
[  +0.000001] RBP: 0000000000000002 R08: ffff88861f6da3a8 R09: 00000000ffff7fff
[  +0.000001] R10: ffff888607140000 R11: ffff888607140000 R12: 000000000628b766
[  +0.000000] R13: ffffc90000983b38 R14: 0000000000000002 R15: ffff88860749e100
[  +0.000002] FS:  00007fcf8ea697c0(0000) GS:ffff888607480000(0000) knlGS:0000000000000000
[  +0.000001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0.000001] CR2: 00005573b22481a9 CR3: 0000000106657004 CR4: 00000000000606e0
[  +0.000001] Call Trace:
[  +0.000002]  <IRQ>
[  +0.000001]  scheduler_tick+0x1f0/0x220
[  +0.000003]  update_process_times+0xb0/0xc0
[  +0.000003]  tick_sched_handle+0x34/0x50
[  +0.000003]  tick_sched_timer+0x7a/0xa0
[  +0.000001]  ? can_stop_idle_tick+0x90/0x90
[  +0.000002]  __hrtimer_run_queues+0x112/0x240
[  +0.000002]  hrtimer_interrupt+0x110/0x2c0
[  +0.000001]  __sysvec_apic_timer_interrupt+0x4e/0xc0
[  +0.000004]  sysvec_apic_timer_interrupt+0x65/0x90
[  +0.000003]  </IRQ>
[  +0.000000]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[  +0.000004] RIP: 0010:delay_tsc+0x35/0x70
[  +0.000002] Code: 05 48 fe b6 7e 0f 01 f9 66 90 48 c1 e2 20 48 89 d7 48 09 c7 eb 11 f3 90 65 8b 35 2e fe b6 7e 41 39 f0 75 1b 41 89 f0 0f 01 f9 <66> 90 48 c1 e2 20 48 09 d0 48 89 c2 48 29 fa 4c 39 ca 72 d8 c3 4c
[  +0.000001] RSP: 0000:ffffc90000983be0 EFLAGS: 00000246
[  +0.000001] RAX: 00000000579f3172 RBX: 0000000000000004 RCX: 0000000000000002
[  +0.000001] RDX: 000000000000001c RSI: 0000000000000002 RDI: 0000001c57978593
[  +0.000001] RBP: ffff888107c22000 R08: 0000000000000002 R09: 000000000033c32e
[  +0.000001] R10: ffff888107535940 R11: 0000000000000006 R12: 00000000000003e4
[  +0.000001] R13: 0000000007000000 R14: ffff888107c39000 R15: ffff888107c22000
[  +0.000002]  hw_atl_utils_soft_reset+0x34b/0x5a0 [atlantic]
[  +0.000012]  aq_nic_ndev_register+0x33/0x210 [atlantic]
[  +0.000008]  aq_pci_probe+0x33c/0x390 [atlantic]
[  +0.000007]  local_pci_probe+0x3d/0x70
[  +0.000003]  ? __cond_resched+0x16/0x40
[  +0.000002]  pci_device_probe+0xd1/0x190
[  +0.000002]  really_probe.part.0+0x9c/0x280
[  +0.000003]  __driver_probe_device+0x90/0x120
[  +0.000001]  driver_probe_device+0x1e/0xe0
[  +0.000001]  __driver_attach+0xa8/0x170
[  +0.000002]  ? __device_attach_driver+0xe0/0xe0
[  +0.000001]  bus_for_each_dev+0x63/0x90
[  +0.000003]  bus_add_driver+0x10b/0x1c0
[  +0.000002]  driver_register+0x8f/0xe0
[  +0.000002]  ? 0xffffffffa00c5000
[  +0.000001]  aq_ndev_init_module+0x49/0x1000 [atlantic]
[  +0.000007]  do_one_initcall+0x41/0x1c0
[  +0.000003]  ? __cond_resched+0x16/0x40
[  +0.000001]  ? kmem_cache_alloc_trace+0x44/0x3c0
[  +0.000002]  do_init_module+0x5c/0x270
[  +0.000002]  __do_sys_finit_module+0x8f/0xc0
[  +0.000002]  do_syscall_64+0x35/0x80
[  +0.000003]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  +0.000003] RIP: 0033:0x7fcf8eca5f99
[  +0.000001] Code: 0c 00 b8 ca 00 00 00 0f 05 eb a5 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 9f 5e 0c 00 f7 d8 64 89 01 48
[  +0.000001] RSP: 002b:00007fffa3ccd0c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[  +0.000002] RAX: ffffffffffffffda RBX: 00005573b395a1b0 RCX: 00007fcf8eca5f99
[  +0.000000] RDX: 0000000000000000 RSI: 00007fcf8ee23b65 RDI: 000000000000000d
[  +0.000001] RBP: 0000000000020000 R08: 0000000000000000 R09: 00005573b3925b70
[  +0.000001] R10: 000000000000000d R11: 0000000000000246 R12: 00007fcf8ee23b65
[  +0.000001] R13: 0000000000000000 R14: 00005573b395c0f0 R15: 00005573b395a1b0
[  +0.000002] ---[ end trace 6e0e13c0054d96a9 ]---
--snip--

This started after upgrade from 5.10.x to 5.14.x, and I traced it to commit
c006fac556e4 ("sched: Warn on long periods of pending need_resched"), and the fact
that I had SCHED_DEBUG enabled. The important detail here might be that I'm using
a non-standard CPU scheduler (PDS, part of the ProjectC patchset) which provides
much better responsiveness & lower scheduling latency than CFS.

My bug report & initial investigation about this can be found at:
https://gitlab.com/alfredchen/linux-prjc/-/issues/38

I haven't tried to reproduce this with CFS yet, but I *did* look into the source
and found lots of calls to AQ_HW_SLEEP, with quite a few long delays (10s of ms)
during hw_atl_utils_soft_reset().

For now I have disabled SCHED_DEBUG but nevertheless wanted to bring this to
your attention. Maybe you can replace the longer sleeps with staggered shorter
ones and sprinkle a cond_resched() in there as well. I don't know enough about
the nitty-gritty detils of the chip reset process, otherwise I'd have attempted
something myself.

If you come up with a patch please let me know and I'll gladly test.

thanks,
Holger
