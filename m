Return-Path: <netdev+bounces-10799-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 469EC730586
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B4761C20CE5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 791402EC19;
	Wed, 14 Jun 2023 16:57:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617F77F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:57:07 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE7E1BC6
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686761826; x=1718297826;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EtCGyIYsSnT0MS8ZPjF/wIV3OSY8ymGDCsyMtHRh2FM=;
  b=YQSLWsTsMNsJ/hLgO5MpgQZvJJGcqUQPs/8AWfDMy5UyKvOF0Wo3qIai
   r27fEyO1Ag1T+AzO/HAy3UxE2S57B4o6GB8rVLfQpGaMlwBO7s5sgLrQ9
   LlTwiHl8aWkWj5gxH9lJw2T36DDljmpsbX8wl+2/VO5dd1EwvDxSCniwr
   T9rCNSh02Z9rH1Y/jc2zPs2pAvVd/x6/alDFP4K8hmN7MoPjk6xYz5WAk
   2QiiDRfeJkpjHrdLGpJBPB2JiqpesrEljJTCmHeKvtERZUUR8Z03t2rVK
   izDZPdf94Eu93OISzQ2LXFDBwdaQyAVfnSpgFrcDKKwWEXyWe5WafGfKJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="338306598"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="338306598"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 09:57:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="886326015"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="886326015"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 14 Jun 2023 09:57:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 09:57:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 09:57:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 09:57:03 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 09:57:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bF8KW80v09GW71ex3sbNnbwW08iUt4ks4QmZRywhg2jJb2F2cTuuXjPjeVX9cI5qhIfiZoyb7COG0dr2++G47ZYPk0AsR7qnbFFybDSRnDYEWKMh24y61ZtQU49DXwM333uQmEKEEwbtz47OUz5CgAOj8qzRGPnsAxSN/e/Rjht03GWo2H3ioSXwvg2W470hFbAEfxYoO4uRYjOjC+vx9GmfkRO6SSVKrQsxYFzDBBippDrbTMKfefTOHp7vO/mgj00PqX5RRnDwcBfbMqty78ORH9hRwntYUwG0w0FeG4+qiRFvodqp4B1UWBoaXwkPzXoFXilEXQ7gZ92MnEnPAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EtCGyIYsSnT0MS8ZPjF/wIV3OSY8ymGDCsyMtHRh2FM=;
 b=fMHXF3csEHdeLXGwlU/QnxdLpZtsqN6y3LyuAO8H0HlZ2b/bUPhYDGAirS92LxupUuL9rSNnrRjmoXCXHjyXcvCLjfNGpXnCiaxSHqSCayVAJUSHZUtVtwJQ/dut4E7q1gKIDC4hOFXwYiPbFGOL6CYGzENCAje1mGEAXco+a3siT2RsTIie20TAxJEYehL5reZQBrLWsagcMYqKkiR5w7FlZ2zQyIRNMsZ6CSldKJxlC+b99YNMoU6W7ggMNVIUnixrwGvBde23rV9H+eXWqKLbMqTN/R4mlvv7aIva0EJ4Yv/uhRDnPDM9n5FUEFQznSv4CjZexvLVWfvf7E/9+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by DM4PR11MB8130.namprd11.prod.outlook.com (2603:10b6:8:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Wed, 14 Jun
 2023 16:56:53 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5e37:38f7:33d2:137a]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5e37:38f7:33d2:137a%6]) with mapi id 15.20.6455.030; Wed, 14 Jun 2023
 16:56:53 +0000
From: "Ertman, David M" <david.m.ertman@intel.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"daniel.machon@microchip.com" <daniel.machon@microchip.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH iwl-next v4 02/10] ice: Add driver support for firmware
 changes for LAG
Thread-Topic: [PATCH iwl-next v4 02/10] ice: Add driver support for firmware
 changes for LAG
Thread-Index: AQHZmxeMU0H/mWURmECI3Vg6OeoxwK+KLYgAgABdmDA=
Date: Wed, 14 Jun 2023 16:56:53 +0000
Message-ID: <MW5PR11MB5811EF2458CF3AC2A083C64CDD5AA@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20230609211626.621968-1-david.m.ertman@intel.com>
 <20230609211626.621968-3-david.m.ertman@intel.com>
 <ZImh4NunKEpay3zu@corigine.com>
