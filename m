Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAE542B59
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730220AbfFLP4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:56:51 -0400
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:31558
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726725AbfFLP4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 11:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbiWP55Q61DzvBO1MRA6OZJiCpSbDMB6kw9Hr2FJY6M=;
 b=Jl6MZuFs24FC8z+T9Dtz6y2LxY4aE2OIZQViTO5YjMR+lGEQ1vnoXPB/qhnvcLO+5bNdT50dfE0agT5ryGFcnHXh1YzgbE/KITAAdQvdbaCX/UuKyNTc5byXWdqGRfe6KZU8f18Sv4tHR2j1QaLbb/bbH/OEjxzsy2ntht38v0A=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5240.eurprd05.prod.outlook.com (20.177.196.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 12 Jun 2019 15:56:35 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 15:56:35 +0000
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
Subject: [PATCH bpf-next v4 01/17] net/mlx5e: Attach/detach XDP program safely
Thread-Topic: [PATCH bpf-next v4 01/17] net/mlx5e: Attach/detach XDP program
 safely
Thread-Index: AQHVITdpoGqZWrq1/EGfQD2C5Injmw==
Date:   Wed, 12 Jun 2019 15:56:35 +0000
Message-ID: <20190612155605.22450-2-maximmi@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
In-Reply-To: <20190612155605.22450-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::31) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a08fa60-e21a-4631-0e40-08d6ef4e8b9b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5240;
x-ms-traffictypediagnostic: AM6PR05MB5240:
x-microsoft-antispam-prvs: <AM6PR05MB5240E055BC4950AE973F47AAD1EC0@AM6PR05MB5240.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(39860400002)(396003)(346002)(189003)(199004)(486006)(8936002)(6486002)(446003)(8676002)(81166006)(81156014)(2906002)(6436002)(36756003)(26005)(11346002)(2616005)(476003)(50226002)(66066001)(102836004)(14454004)(186003)(107886003)(110136005)(54906003)(71190400001)(71200400001)(478600001)(316002)(25786009)(4326008)(1076003)(7736002)(305945005)(6512007)(66476007)(66946007)(66556008)(64756008)(66446008)(73956011)(68736007)(256004)(99286004)(7416002)(6116002)(386003)(14444005)(3846002)(6506007)(86362001)(53936002)(76176011)(5660300002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5240;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: i380p8nNmuWb8FslBf9NWmQDwLrRnCc6Zc+91RsAJZqUe1WfkvUPmX5DkRMPza5Xn6TKX2bOI7sxP3Xrz66CJOxnKj7p2XNzzURSGDNadBLL61hXh7ZCCAs3+XCkCFqqPm4DMBDAbewFCx2hIWzERZ0nfqhMeo/ob7OEXP7oby8s0Exrp8kmRzmn5KbzJqcXNOJmvcP1fDxVWSXjPcpJruyiRUbo8Ja6HfQM16DQKA5L3wPuVQJlqBCfIEIFI7D3sMYgb2M26iVijfFStuUXwVUKsBLrRTMEW152098aPhfdeaMsb0N4pBtsQRvBFyoyuqJO5BFJj7whw/XUAtKFbFNMjyIleOuCYKgz3SWGN4/HaT9vdFTYc3HHupkSWLCtLpW/4NTlFLywxJfCWi3a4hOXAacu5Rjn0nSMcGOM5og=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a08fa60-e21a-4631-0e40-08d6ef4e8b9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 15:56:35.2973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5240
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
