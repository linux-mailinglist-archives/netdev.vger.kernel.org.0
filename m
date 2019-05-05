Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A44313C64
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 02:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfEEAd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 20:33:29 -0400
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:14048
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727295AbfEEAd2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 20:33:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvU/fKsfZVIM9Wp/fnRfbvpqXsYS1Vx9QanOfiUWI4Q=;
 b=R5HHkFV1EMS5LJRXe+LfKYk6Rf5VfbRGbjsbjw60Ylk5vAwSs86IOOstQFBagP4H6mwciwFd++dsdExpT/QyomFv6p5Em8MfQR3yYFBMHt7VwjKNHyRgurXUyq8NeIthOTHnX/As5GMi6YyF1m8MR3+/+AyZiJEfsj0Ia8g9ZW8=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5881.eurprd05.prod.outlook.com (20.179.10.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Sun, 5 May 2019 00:33:06 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.012; Sun, 5 May 2019
 00:33:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alex Vesker <valex@mellanox.com>
Subject: [net-next 06/15] net/mlx5: Control CR-space access by different PFs
Thread-Topic: [net-next 06/15] net/mlx5: Control CR-space access by different
 PFs
Thread-Index: AQHVAtobMVY9oVvvp0+pLXGREAGN7w==
Date:   Sun, 5 May 2019 00:33:06 +0000
Message-ID: <20190505003207.1353-7-saeedm@mellanox.com>
References: <20190505003207.1353-1-saeedm@mellanox.com>
In-Reply-To: <20190505003207.1353-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:180::21) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b63bde6a-f5e3-44cd-5758-08d6d0f13dbc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5881;
x-ms-traffictypediagnostic: DB8PR05MB5881:
x-microsoft-antispam-prvs: <DB8PR05MB58813E8A65D6928A020724D6BE370@DB8PR05MB5881.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-forefront-prvs: 00286C0CA6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(39850400004)(136003)(396003)(199004)(189003)(305945005)(52116002)(76176011)(36756003)(316002)(25786009)(6486002)(478600001)(14454004)(446003)(50226002)(476003)(11346002)(2616005)(26005)(7736002)(4326008)(99286004)(86362001)(6916009)(53936002)(66476007)(186003)(68736007)(66446008)(64756008)(66556008)(6436002)(66946007)(73956011)(6512007)(14444005)(1076003)(66066001)(71190400001)(71200400001)(54906003)(256004)(102836004)(81156014)(81166006)(8936002)(3846002)(6506007)(386003)(107886003)(2906002)(8676002)(5660300002)(6116002)(486006)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5881;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CfNHOQQY22nXuXn621kI7tL+AgENVS6ChdFuHORiYWBHhir3RPcYPoAzsEsa/l4clcbv/Sh1z7AB5C33f+nipuzMqxQrrHUMHbVki9mPqWcQCBGtMtROvPP+pc3zdr6bRQJONRYogOspoMQgPIXJDOfohffwogpPvycsWkY9r6QuHW06D/tfwBmzlmFjCi5pMPIAxpjVc849r0MGFsJbdw2vENm6qEryfaAUhzo4mVjv9/AtvG7/89eAwlRlNObJf41M9oki2IZCjw5wl7KHz8OwfMurMpPVvzpt7D9AE9cribx17kPTsoabyq3psRuRBh9IYNnnApszV/To5aibHEO5WOq9bsS9ohAotTlZIkMG75VnMb2VsEy+Uq0QAIASLpUoJZpBdFjRMAhEZFpCiJaUd1gH6H9ua1Bbc7ye0Nc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b63bde6a-f5e3-44cd-5758-08d6d0f13dbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2019 00:33:06.3734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5881
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRmVyYXMgRGFvdWQgPGZlcmFzZGFAbWVsbGFub3guY29tPg0KDQpTaW5jZSB0aGUgRlcg
Y2FuIGJlIHNoYXJlZCBiZXR3ZWVuIGRpZmZlcmVudCBQRnMvVkZzIGl0IGlzIGNvbW1vbg0KdGhh
dCBtb3JlIHRoYW4gb25lIGhlYWx0aCBwb2xsIHdpbGwgZGV0ZWN0ZWQgYSBmYWlsdXJlLCB0aGlz
IGNhbg0KbGVhZCB0byBtdWx0aXBsZSByZXNldHMgd2hpY2ggYXJlIHVubmVlZGVkLg0KDQpUaGUg
c29sdXRpb24gaXMgdG8gdXNlIGEgRlcgbG9ja2luZyBtZWNoYW5pc20gdXNpbmcgc2VtYXBob3Jl
IHNwYWNlDQp0byBwcm92aWRlIGEgd2F5IHRvIGFsbG93IG9ubHkgb25lIGRldmljZSB0byBjb2xs
ZWN0IHRoZSBjci1kdW1wIGFuZA0KdG8gaXNzdWUgYSBzdy1yZXNldC4NCg0KU2lnbmVkLW9mZi1i
eTogRmVyYXMgRGFvdWQgPGZlcmFzZGFAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2Fl
ZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogQWxleCBWZXNr
ZXIgPHZhbGV4QG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxz
YWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogLi4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9saWIvcGNpX3ZzYy5jIHwgNDAgKysrKysrKysrKysrKysrKy0tLQ0KIC4uLi9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvbGliL3BjaV92c2MuaCB8ICA4ICsrKysNCiAuLi4vZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL21seDVfY29yZS5oICAgfCAgNCArKw0KIDMgZmlsZXMgY2hhbmdl
ZCwgNDcgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvcGNpX3ZzYy5jIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9wY2lfdnNjLmMNCmluZGV4IGY0
Mjg5MGJkZDZiMS4uYjZiOGZiMTNmNjIxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9wY2lfdnNjLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvcGNpX3ZzYy5jDQpAQCAtMjQsMTEgKzI0LDYg
QEANCiAJcGNpX3dyaXRlX2NvbmZpZ19kd29yZCgoZGV2KS0+cGRldiwgKGRldiktPnZzY19hZGRy
ICsgKG9mZnNldCksICh2YWwpKQ0KICNkZWZpbmUgVlNDX01BWF9SRVRSSUVTIDIwNDgNCiANCi1l
bnVtIG1seDVfdnNjX3N0YXRlIHsNCi0JTUxYNV9WU0NfVU5MT0NLLA0KLQlNTFg1X1ZTQ19MT0NL
LA0KLX07DQotDQogZW51bSB7DQogCVZTQ19DVFJMX09GRlNFVCA9IDB4NCwNCiAJVlNDX0NPVU5U
RVJfT0ZGU0VUID0gMHg4LA0KQEAgLTI4MSwzICsyNzYsMzggQEAgaW50IG1seDVfdnNjX2d3X3Jl
YWRfYmxvY2tfZmFzdChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCB1MzIgKmRhdGEsDQogCX0N
CiAJcmV0dXJuIGxlbmd0aDsNCiB9DQorDQoraW50IG1seDVfdnNjX3NlbV9zZXRfc3BhY2Uoc3Ry
dWN0IG1seDVfY29yZV9kZXYgKmRldiwgdTE2IHNwYWNlLA0KKwkJCSAgIGVudW0gbWx4NV92c2Nf
c3RhdGUgc3RhdGUpDQorew0KKwl1MzIgZGF0YSwgaWQgPSAwOw0KKwlpbnQgcmV0Ow0KKw0KKwly
ZXQgPSBtbHg1X3ZzY19nd19zZXRfc3BhY2UoZGV2LCBNTFg1X1NFTUFQSE9SRV9TUEFDRV9ET01B
SU4sIE5VTEwpOw0KKwlpZiAocmV0KSB7DQorCQltbHg1X2NvcmVfd2FybihkZXYsICJGYWlsZWQg
dG8gc2V0IGd3IHNwYWNlICVkXG4iLCByZXQpOw0KKwkJcmV0dXJuIHJldDsNCisJfQ0KKw0KKwlp
ZiAoc3RhdGUgPT0gTUxYNV9WU0NfTE9DSykgew0KKwkJLyogR2V0IGEgdW5pcXVlIElEIGJhc2Vk
IG9uIHRoZSBjb3VudGVyICovDQorCQlyZXQgPSB2c2NfcmVhZChkZXYsIFZTQ19DT1VOVEVSX09G
RlNFVCwgJmlkKTsNCisJCWlmIChyZXQpDQorCQkJcmV0dXJuIHJldDsNCisJfQ0KKw0KKwkvKiBU
cnkgdG8gbW9kaWZ5IGxvY2sgKi8NCisJcmV0ID0gbWx4NV92c2NfZ3dfd3JpdGUoZGV2LCBzcGFj
ZSwgaWQpOw0KKwlpZiAocmV0KQ0KKwkJcmV0dXJuIHJldDsNCisNCisJLyogVmVyaWZ5IGxvY2sg
d2FzIG1vZGlmaWVkICovDQorCXJldCA9IG1seDVfdnNjX2d3X3JlYWQoZGV2LCBzcGFjZSwgJmRh
dGEpOw0KKwlpZiAocmV0KQ0KKwkJcmV0dXJuIC1FSU5WQUw7DQorDQorCWlmIChkYXRhICE9IGlk
KQ0KKwkJcmV0dXJuIC1FQlVTWTsNCisNCisJcmV0dXJuIDA7DQorfQ0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvcGNpX3ZzYy5oIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9wY2lfdnNjLmgNCmluZGV4
IGM2ZWJmNTkwMDZjNS4uNDI2NGI2NWY3NDM3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9wY2lfdnNjLmgNCisrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvcGNpX3ZzYy5oDQpAQCAtNCw2ICs0LDEx
IEBADQogI2lmbmRlZiBfX01MWDVfUENJX1ZTQ19IX18NCiAjZGVmaW5lIF9fTUxYNV9QQ0lfVlND
X0hfXw0KIA0KK2VudW0gbWx4NV92c2Nfc3RhdGUgew0KKwlNTFg1X1ZTQ19VTkxPQ0ssDQorCU1M
WDVfVlNDX0xPQ0ssDQorfTsNCisNCiBlbnVtIHsNCiAJTUxYNV9WU0NfU1BBQ0VfU0NBTl9DUlNQ
QUNFID0gMHg3LA0KIH07DQpAQCAtMjIsNCArMjcsNyBAQCBzdGF0aWMgaW5saW5lIGJvb2wgbWx4
NV92c2NfYWNjZXNzaWJsZShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KIAlyZXR1cm4gISFk
ZXYtPnZzY19hZGRyOw0KIH0NCiANCitpbnQgbWx4NV92c2Nfc2VtX3NldF9zcGFjZShzdHJ1Y3Qg
bWx4NV9jb3JlX2RldiAqZGV2LCB1MTYgc3BhY2UsDQorCQkJICAgZW51bSBtbHg1X3ZzY19zdGF0
ZSBzdGF0ZSk7DQorDQogI2VuZGlmIC8qIF9fTUxYNV9QQ0lfVlNDX0hfXyAqLw0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tbHg1X2NvcmUuaCBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tbHg1X2NvcmUuaA0KaW5k
ZXggZDMxYjc3YWQ1MzNkLi40MzljZjIzOTQ1YTQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWx4NV9jb3JlLmgNCisrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tbHg1X2NvcmUuaA0KQEAgLTExMSw2ICsxMTEs
MTAgQEAgZW51bSB7DQogCU1MWDVfRFJJVkVSX1NZTkQgPSAweGJhZGQwMGRlLA0KIH07DQogDQor
ZW51bSBtbHg1X3NlbWFwaG9yZV9zcGFjZV9hZGRyZXNzIHsNCisJTUxYNV9TRU1BUEhPUkVfU1BB
Q0VfRE9NQUlOICAgICA9IDB4QSwNCit9Ow0KKw0KIGludCBtbHg1X3F1ZXJ5X2hjYV9jYXBzKHN0
cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpOw0KIGludCBtbHg1X3F1ZXJ5X2JvYXJkX2lkKHN0cnVj
dCBtbHg1X2NvcmVfZGV2ICpkZXYpOw0KIGludCBtbHg1X2NtZF9pbml0X2hjYShzdHJ1Y3QgbWx4
NV9jb3JlX2RldiAqZGV2LCB1aW50MzJfdCAqc3dfb3duZXJfaWQpOw0KLS0gDQoyLjIwLjENCg0K
