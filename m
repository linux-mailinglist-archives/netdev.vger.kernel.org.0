Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68261FCC6F
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 13:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgFQLeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 07:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgFQLeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 07:34:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4496C061573
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 04:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=p4B8CjAEjj8cGqxUdh3/eOTjqBsFkzIk5ge+Bqy4W9I=; b=c6Pz00XMxvThNGs0hjMmIyttO
        NcaCnAcywdpRiEuxkEJf6s4NnkEixpcY+tedTzK3LzCLNb4esTTWmRyJ8299MGSTy8247H41aZaIx
        JInLdj7w0molKHD/b8lgv2xOkFpX9Eu5v1EygTxsM6Qu3e4w4gw3raenKMAHtsIYUlNfdKzCQ1JOg
        Jxomad7N+zvycejpTODipwWrDlr+tHO9q8i2Dp9apK6N/jnA/GWZ1qV5hewvYaBjJZnFQ23g8tATy
        NbwyUw4PzS7yd6RaaYnhOOJAcAC/EzH5b5D02KtIsNuYG68PWe2ZXwZFK3iXNQ5R4ajjBJ6+SM2TO
        NVn0VTvvg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58462)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlWKZ-0003gK-IP; Wed, 17 Jun 2020 12:34:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlWKY-0003gq-Rt; Wed, 17 Jun 2020 12:34:10 +0100
Date:   Wed, 17 Jun 2020 12:34:10 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Helmut Grohne <helmut.grohne@intenta.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200617113410.GP1551@shell.armlinux.org.uk>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
 <CA+h21hotpF58RrKsZsET9XT-vVD3EHPZ=kjQ2mKVT2ix5XAt=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hotpF58RrKsZsET9XT-vVD3EHPZ=kjQ2mKVT2ix5XAt=A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 02:32:09PM +0300, Vladimir Oltean wrote:
> On Wed, 17 Jun 2020 at 13:56, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Tue, Jun 16, 2020 at 09:49:56AM +0200, Helmut Grohne wrote:
> > > The macb driver does not support configuring rgmii delays. At least for
> > > the Zynq GEM, delays are not supported by the hardware at all. However,
> > > the driver happily accepts and ignores any such delays.
> > >
> > > When operating in a mac to phy connection, the delay setting applies to
> > > the phy. Since the MAC does not support delays, the phy must provide
> > > them and the only supported mode is rgmii-id.  However, in a fixed mac
> > > to mac connection, the delay applies to the mac itself. Therefore the
> > > only supported rgmii mode is rgmii.
> >
> > This seems incorrect - see the phy documentation in
> > Documentation/networking/phy.rst:
> >
> > * PHY_INTERFACE_MODE_RGMII: the PHY is not responsible for inserting any
> >   internal delay by itself, it assumes that either the Ethernet MAC (if capable
> >   or the PCB traces) insert the correct 1.5-2ns delay
> >
> > * PHY_INTERFACE_MODE_RGMII_TXID: the PHY should insert an internal delay
> >   for the transmit data lines (TXD[3:0]) processed by the PHY device
> >
> > * PHY_INTERFACE_MODE_RGMII_RXID: the PHY should insert an internal delay
> >   for the receive data lines (RXD[3:0]) processed by the PHY device
> >
> > * PHY_INTERFACE_MODE_RGMII_ID: the PHY should insert internal delays for
> >   both transmit AND receive data lines from/to the PHY device
> >
> > Note that PHY_INTERFACE_MODE_RGMII, the delay can be added by _either_
> > the MAC or by PCB trace routing.
> >
> 
> What does it mean "can" be added? Is it or is it not added? As a MAC
> driver, what do you do?

I'm just stating what is documented.

> > The individual RGMII delay modes are more about what the PHY itself is
> > asked to do with respect to inserting delays, so I don't think your
> > patch makes sense.
> >
> 
> We all read the phy-mode documentation, but we aren't really any
> smarter. That document completely fails to address the existence of
> PCB traces.
> Helmut's link points to some more discussion around this topic.

Why are you so abrasive?

Not responding to this until you start behaving more reasonably.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
