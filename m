Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F0309141
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 02:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhA3B0W convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Jan 2021 20:26:22 -0500
Received: from mga03.intel.com ([134.134.136.65]:34835 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232539AbhA3BVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 20:21:52 -0500
IronPort-SDR: ItGssPtja2wDUKH7wk40SkUZHIfe7g/juImXw4WhJsHLGWo7QCKkzFk54NgbsIuYAjbh7d4Cbx
 slqEuEpLG5Ew==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="180577612"
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="180577612"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 17:19:29 -0800
IronPort-SDR: I17f1/TDf/7XrSotbyUNb8d+gVe4yOtyBN3NVIRbFu42033mU3iK04fafdFwHWNxQm04IhAt0k
 NyrELWLOvxkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="574295389"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga005.jf.intel.com with ESMTP; 29 Jan 2021 17:19:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 29 Jan 2021 17:19:29 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 29 Jan 2021 17:19:28 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.002;
 Fri, 29 Jan 2021 17:19:28 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Index: AQHW8RlTrNE3qjtLukSnj7NcX24DDao5QQsAgAMVEvA=
Date:   Sat, 30 Jan 2021 01:19:28 +0000
Message-ID: <5210a664d5e94ea9968fc9b207a53d45@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125191622.GA1599720@nvidia.com>
In-Reply-To: <20210125191622.GA1599720@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> implement private channel OPs
> 
> On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
> 
> > +static int irdma_probe(struct auxiliary_device *aux_dev,
> > +		       const struct auxiliary_device_id *id) {
> > +	struct irdma_drvdata *drvdata;
> > +	int ret;
> > +
> > +	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
> > +	if (!drvdata)
> > +		return -ENOMEM;
> > +
> > +	switch (id->driver_data) {
> > +	case IRDMA_GEN_2:
> > +		drvdata->init_dev = irdma_init_dev;
> > +		drvdata->deinit_dev = irdma_deinit_dev;
> > +		break;
> > +	case IRDMA_GEN_1:
> > +		drvdata->init_dev = i40iw_init_dev;
> > +		drvdata->deinit_dev = i40iw_deinit_dev;
> > +		break;
> > +	default:
> > +		ret = -ENODEV;
> > +		goto ver_err;
> 
> Also don't do this, if the drivers are so different then give them different aux bus
> names and bind two drivers with the different flow.

I suppose we could have a gen1 aux driver and one for gen2 with the flows being a little orthogonal from each other.

The gen2 aux driver auxiliary_device_id table would have entries for iWARP and RoCE
aux dev's.


> 
> I suppose the old i40e can keep its weird registration thing, but ice should not
> duplicate that, new code must use aux devices properly, as in my other email.
> 
> Jason
