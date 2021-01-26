Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1539C305B43
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314056AbhAZW4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 17:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387531AbhAZF37 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 00:29:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BED5A206F7;
        Tue, 26 Jan 2021 05:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611638958;
        bh=I9uZ8hXLc/MlYco2PPW7ucH9aDZgy60wNQLA9o6/xXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mGuwCa+PjuoYh13mZdZn63GaEJsteSrTx54Lk2i5EczZrgeyUwBCZ12cTqObMdaAr
         KUaCUNWuEXKee2Oxein5wLZLKzqBluKnjQJdWC+upunlkErpnS4f34kihdKHil+dtf
         mDt4EwNRiauyTU2PbVMTU1wTLsXOQyp9NaiSNrtbhPxNkysWNnu9F3HUhI3FXCoZ/r
         MWtS5JhTbiizynFM4OsSQ+fPfT7f5pCO463zDh1LT8hd3OYesJpN/0vMBIUNHniQqP
         O7p29GTSb2XuefqWz/EOzk71U/vvAwqZuQV1UmoZECN9n+BV0m13UEse1YpX3o/xpp
         MCw1cd0/e+BCw==
Date:   Tue, 26 Jan 2021 07:29:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210126052914.GN579511@unreal>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210124134551.GB5038@unreal>
 <20210125132834.GK4147@nvidia.com>
 <2072c76154cd4232b78392c650b2b2bf@intel.com>
 <5b3f609d-034a-826f-1e50-0a5f8ad8406e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b3f609d-034a-826f-1e50-0a5f8ad8406e@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 05:01:40PM -0800, Jacob Keller wrote:
>
>
> On 1/25/2021 4:39 PM, Saleem, Shiraz wrote:
> >> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> >> implement private channel OPs
> >>
> >> On Sun, Jan 24, 2021 at 03:45:51PM +0200, Leon Romanovsky wrote:
> >>> On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
> >>>> From: Mustafa Ismail <mustafa.ismail@intel.com>
> >>>>
> >>>> Register irdma as an auxiliary driver which can attach to auxiliary
> >>>> RDMA devices from Intel PCI netdev drivers i40e and ice. Implement
> >>>> the private channel ops, add basic devlink support in the driver and
> >>>> register net notifiers.
> >>>
> >>> Devlink part in "the RDMA client" is interesting thing.
> >>>
> >>> The idea behind auxiliary bus was that PCI logic will stay at one
> >>> place and devlink considered as the tool to manage that.
> >>
> >> Yes, this doesn't seem right, I don't think these auxiliary bus objects should have
> >> devlink instances, or at least someone from devlink land should approve of the
> >> idea.
> >>
> >
> > In our model, we have one auxdev (for RDMA) per PCI device function owned by netdev driver
> > and one devlink instance per auxdev. Plus there is an Intel netdev driver for each HW generation.
> > Moving the devlink logic to the PCI netdev driver would mean duplicating the same set of RDMA
> > params in each Intel netdev driver. Additionally, plumbing RDMA specific params in the netdev
> > driver sort of seems misplaced to me.
> >
>
> I agree that plumbing these parameters at the PCI side in the devlink of
> the parent device is weird. They don't seem to be parameters that the
> parent driver cares about.
>
> Maybe there is another mechanism that makes more sense? To me it is a
> bit like if we were plumbing netdev specific paramters into devlink
> instead of trying to expose them through netdevice specific interfaces
> like iproute2 or ethtool.

I'm far from being expert in devlink, but for me separation is following:
1. devlink - operates on physical device level, when PCI device already initialized.
2. ethtool - changes needed to be done on netdev layer.
3. ip - upper layer of the netdev
4. rdmatool - RDMA specific when IB device already exists.

And the ENABLE_ROCE/ENABLE_RDMA thing shouldn't be in the RDMA driver at
all, because it is physical device property which once toggled will
prohibit creation of respective aux device.

Thanks
