Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14E975AFC9
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 14:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfF3MTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 08:19:54 -0400
Received: from mail-eopbgr60053.outbound.protection.outlook.com ([40.107.6.53]:38723
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726500AbfF3MTx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 08:19:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=uboOjo+PyPh3SdPIuJkndrWMzSXu9SatZLFZY6Ka7n2V4TjgML6v5i2S51qSx7btfdV0PojCLVdAgXbryPPlpgcBmmBYKwxixZtiNRYaXJ1TVZzVP8aSb193ah0+ZmO9nrrWA8aqTASEzrBWryufovQSa8TpR/ybV5t3QWGIU6M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4g5rnkv9iXIo+5pZsH/PddyndhXuE5oKWblB3wj7+Fc=;
 b=qGEcF5Zv8SjrQ4k6ZOH1IRTJ7s53JalqCSOI8pdySCk1q2muAvCL7ZTnbUtXmfiDRCeoYBJlguBAGls0Qr7cYhzPSm8VZ5M07jfUhfARD9U+x6Koq3yFva9MnpxUtA23YulYKBfknKwveho5pmltjluEHU77NmKD+H9kCAVHscg=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4g5rnkv9iXIo+5pZsH/PddyndhXuE5oKWblB3wj7+Fc=;
 b=UAuzSLQO6sjJ01hrO82HNkUOCm4ErToXbXOIuR1+41+RfXGbpYotSWvUp0/WYKi1/w9/0eMik8WIn5Goq5UMQ9P067QdYOZ+RNPjkbPFEmtPS5+yO2Yee+O7PF87+g3Bnjl/u6VNOYTqNGTDfAayhrbt3IGuhwI+NbM0JWecW6o=
Received: from AM0PR05MB6274.eurprd05.prod.outlook.com (20.179.32.142) by
 AM0PR05MB4611.eurprd05.prod.outlook.com (52.133.52.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Sun, 30 Jun 2019 12:19:49 +0000
Received: from AM0PR05MB6274.eurprd05.prod.outlook.com
 ([fe80::1cc3:1163:6c88:384d]) by AM0PR05MB6274.eurprd05.prod.outlook.com
 ([fe80::1cc3:1163:6c88:384d%5]) with mapi id 15.20.2032.019; Sun, 30 Jun 2019
 12:19:49 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Fuqian Huang <huangfq.daxian@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH v2 15/27] net: use zeroing allocator rather than allocator
 followed by memset zero
Thread-Topic: [PATCH v2 15/27] net: use zeroing allocator rather than
 allocator followed by memset zero
Thread-Index: AQHVLVv5nFKYQsWCK0C5fSuOfIejtKa0IX0A
Date:   Sun, 30 Jun 2019 12:19:49 +0000
Message-ID: <741d9946-ff30-1df1-1de0-592621531387@mellanox.com>
References: <20190628024824.15581-1-huangfq.daxian@gmail.com>
In-Reply-To: <20190628024824.15581-1-huangfq.daxian@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR1PR01CA0002.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::15) To AM0PR05MB6274.eurprd05.prod.outlook.com
 (2603:10a6:208:139::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c61d370-9601-49d1-7a05-08d6fd553f1b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4611;
x-ms-traffictypediagnostic: AM0PR05MB4611:
x-microsoft-antispam-prvs: <AM0PR05MB4611987B495F3C1F9A9823B3AEFE0@AM0PR05MB4611.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:374;
x-forefront-prvs: 008421A8FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(189003)(199004)(76176011)(26005)(6916009)(446003)(11346002)(66476007)(36756003)(486006)(102836004)(86362001)(31696002)(229853002)(7736002)(66446008)(2616005)(4744005)(4326008)(476003)(81156014)(305945005)(71190400001)(99286004)(53936002)(53546011)(186003)(68736007)(386003)(71200400001)(52116002)(6506007)(6246003)(6512007)(316002)(2906002)(8936002)(6116002)(66066001)(54906003)(5660300002)(478600001)(31686004)(66946007)(3846002)(256004)(6486002)(8676002)(73956011)(64756008)(66556008)(81166006)(14454004)(25786009)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4611;H:AM0PR05MB6274.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qDQ4wX+Qww8V4I5tcqBwSUP8F4r6BoM4Wz91mAF4I6j5eGiDq9bElJwarbPhdYSlEkG9xOTCrFT6Qn/QpKNaO8TcDv3nomkhepzsP9mOJmGc4UQoBZ/H7y7EnkGXpGB9hTgkfJ/XIZZZbd62Od7oT2BFahmFAeh+qRLitDxXDcEeSz8zDrYRe9hLvDKFr6IAuanCkhExHni4ANcWofgg5YNau3hbUlC46J46qh/RBMpC7GGDhzWPJkMgEQzXeVdkS2apeBlgPxjok+CWqb77DvoqQXHe05u4e2G6gHYsU9jWyAgEkM1SYRI/qE1BfQBQJp28MW3/AKrlHtuoRN7YTrKGcd8fhOHU8xkS9F0yisvfN+iq/r30zgYNbcRYhxi0z+qtMF7LEEQ8IiGqs4L6lDwoVEw2iX8VoTT4nCXd00E=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A80E9E5F6E5D8B4DA0E5ECDAD3C4D3C8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c61d370-9601-49d1-7a05-08d6fd553f1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2019 12:19:49.5524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4611
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMjgvMjAxOSA1OjQ4IEFNLCBGdXFpYW4gSHVhbmcgd3JvdGU6DQo+IFJlcGxhY2Ug
YWxsb2NhdG9yIGZvbGxvd2VkIGJ5IG1lbXNldCB3aXRoIDAgd2l0aCB6ZXJvaW5nIGFsbG9jYXRv
ci4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEZ1cWlhbiBIdWFuZyA8aHVhbmdmcS5kYXhpYW5AZ21h
aWwuY29tPg0KPiAtLS0NCg0KLi4NCg0KDQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDQvZW5fcnguYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg0L2VuX3J4LmMNCj4gQEAgLTEwNjIsNyArMTA2Miw3IEBAIHN0YXRpYyBpbnQgbWx4NF9l
bl9jb25maWdfcnNzX3FwKHN0cnVjdCBtbHg0X2VuX3ByaXYgKnByaXYsIGludCBxcG4sDQo+ICAg
CXN0cnVjdCBtbHg0X3FwX2NvbnRleHQgKmNvbnRleHQ7DQo+ICAgCWludCBlcnIgPSAwOw0KPiAg
IA0KPiAtCWNvbnRleHQgPSBrbWFsbG9jKHNpemVvZigqY29udGV4dCksIEdGUF9LRVJORUwpOw0K
PiArCWNvbnRleHQgPSBremFsbG9jKHNpemVvZigqY29udGV4dCksIEdGUF9LRVJORUwpOw0KPiAg
IAlpZiAoIWNvbnRleHQpDQo+ICAgCQlyZXR1cm4gLUVOT01FTTsNCj4gICANCj4gQEAgLTEwNzMs
NyArMTA3Myw2IEBAIHN0YXRpYyBpbnQgbWx4NF9lbl9jb25maWdfcnNzX3FwKHN0cnVjdCBtbHg0
X2VuX3ByaXYgKnByaXYsIGludCBxcG4sDQo+ICAgCX0NCj4gICAJcXAtPmV2ZW50ID0gbWx4NF9l
bl9zcXBfZXZlbnQ7DQo+ICAgDQo+IC0JbWVtc2V0KGNvbnRleHQsIDAsIHNpemVvZigqY29udGV4
dCkpOw0KPiAgIAltbHg0X2VuX2ZpbGxfcXBfY29udGV4dChwcml2LCByaW5nLT5hY3R1YWxfc2l6
ZSwgcmluZy0+c3RyaWRlLCAwLCAwLA0KPiAgIAkJCQlxcG4sIHJpbmctPmNxbiwgLTEsIGNvbnRl
eHQpOw0KPiAgIAljb250ZXh0LT5kYl9yZWNfYWRkciA9IGNwdV90b19iZTY0KHJpbmctPndxcmVz
LmRiLmRtYSk7DQo+IA0KDQoNCkZvciB0aGUgbWx4NCBwYXJ0Og0KUmV2aWV3ZWQtYnk6IFRhcmlx
IFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCg0KVGFyaXENCg==
