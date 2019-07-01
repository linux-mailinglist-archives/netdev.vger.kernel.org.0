Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C68CB5B5AA
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 09:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfGAHWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 03:22:00 -0400
Received: from mail-eopbgr00064.outbound.protection.outlook.com ([40.107.0.64]:48740
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727224AbfGAHWA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 03:22:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+eQ3Zz82wqMr058esOOs4LD1ATTcUkJmc6PDIe050M=;
 b=T/R/bQBmHPi4cL8byEYBemzk5ji3cqCQS9su8fwoKawjXUCx0uJn/AnOxdn6TzQURr6tRpnGmMUn8IWg0M0miT0kCkobQKB70cgVTI05RiQU7eR9v46P+VtkPw6jpsHwQD7YU8/kV6ZvfudzThuobqvcphNJVIYEHamprZxltcU=
Received: from AM0PR05MB6274.eurprd05.prod.outlook.com (20.179.32.142) by
 AM0PR05MB6403.eurprd05.prod.outlook.com (20.179.33.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Mon, 1 Jul 2019 07:21:55 +0000
Received: from AM0PR05MB6274.eurprd05.prod.outlook.com
 ([fe80::1cc3:1163:6c88:384d]) by AM0PR05MB6274.eurprd05.prod.outlook.com
 ([fe80::1cc3:1163:6c88:384d%5]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 07:21:55 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Ran Rozenstein <ranro@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "fw@strlen.de" <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: Re: [PATCH net-next 0/2] net: ipv4: fix circular-list infinite loop
Thread-Topic: [PATCH net-next 0/2] net: ipv4: fix circular-list infinite loop
Thread-Index: AQHVLOBaV/70ff2t5kGwV9qdZG2IyKavuFoAgARS5wCAAUxpAIAACeKA
Date:   Mon, 1 Jul 2019 07:21:55 +0000
Message-ID: <3f13a431-0013-6150-737f-d1c63c515d57@mellanox.com>
References: <20190627120333.12469-1-fw@strlen.de>
 <20190627.095458.1221651269287757130.davem@davemloft.net>
 <d419cd16-e693-2214-fa41-4c9c81f1649d@mellanox.com>
 <AM4PR0501MB27693D777034422FC18A98B9C5F90@AM4PR0501MB2769.eurprd05.prod.outlook.com>
In-Reply-To: <AM4PR0501MB27693D777034422FC18A98B9C5F90@AM4PR0501MB2769.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR06CA0034.eurprd06.prod.outlook.com
 (2603:10a6:20b:14::47) To AM0PR05MB6274.eurprd05.prod.outlook.com
 (2603:10a6:208:139::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f75753e7-a003-4528-3a90-08d6fdf4cb7d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6403;
x-ms-traffictypediagnostic: AM0PR05MB6403:
x-microsoft-antispam-prvs: <AM0PR05MB64034919FB2F360648016554AEF90@AM0PR05MB6403.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(189003)(199004)(13464003)(7736002)(11346002)(305945005)(2616005)(476003)(486006)(86362001)(229853002)(66066001)(31686004)(186003)(6246003)(4326008)(446003)(31696002)(6506007)(53546011)(386003)(36756003)(76176011)(6436002)(2906002)(6512007)(25786009)(6486002)(107886003)(478600001)(102836004)(52116002)(71190400001)(66476007)(71200400001)(66556008)(64756008)(5660300002)(54906003)(3846002)(99286004)(53936002)(66446008)(66946007)(73956011)(8936002)(68736007)(81156014)(110136005)(6116002)(14444005)(81166006)(316002)(256004)(2501003)(26005)(14454004)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6403;H:AM0PR05MB6274.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P9ez/IJ5STPB/pw+zgLc6H/F9bZkTBhrXxcyIg0rr42zyTZxzIaNZK45h2645hHbW19BCXhf7xeT3WUmSePEJsZGKFj03kjwbV3WuPLvy6PZElhNoP+9wyOLwRMNFz/+8pSh1Tkj4xgaMQbXyge5W6qw+0A56Wr+H5C5N/lQnproLjNCQAHe8qZklyo+L/rQH2O9XkURNi7lljhMUECC3GOn1SIgGyuQPb6AMWlrFMg64/jlwug9k4c38jZ1tZrj0X5pqjpQNX1gxBnYs2S1AKinNCMu3Gd+HHFb/3k/4NnuZ5ueFmZeacIEHfpMUkFy0Y7n58uSYjJqkmGmAokGrr0/zaQ5+QETB9o+PcdWn7fBz4ifylMajiD7Np+s/fenLZQXlKcsnvP2eCn4Zj9cfjUTMvP8KDzmchGyJXfYgKs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8BD9FB95550CFE459B633A8AB4374849@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f75753e7-a003-4528-3a90-08d6fdf4cb7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 07:21:55.0601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6403
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMS8yMDE5IDk6NDYgQU0sIFJhbiBSb3plbnN0ZWluIHdyb3RlOg0KPiANCj4gDQo+
PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPj4gRnJvbTogVGFyaXEgVG91a2FuDQo+PiBT
ZW50OiBTdW5kYXksIEp1bmUgMzAsIDIwMTkgMTA6NTcNCj4+IFRvOiBEYXZpZCBNaWxsZXIgPGRh
dmVtQGRhdmVtbG9mdC5uZXQ+OyBmd0BzdHJsZW4uZGUNCj4+IENjOiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBSYW4gUm96ZW5zdGVpbiA8cmFucm9AbWVsbGFub3guY29tPjsgVGFyaXENCj4+IFRv
dWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5l
eHQgMC8yXSBuZXQ6IGlwdjQ6IGZpeCBjaXJjdWxhci1saXN0IGluZmluaXRlIGxvb3ANCj4+DQo+
Pg0KPj4NCj4+IE9uIDYvMjcvMjAxOSA3OjU0IFBNLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+Pj4g
RnJvbTogRmxvcmlhbiBXZXN0cGhhbCA8ZndAc3RybGVuLmRlPg0KPj4+IERhdGU6IFRodSwgMjcg
SnVuIDIwMTkgMTQ6MDM6MzEgKzAyMDANCj4+Pg0KPj4+PiBUYXJpcSBhbmQgUmFuIHJlcG9ydGVk
IGEgcmVncmVzc2lvbiBjYXVzZWQgYnkgbmV0LW5leHQgY29tbWl0DQo+Pj4+IDI2MzhlYjhiNTBj
ZiAoIm5ldDogaXB2NDogcHJvdmlkZSBfX3JjdSBhbm5vdGF0aW9uIGZvciBpZmFfbGlzdCIpLg0K
Pj4+Pg0KPj4+PiBUaGlzIGhhcHBlbnMgd2hlbiBuZXQuaXB2NC5jb25mLiRkZXYucHJvbW90ZV9z
ZWNvbmRhcmllcyBzeXNjdGwgaXMNCj4+Pj4gZW5hYmxlZCAtLSB3ZSBjYW4gYXJyYW5nZSBmb3Ig
aWZhLT5uZXh0IHRvIHBvaW50IGF0IGlmYSwgc28gbmV4dA0KPj4+PiBwcm9jZXNzIHRoYXQgdHJp
ZXMgdG8gd2FsayB0aGUgbGlzdCBsb29wcyBmb3JldmVyLg0KPj4+Pg0KPj4+PiBGaXggdGhpcyBh
bmQgZXh0ZW5kIHJ0bmV0bGluay5zaCB3aXRoIGEgc21hbGwgdGVzdCBjYXNlIGZvciB0aGlzLg0K
Pj4+DQo+Pj4gU2VyaWVzIGFwcGxpZWQsIHRoYW5rcyBGbG9yaWFuLg0KPj4+DQo+Pg0KPj4gVGhh
bmtzIEZsb3JpYW4hDQo+Pg0KPj4gUmFuLCBwbGVhc2UgdGVzdCBhbmQgdXBkYXRlLg0KPj4NCj4+
IFRhcmlxDQo+IA0KPiBUaGFua3MgRmxvcmlhbi4NCj4gRGlkbid0IHJlcHJvZHVjZSB0b25pZ2h0
IHdpdGggdGhlIGZpeGVzLg0KPiANCj4gUmFuLg0KPiANCg0KU291bmRzIGdvb2QhDQoNClRoYW5r
cywNClRhcmlxDQo=
