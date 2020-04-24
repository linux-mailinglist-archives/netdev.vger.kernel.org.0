Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5670D1B78A7
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 16:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgDXO4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 10:56:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgDXO4t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 10:56:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=i8T8P91+yzcMB/IYq4PEZyj+h3cSZcj0sTJ9rKQhaaY=; b=iGp9a3vlmwA0+2N3ar/5vj/na/
        ZazxDH05VDYsLFC+x395RWF8pI2wxVPWtby8BnVnCoaFv/77qGF99D4QPfirjkwi4POEhx49cg8WE
        n/3e7HiOOu6xNUarECxAjKcAtobNKax6eXFRFl2svjY4RX4WND5aWUzDeTWpsoyV5fzg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jRzkp-004ZXA-Qh; Fri, 24 Apr 2020 16:56:35 +0200
Date:   Fri, 24 Apr 2020 16:56:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH net-next v2 6/9] net: phy: add backplane kr driver
 support
Message-ID: <20200424145635.GB1088354@lunn.ch>
References: <AM0PR04MB5443BCFEC71B6903BE6EFE02FBD00@AM0PR04MB5443.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB5443BCFEC71B6903BE6EFE02FBD00@AM0PR04MB5443.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 02:39:54PM +0000, Florinel Iordache wrote:
> > > +/* Backplane custom logging */
> > > +#define bpdev_fn(fn)                                                 \
> > > +void bpdev_##fn(struct phy_device *phydev, char *fmt, ...)           \
> > > +{                                                                    \
> > > +     struct va_format vaf = {                                        \
> > > +             .fmt = fmt,                                             \
> > > +     };                                                              \
> > > +     va_list args;                                                   \
> > > +     va_start(args, fmt);                                            \
> > > +     vaf.va = &args;                                                 \
> > > +     if (!phydev->attached_dev)                                      \
> > > +             dev_##fn(&phydev->mdio.dev, "%pV", &vaf);               \
> > > +     else                                                            \
> > > +             dev_##fn(&phydev->mdio.dev, "%s: %pV",                  \
> > > +                     netdev_name(phydev->attached_dev), &vaf);       \
> > > +     va_end(args);                                                   \
> > > +}
> > > +
> > > +bpdev_fn(err)
> > > +EXPORT_SYMBOL(bpdev_err);
> > > +
> > > +bpdev_fn(warn)
> > > +EXPORT_SYMBOL(bpdev_warn);
> > > +
> > > +bpdev_fn(info)
> > > +EXPORT_SYMBOL(bpdev_info);
> > > +
> > > +bpdev_fn(dbg)
> > > +EXPORT_SYMBOL(bpdev_dbg);
> > 
> > Didn't i say something about just using phydev_{err|warn|info|dbg}?
> > 
> >        Andrew
> 
> Hi Andrew,
> 
> I used this custom logging in order to be able to add any kind of useful information we might need to all prints (err/warn/info/dbg).
> For example all these bpdev_ functions are equivalent with phydev_ but only in the case when there is no attached device: phydev->attached_dev == NULL.
> Otherwise, if there is a device attached, then we also want to add its name to all these prints in order to know to which device the information refers to.
> For example in this case the print looks like this:
> [   50.853515] backplane_qoriq 8c13000:00: eth1: 10gbase-kr link trained, Tx equalization: C(-1)=0x0, C(0)=0x29, C(+1)=0x5
> This is very useful because we can see very easy to which interface the information printed is related to: in this case the link was trained for interface: eth1
> This information (the name of attached device: eth1) is not printed by phydev_ functions.
> I'm sorry I have not explained all this earlier, the first time when you asked about it. 

So why not argue that the phydev_* functions should be extended to
include this information? Is this extra information only valuable for
link training, or for anything a PHY does? If the core does not do
something, fix the core, rather than work around it in your driver.

     Andrew
