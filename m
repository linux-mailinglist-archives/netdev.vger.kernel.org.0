Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDCB24E950
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 21:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgHVS4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 14:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728398AbgHVS4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 14:56:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A692CC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 11:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NAX9n8relzhKEl3ZlDFUFOoGy3bnKWrywtRFciCOibU=; b=FeoyioO/JjBEjSSqqrfBZvvRi
        5l2IkeSZ1YPk80xmdzM+Ocx9cZPJGQ7NBHFkkDc5Sam/BTbQreG8hdq7iJP/OUybCXzrjpEhaPYlH
        kTjQpU7XGDM6JRhUudRF3o2o5GKGq3TCFq+7qKsI+GZwYYJMNhnB8cFTqkKfNjQ3Qj2zdp2pXllyZ
        x+YCeIyhEDe/fdRQMEelGjQtyTzsgPKq05Dj9FltTbTvXRodr7cmw7oBzFA0nlE2LlNFsKIw70N4K
        uv4eXJj13H+9EHKsuVki2jtoKr8FpZSNIGzwSHXs59ovruJhuIV535ClSRlPeWwxUy+8gJyBomu9A
        GLtLi+pjA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55830)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k9YgD-0006Ls-5G; Sat, 22 Aug 2020 19:55:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k9YgC-0005eA-Ix; Sat, 22 Aug 2020 19:55:52 +0100
Date:   Sat, 22 Aug 2020 19:55:52 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: add support for
 88E6393X from Amethyst family
Message-ID: <20200822185552.GG1551@shell.armlinux.org.uk>
References: <20200819153816.30834-1-marek.behun@nic.cz>
 <20200819153816.30834-4-marek.behun@nic.cz>
 <20200822164946.GI2347062@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822164946.GI2347062@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 22, 2020 at 06:49:46PM +0200, Andrew Lunn wrote:
> > --- a/drivers/net/dsa/mv88e6xxx/port.c
> > +++ b/drivers/net/dsa/mv88e6xxx/port.c
> > @@ -187,11 +187,16 @@ static int mv88e6xxx_port_set_speed_duplex(struct mv88e6xxx_chip *chip,
> >  		ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_1000;
> >  		break;
> >  	case 2500:
> > -		if (alt_bit)
> > -			ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000 |
> > -				MV88E6390_PORT_MAC_CTL_ALTSPEED;
> > +		if (chip->info->family == MV88E6XXX_FAMILY_6393)
> > +			ctrl = MV88E6XXX_PORT_MAC_CTL_SPEED_1000;
> >  		else
> >  			ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000;
> > +		if (alt_bit)
> > +			ctrl |= MV88E6390_PORT_MAC_CTL_ALTSPEED;
> > +		break;
> > +	case 5000:
> > +		ctrl = MV88E6390_PORT_MAC_CTL_SPEED_10000 |
> > +			MV88E6390_PORT_MAC_CTL_ALTSPEED;
> >  		break;
> >  	case 10000:
> >  		/* all bits set, fall through... */
> 
> This is getting more and more complex. Maybe it is time to refactor it?

However, please note that the speed/duplex that is passed through
phylink from phylib is the _media_ speed.  If you are using RXAUI
(for example) then the link should be running at 10G speed,
especially if the PHY is doing rate matching.  The only other thing
is if rate matching is in use but no flow control, then limiting the
egress rate is needed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
