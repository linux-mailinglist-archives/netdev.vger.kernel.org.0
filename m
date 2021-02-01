Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409B530A1E8
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 07:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhBAGZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 01:25:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232120AbhBAGK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 01:10:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBF6764E06;
        Mon,  1 Feb 2021 06:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612159766;
        bh=UBwxXkczigCj0i40nmBHADQZEPwvhb5D9gS621AOJuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q7KGuLOKW/tqERGqDdAsWebkkpBhdhtWmsCos1s6732i3mXaHt3ZjvdWbAVqIOidp
         96EOQThz4u0kURNAEiFjnll6t7OxoqdeISxBWTvocTmPJHOR7P6jnOJcLHs8DoDbAu
         JtaXZ+NsL53Yx9qiOz77OYIq4GQTLg6FvKvUGFe09IuclCqMuYe2bFKdS+iT1m7rLI
         Itg35zRUa1rFJoMqYspr2FItdnJOtLnHNr+mJKFjqfDbts8EkJ6TREUQl8iDr95ePI
         NmpdHMxTZP54wDwkW5rZSP8oDKGk3SFMRa71cUcIJPXtiSvvg2NNziPp9+bXA0neoY
         +WQ4w7HHGS9Vw==
Date:   Mon, 1 Feb 2021 08:09:22 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210201060922.GB4593@unreal>
References: <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com>
 <99895f7c10a2473c84a105f46c7ef498@intel.com>
 <20210126005928.GF4147@nvidia.com>
 <031c2675aff248bd9c78fada059b5c02@intel.com>
 <20210127121847.GK1053290@unreal>
 <ea62658f01664a6ea9438631c9ddcb6e@intel.com>
 <20210127231641.GS4147@nvidia.com>
 <20210128054133.GA1877006@unreal>
 <d58f341898834170af1bfb6719e17956@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d58f341898834170af1bfb6719e17956@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 01:19:36AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> > implement private channel OPs
> >
> > On Wed, Jan 27, 2021 at 07:16:41PM -0400, Jason Gunthorpe wrote:
> > > On Wed, Jan 27, 2021 at 10:17:56PM +0000, Saleem, Shiraz wrote:
> > >
> > > > Even with another core PCI driver, there still needs to be private
> > > > communication channel between the aux rdma driver and this PCI
> > > > driver to pass things like QoS updates.
> > >
> > > Data pushed from the core driver to its aux drivers should either be
> > > done through new callbacks in a struct device_driver or by having a
> > > notifier chain scheme from the core driver.
> >
> > Right, and internal to driver/core device_lock will protect from parallel
> > probe/remove and PCI flows.
> >
>
> OK. We will hold the device_lock while issuing the .ops callbacks from core driver.
> This should solve our synchronization issue.
>
> There have been a few discussions in this thread. And I would like to be clear on what
> to do.
>
> So we will,
>
> 1. Remove .open/.close, .peer_register/.peer_unregister
> 2. Protect ops callbacks issued from core driver to the aux driver with device_lock
> 3. Move the custom iidc_peer_op callbacks to an irdma driver struct that encapsulates the auxiliary driver struct. For core driver to use.
> 4. Remove ice FSM around open, close etc...
> 5. RDMA aux driver probe will allocate ib_device and register it at the end of probe.
>
> Does this sound acceptable?

I think that it will be good start, it just hard to say in advance
without seeing the end result.

Thanks
