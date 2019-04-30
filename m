Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80973FF8D
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfD3SNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:13:13 -0400
Received: from mail-eopbgr30059.outbound.protection.outlook.com ([40.107.3.59]:50702
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727116AbfD3SNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 14:13:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHjfPZYWf8YCHEMhQ//r4APPkgy8jPN+XH9M3DKK8HQ=;
 b=V1BuiLJtOR4ZOUWUvkRJINN+9mEIA0161SKFXUERQnX+bq3nPEHECspoR7LQVZMJMUSlqEK2bH8OnAljl+QJZIlDePu4EK78CCpgNkA1lnL0Eyt82j965y58pJmnQYwbAhPs0oaDqpcGCtGcSeoPuCphNY81xhlm8qk+fpzFQSs=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5553.eurprd05.prod.outlook.com (20.177.119.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 18:13:00 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f%2]) with mapi id 15.20.1856.008; Tue, 30 Apr 2019
 18:13:00 +0000
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
Subject: [PATCH bpf-next v2 12/16] net/mlx5e: XDP_TX from UMEM support
Thread-Topic: [PATCH bpf-next v2 12/16] net/mlx5e: XDP_TX from UMEM support
Thread-Index: AQHU/4BY7+ol6mGyPk+jUMCWC6sZuQ==
Date:   Tue, 30 Apr 2019 18:13:00 +0000
Message-ID: <20190430181215.15305-13-maximmi@mellanox.com>
References: <20190430181215.15305-1-maximmi@mellanox.com>
In-Reply-To: <20190430181215.15305-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0250.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::22) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0233007-6601-4158-6297-08d6cd977ab5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5553;
x-ms-traffictypediagnostic: AM6PR05MB5553:
x-microsoft-antispam-prvs: <AM6PR05MB5553B23B953B4A40A98E77E5D13A0@AM6PR05MB5553.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(6506007)(3846002)(26005)(478600001)(316002)(97736004)(6116002)(446003)(76176011)(4326008)(476003)(486006)(8676002)(110136005)(52116002)(81166006)(6436002)(50226002)(54906003)(8936002)(99286004)(11346002)(81156014)(2616005)(66946007)(66556008)(256004)(66476007)(64756008)(66446008)(73956011)(36756003)(305945005)(71200400001)(71190400001)(107886003)(102836004)(68736007)(86362001)(7736002)(186003)(66066001)(6486002)(1076003)(386003)(5660300002)(53936002)(25786009)(6512007)(14454004)(7416002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5553;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FCSr2DByuZCDUwEun6DT7yQn3SChN3UerxK29NKUACE9MK53IpkyfquyaSPxQdgyimpacvJqFyISsqB9iAPImPFouaRMtMhmfbcyhHC/R/Ey0AYY/Tw9hdDv1nKP7Ra9jXMYksTKSlQJf3p4QYqQl1A5HYhn/BWevLW+KSIfhsDcU8DrzrsA3tA5SRum07+gYSZVsCXzv/YFDMX6Bk/PxyuVt8Uq9FOPUuRTZ6STUWyrUa7sv9thCenx6QG/a28/UDrAwhgtDJB6BNZmzNRm+M7SSKDFYR57nYa75/F4SlD1LwT/xAWLPsvfBhsODqMmnKgegeGqTR/mYs9CLMLkVS9M9Ff3FoGOQ6W904rayaDn+GwzseWLLUxAov1JmBQ5ogSRIxrbLkS4ebqk0YJVMynaaG04Do3D8zNAmsxgUyc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0233007-6601-4158-6297-08d6cd977ab5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 18:13:00.5309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5553
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2hlbiBhbiBYRFAgcHJvZ3JhbSByZXR1cm5zIFhEUF9UWCwgYW5kIHRoZSBSUSBpcyBYU0stZW5h
YmxlZCwgaXQNCnJlcXVpcmVzIGNhcmVmdWwgaGFuZGxpbmcsIGJlY2F1c2UgY29udmVydF90b194
ZHBfZnJhbWUgY3JlYXRlcyBhIG5ldw0KcGFnZSBhbmQgY29waWVzIHRoZSBkYXRhIHRoZXJlLCB3
aGlsZSBvdXIgZHJpdmVyIGV4cGVjdHMgdGhlIHhkcF9mcmFtZQ0KdG8gcG9pbnQgdG8gdGhlIHNh
bWUgbWVtb3J5IGFzIHRoZSB4ZHBfYnVmZi4gSGFuZGxlIHRoaXMgY2FzZQ0Kc2VwYXJhdGVseTog
bWFwIHRoZSBwYWdlLCBhbmQgaW4gdGhlIGVuZCB1bm1hcCBpdCBhbmQgY2FsbA0KeGRwX3JldHVy
bl9mcmFtZS4NCg0KU2lnbmVkLW9mZi1ieTogTWF4aW0gTWlraXR5YW5za2l5IDxtYXhpbW1pQG1l
bGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBtZWxsYW5veC5j
b20+DQpBY2tlZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0N
CiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94ZHAuYyAgfCA1MCArKysr
KysrKysrKysrKysrLS0tDQogMSBmaWxlIGNoYW5nZWQsIDQyIGluc2VydGlvbnMoKyksIDggZGVs
ZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW4veGRwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW4veGRwLmMNCmluZGV4IGIzZTExOGZjNDUyMS4uMTM2NGJkZmY3MDJjIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hkcC5jDQorKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMNCkBAIC02
OSwxNCArNjksNDggQEAgbWx4NWVfeG1pdF94ZHBfYnVmZihzdHJ1Y3QgbWx4NWVfeGRwc3EgKnNx
LCBzdHJ1Y3QgbWx4NWVfcnEgKnJxLA0KIAl4ZHB0eGQuZGF0YSA9IHhkcGYtPmRhdGE7DQogCXhk
cHR4ZC5sZW4gID0geGRwZi0+bGVuOw0KIA0KLQl4ZHBpLm1vZGUgPSBNTFg1RV9YRFBfWE1JVF9N
T0RFX1BBR0U7DQorCWlmICh4ZHAtPnJ4cS0+bWVtLnR5cGUgPT0gTUVNX1RZUEVfWkVST19DT1BZ
KSB7DQorCQkvKiBUaGUgeGRwX2J1ZmYgd2FzIGluIHRoZSBVTUVNIGFuZCB3YXMgY29waWVkIGlu
dG8gYSBuZXdseQ0KKwkJICogYWxsb2NhdGVkIHBhZ2UuIFRoZSBVTUVNIHBhZ2Ugd2FzIHJldHVy
bmVkIHZpYSB0aGUgWkNBLCBhbmQNCisJCSAqIHRoaXMgbmV3IHBhZ2UgaGFzIHRvIGJlIG1hcHBl
ZCBhdCB0aGlzIHBvaW50IGFuZCBoYXMgdG8gYmUNCisJCSAqIHVubWFwcGVkIGFuZCByZXR1cm5l
ZCB2aWEgeGRwX3JldHVybl9mcmFtZSBvbiBjb21wbGV0aW9uLg0KKwkJICovDQorDQorCQkvKiBQ
cmV2ZW50IGRvdWJsZSByZWN5Y2xpbmcgb2YgdGhlIFVNRU0gcGFnZS4gRXZlbiBpbiBjYXNlIHRo
aXMNCisJCSAqIGZ1bmN0aW9uIHJldHVybnMgZmFsc2UsIHRoZSB4ZHBfYnVmZiBzaG91bGRuJ3Qg
YmUgcmVjeWNsZWQsDQorCQkgKiBhcyBpdCB3YXMgYWxyZWFkeSBkb25lIGluIHhkcF9jb252ZXJ0
X3pjX3RvX3hkcF9mcmFtZS4NCisJCSAqLw0KKwkJX19zZXRfYml0KE1MWDVFX1JRX0ZMQUdfWERQ
X1hNSVQsIHJxLT5mbGFncyk7IC8qIG5vbi1hdG9taWMgKi8NCisNCisJCXhkcGkubW9kZSA9IE1M
WDVFX1hEUF9YTUlUX01PREVfRlJBTUU7DQogDQotCWRtYV9hZGRyID0gZGktPmFkZHIgKyAoeGRw
Zi0+ZGF0YSAtICh2b2lkICopeGRwZik7DQotCWRtYV9zeW5jX3NpbmdsZV9mb3JfZGV2aWNlKHNx
LT5wZGV2LCBkbWFfYWRkciwgeGRwdHhkLmxlbiwgRE1BX1RPX0RFVklDRSk7DQorCQlkbWFfYWRk
ciA9IGRtYV9tYXBfc2luZ2xlKHNxLT5wZGV2LCB4ZHB0eGQuZGF0YSwgeGRwdHhkLmxlbiwNCisJ
CQkJCSAgRE1BX1RPX0RFVklDRSk7DQorCQlpZiAoZG1hX21hcHBpbmdfZXJyb3Ioc3EtPnBkZXYs
IGRtYV9hZGRyKSkgew0KKwkJCXhkcF9yZXR1cm5fZnJhbWUoeGRwZik7DQorCQkJcmV0dXJuIGZh
bHNlOw0KKwkJfQ0KIA0KLQl4ZHB0eGQuZG1hX2FkZHIgPSBkbWFfYWRkcjsNCi0JeGRwaS5wYWdl
LnJxID0gcnE7DQotCXhkcGkucGFnZS5kaSA9ICpkaTsNCisJCXhkcHR4ZC5kbWFfYWRkciAgICAg
PSBkbWFfYWRkcjsNCisJCXhkcGkuZnJhbWUueGRwZiAgICAgPSB4ZHBmOw0KKwkJeGRwaS5mcmFt
ZS5kbWFfYWRkciA9IGRtYV9hZGRyOw0KKwl9IGVsc2Ugew0KKwkJLyogRHJpdmVyIGFzc3VtZXMg
dGhhdCBjb252ZXJ0X3RvX3hkcF9mcmFtZSByZXR1cm5zIGFuIHhkcF9mcmFtZQ0KKwkJICogdGhh
dCBwb2ludHMgdG8gdGhlIHNhbWUgbWVtb3J5IHJlZ2lvbiBhcyB0aGUgb3JpZ2luYWwNCisJCSAq
IHhkcF9idWZmLiBJdCBhbGxvd3MgdG8gbWFwIHRoZSBtZW1vcnkgb25seSBvbmNlIGFuZCB0byB1
c2UNCisJCSAqIHRoZSBETUFfQklESVJFQ1RJT05BTCBtb2RlLg0KKwkJICovDQorDQorCQl4ZHBp
Lm1vZGUgPSBNTFg1RV9YRFBfWE1JVF9NT0RFX1BBR0U7DQorDQorCQlkbWFfYWRkciA9IGRpLT5h
ZGRyICsgKHhkcGYtPmRhdGEgLSAodm9pZCAqKXhkcGYpOw0KKwkJZG1hX3N5bmNfc2luZ2xlX2Zv
cl9kZXZpY2Uoc3EtPnBkZXYsIGRtYV9hZGRyLCB4ZHB0eGQubGVuLA0KKwkJCQkJICAgRE1BX1RP
X0RFVklDRSk7DQorDQorCQl4ZHB0eGQuZG1hX2FkZHIgPSBkbWFfYWRkcjsNCisJCXhkcGkucGFn
ZS5ycSAgICA9IHJxOw0KKwkJeGRwaS5wYWdlLmRpICAgID0gKmRpOw0KKwl9DQogDQogCXJldHVy
biBzcS0+eG1pdF94ZHBfZnJhbWUoc3EsICZ4ZHB0eGQsICZ4ZHBpKTsNCiB9DQpAQCAtMjk4LDEz
ICszMzIsMTMgQEAgc3RhdGljIHZvaWQgbWx4NWVfZnJlZV94ZHBzcV9kZXNjKHN0cnVjdCBtbHg1
ZV94ZHBzcSAqc3EsDQogDQogCQlzd2l0Y2ggKHhkcGkubW9kZSkgew0KIAkJY2FzZSBNTFg1RV9Y
RFBfWE1JVF9NT0RFX0ZSQU1FOg0KLQkJCS8qIFhEUF9SRURJUkVDVCAqLw0KKwkJCS8qIFhEUF9U
WCBmcm9tIHRoZSBYU0sgUlEgYW5kIFhEUF9SRURJUkVDVCAqLw0KIAkJCWRtYV91bm1hcF9zaW5n
bGUoc3EtPnBkZXYsIHhkcGkuZnJhbWUuZG1hX2FkZHIsDQogCQkJCQkgeGRwaS5mcmFtZS54ZHBm
LT5sZW4sIERNQV9UT19ERVZJQ0UpOw0KIAkJCXhkcF9yZXR1cm5fZnJhbWUoeGRwaS5mcmFtZS54
ZHBmKTsNCiAJCQlicmVhazsNCiAJCWNhc2UgTUxYNUVfWERQX1hNSVRfTU9ERV9QQUdFOg0KLQkJ
CS8qIFhEUF9UWCAqLw0KKwkJCS8qIFhEUF9UWCBmcm9tIHRoZSByZWd1bGFyIFJRICovDQogCQkJ
bWx4NWVfcGFnZV9yZWxlYXNlKHhkcGkucGFnZS5ycSwgJnhkcGkucGFnZS5kaSwgcmVjeWNsZSk7
DQogCQkJYnJlYWs7DQogCQlkZWZhdWx0Og0KLS0gDQoyLjE5LjENCg0K
