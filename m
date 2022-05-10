Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544385224B0
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiEJTXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349009AbiEJTXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:23:07 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2121.outbound.protection.outlook.com [40.107.22.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1588266CB4
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 12:23:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GmuO+C/LqkkQ8iofVzGKPoEkz3mQ9gfc6AIk1gBpCoyNUJolzktKKq+w3E7Z67Cp3+xzqhvbJVUX4gcxzbewSRkm/4ql6fFb/AzJFcn1Am6K/xKbn4FPb5K+h3fFrZkIu8DhnXyUY1ypHanNhZzMfzwX37d60aQkfyZL+76FzXFcs5NaZjyWmn/p44sEAUPerMbzUx1hGbRDNdPYLQYJrJRZQN8gGHWAdSi87rywkRozo/nY0whfvuOQZ/zf1DbAG8j2CNy2KJ0GXryL8jnkaQYBFcTD8Iy8G9NVVHbBeLh5cH1GioDXqZZWv7UiHgoIumNHZ9x6gH5ipoQJOoN+qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tm+p153Qmw+fln4/6XfOITu5hlK0SYNypCehKcspdUo=;
 b=eAzBHui1V49hvMbfeYgAQXlIDcEJwlx6DajMBBg/oVCMMNP+rNO+oE0CRh7AhJZT8IiJhAeAk/KubE1N3zwI+p+1OzIYhpRrpqJhfQnQFX2S6/fH9Srwc2aQiTwPh53KrYbzej0H4cWuo6C6X1RHX/yjn/7KeLPHVIP4Umx9ZSSBHgT127vyyvZDP0Bm6mOnCOk1gfJ3bQWCCvvvFw9ggbQnxcVH8kAmXEnVh+PRtRPWnd19kF57b6wg1JM3h2Lg3VCUNT/KuP4y1c9YslV6Jm+djoCUJWxdxdtNi1qKpwyps9/6R9I+Xs+z0z0CHqNXUhGMaey10cpOjqcMjs971w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tm+p153Qmw+fln4/6XfOITu5hlK0SYNypCehKcspdUo=;
 b=Qs8LHwUZgC1X5Nkr4TgC8dGfbA7dnoAvDBtJHKqj/aoPvQoFnVEd9DC9Ogb19dFrtlx/e6jzz5vI+A2V/sMfngETFUWKOdHoEII1LZnXzjnxwrijSXeaX03cecVuwAutumtqRhUjqv2Pcw5IqzmzPhDgfwEJ/g2YnvxavIIiyOY=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM0PR0302MB3475.eurprd03.prod.outlook.com (2603:10a6:208:2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 19:23:01 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::e5d4:b044:7949:db96]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::e5d4:b044:7949:db96%3]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 19:23:01 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Hauke Mehrtens <hauke@hauke-m.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 4/4] net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII
 support
Thread-Topic: [PATCH 4/4] net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII
 support
Thread-Index: AQHYYy3myVmlByOXDkG6ZhLq4x50Ba0YYI4AgAAf0IA=
Date:   Tue, 10 May 2022 19:23:01 +0000
Message-ID: <20220510192301.5djdt3ghoavxulhl@bang-olufsen.dk>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
 <20220508224848.2384723-5-hauke@hauke-m.de>
 <20220510172910.kthpd7kokb2qk27l@skbuf>
