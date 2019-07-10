Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22ED6645AA
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 13:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfGJLQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 07:16:50 -0400
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:42982
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725956AbfGJLQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 07:16:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1I2q0qwBv7GJneUaj7tOqa+eb+xwH/vUoBfuEOeZP5BRuLYrHvWYPCIPrIMT3/MyWgVMwpeGeFE1zu6oF2zgMRvorKCgL8j5laTGh+IRMQ3uE8ZpgkATR8fHkXse4VUt8dbGXV31kfO6nyg+ki4ceNKSNGfPZFTW4NsSbU4yrbP/GZtZro6EYqcihy9NFB3WPuNDRPzMudZBgNL/AJ2FYj7hHmQobG6++9Fp8gTRDKosH2I+/mLQkpSzc3h5WjL1l3PP7LnTY0CxKB71fnyWOUHBUphwkXvCe/UUpFl9e1XAtntf4pcHPjKNIPGu52KAkp9XNySYOQhDSLXBUwEPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeOkYuOQlmA38734XJQ0AaCDeDzafnoeXGCw6+HRUdU=;
 b=ihbL6TOGmgQLGJoxeTrdzh4gOVx5ptySxyKW0xR0i03HNWgp6mcfT60LPCOLP9Ifp2wkc9R8Z3HRagyOZiye+kneOE0ycc4vxOZu3Y8x2j5IcifjnXW0J173W6024FCNMqcZUMuq72JxqFcNed3gi8qalr3VC4c+ZgdlPL6zXMJZx5OeM8iN6Pm6JC5NP2ytCKNek7KhUvcGeivegBx3F350fCxl/1N11sOCobNWPzA9mkDFODwEfurfe9cC1+hUk0VYIN+CVMX+FkhnG9ekDeS05ElVc1GypXEckpb2JRvxPayt7lgZaceX/aIuechyzB3hZ54dJ8W+L+TCpCP6Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeOkYuOQlmA38734XJQ0AaCDeDzafnoeXGCw6+HRUdU=;
 b=YZshxCm1gLGsSpngbQSv/vGTiSUvApIQDQOY6vAAcR3QL0U8FX4X0NKlSMKxWp+nwWq6CpnVYPwk8LBcidQDP24XYOCfGrsYT41t12Y206nO/YnAyrWgwW1UfBXgNaRaTyOSOukf/yMlvwu12tXM1BS6TkmwVtIAh7kbE5a1798=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5412.eurprd05.prod.outlook.com (20.177.118.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Wed, 10 Jul 2019 11:16:05 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::4923:8635:3371:e4f0]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::4923:8635:3371:e4f0%3]) with mapi id 15.20.2052.020; Wed, 10 Jul 2019
 11:16:05 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next] net: Don't uninstall an XDP program when none is
 installed
Thread-Topic: [PATCH bpf-next] net: Don't uninstall an XDP program when none
 is installed
Thread-Index: AQHVITnjNkqLzd5XB0OcDX35ut8GrKbD30KA
Date:   Wed, 10 Jul 2019 11:16:05 +0000
Message-ID: <3124b473-1322-e98e-d5ab-60e584e74200@mellanox.com>
References: <20190612161405.24064-1-maximmi@mellanox.com>
In-Reply-To: <20190612161405.24064-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0502CA0021.eurprd05.prod.outlook.com
 (2603:10a6:3:e3::31) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99f1e537-1f79-4019-eb23-08d70528000f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5412;
