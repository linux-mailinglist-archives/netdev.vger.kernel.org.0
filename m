Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A14D36054D
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhDOJJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:09:59 -0400
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:34100
        "EHLO know-smtprelay-omc-10.server.virginmedia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231678AbhDOJJ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 05:09:59 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2021 05:09:58 EDT
Received: from trevor4.trevor.local ([82.3.223.249])
        by cmsmtp with ESMTPA
        id WxunlXqa9LZWkWxuolGCsb; Thu, 15 Apr 2021 10:03:58 +0100
X-Originating-IP: [82.3.223.249]
X-Authenticated-User: trevor.hemsley@ntlworld.com
X-Spam: 0
X-Authority: v=2.3 cv=HPTt6Llv c=1 sm=1 tr=0 cx=a_exe
 a=7Y/zLBzgJ9hZK8ZgStTyBw==:117 a=7Y/zLBzgJ9hZK8ZgStTyBw==:17
 a=IkcTkHD0fZMA:10 a=3YhXtTcJ-WEA:10 a=20KFwNOVAAAA:8 a=anyjoqyV-L9izOv4T00A:9
 a=QEXdDO2ut3YA:10
Received: from trevor4.trevor.local (localhost [127.0.0.1])
        by trevor4.trevor.local (Postfix) with ESMTP id B6E80120F72
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 10:03:57 +0100 (BST)
To:     netdev@vger.kernel.org
From:   Trevor Hemsley <themsley@voiceflex.com>
Subject: Panic in sfc module on boot since 5.10
Message-ID: <c510abba-3e99-6d7e-64ad-572d55d73695@voiceflex.com>
Date:   Thu, 15 Apr 2021 10:03:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-CMAE-Envelope: MS4wfNULx/NcWFtwaRotUoaVelfdUBFNL10PrfjhWMlHStPdNjPq30gzDQz5yuYpjFnOhp2LhsENaZ8eSYkfM9/LCF+MJsb6kmj6Uthcfk7sbzcG5WpMZWlP
 CDDi/khUcZssNnvE1jYjLO6Rq4sQ2iac2gtW7leMik/E0/AafHQLzkd9Bnr8P/+QFsHFkhHsPvabEg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I run Fedora 32 and since kernels in the 5.10 series I have been unable 
to boot without getting a panic in the sfc module. I tried on 5.11.12 
tonight and the crash still occurs. I have tried reporting this via 
Fedora channels but the silence has been deafening and I suspect this is 
an upstream issue anyway.

I'm running an Asus X570-Pro with a 3700x processor, 64GB ECC RAM and 
various nvme/SATA disks. I have a dual port Solarflare SFN6122F PCIE 
card installed that shows up in lspci as:

0b:00.0 Ethernet controller [0200]: Solarflare Communications SFC9020 
10G Ethernet Controller [1924:0803]
0b:00.1 Ethernet controller [0200]: Solarflare Communications SFC9020 
10G Ethernet Controller [1924:0803]

I have attached jpegs of the crash on the Fedora bugzilla entry 
https://bugzilla.redhat.com/show_bug.cgi?id=1924982 but since I figure 
many here won't want to download a 2.5MB attachment from a slow bugzilla 
I'll try to transcribe the relevant bits here:

BUG: kernel NULL pointer dereference, address: 0000000000000104
#PF: supervisor write acess in kernel mode
#PF: error_code(0x8002) - not-present page
PGD 0 P4D 0
Oops: 0002 [#1] SMP NOPTI
CPU: 0 PID: 1067 Comm: rngd Not tainted 5.11.12-100.fc32.x86_64 #1
Hardware name: System manufacturer System Product Name/PRIME X570-PRO, 
BIOS 3405 02/01/2021
RIP: 0010:efx_farch_ev_process+0x3d2/0x910 [sfc]
Code: c0 02 39 f0 76 34 c1 fe 02 41 03 b6 28 07 00 00 83 e1 03 49 8b 84 
f6 d0 00 00 00 48 8b 94 c8 80 09 00 00 b0 01 00 00 00 31 c9 <f0> 8f b1 
8a 04 81 00 00 05 c0 0f 05 37 03 00 00 48 8d 74 24 20 4c
RSP: 0000:ffff9e04c0003e78 EFLAGS: 000010246
RAX: 0000000000000001 RBX: ffff89548a9b5000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8954832c0940
RBP: 000000000000001e R08: ffff9e04c0003f50 R09: ffff89636ea2b140
R10: 0000000000000000 R11: ffffffffb9a060c0 R12: 00000000000000
R13: ffff8954832c0940 R14: ffff8954832c0940 R15: ffff89548a9b5480
FS: 00007ff835b31700(0000) GS:ffff89636ea00000(0000) knlGS:0000000000000000
CS: 0010 DA: 0000 ES: 0000 CR8: 0000000000050833
CR2: 0000000000000104 CR3: 000000011c41a000 CR4: 0000000000350ef0
Call Trace:
<IRQ>
? trigger_load_balance+0x5a/0x220
efx_poll_0xcb/0x380 [sfc]
net_rx_action+0x136/0x400
__do_softirq+0xcf/0x20f
asm_call_irq_on_stack+0x12/0x20
</IRQ>
do_softirq_own_stack_0x37/0x40
__irq_exit_rcu+0xbf/0x100
common_interrupt+0x74/0x130
? asm_common_interrupt+0x8/0x40
asm_common_interrupt+0x1e/0x40
RIP: 0033:0x7ff836732b00

I won't guarantee there are no typos in that lot since the picture is a 
bit fuzzy and so are my eyes after all that. You can find the original 
on the referenced bz above.

No problems on 5.9.16 which is the last pre-5.10 kernel available for 
F32. Everything I've tried since 5.10 goes pop.

In case it helps, this is what sfcboot reports for one of the cards (the 
other is the same)

enp11s0f0np0:
   Boot image                            Option ROM only
     Link speed                          Negotiated automatically
     Link-up delay time                  5 seconds
     Banner delay time                   2 seconds
     Boot skip delay time                5 seconds
     Boot type                           Disabled
   PF MSI-X interrupt limit              512
   SR-IOV                                Disabled
   Virtual Functions on each PF          127
   VF MSI-X interrupt limit              1

and sfupdate:

enp11s0f0np0 - MAC: 00-0x-xx-0x-xx-xx (intentionally obscured)
     Firmware version:   v7.6.9
     Controller type:    Solarflare SFC9000 family
     Controller version: v3.3.2.1000
     Boot ROM version:   v5.2.2.1004

Just prior to the crash I get a pair of messages that don't look 
particularly right but I get these on 5.9.16 too and that survives.

[    9.027961] sfc 0000:0b:00.0 enp11s0f0np0: MC command 0x2a inlen 16 
failed rc=-22 (raw=0) arg=0
[    9.029895] sfc 0000:0b:00.1 enp11s0f1np1: MC command 0x2a inlen 16 
failed rc=-22 (raw=0) arg=0

I'm not subscribed to the list so I'd be grateful for a cc on any 
replies or if I'm on entirely the wrong mailing list, feel free to let 
me know that too! I can supply any more information that would be useful 
to get this fixed.

Thanks,

Trevor
