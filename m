Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C83421EB1
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhJEGI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:08:26 -0400
Received: from mail-eopbgr1400105.outbound.protection.outlook.com ([40.107.140.105]:58816
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232020AbhJEGIN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 02:08:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLjVi5ThRYSpW25/qWE5zwWFrlxJ17mmKfSp5VpUPcyDiFScmU/JNUs6FX8qj0aWIxspeK33F4C9b5/3STlXGhWionO/W+6G4Dymz1Vj+hOfZKmNt3k6M93Z/P668kfx0Xw4NiVu+RPgIUe2hok6GD9iWgorgTFFcL5mi5ru6a9tVCW4I1tb5Nz0VgvE8ZxyEZ9rWKv3XiTijklyYTlG7DTAno8Cy2XKqRyjpXGtfmz2fJFYjjIWczeYbpC/PuiTrEe4yiSJuZA9DQQrJvGcYIdb3PQa4go4vbFRnjtwcmhPX+d70CimltzFslPyi1xZW3A/QOmY2gINKuGTTQ9fug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0x1QQwQ4TEXAY+LZ76eJahApLKZ6VowQ+mwd3F9b5Io=;
 b=H+4ewIBkViRTDQ1p+RCKTPdXSMf3pTvmgFCGzFdsRey8WxXk+ZXgF612pA65oMe3enpGYXC0axuyUkY47fSk0YvAWudKTYzts1dVOszgnGJ5L1cctKOKEQtjkIoqOXr2JZ9YrL79dW0zxllTj9WKc9qfh5MKopEzk6Mo+8I0ixZecCAUs/G+lTX2GoxqOP7DKGQ9Q4usJ9XvUpaHhGJvj/e16T0PfshQB6uTMnqqdJoW8NUZaQ1lJoQ7+IGVQdMYWU/EtWbOA+gy9TuqUntuXRG0HIvF+hLfdQ18HqODFalpBl8xPvuRpzncOikO99QXLYOc+0Je96P42GQV369yHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0x1QQwQ4TEXAY+LZ76eJahApLKZ6VowQ+mwd3F9b5Io=;
 b=V1YZJeM7XC4vhXoFca53Rc9EJ+wBU/sobHFV48NqmSdAVeGVwOhOeXVix7ex2WLMKY78cJXFPS0CNOEl6SeVaIZuoepgepHudIFUohQGHKq0X/GNgX727cKqX8tEBrp9qiwucWJxjcoQqHknyfV2g/jGxGzjZ0dkunMO8UnEuaA=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB5223.jpnprd01.prod.outlook.com (2603:1096:604:7f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 06:06:19 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 06:06:19 +0000
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
Subject: RE: [PATCH 2/8] ravb: Fillup ravb_rx_ring_free_gbeth() stub
Thread-Topic: [PATCH 2/8] ravb: Fillup ravb_rx_ring_free_gbeth() stub
Thread-Index: AQHXtuNyDqPXdQPmZEWoApgT46bztavDT08AgACgeTA=
Date:   Tue, 5 Oct 2021 06:06:18 +0000
Message-ID: <OS0PR01MB592219AE6011022D5064085586AF9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001164305.8999-1-biju.das.jz@bp.renesas.com>
 <20211001164305.8999-3-biju.das.jz@bp.renesas.com>
 <942afec6-6566-25ce-356a-f692f17b4153@omp.ru>
In-Reply-To: <942afec6-6566-25ce-356a-f692f17b4153@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0b2d9e1-4219-4e81-3ba4-08d987c63fb7
x-ms-traffictypediagnostic: OSBPR01MB5223:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB5223C0D04E576B533242265286AF9@OSBPR01MB5223.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KXncpCqqtvpkOunXDN1NlMCDIxzLUpAIV5LREgJIEgVpcD10xVPaITKHHc0D5C5HdROwRYVqqFQlhWWJX7cDRHhCmsxHd0YZiiQU3aFgov4F4kp763Ndjxk87LzzNCGUmjf8zgBPM48QoDa5iQrg48rJAl8Ld1b6iJkKsg+md1DqkQUCtaDOu4fxR0JMGbLe6AAU+JBmEX8+BfVMqYQne25O1x0uhIdWkmdBDb4WZEwgV5b25ujnz+gaqeSWhIrK02mOvzVW+SUX9CGQQhsV4Tj0RodzJY1iaPJ1vZspAfD0c6IzgxETk9gKhBTM6z0TGlpaaX1SWQ2CbQbDZFnhQtlkbQBTECw7g5Jx7JmwOX06JDnozoePiS3j3AXipUQ9OnmHVC/nyJnV4D3bYKWFr2q3RFxnvURL7HZd7HmwO9FYCITRPA5L8YNyEZgMSbYHtbwa5KRG3TK5zyEFvMrfV4rLYuuAKjXfYmrbGbIKZ69A8P56WxOlhfzAYt2EPj4ooJH3DsU5inNkqne95U8hE8yWe6OMQMarIaRG9gCKhRCchkFHgLvYp07ssbmzvxDZGnjj8oUA5esGKCv85KdA1305L4YJpZWKo2/lTg7HqrQ7Noc1LftRrgTBQzazNMZ+Tu1P4h1pavuaMf68zyNaPE0/GTgOdi5NI0xnxm5G/e9sdx+6lB7cI8vFbUb/b606RCcy1ddVi5udC39fAR9Pbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(64756008)(9686003)(66476007)(66946007)(7416002)(66556008)(38100700002)(2906002)(122000001)(55016002)(7696005)(53546011)(508600001)(6506007)(66446008)(52536014)(76116006)(110136005)(316002)(71200400001)(8936002)(5660300002)(107886003)(86362001)(8676002)(26005)(4326008)(83380400001)(54906003)(33656002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjduaXB3Y291eGZuamlDYzB1KzdzUHJKQ3RTOUwvZWtrS2IrYi9BYTgvMHZM?=
 =?utf-8?B?aEVYZEhDczVlb3doekRWdk5MWEU1OHlXSVJWM1Jka0tzc2FydmlIN3NmSHJz?=
 =?utf-8?B?VWhOcUxCUWE0RmdxdnRxMDlLbEdLWGppRkxQUUpFUFVvYVBoeTlTRlRGckM5?=
 =?utf-8?B?TThjMFRmNXdtR2xhbitWdzVBMjBWU3lrYy9TaTA4SzNsN011bFV4WG1PZWl4?=
 =?utf-8?B?NlRvMXNNQjB4U2F0T09CSnpWYi8xQmpySjRlUTBPNEpQRXFwUGFkZG5hd0dt?=
 =?utf-8?B?R08xYTgvNXozOEUwL2RpaFNqQ2QrT0lSUEhhQXkxYWpvUWhKZmNvTXJBemt4?=
 =?utf-8?B?MUV6MTNFS0E5aTZER1c5OW5rbjhxMnl5dnFnNk5yUkZKYkxZQjZnTXVFaEM0?=
 =?utf-8?B?ZDRFS0UxcE55Y0M3YlFwbU95Q0hFcmNtZ0w2RjU0Rk5nU2o1SG9TZ1J4WXp0?=
 =?utf-8?B?bVhLbDRTanJhREFQMXozMzhBeTNMT1pNVUk5YTB0MjVqVG5SMm82UVNRdE5U?=
 =?utf-8?B?ZStJeGxBdkh3UjdTbGlQZDNGUGl3Yk5ObXZ5TVBIZjFrQmhCMU9TeUIwckx0?=
 =?utf-8?B?d1NyZW53a1RJTng4M3EyWW4xUnU1QzZYWHVhRm1kQ24zQWVHVXBrc1A3Q2R3?=
 =?utf-8?B?TnJsNnY3RS9NUnBETXc5MEYxZWlKSk1lU0d4THZ2c2R1ZnQwQnd6UEhlZm5t?=
 =?utf-8?B?NElXQzRNNG1kZ3RVdit0STJya0ZKb1pKcFBnVlZXT0xlWXZaRklBZDZkcHhB?=
 =?utf-8?B?a05GTXBDaW5lM2lKNWh3UlBjZVF5K2dqNlFROVhVdmpWTTRFUHM0YkR3MkQy?=
 =?utf-8?B?cUpkanlGY3Q1dDhBajBRT0VtbS9Rc0ZTUDlWZmw4MFFXVXNQWE1DTkRCN082?=
 =?utf-8?B?MGlZaDlLZ3kvQXNKUzVnUlRIMjNyb1dsZisyMHVhRml6cm1sUDBLam5mdUh5?=
 =?utf-8?B?cFFxR3RheVZGeXJrR2MyQmtJQnFQSUl4WCtGOUpReFUva0hPMllrZCs4R0pP?=
 =?utf-8?B?empyTWsxYVU2Vmx5ZTRqdFhXYVo0bkxjWXFTM0crYTZnZkN3N3daVFUvU0Vt?=
 =?utf-8?B?dzcxSDRQL2xURUErdndtVFM0NkF1S1p2cERkc056UTNMTnFEdWJlQm5aZXBM?=
 =?utf-8?B?Y2FYM1dWVUYzVjRxU1J4clQ1RGYyNjdSc1NyUS90SUlpeXRSUjkrQ1l5Y0Q2?=
 =?utf-8?B?VG9MdUQ0T3pyblJZWjhaeXRYTlVqL21wdHdjV3JvWndkeG5FN3dCVUx3OGxL?=
 =?utf-8?B?WUt5T1N2Q2hxYlFYTncrOU9ZTUFibEVKY2FEa01WTzRINWRnNUE4d0FRYzlM?=
 =?utf-8?B?ME1vLy9oVXdmbHJtTXJGRm9WRlovTDJMN2I4a2Jxa20wQVhrbTlWTlVqaHYv?=
 =?utf-8?B?ZEZwbnVLVGoyZlVydTBTdERwSjFBbHVadW1VcmdyY0w4WDdaWHllMFQxZ20w?=
 =?utf-8?B?M0RvWmgrUzFtSVpyeWpXL0ZpVThqOXBvRmc4a2Z4V0pkelRyR0tEb1ljUk9M?=
 =?utf-8?B?WmNVTlN5SHF3YVFoQ095YjlPK3drVlZYRmhEeFA1bGxsWkVCUXdMT2NQSUN4?=
 =?utf-8?B?b0wrb25pMlJsNHFXVWY2VUVwS2oyUHpHcllabTlNeTg5S2lIS0xTTVdYMCtX?=
 =?utf-8?B?VTJQRWNJbk05SDVYMVdDWFB0aThRQ2JIVVpkcGFaNWhSZEh5SkZxZXJaUExP?=
 =?utf-8?B?VDNvbENYQ3dUVm14ZFVoMXV6YVF4Z2h0bmdoUGVkdjhIUlpKSkJYdFFFd1lq?=
 =?utf-8?Q?QWrw9wNw+okkkLpX+wVT5Lm41VToagridXYKeZ7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b2d9e1-4219-4e81-3ba4-08d987c63fb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2021 06:06:18.9772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xSSBeTF8mbxjR9JWbPViTVDEQYNfKsR/3CHRDX/2B1IeOKmHK4TK2stpeYAfstjKodW79O3SvY6ptLBmyObnak6LGCNMQcAM93OnIAHwg8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB5223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMi84XSByYXZiOiBGaWxsdXAgcmF2
Yl9yeF9yaW5nX2ZyZWVfZ2JldGgoKSBzdHViDQo+IA0KPiBPbiAxMC8xLzIxIDc6NDIgUE0sIEJp
anUgRGFzIHdyb3RlOg0KPiANCj4gPiBGaWxsdXAgcmF2Yl9yeF9yaW5nX2ZyZWVfZ2JldGgoKSBm
dW5jdGlvbiB0byBzdXBwb3J0IFJaL0cyTC4NCj4gPg0KPiA+IFRoaXMgcGF0Y2ggYWxzbyByZW5h
bWVzIHJhdmJfcnhfcmluZ19mcmVlIHRvIHJhdmJfcnhfcmluZ19mcmVlX3JjYXIgdG8NCj4gPiBi
ZSBjb25zaXN0ZW50IHdpdGggdGhlIG5hbWluZyBjb252ZW50aW9uIHVzZWQgaW4gc2hfZXRoIGRy
aXZlci4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5y
ZW5lc2FzLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1h
aGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiA+IC0tLQ0KPiA+IFJGQy0+djE6DQo+ID4g
ICogcmVuYW1lZCAicmdldGgiIHRvICJnYmV0aCIuDQo+ID4gICogcmVuYW1lZCByYXZiX3J4X3Jp
bmdfZnJlZSB0byByYXZiX3J4X3JpbmdfZnJlZV9yY2FyDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAgMSArDQo+ID4gIGRyaXZlcnMvbmV0
L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgfCA0MQ0KPiA+ICsrKysrKysrKysrKysrKysr
KysrLS0tLQ0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDM2IGluc2VydGlvbnMoKyksIDYgZGVsZXRp
b25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yYXZiLmgNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4g
aW5kZXggYjE0N2M0YTBkYzBiLi4xYTczZjk2MGQ5MTggMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IEBAIC0xMDc3LDYgKzEwNzcsNyBAQCBzdHJ1Y3QgcmF2
Yl9wcml2YXRlIHsNCj4gPiAgCXVuc2lnbmVkIGludCBudW1fdHhfZGVzYzsJLyogVFggZGVzY3Jp
cHRvcnMgcGVyIHBhY2tldCAqLw0KPiA+DQo+ID4gIAlpbnQgZHVwbGV4Ow0KPiA+ICsJc3RydWN0
IHJhdmJfcnhfZGVzYyAqZ2JldGhfcnhfcmluZ1tOVU1fUlhfUVVFVUVdOw0KPiANCj4gICAgR0JF
dGhlciBvbmx5IGhhcyAxIFJYIHF1ZXVlLCByaWdodD8NCj4gICAgQW5kIHBsZWFzZSBtb3ZlIHRo
ZSBkZWNsYXJhdGlvbiBjbG9zZXIgdG8gcmF2Yl9wcml2YXRlOjpyeF9yaW5nLg0KDQpPay4gV2ls
bCBtb3ZlIGl0IGFuZCBkZWNsYXJlIGl0IGFzIHN0cnVjdCByYXZiX3J4X2Rlc2MgKmdiZXRoX3J4
X3Jpbmc7DQpBbHNvIEkgYW0gcGxhbm5pbmcgdG8gYWRkIGFsbG9jIHBhdGNoIGZpcnN0IHRoZW4g
ZnJlZS4gU28gdGhpcyBjaGFuZ2Ugd2lsbCBnbyB0bw0KYWxsb2MgcGF0Y2guDQoNCj4gDQo+IFsu
Li5dDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9t
YWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4g
PiBpbmRleCAwZDFlM2Y3ZDhjMzMuLjZlZjU1ZjFjZjMwNiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiBbLi4uXQ0KPiA+IEBAIC0xMDg0LDE2
ICsxMTA0LDI1IEBAIHN0YXRpYyBpbnQgcmF2Yl9wb2xsKHN0cnVjdCBuYXBpX3N0cnVjdCAqbmFw
aSwNCj4gaW50IGJ1ZGdldCkNCj4gPiAgCXN0cnVjdCBuZXRfZGV2aWNlICpuZGV2ID0gbmFwaS0+
ZGV2Ow0KPiA+ICAJc3RydWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2KG5kZXYp
Ow0KPiA+ICAJY29uc3Qgc3RydWN0IHJhdmJfaHdfaW5mbyAqaW5mbyA9IHByaXYtPmluZm87DQo+
ID4gKwlzdHJ1Y3QgcmF2Yl9yeF9kZXNjICpkZXNjOw0KPiA+ICAJdW5zaWduZWQgbG9uZyBmbGFn
czsNCj4gPiAgCWludCBxID0gbmFwaSAtIHByaXYtPm5hcGk7DQo+ID4gIAlpbnQgbWFzayA9IEJJ
VChxKTsNCj4gPiAgCWludCBxdW90YSA9IGJ1ZGdldDsNCj4gPiArCXVuc2lnbmVkIGludCBlbnRy
eTsNCj4gPiArCWJvb2wgbm9uX2dwdHAgPSAhKGluZm8tPmdwdHAgfHwgaW5mby0+Y2NjX2dhYyk7
DQo+IA0KPiAgICBKdXN0IG5vX2dwdHA/IE9yIG1heWJlIGdwdHAsIHNlZW1zIGV2ZW4gYmV0dGVy
Pw0KDQpPSy4gV2lsbCB1c2UgZ3B0cC4NCg0KUmVnYXJkcywNCkJpanUNCg0KPiANCj4gPg0KPiA+
ICsJaWYgKG5vbl9ncHRwKSB7DQo+ID4gKwkJZW50cnkgPSBwcml2LT5jdXJfcnhbcV0gJSBwcml2
LT5udW1fcnhfcmluZ1txXTsNCj4gPiArCQlkZXNjID0gJnByaXYtPmdiZXRoX3J4X3JpbmdbcV1b
ZW50cnldOw0KPiA+ICsJfQ0KPiA+ICAJLyogUHJvY2Vzc2luZyBSWCBEZXNjcmlwdG9yIFJpbmcg
Ki8NCj4gPiAgCS8qIENsZWFyIFJYIGludGVycnVwdCAqLw0KPiA+ICAJcmF2Yl93cml0ZShuZGV2
LCB+KG1hc2sgfCBSSVMwX1JFU0VSVkVEKSwgUklTMCk7DQo+ID4gLQlpZiAocmF2Yl9yeChuZGV2
LCAmcXVvdGEsIHEpKQ0KPiA+IC0JCWdvdG8gb3V0Ow0KPiA+ICsJaWYgKCFub25fZ3B0cCB8fCBk
ZXNjLT5kaWVfZHQgIT0gRFRfRkVNUFRZKSB7DQo+ID4gKwkJaWYgKHJhdmJfcngobmRldiwgJnF1
b3RhLCBxKSkNCj4gPiArCQkJZ290byBvdXQ7DQo+ID4gKwl9DQo+ID4NCj4gPiAgCS8qIFByb2Nl
c3NpbmcgVFggRGVzY3JpcHRvciBSaW5nICovDQo+ID4gIAlzcGluX2xvY2tfaXJxc2F2ZSgmcHJp
di0+bG9jaywgZmxhZ3MpOw0KPiBbLi4uXQ0KPiANCj4gTUJSLCBTZXJnZXkNCg==
