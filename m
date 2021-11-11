Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A9B44D67C
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 13:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhKKMUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 07:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230400AbhKKMUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 07:20:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7391561211;
        Thu, 11 Nov 2021 12:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636633076;
        bh=c9VnKqgJ2rMO+Zzc7vjuRNOc5h6hZhw6e30Z2VmL5pQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=skPFgRlSGWq8aW1LHjsoYXYnHL9p1T69fIrrV07x9jFLCB28Qt+gzAyc9RGWvCdq7
         v6KO/HTZ15R34UM1wdXCOzu3qFcedG0unzzh4RgxGcXyAEU+ssOf84e7W+ukrwE2PO
         agPyFyiVdS5qLjsTbBEBYX+P8IC7XOMq5N6n/12j0Mrw1zkT4+ijP8hAst+a4uTBXN
         E0K5qBXAbPMOBB4xDUqzS47UKLsMpMmkRnX/A+27U1vGIQjzvJo6wmcUPZOFHNYhEl
         IHV0PXpIYvy7c69DhrBD/SB6n4ljoBEd/aLxZWwuxk8GCQgQeGRdCbszXFKTvtN0n1
         pcBBvVlZ6D2lA==
Date:   Thu, 11 Nov 2021 14:17:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YY0J8IOLQBBhok2M@unreal>
References: <YYlrZZTdJKhha0FF@unreal>
 <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYmBbJ5++iO4MOo7@unreal>
 <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109144358.GA1824154@nvidia.com>
 <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109153335.GH1740502@nvidia.com>
 <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109182427.GJ1740502@nvidia.com>
 <YY0G90fJpu/OtF8L@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YY0G90fJpu/OtF8L@nanopsycho>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 01:05:11PM +0100, Jiri Pirko wrote:
> Tue, Nov 09, 2021 at 07:24:27PM CET, jgg@nvidia.com wrote:
> >On Tue, Nov 09, 2021 at 08:20:42AM -0800, Jakub Kicinski wrote:
> >> On Tue, 9 Nov 2021 11:33:35 -0400 Jason Gunthorpe wrote:
> >> > > > I once sketched out fixing this by removing the need to hold the
> >> > > > per_net_rwsem just for list iteration, which in turn avoids holding it
> >> > > > over the devlink reload paths. It seemed like a reasonable step toward
> >> > > > finer grained locking.  
> >> > > 
> >> > > Seems to me the locking is just a symptom.  
> >> > 
> >> > My fear is this reload during net ns destruction is devlink uAPI now
> >> > and, yes it may be only a symptom, but the root cause may be unfixable
> >> > uAPI constraints.
> >> 
> >> If I'm reading this right it locks up 100% of the time, what is a uAPI
> >> for? DoS? ;)
> >> 
> >> Hence my questions about the actual use cases.
> >
> >Removing namespace support from devlink would solve the crasher. I
> >certainly didn't feel bold enough to suggest such a thing :)
> >
> >If no other devlink driver cares about this it is probably the best
> >idea.
> 
> Devlink namespace support is not generic, not related to any driver.

What do you mean?

devlink_pernet_pre_exit() calls to devlink reload, which means that only
drivers that support reload care about it. The reload is driver thing.

Thanks

> 
> >
> >Jason
