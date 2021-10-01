Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD29341E7CB
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 08:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352355AbhJAGzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 02:55:22 -0400
Received: from mail-eopbgr1400097.outbound.protection.outlook.com ([40.107.140.97]:20500
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231134AbhJAGzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 02:55:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmpCDkoRtQ8LC+3A9QZJFm9F389k8dxdKio5znxu0Fkdr8/4u0/wlIlqCDRrEUP303Ptkkd3K/kx1u7pwU7AdOk6ctlztQRYwuSp5UXgF1X6uq/XEQ9P9rEAwP1POgjUT9X0u1PTwC7jo4o1k+d+glzlNCUJkLKCyqSdwA2QLf5BZjuMgfvF/YLpcj7nyJvgi7csnNQfzmXryiVMTyHaVMTOAEXVRkrtxrZ+NmHzv+T4+TgM7pIcQ2di9ZLPPGHhqaIEk7aJBZVjoTNgM9x9NqzBxhRVhrmD/4BuVY5JbO7J9UjIv0ARNZzyAO8EEdIPukfnsHZqTIYzVBrCx1cGdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aAOkJ/YR3by9+PyDKpp9s3QtT+YrvZvtBwitrd8wtM0=;
 b=LsypK7b7kmmS291cSLD9c7K/YQYRAToyAmTn50dTCCgM3r+PpQSrW3SEUQeQbC3TmT5DhWyP+38rBlyuz2CPOijHnROEs7eWG0cclDnqWu3uWsZ0YKB32uHn4yNSz4L4t3Wu67KKJt3Yt6E62fnsx0L2jm6y0s+91b4tHtHBTk86HSVmUuqy2tv0mEHdzSmJLpWYsDzQnSBJ+JHZXoEoSmWy0e0kznuHgG/fyapfk+bVUpi9L6g3xoU/U3XUQuXr1nkqhufHegvItnWC449ev4vZFZnobcWXtbbD1gkZS4cilH3GlSrE3yilb4Ck2t2dHYkTNhzAbRpl7Dt/zEfKNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAOkJ/YR3by9+PyDKpp9s3QtT+YrvZvtBwitrd8wtM0=;
 b=Bw+XZwl6pykpSvntiS7AmfROU3BlhK/iK1EtnaQqEa0cuO55t4uXbbpT9zb6AOKcZcvNkjmv3xcRa+xVwLCsULqzblocQqEx3uZOJfduK3vZBTTpQUqRsdFcLuvvytwA82NNpZNS2L1JTNo8SYf9KQ5C/o2FUjogIOYEjrB5ZY4=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB4451.jpnprd01.prod.outlook.com (2603:1096:604:37::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Fri, 1 Oct
 2021 06:53:28 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.015; Fri, 1 Oct 2021
 06:53:28 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 18/18] ravb: Add set_feature support for RZ/G2L
Thread-Topic: [RFC/PATCH 18/18] ravb: Add set_feature support for RZ/G2L
Thread-Index: AQHXsISbPS3JiQSpSkuqkXJbL6JsEau9FXsAgACdUCA=
Date:   Fri, 1 Oct 2021 06:53:27 +0000
Message-ID: <OS0PR01MB59221BB67442BD5CA5898D9E86AB9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-19-biju.das.jz@bp.renesas.com>
 <b19b7b83-7b0b-2c48-afc2-6fbf36a5ad98@omp.ru>
In-Reply-To: <b19b7b83-7b0b-2c48-afc2-6fbf36a5ad98@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 602dcecc-5f99-4763-38bb-08d984a82c31
x-ms-traffictypediagnostic: OSAPR01MB4451:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB4451EFD5196D7FF6F64BD68F86AB9@OSAPR01MB4451.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OuX/dYLAG9GswCglm4LwCt1iSclPTPzmB3ws+wMIh4Hf5CD8TlIy8ybm4lNTJEZ8hnfuWMPNhwlj3PnHEjp8S49lDFAnP+8bPyTc8dRshvXuZ96we+YK7CQ4Y/dCvOqqcdh6FaQuX0rOLimeG88P+nQKO3zTwlPVoDNPSaoT2hf/YckUkG0UKpnOtmfTb6WQ59JFsKPvz6aPIN+sCvYaztsDgu2J6tzebC2nguhSK+KPJSgZiFKrbUM7gHY3iS1WVjB2+9qOnpQhDKdHQdb+t/mFrCcrN4KtQuxefqBaTpwOGiRNQYOdVl5vMRNlWlJMPO+6nDPz4SOPmkHpmrlMVxahZLiXS70+wzOpxJvf6/LB3c73ddHjdIS4W18kbsgiUWgvMrPNvXcYog/Kaydda6ov4OIgQrOxWlNgh8dUzJLBKFax27zoOyCW6VnGTuJOrsQppkdVjEzF795tvkf8JqoA4zCtyKIY51tfmtpCxLUo399dA3YyUPv8e5c5OknTM5Z5uC1t1y8BKmKcxfnKQK7EqgW2E0X/skOLJtzQNPH1/J/6wEchWM8k/+Z233jFoLBxYl8bDBl0MBvj5JhWkvNaO0H9kK6dRulMo7KdPjeJRH2X4COppypxnTI6FutGvR/KgLbbox954OwklJm7VxQFKMhpJhrpUygW8H2+xYhPLL5CxTGINN+VEdr3oc5NjI/0F0p2SqDHaGVfgk7ELA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(33656002)(7696005)(107886003)(4326008)(52536014)(83380400001)(53546011)(186003)(26005)(86362001)(38070700005)(122000001)(55016002)(38100700002)(8676002)(316002)(9686003)(508600001)(71200400001)(2906002)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(8936002)(110136005)(5660300002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2h1dkZ5ZGpnbnpvOWhXMXFldjBTbitWOFZPMjVOWHlwTHNDcm5tZ3VwanZh?=
 =?utf-8?B?ZmN2N0VHVUFtZGxDMUM2MmMrOUhQTzd1bVVvT3NjWUF0a08wQ1IxbEN3VTFu?=
 =?utf-8?B?Ung1UzN5clVBODBJVy9JYWNCdUxnZkpISDYyYkVqalpoUlJ4YmJiNlN6QjBH?=
 =?utf-8?B?dURlK0NQaFRuWm5TM0R3eExtTmw2b1N5MUNqSlR1ODJDSks5UGRNOFVJczNQ?=
 =?utf-8?B?Sy9ybzBVVnVrMXQ1blN6TSsySUZYUVZoaTBZeDh6SitOdmpmdG5nbkZiSFk0?=
 =?utf-8?B?MEpQN3RpazZUYmhUNlA1TEpINytZTkdwNDBBNWhUUWFjODNqZkVreVNQa2lj?=
 =?utf-8?B?VjRVVXU5eHc5ZEtkYkk3REJzRzNJNi83SU94ZG8xVFdsa1RmZlgwdkVSV3Yv?=
 =?utf-8?B?Qm05eEpPSEFKMkVwWjZaV1J4Z0ZEZ1plT3BTNHc4cFo2SmtIME9zR1Q3R1lJ?=
 =?utf-8?B?WlNYbjM0QmRRUDJ2emRaMkNqMXZEQkR3V1JkWEo5aElzalJhVmpDY0RRdS9I?=
 =?utf-8?B?akxMZEVPV3hFTitRcTFtYmowUndKQVYxaTFlTkJCaW9KSUk3NXNiVXhFTU5T?=
 =?utf-8?B?WGxJWFUwaXVnSFEwUCtJczNZa2tUdnFlRlRmNVFOV2ZTK1BkQkxGTURiR1lt?=
 =?utf-8?B?OHpuckhjY2NhK1hwUWl0ZFBQSXRFU2FtZmR1R3VXZDJMbkJhQXVlNEswNGdO?=
 =?utf-8?B?VGlsRFpzTzUwcER4ckNsdHd5Z2FSWTVBZFJrYVRnWG5iYkJiampqcFpabmFw?=
 =?utf-8?B?bnVMZENCRm00MzM0RW5yUG1CKzRhWURGTEk4Y25HV2pDVU1lNkoxQlZuUTJs?=
 =?utf-8?B?MzFSNjFYa1J4dmcrVWlFakk2MDdYSFJ6YjAyQ0l3M1RRWEV1WU5CY002Z1ZM?=
 =?utf-8?B?RURhZjNBdmNLajJHSEo0dnJaWlRwZXVXL3l0NlY1VmRrWCt2TUNMZUMySzZq?=
 =?utf-8?B?dTNuejJ5RHhiaEl2Tkw0OTNGcEVrMjlDMmtpNy80QjdCdjl5dzh5NVZpK2cy?=
 =?utf-8?B?cy9ZWGFOcDN4cUxGTDFYbTdsSzlCU2JPellzeDRXVHhIa0owNHIrbVQ5a2Nh?=
 =?utf-8?B?SURCeDdRbkxCQy9lQ0hJb3BvcWhHZjZ2MFRNZXlVSnVhZWVCVnVPWEtjemJz?=
 =?utf-8?B?cnBRSkpmQUZmYkp1WDBtVGgvRytLNGpOeVNXblR1SlNFWVNiYW5weUNGdWdk?=
 =?utf-8?B?dDhjWUJBUFNKeUJmNG50Y3QvQXdIbUQwUWlZQVN2TGExT1pyWlltY1gydjhZ?=
 =?utf-8?B?VU4zWXhlRUdsVWY2NytBd1BicWVJM3UyUzZaUC80Y2NYQll5L2Ivbk5WaGpv?=
 =?utf-8?B?aTBrckJLdTNiMnRpT3NMeWZNaFFIMXY4Y2luOWk4NHdtVHQ0VzBhYnBNY2hk?=
 =?utf-8?B?Y3k4MDloZzJKVGROWUtwU2hYRkVqaHZXZjFydHJWLytaWDFnWXliZ3M1ZEdu?=
 =?utf-8?B?WFlJZ3cwSWgxMnpaTVRRVzJsazJ4UzFINjNzaVk3anhoZE9wa2NtUTY1eHpi?=
 =?utf-8?B?N0tEcFkycTdTUkZlRXRxeTllTTVhSnFvK3gzUSsvQjlhcUhhbFlFbmNVZHNE?=
 =?utf-8?B?MTVNOU1vU21tVEFpOE05NzV0NVJaNDcrcENIRlJTYStqelBBaFRoMlNzazYx?=
 =?utf-8?B?WWQ5NkJwSUNKVzZQckJjZWlmZVphTGRvK3lmYmJneGprRi9scm9RdmxsSllL?=
 =?utf-8?B?MDlXd2l2K0Q1UHlxcUpJUVVYRVpiZ2laemJrWTFaZkFxaHBtbURNMXBtc0tN?=
 =?utf-8?Q?e5xR/DssmJPc8pScZI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 602dcecc-5f99-4763-38bb-08d984a82c31
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2021 06:53:27.7982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QqwCg4xDNfw9KlC7aoHokuxF1H3p51EWFDSVSwxnadjhMti8bK2DK0LBCf8e2keGTxQLtxIGqP0z93nV9o8+hmum97RtGkbikWrNglOaI2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4451
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1JGQy9QQVRDSCAxOC8xOF0gcmF2YjogQWRkIHNldF9mZWF0dXJlIHN1cHBvcnQgZm9yIFJaL0cy
TA0KPiANCj4gT24gOS8yMy8yMSA1OjA4IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4gVGhp
cyBwYXRjaCBhZGRzIHNldF9mZWF0dXJlIHN1cHBvcnQgZm9yIFJaL0cyTC4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiAt
LS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmggICAgICB8IDMyICsr
KysrKysrKysrKysrDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMgfCA1Ng0KPiA+ICsrKysrKysrKysrKysrKysrKysrKysrLQ0KPiA+ICAyIGZpbGVzIGNoYW5n
ZWQsIDg3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBpbmRleCBkNDJlOGVhOTgxZGYuLjIyNzVmMjdj
MDY3MiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIu
aA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gQEAg
LTIwOSw2ICsyMDksOCBAQCBlbnVtIHJhdmJfcmVnIHsNCj4gPiAgCUNYUjU2CT0gMHgwNzcwLAkv
KiBEb2N1bWVudGVkIGZvciBSWi9HMkwgb25seSAqLw0KPiA+ICAJTUFGQ1IJPSAweDA3NzgsDQo+
ID4gIAlDU1IwICAgICA9IDB4MDgwMCwJLyogRG9jdW1lbnRlZCBmb3IgUlovRzJMIG9ubHkgKi8N
Cj4gPiArCUNTUjEgICAgID0gMHgwODA0LAkvKiBEb2N1bWVudGVkIGZvciBSWi9HMkwgb25seSAq
Lw0KPiA+ICsJQ1NSMiAgICAgPSAweDA4MDgsCS8qIERvY3VtZW50ZWQgZm9yIFJaL0cyTCBvbmx5
ICovDQo+IA0KPiAgICBUaGVzZSBhcmUgdGhlIFRPRSByZWdzIChDU1IwIGluY2x1ZGVkKSwgdGhl
eSBvbmx5IGV4aXN0IG9uIFJaL0cyTCwgbm8/DQoNClNlZSBqdXN0IG9uZSBsaW5lIGFib3ZlIHlv
dSBjYW4gc2VlIENTUjAgcmVnaXN0ZXJzIGFuZCBjb21tZW50cyBvbiB0aGUgcmlnaHQgY2xlYXJs
eQ0KbWVudGlvbnMgIi8qIERvY3VtZW50ZWQgZm9yIFJaL0cyTCBvbmx5ICovDQoNCk9LIHdpbGwg
ZG8gQ1NSMCBpbml0aWFsaXNhdGlvbiBhcyBwYXJ0IG9mIHRoaXMgcGF0Y2ggaW5zdGVhZCBvZiBw
YXRjaCAjMTAuDQoNCg0KPiBbLi4uXQ0KPiA+IEBAIC05NzgsNiArOTgwLDM2IEBAIGVudW0gQ1NS
MF9CSVQgew0KPiA+ICAJQ1NSMF9SUEUJPSAweDAwMDAwMDIwLA0KPiA+ICB9Ow0KPiA+DQo+IA0K
PiAgICAqZW51bSogQ1NSMF9CSVQgc2hvdWxkIGJlIGhlcmUgKGFzIHdlIGNvbmNsdWRlZCkuDQoN
Ckl0IGlzIGFscmVhZHkgdGhlcmUuIFNlZSBhYm92ZS4NCkFzIGRpc2N1c3NlZCBhYm92ZSBpdCB3
aWxsIGJlIG1vdmVkIGZyb20gcGF0Y2ggIzEwIHRvIGhlcmUuDQoNCj4gDQo+ID4gK2VudW0gQ1NS
MV9CSVQgew0KPiBbLi4uXQ0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jh
dmJfbWFpbi5jDQo+ID4gaW5kZXggNzJhZWE1ODc1YmM1Li42NDFhZTU1NTNiNjQgMTAwNjQ0DQo+
ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gWy4uLl0NCj4g
PiBAQCAtMjI5MCw3ICsyMzA4LDM4IEBAIHN0YXRpYyB2b2lkIHJhdmJfc2V0X3J4X2NzdW0oc3Ry
dWN0IG5ldF9kZXZpY2UNCj4gPiAqbmRldiwgYm9vbCBlbmFibGUpICBzdGF0aWMgaW50IHJhdmJf
c2V0X2ZlYXR1cmVzX3JnZXRoKHN0cnVjdA0KPiBuZXRfZGV2aWNlICpuZGV2LA0KPiA+ICAJCQkJ
ICAgbmV0ZGV2X2ZlYXR1cmVzX3QgZmVhdHVyZXMpDQo+ID4gIHsNCj4gPiAtCS8qIFBsYWNlIGhv
bGRlciAqLw0KPiA+ICsJbmV0ZGV2X2ZlYXR1cmVzX3QgY2hhbmdlZCA9IGZlYXR1cmVzIF4gbmRl
di0+ZmVhdHVyZXM7DQo+ID4gKwl1bnNpZ25lZCBpbnQgcmVnOw0KPiANCj4gICAgdTMyIHJlZzsN
Cj4gDQo+ID4gKwlpbnQgZXJyb3I7DQo+ID4gKw0KPiA+ICsJcmVnID0gcmF2Yl9yZWFkKG5kZXYs
IENTUjApOw0KPiANCj4gICAgLi4uIGFzIHRoaXMgZnVuY3Rpb24gcmV0dXJucyB1MzIuDQo+IA0K
PiA+ICsNCj4gPiArCXJhdmJfd3JpdGUobmRldiwgcmVnICYgfihDU1IwX1JQRSB8IENTUjBfVFBF
KSwgQ1NSMCk7DQo+ID4gKwllcnJvciA9IHJhdmJfd2FpdChuZGV2LCBDU1IwLCBDU1IwX1JQRSB8
IENTUjBfVFBFLCAwKTsNCj4gPiArCWlmIChlcnJvcikgew0KPiA+ICsJCXJhdmJfd3JpdGUobmRl
diwgcmVnLCBDU1IwKTsNCj4gPiArCQlyZXR1cm4gZXJyb3I7DQo+ID4gKwl9DQo+ID4gKw0KPiA+
ICsJaWYgKGNoYW5nZWQgJiBORVRJRl9GX1JYQ1NVTSkgew0KPiA+ICsJCWlmIChmZWF0dXJlcyAm
IE5FVElGX0ZfUlhDU1VNKQ0KPiA+ICsJCQlyYXZiX3dyaXRlKG5kZXYsIENTUjJfQUxMLCBDU1Iy
KTsNCj4gPiArCQllbHNlDQo+ID4gKwkJCXJhdmJfd3JpdGUobmRldiwgMCwgQ1NSMik7DQo+ID4g
Kwl9DQo+ID4gKw0KPiA+ICsJaWYgKGNoYW5nZWQgJiBORVRJRl9GX0hXX0NTVU0pIHsNCj4gPiAr
CQlpZiAoZmVhdHVyZXMgJiBORVRJRl9GX0hXX0NTVU0pIHsNCj4gPiArCQkJcmF2Yl93cml0ZShu
ZGV2LCBDU1IxX0FMTCwgQ1NSMSk7DQo+ID4gKwkJCW5kZXYtPmZlYXR1cmVzIHw9IE5FVElGX0Zf
Q1NVTV9NQVNLOw0KPiANCj4gICAgSG0sIEkgZG9uJ3QgdW5kZXJzdGFuZCB0aGlzLi4uIGl0IHdv
dWxkIGJlIG5pY2UgaWYgc29tZW9uZQ0KPiBrbm93bGVkZ2VhYmxlIGFib3V0IHRoZSBvZmZsb2Fk
cyB3b3VsZCBsb29rIGF0IHRoaXMuLi4gQWx0aG91Z2gsIHdpdGhvdXQNCj4gdGhlIHJlZ2lzdGVy
IGRvY3VtZW50YXRpb24gaXQncyBwb3NzaWJseSB2YWluLi4uDQo+IA0KPiA+ICsJCX0gZWxzZSB7
DQo+ID4gKwkJCXJhdmJfd3JpdGUobmRldiwgMCwgQ1NSMSk7DQo+ID4gKwkJfQ0KPiA+ICsJfQ0K
PiA+ICsJcmF2Yl93cml0ZShuZGV2LCByZWcsIENTUjApOw0KPiA+ICsNCj4gPiArCW5kZXYtPmZl
YXR1cmVzID0gZmVhdHVyZXM7DQo+ID4gKw0KPiA+ICAJcmV0dXJuIDA7DQo+ID4gIH0NCj4gPg0K
PiA+IEBAIC0yNDMyLDYgKzI0ODEsMTEgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCByYXZiX2h3X2lu
Zm8gcmdldGhfaHdfaW5mbyA9DQo+IHsNCj4gPiAgCS5zZXRfZmVhdHVyZSA9IHJhdmJfc2V0X2Zl
YXR1cmVzX3JnZXRoLA0KPiA+ICAJLmRtYWNfaW5pdCA9IHJhdmJfZG1hY19pbml0X3JnZXRoLA0K
PiA+ICAJLmVtYWNfaW5pdCA9IHJhdmJfZW1hY19pbml0X3JnZXRoLA0KPiA+ICsJLm5ldF9od19m
ZWF0dXJlcyA9IChORVRJRl9GX0hXX0NTVU0gfCBORVRJRl9GX1JYQ1NVTSksDQo+ID4gKwkuZ3N0
cmluZ3Nfc3RhdHMgPSByYXZiX2dzdHJpbmdzX3N0YXRzX3JnZXRoLA0KPiA+ICsJLmdzdHJpbmdz
X3NpemUgPSBzaXplb2YocmF2Yl9nc3RyaW5nc19zdGF0c19yZ2V0aCksDQo+ID4gKwkuc3RhdHNf
bGVuID0gQVJSQVlfU0laRShyYXZiX2dzdHJpbmdzX3N0YXRzX3JnZXRoKSwNCj4gDQo+ICAgICBU
aGVzZSBzZWVtIHVucmVsYXRlZCwgY291bGRuJ3QgaXQgYmUgbW92ZWQgdG8gYSBzcGVhcmF0ZSBw
YXRjaD8NCg0KT2sgd2lsbCBzcGxpdCBpbnRvIDIuIEFkZGluZyAgc2V0X2ZlYXR1cmUgc3VwcG9y
dCBpbiBmaXJzdCBwYXRjaA0KYW5kIHN0YXRzIGluIHNlY29uZCBwYXRjaC4NCg0KPiANCj4gPiAr
CS5tYXhfcnhfbGVuID0gUkdFVEhfUlhfQlVGRl9NQVggKyBSQVZCX0FMSUdOIC0gMSwNCj4gDQo+
ICAgIFRoaXMgc2VlbXMgdW5yZWxzYXRlZCBhbmQgbWlzcGxhY2VkIHRvby4NCg0KQWdyZWVkLiBJ
dCBpcyBhIG1pc3Rha2UuIFdpbGwgYmUgdGFrZW4gY2FyZSBpbiBuZXh0IHZlcnNpb24uDQoNClJl
Z2FyZHMsDQpCaWp1DQoNCj4gDQo+IFsuLi5dDQo+IA0KPiBNQlIsIFNlcmdleQ0K
