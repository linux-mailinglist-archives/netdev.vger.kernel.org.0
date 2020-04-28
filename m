Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAA51BC138
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 16:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgD1O3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 10:29:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57092 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbgD1O3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 10:29:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PbFOZEx8ndKffRxlPvQC3tGFrIJODrlk14t+UpWxRAA=; b=ZkZPzEBA1FQMJdCmlhGwCCQWAq
        P30PPRvzzoDP93kSP0KO3Qu5TKbOxKMLvIHc4303slO1wcl+lDKNEfRmIJtvzg+/9TZVwCqpMvQq1
        wHlJ98bud2GtFawyYR7DEr4aQCh/oUdjbnUGTcz01ldkMja7zSsVivRSrbTCmf6RWCO4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTRET-0006AC-BU; Tue, 28 Apr 2020 16:29:09 +0200
Date:   Tue, 28 Apr 2020 16:29:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        dl-linux-imx <linux-imx@nxp.com>, Chris Healy <cphealy@gmail.com>
Subject: Re: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Message-ID: <20200428142909.GB22600@lunn.ch>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
 <20200427164620.GD1250287@lunn.ch>
 <VI1PR04MB6941C603529307039AF7F4ABEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
 <20200427201339.GJ1250287@lunn.ch>
 <HE1PR0402MB2745B6388B6BF7306629A305FFAC0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
 <20200428133445.GA21352@lunn.ch>
 <HE1PR0402MB27457CCE2807853856117D76FFAC0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HE1PR0402MB27457CCE2807853856117D76FFAC0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Andy
> > 
> > Thanks for digging into the internal of the FEC. Just to make sure i understand
> > this correctly:
> > 
> > In fec_enet_mii_init() we have:
> > 
> >         holdtime = DIV_ROUND_UP(clk_get_rate(fep->clk_ipg), 100000000)
> > - 1;
> > 
> >         fep->phy_speed = mii_speed << 1 | holdtime << 8;
> > 
> >         writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
> > 
> >         /* Clear any pending transaction complete indication */
> >         writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
> > 
> > You are saying this write to the FEC_MII_SPEED register can on some SoCs
> > trigger an FEC_ENET_MII event. And because it does not happen immediately,
> > it happens after the clear which is performed here?
> 
> Correct.
> Before write FEC_MII_SPEED register, FEC_MII_DATA register is not zero, and
> the current value of FEC_MII_SPEED register is zero, once write non zero value
> to FEC_MII_SPEED register, it trigger MII event.
> 
> > Sometime later we then go into fec_enet_mdio_wait(), the event is still
> > pending, so we read the FEC_MII_DATA register too early?
> 
> Correct.
> The first mdio operation is mdio read, read FEC_MII_DATA register is too early,
> it get invalid value. 
> > 
> > But this does not fully explain the problem. This should only affect the first
> > MDIO transaction, because as we exit fec_enet_mdio_wait() the event is
> > cleared. But Leonard reported that all reads return 0, not just the first.
> 
> Of course, it impact subsequent mdio read/write operations.
> After you clear MII event that is pending before.
> Then, after mdio read data back, MII event is set again.
> 
> cpu instruction is much faster than mdio read/write operation.

Ah. Now i get it....

The flow is...

Write FEC_MII_SPEED register
Clear event register

A little latter

event bit set because of FEC_MII_SPEED

A little later
Setup read
fec_enet_mdio_wait()
exit immediately, because of pending event from FEC_MII_SPEED
Clear FEC_MII_SPEED event
Read data register too early

A little later

event bit set because read complete

A little later
Setup read
fec_enet_mdio_wait()
exit immediately, because of pending event from read complete
Clear previous read complete event
Read data register too early

A little later

event bit set because read complete

And the cycle continues...

I will make a formal patch from your email.

  Andrew
