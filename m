Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E21C2D5DF
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 09:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfE2HCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 03:02:16 -0400
Received: from mail-eopbgr80132.outbound.protection.outlook.com ([40.107.8.132]:46729
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbfE2HCQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 03:02:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDqI4gw6TsCCPEHj55g0+Qph0f44D3m90I0w3jUmyeY=;
 b=Da5akzEid+qHUJyqMD6RNjsJBK46VaGmqVxqg4eTiYgIqjE2v5c3q5CwiNh7cQkjBAVvzEBY47VAtl9UrZDzK8nPgjaEoozgn2Z8AP7ffZjwuLZWDIpcjU1a4zTf+GabMn7+gUBWumnDpdVyAyCfasYY5g0d5DtDxXRkIVnxcoo=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2384.EURPRD10.PROD.OUTLOOK.COM (20.177.62.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 07:02:11 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 07:02:11 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2] net: dsa: mv88e6xxx: fix handling of upper half of
 STATS_TYPE_PORT
Thread-Topic: [PATCH net v2] net: dsa: mv88e6xxx: fix handling of upper half
 of STATS_TYPE_PORT
Thread-Index: AQHVFexwewLvjBXjCUSJ0awhE0fnMQ==
Date:   Wed, 29 May 2019 07:02:11 +0000
Message-ID: <20190529070158.7040-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0211.eurprd05.prod.outlook.com
 (2603:10a6:3:fa::11) To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 228cee14-80f4-4111-5f91-08d6e4039273
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB2384;
x-ms-traffictypediagnostic: VI1PR10MB2384:
x-microsoft-antispam-prvs: <VI1PR10MB23849E0C0936E46E18B06CC88A1F0@VI1PR10MB2384.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39850400004)(396003)(366004)(136003)(376002)(189003)(199004)(66946007)(4744005)(66556008)(72206003)(64756008)(66446008)(2906002)(6486002)(66476007)(81156014)(186003)(8676002)(71200400001)(8976002)(478600001)(5660300002)(66066001)(71190400001)(6436002)(81166006)(53936002)(26005)(50226002)(54906003)(14454004)(44832011)(99286004)(36756003)(316002)(486006)(1076003)(74482002)(42882007)(7736002)(305945005)(14444005)(4326008)(2616005)(3846002)(6116002)(110136005)(52116002)(6512007)(256004)(25786009)(68736007)(73956011)(102836004)(8936002)(6506007)(386003)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2384;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: o3iAtRBr3sfWvoeY2+AGLIZqC2hTk+Rb5wtvhgafsG6SJLx3diB+f0sfn2AiTdTdLr9a2LTXbrAMHVoKhw0YkmqtHe3TAIcxFshSkT+lxfza74Oqb4t903YNJ1MZLCvSkQFOjncU5vPPeGtxnFVioYxcEfgxl9EwnMQXigDNm/t1K0xI+/TGj8xKKTCIS0aEIt6c72iASqZ5MKb0kA7MQmcz5ERtl7IBHQf2Ccy2re1Kb8PE7wpUJNZLh6k8sJbBTNcpKz75jA6EYeIE8enjWSmx5T+49m2IPiX0X+7i+KGuDMDJ8HWFwlRJqjnmSFMOXtRybFlw7gPFBh/Z+6sWH/ApljvfgWpLs0EPTz0yzdeoTpCpi0AnwaTkbBB0raTfT1dXoUPYH0qanlU2knnEJawA3+BzBkAGB4KSZY+zJDI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 228cee14-80f4-4111-5f91-08d6e4039273
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 07:02:11.5821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2384
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q3VycmVudGx5LCB0aGUgdXBwZXIgaGFsZiBvZiBhIDQtYnl0ZSBTVEFUU19UWVBFX1BPUlQgc3Rh
dGlzdGljIGVuZHMNCnVwIGluIGJpdHMgNDc6MzIgb2YgdGhlIHJldHVybiB2YWx1ZSwgaW5zdGVh
ZCBvZiBiaXRzIDMxOjE2IGFzIHRoZXkNCnNob3VsZC4NCg0KRml4ZXM6IDZlNDZlMmQ4MjFiYiAo
Im5ldDogZHNhOiBtdjg4ZTZ4eHg6IEZpeCB1NjQgc3RhdGlzdGljcyIpDQpTaWduZWQtb2ZmLWJ5
OiBSYXNtdXMgVmlsbGVtb2VzIDxyYXNtdXMudmlsbGVtb2VzQHByZXZhcy5kaz4NCi0tLQ0KdjI6
IGluY2x1ZGUgRml4ZXMgdGFnLCB1c2UgcHJvcGVyIHN1YmplY3QgcHJlZml4Lg0KDQogZHJpdmVy
cy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMgfCAyICstDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2Ev
bXY4OGU2eHh4L2NoaXAuYyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5jDQppbmRl
eCAzNzA0MzRiZGJkYWIuLjMxNzU1M2QyY2IyMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2Rz
YS9tdjg4ZTZ4eHgvY2hpcC5jDQorKysgYi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2NoaXAu
Yw0KQEAgLTc4NSw3ICs3ODUsNyBAQCBzdGF0aWMgdWludDY0X3QgX212ODhlNnh4eF9nZXRfZXRo
dG9vbF9zdGF0KHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCiAJCQllcnIgPSBtdjg4ZTZ4
eHhfcG9ydF9yZWFkKGNoaXAsIHBvcnQsIHMtPnJlZyArIDEsICZyZWcpOw0KIAkJCWlmIChlcnIp
DQogCQkJCXJldHVybiBVNjRfTUFYOw0KLQkJCWhpZ2ggPSByZWc7DQorCQkJbG93IHw9ICgodTMy
KXJlZykgPDwgMTY7DQogCQl9DQogCQlicmVhazsNCiAJY2FzZSBTVEFUU19UWVBFX0JBTksxOg0K
LS0gDQoyLjIwLjENCg0K
