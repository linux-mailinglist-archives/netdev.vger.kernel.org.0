Return-Path: <netdev+bounces-8701-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E46A4725403
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CBC12811FA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0F546A4;
	Wed,  7 Jun 2023 06:22:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA301845
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:22:16 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39EB11F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 23:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686118934; x=1717654934;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jwe72qhQgRoFaiE5HaOuqjEdkNFFlo2/arUNj50XnM4=;
  b=Jiax80myE6wuuKXudP0mTFP8vtUL6OOfIXAUcaafU/w2FE+IxrKmZHDj
   cmDbPwOLHghLbI/0+iaHHey4k/E4dtRhaAMzud2macr8MbPtn+VgHoB8v
   fnXC/nRXgNc7icdRkzif/Nye2tS0Cb/L5cNrwI//Tl7fus+M3C6u0IVnv
   DU29+1n3wSVzodGtCW0sfVOrNOOo5K9J/FIRkW7tCqBDuml7cfFWRSsxq
   TwslzZ/9ukPhprxWgMk3NE1wwqeKYtahiWucMnIRBX4hQ4mGggkhn0Ol6
   rs/wmlv+2OplVNJ1hCWFZKdfJyft8mJ1yaPPbLhxVvPIFnQSaF7M9torO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="346510761"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="346510761"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 23:22:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="956076987"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="956076987"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 06 Jun 2023 23:22:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 23:22:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 23:22:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 23:22:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 23:22:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ViCxvwAY4ziX9tNRHCSeh92IAvYq3q8wEB9VH+uGDd75DD6GEUQCba4j9KQ0nusWTxH5DkiesVt2gUSboClEJkyTbSPS0hRdviht5tDcQgAHDE45eJ/1o8/kC+4sKAjiU0XqjwzF90xBhxQQJv2ad+L0ALJGZHfKQnNeJxO4sry72bs/UTN6d4pcnkqiQOuXTW8OWd4LSNfIT1pzfZ8yJhZl8vY3n/2MNmgwvl6Rg+p4Ow5VgJEw/Odw9OGut8XdJ3U6jeyuO4hTF33+10JNJpKZtg3gfT70150Lcw/IteJjF3/lCDTcrBnfJtc46WL5SUFz6L5aqcmLT5yhSDTyGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9s9dB4NOWwx+A2xoHwdb8Ppg5bb31w7Oz+1+0ZKrwU=;
 b=Pt5vFhKshuXDjz/SVojfLsHPMct7uuFg4N941715e/pHV91xjjQO+9Y8cU2Q111sBh9sUhFaALusCQIZOtlxcnh4T5vkWcMeEHdKhiYWCDOpzCRt7Nyh714anU0U70HOrFet5R1wvxcpjylZGmnl2waWbX/w8/i2hu546eNdSf7FewdZEJuX2OZaVdKR87Qo92uLdZNNtPv24QrFFL1yWnpKswszZsKtwa/SUsLOxyxh8GJu97vlX5XLY6/woUS2oV5fX6j2wM/Ehn87bXYm6IS8BXCpx/Xs79Ai7Gekwiz6+8G0JAlRAqoMYf66gU8MVBSK3rtinR9p/xiVpoCUfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by MN0PR11MB6253.namprd11.prod.outlook.com (2603:10b6:208:3c6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 06:22:07 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 06:22:07 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v4 08/13] ice: Add guard rule
 when creating FDB in switchdev
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v4 08/13] ice: Add guard rule
 when creating FDB in switchdev
