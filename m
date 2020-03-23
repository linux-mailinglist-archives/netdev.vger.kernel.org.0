Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6C8190127
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 23:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgCWWji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 18:39:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52908 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgCWWji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 18:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IIeMiporbrea7MYQVytfjv0F54IgHiv6DkyNSVyLJtQ=; b=Uio5YaI78I+E/zgW/Qp8zQAXl9
        /onwthQitFdR8LDvNksWyufymAxdP5BglsY8IduVc1iiR9t2il3w/iaA05lDeOsqcbaIngfGLhY/6
        1lq+kYwcge0JAfM50yycVSjmryuBRxvSsTLagbuIVaA4hVp0w86lTHNpXPqssjxDXFVI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGVjK-00048Y-IN; Mon, 23 Mar 2020 23:39:34 +0100
Date:   Mon, 23 Mar 2020 23:39:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Set link down when
 changing speed
Message-ID: <20200323223934.GA14512@lunn.ch>
References: <20200323214900.14083-1-andrew@lunn.ch>
 <20200323214900.14083-3-andrew@lunn.ch>
 <20200323220113.GX25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323220113.GX25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 10:01:13PM +0000, Russell King - ARM Linux admin wrote:
> On Mon, Mar 23, 2020 at 10:49:00PM +0100, Andrew Lunn wrote:
> > The MAC control register must not be changed unless the link is down.
> > Add the necassary call into mv88e6xxx_mac_link_up. Without it, the MAC
> > does not change state, the link remains at the wrong speed.
> > 
> > Fixes: 30c4a5b0aad8 ("net: mv88e6xxx: use resolved link config in mac_link_up()")
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  drivers/net/dsa/mv88e6xxx/chip.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> > index dd8a5666a584..24ce17503950 100644
> > --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> > @@ -733,6 +733,14 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
> >  
> >  	mv88e6xxx_reg_lock(chip);
> >  	if (!mv88e6xxx_port_ppu_updates(chip, port) || mode == MLO_AN_FIXED) {
> > +		/* Port's MAC control must not be changed unless the
> > +		 * link is down
> > +		 */
> > +		err = chip->info->ops->port_set_link(chip, port,
> > +						     LINK_FORCED_DOWN);
> > +		if (err)
> > +			goto error;
> > +
> 
> The port should be down at this point, otherwise the link state is not
> matching phylink's idea of the state.  Your patch merely works around
> that.  I think it needs solving properly.

Hi Russell

So the problem here is that CPU and DSA ports should default to up and
at their fastest speed. During setup, the driver is setting the CPU
port to 1G and up. Later on, phylink finds the fixed-link node in DT,
and then sets the port to 100Mbps as requested.

How do you suggest fixing this? If we find a fixed-link, configure it
first down and then up?

     Andrew
