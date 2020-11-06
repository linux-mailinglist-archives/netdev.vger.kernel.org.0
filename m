Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D03A2A8FBB
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 07:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgKFG4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 01:56:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgKFG4d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 01:56:33 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83A17206F4;
        Fri,  6 Nov 2020 06:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604645793;
        bh=yRhE6XR0cLSyZZkXEIf4EKqkW1OuHyv4bdZKoioXVrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kuiVH9hQopx87bfdsAx2gbKmFgqYBDw23j1qfXnRfX10trVIjqzi1XQuIsXTGLE9G
         1DTngfIQUa/4q9EbToBgKnayZOqY86jTsC5P77eqHjqujTvlcdN+c69Yid3YbD3VC5
         tWou/zcOf1hZwMT8Gp8NSxGCgRn/4TGKZrD2daKc=
Date:   Fri, 6 Nov 2020 08:56:29 +0200
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
Subject: Re: [PATCH mlx5-next v1 05/11] net/mlx5: Register mlx5 devices to
 auxiliary virtual bus
Message-ID: <20201106065629.GD5475@unreal>
References: <20201101201542.2027568-1-leon@kernel.org>
 <20201101201542.2027568-6-leon@kernel.org>
 <d10e7a08200458c1bddb72fc983a5917daebc8f1.camel@kernel.org>
 <20201105210948.GS2620339@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105210948.GS2620339@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 05:09:48PM -0400, Jason Gunthorpe wrote:
> On Thu, Nov 05, 2020 at 12:59:20PM -0800, Saeed Mahameed wrote:
>
> > 2. you can always load a driver without its underlying device existed.
> > for example, you can load a pci device driver/module and it will load
> > and wait for pci devices to pop up, the subsysetem infrastructure will
> > match between drivers and devices and probe them.
>
> Yes, this works fine with this design
>
> > struct aux_driver mlx5_vpda_aux_driver {
> >
> >       .name = "vdpa",
> >        /* match this driver with mlx5_core devices */
> >       .id_table = {"mlx5_core"},
> >       .ops {
> >             /* called before probe on actual aux mlx5_core device */
> >            .is_supported(struct aux_device);
>
> This means module auto loading is impossible, we can't tell to load
> the module until we load the module to call the is_supported code ..

Right, and if we can, it will be violation of everything we know in
driver model, because the call "is_supported" will need to be called
for every registered driver without any relation to existed devices.

And mlx5_rescan_drivers() came as a need to overcome LAG and eswitch
craziness in everything related to their reprobe flows. Once they will
be changed to work like normal drivers, we will be able to simplify it.

So let's talk offline to see how can we improve mlx5_core even more
after this series is merged.

Thanks

>
> Jason
