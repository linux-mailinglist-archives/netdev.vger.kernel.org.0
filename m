Return-Path: <netdev+bounces-122-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A32396F5481
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:21:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 527F82812D4
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF659466;
	Wed,  3 May 2023 09:21:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C14ED2
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 09:21:21 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE221BFA
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 02:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683105680; x=1714641680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Te4l01bH/yrI3PuNDde7J+9oJ/DEww0gk2HrS86AhNE=;
  b=V7NNa4bJMV7CS9rGyFIy2YwM8pZ6D+9J4pYrItqg4GdWFHyjYmpKgo+u
   LAxeGQERNlXWMFWtqg5wsDnO8omgFcguNBAtPxzAp3i00ewP3/lb7ZvBO
   8mEot3Hes/FRjyySdelKkEwuhg4DMDf8uDFXNKmLU152bGCnyXIlFJi/7
   OQhuzV6WpBCP6MKbaspWW5cWNp9vHnzgZFsbSM0dgSb0s76i2t4fAGnEU
   2H80ncEMVqYD9sOR76qBw/P64T/O9gn2H7OeUXilST4+5W25OVEiN/wQR
   o+0BAsrNsbGXbN81vuZK+GLBF5rVxbw6ZC0Kp73b/UJI8bu1bZwFRuXGS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="346088722"
X-IronPort-AV: E=Sophos;i="5.99,246,1677571200"; 
   d="scan'208";a="346088722"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 02:21:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="942779986"
X-IronPort-AV: E=Sophos;i="5.99,246,1677571200"; 
   d="scan'208";a="942779986"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 03 May 2023 02:21:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 02:21:18 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 02:21:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 02:21:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 02:21:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PsLd06sh+OyI+p6b4ukiE+iLw3fAQ6iPGn8owdsBmtC1p/UQGzNGT3t/C4Fpq4BB43kq9tsFOv51SSelBgFhTs5Qb1aROYm9Ymga7yx2xW6ZBnCxp69zmMqnKYnkoMMI736GreWD5fYzVcQQ8AAj5orzOFwsWDhZTiTOHeFLDRlCyR9fkukSVyZze5KnWd2Awtm23Y//r9dUXL6+liDPJhp9cXTgSNW+31eH6/yl/7cB8Eo3zE3VZQn2h7FJZGIz+qsitR+JWUTsvjPGD67G3d3mTOkU+JQ3fN5wRLG6HdetdwnRUP6oQHiiOIq7xK7+DwUBOcD0xEWwFH/JhtQi5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+uinpYv+SwtJplQwHq6ZtuFsElTZ+ujwnMi0zu3srLY=;
 b=CYpxxneQhLVIp1QgdDsCFzpT/PeCsPaDcUk7xkXbjTh3+kGVvMARRy8v0wK49MKtRG5y3sGUo633TfyzIfdfSXGgee3t1x1sJJthis1wZQm0faP4umzmFuTQKSnEfsbFjFHwpfiOz9otbNxelgSemNV6u8YO2oNt4dtAZhJg9+9+tnvsYEX+TSCF+O58vSMcXq4J+w/kqgD1wIQgX4cLuJndP8srXaoUlWqKaxtD+O2B/24kHWgciAgkoDsiuiyahsY5yA1oU23dodLZD9MnwBBKcCKuJ2GC3a2rSsACzjxsnOdwpI085kV2mDsVjEWiRU+1XFOKZKETqheVUUBj8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20)
 by CH3PR11MB8237.namprd11.prod.outlook.com (2603:10b6:610:154::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.29; Wed, 3 May
 2023 09:20:58 +0000
Received: from PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::4193:37f3:d925:74bf]) by PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::4193:37f3:d925:74bf%3]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 09:20:57 +0000
From: "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
To: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Szycik, Marcin"
	<marcin.szycik@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net v1] ice: block LAN in case of VF to
 VF offload
Thread-Topic: [Intel-wired-lan] [PATCH net v1] ice: block LAN in case of VF to
 VF offload
