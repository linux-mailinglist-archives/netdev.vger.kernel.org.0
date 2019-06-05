Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BDC364AC
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 21:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfFET2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 15:28:43 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:18318
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726280AbfFET2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 15:28:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kA4hQGNZ5wH6TkM+B5mc6wZ++FTmbpRtY1blwdLTzn0=;
 b=JNJEz2EaDzDGfK0varRE7Vmq8umqo6YLkP4CslW5jgr2QuK3uD3UlX33Z9qQdg+H/unhg+GHAazXGENfztIInUvdAieZOVKwOYxQSJfeX0y3FKjEgIX1brkxIxJ14rVnUS7CB/x/dTjVQwMHyAOu4OO+h4XNffd0XjEfqxllzgg=
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com (20.177.119.89) by
 AM6PR05MB6101.eurprd05.prod.outlook.com (20.179.3.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Wed, 5 Jun 2019 19:28:38 +0000
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae]) by AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae%5]) with mapi id 15.20.1965.011; Wed, 5 Jun 2019
 19:28:38 +0000
From:   Shalom Toledo <shalomt@mellanox.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Thread-Topic: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Thread-Index: AQHVGgXTQ0R6KLy1CUKANB7103lOSqaLj3aAgAFkg4CAAGN+gIAAHjmA
Date:   Wed, 5 Jun 2019 19:28:38 +0000
Message-ID: <be656773-93e8-2f95-ad63-bfec18c9523a@mellanox.com>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-8-idosch@idosch.org>
 <20190604142819.cml2tbkmcj2mvkpl@localhost>
 <5c757fb9-8b47-c03a-6b78-45ac2b2140f3@mellanox.com>
 <20190605174025.uwy2u7z55v3c2opm@localhost>
