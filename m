Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BC062E5FE
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 21:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240454AbiKQUed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 15:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239672AbiKQUeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 15:34:31 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FD9657FD;
        Thu, 17 Nov 2022 12:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668717267; x=1700253267;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e9I9V0OU7jNTCi2/768OVpRoie9HqGInRScivZ9ZCTU=;
  b=ak+m84ldD4+wm4DmIX3FprjXxjnFuLD98fJpfmctOBIDrYqSAyJz7noD
   IKPzPh4eoRfj1A0ObE/26oq4LMIcWrz6ODZ+lwHu7k+Gz/Hp5UTJsQ/YU
   7P5X9Cy3QJJHyxh8hFG4MS1VZY9HKbnHT4VyG2oMxXPV1KpZEbZ98c+53
   LcLXHBYdDg41AeLUc91sqFkMQNj1xcis6+p96iWbTQ7VvooVM/TayHtcQ
   yIYwkqxKqwADbMojUS6/sZY90djulVCXfvJVuBCTFeOqfB5dLEQ4rpYs8
   sdw+EsxTwcrul1ULMW/FSLg/NCTStR1DLWu/cL7Y2mwh5D8jc+9sqNlqm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="310600729"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="310600729"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 12:34:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="708772452"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="708772452"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 17 Nov 2022 12:34:18 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 12:34:18 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 12:34:18 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 17 Nov 2022 12:34:18 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 17 Nov 2022 12:34:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjEoKCTyG/D3L+kwsR+8QI2DK5xg9KFm0mstc3BS8Du2wYF+RGu9FFJboqhkKdWBf8qoI3C0gNxru90ZSAwYMnLRG2lgjwdJk/vrQ5HiikHP6d8EY2Kj3PiEspWhS5tsB1H3bbWTAkpfIt/yKYEDUT6p0Du0+naoxPN+NpnQo6rU3J06pPSdEm/BHuIfD72dg0mh3g01CV5ULXZvevdQhB97rVpihRtrTpzwEX3rn9dnXZvcmal/nHSQHu+8CnS+G7QtsCy0XCKgKpojYxsNAWNO+wGWjrmJ9bt79eqwjVwZPLfxNKt9uB/Hq6TB1eeJfpTw3DRCF8nmc11AGmZb/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9I9V0OU7jNTCi2/768OVpRoie9HqGInRScivZ9ZCTU=;
 b=gGbL2ppaa6zSa3NzZPXOakZYjn53Fg++MapMfeIfveknKyTOT4hqFAEz9npP4zI7eaQlbwn35oJQjHJqZuVFQdGV1oZBfGNxr2AzlfDSIrC1bfjmncCfoc0WVn9oaZyWEoSJXoL7W/OCgS//P7UkFzhL8Vgt8E7LLcYU5mxNfWxxEdoSdCJYBHhWzYeZsPJrHtYnsNzco56lvk1ZhKr09Wjh+QxGEY3yGOmwaKU9a8AuAHcxZokRwgH0cN0CYnNr0Ua0keQRYJJrDE3M9Ai10Ac75TGWaF8l23jSQNX3kpRjUVojLM0DiAQjF8Ap5DcT4AVh+78T7MUwss5q+6i1BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA0PR11MB4526.namprd11.prod.outlook.com (2603:10b6:806:96::15)
 by DM4PR11MB7304.namprd11.prod.outlook.com (2603:10b6:8:107::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 20:34:16 +0000
Received: from SA0PR11MB4526.namprd11.prod.outlook.com
 ([fe80::fae8:2a72:6b07:e5c]) by SA0PR11MB4526.namprd11.prod.outlook.com
 ([fe80::fae8:2a72:6b07:e5c%4]) with mapi id 15.20.5813.020; Thu, 17 Nov 2022
 20:34:16 +0000
From:   "Gix, Brian" <brian.gix@intel.com>
To:     "mat.jonczyk@o2.pl" <mat.jonczyk@o2.pl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Von Dentz, Luiz" <luiz.von.dentz@intel.com>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "marcel@holtmann.org" <marcel@holtmann.org>
Subject: Re: [PATCH] Bluetooth: silence a dmesg error message in hci_request.c
Thread-Topic: [PATCH] Bluetooth: silence a dmesg error message in
 hci_request.c
Thread-Index: AQHY+foo/clfMr03b0+vGy2gyjbY1q5Dk/UA
Date:   Thu, 17 Nov 2022 20:34:16 +0000
Message-ID: <499a1278bcf1b2028f6984d61733717a849d9787.camel@intel.com>
References: <20221116202856.55847-1-mat.jonczyk@o2.pl>
In-Reply-To: <20221116202856.55847-1-mat.jonczyk@o2.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR11MB4526:EE_|DM4PR11MB7304:EE_
x-ms-office365-filtering-correlation-id: 1ede1c42-e67c-452b-3e19-08dac8db18ad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /xUMBgY0Ujnv0/TfiEDTQH0NUn00sKDEou2MdrCpFPMDLxowpXNB4Axfvo7ylNgyzbFhoHio2MqeVneV07SBUR+ipq6cYxk6AMHzh085rTk1ritssrv7P81ko+TUUh7zF1kHbdoR+R/g73H459pp/V/mzX65QAX1G5y7LmOe0mFO0d7GeUdHXxXUUclug8DrhACymyu9ic05c8YD/p5vG6YqGO91mwd3M9r2MRjWi1LikLc3PATGKSusOLa6lmK+Yp5qhpxm4NfZ5oHPwgwzNiykmYIlZ9hJya/rVeuVX7gYeOeNUn/VH+aK5Scecy6Zm6Q2wKmp2QU3vkcTQMxh/uo3UdBV4KSGih+mlNKwHibLIhWUe1DEfLSbh7mGSkXQLUKnOSAwarSRtnS/U9jw2e+VhwANG1jKpASPwFVb6qf7t6AQh22mPNX9Tno7iPqyvT1LVfBqbZqT+0R+bqr5QjjQ+bKvgmcfZuXmNAXoXPkji1PiWiYXPfh417HerSvX0Ut1f1IfBo1cwZECMATUMdmz2TRnGiQO37DMgVjqq5RgkoadRMm0vByf+wH+tijzgHHWGIaC0QnjLQY2uxyCoBvb9fi1zH+5912wZsimpNISXw5bNOMQIhF/4e19RD7hmB9NmDjN8IF0oeApqqtr+FV4zwhWkylAoTQOKd8J8/mrWmaYEzEgxhpik4UBXlWN5UdrDJOwKCBPSQ3Hnpc0f6kperD11Gd0lsIKhk4R3io=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR11MB4526.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199015)(2906002)(4001150100001)(8936002)(5660300002)(41300700001)(8676002)(83380400001)(64756008)(66556008)(66476007)(66446008)(91956017)(4326008)(76116006)(66946007)(86362001)(66574015)(110136005)(71200400001)(54906003)(316002)(45080400002)(38070700005)(15650500001)(36756003)(82960400001)(38100700002)(122000001)(186003)(2616005)(6486002)(26005)(6512007)(6506007)(478600001)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1BYOEREWWRTWWpCN0FHcGp5cm52VHVOb0ZlSEpLZnJYWEh0MjRoSTdLZ1Np?=
 =?utf-8?B?WXFqeFNGTEVyVE5jRVhjNytJWWE1SncrWTZQQWxUTHdOQTRXMmJXQ0hOazFB?=
 =?utf-8?B?L1ViL3ZmYlNCYlp3M0J3Zmp1WFJLOExjSGhQQkVNVDVXMzNUZGdnUFgvMEl4?=
 =?utf-8?B?Sm5Va1c0bTB6d1RMQTZWQW1hbzRWZ2YrNHEweWdsblRXUURLSEIxZjJsNU1P?=
 =?utf-8?B?cGNXamMvQkN3TnFjY2EweWdwS2hGRWJXZFdaaENjM1BQUjY0cko3TTF0U1E4?=
 =?utf-8?B?czBwelFaY3BBTjVQOGFmUHIvUEpobWMzYjJ3UnhVc0gxc2dXTVlRU1gxNzJ1?=
 =?utf-8?B?T0tXV09OSHozUzBiZU1INzlET1BmTVpmYmhBcDhGc0dYS29WdkJZUTdLeXlE?=
 =?utf-8?B?Nm8xUXphclBtOWlUclluSEtzc041Y0swbE9PV3lra3ZLQkhKL0VuRU9Zb3NL?=
 =?utf-8?B?UkNGcno0UzMzNWl0S0xrUWF6ZVpLakZJdEdsREUyZGRVTmY2dXFwTnczcHVm?=
 =?utf-8?B?VDJWWC9QREJHakJ3Z05QaUVpbjJEVk51cURFR3IxYVF6L1d4OVZ0UmNzaGRP?=
 =?utf-8?B?L3Z5UDNwQTFtMzUvd2RlSzI4VEQ4MFUrVExSYWlQNDdUYWZoWVMzVUdvRW5l?=
 =?utf-8?B?OWg3OFgzTzdVTzdRSjltaUlqMGdXeE5vam5BOWJvT2Fwak1LdGNLZml3UUlr?=
 =?utf-8?B?dDgwT29CSTduaEdCVDcvQ3lMaHNBenFGTGtGTUd3Q2lsNHVlbXhYS1UwZmJx?=
 =?utf-8?B?N3RqWVhCVVJ1YkZkNjI3blRCZUZ2Z2dHa1VYbzNaUGtmUko5QjRqVngyYy92?=
 =?utf-8?B?M0FoZEdDYVFGcVZ1VmZZcG5ud3R3eEMwMDdPSll4dUVJZEhRdEgrWm1NcDdj?=
 =?utf-8?B?amw3elRBOTYwcWhuUDBpTUp5MFlBNGR2TDRJYVNlcU00eXNaeUx1UDd2anRu?=
 =?utf-8?B?RzdlczFtMzZnc2toYVo5Nnl0NU44Q1ptNDVSemtSYm4vWG9Kd0lSSkZGVzFO?=
 =?utf-8?B?OG9Ba3d5MlRaak4wRkgwL0xiUHBDN2JocUpHdEx6dzR5VDRBQndRYk9RYjBG?=
 =?utf-8?B?K0s0cFk3RFkrM0V2QzlJVFdHZDdEMk80cTNFdmVIdUhpcWF1QWIxcWNMZDd5?=
 =?utf-8?B?V2YzM1RIT0ZGSWs2WnA4L3FidHVIQktlTHd4NVZ3L2hjZlBJRmJHVTJXWFZP?=
 =?utf-8?B?cGUvYTVZYlZ4bE5jSVQ5MksyV3lzK2FUUGlzVmQ1cTNpYzRONlBDWlVLampu?=
 =?utf-8?B?TyszS3N6RXZVZCtVRWt4bEJmY1gxeS9YOURRUEFQSW9lZENvUDNMaVBGeXVR?=
 =?utf-8?B?VndjSEd6MTNsdzI2MWMzZVJNZjd0azZhV2F1OXhXTExWdjQzR255WHNvYzJ5?=
 =?utf-8?B?TVg3Q0k1TkMwR3JBeFYybHRFTnJEOU9SQ05kYm5UT2cwZC9sVnM0aU1MTzBw?=
 =?utf-8?B?ZTRycmU5VUlrS2o5eFBVSGlnYk5pNXZYcHNmUHZINzVKMVRmeVRCRWV3Wk8v?=
 =?utf-8?B?c2lySFFQUUpNeDdPell3WDJPL0hRbTFXMlpVR0l6SCtiSE1sQTZIdENDbWNN?=
 =?utf-8?B?NXpvS3pRMStBTDBMc01XM0NiQ3RpaU1IOVU1L2RIeXpmYTNhTEJZUnNvd25K?=
 =?utf-8?B?NWpOVmNUS1FNazJrbGZCc2NkeSs1YUNRTzE3NzlwdWVrRVFkdkFCRmJoL1lO?=
 =?utf-8?B?S3JsWkVGQjI3V3NJbExyMitDUmloSFgyUDZzcUloLzBvamd4VFhzMGVFQVda?=
 =?utf-8?B?eGtCOVpHcFRldmY0Yk1vY1RWUjFFeHhVemIzcS9PUjNxSXNRTmd0ejdZT0pl?=
 =?utf-8?B?Z0w1QTJndkgzMzVRRmRLamlMblFwZ2RJaVZlM2JFeitjdkh5L1ova1pWZ1FM?=
 =?utf-8?B?WGk3amQxWFVxOWxELzBKWTcvSXFQS0dHTzkyOUQra1FuL0lRUEl4d2krK241?=
 =?utf-8?B?ZkNKQXcyL2pqSGZKMmhmb1dOQ2w5SHBVbk03bEs2Uzc5UEdoREJFOE9JMXZn?=
 =?utf-8?B?SXJCL0lBK1JEWC9wSFQrMVVEeDY1UmtPQ0ZBZHpTMUVSUTRETU4rd1d6cHps?=
 =?utf-8?B?UlJsWlVYM2piWnJCUy8zRlpSSnZGWlZCbkdNT0NZRlp3TytEUi8vendJTkI2?=
 =?utf-8?Q?OQn+E1LGJNv79GFONkBSSIjw6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E79970E9B14DAF45B80B1509D1B9AF58@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR11MB4526.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ede1c42-e67c-452b-3e19-08dac8db18ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 20:34:16.3277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +5uVXjv09k5qGXgMYfVvjqUqRq8w7eVbKJqV7Tc3BAL3qomXXDEUyhxqYJP9ZSyifyMa0MeZy/38sKYdAmVrmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7304
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWF0ZXVzeiwNCg0KT24gV2VkLCAyMDIyLTExLTE2IGF0IDIxOjI4ICswMTAwLCBNYXRldXN6
IEpvxYRjenlrIHdyb3RlOg0KPiBPbiBrZXJuZWwgNi4xLXJjWCwgSSBoYXZlIGJlZW4gZ2V0dGlu
ZyB0aGUgZm9sbG93aW5nIGRtZXNnIGVycm9yDQo+IG1lc3NhZ2UNCj4gb24gZXZlcnkgYm9vdCwg
cmVzdW1lIGZyb20gc3VzcGVuZCBhbmQgcmZraWxsIHVuYmxvY2sgb2YgdGhlDQo+IEJsdWV0b290
aA0KPiBkZXZpY2U6DQo+IA0KPiDCoMKgwqDCoMKgwqDCoMKgQmx1ZXRvb3RoOiBoY2kwOiBIQ0lf
UkVRLTB4ZmNmMA0KPiANCg0KVGhpcyBoYXMgYSBwYXRjaCB0aGF0IGZpeGVzIHRoZSB1c2FnZSBv
ZiB0aGUgZGVwcmVjYXRlZCBIQ0lfUkVRDQptZWNoYW5pc20gcmF0aGVyIHRoYW4gaGlkaW5nIHRo
ZSBmYWN0IGl0IGlzIGJlaW5nIGNhbGxlZCwgYXMgaW4gdGhpcw0KY2FzZS4NCg0KSSBhbSBzdGls
bCB3YWl0aW5nIGZvciBzb21lb25lIHRvIGdpdmUgbWUgYSAiVGVzdGVkLUJ5OiIgdGFnIHRvIHBh
dGNoOg0KDQpbUEFUQ0ggMS8xXSBCbHVldG9vdGg6IENvbnZlcnQgTVNGVCBmaWx0ZXIgSENJIGNt
ZCB0byBoY2lfc3luYw0KDQpXaGljaCB3aWxsIGFsc28gc3RvcCB0aGUgZG1lc2cgZXJyb3IuIElm
IHlvdSBjb3VsZCB0cnkgdGhhdCBwYXRjaCwgYW5kDQpyZXNlbmQgaXQgdG8gdGhlIGxpc3Qgd2l0
aCBhIFRlc3RlZC1CeSB0YWcsIGl0IGNhbiBiZSBhcHBsaWVkLg0KDQpXZSBzdGlsbCB3YW50IHRv
IGJlIGFsbGVydGVkIHRvIGRlcHJlY2F0ZWQgdXNhZ2Ugc2l0dWF0aW9ucy4NCg0KPiBBZnRlciBz
b21lIGludmVzdGlnYXRpb24sIGl0IHR1cm5lZCBvdXQgdG8gYmUgY2F1c2VkIGJ5DQo+IGNvbW1p
dCBkZDUwYTg2NGZmYWUgKCJCbHVldG9vdGg6IERlbGV0ZSB1bnJlZmVyZW5jZWQgaGNpX3JlcXVl
c3QNCj4gY29kZSIpDQo+IHdoaWNoIG1vZGlmaWVkIGhjaV9yZXFfYWRkKCkgaW4gbmV0L2JsdWV0
b290aC9oY2lfcmVxdWVzdC5jIHRvIGFsd2F5cw0KPiBwcmludCBhbiBlcnJvciBtZXNzYWdlIHdo
ZW4gaXQgaXMgZXhlY3V0ZWQuIEluIG15IGNhc2UsIHRoZSBmdW5jdGlvbg0KPiB3YXMNCj4gZXhl
Y3V0ZWQgYnkgbXNmdF9zZXRfZmlsdGVyX2VuYWJsZSgpIGluIG5ldC9ibHVldG9vdGgvbXNmdC5j
LCB3aGljaA0KPiBwcm92aWRlcyBzdXBwb3J0IGZvciBNaWNyb3NvZnQgdmVuZG9yIG9wY29kZXMu
DQo+IA0KPiBBcyBleHBsYWluZWQgYnkgQnJpYW4gR2l4LCAidGhlIGVycm9yIGdldHMgbG9nZ2Vk
IGJlY2F1c2UgaXQgaXMgdXNpbmcNCj4gYQ0KPiBkZXByZWNhdGVkIChidXQgc3RpbGwgd29ya2lu
ZykgbWVjaGFuaXNtIHRvIGlzc3VlIEhDSSBvcGNvZGVzIiBbMV0uDQo+IFNvDQo+IHRoaXMgaXMg
anVzdCBhIGRlYnVnZ2luZyB0b29sIHRvIHNob3cgdGhhdCBhIGRlcHJlY2F0ZWQgZnVuY3Rpb24g
aXMNCj4gZXhlY3V0ZWQuIEFzIHN1Y2gsIGl0IHNob3VsZCBub3QgYmUgaW5jbHVkZWQgaW4gdGhl
IG1haW5saW5lIGtlcm5lbC4NCj4gU2VlIGZvciBleGFtcGxlDQo+IGNvbW1pdCA3NzFjMDM1Mzcy
YTAgKCJkZXByZWNhdGUgdGhlICdfX2RlcHJlY2F0ZWQnIGF0dHJpYnV0ZSB3YXJuaW5ncw0KPiBl
bnRpcmVseSBhbmQgZm9yIGdvb2QiKQ0KPiBBZGRpdGlvbmFsbHksIHRoaXMgZXJyb3IgbWVzc2Fn
ZSBpcyBjcnlwdGljIGFuZCB0aGUgdXNlciBpcyBub3QgYWJsZQ0KPiB0bw0KPiBkbyBhbnl0aGlu
ZyBhYm91dCBpdC4NCj4gDQo+IFsxXQ0KPiBMaW5rOg0KPiBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9sa21sL2JlYjhkY2RjM2FlZTRjNWM4MzNhYTM4MmYzNTk5NWYxN2U3OTYxYTEuY2FtZWxAaW50
ZWwuY29tLw0KPiANCj4gRml4ZXM6IGRkNTBhODY0ZmZhZSAoIkJsdWV0b290aDogRGVsZXRlIHVu
cmVmZXJlbmNlZCBoY2lfcmVxdWVzdA0KPiBjb2RlIikNCj4gU2lnbmVkLW9mZi1ieTogTWF0ZXVz
eiBKb8WEY3p5ayA8bWF0LmpvbmN6eWtAbzIucGw+DQo+IENjOiBCcmlhbiBHaXggPGJyaWFuLmdp
eEBpbnRlbC5jb20+DQo+IENjOiBMdWl6IEF1Z3VzdG8gdm9uIERlbnR6IDxsdWl6LnZvbi5kZW50
ekBpbnRlbC5jb20+DQo+IENjOiBNYXJjZWwgSG9sdG1hbm4gPG1hcmNlbEBob2x0bWFubi5vcmc+
DQo+IENjOiBKb2hhbiBIZWRiZXJnIDxqb2hhbi5oZWRiZXJnQGdtYWlsLmNvbT4NCj4gLS0tDQo+
IMKgbmV0L2JsdWV0b290aC9oY2lfcmVxdWVzdC5jIHwgMiArLQ0KPiDCoDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9i
bHVldG9vdGgvaGNpX3JlcXVlc3QuYw0KPiBiL25ldC9ibHVldG9vdGgvaGNpX3JlcXVlc3QuYw0K
PiBpbmRleCA1YTAyOTZhNDM1MmUuLmY3ZTAwNmEzNjM4MiAxMDA2NDQNCj4gLS0tIGEvbmV0L2Js
dWV0b290aC9oY2lfcmVxdWVzdC5jDQo+ICsrKyBiL25ldC9ibHVldG9vdGgvaGNpX3JlcXVlc3Qu
Yw0KPiBAQCAtMjY5LDcgKzI2OSw3IEBAIHZvaWQgaGNpX3JlcV9hZGRfZXYoc3RydWN0IGhjaV9y
ZXF1ZXN0ICpyZXEsIHUxNg0KPiBvcGNvZGUsIHUzMiBwbGVuLA0KPiDCoHZvaWQgaGNpX3JlcV9h
ZGQoc3RydWN0IGhjaV9yZXF1ZXN0ICpyZXEsIHUxNiBvcGNvZGUsIHUzMiBwbGVuLA0KPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb25zdCB2b2lkICpwYXJhbSkNCj4gwqB7DQo+
IC3CoMKgwqDCoMKgwqDCoGJ0X2Rldl9lcnIocmVxLT5oZGV2LCAiSENJX1JFUS0weCU0LjR4Iiwg
b3Bjb2RlKTsNCj4gK8KgwqDCoMKgwqDCoMKgYnRfZGV2X2RiZyhyZXEtPmhkZXYsICJIQ0lfUkVR
LTB4JTQuNHgiLCBvcGNvZGUpOw0KPiDCoMKgwqDCoMKgwqDCoMKgaGNpX3JlcV9hZGRfZXYocmVx
LCBvcGNvZGUsIHBsZW4sIHBhcmFtLCAwKTsNCj4gwqB9DQo+IMKgDQo+IA0KPiBiYXNlLWNvbW1p
dDogMDk0MjI2YWQ5NGY0NzFhOWYxOWU4ZjhlNzE0MGEwOWMyNjI1YWJhYQ0KDQpSZWdhcmRzLA0K
LS1CcmlhbiBHaXgNCg0K