Thread-Index: AQHZjjqtJKgpTaFEwkeCsZFOwowgkq9+9CtQ
Date: Wed, 7 Jun 2023 06:22:07 +0000
Message-ID: <PH0PR11MB501359AA00662CDE476517789653A@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-9-wojciech.drewek@intel.com>
In-Reply-To: <20230524122121.15012-9-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|MN0PR11MB6253:EE_
x-ms-office365-filtering-correlation-id: 47f7634f-6d8e-4f29-69ad-08db671f84ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5GlyYqGHsWS8GqaSyjq90S/k76MBQAMpvkj+hY5HIWmv6l1N6y/HRfbP3oJGg9H9CtAM2KwXuKoLA3ma1u6YBQGLqAe87a8qhov5okSzCNkjPOPgrpDPZEeFtM8796iwTOjX4JZvSV/3B4/veVjjQZ8jfAmRW3WBsBSzdgJA2E49/QY2J+YAbV4832YcH9bCdI7DH12EmXS4pu6uNlB/6bXMld4l9ydSuE/vd7FGTxmBSC+d7bEp//DAwRylPvb4LpH3/qxh7iYXXXZnXIk193Kp75FFp2tbQaAbYup5KPkDSoeN9BxwIADfYPtZsFAHy8FcxqeJA47Bqq3hQRQ5uwU/SC2Dq3yr1WwgzhgTqkTFT0ZRIdMwD0uHLv5xZEs1DKYTetoKc7MWIfKPc5AmwXMDkHppXxzUoJDHBGROGKM+wHJHC54qzBBb8hdNEOPA+xR2+USeoUD8XmqfiQ+7LW27e6DdcZyYl9PpaEIVG5ODeuGCIIfKxcpVE8Rq/I+FzMUW5gr4oApS2GZRVNXA3fhUaxlt1PWiugaMRPQmRX1DrVPaCX2erXLqQ8KI7NNV16nSPfCcFwrl+PpFdqR/ZrflCss8YbA6tN2ilefNacl7j43e0m6ejRTSvkzIj+0K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39860400002)(376002)(136003)(366004)(451199021)(9686003)(6506007)(26005)(53546011)(83380400001)(122000001)(33656002)(86362001)(38070700005)(82960400001)(38100700002)(186003)(55016003)(8676002)(4326008)(41300700001)(110136005)(54906003)(66446008)(478600001)(66946007)(66476007)(76116006)(2906002)(316002)(64756008)(8936002)(52536014)(5660300002)(7696005)(71200400001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?75wXIkg/i3CdBSEL/v5L/dL0zavaOI2GuqqTaicLVD/Tgrmd3Pym4YrmVBDc?=
 =?us-ascii?Q?KV2J5fJpOCo7/a3AVbmOd451e2qvv9sIVVVtUhkEjTE2zqMwlApoE+jF9WnA?=
 =?us-ascii?Q?+XVy+OAvjh10jJgjpp0ugBUax9HbpSdCTofbP3BtIT7nGVzUaLCzaf3U/7Qc?=
 =?us-ascii?Q?wO+CTxmvQZQKcc9t9aAdG+2arHgux4PApx2qn68w4v299KUvvACSFzQhWiLN?=
 =?us-ascii?Q?lkako9Q/7XEvaJramNO6rns5sSi+Jq10jRI2BfTIuyhBdAvxKRlc7LrNsL+/?=
 =?us-ascii?Q?quL5B0DlMdGiNlmt7QZ87D6A7H/3RCKgxuqE0bJJelJEdcweBSPHKpKXZQBf?=
 =?us-ascii?Q?CUHmYI1Cj0qjeeVaGlMkzDJoRKLvQ1yy82hOrJo7opo0ohOdxvoQcEwkuByX?=
 =?us-ascii?Q?xYRbj1HKULKUDeLhLVPEGFVQRKg+ctOW1XKcsKQJzt6xrmj2mnh2NFGz2/Jy?=
 =?us-ascii?Q?bG0AQfdP8kqxaAe7rczMSSiUGJTTxHjtvTvxZKF9uvL7kK7NUKN35V5riSAe?=
 =?us-ascii?Q?gX3YumZ1dee3cs4MookKloPlm2DbCxt7ZcbVQZnsS4jKXGLTlepwvcVuZ7Ub?=
 =?us-ascii?Q?gEea9+ieFXzQ1idliwm6YOxxcDEKkIw6IP1smcmtCBk5AyksdWJ1nTCh9w7Y?=
 =?us-ascii?Q?y1FAn66yMXdGKWOmt2o+S89P3sJwVlXiRvhxPvat02zb0p5ZhTcX6nAwJl2h?=
 =?us-ascii?Q?79mp2Oan2RJkHjG5ASbC6UMs7jM0WBfXGO4Im+hE2IcMcNsoz+S90zexpap5?=
 =?us-ascii?Q?Mj6fkfneuB2M8dgybyEztC6Yg4uEWUeFYIGv3aehxh4tpxVdbhsGvR8fn6jl?=
 =?us-ascii?Q?aBOQDvVRbzrwbSjMj4DnlW66MGHrPG4SVRIq3iILOY3jGna5nzBmu9LgzQof?=
 =?us-ascii?Q?aOvkF+Zx8VUcDqV+UjFZQYKsewu+9f8oHE0+33rVR+uLtS59jE54ymcsU13W?=
 =?us-ascii?Q?naZmeJH5EYookFtSs2wc6dwnvy8Z0b/A2wE4mkoh3iURMHKVfBoq5hvK4cSP?=
 =?us-ascii?Q?ivY+5ERa5QTYnFNKIOJdF0o2UY0Z9GBiCNkrU7AIM43SKSeP1HtTm3HPPRot?=
 =?us-ascii?Q?ATISnka0aqFOcst7hquc2PT/KyZwAdiTIySA2/VZY/VIyLLj9u3hzOStzgSD?=
 =?us-ascii?Q?3DkQF3daL49MDVnRFYn3xaWDHMTDUPGaL81UOOubGAk3okBgs6tZIOOey6oG?=
 =?us-ascii?Q?s1OL9djwddC3g7z1zi8ZNlOiD+uH3gY/KRto5Nl1w0jiGvPfHn0LsCWnAV1I?=
 =?us-ascii?Q?4rxV2hqrvk9dVTinww/9v9V1hc5mNbXjzdC1E3ZgZAux3hTjL+J3/QdDHzZA?=
 =?us-ascii?Q?esUEaaBAQLlFTdZCMlFoH7CeIxU+BEV5/+T4JkoBlLhpRhdsAKZL11ZIJRTq?=
 =?us-ascii?Q?gmWVHx+9he16sPDd5I1KF/LKMe3SaFQL6WLG+8oNgKvDbnWSNc1iuyWA0/ci?=
 =?us-ascii?Q?1GnSIJ+tpv+lv7SduQIVsBgTwTvioOF2/1o9uLdFuEiqABxVwTCCcACuTNqe?=
 =?us-ascii?Q?VX1M+IS1vXkc6MQ2p8f4bmkZCtlM3PdAtgYyjeFqV/iTFuAKXroyRCRKrP4k?=
 =?us-ascii?Q?lA2gF/CIyNUfSYHPYuzbna5LAIG3yLCGC1fESs5BNOjd0Iv5tBniUlx6yuTl?=
 =?us-ascii?Q?wg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5013.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47f7634f-6d8e-4f29-69ad-08db671f84ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 06:22:07.2282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jo8XDXfUIVkltEuPOLwt0+YRIv31/9XG1xc5ZOBKcMOxbmpOmP4AqMZEPq8V6L8KVdWbd6awYi2ze2IdmTh/43Tsq+WRM2wvP934n+P/4NU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6253
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Wojciech Drewek
> Sent: Wednesday, May 24, 2023 5:51 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org;
> simon.horman@corigine.com; dan.carpenter@linaro.org
> Subject: [Intel-wired-lan] [PATCH iwl-next v4 08/13] ice: Add guard rule =
when
> creating FDB in switchdev
>=20
> From: Marcin Szycik <marcin.szycik@intel.com>
>=20
> Introduce new "guard" rule upon FDB entry creation.
>=20
> It matches on src_mac, has valid bit unset, allow_pass_l2 set and has a n=
op
> action.
>=20
> Previously introduced "forward" rule matches on dst_mac, has valid bit se=
t,
> need_pass_l2 set and has a forward action.
>=20
> With these rules, a packet will be offloaded only if FDB exists in both
> directions (RX and TX).
>=20
> Let's assume link partner sends a packet to VF1: src_mac =3D LP_MAC, dst_=
mac
> =3D is VF1_MAC. Bridge adds FDB, two rules are created:
> 1. Guard rule matching on src_mac =3D=3D LP_MAC 2. Forward rule matching =
on
> dst_mac =3D=3D LP_MAC Now VF1 responds with src_mac =3D VF1_MAC, dst_mac =
=3D
> LP_MAC. Before this change, only one rule with dst_mac =3D=3D LP_MAC woul=
d
> have existed, and the packet would have been offloaded, meaning the bridg=
e
> wouldn't add FDB in the opposite direction. Now, the forward rule matches
> (dst_mac =3D=3D LP_MAC), but it has need_pass_l2 set an there is no guard=
 rule
