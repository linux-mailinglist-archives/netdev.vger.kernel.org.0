Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85CC51618FA
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 18:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgBQRms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 12:42:48 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:34651 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgBQRms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 12:42:48 -0500
Received: from localhost (lfbn-lyo-1-1670-129.w90-65.abo.wanadoo.fr [90.65.102.129])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 83AE024000D;
        Mon, 17 Feb 2020 17:42:44 +0000 (UTC)
Date:   Mon, 17 Feb 2020 18:42:44 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net] net: macb: Properly handle phylink on at91rm9200
Message-ID: <20200217174244.GD3316@piout.net>
References: <20200217104348.43164-1-alexandre.belloni@bootlin.com>
 <20200217165644.GX25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217165644.GX25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/02/2020 16:56:44+0000, Russell King - ARM Linux admin wrote:
> On Mon, Feb 17, 2020 at 11:43:48AM +0100, Alexandre Belloni wrote:
> > at91ether_init was handling the phy mode and speed but since the switch to
> > phylink, the NCFGR register got overwritten by macb_mac_config().
> 
> I don't think this actually explains anything - or at least I can't
> make sense of it with respect to your patch.
> 
> You claim that the NCFGR register gets overwritten in macb_mac_config(),
> but I see that the NCFGR register is read-modify-write in there,
> whereas your new implementation below doesn't bother reading the
> present value.
> 
> I think the issue you're referring to is the clearing of the PAE bit,
> which is also the RM9200_RMII for at91rm9200?
> 

This is the issue, I'll rework the commit message.

> Next, there's some duplication of code introduced here - it seems
> that the tail end of macb_mac_link_down() and at91ether_mac_link_down()
> are identical, as are the tail end of macb_mac_link_up() and
> at91ether_mac_link_up().
> 

I was split between having a new phylink_mac_ops instance or
differentiating in the various callbacks. If your preference is the
latter, I'm fine with that.

> > Add new phylink callbacks to handle emac and at91rm9200 properly.
> > 
> > Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > ---
> 
> I posted a heads-up message last week about updates to phylink that
> I'll be submitting soon (most of the prerequisits have now been sent
> for review) which touch every phylink_mac_ops-using piece of code in
> the tree.  Unfortunately, this patch introduces a new instance that
> likely isn't going to get my attention, so it's going to create a
> subtle merge conflict between net-next and net trees unless we work
> out some way to deal with it.
> 
> I'm just mentioning that so that some thought can be applied now
> rather than when it actually happens - especially as I've no way to
> test the changes that will be necessary for this driver.
> 

Does that help if I change the callbacks instead of adding a new
phylink_mac_ops instance? I can also wait for your work and rebase on
top of that but that would mean that the fix will not get backported.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
