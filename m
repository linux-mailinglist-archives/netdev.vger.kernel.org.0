Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF37C294C3
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390220AbfEXJfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:35:41 -0400
Received: from mail-eopbgr50069.outbound.protection.outlook.com ([40.107.5.69]:42462
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390164AbfEXJfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHjfPZYWf8YCHEMhQ//r4APPkgy8jPN+XH9M3DKK8HQ=;
 b=l23L7gGmldIxcpS7Vb/TVnDWlfzm/GIUA6AAq/Hekq9MIoUQGymRve1NKwgFUTArQ3ey3txPik7/HcmavpWR6cSWAoxVUW00LbgTdenQOLLubJNinGCRaLnDy9qcJaHQO4XKImf+ecFJOqPlXqo7tn3hhFeCSfUxJ1KSGUjmV/4=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.196.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Fri, 24 May 2019 09:35:35 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2%7]) with mapi id 15.20.1922.019; Fri, 24 May 2019
 09:35:35 +0000
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
Subject: [PATCH bpf-next v3 12/16] net/mlx5e: XDP_TX from UMEM support
Thread-Topic: [PATCH bpf-next v3 12/16] net/mlx5e: XDP_TX from UMEM support
Thread-Index: AQHVEhQJkn4VsTBTDkKx1V0P5+2ozQ==
Date:   Fri, 24 May 2019 09:35:35 +0000
Message-ID: <20190524093431.20887-13-maximmi@mellanox.com>
References: <20190524093431.20887-1-maximmi@mellanox.com>
In-Reply-To: <20190524093431.20887-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0126.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::18) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fac57b23-ac5a-4828-93e1-08d6e02b2c22
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5142;
x-ms-traffictypediagnostic: AM6PR05MB5142:
x-microsoft-antispam-prvs: <AM6PR05MB5142758CFD0F7124EF7547E1D1020@AM6PR05MB5142.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(136003)(376002)(366004)(39860400002)(199004)(189003)(76176011)(99286004)(52116002)(14454004)(256004)(66446008)(64756008)(66556008)(66476007)(7736002)(305945005)(73956011)(110136005)(54906003)(66946007)(7416002)(386003)(6506007)(68736007)(86362001)(2906002)(66066001)(316002)(26005)(3846002)(6116002)(186003)(102836004)(107886003)(6436002)(478600001)(81156014)(36756003)(50226002)(8936002)(6486002)(1076003)(5660300002)(6512007)(71200400001)(71190400001)(25786009)(8676002)(81166006)(53936002)(476003)(446003)(486006)(11346002)(4326008)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5142;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LM7YxwRH9gA8iPF1W76j2DwrHd6Wh9NNxjwi/N5ya5O53CFaKLZ7pUMTdi3PbfW9WZwx5yl+/6hkzlnsVTJiVsyP7RbUrXRDXhexihH209z8sv3JXpi0WFmmSmmHtY59lpbos9JNyr3MWEO1TvGAQuV57C9JguY3facZ91jtgvuRJiE50lPuyA9D5RN2qdgxe9fV9qEdN7LDG54G8TRrK7djXipF1s2GlXIuhz0aUcGNjZfJwThsHMDc2gx9+74HqF0m1+8ORVqZKd68hnj/BWNNoXgiEMNZjriAaJpyQIq0G4QN6bgThSMOgnskX3eoe0sImKKQHQFL8d9NCta2K308n+Kop4eysNa8LNRSLc66hYKJnurBnfaQ4BO4SEgfGAyOtHQC3laRVtLItEH6OFIebao9+JRbFAml24+kmDM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fac57b23-ac5a-4828-93e1-08d6e02b2c22
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:35:35.0991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5142
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
