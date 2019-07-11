Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C9766017
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 21:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbfGKTkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 15:40:05 -0400
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:33188
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfGKTkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 15:40:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLuYknxvcU134oAdebKI8pGGRNnI0bKGvHU40mDgaMU=;
 b=qFNbwHKHvnl8J0RTXT3O/v5OywVOd9HVye+QaUXtu+LdVnwBX1x4fQdINM+dIiB+3y9IZizS7/nAKxvupHQB4gBuEMAhq00ZI6YoXW2TlKc9QB4wttHzpuUbYsX9hZm/IDKEIB1OG4vdYbJEenlwnypdOaX7MiJTpbX4wcd5y6U=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2851.eurprd05.prod.outlook.com (10.172.216.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Thu, 11 Jul 2019 19:40:00 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1%9]) with mapi id 15.20.2052.022; Thu, 11 Jul 2019
 19:39:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>
Subject: [PATCH net-next 3/3] net/mlx5: E-Switch, Reduce ingress acl modify
 metadata stack usage
Thread-Topic: [PATCH net-next 3/3] net/mlx5: E-Switch, Reduce ingress acl
 modify metadata stack usage
Thread-Index: AQHVOCBs9oBduE1wQ0qYLj3SgQj6bw==
Date:   Thu, 11 Jul 2019 19:39:59 +0000
Message-ID: <20190711193937.29802-4-saeedm@mellanox.com>
References: <20190711193937.29802-1-saeedm@mellanox.com>
In-Reply-To: <20190711193937.29802-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR11CA0070.namprd11.prod.outlook.com
 (2603:10b6:a03:80::47) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27da9b20-4c73-43c8-be1e-08d706378f01
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2851;
x-ms-traffictypediagnostic: AM4PR0501MB2851:
x-microsoft-antispam-prvs: <AM4PR0501MB28512DA9E6762337A73C82C2BEF30@AM4PR0501MB2851.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(199004)(189003)(66946007)(66066001)(26005)(66446008)(71200400001)(66476007)(71190400001)(186003)(81156014)(8936002)(6506007)(5660300002)(1076003)(305945005)(66556008)(36756003)(99286004)(81166006)(86362001)(25786009)(14444005)(52116002)(102836004)(107886003)(64756008)(53936002)(8676002)(386003)(478600001)(76176011)(446003)(6436002)(476003)(3846002)(11346002)(54906003)(6486002)(6916009)(2906002)(2616005)(6116002)(6512007)(486006)(68736007)(256004)(4326008)(7736002)(316002)(14454004)(50226002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2851;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Wm169SbOO1zLLmtcGIdGDtUboYh033BrsBAuzrAD6OpVhbIgGBTeJKIDZ19YHzs13auedOzTSl0rgEgIsdqdzYup4fsKG1dZqslUpmUo+v2f7K11SNh9fVVnSrdQ7Zm2lFBHQ5gHJVu5zelaJgNovR14HLINeEUzaM5hC8l2VFN06Vz5OZk9zIzQpb6mAO21lsn5zdRVCUxvIoRxsNMpHOBP+VEmq4ajrjSiaINt6PS0hywWvCNC4vA062HMOGFB/tTB7CiGzO0ApQ2qmsEpSGUq8PHlf4lE1ZHmXbEjB8mDrbpbDiOPQhfQO7BqLatkhXgan68jfLV7UxbUMLhXtSdDtizdssCfLPK451VKvmwDLqG600hipvc55ZokTYNmMklZla6XHRDobHkq+Byf+RYv32HhEXIN2eoDXD+1G+k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D961162EDE89D40926CFE17120E43B9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27da9b20-4c73-43c8-be1e-08d706378f01
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 19:39:59.4605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2851
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rml4IHRoZSBmb2xsb3dpbmcgY29tcGlsZXIgd2FybmluZzoNCkluIGZ1bmN0aW9uIOKAmGVzd192
cG9ydF9hZGRfaW5ncmVzc19hY2xfbW9kaWZ5X21ldGFkYXRh4oCZOg0KdGhlIGZyYW1lIHNpemUg
b2YgMTA4NCBieXRlcyBpcyBsYXJnZXIgdGhhbiAxMDI0IGJ5dGVzIFstV2ZyYW1lLWxhcmdlci10
aGFuPV0NCg0KU2luY2UgdGhlIHN0cnVjdHVyZSBpcyBuZXZlciB3cml0dGVuIHRvLCB3ZSBjYW4g
c3RhdGljYWxseSBhbGxvY2F0ZQ0KaXQgdG8gYXZvaWQgdGhlIHN0YWNrIHVzYWdlLg0KDQpGaXhl
czogNzQ0NWNmYjExNjljICgibmV0L21seDU6IEUtU3dpdGNoLCBUYWcgcGFja2V0IHdpdGggdnBv
cnQgbnVtYmVyIGluIFZGIHZwb3J0cyBhbmQgdXBsaW5rIGluZ3Jlc3MgQUNMcyIpDQpTaWduZWQt
b2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5
OiBKaWFuYm8gTGl1IDxqaWFuYm9sQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgfCAyICstDQogMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fk
cy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2Zm
bG9hZHMuYw0KaW5kZXggOGVkNDQ5NzkyOWI5Li41Zjc4ZTc2MDE5YzUgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5j
DQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9v
ZmZsb2Fkcy5jDQpAQCAtMTc4NSw4ICsxNzg1LDggQEAgc3RhdGljIGludCBlc3dfdnBvcnRfYWRk
X2luZ3Jlc3NfYWNsX21vZGlmeV9tZXRhZGF0YShzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csDQog
CQkJCQkJICAgICBzdHJ1Y3QgbWx4NV92cG9ydCAqdnBvcnQpDQogew0KIAl1OCBhY3Rpb25bTUxY
NV9VTl9TWl9CWVRFUyhzZXRfYWN0aW9uX2luX2FkZF9hY3Rpb25faW5fYXV0byldID0ge307DQor
CXN0YXRpYyBjb25zdCBzdHJ1Y3QgbWx4NV9mbG93X3NwZWMgc3BlYyA9IHt9Ow0KIAlzdHJ1Y3Qg
bWx4NV9mbG93X2FjdCBmbG93X2FjdCA9IHt9Ow0KLQlzdHJ1Y3QgbWx4NV9mbG93X3NwZWMgc3Bl
YyA9IHt9Ow0KIAlpbnQgZXJyID0gMDsNCiANCiAJTUxYNV9TRVQoc2V0X2FjdGlvbl9pbiwgYWN0
aW9uLCBhY3Rpb25fdHlwZSwgTUxYNV9BQ1RJT05fVFlQRV9TRVQpOw0KLS0gDQoyLjIxLjANCg0K
