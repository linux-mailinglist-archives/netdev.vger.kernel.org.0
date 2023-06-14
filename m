Return-Path: <netdev+bounces-10938-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31593730B7B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:21:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C5FF1C20AC1
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149C6156DC;
	Wed, 14 Jun 2023 23:21:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0172D13ACE
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:21:04 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DDF268A
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686784831; x=1718320831;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Nw60cGoJdRpMShXAF0pne/7hAR35BGZO3D97nvsXczA=;
  b=R8Qt4Y4yS8cfuMDIT4qW4JeqvazPoRR06lb+w90UMLavBciun31MzM99
   miL9fHaVybxNjj5ouUMxeZm83tmnITkhT5yp9R9HMtPM353+6oP7fg8de
   Ds7dhfx1GPEpoAWvtBih10xa11CHC7DDpN9oYeW6k9XL8H6VFBpnfs+OQ
   IHX7PqheVWF4MJkNPwU6ao1Zt4K5O5seLzJZ4B8x1iTVQ9PIML/oaHRGS
   IqSbUtKPXvcrz9NWr9YJcQaYB2hiL8RcmEIgNV9qWJTm8EN48K1ox8AFe
   a3r9ZpdSMusnbgyMkC4GSQO64I9XZUVih6usQcuObUMdtXtKzZYgPISTX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="387176237"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="387176237"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 16:19:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="782277425"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="782277425"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jun 2023 16:19:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 16:19:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 16:19:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 16:19:28 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 16:19:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctrHpvEyTd0pcLgnkKkVxAuKNE/ITfe6hl/vlU5GWS3Frx8EZITDM2EgLrETFnlimlyX2GuXRMoPKayBCFJoTaoPr5+CIx1yKFs2+40bWaD+9TVyZZLpGv5AxUJgRnzmEzItZX8lMSGQ/QlJtaIDfvX4gqTRnSkNDK2Hleg1wTx7JS0+uD85OA32dMvzparB7PrfdSMhDwUeHhC2TDPYuXsA93yhOaYoISxC9vxJOZHyfbRAtrQMJ5/A+LaqmlQ9dm7/zXjGI9CTu6iM3HPEuX4Lkz1samaw0nd6DooFsu3CAbg9NLHC1xcW1FzYNV984IdjVCzLtNIwsXcfS5Zrbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nw60cGoJdRpMShXAF0pne/7hAR35BGZO3D97nvsXczA=;
 b=B0VXj8JmIMiR11/pGicNq1mV55KsudtG9jVZyQWksRiU9LDxxvAKixiUSJxu9hNC++IHuHhZrw4YEKbjROzZmJGqaWifWHAg3gVjauFAowPF1QGHOk4x1ZoiKf4Hw4GuCxsErsdzlLFuL+Pnspwv2xjU1jZLEN+rESY90ydi+ie1Th3FHVSrNu99ChJ/mX83mZudirXWWAsCrZdJPyjqos80zcnOKojRdvssYHHMSMR9e5aAHEilqy0XoPLru/Fa3SpgSk6FEDoXciTYCaDg4ZgdQv14YjlukJSSOnNA5fEo2XLWnnuSDKEeyc8GmP+BFmdWRPhxgOCPEhGRtPdLRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by CYYPR11MB8358.namprd11.prod.outlook.com (2603:10b6:930:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 23:19:26 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5e37:38f7:33d2:137a]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5e37:38f7:33d2:137a%6]) with mapi id 15.20.6455.030; Wed, 14 Jun 2023
 23:19:26 +0000
From: "Ertman, David M" <david.m.ertman@intel.com>
To: Brett Creeley <bcreeley@amd.com>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>
CC: "daniel.machon@microchip.com" <daniel.machon@microchip.com>,
	"simon.horman@corigine.com" <simon.horman@corigine.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH iwl-next v4 05/10] ice: process events created by lag
 netdev event handler
Thread-Topic: [PATCH iwl-next v4 05/10] ice: process events created by lag
 netdev event handler
