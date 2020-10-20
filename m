Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C673A293F08
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 16:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408426AbgJTOvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 10:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408395AbgJTOvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 10:51:21 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FBCC061755;
        Tue, 20 Oct 2020 07:51:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id C12121406A6;
        Tue, 20 Oct 2020 16:51:17 +0200 (CEST)
Date:   Tue, 20 Oct 2020 16:51:15 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] net: dsa: mv88e6xxx: Don't force link when using
 in-band-status
Message-ID: <20201020165115.3ecfd601@nic.cz>
In-Reply-To: <20201020141525.GD1551@shell.armlinux.org.uk>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
        <20201020034558.19438-2-chris.packham@alliedtelesis.co.nz>
        <20201020101552.GB1551@shell.armlinux.org.uk>
        <20201020154940.60357b6c@nic.cz>
        <20201020140535.GE139700@lunn.ch>
        <20201020141525.GD1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 15:15:25 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Tue, Oct 20, 2020 at 04:05:35PM +0200, Andrew Lunn wrote:
> > On Tue, Oct 20, 2020 at 03:49:40PM +0200, Marek Behun wrote:  
> > > On Tue, 20 Oct 2020 11:15:52 +0100
> > > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > >   
> > > > On Tue, Oct 20, 2020 at 04:45:56PM +1300, Chris Packham wrote:  
> > > > > When a port is configured with 'managed = "in-band-status"' don't force
> > > > > the link up, the switch MAC will detect the link status correctly.
> > > > > 
> > > > > Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> > > > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>    
> > > > 
> > > > I thought we had issues with the 88E6390 where the PCS does not
> > > > update the MAC with its results. Isn't this going to break the
> > > > 6390? Andrew?
> > > >   
> > > 
> > > Russell, I tested this patch on Turris MOX with 6390 on port 9 (cpu
> > > port) which is configured in devicetree as 2500base-x, in-band-status,
> > > and it works...
> > > 
> > > Or will this break on user ports?  
> > 
> > User ports is what needs testing, ideally with an SFP.
> > 
> > There used to be explicit code which when the SERDES reported link up,
> > the MAC was configured in software with the correct speed etc. With
> > the move to pcs APIs, it is less obvious how this works now, does it
> > still software configure the MAC, or do we have the right magic so
> > that the hardware updates itself.  
> 
> It's still there. The speed/duplex etc are read from the serdes PHY
> via mv88e6390_serdes_pcs_get_state(). When the link comes up, we
> pass the negotiated link parameters read from there to the link_up()
> functions. For ports where mv88e6xxx_port_ppu_updates() returns false
> (no external PHY) we update the port's speed and duplex setting and
> (currently, before this patch) force the link up.
> 
> That was the behaviour before I converted the code, the one that you
> referred to. I had assumed the code was correct, and _none_ of the
> speed, duplex, nor link state was propagated from the serdes PCS to
> the port on the 88E6390 - hence why the code you refer to existed.
> 

Russell, you are right.
SFP on 88E6390 does not work with this patch applied.
So this patch breaks 88E6390.

Marek
