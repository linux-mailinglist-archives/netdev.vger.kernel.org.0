Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932B22887F5
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 13:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388161AbgJILkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 07:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388152AbgJILkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 07:40:53 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0C5D22261;
        Fri,  9 Oct 2020 11:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602243651;
        bh=djPO21ZI0rtD0x7eWZ96qPf9XDpj0bJs7WKf+/73JqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HDcHBEhXf9UNRMliUnYR5v/8aiRm+ZG2p1kwmx+R6ybNi/ZkFjm3mN6dMyfcIU4+S
         uKEcBdce3uL7cTIvO5tRMdnzsiEFSfeSNdI4A0YFG1/wIwR0gRYqZZILGkHBdIeBkQ
         7dXXGUweVqCk/CE2Geya+U0+J54NbsDjvcRzMtW0=
Date:   Fri, 9 Oct 2020 14:40:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
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
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
Message-ID: <20201009114047.GQ13580@unreal>
References: <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c90316f5-a5a9-fe22-ec11-a30a54ff0a9d@linux.intel.com>
 <DM6PR11MB284147D4BC3FD081B9F0B8BBDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c88b0339-48c6-d804-6fbd-b2fc6fa826d6@linux.intel.com>
 <BY5PR12MB43222FD5959E490E331D680ADC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <1e2a38ac-e259-f955-07ad-602431ad354b@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e2a38ac-e259-f955-07ad-602431ad354b@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 08:29:00AM -0500, Pierre-Louis Bossart wrote:
>
> > > > > > But ... since the init() function is performing both device_init and
> > > > > > device_add - it should probably be called ancillary_device_register,
> > > > > > and we are back to a single exported API for both register and
> > > > > > unregister.
> > > > >
> > > > > Kind reminder that we introduced the two functions to allow the
> > > > > caller to know if it needed to free memory when initialize() fails,
> > > > > and it didn't need to free memory when add() failed since
> > > > > put_device() takes care of it. If you have a single init() function
> > > > > it's impossible to know which behavior to select on error.
> > > > >
> > > > > I also have a case with SoundWire where it's nice to first
> > > > > initialize, then set some data and then add.
> > > > >
> > > >
> > > > The flow as outlined by Parav above does an initialize as the first
> > > > step, so every error path out of the function has to do a
> > > > put_device(), so you would never need to manually free the memory in
> > > the setup function.
> > > > It would be freed in the release call.
> > >
> > > err = ancillary_device_initialize();
> > > if (err)
> > > 	return ret;
> > >
> > > where is the put_device() here? if the release function does any sort of
> > > kfree, then you'd need to do it manually in this case.
> > Since device_initialize() failed, put_device() cannot be done here.
> > So yes, pseudo code should have shown,
> > if (err) {
> > 	kfree(adev);
> > 	return err;
> > }
>
> This doesn't work if the adev is part of a larger structure allocated by the
> parent, which is pretty much the intent to extent the basic bus and pass
> additional information which can be accessed with container_of().

Please take a look how ib_alloc_device() is implemented. It does all
that you wrote above in very similar manner to netdev_alloc.

In a nutshell, ib_alloc_device receives needed size from the user and
requires from the users to extend their structures below "general" one.

Thanks
