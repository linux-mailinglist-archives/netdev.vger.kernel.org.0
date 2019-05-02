Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE521134B
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 08:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfEBGVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 02:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbfEBGVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 02:21:25 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 802CE2085A;
        Thu,  2 May 2019 06:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556778084;
        bh=U3VdY1Yu2Cf3cFUWAMwaV9luwZehJB6zJ3B9+GKYMFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vxyUYKwDbmjGwr9OUviOFKzl5lnBZ4p/umsxKLI4sV7Y5OA8NVoqIRB+y0VYAuQvi
         tkxNdPPYHlt/SEZz/ayNhAGqKUyXTLwRijQwPtyXDhhPoNjMgvN+rPe9u9xaef1jOL
         GphkqKVzhMhlWG+t6nYn0ZQv9KKuYKmtERbTfsR8=
Date:   Thu, 2 May 2019 09:21:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [net-next][PATCH v2 1/2] rds: handle unsupported rdma request to
 fs dax memory
Message-ID: <20190502062120.GM7676@mtr-leonro.mtl.com>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-2-git-send-email-santosh.shilimkar@oracle.com>
 <20190501074415.GB7676@mtr-leonro.mtl.com>
 <2829f9d8-0383-d141-46c3-f2a09cd542b2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2829f9d8-0383-d141-46c3-f2a09cd542b2@oracle.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 10:54:00AM -0700, Santosh Shilimkar wrote:
> On 5/1/2019 12:44 AM, Leon Romanovsky wrote:
> > On Mon, Apr 29, 2019 at 04:37:19PM -0700, Santosh Shilimkar wrote:
> > > From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > >
> > > RDS doesn't support RDMA on memory apertures that require On Demand
> > > Paging (ODP), such as FS DAX memory. User applications can try to use
> > > RDS to perform RDMA over such memories and since it doesn't report any
> > > failure, it can lead to unexpected issues like memory corruption when
> > > a couple of out of sync file system operations like ftruncate etc. are
> > > performed.
> > >
> > > The patch adds a check so that such an attempt to RDMA to/from memory
> > > apertures requiring ODP will fail.
> > >
> > > Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
> > > Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> > > Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> > > ---
> > >   net/rds/rdma.c | 5 +++--
> > >   1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> > > index 182ab84..e0a6b72 100644
> > > --- a/net/rds/rdma.c
> > > +++ b/net/rds/rdma.c
> > > @@ -158,8 +158,9 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
> > >   {
> > >   	int ret;
> > >
> > > -	ret = get_user_pages_fast(user_addr, nr_pages, write, pages);
> > > -
> > > +	/* get_user_pages return -EOPNOTSUPP for fs_dax memory */
> > > +	ret = get_user_pages_longterm(user_addr, nr_pages,
> > > +				      write, pages, NULL);
> >
> > I'm not RDS expert, but from what I see in net/rds/rdma.c and this code,
> > you tried to mimic ib_umem_get() without protection, checks and native
> > ODP, FS and DAX supports.
> >
> > The real way to solve your ODP problem will require to extend
> > ib_umem_get() to work for kernel ULPs too and use it instead of
> > get_user_pages(). We are working on that and it is in internal review now.
> >
> Yes am aware of it. For FS_DAX like memory,  get_user_pages_longterm()
> fails and then using ib_reg_user_mr() the memory is registered as
> ODP regsion. This work is not ready yet and without above check,
> one can do RDMA on FS DAX memory with Fast Reg or FMR memory
> registration which is not safe and hence need to fail the operation.
>
> Once the support is added to RDS, this code path will make that
> registration go through.
>
> Hope it clarifies.

Only partial, why don't you check if user asked ODP through verbs
interface and return EOPNOTSUPP in such case?

It will ensure that once your code will support ODP properly written
applications will work with/without ODP natively.

Thanks

>
> Regards,
> Santosh
>
