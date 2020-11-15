Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504172B32C5
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 07:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgKOGsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 01:48:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbgKOGsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 01:48:07 -0500
Received: from localhost (thunderhill.nvidia.com [216.228.112.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA760223AB;
        Sun, 15 Nov 2020 06:48:05 +0000 (UTC)
Date:   Sun, 15 Nov 2020 08:48:02 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Ertman, David M" <david.m.ertman@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
Message-ID: <20201115064802.GB5552@unreal>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
 <X66rMg1lNJq+W/cp@kroah.com>
 <DM6PR11MB284160D4E69D9C7801A6B1C2DDE60@DM6PR11MB2841.namprd11.prod.outlook.com>
 <X68VA6uw5nz51dll@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X68VA6uw5nz51dll@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 12:21:39AM +0100, Greg KH wrote:
> On Fri, Nov 13, 2020 at 04:07:57PM +0000, Ertman, David M wrote:
> > > -----Original Message-----
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > Sent: Friday, November 13, 2020 7:50 AM
> > > To: Ertman, David M <david.m.ertman@intel.com>
> > > Cc: alsa-devel@alsa-project.org; tiwai@suse.de; broonie@kernel.org; linux-
> > > rdma@vger.kernel.org; jgg@nvidia.com; dledford@redhat.com;
> > > netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org;
> > > ranjani.sridharan@linux.intel.com; pierre-louis.bossart@linux.intel.com;
> > > fred.oh@linux.intel.com; parav@mellanox.com; Saleem, Shiraz
> > > <shiraz.saleem@intel.com>; Williams, Dan J <dan.j.williams@intel.com>;
> > > Patil, Kiran <kiran.patil@intel.com>; linux-kernel@vger.kernel.org;
> > > leonro@nvidia.com
> > > Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
> > >
> > > On Thu, Oct 22, 2020 at 05:33:29PM -0700, Dave Ertman wrote:
> > > > Add support for the Auxiliary Bus, auxiliary_device and auxiliary_driver.
> > > > It enables drivers to create an auxiliary_device and bind an
> > > > auxiliary_driver to it.
> > > >
> > > > The bus supports probe/remove shutdown and suspend/resume callbacks.
> > > > Each auxiliary_device has a unique string based id; driver binds to
> > > > an auxiliary_device based on this id through the bus.
> > > >
> > > > Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> > > > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > > > Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > > Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > > Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> > > > Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> > > > Co-developed-by: Leon Romanovsky <leonro@nvidia.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > > Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > > > ---
> > >
> > > Is this really the "latest" version of this patch submission?
> > >
> > > I see a number of comments on it already, have you sent out a newer one,
> > > or is this the same one that the mlx5 driver conversion was done on top
> > > of?
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > V3 is the latest sent so far.  There was a suggestion that v3 might be merged and
> > the documentation changes could be in a follow up patch.  I have those changes done
> > and ready though, so no reason not to merge them in and do a resend.
> >
> > Please expect v4 in just a little while.
>
> Thank you, follow-up patches aren't usually a good idea :)

The changes were in documentation area that will be changed
anyway after dust will settle and we all see real users and
more or less stable in-kernel API.

Thanks
