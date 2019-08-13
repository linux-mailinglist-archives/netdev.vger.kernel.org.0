Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F03EB8BBB8
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 16:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbfHMOkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 10:40:14 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:63174
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727768AbfHMOkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 10:40:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9CanbNkCYTWcRnzV0nuKYJSpBNzIAAgm81TEQe92DsvvhelxxaJ3eLZQ1ySoy/zqNd7lV4MgA2r6vVqzKRioj7CJC6eGkQl/17t4zxy6JzlvCdfffR3sdxn9DWWrz7tMuTWZQ3Itsa5iRaoQRr3Ii9dOL+0UmC7rQvpE+vQkGC9/mldqgQeQayglCdfgKz6MeN5PXwBAAhpDVt/F4o8DhiVO00JyQ5x9qwmPPY3EHGK/Ro+zAH7UijMdSipBvOA4qCDiRVE87MVkRo1crrAYCEEo7cZSB0ck8umK42E/BswgCL0s6V2xxB/AUAxqNSIKbO1jhwevOlCJhTCJRtrcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyTnGGRKX7P9Y1v825/XvLU6psC/kFaqk5Z3PFpbZsU=;
 b=TABjzuR+b0J1YgB+rJl5fMFi7/nDGHHIu8RSAJboOR03g9b95wq9YWcWt4NuEwNr/o8o22/G8UO2ADzeTwrpF/jQK+TVaSGa3fHVsmAK6i5ZkMIEOUWenqvZlfMq72RHSIN4fwaJ5gmkWXjxrcKr32gItazHaWOxWQozFken30o2/luHb1oN/SMzhCoavmwybtK8QVuFPtf+9/+VRMIMP/U9+AUkQlSlfqnsv2jfzdNGkp0ezFOzcd+m+oCQiaRj/uPrBr0unrL2XyJxLazCeyi0YkBtsXF56XoTp7Dz8B4cATjx/1bBAIDdQHZNvdJCbds8KO3ZYr874jCrdJoAWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyTnGGRKX7P9Y1v825/XvLU6psC/kFaqk5Z3PFpbZsU=;
 b=dHwP7DIuJr1ZtEZY6a+yv8lVhfYeqsUIsjtBmv/ziweA8mXKibgTfsulUFwh/dRcM3bJKPQo0vFMxIqWDlLn7aPXj6mrNZ3tEcdnvb+NQ2ESOswuT6qhoORXGBp3lJ0ulMMnjegNtp4om59dtylq+vyF+ymzUB9VrKw9VRizj0Q=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6524.eurprd05.prod.outlook.com (20.179.43.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Tue, 13 Aug 2019 14:39:54 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::c5c1:c1d:85e9:a16a]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::c5c1:c1d:85e9:a16a%6]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 14:39:54 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Wenwen Wang <wenwen@cs.uga.edu>
CC:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:MELLANOX ETHERNET DRIVER (mlx4_en)" 
        <netdev@vger.kernel.org>,
        "open list:MELLANOX MLX4 core VPI driver" 
        <linux-rdma@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx4_en: fix a memory leak bug
