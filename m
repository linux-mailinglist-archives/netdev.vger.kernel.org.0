Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA25424CE2
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 07:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbhJGFvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 01:51:10 -0400
Received: from mail-eopbgr1400122.outbound.protection.outlook.com ([40.107.140.122]:11282
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229766AbhJGFvJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 01:51:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bHzpQChRzS/4bs8GflxRjecCT6DvsA7WCBezR+v2NKgqKPP2PMzVbnrcTA2oQF/IVUWXMpr9B2lDrK0QPOqN7BT7F+yVXIEivTDFGd8UP36+5VQEtrqAnsZW8iPA1ZWB3ZdlGhuHrTNuLLbNGzJVG4zMm6CQ5KPXf5Bza4FbtxG0sLv4u+KwCga1Jbl6fHoBMVGcELx76HFriJK1VXfzXtQqo3XcBKx5pzHli9YD81R68tcUP5w0KYGqpBKfFOzYE73lVINJ1cdGIbfFS/miMuuDcOHuOcytUsDxK6tRYD04/OWY8RtENoMO0P+9P++Rm12iWwj0hI7omahxoFhmsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypIOO9Ed3GnMiLAL9B8Ql+STaTviiZg827Q5344l21M=;
 b=M7kXiaJ+/V1bxxgwvWX+zE/9uObBWj84Btn5W31Y8I0WRl9mQ6ABxNBZSI9WIkWblYoIEE7JfGb4m76M/ukQ8VSeZoxQayldQGpy4uq8ktLBHsgP5X5MhzkZuUxU3R4FzYq9JaNBvfsQu3p+6sOEt2Xnz/f+4Cxfx2sf2Mg1mflDG3V0s0RUCRJLVxVtTAvQ9yAalJjHdCKFsrWWcNvSwx2Cl4hJq8jOh60jeftCvy3mEzJQYjUClXoENPgluTs5tG31wrUXO1rfDGVqBJlnqia2NvHaPtGLjb7uIP222UxOKm1Gk4QezOzeO21liQkxvZ3kYVhso1ZNQxaRfiVOgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypIOO9Ed3GnMiLAL9B8Ql+STaTviiZg827Q5344l21M=;
 b=UacTDNIodEZNHqjp17N/K5+ZYsz1wFQb/09HycC6FTYBlIohuskOjaFEkI7SuMNtWP5TGaClQofha2E/eOJhQgGOx4NC6g84zacBKZyuGr6uAxNFhOE6DLBDp5a+0nT5AD9Jss6iVlYP20iFYh0HhYm/oIro8PphBTlSJgZ1nhM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2802.jpnprd01.prod.outlook.com (2603:1096:603:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Thu, 7 Oct
 2021 05:49:10 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.018; Thu, 7 Oct 2021
 05:49:10 +0000
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
Subject: RE: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
Thread-Topic: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
Thread-Index: AQHXudknyVYpSr19EUOWd3E+ko3swavGX+aAgAAJbzCAAAV1gIAAlePw
Date:   Thu, 7 Oct 2021 05:49:09 +0000
Message-ID: <OS0PR01MB5922239A85405F807AE3C79A86B19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-8-biju.das.jz@bp.renesas.com>
 <63592646-7547-1a81-e6c3-5bac413cb94a@omp.ru>
 <OS0PR01MB592295BD59F39001AC63FD3886B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <7c31964b-8cde-50c5-d686-939b7c5bd7f0@omp.ru>
In-Reply-To: <7c31964b-8cde-50c5-d686-939b7c5bd7f0@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5419cb1e-57f2-4dcb-9eca-08d989562f43
x-ms-traffictypediagnostic: OSAPR01MB2802:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB28027BFC0386125E0143E7DE86B19@OSAPR01MB2802.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VxUDyczJ5n89WMESm4aEGgLNemOr+6lqXeLhRorfP14gWxjX+3L5HMRPJN+RjwOoPymbyM9xloAVGiMZSTGRbCyGBfz2bUiWQO1H0KNOoJ4A4EAjX0apRC2rUdBcvw5iI7gCt2bKkjSNXfbLtvIRtlR+yo2ZouQMmVnpUE03vRlZVgCCSrTAi0RAUm2CY3Q69eC/3MedqoPyNSlp+d8hdhfT9tc0yMlxJdAGTGTDYFOb6fVsxp8jq3G3rgBGNycx08q63XMVYJiHyqEgH5cIyEP8HiCw4nhYdPvB81/kqX2TMfsJHKg523gY/4ZIbnr5kkR2YJfACwLxnfnXOi2MQWoKsC7qYjVOwu+Lt1v8hGfWphQAaiDNto/DEPvReTvFHeQV7YMLe60Hs4qwJpGwsIApu0+ngknQkhg5HA+AfaEgXmF0q/1mfUe+meBCHMjOLZrB7acmK7Sb0jdwElmP4I9kWinoW3zdqOHR9SOinkkbypkV+ELCHr+cerwFUs96TtRvmiQBQQv7LKMrrQzbld63xPzuMzQNJjGMrVizgngrq1TIsMBcgICMsJUHCm632HVnV/whXLDyVr8cssOqcppFZt9zY0ZN+6mcvQZj7xLjNYr2JeYvfRoxdnatcVpuY5Q1Df5Zxj4AoolyblVfA7yVonCswhjTspMo8uBIB30v83VycZSYlGd2pkGEfCFUD6+9qfWXaGTUx7gSyHBkqsARVmcJor/E42UnD1Ofzs7i8P+fOrdmgGIBsEsUkIYTnyH3730lpQfJWFgQNGOwOW7hSq2sqGD9P+HP+Csn2yQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(2906002)(38100700002)(107886003)(7696005)(53546011)(26005)(86362001)(6506007)(122000001)(966005)(8936002)(186003)(9686003)(66476007)(54906003)(316002)(5660300002)(71200400001)(52536014)(7416002)(8676002)(33656002)(83380400001)(38070700005)(4326008)(66446008)(66946007)(76116006)(66556008)(64756008)(55016002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGJQQW52OEhwY3dvK2VvU3QvdVUrTkdjUTkzc0VrbkdmN2dhT0VSeWZxK2d4?=
 =?utf-8?B?UnZVQ1lNTVVtWVZHVTdZczVrY0dZVVpoRmljUGFnL0dPcXBObVROV2tiWnZr?=
 =?utf-8?B?Y2R2QmVVV2UzSUFOTVVuSHIwWDMwQkRGa21LOTQ3U1R1UC9leklnMzIxTTVV?=
 =?utf-8?B?VGlnMEpqZWkxQVFMRW9ZTUJ3M3M5VTFMQitxSWpHY2JxZTYxVmFPMUlCalpa?=
 =?utf-8?B?eDVJZnlLV2lzVm9nMTA2Z2dtbnVRRHVDalhIR2FoVXpJV1dZeGYzdmpIVlhX?=
 =?utf-8?B?b1M4dHVML2JjZVlPTlRXaXVlK0VsTGR1TEp0VExKSkQrM2ZXVHFZb2R3VWV1?=
 =?utf-8?B?KzZjZU1KVmJ4YlZmKzBHZWZPcmUzaExQV2RoK3JUL3lGRVRsR1Z0dFNqRWFO?=
 =?utf-8?B?bTMreVRtZGl6d2FRSlNqQjNRdnA5eG55a3hYTjMzMUdzcUx3NFpLeHJ3OG1n?=
 =?utf-8?B?S3pzZTUzTGFCdTkwZkdSemRyVFNKVytocjZWZDZuQTJWcGtYTzdsamR3dk0w?=
 =?utf-8?B?cGhHN00ydnU5SHNwbzVpcVBsanJlcnZoR0swb1VmR2FVMFVmbkNkNDRHU1V2?=
 =?utf-8?B?MXd0T3RxS3hMN3NiR3JxK25LOWl0LzcvUDUyZkhvZkpKL2tUQ2NFb1NmT2Ns?=
 =?utf-8?B?QkJ2dWpPT0RBcndpNC9yNDFHVkdQRTMvaUtwUjBZUGF6eW9uVnlWdDAwRU1h?=
 =?utf-8?B?ajZqdGR0bEFPTThZQlR2dGhTRXNRakNDLzRoQzRabXVUKzFOYlRZaS9nWG5t?=
 =?utf-8?B?N0h2eUN3aHE1NXZ2Q3JGVkxvQTE1ODRNQkhxbDBLNXZMMERhMDN3ZmpQS01a?=
 =?utf-8?B?bTFVTEk1WHp4emdQcU8vcUFTRmE4S2tLQmRwVE52K2QvdHdtelZuMmw3MTJY?=
 =?utf-8?B?dkttL1dhVHFSZmtZc3lYdFVrMzlEV0xkTzZaKytEYThHQjdEdGZOdXZycGdr?=
 =?utf-8?B?dW5HR3phd25EWTZiMVpMK3kxanhyYmtBQjBUS2RNa2NCRGZYd09iQ1dxYnN3?=
 =?utf-8?B?MEliNjQ1VCszUXpaL3BCUUVUQTc0MUQ2eXYvZm1FMngxd1NaeXdkUEx3MmFn?=
 =?utf-8?B?dWVSbVdJQ1BiWVk5VWRhdkpjUCtSZHRGUEQxUC9hS0hyZnBKSVlZSU53U2ho?=
 =?utf-8?B?dkowMlJXZ3Jhd0czTE1zeFZMaXFiTEt2VjJhcE5KejRxTU9sNVJhOFZpRlpT?=
 =?utf-8?B?c3ZBbldiU3JqZjltWlYramg3RDJEY2tCSlBnR3NjRzlsYTg1OVBNTGhCaUtX?=
 =?utf-8?B?M3FFYnhOcjRhYVp2MGZ4UDlyLzZ3d3Vyek84Sk5lemdGSXdqYUVCNzlreVZP?=
 =?utf-8?B?TjJtNXFwNHdCaUlwM2k0U1BVT0YyOVB6dHJrRlhmUWVjTDlXUXBQVStkSDVE?=
 =?utf-8?B?aFIxTEdBSU5vbHY0eTJ4S21MTDNsbmZ2QzlxTkRFdXdKVzMzMDNjQTRnczMy?=
 =?utf-8?B?bzNaaHVNdi9jdkcvKzhHTmpURWVjbXk0SlZXaUlpMUYvcDdOM2NOUXYyWXMx?=
 =?utf-8?B?THphMXlzZEdYQWZ3WUl3cVo0Q1g2U0hSMmpZZkJnREJ3YkpTaldSMjZmS0VW?=
 =?utf-8?B?d2dUMTlWTHZKeUNXYmxMTUtTVCtLMC9vQ1NEK2VoVGRkNW9URmpacnA5Nmhj?=
 =?utf-8?B?U1VrVDlYdXhvZExmc3Yxd0tCY01wanZUYXJQUUpoK05VaUFJd3lKSk03OGVU?=
 =?utf-8?B?d3hOUGNNWis0VTBQaWVCNGNzZ2RnVmVXa3dLdm5WNDdpR0ZEVkZhajMyM053?=
 =?utf-8?Q?e5xpctchWN0wP0YG2k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5419cb1e-57f2-4dcb-9eca-08d989562f43
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 05:49:10.0260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W7Jq47bdsUMrp2xargFCz90BgKDGiMNuJHyktCm0EMZfOIFpU0tBfmdfm9pNwujSa/Vgm5DKC06R1PrKy/9xXXnHsElea+oVeI5eK3wCskE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2802
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDIDA3LzEyXSByYXZiOiBGaWxsdXAgcmF2
Yl9yeF9nYmV0aCgpIHN0dWINCj4gDQo+IE9uIDEwLzYvMjEgMTE6MjIgUE0sIEJpanUgRGFzIHdy
b3RlOg0KPiANCj4gWy4uLl0NCj4gPj4+IEZpbGx1cCByYXZiX3J4X2diZXRoKCkgZnVuY3Rpb24g
dG8gc3VwcG9ydCBSWi9HMkwuDQo+ID4+Pg0KPiA+Pj4gVGhpcyBwYXRjaCBhbHNvIHJlbmFtZXMg
cmF2Yl9yY2FyX3J4IHRvIHJhdmJfcnhfcmNhciB0byBiZQ0KPiA+Pj4gY29uc2lzdGVudCB3aXRo
IHRoZSBuYW1pbmcgY29udmVudGlvbiB1c2VkIGluIHNoX2V0aCBkcml2ZXIuDQo+ID4+Pg0KPiA+
Pj4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0K
PiA+Pj4gUmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFrYXINCj4gPj4+IDxwcmFiaGFrYXIubWFoYWRl
di1sYWQucmpAYnAucmVuZXNhcy5jb20+Wy4uLl0NCj4gPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+PiBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPj4+IGluZGV4IDM3MTY0YTk4MzE1Ni4uNDI1
NzNlYWM4MmI5IDEwMDY0NA0KPiA+Pj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yYXZiX21haW4uYw0KPiA+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiX21haW4uYw0KPiA+Pj4gQEAgLTcyMCw2ICs3MjAsMjMgQEAgc3RhdGljIHZvaWQgcmF2Yl9n
ZXRfdHhfdHN0YW1wKHN0cnVjdA0KPiA+Pj4gbmV0X2RldmljZQ0KPiA+PiAqbmRldikNCj4gPj4+
ICAJfQ0KPiA+Pj4gIH0NCj4gPj4+DQo+ID4+PiArc3RhdGljIHZvaWQgcmF2Yl9yeF9jc3VtX2di
ZXRoKHN0cnVjdCBza19idWZmICpza2IpIHsNCj4gPj4+ICsJdTggKmh3X2NzdW07DQo+ID4+PiAr
DQo+ID4+PiArCS8qIFRoZSBoYXJkd2FyZSBjaGVja3N1bSBpcyBjb250YWluZWQgaW4gc2l6ZW9m
KF9fc3VtMTYpICgyKSBieXRlcw0KPiA+Pj4gKwkgKiBhcHBlbmRlZCB0byBwYWNrZXQgZGF0YQ0K
PiA+Pj4gKwkgKi8NCj4gPj4+ICsJaWYgKHVubGlrZWx5KHNrYi0+bGVuIDwgc2l6ZW9mKF9fc3Vt
MTYpKSkNCj4gPj4+ICsJCXJldHVybjsNCj4gPj4+ICsJaHdfY3N1bSA9IHNrYl90YWlsX3BvaW50
ZXIoc2tiKSAtIHNpemVvZihfX3N1bTE2KTsNCj4gPj4NCj4gPj4gICAgTm90IDMyLWJpdD8gVGhl
IG1hbnVhbCBzYXlzIHRoZSBJUCBjaGVja3N1bSBpcyBzdG9yZWQgaW4gdGhlIGZpcnN0DQo+ID4+
IDIgYnl0ZXMuDQo+ID4NCj4gPiBJdCBpcyAxNiBiaXQuIEl0IGlzIG9uIGxhc3QgMiBieXRlcy4N
Cj4gDQo+ICAgIFNvIHlvdSdyZSBzYXlpbmcgdGhlIG1hbnVhbCBpcyB3cm9uZz8NCg0KSSBhbSBu
b3Qgc3VyZSB3aGljaCBtYW51YWwgeW91IGFyZSByZWZlcnJpbmcgaGVyZS4NCg0KSSBhbSByZWZl
cnJpbmcgdG8gUmV2LjEuMDAgU2VwLCAyMDIxIG9mIFJaL0cyTCBoYXJkd2FyZSBtYW51YWwgYW5k
DQpJIGhhdmUgc2hhcmVkIHRoZSBsaW5rWzFdIGZvciB5b3UgdG8gZG93bmxvYWQuIEhvcGUgeW91
IGFyZSByZWZlcnJpbmcgc2FtZSBtYW51YWwNCg0KDQpbMV0gaHR0cHM6Ly93d3cucmVuZXNhcy5j
b20vZG9jdW1lbnQvbWFoL3J6ZzJsLWdyb3VwLXJ6ZzJsYy1ncm91cC11c2Vycy1tYW51YWwtaGFy
ZHdhcmUtMD9sYW5ndWFnZT1lbiZyPTE0Njc5ODENCg0KUGxlYXNlIGNoZWNrIHRoZSBzZWN0aW9u
IDMwLjUuNi4xIGNoZWNrc3VtIGNhbGN1bGF0aW9uIGhhbmRsaW5nDQpBbmQgZmlndXJlIDMwLjI1
IHRoZSBmaWVsZCBvZiBjaGVja3N1bSBhdHRhY2hpbmcgZmllbGQNCg0KQWxzbyBzZWUgVGFibGUg
MzAuMTcgZm9yIGNoZWNrc3VtIHZhbHVlcyBmb3Igbm9uLWVycm9yIGNvbmRpdGlvbnMuDQoNClRD
UC9VRFAvSUNQTSBjaGVja3N1bSBpcyBhdCBsYXN0IDJieXRlcy4NCg0KPiANCj4gPj4NCj4gPj4+
ICsNCj4gPj4+ICsJaWYgKCpod19jc3VtID09IDApDQo+ID4+DQo+ID4+ICAgIFlvdSBvbmx5IGNo
ZWNrIHRoZSAxc3QgYnl0ZSwgbm90IHRoZSBmdWxsIGNoZWNrc3VtIQ0KPiA+DQo+ID4gQXMgSSBz
YWlkIGVhcmxpZXIsICIwIiB2YWx1ZSBvbiBsYXN0IDE2IGJpdCwgbWVhbnMgbm8gY2hlY2tzdW0g
ZXJyb3IuDQo+IA0KPiAgICBIb3cncyB0aGF0PyAnaHdfY3N1bScgaXMgZGVjbGFyZWQgYXMgJ3U4
IConIQ0KDQpJdCBpcyBteSBtaXN0YWtlLCB3aGljaCB3aWxsIGJlIHRha2VuIGNhcmUgaW4gdGhl
IG5leHQgcGF0Y2ggYnkgdXNpbmcgdTE2ICouDQoNCj4gDQo+ID4+PiArCQlza2ItPmlwX3N1bW1l
ZCA9IENIRUNLU1VNX1VOTkVDRVNTQVJZOw0KPiA+Pj4gKwllbHNlDQo+ID4+PiArCQlza2ItPmlw
X3N1bW1lZCA9IENIRUNLU1VNX05PTkU7DQo+ID4+DQo+ID4+ICAgU28gdGhlIFRDUC9VRFAvSUNN
UCBjaGVja3N1bXMgYXJlIG5vdCBkZWFsdCB3aXRoPyBXaHkgZW5hYmxlIHRoZW0NCj4gdGhlbj8N
Cj4gPg0KPiA+IElmIGxhc3QgMmJ5dGVzIGlzIHplcm8sIG1lYW5zIHRoZXJlIGlzIG5vIGNoZWNr
c3VtIGVycm9yIHcuci50bw0KPiBUQ1AvVURQL0lDTVAgY2hlY2tzdW1zLg0KPiANCj4gICAgV2h5
IGNoZWNrc3VtIHRoZW0gaW5kZXBlbmRlbnRseSB0aGVuPw0KDQpJdCBpcyBhIGhhcmR3YXJlIGZl
YXR1cmUuIA0KDQpSZWdhcmRzLA0KQmlqdQ0KDQo+IA0KPiA+IFJaL0cyTCBjaGVja3N1bSBwYXJ0
IGlzIGRpZmZlcmVudCBmcm9tIFItQ2FyIEdlbjMuIFRoZXJlIGlzIG5vIFRPRSBibG9jaw0KPiBh
dCBhbGwgZm9yIFItQ2FyIEdlbjMuDQo+ID4NCj4gPiBSZWdhcmRzLA0KPiA+IEJpanUNCj4gDQo+
IFsuLi5dDQo+IA0KPiBNQlIsIFNlcmdleQ0K
