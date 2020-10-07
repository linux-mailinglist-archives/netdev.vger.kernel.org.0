Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7819286048
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 15:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgJGNgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 09:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728271AbgJGNgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 09:36:38 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36ABC206DD;
        Wed,  7 Oct 2020 13:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602077798;
        bh=MAeEvybVEoJRT6lc2sDnUP7WRyNeQfW3/IR19lxt3n0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BWZaWTr08epBHl9vryIfizBSgAF/Ov+UNRxdscWjXcpcq6behdtjEZeXEYWySAksK
         x/uU7MM5ickJTP4tw3IbMpF7SN2aiSHWsmSzo/hbq0diLUmeiWbH7qBE3YrxGOy92L
         2FrLTA+J9Es8X64gnA57vhZE3UCMfPqOlHzmopRA=
Date:   Wed, 7 Oct 2020 16:36:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Williams, Dan J" <dan.j.williams@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
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
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
Message-ID: <20201007133633.GB3964015@unreal>
References: <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <BY5PR12MB43228E8DAA0B56BCF43AF3EFDC0D0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201006172650.GO1874917@unreal>
 <3ff1445d86564ef3aae28d1d1a9a19ea@intel.com>
 <20201006192036.GQ1874917@unreal>
 <CAPcyv4iC_KGOx7Jwax-GWxFJbfUM-2+ymSuf4zkCxG=Yob5KnQ@mail.gmail.com>
 <cd80aad674ee48faaaedc8698c9b23e2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd80aad674ee48faaaedc8698c9b23e2@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 01:09:55PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> >
> > On Tue, Oct 6, 2020 at 12:21 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Tue, Oct 06, 2020 at 05:41:00PM +0000, Saleem, Shiraz wrote:
> > > > > Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> > > > >
> > > > > On Tue, Oct 06, 2020 at 05:09:09PM +0000, Parav Pandit wrote:
> > > > > >
> > > > > > > From: Leon Romanovsky <leon@kernel.org>
> > > > > > > Sent: Tuesday, October 6, 2020 10:33 PM
> > > > > > >
> > > > > > > On Tue, Oct 06, 2020 at 10:18:07AM -0500, Pierre-Louis Bossart wrote:
> > > > > > > > Thanks for the review Leon.
> > > > > > > >
> > > > > > > > > > Add support for the Ancillary Bus, ancillary_device and
> > ancillary_driver.
> > > > > > > > > > It enables drivers to create an ancillary_device and
> > > > > > > > > > bind an ancillary_driver to it.
> > > > > > > > >
> > > > > > > > > I was under impression that this name is going to be changed.
> > > > > > > >
> > > > > > > > It's part of the opens stated in the cover letter.
> > > > > > >
> > > > > > > ok, so what are the variants?
> > > > > > > system bus (sysbus), sbsystem bus (subbus), crossbus ?
> > > > > > Since the intended use of this bus is to
> > > > > > (a) create sub devices that represent 'functional separation'
> > > > > > and
> > > > > > (b) second use case for subfunctions from a pci device,
> > > > > >
> > > > > > I proposed below names in v1 of this patchset.
> > > > >
> > > > > > (a) subdev_bus
> > > > >
> > > > > It sounds good, just can we avoid "_" in the name and call it subdev?
> > > > >
> > > >
> > > > What is wrong with naming the bus 'ancillary bus'? I feel it's a fitting name.
> > > > An ancillary software bus for ancillary devices carved off a parent device
> > registered on a primary bus.
> > >
> > > Greg summarized it very well, every internal conversation about this
> > > patch with my colleagues (non-english speakers) starts with the question:
> > > "What does ancillary mean?"
> > > https://lore.kernel.org/alsa-devel/20201001071403.GC31191@kroah.com/
> > >
> > > "For non-native english speakers this is going to be rough, given that
> > > I as a native english speaker had to go look up the word in a
> > > dictionary to fully understand what you are trying to do with that
> > > name."
> >
> > I suggested "auxiliary" in another splintered thread on this question.
> > In terms of what the kernel is already using:
> >
> > $ git grep auxiliary | wc -l
> > 507
> > $ git grep ancillary | wc -l
> > 153
> >
> > Empirically, "auxiliary" is more common and closely matches the intended function
> > of these devices relative to their parent device.
>
> auxiliary bus is a befitting name as well.

Let's share all options and decide later.
I don't want to find us bikeshedding about it.

Thanks
