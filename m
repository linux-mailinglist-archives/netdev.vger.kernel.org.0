Return-Path: <netdev+bounces-8600-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E6BE724B5A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2D431C20B13
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB50822E4B;
	Tue,  6 Jun 2023 18:26:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CD422E36
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 18:26:41 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0074170E
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686075987; x=1717611987;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oZzbVRbXB34JbC6F9Vifcq5UMIyYswJFsM+LxVVsido=;
  b=HzrwEJCNqoEBD+ZYITaLUBmZQ/C6kguIXdXb2vz519ND725wo7lU/o5m
   tLISz+aRjOmWsy5u/4IFUFharpONFbdKzVxEXFvfzI7F1ZTSpWFBOhbxu
   enlUH1KybtNczf4SbhT9ZlbaFbQNtGhY4iuH2Ics62tkUq8HnDLDCe+/w
   f4VUo9qWZF9Cxos37se9eMaSp87k6IWVNzzdoEmiLpEG1KVgpKYhM7+9H
   7tsw8PO6kGC8D0FBORnJZ9W8yNk/qIpVky81NZDN+yQEQJElTlXAAdVhg
   pFe9bV9EmRy5SeraoWYEe8kv1SJ2gv7mrAETtfjP+AJO4yrFBzMykZ6sh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="354260146"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="354260146"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 11:26:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="833340002"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="833340002"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 06 Jun 2023 11:26:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 11:26:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 11:26:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 11:26:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6Ln5+2YyL1iSPwsKZ3qVIzOkxajYLj3yBNYazqH4YHycg1PEXGJgH3zL2w0dnrvtcv2Ymyn1jVWqY7EN4dkMtA3RhgCamF6J+ywTIcgc1dcG4ixmwOsm5ukp6ezFVolgFkAkBXK9gjy9aM8ieGgDhhmOK69Thk6vxivfZee6uQEYI7O7/M+y/K/noxO2ZXbHZdZOeotuETZEy/rF3wGHe1SECKLVx5ooyuwJhhIts51n1fsGV3sw5GfHlFVgGptKTc3l87HrvfwedCajJzAdBvfmNu84jokd39zXOSWGWynnoK4pIIqjpzqzfdHB2n235qwdbGXz+JtZHseUibfYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZzbVRbXB34JbC6F9Vifcq5UMIyYswJFsM+LxVVsido=;
 b=bX5muqw60lsDzIrgm5Ael0flKKVZRkrlQ53SrBYISMDRpD9l4RIDtRS4v5/VefdkMVCKj/Xr7aVap87KE5eskuRhDZWCjge6Nxq9eyZSy0Kuq/NOmuDgXP72QLUOo1du/Gnc0MKk6I30mnZI8rlWatrUJE9z2GqfI+mUJqXcGFAI7Tkd3tIpUFmXLlCbfcYb2suAcLOXyXWUChStqPKOVllI2Zu/wgp+oxgYwzNZTlcPQ0D5h5alMMyqcFbdjnS6z9VBUvJONw8PXFavMNH2joDfo8PGnbpcCPb4dAvLn2b3qncDmSV1Sf6+5wMtqunlUAbLvKzCe8p2sQhAVo8kHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by BL1PR11MB5381.namprd11.prod.outlook.com (2603:10b6:208:308::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 18:26:22 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5c8b:6d4d:5e21:f00f]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5c8b:6d4d:5e21:f00f%6]) with mapi id 15.20.6455.027; Tue, 6 Jun 2023
 18:26:22 +0000
From: "Ertman, David M" <david.m.ertman@intel.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v2 05/10] ice: process events created by lag netdev
 event handler
Thread-Topic: [PATCH net v2 05/10] ice: process events created by lag netdev
 event handler
Thread-Index: AQHZmGVHcTiQDFfud0K4p4GUI/Q2FK9+F64A
Date: Tue, 6 Jun 2023 18:26:22 +0000
Message-ID: <MW5PR11MB58111148A4D11FF157009947DD52A@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
 <20230605182258.557933-6-david.m.ertman@intel.com>
 <20230606105418.m2sqt4gol6sg77oj@DEN-LT-70577>
