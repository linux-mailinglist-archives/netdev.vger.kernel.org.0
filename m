Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298FE1B2904
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 16:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgDUOG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 10:06:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53980 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728803AbgDUOG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 10:06:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZE7ZPZNWpZOx6t4slyFG28BbRXDnbL4Q+ZDXIqQsbnw=; b=lz9qCO50t/Hg0HRv77g0hKhirQ
        GTSlsi0hC6fbqYV+GQyhy2Pbq4hcd3cHqMREgyMCdmjyukPTVBeuCNfb7CMefPykSGunle0IxN5uM
        rlyrDNkLP8f0TiNM6EEmVC8lgMjarSqRbCRsqZn9F6CJiixBfi+6N6alo4k6iMfWODzo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQtY5-00427K-L3; Tue, 21 Apr 2020 16:06:53 +0200
Date:   Tue, 21 Apr 2020 16:06:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] net: dsa: be compatible with DSA masters with
 max_mtu of 1500 or less
Message-ID: <20200421140653.GA933345@lunn.ch>
References: <20200421123110.13733-1-olteanv@gmail.com>
 <20200421123110.13733-2-olteanv@gmail.com>
 <20200421133321.GD937199@lunn.ch>
 <CA+h21hrXJf1vm-5b3O7zQciznKF-jGSTpe_v6Mgtv8dXNOCt7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrXJf1vm-5b3O7zQciznKF-jGSTpe_v6Mgtv8dXNOCt7g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 04:42:41PM +0300, Vladimir Oltean wrote:
> Hi Andrew,
> 
> On Tue, 21 Apr 2020 at 16:33, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Tue, Apr 21, 2020 at 03:31:09PM +0300, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > It would be ideal if the DSA switch ports would support an MTU of 1500
> > > bytes by default, same as any other net device. But there are 2 cases of
> > > issues with trying to do that:
> > >
> > > - Drivers that are legitimately MTU-challenged and don't support
> > >   anything larger than ETH_DATA_LEN. A very quick search shows that
> > >   sungem.c is one such example - there may be many others.
> > >
> > > - Drivers that simply don't populate netdev->max_mtu. In that case, it
> > >   seems that the ether_setup function sets dev->max_mtu to a default
> > >   value of ETH_DATA_LEN. And due to the above cases which really are
> > >   MTU-challenged, we can't really make any guesses.
> > >
> > > So for these cases, if the max_mtu of the master net_device is lower
> > > than 1500, use that (minus the tagger overhead) as the max MTU of the
> > > switch ports.
> >
> > I don't like this. I suspect this will also break in subtle ways.
> >
> > Please go back to the original behaviour. Make the call to request the
> > minimum needed for DSA.
> 
> In what sense "minimum needed"? It is minimum needed. If
> master->max_mtu is 1500, the MTU will be set to 1496.

Ah, sorry. This is the slave. I was thinking it was the master.

We have always assumed the slave can send normal sized frames,
independent of what the master supports. This is just a follow on from
the fact we ignore errors setting the MTU on the master for the DSA
overhead for normal size frames. So don't set the MTU to 1496, leave
it at 1500. For all working boards out in the wild, 1500 will work.

	 Andrew
