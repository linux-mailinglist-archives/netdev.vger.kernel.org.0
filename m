Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C632851C660
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 19:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382412AbiEERpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 13:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382886AbiEERou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 13:44:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA583C714
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EJ38/dXLJDREYh1UnUfC+pcDnVkXPXp6sEGUVFZ/o0c=; b=xgnE/7cG24wHBd97SKEatQ3F/G
        OdcVc1gdUTqG8GT94mCuNZTKG29fmeoxYq5ISOjwPCxkTJcFlADZc31wdwvugWDWH56NbpNuBPLlZ
        yQLnBXjN/1HOKQwvc0M+i/ThKs2ZjEUbKFEleoQ5RwcrzUjjHpae7FJvJ3aIJy/25ckQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmfTI-001Ogz-B9; Thu, 05 May 2022 19:41:00 +0200
Date:   Thu, 5 May 2022 19:41:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>, netdev@vger.kernel.org,
        Andy Duan <fugang.duan@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <festevam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: FEC MDIO read timeout on linkup
Message-ID: <YnQMLLXsldQt5Pve@lunn.ch>
References: <20220422152612.GA510015@francesco-nb.int.toradex.com>
 <20220502170527.GA137942@francesco-nb.int.toradex.com>
 <YnAh9Q1lwz6Wu9R8@lunn.ch>
 <20220502183443.GB400423@francesco-nb.int.toradex.com>
 <20220503161356.GA35226@francesco-nb.int.toradex.com>
 <YnGqF4/040/Y9RjS@lunn.ch>
 <20220505082901.GA195398@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505082901.GA195398@francesco-nb.int.toradex.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 10:29:01AM +0200, Francesco Dolcini wrote:
> Hello Andrew and all, I believe I finally found the problem and I'm
> preparing a patch for it.
> 
> On Wed, May 04, 2022 at 12:17:59AM +0200, Andrew Lunn wrote:
> > > I'm wondering could this be related to
> > > fec_enet_adjust_link()->fec_restart() during a fec_enet_mdio_read()
> > > and one of the many register write in fec_restart() just creates the
> > > issue, maybe while resetting the FEC? Does this makes any sense?
> > 
> > phylib is 'single threaded', in that only one thing will be active at
> > once for a PHY. While fec_enet_adjust_link() is being called, there
> > will not be any read/writes occurring for that PHY.
> 
> I think this is not the whole story here. We can have a phy interrupt
> handler that runs in its own context and it could be doing a MDIO
> transaction, and this is exactly my case.
> 
> Thread 1 (phylib WQ)       | Thread 2 (phy interrupt)
>                            |
>                            | phy_interrupt()            <-- PHY IRQ
> 	                   |  handle_interrupt()
> 	                   |   phy_read()
> 	                   |   phy_trigger_machine()
> 	                   |    --> schedule WQ
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
> 
> To confirm this I have added a spinlock to detect this race condition
> with just a trylock and a WARN_ON(1) when the locking is failing. On
> "MDIO read timeout" acquiring the spinlock fails.
> 
> This is also in agreement with the fact that polling the PHY instead of
> having the interrupt is working just fine.

Yes, that makes sense.

But i would fix this differently. The interrupt handler runs in a
threaded interrupt. So it can use mutex. So it should actually take
the phy mutex.

Please try this:

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index beb2b66da132..7d3a64d04820 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -970,8 +970,13 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 {
        struct phy_device *phydev = phy_dat;
        struct phy_driver *drv = phydev->drv;
+       int ret;
 
-       return drv->handle_interrupt(phydev);
+       mutex_lock(&phydev->lock);
+       ret = drv->handle_interrupt(phydev);
+       mutex_unlock(&phydev->lock);
+
+       return ret;
 }
 
That will stop it running in parallel to the adjust_link callback, or
anything else in phylib.

	 Andrew
