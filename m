Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4DE1F05A0
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 09:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgFFHtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 03:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgFFHtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 03:49:24 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04371C08C5C2;
        Sat,  6 Jun 2020 00:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xL+G4GsW94/ggK5JfU33JmEGYUmeoXOu9t2Nxi5lgnY=; b=bjusGVWuo6H9lsUp6/2Jur4gzM
        uYQtLAOctf16HA6m4aU/6EAEfqy0jo+pwzk3yEvk4YjkNA9RRR/1Na1MqZbs8DqqLkIJVCUp6dNr7
        4lxV7ePJo9Uvo47yKuedn0fa5Kjw6Inwg0VFA1bhXxQaMAbHiR0G2f07XS3PBG/267lcy5kUlYYc3
        x26fm/A3VaoOKh6BHKFjzyj1yUIbTutkcrNLx+YHB9xXgdavB21Tok0P7rNQwaxB7MDwV1l54MZkG
        HVzNpDCTFlG83GCTLg+7L53YqMggjYoEu2oUxvGsrknG0B1IKfSgeF1SlvwP6bYR+qLGqyH9fXR/W
        TjLww1iQ==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jhTZs-0003Od-7f; Sat, 06 Jun 2020 08:49:16 +0100
Date:   Sat, 6 Jun 2020 08:49:16 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: qca8k: introduce SGMII configuration
 options
Message-ID: <20200606074916.GM311@earth.li>
References: <cover.1591380105.git.noodles@earth.li>
 <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
 <20200605183843.GB1006885@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605183843.GB1006885@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 08:38:43PM +0200, Andrew Lunn wrote:
> On Fri, Jun 05, 2020 at 07:10:58PM +0100, Jonathan McDowell wrote:
> > The QCA8337(N) has an SGMII port which can operate in MAC, PHY or BASE-X
> > mode depending on what it's connected to (e.g. CPU vs external PHY or
> > SFP). At present the driver does no configuration of this port even if
> > it is selected.
> > 
> > Add support for making sure the SGMII is enabled if it's in use, and
> > device tree support for configuring the connection details.
> 
> It is good to include Russell King in Cc: for patches like this.

No problem, I can keep him in the thread; I used get_maintainer for the
initial set of people/lists to copy.

> Also, netdev is closed at the moment, so please post patches as RFC.

"closed"? If you mean this won't get into 5.8 then I wasn't expecting it
to, I'm aware the merge window for that is already open.

> It sounds like the hardware has a PCS which can support SGMII or
> 1000BaseX. phylink will tell you what mode to configure it to. e.g. A
> fibre SFP module will want 1000BaseX. A copper SFP module will want
> SGMII. A switch is likely to want 1000BaseX. A PHY is likely to want
> SGMII. So remove the "sgmii-mode" property and configure it as phylink
> is requesting.

It's more than SGMII or 1000BaseX as I read it. The port can act as if
it's talking to an SGMII MAC, i.e. a CPU, or an SGMII PHY, i.e. an
external PHY, or in BaseX mode for an SFP. I couldn't figure out a way
in the current framework to automatically work out if I wanted PHY or
MAC mode. For the port tagged CPU I can assume MAC mode, but a port that
doesn't have that might still be attached to the CPU rather than an
external PHY.

> What exactly does sgmii-delay do?

As per the device tree documentation update I sent it delays the SGMII
clock by 2ns. From the data sheet:

SGMII_SEL_CLK125M	sgmii_clk125m_rx_delay is delayed by 2ns

> > +#define QCA8K_REG_SGMII_CTRL				0x0e0
> > +#define   QCA8K_SGMII_EN_PLL				BIT(1)
> > +#define   QCA8K_SGMII_EN_RX				BIT(2)
> > +#define   QCA8K_SGMII_EN_TX				BIT(3)
> > +#define   QCA8K_SGMII_EN_SD				BIT(4)
> > +#define   QCA8K_SGMII_CLK125M_DELAY			BIT(7)
> > +#define   QCA8K_SGMII_MODE_CTRL_MASK			(BIT(22) | BIT(23))
> > +#define   QCA8K_SGMII_MODE_CTRL_BASEX			0
> > +#define   QCA8K_SGMII_MODE_CTRL_PHY			BIT(22)
> > +#define   QCA8K_SGMII_MODE_CTRL_MAC			BIT(23)
> 
> I guess these are not really bits. You cannot combine
> QCA8K_SGMII_MODE_CTRL_MAC and QCA8K_SGMII_MODE_CTRL_PHY. So it makes
> more sense to have:
> 
> #define   QCA8K_SGMII_MODE_CTRL_BASEX			(0x0 << 22)
> #define   QCA8K_SGMII_MODE_CTRL_PHY			(0x1 << 22)
> #define   QCA8K_SGMII_MODE_CTRL_MAC			(0x2 << 22)

Sure; given there's no 0x3 choice I just went for the bits that need
set, but that works too.

J.

-- 
Mistakes aren't always regrets.
