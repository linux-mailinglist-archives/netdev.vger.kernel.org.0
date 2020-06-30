Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E5A20FA7A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 19:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390298AbgF3RYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 13:24:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:45357 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390241AbgF3RYF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 13:24:05 -0400
IronPort-SDR: YqgPasl+4s2jaEjdMw0AVTEUKlBdnjCZpilmsmoif6NnjbilwsQ2P/SGU/Q/Za4h7HkvrOr75p
 3Pdz+MU/5+6Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="143807749"
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="143807749"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 10:24:05 -0700
IronPort-SDR: aqKw0kyJto2TMNUXkyLRwzW1m6zH6mYeXW5q8JAWzE1QZv5THhvcyQk8BgN4tdK7gkTcR4CZto
 76rW/8dCWgZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="321472381"
Received: from hlziegle-mobl.amr.corp.intel.com ([10.251.154.212])
  by orsmga007.jf.intel.com with ESMTP; 30 Jun 2020 10:24:04 -0700
Message-ID: <936d8b1cbd7a598327e1b247441fa055d7083cb6.camel@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
From:   Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Mark Brown <broonie@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>,
        lee.jones@linaro.org
Date:   Tue, 30 Jun 2020 10:24:04 -0700
In-Reply-To: <20200630113245.GG25301@ziepe.ca>
References: <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
         <20200523062351.GD3156699@kroah.com>
         <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
         <20200524063519.GB1369260@kroah.com>
         <fe44419b-924c-b183-b761-78771b7d506d@linux.intel.com>
         <s5h5zcistpb.wl-tiwai@suse.de> <20200527071733.GB52617@kroah.com>
         <20200629203317.GM5499@sirena.org.uk> <20200629225959.GF25301@ziepe.ca>
         <20200630103141.GA5272@sirena.org.uk> <20200630113245.GG25301@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-06-30 at 08:32 -0300, Jason Gunthorpe wrote:
> On Tue, Jun 30, 2020 at 11:31:41AM +0100, Mark Brown wrote:
> > On Mon, Jun 29, 2020 at 07:59:59PM -0300, Jason Gunthorpe wrote:
> > > On Mon, Jun 29, 2020 at 09:33:17PM +0100, Mark Brown wrote:
> > > > On Wed, May 27, 2020 at 09:17:33AM +0200, Greg KH wrote:
> > > > > Ok, that's good to hear.  But platform devices should never
> > > > > be showing
> > > > > up as a child of a PCI device.  In the "near future" when we
> > > > > get the
> > > > > virtual bus code merged, we can convert any existing users
> > > > > like this to
> > > > > the new code.
> > > > What are we supposed to do with things like PCI attached FPGAs
> > > > and ASICs
> > > > in that case?  They can have host visible devices with physical
> > > > resources like MMIO ranges and interrupts without those being
> > > > split up
> > > > neatly as PCI subfunctions - the original use case for MFD was
> > > > such
> > > > ASICs, there's a few PCI drivers in there now. 
> > > Greg has been pretty clear that MFD shouldn't have been used on
> > > top of
> > > PCI drivers.
> > 
> > The proposed bus lacks resource handling, an equivalent of
> > platform_get_resource() and friends for example, which would be
> > needed
> > for use with physical devices.  Both that and the name suggest that
> > it's
> > for virtual devices.
> 
> Resource handling is only useful if the HW has a hard distinction
> between it's functional blocks. This scheme is intended for devices
> where that doesn't exist. The driver that attaches to the PCI device
> and creates the virtual devices is supposed to provide SW
> abstractions
> for the other drivers to sit on.
>  
> I'm not sure why we are calling it virtual bus.
Hi Jason,

We're addressing the naming in the next version as well. We've had
several people reject the name virtual bus and we've narrowed in on
"ancillary bus" for the new name suggesting that we have the core
device that is attached to the primary bus and one or more sub-devices
that are attached to the ancillary bus. Please let us know what you
think of it.

Thanks,
Ranjani

