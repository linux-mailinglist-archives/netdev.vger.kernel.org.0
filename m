Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C90DBFE45
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 06:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfI0Eue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 00:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfI0Eue (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 00:50:34 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A45720872;
        Fri, 27 Sep 2019 04:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569559833;
        bh=JVEnk9tinPjTGLJ3dFKeOM+IowNE8SvIlokdPK+hW08=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=anTuyJfN6AOmQhVHlw9SPneEDj1Tj+pbQ1vpXawgaSgXf4aWoBgdvS2/yh60NMv09
         FNq1528w7YOKKNiTtSzJTPxKX8pARpKLnK+i8G0UhntwZMJopXsvqDRdryGVDVYqXw
         NBYWTXRqdF5C92mU3Sh+1qzjGcke+6Y/xotNWtHA=
Date:   Fri, 27 Sep 2019 07:50:29 +0300
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
Message-ID: <20190927045029.GG14368@unreal>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-13-jeffrey.t.kirsher@intel.com>
 <20190926173710.GC14368@unreal>
 <9DD61F30A802C4429A01CA4200E302A7AC702BEA@fmsmsx123.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7AC702BEA@fmsmsx123.amr.corp.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 07:49:52PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
> >
> > On Thu, Sep 26, 2019 at 09:45:11AM -0700, Jeff Kirsher wrote:
> > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > >
> > > Implement device supported verb APIs. The supported APIs vary based on
> > > the underlying transport the ibdev is registered as (i.e. iWARP or
> > > RoCEv2).
> > >
> > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > ---
> > >  drivers/infiniband/hw/irdma/verbs.c      | 4346 ++++++++++++++++++++++
> > >  drivers/infiniband/hw/irdma/verbs.h      |  199 +
> > >  include/uapi/rdma/rdma_user_ioctl_cmds.h |    1 +
> > >  3 files changed, 4546 insertions(+)
> > >  create mode 100644 drivers/infiniband/hw/irdma/verbs.c
> > >  create mode 100644 drivers/infiniband/hw/irdma/verbs.h
> > >
> > > diff --git a/drivers/infiniband/hw/irdma/verbs.c
> > > b/drivers/infiniband/hw/irdma/verbs.c
> > > new file mode 100644
> > > index 000000000000..025c21c722e2
> > > --- /dev/null
> > > +++ b/drivers/infiniband/hw/irdma/verbs.c
> > > @@ -0,0 +1,4346 @@
> > > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > > +/* Copyright (c) 2019, Intel Corporation. */
> >
> > <...>
> >
> > > +
> > > +	size = sqdepth * sizeof(struct irdma_sq_uk_wr_trk_info) +
> > > +	       (rqdepth << 3);
> > > +	iwqp->kqp.wrid_mem = kzalloc(size, GFP_KERNEL);
> > > +	if (!iwqp->kqp.wrid_mem)
> > > +		return -ENOMEM;
> > > +
> > > +	ukinfo->sq_wrtrk_array = (struct irdma_sq_uk_wr_trk_info *)
> > > +				 iwqp->kqp.wrid_mem;
> > > +	if (!ukinfo->sq_wrtrk_array)
> > > +		return -ENOMEM;
> >
> > You are leaking resources here, forgot to do proper error unwinding.
> >
>
> irdma_free_qp_rsrc() will free up that memory in case of an error.

I'm talking about kqp.wrid_mem you allocated a couple of lines above and
didn't free in case of sq_wrtrk_array allocation failed.

Thanks
