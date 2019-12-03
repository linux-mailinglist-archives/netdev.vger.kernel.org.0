Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D562110FB37
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 10:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfLCJ6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 04:58:39 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:46032 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfLCJ6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 04:58:38 -0500
Received: by mail-io1-f67.google.com with SMTP id i11so2938212ioi.12
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 01:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endian-se.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:cc;
        bh=W1tmd826wzxxw2dz8JHNgNRaQybNm4AACGIANRlyga0=;
        b=fN6VeGurros2MpqJOXm5H5Zwx7Kpp5X3QvQ8B3RXJocdG59tgYiAvxuyOy46C3d17a
         4QwpWBBiQDy90L/tXwGkzwhFDSnvGqgSRvepxZUkgad7A7gwXQai/XFSk5upT4W9Vk2y
         ND990M8EPQ89bt8W7kOMHArEnQP1QB5fQRNBq/dmTs67AvfiT9fKqvt8etR5IdREWn1J
         Eto3Qh8jr/8HTApEZgwC1ZVyvP5UI34vPKKvnTIMg3SiB5qQ4YWiRrn161/FkFgtQC41
         ZDltmcoHMBhBo5Rfs62vyrq0n/bYqgj/JJCEXKNfJrsakVTq7I8lLtVTZRFyD5PuweYc
         SDfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:cc;
        bh=W1tmd826wzxxw2dz8JHNgNRaQybNm4AACGIANRlyga0=;
        b=Nv7W638Nc3N5rKC/68BdSMGVeGfKjQdjusPVWczW6cml9vD4UDJCYPyP0xJHkiqKRP
         l5gPBg5CC4KTwpaNZTg5YNq7D/9/Dvn2dFLRcSptJP0d3z76oZwm3Mui6MAcTQo1XC3R
         j8EpjulKzCylONu/DU+2YsYNsEUKMMTEJ7HyjSl5w20K9co/Mx1uopXrFJztvkTQ9qJG
         9727uvktMzt59DFBAkYBzxgYnKTAwqQjnloOz8tmgtvk6VhgHD9AVc1Kh1julmcat9fa
         d1m64SLYVApwAYA0Rg1Bt9GIlcCRwMd074x9z9rjmQH0e3WAmcNPbIMZMF/pRzSK4bQ8
         eqfQ==
X-Gm-Message-State: APjAAAVZ1iCYad0b+3l+NlArBzEFoNrnit4uB/qJ5bkUH+go8N3/1zIQ
        IBfzloCE0P21SPDSYBlYtiFDnGD34nHmGkL4Qan+I68iD0s=
X-Received: by 2002:a5d:9046:: with SMTP id v6mt637573ioq.302.1575367116795;
 Tue, 03 Dec 2019 01:58:36 -0800 (PST)
MIME-Version: 1.0
From:   Fredrik Yhlen <fredrik.yhlen@endian.se>
Date:   Tue, 3 Dec 2019 10:56:28 +0100
Message-ID: <CAEZwD6zw+7tR8QBTCLgj7jxJQL802YYrH2Gsuywa6v0xH3D7pg@mail.gmail.com>
Subject: Problems with USB on Raspberry Pi CM3, Linux 5.3 and 5.4
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Stefan Wahren <wahrenst@gmx.net>, nsaenzjulienne@suse.de,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The problems are especially easy to trigger via LTE modem in QMI mode
using the qmi_wwan driver on mainline Linux 5.3. When pushing big bulk
transfers over the modem it quickly triggers kernel oops in the
network stack. I have based my defconfig of bcm2835_defconfig.

