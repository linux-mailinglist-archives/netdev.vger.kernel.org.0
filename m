Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A06310D71
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 16:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhBEOPB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Feb 2021 09:15:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:60961 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231364AbhBEONe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 09:13:34 -0500
IronPort-SDR: 9WbNsnZ+jFrHTvX8zE0fql/tDNOoQ2lxTl7VSede4QiBCxMqNq0xyGR3BO3iP2L25VPSmWS64z
 p9Y1qpvdaV7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="177940140"
X-IronPort-AV: E=Sophos;i="5.81,155,1610438400"; 
   d="scan'208";a="177940140"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 07:23:13 -0800
IronPort-SDR: tMFdhCynUeam6V8pDza4NKZ6iOW6KRZGzVQSvQ57NOzkf0AYS3jriRTnp0qQgYPDOk+wsscLNg
 GRR6fRu+twVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,155,1610438400"; 
   d="scan'208";a="581184900"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 05 Feb 2021 07:23:13 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Feb 2021 07:23:12 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Feb 2021 07:23:12 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.002;
 Fri, 5 Feb 2021 07:23:12 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH 04/22] ice: Register auxiliary device to provide RDMA
Thread-Topic: [PATCH 04/22] ice: Register auxiliary device to provide RDMA
Thread-Index: AQHW8RnXnqa89naYL0CyeK9hU5Aknao5PxeAgBB++qA=
Date:   Fri, 5 Feb 2021 15:23:12 +0000
Message-ID: <ae763e223c0040259c63c1e745faa095@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-5-shiraz.saleem@intel.com>
 <20210125190923.GV4147@nvidia.com>
In-Reply-To: <20210125190923.GV4147@nvidia.com>
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

> Subject: Re: [PATCH 04/22] ice: Register auxiliary device to provide RDMA
>  
> > @@ -1254,20 +1282,37 @@ int ice_init_peer_devices(struct ice_pf *pf)
> >  		 * |--> iidc_peer_obj
> >  		 * |--> *ice_peer_drv_int
> >  		 *
> > +		 * iidc_auxiliary_object (container_of parent for adev)
> > +		 * |--> auxiliary_device
> > +		 * |--> *iidc_peer_obj (pointer from internal struct)
> > +		 *
> >  		 * ice_peer_drv_int (internal only peer_drv struct)
> >  		 */
> >  		peer_obj_int = kzalloc(sizeof(*peer_obj_int), GFP_KERNEL);
> > -		if (!peer_obj_int)
> > +		if (!peer_obj_int) {
> > +			ida_simple_remove(&ice_peer_ida, id);
> >  			return -ENOMEM;
> > +		}
> 
> Why is this allocated memory with a lifetime different from the aux device?

This ice_peer_obj_int is the PCI driver internal only info about the peer_obj (not exposed externally)
like the state machine, per PF. But Dave is re-writing all of this with the feedback about getting rid
of state machine, and this peer_obj_int will likely be culled.

I think what we will end up with is an iidc_peer_obj per PF which is exported to aux driver with lifetime as described below.

/* structure layout needed for container_of's looks like:  
                  * iidc_auxiliary_dev (container_of parent for adev)
                  * |--> auxiliary_device
                  * |--> *iidc_peer_obj (pointer from peer_obj struct)
                  *
                  * The iidc_auxiliary device has a lifespan as long as it is
                  * on the bus.  Once removed it will be freed and a new
                  * one allocated if needed to re-add.
                  *
                  * The peer_obj is tied to the life of the PF, and will
                  * exist as long as the PF driver is loaded.  It will be
                  * freed in the remove flow for the PF driver.
                  */


