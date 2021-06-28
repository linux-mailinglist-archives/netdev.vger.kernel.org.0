Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04F53B6B0A
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhF1WsU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Jun 2021 18:48:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:9981 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233035AbhF1WsT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 18:48:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10029"; a="271903954"
X-IronPort-AV: E=Sophos;i="5.83,306,1616482800"; 
   d="scan'208";a="271903954"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 15:45:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,306,1616482800"; 
   d="scan'208";a="407918057"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga006.jf.intel.com with ESMTP; 28 Jun 2021 15:45:51 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 28 Jun 2021 15:45:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 28 Jun 2021 15:45:50 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2242.008;
 Mon, 28 Jun 2021 15:45:50 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/5] ice: add support for auxiliary input/output
 pins
Thread-Topic: [PATCH net-next 2/5] ice: add support for auxiliary input/output
 pins
Thread-Index: AQHXafOQsu1unZMWWk2FI7QX5ZbbUasmyVGAgANBEXA=
Date:   Mon, 28 Jun 2021 22:45:50 +0000
Message-ID: <fcc626d6773745ae9ecee10dfaca1316@intel.com>
References: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
 <20210625185733.1848704-3-anthony.l.nguyen@intel.com>
 <20210626140245.GA15724@hoboy.vegasvil.org>
In-Reply-To: <20210626140245.GA15724@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Saturday, June 26, 2021 7:03 AM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; kuba@kernel.org; Machnikowski, Maciej
> <maciej.machnikowski@intel.com>; netdev@vger.kernel.org; Keller, Jacob E
> <jacob.e.keller@intel.com>
> Subject: Re: [PATCH net-next 2/5] ice: add support for auxiliary input/output pins
> 
> On Fri, Jun 25, 2021 at 11:57:30AM -0700, Tony Nguyen wrote:
> 
> > @@ -783,6 +1064,17 @@ static long ice_ptp_create_clock(struct ice_pf *pf)
> >  	info = &pf->ptp.info;
> >  	dev = ice_pf_to_dev(pf);
> >
> > +	/* Allocate memory for kernel pins interface */
> > +	if (info->n_pins) {
> > +		info->pin_config = devm_kcalloc(dev, info->n_pins,
> > +						sizeof(*info->pin_config),
> > +						GFP_KERNEL);
> > +		if (!info->pin_config) {
> > +			info->n_pins = 0;
> > +			return -ENOMEM;
> > +		}
> > +	}
> 
> How is this supposed to worK?
> 
> - If n_pins is non-zero, there must also be a ptp_caps.verify method,
>   but you don't provide one.
> 

Hmm. Yea, that's missing.

> - You allocate the pin_config, but you don't set the .name or .index fields.
> 

Ok

> Thanks,
> Richard
> 

Lets hold on this one until I can discuss with Maciej about what's missing here and what we need to add.

Thanks for the careful review, Richard!

Thanks,
Jake
