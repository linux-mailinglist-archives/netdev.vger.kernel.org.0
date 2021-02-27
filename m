Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F804326ACF
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 01:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhB0AqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 19:46:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhB0AqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 19:46:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37E5F64EB3;
        Sat, 27 Feb 2021 00:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614386720;
        bh=8GzcFHqVxwP64MUyl/ewaMATY96Fy0U7B+s+LROxfOQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uC4lr+p3faAhWLyMBE/fy3v1cj70OWIVnfCwMgBKcwDfixShShmrdYpR9i7rXd4jj
         UNM40bUd+tR14h8nGB6zqiUKO6na1cbYlHqMScfc5umtAyXUmpvv9IAQjd6MhbIABK
         uE/QEgbt0n1ECJvKdJ/N9WvYMydc2Li4VNb1xH0BCB9sAXr7Q2XFROkQt3/nystncM
         VEy06uxW0+0JmdgrgnD07zlsYHmhhFfaBF9yO8nzZfXWOLOBK8LbAtYZoJcad0nhwg
         Jnk2n32cGe9fJ+xvZY5cWdeYK46G5jc1Ds0uuN09Jz7NuNnGsczHsRb+8UsdQrXMMv
         ZEdevULJMoMUA==
Date:   Fri, 26 Feb 2021 16:45:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Markus =?UTF-8?B?QmzDtmNobA==?= <Markus.Bloechl@ipetronik.com>
Subject: Re: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in
 IFF_PROMISC mode
Message-ID: <20210226164519.4da3775d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210227001651.geuv4pt2bxkzuz5d@skbuf>
References: <20210225121835.3864036-1-olteanv@gmail.com>
        <20210225121835.3864036-6-olteanv@gmail.com>
        <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210226234244.w7xw7qnpo3skdseb@skbuf>
        <20210226154922.5956512b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210227001651.geuv4pt2bxkzuz5d@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Feb 2021 02:16:51 +0200 Vladimir Oltean wrote:
> On Fri, Feb 26, 2021 at 03:49:22PM -0800, Jakub Kicinski wrote:
> > On Sat, 27 Feb 2021 01:42:44 +0200 Vladimir Oltean wrote:  
> > > What I'm fixing is unexpected behavior, according to the applicable
> > > standards I could find. If I don't mark this change as a bug fix but as
> > > a simple patch, somebody could claim it's a regression, since promiscuity
> > > used to be enough to see packets with unknown VLANs, and now it no
> > > longer is...  
> >
> > Can we take it into net-next? What's your feeling on that option?  
> 
> I see how you can view this patch as pointless, but there is some
> context to it. It isn't just for tcpdump/debugging, instead NXP has some
> TSN use cases which involve some asymmetric tc-vlan rules, which is how
> I arrived at this topic in the first place. I've already established
> that tc-vlan only works with ethtool -K eth0 rx-vlan-filter off:
> https://lore.kernel.org/netdev/CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com/
> and that's what we recommend doing, but while adding the support for
> rx-vlan-filter in enetc I accidentally created another possibility for
> this to work on enetc, by turning IFF_PROMISC on. This is not portable,
> so if somebody develops a solution based on that in parallel, it will
> most certainly break on other non-enetc drivers.
> NXP has not released a kernel based on the v5.10 stable yet, so there is
> still time to change the behavior, but if this goes in through net-next,
> the apparent regression will only be visible when the next LTS comes
> around (whatever the number of that might be). Now, I'm going to
> backport this to the NXP v5.10 anyway, so that's not an issue, but there
> will still be the mild annoyance that the upstream v5.10 will behave
> differently in this regard compared to the NXP v5.10, which is again a
> point of potential confusion, but that seems to be out of my control.
> 
> So if you're still "yeah, don't care", then I guess I'm ok with leaving
> things alone on stable kernels.

I see, so this is indeed of practical importance to NXP.

Would you mind re-spinning with an expanded justification?
