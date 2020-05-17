Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86571D6E1F
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 01:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgEQXug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 19:50:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36466 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726656AbgEQXug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 19:50:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LLTzz3YzvyMyBPk+Kolqx1Uu8fddMZ1ye55MJSgzQRA=; b=RjUwc6azwrY5RW4MhmjFAjsr0D
        1J0L/dBUzDvf1yDZzamdb3Ob8HfeWJWqAFZR3PtWxFbpetrN2DHYTFXkLBYjd/WuwAVi8Qbs1ECTp
        xjAYyJOUm8rLY4XIUBYO+fXGvRBF1u+qS4iWeNM90jkIuon6PrhgFLzqHDtk6yfbZ2ho=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jaT34-002ZTa-Tb; Mon, 18 May 2020 01:50:26 +0200
Date:   Mon, 18 May 2020 01:50:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: Added fixed link support
Message-ID: <20200517235026.GD610998@lunn.ch>
References: <20200516192402.4201-1-rberg@berg-solutions.de>
 <20200517183710.GC606317@lunn.ch>
 <6E144634-8E2F-48F7-A0A4-6073164F2B70@berg-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6E144634-8E2F-48F7-A0A4-6073164F2B70@berg-solutions.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +			/* Configure MAC to fixed link parameters */
> >> +			data = lan743x_csr_read(adapter, MAC_CR);
> >> +			/* Disable auto negotiation */
> >> +			data &= ~(MAC_CR_ADD_ | MAC_CR_ASD_);
> > 
> > Why does the MAC care about autoneg? In general, all the MAC needs to
> > know is the speed and duplex.
> > 
> 

> My assumption is, that in fixed-link mode we should switch off the
> autonegotiation between MAC and remote peer (e.g. a switch). I
> didn’t test, if it would also wun with the hardware doing
> auto-negotiation, however it feels cleaner to me to prevent the
> hardware from initiating any auto-negotiation in fixed-link mode.

The MAC is not involved in autoneg. autoneg is between two PHYs. They
talk with each other, and then phylibs sees the results and tells the
MAC the results of the negotiation. That happens via this call
back. So i have no idea what this is doing in general in the MAC. And
in your setup, you don't have any PHYs at all. So there is no
auto-neg. You should read the datasheet and understand what this is
controlling. It might need to be disabled in general.

> Using get_phy_mode() in all cases is not possible on a PC as it
> returns SGMII on a standard PC.

Why do you think that?

> > I don't understand this comment.
> > 
> 
> See above the lengthy section. On a PC SGMII is returned when I call of_get_phy_mode(phynode, &phyifc);

There are two things possible here:

A PC has no OF support, so you are using:

https://elixir.bootlin.com/linux/latest/source/include/linux/of_net.h#L19

So you get the error code -ENODEV, and phyifc is not changed.

Or you are using:

https://elixir.bootlin.com/linux/latest/source/drivers/of/of_net.c#L25

There is unlikely to be a device node, so phyifc is set to
PHY_INTERFACE_MODE_NA and -ENODEV is returned.

So if of_get_phy_mode() returns an error, use RMII. Otherwise use what
value it set phyifc to.

      Andrew
