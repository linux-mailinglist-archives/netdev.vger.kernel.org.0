Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FA86EA362
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 07:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbjDUFxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 01:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbjDUFxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 01:53:30 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB03F7692
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 22:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682056408; x=1713592408;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y3g0rrYGHAh6GcER5taEsDea0Z32hTTwafCDoH8ApCM=;
  b=Jmg6NPcl9dmiuw9X2ePX/6bsqX52THgCLfuar2pQopsLyxsUs2QZZgt7
   1OAdEmn8ERxjOVwQ/kQfz2GNT2OacV392uNl1miEpfNSsQJHLGMCu4zH6
   BotXGC3SEvq+LQPfa2eHVZg90QWHRnRZb7XUg0ih7G2vO0CHv3lZInTGN
   x+hvWy13fb6bbSYC8B2y15U0Wxl1T74hYArufRBg9pwq+iH+zcdPjLkcq
   w7Kh051kw+U+ZpHuBw2xzbwA962fVVzcer5FTI6le83CotDovVKgGXmNE
   8wzgUi5PFAlYGJq+9iFEUW1XrMLU8ayTppuCCPLAT/kgtHHXcrg2vWUDT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="347822958"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="347822958"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 22:53:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="803604615"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="803604615"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 20 Apr 2023 22:53:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 22:53:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 22:53:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 22:53:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 22:53:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bb3ix25V1Y1fL0pWsrT0mhzm9MDZD3r8g14hEEAE5NvvsfL/ulGMzBP0tkQAO1nn2TZRKamnnJw0mSujSpn78TW/+d5aDR19weCO72D/w7hsrjpelcX/YgW08kzBEwFqLX9WX98dltspiMLJTnkpPqtRcm+38i69lzUFgdJdMdMalTX5b6RddncPkkDFRkxuKKtgx35FVDV0O+0qeNw2ptQK+dZ8Zs/pLzH3NQG4lPHxyRRDY/CDa09tUmsN6f/8BaJrulTHmoHQLtELFBFN1fEGNJC015IvwkDRQYlsIfBqAetZFgp2VBvaKPYojEFolPt0efvleJvEbSliSK0adA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ucPtTeh8bCMEzjMsc/5JGD1z72sJ3dsYZ635yZAptc=;
 b=LuVSAqWrvOodTrWsy/VTcbgeXxqJsSv8gGVFq1Lo7LA1uZpvdvDVA24mHx/SSoTbJ0BythxTuJdFNu1lV7lj16fT4eTkMxzG4AcN4YMgx7NUwj3YyN6OrSoXNUqx7hBoMsU3+ieFx9t3QseC0fpPmQIYNpY+9g+Ac9wN3g+m/dd8i+BhUBfYSYfEQme6kOUtfnm+Y7/4yvvd8o/wmvL0ynrZ8yWMSDfmrIBMNVl8E9IL6FmKaCod+VWZ7kPFYCNyU+6zxEGqFiWefpFoSAbKBjhNeuAEz0T/vAYV+BMTXgbtXlxQ3OENmfIOnAHY38a+dkqsuBIU/xqruXyydlWuNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3122.namprd11.prod.outlook.com (2603:10b6:208:75::32)
 by CH3PR11MB8314.namprd11.prod.outlook.com (2603:10b6:610:170::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 05:53:24 +0000
Received: from BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::a4e7:9fa1:19f7:6a41]) by BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::a4e7:9fa1:19f7:6a41%6]) with mapi id 15.20.6298.045; Fri, 21 Apr 2023
 05:53:23 +0000
From:   "Pucha, HimasekharX Reddy" <himasekharx.reddy.pucha@intel.com>
To:     "Raczynski, Piotr" <piotr.raczynski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Swiatkowski, Michal" <michal.swiatkowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next v3 7/8] ice: track interrupt
 vectors with xarray
Thread-Topic: [Intel-wired-lan] [PATCH net-next v3 7/8] ice: track interrupt
 vectors with xarray
Thread-Index: AQHZXYKi8+ZQY7IV+UuXGSIyPmw8Ba81b25Q
Date:   Fri, 21 Apr 2023 05:53:23 +0000
Message-ID: <BL0PR11MB3122ABA3822AFDBD61FAF126BD609@BL0PR11MB3122.namprd11.prod.outlook.com>
References: <20230323122440.3419214-1-piotr.raczynski@intel.com>
 <20230323122440.3419214-8-piotr.raczynski@intel.com>
