Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F924A003
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbfFRMAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:00:48 -0400
Received: from mail-eopbgr140055.outbound.protection.outlook.com ([40.107.14.55]:53730
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726023AbfFRMAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 08:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbiWP55Q61DzvBO1MRA6OZJiCpSbDMB6kw9Hr2FJY6M=;
 b=B14NV7F+4W/wN0NFBHtfdozalA0ruTT+CVdS9EzZp1oR3zxNzaORtMvApQEcfNvi7utRTZhDZrsfYdyecUHuiIVkQyeDUYyLH9Lwc3+HgsZ779GJJ+4mMoY4sne+jAuAvZ0dtdMd506MkyxiUz5ibOA0XQz3TcnGW6HtkhYBEn8=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6277.eurprd05.prod.outlook.com (20.179.4.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Tue, 18 Jun 2019 12:00:41 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 12:00:41 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf-next v5 01/16] net/mlx5e: Attach/detach XDP program safely
Thread-Topic: [PATCH bpf-next v5 01/16] net/mlx5e: Attach/detach XDP program
 safely
Thread-Index: AQHVJc1zWlud6YaRkkiFlMCapVQwDw==
Date:   Tue, 18 Jun 2019 12:00:41 +0000
Message-ID: <20190618120024.16788-2-maximmi@mellanox.com>
References: <20190618120024.16788-1-maximmi@mellanox.com>
In-Reply-To: <20190618120024.16788-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0064.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::28) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2b4f6af-d068-49f4-4196-08d6f3e495ac
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6277;
x-ms-traffictypediagnostic: AM6PR05MB6277:
x-microsoft-antispam-prvs: <AM6PR05MB62775CEF29A481CA743364FFD1EA0@AM6PR05MB6277.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(39860400002)(366004)(376002)(396003)(189003)(199004)(7416002)(8936002)(1076003)(71190400001)(6116002)(71200400001)(478600001)(5660300002)(110136005)(2906002)(11346002)(6436002)(2616005)(256004)(54906003)(446003)(14444005)(3846002)(6486002)(68736007)(36756003)(186003)(26005)(66066001)(6512007)(81166006)(4326008)(486006)(476003)(81156014)(6506007)(73956011)(99286004)(386003)(102836004)(316002)(52116002)(76176011)(14454004)(107886003)(86362001)(8676002)(25786009)(53936002)(305945005)(7736002)(64756008)(66946007)(66476007)(50226002)(66556008)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6277;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /sRS6FYH64fDqtvAPP9J9KC8SRyyauOem3btlJoT4i0/IJoeS90ly41QXoNh0r4iKX0pJvXP6oxtlhECMTUVVaVN9bQAr1QLvOTUui7gq7ljIrDNhYDlxAu4aDbWiBElV8aIwtVORYYbNZx+LeSnb/RM9tNwSVqB0px8mmZjKx12IhMmjxWub8o3r/lg58p3SnrOTCDWP6jYT3QKwZhllUYVS43hW2RU+YEYJM5OtIZSq7Ag3KRk/ivjD5x6//j4BahNDBiln+dJQOZDu9jc395YWmJr/9G/omctCaZ6JawOmbHTeDoG6x7DWo/BORAULrZOlPzFbSGj3/sGJDFr41w15adh+gZdSM8750UcuUatHVFzVtkkR62R/DUTZg7zoc9Rn3kBnSirr5XJd1mYLcm91G6UEdNvKgiNoWW1Beg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b4f6af-d068-49f4-4196-08d6f3e495ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 12:00:41.2808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6277
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2hlbiBhbiBYRFAgcHJvZ3JhbSBpcyBzZXQsIGEgZnVsbCByZW9wZW4gb2YgYWxsIGNoYW5uZWxz
IGhhcHBlbnMgaW4gdHdvDQpjYXNlczoNCg0KMS4gV2hlbiB0aGVyZSB3YXMgbm8gcHJvZ3JhbSBz
ZXQsIGFuZCBhIG5ldyBvbmUgaXMgYmVpbmcgc2V0Lg0KDQoyLiBXaGVuIHRoZXJlIHdhcyBhIHBy
b2dyYW0gc2V0LCBidXQgaXQncyBiZWluZyB1bnNldC4NCg0KVGhlIGZ1bGwgcmVvcGVuIGlzIG5l
Y2Vzc2FyeSwgYmVjYXVzZSB0aGUgY2hhbm5lbCBwYXJhbWV0ZXJzIG1heSBjaGFuZ2UNCmlmIFhE
UCBpcyBlbmFibGVkIG9yIGRpc2FibGVkLiBIb3dldmVyLCBpdCdzIHBlcmZvcm1lZCBpbiBhbiB1
bnNhZmUgd2F5Og0KaWYgdGhlIG5ldyBjaGFubmVscyBmYWlsIHRvIG9wZW4sIHRoZSBvbGQgb25l
cyBhcmUgYWxyZWFkeSBjbG9zZWQsIGFuZA0KdGhlIGludGVyZmFjZSBnb2VzIGRvd24uIFVzZSB0
aGUgc2FmZSB3YXkgdG8gc3dpdGNoIGNoYW5uZWxzIGluc3RlYWQuDQpUaGUgc2FtZSB3YXkgaXMg
YWxyZWFkeSB1c2VkIGZvciBvdGhlciBjb25maWd1cmF0aW9uIGNoYW5nZXMuDQoNClNpZ25lZC1v
ZmYtYnk6IE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQpSZXZpZXdl
ZC1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTog
U2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiAuLi4vbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMgfCAzMSArKysrKysrKysrKystLS0tLS0t
DQogMSBmaWxlIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21h
aW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMN
CmluZGV4IGM2NWNlZmQ4NGVkYS4uM2U1NGIxZjMzNTg3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KQEAgLTQxOTIsOCArNDE5
Miw2IEBAIHN0YXRpYyBpbnQgbWx4NWVfeGRwX3NldChzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2
LCBzdHJ1Y3QgYnBmX3Byb2cgKnByb2cpDQogCS8qIG5vIG5lZWQgZm9yIGZ1bGwgcmVzZXQgd2hl
biBleGNoYW5naW5nIHByb2dyYW1zICovDQogCXJlc2V0ID0gKCFwcml2LT5jaGFubmVscy5wYXJh
bXMueGRwX3Byb2cgfHwgIXByb2cpOw0KIA0KLQlpZiAod2FzX29wZW5lZCAmJiByZXNldCkNCi0J
CW1seDVlX2Nsb3NlX2xvY2tlZChuZXRkZXYpOw0KIAlpZiAod2FzX29wZW5lZCAmJiAhcmVzZXQp
IHsNCiAJCS8qIG51bV9jaGFubmVscyBpcyBpbnZhcmlhbnQgaGVyZSwgc28gd2UgY2FuIHRha2Ug
dGhlDQogCQkgKiBiYXRjaGVkIHJlZmVyZW5jZSByaWdodCB1cGZyb250Lg0KQEAgLTQyMDUsMjAg
KzQyMDMsMzEgQEAgc3RhdGljIGludCBtbHg1ZV94ZHBfc2V0KHN0cnVjdCBuZXRfZGV2aWNlICpu
ZXRkZXYsIHN0cnVjdCBicGZfcHJvZyAqcHJvZykNCiAJCX0NCiAJfQ0KIA0KLQkvKiBleGNoYW5n
ZSBwcm9ncmFtcywgZXh0cmEgcHJvZyByZWZlcmVuY2Ugd2UgZ290IGZyb20gY2FsbGVyDQotCSAq
IGFzIGxvbmcgYXMgd2UgZG9uJ3QgZmFpbCBmcm9tIHRoaXMgcG9pbnQgb253YXJkcy4NCi0JICov
DQotCW9sZF9wcm9nID0geGNoZygmcHJpdi0+Y2hhbm5lbHMucGFyYW1zLnhkcF9wcm9nLCBwcm9n
KTsNCisJaWYgKHdhc19vcGVuZWQgJiYgcmVzZXQpIHsNCisJCXN0cnVjdCBtbHg1ZV9jaGFubmVs
cyBuZXdfY2hhbm5lbHMgPSB7fTsNCisNCisJCW5ld19jaGFubmVscy5wYXJhbXMgPSBwcml2LT5j
aGFubmVscy5wYXJhbXM7DQorCQluZXdfY2hhbm5lbHMucGFyYW1zLnhkcF9wcm9nID0gcHJvZzsN
CisJCW1seDVlX3NldF9ycV90eXBlKHByaXYtPm1kZXYsICZuZXdfY2hhbm5lbHMucGFyYW1zKTsN
CisJCW9sZF9wcm9nID0gcHJpdi0+Y2hhbm5lbHMucGFyYW1zLnhkcF9wcm9nOw0KKw0KKwkJZXJy
ID0gbWx4NWVfc2FmZV9zd2l0Y2hfY2hhbm5lbHMocHJpdiwgJm5ld19jaGFubmVscywgTlVMTCk7
DQorCQlpZiAoZXJyKQ0KKwkJCWdvdG8gdW5sb2NrOw0KKwl9IGVsc2Ugew0KKwkJLyogZXhjaGFu
Z2UgcHJvZ3JhbXMsIGV4dHJhIHByb2cgcmVmZXJlbmNlIHdlIGdvdCBmcm9tIGNhbGxlcg0KKwkJ
ICogYXMgbG9uZyBhcyB3ZSBkb24ndCBmYWlsIGZyb20gdGhpcyBwb2ludCBvbndhcmRzLg0KKwkJ
ICovDQorCQlvbGRfcHJvZyA9IHhjaGcoJnByaXYtPmNoYW5uZWxzLnBhcmFtcy54ZHBfcHJvZywg
cHJvZyk7DQorCX0NCisNCiAJaWYgKG9sZF9wcm9nKQ0KIAkJYnBmX3Byb2dfcHV0KG9sZF9wcm9n
KTsNCiANCi0JaWYgKHJlc2V0KSAvKiBjaGFuZ2UgUlEgdHlwZSBhY2NvcmRpbmcgdG8gcHJpdi0+
eGRwX3Byb2cgKi8NCisJaWYgKCF3YXNfb3BlbmVkICYmIHJlc2V0KSAvKiBjaGFuZ2UgUlEgdHlw
ZSBhY2NvcmRpbmcgdG8gcHJpdi0+eGRwX3Byb2cgKi8NCiAJCW1seDVlX3NldF9ycV90eXBlKHBy
aXYtPm1kZXYsICZwcml2LT5jaGFubmVscy5wYXJhbXMpOw0KIA0KLQlpZiAod2FzX29wZW5lZCAm
JiByZXNldCkNCi0JCWVyciA9IG1seDVlX29wZW5fbG9ja2VkKG5ldGRldik7DQotDQotCWlmICgh
dGVzdF9iaXQoTUxYNUVfU1RBVEVfT1BFTkVELCAmcHJpdi0+c3RhdGUpIHx8IHJlc2V0KQ0KKwlp
ZiAoIXdhc19vcGVuZWQgfHwgcmVzZXQpDQogCQlnb3RvIHVubG9jazsNCiANCiAJLyogZXhjaGFu
Z2luZyBwcm9ncmFtcyB3L28gcmVzZXQsIHdlIHVwZGF0ZSByZWYgY291bnRzIG9uIGJlaGFsZg0K
LS0gDQoyLjE5LjENCg0K
