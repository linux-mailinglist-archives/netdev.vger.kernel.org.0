Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD1A28EA72
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgJOBtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:49:21 -0400
Received: from mail-eopbgr1310114.outbound.protection.outlook.com ([40.107.131.114]:36814
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728240AbgJOBtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 21:49:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNFO7g2jeAmFJjUS1chwH8Dv8IVpzskcGZ5Yo9G/MXDXHNC8sbFNebQaja3Vq3Dqz2OlEl/O513L8pverc5HGqheo+vFZPx97nbSL5EcfOuiG0y6hEzgboHONFtsg5rMAxZ6H3dokrESXR9P/6WniMqbxNvC2ZtwJGyYOPpDY1oi8lNCgBlMiu0h6/uygTniZO+skVD2gNFVBmMthyWBoD6I5CP2PKtW3GWVYsH7+6zJM/G6gwgmYXpjuepjhPrasfF6kWjg+Bm2A30hL2Qk2B9oJ9FV/31ENx0Ygn4iFlL0iGVeYr34btCoB+lnyiQDVyBWMtw8XQTUNMBQAub2PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lN1nUFvNQ0WUq5hDeHDeKP0Rp8h4JIWBnomOpYgES8=;
 b=iUXnuf2FVfHj7JvLSk73uW2J6g/nAXK54WG4mPBNYbQ6XeKkfU6HpP0++Ci2LcSPfRb2byfgCUbHsMffUEkJUbCp0f6NoEzvNKLPOX0riRdc5NZ4idh7eyO0mS2aoDJhGIb5fnBrfHGGwgoxjwHfwr4NJMUjMfl7dGDrlxllev+jaym3rc4mxSp4LW3CYxm2SW4R53ywWWhIJ+TNM7L94HjxzI55lvFMfx1KUpJi9xfyCjhiAbdI/Dj6RbGy6a6VDEPWFtJ4iIKDYEtQ/ent8FYKESPQd5m7lO+5DYjs0qo0GMy2FaDLWMezm3yD3Vd9UYQWYbYFpmPYJTTOhlawTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
Received: from PS1PR0601MB1849.apcprd06.prod.outlook.com (2603:1096:803:6::17)
 by PSAPR06MB3960.apcprd06.prod.outlook.com (2603:1096:301:3a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Thu, 15 Oct
 2020 01:49:14 +0000
Received: from PS1PR0601MB1849.apcprd06.prod.outlook.com
 ([fe80::31d5:24c7:7ac6:a5cc]) by PS1PR0601MB1849.apcprd06.prod.outlook.com
 ([fe80::31d5:24c7:7ac6:a5cc%7]) with mapi id 15.20.3477.022; Thu, 15 Oct 2020
 01:49:14 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Joel Stanley <joel@jms.id.au>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Subject: RE: [PATCH 1/1] net: ftgmac100: Fix Aspeed ast2600 TX hang issue
Thread-Topic: [PATCH 1/1] net: ftgmac100: Fix Aspeed ast2600 TX hang issue
Thread-Index: AQHWofAzDvWchifNuUyQtsmFJfPVT6mWpi2AgAAOHMCAAPs9AIAALjdQ
Date:   Thu, 15 Oct 2020 01:49:14 +0000
Message-ID: <PS1PR0601MB184990423661220EACDBF4BB9C020@PS1PR0601MB1849.apcprd06.prod.outlook.com>
References: <20201014060632.16085-1-dylan_hung@aspeedtech.com>
 <20201014060632.16085-2-dylan_hung@aspeedtech.com>
 <CACPK8Xe_O44BUaPCEm2j3ZN+d4q6JbjEttLsiCLbWF6GnaqSPg@mail.gmail.com>
 <PS1PR0601MB1849DAC59EDA6A9DB62B4EE09C050@PS1PR0601MB1849.apcprd06.prod.outlook.com>
 <CACPK8Xd_DH+VeaPmXK2b5FXbrOpg_NmT_R4ENzY-=uNo=6HcyQ@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: jms.id.au; dkim=none (message not signed)
 header.d=none;jms.id.au; dmarc=none action=none header.from=aspeedtech.com;
x-originating-ip: [211.20.114.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b8b95b3-fb3a-40a5-f671-08d870ac851e
x-ms-traffictypediagnostic: PSAPR06MB3960:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PSAPR06MB39606B643A45B613E874AB4F9C020@PSAPR06MB3960.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AcrsQ+Hv4nK59dOnWAj8nETeb37Wxyvso+/QtNTl9gykY2TR9Byj8qnvbYLhqY/qM1KtVaQDIrGbieW/mWgvXzcAN5VkRAPeVZNImeAszyLv5v+P87+xOgeaKdQqPMLlVJxa83RcnS3CVE6AM8X49O4FjBeyMUi3wzS07r754pKss9M6NYXrfnSN1c7rtQaPV+SVn94HlaJ4kd1xyWlBJrr1bQK9TS6uWZhzvkvPxI5hacFDD8ronIYw6yQj7rvmzAFU6L70w6Mm8Rynl+6eqwN6doqsrkHuFIvOZCDVL2YoAiG6ekG2fdDmgKsgnawqDoFNC5L8evFxZDgEqls47Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PR0601MB1849.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39840400004)(366004)(136003)(346002)(376002)(478600001)(83380400001)(5660300002)(4326008)(107886003)(9686003)(86362001)(52536014)(2906002)(186003)(33656002)(26005)(8676002)(8936002)(6506007)(66946007)(71200400001)(64756008)(66476007)(66446008)(66556008)(54906003)(6916009)(316002)(55016002)(7696005)(91956017)(76116006)(55236004)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MrDg3I8J8HcxtcpxKuH+Kw+aguCGwX71mlBeuHIZ5+cwTIvCnt4sRjYobj4MuUn2ytL3Jv+v0iO78B2sK7+Sv9/6XwvI7EJCNgeuo5mBhf+wNMf7+ws+wP7II9sGan7CVUj4HKBUWSCHzR+1p2RW46aqZPfp7BfGxGVosKnID8vA80Ooq/Yc7IOCYhP30xioZUzvAvX04Nvk8NTTXWw2kcf9FQWqX3KlzSardXo2/xEXBKWbBXSkq70tgkRh3p7gJ17pWNGdHtX13I2uqXk0olnZ80zYGmNNkbJzTA7KQaB2zNpEHgXTlqB3s62esRDDN8AYdiOaTwrTuZ39u7dRnZMQjoJJurta6L9LUf/9C6CwiEBO48Hw0HaGZPzlDBUhRBMowMEmOKHw8AFCAhvdPD5gpdLdk1j16NOgwj9Udw8pIsKOw3cKoCn9eoEVfaTeuEws37k02les8OnvMowCn2ow+usJlIVBqZMrbYN34HPsas5vApWHnL1jGJEvPzq+gReTC+bFuib1XnkoWNmtF1CJj5cyqfbIrDf4oO9bS/23Fi01dVNAr/uuLqTKoQW8bkpzrEVlhM/saoc/nvXIdg0sonPmdaqMMgi+FkLvFjm79cDBwWCVFF21BCLUZhfufKwjntJc5h/gSrRWCNRokA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <03335D2BB8C33F4D84DD7CAE4019974A@apcprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PS1PR0601MB1849.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b8b95b3-fb3a-40a5-f671-08d870ac851e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 01:49:14.2180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rEnSB6qrfa/Riy1iA9tgcgzW/f+/cvMmkmzXGBW7uIQb7dNqUFhkFVx9wxCVIr3QUf998D+TxoApNthwkg0dpjiC4AqUVlzAbbNm6xQ8Lx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR06MB3960
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2VsIFN0YW5sZXkgW21haWx0
bzpqb2VsQGptcy5pZC5hdV0NCj4gU2VudDogVGh1cnNkYXksIE9jdG9iZXIgMTUsIDIwMjAgNjoz
MSBBTQ0KPiBUbzogRHlsYW4gSHVuZyA8ZHlsYW5faHVuZ0Bhc3BlZWR0ZWNoLmNvbT4NCj4gQ2M6
IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraQ0K
PiA8a3ViYUBrZXJuZWwub3JnPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgTGludXggS2VybmVs
IE1haWxpbmcgTGlzdA0KPiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IFBvLVl1IENo
dWFuZyA8cmF0YmVydEBmYXJhZGF5LXRlY2guY29tPjsNCj4gbGludXgtYXNwZWVkIDxsaW51eC1h
c3BlZWRAbGlzdHMub3psYWJzLm9yZz47IE9wZW5CTUMgTWFpbGxpc3QNCj4gPG9wZW5ibWNAbGlz
dHMub3psYWJzLm9yZz47IEJNQy1TVyA8Qk1DLVNXQGFzcGVlZHRlY2guY29tPg0KPiBTdWJqZWN0
OiBSZTogW1BBVENIIDEvMV0gbmV0OiBmdGdtYWMxMDA6IEZpeCBBc3BlZWQgYXN0MjYwMCBUWCBo
YW5nIGlzc3VlDQo+IA0KPiBPbiBXZWQsIDE0IE9jdCAyMDIwIGF0IDEzOjMyLCBEeWxhbiBIdW5n
IDxkeWxhbl9odW5nQGFzcGVlZHRlY2guY29tPg0KPiB3cm90ZToNCj4gPiA+ID4gVGhlIG5ldyBI
VyBhcmJpdHJhdGlvbiBmZWF0dXJlIG9uIEFzcGVlZCBhc3QyNjAwIHdpbGwgY2F1c2UgTUFDIFRY
DQo+ID4gPiA+IHRvIGhhbmcgd2hlbiBoYW5kbGluZyBzY2F0dGVyLWdhdGhlciBETUEuICBEaXNh
YmxlIHRoZSBwcm9ibGVtYXRpYw0KPiA+ID4gPiBmZWF0dXJlIGJ5IHNldHRpbmcgTUFDIHJlZ2lz
dGVyIDB4NTggYml0MjggYW5kIGJpdDI3Lg0KPiA+ID4NCj4gPiA+IEhpIER5bGFuLA0KPiA+ID4N
Cj4gPiA+IFdoYXQgYXJlIHRoZSBzeW1wdG9tcyBvZiB0aGlzIGlzc3VlPyBXZSBhcmUgc2VlaW5n
IHRoaXMgb24gb3VyIHN5c3RlbXM6DQo+ID4gPg0KPiA+ID4gWzI5Mzc2LjA5MDYzN10gV0FSTklO
RzogQ1BVOiAwIFBJRDogOSBhdCBuZXQvc2NoZWQvc2NoX2dlbmVyaWMuYzo0NDINCj4gPiA+IGRl
dl93YXRjaGRvZysweDJmMC8weDJmNA0KPiA+ID4gWzI5Mzc2LjA5OTg5OF0gTkVUREVWIFdBVENI
RE9HOiBldGgwIChmdGdtYWMxMDApOiB0cmFuc21pdCBxdWV1ZSAwDQo+ID4gPiB0aW1lZCBvdXQN
Cj4gPiA+DQo+ID4NCj4gPiBNYXkgSSBrbm93IHlvdXIgc29jIHZlcnNpb24/IFRoaXMgaXNzdWUg
aGFwcGVucyBvbiBhc3QyNjAwIHZlcnNpb24gQTEuDQo+IFRoZSByZWdpc3RlcnMgdG8gZml4IHRo
aXMgaXNzdWUgYXJlIG1lYW5pbmdsZXNzL3Jlc2VydmVkIG9uIEEwIGNoaXAsIHNvIGl0IGlzDQo+
IG9rYXkgdG8gc2V0IHRoZW0gb24gZWl0aGVyIEEwIG9yIEExLg0KPiANCj4gV2UgYXJlIHJ1bm5p
bmcgdGhlIEExLiBBbGwgb2Ygb3VyIEEwIHBhcnRzIGhhdmUgYmVlbiByZXBsYWNlZCB3aXRoIEEx
Lg0KPiANCj4gPiBJIHdhcyBlbmNvdW50ZXJpbmcgdGhpcyBpc3N1ZSB3aGVuIEkgd2FzIHJ1bm5p
bmcgdGhlIGlwZXJmIFRYIHRlc3QuICBUaGUNCj4gc3ltcHRvbSBpcyB0aGUgVFggZGVzY3JpcHRv
cnMgYXJlIGNvbnN1bWVkLCBidXQgbm8gY29tcGxldGUgcGFja2V0IGlzIHNlbnQNCj4gb3V0Lg0K
PiANCj4gV2hhdCBwYXJhbWV0ZXJzIGFyZSB5b3UgdXNpbmcgZm9yIGlwZXJmPyBJIGRpZCBhIGxv
dCBvZiB0ZXN0aW5nIHdpdGgNCj4gaXBlcmYzIChhbmQgc3RyZXNzLW5nIHJ1bm5pbmcgYXQgdGhl
IHNhbWUgdGltZSkgYW5kIGNvdWxkbid0IHJlcHJvZHVjZSB0aGUNCj4gZXJyb3IuDQo+IA0KDQpJ
IHNpbXBseSB1c2UgImlwZXJmIC1jIDxzZXJ2ZXIgaXA+IiBvbiBhc3QyNjAwLiAgSXQgaXMgdmVy
eSBlYXN5IHRvIHJlcHJvZHVjZS4gSSBhcHBlbmQgdGhlIGxvZyBiZWxvdzoNCk5vdGljZWQgdGhh
dCB0aGlzIGlzc3VlIG9ubHkgaGFwcGVucyB3aGVuIEhXIHNjYXR0ZXItZ2F0aGVyIChORVRJRl9G
X1NHKSBpcyBvbi4NCg0KW0FTVCAvXSQgaXBlcmYzIC1jIDE5Mi4xNjguMTAwLjg5DQpDb25uZWN0
aW5nIHRvIGhvc3QgMTkyLjE2OC4xMDAuODksIHBvcnQgNTIwMQ0KWyAgNF0gbG9jYWwgMTkyLjE2
OC4xMDAuNDUgcG9ydCA0NTM0NiBjb25uZWN0ZWQgdG8gMTkyLjE2OC4xMDAuODkgcG9ydCA1MjAx
DQpbIElEXSBJbnRlcnZhbCAgICAgICAgICAgVHJhbnNmZXIgICAgIEJhbmR3aWR0aCAgICAgICBS
ZXRyICBDd25kDQpbICA0XSAgIDAuMDAtMS4wMCAgIHNlYyAgNDQuOCBNQnl0ZXMgICAzNzUgTWJp
dHMvc2VjICAgIDIgICAxLjQzIEtCeXRlcw0KWyAgNF0gICAxLjAwLTIuMDAgICBzZWMgIDAuMDAg
Qnl0ZXMgIDAuMDAgYml0cy9zZWMgICAgMiAgIDEuNDMgS0J5dGVzDQpbICA0XSAgIDIuMDAtMy4w
MCAgIHNlYyAgMC4wMCBCeXRlcyAgMC4wMCBiaXRzL3NlYyAgICAwICAgMS40MyBLQnl0ZXMNClsg
IDRdICAgMy4wMC00LjAwICAgc2VjICAwLjAwIEJ5dGVzICAwLjAwIGJpdHMvc2VjICAgIDEgICAx
LjQzIEtCeXRlcw0KWyAgNF0gICA0LjAwLTUuMDAgICBzZWMgIDAuMDAgQnl0ZXMgIDAuMDAgYml0
cy9zZWMgICAgMCAgIDEuNDMgS0J5dGVzDQpeQ1sgIDRdICAgNS4wMC01Ljg4ICAgc2VjICAwLjAw
IEJ5dGVzICAwLjAwIGJpdHMvc2VjICAgIDAgICAxLjQzIEtCeXRlcw0KLSAtIC0gLSAtIC0gLSAt
IC0gLSAtIC0gLSAtIC0gLSAtIC0gLSAtIC0gLSAtIC0gLQ0KWyBJRF0gSW50ZXJ2YWwgICAgICAg
ICAgIFRyYW5zZmVyICAgICBCYW5kd2lkdGggICAgICAgUmV0cg0KWyAgNF0gICAwLjAwLTUuODgg
ICBzZWMgIDQ0LjggTUJ5dGVzICA2NC4wIE1iaXRzL3NlYyAgICA1ICAgICAgICAgICAgIHNlbmRl
cg0KWyAgNF0gICAwLjAwLTUuODggICBzZWMgIDAuMDAgQnl0ZXMgIDAuMDAgYml0cy9zZWMgICAg
ICAgICAgICAgICAgICByZWNlaXZlcg0KaXBlcmYzOiBpbnRlcnJ1cHQgLSB0aGUgY2xpZW50IGhh
cyB0ZXJtaW5hdGVkDQoNCj4gV2UgY291bGQgb25seSByZXByb2R1Y2UgaXQgd2hlbiBwZXJmb3Jt
aW5nIG90aGVyIGZ1bmN0aW9ucywgc3VjaCBhcw0KPiBkZWJ1Z2dpbmcvYm9vdGluZyB0aGUgaG9z
dCBwcm9jZXNzb3IuDQo+IA0KQ291bGQgaXQgYmUgYW5vdGhlciBpc3N1ZT8NCg0KPiA+ID4gPiAr
LyoNCj4gPiA+ID4gKyAqIHRlc3QgbW9kZSBjb250cm9sIHJlZ2lzdGVyDQo+ID4gPiA+ICsgKi8N
Cj4gPiA+ID4gKyNkZWZpbmUgRlRHTUFDMTAwX1RNX1JRX1RYX1ZBTElEX0RJUyAoMSA8PCAyOCkg
I2RlZmluZQ0KPiA+ID4gPiArRlRHTUFDMTAwX1RNX1JRX1JSX0lETEVfUFJFViAoMSA8PCAyNykg
I2RlZmluZQ0KPiA+ID4gPiArRlRHTUFDMTAwX1RNX0RFRkFVTFQNCj4gPiA+IFwNCj4gPiA+ID4g
KyAgICAgICAoRlRHTUFDMTAwX1RNX1JRX1RYX1ZBTElEX0RJUyB8DQo+ID4gPiBGVEdNQUMxMDBf
VE1fUlFfUlJfSURMRV9QUkVWKQ0KPiA+ID4NCj4gPiA+IFdpbGwgYXNwZWVkIGlzc3VlIGFuIHVw
ZGF0ZWQgZGF0YXNoZWV0IHdpdGggdGhpcyByZWdpc3RlciBkb2N1bWVudGVkPw0KPiANCj4gRGlk
IHlvdSBzZWUgdGhpcyBxdWVzdGlvbj8NCj4gDQpTb3JyeSwgSSBtaXNzZWQgdGhpcyBxdWVzdGlv
bi4gIEFzcGVlZCB3aWxsIHVwZGF0ZSB0aGUgZGF0YXNoZWV0IGFjY29yZGluZ2x5Lg0KDQo+IENo
ZWVycywNCj4gDQo+IEpvZWwNCg0K
