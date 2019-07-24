Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124C573007
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfGXNhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:37:34 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46374 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfGXNhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 09:37:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JoktU8a+hW6UntB+a/HvO+7gSuAIPSu8k5PUaDzB24E=; b=D58hRZEM1n7zdGZaVWkpLQmb6
        rWk7SzvfoVxUdlSbHnkif67S1jnvlxtkRkdQUubJwmV9q3aJC6LHkAr0sKAK8NmpMvCxgaYOqVaWY
        Zv56ZrcdVKaGXMt/NeYFgMHBHzBZ0Q8QXnTumVlMhocqGrxmDUaZpVp+QFMwx1MBleTXF/2JfCYss
        7ky62lX98JiqoxeFYv4kmu7UAd2HonJYvlloIUAq9yQPaSpjE2M1ItjShLUpJBdqmTV2ITnjDPL0U
        qcvgLjn8H0Zi6Wrr76IdmxPFPp8dxNDTmR/aUcjOjKK1nIi4c0+A8Kx6mk7Ji0bN7FzhumJW3gc5k
        ZD/yElluA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:44524)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hqHSO-0002UU-Jo; Wed, 24 Jul 2019 14:37:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hqHSL-0004rT-PT; Wed, 24 Jul 2019 14:37:22 +0100
Date:   Wed, 24 Jul 2019 14:37:21 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Arseny Solokha <asolokha@kb.kras.ru>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: phylink: don't start and stop SGMII PHYs in SFP
 modules twice
Message-ID: <20190724133721.GH1330@shell.armlinux.org.uk>
References: <20190724090139.GG1330@shell.armlinux.org.uk>
 <20190724133139.8356-1-asolokha@kb.kras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724133139.8356-1-asolokha@kb.kras.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 08:31:39PM +0700, Arseny Solokha wrote:
