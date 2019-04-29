Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D319E032
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfD2KFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:05:23 -0400
Received: from mail-eopbgr810055.outbound.protection.outlook.com ([40.107.81.55]:40164
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727960AbfD2KFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:05:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7X3XSCDrI2zSgUk8rpc17RZSvhCwcWtzm/HYLoO74JI=;
 b=Rt4yoFne1kSTFpBFsSCLHiVLdZ+bWMhozTF3+xFgIsLioN59taQG2O6/Mp+ywGxAbW7LGmTa8P5L+Szr7oJ37PrrkabmM6oVCDZq6l1GOu2eTHOBCaTuSE3CWgH6cj07Sa8G84kOd3RnIC6obzS0N3xkmbo4jWjSfAeuazP8K00=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3644.namprd11.prod.outlook.com (20.178.230.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 10:04:50 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653%3]) with mapi id 15.20.1835.010; Mon, 29 Apr 2019
 10:04:50 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v4 net-next 07/15] net: aquantia: improve ifup link detection
Thread-Topic: [PATCH v4 net-next 07/15] net: aquantia: improve ifup link
 detection
Thread-Index: AQHU/nL7zfgTnQQt7EGGNvGrV2rn2A==
Date:   Mon, 29 Apr 2019 10:04:50 +0000
Message-ID: <ae62eaeb325fee0990af04aee285fa26d57bef63.1556531633.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: 8fd97874-ef7b-454c-9676-08d6cc8a1e01
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3644;
x-ms-traffictypediagnostic: DM6PR11MB3644:
x-microsoft-antispam-prvs: <DM6PR11MB3644BC7CA4D308D0462DB60C98390@DM6PR11MB3644.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:475;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(376002)(396003)(39840400004)(189003)(199004)(6512007)(2906002)(5660300002)(71200400001)(6486002)(99286004)(53936002)(26005)(25786009)(44832011)(71190400001)(14454004)(50226002)(4326008)(3846002)(66556008)(64756008)(66446008)(36756003)(8936002)(73956011)(72206003)(66946007)(54906003)(66476007)(7736002)(6116002)(6436002)(81166006)(86362001)(6506007)(478600001)(81156014)(8676002)(97736004)(305945005)(107886003)(386003)(316002)(118296001)(68736007)(102836004)(6916009)(76176011)(476003)(186003)(2616005)(486006)(4744005)(256004)(11346002)(52116002)(446003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3644;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +Tp9TEvjSAnmn8wW9EhGclD06xNHt4copoIwCdo6RwmJW98P5DeheqRRu7f8R/xvp/p4NHulggDc/LmV04OFK2lgfrFCK3OSodNY/Gn5r09nMg6gPCthFK0pcHugNXxTk2GjXOHWpxQdB6g3e27SP/7sPA6D0O1UB7oHiwjJdSTawNWJxEjeVYj4/BmoKQi1/Dy1d9g9T/C/mft+aG35iDMY9kCCIi7W+G07TQ7/hUgMuzMn8gyeZXHCGaSBsFIGClFxBhzhtKebMYYpPauVdSpLwNh9O7rYUCXq1Ux+t0INKwbTvuJi+9SvpVvEmGV5LgTCiLqKgbujvvn67B6k5XIXA94p9oXDdV8eNxBKiqNgz+dujGNYeAyduAWDJQmqSvoZGN0hBZY97Gj/hO/lGfkAo3WZAAV7Y2LO7bsrqRg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd97874-ef7b-454c-9676-08d6cc8a1e01
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 10:04:50.5250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3644
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T3JpZ2luYWwgY29kZSBkZXRlY3RlZCBsaW5rIG9ubHkgYWZ0ZXIgMSBzZWMgaXMgcGFzc2VkIGFm
dGVyIHVwLg0KSGVyZSB3ZSByZXBsYWNlIHRoaXMgd2l0aCBkaXJlY3Qgc2VydmljZSBjYWxsYmFj
ayB3aGljaCB1cGRhdGVzDQpsaW5rIHN0YXR1cyBpbW1lZGlhdGVseQ0KDQpTaWduZWQtb2ZmLWJ5
OiBJZ29yIFJ1c3NraWtoIDxpZ29yLnJ1c3NraWtoQGFxdWFudGlhLmNvbT4NCi0tLQ0KIGRyaXZl
cnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX25pYy5jIHwgMyArLS0NCiAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9uaWMuYyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX25pYy5jDQppbmRleCAwMjUxNTY2
YjY2YWYuLjZkZTBkMWMwZWQ3OSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Fx
dWFudGlhL2F0bGFudGljL2FxX25pYy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVh
bnRpYS9hdGxhbnRpYy9hcV9uaWMuYw0KQEAgLTM1NSw4ICszNTUsNyBAQCBpbnQgYXFfbmljX3N0
YXJ0KHN0cnVjdCBhcV9uaWNfcyAqc2VsZikNCiAJaWYgKGVycikNCiAJCWdvdG8gZXJyX2V4aXQ7
DQogCXRpbWVyX3NldHVwKCZzZWxmLT5zZXJ2aWNlX3RpbWVyLCBhcV9uaWNfc2VydmljZV90aW1l
cl9jYiwgMCk7DQotCW1vZF90aW1lcigmc2VsZi0+c2VydmljZV90aW1lciwgamlmZmllcyArDQot
CQkgIEFRX0NGR19TRVJWSUNFX1RJTUVSX0lOVEVSVkFMKTsNCisJYXFfbmljX3NlcnZpY2VfdGlt
ZXJfY2IoJnNlbGYtPnNlcnZpY2VfdGltZXIpOw0KIA0KIAlpZiAoc2VsZi0+YXFfbmljX2NmZy5p
c19wb2xsaW5nKSB7DQogCQl0aW1lcl9zZXR1cCgmc2VsZi0+cG9sbGluZ190aW1lciwgYXFfbmlj
X3BvbGxpbmdfdGltZXJfY2IsIDApOw0KLS0gDQoyLjE3LjENCg0K
