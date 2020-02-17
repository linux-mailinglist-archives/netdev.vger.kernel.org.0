Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86A716187B
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 18:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgBQRHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 12:07:01 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39288 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728935AbgBQRHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 12:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=V2b0d1gUR930/id42O1ijC2yJQ/z2WLsY4dFHF7zz9k=; b=TT35hLrOxBVLzCKJph9tBQ4I9
        9qjfMI6ImhwTUvtKySaL+IoXUyRExCX181Kyao7+OvlCpIn2KUte7mEJImazIdbuL+X8RVggxkA+1
        SOBF21/nbzYN1UA93A3m9qzdLRIFxHB1Mbupvuo4laKp4GBQOe6wrXt4HkagkEGw/bVaY965HSLme
        +CyU8K5lRCjuHpoKdkcbfTJgLhHqhU7pedP0CP4XkvZiFTUNCfz73R0FxYffyaLKHtP5ZqBQvU1XI
        gdg2bNamdlh/MIRODoV4PQoWU0SQUEDDd3cZodhzPyxQP2cK8ASvh3lMf0Elalxf8WaeeVT3wDuML
        SHaRTJEVw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:49118)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j3jrF-00021x-7A; Mon, 17 Feb 2020 17:06:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j3jrE-0006T8-Ig; Mon, 17 Feb 2020 17:06:56 +0000
Date:   Mon, 17 Feb 2020 17:06:56 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Antoine =?iso-8859-1?Q?T=E9nart?= <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net] net: macb: Properly handle phylink on at91rm9200
Message-ID: <20200217170656.GY25745@shell.armlinux.org.uk>
References: <20200217104348.43164-1-alexandre.belloni@bootlin.com>
 <20200217165644.GX25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217165644.GX25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 04:56:44PM +0000, Russell King - ARM Linux admin wrote:
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
> Next, there's some duplication of code introduced here - it seems
> that the tail end of macb_mac_link_down() and at91ether_mac_link_down()
> are identical, as are the tail end of macb_mac_link_up() and
> at91ether_mac_link_up().
> 
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

I'm going to post these changes shortly, but not for davem to merge
yet - it would be a good idea if people can test the changes first.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
