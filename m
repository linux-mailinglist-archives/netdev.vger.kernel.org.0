Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C302C1DC18F
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 23:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgETVra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 17:47:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42144 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgETVra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 17:47:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ajMWx+yytMgnzEmWmzTjT+rRlBFvqxpGMWsH1u6Yhxw=; b=KyFEWqql4G3ocyRVDQr9pPpMD6
        rMycpRombqTwpMHi5LRF7J2ZYZcPRbcwg+E7JQltEvSKPJ+4NVsjb9oB7OKAnYxfhBYBHnKl4P5SD
        rGuhG1phNB1B0jZRedhMteSeJ/yt7yJVUOCES7ATUgRsYRCxB/QgTKc3fVw+qtsCgZ0g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jbWYh-002qaf-K9; Wed, 20 May 2020 23:47:27 +0200
Date:   Wed, 20 May 2020 23:47:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel =?iso-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: mvneta and phy_speed_up()
Message-ID: <20200520214727.GB677363@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel

I have a WRT1900AC which uses a Marvel XP SoC. One of its mvneta
interfaces is connected to an Ethernet switch. I now get:

[   21.934996] mvneta f1070000.ethernet eth0: configuring for fixed/rgmii-id link mode
[   21.942783] 8<--- cut here ---
[   21.945876] Unable to handle kernel NULL pointer dereference at virtual address 0000024d
[   21.954048] pgd = 0d7442d2
[   21.956773] [0000024d] *pgd=00000000
[   21.960438] Internal error: Oops: 15 [#1] SMP ARM
[   21.965166] Modules linked in:
[   21.968243] CPU: 0 PID: 2440 Comm: ip Not tainted 5.7.0-rc5-01775-gd7d2b59093bf #11
[   21.975927] Hardware name: Marvell Armada 370/XP (Device Tree)
[   21.981797] PC is at phy_speed_up+0x1c/0xd4
[   21.985999] LR is at mvneta_start_dev+0x218/0x2bc
[   21.990725] pc : [<c04c2ac4>]    lr : [<c04e802c>]    psr: 60050013
[   21.997011] sp : cc103940  ip : 00000d53  fp : cdf726c0
[   22.002260] r10: cc103c80  r9 : 00000004  r8 : c0b04020
[   22.007503] r7 : c0b03fac  r6 : c0b03ee8  r5 : cf02b540  r4 : ff7f49e8
[   22.014057] r3 : 00000000  r2 : cfdd34c0  r1 : 80050093  r0 : 00000000
[   22.020615] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   22.027775] Control: 10c5387d  Table: 0c0e806a  DAC: 00000051
[   22.033549] Process ip (pid: 2440, stack limit = 0x5369f874)
[   22.039228] Stack: (0xcc103940 to 0xcc104000)
....
[   22.487185] [<c04c2ac4>] (phy_speed_up) from [<c04e802c>] (mvneta_start_dev+0x218/0x2bc)
[   22.495319] [<c04e802c>] (mvneta_start_dev) from [<c04e86e8>] (mvneta_open+0x17c/0x2c8)
[   22.503369] [<c04e86e8>] (mvneta_open) from [<c06179f0>] (__dev_open+0xd4/0x158)
[   22.510808] [<c06179f0>] (__dev_open) from [<c0617dcc>] (__dev_change_flags+0x174/0x1d4)
[   22.518928] [<c0617dcc>] (__dev_change_flags) from [<c0617e44>] (dev_change_flags+0x18/0x48)
[   22.527410] [<c0617e44>] (dev_change_flags) from [<c0624484>] (do_setlink+0x268/0x910)
[   22.535371] [<c0624484>] (do_setlink) from [<c062a48c>] (__rtnl_newlink+0x4f0/0x730)
[   22.543158] [<c062a48c>] (__rtnl_newlink) from [<c062a70c>] (rtnl_newlink+0x40/0x60)
[   22.550942] [<c062a70c>] (rtnl_newlink) from [<c06252d8>] (rtnetlink_rcv_msg+0x260/0x2e4)
[   22.559153] [<c06252d8>] (rtnetlink_rcv_msg) from [<c065697c>] (netlink_rcv_skb+0xc0/0x120)
[   22.567547] [<c065697c>] (netlink_rcv_skb) from [<c0656114>] (netlink_unicast+0x1a8/0x250)
[   22.575856] [<c0656114>] (netlink_unicast) from [<c0656380>] (netlink_sendmsg+0x1c4/0x3fc)
[   22.584168] [<c0656380>] (netlink_sendmsg) from [<c05f26f8>] (____sys_sendmsg+0x1b4/0x248)
[   22.592477] [<c05f26f8>] (____sys_sendmsg) from [<c05f4008>] (___sys_sendmsg+0x70/0xa4)
[   22.600522] [<c05f4008>] (___sys_sendmsg) from [<c05f442c>] (__sys_sendmsg+0x54/0x98)
[   22.608381] [<c05f442c>] (__sys_sendmsg) from [<c0100060>] (ret_fast_syscall+0x0/0x54)
[   22.616329] Exception stack(0xcc103fa8 to 0xcc103ff0)
[   22.621411] 3fa0:                   00000078 004f4cb8 00000003 bea9a6c8 00000000 00000000
[   22.629627] 3fc0: 00000078 004f4cb8 00000003 00000128 5e3af347 00000000 004f4cb8 004f4cb8
[   22.637831] 3fe0: 00000128 bea9a678 b6e7277f b6dedcd6
[   22.642913] Code: e34c3092 e5933000 e58d300c e3a03000 (e5d0324d) 
[   22.649092] ---[ end trace 5a0f1861fece84f4 ]---

I've not done a bisect, but i suspect this change:

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 51889770958d..e0e9e56830c0 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3561,6 +3561,10 @@ static void mvneta_start_dev(struct mvneta_port *pp)
                    MVNETA_CAUSE_LINK_CHANGE);
 
        phylink_start(pp->phylink);
+
+       /* We may have called phy_speed_down before */
+       phy_speed_up(pp->dev->phydev);
+
        netif_tx_start_all_queues(pp->dev);
 }

mvneta uses phylink, not phydev directly. You cannot assume
pp->dev->phydev is a valid pointer, e.g. when there is no PHY.

Please could you fix this.

Thanks
	Andrew
