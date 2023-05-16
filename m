Return-Path: <netdev+bounces-2958-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE654704AE1
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:39:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F5741C20B14
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:39:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A5A34CDC;
	Tue, 16 May 2023 10:37:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC3134CC0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:37:26 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126282D5F
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684233407; x=1715769407;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gIxv4o4vMGHFToGIGmDJKaNRhVp+hb5YvjQPP8Tz2IM=;
  b=Qq+EaAjFSQyx+KKIPAme2QOq1sfRYClp/+bvrife3DgJ5WlNiHhP4WOE
   xiyUfNgm18749Z93W550eSCtfeLfMMIq+4NJCLxF3+bihCjSVE4crokI3
   ZCz7IeMnyGhDl77mrKvu9q32v3l9qOXcmqb+Qjmk2cj2kBnmZHoFu8HIG
   Gtcy5Sp8AtMqdOEk9I6Zbe6bhfL9vhGDIWh/eyw7wdasPs0d95CvLjE7l
   iTfJlMGOU5pj0u7CAosk2ngP3XFaTpw6WsOt8TYdEIkXXQu5bKFbKHJ0W
   2Ce4sr+mzsO5/AQ0GcRacLTqOG1BZJRZxWx/kwiH+WsY4aYFRYFBCYHr5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="331061506"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="331061506"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 03:36:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="770990933"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="770990933"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2023 03:36:29 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 03:36:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 03:36:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 03:36:28 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 03:36:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZ+mLJh6QcSykEiNOCfKRAN2zeZTjxjFy2JPhEbX+jX3/TRmxObN1mJkPF/UL+FfIM4Qi/S38810owut1CmX3Ud7icCgkK2iA4zKHEs0s54+Fn51rDfhH3u1ST5B6/6/inWgTP8KmN9aUvcsDpR0S80rcJ/AaahtS2ozrwySkSMTKj9zCEtzSpFmkm/7oYV9u5jl7zncuUSSY0GWVhh9F6HWgfGAWSlcIPd5VSpSnaNZOjy9pNqY2L8FOudFzCeuJDX0sbaYHHX5PGrNFNV6qhgLmF5Rk33fYWgmWLkmSyO0aAW4i37FkNeRj4qwW1J4UDti3o7w6pYHwOjI0gHfpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIxv4o4vMGHFToGIGmDJKaNRhVp+hb5YvjQPP8Tz2IM=;
 b=k51Yn9QNPakmI+7M7+UGqhjow0nSw4Hc2Fx2XtF3FRXeD0bVO29zekS1YxgFCTFI22nN160JeikUSmnq26yZOf0dyKzj/hUBelx/oPPayd3bmwxT3KEleDW9Yof3NSliWdR87WTwiGDzPzYU+Vcy19/syQMPs1iQ9ZVCcPcCda9lR63MDgu5e3Yaz7MfeqgoiY4pEeSTtnUM3RmOlK+PR9l1fHaTs8cJuxkdn/7dmcff6pwc56wK5N3q9ZoXnFNkIUkhQSpsboU9kNo1Mhf6OFDW8PWtQ6ZbzhiOCtK3KlbrMPPzPbmYD3s91mDeBr79boFdDMdrXU+5x5TZTkZKZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by PH0PR11MB4792.namprd11.prod.outlook.com (2603:10b6:510:32::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 10:36:25 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%7]) with mapi id 15.20.6387.032; Tue, 16 May 2023
 10:36:24 +0000
From: "Drewek, Wojciech" <wojciech.drewek@intel.com>
To: =?utf-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ertman, David M"
	<david.m.ertman@intel.com>, mschmidt <mschmidt@redhat.com>
Subject: RE: [PATCH iwl-next] ice: Remove LAG+SRIOV mutual exclusion
Thread-Topic: [PATCH iwl-next] ice: Remove LAG+SRIOV mutual exclusion
Thread-Index: AQHZh9dt4fHx73OP5kKhfu/HpsKYl69cs93g
Date: Tue, 16 May 2023 10:36:24 +0000
Message-ID: <MW4PR11MB57769C0E492F1252D58DEFB1FD799@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230512090652.190058-1-wojciech.drewek@intel.com>
 <CACT4oueyxJT2Xb5uojaKFAQ-R4nBQr5o457g2nfNsKDQPYEXvw@mail.gmail.com>
