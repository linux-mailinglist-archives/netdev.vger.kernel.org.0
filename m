Return-Path: <netdev+bounces-3828-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26F7370903D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:16:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A2F01C21234
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 07:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE527F3;
	Fri, 19 May 2023 07:16:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C986D10E2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:16:48 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB44C2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 00:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684480607; x=1716016607;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6GuhxxmqldPb/Kq9Yg7i+TawS6ePqtOON/ZC/zo9wrc=;
  b=aQ8xihsafPBXCCgUTqgOZBm2y1iMS5MmIiyGu3cQ6myDnRgsePd9NKPd
   cjzDTvdn0E8O3uhILMWVb2mMcrwHQ3r4lVfgHydVFhcLfcSW6Vs72c4kE
   olKe7W4fIMOebKJKjH19G4DNVIk6CVzMHwn1K/UDTzyPgM9JbQvaN15OT
   VOMKkq0HwrsXnqm0v9cPlGWKRrHRfLQK7ftLGE2GKV45aXYCbD9kNojWc
   71FyyKSaFMM++LRm06EjKRV2YExtwZqVTHGCkUcspAMvPk4z2cFLj20OD
   WxAE7YAGFOMjtsps5j2YWOgTnUA1UlNyr0Gnq8zcIdDgwiGG9S0nRnIIG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="380515476"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="380515476"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 00:16:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="826692506"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="826692506"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 19 May 2023 00:16:45 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 19 May 2023 00:16:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 19 May 2023 00:16:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 19 May 2023 00:16:45 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 19 May 2023 00:16:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eglDrynb0hr0ie7edQS1Y76cVgohJhl7YL/kM3LuuYcY3RPQUggJfaeBfhx/HSI9gTeL9fxz9GIoAylJDVZIa2t3P64ldUED6hRLMEdkqjLMbiLnYJ6HPXe5ngY0HZALyUaqmMFyMIR7ZtLuNQrQBe1Z/wCK1Pp8L1MLFJ8Q8LoUdlEmyBM6oy+292VDRxp4iJ3U/Rv6nu83IkzsjJWC3T3mx3q7QjuvTODrNTgP+pDZc3EZMK8mGfAp1Hi8iC6LvOz4EXbG+NbkovAvT1YLc41Hw7CjnjaSH4Rfy20WlwhvG66n2eTIkoC/VijD42660kQHD1FrRC1FtR/vr7SH2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LwyKuJ2qeSYxace3+Yt83l90zK+LxjPLldKaRaw6sLM=;
 b=CKwe3XSCYNJZme8vYBXYC4OfxAmnu3fPbVt9YEha8GzBMgNT+i9xnb+Hfj1MhPGuoEoh9G4dcOOQOGhOOIGLeaOQmNFD7NbySn8k+vCe9rhz+X4xGUlbdnoZxKsiPqRnRcLs9wCV0n6faB3VZuArCZK3OfdTHCd/WUcW7bfuL9hzCsE7RKywffkTEzf3qlq9mererOrmF9rIJQgmj3efarGCvr8Qf4n7aJD+vvPpJQzi/JmFTuOwoyDbMeJ3oILO+I9KQcmP/hCrWcybn8r0KfW5heaEEFLFTdIMKb3kAjSIaW8PN5WmZncR6NBVuCDh0cBRWelgBqmmKy18OTWwHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3122.namprd11.prod.outlook.com (2603:10b6:208:75::32)
 by SA1PR11MB5778.namprd11.prod.outlook.com (2603:10b6:806:23f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 07:16:38 +0000
Received: from BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::f4d9:b675:9fd6:72ca]) by BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::f4d9:b675:9fd6:72ca%3]) with mapi id 15.20.6411.018; Fri, 19 May 2023
 07:16:38 +0000
From: "Pucha, HimasekharX Reddy" <himasekharx.reddy.pucha@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "ihuguet@redhat.com"
	<ihuguet@redhat.com>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v2] ice: Remove LAG+SRIOV
 mutual exclusion
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v2] ice: Remove LAG+SRIOV
 mutual exclusion
