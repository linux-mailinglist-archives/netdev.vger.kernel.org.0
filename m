Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082C3E036
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfD2KF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:05:29 -0400
Received: from mail-eopbgr810055.outbound.protection.outlook.com ([40.107.81.55]:40164
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727608AbfD2KF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:05:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fslB5WAPdekkjRMO3Bt4TzfjDhFEhwh45ozH34KVE58=;
 b=hamW31BzQUroQ99FrqrTLMvW+A8RVyDBxKuuJ6iTyXScoYb5W32NmFtsGuDqXjvcRxUbvF2FIvvEFS/cQ2gzd+H1sZvAWtHPOAYAbjc2KjG9Ud+zwvPpsJm1CTGr83W+SISCMf6JmhY+RU9xZ0Mv0psawts98xcgNAOLChy1XA0=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3644.namprd11.prod.outlook.com (20.178.230.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 10:05:00 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653%3]) with mapi id 15.20.1835.010; Mon, 29 Apr 2019
 10:05:00 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: [PATCH v4 net-next 11/15] net: aquantia: extract timer cb into work
 job
Thread-Topic: [PATCH v4 net-next 11/15] net: aquantia: extract timer cb into
 work job
Thread-Index: AQHU/nMBTK0H+3I6jUyJ6CE5xMVjqg==
Date:   Mon, 29 Apr 2019 10:05:00 +0000
Message-ID: <615c553b41c4af15ed9c99a9ef27afea444ac6b9.1556531633.git.igor.russkikh@aquantia.com>
References: <cover.1556531633.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1556531633.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0189.eurprd05.prod.outlook.com
 (2603:10a6:3:f9::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b367d62-16be-4d50-3f5b-08d6cc8a23e2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3644;
x-ms-traffictypediagnostic: DM6PR11MB3644:
x-microsoft-antispam-prvs: <DM6PR11MB3644289462558D4528074C0D98390@DM6PR11MB3644.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:398;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(376002)(396003)(39840400004)(189003)(199004)(6512007)(2906002)(5660300002)(71200400001)(6486002)(99286004)(53936002)(26005)(25786009)(44832011)(71190400001)(14454004)(50226002)(4326008)(3846002)(66556008)(64756008)(66446008)(36756003)(8936002)(73956011)(72206003)(66946007)(54906003)(66476007)(7736002)(6116002)(6436002)(81166006)(86362001)(6506007)(478600001)(81156014)(8676002)(97736004)(305945005)(107886003)(386003)(316002)(118296001)(68736007)(102836004)(6916009)(76176011)(476003)(186003)(2616005)(486006)(256004)(11346002)(52116002)(446003)(66066001)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3644;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CFjrrQYy+iVHbAEY/PCtrrZRMNV+V69NZ/eZ3e6wxpV8/ftiSfbPdSM5LSAWrTVcquMG6+Uz//Cx5ExD8NJHsAm/YcwF/Uz9j2nvD39kLNrvrxGS1qpNI8A1rU9LXgu1GAuGxFlDkVoQUUKpM5A0e8kBIOE781YadeA+XiaXXhZ80gwkGco+ZLagV2yLc0zKY6BrTaT0xVUlR2a8JlsRnJpl5Gcnj6MFSa9z645OBv8XZyImBUQGhBmg0lnNGI2gl7+KLvU6x42qyxQHUxi6LP20xytSyeVlWoPuwPA1moqgfUptATg4ZFB101rmTHmGqSSNpPkv7j3vLUcZ3ipNSjHsDwz2LIEz627275f4jGxPDNS1FIhjbIrPTcAInUU/a9VqnXG9szyEDxDE8Dog9zQMW6W+gjUdUG1h1nX5Y+c=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b367d62-16be-4d50-3f5b-08d6cc8a23e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 10:05:00.3219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3644
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2VydmljZSB0aW1lciBjYWxsYmFjayBmZXRjaGVzIHN0YXRpc3RpY3MgZnJvbSBGVyBhbmQgdGhh
dCBtYXkgY2F1c2UNCmEgbG9uZyBkZWxheSBpbiBlcnJvciBjYXNlcy4gV2UgYWxzbyBub3cgbmVl
ZCB0byB1c2UgZncgbXV0ZXgNCnRvIHByZXZlbnQgY29uY3VycmVudCBhY2Nlc3MgdG8gRlcsIHRo
dXMgLSBleHRyYWN0IHRoYXQgbG9naWMNCmZyb20gdGltZXIgY2FsbGJhY2sgaW50byB0aGUgam9i
IGluIHRoZSBzZXBhcmF0ZSB3b3JrIHF1ZXVlLg0KDQpTaWduZWQtb2ZmLWJ5OiBOaWtpdGEgRGFu
aWxvdiA8bmRhbmlsb3ZAYXF1YW50aWEuY29tPg0KU2lnbmVkLW9mZi1ieTogSWdvciBSdXNza2lr
aCA8aWdvci5ydXNza2lraEBhcXVhbnRpYS5jb20+DQotLS0NCiAuLi4vbmV0L2V0aGVybmV0L2Fx
dWFudGlhL2F0bGFudGljL2FxX25pYy5jICAgfCAyNSArKysrKysrKysrKysrKy0tLS0tDQogLi4u
L25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9uaWMuaCAgIHwgIDEgKw0KIDIgZmls
ZXMgY2hhbmdlZCwgMjAgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX25pYy5jIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbmljLmMNCmluZGV4IGIwMzhl
MmU5YWYzYS4uNDU0YTQ0YmIxNDhlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
YXF1YW50aWEvYXRsYW50aWMvYXFfbmljLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Fx
dWFudGlhL2F0bGFudGljL2FxX25pYy5jDQpAQCAtMTg2LDI1ICsxODYsMzQgQEAgc3RhdGljIGly
cXJldHVybl90IGFxX2xpbmtzdGF0ZV90aHJlYWRlZF9pc3IoaW50IGlycSwgdm9pZCAqcHJpdmF0
ZSkNCiAJcmV0dXJuIElSUV9IQU5ETEVEOw0KIH0NCiANCi1zdGF0aWMgdm9pZCBhcV9uaWNfc2Vy
dmljZV90aW1lcl9jYihzdHJ1Y3QgdGltZXJfbGlzdCAqdCkNCitzdGF0aWMgdm9pZCBhcV9uaWNf
c2VydmljZV90YXNrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiB7DQotCXN0cnVjdCBhcV9u
aWNfcyAqc2VsZiA9IGZyb21fdGltZXIoc2VsZiwgdCwgc2VydmljZV90aW1lcik7DQotCWludCBl
cnIgPSAwOw0KKwlzdHJ1Y3QgYXFfbmljX3MgKnNlbGYgPSBjb250YWluZXJfb2Yod29yaywgc3Ry
dWN0IGFxX25pY19zLA0KKwkJCQkJICAgICBzZXJ2aWNlX3Rhc2spOw0KKwlpbnQgZXJyOw0KIA0K
IAlpZiAoYXFfdXRpbHNfb2JqX3Rlc3QoJnNlbGYtPmZsYWdzLCBBUV9OSUNfRkxBR1NfSVNfTk9U
X1JFQURZKSkNCi0JCWdvdG8gZXJyX2V4aXQ7DQorCQlyZXR1cm47DQogDQogCWVyciA9IGFxX25p
Y191cGRhdGVfbGlua19zdGF0dXMoc2VsZik7DQogCWlmIChlcnIpDQotCQlnb3RvIGVycl9leGl0
Ow0KKwkJcmV0dXJuOw0KIA0KKwltdXRleF9sb2NrKCZzZWxmLT5md3JlcV9tdXRleCk7DQogCWlm
IChzZWxmLT5hcV9md19vcHMtPnVwZGF0ZV9zdGF0cykNCiAJCXNlbGYtPmFxX2Z3X29wcy0+dXBk
YXRlX3N0YXRzKHNlbGYtPmFxX2h3KTsNCisJbXV0ZXhfdW5sb2NrKCZzZWxmLT5md3JlcV9tdXRl
eCk7DQogDQogCWFxX25pY191cGRhdGVfbmRldl9zdGF0cyhzZWxmKTsNCit9DQorDQorc3RhdGlj
IHZvaWQgYXFfbmljX3NlcnZpY2VfdGltZXJfY2Ioc3RydWN0IHRpbWVyX2xpc3QgKnQpDQorew0K
KwlzdHJ1Y3QgYXFfbmljX3MgKnNlbGYgPSBmcm9tX3RpbWVyKHNlbGYsIHQsIHNlcnZpY2VfdGlt
ZXIpOw0KIA0KLWVycl9leGl0Og0KIAltb2RfdGltZXIoJnNlbGYtPnNlcnZpY2VfdGltZXIsIGpp
ZmZpZXMgKyBBUV9DRkdfU0VSVklDRV9USU1FUl9JTlRFUlZBTCk7DQorDQorCWFxX25kZXZfc2No
ZWR1bGVfd29yaygmc2VsZi0+c2VydmljZV90YXNrKTsNCiB9DQogDQogc3RhdGljIHZvaWQgYXFf
bmljX3BvbGxpbmdfdGltZXJfY2Ioc3RydWN0IHRpbWVyX2xpc3QgKnQpDQpAQCAtMzU4LDYgKzM2
Nyw5IEBAIGludCBhcV9uaWNfc3RhcnQoc3RydWN0IGFxX25pY19zICpzZWxmKQ0KIAllcnIgPSBh
cV9uaWNfdXBkYXRlX2ludGVycnVwdF9tb2RlcmF0aW9uX3NldHRpbmdzKHNlbGYpOw0KIAlpZiAo
ZXJyKQ0KIAkJZ290byBlcnJfZXhpdDsNCisNCisJSU5JVF9XT1JLKCZzZWxmLT5zZXJ2aWNlX3Rh
c2ssIGFxX25pY19zZXJ2aWNlX3Rhc2spOw0KKw0KIAl0aW1lcl9zZXR1cCgmc2VsZi0+c2Vydmlj
ZV90aW1lciwgYXFfbmljX3NlcnZpY2VfdGltZXJfY2IsIDApOw0KIAlhcV9uaWNfc2VydmljZV90
aW1lcl9jYigmc2VsZi0+c2VydmljZV90aW1lcik7DQogDQpAQCAtOTEwLDYgKzkyMiw3IEBAIGlu
dCBhcV9uaWNfc3RvcChzdHJ1Y3QgYXFfbmljX3MgKnNlbGYpDQogCW5ldGlmX2NhcnJpZXJfb2Zm
KHNlbGYtPm5kZXYpOw0KIA0KIAlkZWxfdGltZXJfc3luYygmc2VsZi0+c2VydmljZV90aW1lcik7
DQorCWNhbmNlbF93b3JrX3N5bmMoJnNlbGYtPnNlcnZpY2VfdGFzayk7DQogDQogCXNlbGYtPmFx
X2h3X29wcy0+aHdfaXJxX2Rpc2FibGUoc2VsZi0+YXFfaHcsIEFRX0NGR19JUlFfTUFTSyk7DQog
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFf
bmljLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9uaWMuaA0K
aW5kZXggYmU1NmFjZTYyNzRiLi5jMDNkMzhlZDEwNWQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9uaWMuaA0KKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbmljLmgNCkBAIC05Myw2ICs5Myw3IEBAIHN0
cnVjdCBhcV9uaWNfcyB7DQogCWNvbnN0IHN0cnVjdCBhcV9md19vcHMgKmFxX2Z3X29wczsNCiAJ
c3RydWN0IGFxX25pY19jZmdfcyBhcV9uaWNfY2ZnOw0KIAlzdHJ1Y3QgdGltZXJfbGlzdCBzZXJ2
aWNlX3RpbWVyOw0KKwlzdHJ1Y3Qgd29ya19zdHJ1Y3Qgc2VydmljZV90YXNrOw0KIAlzdHJ1Y3Qg
dGltZXJfbGlzdCBwb2xsaW5nX3RpbWVyOw0KIAlzdHJ1Y3QgYXFfaHdfbGlua19zdGF0dXNfcyBs
aW5rX3N0YXR1czsNCiAJc3RydWN0IHsNCi0tIA0KMi4xNy4xDQoNCg==