x-ms-traffictypediagnostic: AM6PR05MB5412:
x-microsoft-antispam-prvs: <AM6PR05MB54121743CAD1C098188B1839D1F00@AM6PR05MB5412.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(189003)(199004)(25786009)(6436002)(53546011)(26005)(31686004)(386003)(6506007)(102836004)(66946007)(71200400001)(64756008)(186003)(5660300002)(76176011)(68736007)(52116002)(66446008)(2906002)(6246003)(31696002)(99286004)(66556008)(66476007)(71190400001)(14454004)(36756003)(3846002)(6116002)(6512007)(81156014)(4326008)(86362001)(54906003)(53936002)(7736002)(478600001)(486006)(66066001)(7416002)(8936002)(110136005)(305945005)(5024004)(256004)(316002)(229853002)(8676002)(446003)(11346002)(2616005)(476003)(81166006)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5412;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZpgLFzmiDXn45506/MLOw6bAXmZtRiCdAgQBQwYyanRwiwED5Dq+Pg6CiXJyOqyezRtcVgfVx419BDda3rYj4S6uE/H5v63ea+/xoFpBd4M8VnOKr8OtjP21AeE6djx+jOW61siOJ49WLKGAAJCaVxD+v8cvnE9pB3bTo3KZNdzT9vmjA6drZv2a0fJZ5WS+pqZ9Css++dxDwxWYk9dUmIKsK0jW4KbX2NMUmyRMtkEcplq2Bv7qmtbN7dwnm4rC2AHFtoO/keIsIM0w/RaY3YmkOnmEGf8YAom+HmGzq35Pc1ZFQJxKpOf+N0kL/hk/ReAy2VOhufGOQkalRcW86DekmTbBot79Ofv40D6PLH27b+jbwHeSyn/cP5zdyP4XHEqYHqd9GpHoqSoxJgOc6ggs5gfI0hfu/M54f421Cgc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3347EA0155ACA4C836ED5E0D88537BE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f1e537-1f79-4019-eb23-08d70528000f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 11:16:05.5477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5412
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNi0xMiAxOToxNCwgTWF4aW0gTWlraXR5YW5za2l5IHdyb3RlOg0KPiBkZXZfY2hh
bmdlX3hkcF9mZCBkb2Vzbid0IHBlcmZvcm0gYW55IGNoZWNrcyBpbiBjYXNlIGl0IHVuaW5zdGFs
bHMgYW4NCj4gWERQIHByb2dyYW0uIEl0IG1lYW5zIHRoYXQgdGhlIGRyaXZlcidzIG5kb19icGYg
Y2FuIGJlIGNhbGxlZCB3aXRoDQo+IFhEUF9TRVRVUF9QUk9HIGFza2luZyB0byBzZXQgaXQgdG8g
TlVMTCBldmVuIGlmIGl0J3MgYWxyZWFkeSBOVUxMLiBUaGlzDQo+IGNhc2UgaGFwcGVucyBpZiB0
aGUgdXNlciBydW5zIGBpcCBsaW5rIHNldCBldGgwIHhkcCBvZmZgIHdoZW4gdGhlcmUgaXMNCj4g
bm8gWERQIHByb2dyYW0gYXR0YWNoZWQuDQo+IA0KPiBUaGUgZHJpdmVycyB0eXBpY2FsbHkgcGVy
Zm9ybSBzb21lIGhlYXZ5IG9wZXJhdGlvbnMgb24gWERQX1NFVFVQX1BST0csDQo+IHNvIHRoZXkg
YWxsIGhhdmUgdG8gaGFuZGxlIHRoaXMgY2FzZSBpbnRlcm5hbGx5IHRvIHJldHVybiBlYXJseSBp
ZiBpdA0KPiBoYXBwZW5zLiBUaGlzIHBhdGNoIHB1dHMgdGhpcyBjaGVjayBpbnRvIHRoZSBrZXJu
ZWwgY29kZSwgc28gdGhhdCBhbGwNCj4gZHJpdmVycyB3aWxsIGJlbmVmaXQgZnJvbSBpdC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBtZWxsYW5veC5j
b20+DQo+IC0tLQ0KPiBCasO2cm4sIHBsZWFzZSB0YWtlIGEgbG9vayBhdCB0aGlzLCBTYWVlZCB0
b2xkIG1lIHlvdSB3ZXJlIGRvaW5nDQo+IHNvbWV0aGluZyByZWxhdGVkLCBidXQgSSBjb3VsZG4n
dCBmaW5kIGl0LiBJZiB0aGlzIGZpeCBpcyBhbHJlYWR5DQo+IGNvdmVyZWQgYnkgeW91ciB3b3Jr
LCBwbGVhc2UgdGVsbCBhYm91dCB0aGF0Lg0KPiANCj4gICBuZXQvY29yZS9kZXYuYyB8IDMgKysr
DQo+ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L25ldC9jb3JlL2Rldi5jIGIvbmV0L2NvcmUvZGV2LmMNCj4gaW5kZXggNjZmNzUwODgyNWJkLi42
OGIzZTMzMjBjZWIgMTAwNjQ0DQo+IC0tLSBhL25ldC9jb3JlL2Rldi5jDQo+ICsrKyBiL25ldC9j
b3JlL2Rldi5jDQo+IEBAIC04MDg5LDYgKzgwODksOSBAQCBpbnQgZGV2X2NoYW5nZV94ZHBfZmQo
c3RydWN0IG5ldF9kZXZpY2UgKmRldiwgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrLA0K
PiAgIAkJCWJwZl9wcm9nX3B1dChwcm9nKTsNCj4gICAJCQlyZXR1cm4gLUVJTlZBTDsNCj4gICAJ
CX0NCj4gKwl9IGVsc2Ugew0KPiArCQlpZiAoIV9fZGV2X3hkcF9xdWVyeShkZXYsIGJwZl9vcCwg
cXVlcnkpKQ0KPiArCQkJcmV0dXJuIDA7DQo+ICAgCX0NCj4gICANCj4gICAJZXJyID0gZGV2X3hk
cF9pbnN0YWxsKGRldiwgYnBmX29wLCBleHRhY2ssIGZsYWdzLCBwcm9nKTsNCj4gDQoNCkFsZXhl
aSwgc28gd2hhdCBhYm91dCB0aGlzIHBhdGNoPyBJdCdzIG1hcmtlZCBhcyAiQ2hhbmdlZCBSZXF1
ZXN0ZWQiIGluIA0KcGF0Y2h3b3JrLCBidXQgSmFrdWIncyBwb2ludCBsb29rcyByZXNvbHZlZCAt
IEkgZG9uJ3Qgc2VlIGFueSBjaGFuZ2VzIA0KcmVxdWlyZWQgZnJvbSBteSBzaWRlLg0K