In-Reply-To: <ZImh4NunKEpay3zu@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|DM4PR11MB8130:EE_
x-ms-office365-filtering-correlation-id: 41ef31ba-c4f4-439d-3c8e-08db6cf85ab0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Hm1bHVxIfW9sn8gtP2GiGFEI5S5iNnTVJwPbtFlEbWgDnsHFaRzYKXqSRzXrU5EkPY7HmQzSzAcDTleIuWlBMSN6RpFjzEoBWglZgp0vqVIxAewfBQk3d8PY11S3rtlZ4qnwvKT8ww3pn/j5lmvRMB2s78vcq8MaxSASCKRDdAHbJvxkZFspGx6f9PuL/RRuFVUsYcTMbPn4sszdF7oARPXhku20IzDGXniqtBqEOAU0BEhNUEeTut7TUEKEdR60uxsSSZ4N5/cw9cjh2qgW6rcIhhr9LQZfRTRne2W+hjLVIViuAKPRu+iMmGfHSf7tJDjZhyhfEtqOunzx+3kddG5oD/7TneyDBv5nvRfl0zOFf9W4vJv+2A5hyM2jW1yYFte3ilisQmbt3TogasbrvKnSKQX1yx/KPatjPUDGNnsacpH/FEnVHFRppms1IThGpsPC78sqKl3e20n/Zu0ZX8h66/p5Tg4blkls8irHWApEdJFKhJKasG6Tmv/vqEwEafN3SdELDw2dDWRDK18phQgi2cILqz6GUblF1C3PrQXVyNcd2tBnUjWGJmFvVs5VhyLiRk+xG4hb2wpBLmw3ktB+zXe3tpOUoYOn07pJ2r9o0Nuv31GGVq81VXmUO5P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199021)(54906003)(6916009)(4326008)(66946007)(76116006)(66446008)(66556008)(66476007)(64756008)(186003)(478600001)(2906002)(316002)(8676002)(41300700001)(38070700005)(86362001)(7696005)(6506007)(52536014)(53546011)(9686003)(33656002)(71200400001)(8936002)(122000001)(5660300002)(26005)(82960400001)(83380400001)(38100700002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkkvNmRSQ0lEQnpqSkNnbXhNV0MzMUdKZzFtQlRpSFE2d1NWdXZYbXBzamp2?=
 =?utf-8?B?dU5mRk1xUXBZY1VJNU96azhZMFlBckxrKy94TVY4VElrcmpUM0Z6aHNsQjI4?=
 =?utf-8?B?dE42OThLTDVMOEtBUTY5Qjd4emZFLzZxTTMvOHYyL1VaUzJQZVNYWmx1TVVE?=
 =?utf-8?B?bWdkQlo3UHlRQnlCR3lNR2hhNkg5Z3I1QmlPb1NWK2JBMUtucHVpN3c2dU80?=
 =?utf-8?B?WmliWG5tSFJOOWtaa0NZMUh0dXBRd3VoMXViQmUzemgzM2xVQjVjTVFaTXMv?=
 =?utf-8?B?U2YrMGsyUEF2QjdEZWRlSi9mN3YrZ0oyT2FKcWo4V20rSFlOQjhOZHp0WSta?=
 =?utf-8?B?SGM4Z1A3bDVWN3h2VlJIUytqOERYS1MrWHpnSVJVeGpOT0xETVltSjE4azlo?=
 =?utf-8?B?anZoZXhrSTArRTNvd2VqTFJLQUYvUlc2eFNzeW1mNlQxQmhnS1BzdGdGTW44?=
 =?utf-8?B?RENBaElyT2xJNEo2TzdWMWF1ejJjSTllS2QvUlV3a2NoVWFlRkc1emxJOWNF?=
 =?utf-8?B?c1FUUmhlckxNZmJ3MmdLQ29LRndzVWh5S09XSXRNc3czMEhUT0ZLR1dDTVM5?=
 =?utf-8?B?V3RLUlE1c2V6QlBxWFFKc1IxNTlPWG9KcGtEMng1VHpYU1pUMk5uNWw2Ynhv?=
 =?utf-8?B?dC9PV0puSU16S1c0Szd0MW51ZEZDMUVRQ1RjK0taNDNQM2NsNXdxNFE5cTVw?=
 =?utf-8?B?VExQaXZJWTQyZ3hRSEJEa1R5b0xXbkppdzMxNzlydzIrenNTYmZIb0VkYTdl?=
 =?utf-8?B?NEVtU1haQTJqVUQxRmFjWTVwUmFLZUlEMGl4RHUyZnNMMmtUSzdrTzZUTllG?=
 =?utf-8?B?eHUvUTVPVXdKQ2lmbjJ1MGltK3o3N0xDQXpSOFc0YVZPclRZOXZyUVFtQnY4?=
 =?utf-8?B?U1pReGNSaW9sK2xWRzFSNzZSc3pwMlFRZlhVMVJCWitlc0NLMzZNNEhqT3l3?=
 =?utf-8?B?THVCZDVrbHVaYm5GOVlsM1JtRTBZR2RrNUF5b3pCMitBWlJvRnpyNjhuT3NL?=
 =?utf-8?B?dFE2SDlLa05JZ3RWWWd6ck1hNmtnSnpkWUJGY1RheEpRM3Uxbmtjc25QV1o3?=
 =?utf-8?B?Q2Jwc3R5R0FtWlh2cmtITjcveGN0aVRHUkk4d2xoR3BZSU5MdDR6bm8rRXFF?=
 =?utf-8?B?WTRQS0pVVlN2aC9Vcy9yMXBIanE0c3RMNWFScThRS3BlRkRrb3dzOEgwNmdV?=
 =?utf-8?B?aDhnMjdaT2VUdk5nN0hUcVJFaTNuQ0M5SEVya2tpdTVBMm5Kbzg5Z2JOMW9r?=
 =?utf-8?B?Umc4dkRDK3JvaENlMXFFYXgrdUovVjBKdGtmV2tncGxrVHNsUGF1Vk5BSkJD?=
 =?utf-8?B?MXJhcTBzYkl4ek1pZlZhTTc5ZUNXVmhpdjNKOTJnR280YUwzU2UrVG5zWHlC?=
 =?utf-8?B?TFU0dmpOQndrNHVzdXpPS0wwdkY4Y2RGVzhMYUtxdDRtTXluSmE2VkZJR3lR?=
 =?utf-8?B?U3ZvWFJtT1BwVUIrbHJ6dmFPenp6YlJHUDNYcDBqNlg4VmFPWTV2OTFWY0ps?=
 =?utf-8?B?SlIrNWgvNjB0cGlZS3d3alZRdTd4djRXVVBJS0F5QlM0Ni8xSDZpYmplREFE?=
 =?utf-8?B?VnpyckcvT3lObzQrS3V1VjYrUGVSL1YxQWV6djVLci9wTzFBcXR5MHBGYnI4?=
 =?utf-8?B?UFFyNGRlTm8zMDdDeDVlMjdjL2FmSEN6SU0weCtReCtUMlJyczRSMTZYS2Jr?=
 =?utf-8?B?alRuTGFqcEVBUmVocVBRUmovNWdmVkhCaVQzNUduMHlMMitaTXkvV2haQ1Bt?=
 =?utf-8?B?YTFHRTJoTi9wTXNhQjFlMEIwMTJFZ2s3Z0xpRGZXdC9xeWxsVTZmN1lzNlE2?=
 =?utf-8?B?ZWIxblppVTg5cS9OWDIvOUhqUE0wMVR6dlByNTY5emFPc2Q2cmdMaC92RUxI?=
 =?utf-8?B?YUxyY2YvbU5SVzd3WkxaNnNGaVNrSVFVR0htd0ZJSTRuNUxxc2IwdnU4U0VY?=
 =?utf-8?B?d29lWEJabW1GckZWSVBWM3RhZFdxMzhpaUxYT0o4ZkZ4TkZTU3h6QlJGdUNU?=
 =?utf-8?B?dFQ0TlZQSGRpN1ROclMrRlFDTU5HNXEwMFpnNVl6alVjZk5TV1M2RGM0WXVP?=
 =?utf-8?B?NUxEM3ZBQlozdTViMUprUkcxNWhaVVhKdTQvcUN5azlkNEhxZmxlb3AvcHc4?=
 =?utf-8?Q?blZUGi/6rg2reDU2GF+1Hkpx4?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 41ef31ba-c4f4-439d-3c8e-08db6cf85ab0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 16:56:53.1751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zTYlZJBOGx+BqFI0IX3ffvmyYsX8HJG4Rd9jZbOLvZV5fcMaetEswG/14pAm04fxbYBC6x5ZQPNyV5pm/w2qpAu83zKOO+rpoGBeOKCIV2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8130
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTaW1vbiBIb3JtYW4gPHNpbW9u
Lmhvcm1hbkBjb3JpZ2luZS5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgSnVuZSAxNCwgMjAyMyA0
OjE4IEFNDQo+IFRvOiBFcnRtYW4sIERhdmlkIE0gPGRhdmlkLm0uZXJ0bWFuQGludGVsLmNvbT4N
Cj4gQ2M6IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOyBkYW5pZWwubWFjaG9uQG1p
Y3JvY2hpcC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCBpd2wtbmV4dCB2NCAwMi8xMF0gaWNlOiBBZGQgZHJpdmVyIHN1cHBvcnQgZm9yIGZpcm13
YXJlDQo+IGNoYW5nZXMgZm9yIExBRw0KPiANCj4gT24gRnJpLCBKdW4gMDksIDIwMjMgYXQgMDI6
MTY6MThQTSAtMDcwMCwgRGF2ZSBFcnRtYW4gd3JvdGU6DQo+IA0KPiAuLi4NCj4gDQo+IEhpIERh
dmUsDQo+IA0KPiBzb21lIG1pbm9yIGZlZWRiYWNrIGZyb20gbXkgc2lkZS4NCj4gDQo+ID4gQEAg
LTU1NzYsMTAgKzU1NzksMTggQEAgc3RhdGljIGludCBfX2luaXQgaWNlX21vZHVsZV9pbml0KHZv
aWQpDQo+ID4gIAkJcmV0dXJuIC1FTk9NRU07DQo+ID4gIAl9DQo+ID4NCj4gPiArCWljZV9sYWdf
d3EgPSBhbGxvY19vcmRlcmVkX3dvcmtxdWV1ZSgiaWNlX2xhZ193cSIsIDApOw0KPiA+ICsJaWYg
KCFpY2VfbGFnX3dxKSB7DQo+ID4gKwkJcHJfZXJyKCJGYWlsZWQgdG8gY3JlYXRlIExBRyB3b3Jr
cXVldWVcbiIpOw0KPiANCj4gSXMgdGhlIGFsbG9jYXRpb24gZmFpbHVyZSBhbHJlYWR5IGxvZ2dl
ZCBieSBjb3JlIGNvZGU/DQo+IElmIHNvLCBwZXJoYXBzIHRoaXMgaXMgdW5uZWNlc3Nhcnk/DQoN
CkkgZG8gbm90IHNlZSBhbnkgbWVzc2FnaW5nIGZyb20gdGhlIGNvcmUsIHNvIEkgc2hvdWxkIHBy
b2JhYmx5IGxlYXZlIHRoaXMgaGVyZQ0KdW5sZXNzIHlvdSBjYW4gcG9pbnQgb3V0IHNvbWV0aGlu
ZyBJIG1pc3NlZCDwn5iKDQoNCj4gDQo+ID4gKwkJZGVzdHJveV93b3JrcXVldWUoaWNlX3dxKTsN
Cj4gPiArCQlyZXR1cm4gLUVOT01FTTsNCj4gPiArCX0NCj4gPiArDQo+ID4gIAlzdGF0dXMgPSBw
Y2lfcmVnaXN0ZXJfZHJpdmVyKCZpY2VfZHJpdmVyKTsNCj4gPiAgCWlmIChzdGF0dXMpIHsNCj4g
PiAgCQlwcl9lcnIoImZhaWxlZCB0byByZWdpc3RlciBQQ0kgZHJpdmVyLCBlcnIgJWRcbiIsIHN0
YXR1cyk7DQo+ID4gIAkJZGVzdHJveV93b3JrcXVldWUoaWNlX3dxKTsNCj4gPiArCQlkZXN0cm95
X3dvcmtxdWV1ZShpY2VfbGFnX3dxKTsNCj4gPiAgCX0NCj4gPg0KPiA+ICAJcmV0dXJuIHN0YXR1
czsNCj4gDQo+IEFzIHRoZXJlIGFyZSBub3cgYSBmZXcgdGhpbmdzIChtb3JlIHRoYW4gemVybykg
dG8gdW53aW5kIEkgdGhpbmsgaXQgd291bGQNCj4gYmUgYmVzdCB0byB1c2UgdGhlIEtlcm5lbCdz
IGlkaW9tYXRpYyBnb3RvLWJhc2VkIGFwcHJvYWNoLg0KPiANCg0KU291bmRzIHJlYXNvbmFibGUg
LSB3aWxsIHN3aXRjaCB0byBhIGdvdG8gYmFzZWQgYXBwcm9hY2guDQoNCkNoYW5nZXMgdG8gY29t
ZSBpbiB2NS4NCg0KRGF2ZUUNCg0KPiAoQ29tcGxldGVseSB1bnRlc3RlZCEpDQo+IA0KPiAJaWNl
X2xhZ193cSA9IGFsbG9jX29yZGVyZWRfd29ya3F1ZXVlKCJpY2VfbGFnX3dxIiwgMCk7DQo+IAlp
ZiAoIWljZV9sYWdfd3EpIHsNCj4gCQlwcl9lcnIoIkZhaWxlZCB0byBjcmVhdGUgTEFHIHdvcmtx
dWV1ZVxuIik7DQo+IAkJc3RhdHVzID0gLUVOT01FTTsNCj4gCQlnb3RvIGVycl9kZXN0cm95X2lj
ZV93cTsNCj4gCX0NCj4gDQo+IAlzdGF0dXMgPSBwY2lfcmVnaXN0ZXJfZHJpdmVyKCZpY2VfZHJp
dmVyKTsNCj4gCWlmIChzdGF0dXMpIHsNCj4gCQlwcl9lcnIoImZhaWxlZCB0byByZWdpc3RlciBQ
Q0kgZHJpdmVyLCBlcnIgJWRcbiIsIHN0YXR1cyk7DQo+IAkJZ290byBlcnJfZGVzdHJveV9sYWdf
d3E7DQo+IAl9DQo+IA0KPiAJcmV0dXJuIHN0YXR1czsNCj4gDQo+IGVycl9kZXN0cm95X2xhZ193
cToNCj4gCWRlc3Ryb3lfd29ya3F1ZXVlKGljZV9sYWdfd3EpOw0KPiBlcnJfZGVzdHJveV9pY2Vf
d3E6DQo+IAlkZXN0cm95X3dvcmtxdWV1ZShpY2Vfd3EpOw0KPiAJcmV0dXJuIHN0YXR1cw0KPiAN
Cj4gDQo+ID4gQEAgLTU1OTYsNiArNTYwNyw3IEBAIHN0YXRpYyB2b2lkIF9fZXhpdCBpY2VfbW9k
dWxlX2V4aXQodm9pZCkNCj4gPiAgew0KPiA+ICAJcGNpX3VucmVnaXN0ZXJfZHJpdmVyKCZpY2Vf
ZHJpdmVyKTsNCj4gPiAgCWRlc3Ryb3lfd29ya3F1ZXVlKGljZV93cSk7DQo+ID4gKwlkZXN0cm95
X3dvcmtxdWV1ZShpY2VfbGFnX3dxKTsNCj4gPiAgCXByX2luZm8oIm1vZHVsZSB1bmxvYWRlZFxu
Iik7DQo+ID4gIH0NCj4gPiAgbW9kdWxlX2V4aXQoaWNlX21vZHVsZV9leGl0KTsNCj4gDQo+IC4u
Lg0K

