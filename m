Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFE464DE85
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiLOQXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiLOQWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:22:23 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC0A29834
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 08:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671121311; x=1702657311;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0O8s//QFw/kJ2kGNQ0G31XycUe9oI1LDBOOrmQMlaRs=;
  b=K9bU2n0RSoUsNEabAnWcit0RtCShynepZHsp8VZRaVKzIYOLxrQQzYI1
   iLOxUj2gKHBdqIV7mypl3ZrdcUnwRFX5g1ijS66BSX+uR6PCl+K6igDR1
   qvNLrlZ+/xOV4OifQVvPNzIIr7wHInp2luVDGv9UY1P56XWH2Fwk4uHSX
   P80iqJV0vYI/HaSTn1u0Kcg5LutrJXvx7L/nauWTrSDvLeQvaJKVLpn+X
   4I/kEYdIrZ7ipnOATO66OV69/DzjgcnzlS/JvCP090vLgc44iwDboBT0X
   OzaOWGZoaOVZqq42EUuTbHN2WZO25xgIIpoSRbwOXqhDUmRDdGnspD3Cc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="316357257"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="316357257"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 08:13:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="978251209"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="978251209"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 15 Dec 2022 08:13:12 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 08:13:11 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 08:13:10 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 08:13:10 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 08:13:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCZmfs5gwueQ5V2MTf89/ftSEI100CXh4SQzgDgqaKGzpPF79VbGqjJIoqmGgPGOCz22yKsQtTwbPEm7pGxpgZE3dNbnLl/MRz/XtIu6CVzI2MFvz+hyIP8kEGO6NWosasFELNW6vgWbPNJQqYmRmpEDYetxotAUASr+hiktNEdnzD1biKe1tRQN3quCX+Xf1P+QrHSJnaJULkkGs4JVW6ofeTfAbzSChSaEf0P8x16g1WNS5roiBxnxoyyfqmt6FI1P8kTwralOwLw1hn8sIubSV06PfP8vsSO0yqNRVhomWiaCV3kCTabgGeE+3ewMcTmqE5QuUb/R5GmBh/oQWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0O8s//QFw/kJ2kGNQ0G31XycUe9oI1LDBOOrmQMlaRs=;
 b=ck7IYS2p0wmgDTL4iyvXc/l4t2y1szB0VqAqbxn5i8Fi3JWC/2diQprj9ap6Kc0dk3r81aUye/RKTKeWxRj9fSsFRO5aNVXd7ZoomzF8rcT6aNmsCAhrLU6/5DCDyJXzHop4uPreLJmv6Q+LIjE0UVpbak1AdE7s4aE/Pk6lipfa/OOIHlwcdYFVtU2Ktzg7pl0bnBSXpsrCCgH9aWK0hZdV+mIhMmQPdEdwJt7ZxXq2VuCq11hyifeTNrtY0N8DwYH2/4H1oqq2TeWiJ7If7KCz04XtBebitMBFgJRW9SmSuY1WVGhfTlUdJgIgJcylTfh9C+8ikp76YcAbxHNYqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by PH7PR11MB6794.namprd11.prod.outlook.com (2603:10b6:510:1b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 16:13:08 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::cfab:5e4e:581:39cf]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::cfab:5e4e:581:39cf%9]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 16:13:08 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Missing patch in iproute2 6.1 release
Thread-Topic: Missing patch in iproute2 6.1 release
Thread-Index: AdkQb9xUC5vmlm8hSd6HD7llrKjh9gALmKOAAABdHZA=
Date:   Thu, 15 Dec 2022 16:13:07 +0000
Message-ID: <MW4PR11MB57760310424E2B73F53F933CFDE19@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <MW4PR11MB5776DC6756FF5CB106F3ED26FDE19@MW4PR11MB5776.namprd11.prod.outlook.com>
 <20221215075943.3f51def8@hermes.local>
