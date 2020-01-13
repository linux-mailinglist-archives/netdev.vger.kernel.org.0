Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44864139802
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 18:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgAMRsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 12:48:21 -0500
Received: from krieglstein.org ([188.68.35.71]:36732 "EHLO krieglstein.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgAMRsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 12:48:21 -0500
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2020 12:48:19 EST
Received: from dabox.localnet (gateway.hbm.com [213.157.30.2])
        by krieglstein.org (Postfix) with ESMTPSA id 85A124009B;
        Mon, 13 Jan 2020 18:37:52 +0100 (CET)
From:   Tim Sander <tim@krieglstein.org>
To:     Jayati Sahu <jayati.sahu@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>,
        netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        andriy.shevchenko@linux.intel.com
Subject: Commit bfdbfd28f76028b960458d107dc4ae9240c928b3 leads to crash on Intel SocFPGA Cyclone 5 DE0 NanoSoc
Date:   Mon, 13 Jan 2020 18:37:52 +0100
Message-ID: <1758567.4I393bidJ1@dabox>
Organization: Sander and Lightning
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

I just found out that the commit bfdbfd28f76028b960458d107dc4ae9240c928b3
which also went in the stable release series causes an oops
in the stmicro driver an a Terrasic DE0 NanoSoc board with Intel SocFPGA 
CycloneV chip. I am currently following Preempt-RT that's why i just noticed 
only yet when testing 5.4.10-rt5 but this also occurs without any Preempt-RT 
patchset. Reverting the patch fixes the oops.

It would be nice if this change could be reverted or otherwise fixed.

Best regards
Tim Sander

8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 00000234
pgd = 3bed3403
[00000234] *pgd=1e05d831, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] SMP ARM
Modules linked in: i2c_altera
CPU: 0 PID: 182 Comm: systemd-network Tainted: G        W         5.4.10 #1
Hardware name: Altera SOCFPGA
PC is at mdiobus_get_phy+0x18/0x34
LR is at stmmac_open+0x3a0/0x4a8
pc : [<8056a73c>]    lr : [<8057887c>]    psr: a0070013
sp : 9e13fa98  ip : 9e13faa8  fp : 9e13faa4
r10: 9f3dd000  r9 : 9e94d3c0  r8 : 9f3de000
r7 : 9f3dc500  r6 : 8093d10c  r5 : ffffffff  r4 : 9f3dc000
r3 : 9f1e7440  r2 : 00000000  r1 : 0000008d  r0 : 00000000
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 1eb9004a  DAC: 00000051
Process systemd-network (pid: 182, stack limit = 0x6c130e0c)
Stack: (0x9e13fa98 to 0x9e140000)
fa80:                                                       9e13fb04 9e13faa8
faa0: 8057887c 8056a730 0000000e 9e13fb14 8093d10c 9e13fdbc 00001002 9e94d3c0
fac0: 9e13fae4 9e13fad0 80147f54 80147da8 00000000 80c04e08 9e13fb04 9f3dc000
fae0: 9e13fdbc 8093d10c 9f3dc02c 00001002 9e94d3c0 9e13fd24 9e13fb3c 9e13fb08
fb00: 80699fa8 805784e8 9e13fb24 9e13fb18 8086b4dc 9f3dc000 9e13fdbc 80c04e08
fb20: 9f3dc000 00000001 00001003 9e13fdbc 9e13fb7c 9e13fb40 8069a3d8 80699ed0
fb40: 00000000 20030093 9f264300 80c053a4 9e13fb7c 80c04e08 801107b0 9f3dc000
fb60: 9e13fc54 00001002 00000000 9f3dc138 9e13fba4 9e13fb80 8069a460 8069a264
fb80: 9f3dc000 9e13fc54 00000000 9e13fdbc 00000000 9e94d3c0 9e13fc3c 9e13fba8
fba0: 806ae5b4 8069a444 00000000 80c04e08 9e13fbcc 00000008 9eb4ca10 8093d10c
fbc0: 80955290 9e13fc54 00000000 0000000a 9e13fc14 9e13fbe0 804a679c 804a5f80
fbe0: 9e13fdbc 9e9c9c14 00000000 9e13fc54 9e13fdbc 9e94d3c0 80c6a9c0 9e13fdbc
fc00: 80c9e60c 00000000 9e13fc3c 80c04e08 804a687c 9eb4ca00 9e13fdbc 9e94d3c0
fc20: 80c6a9c0 9eb4ca10 80c9e60c 00000000 9e13fd5c 9e13fc40 806aed1c 806ae320
fc40: 9e13fc54 9e13fd24 00000000 9e13fc58 80166278 00000000 00000000 00000000
fc60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 9eb4ca20
fc80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fca0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fcc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fce0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fd00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
fd20: 00000000 8012dc00 9e13fd4c 9e13fd38 806d93b8 80c04e08 9eb4ca00 9eb4ca00
fd40: 00000003 9e94d3c0 9f11e200 9e13fdbc 9e13fdb4 9e13fd60 806adfc4 806aec24
fd60: 80760e20 00000000 9e13fd8c 00000003 9f1f54c4 9f19c000 9e13fd94 9e13fd88
fd80: 8049134c 80c04e08 9e13fe0c 9e94d3c0 806add48 9eb4ca00 00000028 00000000
fda0: 00000000 000000ca 9e13fdfc 9e13fdb8 806dddec 806add54 00010000 00000000
fdc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 80c04e08
fde0: 9f19c000 00000028 9eb40800 9e94d3c0 9e13fe0c 9e13fe00 806ad2bc 806ddd28
fe00: 9e13fe3c 9e13fe10 806dd604 806ad2a8 7fffffff 80c04e08 00000008 9e13febc
fe20: 00000008 9e94d3c0 00000028 9eb40800 9e13fe9c 9e13fe40 806dd844 806dd488
fe40: 00000000 000bd178 00000098 000bc8a0 9f11f6c0 00000000 9f11f6c0 00000000
fe60: 000000b6 000000ca 000000ca 80c04e08 00000010 00000000 9e44cb40 00000000
fe80: 7ec128a4 801011c4 9e13e000 00000122 9e13ff8c 9e13fea0 80671f34 806dd69c
fea0: 9e13fec4 8018b8d4 9e13feec 00000000 00000000 000b5698 00000028 9e13feec
fec0: 00000010 00000005 00000000 00000000 9e13febc 00000000 00000000 00000000
fee0: 00000000 00000000 808662a4 00000010 00000000 00000000 00000000 9e13ff08
ff00: 802ab5e8 80c04e08 9e13ff2c 8019c218 9e13ff64 9e13ff20 8019c218 8062fde8
ff20: 5d92971d 25613170 00000000 00000001 7ec128d4 00000107 801011c4 7ec128d4
ff40: 00000008 00000000 00000051 80194160 9e13e000 0000001f 28626690 80c04e08
ff60: 801a4e20 7ec128d4 9e13ffa4 80c04e08 7ec128a4 00000010 76f21180 00000122
ff80: 9e13ffa4 9e13ff90 80671fb8 80671e5c 7ec128a4 00000010 00000000 9e13ffa8
ffa0: 80101000 80671f98 7ec128a4 00000010 00000003 000b5698 00000028 00000000
ffc0: 7ec128a4 00000010 76f21180 00000122 000000b6 00000000 000000b6 0008b7c0
ffe0: 00000122 7ec12870 76d2f425 76d312b6 00070030 00000003 00000000 00000000
Backtrace: 
[<8056a724>] (mdiobus_get_phy) from [<8057887c>] (stmmac_open+0x3a0/0x4a8)
[<805784dc>] (stmmac_open) from [<80699fa8>] (__dev_open+0xe4/0x168)
 r10:9e13fd24 r9:9e94d3c0 r8:00001002 r7:9f3dc02c r6:8093d10c r5:9e13fdbc
 r4:9f3dc000
