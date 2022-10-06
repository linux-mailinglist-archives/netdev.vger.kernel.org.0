Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A8C5F6871
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 15:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiJFNp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 09:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiJFNpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 09:45:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9A09E6A3
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 06:45:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jl8OSSLuYd/KYZtO22REU95NMRdQJUuBh0N6XwArpv5ci+rOIFNaS/6T5u+c5fKROragwPrfrXAsC23KOJOVrWzS8Bz7MnH4AmHLvtCZmzRfSbSsNmeFbdYSlVixCW1A+XpEZEW0l9Uj6kGfhDyRUV9PCRkt+G9Uin2SZSOFVuhMoYduWd9Zrpr9/onh3m4zPlEmGF589PKTA4wkbuEhJOMbnGHwtqaPAvWYntWNL45v2FcmIPoxyLXsx/pKhNrmfiiLKCvYC17tEJD7WcpVi1AH5208kg4g+R97H0T9k5Gj64090clCx4jT7VT+S+OT6WecxIPC/1vgKokpYOhXRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jM/cCUW7Z6GRFGiTgsUgkjL7yRoynDai3qvoNLEvEIM=;
 b=Pp2S3k3i+28K6iF5Ddj9BmmFJsWx4YQHXg5en3BpkZeGrPdR7eIR5y25xouTVxEuQnHnxcoDDAsXMZ5ZgzkmcDu8csiYxX69ryOaeOrXTgO2KRWb4I63koKDRK7VMgJUk+xbVfts9VmEO3/eniW8tKVfVAyEL4O+JueXFgUrG8TrKEDlRsBfQbq94UHbfUd2c+6BDmxNjzwghBW+lCa6t2mWw80UD2h1oM4KacSXkZeoYn4CwPAd9iQ/5LDnYf22rgJwCf8L/Kp0Z0DyUqqYRSwfBK6NGaSv8SDim6Vj5cxb9sfadVDYRveOgiTSK1oWrcrg1Gqrn1s0F6cLW/3N+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jM/cCUW7Z6GRFGiTgsUgkjL7yRoynDai3qvoNLEvEIM=;
 b=pBEvuxAXbTtzotvTQdzIb8JQn633jvOiwtgE+KmixhFLTZ1DcD7HtB/nWk6VOduQHIjK+Q451DBwUvK0mjvR1bWyBw0iShJYAWAqll2bUR61k8OOY64gWqGn6036HP/0UqVXZbNaZEoqDNl7+rW+VhvgFFqxAGJ3Ctn8Db+iZfU=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by LV2PR12MB5941.namprd12.prod.outlook.com (2603:10b6:408:172::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.36; Thu, 6 Oct
 2022 13:45:49 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::b131:1ee7:1726:3ac9]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::b131:1ee7:1726:3ac9%5]) with mapi id 15.20.5676.036; Thu, 6 Oct 2022
 13:45:48 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "dmichail@fungible.com" <dmichail@fungible.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>
Subject: Re: [patch net-next 0/3] devlink: fix order of port and netdev
 register in drivers
Thread-Topic: [patch net-next 0/3] devlink: fix order of port and netdev
 register in drivers
