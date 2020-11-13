Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E89D2B291B
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 00:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgKMXUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 18:20:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgKMXUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 18:20:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5905322256;
        Fri, 13 Nov 2020 23:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605309643;
        bh=NuhkiV2bk+P2nm9RmCwzXiSURYvAzkorSkZlQdsyIyI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HNYHa1YTSWRM2Nq4Lj/6KwBuYRXmoOm3ylGPkVHoS34gXThqVVPWjmsVbQzYPDVGe
         Ev+dOOC5dlHp2f3V2hGbgMKgYfcwzn600L4peMVNsguIXxtCxuuKLybuZfpcstEV3b
         /izANNTZJa3cloFxirC+Vr31LhhTxVOvY2D9LtRE=
Date:   Sat, 14 Nov 2020 00:21:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>
Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
Message-ID: <X68VA6uw5nz51dll@kroah.com>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
 <X66rMg1lNJq+W/cp@kroah.com>
 <DM6PR11MB284160D4E69D9C7801A6B1C2DDE60@DM6PR11MB2841.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB284160D4E69D9C7801A6B1C2DDE60@DM6PR11MB2841.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 04:07:57PM +0000, Ertman, David M wrote:
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Friday, November 13, 2020 7:50 AM
> > To: Ertman, David M <david.m.ertman@intel.com>
> > Cc: alsa-devel@alsa-project.org; tiwai@suse.de; broonie@kernel.org; linux-
> > rdma@vger.kernel.org; jgg@nvidia.com; dledford@redhat.com;
> > netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org;
> > ranjani.sridharan@linux.intel.com; pierre-louis.bossart@linux.intel.com;
> > fred.oh@linux.intel.com; parav@mellanox.com; Saleem, Shiraz
> > <shiraz.saleem@intel.com>; Williams, Dan J <dan.j.williams@intel.com>;
> > Patil, Kiran <kiran.patil@intel.com>; linux-kernel@vger.kernel.org;
> > leonro@nvidia.com
> > Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
> > 
> > On Thu, Oct 22, 2020 at 05:33:29PM -0700, Dave Ertman wrote:
> > > Add support for the Auxiliary Bus, auxiliary_device and auxiliary_driver.
> > > It enables drivers to create an auxiliary_device and bind an
> > > auxiliary_driver to it.
> > >
> > > The bus supports probe/remove shutdown and suspend/resume callbacks.
> > > Each auxiliary_device has a unique string based id; driver binds to
> > > an auxiliary_device based on this id through the bus.
> > >
> > > Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> > > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > > Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> > > Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> > > Co-developed-by: Leon Romanovsky <leonro@nvidia.com>
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > > ---
> > 
> > Is this really the "latest" version of this patch submission?
> > 
> > I see a number of comments on it already, have you sent out a newer one,
> > or is this the same one that the mlx5 driver conversion was done on top
> > of?
> > 
> > thanks,
> > 
> > greg k-h
> 
> V3 is the latest sent so far.  There was a suggestion that v3 might be merged and
> the documentation changes could be in a follow up patch.  I have those changes done
> and ready though, so no reason not to merge them in and do a resend.
> 
> Please expect v4 in just a little while.

Thank you, follow-up patches aren't usually a good idea :)
