Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9921E3A30
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 09:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387403AbgE0HRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 03:17:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387395AbgE0HRg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 03:17:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E57C207ED;
        Wed, 27 May 2020 07:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590563856;
        bh=dbCiVcOZ3jW/HX4+nny+dgvdKPl1ec5YfDTKSi7itfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NzCszPNqpgaMVG0p1VFWA+T1SALHZ7AaX7xMtVKCCOP0dIupH9laAOCVzNZcGoaQj
         15ZnixSKDy12dgjE4UtsbzL5n+ZZ+BFru1evK4h6zQR2qNDtseO/Yfa/C0cPRY9q9E
         jlK3B8eHmRsbgV+ng3jQBX02uj2c1JBJ567j6yOA=
Date:   Wed, 27 May 2020 09:17:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200527071733.GB52617@kroah.com>
References: <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
 <20200520125437.GH31189@ziepe.ca>
 <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200523062351.GD3156699@kroah.com>
 <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
 <20200524063519.GB1369260@kroah.com>
 <fe44419b-924c-b183-b761-78771b7d506d@linux.intel.com>
 <s5h5zcistpb.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h5zcistpb.wl-tiwai@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 03:37:36PM +0200, Takashi Iwai wrote:
> On Tue, 26 May 2020 15:15:26 +0200,
> Pierre-Louis Bossart wrote:
> > 
> > 
> > 
> > On 5/24/20 1:35 AM, Greg KH wrote:
> > > On Sat, May 23, 2020 at 02:41:51PM -0500, Pierre-Louis Bossart wrote:
> > >>
> > >>
> > >> On 5/23/20 1:23 AM, Greg KH wrote:
> > >>> On Fri, May 22, 2020 at 09:29:57AM -0500, Pierre-Louis Bossart wrote:
> > >>>> This is not an hypothetical case, we've had this recurring problem when a
> > >>>> PCI device creates an audio card represented as a platform device. When the
> > >>>> card registration fails, typically due to configuration issues, the PCI
> > >>>> probe still completes.
> > >>>
> > >>> Then fix that problem there.  The audio card should not be being created
> > >>> as a platform device, as that is not what it is.  And even if it was,
> > >>> the probe should not complete, it should clean up after itself and error
> > >>> out.
> > >>
> > >> Did you mean 'the PCI probe should not complete and error out'?
> > >
> > > Yes.
> > >
> > >> If yes, that's yet another problem... During the PCI probe, we start a
> > >> workqueue and return success to avoid blocking everything.
> > >
> > > That's crazy.
> > >
> > >> And only 'later' do we actually create the card. So that's two levels
> > >> of probe that cannot report a failure. I didn't come up with this
> > >> design, IIRC this is due to audio-DRM dependencies and it's been used
> > >> for 10+ years.
> > >
> > > Then if the probe function fails, it needs to unwind everything itself
> > > and unregister the device with the PCI subsystem so that things work
> > > properly.  If it does not do that today, that's a bug.
> > >
> > > What kind of crazy dependencies cause this type of "requirement"?
> > 
> > I think it is related to the request_module("i915") in
> > snd_hdac_i915_init(), and possibly other firmware download.
> > 
> > Adding Takashi for more details.
> 
> Right, there are a few levels of complexity there.  The HD-audio
> PCI controller driver, for example, is initialized in an async way
> with a work.  It loads the firmware files with
> request_firmware_nowait() and also binds itself as a component master
> with the DRM graphics driver via component framework.
> 
> Currently it has no way to unwind the PCI binding itself at the error
> path, though.  In theory it should be possible to unregister the PCI
> from the driver itself in the work context, but it failed in the
> earlier experiments, hence the driver sets itself in a disabled state
> instead.  Maybe worth to try again.
> 
> But, to be noted, all belonging sub-devices aren't instantiated but
> deleted at the error path.  Only the main PCI binding is kept in a
> disabled state just as a place holder until it's unbound explicitly.

Ok, that's good to hear.  But platform devices should never be showing
up as a child of a PCI device.  In the "near future" when we get the
virtual bus code merged, we can convert any existing users like this to
the new code.

thanks,

greg k-h
