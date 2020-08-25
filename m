Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005BF251937
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgHYNJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:09:41 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:56496 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726585AbgHYNJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 09:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1598360976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mQsd9WwYizN9MgDKaOHPRCzEhFyg4PUtwC7LSDULEmg=;
        b=dTUU/5ix91rP7YqrIcV7y3AVMbfD1LQJEC3SxrzVcge/8q/nsbgHW27XU17XT5euvW80sz
        EJ0h6uBJET70RBhths3mDuB59phA6vPt2ONhh5pl+Thu/Q1+nz8FXX8UILRoHF0jqzxBt4
        AMIi8x1fgYlaoM7OKpuE8+jPE6lTNLg=
Received: from NAM04-BN3-obe.outbound.protection.outlook.com
 (mail-bn3nam04lp2053.outbound.protection.outlook.com [104.47.46.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-CgvfP7GDPOW94VfPqbhNVQ-1; Tue, 25 Aug 2020 09:09:35 -0400
X-MC-Unique: CgvfP7GDPOW94VfPqbhNVQ-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR04MB0455.namprd04.prod.outlook.com
 (2603:10b6:903:b3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 13:09:32 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::e563:74ca:b05f:e468]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::e563:74ca:b05f:e468%7]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 13:09:32 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Sabrina Dubroca <sd@queasysnail.net>,
        Scott Dial <scott@scottdial.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Ryan Cox <ryan_cox@byu.edu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "ebiggers@google.com" <ebiggers@google.com>
Subject: RE: Severe performance regression in "net: macsec: preserve ingress
 frame ordering"
Thread-Topic: Severe performance regression in "net: macsec: preserve ingress
 frame ordering"
Thread-Index: AQHWbxswXQv6N8/0LkqF3KAyUpB/cqkxgxcAgAK+soCAAAOeEIAAKFWAgBKXA/CAAEp3AIABkZyw
Date:   Tue, 25 Aug 2020 13:09:31 +0000
Message-ID: <CY4PR0401MB3652AB8C5DC2FEA09A6F2BECC3570@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <1b0cec71-d084-8153-2ba4-72ce71abeb65@byu.edu>
 <a335c8eb-0450-1274-d1bf-3908dcd9b251@scottdial.com>
 <20200810133427.GB1128331@bistromath.localdomain>
 <7663cbb1-7a55-6986-7d5d-8fab55887a80@scottdial.com>
 <20200812100443.GF1128331@bistromath.localdomain>
 <CY4PR0401MB36524B348358B23A8DFB741AC3420@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200812124201.GF2154440@lunn.ch>
 <CY4PR0401MB365240B04FC43F7F8AAE6A0CC3560@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200824130142.GN2588906@lunn.ch>
In-Reply-To: <20200824130142.GN2588906@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 015008c1-6c1e-4eb6-62f5-08d848f81b4f
x-ms-traffictypediagnostic: CY4PR04MB0455:
x-microsoft-antispam-prvs: <CY4PR04MB0455267EE083E374DD1ACD4AC3570@CY4PR04MB0455.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h1SQvXVsuynsSB+bWw9JFNmcygoWNQwaFO8me6OimKtm649SPG4pKoQM4fEI4MsYYBdEGrWAUuj+1iMMp7eNb6vkLt5jNb61tPiOM7sUrqcNltdf1edDsfwPFY2wiQ8ehv/Fk8i7AfXubncG5K6ic4hrAXbAS0OrBOzbioeb/CYT+2VHX9KB3Y3JeZq4bC+jKQsuLTMc34ewFsOZTHZsLokK3fwZ/NQNWyQfyif1rv8DstyDRheORJDK2h6pdmJqs/USKzNNHZ9zjRtZty8p/V50lpxWXNSTIR8AbBSZs8Ssmh17vUg4z1V6KjgdGh2D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39850400004)(396003)(346002)(376002)(366004)(33656002)(6916009)(8936002)(9686003)(86362001)(4326008)(83380400001)(2906002)(66556008)(26005)(76116006)(54906003)(53546011)(66446008)(316002)(66476007)(66946007)(55016002)(186003)(478600001)(71200400001)(6506007)(64756008)(7696005)(8676002)(52536014)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 15SJod3vj1Puk9cn7jyIX2CIyhJBFBWL+K1oUy7WcDssIEEv8vE+SBAOnp/KH07lS4JRrIcEOO7Uw/McAb1wkzwpbkj9fYqudg/gbWUHCHVftF+xS0XlLGvucmrmMM7hqPpSVWb5Pp1+Eny0tpWFLCVV7bdY54c8ZRVo0bEh5VsBvTJKu5OjXaZwpXlhKI0QGx1gMo8LGpSNikjSFO1bKDqgJ3bf9Tq6g+S1G8RoBLck6up4x6T5S8pQd8IBPuSY6drRu8uDH5phO+NCcmLxzbKGUvQrYZ5aKTuGRjT1y9hSKwO5x2lflXAZ3+DlzlIH9chnXP/yl/VrnYEx1VI5nWO/QJ1uOEG532kanwEqL+3fItryDiETKj22ZCODKMujCRdrFvn/R7PptUdD+47JwDMyKtYbs/4aTkPB5NILs1DFblPXnVumb6ZQu0DUs4m40QJ12WiwOn4LnbRYd5k+WnRURr+1Osn6O07YS0fDvMe4w65UdeIjDtOZpQu3FVhE/OyK9GOvRP+ufy3zgvG4s+g1odwX/m2oy8X++jciq7CwBASOTGPneezZZ1atCSwFMWptYdKnluWufsOSg17eIMsEsePRwyvmQlHYXz3nMu9yZ2x6WS0tbpahbMoW0me1Q4nPOLEJ5E87Iu5cs/Ztig==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 015008c1-6c1e-4eb6-62f5-08d848f81b4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2020 13:09:31.8862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UMBvnjZT07BGh93EJCFmbT3JLT0cT83jmTP4f+7hN+9vXdCq4mAQW1iGD9QTPMvZcsZdfXIpp0u+k1fNHicI3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0455
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA48A24 smtp.mailfrom=pvanleeuwen@rambus.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmRyZXcgTHVubiA8YW5kcmV3
QGx1bm4uY2g+DQo+IFNlbnQ6IE1vbmRheSwgQXVndXN0IDI0LCAyMDIwIDM6MDIgUE0NCj4gVG86
IFZhbiBMZWV1d2VuLCBQYXNjYWwgPHB2YW5sZWV1d2VuQHJhbWJ1cy5jb20+DQo+IENjOiBTYWJy
aW5hIER1YnJvY2EgPHNkQHF1ZWFzeXNuYWlsLm5ldD47IFNjb3R0IERpYWwgPHNjb3R0QHNjb3R0
ZGlhbC5jb20+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBSeWFuIENveA0KPiA8cnlh
bl9jb3hAYnl1LmVkdT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRhdmVtQGRhdmVtbG9mdC5u
ZXQ7IEFudG9pbmUgVGVuYXJ0IDxhbnRvaW5lLnRlbmFydEBib290bGluLmNvbT47DQo+IGViaWdn
ZXJzQGdvb2dsZS5jb20NCj4gU3ViamVjdDogUmU6IFNldmVyZSBwZXJmb3JtYW5jZSByZWdyZXNz
aW9uIGluICJuZXQ6IG1hY3NlYzogcHJlc2VydmUgaW5ncmVzcyBmcmFtZSBvcmRlcmluZyINCj4N
Cj4gPDw8IEV4dGVybmFsIEVtYWlsID4+Pg0KPiBPbiBNb24sIEF1ZyAyNCwgMjAyMCBhdCAwOTow
NzoyNkFNICswMDAwLCBWYW4gTGVldXdlbiwgUGFzY2FsIHdyb3RlOg0KPiA+IE5vIG5lZWQgdG8g
cG9pbnQgdGhpcyBvdXQgdG8gbWUgYXMgd2UncmUgdGhlIG51bWJlciBvbmUgc3VwcGxpZXIgb2Yg
aW5saW5lIE1BQ3NlYyBJUCA6LSkNCj4gPiBJbiBmYWN0LCB0aGUgTWljcm9zZW1pIFBIWSBzb2x1
dGlvbiB5b3UgbWVudGlvbiBpcyBvdXJzLCBtYWpvciBwYXJ0cyBvZiB0aGF0IGRlc2lnbiB3ZXJl
DQo+ID4gZXZlbiBjcmVhdGVkIGJ5IHRoZXNlIDIgaGFuZHMgaGVyZS4NCj4NCj4gT2gsICBPLksu
DQo+DQo+IERvIHlvdSBrbm93IG9mIG90aGVyIHNpbGljb24gdmVuZG9ycyB3aGljaCBhcmUgdXNp
bmcgdGhlIHNhbWUgSVA/DQo+DQpJIGRvLCB0aGVyZSBhcmUgbWFueS4gQnV0IHVuZm9ydHVuYXRl
bHksIEkgY2Fubm90IGRpc2Nsb3NlIG91ciBjdXN0b21lcnMgdW5sZXNzIHRoaXMgaXMgYWxyZWFk
eQ0KcHVibGljIGluZm9ybWF0aW9uLCBlLmcuIGR1ZSB0byBzb21lIHByZXNzIHJlbGVhc2Ugb3Ig
d2hhdGV2ZXIuDQoNCj4gTWF5YmUgd2UgY2FuIGVuY291cmFnZSB0aGVtIHRvIHNoYXJlIHRoZSBk
cml2ZXIsIHJhdGhlciB0aGFuIHJlLWludmVudA0KPiB0aGUgd2hlZWwsIHdoaWNoIG9mdGVuIGhh
cHBlbnMgd2hlbiBub2JvZHkgcmVhbGlzZXMgaXQgaXMgYmFzaWNhbGx5DQo+IHRoZSBzYW1lIGNv
cmUgd2l0aCBhIGRpZmZlcmVudCB3cmFwcGVyLg0KPg0KWWVzLCB0aGF0IGNvdWxkIHNhdmUgYSBs
b3Qgb2YgZHVwbGljYXRpb24gb2YgY29kZSBhbmQgZWZmb3J0LiBBbmQgaXQgc2hvdWxkIGJlIHJh
dGhlciB0cml2aWFsIHRvDQptb3ZlIHRoZSBNQUNzZWMgc3R1ZmYgdG8gYSBoaWdoZXIgbGV2ZWwg
YXMgYWxsIGl0IG5lZWRzIGlzIHNvbWUgcmVnaXN0ZXIgYWNjZXNzIHRvIFBIWSBjb250cm9sDQpz
cGFjZSBhbmQgYW4gaW50ZXJydXB0IGNhbGxiYWNrLiBTbyBpdCBzaG91bGQgYmUgcG9zc2libGUg
dG8gZGVmaW5lIGEgc2ltcGxlIEFQSSBiZXR3ZWVuIHRoZQ0KTUFDc2VjIGRyaXZlciBhbmQgdGhl
IFBIWSBkcml2ZXIgZm9yIHRoYXQuIEkgd291bGQgZXhwZWN0IGEgc2ltaWxhciBBUEkgdG8gYmUg
dXNlZnVsIGZvcg0KTUFDc2VjIGVuYWJsZWQgUEhZJ3MgdXNpbmcgb3RoZXIgTUFDc2VjIHNvbHV0
aW9ucyAoaS5lLiBub3Qgb3VycykgYXMgd2VsbCAuLi4NCg0KVGhlIHByb2JsZW0gaXM6IHdobyB3
aWxsIGRvIGl0PyBXZSBjYW4ndCBkbyBpdCwgYmVjYXVzZSB3ZSBoYXZlIG5vIGFjY2VzcyB0byB0
aGUgYWN0dWFsIEhXLg0KTWljcm9zZW1pIHdvbid0IGJlIG1vdGl2YXRlZCB0byBkbyBpdCwgYmVj
YXVzZSBpdCB3b3VsZCBvbmx5IGhlbHAgdGhlIGNvbXBldGl0aW9uLCBzbyB3aHkNCndvdWxkIHRo
ZXk/IFNvIGl0IHdvdWxkIGhhdmUgdG8gYmUgc29tZSBjb21wZXRpdG9yIGFsc28gZGVzaXJpbmcg
TUFDc2VjIHN1cHBvcnQgKGZvciB0aGUNCnNhbWUgTUFDc2VjIElQKSwgY29udmluY2luZyB0aGUg
bWFpbnRhaW5lciBvZiB0aGUgTWljcm9zZW1pIGRyaXZlciB0byBnbyBhbG9uZyB3aXRoIHRoZQ0K
Y2hhbmdlcy4gSSBndWVzcyBpdCdzIG5vdCBhbGwgdGhhdCByZWxldmFudCB1bnRpbCB3ZSBoaXQg
dGhhdCBzaXR1YXRpb24uDQoNCj4gVGhhbmtzDQo+IEFuZHJldw0KDQpSZWdhcmRzLA0KUGFzY2Fs
IHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVz
LCBSYW1idXMgU2VjdXJpdHkNClJhbWJ1cyBST1RXIEhvbGRpbmcgQlYNCiszMS03MyA2NTgxOTUz
DQoNCk5vdGU6IFRoZSBJbnNpZGUgU2VjdXJlL1ZlcmltYXRyaXggU2lsaWNvbiBJUCB0ZWFtIHdh
cyByZWNlbnRseSBhY3F1aXJlZCBieSBSYW1idXMuDQpQbGVhc2UgYmUgc28ga2luZCB0byB1cGRh
dGUgeW91ciBlLW1haWwgYWRkcmVzcyBib29rIHdpdGggbXkgbmV3IGUtbWFpbCBhZGRyZXNzLg0K
DQoNCioqIFRoaXMgbWVzc2FnZSBhbmQgYW55IGF0dGFjaG1lbnRzIGFyZSBmb3IgdGhlIHNvbGUg
dXNlIG9mIHRoZSBpbnRlbmRlZCByZWNpcGllbnQocykuIEl0IG1heSBjb250YWluIGluZm9ybWF0
aW9uIHRoYXQgaXMgY29uZmlkZW50aWFsIGFuZCBwcml2aWxlZ2VkLiBJZiB5b3UgYXJlIG5vdCB0
aGUgaW50ZW5kZWQgcmVjaXBpZW50IG9mIHRoaXMgbWVzc2FnZSwgeW91IGFyZSBwcm9oaWJpdGVk
IGZyb20gcHJpbnRpbmcsIGNvcHlpbmcsIGZvcndhcmRpbmcgb3Igc2F2aW5nIGl0LiBQbGVhc2Ug
ZGVsZXRlIHRoZSBtZXNzYWdlIGFuZCBhdHRhY2htZW50cyBhbmQgbm90aWZ5IHRoZSBzZW5kZXIg
aW1tZWRpYXRlbHkuICoqDQoNClJhbWJ1cyBJbmMuPGh0dHA6Ly93d3cucmFtYnVzLmNvbT4NCg==

