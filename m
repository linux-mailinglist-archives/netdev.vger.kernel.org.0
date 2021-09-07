Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E96402D08
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 18:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344726AbhIGQoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 12:44:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59636 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238089AbhIGQoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 12:44:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vQghaR3JGVvxJEfwNBjrGXItKHKj0vvMMYgSps93pfU=; b=sXQP+VAxSiTYKXkn9KouQ7/nco
        e4MOPGzxLCEAjFzjOmAhu4eO2GrbkkFDLQpwxlKACFaWtnmdlcXjUJDYqunF0d0tW1SwoCHRTBV/m
        tCU7Bk8Iy10J/ws9aAMOKAsQpzMrJwDsKN5pSUifdigNuy5UgGtvpszQpq7MvALFVV3s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mNeBe-005fDt-Ls; Tue, 07 Sep 2021 18:43:06 +0200
Date:   Tue, 7 Sep 2021 18:43:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Message-ID: <YTeWmq0sfYJyab6d@lunn.ch>
References: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
 <YTRswWukNB0zDRIc@unreal>
 <20210905084518.emlagw76qmo44rpw@skbuf>
 <YTSa/3XHe9qVz9t7@unreal>
 <20210905103125.2ulxt2l65frw7bwu@skbuf>
 <YTSgVw7BNK1e4YWY@unreal>
 <20210905110735.asgsyjygsrxti6jk@skbuf>
 <20210907084431.563ee411@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ac8e1c9e-5df2-0af7-2ab4-26f78d5839e3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac8e1c9e-5df2-0af7-2ab4-26f78d5839e3@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 07, 2021 at 08:47:35AM -0700, Florian Fainelli wrote:
> 
> 
> On 9/7/2021 8:44 AM, Jakub Kicinski wrote:
> > On Sun, 5 Sep 2021 14:07:35 +0300 Vladimir Oltean wrote:
> > > Again, fallback but not during devlink port register. The devlink port
> > > was registered just fine, but our plans changed midway. If you want to
> > > create a net device with an associated devlink port, first you need to
> > > create the devlink port and then the net device, then you need to link
> > > the two using devlink_port_type_eth_set, at least according to my
> > > understanding.
> > > 
> > > So the failure is during the creation of the **net device**, we now have a
> > > devlink port which was originally intended to be of the Ethernet type
> > > and have a physical flavour, but it will not be backed by any net device,
> > > because the creation of that just failed. So the question is simply what
> > > to do with that devlink port.
> > 
> > Is the failure you're referring to discovered inside the
> > register_netdevice() call?
> 
> It is before, at the time we attempt to connect to the PHY device, prior to
> registering the netdev, we may fail that PHY connection, tearing down the
> entire switch because of that is highly undesirable.
> 
> Maybe we should re-order things a little bit and try to register devlink
> ports only after we successfully registered with the PHY/SFP and prior to
> registering the netdev?

Maybe, but it should not really matter. EPROBE_DEFER exists, and can
happen. The probe can fail for other reasons. All core code should be
cleanly undoable. Maybe we are pushing it a little by only wanting to
undo a single port, rather than the whole switch, but still, i would
make the core handle this, not rearrange the driver. It is not robust
otherwise.

     Andrew
