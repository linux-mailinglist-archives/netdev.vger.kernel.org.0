Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE314C0FEA
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 08:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfI1GAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 02:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725263AbfI1GAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Sep 2019 02:00:36 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40C342081B;
        Sat, 28 Sep 2019 06:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569650436;
        bh=vme6/jAMbcwv00vmJFNWcY1fDi3aFHpqvBkw0DKLf04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kOiIpgvRUboTTxj8/O7CzeZVehsfokWe2W/UttvBguJouBiEXgpwdeR7eGGYLsvIW
         72g5WmRODXVgeWpWakE841XhIGIhf7aPidSLmT9QdmTAuPal6V4A+yzfp6VsecTrrN
         hsNubj/ejOIwl3tWzCr9J8GSA1dnarUSDb/a+Oqg=
Date:   Sat, 28 Sep 2019 09:00:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
Message-ID: <20190928060032.GJ14368@unreal>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-13-jeffrey.t.kirsher@intel.com>
 <20190926173710.GC14368@unreal>
 <9DD61F30A802C4429A01CA4200E302A7AC702BEA@fmsmsx123.amr.corp.intel.com>
 <20190927045029.GG14368@unreal>
 <9DD61F30A802C4429A01CA4200E302A7AC70468F@fmsmsx123.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7AC70468F@fmsmsx123.amr.corp.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 02:28:41PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
> >
> > On Thu, Sep 26, 2019 at 07:49:52PM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [RFC 12/20] RDMA/irdma: Implement device supported verb
> > > > APIs
> > > >
> > > > On Thu, Sep 26, 2019 at 09:45:11AM -0700, Jeff Kirsher wrote:
> > > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > >
> > > > > Implement device supported verb APIs. The supported APIs vary
> > > > > based on the underlying transport the ibdev is registered as (i.e.
> > > > > iWARP or RoCEv2).
> > > > >
> > > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > > ---
> > > > >  drivers/infiniband/hw/irdma/verbs.c      | 4346 ++++++++++++++++++++++
> > > > >  drivers/infiniband/hw/irdma/verbs.h      |  199 +
> > > > >  include/uapi/rdma/rdma_user_ioctl_cmds.h |    1 +
> > > > >  3 files changed, 4546 insertions(+)  create mode 100644
> > > > > drivers/infiniband/hw/irdma/verbs.c
> > > > >  create mode 100644 drivers/infiniband/hw/irdma/verbs.h
> > > > >
> > > > > diff --git a/drivers/infiniband/hw/irdma/verbs.c
> > > > > b/drivers/infiniband/hw/irdma/verbs.c
> > > > > new file mode 100644
> > > > > index 000000000000..025c21c722e2
> > > > > --- /dev/null
> > > > > +++ b/drivers/infiniband/hw/irdma/verbs.c
> > > > > @@ -0,0 +1,4346 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > > > > +/* Copyright (c) 2019, Intel Corporation. */
> > > >
> > > > <...>
> > > >
> > > > > +
> > > > > +	size = sqdepth * sizeof(struct irdma_sq_uk_wr_trk_info) +
> > > > > +	       (rqdepth << 3);
> > > > > +	iwqp->kqp.wrid_mem = kzalloc(size, GFP_KERNEL);
> > > > > +	if (!iwqp->kqp.wrid_mem)
> > > > > +		return -ENOMEM;
> > > > > +
> > > > > +	ukinfo->sq_wrtrk_array = (struct irdma_sq_uk_wr_trk_info *)
> > > > > +				 iwqp->kqp.wrid_mem;
> > > > > +	if (!ukinfo->sq_wrtrk_array)
> > > > > +		return -ENOMEM;
> > > >
> > > > You are leaking resources here, forgot to do proper error unwinding.
> > > >
> > >
> > > irdma_free_qp_rsrc() will free up that memory in case of an error.
> >
> > I'm talking about kqp.wrid_mem you allocated a couple of lines above and didn't
> > free in case of sq_wrtrk_array allocation failed.
> >
> Yes, I am referring to kqp.wrid_mem as well
> In case of err, all memory resources setup for
> the QP is freed in the common utility irdma_free_qp_rsrc()
> including the kqp.wrid_mem.

I see it as an anti-pattern, you have function to setup and it shouldn't
return half initialized state and rely on some other function to clean
the mess.

Current code is written in a way that makes very hard to check for
unwinding errors.

Thanks
