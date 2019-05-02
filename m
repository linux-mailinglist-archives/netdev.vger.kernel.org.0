Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCADC115FC
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfEBJFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:05:47 -0400
Received: from mail-eopbgr140072.outbound.protection.outlook.com ([40.107.14.72]:18105
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726001AbfEBJFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:05:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdC19H38zi5+A8RC77iYiWFkQGBZunhUFHwr1Ygr+sc=;
 b=rkIIYT8addpS7I+Ki1RBiiRjIhyTvCoM0Z3OeuNNbxzduj29iI4gaIblWxo3h4n0qo0ZnVXInn8FND5TC9UYZKgNo0T36oZ74tQP/JEjKdFZKIOUfPfM3TlInUTO7U+w+cMlQbi03AlQHwpgZKMyrmTv5Mk2IUdoagpl7uSn8GE=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.50.159) by
 VI1PR04MB4253.eurprd04.prod.outlook.com (52.134.31.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Thu, 2 May 2019 09:05:41 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::81d8:f74b:f91e:f071]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::81d8:f74b:f91e:f071%7]) with mapi id 15.20.1835.018; Thu, 2 May 2019
 09:05:41 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     "jocke@infinera.com" <joakim.tjernlund@infinera.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Roy Pledge <roy.pledge@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH v2 9/9] dpaa_eth: fix SG frame cleanup
Thread-Topic: [PATCH v2 9/9] dpaa_eth: fix SG frame cleanup
Thread-Index: AQHU/MhUOSfNbgWjXk28jO3/UbT5S6ZQPsaAgAdTq4A=
Date:   Thu, 2 May 2019 09:05:41 +0000
Message-ID: <VI1PR04MB5134C0D6707E78D674B96898EC340@VI1PR04MB5134.eurprd04.prod.outlook.com>
References: <20190427071031.6563-1-laurentiu.tudor@nxp.com>
         <20190427071031.6563-10-laurentiu.tudor@nxp.com>
 <2c6f5d170edab346e0a87b1dfeb12e2f65801685.camel@infinera.com>
