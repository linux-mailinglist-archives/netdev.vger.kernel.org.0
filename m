Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65AE5B8E28
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiINR3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 13:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiINR3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:29:32 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2127.outbound.protection.outlook.com [40.107.114.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B44BD7;
        Wed, 14 Sep 2022 10:29:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZcc1P84TEKDtrFgKEhlC1c3q+Svr9a7/VnrCtiCu6z+leP286aXXk5Cf4barr80QqYfy99+iOG7yj2pMYSsm42DQHOCHPckhM2jp5GuIsKnnmjdeE0RuMq8ztjSRrYt/Dj1o53IIKC6wT/DFhmOkmyibiO4XssPokUuiF/AfJYDOgwituzFV44xJknj9e54+4gCy/IB8ksqmWo+86cDjS81lUyvSUVMQ5hYO2w5kwuPM79ricTSJceg6tAL8TBQ/tN0d0/evtw+PClUsu4y6bsAUP1G1A1STbeeQNDypw302zxQnrQKnTRYJCNIbdKL9EZhwSLiieCH78JLYlnODg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OYwjGnbSYTdCnLHxqBnc/UZesbMrBy8F6mB92LlGyxk=;
 b=W39w20AEgW16G22l9vGzdYjEXEAURsN6HPftg+128+PLxf7kzSiSscr3jG+dqqZCaIeG/Xzg36i4vNxoOPcZlxtK3Xt7Kh7qAoI7WMtmxtJw1UAMi5uz1x7EANOiysYgWK0gZ87dsw5Kb81RV/vTRa5mnTPLxVvJ5DLnYUvnGqVcQ5BRXkeStVso3VVLxjMGNO2qaWXyON6CfDi8EnTLGJVqjbO06zzIUoPyVdJXLzNoU8HSdr7NyvFdMdpa6nlQN5/dK+dTVTeBUod1LjC99GkE4Sh53SZ9ZuGex7ptTB6WZLI/3LqkvRo9uWxeGezGQh8PqCY4KRF/BuyVd4eyhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYwjGnbSYTdCnLHxqBnc/UZesbMrBy8F6mB92LlGyxk=;
 b=rq/H8tsKJM2syqwpdGVTqOFuOPqhsxUam5b9AoQTossW6VqeMRh93U0VEeW0KxVlsa4i56RqmlaQlQ2bfCVUq28SbwPFkvXlWGyD7Lr900nzXf+hjuajGxkG3p4JIJnUvTdLGRvpXP7PFmwP1SusZsOhz1kFpyrW63JJS+hQh5Q=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB10216.jpnprd01.prod.outlook.com (2603:1096:604:1e5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 14 Sep
 2022 17:29:25 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c502:8f9f:ec5e:8e3f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c502:8f9f:ec5e:8e3f%3]) with mapi id 15.20.5632.014; Wed, 14 Sep 2022
 17:29:25 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next v3] ravb: Add RZ/G2L MII interface support
Thread-Topic: [PATCH net-next v3] ravb: Add RZ/G2L MII interface support
Thread-Index: AQHYyAXhcDwFSsslx0u3BQUD3D9PoK3fKQ2AgAAAbaCAAAUjIA==
Date:   Wed, 14 Sep 2022 17:29:25 +0000
Message-ID: <OS0PR01MB5922511C2835648F2D61177E86469@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220914064730.1878211-1-biju.das.jz@bp.renesas.com>
 <631f13b7-9cab-68b7-a0b1-368bb591c4d2@omp.ru>
 <OS0PR01MB592297F89124DD62211582AE86469@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB592297F89124DD62211582AE86469@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS3PR01MB10216:EE_
