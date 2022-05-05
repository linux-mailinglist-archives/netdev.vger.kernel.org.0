Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC6251CC05
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 00:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356370AbiEEWY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 18:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbiEEWY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 18:24:26 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1751D275CF;
        Thu,  5 May 2022 15:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KUYjKfhp/PbhUg2lTtsLdW1SIyYpeG21/n0+5cJggHU=; b=jK/EJPlPCz+4obHyo5yjHAWMLq
        41VWJPwbNN0UUo5aLn2W4fgxk8hBkorhEhcYslcaJcE2Zrc69MpYYk5pfUTCGsw1qC3bEwxUW7R1A
        KUGTpUA8kBWJgK7z6pyIOc5VnR92U6KNCm5M8wKZenLeX2WEo4oDW5lTFXK0cmgbGfxs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmjph-001QiJ-H5; Fri, 06 May 2022 00:20:25 +0200
Date:   Fri, 6 May 2022 00:20:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net v1] net: phy: Fix race condition on link status change
Message-ID: <YnRNqd32fLbiNpkA@lunn.ch>
References: <20220505203229.322509-1-francesco.dolcini@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505203229.322509-1-francesco.dolcini@toradex.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 10:32:29PM +0200, Francesco Dolcini wrote:
> This fixes the following error caused by a race condition between
> phydev->adjust_link() and a MDIO transaction in the phy interrupt
> handler. The issue was reproduced with the ethernet FEC driver and a
> micrel KSZ9031 phy.
> 
> [  146.195696] fec 2188000.ethernet eth0: MDIO read timeout
> [  146.201779] ------------[ cut here ]------------
> [  146.206671] WARNING: CPU: 0 PID: 571 at drivers/net/phy/phy.c:942 phy_error+0x24/0x6c
> [  146.214744] Modules linked in: bnep imx_vdoa imx_sdma evbug
> [  146.220640] CPU: 0 PID: 571 Comm: irq/128-2188000 Not tainted 5.18.0-rc3-00080-gd569e86915b7 #9
> [  146.229563] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [  146.236257]  unwind_backtrace from show_stack+0x10/0x14
> [  146.241640]  show_stack from dump_stack_lvl+0x58/0x70
> [  146.246841]  dump_stack_lvl from __warn+0xb4/0x24c
> [  146.251772]  __warn from warn_slowpath_fmt+0x5c/0xd4
> [  146.256873]  warn_slowpath_fmt from phy_error+0x24/0x6c
> [  146.262249]  phy_error from kszphy_handle_interrupt+0x40/0x48
> [  146.268159]  kszphy_handle_interrupt from irq_thread_fn+0x1c/0x78
> [  146.274417]  irq_thread_fn from irq_thread+0xf0/0x1dc
> [  146.279605]  irq_thread from kthread+0xe4/0x104
> [  146.284267]  kthread from ret_from_fork+0x14/0x28
> [  146.289164] Exception stack(0xe6fa1fb0 to 0xe6fa1ff8)
> [  146.294448] 1fa0:                                     00000000 00000000 00000000 00000000
> [  146.302842] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [  146.311281] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [  146.318262] irq event stamp: 12325
> [  146.321780] hardirqs last  enabled at (12333): [<c01984c4>] __up_console_sem+0x50/0x60
> [  146.330013] hardirqs last disabled at (12342): [<c01984b0>] __up_console_sem+0x3c/0x60
> [  146.338259] softirqs last  enabled at (12324): [<c01017f0>] __do_softirq+0x2c0/0x624
> [  146.346311] softirqs last disabled at (12319): [<c01300ac>] __irq_exit_rcu+0x138/0x178
> [  146.354447] ---[ end trace 0000000000000000 ]---
> 
> With the FEC driver phydev->adjust_link() calls fec_enet_adjust_link()
> calls fec_stop()/fec_restart() and both these function reset and
> temporary disable the FEC disrupting any MII transaction that
> could be happening at the same time.
> 
> fec_enet_adjust_link() and phy_read() can be running at the same time
> when we have one additional interrupt before the phy_state_machine() is
> able to terminate.
> 
> Thread 1 (phylib WQ)       | Thread 2 (phy interrupt)
>                            |
>                            | phy_interrupt()            <-- PHY IRQ
> 	                   |  handle_interrupt()
> 	                   |   phy_read()
> 	                   |   phy_trigger_machine()
> 	                   |    --> schedule phylib WQ
>                            |
> 	                   |
> phy_state_machine()        |
>  phy_check_link_status()   |
>   phy_link_change()        |
>    phydev->adjust_link()   |
>     fec_enet_adjust_link() |
>      --> FEC reset         | phy_interrupt()            <-- PHY IRQ
> 	                   |  phy_read()
> 	 	           |

You have a mix of tabs and spaces here, which is why it is getting
messed up.

> 
> Fix this by acquiring the phydev lock in phy_interrupt().
> 
> Link: https://lore.kernel.org/all/20220422152612.GA510015@francesco-nb.int.toradex.com/
> cc: <stable@vger.kernel.org>
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>

The fixes tag is not so easy. I decided on:

Fixes: c974bdbc3e77 ("net: phy: Use threaded IRQ, to allow IRQ from sleeping devices")

This is where threaded interrupts were added. Before this it was not
possible to read MDIO registers inside the interrupt handler, since
that often involves blocking operations. 

     Andrew