Thread-Index: AQHZeMeBZEtyq/slIEa5qSB6+sByXa9ITKYQ
Date: Wed, 3 May 2023 09:20:57 +0000
Message-ID: <PH0PR11MB5144752B3914DC9774D7D121E26C9@PH0PR11MB5144.namprd11.prod.outlook.com>
References: <20230427045711.1625449-1-michal.swiatkowski@linux.intel.com>
In-Reply-To: <20230427045711.1625449-1-michal.swiatkowski@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5144:EE_|CH3PR11MB8237:EE_
x-ms-office365-filtering-correlation-id: c6af38b5-d973-4b8c-0c25-08db4bb7b435
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gGfuNFMx+DoN+uMHTKn6eexORWpFFjssUiHU8wvQTx9l+SG/WPFF2m5X5cR+ZV6tSUjNtNZdDUH2NJ+anvOFXvgCC0gFpPtsGWkp/q9UiRXVY/SvWYTrj+0zfLzS/JwxkanNyzeYSIN5r0CERQc8FUZHf9mkEUQKTMDjbeAeUA3ZkFK81b2v+fpXD4YOh1We/nY7Hmp58MgUuZLNFxmciNNWMdw0s5bIfoOkMCnyMXpbUt6vgA/OGujUGbwLPappdrvz1gkThBJl9bv08M4HSC9x347sPJcj3VjnL57qmwW+KPpbUGGFtnxDbLc8epAA3UWSgx8t9NJ0ArOEdKP0E4Nz4KwYLjF6tW9Qdl/RUP+DguNrlF4iqIxtb98QWN6vup+oeoEuFm9pZE8ByhOvyv1UJeH0h0tHSkzLxDYqUKOsrzinqgIIm5/QC2FYPk6gALDgL19i06NQ7Re9r08Ma9A0TeLh+Q5NZbWucw+5IDH1Ul2EyRK+ZI9BVBziTD+qy2ehhkVUBmFm9jnzjLjgLc47I3ctCuGC3GAbdh32XZD+Fd8mwSn9nLqbMpwWcLu1piodcEpvGTKVrbBxhfVFYIMJYc86RhgvqPCMGlXlaQa2404Ap7xLc6mQIYCP+H43
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5144.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199021)(53546011)(4326008)(9686003)(6506007)(316002)(55016003)(38100700002)(8936002)(8676002)(33656002)(38070700005)(86362001)(5660300002)(52536014)(76116006)(54906003)(110136005)(478600001)(26005)(83380400001)(41300700001)(2906002)(122000001)(82960400001)(66946007)(71200400001)(66446008)(66476007)(4744005)(66556008)(186003)(7696005)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eT9XsgOz0T3xhrIHTE9mn25+2YoLDR9/loQEbmTDM90LeMs4nPv6AQTeMTbK?=
 =?us-ascii?Q?F1qyLWdLKScxMZbrPZvbQpZ8awTMu+JoE7sNezbhcIj60rQB+ys+fg4Muh16?=
 =?us-ascii?Q?b2ILk5p+ZQFK6k/UnsWDYbn44+jX3wmyuFn3dP1UMiBsFFHpJBWRMOMyy23R?=
 =?us-ascii?Q?ujET+XzHsmJjrs9og9RoR+h1TL1wjnC9ivOk83x3+7vRdRaXL4yZdhdPGiep?=
 =?us-ascii?Q?kz2FL02DPZqOnHrKwJcfIVCKBtjJgz9CcM9frY/I6XAM85vvRNDw28f7hxiy?=
 =?us-ascii?Q?8aRl1eJ8gkwEE+Iveot5VXetHBJpVte6xrBKqHK6UbEGQLL37cTyHJlEp7vf?=
 =?us-ascii?Q?mo9JwyTz+hN3QCparmluB7IsRAbGbMUQ2hCbIWeXelVlHWL+AdzyeJ/8wVdL?=
 =?us-ascii?Q?6nfuq5ixQqx+YJRniCRqaBghN4PfUNwgKtLUR2arxMGRw9dSsRPKRCqY0Wy8?=
 =?us-ascii?Q?2eCR6ir4OHGUV+YI8obyqeCqhT5mk4P2SLjvNXQE2vM3v6KP3WBHrL8oZ00u?=
 =?us-ascii?Q?HuQNNBepuK4qsC859fFw2yM+DPc4+UgRYK0p7sIt8O6zyjd/rC+kGipZgGGT?=
 =?us-ascii?Q?CGydsFt0+uztu79lKyCtYNIwGGVuVqMgR8q0lJBKvlPtDAP4WqhCCMmjBJgs?=
 =?us-ascii?Q?kpz5ITq3QbQ8BK/41fX0cFkElfl//8qva3KSTn7YBlgy2hSBEGNYCk2w/GNs?=
 =?us-ascii?Q?Z1AKC0ScNtOc7xtGKYdcVgU/t2pKFmxYONiRk9asQJueHbR0Pj2KZwYQuuiX?=
 =?us-ascii?Q?ldYz/lgmxGvPuLDHLbxuZDBxx7Ri0yhABJOlPkkXYMS4ANMvA9M8yzes4yWs?=
 =?us-ascii?Q?bvB/lw+urimiewM2O8IsP8GYIcusShsoBJ0B7GD99+H/ZCBqNMHncUSVys+u?=
 =?us-ascii?Q?PAO7kVn0v1qKPXbuJUSZegQrMMhJXPPyGXyr8yS3yl9q0tyyzfRZVG4ASNfC?=
 =?us-ascii?Q?7wEN4aK5GvP2lTsWRPbvEh0dPb6O9ZUJ06NqHh1JCUqN6GhKvpddyXcsOVjP?=
 =?us-ascii?Q?x7gQBTyZrc7C0bC9v8Vfn8nca2thEnG7ZPHCFunb5LWEU0kzK4PbswjNQNeN?=
 =?us-ascii?Q?URS7neg5419EMEf6GfA0L3dt4laPywVWVwaOPdVEKqfvmeCmkY0M5Ygxdxvb?=
 =?us-ascii?Q?bD7WUBHc1QO1TKL+m1K6zzVK6jXuYCr7S2mLcHOBYIlYiQ2zvXdk+t3dsb9w?=
 =?us-ascii?Q?JPabgXg5Varg88FTkrUa13CPrYDh+2BhBbYNhy1pFSU+RAU6+dFO8Z8jJuRn?=
 =?us-ascii?Q?OcBzHlUsj8twO0qUwJonbl1yMtsx8qN8uAeR1qUekkgJEx+cNrODHUCyhNZG?=
 =?us-ascii?Q?1cfhXyIlTfIAWMSnukrKOmSsdhnhfodzsMc4uWa89O/WgYczyFjox3lYQPWe?=
 =?us-ascii?Q?/G9EAgX3+Sh2gctJA+Xf5g+FqvbvYH+p7sMksMEAIyhoRf/ymnJuoH/8QZYs?=
 =?us-ascii?Q?q8zDneStIiiNYR12QOknOsGRfQWvV3UgmHz7od7LcYbI5X4Cpgu7V+Wuebqi?=
 =?us-ascii?Q?LR5l0XFpi10VzsNnJMbEDiRFp0hAty6ypHV3WL+nPLhX6Rnn2v3wpHJWgdZJ?=
 =?us-ascii?Q?i/c3rHX7tkuo/0TCO7GWfWCQJri5wCaD7RdCfjno0cd3cUfGa3aOAtTeRzBh?=
 =?us-ascii?Q?RA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5144.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6af38b5-d973-4b8c-0c25-08db4bb7b435
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 09:20:57.6937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: opX+TI5QNcuGujbi+Nauc++9l6akdg1dbzCv5utUdpZH85e5txAAln7qE7UyiR2He6YS1oi069qoosUlPdWHdTUUUVLZ/CVqHMixTQXSjno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8237
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
ichal
> Swiatkowski
> Sent: Thursday, April 27, 2023 10:27 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; Szycik, Marcin <marcin.szycik@intel.com>
> Subject: [Intel-wired-lan] [PATCH net v1] ice: block LAN in case of VF to=
 VF offload
>=20
> VF to VF traffic shouldn't go outside. To enforce it, set only the loopba=
ck enable bit
> in case of all ingress type rules added via the tc tool.
>=20
> Fixes: 0d08a441fb1a ("ice: ndo_setup_tc implementation for PF")
> Reported-by: Sujai Buvaneswaran <Sujai.Buvaneswaran@intel.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_tc_lib.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>

