Return-Path: <netdev+bounces-1118-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9925E6FC418
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 147F32811A0
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2379DDB1;
	Tue,  9 May 2023 10:40:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1EA7C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:40:03 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36183C2F
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683628800; x=1715164800;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/kZQAZXbKv0KCuFFhgt+X3JjHtNpEp/qoqnZgpvKvcI=;
  b=bJL0JTLGeTZ7lRb+Iz0nqxyiEWHz9Pbp68STV9Ads3eKCFRLlFAJmxF9
   1aXjs6fqlASXTjxyBdvGmN+DVI5P+rl3DjygdjwmLfDyYT2vA97mNvnP3
   FVWG4l9mduFsjuozniQL4QrcT7ObMjEvWo3dt4R9x94KWNSNx+GYUw/ap
   DA6H0xvQ4ajJbiCHm3cTFBZ+uKEYZutaEGoDUfh7xy9+4PU//apqP2Uor
   nSGmUcLtfMzDNUhqpur014AlE9VkbjYrk0h1cS5xXxI4BcBqziBzpdRG1
   pE34Zhs+9LbCRDTFOkFXL+rLcAHwOrjPXDdMjnoYMY57/HJRaF4hQGFdz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="415460806"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="415460806"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 03:40:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="843056044"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="843056044"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 09 May 2023 03:40:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 03:39:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 03:39:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 03:39:59 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 03:39:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fktudUIpdjeZVKUNLREpannlVOpm0NUmgXW+t0DaYmbzGxvn6OzJ+Wb8IVN1PYsb+9htn+1xMmqWVfpPGyY9WrdK0UZu3HRBTAo7UUCQ0gY3Oz2qp3ZukY2ep45+M/guIca/wQmcJ7z6m0nvQszYWGZVaL2tyhtIPR4hvGNUcqGGK40iMcet+ymKC3mI8w0oxquRPp2z8h7Ke6Yoxbi51Dy60nz1OG2YlQAW6/aYOZozI9AyRtLKOzSns6SOfuouT2ifaw3Cu1In1CPqT4WXvOi8D/EVIDAM4MMl/vkPBZSS5W8i36X9+q5N2zBdzqwWyUnyhsZSuHZ1c9V3v5di2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/kZQAZXbKv0KCuFFhgt+X3JjHtNpEp/qoqnZgpvKvcI=;
 b=VK3no4K+8W8jyW/VYwINNnk0pd9po7zGVERmIa8cJ30FViiv7we5gk7HHzqkMC2R84ZTsYkgbCCtGgnzilx4illKBOKNQTfCcF8LfkHnOMI8SIcADkR0HsbZxmuvzriJHxUg+fEbV8B1ehChHKau5WuLmaKY/WIH/6iPt0eUkUfRlBL7QlCe41Tap0z3F7/eeVBI0xzVXW23A6CC4rVgIBiH5ohA5pjDJx+KctsIhhePnygQ/c8w5t8jdphC3OOfkECOoSI4ndHb2jf7yPweTB6EysEUs4Yn5Vwg3DCIbjZrlY4XesG5Njr3ipdlFBR5SrvlMYJD8BhigxYs2dUtvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by PH7PR11MB8035.namprd11.prod.outlook.com (2603:10b6:510:245::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 10:39:56 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 10:39:56 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Paolo Abeni <pabeni@redhat.com>, "edumazet@google.com"
	<edumazet@google.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>
CC: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "You,
 Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOA=
Date: Tue, 9 May 2023 10:39:55 +0000
Message-ID: <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
	 <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
In-Reply-To: <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|PH7PR11MB8035:EE_
x-ms-office365-filtering-correlation-id: bdfc5885-4d7d-4c8a-bdf1-08db5079bac5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2nedHFyfaRfXuwwQaNxXjf+tYMS2Cs01d4YolGdd2C7clv0VAqQXJqNJZ69LVWev8ffU4hDBKanqg2rC8VrDcVCmTTN/6A8s3/Je0ynJ2NhRm37I4sdNBL9QLByFpBQBeTrfNvBTDycPWLi4oG2XBWTXY3LxpfE9RlnjPjmofg4C0TkXvZs6oabHNrEIHO/+KhBnxtv9M6zsZoLoey7eufODvp4IhBpW8EUOnd6X/yZaqt6qnAYjj/lRhVgam1rHVgyukFeJG5CO/N44kZAuBIW23yZh7aPDfXzpPZI280k0asi8niF4Pn5DDcVhkDgzZmc7Dd/DCCXhKhP6XnVJEyXjDrmapaIlQAbrYObGiYXoowriafil9BeVSubFIxvBNFqqEWexo6wbLy4DV0vtxq8VrAx4MqYOF3ihaMwk2vwFM1QPXGufCWI542Azrh2S6loUHcfnj3pCv7bA2qYdiOMSE9TTBRHkAd/AyGpEJwAuREhepoiCrw3ChVyCZ7X+lQkVvNht3RXvdWz2JekFIYy5oiLFGZdZelbMOkRVprvDGYEhMhwXpBpTNYdlRvIt9Hzb25eT3Waknbjo1oRYM8NQYikHWzuZPQzuyWlYyBEiuEIPBKYVsqQE5VOR7jXH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199021)(83380400001)(9686003)(2906002)(53546011)(186003)(6506007)(4326008)(66946007)(66556008)(66476007)(66446008)(64756008)(71200400001)(76116006)(316002)(110136005)(54906003)(41300700001)(478600001)(5660300002)(26005)(52536014)(7696005)(8936002)(8676002)(55016003)(38100700002)(38070700005)(82960400001)(122000001)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDZocE9VZExvMGk5K2UwQWQyNG1vVHl4RnJqT3h3OHcxanJHTnVwOVduZVN2?=
 =?utf-8?B?NUhJWVdnRVpKc01TRlpWOHUvMEtqemFnSUEybzNGa3VpTUVGbXE4bzJnSHJF?=
 =?utf-8?B?VSt6MzQ0ckxrUGVqSnRVcnBjenRtTm1EWFZJSThOd2I1RUlodG1GblYyYXZF?=
 =?utf-8?B?UmQ2QlBVNDRvRXBoTSs1bEpEOXpNakxwWXJVc2JwTG16Q3djMFFzaDdzeEpP?=
 =?utf-8?B?VnJrZWZHYUJIZFBPRHg1cktkUTJuTThOays0S0dyQ0x5blkyMEpYT2pOVkp1?=
 =?utf-8?B?NmxNNENwOWd1SGowNnhlNmtnNnBOb0VYZVlHOXR5UnRNdDdoQ2pZaW81UW1L?=
 =?utf-8?B?QWpWVHZJTmp4blRhVUQvNlFFWHdadE9jcnozUXFKUTNkYXB6eTA0TlVLZE1P?=
 =?utf-8?B?Y1pVN3l2dldmRmJlRk1iWDFOdGZKWHd0dWpLTkhLRFZqK3hDcEpBSnQyQWkv?=
 =?utf-8?B?ZXR5WStsM24xdnBsWlFJbmMwUzRLT1JqWGgrem1jM1Jza2JLRlZBVHljZGN4?=
 =?utf-8?B?OUQvQmZHMkxTZmlWTFlmS0NNQlpQOXBaOXM5ZG9KNVk5ajlHVjFOcE13bUpZ?=
 =?utf-8?B?QWVFMnJMNXZWVEJKNERtVmJDR09HSXlYaXVuU2dyTG5sSndBU2g4Umk5MTVI?=
 =?utf-8?B?Zlg5cTkrUWZCeU5SNE1ZZ3htY1pSbWVLK1NXclZtRjUxcVVtalZwRm82ZTd4?=
 =?utf-8?B?VURpeXRBTXA1T3ZhMzlBSlBndkl2VkZTWDNNYkJnRllJZUNIZDUyY3ZaTDNt?=
 =?utf-8?B?Mk5iOSsvWUlRMlMrdWJQdWdzUVpHdzJ1VG9POEZaYi9vUmMvU0FNR0dkcHdp?=
 =?utf-8?B?MksyYnpJS3p5UlFQWXcrYUdwTkdaZ25ZUXllYU9wV3Y2L1YrcVdaa0lseUs4?=
 =?utf-8?B?V2duSm1BaXZwa09GbGFzR0luRU9aSW82enpYWmN2OWUvMkV1UEx6OEpCMjJU?=
 =?utf-8?B?dCtSV2VoYlIxTGtnKzdLMGVHNXFGak9HOEk3NFNVVS9pdUQwUTFlVzJXODcr?=
 =?utf-8?B?RzJnQkt6WWZId0NqOTA3S0dXNWxEVmF5V3J5S2V5a0h6Z3R1ZW1zTWgxUmlL?=
 =?utf-8?B?ZmNveVZXLzFuTkJUNE96NVhJR1R6ckNUSk5ldXRpTHA1VEs5MEZOdENaOE5F?=
 =?utf-8?B?MERZZGdISUJaaE1FaFBNeUlHaHRTTTVreDd3V3NZcnhEYlQ4NmVBT08rbmhk?=
 =?utf-8?B?MzQySytEcCsxb2hTRmdmd0JCT3BqRmtzVE9ET2EwUkZMODc5ZDBkRW5yMkdn?=
 =?utf-8?B?VWdaVHZvRkRqbVZCa2NkcUoxSlhyQklEelFJZllDOTdIY1c3djh1aFFBUlc2?=
 =?utf-8?B?Z0E1cG5XOHpqM2FwT2tEU3E5QUhYcEVvQXBINFJQa0pRSGtqVHp2ZUl2ZDNE?=
 =?utf-8?B?aUs5Q0M1R3NvT3ZmbDV4a2JwTlVZdk82dDF1eFRXd3docEMwTEpFb0E4K1VK?=
 =?utf-8?B?cVIxbjVVOFRySENldGcvbGxScGVRMzhBRHZOQW9acVhSQzE3TnZCaXZnT0Ju?=
 =?utf-8?B?aVpZNE1ZLytFSGt5ZXBKWUZTbkN1Zm1pUWxFVkszSU0yTmUyS0NRV2ZieDdu?=
 =?utf-8?B?Rnd4eUxjak9XdXczc0dXa0VBNUthaTZyNTBvTWxNT2hEQWdFc2gwSTBwTEJB?=
 =?utf-8?B?eEpRMnBsZmtRS3pTRHYzUUdNUm1XNkxZbkxEams1NU9KeUVGdncwS3MwWDRM?=
 =?utf-8?B?aEtuVXFkVnpCRGEvSE9RMTRxMHNiTklObW5HZ1Y5bDhpc0NzamZUekdqNGYy?=
 =?utf-8?B?OUk0RGdpVjFnRUpUWVBzTnZZbG9iUFF5RFpua3ZzNmNSRlpnTWUzaXZnYTl3?=
 =?utf-8?B?aFUrNUVGLytuTXlrdWcvMnh5Qk1pNFZDYTduMVNmaEtUQkJJanY4Y2hhSVdl?=
 =?utf-8?B?OE4wdDVrVDIzdU83SHlYRGdLWWxSdkMyVldzWllTdU5YbGVLZEVQa0xkUExl?=
 =?utf-8?B?VlJqTXpMa3F6WTJITm85bUhBVDlMczFCMWMrNWZReVhmRmNreFdETGY5N0pv?=
 =?utf-8?B?OWNLUTIwTG1YRzNpaWtNTTdaQ2tzVWR4QlBpZTBhTDJYYnJ4Y2liT000UzN2?=
 =?utf-8?B?ZFpmSElhK0FzVjQ4ejRuVVlObGJxNlZWeHJIb2ozODlhSFpoWjZINWI5ZTlz?=
 =?utf-8?Q?MC7qy+w1f5KqZCZNHid9qK27u?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdfc5885-4d7d-4c8a-bdf1-08db5079bac5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 10:39:55.7469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wgpf6KNVOYLd+gncLCLtGgILH7BpG8b8y7H4/4X1RlMmmOw2C3Z/PElmjr58SIbLxQ9PeUVHzlwoUtKzeSxBtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8035
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8gQWJlbmkgPHBh
YmVuaUByZWRoYXQuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBNYXkgOSwgMjAyMyA1OjUxIFBNDQo+
IFRvOiBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT47IGVkdW1hemV0QGdvb2ds
ZS5jb207DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZw0KPiBDYzogQnJh
bmRlYnVyZywgSmVzc2UgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsgU3Jpbml2YXMsIFN1
cmVzaA0KPiA8c3VyZXNoLnNyaW5pdmFzQGludGVsLmNvbT47IENoZW4sIFRpbSBDIDx0aW0uYy5j
aGVuQGludGVsLmNvbT47IFlvdSwNCj4gTGl6aGVuIDxsaXpoZW4ueW91QGludGVsLmNvbT47IGVy
aWMuZHVtYXpldEBnbWFpbC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVj
dDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzJdIG5ldDogS2VlcCBzay0+c2tfZm9yd2FyZF9hbGxv
YyBhcyBhIHByb3Blcg0KPiBzaXplDQo+IA0KPiBPbiBTdW4sIDIwMjMtMDUtMDcgYXQgMTk6MDgg
LTA3MDAsIENhdGh5IFpoYW5nIHdyb3RlOg0KPiA+IEJlZm9yZSBjb21taXQgNDg5MGI2ODZmNDA4
ICgibmV0OiBrZWVwIHNrLT5za19mb3J3YXJkX2FsbG9jIGFzIHNtYWxsDQo+ID4gYXMgcG9zc2li
bGUiKSwgZWFjaCBUQ1AgY2FuIGZvcndhcmQgYWxsb2NhdGUgdXAgdG8gMiBNQiBvZiBtZW1vcnkg
YW5kDQo+ID4gdGNwX21lbW9yeV9hbGxvY2F0ZWQgbWlnaHQgaGl0IHRjcCBtZW1vcnkgbGltaXRh
dGlvbiBxdWl0ZSBzb29uLiBUbw0KPiA+IHJlZHVjZSB0aGUgbWVtb3J5IHByZXNzdXJlLCB0aGF0
IGNvbW1pdCBrZWVwcyBzay0+c2tfZm9yd2FyZF9hbGxvYyBhcw0KPiA+IHNtYWxsIGFzIHBvc3Np
YmxlLCB3aGljaCB3aWxsIGJlIGxlc3MgdGhhbiAxIHBhZ2Ugc2l6ZSBpZg0KPiA+IFNPX1JFU0VS
VkVfTUVNIGlzIG5vdCBzcGVjaWZpZWQuDQo+ID4NCj4gPiBIb3dldmVyLCB3aXRoIGNvbW1pdCA0
ODkwYjY4NmY0MDggKCJuZXQ6IGtlZXAgc2stPnNrX2ZvcndhcmRfYWxsb2MgYXMNCj4gPiBzbWFs
bCBhcyBwb3NzaWJsZSIpLCBtZW1jZyBjaGFyZ2UgaG90IHBhdGhzIGFyZSBvYnNlcnZlZCB3aGls
ZSBzeXN0ZW0NCj4gPiBpcyBzdHJlc3NlZCB3aXRoIGEgbGFyZ2UgYW1vdW50IG9mIGNvbm5lY3Rp
b25zLiBUaGF0IGlzIGJlY2F1c2UNCj4gPiBzay0+c2tfZm9yd2FyZF9hbGxvYyBpcyB0b28gc21h
bGwgYW5kIGl0J3MgYWx3YXlzIGxlc3MgdGhhbiB0cnVlc2l6ZSwNCj4gPiBzay0+bmV0d29yayBo
YW5kbGVycyBsaWtlIHRjcF9yY3ZfZXN0YWJsaXNoZWQoKSBzaG91bGQganVtcCB0bw0KPiA+IHNs
b3cgcGF0aCBtb3JlIGZyZXF1ZW50bHkgdG8gaW5jcmVhc2Ugc2stPnNrX2ZvcndhcmRfYWxsb2Mu
IEVhY2gNCj4gPiBtZW1vcnkgYWxsb2NhdGlvbiB3aWxsIHRyaWdnZXIgbWVtY2cgY2hhcmdlLCB0
aGVuIHBlcmYgdG9wIHNob3dzIHRoZQ0KPiA+IGZvbGxvd2luZyBjb250ZW50aW9uIHBhdGhzIG9u
IHRoZSBidXN5IHN5c3RlbS4NCj4gPg0KPiA+ICAgICAxNi43NyUgIFtrZXJuZWxdICAgICAgICAg
ICAgW2tdIHBhZ2VfY291bnRlcl90cnlfY2hhcmdlDQo+ID4gICAgIDE2LjU2JSAgW2tlcm5lbF0g
ICAgICAgICAgICBba10gcGFnZV9jb3VudGVyX2NhbmNlbA0KPiA+ICAgICAxNS42NSUgIFtrZXJu
ZWxdICAgICAgICAgICAgW2tdIHRyeV9jaGFyZ2VfbWVtY2cNCj4gDQo+IEknbSBndWVzc2luZyB5
b3UgaGl0IG1lbWNnIGxpbWl0cyBmcmVxdWVudGx5LiBJJ20gd29uZGVyaW5nIGlmIGl0J3MganVz
dCBhDQo+IG1hdHRlciBvZiB0dW5pbmcvcmVkdWNpbmcgdGNwIGxpbWl0cyBpbiAvcHJvYy9zeXMv
bmV0L2lwdjQvdGNwX21lbS4NCg0KSGkgUGFvbG8sDQoNCkRvIHlvdSBtZWFuIGhpdHRpbmcgdGhl
IGxpbWl0IG9mICItLW1lbW9yeSIgd2hpY2ggc2V0IHdoZW4gc3RhcnQgY29udGFpbmVyPw0KSWYg
dGhlIG1lbW9yeSBvcHRpb24gaXMgbm90IHNwZWNpZmllZCB3aGVuIGluaXQgYSBjb250YWluZXIs
IGNncm91cDIgd2lsbCBjcmVhdGUNCmEgbWVtY2cgd2l0aG91dCBtZW1vcnkgbGltaXRhdGlvbiBv
biB0aGUgc3lzdGVtLCByaWdodD8gV2UndmUgcnVuIHRlc3QNCndpdGhvdXQgdGhpcyBzZXR0aW5n
LCBhbmQgdGhlIG1lbWNnIGNoYXJnZSBob3QgcGF0aHMgYWxzbyBleGlzdC4NCg0KSXQgc2VlbXMg
dGhhdCAvcHJvYy9zeXMvbmV0L2lwdjQvdGNwX1t3cl1tZW0gaXMgbm90IGFsbG93ZWQgdG8gYmUg
Y2hhbmdlZCBieQ0KYSBzaW1wbGUgZWNobyB3cml0aW5nLCBidXQgcmVxdWlyZXMgYSBjaGFuZ2Ug
dG8gL2V0Yy9zeXMuY29uZiwgSSdtIG5vdCBzdXJlIGlmIGl0DQpjb3VsZCBiZSBjaGFuZ2VkIHdp
dGhvdXQgc3RvcHBpbmcgdGhlIHJ1bm5pbmcgYXBwbGljYXRpb24uICBBZGRpdGlvbmFsbHksIHdp
bGwNCnRoaXMgdHlwZSBvZiBjaGFuZ2UgYnJpbmcgbW9yZSBkZWVwZXIgYW5kIGNvbXBsZXggaW1w
YWN0IG9mIG5ldHdvcmsgc3RhY2ssDQpjb21wYXJlZCB0byByZWNsYWltX3RocmVzaG9sZCB3aGlj
aCBpcyBhc3N1bWVkIHRvIG1vc3RseSBhZmZlY3Qgb2YgdGhlIG1lbW9yeQ0KYWxsb2NhdGlvbiBw
YXRocz8gQ29uc2lkZXJpbmcgYWJvdXQgdGhpcywgaXQncyBkZWNpZGVkIHRvIGFkZCB0aGUgcmVj
bGFpbV90aHJlc2hvbGQNCmRpcmVjdGx5Lg0KDQo+IA0KPiBDaGVlcnMsDQo+IA0KPiBQYW9sbw0K
DQo=

