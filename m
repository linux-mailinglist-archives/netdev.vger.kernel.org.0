Return-Path: <netdev+bounces-11161-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCA22731CD4
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4C211C20EBF
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7027E17AAB;
	Thu, 15 Jun 2023 15:38:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0D517FE5
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 15:38:52 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF94B6
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686843530; x=1718379530;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iHMh+kzKbiN/2+sE/1BF4AElFcpo5iJabDawOMsc0KQ=;
  b=NnDn+ab85KwnxOcHWXYjaudAWYjmjDir7jCqV0cIMSucQaW7MDv9NJWK
   5p88hlXBcNGkiy15DLrzav/kP6sRupNdJKc4FLuxGlZQXZgm5Q3kG2eXG
   YXWsk5rad+P69Cu8qUfJTgyBvxT48ar0GM/IB1dccQhclQy2V2+dHWMLH
   z3+L4u3nrqoy9UoXNYqeQMofXOOCHeiTkXz5YTADURd7DppAs/E9lEm9/
   VgkazTOJbTVdMv45xCIAjX8npd5FXtpaOl0GmQ8yHTYls09J7E3iRxlW8
   XRsP9xYLWsg5hkVV7Ym25ZeWc7UdTP14YHB8Eo3SBL+TYmLy0IFZFh8zj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="358941527"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="358941527"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 08:38:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="662831155"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="662831155"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 15 Jun 2023 08:38:50 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 08:38:49 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 08:38:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 08:38:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 08:38:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czlBy6e0SfKL3Z+Cf9xQft2OdyWOIEYhZCWHGDuInlcU0R99uiF3Y8khHxCbBGcdX2g+V5N4nvmRwQNf28kIxBAWLvZpLk1H3nAsIZUZ90bPITZ1s/lcy2fEJNEwpEFZ9z8VSOJEgml+06wJ9lE1qgMaFTEKpbJ9umBHOu3VpXsWm2Ebr1wSXDHCOAGRg40xzOmmsgpVRf45AhOdxsp8SfLtiJx1GX/7ohZ1NleMCG4XfC0SAL8tlFtmhNQS/6Fp6+xtKGvzYoBs0lfiGYzt/hsNC1pLCT823AgiKJeYEfciDXN/ucCmu9xja4hqTxuJ3mQD+pgANfc218MYbGhEuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U0UcOSAs5dc+f33JKqgk3Oiy0K7XrTTvOkw94Y7An40=;
 b=PZBhiCw/8fmEm5+jrRQsVaJkJpNrhWX5J/5T+7C4lHLYMLDtMHgdxIMoNUlOqmoAsMvlflqvDZ20iLLka5j0bEwp5jgQGjhe2yPhYfTrrEidhsOdnsePQUFEQ/xrIfrKy4qTTzOkJonwZxdzMmEzNwrFT+T8ikUCfcGFvLF5TzuHtIPDHNkw1nx8amjJNVeIi4t73qEILmIDwQxvEdAWt4KDnxqy+qwKwZbTy28r4pqdKo7rdv5b2v8rxdEIgA8VJfxmr1Wixdl5SFNiSMuW8VYCruNJs3RCTMUYe+b+UwUC8Vv0qnplTE05PPnQj8E1yPdCMghYqIdhbLK4foVvqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3521.namprd11.prod.outlook.com (2603:10b6:208:7b::32)
 by PH7PR11MB8456.namprd11.prod.outlook.com (2603:10b6:510:2fe::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Thu, 15 Jun
 2023 15:38:46 +0000
Received: from BL0PR11MB3521.namprd11.prod.outlook.com
 ([fe80::2134:60a2:3968:7298]) by BL0PR11MB3521.namprd11.prod.outlook.com
 ([fe80::2134:60a2:3968:7298%2]) with mapi id 15.20.6477.028; Thu, 15 Jun 2023
 15:38:45 +0000
From: "Romanowski, Rafal" <rafal.romanowski@intel.com>
To: "Kitszel, Przemyslaw" <przemyslaw.kitszel@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: Simon Horman <simon.horman@corigine.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Kitszel, Przemyslaw"
	<przemyslaw.kitszel@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v2] ice: clean up freeing
 SR-IOV VFs
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v2] ice: clean up freeing
 SR-IOV VFs