> with src_mac =3D=3D VF1_MAC, so the packet goes through slow-path and the
> bridge adds FDB. Two rules are created:
> 1. Guard rule matching on src_mac =3D=3D VF1_MAC 2. Forward rule matching=
 on
> dst_mac =3D=3D VF1_MAC Further packets in both directions will be offload=
ed.
>=20
> The same example is true in opposite direction (i.e. VF1 is the first to =
send a
> packet out).
>=20
> Signed-off-by: Marcin Szycik <marcin.szycik@intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: init err with -ENOMEM in ice_eswitch_br_guard_rule_create,
>     use FIELD_PREP in ice_add_adv_rule, use @content var in
>     ice_add_sw_recipe
> v3: fix kdoc for ice_find_recp
> ---
>  .../net/ethernet/intel/ice/ice_eswitch_br.c   | 62 +++++++++++-
>  .../net/ethernet/intel/ice/ice_eswitch_br.h   |  1 +
>  drivers/net/ethernet/intel/ice/ice_switch.c   | 97 ++++++++++++-------
>  drivers/net/ethernet/intel/ice/ice_switch.h   |  5 +
>  drivers/net/ethernet/intel/ice/ice_type.h     |  1 +
>  5 files changed, 130 insertions(+), 36 deletions(-)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

