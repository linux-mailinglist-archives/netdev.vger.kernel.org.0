Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41966CDB41
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjC2NzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjC2Ny6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:54:58 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC71B6;
        Wed, 29 Mar 2023 06:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680098097; x=1711634097;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=96+qsi1gbb60X46DxbY3Js3iNOLQKnfsR1d1fq8vCuA=;
  b=FEqXy/aR9Q9LmqpBDxGinQtVR2lpAP5OVoXSGNt43QPzTE6HousCHIQT
   e4KjqIMYe3P8mvMtRrdNNFrrbplKq8iH7fyugooy3/QSRDHJ8w84sqUfN
   iDSe66W8AAKRpXuxP9BAJH/dNUgpsfUe/LPMdtm5sQxdrW7kG42nW27a7
   PMwYS6YhKqojQK5lVUW/8kjORiLYLSKQTLp/pK482Hngzjqt4yRxgjfLf
   OAxFI+tFcM9zY57Ye9UH3QltDKFyxKckswW+zAfaI48DrNKM6EFLZJ8vA
   1TKhFADcnney8M/w8H9yS5Yq4eG4mGWlWoiZnUIH8sK/gP/7oJbyAai9D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="405824518"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="405824518"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 06:54:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="684270822"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="684270822"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 29 Mar 2023 06:54:55 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 06:54:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 06:54:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 06:54:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 06:54:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/olA9xLiNBMzmUO5YCsNQJ2O3bj+8bXAcB5EqmxrgA/MapOk1ZsY/l4Y/t6Iour5HCWJok6E7rcqkKfdOPD/Tbk0iboiscmZx1z/Mc0JhZ5kpTHRHrChng4y9cfGawrGWLbCRGsE5qYq6UTvXKVMAgUKD3QbA/hWzzyOgVmLBB30tDKQgo2/ICHDLEZNFKhM9VSCsSkxP+4xVWKoD+NpMOudxW2tXvqzQmC2nQYdzWVriOF+JtPcrqD0A+iUs3oRsiYnXZK2OXkUj7s4I+PmBcYvJl8NXX9iiTXQd4qP2SzjRho+j/RimVsoCvm9aeHJ3BPFBKX1qA3K+jELoW9Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4rq6ljKK8P3G2Bhbb9EIfLT/bvWvCLUAugsl6/tEYzI=;
 b=DvSu8OPJpa03KQ9EXaOJv4hpqfoxuV+6BQPbEh8oN8xcKGIiHF19RS+cXjI2zTffDXCa8EvxCb3IrTlCCzUPJeLjnbEjMLgMl9r9w+cXtPDW5elOpQP4gzqdiN/PubBeTaHH7jWTBMl3pJotCJ6/JhxwDXc84zjGMt6Ggljg1kIczL8LElR/1a+6m+DAzNZkF39pFB0OEOrWcrzFqSf6xCFwbnXvKt3YBjgzuSKypXNLa0FpEo7DMdQq/6yjFjVrVv73MYAaSZ55v/ZV0jf50mFhA0Hbb3MtE7yoekmFhos+z5uiVUNjFKhBI0gtxSOBd1NZpC3ud1ukmdgm7RgQnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5483.namprd11.prod.outlook.com (2603:10b6:408:104::10)
 by PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 13:54:51 +0000
Received: from BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::2ac6:e032:8994:2e12]) by BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::2ac6:e032:8994:2e12%4]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 13:54:51 +0000
From:   "Zhang, Tianfei" <tianfei.zhang@intel.com>
To:     =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Pagani, Marco" <marpagan@redhat.com>,
        "Weight, Russell H" <russell.h.weight@intel.com>,
        "matthew.gerlach@linux.intel.com" <matthew.gerlach@linux.intel.com>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "Khadatare, RaghavendraX Anand" 
        <raghavendrax.anand.khadatare@intel.com>
