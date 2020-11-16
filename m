Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7AF2B54CA
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgKPXNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:13:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727342AbgKPXNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 18:13:49 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61F062223D;
        Mon, 16 Nov 2020 23:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605568429;
        bh=e4YWQykP4JOPmhpqBbyLhdo9/W/RcDDwoCDFNn3Ut1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cUdLQLlDHMtAFQ0/OLw+HRv1w06+nMlzobP64urpp0RBkQBatE2/MWsUdMnAsFYAL
         UV8SezOONXh4lJIyuI4UokWCxYtw2vYdo8/3jWCPlhq0jyA7KNpayX9DM5PuKSi4Aa
         2+EvQnqw7xRPWwcQhzonFxWDx42xQ+dX0Fw7bBYM=
Date:   Mon, 16 Nov 2020 15:13:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 net-next] net: dsa: qca: ar9331: add ethtool stats
 support
Message-ID: <20201116151347.591925ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116230053.ddub7p6lvvszz7ic@skbuf>
References: <20201115073533.1366-1-o.rempel@pengutronix.de>
        <20201116133453.270b8db5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116222146.znetv5u2q2q2vk2j@skbuf>
        <20201116143544.036baf58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116230053.ddub7p6lvvszz7ic@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 01:00:53 +0200 Vladimir Oltean wrote:
> On Mon, Nov 16, 2020 at 02:35:44PM -0800, Jakub Kicinski wrote:
> > On Tue, 17 Nov 2020 00:21:46 +0200 Vladimir Oltean wrote:  
> > > On Mon, Nov 16, 2020 at 01:34:53PM -0800, Jakub Kicinski wrote:  
> > > > You must expose relevant statistics via the normal get_stats64 NDO
> > > > before you start dumping free form stuff in ethtool -S.  
> > >
> > > Completely agree on the point, Jakub, but to be honest we don't give him
> > > that possibility within the DSA framework today, see .ndo_get_stats64 in
> > > net/dsa/slave.c which returns the generic dev_get_tstats64 implementation,
> > > and not something that hooks into the hardware counters, or into the
> > > driver at all, for that matter.  
> >
> > Simple matter of coding, right? I don't see a problem.
> >
> > Also I only mentioned .ndo_get_stats64, but now we also have stats in
> > ethtool->get_pause_stats.  
> 
> Yes, sure we can do that. The pause stats and packet counter ops would
> need to be exposed to the drivers by DSA first, though. Not sure if this
> is something you expect Oleksij to do or if we could pick that up separately
> afterwards.

Well, I feel like unless we draw the line nobody will have 
the incentive to do the work.

I don't mind if it's Oleksij or anyone else doing the plumbing work,
but the task itself seems rather trivial.

> > > But it's good that you raise the point, I was thinking too that we
> > > should do better in terms of keeping the software counters in sync with
> > > the hardware. But what would be a good reference for keeping statistics
> > > on an offloaded interface? Is it ok to just populate the netdev counters
> > > based on the hardware statistics?  
> >
> > IIRC the stats on the interface should be a sum of forwarded in software
> > and in hardware. Which in practice means interface HW stats are okay,
> > given eventually both forwarding types end up in the HW interface
> > (/MAC block).  
> 
> A sum? Wouldn't that count the packets sent/received by the stack twice?

Note that I said _forwarded_. Frames are either forwarded by the HW or
SW (former never hit the CPU, while the latter do hit the CPU or
originate from it). 
