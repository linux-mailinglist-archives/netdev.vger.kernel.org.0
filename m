Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35C2420062
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 08:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbhJCHAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 03:00:35 -0400
Received: from mail-eopbgr1410097.outbound.protection.outlook.com ([40.107.141.97]:62027
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229567AbhJCHAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 03:00:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDbwqJ7nDKnGoq/MNK42Vw2tzGwOe9SDqXN93eW4KQ4G7UI3mT8xIK3cEssCPvQ2FlPfMeJbSj9A6+gdth8lsaLSZ7gpoq1ykqhx0MLlD9vE7wvbFu4guCBLxsTIj6FD3wuEUZqBEg5KJDeHl7TtXiVn+96Pyp5USdqWcpERVE4qGGndIRPZDDyYVChQuYFP93Q2CDhoS7c3ODunrrNXusIIC3HxUDq+P2GpFsCdBnTBnxsDqacNk1Vt0nhlSvcqY5ZEMq4fdf6kW418fXIR9qtOEwJesOiPQ4VPw6GUdq38Bc8QRSJJXZkVGsf1hw1gOAd6zvtAR+K0bIkKz72qzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=03i9+pJF46x705F/tY7PyuircwtpDNIdgLNNfAcP6qE=;
 b=n5rOPc0wyuf5dOJ1uqkw2rsI7tWIZJtfIl+n+vfhNOFtp9fxpydfwvbCnJx5EXD/a/FEYSHtPgyZ+YITcDhURoWn/R6vfoqRN5op8XuuzfXLlimKlHasaT1wISi4g4kv7rwLqa4QWpVM/yqs4Jbn5vi1GX+noqnFrsJ11tzXXVwm9npx2Cfw0REqjfJD60nbJBfQM/DmR2G45Qstqo8XuMF4ZVWBYuWrQ+TKwheDW6Mn+/G672t6L+gMsYedqB4vUK1W7VqXWVFfUxGROheyydF1vxP6eghq46QRKcnDKSEGgOtArGx8HuCAVmJDeY/3K9xMNlKSLa3DWiX/vxMEzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03i9+pJF46x705F/tY7PyuircwtpDNIdgLNNfAcP6qE=;
 b=a+QQtpc+zVSQoPiy4u00emgMDmS5zagID8fXcZFmz4bNqrOx9YMuNQH0iCj/XDo0I86QZUKXAYmQ4TeN/K6KboftUBQI2gNfWnMgGkaojSF/0xqTEnrMXAH5+EYEmm8o8WLoAOrADHEXWkff8024yBQaRWX+cbsAnsZ96cSTvlM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5928.jpnprd01.prod.outlook.com (2603:1096:604:c3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Sun, 3 Oct
 2021 06:58:44 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.015; Sun, 3 Oct 2021
 06:58:44 +0000
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
Subject: RE: [PATCH 03/10] ravb: Add nc_queue to struct ravb_hw_info
Thread-Topic: [PATCH 03/10] ravb: Add nc_queue to struct ravb_hw_info
Thread-Index: AQHXttX5ODlVZmq7uEmXI4BQLB83BavACvsAgADNqeA=
Date:   Sun, 3 Oct 2021 06:58:44 +0000
Message-ID: <OS0PR01MB59222DB9D710A944235FD1D586AD9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-4-biju.das.jz@bp.renesas.com>
 <334a8156-0645-b29c-137b-1e76d524efb9@omp.ru>
In-Reply-To: <334a8156-0645-b29c-137b-1e76d524efb9@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 133a5479-5e64-4f8f-bbbd-08d9863b3dca
x-ms-traffictypediagnostic: OS3PR01MB5928:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB5928AF5FFF98EDB19F0B3C1986AD9@OS3PR01MB5928.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LbUiUZ2Q87Uc/HWCYUG/G3ExOppAVUjeqE5o4Wb8BZMZoYZbja4yAD8yGlbAa1M7zdozNCtMC2ZeTmLe+TfpKRsepkBe4nDSY1maqjThC39uRcIKyQXyHa/HA4P9tMykA4IIioEBnvpxPAcWEyB0Wfl/UIMZHYzy8IniN+WBEyX73rtPaN8JD2kd+vkdLodhisH/1T6SBeOhYAzzk6Hdj3c/Xc5pEKUh3EUj70cdFu7HEDE10vhIC1vHpxGLQazVfa5NgXgiqOwtJjuwcRKq6CbS4j1ZMVa4OLwGUnMkFFaaH76mMYBXdQ1QEh0vxOCuAlBKFBn/Fng5KtBm/2XfFfap5Tplg4k1TLrHqVtPBufwQuJqtzwz4k4w+EQGFNPOPspbKtJOBqKdzoPKbUhYdKvBkJWTHjQhpSygEJONB+GUycqJKuDIAwaxr2kFtJ3cQpISKJuzab8l5+rqpBmlgGyp3pTHBBc9gNF8exJ8yt2fodVavzgB5i6+XlqHgjocC3UNilLX0Ppy98MLc4ElQk2afs+VvSU89NzejJkRzgFAqVjCUjxeECiOsL7lRcPmEweb1/K0pdPCQRdNlyU9uVPtuVCUSp/1N81bEVy6HPrOcl3uhb02XWdSUARVGdUylBJuKNRUx8wTzG0zuEyAEiDn9hjVfIQ68+47mTC7VYi07pDfBbur6JlgMEHiCkVt45b0+3ZBBbBGv4KK5h9+Ng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(83380400001)(66946007)(8676002)(122000001)(66446008)(64756008)(66556008)(76116006)(508600001)(4326008)(107886003)(86362001)(38070700005)(33656002)(55016002)(66476007)(9686003)(38100700002)(2906002)(186003)(26005)(54906003)(316002)(7416002)(5660300002)(6506007)(53546011)(7696005)(52536014)(110136005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U25JeFZrWUg5ZmN3Ty9mN1RDTzFGWFR2VDNEb2hCTVNCNjV4S0lJOVJrc1JJ?=
 =?utf-8?B?YzE1VDVmdm5iMER6YkVoM0IyLzdwbWJLNE45SWgrZFJPQVVWV0t5anJabmJO?=
 =?utf-8?B?RFFZeHNKcE9sV1Vxc053MmViSjFPK3BIUlI0QlZsSVhYMENSQXVKWVZ0Nyty?=
 =?utf-8?B?dDlRdEhFdC9BckdWU09PcVQ3cXJ4Z0M0bk50VkdNSmpQaytMTVh2RTZMZDRR?=
 =?utf-8?B?UHJWcGVZMmYzY3FNMWJETGVDTTlXZmdlM3UySjZ3SHBvNTAySWVTa1JJL0Rh?=
 =?utf-8?B?L1BobFphdmsrT29pRFo3UmFvdU9hZTBpYWF4Y2hLdldFRjlLYkhwMXk5VTJB?=
 =?utf-8?B?YnRMT0VMaURFaFJwQVZNUXNNTDFhMW9DQ1FJQVoxRXZyazlIakJEaGx2Nk8v?=
 =?utf-8?B?bTlselA5MU5oMThFcE1GVjRWZkdXNGVvMDM1MUJJQjVYVjFhM3hjQ3NuTWp3?=
 =?utf-8?B?dGJxU2dBeVdRUXlWaWVwTHlKZjkrT3lmdzFnT3JoNVRnT1dzRVlMTk1WaG1C?=
 =?utf-8?B?WUIwemRpV2J5SFA3OHBzdGdjRlRTYXZhR1NCVE1Na2N3V0ZrY1JhckwxRGdD?=
 =?utf-8?B?ejZRL0Z3ZUtXOGZqeW94bEJOTnNuYytybGRSaDM2cXdyNndid2lwRVl2N2pM?=
 =?utf-8?B?OEMxazcvY2JMdDdUbHhibk1BZGdOaG1HK1YvWm4yNGNSM0xLOG0yTzViQW92?=
 =?utf-8?B?cURLeGFzK3l3Vm80NDBTNzJNdFlxV0owVmxkRDJ1QVk0SGNkNUdFK2ZId2to?=
 =?utf-8?B?Unl0NG1GR0YrS3FjTkFtOHB4SlpYdDZNdFJCaU4rZEVHaFpMb21FdnF0Q21B?=
 =?utf-8?B?N09oUmJFMkxvMXZzMW8rU2dCQmU5MkFkMjJmTVM1VVplaUVsRG10bDRhSEtG?=
 =?utf-8?B?Y042VVRrVC9ydDl5eUJGQ2FtS21LYk1DV29ER3VPMUlMRjZyc1dHeHNLQmNR?=
 =?utf-8?B?Y1VtNHdFaWYvSjhqYlhXM3VITGszL1N2MDlDaHZQUE4wM3FPSmhBNnlDKzlp?=
 =?utf-8?B?UGVRUHBSblR2VVVOWnFRTEpScTI0TzdlRHhmaFBTOW9GRWRyNjZJL0VHZWF2?=
 =?utf-8?B?ZGIxaXB2UXpHczNMV1Y4RzIxR242UzRnZ29rdjBmc254L1J6b24rY0tRdndF?=
 =?utf-8?B?bURqRjFsQTFRSW5KNzM4MHRQTVRxV1FKZThRdGVZdmlEdW5INnlEeUxydnBz?=
 =?utf-8?B?MnN4dGFkYjZvanNhWlF3VnhnMTdkNEtJOFRDQmFpTi9OT25SRW9RenZydStM?=
 =?utf-8?B?ak9hWXZHWjV1cnJxMHJSYkFyejJUYVVJL0QrM0lWS1BYSXhSbDhtREtoZzFV?=
 =?utf-8?B?S3ZIakVZRW55ZzZqaDhpQWZTdHBYaUpJcm1rekNFa0RnMDhScUJoc3lJNGFi?=
 =?utf-8?B?VzVJdW5NNDNQZlQwY25wTExmZHRHZVByK1JTallZWGxkZm45RUF3ekxzeVV6?=
 =?utf-8?B?TmRMaGxxb1dtNlhJR09sK3hDWVdSUTRaU2xQYkhWckZ6Z1VVdzJaR3RSUFYw?=
 =?utf-8?B?K1l0eXR4eVU3ZlR1T2RFNm94UkZiV0xQUjEvMjBQZEsvWVdwS01BblRBYlhx?=
 =?utf-8?B?Q3RsMG1IMVFlblpranhCbDdTcVZsVm1YdGFWQmNzN0tjc28xU0E5OXZ5Y1By?=
 =?utf-8?B?c01iWFUxUmdmVDA1bGl1SzdIdk5sNC92Ujc5QUVhWVhXdDdjU3g4VUxuQU1p?=
 =?utf-8?B?b01wRDBjVkJDTGdianRsZHdHbFJkOGFuUnBSUk9ZRHQyZk1KYkRXcU9QNFFa?=
 =?utf-8?Q?RkeLJ5sdE6uHXjrzX4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 133a5479-5e64-4f8f-bbbd-08d9863b3dca
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2021 06:58:44.6091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VeB0biYLNVg2RkaDfn/gOE0mOPplrV34mx6bgpxerp+KsgbPj3pJSKHPHEVnnTYacSZS/TA1JQQnFMNKhU0/kAv3NGHn00/mUhNdrNcdLjk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5928
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMDMvMTBdIHJhdmI6IEFkZCBuY19x
dWV1ZSB0byBzdHJ1Y3QgcmF2Yl9od19pbmZvDQo+IA0KPiBPbiAxMC8xLzIxIDY6MDYgUE0sIEJp
anUgRGFzIHdyb3RlOg0KPiANCj4gPiBSLUNhciBzdXBwb3J0cyBuZXR3b3JrIGNvbnRyb2wgcXVl
dWUgd2hlcmVhcyBSWi9HMkwgZG9lcyBub3Qgc3VwcG9ydA0KPiA+IGl0LiBBZGQgbmNfcXVldWUg
dG8gc3RydWN0IHJhdmJfaHdfaW5mbywgc28gdGhhdCBOQyBxdWV1ZSBpcyBoYW5kbGVkDQo+ID4g
b25seSBieSBSLUNhci4NCj4gPg0KPiA+IFRoaXMgcGF0Y2ggYWxzbyByZW5hbWVzIHJhdmJfcmNh
cl9kbWFjX2luaXQgdG8gcmF2Yl9kbWFjX2luaXRfcmNhciB0bw0KPiA+IGJlIGNvbnNpc3RlbnQg
d2l0aCB0aGUgbmFtaW5nIGNvbnZlbnRpb24gdXNlZCBpbiBzaF9ldGggZHJpdmVyLg0KPiA+DQo+
ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0K
PiA+IFJldmlld2VkLWJ5OiBMYWQgUHJhYmhha2FyIDxwcmFiaGFrYXIubWFoYWRldi1sYWQucmpA
YnAucmVuZXNhcy5jb20+DQo+IA0KPiBSZXZpZXdlZC1ieTogU2VyZ2V5IFNodHlseW92IDxzLnNo
dHlseW92QG9tcC5ydT4NCj4gDQo+ICAgIE9uZSBsaXR0bGUgbml0IGJlbG93Og0KPiANCj4gPiAt
LS0NCj4gPiBSRkMtPnYxOg0KPiA+ICAqIEhhbmRsZWQgTkMgcXVldWUgb25seSBmb3IgUi1DYXIu
DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAg
fCAgIDMgKy0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8
IDE0MA0KPiA+ICsrKysrKysrKysrKysrKy0tLS0tLS0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwg
OTQgaW5zZXJ0aW9ucygrKSwgNDkgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gaW5kZXggYTMzZmJjYjRhYWMzLi5jOTFlOTNlNTU5
MGYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgN
Cj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IEBAIC05
ODYsNyArOTg2LDcgQEAgc3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4gIAlib29sICgqcmVjZWl2
ZSkoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCAqcXVvdGEsIGludCBxKTsNCj4gPiAgCXZv
aWQgKCpzZXRfcmF0ZSkoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpOw0KPiA+ICAJaW50ICgqc2V0
X2ZlYXR1cmUpKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBuZXRkZXZfZmVhdHVyZXNfdA0KPiBm
ZWF0dXJlcyk7DQo+ID4gLQl2b2lkICgqZG1hY19pbml0KShzdHJ1Y3QgbmV0X2RldmljZSAqbmRl
dik7DQo+ID4gKwlpbnQgKCpkbWFjX2luaXQpKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KTsNCj4g
PiAgCXZvaWQgKCplbWFjX2luaXQpKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KTsNCj4gPiAgCWNv
bnN0IGNoYXIgKCpnc3RyaW5nc19zdGF0cylbRVRIX0dTVFJJTkdfTEVOXTsNCj4gPiAgCXNpemVf
dCBnc3RyaW5nc19zaXplOw0KPiA+IEBAIC0xMDAyLDYgKzEwMDIsNyBAQCBzdHJ1Y3QgcmF2Yl9o
d19pbmZvIHsNCj4gPiAgCXVuc2lnbmVkIG11bHRpX2lycXM6MTsJCS8qIEFWQi1ETUFDIGFuZCBF
LU1BQyBoYXMgbXVsdGlwbGUNCj4gaXJxcyAqLw0KPiA+ICAJdW5zaWduZWQgZ3B0cDoxOwkJLyog
QVZCLURNQUMgaGFzIGdQVFAgc3VwcG9ydCAqLw0KPiA+ICAJdW5zaWduZWQgY2NjX2dhYzoxOwkJ
LyogQVZCLURNQUMgaGFzIGdQVFAgc3VwcG9ydCBhY3RpdmUgaW4NCj4gY29uZmlnIG1vZGUgKi8N
Cj4gPiArCXVuc2lnbmVkIG5jX3F1ZXVlOjE7CQkvKiBBVkItRE1BQyBoYXMgTkMgcXVldWUgKi8N
Cj4gDQo+ICAgIFJhdGhlciAicXVldWVzIiBhcyB0aGVyZSBhcmUgUlggYW5kIFRYIE5DIHF1ZXVl
cywgbm8/DQoNCkl0IGhhcyBOQyBxdWV1ZSBvbiBib3RoIFJYIGFuZCBUWC4NCg0KSWYgbmVlZGVk
LCBJIGNhbiBzZW5kIGEgZm9sbG93IHVwIHBhdGNoIGFzIFJGQyB3aXRoIHRoZSBmb2xsb3dpbmcg
Y2hhbmdlcy4NCg0KdW5zaWduZWQgbmNfcXVldWU6MTsJCS8qIEFWQi1ETUFDIGhhcyBOQyBxdWV1
ZSBvbiBib3RoIFJYIGFuZCBUWCAgKi8NCg0Kb3IgDQoNCnVuc2lnbmVkIG5jX3F1ZXVlczoxOwkJ
LyogQVZCLURNQUMgaGFzIFJYIGFuZCBUWCBOQyBxdWV1ZXMgKi8NCg0KcGxlYXNlIGxldCBtZSBr
bm93Lg0KDQpSZWdhcmRzLA0KQmlqdQ0KDQo+IA0KPiBbLi4uXQ0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gaW5kZXggZGM3NjU0YWJmZTU1Li44
YmYxMzU4NmU5MGEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yYXZiX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2
Yl9tYWluLmMNCj4gWy4uLl0NCj4gPiBAQCAtMTY5OCwyOCArMTcxNywzOCBAQCBzdGF0aWMgc3Ry
dWN0IG5ldF9kZXZpY2Vfc3RhdHMNCj4gPiAqcmF2Yl9nZXRfc3RhdHMoc3RydWN0IG5ldF9kZXZp
Y2UgKm5kZXYpDQo+ID4NCj4gPiAgCW5zdGF0cyA9ICZuZGV2LT5zdGF0czsNCj4gPiAgCXN0YXRz
MCA9ICZwcml2LT5zdGF0c1tSQVZCX0JFXTsNCj4gPiAtCXN0YXRzMSA9ICZwcml2LT5zdGF0c1tS
QVZCX05DXTsNCj4gPg0KPiA+ICAJaWYgKGluZm8tPnR4X2NvdW50ZXJzKSB7DQo+ID4gIAkJbnN0
YXRzLT50eF9kcm9wcGVkICs9IHJhdmJfcmVhZChuZGV2LCBUUk9DUik7DQo+ID4gIAkJcmF2Yl93
cml0ZShuZGV2LCAwLCBUUk9DUik7CS8qICh3cml0ZSBjbGVhcikgKi8NCj4gPiAgCX0NCj4gPg0K
PiA+IC0JbnN0YXRzLT5yeF9wYWNrZXRzID0gc3RhdHMwLT5yeF9wYWNrZXRzICsgc3RhdHMxLT5y
eF9wYWNrZXRzOw0KPiA+IC0JbnN0YXRzLT50eF9wYWNrZXRzID0gc3RhdHMwLT50eF9wYWNrZXRz
ICsgc3RhdHMxLT50eF9wYWNrZXRzOw0KPiA+IC0JbnN0YXRzLT5yeF9ieXRlcyA9IHN0YXRzMC0+
cnhfYnl0ZXMgKyBzdGF0czEtPnJ4X2J5dGVzOw0KPiA+IC0JbnN0YXRzLT50eF9ieXRlcyA9IHN0
YXRzMC0+dHhfYnl0ZXMgKyBzdGF0czEtPnR4X2J5dGVzOw0KPiA+IC0JbnN0YXRzLT5tdWx0aWNh
c3QgPSBzdGF0czAtPm11bHRpY2FzdCArIHN0YXRzMS0+bXVsdGljYXN0Ow0KPiA+IC0JbnN0YXRz
LT5yeF9lcnJvcnMgPSBzdGF0czAtPnJ4X2Vycm9ycyArIHN0YXRzMS0+cnhfZXJyb3JzOw0KPiA+
IC0JbnN0YXRzLT5yeF9jcmNfZXJyb3JzID0gc3RhdHMwLT5yeF9jcmNfZXJyb3JzICsgc3RhdHMx
LQ0KPiA+cnhfY3JjX2Vycm9yczsNCj4gPiAtCW5zdGF0cy0+cnhfZnJhbWVfZXJyb3JzID0NCj4g
PiAtCQlzdGF0czAtPnJ4X2ZyYW1lX2Vycm9ycyArIHN0YXRzMS0+cnhfZnJhbWVfZXJyb3JzOw0K
PiA+IC0JbnN0YXRzLT5yeF9sZW5ndGhfZXJyb3JzID0NCj4gPiAtCQlzdGF0czAtPnJ4X2xlbmd0
aF9lcnJvcnMgKyBzdGF0czEtPnJ4X2xlbmd0aF9lcnJvcnM7DQo+ID4gLQluc3RhdHMtPnJ4X21p
c3NlZF9lcnJvcnMgPQ0KPiA+IC0JCXN0YXRzMC0+cnhfbWlzc2VkX2Vycm9ycyArIHN0YXRzMS0+
cnhfbWlzc2VkX2Vycm9yczsNCj4gPiAtCW5zdGF0cy0+cnhfb3Zlcl9lcnJvcnMgPQ0KPiA+IC0J
CXN0YXRzMC0+cnhfb3Zlcl9lcnJvcnMgKyBzdGF0czEtPnJ4X292ZXJfZXJyb3JzOw0KPiA+ICsJ
bnN0YXRzLT5yeF9wYWNrZXRzID0gc3RhdHMwLT5yeF9wYWNrZXRzOw0KPiA+ICsJbnN0YXRzLT50
eF9wYWNrZXRzID0gc3RhdHMwLT50eF9wYWNrZXRzOw0KPiA+ICsJbnN0YXRzLT5yeF9ieXRlcyA9
IHN0YXRzMC0+cnhfYnl0ZXM7DQo+ID4gKwluc3RhdHMtPnR4X2J5dGVzID0gc3RhdHMwLT50eF9i
eXRlczsNCj4gPiArCW5zdGF0cy0+bXVsdGljYXN0ID0gc3RhdHMwLT5tdWx0aWNhc3Q7DQo+ID4g
Kwluc3RhdHMtPnJ4X2Vycm9ycyA9IHN0YXRzMC0+cnhfZXJyb3JzOw0KPiA+ICsJbnN0YXRzLT5y
eF9jcmNfZXJyb3JzID0gc3RhdHMwLT5yeF9jcmNfZXJyb3JzOw0KPiA+ICsJbnN0YXRzLT5yeF9m
cmFtZV9lcnJvcnMgPSBzdGF0czAtPnJ4X2ZyYW1lX2Vycm9yczsNCj4gPiArCW5zdGF0cy0+cnhf
bGVuZ3RoX2Vycm9ycyA9IHN0YXRzMC0+cnhfbGVuZ3RoX2Vycm9yczsNCj4gPiArCW5zdGF0cy0+
cnhfbWlzc2VkX2Vycm9ycyA9IHN0YXRzMC0+cnhfbWlzc2VkX2Vycm9yczsNCj4gPiArCW5zdGF0
cy0+cnhfb3Zlcl9lcnJvcnMgPSBzdGF0czAtPnJ4X292ZXJfZXJyb3JzOw0KPiA+ICsJaWYgKGlu
Zm8tPm5jX3F1ZXVlKSB7DQo+ID4gKwkJc3RhdHMxID0gJnByaXYtPnN0YXRzW1JBVkJfTkNdOw0K
PiA+ICsNCj4gPiArCQluc3RhdHMtPnJ4X3BhY2tldHMgKz0gc3RhdHMxLT5yeF9wYWNrZXRzOw0K
PiA+ICsJCW5zdGF0cy0+dHhfcGFja2V0cyArPSBzdGF0czEtPnR4X3BhY2tldHM7DQo+ID4gKwkJ
bnN0YXRzLT5yeF9ieXRlcyArPSBzdGF0czEtPnJ4X2J5dGVzOw0KPiA+ICsJCW5zdGF0cy0+dHhf
Ynl0ZXMgKz0gc3RhdHMxLT50eF9ieXRlczsNCj4gPiArCQluc3RhdHMtPm11bHRpY2FzdCArPSBz
dGF0czEtPm11bHRpY2FzdDsNCj4gPiArCQluc3RhdHMtPnJ4X2Vycm9ycyArPSBzdGF0czEtPnJ4
X2Vycm9yczsNCj4gPiArCQluc3RhdHMtPnJ4X2NyY19lcnJvcnMgKz0gc3RhdHMxLT5yeF9jcmNf
ZXJyb3JzOw0KPiA+ICsJCW5zdGF0cy0+cnhfZnJhbWVfZXJyb3JzICs9IHN0YXRzMS0+cnhfZnJh
bWVfZXJyb3JzOw0KPiA+ICsJCW5zdGF0cy0+cnhfbGVuZ3RoX2Vycm9ycyArPSBzdGF0czEtPnJ4
X2xlbmd0aF9lcnJvcnM7DQo+ID4gKwkJbnN0YXRzLT5yeF9taXNzZWRfZXJyb3JzICs9IHN0YXRz
MS0+cnhfbWlzc2VkX2Vycm9yczsNCj4gPiArCQluc3RhdHMtPnJ4X292ZXJfZXJyb3JzICs9IHN0
YXRzMS0+cnhfb3Zlcl9lcnJvcnM7DQo+ID4gKwl9DQo+IA0KPiAgICBHb29kISA6LSkNCj4gDQo+
IFsuLi5dDQo+IA0KPiBNQlIsIFNlcmdleQ0K
