Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B920235C936
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242567AbhDLOvr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Apr 2021 10:51:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:7556 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242562AbhDLOvp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:51:45 -0400
IronPort-SDR: Ymkim6gXIdhyMQLM7Xk2tz6OPkW6wU3EcUbJESM0GiX95JbJRFINCm9zwXjn60vjMF2l5bQe6N
 Kv6XgUfBNZxg==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="181332666"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="181332666"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 07:51:25 -0700
IronPort-SDR: 5SA84r5EcwwhL/y9qwRqAma0s2RyH3WPZV46btc5+qdmvtJqEmg/msX8zZTT0xwIA+ZrDFO2hK
 MQADm+eo4i3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="451495612"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 12 Apr 2021 07:51:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 07:51:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 07:51:24 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Mon, 12 Apr 2021 07:51:24 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v4 resend 04/23] ice: Register auxiliary device to provide
 RDMA
Thread-Topic: [PATCH v4 resend 04/23] ice: Register auxiliary device to
 provide RDMA
Thread-Index: AQHXK0MqKArpPZ2cRE+jvhABAcihUKqpymGAgAKOitA=
Date:   Mon, 12 Apr 2021 14:51:23 +0000
Message-ID: <6722e2809ae44e7cad9832877180ecc3@intel.com>
References: <20210407001502.1890-1-shiraz.saleem@intel.com>
 <20210407001502.1890-5-shiraz.saleem@intel.com>
 <20210407174521.GA542400@nvidia.com>
In-Reply-To: <20210407174521.GA542400@nvidia.com>
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

> Subject: Re: [PATCH v4 resend 04/23] ice: Register auxiliary device to provide
> RDMA
> 
> On Tue, Apr 06, 2021 at 07:14:43PM -0500, Shiraz Saleem wrote:
> > +/**
> > + * ice_plug_aux_devs - allocate and register one AUX dev per
> > +cdev_info in PF
> > + * @pf: pointer to PF struct
> > + */
> > +int ice_plug_aux_devs(struct ice_pf *pf) {
> > +	struct iidc_auxiliary_dev *iadev;
> > +	int ret, i;
> > +
> > +	if (!pf->cdev_infos)
> > +		return 0;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(ice_cdev_ids); i++) {
> > +		struct iidc_core_dev_info *cdev_info;
> > +		struct auxiliary_device *adev;
> > +
> > +		cdev_info = pf->cdev_infos[i];
> > +		if (!cdev_info)
> > +			continue;
> > +
> > +		iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
> > +		if (!iadev)
> > +			return -ENOMEM;
> > +
> > +		adev = &iadev->adev;
> > +		cdev_info->adev = adev;
> > +		iadev->cdev_info = cdev_info;
> > +
> > +		if (ice_cdev_ids[i].id == IIDC_RDMA_ID) {
> > +			if (cdev_info->rdma_protocol ==
> > +			    IIDC_RDMA_PROTOCOL_IWARP)
> > +				adev->name = kasprintf(GFP_KERNEL, "%s_%s",
> > +						       ice_cdev_ids[i].name,
> > +						       "iwarp");
> > +			else
> > +				adev->name = kasprintf(GFP_KERNEL, "%s_%s",
> > +						       ice_cdev_ids[i].name,
> > +						       "roce");
> > +		} else {
> > +			adev->name = kasprintf(GFP_KERNEL, "%s",
> > +					       ice_cdev_ids[i].name);
> 
> This never happens, it is dead code, right?
> 
> > +		}
> 
> This is all confused, the adev->name is supposed to be a compile time constant,
> this not be allocating memory and combining the constant "intel_rdma" and the
> trailing "iwarp" "roce"
> 
> Just use the proper define right here.
> 
> Also all these kasprintfs should have their errors checked, which is also why it
> shouldn't be written like this.
> 

Agree to all the feedback here.
