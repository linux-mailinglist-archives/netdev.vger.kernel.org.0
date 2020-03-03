Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B21F177A42
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgCCPUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:20:24 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37250 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729026AbgCCPUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rqs5n3XmRaCSly2EDMH5QvAtlRmv89IGC+Wzd5o0qbs=; b=nbHgWKIkv2Idzwy2Et9+uo8r5
        hBVoCfFc5qneG0jrRoj6SRap0bI7PVh7DBfz/yHPW+73e/9KrYctdzDVbwSVQ+wjNUG6aO/ffFiod
        UQ/J9JFQB8i+SN+JXWHQU2OoiTk0TG++cuUlUGNq8BIs7J01KfGl6+IOKIKkvzbCFXCFUM8vpoe4S
        T/eu1VUviPns2fnKW05x9bjZ0zaxuWfpOPU7ODT3/O4MblD0MKK7DOZ6T2d2Bp73d7qTvlvdieKSL
        slk74rDFOS1upoLRux0JoJcJwMKqth3Sh/oQP60/HhHjMTpq6qqG6B04egY5L7wEgpNh5O6VXqp6R
        8ZB1TfUjQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:55736)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j99LF-0000Ic-Nd; Tue, 03 Mar 2020 15:20:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j99LE-00060I-U8; Tue, 03 Mar 2020 15:20:16 +0000
Date:   Tue, 3 Mar 2020 15:20:16 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: phy: marvell10g: add mdix control
Message-ID: <20200303152016.GP25745@shell.armlinux.org.uk>
References: <20200303144259.GM25745@shell.armlinux.org.uk>
 <E1j98m5-00057k-Q6@rmk-PC.armlinux.org.uk>
 <20200303150958.GD3179@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303150958.GD3179@kwain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 04:09:58PM +0100, Antoine Tenart wrote:
> Hello Russell,
> 
> On Tue, Mar 03, 2020 at 02:43:57PM +0000, Russell King wrote:
> >  
> > +static int mv3310_config_mdix(struct phy_device *phydev)
> > +{
> > +	u16 val;
> > +	int err;
> > +
> > +	switch (phydev->mdix_ctrl) {
> > +	case ETH_TP_MDI_AUTO:
> > +		val = MV_PCS_CSCR1_MDIX_AUTO;
> > +		break;
> > +	case ETH_TP_MDI_X:
> > +		val = MV_PCS_CSCR1_MDIX_MDIX;
> > +		break;
> > +	case ETH_TP_MDI:
> > +		val = MV_PCS_CSCR1_MDIX_MDI;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	err = phy_modify_mmd_changed(phydev, MDIO_MMD_PCS, MV_PCS_CSCR1,
> > +				     MV_PCS_CSCR1_MDIX_MASK, val);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	return mv3310_maybe_reset(phydev, MV_PCS_BASE_T, err > 0);
> 
> This helper is only introduced in patch 2.

Hmm, must have happened when I reordered the patches, and I hadn't
noticed.  Thanks, v2 coming soon.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
