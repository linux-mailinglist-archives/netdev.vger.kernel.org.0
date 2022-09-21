Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1955BF30E
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 03:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiIUBrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 21:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiIUBrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 21:47:42 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2110.outbound.protection.outlook.com [40.107.94.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4427AC03
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 18:47:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cB6b1y3bydl61luiyuFEeBNZc1+wEgNifQJDbUcoD45rDQmAAsSfstlOVxNPWAh6WkzEi954IEj2JV3HoHC6GsSY8t4AkUe+9LLfIdIzCyFV7fgA9EvpE040OPsEi1TZHHFT4hgNXRRnf0g1jIKEfTWqnW8ja7b3ypZ/eKtaLVuAiWsQlRciU6z3Lq7MUrTGwG6SfchqjkFY/9AAqODUaX8SJWpPq5392U+MgEGT7H7xlARSKWYxMBkjsKWGLOAaI7sHD9Yli3k6DOYAzb6IwVXZqMvnjWQRvxZ9c/nu9ygLoyf9X+T/06tlR8UBqjpyzAWABL8EdvSsNeNEHjUdbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1b3vDNZIfsMIXaV5QW3dAflOl2IuGp9APg47MS2lmI=;
 b=dz/VAee9dUQgr0vsWJz65WRO6R312hW+RJZnWn5GJZrVtMbXSsYnMK2ASHgxz9iD8plyi32+LvAAtbBachlNvzms3Jz3SXJ5mT9I7GwreXn+eW0IzaZZrF8rhJeCc1PU8qjgts2rc6+9HF785EDuigft1eFhuRIn6Fsn0QBu7XfkKYW/XLFTlDgw6HGX7HHKKTFp7Xe8ztRSWn/lt/1Evq8eRChXq9SxzaBWWDS9j+kl4L51SeofJ8Yyhm496xg3/Y0JMsa00VsDUK/IO6buu50fmHXlwm+mfDdUxGkJYtOfMzD8qHWvvfQ39FoeUvoutpc+tQMSh58NJ7zV+lTKaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1b3vDNZIfsMIXaV5QW3dAflOl2IuGp9APg47MS2lmI=;
 b=um37N1dCQLCyH9mqaA2nsp+l8HXwzHvBXVXzdmswBaUBoZQ0PKI0BBxYX4Ro1R3FPnf1KpEVGFZ2Y9z31N4LVGXALYDwfjQS9DZguxgX2gVpvdQ1xgwGq+8QUTQfLkUvXNxM+BLLpIIewspZItd6sGkY2rJ59JLOsXNHJFUaCf4=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by BN0PR13MB5118.namprd13.prod.outlook.com (2603:10b6:408:161::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 01:47:38 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be%5]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 01:47:38 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Diana Wang <na.wang@corigine.com>,
        Nole Zhang <peng.zhang@corigine.com>
Subject: RE: [PATCH/RFC net-next 2/3] devlink: Add new "max_vf_queue" generic
 device param
Thread-Topic: [PATCH/RFC net-next 2/3] devlink: Add new "max_vf_queue" generic
 device param
Thread-Index: AQHYzQPRny9cCQcOJ0ugwm6mPl4IF63oo1YAgABzWXA=
Date:   Wed, 21 Sep 2022 01:47:37 +0000
Message-ID: <DM6PR13MB3705489004C9372EABED69CDFC4F9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20220920151419.76050-1-simon.horman@corigine.com>
 <20220920151419.76050-3-simon.horman@corigine.com>
 <2af4e971-b480-6aff-c26b-6fd60b7523fb@gmail.com>
In-Reply-To: <2af4e971-b480-6aff-c26b-6fd60b7523fb@gmail.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|BN0PR13MB5118:EE_
x-ms-office365-filtering-correlation-id: 38a1ce75-8072-4d4a-b84d-08da9b734363
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZZxWzA3nYGhObOrfO07PbeYNSdUPgRjlo7BgT58uyZFFpa0BLDYeNmauuJvxZcgV14gsvHSbQi/LC06apaTONJ5F0rU2qxzkRgx+E2ZslNQb0lbjd5g/lcVG7g5/+iRg2SDLJKsPxtIBsko8Ncrl7ftqx/XUIv8bCFFHcYa00aLn4n4XnFjbHVEGRJUrspr41FKHbHHZTSuTbzmDFR1GjDQeP3SPnCU3BDeyHt81zRRkV+/NjbGMWmfs+RlCx/tLt89EfxrGAcDVwkleQO3z1zsOg1V7spMx9grK92JVkhqUBaWEIq658MdUfn3srI1WVELEPtgbEmevISHYk7vHFMSviStgjjCQ1lqutmdS7Y4n1UfWfo0yIXdVzrIwcOKYh6NVsSjuEVy73IC+YT6GN+QldOkqRTsbIwYps3gVltwDeE4Ce5Ch8CjuwgZof/0OlnrOhRJ+0mduEdNXIovexDCdIj5gm1FOgWFkCwHko0fHp6rD4n++uGZMqegtG3reyD98zXpjjv0T4lpUzKMkhnAOxlEAmd541wK0D0t/BYxOs4f5ih+LS4iFL4XPWUGTB5W6trWx2am26IPsELTUjNUmlLdl/jRIHzkc8c3t6MtplkBZYtIDTLAdlTtz3nJYtrXOroD8TpjL8uVpwI+x1KLuYi41hWVau1FEI2w/OYNsbUYy4gndY6GjdV6YibM/PiOLsQMLyqRr03O3cs7JnzWl5iTWbFt9TvHlc4HUkqsdvnhPOwLPp5NrOzI3YVY2mTni0teEzFgrsZUpNS+wn5yoY3ngtWvoyl6y54REqnL4ApEsX03p5RVtdomKdBVf2QxWX0vmVbz2axWu/2fE8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(39840400004)(376002)(451199015)(33656002)(71200400001)(478600001)(66899012)(55016003)(122000001)(38100700002)(38070700005)(86362001)(186003)(53546011)(6506007)(41300700001)(107886003)(7696005)(76116006)(4326008)(9686003)(26005)(52536014)(8936002)(2906002)(5660300002)(8676002)(66946007)(66446008)(64756008)(66556008)(66476007)(44832011)(54906003)(110136005)(316002)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STVMVU05YmZCcVBjdVU5NHZYUEFCakVsUWc5Z1UyWFJnOXYwc3p4VFBYb0dO?=
 =?utf-8?B?cmR5UlBmRUNSN1lDbCtxTW9FVWdGUi9NREdGWjZVNlQycHRqTkVud1hmMjVn?=
 =?utf-8?B?ZzlYRHNhd0V0UnZRc3NnVktlLzV4Nk5rMEduanBWNW9UYmxaN2hIOWQ4MnM3?=
 =?utf-8?B?QjFiMnhPSTJ0dDllVzBzL0E5Z0UwV3hTVk1QUDIwU2VxWVZqR3QyZ1gzSVh5?=
 =?utf-8?B?eDEycEtlZlZwZWxscCsyVHBPdllyQUJRb2hSZ1B0LzR1Y1dlSktBa2JnL2o2?=
 =?utf-8?B?ODNOc0ExejdSOVVZV093eEx2c1JCaDFLeTFnU3BTRHkyV1k5ZWpOTVE1TUV6?=
 =?utf-8?B?MTVUQ1JHZkthRXZvVlpOVCtRemsrVGtPazNnaG5WNVpQTHJucEhFcldBVGVO?=
 =?utf-8?B?MklpdzJlRk44K3hOb2FqWVhRWTY4OXEyOW5jUmNhVm11VkhRdGtWNkFHd1Fk?=
 =?utf-8?B?SUhXZUVhMVZ4Y1BQdW1JWVhXb3V5Z1dBQkFuMXJCcnY1emlWNjgyRC9TNzdp?=
 =?utf-8?B?cVVORWRwK2V4bXdKeXFlM1lhc0FzNzNzYzNkWTV2WnhheENCK2FzcTJSMTNr?=
 =?utf-8?B?WHAvdkJpL1pRenlnTndTa2R6VnJEYjVna0VDRWUySlZ1M0tDcE9xbUdxdGpQ?=
 =?utf-8?B?L2ZMUXR6TG9BY0hGY2ZBTGpsUGlZblNXSzhXUERrS09nTXpyQ0I2WTc5Kzlm?=
 =?utf-8?B?VGpLcGZ3S0xSZGlPbERRcm9pT2YyMFlNMHRuQU91T3lIeTFKUi85eFptcHEz?=
 =?utf-8?B?UllHczk1THZwUmh2ekJja3NKNzhjaFRDOS9QejhhVVBoUys4eUZOWENjMkF5?=
 =?utf-8?B?TkdUTTVGVERzK053cWw4cFNucTB4cDhDL3U5NFIvV0sxS1YvTDc2OFNRclp6?=
 =?utf-8?B?dU4rVDArZDhNblVLTk9QZlpBZmlwNlB6WVBJTi9ZY0krQTRCdVRwYjIvWmhM?=
 =?utf-8?B?bnNOYkxKVjBwSWhHMFVocDlRdlZ3eXREV0dpU2UrUVdTcHdWS05vMnl0RjY0?=
 =?utf-8?B?ZkI1WlMxWTk5WnRQYUllZTlyNExmUkdpS0ZuODA2RUFrRzN5UmoycFlOa3dH?=
 =?utf-8?B?QkdjWkhFbHdtTzF6NUJ6Q244d0xMcWNXdG43L0NyaXB0NzZMdmxETHJzY0lE?=
 =?utf-8?B?a1FBcjkwRm9mRGtIRGdMVWoyeFFjS29VQnJFV0ZjdXZ5cWpablR6cVFPZkRC?=
 =?utf-8?B?TVJLdys5UlFjbEhWWUpxTEkxTVY5VVBsb28xOGtLb2xMR3RtK3hnaWQ4NDJF?=
 =?utf-8?B?dXdiUkpaNnhaWFZ1dHpzSWcxSmY1a1A1V0ZLR2xXZThyT0RvK1BvRGc0R2oz?=
 =?utf-8?B?R1VINWQ0VGdiQy93VzJsS2FnTnl5ZitDMnpPNCszR2xvTFlnclZVZm1OeUd5?=
 =?utf-8?B?QUNDS3dqT2lQK1RncE5OUkFIMXM4RVlJSGptVVIwYlBiVTVOZUdwaGI5R2tT?=
 =?utf-8?B?cHlORTgzNW05MWZwZTZ5NUJLY0VLL2N6bkkrRFJUR3Y5eENSUWNNSGVodnZy?=
 =?utf-8?B?SDUzOHBZbGEza2d6VjY3aDNSMktoZ1JabVBCaUs5RjFUczVpOFRwaVBBRjFQ?=
 =?utf-8?B?d1l5alAwY09RQ2tYZ3JKSkxlcHIvM1ZTR1A2RzY0YWNuR3k5TTBFRWdsTUZ0?=
 =?utf-8?B?WXVjYU4wcGRCTFYyaXYyL2lZcmV0WTd5bmJkQS85U2VpZFhYZWZEd2xMaHNU?=
 =?utf-8?B?bGp4RmxsSE11NURKVjFQOG9YM3pHZU9vV1lPREUwU3lJbEJPRTFMNzdVanFr?=
 =?utf-8?B?OXI5R3JBTndJOG9PWE93YUFReUtqSk5sS0E2Y2VmZWVWKzYveFU4OFk3RnJj?=
 =?utf-8?B?T1ZNWW90bXhpTWd6elE1c3hQVEtrRGp3RXpEa0lCZ2cwRkVpb3pXVENXUjl3?=
 =?utf-8?B?Z0x3SFRMd0VMdkhWZUhUcVhtWTRzUlQvNWhBVmFKOFRXWFlPQk8rTzVmejhK?=
 =?utf-8?B?T3pYUWlnWVQwbFJyZWJKMGFEQ2llL04zR3UxWnBRRThWdmhxU1hiK0c5c1Z3?=
 =?utf-8?B?UXpCcG8vVm84TSt3L2JZSEVjSGxpR0l3aVRpUnBwSmh3UHlKaFZzM1FVS0R3?=
 =?utf-8?B?aVJPWnlDanBTdGZNUlhjYzNVeTFvTHdvYmtBMDkrTzZpU2M1amdpUWdTa2xD?=
 =?utf-8?B?TDRTRjdRdHdZbkRIQmRxenI3ZWxXeThKVHhSbVd5Q2luNkYzeU5HY3BCRENo?=
 =?utf-8?B?MHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a1ce75-8072-4d4a-b84d-08da9b734363
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 01:47:38.0322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OuLmpX79Xgq28GM87yalSDWCYr6C4mkKvAsa4DKbgETGeZnvegDo5rURAielqjDU6EQFgu+UCjtmWyPvlBK/lKmYf+JaN9pFeCfh9aAo7kM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5118
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMCBTZXAgMjAyMiAxOToyNzo0OCArMDEwMCwgRWR3YXJkIENyZWUgd3JvdGU6DQo+
IE9uIDIwLzA5LzIwMjIgMTY6MTQsIFNpbW9uIEhvcm1hbiB3cm90ZToNCj4gPiBGcm9tOiBQZW5n
IFpoYW5nIDxwZW5nLnpoYW5nQGNvcmlnaW5lLmNvbT4NCj4gPg0KPiA+IFZGIG1heC1xdWV1ZS1u
dW1iZXIgaXMgdGhlIE1BWCBudW0gb2YgcXVldWVzIHdoaWNoIHRoZSBWRiBoYXMuDQo+ID4NCj4g
PiBBZGQgbmV3IGRldmljZSBnZW5lcmljIHBhcmFtZXRlciB0byBjb25maWd1cmUgdGhlIG1heC1x
dWV1ZS1udW1iZXINCj4gPiBvZiB0aGUgZWFjaCBWRiB0byBiZSBnZW5lcmF0ZWQgZHluYW1pY2Fs
bHkuDQo+ID4NCj4gPiBUaGUgc3RyaW5nIGZvcm1hdCBpcyBkZWNpZGVkIGFkIHZlbmRvciBzcGVj
aWZpYy4gVGhlIHN1Z2dlc3RlZA0KPiA+IGZvcm1hdCBpcyAuLi4tVi1XLVgtWS1aLCB0aGUgViBy
ZXByZXNlbnRzIGdlbmVyYXRpbmcgViBWRnMgdGhhdA0KPiA+IGhhdmUgMTYgcXVldWVzLCB0aGUg
VyByZXByZXNlbnRzIGdlbmVyYXRpbmcgVyBWRnMgdGhhdCBoYXZlIDgNCj4gPiBxdWV1ZXMsIGFu
ZCBzbyBvbiwgdGhlIFogcmVwcmVzZW50cyBnZW5lcmF0aW5nIFogVkZzIHRoYXQgaGF2ZQ0KPiA+
IDEgcXVldWUuDQo+IA0KPiBJIGRvbid0IGxpa2UgdGhpcy4NCj4gSWYgSSdtIGNvcnJlY3RseSB1
bmRlcnN0YW5kaW5nLCBpdCBoYXJkY29kZXMgYW4gYXNzdW1wdGlvbiB0aGF0DQo+ICBsb3dlci1u
dW1iZXJlZCBWRnMgd2lsbCBiZSB0aGUgb25lcyB3aXRoIG1vcmUgcXVldWVzLCBhbmQgYWxzbw0K
DQpVc3VhbGx5IGFsbCBWRnMgaGF2ZSBzYW1lIG1heC1xLW51bSwgc28gY29uZmlnIGxpa2UgIi4u
Li0wLU4tMC0uLiINCndpbGwgYmUgdGhlIG1vc3QgY2FzZS4gSWYgeW91IHdhbnQgc29tZSBWRnMg
aGF2ZSBtb3JlIHF1ZXVlcw0KdGhhbiB0aGUgb3RoZXJzLCB0aGVuIHllcywgdGhlIGxvd2VyLW51
bWJlcmVkIFZGcyBhbHdheXMgaGF2ZQ0KbW9yZS4gV2UgdGhpbmsgaXQncyBPSywgc2luY2UgdGhl
IHVzZXIgY2FuIGRlY2lkZSB3aGljaCBWRnMgZm9yDQp3aGF0IHVzZS4gSWYgeW91IG5lZWQgVkZz
IHdpdGggZmV3ZXIgcXVldWVzLCB0aGVuIHVzZSB0aG9zZQ0KaGlnaGVyLW51bWJlcmVkIFZGcy4N
CkFuZCB0aGUgZm9ybWF0IGlzIGp1c3QgYSByZWNvbW1lbmRhdGlvbiwgdGhlIHBhcnNlIHByb2Nl
c3MNCmlzIGltcGxlbWVudGVkIGluIE5JQyBkcml2ZXIsIHNvIGl0IGNhbiBiZSB2ZW5kb3Igc3Bl
Y2lmaWMuDQoNCj4gIG1ha2VzIGl0IGRpZmZpY3VsdCB0byBjaGFuZ2UgYSBWRidzIG1heC1xdWV1
ZXMgb24gdGhlIGZseS4NCj4gV2h5IG5vdCBpbnN0ZWFkIGhhdmUgYSBwZXItVkYgb3BlcmF0aW9u
IHRvIHNldCB0aGF0IFZGJ3MgbWF4DQo+ICBxdWV1ZSBjb3VudD8gIElkZWFsbHkgdGhyb3VnaCB0
aGUgVkYgcmVwcmVzZW50b3IsIHBlcmhhcHMgYXMNCj4gIGFuIGV0aHRvb2wgcGFyYW0vdHVuYWJs
ZSwgcmF0aGVyIHRoYW4gZGV2bGluay4gIFRoZW4gdGhlDQo+ICBtZWNoYW5pc20gaXMgZmxleGli
bGUgYW5kIG1ha2VzIG5vIGFzc3VtcHRpb25zIGFib3V0IHBvbGljeS4NCg0KVGhlIGJhY2tncm91
bmQgb2YgdGhpcyBjb25maWd1cmF0aW9uIHByb3Bvc2FsIGlzIHRoYXQgd2UgbmVlZCBhIA0Kd2F5
IHRvIHJlYWxsb2NhdGUgdGhlIHF1ZXVlIHJlc291cmNlIHRoYXQgaXMgc2hhcmVkIGJ5IGFsbCBW
RnMuDQpTbyBpdCBzaG91bGQgYmUgcHJlLWNvbmZpZ3VyZWQgYmVmb3JlIFZGcyBhcmUgY3JlYXRl
ZCwgdGhhdCdzIHdoeQ0KdGhlIGNvbmZpZ3VyYXRpb24gaXMgcGVyLVBGIG9yIHBlci1wY2lkZXYu
IFdlJ3JlIG5vdCBzdXBwb3NlZCB0bw0KY2hhbmdlIHRoZSBtYXgtcS1udW1iZXIgb25jZSB0aGUg
VkYgaXMgY3JlYXRlZC4NCg0KVGhhbmtzLg0KDQo+IA0KPiAtZWQNCg==
