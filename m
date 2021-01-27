Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02AC30545F
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhA0HTy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Jan 2021 02:19:54 -0500
Received: from mga12.intel.com ([192.55.52.136]:59453 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317147AbhA0Amu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 19:42:50 -0500
IronPort-SDR: QrIkoSOh5CXZtFu9ZDTryy3QiLMTlOLX1rRr5XzelLQfhhKYO/naIZuFoF/azFxAChyOlStfZ4
 aXxxxTgainMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="159169758"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="159169758"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:42:00 -0800
IronPort-SDR: ki8mWJOSrfZjYyDCVNko7uZgSmP85jMGIpIkO+1hlUgGwlE8cbJBDu5lEb/C3TA/wcLo6mKZHQ
 35VfYlDmReZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="369293355"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 26 Jan 2021 16:41:59 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 26 Jan 2021 16:41:59 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 26 Jan 2021 16:41:59 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Tue, 26 Jan 2021 16:41:59 -0800
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
Subject: RE: [PATCH 09/22] RDMA/irdma: Implement HW Admin Queue OPs
Thread-Topic: [PATCH 09/22] RDMA/irdma: Implement HW Admin Queue OPs
Thread-Index: AQHW8RlWIRUHfz8eR0uS2oJ96sRUVao5QvyAgAD4k+A=
Date:   Wed, 27 Jan 2021 00:41:59 +0000
Message-ID: <5c36451841f64f90ac2be6d23ffa9578@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-10-shiraz.saleem@intel.com>
 <20210125192319.GW4147@nvidia.com>
In-Reply-To: <20210125192319.GW4147@nvidia.com>
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

> Subject: Re: [PATCH 09/22] RDMA/irdma: Implement HW Admin Queue OPs
> 
> On Fri, Jan 22, 2021 at 05:48:14PM -0600, Shiraz Saleem wrote:
> > +#define LS_64_1(val, bits)	((u64)(uintptr_t)(val) << (bits))
> > +#define RS_64_1(val, bits)	((u64)(uintptr_t)(val) >> (bits))
> > +#define LS_32_1(val, bits)	((u32)((val) << (bits)))
> > +#define RS_32_1(val, bits)	((u32)((val) >> (bits)))
> > +#define LS_64(val, field)	(((u64)(val) << field ## _S) & (field ## _M))
> > +#define RS_64(val, field)	((u64)((val) & field ## _M) >> field ## _S)
> > +#define LS_32(val, field)	(((val) << field ## _S) & (field ## _M))
> > +#define RS_32(val, field)	(((val) & field ## _M) >> field ## _S)
> 
> Yikes, why can't this use the normal GENMASK/FIELD_PREP infrastructure like the
> other new drivers are now doing?
> 
> EFA is not a perfect example, but EFA_GET/EFA_SET are the macros I would
> expect to see, just without the _MASK thing.
> 
> IBA_GET/SET shows how to do that pattern
> 
> > +#define FLD_LS_64(dev, val, field)	\
> > +	(((u64)(val) << (dev)->hw_shifts[field ## _S]) & (dev)->hw_masks[field ##
> _M])
> > +#define FLD_RS_64(dev, val, field)	\
> > +	((u64)((val) & (dev)->hw_masks[field ## _M]) >> (dev)->hw_shifts[field ##
> _S])
> > +#define FLD_LS_32(dev, val, field)	\
> > +	(((val) << (dev)->hw_shifts[field ## _S]) & (dev)->hw_masks[field ## _M])
> > +#define FLD_RS_32(dev, val, field)	\
> > +	((u64)((val) & (dev)->hw_masks[field ## _M]) >>
> > +(dev)->hw_shifts[field ## _S])
> 
> Is it because the register access is programmable? That shouldn't be a significant
> problem.
> 

Yes. How do we solve that?

https://lore.kernel.org/linux-rdma/20200602232903.GD65026@mellanox.com/
