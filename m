Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D346D305B26
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbhA0MV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 07:21:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237714AbhA0MTb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 07:19:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DDF320786;
        Wed, 27 Jan 2021 12:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611749931;
        bh=ELIL2d977fqXx4vmV90BaWWEiEcjry8hWCg6N1O8ZbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rN0y6E0gHKSCXh7cD0SrPisILsquFwXMME7pOhplLugcd5RGr3rH6JF4bXfjPVMdH
         RKa4CdUaGqgpBcSSI/ZvRggGxpXWIjHvxbJ5++yvgwRtux9yEScLp0M0dniSTlW6NT
         udGjLvqIePsIuhuyCc6NnXyzUya50UsEyYuUJascwQB7+eNFSdYBcCmwxLLopwSFLY
         UIJe4t5EGkBI/eM97xzZAuQAE5xw5DCZGZQI7nLAXp6aGvHMDygQPQPQHQC0YKkiFE
         +O1gv7WkK9OBvTwCfX7dM/ySCwirqAkirTAPazg9lBq18SdZkUd4e/KptO2g+xBeOj
         4+SUnY6tK+UOg==
Date:   Wed, 27 Jan 2021 14:18:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210127121847.GK1053290@unreal>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com>
 <99895f7c10a2473c84a105f46c7ef498@intel.com>
 <20210126005928.GF4147@nvidia.com>
 <031c2675aff248bd9c78fada059b5c02@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <031c2675aff248bd9c78fada059b5c02@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 12:41:41AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> > implement private channel OPs
> >
> > On Tue, Jan 26, 2021 at 12:42:16AM +0000, Saleem, Shiraz wrote:
> >
> > > I think this essentially means doing away with .open/.close piece.
> >
> > Yes, that too, and probably the FSM as well.
> >
> > > Or are you saying that is ok?  Yes we had a discussion in the past and
> > > I thought we concluded. But maybe I misunderstood.
> > >
> > > https://lore.kernel.org/linux-rdma/9DD61F30A802C4429A01CA4200E302A7DCD
> > > 4FD03@fmsmsx124.amr.corp.intel.com/
> >
> > Well, having now seen how aux bus ended up and the way it effected the
> > mlx5 driver, I am more firmly of the opinion this needs to be fixed. It is extremly
> > hard to get everything right with two different registration schemes running around.
> >
> > You never answered my question:
>
> Sorry I missed it.
> >
> > > Still, you need to be able to cope with the user unbinding your
> > > drivers in any order via sysfs. What happens to the VFs when the PF is
> > > unbound and releases whatever resources? This is where the broadcom
> > > driver ran into troubles..
> >
> > ?
>
> echo -n "ice.intel_rdma.0" > /sys/bus/auxiliary/drivers/irdma/unbind  ???
>
> That I believe will trigger a drv.remove() on the rdma PF side which require
> the rdma VFs to go down.
>
> Yes, we currently have a requirement the aux rdma PF driver remain inited at least to .probe()
> for VFs to survive.
>
> We are doing internal review, but it appears we could potentially get rid of the .open/.close callbacks.
> And its associated FSM in ice.
>
> But if we remove peer_register/unregister, how do we synchronize between say unload of the rdma driver
> and netdev driver stop accessing the priv channel iidc_peer_ops that it uses to send events to rdma?

And here we are returning to square one of intended usage of aux bus.
Your driver should be structured to have PCI core logic that will represent
physical device and many small sub-devices with their respective drivers.

ETH is another sub-device that shouldn't talk directly to the RDMA.

Thanks

>
> Shiraz
>
>
