Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F65105A08
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 19:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfKUSzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 13:55:10 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60674 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUSzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 13:55:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FNZZ6BHsoiG9MNUNKseUGwnKby5k7q5SzmDqGflstPs=; b=sa2loDpPloW1x0j07a6fZofeM
        5r7HJ+GwMZzWJ4rEnLZ3EMrXtaTGRf5J/vHedYbja79fEeVQlRR+q1O1kp8iVzhPgjNoI5RL2Dpas
        KJgOhKXwJM+NaS1Wl1WPiZJHWQDbsPX6BI1UaJDsTyNwqJIAoCzEr2zotB5wNNyzC7sfvYoCnpC2q
        g0vAWweC+u8yPEdTWBDMrNgvD1WKS0X7NW/5bkxsmK0jTlcpcBdGsupGs2MgQnlyU2n7ZCEiezrZR
        3XhsmbY3uOF5eiS8xssVZLrb1BZKKueF/g2eycmTKyJn8UZ8dnTN87W5ZYY/iJ8jxxA8NeGNzowkk
        rnmBJ2paA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:59334)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iXrbY-00009O-LF; Thu, 21 Nov 2019 18:55:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iXrbV-0002xU-Ko; Thu, 21 Nov 2019 18:54:57 +0000
Date:   Thu, 21 Nov 2019 18:54:57 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: sfp: soft status and control support
Message-ID: <20191121185457.GA25745@shell.armlinux.org.uk>
References: <E1iXP7P-0006DS-47@rmk-PC.armlinux.org.uk>
 <DB6PR0402MB27891CA467D04389FA68B0CFE04E0@DB6PR0402MB2789.eurprd04.prod.outlook.com>
 <20191121162309.GZ25745@shell.armlinux.org.uk>
 <VI1PR0402MB28007002CABED79C95DC093DE04E0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB28007002CABED79C95DC093DE04E0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 06:33:41PM +0000, Ioana Ciornei wrote:
> 
> > Subject: Re: [PATCH net-next v2] net: sfp: soft status and control support
> > 
> > On Thu, Nov 21, 2019 at 03:51:07PM +0000, Ioana Ciornei wrote:
> > > > Subject: [PATCH net-next v2] net: sfp: soft status and control
> > > > support
> > > >
> > > > Add support for the soft status and control register, which allows
> > > > TX_FAULT and RX_LOS to be monitored and TX_DISABLE to be set.  We
> > > > make use of this when the board does not support GPIOs for these
> > signals.
> > >
> > > Hi Russell,
> > >
> > > With this addition, shouldn't the following print be removed?
> > >
> > > [    2.967583] sfp sfp-mac4: No tx_disable pin: SFP modules will always be
> > emitting.
> > 
> > No, because modules do not have to provide the soft controls.
> > 
> 
> I understand that the soft controls are optional but can't we read
> byte 93 (Enhanced Options) and see if bit 6 (Optional soft TX_DISABLE control)
> is set or not (ie the soft TX_DISABLE is implemented)?

At cage initialisation time, when we don't know whether there's a
module present or not?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
