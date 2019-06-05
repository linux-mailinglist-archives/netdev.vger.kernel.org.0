Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0E835B9A
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 13:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfFELo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 07:44:27 -0400
Received: from mail-eopbgr10089.outbound.protection.outlook.com ([40.107.1.89]:42617
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727948AbfFELoZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 07:44:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kayFffFsfJhZSsRrwkYAmT0m12cx8nP3W5YWUmKyQWg=;
 b=nc7obCBstyCPKaOaKY2R9/rCAT/+iEr+5xZPApQTDW7MijPOpRio/HKkzA50Rr8hdkeL/Km0rB4KDDAMx707gPFzl2uJcns9hnGQZQDSbiEEkyv37PHqyFTzppKuvjfUGAtlprh2T0L3acJKlDiWHQfe5bv6uA2WPL3w246B2CA=
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com (20.177.119.89) by
 AM6PR05MB4342.eurprd05.prod.outlook.com (52.135.162.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Wed, 5 Jun 2019 11:44:22 +0000
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae]) by AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae%5]) with mapi id 15.20.1965.011; Wed, 5 Jun 2019
 11:44:21 +0000
From:   Shalom Toledo <shalomt@mellanox.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Thread-Topic: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Thread-Index: AQHVGgXTQ0R6KLy1CUKANB7103lOSqaLj3aAgAFkg4A=
Date:   Wed, 5 Jun 2019 11:44:21 +0000
Message-ID: <5c757fb9-8b47-c03a-6b78-45ac2b2140f3@mellanox.com>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-8-idosch@idosch.org>
 <20190604142819.cml2tbkmcj2mvkpl@localhost>
