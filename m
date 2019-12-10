Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB83118BCA
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 15:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfLJO6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 09:58:18 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52826 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727272AbfLJO6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 09:58:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=isOkNJUMf1B7fKaSQLUZcaf/MKjMhWFz9C5BGsPEgD8=; b=na1axSozcdM+lGT7A5F3mPwpr
        TbEutl70IYUef1czLJRlfGJndf1ZwqsWBY3m7DNXm4OTK5j1laMtGETGVU1Ujz2pstYnurjLfgT6C
        L+hLjKsuMkv2vbzPKanIafAR0ct5HyjggBwqZ7Dv6caJyRqLkk5xGSHXP2m8HMcjudguGcIgJPiPm
        vMJefwytFY1cz3Cg3rjyEnR4hL9lI0dK+oUOSt9qu8a1hJ35NtnuXrBBWMT7dAjgty2d/jByYLRet
        I4SxKZ0jKf/kmZbrSM482MWqxCcK1T4Cx3GKOf1NXwCuZu04CN3hTSr4C9+XLZwyhF7/mqdeYrH2X
        03WLBTEEA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:39452)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iegxi-00023g-OS; Tue, 10 Dec 2019 14:58:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iegxf-0004jM-3O; Tue, 10 Dec 2019 14:58:03 +0000
Date:   Tue, 10 Dec 2019 14:58:03 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Willy Tarreau <w@1wt.eu>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        maxime.chevallier@bootlin.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: fix condition for setting up link
 interrupt
Message-ID: <20191210145802.GV25745@shell.armlinux.org.uk>
References: <20190124131803.14038-1-tbogendoerfer@suse.de>
 <20190124155137.GD482@lunn.ch>
 <20190124160741.jady3r2e4dme7c4m@e5254000004ec.dyn.armlinux.org.uk>
 <20190125083720.GK3662@kwain>
 <20191208164235.GT1344@shell.armlinux.org.uk>
 <20191210145359.GA90089@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210145359.GA90089@kwain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 03:53:59PM +0100, Antoine Tenart wrote:
> Hi Russell,
> 
> On Sun, Dec 08, 2019 at 04:42:36PM +0000, Russell King - ARM Linux admin wrote:
> > 
> > Today, I received an email from Willy Tarreau about this issue which
> > persists to this day with mainline kernels.
> > 
> > Willy reminded me that I've been carrying a fix for this, but because
> > of your concerns as stated above, I haven't bothered submitting it
> > through fear of causing regressions (which you seem to know about):
> > 
> >    http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=mvpp2&id=67ef3bff255b26cc0d6def8ca99c4e8ae9937727
> > 
> > Just like Thomas' case, the current code is broken for phylink when
> > in-band negotiation is being used - such as with the 1G/2.5G SFP
> > slot on the Macchiatobin.
> > 
> > It seems that resolving the issue has stalled.  Can I merge my patch,
> > or could you state exactly what the problems are with it so that
> > someone else can look into the issues please?
> 
> Yes, please merge your patch (the one dropping the check on
> '!port->phylink'), I've been using it for months. I answered that patch
> submission back then[1] but it seems it was lost somehow :)
> 
> Thanks!
> Antoine
> 
> [1] https://www.spinics.net/lists/netdev/msg555697.html

Thanks.  Looks like I never read your reply (probably got buried.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
