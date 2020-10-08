Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58437286EEC
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 09:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgJHHAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 03:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbgJHHAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 03:00:38 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8C1C2168B;
        Thu,  8 Oct 2020 07:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602140437;
        bh=3tOO4RN1EatOt5kk0t9+qLCoWAl86clXtcWvklZwDZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G5JC8jtqkp68NJG95+W4kQtjS/psmxzZTsevnnGPg2L+CakCzTGygxEijW7Sne2q8
         q89F7hzIsWHti924+e0jIYNuScrw/f2Xm64QwAbnHJ9DOnDrbQPOWURrevpjPUQau/
         Ahd53Snm6mYuoNnlPsotYwkI6htOk0Ia8PoMtGhE=
Date:   Thu, 8 Oct 2020 10:00:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     "Ertman, David M" <david.m.ertman@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
Message-ID: <20201008070032.GG13580@unreal>
References: <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201008052137.GA13580@unreal>
 <CAPcyv4gz=mMTfLO4mAa34MEEXgg77o1AWrT6aguLYODAWxbQDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gz=mMTfLO4mAa34MEEXgg77o1AWrT6aguLYODAWxbQDQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 11:32:11PM -0700, Dan Williams wrote:
> On Wed, Oct 7, 2020 at 10:21 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, Oct 07, 2020 at 08:46:45PM +0000, Ertman, David M wrote:
> > > > -----Original Message-----
> > > > From: Parav Pandit <parav@nvidia.com>
> > > > Sent: Wednesday, October 7, 2020 1:17 PM
> > > > To: Leon Romanovsky <leon@kernel.org>; Ertman, David M
> > > > <david.m.ertman@intel.com>
> > > > Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>; alsa-
> > > > devel@alsa-project.org; parav@mellanox.com; tiwai@suse.de;
> > > > netdev@vger.kernel.org; ranjani.sridharan@linux.intel.com;
> > > > fred.oh@linux.intel.com; linux-rdma@vger.kernel.org;
> > > > dledford@redhat.com; broonie@kernel.org; Jason Gunthorpe
> > > > <jgg@nvidia.com>; gregkh@linuxfoundation.org; kuba@kernel.org; Williams,
> > > > Dan J <dan.j.williams@intel.com>; Saleem, Shiraz
> > > > <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> > > > <kiran.patil@intel.com>
> > > > Subject: RE: [PATCH v2 1/6] Add ancillary bus support
> > > >
> > > >
> > > > > From: Leon Romanovsky <leon@kernel.org>
> > > > > Sent: Thursday, October 8, 2020 12:56 AM
> > > > >
> > > > > > > This API is partially obscures low level driver-core code and needs
> > > > > > > to provide clear and proper abstractions without need to remember
> > > > > > > about put_device. There is already _add() interface why don't you do
> > > > > > > put_device() in it?
> > > > > > >
> > > > > >
> > > > > > The pushback Pierre is referring to was during our mid-tier internal
> > > > > > review.  It was primarily a concern of Parav as I recall, so he can speak to
> > > > his
> > > > > reasoning.
> > > > > >
> > > > > > What we originally had was a single API call
> > > > > > (ancillary_device_register) that started with a call to
> > > > > > device_initialize(), and every error path out of the function performed a
> > > > > put_device().
> > > > > >
> > > > > > Is this the model you have in mind?
> > > > >
> > > > > I don't like this flow:
> > > > > ancillary_device_initialize()
> > > > > if (ancillary_ancillary_device_add()) {
> > > > >   put_device(....)
> > > > >   ancillary_device_unregister()
> > > > Calling device_unregister() is incorrect, because add() wasn't successful.
> > > > Only put_device() or a wrapper ancillary_device_put() is necessary.
> > > >
> > > > >   return err;
> > > > > }
> > > > >
> > > > > And prefer this flow:
> > > > > ancillary_device_initialize()
> > > > > if (ancillary_device_add()) {
> > > > >   ancillary_device_unregister()
> > > > This is incorrect and a clear deviation from the current core APIs that adds the
> > > > confusion.
> > > >
> > > > >   return err;
> > > > > }
> > > > >
> > > > > In this way, the ancillary users won't need to do non-intuitive put_device();
> > > >
> > > > Below is most simple, intuitive and matching with core APIs for name and
> > > > design pattern wise.
> > > > init()
> > > > {
> > > >     err = ancillary_device_initialize();
> > > >     if (err)
> > > >             return ret;
> > > >
> > > >     err = ancillary_device_add();
> > > >     if (ret)
> > > >             goto err_unwind;
> > > >
> > > >     err = some_foo();
> > > >     if (err)
> > > >             goto err_foo;
> > > >     return 0;
> > > >
> > > > err_foo:
> > > >     ancillary_device_del(adev);
> > > > err_unwind:
> > > >     ancillary_device_put(adev->dev);
> > > >     return err;
> > > > }
> > > >
> > > > cleanup()
> > > > {
> > > >     ancillary_device_de(adev);
> > > >     ancillary_device_put(adev);
> > > >     /* It is common to have a one wrapper for this as
> > > > ancillary_device_unregister().
> > > >      * This will match with core device_unregister() that has precise
> > > > documentation.
> > > >      * but given fact that init() code need proper error unwinding, like
> > > > above,
> > > >      * it make sense to have two APIs, and no need to export another
> > > > symbol for unregister().
> > > >      * This pattern is very easy to audit and code.
> > > >      */
> > > > }
> > >
> > > I like this flow +1
> > >
> > > But ... since the init() function is performing both device_init and
> > > device_add - it should probably be called ancillary_device_register,
> > > and we are back to a single exported API for both register and
> > > unregister.
> > >
> > > At that point, do we need wrappers on the primitives init, add, del,
> > > and put?
> >
> > Let me summarize.
> > 1. You are not providing driver/core API but simplification and obfuscation
> > of basic primitives and structures. This is new layer. There is no room for
> > a claim that we must to follow internal API.
>
> Yes, this a driver core api, Greg even questioned why it was in
> drivers/bus instead of drivers/base which I think makes sense.