In-Reply-To: <20190604142819.cml2tbkmcj2mvkpl@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
x-clientproxiedby: AM6P193CA0128.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::33) To AM6PR05MB5524.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8a6ab13-da9d-4969-528b-08d6e9ab269e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4342;
x-ms-traffictypediagnostic: AM6PR05MB4342:
x-microsoft-antispam-prvs: <AM6PR05MB43426D867BCF7BD05535F991C5160@AM6PR05MB4342.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(14454004)(256004)(5660300002)(316002)(81166006)(81156014)(65826007)(305945005)(7736002)(8676002)(25786009)(54906003)(58126008)(110136005)(6246003)(14444005)(8936002)(186003)(53936002)(2906002)(64126003)(508600001)(99286004)(86362001)(76176011)(6506007)(11346002)(386003)(486006)(66556008)(229853002)(31696002)(68736007)(71190400001)(71200400001)(66476007)(66446008)(64756008)(6436002)(6486002)(52116002)(66066001)(6512007)(26005)(65956001)(65806001)(6116002)(66946007)(4326008)(36756003)(107886003)(53546011)(446003)(73956011)(2616005)(476003)(3846002)(31686004)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4342;H:AM6PR05MB5524.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EF6KuGo1YxdEzpFcrzAwHZDS4N9cLe7UY6P0/ZC+rWT8Tn02mw/AyNtrJE6C8Plv6FanoGpODU4LkCpilhAv/RvkNdRODEXnz6CO/wlK9Fpq3XIBo4yBbD6XZdRY8+LWWsxDTY6zzhj9vRxPS4C/wuHhxg7mSgNjq5ePO41Qtk8S7YYxCArp87+dfrpHo2ZLevpJNx3iO99GG6CP9TtMcAMGaWpw1GziFXaCYOBdZz/NKtZ4WeOmz3oNGVTN6IySdDtYHRoqAbLIAzWpWCHYtknnEVYWscAQMZedKdkikez83KcLPd/0oXgs1VQsNbeQGh9bZno80KMADXe5RmiTSCnsgi+ypLrehLp7G/K9OgbU9JGmRJLbhNoecB444jktEjB8IEi2HPX6bsC0xJye4SEdoWYGVBkfjRLTaNsbhCU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F355D33CE92454C9FB4EF7BD00C4DC1@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a6ab13-da9d-4969-528b-08d6e9ab269e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 11:44:21.8861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shalomt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4342
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDQvMDYvMjAxOSAxNzoyOCwgUmljaGFyZCBDb2NocmFuIHdyb3RlOg0KPiBPbiBNb24sIEp1
biAwMywgMjAxOSBhdCAwMzoxMjo0MlBNICswMzAwLCBJZG8gU2NoaW1tZWwgd3JvdGU6DQo+IA0K
Pj4gK3N0YXRpYyBpbnQNCj4+ICttbHhzd19zcDFfcHRwX3VwZGF0ZV9waGNfc2V0dGltZShzdHJ1
Y3QgbWx4c3dfc3BfcHRwX2Nsb2NrICpjbG9jaywgdTY0IG5zZWMpDQo+IA0KPiBTaXggd29yZHMg
Xl5eDQo+IA0KPiBXaGF0IGlzIHdyb25nIHdpdGggIm1seHN3X3BoY19zZXR0aW1lIiA/DQoNCkkg
Y2FuIGRyb3AgdGhlICJ1cGRhdGUiLiBCdXQgYXMgSmlyaSBtZW50aW9uZWQsIGl0IGlzIGFsaWdu
ZWQgd2l0aCB0aGUgcmVzdCBvZg0KbWx4c3cgY29kZS4NCg0KPiANCj4+ICt7DQo+PiArCXN0cnVj
dCBtbHhzd19jb3JlICptbHhzd19jb3JlID0gY2xvY2stPmNvcmU7DQo+PiArCWNoYXIgbXR1dGNf
cGxbTUxYU1dfUkVHX01UVVRDX0xFTl07DQo+PiArCWNoYXIgbXRwcHNfcGxbTUxYU1dfUkVHX01U
UFBTX0xFTl07DQo+PiArCXU2NCBuZXh0X3NlY19pbl9uc2VjLCBjeWNsZXM7DQo+PiArCXUzMiBu
ZXh0X3NlYzsNCj4+ICsJaW50IGVycjsNCj4+ICsNCj4+ICsJbmV4dF9zZWMgPSBuc2VjIC8gTlNF
Q19QRVJfU0VDICsgMTsNCj4+ICsJbmV4dF9zZWNfaW5fbnNlYyA9IG5leHRfc2VjICogTlNFQ19Q
RVJfU0VDOw0KPj4gKw0KPj4gKwlzcGluX2xvY2soJmNsb2NrLT5sb2NrKTsNCj4+ICsJY3ljbGVz
ID0gbWx4c3dfc3AxX3B0cF9uczJjeWNsZXMoJmNsb2NrLT50YywgbmV4dF9zZWNfaW5fbnNlYyk7
DQo+PiArCXNwaW5fdW5sb2NrKCZjbG9jay0+bG9jayk7DQo+PiArDQo+PiArCW1seHN3X3JlZ19t
dHBwc192cGluX3BhY2sobXRwcHNfcGwsIGN5Y2xlcyk7DQo+PiArCWVyciA9IG1seHN3X3JlZ193
cml0ZShtbHhzd19jb3JlLCBNTFhTV19SRUcobXRwcHMpLCBtdHBwc19wbCk7DQo+PiArCWlmIChl
cnIpDQo+PiArCQlyZXR1cm4gZXJyOw0KPj4gKw0KPj4gKwltbHhzd19yZWdfbXR1dGNfcGFjayht
dHV0Y19wbCwNCj4+ICsJCQkgICAgIE1MWFNXX1JFR19NVFVUQ19PUEVSQVRJT05fU0VUX1RJTUVf
QVRfTkVYVF9TRUMsDQo+PiArCQkJICAgICAwLCBuZXh0X3NlYyk7DQo+PiArCXJldHVybiBtbHhz
d19yZWdfd3JpdGUobWx4c3dfY29yZSwgTUxYU1dfUkVHKG10dXRjKSwgbXR1dGNfcGwpOw0KPj4g
K30NCj4+ICsNCj4+ICtzdGF0aWMgaW50IG1seHN3X3NwMV9wdHBfYWRqZmluZShzdHJ1Y3QgcHRw
X2Nsb2NrX2luZm8gKnB0cCwgbG9uZyBzY2FsZWRfcHBtKQ0KPj4gK3sNCj4+ICsJc3RydWN0IG1s
eHN3X3NwX3B0cF9jbG9jayAqY2xvY2sgPQ0KPj4gKwkJY29udGFpbmVyX29mKHB0cCwgc3RydWN0
IG1seHN3X3NwX3B0cF9jbG9jaywgcHRwX2luZm8pOw0KPj4gKwlpbnQgbmVnX2FkaiA9IDA7DQo+
PiArCXUzMiBkaWZmOw0KPj4gKwl1NjQgYWRqOw0KPj4gKwlzMzIgcHBiOw0KPj4gKw0KPj4gKwlw
cGIgPSBwdHBfY2xvY2tfc2NhbGVkX3BwbV90b19wcGIoc2NhbGVkX3BwbSk7DQo+IA0KPiBOb3cg
SSBzZWUgd2h5IHlvdSBkaWQgdGhpcy4gIE5pY2UgdHJ5Lg0KDQpJIGRpZG4ndCB0cnkgYW55dGhp
bmcuDQoNClRoZSByZWFzb24gaXMgdGhhdCB0aGUgaGFyZHdhcmUgdW5pdHMgaXMgaW4gcHBiIGFu
ZCBub3QgaW4gc2NhbGVkX3BwbShvciBwcG0pLA0Kc28gSSBqdXN0IGNvbnZlcnRlZCB0byBwcGIg
aW4gb3JkZXIgdG8gc2V0IHRoZSBoYXJkd2FyZS4NCg0KQnV0IEkgZ290IHlvdXIgcG9pbnQsIEkg
d2lsbCBjaGFuZ2UgbXkgY2FsY3VsYXRpb24gdG8gdXNlIHNjYWxlZF9wcG0gKHRvIGdldCBhDQpt
b3JlIGZpbmVyIHJlc29sdXRpb24pIGFuZCBub3QgcHBiLCBhbmQgY29udmVydCB0byBwcGIganVz
dCBiZWZvcmUgc2V0dGluZyB0aGUNCmhhcmR3YXJlLiBJcyB0aGF0IG1ha2Ugc2Vuc2U/DQoNCkJ1
dCBJJ20gc3RpbGwgbmVlZCB0byBleHBvc2Ugc2NhbGVkX3BwbV90b19wcGIuDQoNCj4gDQo+IFRo
ZSAnc2NhbGVkX3BwbScgaGFzIGEgZmluZXIgcmVzb2x1dGlvbiB0aGFuIHBwYi4gIFBsZWFzZSBt
YWtlIHVzZSBvZg0KPiB0aGUgZmluZXIgcmVzb2x1dGlvbiBpbiB5b3VyIGNhbGN1bGF0aW9uLiAg
SXQgZG9lcyBtYWtlIGEgZGlmZmVyZW5jZS4NCg0KV2lsbCBjaGFuZ2UsIHRoYW5rcyBmb3IgdGhh
dCENCg0KPiANCj4+ICsNCj4+ICsJaWYgKHBwYiA8IDApIHsNCj4+ICsJCW5lZ19hZGogPSAxOw0K
Pj4gKwkJcHBiID0gLXBwYjsNCj4+ICsJfQ0KPj4gKw0KPj4gKwlhZGogPSBjbG9jay0+bm9taW5h
bF9jX211bHQ7DQo+PiArCWFkaiAqPSBwcGI7DQo+PiArCWRpZmYgPSBkaXZfdTY0KGFkaiwgTlNF
Q19QRVJfU0VDKTsNCj4+ICsNCj4+ICsJc3Bpbl9sb2NrKCZjbG9jay0+bG9jayk7DQo+PiArCXRp
bWVjb3VudGVyX3JlYWQoJmNsb2NrLT50Yyk7DQo+PiArCWNsb2NrLT5jeWNsZXMubXVsdCA9IG5l
Z19hZGogPyBjbG9jay0+bm9taW5hbF9jX211bHQgLSBkaWZmIDoNCj4+ICsJCQkJICAgICAgIGNs
b2NrLT5ub21pbmFsX2NfbXVsdCArIGRpZmY7DQo+PiArCXNwaW5fdW5sb2NrKCZjbG9jay0+bG9j
ayk7DQo+PiArDQo+PiArCXJldHVybiBtbHhzd19zcDFfcHRwX3VwZGF0ZV9waGNfYWRqZnJlcShj
bG9jaywgbmVnX2FkaiA/IC1wcGIgOiBwcGIpOw0KPj4gK30NCj4gDQo+IFRoYW5rcywNCj4gUmlj
aGFyZA0KPiANCg0K