In this example I use a SIM 7600e modem and run Linux 5.4:
dwc2 3f980000.usb: dwc2_hc_chhltd_intr_dma: Channel 3 - ChHltd set,
but reason is unknown
Nov 28 14:07:29  kernel: dwc2 3f980000.usb: hcint 0x00000002, intsts 0x04600009
Nov 28 14:07:29  kernel: dwc2 3f980000.usb:
dwc2_update_urb_state_abn(): trimming xfer length
Nov 28 14:07:29  kernel: dwc2 3f980000.usb: dwc2_update_urb_state():
trimming xfer length
Nov 28 14:07:29  kernel: 8<--- cut here ---
Nov 28 14:07:29  kernel: Unable to handle kernel paging request at
virtual address 60de655e
Nov 28 14:07:29  kernel: pgd = b5a57262
Nov 28 14:07:29  kernel: [60de655e] *pgd=00000000
Nov 28 14:07:29  kernel: Internal error: Oops: 5 [#2] SMP ARM
Nov 28 14:07:29  kernel: Modules linked in: qmi_wwan option cdc_wdm
ftdi_sio usb_wwan usbserial snd_bcm2835(C) raspberrypi_hwmon vchiq(C)
bcm2835_rng rng_core
Nov 28 14:07:29  kernel: CPU: 2 PID: 599 Comm: wget Tainted: G      D
C        5.4.0+ #1
Nov 28 14:07:29  kernel: Hardware name: BCM2835
Nov 28 14:07:29  kernel: PC is at kfree_skb_list+0x1c/0x2c
Nov 28 14:07:29  kernel: LR is at skb_release_data+0x50/0xc0
Nov 28 14:07:29  kernel: pc : [<c06200cc>]    lr : [<c0620948>]    psr: 20000013
Nov 28 14:07:29  kernel: sp : ea55fcc0  ip : ea55fcd8  fp : ea55fcd4
Nov 28 14:07:29  kernel: r10: 00000000  r9 : ea55fe4c  r8 : 0000000c
Nov 28 14:07:29  kernel: r7 : ea619268  r6 : 00000000  r5 : ebe88000
r4 : ea619240
Nov 28 14:07:29  kernel: r3 : 00000000  r2 : 00000000  r1 : eaba9bb0
r0 : 60de655e
Nov 28 14:07:29  kernel: Flags: nzCv  IRQs on  FIQs on  Mode SVC_32
ISA ARM  Segment none
Nov 28 14:07:29  kernel: Control: 10c5383d  Table: 1f88806a  DAC: 00000051
Nov 28 14:07:29  kernel: Process wget (pid: 599, stack limit = 0x90bfafcc)
Nov 28 14:07:29  kernel: Stack: (0xea55fcc0 to 0xea560000)
Nov 28 14:07:29  kernel: fcc0: ea619240 ebe88000 ea55fcfc ea55fcd8
c0620948 c06200bc ebe88000 00000b00
Nov 28 14:07:29  kernel: fce0: ebe88000 00000580 eaba9efc ea55fe4c
ea55fd14 ea55fd00 c061ffd0 c0620904
Nov 28 14:07:29  kernel: fd00: ebe88000 00000b00 ea55fd2c ea55fd18
c061fff0 c061ffac ebe88000 00000b00
Nov 28 14:07:29  kernel: fd20: ea55fd44 ea55fd30 c0688220 c061ffe0
eaba9b00 00000b00 ea55fdf4 ea55fd48
Nov 28 14:07:29  kernel: fd40: c0688ec4 c06881b8 ea55fd64 ea55fd58
c0138790 c0136854 00000000 00000000
Nov 28 14:07:29  kernel: fd60: 00000000 00000000 00000001 00001500
00264ea7 00000001 20010093 00000004
Nov 28 14:07:29  kernel: fd80: c0d04e08 ea55fe04 00000051 7fffffff
00000004 00000051 c0d04e08 00000000
Nov 28 14:07:29  kernel: fda0: 00000000 beb83af4 00000004 00000000
00000000 c027d990 00000005 ea55fe04
Nov 28 14:07:29  kernel: fdc0: ea55fddc 1613dfbd c027d9cc eaba9b00
00000000 c0d04e08 ea55fe4c c06886d8
Nov 28 14:07:29  kernel: fde0: 00002000 00002000 ea55fe2c ea55fdf8
c06b67cc c06886e4 00000000 ea55fe00
Nov 28 14:07:29  kernel: fe00: 00000000 1613dfbd c06b6750 00002000
c0d04e08 ec7b5f80 ef566e40 00d73c38
Nov 28 14:07:29  kernel: fe20: ea55fe44 ea55fe30 c0612f08 c06b675c
ea55feb8 00002000 ea55fea4 ea55fe48
Nov 28 14:07:29  kernel: fe40: c0612fc4 c0612ef4 c05c916c 00000000
00000000 00000004 00000b00 00001500
Nov 28 14:07:29  kernel: fe60: ea55feb0 00000001 ffffffff 00000000
00000000 00000000 ea55fed0 1613dfbd
Nov 28 14:07:30  kernel: fe80: c0d04e08 c0d04e08 ea55ff50 ef566e40
00002000 00000000 ea55ff24 ea55fea8
Nov 28 14:07:30  kernel: fea0: c026a2cc c0612f34 00002000 ea55feb8
00d73c38 00002000 00000004 00000000
Nov 28 14:07:30  kernel: fec0: 00002000 ea55feb0 00000001 ffffffff
ef566e40 00000000 00000000 00000000
Nov 28 14:07:30  kernel: fee0: 00000000 00000000 00000000 00000000
00000000 00000000 ea55ff5c 1613dfbd
Nov 28 14:07:30  kernel: ff00: ef566e40 00000000 00002000 ef566e40
00d73c38 ea55ff50 ea55ff4c ea55ff28
Nov 28 14:07:30  kernel: ff20: c026a39c c026a21c ef566e40 00002000
ea55ff50 c0d04e08 ea55ff5c 00d73c38
Nov 28 14:07:30  kernel: ff40: ea55ff94 ea55ff50 c026a5c4 c026a30c
00000000 00000000 1ec321fc ef566e40
Nov 28 14:07:30  kernel: ff60: 00000000 1613dfbd beb83aec 00000074
00002000 00d73c38 00000003 c0101204
Nov 28 14:07:30  kernel: ff80: ea55e000 00000003 ea55ffa4 ea55ff98
c026a628 c026a558 00000000 ea55ffa8
Nov 28 14:07:30  kernel: ffa0: c0101000 c026a61c 00000074 00002000
00000004 00d73c38 00002000 00000000
Nov 28 14:07:30  kernel: ffc0: 00000074 00002000 00d73c38 00000003
0010e785 00000000 beb841d0 beb84208
Nov 28 14:07:30  kernel: ffe0: 00000003 beb83b88 b6c4c52f b6bd5746
20000030 00000004 00000000 00000000
Nov 28 14:07:30  kernel: Backtrace:
Nov 28 14:07:30  kernel: [<c06200b0>] (kfree_skb_list) from
[<c0620948>] (skb_release_data+0x50/0xc0)
Nov 28 14:07:30  kernel:  r5:ebe88000 r4:ea619240
Nov 28 14:07:30  kernel: [<c06208f8>] (skb_release_data) from
[<c061ffd0>] (skb_release_all+0x30/0x34)
Nov 28 14:07:30  kernel:  r9:ea55fe4c r8:eaba9efc r7:00000580
r6:ebe88000 r5:00000b00 r4:ebe88000
Nov 28 14:07:30  kernel: [<c061ffa0>] (skb_release_all) from
[<c061fff0>] (__kfree_skb+0x1c/0x28)
Nov 28 14:07:30  kernel:  r5:00000b00 r4:ebe88000
Nov 28 14:07:30  kernel: [<c061ffd4>] (__kfree_skb) from [<c0688220>]
(sk_eat_skb+0x74/0x88)
Nov 28 14:07:30  kernel:  r5:00000b00 r4:ebe88000
Nov 28 14:07:30  kernel: [<c06881ac>] (sk_eat_skb) from [<c0688ec4>]
(tcp_recvmsg+0x7ec/0x954)
Nov 28 14:07:30  kernel:  r5:00000b00 r4:eaba9b00
Nov 28 14:07:30  kernel: [<c06886d8>] (tcp_recvmsg) from [<c06b67cc>]
(inet_recvmsg+0x7c/0xa8)
Nov 28 14:07:30  kernel:  r10:00002000 r9:00002000 r8:c06886d8
r7:ea55fe4c r6:c0d04e08 r5:00000000
Nov 28 14:07:30  kernel:  r4:eaba9b00
Nov 28 14:07:30  kernel: [<c06b6750>] (inet_recvmsg) from [<c0612f08>]
(sock_recvmsg_nosec+0x20/0x24)
Nov 28 14:07:30  kernel:  r9:00d73c38 r8:ef566e40 r7:ec7b5f80
r6:c0d04e08 r5:00002000 r4:c06b6750
Nov 28 14:07:30  kernel: [<c0612ee8>] (sock_recvmsg_nosec) from
[<c0612fc4>] (sock_read_iter+0x9c/0xdc)
Nov 28 14:07:30  kernel:  r5:00002000 r4:ea55feb8
Nov 28 14:07:30  kernel: [<c0612f28>] (sock_read_iter) from
[<c026a2cc>] (__vfs_read+0xbc/0xf0)
Nov 28 14:07:30  kernel:  r8:00000000 r7:00002000 r6:ef566e40
r5:ea55ff50 r4:c0d04e08
Nov 28 14:07:30  kernel: [<c026a210>] (__vfs_read) from [<c026a39c>]
(vfs_read+0x9c/0xb8)
Nov 28 14:07:30  kernel:  r8:ea55ff50 r7:00d73c38 r6:ef566e40
r5:00002000 r4:00000000
Nov 28 14:07:30  kernel: [<c026a300>] (vfs_read) from [<c026a5c4>]
(ksys_read+0x78/0xc4)
Nov 28 14:07:30  kernel:  r9:00d73c38 r8:ea55ff5c r7:c0d04e08
r6:ea55ff50 r5:00002000 r4:ef566e40
Nov 28 14:07:30  kernel: [<c026a54c>] (ksys_read) from [<c026a628>]
(sys_read+0x18/0x1c)
Nov 28 14:07:30  kernel:  r10:00000003 r9:ea55e000 r8:c0101204
r7:00000003 r6:00d73c38 r5:00002000
Nov 28 14:07:30  kernel:  r4:00000074
Nov 28 14:07:30  kernel: [<c026a610>] (sys_read) from [<c0101000>]
(ret_fast_syscall+0x0/0x54)
Nov 28 14:07:30  kernel: Exception stack(0xea55ffa8 to 0xea55fff0)
Nov 28 14:07:30  kernel: ffa0:                   00000074 00002000
00000004 00d73c38 00002000 00000000
Nov 28 14:07:30  kernel: ffc0: 00000074 00002000 00d73c38 00000003
0010e785 00000000 beb841d0 beb84208
Nov 28 14:07:30  kernel: ffe0: 00000003 beb83b88 b6c4c52f b6bd5746
Nov 28 14:07:30  kernel: Code: e52de004 e8bd4000 e3500000 089da830 (e5904000)
Nov 28 14:07:30  kernel: ---[ end trace 813694f10fff952d ]---


Linux 5.3:
[  178.201655] dwc2 3f980000.usb: dwc2_hc_chhltd_intr_dma: Channel 5 -
ChHltd set, but reason is unknown
[  178.215388] dwc2 3f980000.usb: hcint 0x00000002, intsts 0x04200009
[  178.223894] dwc2 3f980000.usb: dwc2_update_urb_state_abn():
trimming xfer length
[  178.233735] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
[  178.245841] 8<--- cut here ---
[  178.251360] Unable to handle kernel paging request at virtual
address 97b1527b
[  178.261121] pgd = 2195337a
[  178.266424] [97b1527b] *pgd=00000000
[  178.272452] Internal error: Oops: 5 [#1] SMP ARM
[  178.279433] Modules linked in: can_raw can option usb_wwan qmi_wwan
usbserial cdc_wdm snd_bcm2835(C) r8188eu(C) lib80211 raspberrypi_hwmon
mcp251x can_dev vchiq(C) bcm2835_rng rng_core
[  178.303651] CPU: 0 PID: 2638 Comm: wget Tainted: G         C        5.3.0+ #1
[  178.313557] Hardware name: BCM2835
[  178.319755] PC is at kfree_skb_list+0x1c/0x2c
[  178.326974] LR is at skb_release_data+0xd4/0x144
[  178.334410] pc : [<c065cb08>]    lr : [<c065d4e4>]    psr: a0070013
[  178.343526] sp : e9b93cd8  ip : e9b93cf0  fp : e9b93cec
[  178.351609] r10: 00000000  r9 : e98a6ff4  r8 : e4abd568
[  178.359679] r7 : 00000000  r6 : 00000000  r5 : e9824b40  r4 : e4abd540
[  178.369071] r3 : 00000000  r2 : 00002180  r1 : 000019c0  r0 : 97b1527b
[  178.378452] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[  178.388453] Control: 10c5383d  Table: 24ae806a  DAC: 00000051
[  178.397040] Process wget (pid: 2638, stack limit = 0xf64efb7c)
[  178.405711] Stack: (0xe9b93cd8 to 0xe9b94000)
[  178.412933] 3cc0:
    e4abd540 e9824b40
[  178.426773] 3ce0: e9b93d14 e9b93cf0 c065d4e4 c065caf8 e9824b40
e9824b40 00000fc6 00000542
[  178.440680] 3d00: 00000000 e98a6ff4 e9b93d2c e9b93d18 c065c9ec
c065d41c e9824b40 e9824b40
[  178.454626] 3d20: e9b93d44 e9b93d30 c065ca0c c065c9c8 e98a6c00
e9824b40 e9b93df4 e9b93d48
[  178.468790] 3d40: c06cb7c0 c065c9fc 00000001 ef461c00 00000058
ef405180 00000000 00000000
[  178.483125] 3d60: 00000000 00000001 0000103a e9b93e44 c0d6c440
0002af5c e9b93dbc e9b93d88
[  178.497627] 3d80: c025c6cc c0238374 fffffffc 7fffffff c016a878
eff48b80 40080013 00000002
[  178.512377] 3da0: e9b93dc0 2ecfe000 00000001 0030f231 e9b93e04
e9b93dc0 c025cb98 c025c5c8
[  178.527149] 3dc0: 00000000 19ad9c1c e99fe240 c0d04c08 e9b93e44
c06caf44 e86d2640 e9af16c0
[  178.542045] 3de0: 00000000 00000000 e9b93e24 e9b93df8 c06f9690
c06caf50 00000000 e9b93e00
[  178.557224] 3e00: 00000000 19ad9c1c eaf5c000 c06f95c8 00002000
c0d04c08 e9b93e3c e9b93e28
[  178.572623] 3e20: c064f52c c06f95d4 e9b93eb0 00002000 e9b93e9c
e9b93e40 c064f5cc c064f510
[  178.588285] 3e40: e9b93e6c 00000000 00000000 00000004 00000fc6
0000103a e9b93ea8 00000001
[  178.604209] 3e60: e9b93ed0 00000000 00000000 00000000 e9b93ec8
19ad9c1c c0d04c08 e9af16c0
[  178.620279] 3e80: 00000000 c0d04c08 e9b93f58 00002000 e9b93f24
e9b93ea0 c027fbf4 c064f53c
[  178.636547] 3ea0: 00002000 c0d04c08 01b87818 00002000 00000004
00000000 00002000 e9b93ea8
[  178.653024] 3ec0: 00000001 e9b93ed0 e9af16c0 00000000 00000000
00000000 00000000 00000000
[  178.669793] 3ee0: 00000000 00000000 00000000 00000000 e9b93f14
19ad9c1c c017cf00 e9af16c0
[  178.686390] 3f00: 00002000 00000001 01b87818 e9b93f58 00000000
00002000 e9b93f54 e9b93f28
[  178.702925] 3f20: c027fcc8 c027fa9c c029f580 c029f4d8 e9af16c0
00002000 e9b93f58 c0d04c08
[  178.720034] 3f40: e9af16c0 01b87818 e9b93f94 e9b93f58 c027ffac
c027fc34 00000000 00000000
[  178.736549] 3f60: c0177f4c 19ad9c1c b6c8d518 00000074 00002000
01b87818 00000003 c0101204
[  178.753041] 3f80: e9b92000 00000003 e9b93fa4 e9b93f98 c0280028
c027ff4c 00000000 e9b93fa8
[  178.769535] 3fa0: c0101000 c028001c 00000074 00002000 00000004
01b87818 00002000 00000000
[  178.786022] 3fc0: 00000074 00002000 01b87818 00000003 00013fbf
00000000 bec10900 bec10938
[  178.802511] 3fe0: 00000003 bec102b8 b6c8d52f b6c16746 20070030
00000004 00000000 00000000
[  178.818997] Backtrace:
[  178.825569] [<c065caec>] (kfree_skb_list) from [<c065d4e4>]
(skb_release_data+0xd4/0x144)
[  178.841844]  r5:e9824b40 r4:e4abd540
[  178.849405] [<c065d410>] (skb_release_data) from [<c065c9ec>]
(skb_release_all+0x30/0x34)
[  178.865543]  r9:e98a6ff4 r8:00000000 r7:00000542 r6:00000fc6
r5:e9824b40 r4:e9824b40
[  178.877334] [<c065c9bc>] (skb_release_all) from [<c065ca0c>]
(__kfree_skb+0x1c/0x28)
[  178.889314]  r5:e9824b40 r4:e9824b40
[  178.896997] [<c065c9f0>] (__kfree_skb) from [<c06cb7c0>]
(tcp_recvmsg+0x87c/0xa0c)
[  178.908524]  r5:e9824b40 r4:e98a6c00
[  178.916015] [<c06caf44>] (tcp_recvmsg) from [<c06f9690>]
(inet_recvmsg+0xc8/0xfc)
[  178.927425]  r10:00000000 r9:00000000 r8:e9af16c0 r7:e86d2640
r6:c06caf44 r5:e9b93e44
[  178.939423]  r4:c0d04c08
[  178.945786] [<c06f95c8>] (inet_recvmsg) from [<c064f52c>]
(sock_recvmsg+0x28/0x2c)
[  178.957212]  r6:c0d04c08 r5:00002000 r4:c06f95c8
[  178.965607] [<c064f504>] (sock_recvmsg) from [<c064f5cc>]
(sock_read_iter+0x9c/0xdc)
[  178.977157]  r5:00002000 r4:e9b93eb0
[  178.984455] [<c064f530>] (sock_read_iter) from [<c027fbf4>]
(__vfs_read+0x164/0x198)
[  178.995976]  r8:00002000 r7:e9b93f58 r6:c0d04c08 r5:00000000 r4:e9af16c0
[  179.006419] [<c027fa90>] (__vfs_read) from [<c027fcc8>] (vfs_read+0xa0/0x110)
[  179.017274]  r10:00002000 r9:00000000 r8:e9b93f58 r7:01b87818
r6:00000001 r5:00002000
[  179.028807]  r4:e9af16c0
[  179.034940] [<c027fc28>] (vfs_read) from [<c027ffac>] (ksys_read+0x6c/0xd0)
[  179.045638]  r9:01b87818 r8:e9af16c0 r7:c0d04c08 r6:e9b93f58
r5:00002000 r4:e9af16c0
[  179.057046] [<c027ff40>] (ksys_read) from [<c0280028>] (sys_read+0x18/0x1c)
[  179.067628]  r10:00000003 r9:e9b92000 r8:c0101204 r7:00000003
r6:01b87818 r5:00002000
[  179.079075]  r4:00000074
[  179.085123] [<c0280010>] (sys_read) from [<c0101000>]
(ret_fast_syscall+0x0/0x54)
[  179.096199] Exception stack(0xe9b93fa8 to 0xe9b93ff0)
[  179.104841] 3fa0:                   00000074 00002000 00000004
01b87818 00002000 00000000
[  179.120293] 3fc0: 00000074 00002000 01b87818 00000003 00013fbf
00000000 bec10900 bec10938
[  179.136135] 3fe0: 00000003 bec102b8 b6c8d52f b6c16746
[  179.145377] Code: e52de004 e8bd4000 e3500000 089da830 (e5904000)
[  179.155709] ---[ end trace b3bd3328793c3068 ]---

There is always at least one USB channel that gets halted in the dwc2
controller driver(modem sits on the USB bus) just before the kernel
oops happens. There seems to be some weird race condition or
concurrency issue going on when a USB channel gets halted and the
driver attempts to handle it.

I can trigger it easily by just wget a big file - it usually happens
within 40 seconds or so. I did a quick ugly fix, just for
experimenting, and somehow this seems to fix it:
------------------------------------------------------------------------------------------------------------------
--- linux-5.3/drivers/usb/dwc2/hcd_intr.c 2019-10-11 22:12:45.051690563 +0200
+++ linux-5.3.new/drivers/usb/dwc2/hcd_intr.c 2019-12-02
15:50:31.895458866 +0100
@@ -1974,7 +1974,7 @@
  chan->hcint);
 error:
  /* Failthrough: use 3-strikes rule */
- qtd->error_count++;
+ qtd->error_count = 4;
  dwc2_update_urb_state_abn(hsotg, chan, chnum, qtd->urb,
   qtd, DWC2_HC_XFER_XACT_ERR);
  dwc2_hcd_save_data_toggle(hsotg, chan, chnum, qtd);
------------------------------------------------------------------------------------------------------------------

I can still occasionally see:
dwc2 3f980000.usb: dwc2_hc_chhltd_intr_dma: Channel 5
- ChHltd set, but reason is unknown

But now it doesn't crash when doing wget on big files or when doing
full updates over the modem.
Why does this work?

Thanks!

Best regards,
Fredrik Yhlen
