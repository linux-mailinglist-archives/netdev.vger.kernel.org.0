Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBC82C6D28
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 23:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732570AbgK0WOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 17:14:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732439AbgK0WOE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 17:14:04 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 914A522210;
        Fri, 27 Nov 2020 22:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606515243;
        bh=eTJRYAAphkmmMkSCrXMsIZxAiXtN4mmgG1YPzdYS4qM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1qIBD+VLY8vw+jzDfMn39Rc7ifFqKDIq+i9WOH6s5/UQf7gMT8MlMC/aYPRfKbjiL
         0gTxAVKzjYObXtIMpcSJwBEBACy1PVPZFg6DG2vYW/3CFGxBM+MptZqD+Phh8rDoIi
         blD1mk0IP1/hr4ji6moQJchn2cNR70uy5lTmSRAY=
Date:   Fri, 27 Nov 2020 14:14:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127141402.417933f3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127213244.GY2073444@lunn.ch>
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
        <20201127213244.GY2073444@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 22:32:44 +0100 Andrew Lunn wrote:
> > > So long as these counters are still in ethtool -S, i guess it does not
> > > matter. That i do trust to be accurate, and probably consistent across
> > > the counters it returns.  
> > 
> > Not in the NIC designs I'm familiar with.  
> 
> Many NICs have a way to take a hardware snapshot of all counters.
> You can then read them out as fast or slow as you want, since you
> read the snapshot, not the live counters. As a result you can compare
> counters against each other.

Curious, does Marvell HW do it?
 
> > But anyway - this only matters in some strict testing harness,
> > right? Normal users will look at a stats after they noticed issues
> > (so minutes / hours later) or at the very best they'll look at a
> > graph, which will hardly require <1sec accuracy to when error
> > occurred.  
> 
> As Vladimir has pointed out, polling once per second over an i2c bus
> is expensive. And there is an obvious linear cost with the number of
> ports on these switches. And we need to keep latency down so that PTP
> is accurate. Do we really want to be polling, for something which is
> very unlikely to be used?

IDK I find it very questionable if the system design doesn't take into
account that statistics are retrieved every n seconds. We can perhaps
scale the default period with the speed of the bus?

> I think we should probably take another look at the locking and see
> if it can be modified to allow block, so we can avoid this wasteful
> polling.

It'd be great. Worst case scenario we can have very, very rare polling
+ a synchronous callback? But we shouldn't leave /proc be completely
incorrect.

Converting /proc to be blocking may be a little risky, there may be
legacy daemons, and other software which people have running which reads
/proc just to get a list of interfaces or something silly, which will
suddenly start causing latencies to the entire stack.

But perhaps we can try and find out. I'm not completely opposed.
