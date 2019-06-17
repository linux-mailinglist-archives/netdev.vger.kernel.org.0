Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 941B348E49
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbfFQTXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:23:23 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:14178
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725497AbfFQTXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:23:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bX3f4g9TWCRcvyMfX0PmZux7ctQ4hj5pjL460tShtOI=;
 b=AV/Id1LNEeUsq7I3iLp19NEAlZDHanMsGLNU8oMswiRFGsu3EQHT5/ByHTKGXBNZDBbycc7QvYaK2fYLtCIGbyXjFaATq1vp2wceb2nwh3t0DccydcMHprpCNdm7mgGTRB3mNGg8rGJ6gFCGnfaJMeaQgYbrsTCW5ph8/ygTF9Y=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2789.eurprd05.prod.outlook.com (10.172.226.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 19:23:14 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:23:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 03/15] net/mlx5: Support allocating modify header
 context from ingress ACL
Thread-Topic: [PATCH mlx5-next 03/15] net/mlx5: Support allocating modify
 header context from ingress ACL
Thread-Index: AQHVJUIbaHezaBtsJ0yYK+S1UEShww==
Date:   Mon, 17 Jun 2019 19:23:13 +0000
Message-ID: <20190617192247.25107-4-saeedm@mellanox.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
In-Reply-To: <20190617192247.25107-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::41) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21594755-d395-4b19-189d-08d6f3593dcf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2789;
x-ms-traffictypediagnostic: DB6PR0501MB2789:
x-microsoft-antispam-prvs: <DB6PR0501MB27893DA9A245E0CCD2D77EA9BEEB0@DB6PR0501MB2789.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(2906002)(50226002)(64756008)(66556008)(66446008)(68736007)(256004)(6636002)(66476007)(2616005)(476003)(5024004)(446003)(66946007)(73956011)(5660300002)(71200400001)(7736002)(6506007)(386003)(71190400001)(76176011)(102836004)(99286004)(53936002)(305945005)(52116002)(11346002)(4744005)(1076003)(8676002)(4326008)(450100002)(25786009)(6486002)(3846002)(6116002)(478600001)(186003)(26005)(316002)(110136005)(8936002)(6512007)(81166006)(486006)(81156014)(107886003)(86362001)(14454004)(66066001)(6436002)(36756003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2789;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: g2ZSxuAO/BZt8jF6cDcqKU/WIYC5VBG8heS3wJgnNCaMvIV2fta0h9fYdBkY4Yl+jVVwAGFSreOs8c/bxoqcgortHysHEzu3EqzT8vMM5EYQFB9fsAzSYPXKzIvIjyJt562C1FYZJZjS4jsLL1PpEvstZD0IMQDPCwUZKOT+GpZl6jz0vuRpkroyfADonZQZXXJODGjL3n5wvlazskgUUQIVwMEAoIKsc69UP6XS35hnKN48eVcXpg/2MuWyp77eAN0hTaxH3gGpqJaVgpTspMoJdG+8wvzk+gyBg8/b6S3rjPjjRlt9f2SOwioOHFvaNuUOlVwm890bzwGdgMk1tIinZf7bVv6tkE+FysNoNpUF5KEpoNkuoMLpTEZbINuhJvvKqNJpdgUZlrxMise3kmIWxa9eyjZsTiCFCj+9cK8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21594755-d395-4b19-189d-08d6f3593dcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:23:13.9829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2789
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
