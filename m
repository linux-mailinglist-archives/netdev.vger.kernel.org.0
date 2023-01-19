Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2696734BB
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 10:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjASJrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 04:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjASJrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 04:47:08 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5C56841C;
        Thu, 19 Jan 2023 01:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674121627; x=1705657627;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f97y+IVJPZZs1siZhpsi+lKl60ALvByHRpSHu/nh5QA=;
  b=ZUZJfZZJZkGMVyFYnQ/S6CzSuYd+yKcTrmxlo1In59SyzEDu6F1OKi4R
   jmljhl/hq4yk2+TKrukjK+2CO+FrSGU9Tn0uh6sC0WouuH1mRnP/5ktum
   EsRIfOFITxxhNljXkoEfxNp9+WhtcZP8VBy2op14e62s6rDuJuYDwaV4b
   q25s6wvc8xmjMolzOli6IqfshSyQpxtl/RUgQ5tvSQDYhmCkztXqhRDHN
   viV39B76Lp36psbJ6YXDnzfesl3cBJ5jipiJk+dsoyFQV9G28P6hvuWPo
   zUXkvI3zYe1FtOi3a4rH7vycOg4GlRZS52cqbD8I+aViG9pj0XqwJwjS8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="322929076"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="322929076"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 01:46:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="988924183"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="988924183"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 19 Jan 2023 01:46:52 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 01:46:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 01:46:51 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 01:46:51 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 01:46:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXJ1h9ruSxW3VMVlwzw9EU5beoWiAJ/UJuWYr9h5iZuYHAyNPZs6r/GCNSoqlxMO5waRSLAVCb+v9GVb9lB9M2O0xiuW2D9daAw8GLXpUyRVYp7bX6LV9I5HVK3iod7r5uBK5OhYeZqYcUisyWUoolEXsx3VDdnsjy7j4U1Wvd5py+gZATxTTkVCYh5ofDI/PpnnycCcUWwDUVXLyhK3Gl/MCi60liZPlvkBlX9SBvCSYtCLZpLvXHGpsHVTgO87Z+tGKF6tBkZqfT8m4H+BNgcUfsvZVCY8Li4mKMHL6aNclLya7d5vQubXMr+iiLs3BCKejcACGdRl/KPoBO4YAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VgTz0RXl8qVDkVQMT17m3uiLefirQjjyfzY//46clh0=;
 b=C3HqUbyZ0Us9lH1Mx4nusMF0ae3yj7VCa158p7IRh3FaFTL1/dQwxuOsZcPx6oyL9TEnVwDwzYHBFGjF/XPGFSOFtndBaZ4qAUd1SoVHSsu4cyNRgbHXHbIIofeXEAtWhIKBOjjJ7nQsIOG7U1nMEX2tD7XCz2NsTgLGm1CtJRzpdFBUj/wnSOPphe+pFL9OpIOztAuA2Y5m8Vx2WeWpYUXg+5KpXhSLLUefNm4oOKoA9u57YZB8VZ5THZgBVlnWW4AJHMTZROedtp6Dej4GjN6Kjd+0cFzdnrIneApBNtqbmjxf+B+umrfPkOU7GvaHrkCV7hUPbt5VAdmlfB33Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by DM4PR11MB5358.namprd11.prod.outlook.com (2603:10b6:5:395::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 09:46:50 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44%4]) with mapi id 15.20.5986.023; Thu, 19 Jan 2023
 09:46:50 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Kees Cook <keescook@chromium.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH] net/i40e: Replace 0-length array with
 flexible array
Thread-Topic: [Intel-wired-lan] [PATCH] net/i40e: Replace 0-length array with
 flexible array