x-ms-office365-filtering-correlation-id: a1663e07-1acc-4e98-25e2-08da9676ab8f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p5s/W0sXtO23GBaAhtxj1CLBFGnjUKHqbgduD0dl7zztBtVv+qk7DWYN/Cdl6Ad8dMrWBpXy/d7OnK55kSvrVz/rUoxuCZOhjTm5+opoBieQTeWJeqIKXfkXEc1WfhojmqR4qoSJy28owj9p/u/tjy50zdyXd+vZV8eadhhvBF9d1QJviNxioDnXbomkZ2adOrmJaXM1puqad9M33qCmmrWy0M8WNS403Pt2uYEkxfqHlwtIsxQ3g2AGkfXhnE1txYp7pH0iR1mb3QG6sV2eJ8LPLz1MajFp1PPqWYBfu23HFTy1EAArfnWa1l1izitBKpewaOUsUHkRxKlAdfC+JtLZXOLyTDHbAa8yy+FA/8eSsVPCsUhq2TIAmrYkoeU/CU2NV/Uq3Pexd3WuNdzOdUCkXM7KG7aU9HbTVLMSLuONInvRy8n/OHhs/lLbzpGZqClQq1cpKzv02Bk0X+dtldbpvOm9IKSZggL2m5AM1kA8cIQbVqy8KMJNB3p3JEJ5G8SZcj6ZQTmEKjlLtQRaND2lPY8TdZFclSl1MXYOyZbsXHMR6/1K7SNeacqUghmKk1DwGfr8xTieGrX/rBFIrcg9pcRbCMW9N2yjVsESl5grBLrOvhQfW8n9jv+9V61bo8GFXRsOFQLxSgQKoT68LOS2iP0lAByKCljc9lJ9wSlA+ybfGwUlrbvjoW2c4AhIV1D6o9zcnkJN1PcAa+4KPni9Q0HSbqC1oQCJ6sINOIwGDohdW7g/rcBsW+xe6DLED2sp8W/hBlw0vas/tx2gog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199015)(53546011)(66946007)(55016003)(316002)(64756008)(76116006)(107886003)(2906002)(8676002)(66446008)(110136005)(2940100002)(38070700005)(186003)(7696005)(9686003)(83380400001)(26005)(478600001)(86362001)(33656002)(54906003)(38100700002)(41300700001)(71200400001)(6506007)(66476007)(66556008)(5660300002)(4326008)(52536014)(122000001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnVCV2tBL1ZVdUEyakZzdUFGSHZlNTNSdUlXOXBKcmREL1plckYxQjJpeTNh?=
 =?utf-8?B?MVpZcXhiZWtsMXcyWHFoWVVEQm1EMGdUVFVCKy9XY2RVZGJudVNSeHNGY2tj?=
 =?utf-8?B?ZXNTWnhucmV6WkJyNWNPRWpkRnZDbDJnZXE3T1Z2YWJlTkNQNzRlT3A4RXd1?=
 =?utf-8?B?cERqaU5zcE1jNWl1aEQ5R1FEZGtjQzJzYU4xYmZoR0RrMm5VWGt2T2twN3Nv?=
 =?utf-8?B?YUFEdG13akdQT1J0NzJodTZvR3FDbnVsUmdjYmJmRGd6anNrVlk3RUdjbHBr?=
 =?utf-8?B?eXI1a09jWjBVUVk4L0FQeVNEUUtVcnhRS1J2MnZGcnhHVFY2ZzcvMEVNYWlP?=
 =?utf-8?B?Q1IyMkMwcEEyczdyME9BQnVQZWQ2N0UvTklBbWtmT2gwcG45cVFkSEpTTnBu?=
 =?utf-8?B?VVY1VXhURG9BSDV1UHFwbkg4RmloMS9SQ1p3VFJLalBuRG1LdFVjaTF2aVJW?=
 =?utf-8?B?YmRoL1ltaDdPdE1ydVdxVnJaSVZ6NUc1LzFFM3JsSWt3dVVTcXZDWlNLL3px?=
 =?utf-8?B?QXgrNG80NTVicFc4ZWJkd2F4YTFmSkFwd2NQcExkdnlYbUhYb2IzbStvUjFE?=
 =?utf-8?B?VlhVazgxcGdyVVMrK3M4Y1RwZTR4a1VWaktxM1ZWaXFESnV2SzI2azBPKzhU?=
 =?utf-8?B?TEY5NnhTMjJrQ3JDbVYyYXN1emJHajlWL1Rxakw5aERrWC9oTEU5QmlQRzg1?=
 =?utf-8?B?aGFQSEhhREYveEp4QVNmVVYrMElKL3o0RUhRNlBXdzc0dlFZeEZnZUFZdFhI?=
 =?utf-8?B?cndXbnA1U3dvNlMvSUtackZ1Nk52UWJaRjM2V2xBMnR5d1RBem1ka2Fqb3VK?=
 =?utf-8?B?UGNrS1diSVN2RFV0VG1ZaUdTQkt2MFh0My91cTUreVh2a2VQU2piR0hwTjM1?=
 =?utf-8?B?NTFZOE5Xa3RDQkxnQkVhVk16K1hyM0llNHRXN3FOSEQ1QzBqaHMvSDl1SGVZ?=
 =?utf-8?B?R0RodEQvM2doWUg2RzRPWm0zUVZkK042SVVxcStLRzZvRmxhSVRVR2VDaUV1?=
 =?utf-8?B?d2hDS2FlYUNCVTVqUGU1anZNazJZWjZydjVPZ3ByaVRtS3lLOE5BbkZjZ0hp?=
 =?utf-8?B?dkxtaVlEUjh2Qjh4ZFp3MTRjVnBYdWhtNFcrVHFvaEZvUnEvU0VIV1hZMFhP?=
 =?utf-8?B?VGRUanBBTGhWVzluUHRTdHg5S2ZQcUcxaUszZVhNK2RKTElBT3llczB4SVQ5?=
 =?utf-8?B?UGFjYlN2QkVDRDZIZEc3cGw1ejBEUytUZGdBWHU4Z3NNNFREc3UwbTA0a3JZ?=
 =?utf-8?B?WFdLVlZlUHdIZEtqem1YWXBFRkhqeVNXYk5YTXJiTnVPV0NTNi96aUZLOEZQ?=
 =?utf-8?B?UmZuV29waTVaUDVwUXIxN05pNVJQQzZZNUhaSGM1R2ZLVCtRMCt5ZTVDS0ls?=
 =?utf-8?B?WWlBbzlTeWdLbXdrS1RJZ1REUFk4WHJaVlgwT1gwUmd4R2w0aDNGUUJMMmI1?=
 =?utf-8?B?b0RybkIyVktaOUVVSHhYaVB4dGxTVkZ2bTRMd0VCUDNCaE5Sam5nV1dJME1n?=
 =?utf-8?B?bjE1ZkF5VFpzMnEzNit6UnRrYklWc0ZYQW4rd1hrZk5qYi9IMUxtamRaWTBW?=
 =?utf-8?B?cUg1MC9lWUJuc21jQ3BZb3UrVEtxaGJ3WnhXMkdra0V2eW5DQ0FEdnRJTFZE?=
 =?utf-8?B?Yis5ajJXWlpnS1l1MlF4TjJqTUZWREw3K1B6VFJKVmZ4di9Qcjd5dVlDVndM?=
 =?utf-8?B?aGxHd3liSnVhdzgwNXVsYW5VWU9UZS9PWnJZeUw5TUZxMElGRzUzYzN3TU9l?=
 =?utf-8?B?UWt4VWJtdUpUczNmTTRuNjhWWWc1WW9mTVBRYlN5V3d1TThGSWdocUMzZi9j?=
 =?utf-8?B?Mm0xaWF4YWZUYkgxd2JVTWdjaGJibE9MRGtXcFNRaUZISDNwU3ZCeFNQNTVK?=
 =?utf-8?B?dDR2dUQzSmJaQ2Y3UTVDdFdrSDBIQzBMTFo0V1RBYjBqRnZPdkprZmthWU4r?=
 =?utf-8?B?Q09EUmVXVnZaYlRMY0l1Ulk4eHFhTHUrRk9MUC9IYjJsbXVtTFZYNkZhcFFL?=
 =?utf-8?B?ZjVROHl4U3JOMVFQTlByVXZqZG9sSDA4MVVhT2ZKbVQwNnZEWmJhbndjMy8w?=
 =?utf-8?B?NFQwdDQ4SEFsa3RZTW1tVTF1KytJckV4d3Q3VEdVVXFrbktzN3lQSU1GdUpr?=
 =?utf-8?B?dTdPb0hpRUNEUU4wQkhiekRjcnl6UUJvaWtIZXhMazV6QWhRODdpN3hVOHla?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1663e07-1acc-4e98-25e2-08da9676ab8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 17:29:25.4626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 705HyFgau6wSbraX7lzURMkGqxc+R+GEvjWyWomRaJ8FlEcFpsM/Hn/V8XA398rYaeWVd/V4XjAuRy27wC5X8LIfwi193HhYWV1tXsnMkRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB10216
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggbmV0LW5leHQgdjNdIHJhdmI6IEFk
ZCBSWi9HMkwgTUlJIGludGVyZmFjZSBzdXBwb3J0DQo+IA0KPiBIaSBTZXJnZXksDQo+IA0KPiBU
aGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCj4gDQo+ID4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQt
bmV4dCB2M10gcmF2YjogQWRkIFJaL0cyTCBNSUkgaW50ZXJmYWNlDQo+ID4gc3VwcG9ydA0KPiA+
DQo+ID4gT24gOS8xNC8yMiA5OjQ3IEFNLCBCaWp1IERhcyB3cm90ZToNCj4gPg0KPiA+ID4gRU1B
QyBJUCBmb3VuZCBvbiBSWi9HMkwgR2IgZXRoZXJuZXQgc3VwcG9ydHMgTUlJIGludGVyZmFjZS4N
Cj4gPiA+IFRoaXMgcGF0Y2ggYWRkcyBzdXBwb3J0IGZvciBzZWxlY3RpbmcgTUlJIGludGVyZmFj
ZSBtb2RlLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5q
ekBicC5yZW5lc2FzLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gdjItPnYzOg0KPiA+ID4gICogRG9j
dW1lbnRlZCBDWFIzNV9IQUxGQ1lDX0NMS1NXMTAwMCBhbmQgQ1hSMzVfU0VMX1hNSUlfTUlJIG1h
Y3Jvcy4NCj4gPg0KPiA+ICAgIEkgZGVmaW5pdGVseSBkaWRuJ3QgbWVhbiBpdCBkb25lIHRoaXMg
d2F5Li4uDQo+ID4NCj4gPiBbLi4uXQ0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yi5oDQo+ID4gPiBpbmRleCBiOTgwYmNlNzYzZDMuLjA1OGFjZWFjOGM5MiAxMDA2NDQN
Cj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gPiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IFsuLi5dDQo+ID4g
PiBAQCAtOTY1LDYgKzk2NiwxMSBAQCBlbnVtIENYUjMxX0JJVCB7DQo+ID4gPiAgCUNYUjMxX1NF
TF9MSU5LMQk9IDB4MDAwMDAwMDgsDQo+ID4gPiAgfTsNCj4gPiA+DQo+ID4gPiArZW51bSBDWFIz
NV9CSVQgew0KPiA+ID4gKwlDWFIzNV9IQUxGQ1lDX0NMS1NXMTAwMAk9IDB4MDNFODAwMDAsCS8q
IDEwMDAgY3ljbGUgb2YgY2xrX2NoaQ0KPiA+ICovDQo+ID4NCj4gPiAgICBObywgcGxlYXNlIGp1
c3QgZGVjbGFyZToNCj4gDQo+IA0KPiA+DQo+ID4gCUNYUjM1X0hBTEZDWUNfQ0xLU1cJPSAweGZm
ZmYwMDAwLA0KPiANCj4gUTEpIFdoeSBkbyB5b3UgdGhpbmsgd2Ugc2hvdWxkIHVzZSB0aGlzIHZh
bHVlIGZvciBzZXR0aW5nIE1JST8NCj4gDQo+IEFzIHBlciBoYXJkd2FyZSBtYW51YWwgdGhlIHZh
bHVlIHlvdSBzdWdnZXN0ZWQgaXMgd3JvbmcgZm9yIE1JSSBzZXR0aW5ncy4NCj4gU2VlIHBhZ2Ug
MjE1Nw0KPiANCj4gW0FdIFRoZSBjYXNlIHdoaWNoIENYUjM1IFNFTF9YTUlJIGlzIHVzZWQgZm9y
IHRoZSBzZWxlY3Rpb24gb2YgUkdNSUkvTUlJDQo+IGluIEFQQiBDbG9jayAxMDAgTUh6Lg0KPiAN
Cj4gKDEpIFRvIHVzZSBSR01JSSBpbnRlcmZhY2UsIFNldCDigJhI4oCZMDNFOCAwMDAw4oCZIHRv
IHRoaXMgcmVnaXN0ZXIuDQo+ICgyKSBUbyB1c2UgTUlJIGludGVyZmFjZSwgU2V0IOKAmEjigJkw
M0U4IDAwMDLigJkgdG8gdGhpcyByZWdpc3Rlci4NCj4gDQo+ID4NCj4gPiA+ICsJQ1hSMzVfU0VM
X1hNSUlfTUlJCT0gMHgwMDAwMDAwMiwJLyogTUlJIGludGVyZmFjZSBpcyB1c2VkDQo+ID4gKi8N
Cj4gPg0KPiA+ICAgIEFsbCB0aGUgb3RoZXIgcmVnaXN0ZXIgKmVudW0qcyBhcmUgZGVjbGFyZWQg
ZnJvbSBMU0IgdG8gTVNCLiBUaGUNCj4gPiBjb21tZW50IGlzIHByZXR0eSBzZWxmLW9idmlvdXMg
aGVyZSwgcGxlYXNlIHJlbW92ZSBpdC4gQW5kIGRlY2xhcmUgdGhlDQo+ID4gd2hvbGUgZmllbGQg
dG9vOg0KPiA+DQo+ID4gCUNYUjM1X1NFTF9YTUlJCQk9IDB4MDAwMDAwMDMsDQo+IA0KPiBWYWx1
ZXMgMSBhbmQgMyBhcmUgcmVzZXJ2ZWQgc28gd2UgY2Fubm90IHVzZSAzLg0KPiANCj4gSSB0aGlu
ayB0aGUgY3VycmVudCBwYXRjaCBob2xkcyBnb29kIGFzIHBlciB0aGUgaGFyZHdhcmUgbWFudWFs
IGZvcg0KPiBzZWxlY3RpbmcgTUlJIGludGVyZmFjZS4gUGxlYXNlIHJlY2hlY2sgYW5kIGNvcnJl
Y3QgbWUgaWYgaXQgaXMgd3JvbmcuDQo+IA0KPiBDaGVlcnMsDQo+IEJpanUNCj4gDQo+ID4gCUNY
UjM1X1NFTF9YTUlJX1JHTUlJCT0gMHgwMDAwMDAwMCwNCj4gPiAJQ1hSMzVfU0VMX1hNSUlfTUlJ
CT0gMHgwMDAwMDAwMiwNCj4gPg0KPiA+IFsuLi5dDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ID4gYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gPiBpbmRleCBiMzU3YWM0YzU2YzUuLjlh
MGQwNmRkNWViNiAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yl9tYWluLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yl9tYWluLmMNCj4gPiA+IEBAIC01NDAsNyArNTQwLDE0IEBAIHN0YXRpYyB2b2lkIHJhdmJf
ZW1hY19pbml0X2diZXRoKHN0cnVjdA0KPiA+ID4gbmV0X2RldmljZQ0KPiA+ICpuZGV2KQ0KPiA+
ID4gIAkvKiBFLU1BQyBpbnRlcnJ1cHQgZW5hYmxlIHJlZ2lzdGVyICovDQo+ID4gPiAgCXJhdmJf
d3JpdGUobmRldiwgRUNTSVBSX0lDRElQLCBFQ1NJUFIpOw0KPiA+ID4NCj4gPiA+IC0JcmF2Yl9t
b2RpZnkobmRldiwgQ1hSMzEsIENYUjMxX1NFTF9MSU5LMCB8IENYUjMxX1NFTF9MSU5LMSwNCj4g
PiBDWFIzMV9TRUxfTElOSzApOw0KPiA+ID4gKwlpZiAocHJpdi0+cGh5X2ludGVyZmFjZSA9PSBQ
SFlfSU5URVJGQUNFX01PREVfTUlJKSB7DQo+ID4gPiArCQlyYXZiX21vZGlmeShuZGV2LCBDWFIz
MSwgQ1hSMzFfU0VMX0xJTkswIHwgQ1hSMzFfU0VMX0xJTksxLA0KPiA+IDApOw0KPiA+ID4gKwkJ
cmF2Yl93cml0ZShuZGV2LCBDWFIzNV9IQUxGQ1lDX0NMS1NXMTAwMCB8IENYUjM1X1NFTF9YTUlJ
X01JSSwNCj4gPiA+ICsJCQkgICBDWFIzNSk7DQo+ID4NCj4gPiAJCXJhdmJfd3JpdGUobmRldiwg
KDEwMDAgPDwgMTYpIHwgQ1hSMzVfU0VMX1hNSUlfTUlJLCBDWFIzNSk7DQoNCk9vcHMuIE1pc3Nl
ZCB0aGlzIG1hZ2ljIG51bWJlciBjaGFuZ2VzLiBXaWxsIHNlbmQgdjQgd2l0aCBhYm92ZSBzdWdn
ZXN0aW9ucy4NCg0KQ2hlZXJzLA0KQmlqdQ0K
