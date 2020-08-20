Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AD224C2F8
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgHTQJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbgHTQJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 12:09:45 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADCF32072D;
        Thu, 20 Aug 2020 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597939784;
        bh=uz4SpDnKstY75z+E+TK2SL5ml9ZrB+zjefRGjT8xqWw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fgv2OryLL16SZWAwkSxSeLytWo743WBDnIj99H4gcg/RKHA0/J9KcyVaTKFVYflCy
         EBgQmMk42lBZF1yCPhkO90NgCn3jEDCuULf+O7UwJIO0BMiH7HKYPy3qBIotDbHu3R
         bLCMXPowsWfo2Sibo4PSHCddh6x9qgiGBFDp9YKM=
Date:   Thu, 20 Aug 2020 09:09:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com, roopa@nvidia.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, tariqt@nvidia.com,
        ayal@nvidia.com, mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
Message-ID: <20200820090942.55dc3182@kicinski-fedora-PC1C0HJN>
In-Reply-To: <d0c24aad-b7f3-7fd9-0b34-c695686e3a86@gmail.com>
References: <20200817125059.193242-1-idosch@idosch.org>
 <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
 <20200818203501.5c51e61a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <55e40430-a52f-f77b-0d1e-ef79386a0a53@gmail.com>
 <20200819091843.33ddd113@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e4fd9b1c-5f7c-d560-9da0-362ddf93165c@gmail.com>
 <20200819110725.6e8744ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d0c24aad-b7f3-7fd9-0b34-c695686e3a86@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 08:35:25 -0600 David Ahern wrote:
> On 8/19/20 12:07 PM, Jakub Kicinski wrote:
> > I don't have a great way forward in mind, sadly. All I can think of is
> > that we should try to create more well defined interfaces and steer
> > away from free-form ones.  
> 
> There is a lot of value in free-form too.

On Tue, 18 Aug 2020 20:35:01 -0700 Jakub Kicinski wrote:
> It's a question of interface, not the value of exposed data.

> > Example, here if the stats are vxlan decap/encap/error - we should
> > expose that from the vxlan module. That way vxlan module defines one
> > set of stats for everyone.
> > 
> > In general unless we attach stats to the object they relate to, we will
> > end up building parallel structures for exposing statistics from the
> > drivers. I posted a set once which was implementing hierarchical stats,
> > but I've abandoned it for this reason.
> > > [...]
> > 
> > IDK. I just don't feel like this is going to fly, see how many names
> > people invented for the CRC error statistic in ethtool -S, even tho
> > there is a standard stat for that! And users are actually parsing the
> > output of ethtool -S to get CRC stats because (a) it became the go-to
> > place for NIC stats and (b) some drivers forget to report in the
> > standard place.
> > 
> > The cover letter says this set replaces the bad debugfs with a good,
> > standard API. It may look good and standard for _vendors_ because they
> > will know where to dump their counters, but it makes very little
> > difference for _users_. If I have to parse names for every vendor I use,
> > I can as well add a per-vendor debugfs path to my script.
> > 
> > The bar for implementation-specific driver stats has to be high.  
> 
> My take away from this is you do not like the names - the strings side
> of it.
> 
> Do you object to the netlink API? The netlink API via devlink?
> 
> 'perf' has json files to describe and document counters
> (tools/perf/pmu-events). Would something like that be acceptable as a
> form of in-tree documentation of counters? (vs Documentation/networking
> or URLs like
> https://community.mellanox.com/s/article/understanding-mlx5-ethtool-counters)

Please refer to what I said twice now about the definition of the stats
exposed here belonging with the VxLAN code, not the driver.

> > Okay, fair. I just think that in datacenter deployments we are way
> > closer to the SDK model than people may want to admit.
> 
> I do not agree with that; the SDK model means you *must* use vendor code
> to make something work. Your argument here is about labels for stats and
> an understanding of their meaning.

Sure, no "must" for passing packets, but you "must" use vendor tooling
to operate a fleet.

Since everybody already has vendor tools what value does this API add?
I still need per vendor logic. Let's try to build APIs which will
actually make user's life easier, which users will want to switch to.