> SFP modules connected using the SGMII interface have their own PHYs which
> are handled by the struct phylink's phydev field. On the other hand, for
> the modules connected using 1000Base-X interface that field is not set.
> 
> Since commit ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network
> devices and sfp cages") phylink_start() ends up setting the phydev field
> using the sfp-bus infrastructure, which eventually calls phy_start() on it,
> and then calling phy_start() again on the same phydev from phylink_start()
> itself. Similar call sequence holds for phylink_stop(), only in the reverse
> order. This results in WARNs during network interface bringup and shutdown
> when a copper SFP module is connected, as phy_start() and phy_stop() are
> called twice in a row for the same phy_device:
> 
>   % ip link set up dev eth0
>   ------------[ cut here ]------------
>   called from state UP
>   WARNING: CPU: 1 PID: 155 at drivers/net/phy/phy.c:895 phy_start+0x74/0xc0
>   Modules linked in:
>   CPU: 1 PID: 155 Comm: backend Not tainted 5.2.0+ #1
>   NIP:  c0227bf0 LR: c0227bf0 CTR: c004d224
>   REGS: df547720 TRAP: 0700   Not tainted  (5.2.0+)
>   MSR:  00029000 <CE,EE,ME>  CR: 24002822  XER: 00000000
> 
>   GPR00: c0227bf0 df5477d8 df5d7080 00000014 df9d2370 df9d5ac4 1f4eb000 00000001
>   GPR08: c061fe58 00000000 00000000 df5477d8 0000003c 100c8768 00000000 00000000
>   GPR16: df486a00 c046f1c8 c046eea0 00000000 c046e904 c0239604 db68449c 00000000
>   GPR24: e9083204 00000000 00000001 db684460 e9083404 00000000 db6dce00 db6dcc00
>   NIP [c0227bf0] phy_start+0x74/0xc0
>   LR [c0227bf0] phy_start+0x74/0xc0
>   Call Trace:
>   [df5477d8] [c0227bf0] phy_start+0x74/0xc0 (unreliable)
>   [df5477e8] [c023cad0] startup_gfar+0x398/0x3f4
>   [df547828] [c023cf08] gfar_enet_open+0x364/0x374
>   [df547898] [c029d870] __dev_open+0xe4/0x140
>   [df5478c8] [c029db70] __dev_change_flags+0xf0/0x188
>   [df5478f8] [c029dc28] dev_change_flags+0x20/0x54
>   [df547918] [c02ae304] do_setlink+0x310/0x818
>   [df547a08] [c02b1eb8] __rtnl_newlink+0x384/0x6b0
>   [df547c28] [c02b222c] rtnl_newlink+0x48/0x68
>   [df547c48] [c02ad7c8] rtnetlink_rcv_msg+0x240/0x27c
>   [df547c98] [c02cc068] netlink_rcv_skb+0x8c/0xf0
>   [df547cd8] [c02cba3c] netlink_unicast+0x114/0x19c
>   [df547d08] [c02cbd74] netlink_sendmsg+0x2b0/0x2c0
>   [df547d58] [c027b668] sock_sendmsg_nosec+0x20/0x40
>   [df547d68] [c027d080] ___sys_sendmsg+0x17c/0x1dc
>   [df547e98] [c027df7c] __sys_sendmsg+0x68/0x84
>   [df547ef8] [c027e430] sys_socketcall+0x1a0/0x204
>   [df547f38] [c000d1d8] ret_from_syscall+0x0/0x38
>   --- interrupt: c01 at 0xfd4e030
>       LR = 0xfd4e010
>   Instruction dump:
>   813f0188 38800000 2b890005 419d0014 3d40c046 5529103a 394aa208 7c8a482e
>   3c60c046 3863a1b8 4cc63182 4be009a1 <0fe00000> 48000030 3c60c046 3863a1d0
>   ---[ end trace d4c095aeaf6ea998 ]---
> 
> and
> 
>   % ip link set down dev eth0
>   ------------[ cut here ]------------
>   called from state HALTED
>   WARNING: CPU: 1 PID: 184 at drivers/net/phy/phy.c:858 phy_stop+0x3c/0x88
> 
>   <...>
> 
>   Call Trace:
>   [df581788] [c0228450] phy_stop+0x3c/0x88 (unreliable)
>   [df581798] [c022d548] sfp_sm_phy_detach+0x1c/0x44
>   [df5817a8] [c022e8cc] sfp_sm_event+0x4b0/0x87c
>   [df581848] [c022f04c] sfp_upstream_stop+0x34/0x44
>   [df581858] [c0225608] phylink_stop+0x7c/0xe4
>   [df581868] [c023c57c] stop_gfar+0x7c/0x94
>   [df581888] [c023c5b8] gfar_close+0x24/0x94
>   [df5818a8] [c0298688] __dev_close_many+0xdc/0xf8
>   [df5818c8] [c029db58] __dev_change_flags+0xd8/0x188
>   [df5818f8] [c029dc28] dev_change_flags+0x20/0x54
>   [df581918] [c02ae304] do_setlink+0x310/0x818
>   [df581a08] [c02b1eb8] __rtnl_newlink+0x384/0x6b0
>   [df581c28] [c02b222c] rtnl_newlink+0x48/0x68
>   [df581c48] [c02ad7c8] rtnetlink_rcv_msg+0x240/0x27c
>   [df581c98] [c02cc068] netlink_rcv_skb+0x8c/0xf0
>   [df581cd8] [c02cba3c] netlink_unicast+0x114/0x19c
>   [df581d08] [c02cbd74] netlink_sendmsg+0x2b0/0x2c0
>   [df581d58] [c027b668] sock_sendmsg_nosec+0x20/0x40
>   [df581d68] [c027d080] ___sys_sendmsg+0x17c/0x1dc
>   [df581e98] [c027df7c] __sys_sendmsg+0x68/0x84
>   [df581ef8] [c027e430] sys_socketcall+0x1a0/0x204
>   [df581f38] [c000d1d8] ret_from_syscall+0x0/0x38
> 
>   <...>
> 
>   ---[ end trace d4c095aeaf6ea999 ]---
> 
> SFP modules with the 1000Base-X interface are not affected.
> 
> Place explicit calls to phy_start() and phy_stop() before enabling or after
> disabling an attached SFP module, where phydev is not yet set (or is
> already unset), so they will be made only from the inside of sfp-bus, if
> needed.
> 
> Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

Dave, please merge this as a fix - it looks like it should be applied to
any kernel which also has:

217962615662 ("net: phy: warn if phy_start is called from invalid state")

i.o.w. v5.1 or later.

Thanks.

> ---
> Changes in v2:
>  - Moved phy_start() before sfp_upstream_start(), and phy_stop() after
>  sfp_upstream_stop(), and reworded the commit message accordingly.
> 
> This is a general fix and may be taken out from the driver conversion series
> and applied separately.
> ---
>  drivers/net/phy/phylink.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 5d0af041b8f9..b45862465c4d 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -990,10 +990,10 @@ void phylink_start(struct phylink *pl)
>  	}
>  	if (pl->link_an_mode == MLO_AN_FIXED && pl->get_fixed_state)
>  		mod_timer(&pl->link_poll, jiffies + HZ);
> -	if (pl->sfp_bus)
> -		sfp_upstream_start(pl->sfp_bus);
>  	if (pl->phydev)
>  		phy_start(pl->phydev);
> +	if (pl->sfp_bus)
> +		sfp_upstream_start(pl->sfp_bus);
>  }
>  EXPORT_SYMBOL_GPL(phylink_start);
>  
> @@ -1010,10 +1010,10 @@ void phylink_stop(struct phylink *pl)
>  {
>  	ASSERT_RTNL();
>  
> -	if (pl->phydev)
> -		phy_stop(pl->phydev);
>  	if (pl->sfp_bus)
>  		sfp_upstream_stop(pl->sfp_bus);
> +	if (pl->phydev)
> +		phy_stop(pl->phydev);
>  	del_timer_sync(&pl->link_poll);
>  	if (pl->link_irq) {
>  		free_irq(pl->link_irq, pl);
> -- 
> 2.22.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