In-Reply-To: <20190605174025.uwy2u7z55v3c2opm@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
x-clientproxiedby: LO2P265CA0157.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::25) To AM6PR05MB5524.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [84.108.45.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 041a6071-8fb0-4c81-072a-08d6e9ec02a3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6101;
x-ms-traffictypediagnostic: AM6PR05MB6101:
x-microsoft-antispam-prvs: <AM6PR05MB61014518E7685F6006616026C5160@AM6PR05MB6101.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(39850400004)(366004)(396003)(199004)(189003)(26005)(6436002)(6486002)(6512007)(14454004)(31686004)(71200400001)(229853002)(8936002)(25786009)(71190400001)(53936002)(5660300002)(1411001)(102836004)(14444005)(76176011)(186003)(99286004)(65826007)(6916009)(107886003)(36756003)(6246003)(8676002)(66066001)(81156014)(478600001)(81166006)(4326008)(446003)(256004)(65956001)(64126003)(7736002)(64756008)(386003)(52116002)(53546011)(2906002)(65806001)(305945005)(66446008)(6116002)(66556008)(486006)(58126008)(476003)(54906003)(73956011)(66476007)(31696002)(3846002)(68736007)(11346002)(66946007)(6506007)(316002)(86362001)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6101;H:AM6PR05MB5524.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yqv1vN8uNq3XpHLe8T0Y9zhff+XojRs4BNIHDhDeycCI4fjNtXrkTTDYsswKROZ9lUR5not1OGFXxnbpaXHRAJ32HRSRpjbqqwGu1ChtMxKmn/3yVHOcIKuxbiEbndYB+QVG5JnOksXvZmIPz13CE1B6f8dXvITzQNqVpkYDaZD0u2c36EYsZJBW0FeVqvZ0Cqlv3krYow3xgokLOrQBn3GMWo98iX9Mp1l69Wy6nB44xu6qw3U8ZkH+I/LbwzwARpcE1ho1U6UoDMNbdtoPuZ0l0KKeffHOH8JITqcUl8kQ26txYZqLiUTyP3c895hxhJdJuj0HuF55bXtChn0uR4593WStYURm1EYv+73QKWWGrKnyGEAzemXSJEO7QGsuzdlB0PEFFJAUZ40hpCvLN4tT5oEEOtVp98OA2+Lyio8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1AC524545E1C74A90FAFF3D14FA3398@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 041a6071-8fb0-4c81-072a-08d6e9ec02a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 19:28:38.7974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shalomt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDUvMDYvMjAxOSAyMDo0MCwgUmljaGFyZCBDb2NocmFuIHdyb3RlOg0KPiBPbiBXZWQsIEp1
biAwNSwgMjAxOSBhdCAxMTo0NDoyMUFNICswMDAwLCBTaGFsb20gVG9sZWRvIHdyb3RlOg0KPj4g
T24gMDQvMDYvMjAxOSAxNzoyOCwgUmljaGFyZCBDb2NocmFuIHdyb3RlOg0KPj4+IE5vdyBJIHNl
ZSB3aHkgeW91IGRpZCB0aGlzLiAgTmljZSB0cnkuDQo+Pg0KPj4gSSBkaWRuJ3QgdHJ5IGFueXRo
aW5nLg0KPj4NCj4+IFRoZSByZWFzb24gaXMgdGhhdCB0aGUgaGFyZHdhcmUgdW5pdHMgaXMgaW4g
cHBiIGFuZCBub3QgaW4gc2NhbGVkX3BwbShvciBwcG0pLA0KPj4gc28gSSBqdXN0IGNvbnZlcnRl
ZCB0byBwcGIgaW4gb3JkZXIgdG8gc2V0IHRoZSBoYXJkd2FyZS4NCj4gDQo+IE9oLCBJIHRob3Vn
aHQgeW91IHdlcmUgYWRhcHRpbmcgY29kZSBmb3IgdGhlIGRlcHJlY2F0ZWQgLmFkamZyZXEgbWV0
aG9kLg0KPiAgDQo+PiBCdXQgSSBnb3QgeW91ciBwb2ludCwgSSB3aWxsIGNoYW5nZSBteSBjYWxj
dWxhdGlvbiB0byB1c2Ugc2NhbGVkX3BwbSAodG8gZ2V0IGENCj4+IG1vcmUgZmluZXIgcmVzb2x1
dGlvbikgYW5kIG5vdCBwcGIsIGFuZCBjb252ZXJ0IHRvIHBwYiBqdXN0IGJlZm9yZSBzZXR0aW5n
IHRoZQ0KPj4gaGFyZHdhcmUuIElzIHRoYXQgbWFrZSBzZW5zZT8NCj4gDQo+IFNvIHRoZSBIVyBh
Y3R1YWxseSBhY2NlcHRzIHBwYiBhZGp1c3RtZW50IHZhbHVlcz8gIEZpbmUuDQoNClNvIEkgbGVh
dmUgdGhlIGNvZGUgYXMgaXMuDQoNCj4gDQo+IEJ1dCBJIGRvbid0IHVuZGVyc3RhbmQgdGhpczoN
Cj4gDQo+Pj4+ICsJaWYgKHBwYiA8IDApIHsNCj4+Pj4gKwkJbmVnX2FkaiA9IDE7DQo+Pj4+ICsJ
CXBwYiA9IC1wcGI7DQo+Pj4+ICsJfQ0KPj4+PiArDQo+Pj4+ICsJYWRqID0gY2xvY2stPm5vbWlu
YWxfY19tdWx0Ow0KPj4+PiArCWFkaiAqPSBwcGI7DQo+Pj4+ICsJZGlmZiA9IGRpdl91NjQoYWRq
LCBOU0VDX1BFUl9TRUMpOw0KPj4+PiArDQo+Pj4+ICsJc3Bpbl9sb2NrKCZjbG9jay0+bG9jayk7
DQo+Pj4+ICsJdGltZWNvdW50ZXJfcmVhZCgmY2xvY2stPnRjKTsNCj4+Pj4gKwljbG9jay0+Y3lj
bGVzLm11bHQgPSBuZWdfYWRqID8gY2xvY2stPm5vbWluYWxfY19tdWx0IC0gZGlmZiA6DQo+Pj4+
ICsJCQkJICAgICAgIGNsb2NrLT5ub21pbmFsX2NfbXVsdCArIGRpZmY7DQo+Pj4+ICsJc3Bpbl91
bmxvY2soJmNsb2NrLT5sb2NrKTsNCj4gDQo+IFlvdSBoYXZlIGEgU1cgdGltZSBjb3VudGVyIGhl
cmUNCg0KWWVwLg0KDQo+IA0KPj4+PiArCXJldHVybiBtbHhzd19zcDFfcHRwX3VwZGF0ZV9waGNf
YWRqZnJlcShjbG9jaywgbmVnX2FkaiA/IC1wcGIgOiBwcGIpOw0KPiANCj4gYW5kIGEgaGFyZHdh
cmUgbWV0aG9kIGhlcmU/DQoNClllcC4NCg0KPiANCj4gV2h5IG5vdCBjaG9vc2Ugb25lIG9yIHRo
ZSBvdGhlcj8NCg0KWW91IGFyZSByaWdodCwgYnV0IHRoZXJlIGlzIGEgcmVhc29uIGJlaGluZCBp
dCBvZiBjb3Vyc2UuDQoNClRoZSBoYXJkd2FyZSBoYXMgYSBmcmVlIHJ1bm5pbmcgY291bnRlciB0
aGF0IHRoZSBTVyBjYW4gb25seSByZWFkLiBUaGlzIGlzDQp1c2VkIHdoZW4gd2UgZG8gZ2V0dGlt
ZXggb3AuIFRoZSByZXN0IG9wcywgc2V0dGltZSwgYWRqZmluZSBhbmQgYWRqdGltZSwgd2UgZG8N
Cm9ubHkgaW4gU1csIHNpbmNlIHdlIGNhbid0IGNvbnRyb2wgdGhlIEhXIGZyZWUgcnVubmluZyBj
b3VudGVyLg0KDQpOb3csIHlvdSBhcmUgYXNraW5nIHlvdXJzZWxmLCB3aHkgdGhlIGRyaXZlciBh
bHNvIHVwZGF0ZSB0aGUgSFc/IHdoYXQgZG9lcyBpdA0KbWVhbj8NCg0KU28sIHRoZXJlIGlzIGFu
IEhXIG1hY2hpbmUgd2hpY2ggcmVzcG9uc2libGUgZm9yIGFkZGluZyBVVEMgdGltZXN0YW1wIG9u
DQpSLVNQQU4gbWlycm9yIHBhY2tldHMgYW5kIHRoZXJlIGlzIG5vIGNvbm5lY3Rpb24gdG8gdGhl
IEhXIGZyZWUgcnVubmluZw0KY291bnRlci4gVGhlIFNXIGNhbiBhbmQgc2hvdWxkIGNvbnRyb2wg
dGhpcyBIVyBtYWNoaW5lLCBmcm9tIHNldHRpbmcgdGhlIFVUQw0KdGltZSB3aGVuIGRvaW5nIHNl
dHRpbWUgZm9yIGV4YW1wbGUuIE9yIGFkanVzdGluZyB0aGUgZnJlcXVlbmN5IHdoZW4gZG9pbmcN
CmFkamZpbmUuDQoNCkkgaG9wZSBpdCBpcyBtb3JlIGNsZWFyIG5vdy4NCg0KPiANCj4gVGhhbmtz
LA0KPiBSaWNoYXJkDQo+IA0KDQo=
