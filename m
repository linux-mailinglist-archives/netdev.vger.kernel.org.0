Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E1511C856
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 09:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbfLLIjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 03:39:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728110AbfLLIjI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 03:39:08 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE88214AF;
        Thu, 12 Dec 2019 08:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576139947;
        bh=cqSA+BBmuxnW0DeRg7wYxrHXTet8s8DkuXKihlBn1Po=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Indm809ScNJyXc0kbJaplRDJr8tIkaaOO45qAUSVozv1GCYaTtXHi1AplY/nRX34D
         0X/v0vJVMF386dGYqlQ/oYhwY7oDeMwHo2GQnYYEHrW7KG+62kRlVujGI1uMTRf7jB
         dNjITeHekpyXpMziKBbEBnY/Gsu65aAElsw1E6n8=
Date:   Thu, 12 Dec 2019 10:39:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>
Subject: Re: [PATCH v3 05/20] RDMA/irdma: Add driver framework definitions
Message-ID: <20191212083904.GT67461@unreal>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-6-jeffrey.t.kirsher@intel.com>
 <20191210190438.GF46@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7B6B8FBCA@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7B6B8FBCA@fmsmsx124.amr.corp.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 01:40:27AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH v3 05/20] RDMA/irdma: Add driver framework definitions

<...>

> >
> > > +		ldev->ops->reg_for_notification(ldev, &events);
> > > +	dev_info(rfdev_to_dev(dev), "IRDMA VSI Open Successful");
> >
> > Lets not do this kind of logging..
> >
>
> There is some dev_info which should be cleaned up to dev_dbg.
> But logging this info is useful to know that this functions VSI (and associated ibdev)
> is up and reading for RDMA traffic.
> Is info logging to be avoided altogether?

Will function tracer (ftrace) output be sufficient here?
https://www.kernel.org/doc/html/latest/trace/ftrace.html

>
> > > +static void irdma_close(struct iidc_peer_dev *ldev, enum
> > > +iidc_close_reason reason) {
> > > +	struct irdma_device *iwdev;
> > > +	struct irdma_pci_f *rf;
> > > +
> > > +	iwdev = irdma_get_device(ldev->netdev);
> > > +	if (!iwdev)
> > > +		return;
> > > +
> > > +	irdma_put_device(iwdev);
> > > +	rf = iwdev->rf;
> > > +	if (reason == IIDC_REASON_GLOBR_REQ || reason ==
> > IIDC_REASON_CORER_REQ ||
> > > +	    reason == IIDC_REASON_PFR_REQ || rf->reset) {
> > > +		iwdev->reset = true;
> > > +		rf->reset = true;
> > > +	}
> > > +
> > > +	if (iwdev->init_state >= CEQ0_CREATED)
> > > +		irdma_deinit_rt_device(iwdev);
> > > +
> > > +	kfree(iwdev);
> >
> > Mixing put and kfree? So confusing. Why are there so many structs and so much
> > indirection? Very hard to understand if this is right or not.
>
> This does look weird. I think the irdma_get_device() was here
> just to get to iwdev. And put_device is releasing the refcnt immediately.
> Since we are in a VSI close(), we should not need to take refcnt on ibdev
> and just deregister it. Will fix this.
>
> >
> > > new file mode 100644
> > > index 000000000000..b418e76a3302
> > > +++ b/drivers/infiniband/hw/irdma/main.c
> > > @@ -0,0 +1,630 @@
> > > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > > +/* Copyright (c) 2015 - 2019 Intel Corporation */ #include "main.h"
> > > +
> > > +/* Legacy i40iw module parameters */
> > > +static int resource_profile;
> > > +module_param(resource_profile, int, 0644);
> > > +MODULE_PARM_DESC(resource_profile, "Resource Profile: 0=PF only,
> > > +1=Weighted VF, 2=Even Distribution");
> > > +
> > > +static int max_rdma_vfs = 32;
> > > +module_param(max_rdma_vfs, int, 0644);
> > MODULE_PARM_DESC(max_rdma_vfs,
> > > +"Maximum VF count: 0-32 32=default");
> > > +
> > > +static int mpa_version = 2;
> > > +module_param(mpa_version, int, 0644); MODULE_PARM_DESC(mpa_version,
> > > +"MPA version: deprecated parameter");
> > > +
> > > +static int push_mode;
> > > +module_param(push_mode, int, 0644);
> > > +MODULE_PARM_DESC(push_mode, "Low latency mode: deprecated
> > > +parameter");
> > > +
> > > +static int debug;
> > > +module_param(debug, int, 0644);
> > > +MODULE_PARM_DESC(debug, "debug flags: deprecated parameter");
> >
> > Generally no to module parameters
>
> Agree. But these are module params that existed in i40iw.
> And irdma replaces i40iw and has a module alias
> for it.

Maybe use this opportunity and ditch "deprecated" module parameters?

Thanks
