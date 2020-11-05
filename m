Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9A62A780D
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 08:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgKEHcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 02:32:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgKEHcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 02:32:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930A420936;
        Thu,  5 Nov 2020 07:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604561534;
        bh=95POjnfgmnBfa+PcIUbO71yIixyEwcBCZu8ONi41qSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v7jixjnRS8IofHWpcD2+DxxCXJ90U/evKE0DUQul2JT/Y8H+g7nVaRbkifKy48xox
         VDGBlpUHfWervGmkwxAM0ACUtpdpFRRs9k0EqAwpLdfoM3L9+GBIUBILJMUGPAe8zd
         NU6sc18Y6rTq9FYLuezM9oiY3jBE5sPskCQybDUw=
Date:   Thu, 5 Nov 2020 08:33:02 +0100
From:   gregkh <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Netdev <netdev@vger.kernel.org>, Parav Pandit <parav@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David M Ertman <david.m.ertman@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH mlx5-next v1 06/11] vdpa/mlx5: Connect mlx5_vdpa to
 auxiliary bus
Message-ID: <20201105073302.GA3415673@kroah.com>
References: <20201101201542.2027568-1-leon@kernel.org>
 <20201101201542.2027568-7-leon@kernel.org>
 <20201103154525.GO36674@ziepe.ca>
 <CAPcyv4jP9nFAGdvB7agg3x7Y7moHGcxLd5=f5=5CXnJRUf3n9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jP9nFAGdvB7agg3x7Y7moHGcxLd5=f5=5CXnJRUf3n9w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 03:21:23PM -0800, Dan Williams wrote:
> On Tue, Nov 3, 2020 at 7:45 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> [..]
> > > +MODULE_DEVICE_TABLE(auxiliary, mlx5v_id_table);
> > > +
> > > +static struct auxiliary_driver mlx5v_driver = {
> > > +     .name = "vnet",
> > > +     .probe = mlx5v_probe,
> > > +     .remove = mlx5v_remove,
> > > +     .id_table = mlx5v_id_table,
> > > +};
> >
> > It is hard to see from the diff, but when this patch is applied the
> > vdpa module looks like I imagined things would look with the auxiliary
> > bus. It is very similar in structure to a PCI driver with the probe()
> > function cleanly registering with its subsystem. This is what I'd like
> > to see from the new Intel RDMA driver.
> >
> > Greg, I think this patch is the best clean usage example.
> >
> > I've looked over this series and it has the right idea and
> > parts. There is definitely more that can be done to improve mlx5 in
> > this area, but this series is well scoped and cleans a good part of
> > it.
> 
> Greg?
> 
> I know you alluded to going your own way if the auxiliary bus patches
> did not shape up soon, but it seems they have and the stakeholders
> have reached this consensus point.
> 
> Were there any additional changes you wanted to see happen? I'll go
> give the final set another once over, but David has been diligently
> fixing up all the declared major issues so I expect to find at most
> minor incremental fixups.

This is in my to-review pile, along with a load of other stuff at the
moment:
	$ ~/bin/mdfrm -c ~/mail/todo/
	1709 messages in /home/gregkh/mail/todo/

So give me a chance.  There is no rush on my side for this given the
huge delays that have happened here on the authorship side many times in
the past :)

If you can review it, or anyone else, that is always most appreciated.

thanks,

greg k-h
