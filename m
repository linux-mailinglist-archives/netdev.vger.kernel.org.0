Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FE6348BD4
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhCYIqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhCYIpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 04:45:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6734F619F3;
        Thu, 25 Mar 2021 08:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616661951;
        bh=8FTkRCLDyoEVtkmGm03ZpFYFgZFnI9eioa+y3ybKPeE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jhGQS+O/q2JI2GWuQvnwkgI03j70tSQMzhPhwB0fptitO5HsF9wV3Mopk7lU2jk+b
         A+8dHSZ1MKzZsJJI5BRvi1qu0o5t8ibJ6ZUXLEa2xJ47+YMekfqoNLuqbgP78w+tVD
         hUgsvRvfjFmmyUW0jS6pJpzes6T0rJhcrNTktZS+dAvu9tYStNI4Nkpz5Og4/YEFET
         YIQUGxtr/nyIovSmmRNVLUhi8ZGZyR1re6WFTjgwvR0aTO8TFOU4KdFIhn3Obgbf2B
         fqFBCgO8IHc7giWIBry29H0C835HkRRBU9pEJYmLll61TV+kF4iTzblA18UdC9PG1E
         nzprcNoLxGGPA==
Date:   Thu, 25 Mar 2021 10:45:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: Re: [PATCH v2 08/23] RDMA/irdma: Register auxiliary driver and
 implement private channel OPs
Message-ID: <YFxNu0Zx38IXk4rb@unreal>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
 <20210324000007.1450-9-shiraz.saleem@intel.com>
 <YFtC9hWHYiCR9vIC@unreal>
 <20210324140046.GA481507@nvidia.com>
 <YFtJ8EraVBJsYjuT@unreal>
 <20210324143509.GB481507@nvidia.com>
 <cc3dfb411c2248fdb3a5adc042d22893@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc3dfb411c2248fdb3a5adc042d22893@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 11:46:42PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH v2 08/23] RDMA/irdma: Register auxiliary driver and
> > implement private channel OPs
> > 
> > On Wed, Mar 24, 2021 at 04:17:20PM +0200, Leon Romanovsky wrote:
> > > On Wed, Mar 24, 2021 at 11:00:46AM -0300, Jason Gunthorpe wrote:
> > > > On Wed, Mar 24, 2021 at 03:47:34PM +0200, Leon Romanovsky wrote:
> > > > > On Tue, Mar 23, 2021 at 06:59:52PM -0500, Shiraz Saleem wrote:
> > > > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > >
> > > > > > Register auxiliary drivers which can attach to auxiliary RDMA
> > > > > > devices from Intel PCI netdev drivers i40e and ice. Implement
> > > > > > the private channel ops, and register net notifiers.
> > > > > >
> > > > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > > > drivers/infiniband/hw/irdma/i40iw_if.c | 229 +++++++++++++
> > > > > >  drivers/infiniband/hw/irdma/main.c     | 382 ++++++++++++++++++++++
> > > > > >  drivers/infiniband/hw/irdma/main.h     | 565
> > +++++++++++++++++++++++++++++++++
> > > > > >  3 files changed, 1176 insertions(+)  create mode 100644
> > > > > > drivers/infiniband/hw/irdma/i40iw_if.c
> > > > > >  create mode 100644 drivers/infiniband/hw/irdma/main.c
> > > > > >  create mode 100644 drivers/infiniband/hw/irdma/main.h
> > > > >
> > > > > <...>
> > > > >
> > > > > > +/* client interface functions */ static const struct
> > > > > > +i40e_client_ops i40e_ops = {
> > > > > > +	.open = i40iw_open,
> > > > > > +	.close = i40iw_close,
> > > > > > +	.l2_param_change = i40iw_l2param_change };
> > > > > > +
> > > > > > +static struct i40e_client i40iw_client = {
> > > > > > +	.ops = &i40e_ops,
> > > > > > +	.type = I40E_CLIENT_IWARP,
> > > > > > +};
> > > > > > +
> > > > > > +static int i40iw_probe(struct auxiliary_device *aux_dev, const
> > > > > > +struct auxiliary_device_id *id) {
> > > > > > +	struct i40e_auxiliary_device *i40e_adev = container_of(aux_dev,
> > > > > > +							       struct
> > i40e_auxiliary_device,
> > > > > > +							       aux_dev);
> > > > > > +	struct i40e_info *cdev_info = i40e_adev->ldev;
> > > > > > +
> > > > > > +	strncpy(i40iw_client.name, "irdma", I40E_CLIENT_STR_LENGTH);
> > > > > > +	cdev_info->client = &i40iw_client;
> > > > > > +	cdev_info->aux_dev = aux_dev;
> > > > > > +
> > > > > > +	return cdev_info->ops->client_device_register(cdev_info);
> > > > >
> > > > > Why do we need all this indirection? I see it as leftover from
> > > > > previous version where you mixed auxdev with your peer registration logic.
> > > >
> > > > I think I said the new stuff has to be done sanely, but the i40iw
> > > > stuff is old and already like this.
> > >
> > > They declared this specific "ops" a couple of lines above and all the
> > > functions are static. At least for the new code, in the irdma, this "ops"
> > > thing is not needed.
> > 
> > It is the code in the 'core' i40iw driver that requries this, AFAICT
> > 
>  Yes.

It is worth to fix.

Thanks
