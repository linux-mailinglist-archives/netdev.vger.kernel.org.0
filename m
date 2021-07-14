Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270A03C89BE
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 19:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239748AbhGNR26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 13:28:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54976 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhGNR25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 13:28:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AlrjkHfgiupumNx/+6p/tkKKGBLAJCwsWpH5ndO4cYQ=; b=fEsf9QmUcUYrX3xSZYBzABCnCm
        1B3S4wxmaZBVgRg1oV2+Q1v53JDbHCNlYKeSvDfmY4Zig+T6IL2VSdPnDgbaeDaObYpllAek3I5UD
        ijKZ9QUMSO4gp6M1GQ7Bjf7wz0lkZCZxjS0o0RMB8AKjdaTLHJHIAZDgjokMpyxdgWJ4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m3ids-00DNbk-7K; Wed, 14 Jul 2021 19:25:52 +0200
Date:   Wed, 14 Jul 2021 19:25:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: Re: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
Message-ID: <YO8eILdf4orh0ISY@lunn.ch>
References: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
 <20210714145408.4382-3-biju.das.jz@bp.renesas.com>
 <YO8KeCg8bQPjI/a5@lunn.ch>
 <OS0PR01MB59225983D7FB35F82213911686139@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS0PR01MB59225983D7FB35F82213911686139@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 05:01:34PM +0000, Biju Das wrote:
> Hi Andrew Lunn,
> 
> Thanks for the feedback.
> 
> > Subject: Re: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
> > 
> > > +	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID) {
> > > +		ravb_write(ndev, ravb_read(ndev, CXR31)
> > > +			 | CXR31_SEL_LINK0, CXR31);
> > > +	} else {
> > > +		ravb_write(ndev, ravb_read(ndev, CXR31)
> > > +			 & ~CXR31_SEL_LINK0, CXR31);
> > > +	}
> > 
> > You need to be very careful here. What value is passed to the PHY?
> 
> PHY_INTERFACE_MODE_RGMII is the value passed to PHY.

In all four cases? So if DT contains rgmii-txid, or rgmii-rxid, the
requested delay will not happen in either the MAC or the PHY?

In general in Linux, MAC drivers don't add any delays, and request the
PHY to do it. There are some MAC drivers which do it differently, they
add the delays, but that is uncommon. So unless you have a good reason
not to, i would suggest you leave the PHY to do the delays.

	  Andrew

