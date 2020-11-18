Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63A22B7637
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 07:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgKRGTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 01:19:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgKRGTr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 01:19:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA81224655;
        Wed, 18 Nov 2020 06:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605680386;
        bh=JyKrBTD9KmRY4xEmDo2NZTmBTy+QJ2mMIRc2QKOzzDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d7XNZzIyCJHcdRwphjUy/Ndt5XCEjL6KToKLBaElJF3RoB6avy6xGyclvEDNnyyxo
         10NQwAmikNMCQx6p+YuEMhQvZnWjHkeXTSXeXsB+uDhiDvDp2y9RT4nbVk0gTbTLZa
         Px+oY3SifEt+uys+r2S6/xakQCY6rFsc+dzOMLyM=
Date:   Wed, 18 Nov 2020 07:19:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 01/10] Add auxiliary bus support
Message-ID: <X7S8/1WOQbPTxfiF@kroah.com>
References: <20201113161859.1775473-1-david.m.ertman@intel.com>
 <20201113161859.1775473-2-david.m.ertman@intel.com>
 <20201117053000.GM47002@unreal>
 <X7N1naYOXodPsP/I@kroah.com>
 <CAPcyv4jXinvaLgtdpXTLLQ3sDOhvoBjF=7v7pba5rAd0g_rdow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jXinvaLgtdpXTLLQ3sDOhvoBjF=7v7pba5rAd0g_rdow@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 01:04:56PM -0800, Dan Williams wrote:
> On Mon, Nov 16, 2020 at 11:02 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Nov 17, 2020 at 07:30:00AM +0200, Leon Romanovsky wrote:
> > > On Fri, Nov 13, 2020 at 08:18:50AM -0800, Dave Ertman wrote:
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
> > > Greg,
> > >
> > > This horse was beaten to death, can we please progress with this patch?
> > > Create special topic branch or ack so I'll prepare this branch.
> > >
> > > We are in -rc4 now and we (Mellanox) can't hold our submissions anymore.
> > > My mlx5_core probe patches [1] were too intrusive and they are ready to
> > > be merged, Parav's patches got positive review as well [2] and will be
> > > taken next.
> > >
> > > We delayed and have in our internal queues the patches for VDPA, eswitch
> > > and followup for mlx5_core probe rework, but trapped due to this AUX bus
> > > patch.
> >
> > There are no deadlines for kernel patches here, sorry.  Give me some
> > time to properly review this, core kernel changes should not be rushed.
> >
> > Also, if you really want to blame someone for the delay, look at the
> > patch submitters not the reviewers, as they are the ones that took a
> > very long time with this over the lifecycle of this patchset, not me.  I
> > have provided many "instant" reviews of this patchset, and then months
> > went by between updates from them.
> 
> Please stop this finger pointing. It was already noted that the team,
> out of abundance of caution / deference to the process, decided not to
> push the patches while I was out on family leave. It's cruel to hold
> that against them, and if anyone is to blame it's me for not
> clarifying it was ok to proceed while I was out.

I'm not blaming anyone, I'm just getting pissed when people are
insisting that I do "quick reviews" for this patchset, which has been
happening by different people since the very beginning of this whole
feature, so I am trying to explain where others should be pointing their
frustration at instead of me if they really want to do such a thing
(hint, they shouldn't, but I wasn't explicit about that, sorry).

Combine this with the long delays between my reviews and a new patchset
submission, and on my end it's an extremely frustrating situation, which
frankly, makes me want to review this thing even less and less as I know
it's not going to be a fun or easy time when I do so.

Everyone needs to remember that there are no deadlines here, and the
people involved all have other things to work on at the same time, and
that there are a lot of different subsystems and moving parts all
involved.  So someone is going to get grumpy about it, and right now, it
seems to be me.  I know I need to review this, and complaining that I
haven't done so within 3 days of sending an updated patch set is not
helping anyone.

I'm going to try to carve out some time this week to review this
properly.  Hopefully there's no other major security "scares" popping up
like there was the past few weeks to divert me from this...

thanks,

greg k-h
