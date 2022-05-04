Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD53E519CDB
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 12:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348043AbiEDK1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 06:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbiEDK1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 06:27:49 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11221C131
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 03:24:13 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id j6so1947447ejc.13
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 03:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=2wLzEdoZu1jG30/HxYWy2omi7gho+81iPQcmloF+dTM=;
        b=bmZ6is94AgxCzAJiBFuQdXx88ZuDXLLGCJwPxXDaHA1S2Kf74M3XQqFoIGUhKn/8zl
         K7kKMj+52ajOE0ATv9LzHvdvJBMmsdXc8LCYaX9gM0kgdN3ZgUUuveCsXsBY5nXoGpI3
         dCPFnd46FbI4FCwuF3vBsVS7++IM0EF2pTw69heYpxxzFm9mJQhJzg9K7hd4f3K0kLi8
         l+TxIPr0bU00QRWuR4heABriOOIUuKQBqoyJ39Y8v33UtmBpIQnRKMYDMGTFqw9zeg8h
         kW6v7jvQPESuynK5aaqm45Fynm4ndRo/xpqWPKvuL6YWKkze5p0asnF1cI8/Qj2EWDAL
         lcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=2wLzEdoZu1jG30/HxYWy2omi7gho+81iPQcmloF+dTM=;
        b=UZJ4QTeF0GYwhEoFVA4KOz48Ek+kj+ZfynRmp4l4gB0dd2TL4A6s32m0/KCkNpPir4
         rD09OX9sGfsJ/e2DZOOEkJ0bhH5qgrKrE5RXH6zykD+j92y4yAVI1l5upkyTkHv4UqYo
         XAQ67Da/AEpM6ZaKoiz3OTJLzC96km19fEkcWlpUCAwXxZU7RiNPp5Etrxz4YkIf2Af+
         CaL+VuKQYIqppS57CjgXT+LxTnE2GTu0SBQy4/96rZFmwaXLHN5oUoU77Y8grEDx4A+Z
         mqBy1qbgiMW3GAzteJI4IMpJjIbvwmK3OQUp4fzDkWb89H9WMQ8y6U6rqcBNiL3kRM5c
         wtzQ==
X-Gm-Message-State: AOAM531VkLvZkUS6fmMU0I4OtyqjnMO7twxDMip07Coz2yVPNh8YkGe5
        wYc3o1AdQ4ztqOl5oL5+fm+0mN6Sf1xLQp4x6/0=
X-Google-Smtp-Source: ABdhPJw1hh31UCObHFfFfyFNN5F0NnahOolBxV9HXq1ReqvXKz0QRzdDXUkuxxLCFtlybIr8cYMvDvcymETTK5Fxrxk=
X-Received: by 2002:a17:906:1845:b0:6f4:346f:f767 with SMTP id
 w5-20020a170906184500b006f4346ff767mr14510674eje.214.1651659852194; Wed, 04
 May 2022 03:24:12 -0700 (PDT)
MIME-Version: 1.0
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 4 May 2022 07:24:03 -0300
Message-ID: <CAOMZO5BwYSgMZYHJcxV9bLcSQ2jjdFL47qr8o8FUj75z8SdhrQ@mail.gmail.com>
Subject: imx6sx: Regression on FEC with KSZ8061
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On an imx6sx-based board, the Ethernet is functional on 5.10.

The board has a KSZ8061 Ethernet PHY.

After moving to kernel 5.15 or 5.17, the Ethernet is no longer functional:

# udhcpc -i eth0
udhcpc: started, v1.35.0
8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 00000008
pgd = f73cef4e
[00000008] *pgd=00000000
Internal error: Oops: 5 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 196 Comm: ifconfig Not tainted 5.15.37-dirty #94
Hardware name: Freescale i.MX6 SoloX (Device Tree)
PC is at kszphy_config_reset+0x10/0x114
LR is at kszphy_resume+0x24/0x64
pc : [<c08ed06c>]    lr : [<c08eddc8>]    psr: 60000013
sp : c241dc30  ip : 00000000  fp : 00000000
r10: c2728000  r9 : c2134320  r8 : 00000007
r7 : 00000000  r6 : 00000000  r5 : c263c800  r4 : c263c800
r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : c263c800
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 82a4c04a  DAC: 00000051
Register r0 information: slab kmalloc-2k start c263c800 pointer offset
0 size 2048
Register r1 information: NULL pointer
Register r2 information: NULL pointer
Register r3 information: NULL pointer
Register r4 information: slab kmalloc-2k start c263c800 pointer offset
0 size 2048
Register r5 information: slab kmalloc-2k start c263c800 pointer offset
0 size 2048
Register r6 information: NULL pointer
Register r7 information: NULL pointer
Register r8 information: non-paged memory
Register r9 information: slab kmalloc-4k start c2134000 pointer offset
800 size 4096
Register r10 information: slab kmalloc-4k start c2728000 pointer
offset 0 size 4096
Register r11 information: NULL pointer
Register r12 information: NULL pointer
Process ifconfig (pid: 196, stack limit = 0x4d59d998)
Stack: (0xc241dc30 to 0xc241e000)
dc20:                                     00000000 c263c800 c263c800 c263c800
dc40: c263c800 c2134000 00000000 c08eddc8 c08edda4 c263c800 c2134000 c08e7008
dc60: c263c800 c263ccb0 c2134000 c08e7080 c263c800 00000000 c2134000 c08e78a8
dc80: c263c800 c2134000 c08faafc c08faafc 00000003 c2720818 c2134784 c08e7be4
dca0: c263c800 c2134000 00000000 c08eed74 c2134000 c2720000 f0b73fe0 00000200
dcc0: 00000003 c08f5688 00000007 c060b5d4 c241c000 c2736e00 c16097c8 c018ff64
dce0: c2357cb0 00000000 c0800064 60000013 c2736e00 00000001 00000001 c1609388
dd00: c0800064 c2357cb0 ef7f0e3c c07fb604 00000200 00000003 c2357cb0 ef7f0e3c
dd20: c07fb604 c0ea9480 c241dd3c c060b5d4 c263c800 c07ffbd0 00001000 c2357cb0
dd40: 00000000 c1609388 c2134000 c2720000 f0b73fe0 c1609388 c2134000 c2720000
dd60: f0b73fe0 c08f830c fffffff1 00000001 c241dda4 c2134000 00000000 c0fc7d78
dd80: c2134024 00001002 00000000 c26c6c00 c17f5811 c0b69110 00000001 c0b693f8
dda0: ffffe000 c2134000 00000000 c1609388 00000000 c2134000 00000001 00001043
ddc0: 00000000 c0b694dc 00000000 c241de60 00000000 c0e9cc84 00000000 c1609388
dde0: c2134000 c241de60 00000000 00001002 00008914 c0b69560 00000000 c241de60
de00: c26c6c0c 00000000 00008914 c0c28e18 00000000 c0e9cc84 00000000 c2134000
de20: ffffe000 00001043 00007f00 fffffffd b6f5717c c1609388 00000020 00008914
de40: bed76c90 bed76c90 bed76c90 c23b9500 00000003 c48ea400 00000000 c0c2b490
de60: 30687465 00000000 00000000 00000000 00001043 00007f00 fffffffd b6f5717c
de80: 00000000 00008913 c1e75880 00000000 00000001 bed76c90 c241dee4 00000051
dea0: c23b9500 bed76c90 00000020 00000000 00000000 c1609388 00008913 00008914
dec0: c48ea380 bed76c90 bed76c90 c0b397b4 c241dedf c16e0dd4 c02f6ec8 01000113
dee0: 00000001 30687465 00000000 00000000 00000000 00001002 00007f00 fffffffd
df00: b6f5717c c1609388 00000000 00008914 c0100080 c23b9500 bed76c90 c02e81e8
df20: c27d4840 c241dfb0 00000017 005b403e c27d4840 c241dfb0 00000017 005b403e
df40: c27d4840 c0ea9f4c 00000000 c02f6ed4 00000000 00000000 c02f6e24 00000100
df60: c1028600 00000017 c160fa88 c0ea9d88 c241dfb0 005b403e 00000003 c1609388
df80: c01001dc 005a6daa bed76c90 00008914 00000036 c01002a4 c241c000 00000036
dfa0: 00000000 c0100080 005a6daa bed76c90 00000003 00008914 bed76c90 00000000
dfc0: 005a6daa bed76c90 00008914 00000036 bed76e48 00000003 005c6a04 00000000
dfe0: 005c6a34 bed76c08 004fdc64 b6ef1cfc 60000010 00000003 00000000 00000000
[<c08ed06c>] (kszphy_config_reset) from [<c08eddc8>] (kszphy_resume+0x24/0x64)
[<c08eddc8>] (kszphy_resume) from [<c08e7008>] (__phy_resume+0x38/0x90)
[<c08e7008>] (__phy_resume) from [<c08e7080>] (phy_resume+0x20/0x34)
[<c08e7080>] (phy_resume) from [<c08e78a8>] (phy_attach_direct+0x16c/0x2dc)
[<c08e78a8>] (phy_attach_direct) from [<c08e7be4>]
(phy_connect_direct+0x1c/0x58)
[<c08e7be4>] (phy_connect_direct) from [<c08eed74>] (of_phy_connect+0x48/0x70)
[<c08eed74>] (of_phy_connect) from [<c08f5688>] (fec_enet_mii_probe+0x3c/0x1bc)
[<c08f5688>] (fec_enet_mii_probe) from [<c08f830c>] (fec_enet_open+0x280/0x36c)
[<c08f830c>] (fec_enet_open) from [<c0b69110>] (__dev_open+0xf4/0x178)
[<c0b69110>] (__dev_open) from [<c0b694dc>] (__dev_change_flags+0x164/0x1d4)
[<c0b694dc>] (__dev_change_flags) from [<c0b69560>] (dev_change_flags+0x14/0x44)
[<c0b69560>] (dev_change_flags) from [<c0c28e18>] (devinet_ioctl+0x6c4/0x870)
[<c0c28e18>] (devinet_ioctl) from [<c0c2b490>] (inet_ioctl+0x1c4/0x2c0)
[<c0c2b490>] (inet_ioctl) from [<c0b397b4>] (sock_ioctl+0x468/0x50c)
[<c0b397b4>] (sock_ioctl) from [<c02e81e8>] (sys_ioctl+0xfc/0xebc)
[<c02e81e8>] (sys_ioctl) from [<c0100080>] (ret_fast_syscall+0x0/0x1c)
Exception stack(0xc241dfa8 to 0xc241dff0)
dfa0:                   005a6daa bed76c90 00000003 00008914 bed76c90 00000000
dfc0: 005a6daa bed76c90 00008914 00000036 bed76e48 00000003 005c6a04 00000000
dfe0: 005c6a34 bed76c08 004fdc64 b6ef1cfc
Code: e92d40f0 e1a04000 e5906448 e24dd00c (e5d63008)
---[ end trace 6d08cdbf6720c281 ]---
Segmentation fault

I haven't started debugging this issue but just wanted to report it in
case someone has any ideas first.

Thanks,

Fabio Estevam