In-Reply-To: <2c6f5d170edab346e0a87b1dfeb12e2f65801685.camel@infinera.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd868a55-ef45-47d3-4c6b-08d6cedd5a3e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4253;
x-ms-traffictypediagnostic: VI1PR04MB4253:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1PR04MB4253D8E678A58DD5115D9743EC340@VI1PR04MB4253.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0025434D2D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(366004)(136003)(396003)(199004)(189003)(13464003)(8936002)(5660300002)(229853002)(8676002)(99286004)(256004)(66066001)(25786009)(14444005)(2906002)(6436002)(55016002)(76116006)(486006)(44832011)(14454004)(74316002)(86362001)(53936002)(2501003)(66556008)(9686003)(66446008)(64756008)(7696005)(66476007)(66946007)(73956011)(316002)(54906003)(110136005)(6246003)(446003)(11346002)(6506007)(4326008)(76176011)(71200400001)(81156014)(71190400001)(68736007)(81166006)(476003)(186003)(478600001)(7736002)(52536014)(305945005)(102836004)(6116002)(3846002)(26005)(33656002)(6636002)(491001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4253;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mOmsPNF9QNL8W5itImUGGLc7AK6Em/IIvhIZKNexYmzVGd2mFgHqrZ9peg8anXyPh9GFF1JEpusyNkFlzgotURUbLsemaYx8Kjl+SPvVS2ZsBr7l5v3W+jCc7dW6RmlcxTOigKPpTAVluSWv6UFRxeMdP7Sxj9x65gjSlYWDOGjvBGEx5ZPLUB47XSGOuXPmM0rJye7Jx9YaDh9aHzVP0SVU10p8wxRTbamMo332n6OlOZvnA8e/Vxq4ynopQFF/goVcb9vPUgU25GnyevbvFTK1pGG5S5ljnmO/W8elvuga6k17JWO0K44RyD/cWWXeZvzYwwO9bAiEAKvVVJTQFuayGautV4+N9YNyX81kZDHilDHvs+NNKYH9iiO7GtHuOW+Cl9lOzjc3E61rdSqwrvbgsQW6ief0jHdgvg3cY18=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd868a55-ef45-47d3-4c6b-08d6cedd5a3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2019 09:05:41.5379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4253
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSm9ha2ltLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtp
bSBUamVybmx1bmQgPEpvYWtpbS5UamVybmx1bmRAaW5maW5lcmEuY29tPg0KPiBTZW50OiBTYXR1
cmRheSwgQXByaWwgMjcsIDIwMTkgODoxMSBQTQ0KPiANCj4gT24gU2F0LCAyMDE5LTA0LTI3IGF0
IDEwOjEwICswMzAwLCBsYXVyZW50aXUudHVkb3JAbnhwLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBM
YXVyZW50aXUgVHVkb3IgPGxhdXJlbnRpdS50dWRvckBueHAuY29tPg0KPiA+DQo+ID4gRml4IGlz
c3VlIHdpdGggdGhlIGVudHJ5IGluZGV4aW5nIGluIHRoZSBzZyBmcmFtZSBjbGVhbnVwIGNvZGUg
YmVpbmcNCj4gPiBvZmYtYnktMS4gVGhpcyBwcm9ibGVtIHNob3dlZCB1cCB3aGVuIGRvaW5nIHNv
bWUgYmFzaWMgaXBlcmYgdGVzdHMgYW5kDQo+ID4gbWFuaWZlc3RlZCBpbiB0cmFmZmljIGNvbWlu
ZyB0byBhIGhhbHQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBMYXVyZW50aXUgVHVkb3IgPGxh
dXJlbnRpdS50dWRvckBueHAuY29tPg0KPiA+IEFja2VkLWJ5OiBNYWRhbGluIEJ1Y3VyIDxtYWRh
bGluLmJ1Y3VyQG54cC5jb20+DQo+IA0KPiBXYXNuJ3QgdGhpcyBhIHN0YWJsZSBjYW5kaWRhdGUg
dG9vPw0KDQpZZXMsIGl0IGlzLiBJIGZvcmdvdCB0byBhZGQgdGhlIGNjOnN0YWJsZSB0YWcsIHNv
cnJ5IGFib3V0IHRoYXQuDQoNCi0tLQ0KQmVzdCBSZWdhcmRzLCBMYXVyZW50aXUNCiANCj4gPiAt
LS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEvZHBhYV9ldGguYyB8
IDIgKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0p
DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2Rw
YWEvZHBhYV9ldGguYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhL2Rw
YWFfZXRoLmMNCj4gPiBpbmRleCBkYWVkZTcyNzI3NjguLjQwNDIwZWRjOWNlNiAxMDA2NDQNCj4g
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFhX2V0aC5jDQo+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEvZHBhYV9ldGguYw0K
PiA+IEBAIC0xNjYzLDcgKzE2NjMsNyBAQCBzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKmRwYWFfY2xl
YW51cF90eF9mZChjb25zdA0KPiBzdHJ1Y3QgZHBhYV9wcml2ICpwcml2LA0KPiA+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHFtX3NnX2VudHJ5X2dldF9sZW4oJnNndFswXSksIGRt
YV9kaXIpOw0KPiA+DQo+ID4gICAgICAgICAgICAgICAgIC8qIHJlbWFpbmluZyBwYWdlcyB3ZXJl
IG1hcHBlZCB3aXRoIHNrYl9mcmFnX2RtYV9tYXAoKQ0KPiAqLw0KPiA+IC0gICAgICAgICAgICAg
ICBmb3IgKGkgPSAxOyBpIDwgbnJfZnJhZ3M7IGkrKykgew0KPiA+ICsgICAgICAgICAgICAgICBm
b3IgKGkgPSAxOyBpIDw9IG5yX2ZyYWdzOyBpKyspIHsNCj4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICBXQVJOX09OKHFtX3NnX2VudHJ5X2lzX2V4dCgmc2d0W2ldKSk7DQo+ID4NCj4gPiAgICAg
ICAgICAgICAgICAgICAgICAgICBkbWFfdW5tYXBfcGFnZShkZXYsIHFtX3NnX2FkZHIoJnNndFtp
XSksDQo+ID4gLS0NCj4gPiAyLjE3LjENCj4gPg0KDQo=
