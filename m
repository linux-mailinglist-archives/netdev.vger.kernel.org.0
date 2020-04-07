Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEF11A0C7C
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 13:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgDGLGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 07:06:04 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39084 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgDGLGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 07:06:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ELJ99tITBvhqYigpmJYU0Eq7MDv1Ib9ta9OZruxk3Zg=; b=HWFLQJXP/3Dv/I2y6UrSKLOOV
        c1pMolTgR+++g74RwnASHgtf2QboyHLiTuPO8Dn58QLJGJBVCtQZVlr+I//mlKfli4y5uJDWRTA8s
        JNRS/HAsiOD5+levYZzDnKj06Y/bRRCenktaIYQBHs9QrfqRPrMLh70/u0OyRskPfjeigjL/8aJw/
        9W5unwTDSPKfJeAR2G1O33lsBYBfBZNYkzL2W0n2XleWXt4OQPR9hiykqEJj6J1vvZmF0JvrNBkEg
        jByJqzpI7UFZ0V1Zgl24IrudM3xqjU2C3iHzD8Yy9/Ct1ycxu+5bsf44lnm8f7IyX9BanFEb8hovd
        cgNmeCeag==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46826)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jLm37-0007Wa-Mh; Tue, 07 Apr 2020 12:05:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jLm32-0007aa-Mp; Tue, 07 Apr 2020 12:05:40 +0100
Date:   Tue, 7 Apr 2020 12:05:40 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Philippe Schenker <philippe.schenker@toradex.com>
Cc:     "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "david@protonic.nl" <david@protonic.nl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Message-ID: <20200407110540.GM25745@shell.armlinux.org.uk>
References: <20200407093654.26095-1-o.rempel@pengutronix.de>
 <699bf716ce12178655b47ce77227e4e42b85de1b.camel@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <699bf716ce12178655b47ce77227e4e42b85de1b.camel@toradex.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 07, 2020 at 10:57:07AM +0000, Philippe Schenker wrote:
> On Tue, 2020-04-07 at 11:36 +0200, Oleksij Rempel wrote:
> > Add support for following phy-modes: rgmii, rgmii-id, rgmii-txid,
> > rgmii-rxid.
> > 
> > This PHY has an internal RX delay of 1.2ns and no delay for TX.
> > 
> > The pad skew registers allow to set the total TX delay to max 1.38ns
> > and
> > the total RX delay to max of 2.58ns (configurable 1.38ns + build in
> > 1.2ns) and a minimal delay of 0ns.
> > 
> > According to the RGMII v1.3 specification the delay provided by PCB
> > traces
> > should be between 1.5ns and 2.0ns. The RGMII v2.0 allows to provide
> > this
> > delay by MAC or PHY. So, we configure this PHY to the best values we
> > can
> > get by this HW: TX delay to 1.38ns (max supported value) and RX delay
> > to
> > 1.80ns (best calculated delay)
> > 
> > The phy-modes can still be fine tuned/overwritten by *-skew-ps
> > device tree properties described in:
> > Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> Make sure you do not exceet 80 chars with your phydev_warn. Besides
> that:

There are exceptions to the 80 column rule. From coding-style.rst:

Statements longer than 80 columns will be broken into sensible chunks,
unless exceeding 80 columns significantly increases readability and
does not hide information. Descendants are always substantially shorter
than the parent and are placed substantially to the right. The same
applies to function headers with a long argument list. *However, never
break user-visible strings such as printk messages, because that breaks
the ability to grep for them.*

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
