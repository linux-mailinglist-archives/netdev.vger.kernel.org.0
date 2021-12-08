Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5423046DA92
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238386AbhLHR70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:59:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46050 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236298AbhLHR7X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 12:59:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=QaVe4D2BWNCawey6MHttIWeCZ2SfuFSomUhLYkw8LLE=; b=iy
        5mx6xKx7wpYXzl+1UQ+3/GB6tZIEWS+nSyuhmfgoV65DNlHhnb7NPRcFsE/NC4CL/SafLdO4pvTVV
        RH7gt5Q1M/uPnEPcOqMUcaf4PuEU+tCVQvlmN8ReT4Fg+HA2sWOoBDnFvEHNdaDJi3OLY1BW46ws9
        9YpX0LOMZ6FymrI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mv1AS-00FuMM-Q6; Wed, 08 Dec 2021 18:55:48 +0100
Date:   Wed, 8 Dec 2021 18:55:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <YbDxpJH3GgPDge+O@lunn.ch>
References: <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208162852.4d7361af@thinkpad>
 <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208171720.6a297011@thinkpad>
 <20211208172104.75e32a6b@thinkpad>
 <20211208164131.fy2h652sgyvhm7jx@skbuf>
 <20211208164932.6ojxt64j3v34477k@skbuf>
 <20211208180057.7fb10a17@thinkpad>
 <20211208171909.3hvre5blb734ueyu@skbuf>
 <20211208183626.4e475b0d@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211208183626.4e475b0d@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 06:36:26PM +0100, Marek Behún wrote:
> On Wed, 8 Dec 2021 19:19:09 +0200
> Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > On Wed, Dec 08, 2021 at 06:00:57PM +0100, Marek Behún wrote:
> > > > Also, maybe drop the "serdes-" prefix? The property will sit under a
> > > > SERDES lane node, so it would be a bit redundant?  
> > > 
> > > Hmm. Holger's proposal adds the property into the port node, not SerDes
> > > lane node. mv88e6xxx does not define bindings for SerDes lane nodes
> > > (yet).  
> > 
> > We need to be careful about that. You're saying that there chances of
> > there being a separate SERDES driver for mv88e6xxx in the future?
> 
> I don't think so. Although Russell is working on rewriting the SerDes
> code to new Phylink API, the SerDes code will always be a part of
> mv88e6xxx driver, I think.

In theory, the 6352 family uses standard c22 layout for its SERDES. It
might be possible to use generic code for that. But given the
architecture, i expect such a change would have the mv88e6xxx
instantiate such generic code, not use an external device.

For the 6390 family the SERDES and the MAC are pretty intertwined, and
it is not a 1:1 mapping. It might be possible to make use of shared
code, but i've much doubt it will be a separate device.

I would put the properties in the port nodes, next to phy-mode,
phy-handle, etc.

Where it might get interesting is the 10G modes, where there are 4
lanes. Is it possible to configure the voltage for each lane? Or is it
one setting for all 4 lanes? I've not looked at the data sheet, so i
cannot answer this.
y
    Andrew
