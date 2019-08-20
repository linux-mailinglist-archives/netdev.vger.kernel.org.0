Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE29795C01
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbfHTKH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:07:57 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48029 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729194AbfHTKH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 06:07:56 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 322DBE0009;
        Tue, 20 Aug 2019 10:07:53 +0000 (UTC)
Date:   Tue, 20 Aug 2019 12:07:52 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        sd@queasysnail.net, andrew@lunn.ch, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com
Subject: Re: [PATCH net-next v2 5/9] net: phy: add MACsec ops in phy_device
Message-ID: <20190820100752.GD3292@kwain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-6-antoine.tenart@bootlin.com>
 <1521a28b-a0af-b3fb-d1bf-af82ec2f3d47@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1521a28b-a0af-b3fb-d1bf-af82ec2f3d47@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, Aug 14, 2019 at 04:15:03PM -0700, Florian Fainelli wrote:
> On 8/8/19 7:05 AM, Antoine Tenart wrote:
> > This patch adds a reference to MACsec ops in the phy_device, to allow
> > PHYs to support offloading MACsec operations. The phydev lock will be
> > held while calling those helpers.
> > 
> > Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> > ---
> >  include/linux/phy.h | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 462b90b73f93..6947a19587e4 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -22,6 +22,10 @@
> >  #include <linux/workqueue.h>
> >  #include <linux/mod_devicetable.h>
> >  
> > +#ifdef CONFIG_MACSEC
> > +#include <net/macsec.h>
> > +#endif
> 
> #if IS_ENABLED(CONFIG_MACSEC)
> 
> > +
> >  #include <linux/atomic.h>
> >  
> >  #define PHY_DEFAULT_FEATURES	(SUPPORTED_Autoneg | \
> > @@ -345,6 +349,7 @@ struct phy_c45_device_ids {
> >   * attached_dev: The attached enet driver's device instance ptr
> >   * adjust_link: Callback for the enet controller to respond to
> >   * changes in the link state.
> > + * macsec_ops: MACsec offloading ops.
> >   *
> >   * speed, duplex, pause, supported, advertising, lp_advertising,
> >   * and autoneg are used like in mii_if_info
> > @@ -438,6 +443,11 @@ struct phy_device {
> >  
> >  	void (*phy_link_change)(struct phy_device *, bool up, bool do_carrier);
> >  	void (*adjust_link)(struct net_device *dev);
> > +
> > +#if defined(CONFIG_MACSEC)
> > +	/* MACsec management functions */
> > +	const struct macsec_ops *macsec_ops;
> > +#endif
> 
> #if IS_ENABLED(CONFIG_MACSEC)
> 
> likewise.

I'll fix it.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