Thread-Topic: [PATCH v2] net/mlx4_en: fix a memory leak bug
Thread-Index: AQHVUUHOPfltHRXuVkalSxVa12UX1Kb5J2mA
Date:   Tue, 13 Aug 2019 14:39:54 +0000
Message-ID: <7634e1ca-f4f2-c2df-5d58-bcb334188663@mellanox.com>
References: <1565637095-7972-1-git-send-email-wenwen@cs.uga.edu>
In-Reply-To: <1565637095-7972-1-git-send-email-wenwen@cs.uga.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0117.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::33) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35e4084f-fb2e-4c5d-cef2-08d71ffc1b0f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6524;
x-ms-traffictypediagnostic: DBBPR05MB6524:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR05MB6524F5F035C7A8C36907FF6CAED20@DBBPR05MB6524.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(53546011)(386003)(14454004)(6506007)(76176011)(14444005)(256004)(52116002)(8676002)(71200400001)(71190400001)(86362001)(102836004)(81166006)(446003)(11346002)(2616005)(476003)(2906002)(6246003)(316002)(2171002)(3846002)(26005)(81156014)(54906003)(186003)(486006)(25786009)(4326008)(6116002)(99286004)(53936002)(478600001)(229853002)(66066001)(6486002)(6512007)(6436002)(305945005)(7736002)(31696002)(31686004)(5660300002)(66446008)(66476007)(66556008)(64756008)(66946007)(8936002)(6916009)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6524;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UdGOa+OS4DZn5EVnMzkVi4b2Oro7/5i9ySUI7xfG4CD4mQbIVPJ9OEd+G9Kxvkanc9d7KtrChggdlUGLwAMtyCw7KX1GLPP7WdtwooyvwliZpGvgLqfyJBVvnXuzIbeGR4qvq3saF/2gX+dx3HgVW+5yV3GqLWXTYoMzjSUG1NjwPrg84YkEfFI0H/t/PZlyalul4nuAfALls2Yt8Uo7jmHXg9dCJgsm+KOZXDUjNc4yg4sJSvUIfkIIw1JzcUI4rZ5WUAUzul5khMG61E3JnNdRLYGqromGMuVf1eqcq7Ci5Hl3GLtSaFdk6i2n1LXkpPaBSwfjDYEG0xZu5AHbAqtybf6f7j8ojGOrCqOdHI60ezIfrmuZR7LrZvQi3gvvCqLxew1oglXpalKfB3ObE+RTOldzYnDvankKYBaMRdQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29C36D41EC54A249B6D9E927D6111D9F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35e4084f-fb2e-4c5d-cef2-08d71ffc1b0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 14:39:54.4933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M6vDHBGpXeGZvr0c6FfkKBRI7X4HhglaDGdXQOw+93fZynF3NWk0aaNa/tYm6FLM8RbxDKoOGEkVQoY1B63T4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6524
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMTIvMjAxOSAxMDoxMSBQTSwgV2Vud2VuIFdhbmcgd3JvdGU6DQo+IEluIG1seDRf
ZW5fY29uZmlnX3Jzc19zdGVlcigpLCAncnNzX21hcC0+aW5kaXJfcXAnIGlzIGFsbG9jYXRlZCB0
aHJvdWdoDQo+IGt6YWxsb2MoKS4gQWZ0ZXIgdGhhdCwgbWx4NF9xcF9hbGxvYygpIGlzIGludm9r
ZWQgdG8gY29uZmlndXJlIFJTUw0KPiBpbmRpcmVjdGlvbi4gSG93ZXZlciwgaWYgbWx4NF9xcF9h
bGxvYygpIGZhaWxzLCB0aGUgYWxsb2NhdGVkDQo+ICdyc3NfbWFwLT5pbmRpcl9xcCcgaXMgbm90
IGRlYWxsb2NhdGVkLCBsZWFkaW5nIHRvIGEgbWVtb3J5IGxlYWsgYnVnLg0KPiANCj4gVG8gZml4
IHRoZSBhYm92ZSBpc3N1ZSwgYWRkIHRoZSAncXBfYWxsb2NfZXJyJyBsYWJlbCB0byBmcmVlDQo+
ICdyc3NfbWFwLT5pbmRpcl9xcCcuDQo+IA0KPiBGaXhlczogNDkzMWM2ZWYwNGI0ICgibmV0L21s
eDRfZW46IE9wdGltaXplZCBzaW5nbGUgcmluZyBzdGVlcmluZyIpDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBXZW53ZW4gV2FuZyA8d2Vud2VuQGNzLnVnYS5lZHU+DQo+IC0tLQ0KPiAgIGRyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvZW5fcnguYyB8IDMgKystDQo+ICAgMSBmaWxlIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvZW5fcnguYyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDQvZW5fcnguYw0KPiBpbmRleCA2YzAxMzE0Li5kYjM1NTJm
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX3J4
LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NC9lbl9yeC5jDQo+
IEBAIC0xMTg3LDcgKzExODcsNyBAQCBpbnQgbWx4NF9lbl9jb25maWdfcnNzX3N0ZWVyKHN0cnVj
dCBtbHg0X2VuX3ByaXYgKnByaXYpDQo+ICAgCWVyciA9IG1seDRfcXBfYWxsb2MobWRldi0+ZGV2
LCBwcml2LT5iYXNlX3FwbiwgcnNzX21hcC0+aW5kaXJfcXApOw0KPiAgIAlpZiAoZXJyKSB7DQo+
ICAgCQllbl9lcnIocHJpdiwgIkZhaWxlZCB0byBhbGxvY2F0ZSBSU1MgaW5kaXJlY3Rpb24gUVBc
biIpOw0KPiAtCQlnb3RvIHJzc19lcnI7DQo+ICsJCWdvdG8gcXBfYWxsb2NfZXJyOw0KPiAgIAl9
DQo+ICAgDQo+ICAgCXJzc19tYXAtPmluZGlyX3FwLT5ldmVudCA9IG1seDRfZW5fc3FwX2V2ZW50
Ow0KPiBAQCAtMTI0MSw2ICsxMjQxLDcgQEAgaW50IG1seDRfZW5fY29uZmlnX3Jzc19zdGVlcihz
dHJ1Y3QgbWx4NF9lbl9wcml2ICpwcml2KQ0KPiAgIAkJICAgICAgIE1MWDRfUVBfU1RBVEVfUlNU
LCBOVUxMLCAwLCAwLCByc3NfbWFwLT5pbmRpcl9xcCk7DQo+ICAgCW1seDRfcXBfcmVtb3ZlKG1k
ZXYtPmRldiwgcnNzX21hcC0+aW5kaXJfcXApOw0KPiAgIAltbHg0X3FwX2ZyZWUobWRldi0+ZGV2
LCByc3NfbWFwLT5pbmRpcl9xcCk7DQo+ICtxcF9hbGxvY19lcnI6DQo+ICAgCWtmcmVlKHJzc19t
YXAtPmluZGlyX3FwKTsNCj4gICAJcnNzX21hcC0+aW5kaXJfcXAgPSBOVUxMOw0KPiAgIHJzc19l
cnI6DQo+IA0KDQpUaGFua3MgZm9yIHlvdXIgcGF0Y2guDQpSZXZpZXdlZC1ieTogVGFyaXEgVG91
a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0K
