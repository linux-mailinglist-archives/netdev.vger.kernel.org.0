Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82241353C84
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 10:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbhDEIrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 04:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232587AbhDEIrB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 04:47:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 112ED61398;
        Mon,  5 Apr 2021 08:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617612415;
        bh=lh5iHkLIHcRhEVH5XgYdg8sTt1UzoPbx65v8pw6Y5os=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VRA/3qDRVrIAhd+CiPu8CKTnPViEofn49SLE9Wa1IaH8nbqg/zQ0rULUpz9NLpkeM
         NoRFqOHDhmIUR6DDTapE2yJ5AgydustWv8RrKELvfsAxCWqBFqNIPVFBmcQQo+gHeZ
         dIw/VdNitNAxmCAPgH27T44Jw26gnhoW8z0WWN8m/pzLy4wgFAUh6W4UX0KBE2KnHS
         lVYFQGqSv4vzzOjH1cCcWvFsteAViL/N/aCgpWnJXyitMan9wD+8/5JfuXX2OLuzHU
         5Y0yTIR7uoxqErJaN580bgR4+cC2R/iXVqXpmI9VMziEBXKEgItdtDoIQz9QAc9cpa
         eKCZoO0YPki7w==
Date:   Mon, 5 Apr 2021 11:46:52 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH rdma-next 1/8] RDMA/core: Check if client supports IB
 device or not
Message-ID: <YGrOfCjtTLdwsElz@unreal>
References: <20210405055000.215792-1-leon@kernel.org>
 <20210405055000.215792-2-leon@kernel.org>
 <43f5eb80-55b9-722b-1006-23d823108eb1@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43f5eb80-55b9-722b-1006-23d823108eb1@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 09:20:32AM +0300, Gal Pressman wrote:
> On 05/04/2021 8:49, Leon Romanovsky wrote:
> > From: Parav Pandit <parav@nvidia.com>
> > 
> > RDMA devices are of different transport(iWarp, IB, RoCE) and have
> > different attributes.
> > Not all clients are interested in all type of devices.
> > 
> > Implement a generic callback that each IB client can implement to decide
> > if client add() or remove() should be done by the IB core or not for a
> > given IB device, client combination.
> > 
> > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/infiniband/core/device.c | 3 +++
> >  include/rdma/ib_verbs.h          | 9 +++++++++
> >  2 files changed, 12 insertions(+)
> > 
> > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> > index c660cef66ac6..c9af2deba8c1 100644
> > --- a/drivers/infiniband/core/device.c
> > +++ b/drivers/infiniband/core/device.c
> > @@ -691,6 +691,9 @@ static int add_client_context(struct ib_device *device,
> >  	if (!device->kverbs_provider && !client->no_kverbs_req)
> >  		return 0;
> >  
> > +	if (client->is_supported && !client->is_supported(device))
> > +		return 0;
> 
> Isn't it better to remove the kverbs_provider flag (from previous if statement)
> and unify it with this generic support check?

I thought about it, but didn't find it worth. The kverbs_provider needs
to be provided by device and all ULPs except uverbs will have the same check.

Thanks
