Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6011E740AB
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388021AbfGXVK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:10:28 -0400
Received: from mail-eopbgr150049.outbound.protection.outlook.com ([40.107.15.49]:57414
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388004AbfGXVK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 17:10:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SItp1Ebx2Ca1+p0QjPyZ69gDsVEOnZBlb+FrvZhyD/1dGfwY+eIpw+4nw9cv0UjI5to29ZZcDe+KeYiizioBtzuFMrugTopgKfGoS0SJw6ojbBic715Zwno9KaFdP1AFAiEgZhZ584jRrC08WH2XRnp38dCSCP3dkrVN9IhYEaW6hwree3eMQUDYU05fvj3wBIJssEcOEefGO7bOw7nD1wcg0n9NxjJTYXzNlTsBTeRRd6Y+9S6/7XJ0hFDai7ZXMJEk8gzV2T+/++zK1MObrCZOOFik3HTSlxqTXGqyesUIFGpBgoKhy9nrxhB8f2L7pzoRMmBU/3RU6nQFuRT3VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KB2XI3oMwXz+QywDTTF5L31KxCJrKC5+QKhdBV/+Dus=;
 b=HPdrdv/XLnrtefsl7vkOq3rzFFS4iecoiWnZngNrVcYAnVKaucOvAwIDCcN5NANfmSHV1Nv77MwsPrsWj2O6vFauflq0KGSemf0TP9lbHlgRCijzwa8SEsl+NBwnvBRriMUd2HE1CfIEKj/lAYsGj2oQV9eRlsl3ZR69IF1eufUmJ6AVtCOHKsqeSDoYEBVWQtX76qvQ+0UmCc2wmgGJ13ypJQvSt+ZUPKoC7rxHnJi1m8HYgGOn7eNC5KJYID8LBTrTxiT+M1+t+o6aV8pay4R3MjiKgBkdmYDkd6mo+J+vISBHokfqUOd3zuA87xXLc/wOniVVSfOyCEdYpcMFzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KB2XI3oMwXz+QywDTTF5L31KxCJrKC5+QKhdBV/+Dus=;
 b=ro6PlrXYnydRpCM4Ni6yeIDfQVg2ijlKvxGT9Fz5dNc9zE7K2JHYhL7xTWSOhfY5VhZ/O9SchsuQLTfGdyXBlZplcfgCGVy5b6ulGkj/8x35QB62nelNxd7oUMD29bBzbrJUOhN1njQtgoQTciknofoFAULa5pBBAw2fVFSOa8I=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2167.eurprd05.prod.outlook.com (10.168.58.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 24 Jul 2019 21:10:25 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Wed, 24 Jul 2019
 21:10:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "snelson@pensando.io" <snelson@pensando.io>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v4 net-next 11/19] ionic: Add Rx filter and rx_mode ndo
 support
Thread-Topic: [PATCH v4 net-next 11/19] ionic: Add Rx filter and rx_mode ndo
 support
Thread-Index: AQHVQNYh0hIXTEJm+k+NKGK2L/AMCqbY2M0AgAANJgCAAWDJAA==
Date:   Wed, 24 Jul 2019 21:10:24 +0000
Message-ID: <109ed9efba93bb45017ad3628c107cfa65821b09.camel@mellanox.com>
References: <20190722214023.9513-1-snelson@pensando.io>
         <20190722214023.9513-12-snelson@pensando.io>
         <1ce8b25ccb5632a33be6d18714aadfdabd4105ce.camel@mellanox.com>
         <dbc85d6d-b0cd-43d4-aded-88b482ecc477@pensando.io>
In-Reply-To: <dbc85d6d-b0cd-43d4-aded-88b482ecc477@pensando.io>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71fe691f-595a-4421-3c8e-08d7107b58af
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2167;
x-ms-traffictypediagnostic: DB6PR0501MB2167:
x-microsoft-antispam-prvs: <DB6PR0501MB2167D37489E6CBF4A23305C8BEC60@DB6PR0501MB2167.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(189003)(199004)(6486002)(2501003)(36756003)(4744005)(76176011)(2201001)(256004)(14454004)(66066001)(5660300002)(81166006)(316002)(3846002)(25786009)(8936002)(53936002)(14444005)(476003)(76116006)(305945005)(6246003)(11346002)(446003)(66446008)(66946007)(81156014)(6116002)(64756008)(6512007)(99286004)(66556008)(186003)(2616005)(6506007)(86362001)(71190400001)(2906002)(478600001)(486006)(26005)(229853002)(53546011)(102836004)(7736002)(110136005)(118296001)(6436002)(68736007)(91956017)(71200400001)(8676002)(66476007)(58126008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2167;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AiDVuEC9lVUsA1d5YIf+KuQfiOKcaT6OJ+grYFxZ4udpmXWsoRQxff/+Y7PFUq/cavcynEpfS4zdDEwDiwvnJ63niAkMQxENMhNw6DXp9n5O3WX8Yz1sg5X4X+dnutso6hdbS/lGcY41EPLRLCENz6Aj1VvssAign2h5P5lUY33U1TGyRwg/FCldHs2buf5uQCr+lMCTcyjRoN/zdmjSvF5AAZLNph9suwGkvHAY6TM4KzHtNeepTTkK5TFGtCJbaYe0AoytXRTat/UByU+YvcoaWjcWmRIQ2I+hlOCr5wSvZCuY+76i1k35VXgANhnCvAHjwQi58I0VTLYhSe1savOlcD8L/TRMiAlVjITef+OVHqGhhUUhz5yzUKSslw9vIFUs/whk1Ex2/YmLRK5uXJrIQw8+tGzoLoO/fdpdgvk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E562C8DAFA28BE4491F467DBE4639DB2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71fe691f-595a-4421-3c8e-08d7107b58af
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 21:10:24.9276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2167
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDE3OjA3IC0wNzAwLCBTaGFubm9uIE5lbHNvbiB3cm90ZToN
Cj4gT24gNy8yMy8xOSA0OjIwIFBNLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPiBPbiBNb24s
IDIwMTktMDctMjIgYXQgMTQ6NDAgLTA3MDAsIFNoYW5ub24gTmVsc29uIHdyb3RlOg0KPiA+ID4g
QEAgLTYwNyw2ICs5NDcsOCBAQCBzdGF0aWMgdm9pZCBpb25pY19saWZfZnJlZShzdHJ1Y3QgbGlm
ICpsaWYpDQo+ID4gPiAgIAlpb25pY19xY3FzX2ZyZWUobGlmKTsNCj4gPiA+ICAgCWlvbmljX2xp
Zl9yZXNldChsaWYpOw0KPiA+ID4gICANCj4gPiBJIGRvbid0IHRoaW5rIHlvdSB3YW50IGRlZmVy
cmVkLndvcmsgcnVubmluZyB3aGlsZSByZXNldCBpcw0KPiA+IGV4ZWN1dGluZy4uDQo+ID4gY2Fu
Y2VsX3dvcmtfc3luYyBzaG91bGQgaGFwcGVuIGFzIGVhcmx5IGFzIHlvdSBjbG9zZSB0aGUgbmV0
ZGV2aWNlLg0KPiANCj4gR2l2ZW4gdGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24sIGl0IGRvZXNu
J3QgYWN0dWFsbHkgaHVydCBhbnl0aGluZywNCj4gYnV0IA0KPiB5ZXMgaXQgbWFrZXMgc2Vuc2Ug
dG8gbW92ZSBpdCB1cCBpbiB0aGUgc2VxdWVuY2UuDQo+IA0KPiA+IEkgYXNzdW1lIGlvbmljX2xp
Zl9yZXNldCB3aWxsIGZsdXNoIGFsbCBjb25maWd1cmF0aW9ucyBhbmQgeW91DQo+ID4gZG9uJ3QN
Cj4gPiBuZWVkIHRvIGNsZWFudXAgYW55dGhpbmcgbWFudWFsbHk/ICBvciBhbnkgZGF0YSBzdHJ1
Y3R1cmUgc3RvcmVkIGluDQo+ID4gZHJpdmVyID8NCj4gDQo+IE1vc3Qgb2YgdGhlIGRyaXZlciBk
YXRhIHN0cnVjdHVyZSBjbGVhbmluZyBoYXMgaGFwcGVuZWQgaW4gDQo+IGlvbmljX2xpZl9kZWlu
aXQoKSBiZWZvcmUgZ2V0dGluZyBoZXJlLg0KDQpUaGlzIG1lYW5zIHRoYXQgeW8gZG8gaGF2ZSBh
IHByb2JsZW0ga2VlcGluZyB0aGUgZGVmZXJyZWQud29yayBydW5uaW5nDQphZnRlciBpb25pY19s
aWZfZGVpbml0DQoNCj4gDQo+IHNsbg0KPiANCg==
