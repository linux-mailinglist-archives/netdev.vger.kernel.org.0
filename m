Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B362D397
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 04:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfE2CIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 22:08:06 -0400
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:48196
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726461AbfE2CIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 22:08:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLQGdQIzK4RhcA2CSIqEEE4mPueP/RD9jmW/0rsd4kA=;
 b=DUDJzWrH7oMGKydSTV5GDdjW2o0riUkGoov8LO6J1Ob06F8E4TMFTvtwfyweOkApayleqxIYiQ3FtGQE1NhSi6kQQ1u+ZZAlfRhxsgE3m1LK1ornJKVKvDHJOwbNKm407jpDML9iJZ94FcRPrMunydvh0XzmlC81R9IjwpKhX7c=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5947.eurprd05.prod.outlook.com (20.179.11.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 02:08:01 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 02:08:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/6] net/mlx5: Avoid double free of root ns in the error flow
 path
Thread-Topic: [net 2/6] net/mlx5: Avoid double free of root ns in the error
 flow path
Thread-Index: AQHVFcNXsAcOsl+eaUGJZnKgSrXVpA==
Date:   Wed, 29 May 2019 02:08:01 +0000
Message-ID: <20190529020737.4172-3-saeedm@mellanox.com>
References: <20190529020737.4172-1-saeedm@mellanox.com>
In-Reply-To: <20190529020737.4172-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:a03:74::43) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c9998b8-46ea-43a6-a860-08d6e3da79f0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR05MB5947;
x-ms-traffictypediagnostic: DB8PR05MB5947:
x-microsoft-antispam-prvs: <DB8PR05MB59479646738C2B0B9E5113EEBE1F0@DB8PR05MB5947.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(366004)(376002)(346002)(39860400002)(396003)(189003)(199004)(3846002)(6116002)(54906003)(6486002)(8936002)(2906002)(86362001)(81166006)(6506007)(50226002)(8676002)(81156014)(99286004)(53936002)(256004)(14454004)(386003)(71200400001)(52116002)(7736002)(305945005)(102836004)(6436002)(71190400001)(5660300002)(316002)(36756003)(186003)(4326008)(476003)(68736007)(486006)(6512007)(446003)(1076003)(66476007)(73956011)(66446008)(66556008)(66946007)(25786009)(478600001)(26005)(2616005)(107886003)(76176011)(66066001)(64756008)(6916009)(11346002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5947;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kWBTiO7M6OEH/lgenKdRaVkbzrFS71r2ruLJPHsD6/EFV+aLNmYV1D8VdHH5g6Gv9mQuD2eASzpoYWk04e96IBg4E+nco3wxmsZquX+8FLehhbP0rgX9VRQ/YeMDQP4nHeVDNpH6sc8fSllIEajRu6GJr0OudHJqQe/qJX7YmBOpknNTw5YRNrrsN/W42bM4CVQ+CwzDDmQZKqtdZZJq+lx7uwMaSOmfKYUkTvOSEzSsB8cAYBzuA5akp7W21HQkZx/oGGNX5A8BkLJ6HeZFkftYAoBIXVRj9zA5JKLzSxB6PcY5phYOUFGxtQ26FpFG+RTgUVyLkcy+AJWy8GMcaWH9UCLF6Ey4bIQWWuRU8Z2acRj+cJ6k0vSWnfWWm3lZZZj6GMHXDfHmiuL/ocfLYOVTIOHxFuygrdPrS02u4bA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c9998b8-46ea-43a6-a860-08d6e3da79f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 02:08:01.0632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5947
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQoNCldoZW4gcm9vdCBucyBz
ZXR1cCBmb3IgcmRtYSwgc25pZmZlciB0eCBhbmQgc25pZmZlciByeCBmYWlscywNCnN1Y2ggcm9v
dCBucyBjbGVhbnVwIGlzIGRvbmUgYnkgdGhlIGVycm9yIHVud2luZGluZyBwYXRoIG9mDQptbHg1
X2NsZWFudXBfZnMoKS4NCkJlbG93IGNhbGwgZ3JhcGggc2hvd3MgYW4gZXhhbXBsZSBmb3Igc25p
ZmZlcl9yeF9yb290X25zLg0KDQptbHg1X2luaXRfZnMoKQ0KICBpbml0X3NuaWZmZXJfcnhfcm9v
dF9ucygpDQogICAgY2xlYW51cF9yb290X25zKHN0ZWVyaW5nLT5zbmlmZmVyX3J4X3Jvb3RfbnMp
Ow0KbWx4NV9jbGVhbnVwX2ZzKCkNCiAgY2xlYW51cF9yb290X25zKHN0ZWVyaW5nLT5zbmlmZmVy
X3J4X3Jvb3RfbnMpOw0KICAvKiBkb3VibGUgZnJlZSBvZiBzbmlmZmVyX3J4X3Jvb3RfbnMgKi8N
Cg0KSGVuY2UsIHVzZSB0aGUgZXhpc3RpbmcgY2xlYW51cF9mcyB0byBjbGVhbnVwLg0KDQpGaXhl
czogZDgzZWI1MGUyOWRlMyAoIm5ldC9tbHg1OiBBZGQgc3VwcG9ydCBpbiBSRE1BIFJYIHN0ZWVy
aW5nIikNCkZpeGVzOiA4N2QyMjQ4M2NlNjhlICgibmV0L21seDU6IEFkZCBzbmlmZmVyIG5hbWVz
cGFjZXMiKQ0KU2lnbmVkLW9mZi1ieTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+
DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0t
LQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NvcmUuYyAgfCAxOCAr
KystLS0tLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxNSBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9mc19jb3JlLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZnNfY29yZS5jDQppbmRleCBkN2NhN2U4MmE4MzIuLjRmYTg3Y2E2M2JjYSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mc19jb3JlLmMN
CisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mc19jb3JlLmMN
CkBAIC0yNDc0LDExICsyNDc0LDcgQEAgc3RhdGljIGludCBpbml0X3NuaWZmZXJfdHhfcm9vdF9u
cyhzdHJ1Y3QgbWx4NV9mbG93X3N0ZWVyaW5nICpzdGVlcmluZykNCiANCiAJLyogQ3JlYXRlIHNp
bmdsZSBwcmlvICovDQogCXByaW8gPSBmc19jcmVhdGVfcHJpbygmc3RlZXJpbmctPnNuaWZmZXJf
dHhfcm9vdF9ucy0+bnMsIDAsIDEpOw0KLQlpZiAoSVNfRVJSKHByaW8pKSB7DQotCQljbGVhbnVw
X3Jvb3RfbnMoc3RlZXJpbmctPnNuaWZmZXJfdHhfcm9vdF9ucyk7DQotCQlyZXR1cm4gUFRSX0VS
UihwcmlvKTsNCi0JfQ0KLQlyZXR1cm4gMDsNCisJcmV0dXJuIFBUUl9FUlJfT1JfWkVSTyhwcmlv
KTsNCiB9DQogDQogc3RhdGljIGludCBpbml0X3NuaWZmZXJfcnhfcm9vdF9ucyhzdHJ1Y3QgbWx4
NV9mbG93X3N0ZWVyaW5nICpzdGVlcmluZykNCkBAIC0yNDkxLDExICsyNDg3LDcgQEAgc3RhdGlj
IGludCBpbml0X3NuaWZmZXJfcnhfcm9vdF9ucyhzdHJ1Y3QgbWx4NV9mbG93X3N0ZWVyaW5nICpz
dGVlcmluZykNCiANCiAJLyogQ3JlYXRlIHNpbmdsZSBwcmlvICovDQogCXByaW8gPSBmc19jcmVh
dGVfcHJpbygmc3RlZXJpbmctPnNuaWZmZXJfcnhfcm9vdF9ucy0+bnMsIDAsIDEpOw0KLQlpZiAo
SVNfRVJSKHByaW8pKSB7DQotCQljbGVhbnVwX3Jvb3RfbnMoc3RlZXJpbmctPnNuaWZmZXJfcnhf
cm9vdF9ucyk7DQotCQlyZXR1cm4gUFRSX0VSUihwcmlvKTsNCi0JfQ0KLQlyZXR1cm4gMDsNCisJ
cmV0dXJuIFBUUl9FUlJfT1JfWkVSTyhwcmlvKTsNCiB9DQogDQogc3RhdGljIGludCBpbml0X3Jk
bWFfcnhfcm9vdF9ucyhzdHJ1Y3QgbWx4NV9mbG93X3N0ZWVyaW5nICpzdGVlcmluZykNCkBAIC0y
NTExLDExICsyNTAzLDcgQEAgc3RhdGljIGludCBpbml0X3JkbWFfcnhfcm9vdF9ucyhzdHJ1Y3Qg
bWx4NV9mbG93X3N0ZWVyaW5nICpzdGVlcmluZykNCiANCiAJLyogQ3JlYXRlIHNpbmdsZSBwcmlv
ICovDQogCXByaW8gPSBmc19jcmVhdGVfcHJpbygmc3RlZXJpbmctPnJkbWFfcnhfcm9vdF9ucy0+
bnMsIDAsIDEpOw0KLQlpZiAoSVNfRVJSKHByaW8pKSB7DQotCQljbGVhbnVwX3Jvb3RfbnMoc3Rl
ZXJpbmctPnJkbWFfcnhfcm9vdF9ucyk7DQotCQlyZXR1cm4gUFRSX0VSUihwcmlvKTsNCi0JfQ0K
LQlyZXR1cm4gMDsNCisJcmV0dXJuIFBUUl9FUlJfT1JfWkVSTyhwcmlvKTsNCiB9DQogc3RhdGlj
IGludCBpbml0X2ZkYl9yb290X25zKHN0cnVjdCBtbHg1X2Zsb3dfc3RlZXJpbmcgKnN0ZWVyaW5n
KQ0KIHsNCi0tIA0KMi4yMS4wDQoNCg==
