Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F2B46883E
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 00:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhLDXbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 18:31:25 -0500
Received: from mail-eopbgr60045.outbound.protection.outlook.com ([40.107.6.45]:55891
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233363AbhLDXbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 18:31:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cx1NNeiv7qj0YRRJYPfhBB03BMy933/JHFGnC2yTFEcigWuvowQEZ7BEK3RrfGkWOwYWWZtC9ANRR90bozzv6nckpgwTaAD4DOMFpGfzjZgfe684LNvQdx5R8uNhAzlUnYLPmMB8H/0MtvGF736/G1z4JoqU2bZFRTZBm4n4u2mi96OiUkUpmuAfIMpxSxoPfLn9ROaMDTHRsZoEHhQFYDk/7FSXoVXPrX6l9/o0iaSQW5fgaHOSZbhYAZwKO01eulxOlLqQ04d1ezoOwj2TvQq1G+oxCHsnFkcIW1ELVp8JUsKyaOetdNwoq6xqMFhJWZkQBsOnOIsQVh3ls4h9KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=19oS6HpgJZ3Gq5Fy5GQ2wKpNShsOXGz9wOjGknjSOg4=;
 b=FPBoIIFNw1cOEPD17VeqXppg7v67uChahzOQpDLfM4LaIxfh+xHwQ+Gk8yOLi+qDHJ2C5/AvP4JaFKjYlTtneG8+F2jslpzVC6jMRgOUspFQga0ygzyJQcjGFLm7XNnsrJ+Bp2E3TmCDPxdUTZtIC2rGd2VgUWjRb8JR6FZbIP5+C4IKWZ0LBxtX2JhhxAGzfYp3HvW+BIvlntPprpTrCkhIGWR2a0CZ/Jq+jFSlk6goNcGhn7UCTsNDkgEDXxXDsM2l3/wU+Pj/nfryxIFu7Ji8TJvU50lW6hUnSyNn63UlI9mA5H8so2aFOsHklRGOK0Ap0RE1lDwtuIMSShNuNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19oS6HpgJZ3Gq5Fy5GQ2wKpNShsOXGz9wOjGknjSOg4=;
 b=frNCcaVJooKRxSUyCp1851fOsGW8nwdRdqvpZPEzc7xDjCYGVz2NB9yBkKlbqSKW/23YkzjI75cus3yf7fCfrZ2w1a2SAehW7zHlDDO1w8eBXqGka9C0Wn3v59XFbM7Dh62SPa8mVDdVxVrTm4bdCc90VVjM6OAAlN8iUlaZ0R4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5853.eurprd04.prod.outlook.com (2603:10a6:803:e3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Sat, 4 Dec
 2021 23:27:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.021; Sat, 4 Dec 2021
 23:27:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?gb2312?B?QWx2aW4gqeCoomlwcmFnYQ==?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v2 net-next 3/7] net: dsa: hide dp->bridge_dev and
 dp->bridge_num behind helpers
Thread-Topic: [PATCH v2 net-next 3/7] net: dsa: hide dp->bridge_dev and
 dp->bridge_num behind helpers
Thread-Index: AQHX6Usz2R8jSmTmjUib+W7YKc8My6wi+oqA
Date:   Sat, 4 Dec 2021 23:27:56 +0000
Message-ID: <20211204232755.bgxo3x2jk6bf3voh@skbuf>
References: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
 <20211204201146.4088103-4-vladimir.oltean@nxp.com>
In-Reply-To: <20211204201146.4088103-4-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ffe8050e-f725-4a12-5ca0-08d9b77db3c3
x-ms-traffictypediagnostic: VI1PR04MB5853:
x-microsoft-antispam-prvs: <VI1PR04MB5853B26F02E366FE274B3455E06B9@VI1PR04MB5853.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: syECQfN4lsB/VBgGqv1acp3z2/qzrJehm4SpjLNh9qvUsn9g+OPpr/3tqtApAj5Ci/clZRS3jWNbaYArwADtNC9srfIA1GExLh/o4OZvzj6rgm7onV31SMqE6t2kK2RTyKDdKaHINsj1km1l4yv0VK5jJT9PSdtDe1o4rVdz77QdyvCa0RsK2epL676yFVo2/uh9KTWRW3NAuamoQZj4snlUrIOnwbgzy3Z880IgTqFqBweS+IiwuF8It+G24/pXH25tEsmmHk77N96I0ISrtEFADZNdbiKwy8r30h0rB7MLRwAijcQDGQ9x/D7oFVXUtcKrJ9UItWWIlSvNsC+4fIr6Kh6UU2LLAHhewCnTvdg3y5ebPqvjwv9omndOY+iBEh3gyPG+zBBWFk5xAsQfyMQuPGVGvm0twTlzzTW4MmJTxZ7BqCMAiUNsYYyjca2SJaQgiYkxben4lg5SJkvKmqKXTWzbdpbLDun30pe3SRXGXsglUG0gMtpdHZhBK6gqOtRq2nGbwv7iaE8lvCtyuNJ5MechiH936UozWCdbne44EdILUrJxF9nL6EAK6wEt0AfdzstQrV64xnyCA6VedqK8DnppDOFdEvE6KysHECmrSxvYxQUijAcPnqj1ENg6Xo9IIfxAJXwxloBXvVpw8sGsCRHmlbZjNxHoeGZQZQHlNk5F1cNe2EtWZg/zC7fJk4cqXN+WEBVGp5PDifltBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(71200400001)(38100700002)(2906002)(6486002)(316002)(1076003)(8936002)(26005)(6506007)(122000001)(8676002)(91956017)(66446008)(76116006)(6512007)(9686003)(33716001)(4326008)(6916009)(44832011)(7416002)(5660300002)(54906003)(66946007)(86362001)(508600001)(38070700005)(66476007)(186003)(66556008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Wi9HMGtzVUdYUU1YWmJFV2dnZWtNck40VE80YUZlREp1Y25TbitwMk5vN0p5?=
 =?gb2312?B?R01tY3J0MnFmQllNcGM0RDluTjl4Q0FqTUNzUFlVTUE4YzhyV1Q1V3gzNSt6?=
 =?gb2312?B?ajVMOHFnYXBmVUd0ZWVibHp3eHh2TzMxQXJUWHFTZWtLQUJOUFgwYmpwaFYx?=
 =?gb2312?B?N0h3S01yZmRuU0tDbTZrTjhEZ3d4ZWxDTHlDdGFEbUh0NFFRZGJxd2xpb3RU?=
 =?gb2312?B?VUVwNFlISEtwajA1OWlOU3p1Z1kvWTF2V2NHeGNqcmtBTU1DQkZUZUxtajJo?=
 =?gb2312?B?M28yVGVtNjJ2eXZqdjU1ZFpHT1FyZHBpYzQvOG9Danp0TWFnQy9GS240dGxt?=
 =?gb2312?B?RFdiL2t2amJiazBhS285WTJaQXBSRGx3UlRScGRtWk9TT1M0UnhweDV5T3gz?=
 =?gb2312?B?RHNpZ3A0Wk12K3F4cjZESGRjcW1zb0l5Y0ROZzRmK0FoUVd2eVRiSEJIelF6?=
 =?gb2312?B?bktKL2ZYeEhqSlRqYktNRllGN3RSUzVvODB1dEUrRjNoOVVSb3hUVjdDMDgy?=
 =?gb2312?B?K0pDb2pEWTkxZEptbG1Na2RPSm4wV2pmZ2w0aXF3YTRQSTZHSTkrZTZnODJX?=
 =?gb2312?B?RHZBQkJEN1hCeHlPdU5lZitTRUtxMkt5eTlld08vUFMvbXRlY2E0OE5FU0lB?=
 =?gb2312?B?eERwWXNRQ3JrUEU1dlNoK1l0dkRSdzBVdERHcEVTN0p5L1R5K0hJd2F2eGJR?=
 =?gb2312?B?eUZqR0VVMDhmVUhaL04yK3BtRkR0cmdLV3Y2aEhmN1FLcndQNTBDR1BlcUE1?=
 =?gb2312?B?eE5zZlJpYXFhcjhQeWJTck5rTUhCbzc1UklMK0VkSEdIelBzTjFvRFoxK1ZU?=
 =?gb2312?B?R0pEbGtFeStJOERRRXFVdTBpRmZLcnpmc2huNnNaS0dMd3AxaHZnOGFGMjhF?=
 =?gb2312?B?QVBKZGl4bTRkelVXN1E3V3plYTQ1RWFIVGZuSTRPSlJDOGVNR1IwY01idFFx?=
 =?gb2312?B?a25BZll1UEtxQ3l1T0NQMTQ3VS9BbFBFeEFMT3BlbEdKOENqWFlLb3Jlc0ta?=
 =?gb2312?B?RUMvbGpSaFY1aUp0QlY0ZEtVN1I5dHZ0bHJQZTZ5R2lWNGVObEF1cS9UaEhG?=
 =?gb2312?B?R1lXSlBhVkpkaGJZbWFxYnpIVlBnNnQzSU5va3pjZVd1OXUwVlB2SlhJdHhO?=
 =?gb2312?B?UHZ2cERHTXZnbVVWcFVJaldoUmRSLzJLa0FKMGMrcENPdUZYY3UzMm1FSCtQ?=
 =?gb2312?B?RFh5aDdheURlZjB3TklsK25iV2JIK2RKYitvTGZQSGVyLytGQ3oxV1d4eGJD?=
 =?gb2312?B?UkJVQi9BOWxQZm9yejhaVHVMdzVmcEFHejVEeE0vNXBEa1VvMU11a1piSFlO?=
 =?gb2312?B?SE82T0tNbDBhd01oK1ZnQXJlRFRaZ0FGbjVtTkxXZ2NseUpjRlBHWlpjT3FY?=
 =?gb2312?B?dmRFelVrRFhyR0lQMVloZEIzek1meStqekFtMWl3WnVSR2IwZi9DeVA2STE3?=
 =?gb2312?B?ZXdsR3RUQ3ZUcG4vMkFPRWYyYmVJUXpKR0QxS0tuTUtVM1FnNWM4SXJHdHlx?=
 =?gb2312?B?U3YvWm4zMlVKSUZIK2RjKzhVSDdvNWEyOHRibm1iTUc3M2dMR2tWeVN4Z2x5?=
 =?gb2312?B?Zk5WUmlML0ozVVhEUFZuYUFiZmJxN293eHE5QVQ4ZW5MUG5mWGFEejJxUExZ?=
 =?gb2312?B?OS9yN2JqSVJPZE5MQnBRMjhrS1l4OHJod2xjZXpxSUtTQWZ0Z21YRjZkZ0RM?=
 =?gb2312?B?aXVPUXQwY0VLaWhDK0c3QVhwdmExcW1JV3BhVm1xeWhYL3RtalJVbi9nZUxR?=
 =?gb2312?B?MFprSXBDZ09tR1YrYjkvVHBZSndWVWduOG03U241bkk3WkRmZFFKK1Zzcloz?=
 =?gb2312?B?UjFxSWtyQ20wckFaQXRsaWhhNVVPb1dvRURsaW9mQ0tlcjMrMklobTVRUVlV?=
 =?gb2312?B?MnRRbnljWjZhNmNMTFRDN2d1bm96bVVxandjREFYZmhjSXI4NnBsQTZodXdP?=
 =?gb2312?B?Yk1mblA1bVpXd0l3UEN0eFhXQURrMmVzUlovVW9sSHNpRDdMci9EWnRVeHA3?=
 =?gb2312?B?Y2JKUUFrMnFETE1TbGJCN2hEUXVaK1p5emxjOGVDV3I1M290UDVmeGdJVWtn?=
 =?gb2312?B?dXVFdnc0Zm5haDdOWXZSRVZ2dGp1ZVpGSDdkQ2R4QUpEOEdQRzZtTU1LTHFr?=
 =?gb2312?B?b214d0Z2Y1ZMdzk5alBXRUV3N1ByKzBvSHJORGJFWHd2TjJaRHJnR2tzeFNP?=
 =?gb2312?Q?5HAmlOloHEV8dzT4EQNfQjE=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <299D649DBF3BDA4F8EA4BF5065F8CC5B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe8050e-f725-4a12-5ca0-08d9b77db3c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 23:27:56.3418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t9k5Yex8NA4f+nPqjrTStVVgtHn4NrY0yJZsQvNHrKyfflwoGIS7METzLft3T+oMJlUkSJqkBXoMrpbZz/2DYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5853
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCBEZWMgMDQsIDIwMjEgYXQgMTA6MTE6NDJQTSArMDIwMCwgVmxhZGltaXIgT2x0ZWFu
IHdyb3RlOg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMg
Yi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2NoaXAuYw0KPiBpbmRleCBhODE4ZGYzNWIyMzku
LmM1ODNlY2U4M2IyNCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9j
aGlwLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMNCj4gQEAgLTE2
NDcsOCArMTY0NSwxMCBAQCBzdGF0aWMgaW50IG12ODhlNnh4eF9hdHVfbmV3KHN0cnVjdCBtdjg4
ZTZ4eHhfY2hpcCAqY2hpcCwgdTE2ICpmaWQpDQo+ICBzdGF0aWMgaW50IG12ODhlNnh4eF9wb3J0
X2NoZWNrX2h3X3ZsYW4oc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwNCj4gIAkJCQkJ
dTE2IHZpZCkNCj4gIHsNCj4gKwlzdHJ1Y3QgZHNhX3BvcnQgKmRwID0gZHNhX3RvX3BvcnQoZHMs
IHBvcnQpLCAqb3RoZXJfZHA7DQo+ICAJc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwID0gZHMt
PnByaXY7DQo+ICAJc3RydWN0IG12ODhlNnh4eF92dHVfZW50cnkgdmxhbjsNCj4gKwlzdHJ1Y3Qg
bmV0X2RldmljZSAqb3RoZXJfYnI7DQo+ICAJaW50IGksIGVycjsNCj4gIA0KPiAgCS8qIERTQSBh
bmQgQ1BVIHBvcnRzIGhhdmUgdG8gYmUgbWVtYmVycyBvZiBtdWx0aXBsZSB2bGFucyAqLw0KPiBA
QCAtMTY2MiwyNyArMTY2MiwzMCBAQCBzdGF0aWMgaW50IG12ODhlNnh4eF9wb3J0X2NoZWNrX2h3
X3ZsYW4oc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwNCj4gIAlpZiAoIXZsYW4udmFs
aWQpDQo+ICAJCXJldHVybiAwOw0KPiAgDQo+IC0JZm9yIChpID0gMDsgaSA8IG12ODhlNnh4eF9u
dW1fcG9ydHMoY2hpcCk7ICsraSkgew0KPiAtCQlpZiAoZHNhX2lzX2RzYV9wb3J0KGRzLCBpKSB8
fCBkc2FfaXNfY3B1X3BvcnQoZHMsIGkpKQ0KPiArCWxpc3RfZm9yX2VhY2hfZW50cnkob3RoZXJf
ZHAsICZkcy0+ZHN0LT5wb3J0cywgbGlzdCkgew0KPiArCQlpZiAob3RoZXJfZHAtPmRzICE9IGRz
KQ0KPiAgCQkJY29udGludWU7DQo+ICANCj4gLQkJaWYgKCFkc2FfdG9fcG9ydChkcywgaSktPnNs
YXZlKQ0KPiArCQlpZiAoZHNhX3BvcnRfaXNfZHNhKG90aGVyX2RwKSB8fCBkc2FfcG9ydF9pc19j
cHUob3RoZXJfZHApKQ0KPiArCQkJY29udGludWU7DQo+ICsNCj4gKwkJaWYgKCFvdGhlcl9kcC0+
c2xhdmUpDQo+ICAJCQljb250aW51ZTsNCj4gIA0KPiAgCQlpZiAodmxhbi5tZW1iZXJbaV0gPT0N
Cg0KU29tZSBiYWRseSByZWJhc2VkIGNoYW5nZXMgZnJvbSBzb21lIG90aGVyIHBhdGNoZXMgc251
Y2sgaW4gYW5kIG1hZGUgYQ0KbWVzcyBvdXQgb2YgdGhpcy4gSSByZW1vdmVkIHRoZSBwb3J0IGl0
ZXJhdGlvbiB1c2luZyAiaW50IGkiIGJ1dCBkaWQgbm90DQpyZW1vdmUgdGhhdCB2YXJpYWJsZSwg
YW5kIGl0IGlzIGFsc28gc3RpbGwgdXNlZC4uIHVuaW5pdGlhbGl6ZWQuIFdpbGwNCnNwbGl0IHRo
ZSBtdjg4ZTZ4eHggY29udmVyc2lvbiB0byBpdGVyYXRlIHVzaW5nIGRwIHRvIGEgc2VwYXJhdGUg
cGF0Y2guDQoNCj4gIAkJICAgIE1WODhFNlhYWF9HMV9WVFVfREFUQV9NRU1CRVJfVEFHX05PTl9N
RU1CRVIpDQo+ICAJCQljb250aW51ZTsNCj4gIA0KPiAtCQlpZiAoZHNhX3RvX3BvcnQoZHMsIGkp
LT5icmlkZ2VfZGV2ID09DQo+IC0JCSAgICBkc2FfdG9fcG9ydChkcywgcG9ydCktPmJyaWRnZV9k
ZXYpDQo+ICsJCW90aGVyX2JyID0gZHNhX3BvcnRfYnJpZGdlX2Rldl9nZXQob3RoZXJfZHApOw0K
PiArDQo+ICsJCWlmIChkc2FfcG9ydF9icmlkZ2Vfc2FtZShkcCwgb3RoZXJfZHApKQ0KPiAgCQkJ
YnJlYWs7IC8qIHNhbWUgYnJpZGdlLCBjaGVjayBuZXh0IFZMQU4gKi8NCj4gIA0KPiAtCQlpZiAo
IWRzYV90b19wb3J0KGRzLCBpKS0+YnJpZGdlX2RldikNCj4gKwkJaWYgKCFvdGhlcl9icikNCj4g
IAkJCWNvbnRpbnVlOw0KPiAgDQo+ICAJCWRldl9lcnIoZHMtPmRldiwgInAlZDogaHcgVkxBTiAl
ZCBhbHJlYWR5IHVzZWQgYnkgcG9ydCAlZCBpbiAlc1xuIiwNCj4gLQkJCXBvcnQsIHZsYW4udmlk
LCBpLA0KPiAtCQkJbmV0ZGV2X25hbWUoZHNhX3RvX3BvcnQoZHMsIGkpLT5icmlkZ2VfZGV2KSk7
DQo+ICsJCQlwb3J0LCB2bGFuLnZpZCwgaSwgbmV0ZGV2X25hbWUob3RoZXJfYnIpKTsNCj4gIAkJ
cmV0dXJuIC1FT1BOT1RTVVBQOw0KPiAgCX0=
