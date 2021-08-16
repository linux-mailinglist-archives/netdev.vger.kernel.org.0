Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B38D3ED9D6
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhHPP1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 11:27:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52114 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229550AbhHPP1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 11:27:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vqDcByoS/t/ZISrx+gwmaKvJwGlUqSJuqfW+dLPvQEI=; b=3wrQex6Aqm3DvRfzw43RS4F7ZL
        pCM6as+plmPZev72prdCFC59jJ0NUenzmlaN9N5VzFevPHhn65tsQ7caGod4KblbbEpNlGZj4O521
        1JVH9+sITsVQy0sEMA/FkuhOzHMrrTF8dz8s5xFRiqEMZKi5zvasS0Y75zE4h/eygD/A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mFeW7-000PPH-Qv; Mon, 16 Aug 2021 17:27:11 +0200
Date:   Mon, 16 Aug 2021 17:27:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Song, Yoong Siang" <yoong.siang.song@intel.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Message-ID: <YRqDz9QZwqjadNdL@lunn.ch>
References: <20210814194916.GB22278@shell.armlinux.org.uk>
 <PH0PR11MB4950652B4D07C189508767F1D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <YRnmRp92j7Qpir7N@lunn.ch>
 <PH0PR11MB4950F854C789F610ECD88E6ED8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <20210816071419.GF22278@shell.armlinux.org.uk>
 <PH0PR11MB495065FCAFD90520684810F7D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <20210816081812.GH22278@shell.armlinux.org.uk>
 <PH0PR11MB49509E7A82947DCB6BB48203D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <20210816115435.664d921b@dellmb>
 <PH0PR11MB49507764E1924DAB8B588D59D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB49507764E1924DAB8B588D59D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 03:02:03PM +0000, Song, Yoong Siang wrote:
> > > Yes, you are right. I missed the effect of get_wol.
> > > Is it needed in future to implement link change interrupt in phy
> > > driver? Cause I dint see much phy driver implement link change
> > > interrupt.
> > 
> > If there is a board that has interrupt pin wired correctly from the PHY and the
> > interrupt controller is safe to use (i.e. it is not a PCA953x which cannot
> > handle interrupt storms correctly), then I think the PHY driver should use the
> > interrupt, instead of polling.
> > 
> > Marek
> 
> Any suggestion to avoid the conflict of "WoL on link change" mentioned by Russell?
> Is it make sense to create a new member called wolopts under struct phy_device
> to track the WoL status and return the correct status in get_wol callback?

I really think you need to look at your PMC and see if you can make it
an interrupt controller. You only need level interrupts, not edge. So
the microcontroller in the PMC could just poll the GPIO. There appears
to be a simple IPC between the host and PMC, so just extend it with a
couple of registers, interrupt state, interrupt mask, and make use of
the existing interrupt between the host and PMC.

    Andrew
