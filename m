Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 181E11B976
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 17:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbfEMPFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 11:05:32 -0400
Received: from mail-eopbgr00089.outbound.protection.outlook.com ([40.107.0.89]:7317
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727725AbfEMPFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 11:05:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSox+VqUUorZlvIW1WEeY0Q0253/PFVPXpSLCNaQb1U=;
 b=D4CSO1+o1u1RnH4djxSbHX+Xgtt8S6pC1JCDrqNxDqs+DFVhV0URJmf7FL5SUSa6Z8MxzrxlBtfNZdXlYiA7N97qYpH+l2ZMQIYxplfOzaFS0X0wwozG174vcs1aHYOxUWPGIaydSMkdufmLhezPp4Fl3R5PMo5LUEvlGenGDkM=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6200.eurprd05.prod.outlook.com (20.178.95.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Mon, 13 May 2019 15:05:28 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2%7]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 15:05:28 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [RFC] inet6_validate_link_af improvements
Thread-Topic: [RFC] inet6_validate_link_af improvements
Thread-Index: AQHVCZ1NZIjB4FH9SkGSahMmgdL1cQ==
Date:   Mon, 13 May 2019 15:05:28 +0000
Message-ID: <20190513150513.26872-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0447.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::27) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 991ff493-0808-44d6-e493-08d6d7b46f81
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6200;
x-ms-traffictypediagnostic: AM6PR05MB6200:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR05MB6200902818AEA56948374B26D10F0@AM6PR05MB6200.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(366004)(396003)(346002)(199004)(189003)(86362001)(50226002)(478600001)(186003)(6436002)(6486002)(5660300002)(476003)(26005)(81166006)(99286004)(6116002)(14454004)(81156014)(966005)(256004)(3846002)(14444005)(53936002)(4326008)(107886003)(25786009)(8676002)(2616005)(71190400001)(71200400001)(8936002)(486006)(7736002)(316002)(73956011)(102836004)(305945005)(2906002)(52116002)(66066001)(110136005)(54906003)(386003)(36756003)(6506007)(6306002)(68736007)(6512007)(64756008)(66446008)(1076003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6200;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IduNFSQwObzzL5k2sHCXjAQt97fnC3yBXgP/3nulj2juUtF2zsFmB2NAvPY+NEv+yQsEf+n6VnsZZv/zd9FuXmRs4f2h2wZQy1WXo+gi72g58LzWSSecqZeLDDnjXrbCu69fm4FWcHdUbVqWm9/+FZHF6tKRh326nmx8nq8yXaXLohRUCL5U2ANAL71jAEWYJErQhPyIePzuCO1H87gckG6WGoM7jE9vSaQB5jcK0ODMf58EpeCvFOfGRnXTZwX9RYWlvp7T99dmZtlJssYvkHl8W1B0JlqNGFyWwfm6Bhm/zsDMt4a7Mc+srlIae4e3CSKoNw1GfxYUwFFUGP14iFybq0Ylb+QPQQOmpHqdsLpAXXs5vRraJ9s/uj5ZpT0n+i3LMI8nBBYgZuNy2Ky5c9J0r9o4zuI8X/d1tSf95yc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 991ff493-0808-44d6-e493-08d6d7b46f81
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 15:05:28.7470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QSByZWNlbnQgYnVnIGluIHN5c3RlbWQgWzFdIHRyaWdnZXJlZCB0aGUgZm9sbG93aW5nIGtlcm5l
bCB3YXJuaW5nOg0KDQogIEEgbGluayBjaGFuZ2UgcmVxdWVzdCBmYWlsZWQgd2l0aCBzb21lIGNo
YW5nZXMgY29tbWl0dGVkIGFscmVhZHkuDQogIEludGVyZmFjZSBldGgxIG1heSBoYXZlIGJlZW4g
bGVmdCB3aXRoIGFuIGluY29uc2lzdGVudCBjb25maWd1cmF0aW9uLA0KICBwbGVhc2UgY2hlY2su
DQoNCmRvX3NldGxpbmsoKSBwZXJmb3JtcyBtdWx0aXBsZSBjb25maWd1cmF0aW9uIHVwZGF0ZXMs
IGFuZCBpZiBhbnkgb2YgdGhlbQ0KZmFpbHMsIGRvX3NldGxpbmsoKSBoYXMgbm8gd2F5IHRvIHJl
dmVydCB0aGUgcHJldmlvdXMgb25lcy4gSXQgaXMgYWxzbw0Kbm90IGVhc3kgdG8gdmFsaWRhdGUg
ZXZlcnl0aGluZyBpbiBhZHZhbmNlIGFuZCBwZXJmb3JtIGEgbm9uLWZhaWxpbmcNCnVwZGF0ZSB0
aGVuLiBIb3dldmVyLCBkb19zZXRsaW5rKCkgaGFzIHNvbWUgYmFzaWMgdmFsaWRhdGlvbiB0aGF0
IGNhbiBiZQ0KZXh0ZW5kZWQgYXQgbGVhc3QgdGhpcyBjYXNlLiBJTU8sIGl0J3MgYmV0dGVyIHRv
IGZhaWwgYmVmb3JlIGRvaW5nIGFueQ0KY2hhbmdlcyB0aGFuIHRvIHBlcmZvcm0gYSBwYXJ0aWFs
IGNvbmZpZ3VyYXRpb24gdXBkYXRlLg0KDQpUaGlzIFJGQyBjb250YWlucyB0d28gcGF0Y2hlcyB0
aGF0IG1vdmUgc29tZSBjaGVja3MgdG8gdGhlIHZhbGlkYXRpb24NCnN0YWdlIChpbmV0Nl92YWxp
ZGF0ZV9saW5rX2FmKCkgZnVuY3Rpb24pLiBPbmx5IG9uZSBvZiB0aGUgcGF0Y2hlcyAoaWYNCmFu
eSkgc2hvdWxkIGJlIGFwcGxpZWQuIFBhdGNoIDEgb25seSBjaGVja3MgdGhlIHByZXNlbmNlIG9m
IGF0IGxlYXN0IG9uZQ0KcGFyYW1ldGVyLCBhbmQgcGF0Y2ggMiBhbHNvIG1vdmVzIHRoZSB2YWxp
ZGF0aW9uIGZvciBhZGRyZ2VubW9kZSB0aGF0IGlzDQpjdXJyZW50bHkgcGFydCBvZiBpbmV0Nl9z
ZXRfbGlua19hZigpLiBPZiBjb3Vyc2UsIHRoZXJlIGFyZSBzdGlsbCBtYW55DQp3YXlzIGhvdyBk
b19zZXRsaW5rKCkgY2FuIGZhaWwgYW5kIHBlcmZvcm0gYSBwYXJ0aWFsIHVwZGF0ZSwgYnV0IElN
Tw0KaXQncyBiZXR0ZXIgdG8gcHJldmVudCBhdCBsZWFzdCBzb21lIGNhc2VzIHRoYXQgd2UgY2Fu
Lg0KDQpQbGVhc2UgZXhwcmVzcyB5b3VyIG9waW5pb25zIG9uIHRoaXMgZml4OiBkbyB3ZSBuZWVk
IGl0LCBkbyB3ZSB3YW50IHRvDQp2YWxpZGF0ZSBhcyBtdWNoIGFzIHBvc3NpYmxlIChwYXRjaCAy
KSBvciBvbmx5IGJhc2ljIHN0dWZmIGxpa2UgdGhlDQpwcmVzZW5jZSBvZiBwYXJhbWV0ZXJzIChw
YXRjaCAxKT8gSSdtIGxvb2tpbmcgZm9yd2FyZCB0byBoZWFyaW5nIHRoZQ0KZmVlZGJhY2suDQoN
ClRoYW5rcywNCk1heA0KDQpbMV06IGh0dHBzOi8vZ2l0aHViLmNvbS9zeXN0ZW1kL3N5c3RlbWQv
aXNzdWVzLzEyNTA0DQoNCi0tIA0KMi4xOS4xDQoNCg==