Thread-Index: AQHZnwam8kEZIoOpNEC5ktVuu0r1zK+K7neQ
Date: Wed, 14 Jun 2023 23:19:26 +0000
Message-ID: <MW5PR11MB58117A92BC18CB758DF950BDDD5AA@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20230609211626.621968-1-david.m.ertman@intel.com>
 <20230609211626.621968-6-david.m.ertman@intel.com>
 <887cbcd2-d01c-2736-d0de-660de80ef4d6@amd.com>
In-Reply-To: <887cbcd2-d01c-2736-d0de-660de80ef4d6@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|CYYPR11MB8358:EE_
x-ms-office365-filtering-correlation-id: 99abd95e-b193-4f55-9281-08db6d2dcbc6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pUDvPrZ/Zof03TbX5xjBM9JvetvyAtPMaXKxzFoaxO3AptdYl7XjDVlZxWqEdSgcOu+9ehpf4sq42sOTWmgLsIC/zFNUDq0tnFXe5YMvcTVLZkmNyoSbq5a8x21QCX834sBPd6/Oah2kQrPPzPDlDkCexp8VG0CUvunDGCf7I4NyldV1fTjYjIPNi6AyGxSI8Jt9W+cc+QWV+XBq4ecfVI6hcn0onT6nbktyCZ370tEDaa2Hr/yl/MnVuJkLJghZxHB+ZWHXmDugWbmr17zGso5KYkZERHMpEzgrPG/SGlcckrwXSWJzJrccP4XpGkksGpVcdmXSDES0XgkXjmuXKZ161vZfwfzt96MXj1/GUVbUfBeckpki/+uoROl+nYZeQIkFqFTNRhnyxmFAXiHoqggQpWGGvrBBokfk+dtkifZA/6wom3fkA8SEO/n4Xx1Lohrq/niRkhXSfcFQ08hXZurUkEGLbAE27Q/GhCOD/pIGaTN55FxTS2Q57+kBCxfWXP78HT0S375X1Bhl8EZD9GtvI7ibBjbx3J+7YgQltpCGTTmRtWylfhmJTx99Or0LIO9Xh4rN6y9PniQ9a/0i8JFudTwV0QJ4Oi2SclYSpDuAygCH2ZraiwzT83aN+P93
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199021)(83380400001)(5660300002)(52536014)(186003)(55016003)(6506007)(2906002)(41300700001)(9686003)(8936002)(7696005)(26005)(8676002)(316002)(122000001)(110136005)(54906003)(38070700005)(33656002)(53546011)(82960400001)(478600001)(38100700002)(4326008)(66476007)(64756008)(66556008)(66946007)(66446008)(86362001)(76116006)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2FvQW8zMExxTVdFbG1GYmFVZU5xdU1EQnYydWtIcHhsNitKT09iVjFrdE9E?=
 =?utf-8?B?YnZXUjZKR25LdXVzNm1SL2dJL2E2QnRvT09lQmM5cS9WRURwY3J6c0k0V0xF?=
 =?utf-8?B?eUtBQzkxei81MzExNFV0NVE2b1dUanNZMmg0NHBjQnBrcUEyM2pMN3RyTkl1?=
 =?utf-8?B?WjQrVEdrK0toMEVzL1JtVEtQQ09TVExseEJHais1Tm5XSjY2QUpRRDgrc1g5?=
 =?utf-8?B?aVMwOVlkY3V2VlNqbjM3b1RCY2h1elVoZDJUZ3dpMHdCeG9yTXJoZ2piVk9Q?=
 =?utf-8?B?blAxdWoxR0RKWWRrR2R6VndVNmh1eEVuSkt5cDdHYUNCeS9rajRJR0V0aElB?=
 =?utf-8?B?MU5oZk9Ddmx1eitTcjBPcVZNQzJ3R1JIWU9qTVprdWF6QWU1ajBRQWhLQytV?=
 =?utf-8?B?dnB3RVV0U3I3MURpcXFzUGpwa0pCUUpYT2VJUGxVTkhQL1dYQTgrVHRwdFhq?=
 =?utf-8?B?emtxeDhVOXpVSHVaQTFBWXFKV2ZpUXJyUVhlM2g4dVZkZVEwUUZKakhDczBk?=
 =?utf-8?B?Nm8rQjg1YzVOVkJaMzZQdlltaFlXTDdpUjhjMGx5TFBJVnNtaTNjQnRHbjNx?=
 =?utf-8?B?Y2xuWWMvOUQvQzhQR3dMZ0xtVGpwNXdtUVJEbDhPeUt6STQ1WmJNNGUyR0g5?=
 =?utf-8?B?Mm0rTzF6NUhpSmxlMDZ6MFViMGR1ZFE1T1ZMcUNGSGhLL281Q2VvSnh6czRV?=
 =?utf-8?B?UkgzcGhST1FDQ2lhWUhGVkp5VCtoUEw4cXhmeEV6MGFTbjV3RkowTVFuVEpK?=
 =?utf-8?B?ZkxqbjlnQmxpWGExcEJ2M2ZDN1lpdUtmM0RBTWZHNGgrMWhpUCtRUVdMa3Nt?=
 =?utf-8?B?QUZ1Qmd6OXFVWlVpZU5RckwyUS82NSs2blhQSGlxL1Y3ekplaUt5a2ZtM0dv?=
 =?utf-8?B?dU03N0xJYS8zdmJBbnJNR3ZpdWM4WkdOQUF3RElERm8wL3dVa1ZTSjkvUWFW?=
 =?utf-8?B?cWZDMVN3WkpnejV3L0p1bitDUWdNR2RsbytIRU92ajNGa1phdjE5MjNLcDNo?=
 =?utf-8?B?SHZKNXczSVk4Zm15eDNPUjArcjExRGE5VytRRzdBTUlTT3BYZ2hCeEFHeGF0?=
 =?utf-8?B?VGhZMURhUUZlQk9abXBpMXZvSFQ5dlVvdDgzdXdvdkFYNElXSlAxbWo1R2xi?=
 =?utf-8?B?aUdQc2xrallVU3dqY1hNQVZ6NCtYZytLUEZRTE5IK21weVBJNXlnUWwwK3pK?=
 =?utf-8?B?WmQrd0cyZGJTR1VJcVZEYnppTDZPSmE1QWo0Q3FENjFpZWNHUzk1dVdNOUZx?=
 =?utf-8?B?TTZMeUVsaU40NlV6N1hOZmQrYzZabCtlWXZ1ZEsvak5hSzlMR3h1b2M4bktu?=
 =?utf-8?B?SGdKNDgybjdVSGF2cmlpTk80S2laWW9HbExOdU04L3RQdjRhVnNYSHViMlJK?=
 =?utf-8?B?eUwxdDFvWSt2bkxlUDFFdWduc2FCYytwSzRuWEJUQXEwRkNRd1NuNlpwQnZS?=
 =?utf-8?B?Z0xQTkcvV1hNNEI4WkN5cDQvSi9EMHdmN3hTWnNqa3F5d3RUSE9sNk1lSzMw?=
 =?utf-8?B?ZVM3MUNlZ0pMU0hieHhBbTZYWXNjU1VkVDJQUU5vSDg1SEpVYlhDZ05wTzVS?=
 =?utf-8?B?WXpxNWZnQ2U5RzNSdXAyS0NDRlUwbmRvZ2k1RzJkWmJibTVFRHZyT0FrY0Zx?=
 =?utf-8?B?aFoxS3l2Q21wQ3pqWEdtZ240QXdzRjhRTDBTY1lqaG45cjFCc0toM0Iwa0hY?=
 =?utf-8?B?b3o4UmVNSm11RWhCcXlZTHBlOFl1MjBub3M0VW5SKzJLazloSjZGSnM4Mkxj?=
 =?utf-8?B?Qmp3TDlpQ29KVnB4UTl2azlJeGo3cW1BMjROS1RibE5YWUd0NEZXS3VaNWtS?=
 =?utf-8?B?eXA1MlpwdjB5Rms4aktUbFpTWDZvZ09UZmJHWG9Ud2pxbkxsS2tIci9uOTRN?=
 =?utf-8?B?b0puaDB2czFKWTVPWG1OWkxHQ3Z5VUVlYjlmc0dwM09IN3JYWVZlV2Via2lo?=
 =?utf-8?B?SFNwUGVGcm55QTZoaS9SSVhCZFhRZFJ2TlpVUTAwYW9FZThYeU5neG0xeDc0?=
 =?utf-8?B?S1FUMmd3akp6dUR1bkZTdnRLaDRucjJPNE9NYVRhdXI2emdLS01OWFZKNENK?=
 =?utf-8?B?RlpIcW9JZ1JBL0lKZXUwRnJ5YXk2MStCanU0UjVOSTJnV04yYkNDT0M5V0or?=
 =?utf-8?Q?/FsScwc/TUrn1TkE3pvtJcNtt?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99abd95e-b193-4f55-9281-08db6d2dcbc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 23:19:26.2368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yoekKuR4kogxrZzcKr0m9V+7GZaZ4Iq/eQNQ6oRCCAY4ueZdTpGO9StcrS4YPYNsIwUCMzCycy2kkEv143F/EVpGEmX/mKhi5hgM5S5YOj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8358
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQnJldHQgQ3JlZWxleSA8
YmNyZWVsZXlAYW1kLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBKdW5lIDE0LCAyMDIzIDI6MjQg
UE0NCj4gVG86IEVydG1hbiwgRGF2aWQgTSA8ZGF2aWQubS5lcnRtYW5AaW50ZWwuY29tPjsgaW50
ZWwtd2lyZWQtDQo+IGxhbkBsaXN0cy5vc3Vvc2wub3JnDQo+IENjOiBkYW5pZWwubWFjaG9uQG1p
Y3JvY2hpcC5jb207IHNpbW9uLmhvcm1hbkBjb3JpZ2luZS5jb207DQo+IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBpd2wtbmV4dCB2NCAwNS8xMF0gaWNlOiBw
cm9jZXNzIGV2ZW50cyBjcmVhdGVkIGJ5IGxhZw0KPiBuZXRkZXYgZXZlbnQgaGFuZGxlcg0KPiAN
Cj4gT24gNi85LzIwMjMgMjoxNiBQTSwgRGF2ZSBFcnRtYW4gd3JvdGU6DQo+ID4gQ2F1dGlvbjog
VGhpcyBtZXNzYWdlIG9yaWdpbmF0ZWQgZnJvbSBhbiBFeHRlcm5hbCBTb3VyY2UuIFVzZSBwcm9w
ZXINCj4gY2F1dGlvbiB3aGVuIG9wZW5pbmcgYXR0YWNobWVudHMsIGNsaWNraW5nIGxpbmtzLCBv
ciByZXNwb25kaW5nLg0KPiA+DQo+ID4NCj4gPiBBZGQgaW4gdGhlIGZ1bmN0aW9uIGZyYW1ld29y
ayBmb3IgdGhlIHByb2Nlc3Npbmcgb2YgTEFHIGV2ZW50cy4gIEFsc28gYWRkDQo+ID4gaW4gaGVs
cGVyIGZ1bmN0aW9uIHRvIHBlcmZvcm0gY29tbW9uIHRhc2tzLg0KPiA+DQo+ID4gQWRkIHRoZSBi
YXNpcyBvZiB0aGUgcHJvY2VzcyBvZiBsaW5raW5nIGEgbG93ZXIgbmV0ZGV2IHRvIGFuIHVwcGVy
IG5ldGRldi4NCj4gPg0KPiA+IFJldmlld2VkLWJ5OiBEYW5pZWwgTWFjaG9uIDxkYW5pZWwubWFj
aG9uQG1pY3JvY2hpcC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogRGF2ZSBFcnRtYW4gPGRhdmlk
Lm0uZXJ0bWFuQGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2ljZS9pY2VfbGFnLmMgICAgICB8IDUzNSArKysrKysrKysrKysrKystLS0NCj4gPiAg
IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbGFnLmggICAgICB8ICAgMSArDQo+
ID4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3N3aXRjaC5jICAgfCAgMTAg
Ky0NCj4gPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vfc3dpdGNoLmggICB8
ICAgMyArDQo+ID4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3ZpcnRjaG5s
LmMgfCAgIDIgKw0KPiA+ICAgNSBmaWxlcyBjaGFuZ2VkLCA0NzggaW5zZXJ0aW9ucygrKSwgNzMg
ZGVsZXRpb25zKC0pDQo+ID4NCj4gDQo+IFsuLi5dDQo+IA0KPiA+ICsvKioNCj4gPiArICogaWNl
X2xhZ19yZWNsYWltX3ZmX25vZGVzIC0gV2hlbiBpbnRlcmZhY2UgbGVhdmluZyBib25kIHByaW1h
cnkNCj4gcmVjbGFpbXMgbm9kZXMNCj4gPiArICogQGxhZzogcHJpbWFyeSBpbnRlcmZhY2UgbGFn
IHN0cnVjdA0KPiA+ICsgKiBAc3JjX2h3OiBIVyBzdHJ1Y3QgZm9yIGN1cnJlbnQgbm9kZSBsb2Nh
dGlvbg0KPiA+ICsgKi8NCj4gPiArc3RhdGljIHZvaWQNCj4gPiAraWNlX2xhZ19yZWNsYWltX3Zm
X25vZGVzKHN0cnVjdCBpY2VfbGFnICpsYWcsIHN0cnVjdCBpY2VfaHcgKnNyY19odykNCj4gPiAr
ew0KPiA+ICsgICAgICAgc3RydWN0IGljZV9wZiAqcGY7DQo+ID4gKyAgICAgICBpbnQgaSwgdGM7
DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKCFsYWctPnByaW1hcnkgfHwgIXNyY19odykNCj4gPiAr
ICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+ICsNCj4gPiArICAgICAgIHBmID0gbGFnLT5wZjsN
Cj4gPiArICAgICAgIGljZV9mb3JfZWFjaF92c2kocGYsIGkpDQo+ID4gKyAgICAgICAgICAgICAg
IGlmIChwZi0+dnNpW2ldICYmIChwZi0+dnNpW2ldLT50eXBlID09IElDRV9WU0lfVkYgfHwNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHBmLT52c2lbaV0tPnR5cGUgPT0g
SUNFX1ZTSV9TV0lUQ0hERVZfQ1RSTCkpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgaWNl
X2Zvcl9lYWNoX3RyYWZmaWNfY2xhc3ModGMpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBpY2VfbGFnX3JlY2xhaW1fdmZfdGMobGFnLCBzcmNfaHcsIGksIHRjKTsNCj4gDQo+
IFNlZW1zIGxpa2UgaW5kZW50YXRpb24gZ290IG1lc3NlZCB1cCBoZXJlIGZvciBpY2VfbGFnX3Jl
Y2xhaW1fdmZfdGMoKT8NCj4gSXMgdGhpcyBzdXBwb3NlZCB0byBiZSB1bmRlciB0aGUgaWYgYmxv
Y2s/DQoNClVubGVzcyBJIGFtIG1pc3Npbmcgc29tZXRoaW5nLCBsb29rcyBjb3JyZWN0IHRvIG1l
PyAgVGhlIGlmIHN0YXRlbWVudCBoYXMgYSBwYXJlbnRoZXRpY2FsDQpzdWIgYmxvY2sgdGhhdCB0
aGUgc2Vjb25kIGxpbmUgb2YgdGhlIGlmIHN0YXRlbWVudCBpcyBhbGlnbmluZyB0by4gIFRoZSBp
Y2VfZm9yX2VhY2hfdHJhZmZpY19jbGFzcw0KaXMgb25lIGluZGVudCBpbiBmcm9tIHRoZSBpZiBi
bG9jaywgYW5kIHRoZSBpY2VfbGFnX3JlY2xhaW1fdmZfdGMgaXMgdW5kZXIgdGhlIG1hY3JvJ2Qg
Zm9yIHN0YXRlbWVudC4NCg0KRGF2ZUUNCj4gDQo+ID4gK30NCj4gPiArDQo+IA0KPiANCj4gWy4u
Ll0NCg==

