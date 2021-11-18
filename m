Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B753456124
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 18:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbhKRRLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 12:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbhKRRLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 12:11:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736EFC061574;
        Thu, 18 Nov 2021 09:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cYTLYKJQJUU8wXxLFQkLQdtfZP+rbfAgf0jh2BamScA=; b=y/ujQslsZcLSVuB3eBJc+HpzNE
        m2NgCyVzP2W2m9DuwtcqCNYmt+mD7rHDovY0cgJcSPVQMVka+OPUaNP0RSg+xdf/5NDg0kGPsQyDi
        aM5w8XKGJaxP/JOJd5HuvExjKm8JZ81P+j2RYl/DLIqH0WlsFXOfnkjR2TfTeAT3r07p+m6r0/1yV
        TryDAJPdIs/pOADqttympk9Ilt96ifth64bPloCU9vGvyRvR5NgOHRzvh5OqeDemSg7tYRotsEJjD
        qVvB+cqGIxzctWFhgWi20CTWjmoQacetRXyFS/fPpQI4bzGXTwYJvJxTa/J06Of8k67aqL29eE4bc
        fQHoAyMg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55732)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mnktQ-0003Ak-4p; Thu, 18 Nov 2021 17:08:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mnktO-00045b-JS; Thu, 18 Nov 2021 17:08:10 +0000
Date:   Thu, 18 Nov 2021 17:08:10 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] net: phylink: update supported_interfaces
 with modes from fwnode
Message-ID: <YZaIeiOyhqyVNG8D@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-5-kabel@kernel.org>
 <YZYXctnC168PrV18@shell.armlinux.org.uk>
 <YZaAXadMIduFZr08@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZaAXadMIduFZr08@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 05:33:33PM +0100, Andrew Lunn wrote:
> > > +	/* If supported is empty, just copy modes defined in fwnode. */
> > > +	if (phy_interface_empty(supported))
> > > +		return phy_interface_copy(supported, modes);
> > 
> > Doesn't this mean we always end up with the supported_interfaces field
> > filled in, even for drivers that haven't yet been converted? It will
> > have the effect of locking the driver to the interface mode in "modes"
> > where only one interface mode is mentioned in DT.
> > 
> > At the moment, I think the only drivers that would be affected would be
> > some DSA drivers, stmmac and macb as they haven't yet been converted.
> 
> Hi Russell
> 
> What do you think the best way forward is? Got those converted before
> merging this?

The situation is as follows:

- For macb, I have a bunch of patches ready to go against net-next (in
  git log order):
  net: macb: use phylink_generic_validate()
  net: macb: clean up macb_validate()
  net: macb: remove interface checks in macb_validate()
  net: macb: populate supported_interfaces member

  but I think Sean and myself need to finish discussing PCS capabilities
  before I send those.

- For mv88e6xxx DSA, I have some patches - I need to check with Marek
  whether he has any further changes for those as he's been looking over
  them and checking with the Marvell specs before I can send them.

- For mt7530 DSA, I also have some patches, but no way to test them.

All of the above patches are in my net-queue branch:
  http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=net-queue

- For stmmac, I pinged Jose Abreu about it. stmmac's validate function
  does not check the interface mode at all if there is no XPCS attached.
  Jose says that which interface modes are supported is up to the
  integrator to decide, and it seems there is nothing in the current
  driver to work out which interface modes can be supported.

  If there is an XPCS attached, it defers interface mode checks to
  xpcs_validate(), which uses the interface mode to walk an array to
  find a list of linkmodes that the PCS supports.

  So, I think it's going to take a bit of unpicking to work out what to
  do here, and may depend on what we come up with with Sean for PCS.

That leaves quite a number of DSA drivers untouched.

So, I think we need to realise that even though we have all the users
in the kernel, making changes to phylink's API is always going to be
difficult, and we always need to maintain compatibility for old ways
of doing stuff - at least until every user can be converted. However,
that brings with it its own problem - there is then no motivation for
people to adapt to the new way. This can be seen as we have the
compatibility for calling mac_config() whenever the link comes up
16 months after the PCS stuff was introduced. One of the problem
drivers for this is mtk_eth_soc:

http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=278da006a936c0743c7fc261c23e7de992ac78e6

René van Dorst said in response to me posting that patch in July 2020:
> I know, you have pointed that out before. But I don't know how to fix
> mtk_gmac0_rgmii_adjust(). This function changes the PLL of the MAC.
> But without documentation I am not sure what all the bits are used
> for.

and my attempts to discuss a way forward didn't get a reply. So,
mtk_eth_soc has become an example of a problematical driver that makes
ongoing phylink changes difficult, and I fear stmmac may become another
example.

I'm quite certain that as we try to develop phylink, such as adding
extra facilities like specifying the interface modes, we're going to
end up running into these kinds of problems that we can't solve, and
we are going to have to keep compatibility for the old ways of doing
stuff going for years to come - which is just going to get more and
more painful.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