In-Reply-To: <20230323122440.3419214-8-piotr.raczynski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3122:EE_|CH3PR11MB8314:EE_
x-ms-office365-filtering-correlation-id: 0612d992-b0e9-4151-df37-08db422cb7b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9SbpCbOQbFIFrLNSKM0NhQaVxh43/2vIrAqCygDSMjm7rBiG7WBQ9hue/SJsitlI8IW4vA2sCLi6nce76V/7LRQ6uqMjb9js1pwcPzsNDhy3ACJuPDqD+xCSaibW3+nwSK1GK7cA8sFFMsimJ2sz+gW6BwOeM8bPGB6gtxH7MCyvj0n8G4IcSc/dGTJNiuKlj3gRR/vxbm8+QTrePUXhueqVImC9TMhiK3XUcDEEPRPlMTUlN6HlnUsgvNrfFwEdBQknyIzY8xj9bBPHZdG75r1LNUi5oaM6/6MQ5hx0T4I0A/iMjOHxefb68ZCVjcfSh2pvB+wCHUDez86roY37bGulYJN7RZZkf+YFPf5lxx+OWvW/k/bxCDBbKW/jEYcy7BsOWh8Z3QaEpt/Sg1rsHD/ci/KCfiVV22aP/+tUHEJE3TnjMGmJuP5qIGVPndMjP4y4xKNITWN6U/3t4dWMG8Hq1CHhzZgU4COcTbPp4fy/xGyXP2suDN1Gxr9i8oPomEUOzkB9fLkGDatVbPcnuKbu9mzpEhz+o3InP22zlKREs5Km1Ch2xvLwWj39MtRIgVOQg/NTz8Tjc9y+bpMLiPKYmnJjdyLfqvgtjGDxqYiZRDSKEQKYwySTYIMLxpmt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3122.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(396003)(346002)(366004)(451199021)(33656002)(4326008)(316002)(110136005)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(54906003)(7696005)(478600001)(71200400001)(55016003)(8936002)(5660300002)(8676002)(41300700001)(52536014)(2906002)(38070700005)(86362001)(82960400001)(38100700002)(107886003)(26005)(6506007)(53546011)(9686003)(83380400001)(122000001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NcaLVl71pZp5KhTTKZdG/J41SNQN8rElp/uNzXcIa6nPPM8YunQGO6zYTo8l?=
 =?us-ascii?Q?HyosycFh2YPAEQZ40s5X3MKhDGYMYKZ/CEpeffcpeLiY0RD1SxefjA8O+xGL?=
 =?us-ascii?Q?dEiOQGT2QIfp+GigFk40jJMiwy9wd/0CSjNj8zwmd1GrkMmbCpxk9p0unhVp?=
 =?us-ascii?Q?Rf6YcWcalZSXohf4OzBFfm4h4DZnR6lkXg4ov5Hrk8MEcOq0caLkMMLRpbPr?=
 =?us-ascii?Q?XC36Ib2mePJz08ihIdZb1/prf/13Bbcn2BGyC6x18p3E+blzOHCJUrJpPRRK?=
 =?us-ascii?Q?qAyo0zGZ3wqU4X+wWSmgJwEE8WVi8QquTmbOQYo5et8LDpmm60IGM9qDNWG1?=
 =?us-ascii?Q?VeaGyVrNELzRfF/wqoBA/ga3zIyE/bcAmpmRX5rPMn+wtlgrmeyRdWTi+YlE?=
 =?us-ascii?Q?YrHE7Qxg08UT0YTKKU8yngaZ2/JAcOdIu8Kb08IV5RXBMLOpGVdAYP7SFzUk?=
 =?us-ascii?Q?Vsp6PD0ltBfP9PDeaKsevuQJxrDISkztbdNyhhV8hTdYBPYpfqyUfx/+IUzr?=
 =?us-ascii?Q?/4MtWkNdqIGL+8dM3vlG8t/IITmalgEQOaLCfgarpPpGcJvdOj1wjg4C3ekQ?=
 =?us-ascii?Q?Ok2uTBxGSOTPrpEUoOmGFrGwddAd3MIOx5wAfZxZeVd3VwakJNGyWNAbGH9i?=
 =?us-ascii?Q?SyAOXw8FeF8y96X0GL9/+I/6oqW0/rI9zQz6vfzablh7NcW6nvWAN4XUba+3?=
 =?us-ascii?Q?4cz44t/dTZJzA6deehM0uBjJZe7CYXe48LcXLgU3wTJa+JUkAU5KwMTpeM1m?=
 =?us-ascii?Q?WvrxKNu1TcmM9He6Zpd4uU8G/r37zC80fJviCyLvGPaQIqUaWtUNt+iiZdID?=
 =?us-ascii?Q?dDqZJ7O9dmNAGUFhG0P8zxEqGCV3D9JdUZswN/yndnDrw0gXBW7/RWATDFjf?=
 =?us-ascii?Q?nz/ClR39udVf19Rl3u+D5eeEZMa8Vkbj1myFqx7eI3FS6GjzRQAa/qWhaG8P?=
 =?us-ascii?Q?xNltqQ4cWKHjWtgETbjgSYeBZQaY7sZYg8CBGlQlzES658yPaEcDAEm6ov0s?=
 =?us-ascii?Q?c4tb2ucO3oaedRyiUdkJXwsY9Kg1wZPhzJO3a40q0d2O50FBiNHymQlRCvJT?=
 =?us-ascii?Q?3ZFtP2OEKnFh7dCY5ikzlAzPn3434bLi6W0MiCWmOpvG1Ydkp7XESie1c2RP?=
 =?us-ascii?Q?V6NnJ69L09cjHDt776i8/66AxhKkkesyGDMd6bot+lKV6Zb8/yzIDTrVPH21?=
 =?us-ascii?Q?7PYlUe/s9BhxFTRKTaSQdJT23UWoURrx4YvYWchCttqiQRUzAiQCHmqkwe5d?=
 =?us-ascii?Q?MYLSrPkY07kGHCZ9v3tuGMlb6fc6iCECcdJIkColHvS/7PwHfD6itAnSkhd/?=
 =?us-ascii?Q?Ps1sxhrCPYHB9gRmwFhZpI32pQdykI46o3QwByjCJ9iHqPxmoVyhJzubxaDm?=
 =?us-ascii?Q?ZPo1m7MC8TwMNjpz7YrZAXDm9zfubvu2Q4EiyUrFStJvJxiKxuqQlVBTrSjQ?=
 =?us-ascii?Q?Q4IMqzOyaYgvzWuo1qYeBRI0CSlXO4fNqKhnkWVDLMRo3uQxjAfDZdY8RhRg?=
 =?us-ascii?Q?qceBGqEcbZx7bLjEgvoM9qrJ4JYDVeD4raqxA/Wf4biQ2TXh+JsT7LtZczES?=
 =?us-ascii?Q?dr2tuHzhEpdKqIN9O8+SMTpuXjppFcBKgX/WoUJ+reduR81SyOdNhu1uZfFm?=
 =?us-ascii?Q?AQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3122.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0612d992-b0e9-4151-df37-08db422cb7b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 05:53:23.0811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: He0UuWtpfuUc3jmaI2H59nk55/lGCsCtNoCEhcxutFmw/HQuHS8DHvFajQqM4ZmHy6MuhmHSh8Truombnl3NCfiPCWi7xUTqiMPuh1sNVr6FiFu3crVRWtPimOCnRJTa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8314
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of R=
aczynski, Piotr
> Sent: Thursday, March 23, 2023 5:55 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Swiatkowski, Michal <michal.swiatkowski@intel.com>; netdev@vger.kerne=
l.org; Brandeburg, Jesse <jesse.brandeburg@intel.com>; Saleem, Shiraz <shir=
az.saleem@intel.com>
> Subject: [Intel-wired-lan] [PATCH net-next v3 7/8] ice: track interrupt v=
ectors with xarray
>
> Replace custom interrupt tracker with generic xarray data structure.
> Remove all code responsible for searching for a new entry with xa_alloc, =
which always tries to allocate at the lowes possible index. As a result dri=
ver is always using a contiguous region of the MSIX vector table.
>
> New tracker keeps ice_irq_entry entries in xarray as opaque for the rest =
of the driver hiding the entry details from the caller.
>=20
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h       |   9 +-
>  drivers/net/ethernet/intel/ice/ice_irq.c   | 102 ++++++++++++++++-----
>  drivers/net/ethernet/intel/ice/ice_irq.h   |   9 ++
>  drivers/net/ethernet/intel/ice/ice_lib.c   |  45 ---------
>  drivers/net/ethernet/intel/ice/ice_lib.h   |   5 -
>  drivers/net/ethernet/intel/ice/ice_sriov.c |   4 +-
>  6 files changed, 90 insertions(+), 84 deletions(-)
>

Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Co=
ntingent worker at Intel)
