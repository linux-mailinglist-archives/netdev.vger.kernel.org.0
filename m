Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316B34243F6
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 19:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239219AbhJFRXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 13:23:46 -0400
Received: from mail-eopbgr1410103.outbound.protection.outlook.com ([40.107.141.103]:62272
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239104AbhJFRXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 13:23:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itJm1BTic+KOw15A8kIcs9wcioxNVlIjfiJetiiBgDRTI4D+jIS9MYl2KM9VHn9udz5mp5mkZlXYmVF8OSsO9xQG8MOlv1xYw5pY9lDdsfURRe7N1lZAakJBYQMywXpe7glNkqZKhxj9fAz2Hdf44i5pRAPIndYWEt+ITy9UVOThWvYcZByDGrn9DUXOfjxS5GmBBQswhe2Uf2Da6V7DZ/l2KvVT+bLO1O5QD0EMevsia8O7/jvWEq8FRGisYEYe2786RXuWedk761x3UV/zFtO4GL3eP6jI9ajP+Ci/7y+RuAR43xuecUehX5CxIuj3yPnMBX7/eCW9u4uBTHqrjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QS/S2cJ88rzBQuXd0//7q/28qz4AHBzsH97YXpYePcM=;
 b=YFAVHSfiXU17oBGO1EtDeFWueLa7AUt5+8/9JI9xH0nMR2sJ8kFzsAmplPbKnxESGPcS7iPZBvrhjTdvVtlB62yCQSnjA1lYx2jBVusEjh3LdzCVQWeV9HirLsHFafSr4adOX9/b5cfYIxldU16XBtLmB7cKYZwz0HXOMtOU6rgvQHkI1S9WLmzalNSGhutyKR68iGHUCyoP2N2hf5gKzm9PdB6yeZ2F3de3aruLr4tgYlOX0Cgc+ISi9xCbD/PgJ46mOlIDOlJhOZoNxTL/dPuLcAGBrd7/VE02rV+Ra8DEp/jEqteLSB22MqhLr5Jh2F7PgroNm05O99W6OTtI9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QS/S2cJ88rzBQuXd0//7q/28qz4AHBzsH97YXpYePcM=;
 b=XYzT4eRgmqx5BpHWxRSu+uneAU79VyQHChtl2bHTOX4E/WQV6w7oo0YOlMAMyZLge1UYvACy5ySNP4gO56zaC+nkX7Qt0u+zKyXgqBBE8mSxkEFECGhKT+buo1sbV6mApL9p34WuVrRa5XQbEAL3PpkOZuBIzirJrRR8YW0NjJE=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSZPR01MB6598.jpnprd01.prod.outlook.com (2603:1096:604:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 6 Oct
 2021 17:21:49 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.018; Wed, 6 Oct 2021
 17:21:48 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [RFC 08/12] ravb: Add carrier_counters to struct ravb_hw_info
Thread-Topic: [RFC 08/12] ravb: Add carrier_counters to struct ravb_hw_info
Thread-Index: AQHXudkptJjj8VB/5E2i+VTBh4dGtavGLjAAgAAK5xA=
Date:   Wed, 6 Oct 2021 17:21:48 +0000
Message-ID: <OS0PR01MB59224749D11FE02E47695BB886B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-9-biju.das.jz@bp.renesas.com>
 <5be0aed7-ba46-3b5f-e49f-8edf7cb9c193@omp.ru>
In-Reply-To: <5be0aed7-ba46-3b5f-e49f-8edf7cb9c193@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bb621c7-c95c-4be3-7daf-08d988edc7b1
x-ms-traffictypediagnostic: OSZPR01MB6598:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSZPR01MB65988C47766A1AFCE4D2823786B09@OSZPR01MB6598.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gMbvbFGSzHytqtK36jfk5/7EGd6G8bM9kBgEoJhxEhwUTiSGeT7YNgH/UD2qV9lmmZlgWkvekMaPhUrm0oj7GcX0Th9uVVVoj+0CQFZx5P2LiF7LCbjhvI0sluaBa03eO3UF3k3Q4z1ygVOkG+CW5YqaHA60YHF6fU8095XI+6atl1Raofi4tjFnDRDH9MrM+JDgVnwt/f7uZjwAc7Reb3QDv7QSzBhTRCkT1mGezl1I1H57BsP2sv6MRSTSuj3UHculRyilOGf8mSuPnFBuOKnCtWdKjYKqZglDRV2m2GLNHykfGqvMi1yOVky2Mi9650gCcQmfruFFKrz+WIH6iY2kchubIPWAFk+mxNCwxDG4OJHYD/Gxmqz1tpuVYTRsdSnJTGBxXYZjiUC3nPV0Mb6gkzRpptyPgcHlUUOysDHX13aSokADpgDbMSYtFcAveIfDogFnPpWmCshaE7fiba3lfywSCZuGQihbVNYdp8OFZrLqLAyRNR2NhedOEQ6a10FZ5cSj5elc8mMC0sjYJCtGKWzrX/Ny2aLMuJvI2DL2OsVO9NCa8jizUvHG8ZgjGPnhAYYAyi8mo2aU5vBIY3a5VL/NWfa0MGhELllEqOtSnYgB0O46lWzHkDnoizWOrA9kZK2Qgy6lyk2UdGs85MF2oIYbf9Ne37nhhDHzjT6BTXmv0w8+4/dLHyo/BVYXXxf1ExyoZXPAWzC7RPQA2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(7416002)(508600001)(55016002)(83380400001)(38100700002)(122000001)(86362001)(66946007)(76116006)(316002)(9686003)(8936002)(33656002)(110136005)(54906003)(66476007)(5660300002)(2906002)(66556008)(64756008)(66446008)(38070700005)(52536014)(186003)(53546011)(4326008)(107886003)(6506007)(7696005)(8676002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TTczRVdOTG5wQ0k3a245V3VHYkRxSlZvQjg5TVN0MDVhMFhzbWkzd3RQUmFh?=
 =?utf-8?B?V0NCRUd0eHBrNzd2ekp3THI3eXc5andvbU8zRm5Ia0tRK2ZMT2pGek5lWHdv?=
 =?utf-8?B?QVY0T2pXZmd5MzdFWmljZUk2bjMzdW5GVzVrYzRPTUZPcHlBMmM2TWRKanRZ?=
 =?utf-8?B?NDdkem1RbmJmRzhodzhWdWlYRWVmM2ZLaGNnZ2FxQzg5SEZpUDNzSWRXTm1p?=
 =?utf-8?B?WDlzMVBaZUVhWTJmTmFlTDE3U2l4a1FoQ1pYTlg3R3VKQlBLQlZOYVB5OUZ3?=
 =?utf-8?B?ZVVqVnoxdVR6TkRhV0djZEJtYkJTaXpzU0JQclZvMjdLRjl6akV2Wm8zcVcx?=
 =?utf-8?B?cjM3aWJTWitsWlJvNDduSTdSZXdIVnE2OWd2T2YybnpEeVYyVWViN2loWCtE?=
 =?utf-8?B?dTUwQXRIQ0NhQ2hJQVJISDRSSlQrc2ozVkREOS8xMlJSMHBZVmZEVTNKTmpi?=
 =?utf-8?B?ZTRKc2NzdEpJS0MyOEVlWnpjY29PQ1dxRnlJTG9TTlk3Wll3dUM2MVdhWXNn?=
 =?utf-8?B?ejZHaU9oQW5Mekh4a1BMM2ZKTVMva2djbFRucjRoV1VwSnRXeVlUTm91V0Jj?=
 =?utf-8?B?cE9MYkZSeFZQRW5sWklQUlVTUjNadzgvVThaSll1NWpPankwcldlckxyZUtM?=
 =?utf-8?B?ZjBqUnh5Zm1uYm41LzQrYXg0ZkpSVWJZVEgrMWltL1FUdEFXamVHNk51cTdZ?=
 =?utf-8?B?LzMvTTRITFlOUDRpdjNJZ1FOWmxsRU9EOWJESnFWSlhnQjl6TFVhR0JFNzlG?=
 =?utf-8?B?cjVzUVNvMW9kRFZkR0RHZ2JtWDRkNmN5WDBHbWowR1ltVlRBeE9XY1kyaUd0?=
 =?utf-8?B?S3VCZU0ycE14bk1mekRtUEtjZDBKRWpwNlY0V3NMWlRoa3FtUHpUNi9xeDky?=
 =?utf-8?B?bzZVUnpTVWxESnRpQmtuVXd3WjNBQ0VYVHkvQk1FaldUT3dEK0tGbjBiTS9T?=
 =?utf-8?B?dDQ5b3MramZwUzRnb2g2ZjB2Ny9lejBsYXAyNkFoQk1XYUhBQStiV00yN1pj?=
 =?utf-8?B?WWNJVHFkMllnY3U3UHNWNHlyeWZKT0NwVjhUbElPU1BwbFQzdGtROWE1VjB6?=
 =?utf-8?B?Q0dybS9oWmhDT2k3dU83bVhwWWdiODM1dDFmZWJVbnJMNDU0N2hRT0hOKy90?=
 =?utf-8?B?bWVQaTAvS2dwaFdhMmVrcmk1WVNnUlNrNWV5QU5PVUd4Tkt2emQ4azNDNTkw?=
 =?utf-8?B?V20xVitiU3B6SnJ4NUZyVUwzdS9RQi82WVJHY3dHV3dPdnU2bnVtdlA5ZUJs?=
 =?utf-8?B?M0U2L3l0NjJmZ2tMN3EvMFR6NlZtM2hLeUFQSkpqVHdwMnZWOHFVc1EyMVQx?=
 =?utf-8?B?TENPdFkxVTFQZFpCa3FDTU13SVlnMFdrMVBuZS9ibks3SXpFWXZLTndRdCtq?=
 =?utf-8?B?aHhtU1J3UlRqZnB0R2g2WVRHRGVmUFRFU3MyNy9uUVhmV2ZhcTJlUCtTbU05?=
 =?utf-8?B?SXFSMGZsTUpQV0VMKyszY0FxempGNldvLzRwdHgxM0xGWnpQeWdDNVptL0tw?=
 =?utf-8?B?bm9aZHJibkFiemtaYWFDQ1BIOW91dG54OGZoZ2Q2ejFXeGtGQlcwMklDOWxI?=
 =?utf-8?B?QWptdjltNG9zT1JibmRLQzN0NmpSeXZqb0JSM3V1M2xLYkk5d1RONUtPaFFv?=
 =?utf-8?B?NEFTM3d5bU9OajFMZEwxNjJtRSs5SGVlZWJPcUlUcHh0QjhTcDUvbWY2Wnps?=
 =?utf-8?B?YXdxMlpIaXFqdGdrREV1ZTk5dGxhR0dmUzJFM016clFGa25JQnozSFl5cUFC?=
 =?utf-8?Q?xGxN5uoQP0HcKt6kYA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb621c7-c95c-4be3-7daf-08d988edc7b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 17:21:48.6190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mPw7hmeOwXFw/REN1+4rtZOlTwPQ+JduCjC1TUsQqyA2BPuwA8jnPowHmztKisyulg4Cm1lzNVgNYMhaPGSa0T0p+Dv6laGTIZmxNeYI4sE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB6598
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1JGQyAwOC8xMl0gcmF2YjogQWRkIGNhcnJpZXJfY291bnRlcnMgdG8gc3RydWN0IHJhdmJfaHdf
aW5mbw0KPiANCj4gT24gMTAvNS8yMSAyOjA2IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4g
UlovRzJMIEUtTUFDIHN1cHBvcnRzIGNhcnJpZXIgY291bnRlcnMuDQo+ID4gQWRkIGEgY2Fycmll
cl9jb3VudGVyIGh3IGZlYXR1cmUgYml0IHRvIHN0cnVjdCByYXZiX2h3X2luZm8gdG8gYWRkDQo+
ID4gdGhpcyBmZWF0dXJlIG9ubHkgZm9yIFJaL0cyTC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTog
U2VyZ2V5IFNodHlseW92IDxzLnNodHlseW92QG9tcC5ydT4NCj4gDQo+IFsuLi5dDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiBpbmRleCA4YzdiMjU2OWM3ZGQuLjg5
OWUxNmM1ZWIxYSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiLmgNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gWy4u
Ll0NCj4gQEAgLTEwNjEsNiArMTA2NSw3IEBAIHN0cnVjdCByYXZiX2h3X2luZm8gew0KPiAgCXVu
c2lnbmVkIG5jX3F1ZXVlOjE7CQkvKiBBVkItRE1BQyBoYXMgTkMgcXVldWUgKi8NCj4gIAl1bnNp
Z25lZCBtYWdpY19wa3Q6MTsJCS8qIEUtTUFDIHN1cHBvcnRzIG1hZ2ljIHBhY2tldA0KPiBkZXRl
Y3Rpb24gKi8NCj4gIAl1bnNpZ25lZCBoYWxmX2R1cGxleDoxOwkJLyogRS1NQUMgc3VwcG9ydHMg
aGFsZiBkdXBsZXggbW9kZSAqLw0KPiArCXVuc2lnbmVkIGNhcnJpZXJfY291bnRlcnM6MTsJLyog
RS1NQUMgaGFzIGNhcnJpZXIgY291bnRlcnMgKi8NCj4gDQo+IA0KPiANCj4gWy4uLl0NCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGluZGV4IDQy
NTczZWFjODJiOS4uYzA1N2RlODFlYzU4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gQEAgLTIwNzUsNiArMjA3NSwxOCBAQCBzdGF0aWMg
c3RydWN0IG5ldF9kZXZpY2Vfc3RhdHMNCj4gKnJhdmJfZ2V0X3N0YXRzKHN0cnVjdCBuZXRfZGV2
aWNlICpuZGV2KQ0KPiA+ICAJCXJhdmJfd3JpdGUobmRldiwgMCwgVFJPQ1IpOwkvKiAod3JpdGUg
Y2xlYXIpICovDQo+ID4gIAl9DQo+ID4NCj4gPiArCWlmIChpbmZvLT5jYXJyaWVyX2NvdW50ZXJz
KSB7DQo+ID4gKwkJbnN0YXRzLT5jb2xsaXNpb25zICs9IHJhdmJfcmVhZChuZGV2LCBDWFI0MSk7
DQo+ID4gKwkJcmF2Yl93cml0ZShuZGV2LCAwLCBDWFI0MSk7CS8qICh3cml0ZSBjbGVhcikgKi8N
Cj4gPiArCQluc3RhdHMtPnR4X2NhcnJpZXJfZXJyb3JzICs9IHJhdmJfcmVhZChuZGV2LCBDWFI0
Mik7DQo+ID4gKwkJcmF2Yl93cml0ZShuZGV2LCAwLCBDWFI0Mik7CS8qICh3cml0ZSBjbGVhcikg
Ki8NCj4gPiArDQo+ID4gKwkJbnN0YXRzLT50eF9jYXJyaWVyX2Vycm9ycyArPSByYXZiX3JlYWQo
bmRldiwgQ1hSNTUpOw0KPiANCj4gICAgQWNjb3JkaW5nIHRvIHRoZSBtYW51YWwsIENYUjU1IGNv
dW50cyBSWCBldmVudHMgKGNhcnJpZXIgZXh0ZW5zaW9uDQo+IGxvc3QuDQoNCkFncmVlZC4gd2ls
bCByZW1vdmUgdGhpcyBmcm9tIHR4X2NhcnJpZXJzLg0KDQo+IA0KPiA+ICsJCXJhdmJfd3JpdGUo
bmRldiwgMCwgQ1hSNTUpOwkvKiAod3JpdGUgY2xlYXIpICovDQo+ID4gKwkJbnN0YXRzLT50eF9j
YXJyaWVyX2Vycm9ycyArPSByYXZiX3JlYWQobmRldiwgQ1hSNTYpOw0KPiANCj4gICAgQW5kIENY
UjU2IGNvdW50cyByZWNlaXZlIGV2ZW50cyB0b28uLi4NCg0KQWdyZWVkLiB3aWxsIHJlbW92ZSB0
aGlzIGZyb20gdHhfY2FycmllcnMuDQoNCg0KPiANCj4gPiArCQlyYXZiX3dyaXRlKG5kZXYsIDAs
IENYUjU2KTsJLyogKHdyaXRlIGNsZWFyKSAqLw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiAgCW5zdGF0
cy0+cnhfcGFja2V0cyA9IHN0YXRzMC0+cnhfcGFja2V0czsNCj4gPiAgCW5zdGF0cy0+dHhfcGFj
a2V0cyA9IHN0YXRzMC0+dHhfcGFja2V0czsNCj4gPiAgCW5zdGF0cy0+cnhfYnl0ZXMgPSBzdGF0
czAtPnJ4X2J5dGVzOyBAQCAtMjQ4Niw2ICsyNDk4LDcgQEAgc3RhdGljDQo+ID4gY29uc3Qgc3Ry
dWN0IHJhdmJfaHdfaW5mbyBnYmV0aF9od19pbmZvID0gew0KPiA+ICAJLmFsaWduZWRfdHggPSAx
LA0KPiA+ICAJLnR4X2NvdW50ZXJzID0gMSwNCj4gPiAgCS5oYWxmX2R1cGxleCA9IDEsDQo+ID4g
KwkuY2Fycmllcl9jb3VudGVycyA9IDEsDQo+IA0KPiAgICBBdCBsZWFzdCBpbml0IGl0IG5leHQg
dG8gJ3R4X2NvdW50ZXJzJy4gOi0pDQoNCkFncmVlZC4gd287OyBtb3ZlIG5leHQgdG8gdHhfY291
bnRlcnMuDQoNClJlZ2FyZHMsDQpCaWp1DQoNCj4gDQo+IFsuLi5dDQo+IA0KPiBNQlIsIFNlcmdl
eQ0K
