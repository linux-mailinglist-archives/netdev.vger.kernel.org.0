Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F35255636
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732611AbfFYRsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:48:05 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:15870
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732437AbfFYRsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 13:48:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bX3f4g9TWCRcvyMfX0PmZux7ctQ4hj5pjL460tShtOI=;
 b=NL7hHJAv8zdk/BgkX+2AkljG4CxR97N7D3X3uCpRvieG7itfY7Ay/VICObW+Q+VpM/02EuuNuquQZDeLAqWUEF9yriViApmJKvytM34zfal0G3kH6bsSTa+D2N1pbr3BbiCdg/uHQ1puag+TqZLogxbcHfA81zODuYWIsznVLhE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2216.eurprd05.prod.outlook.com (10.168.55.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 17:47:54 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 17:47:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: [PATCH V2 mlx5-next 03/13] net/mlx5: Support allocating modify header
 context from ingress ACL
Thread-Topic: [PATCH V2 mlx5-next 03/13] net/mlx5: Support allocating modify
 header context from ingress ACL
Thread-Index: AQHVK34e8vgzLecRGEa4kaawpXzhCA==
Date:   Tue, 25 Jun 2019 17:47:54 +0000
Message-ID: <20190625174727.20309-4-saeedm@mellanox.com>
References: <20190625174727.20309-1-saeedm@mellanox.com>
In-Reply-To: <20190625174727.20309-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::36) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cc4f638-c631-4f81-cace-08d6f995402b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2216;
x-ms-traffictypediagnostic: DB6PR0501MB2216:
x-microsoft-antispam-prvs: <DB6PR0501MB2216CD9DBA503C5EC7B11B10BEE30@DB6PR0501MB2216.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(396003)(376002)(39860400002)(189003)(199004)(36756003)(26005)(76176011)(1076003)(86362001)(14454004)(50226002)(52116002)(110136005)(6116002)(186003)(6506007)(4744005)(5660300002)(68736007)(386003)(8936002)(5024004)(2906002)(3846002)(6436002)(256004)(316002)(102836004)(478600001)(81166006)(53936002)(6512007)(107886003)(450100002)(4326008)(486006)(7736002)(8676002)(11346002)(66556008)(64756008)(66946007)(73956011)(99286004)(446003)(66476007)(66446008)(66066001)(2616005)(305945005)(81156014)(71190400001)(54906003)(71200400001)(476003)(6636002)(25786009)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2216;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Q3F/BAAK9I5PHNgW4AqJg/7kl7jsvwJHIsMgWEIgWzsEIrsr3bfwlV560bfvhft4juzryq7W5oqm+5UGxxcADryIILMdGkvrOdrx2lLW8CV3vPQ2SGFrCxHz4zZAjfAaOOjfMXHsxRkqfXL+4cacN7tb6cA7YUVsIn1/pU1dRHD0t+O8RsqwZdIld37qfKvzD5xtgqIaMKijhffjuagPh2GNLkr63iVa1ZczrRSk43C+2G2hsXsRfIdY0dbrwFrbWgTyvnnhRpv04M3o3ESK9Gm81RLwz1sNyNzMAMrBly9LWKLg9CZu3C2kUVrU31XV9VMJGbtqFjNWOHhlIFHistN6hplk7UiAMI9N3RpvQZnzGx+Shj7T1DEDIrLYcbrLdLI4E0Snv0WysnIsyXJPICktrt2A5FKoiJ7B2AwBoJ0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cc4f638-c631-4f81-cace-08d6f995402b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 17:47:54.8154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2216
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQoNClRoYXQgbW9kaWZ5IGhl
YWRlciBhY3Rpb24gY2FuIGJlIHRoZW4gYXR0YWNoZWQgdG8gYSBzdGVlcmluZyBydWxlIGluDQp0
aGUgaW5ncmVzcyBBQ0wuDQoNClNpZ25lZC1vZmYtYnk6IEppYW5ibyBMaXUgPGppYW5ib2xAbWVs
bGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IEVsaSBCcml0c3RlaW4gPGVsaWJyQG1lbGxhbm94LmNv
bT4NClJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQt
Ynk6IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVk
IE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NtZC5jIHwgNCArKysrDQogMSBmaWxlIGNoYW5nZWQs
IDQgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2ZzX2NtZC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2ZzX2NtZC5jDQppbmRleCBiYjI0YzM3OTcyMTguLjRmMWQ0MDI5MjZmMSAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mc19jbWQu
Yw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NtZC5j
DQpAQCAtNzcxLDYgKzc3MSwxMCBAQCBpbnQgbWx4NV9tb2RpZnlfaGVhZGVyX2FsbG9jKHN0cnVj
dCBtbHg1X2NvcmVfZGV2ICpkZXYsDQogCQltYXhfYWN0aW9ucyA9IE1MWDVfQ0FQX0ZMT1dUQUJM
RV9OSUNfVFgoZGV2LCBtYXhfbW9kaWZ5X2hlYWRlcl9hY3Rpb25zKTsNCiAJCXRhYmxlX3R5cGUg
PSBGU19GVF9OSUNfVFg7DQogCQlicmVhazsNCisJY2FzZSBNTFg1X0ZMT1dfTkFNRVNQQUNFX0VT
V19JTkdSRVNTOg0KKwkJbWF4X2FjdGlvbnMgPSBNTFg1X0NBUF9FU1dfSU5HUkVTU19BQ0woZGV2
LCBtYXhfbW9kaWZ5X2hlYWRlcl9hY3Rpb25zKTsNCisJCXRhYmxlX3R5cGUgPSBGU19GVF9FU1df
SU5HUkVTU19BQ0w7DQorCQlicmVhazsNCiAJZGVmYXVsdDoNCiAJCXJldHVybiAtRU9QTk9UU1VQ
UDsNCiAJfQ0KLS0gDQoyLjIxLjANCg0K
