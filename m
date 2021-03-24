Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5784347A76
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbhCXORs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:17:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236117AbhCXOR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 10:17:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D94A060232;
        Wed, 24 Mar 2021 14:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616595444;
        bh=21DLN6zcpHqU2e0nnAHMIAyzk/GbTw2e3TuMQkrOkiM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kosb868gr2mt5xEGIJV2ubVpxKwsu5R2uHyPe6NBJJkWFkX+1e6ICJD5JpATQ4pvo
         NwV0BM7A9EDk43UM1QXXUbeYEkSv5HXtnur+TvZC31+fJ9k2jpz/ZUUG+SGIroVwQh
         jVhKO0vnLlAc8yhaU48lFrUivr4HLPDTXuHQ9Qgh+94nxTkx6aFy9dlbj1huL7KCfd
         xd0rMlIeBgIfrXLm9jIl06H8/ffWrGiwFC2+DXGfx3P5nE17cWIw+sUZKC8BbuvWlB
         1u5RwJo9XMRofLRqqeui3EcNkj96/lOWBiVlx9XoNd3dB8wYtObpm+Gd2+zyOHDRQg
         5lOB0PbDadabA==
Date:   Wed, 24 Mar 2021 16:17:20 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com,
        kuba@kernel.org, davem@davemloft.net, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH v2 08/23] RDMA/irdma: Register auxiliary driver and
 implement private channel OPs
Message-ID: <YFtJ8EraVBJsYjuT@unreal>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
 <20210324000007.1450-9-shiraz.saleem@intel.com>
 <YFtC9hWHYiCR9vIC@unreal>
 <20210324140046.GA481507@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324140046.GA481507@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 11:00:46AM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 24, 2021 at 03:47:34PM +0200, Leon Romanovsky wrote:
> > On Tue, Mar 23, 2021 at 06:59:52PM -0500, Shiraz Saleem wrote:
> > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > 
> > > Register auxiliary drivers which can attach to auxiliary RDMA
> > > devices from Intel PCI netdev drivers i40e and ice. Implement the private
> > > channel ops, and register net notifiers.
> > > 
> > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > >  drivers/infiniband/hw/irdma/i40iw_if.c | 229 +++++++++++++
> > >  drivers/infiniband/hw/irdma/main.c     | 382 ++++++++++++++++++++++
> > >  drivers/infiniband/hw/irdma/main.h     | 565 +++++++++++++++++++++++++++++++++
> > >  3 files changed, 1176 insertions(+)
> > >  create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
> > >  create mode 100644 drivers/infiniband/hw/irdma/main.c
> > >  create mode 100644 drivers/infiniband/hw/irdma/main.h
> > 
> > <...>
> > 
> > > +/* client interface functions */
> > > +static const struct i40e_client_ops i40e_ops = {
> > > +	.open = i40iw_open,
> > > +	.close = i40iw_close,
> > > +	.l2_param_change = i40iw_l2param_change
> > > +};
> > > +
> > > +static struct i40e_client i40iw_client = {
> > > +	.ops = &i40e_ops,
> > > +	.type = I40E_CLIENT_IWARP,
> > > +};
> > > +
> > > +static int i40iw_probe(struct auxiliary_device *aux_dev, const struct auxiliary_device_id *id)
> > > +{
> > > +	struct i40e_auxiliary_device *i40e_adev = container_of(aux_dev,
> > > +							       struct i40e_auxiliary_device,
> > > +							       aux_dev);
> > > +	struct i40e_info *cdev_info = i40e_adev->ldev;
> > > +
> > > +	strncpy(i40iw_client.name, "irdma", I40E_CLIENT_STR_LENGTH);
> > > +	cdev_info->client = &i40iw_client;
> > > +	cdev_info->aux_dev = aux_dev;
> > > +
> > > +	return cdev_info->ops->client_device_register(cdev_info);
> > 
> > Why do we need all this indirection? I see it as leftover from previous
> > version where you mixed auxdev with your peer registration logic.
> 
> I think I said the new stuff has to be done sanely, but the i40iw
> stuff is old and already like this.

They declared this specific "ops" a couple of lines above and all the
functions are static. At least for the new code, in the irdma, this "ops"
thing is not needed.

> 
> Though I would be happy to see this fixed too.
> 
> Jason