Subject: RE: [PATCH v3] ptp: add ToD device driver for Intel FPGA cards
Thread-Topic: [PATCH v3] ptp: add ToD device driver for Intel FPGA cards
Thread-Index: AQHZYX/jOrnIQ/7C1k2bRg2y0qNbVa8Rl3aAgAAxZ9A=
Date:   Wed, 29 Mar 2023 13:54:51 +0000
Message-ID: <BN9PR11MB5483D3C9882DF580FE55B625E3899@BN9PR11MB5483.namprd11.prod.outlook.com>
References: <20230328142455.481146-1-tianfei.zhang@intel.com>
 <4c4a416d-605f-939-62e7-5f779dffbc73@linux.intel.com>
In-Reply-To: <4c4a416d-605f-939-62e7-5f779dffbc73@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5483:EE_|PH0PR11MB4950:EE_
x-ms-office365-filtering-correlation-id: f6ef818d-a0ae-41a6-f29b-08db305d2ae0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ebw6BUR8q34o3knkyt7kfmtxXqoaCzw35L8nAL7JYNApHuku6SSUC8shyk6IiZXlfgXGmimeZU00gGaP6GGOc5d9s0xmN5ov/6XnpofkuQRmY4nbJGs4JB7LB30/dHaMv/UcbpmmkN/PLRtRCQ9zpAenqCaEsiwdJbkugyEIr6S6byT32naX7/S97sOVj7tBDSa/Lym9tds+OvBNL4wnwpYwXob6NFzLgLCW11CYNxPaf364AsHrUzRoyBwEyfbhAbXA0GAiV/7//a+UHkgHfTEulfCv5Oa3OzKUZ6Il6WQMbpz58zRPiWQhUU4RhetqFnkwCmMyaqpwLclgGGwdpZyAdHryeRSjI0BtlYtdqbAQmRGoC9e0P+El2CxDiWvZ9H4fkyj0mG5QX78INySY0bPjHL0+CdwfEOyUt356H/mPBCdCbeglUkt79DtPTcRqn9AihoQOYcgDQ8g8/jSdtUXIrl22D8xgDi4IqEn1WgnIBWqM+Q9n+fFC92TNF9pOJ5Wzn/TD8uGQUlsnlVnEwTm67tSd31BIIykDfNfMkK2AQRzPJNzr+4UIc9fy8usYlx6h6MUnQUaaNmrT4JoMXciLCkx7aKnnxzjHzQ4/zop4fbcvWzi7HhJA9+6OH/5A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5483.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199021)(38070700005)(66946007)(122000001)(33656002)(38100700002)(55016003)(86362001)(8676002)(76116006)(66476007)(66556008)(6916009)(66446008)(64756008)(4326008)(5660300002)(186003)(83380400001)(8936002)(41300700001)(52536014)(6506007)(478600001)(7696005)(71200400001)(9686003)(53546011)(54906003)(316002)(82960400001)(2906002)(66574015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?rYZtyG1kZbLAdrbmpnJTop71vwYxf5m16H9G/vesyWw7SSPqiqiGzXUqqL?=
 =?iso-8859-1?Q?aAGbedP641659TqUZJZC0Q3nQgWfJAb8XzP9u3G97Y+H0Hs1RwHHtH/bKd?=
 =?iso-8859-1?Q?bM1Nt60NCn54oJXmzYTACu4E4eQAwWcy/URxr84NA1eYMtgEpbZxBdWw8e?=
 =?iso-8859-1?Q?X2+PXLwubLuTGa7UZSb/A9bsQP4dnXkRpiJK7e+KWFtfaO+jnru/jVR2YK?=
 =?iso-8859-1?Q?ZA+sYxBG6KWTA521/oaQBRu5nv+6/8XdNPTqWVI6pgaYyVK+3hpsBvlIbt?=
 =?iso-8859-1?Q?Qm4jXRu8j+UR9nEVH7MoVdFXlSP/1KW81EM25pvOTCLzua7mTg7fUckcMN?=
 =?iso-8859-1?Q?7JnUfwN2Ct8Bxr//WBO9I+6PTtnncSkqnQgoeko1G5UcYxrH4Q8PlHA9zH?=
 =?iso-8859-1?Q?f6T8z4hyB5bwsH4fb5no9Essveq691HZ5umDP2a5tqr6Kbq9RV/T5UsTWR?=
 =?iso-8859-1?Q?bCorMr/jc4B7RKTQ9X9EpTO5PTw8LKMS9QTKPMMksUTEX9Zb18YqdYNH+2?=
 =?iso-8859-1?Q?Kvpm6EXGJdlr4l90HLFPL01g1lzOT5eySJ9TOdK3HVjj4kK3sTZbkfbPKe?=
 =?iso-8859-1?Q?PUwxYXvkpMEz5+G+sDdGP3ysp2Ahk/GMYWWIioeAGjgfhyIA9ChLBySuHQ?=
 =?iso-8859-1?Q?hoxxZPDEvvb46xPVdhnl1HvuY++NXJ0l8z9/pnhSiC4D8r6HT3NRQdcRmA?=
 =?iso-8859-1?Q?AyRcVgs4yEUaYdFWegndHY7wyB/3qtJhZeo15xbP5DDL09QVau/DXZs3+0?=
 =?iso-8859-1?Q?So2CNMfSXBoKqc3p1FJWclNcnwl8Jk5HCSvRLS0K8chQhmMN8KX7Jd7ccX?=
 =?iso-8859-1?Q?RV/SvqOw3K3KWX8KR6pqnfEwE/hE85uwGlATQGaDez4RJf5bZBDGDB/zGF?=
 =?iso-8859-1?Q?F/w1Dtg6t0t3pQgth07577a5NqvJabIG6hVLQnW/uBksiPCmLtZbFwLYBV?=
 =?iso-8859-1?Q?KnIrz73D2eGKk9aUkIdwlGiIt1bd268tplw4JguFRTAWK1HK27qA4D2y1D?=
 =?iso-8859-1?Q?BU50YZNxnuvOVCqEriyqtbq12LbrAdk9zikURejJNA7KPxzUrqbbTNbUZ9?=
 =?iso-8859-1?Q?z7DZXVFkKFg0Vq4U/nTxP4YrrxAsbqVoDPfSQsNyA7TDzIBuPuYXRFmP9b?=
 =?iso-8859-1?Q?AgK6+Kel21GcVVI2z1h7/8swx+dQnPU9piiEWlDEFHEuNFYzQOQUDdXwVJ?=
 =?iso-8859-1?Q?QxSTC2kegmiq1Qnro2APOfqLYSs6newc2dXS+bY/VZH2KGSkpywsD1XpDU?=
 =?iso-8859-1?Q?O0i5EA5oOAOqWEm0RNTqsIRvKeVZYOjzB2USgXjsPPmElGs3O9ylPXE7qR?=
 =?iso-8859-1?Q?xc73vVREm9t3geqKESjWWl2v5mnm8KIdjn/9FLZzZLFMz9RPRqOT5Q/2Lh?=
 =?iso-8859-1?Q?3mv80q5cAGH6osdE8ZIH3Dewd9pmHVwHqawQByP5yVSnoH1IKnMSSiikGO?=
 =?iso-8859-1?Q?NPvOCqukWg4iIoXXhGRoojLPkG3ICQEcaCMDKnOFGtJbmqYG3V/q5EZHNB?=
 =?iso-8859-1?Q?DaU5uYzzCSsdt9iB9keyInES+L4E04VSiTNN1iTtl8+CsDGAieGGTojYU4?=
 =?iso-8859-1?Q?Tp9wuugzdy/UvCpBaYMCbMjWm7BTLeVp7sWsafZKkRnrNKWy32nIEVurLM?=
 =?iso-8859-1?Q?I4+c7gryWSlBV9eXwuNL/sOWhdqGTkbVC5EOgUNdj4mIALFc3ExchLt9qz?=
 =?iso-8859-1?Q?8bH1lvbCJ/R/ly4HwkFYadOESq40FoTTwilwEzb+?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5483.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ef818d-a0ae-41a6-f29b-08db305d2ae0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 13:54:51.2137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XSmIZAUt/hzwNdcmKEame/5NfHK/ANm0pqHyJBTURz/fPj3y80mZtfiNxDY/v+dbb8iRGfzO7Vt1QRIO9N40Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4950
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>
> Sent: Wednesday, March 29, 2023 6:57 PM
> To: Zhang, Tianfei <tianfei.zhang@intel.com>
> Cc: richardcochran@gmail.com; Netdev <netdev@vger.kernel.org>; linux-
> fpga@vger.kernel.org; Andy Shevchenko <andriy.shevchenko@linux.intel.com>=
;
> Gomes, Vinicius <vinicius.gomes@intel.com>; pierre-louis.bossart@linux.in=
tel.com;
> Pagani, Marco <marpagan@redhat.com>; Weight, Russell H
> <russell.h.weight@intel.com>; matthew.gerlach@linux.intel.com; nico@fluxn=
ic.net;
> Khadatare, RaghavendraX Anand <raghavendrax.anand.khadatare@intel.com>
> Subject: Re: [PATCH v3] ptp: add ToD device driver for Intel FPGA cards
>=20
> On Tue, 28 Mar 2023, Tianfei Zhang wrote:
>=20
> > Adding a DFL (Device Feature List) device driver of ToD device for
> > Intel FPGA cards.
> >
> > The Intel FPGA Time of Day(ToD) IP within the FPGA DFL bus is exposed
> > as PTP Hardware clock(PHC) device to the Linux PTP stack to
> > synchronize the system clock to its ToD information using phc2sys
> > utility of the Linux PTP stack. The DFL is a hardware List within
> > FPGA, which defines a linked list of feature headers within the device
> > MMIO space to provide an extensible way of adding subdevice features.
> >
> > Signed-off-by: Raghavendra Khadatare
> > <raghavendrax.anand.khadatare@intel.com>
> > Signed-off-by: Tianfei Zhang <tianfei.zhang@intel.com>
> >
> > ---
> > v3:
> > - add PTP_1588_CLOCK dependency for PTP_DFL_TOD in Kconfig file.
> > - don't need handle NULL case for ptp_clock_register() after adding
> >   PTP_1588_CLOCK dependency.
> > - wrap the code at 80 characters.
> >
> > v2:
> > - handle NULL for ptp_clock_register().
> > - use readl_poll_timeout_atomic() instead of readl_poll_timeout(), and
> >   change the interval timeout to 10us.
> > - fix the uninitialized variable.
> > ---
>=20
> > diff --git a/drivers/ptp/ptp_dfl_tod.c b/drivers/ptp/ptp_dfl_tod.c new
> > file mode 100644 index 000000000000..f699d541b360
> > --- /dev/null
> > +++ b/drivers/ptp/ptp_dfl_tod.c
> > @@ -0,0 +1,332 @@
> > +#include <linux/bitfield.h>
> > +#include <linux/delay.h>
> > +#include <linux/dfl.h>
> > +#include <linux/gcd.h>
> > +#include <linux/iopoll.h>
> > +#include <linux/module.h>
> > +#include <linux/ptp_clock_kernel.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/units.h>
>=20
> > +static int dfl_tod_probe(struct dfl_device *ddev) {
> > +	struct device *dev =3D &ddev->dev;
> > +	struct dfl_tod *dt;
> > +
> > +	dt =3D devm_kzalloc(dev, sizeof(*dt), GFP_KERNEL);
>=20
> + #include <linux/device.h>

I will add it on v4 patch, thanks.

>=20
> Other than that,
>=20
> Reviewed-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>
>=20
> --
>  i.