In-Reply-To: <20221215075943.3f51def8@hermes.local>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|PH7PR11MB6794:EE_
x-ms-office365-filtering-correlation-id: 00f63012-79fb-4beb-da65-08dadeb74134
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oD/K3hzFGH2TMW1hkthKqBdUoucmIHsfAsWBFZJ2ACSOB8CfTf3/zFeBRdA9cEVWfb5sfFiue8yGzwb6Z1GPiaiIzqY5pUhqssIMoGh4rKEKKiSJ7CKOWvGRiUeJIjnGoKOTFCpXNcn1j8aQFXS+1wkgnqwTY4HHP3LgXRtlC7UxvhCWzOtfTjfjL2mPrsRx5ne6tNNuwVToFXLH6ripXsUNFKsZ9DtW6DPGn5Wj4K8sk+cXJb1Y7cNQ5uKcmavv4DqiML3LcU+ShIBF9e9ObK+BhWimowS2VP2gQnAh+WEHxs9G2SANveI+2Uw6UpD2/mvhb+ljQDdqiRxE275+ch9z5fquD3+uqX2hFPr4UJENWbwEKMjx/4FknCLOo+uGN10Q128N3O2xk+QLzBALllcrCDGXT4OkNzRXOoQTqwKWlA7tZ7StzkOt/ZSe1Ap17MP2+hu7GX5CC2ZBe+f6yJ3hBxA7/aIlbrrGPJCHyxgB1DQpiSGCzw4H5d8prenQIWPPG7v7k+cn1qKEQrMIK97MuQGwdNknrDKGgvlpJlDRQQkvbu4FOQBAKL8El/VEJzyQMZPyYGoiswHSNy15qXntjGSrUwiHLz4bZhb2LcBHSCV8X9J1ofK4frhKNB+XeYcQpxj+B4GZm6c5QmmgzWCoqXQWfTTi/eSOzG5/lYuLBJPT47E6auND10PQJN30nWKFLYfz5MILQXX5vPzgOpPq8RUQu17/18TANgpRJVpLM1pPGI0fIhkArHbgQMdRLDIh5/2GMwBIqUSnUWBF5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(396003)(136003)(346002)(451199015)(478600001)(122000001)(7696005)(6506007)(53546011)(86362001)(4744005)(2906002)(33656002)(55016003)(316002)(38070700005)(6916009)(9686003)(41300700001)(76116006)(186003)(8676002)(66476007)(66556008)(66946007)(64756008)(83380400001)(66446008)(966005)(26005)(4326008)(82960400001)(38100700002)(71200400001)(52536014)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HqjJjLqP1cPDQGyRLrEOFkGF5RZKQIQ28Tn2m96+f6y52ILQHWNjwBozksdd?=
 =?us-ascii?Q?BL0TOWb869S98cm+tBs2S0+Xh6CUv2pL7oOhoJSEJP9cEq+GQ0yKMK1HL9fm?=
 =?us-ascii?Q?27WdsHBLh28ocj+uZ/6Rr7P14m3NP/KNHULIP0uU2//YkYHifN7UFQ9BwNcO?=
 =?us-ascii?Q?lJKhT18R+qgvHV6nM3cjBu2Fsjq10qg11V2FvS3OYFzemnIIxElgVQb/eFvm?=
 =?us-ascii?Q?wJ6WyILR9C86wQQcA4I+O1oKUP+Aj3usPl1R4cDbjJ6OvJHls7KsC0SYPVW9?=
 =?us-ascii?Q?O/wVyE/v1FN1fZwT2rIUqLkS+A7AyOmHCmBnqIKet9b0TnJ5u5Quai1UAsAL?=
 =?us-ascii?Q?5Rdg+CYv6qBlsumZco1WFzKShMzaYD0C+/UvhELyL39g8vua+IHGNgrQI9XT?=
 =?us-ascii?Q?apq+GNeIJjoNF94kxiUrCDQUj69V2W/MI3h14MARxqmsomjMmjVeD4pDMsEz?=
 =?us-ascii?Q?yMbgav0c1pnD2Bc9uAKLqX5TQwd3ZBR0ToEgStcsY/WWQHMVKOlczYvbP0WU?=
 =?us-ascii?Q?f68Os0A36+TpeUWUNEjq573NP1mhpY9B90whHMofWZUT7lVkkGS/q6JhzqCS?=
 =?us-ascii?Q?qHVh3KtVu40pJu8/gg9nIENjeixGOGGRAq5+c8m9SiNp+EW61VZnZltkwvB/?=
 =?us-ascii?Q?Edefzdv8vCf4Wz6oMjZjKvN5CUEesfs+rg2/yxGmLdWv8MMZRELElG1PcWZ+?=
 =?us-ascii?Q?o/EEH/ZzM4U6ftJyqNObV2U7jvQrFwWzHhglBbNISLAccWT7SxFLUGiSx6wJ?=
 =?us-ascii?Q?UJrNEkquRbwm7ONP0w+yafU53moElMQ5RTaOI4CgPUJ0po8VunsTwiE83+VR?=
 =?us-ascii?Q?lkcJ0qn92o5Kj3IyBCZ9FHddaQlcOczFqvQH/QiXMqvA2pdVmRwTWpxgyxXp?=
 =?us-ascii?Q?CRu2Q02M/kbuauYsLTN9YemmkzSl1w7TvB6oOUhnc5wbYAfv5Yo0BHJPKNSZ?=
 =?us-ascii?Q?nwQeX88TKZ8UU5akkf/+ejZyV2n7asfwPZIFEJHml379sz4t/0lQXROAgYW7?=
 =?us-ascii?Q?zUTOdtmEeba9j75r4i1f9jE3UM91eYD6bQylpGCYOj+F/hsC/uWD1l7AhHbh?=
 =?us-ascii?Q?nwY3uABl9Bu8/kTwL0Zc163AHlFwytRP8vlDWzuDNnYZokvOHkrKHYuhVL3o?=
 =?us-ascii?Q?JdKimG+mQhyjlzFAXTWjPjaQkQViEm1oarP1gOu7QV6ZvSIPvaDpZZQs7rYA?=
 =?us-ascii?Q?e6AeazD8uKpKoi2/J5OY+77EBdhWc79+EAHTe/sHCrHJShIAOZdEu1n1n26A?=
 =?us-ascii?Q?S145owE3SNlInJu/9I9exVS2YSgIlbFzQptfOxELchjMKkKLWM5Qi5wOZiTH?=
 =?us-ascii?Q?mudmHZ6bhK/hof0CgjEEpAizu93tDeelyJYr6MWrvlx6cYiugU75TSxbY2pp?=
 =?us-ascii?Q?MSwAuMqIOX/awfYUIpo5YIhCFZ1JZkmQgTuR5OLan8Evc6J/b5UAzBk3QD4S?=
 =?us-ascii?Q?wDGOjClhk/d/xa3PXH9eS4FgbgbddsWpajgnT+UEsdfKJGkMAG0xQ5wIAaQ+?=
 =?us-ascii?Q?B6gjvve0qsMS7y0/lM5bFI5VNq81477nOS3YvtzURfpxvCXELP2nvgCeTMCu?=
 =?us-ascii?Q?Dh4vq8NbUARS+6M8HtLmpxpE9xNu4Le6ptEhL6iq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00f63012-79fb-4beb-da65-08dadeb74134
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 16:13:08.0085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PtwwekFN0ANOSfHe7qyAzkNgkJ9zrZO2C4Ruv7gYNV9X82jpOJG3wVsjO/fe6zjtDbmN/Nt5dfKsbycG4N5PsMMZZrg+vjLqJ6/SjHgYRrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6794
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: czwartek, 15 grudnia 2022 17:00
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: Missing patch in iproute2 6.1 release
>=20
> On Thu, 15 Dec 2022 10:28:16 +0000
> "Drewek, Wojciech" <wojciech.drewek@intel.com> wrote:
>=20
> > Hi Stephen,
> >
> > I've seen iproute2 6.1 being released recently[1] and I'm wondering why=
 my patch[2] was included.
> > Is there anything wrong with the patch?
> >
> > Regards,
> > Wojtek
> >
> > [1] https://lore.kernel.org/netdev/20221214082705.5d2c2e7f@hermes.local=
/
> > [2] https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/c=
ommit/?id=3D9313ba541f793dd1600ea4bb7c4f739accac3e84
>=20
> Iproute2 next tree holds the patches for the next release.
> That patch went into the next tree after 6.1 was started.
> It will get picked up when next is merged to main.

Merge windows for iproute2 are sync to kernel windows?
I should sent this patch before merge window for 6.1 was closed (I sent it =
after it was closed)?