Thread-Index: AQHZIWAIji9rRMWQlU65jvJpwLjShq6lkwQw
Date:   Thu, 19 Jan 2023 09:46:50 +0000
Message-ID: <BYAPR11MB336737A10C11036A183EC1EEFCC49@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20230105234557.never.799-kees@kernel.org>
In-Reply-To: <20230105234557.never.799-kees@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3367:EE_|DM4PR11MB5358:EE_
x-ms-office365-filtering-correlation-id: 69ba8c44-c51e-4026-f938-08dafa02168f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jo65nH9rfEFG1LQAhH/Gp0cUXZbKu4JdkYEHow8HDygpW+/L5ZYgjAJWOytMHBZPGTqRSmCWM+Fo+IaXZzZkd/LCpFqBwU1QtY5GgTihGs1YqsXldjg2GhMrNdA71wD9Qo/VrlfbX83+cmOUkqLvPfIcX0YexfnKr+ymDEhj2TCgrnQHeOb9NVqfpYzx7/8acqUL3dvLrBMD9wJ0paj9K0FgdriBwdL9qyOglyt1It+NON9EEsUJR4gyUwJ8H46s5Ldsy+xPlLporTKS6ywc5dgNvKni2OElbA/B46+G3ykjhHukAv0oFuJ0jFNTKKFWh3N/nKadcax3FCZQZA3FFxfdSIJSNubzPDmCD6qw7gNXGxQ9YZjhGa5lADC4KtC1a+DwsqTP1kAfLKgSGluxjJkuHv9usb2UQZjYdGdnqj4nKO3jgct3X/iPmJn6GRJHrMwjinxIxli6YKeGT6RwUafuotC70hZlfP0avZUrgB4XqTlGODsgNUo4yagzHi7bClsJSimy+kah7MOeiFi/VznoTxGpaFUCkF0abQE75EJnyjRvb+eTdBI9GWvNCu9bQQdhCaMQ3M2AqlL6rETAT+GJ2iJS5YOjDD35/EpPP4vDRCFZ+uwIA5usw492TU90kXpOvSXaPkzBr5bcKA2OGqOrzGrbtCMn0zpoelMTalnI4/6VHxmKeoM7sxLUl4JL1TTls2W8cAu333eggQ7MS+0yUa+q3punHaq196AN6hI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(396003)(366004)(136003)(451199015)(38070700005)(86362001)(7416002)(41300700001)(5660300002)(8936002)(52536014)(38100700002)(82960400001)(122000001)(33656002)(966005)(7696005)(478600001)(110136005)(71200400001)(6636002)(54906003)(83380400001)(6506007)(53546011)(26005)(186003)(9686003)(8676002)(316002)(64756008)(4326008)(66556008)(66946007)(66446008)(76116006)(66476007)(2906002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7tN5GWqDT1fJamXUMHA2J1eZeQqXTrQrzbZc+Iz9qdYoDayAhCX+evhd33vt?=
 =?us-ascii?Q?1nsSvj3oSb/oncebdyYPZ49lTxlUj/8vikLtYrPv1Y1x5mcOspW07E8samdh?=
 =?us-ascii?Q?pMfiFKSSGI9xS6/2FKXJAO9btnGn68MHvx5dnI/lWPg5CiVj8STcgtaWCwYt?=
 =?us-ascii?Q?zR+Uk+oj1kRT7k9MKYojgUIJ+I7mL8a0iGLXbVfAe7R8JwKCfPTk54U8c9cO?=
 =?us-ascii?Q?xuPneEk3NuqSm5mMN7g063erjTTV4S1GTHeuzvg47DhpO+pokyRB+UGyMbs+?=
 =?us-ascii?Q?noQbUY8tSVxDzUj5H7ZHOAUHVLsVk3rT9XlRGLOgSSSalG0/XlB8DwsVMaeW?=
 =?us-ascii?Q?xGnQQUhxxh+XeYk/xvI0ylPZxXZYZHCZIIjQmnjbQuUJ643ByHwXq0+cUuLt?=
 =?us-ascii?Q?OZGfap6TXLjU8xAZ5/J4Q9b95GxNemBYEv5Wi25klmBor2cARoync7ektIQn?=
 =?us-ascii?Q?vb2ohMCdNGSmYI5ZdQdydqbDIGnt5XGYKmG9047995MGdDdMRLk6msNCh5zi?=
 =?us-ascii?Q?FDGSIZ/aocK1Z9zQYgP1KieNmLJQ0ToZDB9f84wRgQnTejPKjjEBmeERWPCS?=
 =?us-ascii?Q?0RchMlL5KsY02VkAmlffgzXFQgmbAPy4R4BPfatKTlR8G/GiQbmDGBLVbu1O?=
 =?us-ascii?Q?2CX4CGhnMkd10eL4WmyPKvazkEU4iyLVQkBIJTKpwyKKw7O1HJIT+K9s2NiS?=
 =?us-ascii?Q?H24rYRxnoh94zNEGa2OAj2mX3/YCtdQd7mPiI9u36YwHCgHCMTBcPO6diFfZ?=
 =?us-ascii?Q?s+6GO5g8vvvNE8uUv804HHnb/7sIQFX+EqfgrbqKJN3rrKJX4AzSZraeZ02B?=
 =?us-ascii?Q?nHOBsvdqJztfZB/iKRq/ar8OtiNMvvXdrkSeyIK5mh0IlhkucQ7YfMC6eclc?=
 =?us-ascii?Q?HbKAbwQEmhrk0VK+XJwNnGRIAbtkiVdotljYdzauoShECVnEF74ZDURA45QO?=
 =?us-ascii?Q?KmrDECbam6lWUmUput/pbJFDLUEbTh3Ql4cST592ZhCKYF4oJyf/rMg5bthC?=
 =?us-ascii?Q?A+YgIMIohgBMJ0lTjFk5BaKW0/UhpjkUjVf9ZwQP6JnYKlDC7CgAXjJy4rjT?=
 =?us-ascii?Q?xsqnHSrbCD7AZy5D/mbY/JaeuFfIDkpeVnKQEhWp49ct0PDF9V0x+jg6YvxY?=
 =?us-ascii?Q?H4GVGT+IzU6jKBEDtZu6l1xjXFx1Q2thcWByaL0kYYWYsgWoIrku3T6p/i5m?=
 =?us-ascii?Q?HrK4F1A3xFYsB29zutRAAeW8GmC7XaiKJJYppfid7yXYNQVJ3ozd960OPlYk?=
 =?us-ascii?Q?Wlkxz+W9lD0GStDFPzA9FY/3eraEddFT2XHB+oiz3xYC3LYLIj5/5MAmIvrY?=
 =?us-ascii?Q?xPxYAtb9eiRMoMBAxuYgtD/bRkYMsmzh0zvkMmXza0BfB1g3HWiZOJp5FOvx?=
 =?us-ascii?Q?KpwbDlZtplj+T6rs3sOusukQq6AtKk6/mSVgrL3O0nShYmkjkZ2IFpjkBNI3?=
 =?us-ascii?Q?+DHrK7r1R9Z08gawSulX1BO/vESEsYOsOM7uyLJqvU9KCp5NfhQM+TzMsH9P?=
 =?us-ascii?Q?Y5guhhme7qBZfVDtzzsT3Ufc9zGidseW/09f/CoUNRXDkl9LRLi4zE0GtfP+?=
 =?us-ascii?Q?7NMRsrBxJ8MrsRzwQ3PUImQRWNFMu8FRX3Ht1EZl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ba8c44-c51e-4026-f938-08dafa02168f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 09:46:50.1446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pCSx7/pdgqeZjeJknbuNkYfAfpN8hOB8GkGCR70uWtQZQsA+k0ymo0W0ll8BxinBx0LvdO7qW+nswWOAFb/WlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5358
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Kees Cook
> Sent: Friday, January 6, 2023 5:16 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>
> Cc: Kees Cook <keescook@chromium.org>; intel-wired-lan@lists.osuosl.org;
> Gustavo A. R. Silva <gustavoars@kernel.org>; linux-kernel@vger.kernel.org=
;
> Eric Dumazet <edumazet@google.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; linux-hardening@vger.kernel.org;
> netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH] net/i40e: Replace 0-length array with
> flexible array
>=20
> Zero-length arrays are deprecated[1]. Replace struct i40e_lump_tracking's
> "list" 0-length array with a flexible array. Detected with GCC 13, using =
-fstrict-
> flex-arrays=3D3:
>=20
> In function 'i40e_put_lump',
>     inlined from 'i40e_clear_interrupt_scheme' at
> drivers/net/ethernet/intel/i40e/i40e_main.c:5145:2:
> drivers/net/ethernet/intel/i40e/i40e_main.c:278:27: warning: array subscr=
ipt
> <unknown> is outside array bounds of 'u16[0]' {aka 'short unsigned int[]'=
} [-
> Warray-bounds=3D]
>   278 |                 pile->list[i] =3D 0;
>       |                 ~~~~~~~~~~^~~
> drivers/net/ethernet/intel/i40e/i40e.h: In function
> 'i40e_clear_interrupt_scheme':
> drivers/net/ethernet/intel/i40e/i40e.h:179:13: note: while referencing 'l=
ist'
>   179 |         u16 list[0];
>       |             ^~~~
>=20
> [1]
> https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-
> length-and-one-element-arrays
>=20
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/ethernet/intel/i40e/i40e.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
