Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE67F35922
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 11:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfFEJAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 05:00:14 -0400
Received: from mail-eopbgr20051.outbound.protection.outlook.com ([40.107.2.51]:14412
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726690AbfFEJAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 05:00:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0mNXQIgLVZZ1DJgaP2cOp5eG9hSGobtrdzn4HJHtK0=;
 b=Bfwdt0HNTmE7J68ezRfcZa6vs9zm+y/orGmiaug3zttWfq7WyjdRNQqsHQk7T8TjWhcLO7kM/CbiEtdjxkrEll0+oUAsPiBvN0dS8hEdLlBZSNf2hV44uoE5PGJ7h+bXb1cdwmiu73eWB5VsvMGMUoVv0pIXQoP0FRdw6O0DPCA=
Received: from AM6PR05MB6133.eurprd05.prod.outlook.com (20.179.3.144) by
 AM6PR05MB4486.eurprd05.prod.outlook.com (52.135.162.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Wed, 5 Jun 2019 09:00:09 +0000
Received: from AM6PR05MB6133.eurprd05.prod.outlook.com
 ([fe80::1cec:5ce0:adab:7a12]) by AM6PR05MB6133.eurprd05.prod.outlook.com
 ([fe80::1cec:5ce0:adab:7a12%7]) with mapi id 15.20.1943.023; Wed, 5 Jun 2019
 09:00:09 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Thread-Topic: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Thread-Index: AQHVGgXT+S72SiTw0kK+/hqBqs3YWaaLuumAgAELMIA=
Date:   Wed, 5 Jun 2019 09:00:09 +0000
Message-ID: <87muiwxv8o.fsf@mellanox.com>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-8-idosch@idosch.org>
 <20190604170349.wqsocilmlaisyzar@localhost>
In-Reply-To: <20190604170349.wqsocilmlaisyzar@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0202CA0007.eurprd02.prod.outlook.com
 (2603:10a6:203:69::17) To AM6PR05MB6133.eurprd05.prod.outlook.com
 (2603:10a6:20b:af::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [78.45.160.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 225b1fd5-d8a6-4636-b1ad-08d6e9943626
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR05MB4486;
x-ms-traffictypediagnostic: AM6PR05MB4486:
x-microsoft-antispam-prvs: <AM6PR05MB448692DAEDD2E5A98E7D0BF9DB160@AM6PR05MB4486.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(366004)(136003)(39860400002)(199004)(189003)(2616005)(99286004)(52116002)(476003)(11346002)(5660300002)(446003)(1411001)(36756003)(66066001)(14454004)(6436002)(186003)(486006)(2906002)(26005)(305945005)(6486002)(76176011)(66946007)(73956011)(316002)(66476007)(66556008)(64756008)(66446008)(102836004)(508600001)(8676002)(386003)(4326008)(25786009)(81156014)(6506007)(86362001)(7736002)(71190400001)(8936002)(71200400001)(53936002)(14444005)(54906003)(229853002)(6116002)(6246003)(6916009)(107886003)(3846002)(256004)(6512007)(81166006)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4486;H:AM6PR05MB6133.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cgZ9kpMgrYs1ouz83JKGEnfiYW867oCUASz/q+I0He7mFU2y7OyeoR5aDYWhMUmSANP7zDSfGHWYBvaE9MZbFo4BFSBspqSvUBp2R9tzyWws3KxswuqxAM1iO5PVntFGJQeVtKhg8xTmGfTffm2f4L7iMPPX/gvg1rcvlISgDc4id+ysh0R4p/jd4vj5POIszgwLbhjo5897c9dxyu+kOBbOPh690HpaWSDQBDLbw9HwCIUyTjEni0DSxxripFnOPXpb2kyesC0dR05GNs71yge+WwZ3e+e9cTcb3plCPLiuVqCoSB3bahAahEnKq4zJ1kcojosywiSgkFtovQ/GNSQh9835b2z8sqBheNfdmM3Wkzbcv1n9uOUejW0ABGVnGAoI9wE+0eCOl5gaqOcVud+kmc1YfagK0YBLHHLXMuY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 225b1fd5-d8a6-4636-b1ad-08d6e9943626
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 09:00:09.5609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4486
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpSaWNoYXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4gd3JpdGVzOg0KDQo+
IE9uIE1vbiwgSnVuIDAzLCAyMDE5IGF0IDAzOjEyOjQyUE0gKzAzMDAsIElkbyBTY2hpbW1lbCB3
cm90ZToNCj4+ICtzdHJ1Y3QgbWx4c3dfc3BfcHRwX2Nsb2NrICoNCj4+ICttbHhzd19zcDFfcHRw
X2Nsb2NrX2luaXQoc3RydWN0IG1seHN3X3NwICptbHhzd19zcCwgc3RydWN0IGRldmljZSAqZGV2
KQ0KDQpbLi4uXQ0KDQo+PiArCWNsb2NrLT5wdHBfaW5mbyA9IG1seHN3X3NwMV9wdHBfY2xvY2tf
aW5mbzsNCj4+ICsJY2xvY2stPnB0cCA9IHB0cF9jbG9ja19yZWdpc3RlcigmY2xvY2stPnB0cF9p
bmZvLCBkZXYpOw0KPj4gKwlpZiAoSVNfRVJSKGNsb2NrLT5wdHApKSB7DQo+PiArCQllcnIgPSBQ
VFJfRVJSKGNsb2NrLT5wdHApOw0KPj4gKwkJZGV2X2VycihkZXYsICJwdHBfY2xvY2tfcmVnaXN0
ZXIgZmFpbGVkICVkXG4iLCBlcnIpOw0KPj4gKwkJZ290byBlcnJfcHRwX2Nsb2NrX3JlZ2lzdGVy
Ow0KPj4gKwl9DQo+PiArDQo+PiArCXJldHVybiBjbG9jazsNCj4NCj4gWW91IG5lZWQgdG8gaGFu
ZGxlIHRoZSBjYXNlIHdoZXJlIHB0cF9jbG9ja19yZWdpc3RlcigpIHJldHVybnMgTlVMTC4uLg0K
Pg0KPiAvKioNCj4gICogcHRwX2Nsb2NrX3JlZ2lzdGVyKCkgLSByZWdpc3RlciBhIFBUUCBoYXJk
d2FyZSBjbG9jayBkcml2ZXINCj4gICoNCj4gICogQGluZm86ICAgU3RydWN0dXJlIGRlc2NyaWJp
bmcgdGhlIG5ldyBjbG9jay4NCj4gICogQHBhcmVudDogUG9pbnRlciB0byB0aGUgcGFyZW50IGRl
dmljZSBvZiB0aGUgbmV3IGNsb2NrLg0KPiAgKg0KPiAgKiBSZXR1cm5zIGEgdmFsaWQgcG9pbnRl
ciBvbiBzdWNjZXNzIG9yIFBUUl9FUlIgb24gZmFpbHVyZS4gIElmIFBIQw0KPiAgKiBzdXBwb3J0
IGlzIG1pc3NpbmcgYXQgdGhlIGNvbmZpZ3VyYXRpb24gbGV2ZWwsIHRoaXMgZnVuY3Rpb24NCj4g
ICogcmV0dXJucyBOVUxMLCBhbmQgZHJpdmVycyBhcmUgZXhwZWN0ZWQgdG8gZ3JhY2VmdWxseSBo
YW5kbGUgdGhhdA0KPiAgKiBjYXNlIHNlcGFyYXRlbHkuDQo+ICAqLw0KDQpXZSBkb24ndCBidWls
ZCB0aGUgUFRQIG1vZHVsZSBhdCBhbGwgdW5sZXNzIENPTkZJR19QVFBfMTU4OF9DTE9DSyBpcw0K
ZW5hYmxlZCwgYW5kIGZhbGwgYmFjayB0byBpbmxpbmUgc3R1YnMgdW5sZXNzIGl0IElTX1JFQUNI
QUJMRS4gSSBiZWxpZXZlDQp0aGlzIHNob3VsZCBiZSBPSy4NCg==
