Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22D31B1AB6
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 02:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDUA3o convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Apr 2020 20:29:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:44559 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgDUA3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 20:29:44 -0400
IronPort-SDR: OvVK+plTFZ62uS1tKTeVnv2oTmbQ3942D4ji6d5/rfZ+4PnKlsie6fkIONNo7tE+gmcp0vYfQw
 nAw4mw6cS0rA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 17:29:44 -0700
IronPort-SDR: SzZmwwagHYDY8kTucYUCUK2k/o2rPtsQlDZh+BByhEpPRTYIwFMp+jyoE2+NSFaf8UvUr3d+lm
 H5nGwygFU+jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="258527862"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga006.jf.intel.com with ESMTP; 20 Apr 2020 17:29:43 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.70]) by
 FMSMSX108.amr.corp.intel.com ([169.254.9.13]) with mapi id 14.03.0439.000;
 Mon, 20 Apr 2020 17:29:43 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [RFC PATCH v5 09/16] RDMA/irdma: Implement device supported
 verb APIs
Thread-Topic: [RFC PATCH v5 09/16] RDMA/irdma: Implement device supported
 verb APIs
Thread-Index: AQHWFNtxOKnxm7SxOkGbTv2AkbFNkah+MQgAgAQg5jA=
Date:   Tue, 21 Apr 2020 00:29:43 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7DCD485DF@fmsmsx124.amr.corp.intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-10-jeffrey.t.kirsher@intel.com>
 <20200417195928.GE3083@unreal>
In-Reply-To: <20200417195928.GE3083@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC PATCH v5 09/16] RDMA/irdma: Implement device supported
> verb APIs
> 
> On Fri, Apr 17, 2020 at 10:12:44AM -0700, Jeff Kirsher wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Implement device supported verb APIs. The supported APIs vary based on
> > the underlying transport the ibdev is registered as (i.e. iWARP or
> > RoCEv2).
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
> >  drivers/infiniband/hw/irdma/verbs.c     | 4555 +++++++++++++++++++++++
> >  drivers/infiniband/hw/irdma/verbs.h     |  213 ++
> >  include/uapi/rdma/ib_user_ioctl_verbs.h |    1 +
> >  3 files changed, 4769 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/irdma/verbs.c
> >  create mode 100644 drivers/infiniband/hw/irdma/verbs.h
> 
> <...>
> 
> > +static int irdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata
> > +*udata) {
> > +	struct irdma_qp *iwqp = to_iwqp(ibqp);
> > +
> > +	iwqp->destroyed = 1;
> > +	if (iwqp->ibqp_state >= IB_QPS_INIT && iwqp->ibqp_state <
> IB_QPS_RTS)
> > +		irdma_next_iw_state(iwqp, IRDMA_QP_STATE_ERROR, 0, 0, 0);
> > +
> > +	if (!iwqp->user_mode) {
> > +		if (iwqp->iwscq) {
> > +			irdma_clean_cqes(iwqp, iwqp->iwscq);
> > +			if (iwqp->iwrcq != iwqp->iwscq)
> > +				irdma_clean_cqes(iwqp, iwqp->iwrcq);
> > +		}
> > +	}
> > +
> > +	irdma_remove_push_mmap_entries(iwqp);
> > +	irdma_free_lsmm_rsrc(iwqp);
> > +	irdma_rem_ref(&iwqp->ibqp);
> 
> No, please ensure that call to destroy_qp is kfree QP without any need in reference
> counting. We need this to move QP allocation to be IB/core responsibility. I hope
> that all other verbs objects (with MR as
> exception) follow the same pattern: create->kzalloc->destroy>kfree.

Yes. I did see the other verb objects allocation move to IB core
responsibility but not QP. Since we are headed in that direction,
I do think it's a reasonable expectation to make destroy QP
synchronous in providers. We ll look to change it in next rev.

Thank you Leon for taking the time to review and provide
feedback.

Shiraz
