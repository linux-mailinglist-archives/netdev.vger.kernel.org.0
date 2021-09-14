Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4C240A43D
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 05:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238695AbhINDRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 23:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237213AbhINDRs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 23:17:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7B8F60FDA;
        Tue, 14 Sep 2021 03:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631589391;
        bh=W34OXpHVI8IRqoH+2KbWo+deibUpb2mP6Uf99tWa4No=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mB7vh8JYTdszNKhX1AtKYJeTmLz/5PNBNlVrtfJOPtqWBHZdQH35u7eRwjErtD4iK
         E1iqgoA7/fk8BTgRM2awWB+DQ1lfjUwAbXMY+YKh0zstHRrzyf4WbKkEfuy5e5Shzx
         5FZnNuZBqrXEzkicJwoY3FX1Hx/ask4KDqJz64i1jYHgvdIIv0U2UjvtwVntKOmtmL
         OxpRXAybDUgS7Dk9Nr0WaijMocO+YNNYZTD8cCFaZcLe1qcOcHx3a3C13GYbul2vL8
         ERy40P4yJTJp1LPX4GilQ3E3uIzkIFhxoX7OmrkNvBIagAFD+3fhMsuYxU/NJ01kcj
         qTV7J47fU6V1g==
Date:   Tue, 14 Sep 2021 06:16:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
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
Message-ID: <YUAUC1AJP6JVMxBr@unreal>
References: <20210909151223.572918-1-david.m.ertman@intel.com>
 <YTsjDsFbBggL2X/8@unreal>
 <4bc2664ac89844a79242339f5e971335@intel.com>
 <PH0PR11MB49667F5B029D37D0E257A256DDD99@PH0PR11MB4966.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB49667F5B029D37D0E257A256DDD99@PH0PR11MB4966.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 04:07:28PM +0000, Ertman, David M wrote:
> > -----Original Message-----
> > From: Saleem, Shiraz <shiraz.saleem@intel.com>
> > Sent: Monday, September 13, 2021 8:50 AM
> > To: Leon Romanovsky <leon@kernel.org>; Ertman, David M
> > <david.m.ertman@intel.com>
> > Cc: davem@davemloft.net; kuba@kernel.org; yongxin.liu@windriver.com;
> > Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Brandeburg, Jesse
> > <jesse.brandeburg@intel.com>; intel-wired-lan@lists.osuosl.org; linux-
> > rdma@vger.kernel.org; jgg@ziepe.ca; Williams, Dan J
> > <dan.j.williams@intel.com>; Singhai, Anjali <anjali.singhai@intel.com>;
> > Parikh, Neerav <neerav.parikh@intel.com>; Samudrala, Sridhar
> > <sridhar.samudrala@intel.com>
> > Subject: RE: [PATCH RESEND net] ice: Correctly deal with PFs that do not
> > support RDMA
> > 
> > > Subject: Re: [PATCH RESEND net] ice: Correctly deal with PFs that do not
> > > support RDMA
> > >
> > > On Thu, Sep 09, 2021 at 08:12:23AM -0700, Dave Ertman wrote:
> > > > There are two cases where the current PF does not support RDMA
> > > > functionality.  The first is if the NVM loaded on the device is set to
> > > > not support RDMA (common_caps.rdma is false).  The second is if the
> > > > kernel bonding driver has included the current PF in an active link
> > > > aggregate.
> > > >
> > > > When the driver has determined that this PF does not support RDMA,
> > > > then auxiliary devices should not be created on the auxiliary bus.
> > >
> > > This part is wrong, auxiliary devices should always be created, in your case it
> > will
> > > be one eth device only without extra irdma device.
> > 
> > It is worth considering having an eth aux device/driver but is it a hard-and-
> > fast rule?
> > In this case, the RDMA-capable PCI network device spawns an auxiliary
> > device for RDMA
> > and the core driver is a network driver.
> > 
> > >
> > > Your "bug" is that you mixed auxiliary bus devices with "regular" ones and
> > created
> > > eth device not as auxiliary one. This is why you are calling to
> > auxiliary_device_init()
> > > for RDMA only and fallback to non-auxiliary mode.
> > 
> > It's a design choice on how you carve out function(s) off your PCI core device
> > to be
> > managed by auxiliary driver(s) and not a bug.
> > 
> > Shiraz
> 
> Also, regardless of whether netdev functionality is carved out into an auxiliary device or not, this code would still be necessary.

Right

> 
> We don't want to carve out an auxiliary device to support a functionality that the base PCI device does not support.  Not having
> the RDMA auxiliary device for an auxiliary driver to bind to is how we differentiate between devices that support RDMA and those
> that don't.

This is right too.

My complain is that you mixed enumerator logic with eth driver and
create auxiliary bus only if your RDMA device exists. It is wrong.

Thanks

> 
> Thanks,
> DaveE
> 
