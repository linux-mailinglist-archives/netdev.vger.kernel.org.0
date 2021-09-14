Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A823B40A42A
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 05:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238399AbhINDL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 23:11:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238376AbhINDL2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 23:11:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDEC960E90;
        Tue, 14 Sep 2021 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631589011;
        bh=OBSvTK9Mvwq13+v31xdl+LwtoLoV9Tl+58u1TVDdvc4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NDtBMryApIiBpCUNt/v5qt5jXAIaf/mUpfl0xAdPm0ysnZ7p+FJuoOVvSiu0JWVxR
         Ji3hqjupI/WBTs1ioh6d3c4zm3c7veFU8x3Y0WNJBsFwRL8VCl0ONcyjOwFCOt+7DW
         fM3XdyVwZhj6AZ0NNkkvnBJzoGiFfMEQPpy5xt89ZXaPQ+/UfizMbNayBXdL26+aJu
         Qp/tJbZcJqNcw97+8OmgmwIHLaHjYTHcv5rTR7Ftwqir/jQ+tHqZnE57zQABLBcH4a
         SVhTVRWSzW/HjwE1LDAw5vIBY2eYYC4Gs0OZBJbuaRD5p1Rucn2jTxGMKL1JtQTUq5
         8GIyOWLRMw2Qg==
Date:   Tue, 14 Sep 2021 06:10:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Ertman, David M" <david.m.ertman@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "yongxin.liu@windriver.com" <yongxin.liu@windriver.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Singhai, Anjali" <anjali.singhai@intel.com>,
        "Parikh, Neerav" <neerav.parikh@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: Re: [PATCH RESEND net] ice: Correctly deal with PFs that do not
 support RDMA
Message-ID: <YUASj03w0RMunvCa@unreal>
References: <20210909151223.572918-1-david.m.ertman@intel.com>
 <YTsjDsFbBggL2X/8@unreal>
 <4bc2664ac89844a79242339f5e971335@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bc2664ac89844a79242339f5e971335@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 03:49:43PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH RESEND net] ice: Correctly deal with PFs that do not
> > support RDMA
> > 
> > On Thu, Sep 09, 2021 at 08:12:23AM -0700, Dave Ertman wrote:
> > > There are two cases where the current PF does not support RDMA
> > > functionality.  The first is if the NVM loaded on the device is set to
> > > not support RDMA (common_caps.rdma is false).  The second is if the
> > > kernel bonding driver has included the current PF in an active link
> > > aggregate.
> > >
> > > When the driver has determined that this PF does not support RDMA,
> > > then auxiliary devices should not be created on the auxiliary bus.
> > 
> > This part is wrong, auxiliary devices should always be created, in your case it will
> > be one eth device only without extra irdma device.
> 
> It is worth considering having an eth aux device/driver but is it a hard-and-fast rule?
> In this case, the RDMA-capable PCI network device spawns an auxiliary device for RDMA
> and the core driver is a network driver.
> 
> > 
> > Your "bug" is that you mixed auxiliary bus devices with "regular" ones and created
> > eth device not as auxiliary one. This is why you are calling to auxiliary_device_init()
> > for RDMA only and fallback to non-auxiliary mode.
> 
> It's a design choice on how you carve out function(s) off your PCI core device to be
> managed by auxiliary driver(s) and not a bug.

I'm not the one who is setting rules, just explaining what is wrong with
the current design and proposed solution.

The driver/core design expects three building blocks: logic that
enumerates (creates) devices, bus that connects those devices
(load/unload drivers) and specific drivers for every such device.

Such separation allows clean view from locking perspective (separated
devices), proper sysfs layout and same logic for the user space tools.

In your case, you connected ethernet driver to be "enumerator" and
replaced (duplicated) general driver/core logic that decides if to load
or not auxiliary device driver with your custom code.

Thanks

> 
> Shiraz