Thread-Index: AQHZk7y/KuKkcG/zFUK4Gv0kLhS6R6+MF2VQ
Date: Thu, 15 Jun 2023 15:38:45 +0000
Message-ID: <BL0PR11MB3521F37B812442601D9A64FE8F5BA@BL0PR11MB3521.namprd11.prod.outlook.com>
References: <20230531123642.20246-1-przemyslaw.kitszel@intel.com>
In-Reply-To: <20230531123642.20246-1-przemyslaw.kitszel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3521:EE_|PH7PR11MB8456:EE_
x-ms-office365-filtering-correlation-id: 986c49bb-af1c-4752-5183-08db6db69b3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZIggSIjHYUXR7O6EGnFkyaEMlur7vgsDQbGu6jHM1hL+q8cXlp/mIXxf6UkL4XruTs0uX1kc19tuEYc4dC0BvasQ/hbCDpMhE7R3TunaOFDuDRwdf+8W6ek/GZq/KBZ5Q3KjKGpXMy3koO0MnHR3AcOhup43ROXwJqw6SBtoMP6O8IU0p1WkpfZOd4taazt4LXjq9SKB9XvWuijcdO0S+WMdK14SKVbQFNHnoc+UQ+wZ+0kuV2YHDxkya/kX5+5ZVc6ZPggs+8jtOLDoyuOa9YhN1/QtkD42CxG9m8dNuxC4YqoxkwToEQxkC6VZvJaEEF3JdnUklF5cLyhOjsaSvJSPxAHAOJuJL6L8Q5ajTSC/dBulPHM8Zy23roC5+6FgPikcgQbKI2dFEevcC5Sn7IA22YkqMDqKofebaosQBIdXFIU4UBrr2gi80ASR9Olcr53vStgZw0a7nerZIDJEtb4yYLuc6qWq8VtEdoR+XpuD4u6Ai8UfQjN0lc0HPSfBAjCwLyqHjcHfJR+Uyu7wK1ezOKSo8RAQC66/i3cupIMsirYGrZkIwSqpiZKqKFu0RHHSUe2qD4NauxRB+gO7Mg05z6BjW1ENpmZSwuVDUsI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(136003)(346002)(376002)(451199021)(26005)(186003)(9686003)(6506007)(2906002)(38100700002)(86362001)(110136005)(478600001)(54906003)(107886003)(55016003)(53546011)(122000001)(83380400001)(316002)(71200400001)(4326008)(64756008)(76116006)(66476007)(66556008)(66946007)(7696005)(5660300002)(33656002)(966005)(66446008)(8936002)(52536014)(82960400001)(8676002)(41300700001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?LYlAaG800W2FX1Nj+UOpBLp+QdTemCGPypbDd2xAhYsWqM5Wcu6Xp/fhyT?=
 =?iso-8859-2?Q?Ko6Val7V++gZoYorvchNzLoT/9cIq7D1KdhpKfxI15Q2AkJsdrzd4yjb8m?=
 =?iso-8859-2?Q?9CXKii0KL+XKYqmndw2L2AwAgC/5yNHPYPWR1mQ/Okyd8uhYWdbLoKZ1Cc?=
 =?iso-8859-2?Q?mZXmNhOPPJHEck/Fk8mvQeT3iWac6PCz9a09oXkbGMc045FKItGeUCENT9?=
 =?iso-8859-2?Q?tS4Hdz9FWCNRr1kMZgcKHBXi2fVB3oc/qH2h/KfecADRYH23bGBmYNbwzH?=
 =?iso-8859-2?Q?t8PctNFtopD71SOoeKt4Qsq98DqYaS2Koo1/3ADcA6WLwYthIekNG/jOY3?=
 =?iso-8859-2?Q?JlxI/I1zVehGySZzOxHbpFSEu1Tn7qXGXg4+kfQ+XEyWWjI5MXcbFihzKt?=
 =?iso-8859-2?Q?Yn/rzpjuvivqyCgrZu5ioc4nKeSMXrh+5KgiosCWuh7kO3Xs1y6VSY34bf?=
 =?iso-8859-2?Q?0Kr//vExU4vLtyVtIh+po9OLsAeHuXJexGqeHRqnB5INPxy6njBPVmqKwF?=
 =?iso-8859-2?Q?uZlMyEk+P/PDSMf9uUFZRIUD5H7DaFvE1Q2de5gF9GvSnK/Fs/Bay+PJXb?=
 =?iso-8859-2?Q?SEQj5haEDsLzC4J+2TErcEHZTTL6I0KUZCaeXCiVz7tYUxGqMtIwLBfdXd?=
 =?iso-8859-2?Q?6G5JCDcI+vwUEoNvzAbVKvYkCaYsMnyvk6PRgWzK6WU6LYQI4yGGt2CJoT?=
 =?iso-8859-2?Q?4Z6HrzpG6mct1TDXHLEkF7J7uhXKeXV1dGHAD4bIq9pWLq6G5BavoYQISo?=
 =?iso-8859-2?Q?zeJArdP78OWcd+bKInkSOygZ/X60c8DvOD3YZAvOPuUFjUJ19rBNGHdoOW?=
 =?iso-8859-2?Q?Cazle0YVaW2nNCXIWB0jjfByIDn54ItKluBMcd7kutRpWSgvbi2iq4/L6T?=
 =?iso-8859-2?Q?hSCj28qVdJCDAYTWFNR1HkF1BaEruv+QLb4usc9lYsu+z3ov+7soqJnvYr?=
 =?iso-8859-2?Q?aKgOzcwikrKZu5M3gWYa5g7IcAvjua3vg54y7kIia8qQDmxjq9xJDs/cnT?=
 =?iso-8859-2?Q?jtKy9/hxP2ZuXRSy7hcLMMWGGHgxWx+VX1JYQIg7WF5NYUgKztxRFdcafK?=
 =?iso-8859-2?Q?E1VRPqwl5lXFQhutAF9x3N0z2/oVKis4r5bR8iocT/Ttj117uOS+BbREe/?=
 =?iso-8859-2?Q?dqBBpjqw/vROq9P74scUbyrK2TtnDoLqkYC2NMU5u3Sinun6qBdpz+jG+I?=
 =?iso-8859-2?Q?WwD82JD2hbYdd4dNHUGoGhUC3VP421Jqp1Gn7LatPNm2kOWD3dPGCEUBbg?=
 =?iso-8859-2?Q?ucktPZ7oE5sKB2/1c2XigxoSnzPVlgPE0/+cDqWZ4WIfaF72L6VuRHUajZ?=
 =?iso-8859-2?Q?h8P9f3ocuk64bVhK9CBT5zv7bERzwZ7jOJ2243NWEJGH7tdXhKveO1Ci29?=
 =?iso-8859-2?Q?R0WBNtVwG7/dKJ2FAXg4+PiySkQ5tGFUjUE3LlZ4UitWrfgNXaNeu+744Z?=
 =?iso-8859-2?Q?Tn092pDWaz82RcfIEHOfuNDG5vSuhsbYMVojIh5oXRb7ykgYT9EIn0jxhx?=
 =?iso-8859-2?Q?jaJRqDt/Nb2vKOQiER0DzWghNav0EpbTkUor/Dexgrlyyh3RRa9nPfHKHe?=
 =?iso-8859-2?Q?t+BzbiPV0KgvIuHzblqDi/NdpBeNHb8MxcyxiqiDQYH4IFNmG7USbA5/ZH?=
 =?iso-8859-2?Q?OVYhgDN3QuxwHbzJa1BOqL5SUbSQjLjUJsYYJXicinPuvMqZ3G/avaIw?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 986c49bb-af1c-4752-5183-08db6db69b3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 15:38:45.8954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vc7mxgxAdb5uvdUldunXFlYnXOebeRhalXv7RpLVum/vbGfXxN1VNz8JZh/EpPMKnklUHruV0Oc2Mt9eWG/Kvfp57l/NPVtcdP3+g8ZYrf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8456
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Przemek Kitszel
> Sent: =B6roda, 31 maja 2023 14:37
> To: intel-wired-lan@lists.osuosl.org
> Cc: Simon Horman <simon.horman@corigine.com>;
> netdev@vger.kernel.org; Kitszel, Przemyslaw
> <przemyslaw.kitszel@intel.com>
> Subject: [Intel-wired-lan] [PATCH iwl-next v2] ice: clean up freeing SR-I=
OV
> VFs
>=20
> The check for existing VFs was redundant since very inception of SR-IOV
> sysfs interface in the kernel, see commit 1789382a72a5 ("PCI: SRIOV contr=
ol
> and status via sysfs").
>=20
> v2: sending to proper IWL address
>=20
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_sriov.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c
> b/drivers/net/ethernet/intel/ice/ice_sriov.c
> index 2ea6d24977a6..1f66914c7a20 100644
> --- a/drivers/net/ethernet/intel/ice/ice_sriov.c
> +++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
> @@ -905,14 +905,13 @@ static int ice_ena_vfs(struct ice_pf *pf, u16
> num_vfs)
>   */
>  static int ice_pci_sriov_ena(struct ice_pf *pf, int num_vfs)  {
> -	int pre_existing_vfs =3D pci_num_vf(pf->pdev);
>  	struct device *dev =3D ice_pf_to_dev(pf);
>  	int err;
>=20
> -	if (pre_existing_vfs && pre_existing_vfs !=3D num_vfs)
> +	if (!num_vfs) {
>  		ice_free_vfs(pf);
> -	else if (pre_existing_vfs && pre_existing_vfs =3D=3D num_vfs)
>  		return 0;
> +	}
>=20
>  	if (num_vfs > pf->vfs.num_supported) {
>  		dev_err(dev, "Can't enable %d VFs, max VFs supported is
> %d\n",
> --
> 2.38.1
>=20
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan


Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>