Thread-Index: AQHZh+ohSJmUh2L7QUqjH/vMa4wOWa9hMydA
Date: Fri, 19 May 2023 07:16:37 +0000
Message-ID: <BL0PR11MB3122A718585E64AA3E59734CBD7C9@BL0PR11MB3122.namprd11.prod.outlook.com>
References: <20230516113055.7336-1-wojciech.drewek@intel.com>
In-Reply-To: <20230516113055.7336-1-wojciech.drewek@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3122:EE_|SA1PR11MB5778:EE_
x-ms-office365-filtering-correlation-id: be5dcc93-1674-4e02-f146-08db5838fc2f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iTqDDZ4j3c8tdJz1GA0RdXYsKvvWoJD98iZvjuG2v2maFpTW8dQR5fiocVnD1zr+baWBxChEDN/YmbkdgHg+pf1rB299/ShqUilxnsg1v5KYYA2xw/x2sZoFC5D1Wm62OC5onzd9Ds1Ht41on5JdDQfTY1IugdMrFpTERHDBou8ras3CC83CaVf1wEeGVaWPyiwgZEmPFqTn8R8hIuxpn3HJLY791hiYFQVqE4vLvpVlpAEnOBArDFjXWeOd17fiZ+ee9QVGsKuzrYtDzmT4VYBs4rB4ORoETShIx0xT1nyVq5CAi2w9zcopv9xYovt2n6SAX96G95n5S6kFQWcZtir66NQ7X3zWMdv2TIPijFaRYb9zjVD83Fyr/FE/MpXSXo0Oe7J0pdbIP6BsZ49NZL20HHaUJlT19MJmj9tUBI8glVgvAnrM6uPYxAT2ZwW9PlCKlN/u4e2OXo5okeV/S9AxG4RpDbz1SZ+aGp9Ga7arv6cRdJ9I1b5e7revD2ozAc2YdECMUngx5Aap0GyQ9MuRHS88PbUpF1fuH1+uJfvAlvuh4y7YsZocQreQe15UoRvH+qMuyZNOOw1vPvKtGmXiZRRdeea1Ah0aa+rKyW/4khXJsrcTbm64ujCU12aQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3122.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199021)(71200400001)(41300700001)(54906003)(110136005)(478600001)(7696005)(4326008)(66946007)(2906002)(66556008)(64756008)(66476007)(316002)(66446008)(76116006)(82960400001)(38070700005)(38100700002)(55016003)(6506007)(26005)(52536014)(86362001)(5660300002)(33656002)(8936002)(8676002)(186003)(83380400001)(9686003)(53546011)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1dV4yAx+RM01qxSwd6dWxLVe6tBXozoDeW0SwQuQ4mh1Oo8OOdqELZTxd/iL?=
 =?us-ascii?Q?v7ddo7H8wLmMh4XnaMA/2OBxY+qOBHYFv8u0stVbB5N9JxNyxbXkif8P0CQ6?=
 =?us-ascii?Q?fU/BlAc3nPamQZ0+voqKipqv0zXPL7RcGhXTZfF2MJWxnzWmeWW/Olgq0x89?=
 =?us-ascii?Q?3xJEp3rFv6+mBEv4AG5V7kOtgUwGSFkwIc6ZVTF3z9ijDp7caxmwy5NqigEr?=
 =?us-ascii?Q?HJeaGfNV4qhYWgF8ahsNVWpS3a2c81fNKkEieMcx6eNYi+Sb7BL2Bx3LkISu?=
 =?us-ascii?Q?anVZ/dSD7Ucy6d+t9xkG3aMo5XTjd0SOjIzlaKwObbGdKSs/IS3bGlAqY2lv?=
 =?us-ascii?Q?zHANgSSUv9UWOQZih6LDnKl4yqfWI+ACQIfXgCfEmzmfZnEUN/nRJBkYdKcT?=
 =?us-ascii?Q?hV9yQFHyAlKpraCg1/CkHUah6s0Rc8vG7bqTTIHSZtqP2mtvvDYe9/Kpsoqc?=
 =?us-ascii?Q?mLRhA4RcfK8+YzeAqe7G8dNpR3kJLb0YxoZtHY82PErhz+y6gRFMrRh+nQDs?=
 =?us-ascii?Q?xiEdaqEuY+9Qr3PomSfOuU5DW3kWPRSJEggJqyty1cKFE4Ol5RxwWWcGjjzz?=
 =?us-ascii?Q?NZqEuI4fj5RoUf/eMUTfpMtubXyENx9Y6Dnot+2PvJjWNFKGTG6AzmB2YDJY?=
 =?us-ascii?Q?gl7j+v0WWT0kztBOowl/cTlUfsbDbNcwh6KOsDB6/Hf+r6uJv2KZoG8G7XIN?=
 =?us-ascii?Q?8nSa1Ag7HkbPhBQjWL/0gJdqRPfZjmXRu4/syZ4TkBFC+gD+ROrusLUiDkCo?=
 =?us-ascii?Q?Q5WffVShyWgiZoCb9IWshD9q2afays4R1ig0dOpYOyGlYNOQwlKMMNI62Ufs?=
 =?us-ascii?Q?JPqyvKeRnGTylVRZb6S2H8aRrxswKlk7uDohmd6l/c/GsUf2qqMUiuxD/tEd?=
 =?us-ascii?Q?H9QA16EchvJ+/4TOtp+xydFN24TGdXeeTLgxjRWXZNk3U8o2kjgSu0gyJT4P?=
 =?us-ascii?Q?TOxZprrW1ASRXF/MunMBjbfJHQq+mmbPjY/GLjDZdpGRmDY0sou8JTSg8Mf6?=
 =?us-ascii?Q?MO1dVU415FOho22BBs26d9u1yjlYTvA8yQWMxgkqmEHtsKRETSHBkFSj8pfk?=
 =?us-ascii?Q?ungNKYCI0Qa35GWmGNi9W2rg2he6Crbm2PAME+p0AjVcoC16NLiQJvk1/yaI?=
 =?us-ascii?Q?XoHq6UBpxxRIHiD6UaqrkSysiWudrPzeDz8QTkO5ObTSa7PwXyqcm9ZtyXxO?=
 =?us-ascii?Q?x3/ozdGFy7Inys/bFU+SMjfytXfKcMAYb0z/+o2DSgCZvp34aYYKmUFjFMmA?=
 =?us-ascii?Q?5rN2AbNqGt7AG1Kn/0jd03HJ0WamoAJta86YS9HgP4HOXGeU//nSfeddkKis?=
 =?us-ascii?Q?4UIvhOjhnolBu+V7No3Fp5UNusJV2JHXz25MGtXXRyQYM8nOpN/RsDJQ3HlS?=
 =?us-ascii?Q?waJXg87sMOu+ZLNKz8S9EUcaL2jdWP5aAV+c9CjMrHG5eYpOFod5lGRCx6yJ?=
 =?us-ascii?Q?OAnjo7Zay37sKmaNDJLnvZR8NOPv10eapxpObQLjtD6oYnt/EvVYFnxBROox?=
 =?us-ascii?Q?fylAZ6Ng84ZvU6jEI/EJQrY2hmHvtbX/cnaXejk7j7lU6SVCG94fLUcYfRdp?=
 =?us-ascii?Q?GRok5MjfIm9JYNmljNZlphsrXmEAWQ18VmZq7ovSbtkQwJT3AjsNH86x5QiD?=
 =?us-ascii?Q?lA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3122.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be5dcc93-1674-4e02-f146-08db5838fc2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2023 07:16:37.5109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c0lMS99dE4/32n/bC0u7O9CyLLOkETQx5/kvYTGh0D26hLdpHu2RGgAvCVg5rDej/KeIPQCy47hGyrKkh1+dHajtrNwS9gmQhoG0GTHbSWmC3TFi1HH5Vm5TWpGH418q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5778
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of W=
ojciech Drewek
> Sent: Tuesday, May 16, 2023 5:01 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; ihuguet@redhat.com
> Subject: [Intel-wired-lan] [PATCH iwl-next v2] ice: Remove LAG+SRIOV mutu=
al exclusion
>
> From: Dave Ertman <david.m.ertman@intel.com>
>
> There was a change previously to stop SR-IOV and LAG from existing on the=
 same interface.  This was to prevent the violation of LACP (Link Aggregati=
on Control Protocol).  The method to achieve this was to add a no-op Rx han=
dler onto the netdev when SR-IOV VFs were present, thus blocking bonding, b=
ridging, etc from claiming the interface by adding its own Rx handler.  Als=
o, when an interface was added into a aggregate, then the SR-IOV capability=
 was set to false.
>
> There are some users that have in house solutions using both SR-IOV and b=
ridging/bonding that this method interferes with (e.g. creating duplicate V=
Fs on the bonded interfaces and failing between them when the interface fai=
ls over).
>
> It makes more sense to provide the most functionality possible, the restr=
iction on co-existence of these features will be removed.  No additional fu=
nctionality is currently being provided beyond what existed before the co-e=
xistence restriction was put into place.  It is up to the end user to not i=
mplement a solution that would interfere with existing network protocols.
>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: remove ice_lag::handler
> ---
>  .../device_drivers/ethernet/intel/ice.rst     | 18 -------
>  drivers/net/ethernet/intel/ice/ice.h          | 19 -------
>  drivers/net/ethernet/intel/ice/ice_lag.c      | 12 -----
>  drivers/net/ethernet/intel/ice/ice_lag.h      | 54 -------------------
>  drivers/net/ethernet/intel/ice/ice_lib.c      |  2 -
>  drivers/net/ethernet/intel/ice/ice_sriov.c    |  4 --
>  6 files changed, 109 deletions(-)
>

Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Co=
ntingent worker at Intel)



