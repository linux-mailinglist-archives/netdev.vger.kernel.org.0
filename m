Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE3736F41
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfFFI6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:58:03 -0400
Received: from mail-eopbgr30080.outbound.protection.outlook.com ([40.107.3.80]:44800
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727484AbfFFI6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 04:58:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=boMjHCtC2STqyDv5bTjKhROpVv+LIsCyR9hnkRb1YSw=;
 b=eZs96gc/e9aF80SH+z0tgaTLQ4CEEfcOSbjmjQvh9/Rif/yQlgcFA13uu1U5PyzsKFwKBiKHUu0u/dVxvVbDZyI6OD5Pjf7ll//yJXm9tVDqaV1bPl7G2XfW+PnXO4Lm0ze5Jzl+39RLKcjnZAT0MDg5DE2r0b+g848PXxYjgJY=
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com (20.177.119.89) by
 AM6PR05MB4502.eurprd05.prod.outlook.com (52.135.163.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Thu, 6 Jun 2019 08:57:59 +0000
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae]) by AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae%5]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 08:57:59 +0000
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
Thread-Index: AQHVGgXTQ0R6KLy1CUKANB7103lOSqaLj3aAgAFkg4CAAGN+gIAAHjmAgAB5eACAAGaBgIAAAigA
Date:   Thu, 6 Jun 2019 08:57:59 +0000
Message-ID: <1d4e8e2f-684d-f703-3008-be0ee1ef4e7a@mellanox.com>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-8-idosch@idosch.org>
 <20190604142819.cml2tbkmcj2mvkpl@localhost>
 <5c757fb9-8b47-c03a-6b78-45ac2b2140f3@mellanox.com>
 <20190605174025.uwy2u7z55v3c2opm@localhost>
 <be656773-93e8-2f95-ad63-bfec18c9523a@mellanox.com>
 <20190606024320.6ilfk5ur3a3d6ead@localhost>
 <7c51a280-9d39-3a13-fd92-5e5afcca07d9@mellanox.com>
In-Reply-To: <7c51a280-9d39-3a13-fd92-5e5afcca07d9@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
x-clientproxiedby: AM6PR0502CA0019.eurprd05.prod.outlook.com (52.133.16.160)
 To AM6PR05MB5524.eurprd05.prod.outlook.com (20.177.119.89)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce32783f-8faa-4a08-9c6f-08d6ea5d12ed
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4502;
x-ms-traffictypediagnostic: AM6PR05MB4502:
x-microsoft-antispam-prvs: <AM6PR05MB45025794738C3CDD27E9189DC5170@AM6PR05MB4502.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(136003)(396003)(39860400002)(376002)(189003)(199004)(81156014)(6506007)(25786009)(81166006)(6512007)(1411001)(8676002)(2906002)(53936002)(107886003)(4326008)(64126003)(54906003)(36756003)(6486002)(7736002)(229853002)(8936002)(386003)(65826007)(6916009)(6246003)(6436002)(71190400001)(73956011)(71200400001)(66066001)(76176011)(305945005)(64756008)(66946007)(316002)(68736007)(66476007)(58126008)(5660300002)(26005)(31686004)(4744005)(102836004)(3846002)(6116002)(186003)(256004)(53546011)(486006)(14454004)(86362001)(99286004)(52116002)(31696002)(65956001)(65806001)(11346002)(476003)(2616005)(66556008)(66446008)(446003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4502;H:AM6PR05MB5524.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5Ez5D+bI8Ug1SMmuRTu+kNkDC64Yw98aIv62DcjijnINzeJ4SvNGsYA6Zos7LT2gFX5uoSdoy9KXZ8AIMTWFQzvu4XbMwCA9TJP+0SFHmYK61PGK0KJ3pelJg/fTDSo5qq7KH8mlgQHa6UY+24GS6D6km1TQz5YiyYHgC9J24htpIIUxhBgy7pYgHvRysXnSoSjCaTkcgQn3mn0MlL1WLpc4fqrhgGh24NwnBJNWt3xRPrmkmHkgXo2WK5Enh+7s3tZWb7VUIZ2A3o2+Akpd+ozGime9PapM4bmoHKI4wjT9uoD/DEiD6wZJZbZaZfFpjkN5hQ1PHRIU45+O/Ezd75HlFkjPuqST3Re8bAZh+HCygim6da2IOWFMzlyV/jUK2flzjNC7c/wF0vZSEjrGm+4ky13uK6q0VKwdflRnJ3Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B96A9824C56E845B24482A952CCB266@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce32783f-8faa-4a08-9c6f-08d6ea5d12ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 08:57:59.3441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shalomt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4502
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDYvMDYvMjAxOSAxMTo1MCwgU2hhbG9tIFRvbGVkbyB3cm90ZToNCj4gT24gMDYvMDYvMjAx
OSA1OjQzLCBSaWNoYXJkIENvY2hyYW4gd3JvdGU6DQo+PiBPbiBXZWQsIEp1biAwNSwgMjAxOSBh
dCAwNzoyODozOFBNICswMDAwLCBTaGFsb20gVG9sZWRvIHdyb3RlOg0KPj4+IFNvLCB0aGVyZSBp
cyBhbiBIVyBtYWNoaW5lIHdoaWNoIHJlc3BvbnNpYmxlIGZvciBhZGRpbmcgVVRDIHRpbWVzdGFt
cCBvbg0KPj4+IFItU1BBTiBtaXJyb3IgcGFja2V0cyBhbmQgdGhlcmUgaXMgbm8gY29ubmVjdGlv
biB0byB0aGUgSFcgZnJlZSBydW5uaW5nDQo+Pj4gY291bnRlci4NCj4+DQo+PiBJZiB0aGVyZSBp
cyBubyBjb25uZWN0aW9uLCB0aGVuIHRoZSBmcmVxdWVuY3kgYWRqdXN0bWVudHMgdG8gdGhlIEhX
DQo+PiBjbG9jayB3aWxsIG5vdCB3b3JrIGFzIGV4cGVjdGVkLg0KPiANCj4gSSBtZWFuIHRoYXQg
dGhlc2UgYXJlIHR3byBkaWZmZXJlbnQgcGVhY2VzIG9mIEhXIHdpdGggZGlmZmVyZW50IGNvbnRy
b2wNCj4gaW50ZXJmYWNlcy4NCg0KcGllY2VzKg0KDQo+IA0KPj4NCj4+IFBlcmhhcHMgdGhlIGZy
ZWUgcnVubmluZyBjb3VudGVyIGFuZCB0aGUgSFcgY2xvY2sgc2hhcmUgdGhlIHNhbWUgY2xvY2sN
Cj4+IHNvdXJjZT8NCj4gDQo+IFllcywgb2YgY291cnNlLg0KPiANCj4+DQo+PiBUaGFua3MsDQo+
PiBSaWNoYXJkDQo+Pg0KPiANCg0K