In-Reply-To: <20230606105418.m2sqt4gol6sg77oj@DEN-LT-70577>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|BL1PR11MB5381:EE_
x-ms-office365-filtering-correlation-id: 21ac000d-0af7-4fa7-be6c-08db66bb8780
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GdaDGfR4sif9ttY0lmWkw9CQ0GSeO9v/AzCZUvoW0SToVSPIiyE3BZPtXiLYJpHfm4VGiuGtY5DW0hXLRlJkUFCgJdWMhoRJjUYYLfojDLNNbuaUGaAPXgf+JtXR6jRMBluYCxiUcRoo9qb72yB6qDAywSgd0EMIrxn54ep20Xb1Isc4ux3a65GNqvMqne966v3JIFVH5w8qPaV5avIEOKPNp0nRY/YMdD/HB/XYQl2J8HzMPAhZ9Vj8rgPs4dNnIcXF+JtrTfpLOpd4q05FgQuo+jD2tchNQzNzXaXACuFKpbqT09HmLtO6BypCzvAudEPD4RQh5WP6B+0LiLSkdMtbwz2ZxHrWTLPtVw6Vo6XYlGidKDs7DisYBAkhsus/aVKcM1NfA7CByhZ7jlMQw9Jz0m5LNMRAkfr9dFAU/HDkcm5hjNmlQb304Rx50ThwGUxGjZ+WzsNm9kLA5As7j+LsivqE3BQdrCp9p+O+b+iTSDBdtEZB6IMXU1zgkDSln0UeEqHPTopimnDPXVLGx//4VlcTYqkHwwOphiFltOeTh0MdyaJjI8HKqM1L8rVWw1fo6MO2KhQn1txEkAvYVURrR0woQH+DKNNk+1NSlYTOr7geOhy7WJ0BQEOYGK4D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199021)(4744005)(2906002)(478600001)(7696005)(26005)(71200400001)(33656002)(83380400001)(38070700005)(53546011)(86362001)(9686003)(122000001)(38100700002)(82960400001)(186003)(6506007)(55016003)(316002)(5660300002)(8676002)(66946007)(8936002)(4326008)(66556008)(6916009)(66476007)(66446008)(64756008)(76116006)(54906003)(52536014)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVVRaGNZWlFVWkFDdVpoYThTeUxSU1Eyd01QOWJybXJUbGtsamxEM2ZKa3Yr?=
 =?utf-8?B?WGNINWgzdXhLeHp2ZCtsSHAyYWFhb05xMWIzVEZKU01zVXB0eC9wdi9IaE9m?=
 =?utf-8?B?Qm9yV3N1MFpOZjMvR2NlcUpOckxGdExTeGNHdjh2aFlERkxTU2dLcU9kT3Rj?=
 =?utf-8?B?dXhZQ1oxRmxTb0dJRFRCN082WlgzVTUwSnRMa2U0RGlmMFRZQlhjeXpmUVVU?=
 =?utf-8?B?azRpdEJnK3BDcXdZSUdzZWN1SU1PalBFbUF1eGVXV29kbHl5V0EyQTZ1R1ZM?=
 =?utf-8?B?LzJleWQvcVRmSWFjWWVBTXR2WmFKNkpKRVBVcEk4MXRqQTNrRVR6MHRIUkI5?=
 =?utf-8?B?QWF2bVFZV0paYU9DWkRKUlJxMk5uZUNXc241WFAyWG1RZnlqOXI2S1M5NDBj?=
 =?utf-8?B?enBOdFhITlVERStoMUFTdGYyZGwxYzdpM3lzQTRzVnd0WmhJOFg4Y0ZhRUU3?=
 =?utf-8?B?dndOcng5SlBxY0NFVkdaQkV4ay96YlF6d2xmVkUwTy9kMmp2MjJNSmRHcDJJ?=
 =?utf-8?B?UHBlNC9HbWlqY095WHBkSUd3UzBLaEErWTFhMmRXbXFxUml4MzRLNHp2dnc1?=
 =?utf-8?B?eDBtUUJhOXE5MVYxUWovZktuK1ZURWJkVW55QmJRTkFwbEpSZnZtRHBkL0pE?=
 =?utf-8?B?Yk5iNlNZTlIzTGtpTU81RjJtYzdhZ3diajR2aGhOeXFPZWc2UjIwTms0bDRv?=
 =?utf-8?B?U0hhbW5UN0w3Qmg4RWV5WGpQdXg1eGE3bmlBMmh0UHF6cXphRjFoOVhaaktE?=
 =?utf-8?B?Ly9Ec0VyWi81d3VoRUhaTUZISDJBUkVWVWpmMVNoYUprdEVKZlR3RmVVcGMz?=
 =?utf-8?B?NG9NU1l3aC9uMkhwMDBoMVB6Q1VkcEgyelhQdnY2VHE1VkFCTmIyZTM4ajNL?=
 =?utf-8?B?d1BCeUFibWNHaExZUHhhdUV4YUV2NHdidHhwL1ZSaDdhY0tKNHhzaHlPTktP?=
 =?utf-8?B?cnpHNHh6YUt6T1pWQWVzWUg0c0JlNDNyeGoyZ1JDeEg0K2ZPTzVnbDBreUlJ?=
 =?utf-8?B?SWxvVi9hT0c0UjFXNXM1c2U3TzdXcDRyaFRscDYxb2pNZFBZMW9va0tuY29p?=
 =?utf-8?B?MDZSaStsdktCVVZnaDJyREVKYjNlZWMweldlc1hVODdFRUZldHphTy9reTRt?=
 =?utf-8?B?NkQ2YUhNMEFNU1NOTW1PL3ExWXllOXZhekw4cEdVbHg0SUZ6N0VJM3dOQmNl?=
 =?utf-8?B?bkR0YXhEQlJPdDNtV2N5ZFFsVjlTTVVBMHdjRkhhQ040a3JwS1V0ZWxIS0tk?=
 =?utf-8?B?REZSdFJjS3BKVXRDZ3dOWFg1MTBoc3JyeFBMOXpCMlgrdkwyTDY0dHI2ckJH?=
 =?utf-8?B?c1FzMWpJV3R4UUxtM29wemJDditnZlk5VnNhY1dvVFpJWGQwbVhEc0FrK3Y1?=
 =?utf-8?B?b3Nvam9pd1ZBZ01mM2MrTlpmQ0xXMXp5U29qalg4WjZZelBtY3V1SjFWa3VB?=
 =?utf-8?B?Z2hVMmpOY3JYdnF6ZlNEQjJjaDJZeHFnUlhPYjRKN1RuckNFQjJzV05adS9p?=
 =?utf-8?B?RXRMenV5RkQvQWsrWVFuSlNacU1YR1NRTm1MTkVsY0RUQnptNmhkS2I3VGZi?=
 =?utf-8?B?OU1YR1pLMUFJZTk3NWJvZFVFOTE2RlVmajJ3c0k1SHFyMjdIV09hTis4SHY1?=
 =?utf-8?B?SG9nRWhXbURkNkh4MExGTlBWWHNoN1FEaWJJbUZVWUFsczE1REpSVTFSamRR?=
 =?utf-8?B?ZmVuMEF0bVByeE9NR1c5Vk41eHpURG9MSEN4Nm83MkZHeUlPWXU4VDF5T2l6?=
 =?utf-8?B?Z29MVmNLWk13RmxDc2NwRis4RnFDcGY2eFBROTdXUGo2bnRJRllaTWt2YlBG?=
 =?utf-8?B?UjkxSVNuK1FndURlY3VFYlVLWmlhZDVMUXArQm13UXRSUzFlNnVVY2tGbEFD?=
 =?utf-8?B?MVlwUThWODJNeDhSRE4renloZVRlYk5UdDVOaEp0VDZqaXVobCsyK2VxS3Bv?=
 =?utf-8?B?S2R4bkpxQncxYTFrYzZNN1BFb25YbGdLUXlWZGdnMFhkK29GRGk2QmJvWXlV?=
 =?utf-8?B?RlN6ZHVsM1k0dVJKZlpCZFpNc1J5SEY1RWI0UHhDSnk5dEh2TlVvR1RpSnNn?=
 =?utf-8?B?K1JDWWphSUwyQ1ZXNzJzNWV1UzRtWDhjd2swNlRISmZLWXB6Rkg0YTl2Tkhz?=
 =?utf-8?Q?rJXeRJGZy8AF7iQeLx5qFk565?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ac000d-0af7-4fa7-be6c-08db66bb8780
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 18:26:22.0823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cjNPgLxh/ukqXt8XTNBcgcSRq5GfrgPE6guHls7e3DQU+TJ9dOZNmFWiHYgifzxEQ4ilQ+FqyjK+oFgbxmQIO9DDy9XEn816p4DITeYEmzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5381
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYW5pZWwgTWFjaG9uIDxkYW5p
ZWwubWFjaG9uQG1pY3JvY2hpcC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgNiwgMjAyMyAz
OjU0IEFNDQo+IFRvOiBFcnRtYW4sIERhdmlkIE0gPGRhdmlkLm0uZXJ0bWFuQGludGVsLmNvbT4N
Cj4gQ2M6IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0IHYyIDA1LzEwXSBpY2U6IHByb2Nlc3Mg
ZXZlbnRzIGNyZWF0ZWQgYnkgbGFnIG5ldGRldg0KPiBldmVudCBoYW5kbGVyDQo+IA0KPiA+ICsv
KioNCj4gPiArICogaWNlX2xhZ19hZGRfcHJ1bmVfbGlzdCAtIEFkZCAncyBldmVudF9wZidzIFZT
SSB0byBwcmltYXJ5J3MgcHJ1bmUgbGlzdA0KPiANCj4gQWRkcz8NCg0KSSB3ZW50IGEgbGl0dGxl
IGNyYXp5IHdpdGggdGhlIGFwb3N0cm9waGVzIHRoZXJlIPCfmIoNCkNoYW5nZSBtYWRlIGFuZCBz
ZXQgZm9yIHYzIG9mIHBhdGNoZXMuDQoNCj4gDQo+IE90aGVyIHRoYW4gdGhhdDoNCj4gDQo+IFJl
dmlld2VkLWJ5OiBEYW5pZWwgTWFjaG9uIDxkYW5pZWwubWFjaG9uQG1pY3JvY2hpcC5jb20+DQo+
IA0KPiA+ICsgKiBAbGFnOiBsYWcgaW5mbyBzdHJ1Y3QNCj4gPiArICogQGV2ZW50X3BmOiBQRiBz
dHJ1Y3QgZm9yIFZTSSB3ZSBhcmUgYWRkaW5nIHRvIHByaW1hcnkncyBwcnVuZSBsaXN0DQo+ID4g
KyAqLw0KPiA+ICtzdGF0aWMgdm9pZCBpY2VfbGFnX2FkZF9wcnVuZV9saXN0KHN0cnVjdCBpY2Vf
bGFnICpsYWcsIHN0cnVjdCBpY2VfcGYNCj4gKmV2ZW50X3BmKQ0KPiA+ICt7DQo+ID4gK30NCg==

