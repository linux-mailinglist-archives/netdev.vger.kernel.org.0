Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5E513DE8
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 08:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfEEG2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 02:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbfEEG2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 02:28:49 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F12220644;
        Sun,  5 May 2019 06:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557037727;
        bh=MdPpVfEbe2rIlXFICRizBGJh3Cmhzu8vV5pSJ/5rgpY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w19skL2t/X8m0ixk8fYQGe3W2CmqtPIre/1mdhAg+ydPnsvxxk0UcjPR5uc64By0K
         FK3a81KyrWq15jIxBO8cAHFiX+gAXoxTj0RuYqxHlTMKT7SHqseP/jRr+Vusp8NanK
         DmipEnctNaX84//tnhXOzbXiqidXi5Co7Uf37H7w=
Date:   Sun, 5 May 2019 09:28:44 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Moni Shoua <monis@mellanox.com>
Subject: Re: [net-next][PATCH v2 1/2] rds: handle unsupported rdma request to
 fs dax memory
Message-ID: <20190505062844.GB6938@mtr-leonro.mtl.com>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-2-git-send-email-santosh.shilimkar@oracle.com>
 <20190501074415.GB7676@mtr-leonro.mtl.com>
 <2829f9d8-0383-d141-46c3-f2a09cd542b2@oracle.com>
 <20190502062120.GM7676@mtr-leonro.mtl.com>
 <b7781380-e85b-78b4-f89e-1e627e213896@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7781380-e85b-78b4-f89e-1e627e213896@oracle.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 02, 2019 at 10:52:23AM -0700, Santosh Shilimkar wrote:
> On 5/1/2019 11:21 PM, Leon Romanovsky wrote:
> > On Wed, May 01, 2019 at 10:54:00AM -0700, Santosh Shilimkar wrote:
> > > On 5/1/2019 12:44 AM, Leon Romanovsky wrote:
> > > > On Mon, Apr 29, 2019 at 04:37:19PM -0700, Santosh Shilimkar wrote:
> > > > > From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > > > >
> > > > > RDS doesn't support RDMA on memory apertures that require On Demand
> > > > > Paging (ODP), such as FS DAX memory. User applications can try to use
> > > > > RDS to perform RDMA over such memories and since it doesn't report any
> > > > > failure, it can lead to unexpected issues like memory corruption when
> > > > > a couple of out of sync file system operations like ftruncate etc. are
> > > > > performed.
> > > > >
> > > > > The patch adds a check so that such an attempt to RDMA to/from memory
> > > > > apertures requiring ODP will fail.
> > > > >
> > > > > Reviewed-by: H??kon Bugge <haakon.bugge@oracle.com>
> > > > > Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> > > > > Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > > > > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> > > > > ---
> > > > >    net/rds/rdma.c | 5 +++--
> > > > >    1 file changed, 3 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> > > > > index 182ab84..e0a6b72 100644
> > > > > --- a/net/rds/rdma.c
> > > > > +++ b/net/rds/rdma.c
> > > > > @@ -158,8 +158,9 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
> > > > >    {
> > > > >    	int ret;
> > > > >
> > > > > -	ret = get_user_pages_fast(user_addr, nr_pages, write, pages);
> > > > > -
> > > > > +	/* get_user_pages return -EOPNOTSUPP for fs_dax memory */
> > > > > +	ret = get_user_pages_longterm(user_addr, nr_pages,
> > > > > +				      write, pages, NULL);
> > > >
> > > > I'm not RDS expert, but from what I see in net/rds/rdma.c and this code,
> > > > you tried to mimic ib_umem_get() without protection, checks and native
> > > > ODP, FS and DAX supports.
> > > >
> > > > The real way to solve your ODP problem will require to extend
> > > > ib_umem_get() to work for kernel ULPs too and use it instead of
> > > > get_user_pages(). We are working on that and it is in internal review now.
> > > >
> > > Yes am aware of it. For FS_DAX like memory,  get_user_pages_longterm()
> > > fails and then using ib_reg_user_mr() the memory is registered as
> > > ODP regsion. This work is not ready yet and without above check,
> > > one can do RDMA on FS DAX memory with Fast Reg or FMR memory
> > > registration which is not safe and hence need to fail the operation.
> > >
> > > Once the support is added to RDS, this code path will make that
> > > registration go through.
> > >
> > > Hope it clarifies.
> >
> > Only partial, why don't you check if user asked ODP through verbs
> > interface and return EOPNOTSUPP in such case?
> >
> I think you are mixing two separate things. ODP is just one way of
> supporting RDMA on FS DAX memory. Tomorrow, some other mechanism
> can be used as well. RDS is just using inbuilt kernel mm API
> to find out if its FS DAX memory(get_user_pages_longterm).
> Current code will make RDS get_mr fail if RDS application issues
> memory registration request on FS DAX memory and in future when
> support gets added, it will do the ODP registration and return
> the key.

But we are talking about kernel code only, right?
Future support will be added if it exists.

>
> > It will ensure that once your code will support ODP properly written
> > applications will work with/without ODP natively.
> >
> Application shouldn't care if RDS ULP internally uses ODP
> or some other mechanism to support RDMA on FS DAX memory.
> This makes it transparent it to RDS application.

ODP checks need to be internal to kernel, user won't see those ODP
checks.

Thanks

>
> Regards,
> Santosh