In-Reply-To: <CACT4oueyxJT2Xb5uojaKFAQ-R4nBQr5o457g2nfNsKDQPYEXvw@mail.gmail.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|PH0PR11MB4792:EE_
x-ms-office365-filtering-correlation-id: 0f0ccea1-fc4e-4486-9ae2-08db55f965f6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y6kNnC64AhtSNnL4lFPZuGNp3+cYedFQu2x8trDdcwbYMOUxnLyYVunDaIxbUlms45VWwna0CKkRM27Fx/UEvpC2sV7Teq/0qCcK6Rp4udvE57BhSd/i0+CFKAgLvAqk2qDpkM7xyvjlEzOi07QM4LHLg0z3wXrA+rHh5dDv70BXJFTOIQxEsCaEUEELZyGt9o1V6gacWHYtwGe5Y8AouOP+kOA/9JXly+WGqZaGn5CfaplFnSa0wPp74szahxjAG5dNmg4HgOd9PuG3X7E7Pb6PvVixdJnHtR9MJo7K4X2UvIIi8U02MztBy4qLvfiyneMcKqTVRDsmSFYvHiKJO0dwzxtD8uiCLdtFSGRJUxb05fJHLImMhYgActpqBhDSpDn1N0GglTMKz9louPVnvypc6/IeDTFi8A+szmYvpvCS6eRGQZzHiq5ZKLueCwFBJ6bmqXbQbfdFGJoXjpGkYC7A4F7iL8yZLEEbJw4K5M/tkgGUDinSMhcYF3TYI7g9vM4gjPmpP/MQh6EUcjxy3mPIUp8vpLN3xudzdjBHrivOgnckv0uZMwA6sMifrha7wNgYzrvdcWKlsNzmKVpWtep0DfA8S9SuJRpnQpxEQ3+NlYAwb7ajUE3SszTqj8x/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(376002)(39860400002)(136003)(451199021)(5660300002)(52536014)(71200400001)(41300700001)(33656002)(83380400001)(2906002)(122000001)(86362001)(82960400001)(38100700002)(38070700005)(26005)(186003)(55016003)(8676002)(8936002)(53546011)(9686003)(6506007)(7696005)(76116006)(64756008)(66946007)(66476007)(66446008)(66556008)(478600001)(54906003)(4326008)(6916009)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkN1RHJzU3ZvOXNKUisxTkptQ0ZWVGxqOHVEUWV6cEsvemt4V0tlTTkwcmg2?=
 =?utf-8?B?a1dBaWYyKzZhaXQ0UU53Vk5nNHUwM3VlUWo2RHJybHZhb0JkZlRXam51bnBN?=
 =?utf-8?B?elZrS08vUUQ5eEJKOEo5NHdtQXRWdzZJM0JaRGhWN2hHSkQ0VVhuNE1ucDh6?=
 =?utf-8?B?TjU0N05JWWJhZUR2elZCLzdyakIyaFJTaW1qeFFlR0lrazB0dzBkbjhwbW81?=
 =?utf-8?B?ME9rcUhMOEM1c2lFNTdVZUtXR1FaZ3U1NlEyeWdZK3JaMmtsUWQ1ajlWNWI0?=
 =?utf-8?B?K3hQS1F1UXVvdDZwbTJuTnBDQlNacXNSeGpQM0VPQWs4RndGYzkxT29Nc01W?=
 =?utf-8?B?ek9yMGpuN294UjdOVCtjQm80RWRMdlJSUFppV1dpS25YMWROM0l4SEV0eVhC?=
 =?utf-8?B?d1FaTmpVdmhTZXBrUkxlUkNVTTdJQ1pZdEx2d0ozMWlqM1Q1ZGVYZm9BeFJs?=
 =?utf-8?B?VDFnaGdZUllSQmlkZk1xQ0FVTVRtVDR5N1orUHAxS1F6Qndod2Z5eGRqK1Iy?=
 =?utf-8?B?eGtEeEpxekJ1ZWhTM3pFV0hqZm1nRDV4em5DMFZuQlR5Y1gwZ29BeFk5Ly81?=
 =?utf-8?B?N29MYTVFSHJML0VwKytzL2k2bytRUytiTDBsWXM0dVl1ajZCaVRIbVVVMUg2?=
 =?utf-8?B?aVJBWnlpM29ldFZDLzdFdUwzaHJrNGVEMmQrSktYTzhtTlJ5TWZGU2NKT1Ar?=
 =?utf-8?B?bFZ6bmFQV2htK25NemcycnBOd3FQSHJxb2tyNStwZnBLV0I2bXpiTFpEeTg4?=
 =?utf-8?B?UVE0eW1SUXdpckdoZUNVN0Jvc0IxbXNraXp2VExiTEJ3QzRISzFnenErZjZR?=
 =?utf-8?B?dkp5VjFBaFJ0QThRSWFwdHBBMWZGT1V2ei80MHZrdHJHd1YyMk5KdEg3d3NO?=
 =?utf-8?B?MjlQdHYwV0dFdGgzMkxDdUhpMXlYZzBBVWh6UGRwbXptYld2Mk5rb1ZpdmFE?=
 =?utf-8?B?ZUNvVkFJZFJiTmFvbTY3VU5iMncyNHV6MGFMZUR3ZnpycGZjYVVHSHAvTmMv?=
 =?utf-8?B?dTg2OHpUd1FwQmpQUDNEd0JiakpCeWdvWUgrVHZ0clg3NlE1WTVOa2VmalUr?=
 =?utf-8?B?MmE5c3ZadUx1cW83enBXV0o3QTl0RnBqWDVHU0piVmpBNkVEYTBoRWdxUDVm?=
 =?utf-8?B?clNoNGhzV2lkT0FzeWl1N013ci80eGpKemxjQ1NZdU96VkFyOS9PRmh5SzJi?=
 =?utf-8?B?T1dpQ25vaGRjcUREWW1QR3d6aUMvZ1dWTWpiSEhYL2JBZ3JKZjBFZ1Jhd2t6?=
 =?utf-8?B?bEkzMm9Pa0xQKzYyQ0xLN0ZsYnF3V0lFMkZkdHkzRGl6S1pxUUJNcHJleW5x?=
 =?utf-8?B?T2R6S0tJcUdiSlVNUDYySlg5eEJ0a3QxeFhIaE9QNk1NcVFlMit3MDdwVzF2?=
 =?utf-8?B?WXRKNEg2K0F3Y3piWlp2b1NoTmNubXZrVHh0RjZncENEeFdNZy9zS1E1eG9q?=
 =?utf-8?B?TythSkxKb081SXo3UVZoQ1U4UjFoZ04vV1M1bjl0SmxWaFRwUVdaUDhxcmpN?=
 =?utf-8?B?WVlPQVA4eDlVbDJ4VTZpZVk4RkRRS0JVTXgvOWFjOVRyeitwa0E4ZVgrQnZ2?=
 =?utf-8?B?Y2tlTHByR3AxL0dia3JJQW53ZWpnZHF0QWp5VEhpNE11YWhzM091VTQ3YlRo?=
 =?utf-8?B?WG8waFJOendZTHFiN0FVT25HTlRmU3RwRHRVSVJCL0F6TnZYNGxLS20zQWM4?=
 =?utf-8?B?ZTl3Tk9IL1IzR3UyOEVzK2lyTkJaRDN1U2FhQnFDeS9jWWR0RDFyeVNmcnlu?=
 =?utf-8?B?LzdZcDJ5cVhBWUVSWGJwRElsT0pFSnZBUVRZa2k1U0VQK0p6dW5xT1lCSGtu?=
 =?utf-8?B?a0RUNkloWmpldHFtVGZzS2ZxdDkyRHExTnZ6VHdRQUd3M3UzNkNJeCtFK2pa?=
 =?utf-8?B?ZWRjd1poWGU1emxTRUdLZXVZUDdHbFY3NHRiWnN1T0NtQ0FGejNjcmJXelFh?=
 =?utf-8?B?Z3o5b1ltOVZZekp6UG5yb1JIRy95V2VXelVyZkRxN3U3QkhRQUM0aUtvd2hM?=
 =?utf-8?B?dGZNSkkzRlpiLzZCMnBSQUtqeVpMNG41bjZnVlAya0lHZVhoY1FQNE9rR2VK?=
 =?utf-8?B?bmJHamhPS2grMUlJeVBWUGgwcXg2dDBDZXV5OHN4RDl5MEdQTTdaTlJOU1E0?=
 =?utf-8?Q?xMHDPyQL8Mgqy0XQdtlCTXros?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0ccea1-fc4e-4486-9ae2-08db55f965f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2023 10:36:24.8555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZqMrOy+Yzg5OGOc2lFPXXvD6KBcyX4uH8SvOgHn5BEso7elPkAWgeeBrrE6rIFCrz84HOA0gK2BEAkJH0GORrjRnPa8cHNj8fuJuzXDWP2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4792
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogw43DsWlnbyBIdWd1ZXQg
PGlodWd1ZXRAcmVkaGF0LmNvbT4NCj4gU2VudDogd3RvcmVrLCAxNiBtYWphIDIwMjMgMTE6MTgN
Cj4gVG86IERyZXdlaywgV29qY2llY2ggPHdvamNpZWNoLmRyZXdla0BpbnRlbC5jb20+DQo+IENj
OiBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgRXJ0bWFuLCBEYXZpZCBNIDxkYXZpZC5tLmVydG1hbkBpbnRlbC5jb20+OyBtc2NobWlkdA0K
PiA8bXNjaG1pZHRAcmVkaGF0LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBpd2wtbmV4dF0g
aWNlOiBSZW1vdmUgTEFHK1NSSU9WIG11dHVhbCBleGNsdXNpb24NCj4gDQo+IE9uIEZyaSwgTWF5
IDEyLCAyMDIzIGF0IDExOjA44oCvQU0gV29qY2llY2ggRHJld2VrDQo+IDx3b2pjaWVjaC5kcmV3
ZWtAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IEZyb206IERhdmUgRXJ0bWFuIDxkYXZpZC5t
LmVydG1hbkBpbnRlbC5jb20+DQo+ID4NCj4gPiBUaGVyZSB3YXMgYSBjaGFuZ2UgcHJldmlvdXNs
eSB0byBzdG9wIFNSLUlPViBhbmQgTEFHIGZyb20gZXhpc3Rpbmcgb24gdGhlDQo+ID4gc2FtZSBp
bnRlcmZhY2UuICBUaGlzIHdhcyB0byBwcmV2ZW50IHRoZSB2aW9sYXRpb24gb2YgTEFDUCAoTGlu
aw0KPiA+IEFnZ3JlZ2F0aW9uIENvbnRyb2wgUHJvdG9jb2wpLiAgVGhlIG1ldGhvZCB0byBhY2hp
ZXZlIHRoaXMgd2FzIHRvIGFkZCBhDQo+ID4gbm8tb3AgUnggaGFuZGxlciBvbnRvIHRoZSBuZXRk
ZXYgd2hlbiBTUi1JT1YgVkZzIHdlcmUgcHJlc2VudCwgdGh1cw0KPiA+IGJsb2NraW5nIGJvbmRp
bmcsIGJyaWRnaW5nLCBldGMgZnJvbSBjbGFpbWluZyB0aGUgaW50ZXJmYWNlIGJ5IGFkZGluZw0K
PiA+IGl0cyBvd24gUnggaGFuZGxlci4gIEFsc28sIHdoZW4gYW4gaW50ZXJmYWNlIHdhcyBhZGRl
ZCBpbnRvIGEgYWdncmVnYXRlLA0KPiA+IHRoZW4gdGhlIFNSLUlPViBjYXBhYmlsaXR5IHdhcyBz
ZXQgdG8gZmFsc2UuDQo+ID4NCj4gPiBUaGVyZSBhcmUgc29tZSB1c2VycyB0aGF0IGhhdmUgaW4g
aG91c2Ugc29sdXRpb25zIHVzaW5nIGJvdGggU1ItSU9WIGFuZA0KPiA+IGJyaWRnaW5nL2JvbmRp
bmcgdGhhdCB0aGlzIG1ldGhvZCBpbnRlcmZlcmVzIHdpdGggKGUuZy4gY3JlYXRpbmcgZHVwbGlj
YXRlDQo+ID4gVkZzIG9uIHRoZSBib25kZWQgaW50ZXJmYWNlcyBhbmQgZmFpbGluZyBiZXR3ZWVu
IHRoZW0gd2hlbiB0aGUgaW50ZXJmYWNlDQo+ID4gZmFpbHMgb3ZlcikuDQo+ID4NCj4gPiBJdCBt
YWtlcyBtb3JlIHNlbnNlIHRvIHByb3ZpZGUgdGhlIG1vc3QgZnVuY3Rpb25hbGl0eQ0KPiA+IHBv
c3NpYmxlLCB0aGUgcmVzdHJpY3Rpb24gb24gY28tZXhpc3RlbmNlIG9mIHRoZXNlIGZlYXR1cmVz
IHdpbGwgYmUNCj4gPiByZW1vdmVkLiAgTm8gYWRkaXRpb25hbCBmdW5jdGlvbmFsaXR5IGlzIGN1
cnJlbnRseSBiZWluZyBwcm92aWRlZCBiZXlvbmQNCj4gPiB3aGF0IGV4aXN0ZWQgYmVmb3JlIHRo
ZSBjby1leGlzdGVuY2UgcmVzdHJpY3Rpb24gd2FzIHB1dCBpbnRvIHBsYWNlLiAgSXQgaXMNCj4g
PiB1cCB0byB0aGUgZW5kIHVzZXIgdG8gbm90IGltcGxlbWVudCBhIHNvbHV0aW9uIHRoYXQgd291
bGQgaW50ZXJmZXJlIHdpdGgNCj4gPiBleGlzdGluZyBuZXR3b3JrIHByb3RvY29scy4NCj4gPg0K
PiA+IFJldmlld2VkLWJ5OiBNaWNoYWwgU3dpYXRrb3dza2kgPG1pY2hhbC5zd2lhdGtvd3NraUBs
aW51eC5pbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogRGF2ZSBFcnRtYW4gPGRhdmlkLm0u
ZXJ0bWFuQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBXb2pjaWVjaCBEcmV3ZWsgPHdv
amNpZWNoLmRyZXdla0BpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIC4uLi9kZXZpY2VfZHJpdmVy
cy9ldGhlcm5ldC9pbnRlbC9pY2UucnN0ICAgICB8IDE4IC0tLS0tLS0NCj4gPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZS5oICAgICAgICAgIHwgMTkgLS0tLS0tLQ0KPiA+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2xhZy5jICAgICAgfCAxMiAtLS0tLQ0K
PiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2xhZy5oICAgICAgfCA1MyAt
LS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9p
Y2VfbGliLmMgICAgICB8ICAyIC0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNl
L2ljZV9zcmlvdi5jICAgIHwgIDQgLS0NCj4gPiAgNiBmaWxlcyBjaGFuZ2VkLCAxMDggZGVsZXRp
b25zKC0pDQo+ID4NCg0KPC4uLj4NCg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9pY2UvaWNlX2xhZy5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNl
L2ljZV9sYWcuaA0KPiA+IGluZGV4IDUxYjVjZjQ2N2NlMi4uNTRkNjY2M2ZlNTg2IDEwMDY0NA0K
PiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbGFnLmgNCj4gPiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2xhZy5oDQo+ID4gQEAgLTI2
LDYyICsyNiw5IEBAIHN0cnVjdCBpY2VfbGFnIHsNCj4gPiAgICAgICAgIHU4IGJvbmRlZDoxOyAv
KiBjdXJyZW50bHkgYm9uZGVkICovDQo+ID4gICAgICAgICB1OCBwcmltYXJ5OjE7IC8qIHRoaXMg
aXMgcHJpbWFyeSAqLw0KPiA+ICAgICAgICAgdTggaGFuZGxlcjoxOyAvKiBkaWQgd2UgcmVnaXN0
ZXIgYSByeF9uZXRkZXZfaGFuZGxlciAqLw0KPiANCj4gImhhbmRsZXIiIGZpZWxkIHNlZW1zIHVu
dXNlZCBub3csIHNob3VsZG4ndCBpdCBiZSByZW1vdmVkPw0KDQpZb3UncmUgcmlnaHQsIEknbGwg
c2VuZCB2Mg0KDQo+IA0KPiA+IC0gICAgICAgLyogZWFjaCB0aGluZyBibG9ja2luZyBib25kaW5n
IHdpbGwgaW5jcmVtZW50IHRoaXMgdmFsdWUgYnkgb25lLg0KPiA+IC0gICAgICAgICogSWYgdGhp
cyB2YWx1ZSBpcyB6ZXJvLCB0aGVuIGJvbmRpbmcgaXMgYWxsb3dlZC4NCj4gPiAtICAgICAgICAq
Lw0KPiA+IC0gICAgICAgdTE2IGRpc19sYWc7DQo+ID4gICAgICAgICB1OCByb2xlOw0KPiA+ICB9
Ow0KPiA+DQo+ID4gIGludCBpY2VfaW5pdF9sYWcoc3RydWN0IGljZV9wZiAqcGYpOw0KPiA+ICB2
b2lkIGljZV9kZWluaXRfbGFnKHN0cnVjdCBpY2VfcGYgKnBmKTsNCj4gPiAtcnhfaGFuZGxlcl9y
ZXN1bHRfdCBpY2VfbGFnX25vcF9oYW5kbGVyKHN0cnVjdCBza19idWZmICoqcHNrYik7DQo+ID4g
LQ0KPiA+IC0vKioNCj4gPiAtICogaWNlX2Rpc2FibGVfbGFnIC0gaW5jcmVtZW50IExBRyBkaXNh
YmxlIGNvdW50DQo+ID4gLSAqIEBsYWc6IExBRyBzdHJ1Y3QNCj4gPiAtICovDQo+ID4gLXN0YXRp
YyBpbmxpbmUgdm9pZCBpY2VfZGlzYWJsZV9sYWcoc3RydWN0IGljZV9sYWcgKmxhZykNCj4gPiAt
ew0KPiA+IC0gICAgICAgLyogSWYgTEFHIHRoaXMgUEYgaXMgbm90IGFscmVhZHkgZGlzYWJsZWQs
IGRpc2FibGUgaXQgKi8NCj4gPiAtICAgICAgIHJ0bmxfbG9jaygpOw0KPiA+IC0gICAgICAgaWYg
KCFuZXRkZXZfaXNfcnhfaGFuZGxlcl9idXN5KGxhZy0+bmV0ZGV2KSkgew0KPiA+IC0gICAgICAg
ICAgICAgICBpZiAoIW5ldGRldl9yeF9oYW5kbGVyX3JlZ2lzdGVyKGxhZy0+bmV0ZGV2LA0KPiA+
IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGljZV9sYWdf
bm9wX2hhbmRsZXIsDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgTlVMTCkpDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgbGFnLT5oYW5kbGVy
ID0gdHJ1ZTsNCj4gPiAtICAgICAgIH0NCj4gPiAtICAgICAgIHJ0bmxfdW5sb2NrKCk7DQo+ID4g
LSAgICAgICBsYWctPmRpc19sYWcrKzsNCj4gPiAtfQ0KPiA+IC0NCj4gPiAtLyoqDQo+ID4gLSAq
IGljZV9lbmFibGVfbGFnIC0gZGVjcmVtZW50IGRpc2FibGUgY291bnQgZm9yIGEgUEYNCj4gPiAt
ICogQGxhZzogTEFHIHN0cnVjdA0KPiA+IC0gKg0KPiA+IC0gKiBEZWNyZW1lbnQgdGhlIGRpc2Fi
bGUgY291bnRlciBmb3IgYSBwb3J0LCBhbmQgaWYgdGhhdCBjb3VudCByZWFjaGVzDQo+ID4gLSAq
IHplcm8sIHRoZW4gcmVtb3ZlIHRoZSBuby1vcCBSeCBoYW5kbGVyIGZyb20gdGhhdCBuZXRkZXYN
Cj4gPiAtICovDQo+ID4gLXN0YXRpYyBpbmxpbmUgdm9pZCBpY2VfZW5hYmxlX2xhZyhzdHJ1Y3Qg
aWNlX2xhZyAqbGFnKQ0KPiA+IC17DQo+ID4gLSAgICAgICBpZiAobGFnLT5kaXNfbGFnKQ0KPiA+
IC0gICAgICAgICAgICAgICBsYWctPmRpc19sYWctLTsNCj4gPiAtICAgICAgIGlmICghbGFnLT5k
aXNfbGFnICYmIGxhZy0+aGFuZGxlcikgew0KPiA+IC0gICAgICAgICAgICAgICBydG5sX2xvY2so
KTsNCj4gPiAtICAgICAgICAgICAgICAgbmV0ZGV2X3J4X2hhbmRsZXJfdW5yZWdpc3RlcihsYWct
Pm5ldGRldik7DQo+ID4gLSAgICAgICAgICAgICAgIHJ0bmxfdW5sb2NrKCk7DQo+ID4gLSAgICAg
ICAgICAgICAgIGxhZy0+aGFuZGxlciA9IGZhbHNlOw0KPiA+IC0gICAgICAgfQ0KPiA+IC19DQo+
ID4gLQ0KPiA+IC0vKioNCj4gPiAtICogaWNlX2lzX2xhZ19kaXMgLSBpcyBMQUcgZGlzYWJsZWQN
Cj4gPiAtICogQGxhZzogTEFHIHN0cnVjdA0KPiA+IC0gKg0KPiA+IC0gKiBSZXR1cm4gdHJ1ZSBp
ZiBib25kaW5nIGlzIGRpc2FibGVkDQo+ID4gLSAqLw0KPiA+IC1zdGF0aWMgaW5saW5lIGJvb2wg
aWNlX2lzX2xhZ19kaXMoc3RydWN0IGljZV9sYWcgKmxhZykNCj4gPiAtew0KPiA+IC0gICAgICAg
cmV0dXJuICEhKGxhZy0+ZGlzX2xhZyk7DQo+ID4gLX0NCj4gPiAgI2VuZGlmIC8qIF9JQ0VfTEFH
X0hfICovDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9p
Y2VfbGliLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2xpYi5jDQo+ID4g
aW5kZXggZDk3MzE0NzZjZDdmLi41ZGRiOTVkMTA3M2EgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9saWIuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbGliLmMNCj4gPiBAQCAtMjcxMiw4ICsyNzEyLDYgQEAg
aWNlX3ZzaV9zZXR1cChzdHJ1Y3QgaWNlX3BmICpwZiwgc3RydWN0IGljZV92c2lfY2ZnX3BhcmFt
cyAqcGFyYW1zKQ0KPiA+ICAgICAgICAgcmV0dXJuIHZzaTsNCj4gPg0KPiA+ICBlcnJfdnNpX2Nm
ZzoNCj4gPiAtICAgICAgIGlmIChwYXJhbXMtPnR5cGUgPT0gSUNFX1ZTSV9WRikNCj4gPiAtICAg
ICAgICAgICAgICAgaWNlX2VuYWJsZV9sYWcocGYtPmxhZyk7DQo+ID4gICAgICAgICBpY2VfdnNp
X2ZyZWUodnNpKTsNCj4gPg0KPiA+ICAgICAgICAgcmV0dXJuIE5VTEw7DQo+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vfc3Jpb3YuYyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vfc3Jpb3YuYw0KPiA+IGluZGV4IDk3ODhmMzYzZTlk
Yy4uYTIyMmNkNzAyZmQ1IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2ljZS9pY2Vfc3Jpb3YuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2ljZS9pY2Vfc3Jpb3YuYw0KPiA+IEBAIC05NjAsOCArOTYwLDYgQEAgaW50IGljZV9zcmlvdl9j
b25maWd1cmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGludCBudW1fdmZzKQ0KPiA+ICAgICAgICAg
aWYgKCFudW1fdmZzKSB7DQo+ID4gICAgICAgICAgICAgICAgIGlmICghcGNpX3Zmc19hc3NpZ25l
ZChwZGV2KSkgew0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGljZV9mcmVlX3ZmcyhwZik7
DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgaWYgKHBmLT5sYWcpDQo+ID4gLSAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBpY2VfZW5hYmxlX2xhZyhwZi0+bGFnKTsNCj4gPiAgICAg
ICAgICAgICAgICAgICAgICAgICByZXR1cm4gMDsNCj4gPiAgICAgICAgICAgICAgICAgfQ0KPiA+
DQo+ID4gQEAgLTk3Myw4ICs5NzEsNiBAQCBpbnQgaWNlX3NyaW92X2NvbmZpZ3VyZShzdHJ1Y3Qg
cGNpX2RldiAqcGRldiwgaW50IG51bV92ZnMpDQo+ID4gICAgICAgICBpZiAoZXJyKQ0KPiA+ICAg
ICAgICAgICAgICAgICByZXR1cm4gZXJyOw0KPiA+DQo+ID4gLSAgICAgICBpZiAocGYtPmxhZykN
Cj4gPiAtICAgICAgICAgICAgICAgaWNlX2Rpc2FibGVfbGFnKHBmLT5sYWcpOw0KPiA+ICAgICAg
ICAgcmV0dXJuIG51bV92ZnM7DQo+ID4gIH0NCj4gPg0KPiA+IC0tDQo+ID4gMi4zOS4yDQo+ID4N
Cj4gPg0KPiANCj4gDQo+IC0tDQo+IMONw7FpZ28gSHVndWV0DQoNCg==

