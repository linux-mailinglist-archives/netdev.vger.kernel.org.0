Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 423845B546
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 08:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfGAGqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 02:46:32 -0400
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:2628
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727080AbfGAGqc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 02:46:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NI1ONVtXH9b3vNa3xrsNeneQXFbKfff23lkE/mX238E=;
 b=IA+qIkw7fdzjm8diUMfJQo9F2r3GNdshy3dXB34VKOdkmc2TBQ2Qjig33rZIx4uuDKC6NwQsxAgaI/HR0huu8oGvfLu3d7GaqHJ2C238MoK49abFvPk08wB+oCttekkDUs4b6R+3L/6SlA1QiIXCfv4YTn0u89vAmypvbKz7fqs=
Received: from AM4PR0501MB2769.eurprd05.prod.outlook.com (10.172.222.15) by
 AM4PR0501MB2164.eurprd05.prod.outlook.com (10.165.82.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Mon, 1 Jul 2019 06:46:28 +0000
Received: from AM4PR0501MB2769.eurprd05.prod.outlook.com
 ([fe80::2d5b:c43:f265:f180]) by AM4PR0501MB2769.eurprd05.prod.outlook.com
 ([fe80::2d5b:c43:f265:f180%11]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 06:46:28 +0000
From:   Ran Rozenstein <ranro@mellanox.com>
To:     Tariq Toukan <tariqt@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "fw@strlen.de" <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: RE: [PATCH net-next 0/2] net: ipv4: fix circular-list infinite loop
Thread-Topic: [PATCH net-next 0/2] net: ipv4: fix circular-list infinite loop
Thread-Index: AQHVLOBa1UBc7Rc+R0ChDsfcyl8nZaavuFoAgAQgoQCAAX5AcA==
Date:   Mon, 1 Jul 2019 06:46:28 +0000
Message-ID: <AM4PR0501MB27693D777034422FC18A98B9C5F90@AM4PR0501MB2769.eurprd05.prod.outlook.com>
References: <20190627120333.12469-1-fw@strlen.de>
 <20190627.095458.1221651269287757130.davem@davemloft.net>
 <d419cd16-e693-2214-fa41-4c9c81f1649d@mellanox.com>
In-Reply-To: <d419cd16-e693-2214-fa41-4c9c81f1649d@mellanox.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ranro@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5825167a-4901-443e-badf-08d6fdefd84b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2164;
x-ms-traffictypediagnostic: AM4PR0501MB2164:
x-microsoft-antispam-prvs: <AM4PR0501MB2164A8C4B05BAC0D3B76E39DC5F90@AM4PR0501MB2164.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(13464003)(199004)(189003)(7696005)(9686003)(11346002)(4744005)(55016002)(476003)(53936002)(6436002)(486006)(68736007)(3846002)(66066001)(86362001)(99286004)(14454004)(6116002)(66946007)(7736002)(102836004)(73956011)(14444005)(446003)(25786009)(74316002)(229853002)(53546011)(71190400001)(71200400001)(76116006)(76176011)(478600001)(305945005)(2501003)(6506007)(4326008)(52536014)(256004)(81156014)(81166006)(8676002)(5660300002)(8936002)(66476007)(66446008)(64756008)(66556008)(6246003)(107886003)(26005)(2906002)(33656002)(186003)(316002)(110136005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2164;H:AM4PR0501MB2769.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YENZhnmn6YjhoKoBJjr391sQcpeZK+OzKH4IXuf1+EYcg8Y3nW9gli1JjIKV7/HoRKyNqErZLVe699FKlbaRPSf0JCYmdQ2O57WQdh01Z2WvHI9XuPp7RKy0Hmh4FCZCCOri+88S5NBcRCprT0BFn3vRzdqpwhAuE0lOGvJAiyKoflu4nPezljxavDBxUY1bgBV5bHj6tfpG/22vxvcmVKVEmJKC7k8U/t7VvZFdYqFgiVW4yUxO7rYkQHMO9MKSu0kIY8lNmwDtLZP8/4QMfYhN7hDm0YY2Y/QP48+ImTFui1+u/+Uvy7y0NC/Wdinv/H/7BtMPQ7nIfvDETomTVEtMH91BxKhbsBK17GRBwySfitbqV5uy1H6NNmHpXCVPAw0/cNDD2mNAiszq5xx8hfyJJsqTfgx3lg/tb5A8dZ0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5825167a-4901-443e-badf-08d6fdefd84b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 06:46:28.5722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ranro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2164
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVGFyaXEgVG91a2FuDQo+
IFNlbnQ6IFN1bmRheSwgSnVuZSAzMCwgMjAxOSAxMDo1Nw0KPiBUbzogRGF2aWQgTWlsbGVyIDxk
YXZlbUBkYXZlbWxvZnQubmV0PjsgZndAc3RybGVuLmRlDQo+IENjOiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBSYW4gUm96ZW5zdGVpbiA8cmFucm9AbWVsbGFub3guY29tPjsgVGFyaXENCj4gVG91
a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0
IDAvMl0gbmV0OiBpcHY0OiBmaXggY2lyY3VsYXItbGlzdCBpbmZpbml0ZSBsb29wDQo+IA0KPiAN
Cj4gDQo+IE9uIDYvMjcvMjAxOSA3OjU0IFBNLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+ID4gRnJv
bTogRmxvcmlhbiBXZXN0cGhhbCA8ZndAc3RybGVuLmRlPg0KPiA+IERhdGU6IFRodSwgMjcgSnVu
IDIwMTkgMTQ6MDM6MzEgKzAyMDANCj4gPg0KPiA+PiBUYXJpcSBhbmQgUmFuIHJlcG9ydGVkIGEg
cmVncmVzc2lvbiBjYXVzZWQgYnkgbmV0LW5leHQgY29tbWl0DQo+ID4+IDI2MzhlYjhiNTBjZiAo
Im5ldDogaXB2NDogcHJvdmlkZSBfX3JjdSBhbm5vdGF0aW9uIGZvciBpZmFfbGlzdCIpLg0KPiA+
Pg0KPiA+PiBUaGlzIGhhcHBlbnMgd2hlbiBuZXQuaXB2NC5jb25mLiRkZXYucHJvbW90ZV9zZWNv
bmRhcmllcyBzeXNjdGwgaXMNCj4gPj4gZW5hYmxlZCAtLSB3ZSBjYW4gYXJyYW5nZSBmb3IgaWZh
LT5uZXh0IHRvIHBvaW50IGF0IGlmYSwgc28gbmV4dA0KPiA+PiBwcm9jZXNzIHRoYXQgdHJpZXMg
dG8gd2FsayB0aGUgbGlzdCBsb29wcyBmb3JldmVyLg0KPiA+Pg0KPiA+PiBGaXggdGhpcyBhbmQg
ZXh0ZW5kIHJ0bmV0bGluay5zaCB3aXRoIGEgc21hbGwgdGVzdCBjYXNlIGZvciB0aGlzLg0KPiA+
DQo+ID4gU2VyaWVzIGFwcGxpZWQsIHRoYW5rcyBGbG9yaWFuLg0KPiA+DQo+IA0KPiBUaGFua3Mg
RmxvcmlhbiENCj4gDQo+IFJhbiwgcGxlYXNlIHRlc3QgYW5kIHVwZGF0ZS4NCj4gDQo+IFRhcmlx
DQoNClRoYW5rcyBGbG9yaWFuLg0KRGlkbid0IHJlcHJvZHVjZSB0b25pZ2h0IHdpdGggdGhlIGZp
eGVzLg0KDQpSYW4uDQoNCg==