[<80699ec4>] (__dev_open) from [<8069a3d8>] (__dev_change_flags+0x180/0x1e0)
 r7:9e13fdbc r6:00001003 r5:00000001 r4:9f3dc000
[<8069a258>] (__dev_change_flags) from [<8069a460>] (dev_change_flags+0x28/0x58)
 r8:9f3dc138 r7:00000000 r6:00001002 r5:9e13fc54 r4:9f3dc000
[<8069a438>] (dev_change_flags) from [<806ae5b4>] (do_setlink+0x2a0/0x904)
 r9:9e94d3c0 r8:00000000 r7:9e13fdbc r6:00000000 r5:9e13fc54 r4:9f3dc000
[<806ae314>] (do_setlink) from [<806aed1c>] (rtnl_setlink+0x104/0x174)
 r10:00000000 r9:80c9e60c r8:9eb4ca10 r7:80c6a9c0 r6:9e94d3c0 r5:9e13fdbc
 r4:9eb4ca00
[<806aec18>] (rtnl_setlink) from [<806adfc4>] (rtnetlink_rcv_msg+0x27c/0x304)
 r8:9e13fdbc r7:9f11e200 r6:9e94d3c0 r5:00000003 r4:9eb4ca00
[<806add48>] (rtnetlink_rcv_msg) from [<806dddec>] 
(netlink_rcv_skb+0xd0/0x130)
 r10:000000ca r9:00000000 r8:00000000 r7:00000028 r6:9eb4ca00 r5:806add48
 r4:9e94d3c0
[<806ddd1c>] (netlink_rcv_skb) from [<806ad2bc>] (rtnetlink_rcv+0x20/0x24)
 r7:9e94d3c0 r6:9eb40800 r5:00000028 r4:9f19c000
[<806ad29c>] (rtnetlink_rcv) from [<806dd604>] (netlink_unicast+0x188/0x214)
[<806dd47c>] (netlink_unicast) from [<806dd844>] (netlink_sendmsg+0x1b4/0x388)
 r8:9eb40800 r7:00000028 r6:9e94d3c0 r5:00000008 r4:9e13febc
[<806dd690>] (netlink_sendmsg) from [<80671f34>] (__sys_sendto+0xe4/0x13c)
 r10:00000122 r9:9e13e000 r8:801011c4 r7:7ec128a4 r6:00000000 r5:9e44cb40
 r4:00000000
[<80671e50>] (__sys_sendto) from [<80671fb8>] (sys_sendto+0x2c/0x34)
 r7:00000122 r6:76f21180 r5:00000010 r4:7ec128a4
[<80671f8c>] (sys_sendto) from [<80101000>] (ret_fast_syscall+0x0/0x28)
Exception stack(0x9e13ffa8 to 0x9e13fff0)
ffa0:                   7ec128a4 00000010 00000003 000b5698 00000028 00000000
ffc0: 7ec128a4 00000010 76f21180 00000122 000000b6 00000000 000000b6 0008b7c0
ffe0: 00000122 7ec12870 76d2f425 76d312b6
Code: e24cb004 e52de004 e8bd4000 e281108e (e7900101) 
         Starting systemd-resolved.service...
---[ end trace 4faeeaf13cd9139e ]---


