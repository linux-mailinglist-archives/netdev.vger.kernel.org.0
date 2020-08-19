Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4AA24A5A5
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 20:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgHSSHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 14:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbgHSSH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 14:07:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDBB320658;
        Wed, 19 Aug 2020 18:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597860447;
        bh=1RSoxbEl3LYTroXQgmInVO+Erwbej0LERCtjRfCnBow=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DmOhIPDLecy7MMIUyEfHSWoHoeRb5b4ijzGQv2c34IwGEQRBUaQ7Jp+oXeo/sPAPc
         dvrjrjAFaZeb75juUYW2fBBdD3r7jwyafi4XixfjmPO6VVfhos20a9T/41f2C5PWES
         C9h8nNDdOdxbDxkhrtGIVxPJcBwQRaiAoKb4+/kY=
Date:   Wed, 19 Aug 2020 11:07:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@idosch.org>,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tariqt@nvidia.com, ayal@nvidia.com, mkubecek@suse.cz,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
Message-ID: <20200819110725.6e8744ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e4fd9b1c-5f7c-d560-9da0-362ddf93165c@gmail.com>
References: <20200817125059.193242-1-idosch@idosch.org>
        <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
        <20200818203501.5c51e61a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <55e40430-a52f-f77b-0d1e-ef79386a0a53@gmail.com>
        <20200819091843.33ddd113@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e4fd9b1c-5f7c-d560-9da0-362ddf93165c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 10:20:08 -0700 Florian Fainelli wrote:
> > I'm trying to find a solution which will not require a policeman to
> > constantly monitor the compliance. Please see my effort to ensure
> > drivers document and use the same ethtool -S stats in the TLS offload
> > implementations. I've been trying to improve this situation for a long
> > time, and it's getting old.  
> 
> Which is why I am asking genuinely what do you think should be done
> besides doing more code reviews? It does not seem to me that there is an
> easy way to catch new stats being added with tools/scripts/whatever and
> then determine what they are about, right?

I don't have a great way forward in mind, sadly. All I can think of is
that we should try to create more well defined interfaces and steer
away from free-form ones.

Example, here if the stats are vxlan decap/encap/error - we should
expose that from the vxlan module. That way vxlan module defines one
set of stats for everyone.

In general unless we attach stats to the object they relate to, we will
end up building parallel structures for exposing statistics from the
drivers. I posted a set once which was implementing hierarchical stats,
but I've abandoned it for this reason.

> > Please focus on the stats this set adds, instead of fantasizing of what
> > could be. These are absolutely not implementation specific!  
> 
> Not sure if fantasizing is quite what I would use. I am just pointing
> out that given the inability to standardize on statistics maybe we
> should have namespaces and try our best to have everything fit into the
> standard namespace along with a standard set of names, and push back
> whenever we see vendor stats being added (or more pragmatically, ask
> what they are). But maybe this very idea is moot.

IDK. I just don't feel like this is going to fly, see how many names
people invented for the CRC error statistic in ethtool -S, even tho
there is a standard stat for that! And users are actually parsing the
output of ethtool -S to get CRC stats because (a) it became the go-to
place for NIC stats and (b) some drivers forget to report in the
standard place.

The cover letter says this set replaces the bad debugfs with a good,
standard API. It may look good and standard for _vendors_ because they
will know where to dump their counters, but it makes very little
difference for _users_. If I have to parse names for every vendor I use,
I can as well add a per-vendor debugfs path to my script.

The bar for implementation-specific driver stats has to be high.

> >>> If I have to download vendor documentation and tooling, or adapt my own
> >>> scripts for every new vendor, I could have as well downloaded an SDK.    
> >>
> >> Are not you being a bit over dramatic here with your example?   
> > 
> > I hope not. It's very hard/impossible today to run a fleet of Linux
> > machines without resorting to vendor tooling.  
> 
> Your argument was putting on the same level resorting to vendor tooling
> to extract meaningful statistics/counters versus using a SDK to operate
> the hardware (this is how I understood it), and I do not believe this is
> fair.

Okay, fair. I just think that in datacenter deployments we are way
closer to the SDK model than people may want to admit.
