Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E6F33264
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbfFCOmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:42:43 -0400
Received: from mail-eopbgr30100.outbound.protection.outlook.com ([40.107.3.100]:11233
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729230AbfFCOmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 10:42:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iOVZxr83Aqc5fdKSBUjXiAeW83zREDQFRFtVolwCnM=;
 b=X+1U+E5Xf/6Vu7cav1f7a76S30DwpT/OqgnScr3e/AYl3hG72ZOMCz0072+sSQyAA+B+dUFtPlnEL2JEZJnpP5DnkcDX7Owd6WTdoJlmKI/2OL1v2/LN+uPB4EvfjAwLNRfigZA5J97WqN/JF4+/HPTGEfg8YGG04N8l2VNmW6Q=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM (20.178.125.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 14:42:25 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 14:42:24 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 10/10] net: dsa: mv88e6xxx: refactor
 mv88e6352_g1_reset
Thread-Topic: [PATCH net-next v3 10/10] net: dsa: mv88e6xxx: refactor
 mv88e6352_g1_reset
Thread-Index: AQHVGhqPCBmyyOE7GkiNIOy6JKfF/w==
Date:   Mon, 3 Jun 2019 14:42:24 +0000
Message-ID: <20190603144112.27713-11-rasmus.villemoes@prevas.dk>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0701CA0070.eurprd07.prod.outlook.com
 (2603:10a6:3:64::14) To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3bfc51ce-f9b1-4a7d-6d5c-08d6e831b14f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB2574;
x-ms-traffictypediagnostic: VI1PR10MB2574:
x-microsoft-antispam-prvs: <VI1PR10MB2574DC402B20E7A8A1347E4D8A140@VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(346002)(376002)(396003)(136003)(189003)(199004)(42882007)(50226002)(446003)(476003)(73956011)(66556008)(64756008)(66446008)(66476007)(81156014)(11346002)(256004)(8976002)(53936002)(72206003)(66946007)(316002)(14454004)(99286004)(8676002)(81166006)(8936002)(71190400001)(110136005)(71200400001)(102836004)(2616005)(4326008)(54906003)(25786009)(386003)(7736002)(52116002)(6506007)(26005)(486006)(2906002)(66066001)(36756003)(186003)(6512007)(68736007)(1076003)(74482002)(305945005)(76176011)(478600001)(3846002)(5660300002)(6436002)(6116002)(44832011)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2574;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gJr2L19EE73wNIcyM6X/flMZ8aj4NXl9zU0v6k199MzZXQ4bwi5AiD0klTlfzAzmTcJ7uwrPdhrLb1fIMh+rjZhbu0zICeiCGnAWg1y+MJSGMZ41ReJy5PrNgiMrTaa9t4yr36pX6zkBPwe4uZqZOCVj8rqscy8S9IwugnK3WsqQIajFEvSrLNBNuvQUgQPtD0w6Qip4OW4p8UV56Sev4ht4oGBtlJaYaUumVhBY96Vl0tgf4F3ujzQkfXN9qMg+LJH/fIvc0KZX8Mu8dk6dMzruj3BAGOEjafTerizenU2UKeSEE39z+seEQ+HnDqwvkgKVjEKCs7iZRR1C7aox541yNwGWkBreMp9P2CHwI5BWWHPJY/z0GQqB0WNJcyjnjmvf6QC7zSKq5c7J7e+r3vDibrmLv7Hrq6+VHlBDj+w=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bfc51ce-f9b1-4a7d-6d5c-08d6e831b14f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 14:42:24.8206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2574
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIG5ldyBtdjg4ZTYyNTBfZzFfcmVzZXQoKSBpcyBpZGVudGljYWwgdG8gbXY4OGU2MzUyX2cx
X3Jlc2V0KCkgZXhjZXB0DQpmb3IgdGhlIGNhbGwgb2YgbXY4OGU2MzUyX2cxX3dhaXRfcHB1X3Bv
bGxpbmcoKSwgc28gcmVmYWN0b3IgdGhlIDYzNTINCnZlcnNpb24gaW4gdGVybSBvZiB0aGUgNjI1
MCBvbmUuIE5vIGZ1bmN0aW9uYWwgY2hhbmdlLg0KDQpTaWduZWQtb2ZmLWJ5OiBSYXNtdXMgVmls
bGVtb2VzIDxyYXNtdXMudmlsbGVtb2VzQHByZXZhcy5kaz4NCi0tLQ0KIGRyaXZlcnMvbmV0L2Rz
YS9tdjg4ZTZ4eHgvZ2xvYmFsMS5jIHwgMTQgKy0tLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDEzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmMgYi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4
L2dsb2JhbDEuYw0KaW5kZXggZmMxMGI2ZTQ5NWY1Li40MWMwNzkyYTJlMmIgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDEuYw0KKysrIGIvZHJpdmVycy9uZXQv
ZHNhL212ODhlNnh4eC9nbG9iYWwxLmMNCkBAIC0yMDMsMjEgKzIwMyw5IEBAIGludCBtdjg4ZTYy
NTBfZzFfcmVzZXQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwKQ0KIA0KIGludCBtdjg4ZTYz
NTJfZzFfcmVzZXQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwKQ0KIHsNCi0JdTE2IHZhbDsN
CiAJaW50IGVycjsNCiANCi0JLyogU2V0IHRoZSBTV1Jlc2V0IGJpdCAxNSAqLw0KLQllcnIgPSBt
djg4ZTZ4eHhfZzFfcmVhZChjaGlwLCBNVjg4RTZYWFhfRzFfQ1RMMSwgJnZhbCk7DQotCWlmIChl
cnIpDQotCQlyZXR1cm4gZXJyOw0KLQ0KLQl2YWwgfD0gTVY4OEU2WFhYX0cxX0NUTDFfU1dfUkVT
RVQ7DQotDQotCWVyciA9IG12ODhlNnh4eF9nMV93cml0ZShjaGlwLCBNVjg4RTZYWFhfRzFfQ1RM
MSwgdmFsKTsNCi0JaWYgKGVycikNCi0JCXJldHVybiBlcnI7DQotDQotCWVyciA9IG12ODhlNnh4
eF9nMV93YWl0X2luaXRfcmVhZHkoY2hpcCk7DQorCWVyciA9IG12ODhlNjI1MF9nMV9yZXNldChj
aGlwKTsNCiAJaWYgKGVycikNCiAJCXJldHVybiBlcnI7DQogDQotLSANCjIuMjAuMQ0KDQo=
