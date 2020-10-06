Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07552851A9
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 20:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgJFSfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 14:35:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:41092 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgJFSfm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 14:35:42 -0400
IronPort-SDR: oBc1qEO6CbQvoTr+mi81dpgXHpeH+B/ZT42Ey3Z6H2Z7Mi1yM/lp4GWQE6TqEuiSiFvDFHy0gn
 o8g8rFwOEF8g==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="182080692"
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="182080692"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 11:35:39 -0700
IronPort-SDR: HdVbTfOcjG7elY9ZVtCoWq9nW0ZjwMAp5bPyeduGT8Mjh9db+f0whfYbGxf58u6omlQg1uyODo
 yQKoLlPmb9mA==
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="342429016"
Received: from unknown (HELO rsridh2-mobl1) ([10.212.228.88])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 11:35:36 -0700
Message-ID: <cb6e2b44e396a6281e12b21253775b9cccf6784d.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
From:   Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
To:     Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@nvidia.com>
Cc:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>
Date:   Tue, 06 Oct 2020 11:35:35 -0700
In-Reply-To: <20201006172650.GO1874917@unreal>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
         <20201005182446.977325-2-david.m.ertman@intel.com>
         <20201006071821.GI1874917@unreal>
         <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
         <20201006170241.GM1874917@unreal>
         <BY5PR12MB43228E8DAA0B56BCF43AF3EFDC0D0@BY5PR12MB4322.namprd12.prod.outlook.com>
         <20201006172650.GO1874917@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-10-06 at 20:26 +0300, Leon Romanovsky wrote:
> On Tue, Oct 06, 2020 at 05:09:09PM +0000, Parav Pandit wrote:
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Tuesday, October 6, 2020 10:33 PM
> > > 
> > > On Tue, Oct 06, 2020 at 10:18:07AM -0500, Pierre-Louis Bossart
> > > wrote:
> > > > Thanks for the review Leon.
> > > > 
> > > > > > Add support for the Ancillary Bus, ancillary_device and
> > > > > > ancillary_driver.
> > > > > > It enables drivers to create an ancillary_device and bind
> > > > > > an
> > > > > > ancillary_driver to it.
> > > > > 
> > > > > I was under impression that this name is going to be changed.
> > > > 
> > > > It's part of the opens stated in the cover letter.
> > > 
> > > ok, so what are the variants?
> > > system bus (sysbus), sbsystem bus (subbus), crossbus ?
> > Since the intended use of this bus is to
> > (a) create sub devices that represent 'functional separation' and
> > (b) second use case for subfunctions from a pci device,
> > 
> > I proposed below names in v1 of this patchset.
> > 
> > (a) subdev_bus
> 
> It sounds good, just can we avoid "_" in the name and call it subdev?
> 
> > (b) subfunction_bus

While we're still discussing names, may I also suggest simply "software
bus" instead?

Thanks,Ranjani

