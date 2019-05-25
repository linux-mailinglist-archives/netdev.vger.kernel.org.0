Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41252A3D5
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 11:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfEYJ6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 05:58:06 -0400
Received: from mail-eopbgr820057.outbound.protection.outlook.com ([40.107.82.57]:59488
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726779AbfEYJ6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 May 2019 05:58:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idQUECT5o560OtvZO2GyBgq6P7D0hI9RkXBYj7GKVeQ=;
 b=OaJQiMiqMsFCRG3hmvG5tPTqby6sNq9q8bPu43MihKrQ8e4qYIEe48OVfcXxrIVzJD7OTZ5yU63+NGSarYJ6FWPw1J1+TTHWKp3Afg+kYKtL3ppxQwirIydNn50OoesJqeL49gfhwqy3RBpKSlsitOVgYi0LJ9I4yDPLzTG8d7I=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3017.namprd11.prod.outlook.com (20.177.218.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Sat, 25 May 2019 09:58:03 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a%5]) with mapi id 15.20.1922.021; Sat, 25 May 2019
 09:58:03 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>
Subject: [PATCH net 3/4] net: aquantia: fix LRO with FCS error
Thread-Topic: [PATCH net 3/4] net: aquantia: fix LRO with FCS error
Thread-Index: AQHVEuBXZ5bUNdId20+Lya9rtau7fA==
Date:   Sat, 25 May 2019 09:58:03 +0000
Message-ID: <dde87be8c775a4f4ed09436cdfb766b100b23bae.1558777421.git.igor.russkikh@aquantia.com>
References: <cover.1558777421.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1558777421.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P190CA0009.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:bc::19)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ea5df4a-531d-40a1-6ab0-08d6e0f77a0c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR11MB3017;
x-ms-traffictypediagnostic: DM6PR11MB3017:
x-microsoft-antispam-prvs: <DM6PR11MB3017BEB464257885E93D16D998030@DM6PR11MB3017.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0048BCF4DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(366004)(39850400004)(199004)(189003)(66946007)(71190400001)(486006)(53936002)(66476007)(2616005)(44832011)(71200400001)(66556008)(107886003)(66446008)(73956011)(64756008)(7736002)(6916009)(14454004)(11346002)(478600001)(316002)(25786009)(446003)(6436002)(72206003)(6512007)(6486002)(386003)(118296001)(36756003)(3846002)(4326008)(305945005)(52116002)(6506007)(186003)(76176011)(26005)(2906002)(99286004)(476003)(102836004)(256004)(86362001)(5660300002)(54906003)(66066001)(68736007)(81156014)(8676002)(81166006)(50226002)(8936002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3017;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aKMcf4tM1ScQPrPlo9efNXl61M5wwiBBApqNHaqiR72isSDdxCn4qFQpf5rYlqRtzniE+FejLIYbr7Aj8PpMk2yCtH0qJU23Gj76BX1YBJcNZaDaHHonTYAKkMN+lqOpb/529HznzIzg3XI9xM6E1lE9NpMlFac+kD2nNVHImyB+txJ7Drj85gJZyEqjhYCRijwVq89KSPsHlK68NxVtsHW6RdJteZdldj08mmkcm84deaRgOl5H3MILW4IaBD3bxe3QrJot8jggdqLbvJBkckoeCjvfYGqnoLG4VGR4ydJLSlR71HOUIMWTokjGDVECUGOVrZt+CDYXcvTSeKuBbCLbFoRuT08GGwoAbyaxJXQGXK7jiUIphKS89fLnZYjZuF/pf6ptFXQuqf2lfXntiVtecdbQqpztGNGmqNtqfmg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ea5df4a-531d-40a1-6ab0-08d6e0f77a0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2019 09:58:03.2919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRG1pdHJ5IEJvZ2Rhbm92IDxkbWl0cnkuYm9nZGFub3ZAYXF1YW50aWEuY29tPg0KDQpE
cml2ZXIgc3RvcHMgcHJvZHVjaW5nIHNrYnMgb24gcmluZyBpZiBhIHBhY2tldCB3aXRoIEZDUyBl
cnJvcg0Kd2FzIGNvYWxlc2NlZCBpbnRvIExSTyBzZXNzaW9uLiBSaW5nIGdldHMgaGFuZyBmb3Jl
dmVyLg0KDQpUaGF0cyBhIGxvZ2ljYWwgZXJyb3IgaW4gZHJpdmVyIHByb2Nlc3NpbmcgZGVzY3Jp
cHRvcnM6DQpXaGVuIHJ4X3N0YXQgaW5kaWNhdGVzIE1BQyBFcnJvciwgbmV4dCBwb2ludGVyIGFu
ZCBlb3AgZmxhZ3MNCmFyZSBub3QgZmlsbGVkLiBUaGlzIGNvbmZ1c2VzIGRyaXZlciBzbyBpdCB3
YWl0cyBmb3IgZGVzY3JpcHRvciAwDQp0byBiZSBmaWxsZWQgYnkgSFcuDQoNClNvbHV0aW9uIGlz
IGZpbGwgbmV4dCBwb2ludGVyIGFuZCBlb3AgZmxhZyBldmVuIGZvciBwYWNrZXRzIHdpdGggRkNT
IGVycm9yLg0KDQpGaXhlczogYmFiNmRlOGZkMTgwYiAoIm5ldDogZXRoZXJuZXQ6IGFxdWFudGlh
OiBBdGxhbnRpYyBBMCBhbmQgQjAgc3BlY2lmaWMgZnVuY3Rpb25zLiIpDQpTaWduZWQtb2ZmLWJ5
OiBJZ29yIFJ1c3NraWtoIDxpZ29yLnJ1c3NraWtoQGFxdWFudGlhLmNvbT4NClNpZ25lZC1vZmYt
Ynk6IERtaXRyeSBCb2dkYW5vdiA8ZG1pdHJ5LmJvZ2Rhbm92QGFxdWFudGlhLmNvbT4NCi0tLQ0K
IC4uLi9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX2IwLmMgICAgICB8IDYxICsrKysr
KysrKystLS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMzIgaW5zZXJ0aW9ucygrKSwgMjkgZGVs
ZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9h
dGxhbnRpYy9od19hdGwvaHdfYXRsX2IwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRp
YS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX2IwLmMNCmluZGV4IGJmY2RhMTJkNzNkZS4uZTk3OWYy
MjdjZjBiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50
aWMvaHdfYXRsL2h3X2F0bF9iMC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRp
YS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX2IwLmMNCkBAIC03MTMsMzggKzcxMyw0MSBAQCBzdGF0
aWMgaW50IGh3X2F0bF9iMF9od19yaW5nX3J4X3JlY2VpdmUoc3RydWN0IGFxX2h3X3MgKnNlbGYs
DQogCQlpZiAoKHJ4X3N0YXQgJiBCSVQoMCkpIHx8IHJ4ZF93Yi0+dHlwZSAmIDB4MTAwMFUpIHsN
CiAJCQkvKiBNQUMgZXJyb3Igb3IgRE1BIGVycm9yICovDQogCQkJYnVmZi0+aXNfZXJyb3IgPSAx
VTsNCi0JCX0gZWxzZSB7DQotCQkJaWYgKHNlbGYtPmFxX25pY19jZmctPmlzX3Jzcykgew0KLQkJ
CQkvKiBsYXN0IDQgYnl0ZSAqLw0KLQkJCQl1MTYgcnNzX3R5cGUgPSByeGRfd2ItPnR5cGUgJiAw
eEZVOw0KLQ0KLQkJCQlpZiAocnNzX3R5cGUgJiYgcnNzX3R5cGUgPCAweDhVKSB7DQotCQkJCQli
dWZmLT5pc19oYXNoX2w0ID0gKHJzc190eXBlID09IDB4NCB8fA0KLQkJCQkJcnNzX3R5cGUgPT0g
MHg1KTsNCi0JCQkJCWJ1ZmYtPnJzc19oYXNoID0gcnhkX3diLT5yc3NfaGFzaDsNCi0JCQkJfQ0K
KwkJfQ0KKwkJaWYgKHNlbGYtPmFxX25pY19jZmctPmlzX3Jzcykgew0KKwkJCS8qIGxhc3QgNCBi
eXRlICovDQorCQkJdTE2IHJzc190eXBlID0gcnhkX3diLT50eXBlICYgMHhGVTsNCisNCisJCQlp
ZiAocnNzX3R5cGUgJiYgcnNzX3R5cGUgPCAweDhVKSB7DQorCQkJCWJ1ZmYtPmlzX2hhc2hfbDQg
PSAocnNzX3R5cGUgPT0gMHg0IHx8DQorCQkJCXJzc190eXBlID09IDB4NSk7DQorCQkJCWJ1ZmYt
PnJzc19oYXNoID0gcnhkX3diLT5yc3NfaGFzaDsNCiAJCQl9DQorCQl9DQogDQotCQkJaWYgKEhX
X0FUTF9CMF9SWERfV0JfU1RBVDJfRU9QICYgcnhkX3diLT5zdGF0dXMpIHsNCi0JCQkJYnVmZi0+
bGVuID0gcnhkX3diLT5wa3RfbGVuICUNCi0JCQkJCUFRX0NGR19SWF9GUkFNRV9NQVg7DQotCQkJ
CWJ1ZmYtPmxlbiA9IGJ1ZmYtPmxlbiA/DQotCQkJCQlidWZmLT5sZW4gOiBBUV9DRkdfUlhfRlJB
TUVfTUFYOw0KLQkJCQlidWZmLT5uZXh0ID0gMFU7DQotCQkJCWJ1ZmYtPmlzX2VvcCA9IDFVOw0K
KwkJaWYgKEhXX0FUTF9CMF9SWERfV0JfU1RBVDJfRU9QICYgcnhkX3diLT5zdGF0dXMpIHsNCisJ
CQlidWZmLT5sZW4gPSByeGRfd2ItPnBrdF9sZW4gJQ0KKwkJCQlBUV9DRkdfUlhfRlJBTUVfTUFY
Ow0KKwkJCWJ1ZmYtPmxlbiA9IGJ1ZmYtPmxlbiA/DQorCQkJCWJ1ZmYtPmxlbiA6IEFRX0NGR19S
WF9GUkFNRV9NQVg7DQorCQkJYnVmZi0+bmV4dCA9IDBVOw0KKwkJCWJ1ZmYtPmlzX2VvcCA9IDFV
Ow0KKwkJfSBlbHNlIHsNCisJCQlidWZmLT5sZW4gPQ0KKwkJCQlyeGRfd2ItPnBrdF9sZW4gPiBB
UV9DRkdfUlhfRlJBTUVfTUFYID8NCisJCQkJQVFfQ0ZHX1JYX0ZSQU1FX01BWCA6IHJ4ZF93Yi0+
cGt0X2xlbjsNCisNCisJCQlpZiAoSFdfQVRMX0IwX1JYRF9XQl9TVEFUMl9SU0NDTlQgJg0KKwkJ
CQlyeGRfd2ItPnN0YXR1cykgew0KKwkJCQkvKiBMUk8gKi8NCisJCQkJYnVmZi0+bmV4dCA9IHJ4
ZF93Yi0+bmV4dF9kZXNjX3B0cjsNCisJCQkJKytyaW5nLT5zdGF0cy5yeC5scm9fcGFja2V0czsN
CiAJCQl9IGVsc2Ugew0KLQkJCQlpZiAoSFdfQVRMX0IwX1JYRF9XQl9TVEFUMl9SU0NDTlQgJg0K
LQkJCQkJcnhkX3diLT5zdGF0dXMpIHsNCi0JCQkJCS8qIExSTyAqLw0KLQkJCQkJYnVmZi0+bmV4
dCA9IHJ4ZF93Yi0+bmV4dF9kZXNjX3B0cjsNCi0JCQkJCSsrcmluZy0+c3RhdHMucngubHJvX3Bh
Y2tldHM7DQotCQkJCX0gZWxzZSB7DQotCQkJCQkvKiBqdW1ibyAqLw0KLQkJCQkJYnVmZi0+bmV4
dCA9DQotCQkJCQkJYXFfcmluZ19uZXh0X2R4KHJpbmcsDQotCQkJCQkJCQlyaW5nLT5od19oZWFk
KTsNCi0JCQkJCSsrcmluZy0+c3RhdHMucnguanVtYm9fcGFja2V0czsNCi0JCQkJfQ0KKwkJCQkv
KiBqdW1ibyAqLw0KKwkJCQlidWZmLT5uZXh0ID0NCisJCQkJCWFxX3JpbmdfbmV4dF9keChyaW5n
LA0KKwkJCQkJCQlyaW5nLT5od19oZWFkKTsNCisJCQkJKytyaW5nLT5zdGF0cy5yeC5qdW1ib19w
YWNrZXRzOw0KIAkJCX0NCiAJCX0NCiAJfQ0KLS0gDQoyLjE3LjENCg0K
