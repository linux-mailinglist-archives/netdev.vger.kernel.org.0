Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9713EF5AA
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 00:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbhHQWUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 18:20:02 -0400
Received: from mail-eopbgr80124.outbound.protection.outlook.com ([40.107.8.124]:10001
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229729AbhHQWUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 18:20:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDTt1N6FY3QymBBe1noPw3E4OhR5nncsFaLUkVqqZV0VeDHSVS0zHfx5F5SBegW1gUCQ0v+1fI+OnSZdvurCFj8pTCs6KJ1vxg6Tvih4DFU3LyrFjKPLwGndEAEEwvNg7rqmcooAup9pSgzfaIlKqT2mFuEaFJqksF5OI6bZvW3ExsTBuzRuT0jiJw7hsRDLe2ihks2n8LjGliD1NGQT5y1+EzQ4dhGHkItOh6BAU3UpTBVRwE0bc/sAnRz5VvNos7Oe/pGIfgY9l+f5/ahfefjZhbVktF64TlVYk4Zm050dFjYO9wKenlriqxcJ5Co7Fq3oJl3xcaorwrZQEWKedw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiOUpcfM32tRviowWAwbwU0BAMmbaoviT3UpAc64atw=;
 b=FUsNrp31DdYbOHAoMSWnfHf7RrWc6moINvkoXa4k6R1srbZX1JYfAd0Y3Vu2FMFvXW0MrojGUdjzZZ2+dSERfUX3iAytT7x0GS2IDtp8ke0Txx5xnukAHStu8TXIZWKOy3gPQHqSj9oijdfvTb7AM2AP7Ty5U3ug2UYKNpSZgGtxFC326+jPD2jlNzgFWa3fYPdpAsyzPmu2jj5YtBQTtVIoPpIHPi5EOM9KElERSUbPJuyOhXBXB/gWUOTF6+9bEgXwWeSO6QYZr98r1DO7T8ufwmE0B2GoAXam6XHkfJb2Bm0mcIvKMlOpzoA+7gW8PAmvtihi7kYfGklUVuTxdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiOUpcfM32tRviowWAwbwU0BAMmbaoviT3UpAc64atw=;
 b=tivlIe0mGnYMo33bvPNwDpTtDRp4UVJ+btLOMPERKkgat9ZSLXjR9vq51M3brfq0ngTlGeCYnP2ATWs+pic2022Mm6v7EbLq05fpVhGOLHeBpaVADuSrvYhtYVzsDs+N4QURAAUbS010+LDNtAY37x6bXKU4+xzGjqRZii8EcQI=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2489.eurprd03.prod.outlook.com (2603:10a6:3:6b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.20; Tue, 17 Aug 2021 22:19:24 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 22:19:24 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Thread-Topic: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Thread-Index: AQHXk3edAldLqW55BEm1kFydkTRTGqt4NdyAgAALEoCAAAP/gA==
Date:   Tue, 17 Aug 2021 22:19:24 +0000
Message-ID: <27140e44-1dfc-4166-9f57-1bbb1ca1dba9@bang-olufsen.dk>
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
 <YRwykZONaibo5KKe@lunn.ch>
In-Reply-To: <YRwykZONaibo5KKe@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f335979f-def8-42e9-a1f1-08d961cd11cf
x-ms-traffictypediagnostic: HE1PR0301MB2489:
x-microsoft-antispam-prvs: <HE1PR0301MB2489EF56DA0E540E1182BBD583FE9@HE1PR0301MB2489.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kh34bcTepG+dWX3MgAtbtH1+LibeqjlA9hHRFNnBfhQwCzGhYSG4E03L1O6rBfJ5Lhm1jcxuZ0bmjoPDA3SGP9zYdhnIZ9sY0Td6PucLnwbfDE8zG9kqFqZOZxEbGIgemgt6XdWRf4Tf/zxduXWQKLq9uYqXytqOciS/g6jvnwPKgzQLryuoH8NgTqU16fyc2W7b+uCg/EN/TnoxtHMxJ/26HY9FB8vyHUwBA0BiuthF2xd3j4doer5qmEVCKpmpd0rxyqfXDmQTxrU0YHOsVx49y+aA27+upi7i1PcirxspzmD5r8NYZe4dXOHuxptt/XVOUHx7PvNBCs9Cu2Oty6J2hI42p9x+TcfGtgbKoUui1y8Dv0F8XBE1U9aV2PCBzhJdppzfMxnl6YpmZGCfYvdRgOGtTBi4hzq/LxCzUuXOPUIgm/o9Zoqt7whKFl1gvYNMF8MSQ7t5ihjq9K0B7k9m87i6DPTYdGyfcCS8ewFfFyWMmSjk4tka51v8NviPVTHHoJpLNCLFZu8QyR/Mv9HEBcbHYjCZ4XPrukLCtRfk1nL5vOUaJyZxZ5E+53FNlDwQGcbUFMcCF/BH2hjdqw32ULB09S4UbpVuM6skL/it37fsw/a2JJv2FMs1MBxS7jzB5qsaaxRb6T9+BvM9N98dMAhTCTx9aMotQWso5U8rwoJ+YEZ9YeBpgzB9YXsFRk+IUjiafhCThZgupWmSMzMQCt+OKv+Y04Zan/BgRKJ7RzAAnSE+UbwFlidk5hiBoWXWqe1kQbiyPPm6bDkKIM65OSHvn129RW+S2K/Vfp4o9ErpcFSoLiClR3wtQDNthNKbo8uGDGczjR4CxNMs2XHpDc5Btv2J0TuVhAk9I2c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39830400003)(376002)(346002)(136003)(366004)(66946007)(316002)(66476007)(66556008)(64756008)(66446008)(54906003)(91956017)(76116006)(85182001)(8676002)(38070700005)(2906002)(38100700002)(4326008)(6512007)(6916009)(6486002)(478600001)(26005)(71200400001)(2616005)(6506007)(53546011)(186003)(7416002)(85202003)(8936002)(8976002)(31686004)(86362001)(31696002)(966005)(122000001)(5660300002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTJnRXFSWHl5dlZmVGxPZ3Rpa1U5dnRkdHdWRHlaRStzZ20wdzNITmlESi9r?=
 =?utf-8?B?QnljaDI3OWNFbm1ubzBVWkhmNUFYSWFzZU5iRmFIL28vQjRTOTlua2RSeFZ4?=
 =?utf-8?B?RUM1MCtJaVNUVWw2Qk9GTndiT2pWU3pEbGRGenFxajFOSmRuSzUzTUFkVlVD?=
 =?utf-8?B?ZWl3SGh6WTNHMVBJS0xRUWtRZnJ2MkV1MWs4dmppWTNwOFVrZW5ha1V3eThC?=
 =?utf-8?B?ck5xUDRhdlJhMjBNTFBwQldJRy9VR1pFWTRsaTZ1b2gyNnVJRnl0cTNkKy90?=
 =?utf-8?B?alhEUkYwMjV3V3BlSW5naUZBNjdyMVNkZjFXSjl3R0c5OUFDek92ZnhwR3ZO?=
 =?utf-8?B?TmFJM0YwUmY1N3BMR000Y3N0emRzekczNENyZml2dHd6cEhXc2R2dngwV290?=
 =?utf-8?B?NCsxMWZUVklxWmVQS1FMTVJTN0dqWm5iUWdNeFRaMFd6bjJJanBjMUYzWEQv?=
 =?utf-8?B?bGRFKzdXSDU2djFzY3g4S3pSMVJPYlJpcjE2MWhiOEF3ZGZobjJpSDdhMWhm?=
 =?utf-8?B?Z09VQzgxaDdqNEpkakFpRGx4d0RYN3JPSU9GMUVkRnJUeS9ZZS9hYlkxcHVU?=
 =?utf-8?B?a1RUQWRQUzVRVlB1NkdyekhpK2J4SVViendsampFYktZS2puT1Z3Ly93YTBt?=
 =?utf-8?B?MnY3Slg3WGZ6WmtCTmp4bVdoRlV4SE9uVmVWWk8yT2Y0dlpGb0U3T1BoVlAw?=
 =?utf-8?B?VFgyQTlGMkVpeU5aMmJSemcraTh5azU1d1I4ckV2NWYyWFg2TGdNRldma09m?=
 =?utf-8?B?dGpVTDNGMHNoQVdzZm5aUTdrNnkrV0hxZXF4eWpJMkdESzZNZ0N6aGQ5WFJl?=
 =?utf-8?B?SDJzb2oyakxENjJQVThpbzRrczBQVk1PV0s2azdzVk1LcGdrVXpFYzdNdElx?=
 =?utf-8?B?Z3NMNzExR3ZjZ25qdGtZRWJyR1kzOFplcTd6Y2F4UWtBZi81Y0RQbDRzYlNs?=
 =?utf-8?B?N1lBQXd3Zm85ODFacElwZndUVis3Tkt5WWR0SFBYb25sU3BXbmVka2FFODVm?=
 =?utf-8?B?a1lqMExvZk10VFg2eVdIRDZJTC9GNktkb1VlNWpvODdBREw4ajlWYlRpeGtx?=
 =?utf-8?B?NDVqV3I3THBVZDNmS0ZRMFI4NlNZVzVRd2lvd2FGSTRjZis2bjNkS2IzN293?=
 =?utf-8?B?TEZPWFZiVjhQcDYyQ2lBZW04V1J2eUxhc1I0dy9lT2JiZEhFTkg0TWNCQzVE?=
 =?utf-8?B?c3pKSVdWL1ZJRWMwdXN1bXNqS3hFaFFZaDcyQnlyQlliUWIwdmhHcmRMUXNK?=
 =?utf-8?B?Z3VNajRWUGNnY0k2S0YySlFNMmZiQjBGSGF6NlIrWERtd1dkWE5DeGR1eXpQ?=
 =?utf-8?B?dit1THBUOW02K3BSWFVodHVYRUpOTDMrbUIzTFkrbGhNZHFaUFpIS0ludWtL?=
 =?utf-8?B?THB6V0tyME1oNXFZb2FYbTl5bURyZ0wrYVppNURQUks3QWNZRUpSVXd0QTVV?=
 =?utf-8?B?ek5UVUJjK3pzSnVkdVlHdGZLaEt3dml0SnZNdmQ2bU1lN1FpaUJrdDhYVnV2?=
 =?utf-8?B?Z2UrMWpPcGlhQ1d0d3JXZUo3TXkwamR0WlZSb2NNNzJGaFZsVHlTTTEvOGhn?=
 =?utf-8?B?TU9KdmtiRWdwMlA3dTY5NUFhTWtNTzBiZTE4T29QemtXOVEzZVBSTDEwcU9x?=
 =?utf-8?B?VjlRK2xWMEhuaXFISi9XNWdpMWhldjZrMEV6VzZMK2xES3hlem5LOUpFeTJQ?=
 =?utf-8?B?MlM5QWlqMjJycnNyZjVNdXJaSE9GdXJIV1FMWlRtcy8vdm4vMzM0dUYwZGVz?=
 =?utf-8?Q?If6/SSBDldyPO3n8C30avEWx6zJiO/yh1NBje2J?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BCE7F765A249640A3EE54D37D8E24C5@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f335979f-def8-42e9-a1f1-08d961cd11cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 22:19:24.3236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 238jn1fi/e8JQsUqcd5thgRn1i3Ay6Nh5prUMKdUlyFGpV+KM87NH12znBeqhL/vj6u+FhQyVGG+aHnMSkBIKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2489
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiA4LzE4LzIxIDEyOjA1IEFNLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+
IERvIHRoZXNlIGludGVncmF0ZWQgTlhQIFBIWXMgdXNlIGEgc3BlY2lmaWMgUEhZIGRyaXZlciwg
b3IgZG8gdGhleSBqdXN0DQo+PiB1c2UgdGhlIEdlbmVyaWMgUEhZIGRyaXZlcj8gSWYgdGhlIGZv
cm1lciBpcyB0aGUgY2FzZSwgZG8geW91IGV4cGVyaWVuY2UNCj4+IHRoYXQgdGhlIFBIWSBkcml2
ZXIgZmFpbHMgdG8gZ2V0IHByb2JlZCBkdXJpbmcgbWRpb2J1cyByZWdpc3RyYXRpb24gaWYNCj4+
IHRoZSBrZXJuZWwgdXNlcyBmd19kZXZsaW5rPW9uPw0KPiANCj4gVGhlIE1hcnZlbGwgbXY4OGU2
eHh4IGRyaXZlciByZWdpc3RlcnMgdXB0byB0d28gTURJTyBidXNzZXMsIGFuZCB0aGUNCj4gUEhZ
cyBvbiB0aG9zZSBidXNzZXMgbWFrZSB1c2Ugb2YgdGhlIG1hcnZlbGwgUEhZIGRyaXZlci4gSSd2
ZSBub3QNCj4gdGVzdGVkIHNwZWNpZmljYWxseSB3aXRoIGZ3X2Rldmxpbms9b24sIGJ1dCBpbiBn
ZW5lcmFsLCB0aGUgTWFydmVsbA0KPiBQSFkgZHJpdmVyIGRvZXMgZ2V0IGJvdW5kIHRvIHRoZXNl
IGRldmljZXMuDQoNClRoYW5rcyBmb3IgeW91ciByZXBseS4gSSBzaG91bGQgYWRkIHRoYXQgd2l0
aCBmd19kZXZsaW5rPXBlcm1pc3NpdmUsIHRoZSANClBIWSBkcml2ZXIgZ2V0cyBwcm9iZWQganVz
dCBmaW5lLiBJdCdzIG9ubHkgc2luY2UgdjUuMTMgdGhhdCANCmZ3X2Rldmxpbms9b24gaGFzIGJl
ZW4gdGhlIGRlZmF1bHRbMV0sIHNvIGl0IG1heSBiZSBzb21ldGhpbmcgbmV3IHRvIA0KY2hlY2su
IEJ1dCBpZiB5b3UgdGhpbmsgaXQncyB3b3JraW5nIGZvciBvdGhlciBkcml2ZXJzIHRoZW4gdGhh
dCBtZWFucyBJIA0Kd2lsbCBoYXZlIHRvIGxvb2sgaW50byBmdXJ0aGVyIG9uIG15IGVuZC4NCg0K
S2luZCByZWdhcmRzLA0KQWx2aW4NCg0KWzFdIGVhNzE4YzY5OTA1NSAoIlJldmVydCAiUmV2ZXJ0
ICJkcml2ZXIgY29yZTogU2V0IGZ3X2Rldmxpbms9b24gYnkgDQpkZWZhdWx0IiIiKQ0KIA0KaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIxMDMwMjIxMTEzMy4yMjQ0MjgxLTQtc2FyYXZh
bmFrQGdvb2dsZS5jb20vDQoNCj4gDQo+ICAgICAgQW5kcmV3DQo+IA0K
