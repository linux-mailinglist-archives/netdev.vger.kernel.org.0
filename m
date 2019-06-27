Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F42158AF2
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 21:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfF0T2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 15:28:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38366 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbfF0T2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 15:28:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pfFOMoKJzOKIQebJNqxQnidmbuTVklA+Iu6cpCenVNE=; b=KXsLMH0hNE8NJ4cEwwQM99d3Me
        gRSSxDznM4Bg2y37GuZ5KL6eCrBoR2YCPrkvTLWL2r2BtqaeoioZPnXheGxF8DoLf3svxxhEwDuMJ
        sSCtzMcfYZO3ZVB6LfQlde6hYtvefr76UEEHBaqjXCMjOQOuFyhU5uxartSW9ErTnewE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hga3y-00037F-Tj; Thu, 27 Jun 2019 21:28:06 +0200
Date:   Thu, 27 Jun 2019 21:28:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Santos <daniel.santos@pobox.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, vivien.didelot@gmail.com,
        frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
Message-ID: <20190627192806.GQ27733@lunn.ch>
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-2-opensource@vdorst.com>
 <20190624153950.hdsuhrvfd77heyor@shell.armlinux.org.uk>
 <20190625113158.Horde.pCaJOVUsgyhYLd5Diz5EZKI@www.vdorst.com>
 <20190625121030.m5w7wi3rpezhfgyo@shell.armlinux.org.uk>
 <1ad9f9a5-8f39-40bd-94bb-6b700f30c4ba@pobox.com>
 <20190625190246.GA27733@lunn.ch>
 <4fc51dc4-0eec-30d7-86d1-3404819cf6fe@pobox.com>
 <20190625204148.GB27733@lunn.ch>
 <e469daa1-3e28-db9c-e29a-7f68cc676fda@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e469daa1-3e28-db9c-e29a-7f68cc676fda@pobox.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Looking at the data sheet page, you want FORCE_MODE_Pn set. You never
> > want the MAC directly talking to the PHY. Bad things will happen.
> 
> So what exactly do you mean by the MAC directly talking to the PHY?  Do
> you mean setting speed, duplex, etc. via the MAC registers instead of
> via MDIO to the MII registers of the PHY?

The data sheet implies the MAC hardware performs reads on the PHY to
get the status, and then uses that to configure the MAC. This is often
called PHY polling. The MAC hardware however has no idea what the PHY
driver is doing. The MAC does not take the PHY mutex. So the PHY
driver might be doing something at the same time the MAC hardware
polls the PHY, and it gets odd results. Some PHYs have multiple pages,
and for example reading the temperature sensor means swapping
pages. If the MAC hardware was to poll while the sensor is being read,
it would not get the link status, it would read some random
temperature register.

So you want the PHY driver to read the results of auto-neg and it then
tell the MAC the results, so the MAC can be configured correctly.

> > Then use FORCE_RX_FC_Pn and FORCE_TX_Pn to reflect phydev->pause and
> > phydev->asym_pause.
> >
> > The same idea applies when using phylink.
> >
> >     Andrew
> 
> You're help is greatly appreciated here.  Admittedly, I'm also trying to
> get this working in the now deprecated swconfig for a 3.18 kernel that's
> in production.

I'm not very familiar with swconfig. Is there software driving the
PHY? If not, it is then safe for the MAC hardware to poll the PHY.

     Andrew

