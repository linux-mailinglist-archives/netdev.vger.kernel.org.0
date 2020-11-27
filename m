Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253672C6D21
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 23:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731681AbgK0WKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 17:10:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:51978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731664AbgK0WDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 17:03:42 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A89A21D7F;
        Fri, 27 Nov 2020 22:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606514621;
        bh=gcKbgVJ21xgfnBK0F2tlwmfV+HJwfmHGsdBZ0TCjShg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HYU+Obf1qT/X8d63MfDRG2Qr56GsYGiOsJV1766APbFGUkoEL774qyOUxVH/Jq4n8
         KzUYdrEmgPpvR4YRiC5r8QNNj5QDYFnVf68g5gsNFWOhkQ7k2Dzj6QpGenqP65000v
         a2o+xrVLcWn3mEEqR8LlQ048GOAoMBRNkqywEEc8=
Date:   Fri, 27 Nov 2020 14:03:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127140340.3bad5985@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127212342.qpyp6bcxd7mwgxf2@skbuf>
References: <20201125193740.36825-3-george.mccollister@gmail.com>
        <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
        <20201126132418.zigx6c2iuc4kmlvy@skbuf>
        <20201126175607.bqmpwbdqbsahtjn2@skbuf>
        <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
        <20201126220500.av3clcxbbvogvde5@skbuf>
        <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201127204714.GX2073444@lunn.ch>
        <20201127131346.3d594c8e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201127212342.qpyp6bcxd7mwgxf2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 23:23:42 +0200 Vladimir Oltean wrote:
> On Fri, Nov 27, 2020 at 01:13:46PM -0800, Jakub Kicinski wrote:
> > On Fri, 27 Nov 2020 21:47:14 +0100 Andrew Lunn wrote:  
> > > > Is the periodic refresh really that awful? We're mostly talking error
> > > > counters here so every second or every few seconds should be perfectly
> > > > fine.  
> > >
> > > Humm, i would prefer error counts to be more correct than anything
> > > else. When debugging issues, you generally don't care how many packets
> > > worked. It is how many failed you are interesting, and how that number
> > > of failures increases.  
> >
> > Right, but not sure I'd use the word "correct". Perhaps "immediately up
> > to date"?
> >
> > High speed NICs usually go through a layer of firmware before they
> > access the stats, IOW even if we always synchronously ask for the stats
> > in the kernel - in practice a lot of NICs (most?) will return some form
> > of cached information.
> >  
> > > So long as these counters are still in ethtool -S, i guess it does not
> > > matter. That i do trust to be accurate, and probably consistent across
> > > the counters it returns.  
> >
> > Not in the NIC designs I'm familiar with.
> >
> > But anyway - this only matters in some strict testing harness, right?
> > Normal users will look at a stats after they noticed issues (so minutes
> > / hours later) or at the very best they'll look at a graph, which will
> > hardly require <1sec accuracy to when error occurred.  
> 
> Either way, can we conclude that ndo_get_stats64 is not a replacement
> for ethtool -S, since the latter is blocking and, if implemented correctly,
> can return the counters at the time of the call (therefore making sure
> that anything that happened before the syscall has been accounted into
> the retrieved values), and the former isn't?

ethtool -S stats are not 100% up to date. Not on Netronome, Intel,
Broadcom or Mellanox NICs AFAIK.

> The whole discussion started because you said we shouldn't expose some
> statistics counters in ethtool as long as they have a standardized
> equivalent. Well, I think we still should.

Users must have access to stats via standard Linux interfaces with well
defined semantics. We cannot continue to live in the world where user
has to guess driver specific name for ethtool -S to find out the number
of CRC errors...

I know it may not matter to a driver developer, and it didn't matter
much to me when I was one, because in my drivers they always had the
same name. But trying to monitor a fleet of hardware from multiple
vendors is very painful with the status quo, we must do better.
We can't have users scrape through what is basically a debug interface
to get to vital information.

I'd really love to find a way out of the procfs issue, but I'm not sure
if there is one.