We can argue till death, but at the end, this is a bus.

>
> > 2. API should be symmetric. If you call to _register()/_add(), you will need
> > to call to _unregister()/_del(). Please don't add obscure _put().
>
> It's not obscure it's a long standing semantic for how to properly
> handle device_add() failures. Especially in this case where there is
> no way to have something like a common auxiliary_device_alloc() that
> will work for everyone the only other option is require all device
> destruction to go through the provided release method (put_device())
> after a device_add() failure.

And this is my main concern, this is not device_add() failure but
ancillary_device_add() which hides driver_* logic.

We won't expect to see inside ancillary drivers direct calls to
device_*(), why will it be different here with put_device?

>
> > 3. You can't "ask" from users to call internal calls (put_device) over internal
> > fields in ancillary_device.
>
> Sure it can. platform_device_add() requires a put_device() on failure,
> but also note how platform_device_add() *requires*
> platform_device_alloc() be used to create the device. That
> inflexibility is something this auxiliary bus is trying to avoid.

I'm writing below, the rationale behind this bus is RDMA, netdev and
other cross-subsystem devices.

>
> > 4. This API should be clear to drivers authors, "device_add()" call (and
> > semantic) is not used by the drivers (git grep " device_add(" drivers/).
>
> This shows 141 instances for me, so I'm not sure what you're getting at?

Did you look at them? I did, most if not all of the calls are in
bus/core/generic logic, drivers are not calling to it or at least
not supposed to.

>
> Look, this api is meant to be a replacement for places where platform
> devices were being abused. The device_initialize() + customize device
> + device_add() organization has the flexibility needed to let users
> customize naming and other parts of device creation in a way that a
> device_register() flow, or platform_device_{register,add} in
> particular, did not.

It is hard me to say if the goal it to replace platform devices or not,
but this ancillary_device bus adventure started after request to stop
reinvent PCI logic for every new RDMA (RoCE) drivers. This is there
full power of this virtbus solution comes into full power by deleting
tons of complex code.

>
> If the concern is that you'd like to have an auxiliary_device_put()
> for symmetry that would need to come with the same warning as
> commented on platform_device_put(), i.e. that's it's really only
> vanity symmetry to be used in error paths. The semantics of
> device_add() and device_put() on failure are long established, don't
> invent new behavior for auxiliary_device_add() and
> auxiliary_device_put() / put_device().

All stated above is my opinion, it can be different from yours.

Thanks
