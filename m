Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF2475A780
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfF1XTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:19:13 -0400
Received: from mail-eopbgr50055.outbound.protection.outlook.com ([40.107.5.55]:38726
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbfF1XTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 19:19:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=wrRiCWqVSgkY7E9DyAnkTu2OPK42E7z+GsCdnhJFs7gDZkhEx4Kbp/Hh9l3XdiUfs57Au3KjxzJnvibkdQNdz0x3W51NEzkcZJCHN1GKELAnGDCLrRk8K5yBlZEUuwsbq5dUKutZCrW1QxtqopC8kiSHMOJkyol0xmskpPDLUqw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ohPnNI/Td8tFxE03hgYW05OGdADQZhcU0K+UKyTF7sk=;
 b=dom4chUupP2XcoB7jJyQi2/BMVMOXO4e2oghDDsQDfpGMArvEQqud5M0z5Kva7zsbaBlZz9CT0WwDMPaw7lo+COv9Pz98ePdXPpbe1l3OOoRjYLBi2qrUKEg3cOAS4xVzzLASE8PdZvat0ojjX8PVY7AaJ8YEAV4PSE0IBbDkMc=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ohPnNI/Td8tFxE03hgYW05OGdADQZhcU0K+UKyTF7sk=;
 b=rUDf7sBy7JSNFMEpZ686JhFBkgNfDJqbTYOgUxIaPuc5NHxUxkrRqhE8dCTSRC80I4z2iAFWEuBiD/JwOEhncOe2WQos2eufIv97Rjxu0ivcvsrH0BFUimiP85GowMYKqFyxIbNXjyVoJ7EWfujkiqUm8VgAkkROcNYalNssS5A=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2198.eurprd05.prod.outlook.com (10.168.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 23:18:35 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 23:18:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/10] net/mlx5e: Disallow tc redirect offload cases we
 don't support
Thread-Topic: [net-next 10/10] net/mlx5e: Disallow tc redirect offload cases
 we don't support
Thread-Index: AQHVLgfPPbsMsVcsBE+HswlSf3H0nQ==
Date:   Fri, 28 Jun 2019 23:18:35 +0000
Message-ID: <20190628231759.16374-11-saeedm@mellanox.com>
References: <20190628231759.16374-1-saeedm@mellanox.com>
In-Reply-To: <20190628231759.16374-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0057.prod.exchangelabs.com (2603:10b6:a03:94::34)
 To DB6PR0501MB2759.eurprd05.prod.outlook.com (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27ae3c85-144e-41f2-ac86-08d6fc1ef180
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2198;
x-ms-traffictypediagnostic: DB6PR0501MB2198:
x-microsoft-antispam-prvs: <DB6PR0501MB21983E013B7A189ABE529E19BEFC0@DB6PR0501MB2198.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39850400004)(136003)(346002)(366004)(189003)(199004)(6512007)(186003)(71190400001)(81166006)(6916009)(478600001)(71200400001)(81156014)(476003)(3846002)(6506007)(53936002)(66946007)(66556008)(66446008)(64756008)(66476007)(25786009)(8676002)(54906003)(6486002)(486006)(446003)(73956011)(305945005)(66066001)(99286004)(4326008)(11346002)(1076003)(86362001)(7736002)(5660300002)(107886003)(52116002)(26005)(6116002)(36756003)(76176011)(2616005)(386003)(14454004)(6436002)(2906002)(8936002)(102836004)(256004)(50226002)(316002)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2198;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EY79VSG3WL1TwNoqe0Mh53IcW7emdHpNWLtML6OuZZRU5XDpPHCKgusSq3masI9QFtycKDvhRn83T7s6c4YGneNqbAYqaKwlXZFqvgKvGaXmbV0Pg5Ha4z7mhl0lfxawVXOJORWa3yH+j4j9xWGlCzj44hWlZXnKVEmaT86yL/J0jbqrTj5LEmzh1GQnPjvRnNJlCnVE82EUnwJrbdMK/9Jqtbeuds2r/azbP5BpAYFSKI9SkriG73RaJRJ9Dqj2iFY8Tk5IH92DEGfvr13zSrOcl32z7Drgx+y2wduKuYxc+Wjd9lXLV9AiFhPllxtbbC3NXI14Dj2GxoFALLS0Lftrhh1a0xQ17RcsmgOXqnJzTC031F1NVSv+EaFTNyE3jRJgvGI6ATRX422ltdIRVFdo5vnB8z8DmASwW+7s63g=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27ae3c85-144e-41f2-ac86-08d6fc1ef180
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 23:18:35.5298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGF1bCBCbGFrZXkgPHBhdWxiQG1lbGxhbm94LmNvbT4NCg0KQWZ0ZXIgY2hhbmdpbmcg
dGhlIHBhcmVudF9pZCB0byBiZSB0aGUgc2FtZSBmb3IgYm90aCBOSUNzIG9mIHNhbWUNCnRoZSBo
YXJkd2FyZSBkZXZpY2UsIG5ldGRldl9wb3J0X3NhbWVfcGFyZW50X2lkIG5vdyByZXR1cm5zIHRy
dWUgZm9yDQptb3JlIGNhc2VzIChhbGwgdGhlIGxvd2VyIGRldmljZXMgaW4gdGhlIGhpZXJhcmNo
eSBhcmUgb24gdGhlIHNhbWUNCmhhcmR3YXJlIGRldmljZSkuDQoNCklmIG1lcmdlZCBlc3dpdGNo
IGlzbid0IGVuYWJsZWQsIHRoZXNlIGNhc2VzIGFyZW4ndCBzdXBwb3J0ZWQsIHNvIGRpc2FsbG93
DQp0aGVtLg0KDQpTaWduZWQtb2ZmLWJ5OiBQYXVsIEJsYWtleSA8cGF1bGJAbWVsbGFub3guY29t
Pg0KUmV2aWV3ZWQtYnk6IFJvaSBEYXlhbiA8cm9pZEBtZWxsYW5veC5jb20+DQpTaWduZWQtb2Zm
LWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIC4uLi9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdGNfdHVuLmMgICB8ICA0ICsrKy0NCiAuLi4vbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jICAgfCAyMiArKysrKysrKysrKysr
KystLS0tDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuaCAgIHwg
IDMgKysrDQogMyBmaWxlcyBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygt
KQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuL3RjX3R1bi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vu
L3RjX3R1bi5jDQppbmRleCBmNWFkNTMxZTE3NDkuLjM3Mzk2NDZiNjUzZiAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi90Y190dW4uYw0KKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3RjX3R1bi5jDQpA
QCAtNSw2ICs1LDcgQEANCiAjaW5jbHVkZSA8bmV0L2dyZS5oPg0KICNpbmNsdWRlIDxuZXQvZ2Vu
ZXZlLmg+DQogI2luY2x1ZGUgImVuL3RjX3R1bi5oIg0KKyNpbmNsdWRlICJlbl90Yy5oIg0KIA0K
IHN0cnVjdCBtbHg1ZV90Y190dW5uZWwgKm1seDVlX2dldF90Y190dW4oc3RydWN0IG5ldF9kZXZp
Y2UgKnR1bm5lbF9kZXYpDQogew0KQEAgLTQ3LDcgKzQ4LDggQEAgc3RhdGljIGludCBnZXRfcm91
dGVfYW5kX291dF9kZXZzKHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2LA0KIAkJKnJvdXRlX2RldiA9
IGRldjsNCiAJCWlmIChpc192bGFuX2Rldigqcm91dGVfZGV2KSkNCiAJCQkqb3V0X2RldiA9IHVw
bGlua19kZXY7DQotCQllbHNlIGlmIChtbHg1ZV9lc3dpdGNoX3JlcChkZXYpKQ0KKwkJZWxzZSBp
ZiAobWx4NWVfZXN3aXRjaF9yZXAoZGV2KSAmJg0KKwkJCSBtbHg1ZV9pc192YWxpZF9lc3dpdGNo
X2Z3ZF9kZXYocHJpdiwgZGV2KSkNCiAJCQkqb3V0X2RldiA9ICpyb3V0ZV9kZXY7DQogCQllbHNl
DQogCQkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCmluZGV4IDE0NTNkYTZlZjU1OS4uZTZiMTk5Y2Q2OGVh
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vu
X3RjLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90
Yy5jDQpAQCAtMjgwMiw2ICsyODAyLDE2IEBAIHN0YXRpYyBpbnQgYWRkX3ZsYW5fcG9wX2FjdGlv
bihzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwNCiAJcmV0dXJuIGVycjsNCiB9DQogDQorYm9vbCBt
bHg1ZV9pc192YWxpZF9lc3dpdGNoX2Z3ZF9kZXYoc3RydWN0IG1seDVlX3ByaXYgKnByaXYsDQor
CQkJCSAgICBzdHJ1Y3QgbmV0X2RldmljZSAqb3V0X2RldikNCit7DQorCWlmIChpc19tZXJnZWRf
ZXN3aXRjaF9kZXYocHJpdiwgb3V0X2RldikpDQorCQlyZXR1cm4gdHJ1ZTsNCisNCisJcmV0dXJu
IG1seDVlX2Vzd2l0Y2hfcmVwKG91dF9kZXYpICYmDQorCSAgICAgICBzYW1lX2h3X2RldnMocHJp
diwgbmV0ZGV2X3ByaXYob3V0X2RldikpOw0KK30NCisNCiBzdGF0aWMgaW50IHBhcnNlX3RjX2Zk
Yl9hY3Rpb25zKHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2LA0KIAkJCQlzdHJ1Y3QgZmxvd19hY3Rp
b24gKmZsb3dfYWN0aW9uLA0KIAkJCQlzdHJ1Y3QgbWx4NWVfdGNfZmxvdyAqZmxvdywNCkBAIC0y
ODY3LDkgKzI4NzcsNyBAQCBzdGF0aWMgaW50IHBhcnNlX3RjX2ZkYl9hY3Rpb25zKHN0cnVjdCBt
bHg1ZV9wcml2ICpwcml2LA0KIA0KIAkJCWFjdGlvbiB8PSBNTFg1X0ZMT1dfQ09OVEVYVF9BQ1RJ
T05fRldEX0RFU1QgfA0KIAkJCQkgIE1MWDVfRkxPV19DT05URVhUX0FDVElPTl9DT1VOVDsNCi0J
CQlpZiAobmV0ZGV2X3BvcnRfc2FtZV9wYXJlbnRfaWQocHJpdi0+bmV0ZGV2LA0KLQkJCQkJCSAg
ICAgICBvdXRfZGV2KSB8fA0KLQkJCSAgICBpc19tZXJnZWRfZXN3aXRjaF9kZXYocHJpdiwgb3V0
X2RldikpIHsNCisJCQlpZiAobmV0ZGV2X3BvcnRfc2FtZV9wYXJlbnRfaWQocHJpdi0+bmV0ZGV2
LCBvdXRfZGV2KSkgew0KIAkJCQlzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3cgPSBwcml2LT5tZGV2
LT5wcml2LmVzd2l0Y2g7DQogCQkJCXN0cnVjdCBuZXRfZGV2aWNlICp1cGxpbmtfZGV2ID0gbWx4
NV9lc3dpdGNoX3VwbGlua19nZXRfcHJvdG9fZGV2KGVzdywgUkVQX0VUSCk7DQogCQkJCXN0cnVj
dCBuZXRfZGV2aWNlICp1cGxpbmtfdXBwZXIgPSBuZXRkZXZfbWFzdGVyX3VwcGVyX2Rldl9nZXQo
dXBsaW5rX2Rldik7DQpAQCAtMjg4Niw2ICsyODk0LDcgQEAgc3RhdGljIGludCBwYXJzZV90Y19m
ZGJfYWN0aW9ucyhzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwNCiAJCQkJCWlmIChlcnIpDQogCQkJ
CQkJcmV0dXJuIGVycjsNCiAJCQkJfQ0KKw0KIAkJCQlpZiAoaXNfdmxhbl9kZXYocGFyc2VfYXR0
ci0+ZmlsdGVyX2RldikpIHsNCiAJCQkJCWVyciA9IGFkZF92bGFuX3BvcF9hY3Rpb24ocHJpdiwg
YXR0ciwNCiAJCQkJCQkJCSAgJmFjdGlvbik7DQpAQCAtMjg5Myw4ICsyOTAyLDEzIEBAIHN0YXRp
YyBpbnQgcGFyc2VfdGNfZmRiX2FjdGlvbnMoc3RydWN0IG1seDVlX3ByaXYgKnByaXYsDQogCQkJ
CQkJcmV0dXJuIGVycjsNCiAJCQkJfQ0KIA0KLQkJCQlpZiAoIW1seDVlX2Vzd2l0Y2hfcmVwKG91
dF9kZXYpKQ0KKwkJCQlpZiAoIW1seDVlX2lzX3ZhbGlkX2Vzd2l0Y2hfZndkX2Rldihwcml2LCBv
dXRfZGV2KSkgew0KKwkJCQkJTkxfU0VUX0VSUl9NU0dfTU9EKGV4dGFjaywNCisJCQkJCQkJICAg
ImRldmljZXMgYXJlIG5vdCBvbiBzYW1lIHN3aXRjaCBIVywgY2FuJ3Qgb2ZmbG9hZCBmb3J3YXJk
aW5nIik7DQorCQkJCQlwcl9lcnIoImRldmljZXMgJXMgJXMgbm90IG9uIHNhbWUgc3dpdGNoIEhX
LCBjYW4ndCBvZmZsb2FkIGZvcndhcmRpbmdcbiIsDQorCQkJCQkgICAgICAgcHJpdi0+bmV0ZGV2
LT5uYW1lLCBvdXRfZGV2LT5uYW1lKTsNCiAJCQkJCXJldHVybiAtRU9QTk9UU1VQUDsNCisJCQkJ
fQ0KIA0KIAkJCQlvdXRfcHJpdiA9IG5ldGRldl9wcml2KG91dF9kZXYpOw0KIAkJCQlycHJpdiA9
IG91dF9wcml2LT5wcHJpdjsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fdGMuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lbl90Yy5oDQppbmRleCBmNjJlODE5MDJkMjcuLjhmMjg4Y2M1M2NlZSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5oDQor
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuaA0KQEAg
LTc0LDYgKzc0LDkgQEAgaW50IG1seDVlX3RjX251bV9maWx0ZXJzKHN0cnVjdCBtbHg1ZV9wcml2
ICpwcml2LCBpbnQgZmxhZ3MpOw0KIA0KIHZvaWQgbWx4NWVfdGNfcmVvZmZsb2FkX2Zsb3dzX3dv
cmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsNCiANCitib29sIG1seDVlX2lzX3ZhbGlkX2Vz
d2l0Y2hfZndkX2RldihzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwNCisJCQkJICAgIHN0cnVjdCBu
ZXRfZGV2aWNlICpvdXRfZGV2KTsNCisNCiAjZWxzZSAvKiBDT05GSUdfTUxYNV9FU1dJVENIICov
DQogc3RhdGljIGlubGluZSBpbnQgIG1seDVlX3RjX25pY19pbml0KHN0cnVjdCBtbHg1ZV9wcml2
ICpwcml2KSB7IHJldHVybiAwOyB9DQogc3RhdGljIGlubGluZSB2b2lkIG1seDVlX3RjX25pY19j
bGVhbnVwKHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2KSB7fQ0KLS0gDQoyLjIxLjANCg0K
