Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7F84A006
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbfFRMAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:00:51 -0400
Received: from mail-eopbgr140055.outbound.protection.outlook.com ([40.107.14.55]:53730
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728792AbfFRMAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 08:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBWl9/0V/m6g0RnEIHyvQXq1JkbHDmpXg1oOvaCkBbg=;
 b=qlgZmUmsqz29qzK/w9qnYKoJykuE3maTux9g7D3gkScpY1sOdE2nFw+UnIpnN5QDSf0/uRnQGGuBbXIbz2KrnUzEEkCjbInh19s6j0USoypPhi0hHILNZ6grSD/7D/5RsBMV1d6kEMNBCOOeIzm1qz/GbRMYCNjJD4dvuNsnYPg=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6277.eurprd05.prod.outlook.com (20.179.4.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Tue, 18 Jun 2019 12:00:43 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 12:00:43 +0000
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
Subject: [PATCH bpf-next v5 02/16] xsk: Add API to check for available entries
 in FQ
Thread-Topic: [PATCH bpf-next v5 02/16] xsk: Add API to check for available
 entries in FQ
Thread-Index: AQHVJc10jngysG608kG8qbW5PY4c7w==
Date:   Tue, 18 Jun 2019 12:00:43 +0000
Message-ID: <20190618120024.16788-3-maximmi@mellanox.com>
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
x-ms-office365-filtering-correlation-id: aba72d8e-7070-48a8-d172-08d6f3e496da
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6277;
x-ms-traffictypediagnostic: AM6PR05MB6277:
x-microsoft-antispam-prvs: <AM6PR05MB627723DED5AF018A3D22C59FD1EA0@AM6PR05MB6277.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(39860400002)(366004)(376002)(396003)(189003)(199004)(7416002)(8936002)(1076003)(71190400001)(6116002)(71200400001)(478600001)(5660300002)(110136005)(2906002)(11346002)(6436002)(2616005)(256004)(54906003)(446003)(3846002)(6486002)(68736007)(36756003)(186003)(26005)(66066001)(6512007)(81166006)(4326008)(486006)(476003)(81156014)(6506007)(73956011)(99286004)(386003)(102836004)(316002)(52116002)(76176011)(14454004)(107886003)(86362001)(8676002)(25786009)(53936002)(305945005)(7736002)(64756008)(66946007)(66476007)(50226002)(66556008)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6277;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2iEupRuM444Wg4dHnENr/Nvx/WSeQUo66Yan+cW58l5SZfk1APDdQltXTH0TYTO7K3kzBEcz0bFi8/3PiiKwERJ+qJY12BGRpJBtt0XTtOFlMYpJ9+TqV7dBO/HXUJU0svLgNcp4lNoNEaETcpRbb+Rtboh2vJiM8qeIEOLdjuWBA0cPyQsto0tC3kB5Qo/2yFq4wAdjknmpy90kTnHmvBgxfxVg0wNXMF5QDiWLFiEFwQW1GxsWlu8I0qU7xKn/vnRjbumVGLWQii5//KhQK1iGYdF5fWNDEEZ8MAiK2iNQgJgM97RQOyzmJJcDNUW9S0W36i97IKdPtG71bMRmWV6pGIzVGcFbKiHIcp4xV7LmMt0+qrqlnbSnteIoiIBBx5VgkErYfyMBxfJIs7A/YmoVaqjcynx4GJZknpKKc2s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12359EDF12153F40B62C691FFBA50F0C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aba72d8e-7070-48a8-d172-08d6f3e496da
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 12:00:43.1787
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

QWRkIGEgZnVuY3Rpb24gdGhhdCBjaGVja3Mgd2hldGhlciB0aGUgRmlsbCBSaW5nIGhhcyB0aGUg
c3BlY2lmaWVkDQphbW91bnQgb2YgZGVzY3JpcHRvcnMgYXZhaWxhYmxlLiBJdCB3aWxsIGJlIHVz
ZWZ1bCBmb3IgbWx4NWUgdGhhdCB3YW50cw0KdG8gY2hlY2sgaW4gYWR2YW5jZSwgd2hldGhlciBp
dCBjYW4gYWxsb2NhdGUgYSBidWxrIG9mIFJYIGRlc2NyaXB0b3JzLA0KdG8gZ2V0IHRoZSBiZXN0
IHBlcmZvcm1hbmNlLg0KDQpTaWduZWQtb2ZmLWJ5OiBNYXhpbSBNaWtpdHlhbnNraXkgPG1heGlt
bWlAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxh
bm94LmNvbT4NCkFja2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4N
CkFja2VkLWJ5OiBCasO2cm4gVMO2cGVsIDxiam9ybi50b3BlbEBpbnRlbC5jb20+DQotLS0NCiBp
bmNsdWRlL25ldC94ZHBfc29jay5oIHwgMjEgKysrKysrKysrKysrKysrKysrKysrDQogbmV0L3hk
cC94c2suYyAgICAgICAgICB8ICA2ICsrKysrKw0KIG5ldC94ZHAveHNrX3F1ZXVlLmggICAgfCAx
NCArKysrKysrKysrKysrKw0KIDMgZmlsZXMgY2hhbmdlZCwgNDEgaW5zZXJ0aW9ucygrKQ0KDQpk
aWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQveGRwX3NvY2suaCBiL2luY2x1ZGUvbmV0L3hkcF9zb2Nr
LmgNCmluZGV4IGFlMGYzNjhhNjJiYi4uYjZmNWViYWU0M2ExIDEwMDY0NA0KLS0tIGEvaW5jbHVk
ZS9uZXQveGRwX3NvY2suaA0KKysrIGIvaW5jbHVkZS9uZXQveGRwX3NvY2suaA0KQEAgLTc3LDYg
Kzc3LDcgQEAgaW50IHhza19yY3Yoc3RydWN0IHhkcF9zb2NrICp4cywgc3RydWN0IHhkcF9idWZm
ICp4ZHApOw0KIHZvaWQgeHNrX2ZsdXNoKHN0cnVjdCB4ZHBfc29jayAqeHMpOw0KIGJvb2wgeHNr
X2lzX3NldHVwX2Zvcl9icGZfbWFwKHN0cnVjdCB4ZHBfc29jayAqeHMpOw0KIC8qIFVzZWQgZnJv
bSBuZXRkZXYgZHJpdmVyICovDQorYm9vbCB4c2tfdW1lbV9oYXNfYWRkcnMoc3RydWN0IHhkcF91
bWVtICp1bWVtLCB1MzIgY250KTsNCiB1NjQgKnhza191bWVtX3BlZWtfYWRkcihzdHJ1Y3QgeGRw
X3VtZW0gKnVtZW0sIHU2NCAqYWRkcik7DQogdm9pZCB4c2tfdW1lbV9kaXNjYXJkX2FkZHIoc3Ry
dWN0IHhkcF91bWVtICp1bWVtKTsNCiB2b2lkIHhza191bWVtX2NvbXBsZXRlX3R4KHN0cnVjdCB4
ZHBfdW1lbSAqdW1lbSwgdTMyIG5iX2VudHJpZXMpOw0KQEAgLTk5LDYgKzEwMCwxNiBAQCBzdGF0
aWMgaW5saW5lIGRtYV9hZGRyX3QgeGRwX3VtZW1fZ2V0X2RtYShzdHJ1Y3QgeGRwX3VtZW0gKnVt
ZW0sIHU2NCBhZGRyKQ0KIH0NCiANCiAvKiBSZXVzZS1xdWV1ZSBhd2FyZSB2ZXJzaW9uIG9mIEZJ
TEwgcXVldWUgaGVscGVycyAqLw0KK3N0YXRpYyBpbmxpbmUgYm9vbCB4c2tfdW1lbV9oYXNfYWRk
cnNfcnEoc3RydWN0IHhkcF91bWVtICp1bWVtLCB1MzIgY250KQ0KK3sNCisJc3RydWN0IHhkcF91
bWVtX2ZxX3JldXNlICpycSA9IHVtZW0tPmZxX3JldXNlOw0KKw0KKwlpZiAocnEtPmxlbmd0aCA+
PSBjbnQpDQorCQlyZXR1cm4gdHJ1ZTsNCisNCisJcmV0dXJuIHhza191bWVtX2hhc19hZGRycyh1
bWVtLCBjbnQgLSBycS0+bGVuZ3RoKTsNCit9DQorDQogc3RhdGljIGlubGluZSB1NjQgKnhza191
bWVtX3BlZWtfYWRkcl9ycShzdHJ1Y3QgeGRwX3VtZW0gKnVtZW0sIHU2NCAqYWRkcikNCiB7DQog
CXN0cnVjdCB4ZHBfdW1lbV9mcV9yZXVzZSAqcnEgPSB1bWVtLT5mcV9yZXVzZTsNCkBAIC0xNDYs
NiArMTU3LDExIEBAIHN0YXRpYyBpbmxpbmUgYm9vbCB4c2tfaXNfc2V0dXBfZm9yX2JwZl9tYXAo
c3RydWN0IHhkcF9zb2NrICp4cykNCiAJcmV0dXJuIGZhbHNlOw0KIH0NCiANCitzdGF0aWMgaW5s
aW5lIGJvb2wgeHNrX3VtZW1faGFzX2FkZHJzKHN0cnVjdCB4ZHBfdW1lbSAqdW1lbSwgdTMyIGNu
dCkNCit7DQorCXJldHVybiBmYWxzZTsNCit9DQorDQogc3RhdGljIGlubGluZSB1NjQgKnhza191
bWVtX3BlZWtfYWRkcihzdHJ1Y3QgeGRwX3VtZW0gKnVtZW0sIHU2NCAqYWRkcikNCiB7DQogCXJl
dHVybiBOVUxMOw0KQEAgLTIwMCw2ICsyMTYsMTEgQEAgc3RhdGljIGlubGluZSBkbWFfYWRkcl90
IHhkcF91bWVtX2dldF9kbWEoc3RydWN0IHhkcF91bWVtICp1bWVtLCB1NjQgYWRkcikNCiAJcmV0
dXJuIDA7DQogfQ0KIA0KK3N0YXRpYyBpbmxpbmUgYm9vbCB4c2tfdW1lbV9oYXNfYWRkcnNfcnEo
c3RydWN0IHhkcF91bWVtICp1bWVtLCB1MzIgY250KQ0KK3sNCisJcmV0dXJuIGZhbHNlOw0KK30N
CisNCiBzdGF0aWMgaW5saW5lIHU2NCAqeHNrX3VtZW1fcGVla19hZGRyX3JxKHN0cnVjdCB4ZHBf
dW1lbSAqdW1lbSwgdTY0ICphZGRyKQ0KIHsNCiAJcmV0dXJuIE5VTEw7DQpkaWZmIC0tZ2l0IGEv
bmV0L3hkcC94c2suYyBiL25ldC94ZHAveHNrLmMNCmluZGV4IGExNGU4ODY0ZTRmYS4uYjY4YTM4
MGY1MGIzIDEwMDY0NA0KLS0tIGEvbmV0L3hkcC94c2suYw0KKysrIGIvbmV0L3hkcC94c2suYw0K
QEAgLTM3LDYgKzM3LDEyIEBAIGJvb2wgeHNrX2lzX3NldHVwX2Zvcl9icGZfbWFwKHN0cnVjdCB4
ZHBfc29jayAqeHMpDQogCQlSRUFEX09OQ0UoeHMtPnVtZW0tPmZxKTsNCiB9DQogDQorYm9vbCB4
c2tfdW1lbV9oYXNfYWRkcnMoc3RydWN0IHhkcF91bWVtICp1bWVtLCB1MzIgY250KQ0KK3sNCisJ
cmV0dXJuIHhza3FfaGFzX2FkZHJzKHVtZW0tPmZxLCBjbnQpOw0KK30NCitFWFBPUlRfU1lNQk9M
KHhza191bWVtX2hhc19hZGRycyk7DQorDQogdTY0ICp4c2tfdW1lbV9wZWVrX2FkZHIoc3RydWN0
IHhkcF91bWVtICp1bWVtLCB1NjQgKmFkZHIpDQogew0KIAlyZXR1cm4geHNrcV9wZWVrX2FkZHIo
dW1lbS0+ZnEsIGFkZHIpOw0KZGlmZiAtLWdpdCBhL25ldC94ZHAveHNrX3F1ZXVlLmggYi9uZXQv
eGRwL3hza19xdWV1ZS5oDQppbmRleCA4OGI5YWUyNDY1OGQuLjEyYjQ5Nzg0YTZkNSAxMDA2NDQN
Ci0tLSBhL25ldC94ZHAveHNrX3F1ZXVlLmgNCisrKyBiL25ldC94ZHAveHNrX3F1ZXVlLmgNCkBA
IC0xMTcsNiArMTE3LDIwIEBAIHN0YXRpYyBpbmxpbmUgdTMyIHhza3FfbmJfZnJlZShzdHJ1Y3Qg
eHNrX3F1ZXVlICpxLCB1MzIgcHJvZHVjZXIsIHUzMiBkY250KQ0KIAlyZXR1cm4gcS0+bmVudHJp
ZXMgLSAocHJvZHVjZXIgLSBxLT5jb25zX3RhaWwpOw0KIH0NCiANCitzdGF0aWMgaW5saW5lIGJv
b2wgeHNrcV9oYXNfYWRkcnMoc3RydWN0IHhza19xdWV1ZSAqcSwgdTMyIGNudCkNCit7DQorCXUz
MiBlbnRyaWVzID0gcS0+cHJvZF90YWlsIC0gcS0+Y29uc190YWlsOw0KKw0KKwlpZiAoZW50cmll
cyA+PSBjbnQpDQorCQlyZXR1cm4gdHJ1ZTsNCisNCisJLyogUmVmcmVzaCB0aGUgbG9jYWwgcG9p
bnRlci4gKi8NCisJcS0+cHJvZF90YWlsID0gUkVBRF9PTkNFKHEtPnJpbmctPnByb2R1Y2VyKTsN
CisJZW50cmllcyA9IHEtPnByb2RfdGFpbCAtIHEtPmNvbnNfdGFpbDsNCisNCisJcmV0dXJuIGVu
dHJpZXMgPj0gY250Ow0KK30NCisNCiAvKiBVTUVNIHF1ZXVlICovDQogDQogc3RhdGljIGlubGlu
ZSBib29sIHhza3FfaXNfdmFsaWRfYWRkcihzdHJ1Y3QgeHNrX3F1ZXVlICpxLCB1NjQgYWRkcikN
Ci0tIA0KMi4xOS4xDQoNCg==