In-Reply-To: <20220510172910.kthpd7kokb2qk27l@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 734f8178-326e-4fe5-d48c-08da32ba7fca
x-ms-traffictypediagnostic: AM0PR0302MB3475:EE_
x-microsoft-antispam-prvs: <AM0PR0302MB3475D5862B9856E70BAB200D83C99@AM0PR0302MB3475.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /SGuVZUnqwR6XOwKUFqF04BH8uTPpRLQqpEOJQsD7hldA+1hsq4T6jwdTqAvzDWI4XiEkkQ1ydLCkvg1h3KF9AuWJfmIL9+KSdq4NG53PochSn2BHvTSI5FWOljhA3WXhY6vJIZdpIM7MYd6clUkEcYn7Umt57mnk+WeIhze/hDuHk7Wvgg+zcfvsUJl/8lW+mMxt9sC7c9Dy+PKyIEs4WQFkMa04fK12FmvCbxx/oEXRmEFmxUweTIM3vXPij9HrfMIS5H7RwSuJGeFr4Rx5Uiyoka2OwoiSAjRKTKn5bGqbQ3woEFobHg9toeuMu13/xJcl2cygYR45NlUksMBfQVeaipvck2X3y8bejazZ/swdEWGczE2wjMccLLO5Xy4FNvez1W4n1rAALE84faDiKSjCPq5YWVN3MCWi0LbNTeDEHz/rU6dC2TVOryosHEcKf7quYbMzqMKV3+Tn/sIavaqd5D8+yDPxy3D/sgVUPgmURPX4UUehy195HfF3GPPyUXsFGlh4+RAcssK2KESCth/hwNwLztZef7mBPFHhTRSN2qN2eHsZTVpOcAg5/079V0wDZ2boUZOFZ/d8zxoKXaKlLdRrpG1/dvLaj0f6eTIi2QZyuQ53W6Rg0XPeTY+yP/m0Kg2jmX5G5sMAUSVWZJXp6lkj/kDv+pNK68IZPQC2RCZHXlYOrS3NRieCsGMAcatEwCoJXRasl8WTqmFFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8976002)(66946007)(66556008)(54906003)(508600001)(76116006)(91956017)(6486002)(8936002)(86362001)(2616005)(26005)(5660300002)(6512007)(6506007)(64756008)(66446008)(38070700005)(38100700002)(6916009)(8676002)(66476007)(4326008)(316002)(122000001)(1076003)(85202003)(186003)(85182001)(36756003)(2906002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YUxwUWt6OE0xU2h0RGRKcTVJclJpaFJhNS9DMzZXUjlydzR4U3pFWDgrMlFF?=
 =?utf-8?B?bmZTTnV1U2x5QXZWYkN0S25JTGhrVGpmYUVLV0tvWHZNN2ZrZWJDaTNiK0Jl?=
 =?utf-8?B?c2ZEeFcrNnptOEljdTUvTk8yb2w3K1NIa1B4d3ZzNVJkZ0tMZklkMExjTGRB?=
 =?utf-8?B?ZStiNEhaN3NSVVFvOTc1c2Ywck41bFhZM1l0OWgyR05WM2J6MERKa2pHTVpL?=
 =?utf-8?B?N3RpWGRVTlVjT2w3bTE2SmV1ekhraXRHUHpmWTlSRGl5REJ3Yyt2OW5QSmxn?=
 =?utf-8?B?RzZsOU5hZHlVVE5SVi9zdUpHQ1RyV1NzajJNMlEwOVpNUWNEK1l5cW9UaExY?=
 =?utf-8?B?VUZ4amswQnlvbWM2cVM0OThpc0tOZ2l1dERveUoxY0xvb095TjFDQmZrZTcr?=
 =?utf-8?B?YlREeHFLcUpEUWNrblZHaG4zTnhxWGF0d3Y4OCtTbFZCV0cyNFN6eWZKVkdO?=
 =?utf-8?B?VmwxT3JBWlJrcFl2UU9MWVhDYXErM3EyT3hrY3ZPMEMyMWptK0NXQlNDV0Fj?=
 =?utf-8?B?clIxa0c1Z3VXd1k0d1ZEOFBpTWxNWlRFR2NNVng3YzZNYUorTDJSbXEvTVgz?=
 =?utf-8?B?aTREWFZhbDduYzhLSlA5cXA3ekJPb0Q2b2lIdmRKTFdxNkVhZ1M3b3lrYUZE?=
 =?utf-8?B?NHVrb1VQdzRiOE84SndPb00wbWk3RTcreEF4UldMK3VZcjlpRlNMMGVBQWFV?=
 =?utf-8?B?YXkxYXJ3SVFRclRPVFZIZkQrRW9FS3g3bnZZTHpxcjk3VXdreHorV2Z2a21R?=
 =?utf-8?B?aUVJOFloRm1Fb2RLeFdDMmtWQ3NmVWM1anJBdzIvODZVTm5pL0ZZaW9JKy9V?=
 =?utf-8?B?ZTVUNWYzbWpOUjdOM1M2SVdmUlc0VVEydy9ybE94QUdHUHZMRUMzblRKSUlm?=
 =?utf-8?B?cUNlU2xBbUxDc3R5YStPdXBQeDlEUWFNbzlNVVZQdEpTWE5uNCtRVWFqZVZV?=
 =?utf-8?B?MEZLbTBVTngwaC9HcDF5bGJDNDN2N0g1Wm1EYzA1a05lNG05OXB6L1FEb3N6?=
 =?utf-8?B?UGNTelcxUUEvZG1uakY1Z1FrdXgvY1BXSzdiQXpuMTVIb0RSWFl2ais2R3Np?=
 =?utf-8?B?ZGdHQklYb3U3eUEwRGFvcS9iWmgrSDBHM05ROFZNakEyZjV2VzVEV015VWoy?=
 =?utf-8?B?Ky9IZlprLytRbkFlcWVIek05clp1QjJ1UlFwZHJ0UU01MlpHZ1J4UVpDNEdi?=
 =?utf-8?B?TGdFTUsvQzYva1dwbU4zbmFzUWl1ZFNnZzlkLzJ6UmlXLzNyanZ3eEI0THdR?=
 =?utf-8?B?N3JLZHJhTUp6dmE3Y0x2Q2dkV2QwMGNxR3cxOEpWYnlHWmFiRzBoSnV3OUxM?=
 =?utf-8?B?bVJtMHR1YUdURkRIanhCNzVnRGUzdzUxZnVmWnNFVEZSd2pEcXZwU3kxdVNB?=
 =?utf-8?B?WGJpV1FvbkNHSUJaMzdzMXlzYXRoMmJhMUF4TkhjT1lvdGJvODFoS2xZTkRD?=
 =?utf-8?B?dTQwdDR0ejJlblBwbFBnaGQzazZSN3NqUlNmOEtNYlJzdXBVMjJncGtkSEM3?=
 =?utf-8?B?cmN4YXAyQmYzMEZwdm1kTk4rb0U2d3JzdktESTJYa3dtcE4yWFZRUGI1ZzRZ?=
 =?utf-8?B?TkU0RDJ3RFdDckgyZDdaMm1pakxuS0tiWGFObW53WFEwcnNHRzM0ZDdKSTlm?=
 =?utf-8?B?VlF4Mm02ODQ5Vjl1WnZoYmlWeHNFMkloSm1EUGxlVksvczlzYkFHQ3BrL1lN?=
 =?utf-8?B?K2RMSDBPQlZGbENqTWx3K0xoSjdrSXlhd2tlUGViUjY2VnBuNC9nV1I0WXFB?=
 =?utf-8?B?WVZIaDl5bmxyelk3elY2TnhKaFM4ZzhPeVVrSlNzY2FwalRmL1RVYWtNRHNj?=
 =?utf-8?B?QTB3ejRqcThLblhSSEI1aTBITXJ3dldXazliTUNZYmp5b2V4OW1Id1Y2Uzk0?=
 =?utf-8?B?ZnNPR1ZXa0NKa0RCMmxtbGlzN21XVFFHRmxXU0o1aHBPRHVDZUtuSElQQmpF?=
 =?utf-8?B?YzFRYlN2RkNuQmxYaUxBRDd5N0pDSHJqdzVvT2xlVHdJMjdFUFNZenN2bkpj?=
 =?utf-8?B?RXZIbnBGNTFUUzBjcm9rYUtMY1pxcHd6blRranIwRFlLVEN0bE9GMUpNMVZu?=
 =?utf-8?B?V1I4dmRRWHZmNVBoazhId0R2MTdwWjhhVlEwR2MrOG9YVDRjU2pRZHpINWU2?=
 =?utf-8?B?elJuUStYRThsSW0zRFNoemNFT1dyMHhOcllWWG1jMWZrbGl3UHc3NWZEc01V?=
 =?utf-8?B?QnZPMUwzcmw0UHRlYXZ3M2U0UGhlV21QSmpEeW45NGI2OUtXY2hXRTBMMXc0?=
 =?utf-8?B?TjJBbmM1RWFIbG1XU2kvdWtXNkRSUE9LSWlmRmpkYU8wZlpiZXZMSE93MEhm?=
 =?utf-8?B?cmxGNWdOTGdjTHdTZFZZRkNnNm15Z2JpRThpOHZsdERzbnljYXpMY0pYVnRy?=
 =?utf-8?Q?Bqfvxh3Mzjf9bnw8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7DF0BF50FC83EE45A5CA3F266699B8FC@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 734f8178-326e-4fe5-d48c-08da32ba7fca
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 19:23:01.5182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OvqIIZ8Xe19r3sEk0Ly53KJ7JoBXXlRIQLoHmE39Z1QJGjBP7jRQv8n+FIskhYkGIYuaRT65KuGvKE14jVCK1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0302MB3475
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBNYXkgMTAsIDIwMjIgYXQgMDg6Mjk6MTBQTSArMDMwMCwgVmxhZGltaXIgT2x0ZWFu
IHdyb3RlOg0KPiBPbiBNb24sIE1heSAwOSwgMjAyMiBhdCAxMjo0ODo0OEFNICswMjAwLCBIYXVr
ZSBNZWhydGVucyB3cm90ZToNCj4gPiBAQCAtOTgzLDE0ICsxMjk1LDI1IEBAIHN0YXRpYyBib29s
IHJ0bDgzNjVtYl9waHlfbW9kZV9zdXBwb3J0ZWQoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQg
cG9ydCwNCj4gPiAgc3RhdGljIHZvaWQgcnRsODM2NW1iX3BoeWxpbmtfZ2V0X2NhcHMoc3RydWN0
IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwNCj4gPiAgCQkJCSAgICAgICBzdHJ1Y3QgcGh5bGlu
a19jb25maWcgKmNvbmZpZykNCj4gPiAgew0KPiA+IC0JaWYgKGRzYV9pc191c2VyX3BvcnQoZHMs
IHBvcnQpKQ0KPiA+ICsJaW50IGV4dF9pbnQgPSBydGw4MzY1bWJfZXh0aW50X3BvcnRfbWFwW3Bv
cnRdOw0KPiA+ICsNCj4gPiArCWNvbmZpZy0+bWFjX2NhcGFiaWxpdGllcyA9IE1BQ19TWU1fUEFV
U0UgfCBNQUNfQVNZTV9QQVVTRSB8DQo+ID4gKwkJCQkgICBNQUNfMTAgfCBNQUNfMTAwIHwgTUFD
XzEwMDBGRDsNCj4gPiArDQo+ID4gKwlpZiAoZHNhX2lzX3VzZXJfcG9ydChkcywgcG9ydCkpIHsN
Cj4gPiAgCQlfX3NldF9iaXQoUEhZX0lOVEVSRkFDRV9NT0RFX0lOVEVSTkFMLA0KPiA+ICAJCQkg
IGNvbmZpZy0+c3VwcG9ydGVkX2ludGVyZmFjZXMpOw0KPiA+IC0JZWxzZSBpZiAoZHNhX2lzX2Nw
dV9wb3J0KGRzLCBwb3J0KSkNCj4gPiArCX0gZWxzZSBpZiAoZHNhX2lzX2NwdV9wb3J0KGRzLCBw
b3J0KSkgew0KPiANCj4gV2hhdCBkb2VzIHRoZSBxdWFsaXR5IG9mIGJlaW5nIGEgdXNlciBwb3J0
IG9yIGEgQ1BVIHBvcnQgaGF2ZSB0byBkbyB3aXRoDQo+IHdoaWNoIGludGVyZmFjZXMgYXJlIHN1
cHBvcnRlZD8NCg0KUmlnaHQsIEkgdGhpbmsgdGhpcyBmdW5jdGlvbiB3YXMgYWN0dWFsbHkgYnJv
a2VuIGFscmVhZHkgaW4gYSBmZXcgd2F5cy4gVGhlDQpzd2l0Y2ggd2lsbCBoYXZlIHBvcnRzIHdp
dGggaW50ZWdyYXRlZCBQSFlzLCBhbmQgcG9ydHMgd2l0aCBleHRlbnNpb24gaW50ZXJmYWNlcw0K
bGlrZSBSR01JSSBvciBTR01JSSBldGMuIEJ1dCB3aGljaCBvZiB0aG9zZSBwb3J0cyBvbmUgdXNl
cyBhcyBhIENQVSBwb3J0LCB1c2VyDQpwb3J0LCBvciAob25lIGRheSkgRFNBIHBvcnQsIGlzIG9m
IG5vIGNvbmNlcm4gdG8gdGhlIHN3aXRjaC4gVGhlIHN1cHBvcnRlZA0KaW50ZXJmYWNlIG9mIGEg
Z2l2ZW4gcG9ydCBpcyBhIHN0YXRpYyBwcm9wZXJ0eSBhbmQgc2ltcGx5IGEgZnVuY3Rpb24gb2Yg
dGhlIHBvcnQNCm51bWJlciBhbmQgc3dpdGNoIG1vZGVsLiBBbGwgc3dpdGNoIG1vZGVscyBpbiB0
aGUgZmFtaWx5IGhhdmUgYmV0d2VlbiAxIGFuZCAyDQpwb3J0cyB3aXRoIGFuIGV4dGVuc2lvbiBp
bnRlcmZhY2UuDQoNCkx1aXogaW50cm9kdWNlZCB0aGlzIG1hcDoNCg0KLyogdmFsaWQgZm9yIGFs
bCA2LXBvcnQgb3IgbGVzcyB2YXJpYW50cyAqLw0Kc3RhdGljIGNvbnN0IGludCBydGw4MzY1bWJf
ZXh0aW50X3BvcnRfbWFwW10gID0geyAtMSwgLTEsIC0xLCAtMSwgLTEsIC0xLCAxLCAyLCAtMSwg
LTF9Ow0KDQouLi4gd2hpY2ggSSB0aGluayBpcyBhY3R1YWxseSB3aGF0IHdlIG91Z2h0IHRvIHRl
c3Qgb24uIEl0IGNhbiBiZSBpbXByb3ZlZCwgYnV0DQpjdXJyZW50bHkgaXQgaXMgY29ycmVjdCBm
b3IgYWxsIHN1cHBvcnRlZCBtb2RlbHMuDQoNClNvIHNvbWV0aGluZyBsaWtlIHRoaXMgd291bGQg
YmUgY29ycmVjdDoNCg0Kc3RhdGljIHZvaWQgcnRsODM2NW1iX3BoeWxpbmtfZ2V0X2NhcHMoc3Ry
dWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwNCgkJCQkgICAgICAgc3RydWN0IHBoeWxpbmtf
Y29uZmlnICpjb25maWcpDQp7DQoJaW50IGV4dF9pbnQgPSBydGw4MzY1bWJfZXh0aW50X3BvcnRf
bWFwW3BvcnRdOw0KCWlmIChleHRfaW50ID09IC0xKSB7DQoJCS8qIGludGVncmF0ZWQgUEhZLCBz
ZXQgUEhZX0lOVEVSRkFDRV9NT0RFX0lOVEVSTkFMIGV0Yy4gKi8NCgl9IGVsc2Ugew0KCQkvKiBl
eHRlbnNpb24gaW50ZXJmYWNlIGF2YWlsYWJsZSwgYnV0IGhlcmUgb25lIHNob3VsZCByZWFsbHkN
CgkJICogY2hlY2sgdGhlIG1vZGVsIGJhc2VkIG9uIHRoZSBjaGlwIElEL3ZlcnNpb24sIGJlY2F1
c2UgaXQNCgkJICogdmFyaWVzIGEgbG90DQoJCSAqLw0KCQlpZiAobW9kZWwgPT0gUlRMODM2NU1C
ICYmIGV4dF9pbnQgPT0gMSkNCgkJCS8qIFJHTUlJICovDQoJCWVsc2UgaWYgKG1vZGVsID09IFJU
TDgzNjdTICYmIGV4dF9pbnQgPT0gMSkNCgkJCS8qIFNHTUlJIC8gSFNHTUlJICovDQoJCWVsc2Ug
aWYgKG1vZGVsID09IFJUTDgzNjdTICYmIGV4dF9pbnQgPT0gMikNCgkJCS8qIFJHTUlJICovDQoJ
CS8qIGV0YyAqLw0KCX0NCg0KCS8qIC4uLiAqLw0KfQ0KDQpUaGVyZSBhcmUgb2YgY291cnNlIHZh
cmlvdXMgd2F5cyB0byBkbyB0aGlzLg0KDQpIYXVrZSwgZG8geW91IGZvbGxvdyB3aGF0IEkgbWVh
bj8gIFdvdWxkIHlvdSBsaWtlIG1lIHRvIHByZXBhcmUgYSBwYXRjaCBmb3IgdGhlDQpjdXJyZW50
IHN1cHBvcnRlZCBtb2RlbHMvaW50ZXJmYWNlcyBhbmQgdGhlbiB5b3UgY2FuIHJlYmFzZSB5b3Vy
IGNoYW5nZXMgb24gdG9wDQpvZiB0aGF0IHRvIGluZGljYXRlIHN1cHBvcnQgZm9yIChIKVNHTUlJ
PyBPciBkbyB5b3Ugd2FudCB0byBnaXZlIGl0IGEgdHJ5DQp5b3Vyc2VsZj8NCg0KS2luZCByZWdh
cmRzLA0KQWx2aW4NCiAgICANCg0KPiANCj4gPiArCQlpZiAoZXh0X2ludCA9PSAxKSB7DQo+ID4g
KwkJCV9fc2V0X2JpdChQSFlfSU5URVJGQUNFX01PREVfU0dNSUksDQo+ID4gKwkJCQkgIGNvbmZp
Zy0+c3VwcG9ydGVkX2ludGVyZmFjZXMpOw0KPiA+ICsJCQlfX3NldF9iaXQoUEhZX0lOVEVSRkFD
RV9NT0RFXzI1MDBCQVNFWCwNCj4gPiArCQkJCSAgY29uZmlnLT5zdXBwb3J0ZWRfaW50ZXJmYWNl
cyk7DQo+ID4gKwkJCWNvbmZpZy0+bWFjX2NhcGFiaWxpdGllcyB8PSBNQUNfMjUwMEZEOw0KPiA+
ICsJCX0NCj4gPiAgCQlwaHlfaW50ZXJmYWNlX3NldF9yZ21paShjb25maWctPnN1cHBvcnRlZF9p
bnRlcmZhY2VzKTsNCj4gPiArCX0NCj4gPiAgDQo+ID4gLQljb25maWctPm1hY19jYXBhYmlsaXRp
ZXMgPSBNQUNfU1lNX1BBVVNFIHwgTUFDX0FTWU1fUEFVU0UgfA0KPiA+IC0JCQkJICAgTUFDXzEw
IHwgTUFDXzEwMCB8IE1BQ18xMDAwRkQ7DQo+ID4gIH0NCj4gPiAgDQo+ID4gIHN0YXRpYyB2b2lk
IHJ0bDgzNjVtYl9waHlsaW5rX21hY19jb25maWcoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQg
cG9ydCw=