Thread-Index: AQHY0aQfklrqw/9EBkuPEu5x26dKnK3+aDuAgAESfACAAAfEgIAB3NkAgAARFoA=
Date:   Thu, 6 Oct 2022 13:45:48 +0000
Message-ID: <77e69cf1-ad8e-963e-97d0-effdd7c1453f@amd.com>
References: <20220926110938.2800005-1-jiri@resnulli.us>
 <6dd32faa-2651-31bf-da2e-e768b9966e36@amd.com> <Yz03Cm/OBMae5IVT@nanopsycho>
 <c85fb638-77d1-dbbd-51aa-e39b05652e75@amd.com> <Yz7NkPIWItRy0hkC@nanopsycho>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.53.21091200
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|LV2PR12MB5941:EE_
x-ms-office365-filtering-correlation-id: 16457ad7-747e-4509-61cc-08daa7a11356
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0g9bWVebz0Y64bkzECXcIFcu2xnlsAs83GzEaBBEQXa5rAXBEEfhXdZCBabxky8PXymAYHmr95HGaiqILM7JqyEpvlezwM8hQqeHt/r3FZvuCTRC9dKG2pjtP64QkryZplHX+oLRx6k509dfy/0QA7sGeNvs1d3dmoiZYKukCBKva9T4jmTqIqC7RmOgLLOrYpMDFSv7vMHBW0MoNQZMx5ySiGyDT9SCEjWKCJ1AalM/7HUgsGNI3zCCKDTZhNKzKDNePzBE8IE29NgFCN9U7xSZXwK7stwieefWrP7b/4vPsA3bnT9ie6jdhQiA1NsiFoG2snY2UcV5jivC8xH4k+71jrd+qBKEW1r4DjxNCnfpDLeFxl7Fc30UUV8FLWfibt9PnY/F+C0WVGx04aNMrhYmCyEtx4Eqwk+rpLfLJM3aJchd13eQAB0MrraqsbUZ8zGSJRpgDByiFbusRfiusJVsOE2XHK8H3nWX2gIF/zWtJRD/iFfha0dRnYnBojRGnDMj4WNdU4gD8HSD0G2iY8Cf0tvEhTys2ro179eBK8AgRDOrn029Go6LUyYvWCUjJ107YieEYZHRNz9AFMXgZrybPMVsBVCrNJXuP3z7Y1UDy5+Vn4QMMuUCRGJ9Sdsle8FcfxmivoSatErT7zBgmlI2IQTJ8XJm4GWZ9DWWCMn6D9GCCR7MN34vyI9qTZkIDxqocRcQ3l3YtaslICbcR8SidX8koceyB+khIY1ful/8fS9bd+xNY0ir0EgtMaT8j5/nYqsANZ+KpECIJz2KweHBZajNnmjRRCX81WEXZaE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199015)(31686004)(83380400001)(316002)(86362001)(31696002)(2906002)(36756003)(6512007)(38070700005)(186003)(122000001)(38100700002)(7416002)(5660300002)(8936002)(76116006)(66946007)(66556008)(66476007)(64756008)(8676002)(91956017)(66446008)(4326008)(41300700001)(478600001)(110136005)(54906003)(6506007)(2616005)(53546011)(26005)(6486002)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YW8zS3UvRGd0U1JFL0pFVS9QY2hMblJ4UnBpNUp3a1NSWTRiNlUrcGs5UTNr?=
 =?utf-8?B?bkllREw3ZmhkMkFqRlZZcVFYYVdva2JPcGE5RXc2cXdJNnZxWGVYZlZLdU1j?=
 =?utf-8?B?WDJ4Q1dsUnovNXdHVm5DUFJUeFBoM2lCTlFqYUVHa21aMk5WeHVkWm9YR3Rw?=
 =?utf-8?B?MGRlNVU1WXZlbjMrcFI5U3N5OHpFbmU5byt0SXpUYkZVMXljYngrKzdQczc1?=
 =?utf-8?B?cU5aa1I0WENEQTVBRk0yMXpZM2ZxcFpEL1BHcWp5NTlIaitNcm1FNnVXdURX?=
 =?utf-8?B?cnI4NVFuZjVGTUVLbGhnbDhEQzBNaC91KzBlTnJEa1dpb3FVUGgrajFFc0sx?=
 =?utf-8?B?bkM4YVNHVVdEVjBGY3BRTXNiSytJNWVZN29iS1U5bnkxaEZwUXIxL1R2UE9m?=
 =?utf-8?B?OVdHSnU2MERBbVBkTXF4V2xtbWZqbWpKMWhlT0dWQWw1SnRVWjB3b0VQNzgr?=
 =?utf-8?B?RDZpZ01RUGo1NkMzQWJNSmZsMW1ZbHVMR1IrWEswcCtvb0hmTDFXNENCQS9w?=
 =?utf-8?B?aUhDQ2wwTCtEWk8xdzRFMGJSVGlNZDFXZTFhZ0hDdFdDR3RjTjlwWjhIaWI4?=
 =?utf-8?B?ZHlFVGdnNFQ0YVNwWmJ3SThqRmFibkxWMWhUaDVJQ0Z5a3ovRm1uQWpCSFor?=
 =?utf-8?B?WXZHQ0tKNFpGbGtYTWx3ajljRlYwclphZTZrWXRTN1hRcERHalB3R0t5UkFF?=
 =?utf-8?B?SEhzYWwrZkF4blFZeU1WODhBc1cvcmZxNUlJM3QxMTdhSmVleUpxazRlYUNL?=
 =?utf-8?B?aTNxUFFreTZFY1pQSnB5ejAyMTlmZ21PRjFacXdyeU5sOFRjcFJvYVZzYU9i?=
 =?utf-8?B?TmNSeWNKVXV4Rk9kSXYvQStEYjBMNExHSnZ3aGUwdFd6MHRhR280Z2llUlRT?=
 =?utf-8?B?VDIrdDhGaHVXOXNVbzVRQm14cG8rOWVVRDdrNGphc2NRMXRGbjdmTU50VjVw?=
 =?utf-8?B?aTYwUkoyOElTYlRpWG9JblNkZERLT1pVOFhWdlljSE1GUVdYZ3dpY0J3dzY0?=
 =?utf-8?B?ODk3N3h1b0RaMGNHVHl1d1FWQW9Gb0E5T3orMU5CNmdnK2dUd2YyZVFKdzdu?=
 =?utf-8?B?QWwvYkgxSVFDN3BjbHFheWtwZThGeUJPejJPV0RJNEpZRkxUY3ZmN2c0NVla?=
 =?utf-8?B?aGkyWWI0algwQmRWNzNoV1FyeXdCdnQ3ZjFoV0liRkxXYXY0aUJ1U1lNOVkz?=
 =?utf-8?B?eWREZnVmRnR2ZEtBSHR0VEcyQ29LTjJjZ2FFTDdmMUR2b0RxN0hmeTFxdmU4?=
 =?utf-8?B?UDArMU15RzZ3S3p4cVNVT09zV2VQeCs3YStoQkQ3ci9OU2Z4TTRWMlF4ZHFY?=
 =?utf-8?B?T3Z6OHJJUmVpZHhmQVI2SXQ5eXpVOHJBT2pIU3g3OFhJVE1HNisyWmRab3pz?=
 =?utf-8?B?UXN2UUIvOHdRbkRtYlpUUlVEUHRSTitqUnVTTDFmaFltNTZXNGV2ZXVjY2dW?=
 =?utf-8?B?ZUppbE9vaWZmajF6OUlpZmRLWmN6ZFY2bnRUWDhNeVk3K1BnMFNiZncxMHZP?=
 =?utf-8?B?S2NQQ3BTWWNTZTR4ZTVJeEhSbDFXUHM2d0dRUHF4Mm9vc2xjUzhKMkpDM2NB?=
 =?utf-8?B?aW0rVHhPZVJjc3hBYnNjMUhnL2NaZmhONFhMNmE2T3B4NzZSWUJCRUg4RVh2?=
 =?utf-8?B?bUo4N1ozZGxDaFVTU3N0YXVGeUpVQll0b3ZtZnZvU1VYT3RuTG1TYnkrZkgx?=
 =?utf-8?B?YmtzLzFHdFJtVWk2Yy9wQmNMUlZ4TDJ6ZytyWXUrMmgwUEU4TUlWc0ZBZ1ZK?=
 =?utf-8?B?YXltNFpVaTJSVzRrL0xOSmpKdnZzanNxWlpzaXVtQmt2aHYxdmdMM0RzU0RD?=
 =?utf-8?B?U0hyaUQzV1JFNHkwNy8ycG5SSllNZ0NUVVFlVXZBUTg2SDNQT1o1OWVMWHZj?=
 =?utf-8?B?SjNrSVl1ZjdLelJCbEdmVGxWK3h2TXhDT0xzQlJxYlIyc2x6eEtSM3M2RXNv?=
 =?utf-8?B?SzR3UE9xUXN5Y3Zid2FaNE1mYnpock1iNm1uVTEwWFlnNGd4N05MNUV0dDI4?=
 =?utf-8?B?dkMyVFFycjF6b0J2SVdRMm04cFM0Qm1TS2ZPU2hSanFXOGhhcXJMMkhTMk5S?=
 =?utf-8?B?TFJIMTlPUEtWZUhZbDFrZmFvdmYwK1BWSWJXYXRSNTh4WkFyOTBZSEpYSmxH?=
 =?utf-8?Q?uvKXXVh2L4WD6Ph+W/hu3EJ8H?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86AAF6F73138934786689ECB8C9C545A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16457ad7-747e-4509-61cc-08daa7a11356
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2022 13:45:48.2035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FFTYx+KHsh9okks/wCZMXsMD6fekleo+it+iK2zYROTXEFPWHnuDhSBhYP/0cQPDBGx5V3GGvElMY8Gud0cmiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5941
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxMC82LzIyIDE0OjQ0LCBKaXJpIFBpcmtvIHdyb3RlOg0KPiBXZWQsIE9jdCAwNSwgMjAy
MiBhdCAxMDoxODoyOUFNIENFU1QsIGFsZWphbmRyby5sdWNlcm8tcGFsYXVAYW1kLmNvbSB3cm90
ZToNCj4+IE9uIDEwLzUvMjIgMDk6NDksIEppcmkgUGlya28gd3JvdGU6DQo+Pj4gVHVlLCBPY3Qg
MDQsIDIwMjIgYXQgMDU6MzE6MTBQTSBDRVNULCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5j
b20gd3JvdGU6DQo+Pj4+IEhpIEppcmksDQo+Pj4gSSBkb24ndCB1bmRlcnN0YW5kIHdoeSB5b3Ug
c2VuZCB0aGlzIGFzIGEgcmVwbHkgdG8gdGhpcyBwYXRjaHNldC4gSQ0KPj4+IGRvbid0IHNlZSB0
aGUgcmVsYXRpb24gdG8gaXQuDQo+PiBJIHRob3VnaHQgdGhlcmUgd2FzIGEgcmVsYXRpb25zaGlw
IHdpdGggb3JkZXJpbmcgYmVpbmcgdGhlIGlzc3VlLg0KPj4NCj4+IEFwb2xvZ2llcyBpZiB0aGlz
IGlzIG5vdCB0aGUgcmlnaHQgd2F5IGZvciByaXNpbmcgbXkgY29uY2Vybi4NCj4+DQo+Pg0KPj4+
PiBJIHRoaW5rIHdlIGhhdmUgYW5vdGhlciBpc3N1ZSB3aXRoIGRldmxpbmtfdW5yZWdpc3RlciBh
bmQgcmVsYXRlZA0KPj4+PiBkZXZsaW5rX3BvcnRfdW5yZWdpc3Rlci4gSXQgaXMgbGlrZWx5IG5v
dCBhbiBpc3N1ZSB3aXRoIGN1cnJlbnQgZHJpdmVycw0KPj4+PiBiZWNhdXNlIHRoZSBkZXZsaW5r
IHBvcnRzIGFyZSBtYW5hZ2VkIGJ5IG5ldGRldiByZWdpc3Rlci91bnJlZ2lzdGVyDQo+Pj4+IGNv
ZGUsIGFuZCB3aXRoIHlvdXIgcGF0Y2ggdGhhdCB3aWxsIGJlIGZpbmUuDQo+Pj4+DQo+Pj4+IEJ1
dCBieSBkZWZpbml0aW9uLCBkZXZsaW5rIGRvZXMgZXhpc3QgZm9yIHRob3NlIHRoaW5ncyBub3Qg
bWF0Y2hpbmcNCj4+Pj4gc21vb3RobHkgdG8gbmV0ZGV2cywgc28gaXQgaXMgZXhwZWN0ZWQgZGV2
bGluayBwb3J0cyBub3QgcmVsYXRlZCB0bw0KPj4+PiBleGlzdGluZyBuZXRkZXZzIGF0IGFsbC4g
VGhhdCBpcyB0aGUgY2FzZSBpbiBhIHBhdGNoIEknbSB3b3JraW5nIG9uIGZvcg0KPj4+PiBzZmMg
ZWYxMDAsIHdoZXJlIGRldmxpbmsgcG9ydHMgYXJlIGNyZWF0ZWQgYXQgUEYgaW5pdGlhbGl6YXRp
b24sIHNvDQo+Pj4+IHJlbGF0ZWQgbmV0ZGV2cyB3aWxsIG5vdCBiZSB0aGVyZSBhdCB0aGF0IHBv
aW50LCBhbmQgdGhleSBjYW4gbm90IGV4aXN0DQo+Pj4+IHdoZW4gdGhlIGRldmxpbmsgcG9ydHMg
YXJlIHJlbW92ZWQgd2hlbiB0aGUgZHJpdmVyIGlzIHJlbW92ZWQuDQo+Pj4+DQo+Pj4+IFNvIHRo
ZSBxdWVzdGlvbiBpbiB0aGlzIGNhc2UgaXMsIHNob3VsZCB0aGUgZGV2bGluayBwb3J0cyB1bnJl
Z2lzdGVyDQo+Pj4+IGJlZm9yZSBvciBhZnRlciB0aGVpciBkZXZsaW5rIHVucmVnaXN0ZXJzPw0K
Pj4+IEJlZm9yZS4gSWYgZGV2bGluayBpbnN0YW5jZSBzaG91bGQgYmUgdW5yZWdpc3RlcmVkIG9u
bHkgYWZ0ZXIgYWxsIG90aGVyDQo+Pj4gcmVsYXRlZCBpbnN0YW5jZXMgYXJlIGdvbmUuDQo+Pj4N
Cj4+PiBBbHNvLCB0aGUgZGV2bGluayBwb3J0cyBjb21lIGFuZCBnbyBkdXJpbmcgdGhlIGRldmxp
bmsgbGlmZXRpbWUuIFdoZW4NCj4+PiB5b3UgYWRkIGEgVkYsIHNwbGl0IGEgcG9ydCBmb3IgZXhh
bXBsZS4gVGhlcmUgYXJlIG1hbnkgb3RoZXIgY2FzZXMuDQo+Pj4NCj4+Pg0KPj4+PiBTaW5jZSB0
aGUgcG9ydHMgYXJlIGluIGEgbGlzdCBvd25lZCBieSB0aGUgZGV2bGluayBzdHJ1Y3QsIEkgdGhp
bmsgaXQNCj4+Pj4gc2VlbXMgbG9naWNhbCB0byB1bnJlZ2lzdGVyIHRoZSBwb3J0cyBmaXJzdCwg
YW5kIHRoYXQgaXMgd2hhdCBJIGRpZC4gSXQNCj4+Pj4gd29ya3MgYnV0IHRoZXJlIGV4aXN0cyBh
IHBvdGVudGlhbCBjb25jdXJyZW5jeSBpc3N1ZSB3aXRoIGRldmxpbmsgdXNlcg0KPj4+IFdoYXQg
Y29uY3VycmVuY3kgaXNzdWUgYXJlIHlvdSB0YWxraW5nIGFib3V0Pw0KPj4+DQo+PiAxKSBkZXZs
aW5rIHBvcnQgZnVuY3Rpb24gc2V0IC4uLg0KPj4NCj4+IDIpIHByZWRvaXQgaW5zaWRlIGRldmxp
bmsgb2J0YWlucyBkZXZsaW5rIHRoZW4gdGhlIHJlZmVyZW5jZSB0byBkZXZsaW5rDQo+PiBwb3J0
LiBDb2RlIGRvZXMgYSBwdXQgb24gZGV2bGluayBidXQgbm90IG9uIHRoZSBkZXZsaW5rIHBvcnQu
DQo+IGRldmxfbG9jayBpcyB0YWtlbiBoZXJlLg0KDQpUaGlzIGlzIGVtYmFycmFzc2luZy4NCg0K
U29tZWhvdyBJIG1pc3JlYWQgdGhlIGNvZGUgYXNzdW1pbmcgdGhlIHByb3RlY3Rpb24gd2FzIG9u
bHkgYmFzZWQgb24gdGhlIA0KZ2V0IG9wZXJhdGlvbiwgdGhhdCB0aGUgZGV2bGluayBsb2NrIHdh
cyByZWxlYXNlZCB0aGVyZSBhbmQgbm90IGluIHRoZSANCnBvc3RfZG9pdC4NCg0KVGhhdCBnb3Rv
IHVubG9jayBjb25mdXNlZCBtZSwgSSBndWVzcywgYWxvbmcgd2l0aCBhIGJpYXMgbG9va2luZyBm
b3IgDQpvcmRlcmluZyBpc3N1ZXMuDQoNCkFwb2xvZ2llcy4NCg0KSGFwcHkgdG8gc2VlIGFsbCBp
cyBmaW5lLg0KDQpUaGFuayB5b3UuDQoNCj4NCj4+IDMpIGRyaXZlciBpcyByZW1vdmVkLiBkZXZs
aW5rIHBvcnQgaXMgcmVtb3ZlZC4gZGV2bGluayBpcyBub3QgYmVjYXVzZQ0KPiBkZXZsX2xvY2sg
dGFrZW4gYmVmb3JlIHBvcnQgaXMgcmVtb3ZlZCBhbmQgd2lsbCBibG9jayB0aGVyZS4NCj4NCj4g
SSBkb24ndCBzZWUgYW55IHByb2JsZW0uIERpZCB5b3UgYWN0dWFsbHkgZW5jb3V0ZXJlZCBhbnkg
cHJvYmxlbT8NCj4NCj4NCj4+IHRoZSBwdXQuDQo+Pg0KPj4gNCkgZGV2bGluayBwb3J0IHJlZmVy
ZW5jZSBpcyB3cm9uZy4NCj4+DQo+Pg0KPj4+PiBzcGFjZSBvcGVyYXRpb25zLiBUaGUgZGV2bGlu
ayBjb2RlIHRha2VzIGNhcmUgb2YgcmFjZSBjb25kaXRpb25zIGludm9sdmluZyB0aGUNCj4+Pj4g
ZGV2bGluayBzdHJ1Y3Qgd2l0aCByY3UgcGx1cyBnZXQvcHV0IG9wZXJhdGlvbnMsIGJ1dCB0aGF0
IGlzIG5vdCB0aGUNCj4+Pj4gY2FzZSBmb3IgZGV2bGluayBwb3J0cy4NCj4+Pj4NCj4+Pj4gSW50
ZXJlc3RpbmdseSwgdW5yZWdpc3RlcmluZyB0aGUgZGV2bGluayBmaXJzdCwgYW5kIGRvaW5nIHNv
IHdpdGggdGhlDQo+Pj4+IHBvcnRzIHdpdGhvdXQgdG91Y2hpbmcvcmVsZWFzaW5nIHRoZSBkZXZs
aW5rIHN0cnVjdCB3b3VsZCBzb2x2ZSB0aGUNCj4+Pj4gcHJvYmxlbSwgYnV0IG5vdCBzdXJlIHRo
aXMgaXMgdGhlIHJpZ2h0IGFwcHJvYWNoIGhlcmUuIEl0IGRvZXMgbm90IHNlZW0NCj4+PiBJdCBp
cyBub3QuIEFzIEkgd3JvdGUgYWJvdmUsIHRoZSBkZXZsaW5rIHBvcnRzIGNvbWUgYW5kIGdvLg0K
Pj4+DQo+Pj4NCj4+Pj4gY2xlYW4sIGFuZCBpdCB3b3VsZCByZXF1aXJlIGRvY3VtZW50aW5nIHRo
ZSByaWdodCB1bndpbmRpbmcgb3JkZXIgYW5kDQo+Pj4+IHRvIGFkZCBhIGNoZWNrIGZvciBERVZM
SU5LX1JFR0lTVEVSRUQgaW4gZGV2bGlua19wb3J0X3VucmVnaXN0ZXIuDQo+Pj4+DQo+Pj4+IEkg
dGhpbmsgdGhlIHJpZ2h0IHNvbHV0aW9uIHdvdWxkIGJlIHRvIGFkZCBwcm90ZWN0aW9uIHRvIGRl
dmxpbmsgcG9ydHMNCj4+Pj4gYW5kIGxpa2VseSBvdGhlciBkZXZsaW5rIG9iamVjdHMgd2l0aCBz
aW1pbGFyIGNvbmN1cnJlbmN5IGlzc3Vlcy4NCj4+Pj4NCj4+Pj4NCj4+Pj4gTGV0IG1lIGtub3cg
d2hhdCB5b3UgdGhpbmsgYWJvdXQgaXQuDQo+Pj4+DQo+Pj4+DQo+Pj4+DQo+Pj4+IE9uIDkvMjYv
MjIgMTM6MDksIEppcmkgUGlya28gd3JvdGU6DQo+Pj4+PiBDQVVUSU9OOiBUaGlzIG1lc3NhZ2Ug
aGFzIG9yaWdpbmF0ZWQgZnJvbSBhbiBFeHRlcm5hbCBTb3VyY2UuIFBsZWFzZSB1c2UgcHJvcGVy
IGp1ZGdtZW50IGFuZCBjYXV0aW9uIHdoZW4gb3BlbmluZyBhdHRhY2htZW50cywgY2xpY2tpbmcg
bGlua3MsIG9yIHJlc3BvbmRpbmcgdG8gdGhpcyBlbWFpbC4NCj4+Pj4+DQo+Pj4+Pg0KPj4+Pj4g
RnJvbTogSmlyaSBQaXJrbyA8amlyaUBudmlkaWEuY29tPg0KPj4+Pj4NCj4+Pj4+IFNvbWUgb2Yg
dGhlIGRyaXZlcnMgdXNlIHdyb25nIG9yZGVyIGluIHJlZ2lzdGVyaW5nIGRldmxpbmsgcG9ydCBh
bmQNCj4+Pj4+IG5ldGRldiwgcmVnaXN0ZXJpbmcgbmV0ZGV2IGZpcnN0LiBUaGF0IHdhcyBub3Qg
aW50ZW5kZWQgYXMgdGhlIGRldmxpbmsNCj4+Pj4+IHBvcnQgaXMgc29tZSBzb3J0IG9mIHBhcmVu
dCBmb3IgdGhlIG5ldGRldi4gRml4IHRoZSBvcmRlcmluZy4NCj4+Pj4+DQo+Pj4+PiBOb3RlIHRo
YXQgdGhlIGZvbGxvdy11cCBwYXRjaHNldCBpcyBnb2luZyB0byBtYWtlIHRoaXMgb3JkZXJpbmcN
Cj4+Pj4+IG1hbmRhdG9yeS4NCj4+Pj4+DQo+Pj4+PiBKaXJpIFBpcmtvICgzKToNCj4+Pj4+ICAg
ICAgZnVuZXRoOiB1bnJlZ2lzdGVyIGRldmxpbmsgcG9ydCBhZnRlciBuZXRkZXZpY2UgdW5yZWdp
c3Rlcg0KPj4+Pj4gICAgICBpY2U6IHJlb3JkZXIgUEYvcmVwcmVzZW50b3IgZGV2bGluayBwb3J0
IHJlZ2lzdGVyL3VucmVnaXN0ZXIgZmxvd3MNCj4+Pj4+ICAgICAgaW9uaWM6IGNoYW5nZSBvcmRl
ciBvZiBkZXZsaW5rIHBvcnQgcmVnaXN0ZXIgYW5kIG5ldGRldiByZWdpc3Rlcg0KPj4+Pj4NCj4+
Pj4+ICAgICAuLi4vbmV0L2V0aGVybmV0L2Z1bmdpYmxlL2Z1bmV0aC9mdW5ldGhfbWFpbi5jICAg
fCAgMiArLQ0KPj4+Pj4gICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbGli
LmMgICAgICAgICB8ICA2ICsrKy0tLQ0KPj4+Pj4gICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2ljZS9pY2VfbWFpbi5jICAgICAgICB8IDEyICsrKysrKy0tLS0tLQ0KPj4+Pj4gICAgIGRy
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfcmVwci5jICAgICAgICB8ICAyICstDQo+
Pj4+PiAgICAgLi4uL25ldC9ldGhlcm5ldC9wZW5zYW5kby9pb25pYy9pb25pY19idXNfcGNpLmMg
IHwgMTYgKysrKysrKystLS0tLS0tLQ0KPj4+Pj4gICAgIDUgZmlsZXMgY2hhbmdlZCwgMTkgaW5z
ZXJ0aW9ucygrKSwgMTkgZGVsZXRpb25zKC0pDQo+Pj4+Pg0KPj4+Pj4gLS0NCj4+Pj4+IDIuMzcu
MQ0KPj4+Pj4NCg0K
