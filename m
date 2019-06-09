Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C00D3AC2A
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 00:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbfFIWEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 18:04:12 -0400
Received: from smtp.knology.net ([64.8.71.112]:50165 "EHLO smtp.knology.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfFIWEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jun 2019 18:04:11 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Jun 2019 18:04:10 EDT
X-CTCH-AV-ThreatsCount: 
X-CTCH-VOD: Unknown
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A150201.5CFD7DA9.0042,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X_CMAE_Category: , ,
X-CNFS-Analysis: v=2.3 cv=OZ/m8SbY c=1 sm=1 tr=0 a=TJn/bo6x+BmUhJ5QWj0rSA==:117 a=TJn/bo6x+BmUhJ5QWj0rSA==:17 a=KGjhK52YXX0A:10 a=IkcTkHD0fZMA:10 a=t3LY3UrxeVQA:10 a=dq6fvYVFJ5YA:10 a=pO7Hyq7_a4YA:10 a=LpQP-O61AAAA:8 a=fhupR4f58NVJc1NYHSgA:9 a=QEXdDO2ut3YA:10 a=pioyyrs4ZptJ924tMmac:22
X-CM-Score: 0
X-Scanned-by: Cloudmark Authority Engine
X-Authed-Username: YnV1c0B3b3d3YXkuY29t
X_CMAE_Category: , ,
X-CNFS-Analysis: 
X-CM-Score: 
X-Scanned-by: Cloudmark Authority Engine
Authentication-Results:  smtp02.wow.cmh.synacor.com smtp.user=buus@wowway.com; auth=pass (LOGIN)
Received: from [96.27.15.54] ([96.27.15.54:57100] helo=[192.168.1.245])
        by smtp.mail.wowway.com (envelope-from <ubuntu@hbuus.com>)
        (ecelerity 3.6.25.56547 r(Core:3.6.25.0)) with ESMTPSA (cipher=AES128-SHA) 
        id 92/3E-27040-8AD7DFC5; Sun, 09 Jun 2019 17:44:09 -0400
From:   H Buus <ubuntu@hbuus.com>
Subject: Should b44_init lead to WARN_ON in drivers/ssb/driver_gpio.c:464?
To:     Michael Buesch <m@bues.ch>, Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <946c86bf-7e90-a981-b9fc-757adb98adfa@hbuus.com>
Date:   Sun, 9 Jun 2019 17:44:10 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have an old 32 bit laptop with a BCM4401-B0 100Base-TX ethernet
controller. For every kernel from 4.19-rc1 going forward, I get a
warning and call trace within a few seconds of start up (see dmesg
snippet below). I have traced it to a specific commit (see commit
below). On the face of it, I would think it is a regression, but it
doesn't seem to cause a problem, since networking over ethernet is working.

I might not have noticed the warning except for the fact that something
in the 4.19 time frame is causing this laptop to be unstable. I still
have to identify the source of the instability. The laptop appears
stable with this commit but not with 4.19-rc7 or more recent kernels.

I thought I should at least ask if the following warning is an issue. If
it is, I am happy to help with creating a proper bug report as well as
debugging and testing. Is this an issue that should be addressed to the
netdev or linux-wireless lists, or both, since it appears to be an
interaction between the b44 driver which belongs to netdev and the ssb
driver which belongs to linux-wireless?

--- Begin dmesg snippet ---
[    5.145764] ssb: Found chip with id 0x4318, rev 0x02 and package 0x02
[    5.265914] b43-pci-bridge 0000:02:03.0: Sonics Silicon Backplane
found on PCI device 0000:02:03.0
[    5.353718] ssb: Found chip with id 0x4401, rev 0x02 and package 0x00
[    5.421787] WARNING: CPU: 0 PID: 157 at drivers/ssb/driver_gpio.c:464
ssb_gpio_init+0xa0/0xb0 [ssb]
[    5.425679] Modules linked in: b44(+) psmouse pata_acpi ssb mii
[    5.425679] CPU: 0 PID: 157 Comm: systemd-udevd Not tainted
4.19.31-041931-generic #201903231635
[    5.425679] Hardware name: Dell Inc. ME051
/0DK344, BIOS A10 11/07/2006
[    5.425679] EIP: ssb_gpio_init+0xa0/0xb0 [ssb]
[    5.425679] Code: 00 31 c0 85 c9 0f 95 c0 31 c9 f7 d8 89 82 18 05 00
00 8d 82 d8 04 00 00 6a 00 e8 1b b6 17 dd 5a c9 c3 8d b4 26 00 00 00 00
90 <0f> 0b c9 b8 ff ff ff ff c3 8d b4 26 00 00 00 00 3e 8d 74 26 00 55
[    5.425679] EAX: f58a3800 EBX: f58a3800 ECX: 00000000 EDX: f7e1ef94
[    5.425679] ESI: 00000000 EDI: f58a3800 EBP: f585bc80 ESP: f585bc80
[    5.425679] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
[    5.425679] CR0: 80050033 CR2: b7ab702b CR3: 3586c000 CR4: 000006f0
[    5.425679] Call Trace:
[    5.425679]  ssb_attach_queued_buses+0xe2/0x310 [ssb]
[    5.425679]  ssb_bus_register+0x167/0x1c0 [ssb]
[    5.425679]  ? ssb_pci_xtal+0x1d0/0x1d0 [ssb]
[    5.425679]  ssb_bus_pcibus_register+0x29/0x80 [ssb]
[    5.425679]  ssb_pcihost_probe+0xb7/0x110 [ssb]
[    5.425679]  ? ssb_pcihost_remove+0x40/0x40 [ssb]
[    5.425679]  pci_device_probe+0xc7/0x160
[    5.425679]  really_probe+0x1fe/0x390
[    5.425679]  driver_probe_device+0xe1/0x120
[    5.425679]  ? pci_match_device+0xde/0x110
[    5.425679]  ? _cond_resched+0x17/0x30
[    5.425679]  __driver_attach+0xd9/0x100
[    5.425679]  ? driver_probe_device+0x120/0x120
[    5.425679]  bus_for_each_dev+0x5b/0xa0
[    5.425679]  driver_attach+0x19/0x20
[    5.425679]  ? driver_probe_device+0x120/0x120
[    5.425679]  bus_add_driver+0x117/0x210
[    5.425679]  ? pci_bus_num_vf+0x20/0x20
[    5.425679]  driver_register+0x66/0xb0
[    5.425679]  ? 0xf8365000
[    5.425679]  __pci_register_driver+0x3d/0x40
[    5.425679]  ssb_pcihost_register+0x2c/0x30 [ssb]
[    5.425679]  b44_init+0x1d/0x1000 [b44]
[    5.425679]  do_one_initcall+0x42/0x19a
[    5.425679]  ? vunmap_page_range+0x1c9/0x260
[    5.425679]  ? free_pcp_prepare+0x5d/0xf0
[    5.425679]  ? _cond_resched+0x17/0x30
[    5.425679]  ? kmem_cache_alloc_trace+0x15f/0x1b0
[    5.425679]  ? do_init_module+0x21/0x210
[    5.425679]  ? do_init_module+0x21/0x210
[    5.425679]  do_init_module+0x50/0x210
[    5.425679]  load_module+0x1368/0x1630
[    5.425679]  ? security_kernel_post_read_file+0x54/0x60
[    5.425679]  sys_finit_module+0x8a/0xe0
[    5.425679]  do_fast_syscall_32+0x87/0x1e0
[    5.425679]  entry_SYSENTER_32+0x6b/0xbe
[    5.425679] EIP: 0xb7eead61
[    5.425679] Code: f6 ff ff 55 89 e5 8b 55 08 8b 80 5c cd ff ff 85 d2
74 02 89 02 5d c3 8b 04 24 c3 8b 1c 24 c3 90 90 51 52 55 89 e5 0f 34 cd
80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90 8d 76
[    5.425679] EAX: ffffffda EBX: 0000000d ECX: b7cfda15 EDX: 00000000
[    5.425679] ESI: 00fcaf40 EDI: 00fcca40 EBP: 00000000 ESP: bfa404dc
[    5.425679] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000296
[    5.425679] ---[ end trace b0d87e1b3433e0ca ]---
[    6.245890] b44 0000:02:00.0: Sonics Silicon Backplane found on PCI
device 0000:02:00.0
[    6.260263] b44: Broadcom 44xx/47xx 10/100 PCI ethernet driver
version 2.0
[    6.299684] b44 ssb1:0 eth0: Broadcom 44xx/47xx 10/100 PCI ethernet
driver 00:14:22:af:83:9b
[    6.367622] random: fast init done
--- End dmesg snippet ---

--- Begin commit ---
commit 209b43759d65b2cc99ce7757249aacc82b03c4e2
Author: Michael Büsch <m@bues.ch>
Date:   Tue Jul 31 22:15:09 2018 +0200

    ssb: Remove SSB_WARN_ON, SSB_BUG_ON and SSB_DEBUG

    Use the standard WARN_ON instead.
    If a small kernel is desired, WARN_ON can be disabled globally.

    Also remove SSB_DEBUG. Besides WARN_ON it only adds a tiny debug check.
    Include this check unconditionally.

    Signed-off-by: Michael Buesch <m@bues.ch>
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
--- End commit ---
