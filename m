Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041721B1FA4
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 09:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgDUHQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 03:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgDUHQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 03:16:23 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 919C92074B;
        Tue, 21 Apr 2020 07:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587453383;
        bh=zm0TfsmGcC6PBFnKL4A2J+wsiYw2A0UW6BGM1EQTjvs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VornwpBW9vZzCNqvtmt3dsxRJe1m4ZIbj7quOJdDoAcxN2RQPG8U5ZGXvWVS3CR9x
         PPkDcm0w6+7UMZE57VVztkaHv4uKwboW2r4ZxtVniRuK11UhiMBJP7Fnl6TQVFyl+9
         W/jjVhCMkiyxdsOjPv9Jdk3oLkcIyfbRQqwKnbXA=
Date:   Tue, 21 Apr 2020 10:16:19 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [RFC PATCH v5 09/16] RDMA/irdma: Implement device supported verb
 APIs
Message-ID: <20200421071619.GG121146@unreal>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-10-jeffrey.t.kirsher@intel.com>
 <20200417195928.GE3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD485DF@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7DCD485DF@fmsmsx124.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 12:29:43AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC PATCH v5 09/16] RDMA/irdma: Implement device supported
> > verb APIs
> >
> > On Fri, Apr 17, 2020 at 10:12:44AM -0700, Jeff Kirsher wrote:
> > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > >
> > > Implement device supported verb APIs. The supported APIs vary based on
> > > the underlying transport the ibdev is registered as (i.e. iWARP or
> > > RoCEv2).
> > >
> > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > ---
> > >  drivers/infiniband/hw/irdma/verbs.c     | 4555 +++++++++++++++++++++++
> > >  drivers/infiniband/hw/irdma/verbs.h     |  213 ++
> > >  include/uapi/rdma/ib_user_ioctl_verbs.h |    1 +
> > >  3 files changed, 4769 insertions(+)
> > >  create mode 100644 drivers/infiniband/hw/irdma/verbs.c
> > >  create mode 100644 drivers/infiniband/hw/irdma/verbs.h
> >
> > <...>
> >
> > > +static int irdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata
> > > +*udata) {
> > > +	struct irdma_qp *iwqp = to_iwqp(ibqp);
> > > +
> > > +	iwqp->destroyed = 1;
> > > +	if (iwqp->ibqp_state >= IB_QPS_INIT && iwqp->ibqp_state <
> > IB_QPS_RTS)
> > > +		irdma_next_iw_state(iwqp, IRDMA_QP_STATE_ERROR, 0, 0, 0);
> > > +
> > > +	if (!iwqp->user_mode) {
> > > +		if (iwqp->iwscq) {
> > > +			irdma_clean_cqes(iwqp, iwqp->iwscq);
> > > +			if (iwqp->iwrcq != iwqp->iwscq)
> > > +				irdma_clean_cqes(iwqp, iwqp->iwrcq);
> > > +		}
> > > +	}
> > > +
> > > +	irdma_remove_push_mmap_entries(iwqp);
> > > +	irdma_free_lsmm_rsrc(iwqp);
> > > +	irdma_rem_ref(&iwqp->ibqp);
> >
> > No, please ensure that call to destroy_qp is kfree QP without any need in reference
> > counting. We need this to move QP allocation to be IB/core responsibility. I hope
> > that all other verbs objects (with MR as
> > exception) follow the same pattern: create->kzalloc->destroy>kfree.
>
> Yes. I did see the other verb objects allocation move to IB core
> responsibility but not QP. Since we are headed in that direction,
> I do think it's a reasonable expectation to make destroy QP
> synchronous in providers. We ll look to change it in next rev.

Thanks

>
> Thank you Leon for taking the time to review and provide
> feedback.
>
> Shiraz
