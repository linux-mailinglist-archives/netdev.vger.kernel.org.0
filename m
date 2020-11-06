Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C252A8FFD
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 08:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgKFHF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 02:05:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbgKFHF6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 02:05:58 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D5BA221FE;
        Fri,  6 Nov 2020 07:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604646357;
        bh=NcentItc4GzP7DMUGCOjybP9u3nED8AkeAk+ghWanY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WeQA5GCo1OiQ1S6XtvtUVHunQH7CB+jf6nhafOK25CaY7SOsjWWUXWSJTXufQ/GuX
         LsOp24B2uwbjJacAax4MwryzJX6VOHqIaoqxNPHG9ye7oPP/P7SCzGEIZXBAu0IGyo
         jpWetcwbyQsUe42ZWwf7KowqZsGWui5Y9hyxhSz8=
Date:   Fri, 6 Nov 2020 09:05:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Saeed Mahameed <saeed@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        gregkh <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        shiraz.saleem@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mlx5-next v1 04/11] vdpa/mlx5: Make hardware definitions
 visible to all mlx5 devices
Message-ID: <20201106070552.GE5475@unreal>
References: <20201101201542.2027568-1-leon@kernel.org>
 <20201101201542.2027568-5-leon@kernel.org>
 <8a8e75215a5d3d8cfa9c3c6747325dbbf965811f.camel@kernel.org>
 <20201105203657.GR2620339@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105203657.GR2620339@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 04:36:57PM -0400, Jason Gunthorpe wrote:
> On Thu, Nov 05, 2020 at 12:31:52PM -0800, Saeed Mahameed wrote:
> > On Sun, 2020-11-01 at 22:15 +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > Move mlx5_vdpa IFC header file to the general include folder, so
> > > mlx5_core will be able to reuse it to check if VDPA is supported
> > > prior to creating an auxiliary device.
> > >
> >
> > I don't really like this, the whole idea of aux devices is that they
> > get to do own logic and hide details, now we are exposing aux
> > specific stuff to the bus ..  let's figure a way to avoid such
> > exposure as we discussed yesterday.
>
> Not quite, the idea is we get to have a cleaner split between the two
> sides.
>
> The device side is responsible for things centric to the device, like
> "does this device actually exists" which is what is_supported is
> doing.
>
> The driver side holds the driver specific logic.
>
> > is_supported check shouldn't belong to mlx5_core and each aux device
> > (en/ib/vdpa) should implement own is_supported op and keep the details
> > hidden in the aux driver like it was before this patch.
>
> No, it really should be in the device side.
>
> Part of the point here is to properly fix module loading. That means
> the core driver must only create devices that can actually have a
> driver bound to them because creating a device triggers module
> loading.
>
> For instance we do not want to auto load vdpa modules on every mlx5
> system for no reason, that is not clean at all.

Saeed,

Jason gave very good example and it is not far from the real life requirement.
We have an internal task to make sure that mlx5_vdpa is loaded without any
other mlx5_* modules (ib and eth). This series solves it naturally.

Thanks

>
> Jason
