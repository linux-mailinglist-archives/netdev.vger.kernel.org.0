Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB0F3717F
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 12:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfFFKV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 06:21:59 -0400
Received: from mail-eopbgr130070.outbound.protection.outlook.com ([40.107.13.70]:57155
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727469AbfFFKV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 06:21:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jB+5TjA6SAqA+jiM9tZXVSUfmYyvCzuD/lt3syhXnbg=;
 b=ZwMiHyLGHjXt8ne8eNMwggQ9rqx+H2XxZ7fxVJBnv3dat6wQ2YrFytBRMqvKaoSU5kNhfg6lXBp9/wzqvvE49t1a0Swc8AuY+T17/B0jhfZcBbabaorOBtEQsWOoMZpyVCBC4mFBPSJaVZmE8VxO0urJZ7Q/aL1MFizgoxktLXA=
Received: from AM6PR05MB6133.eurprd05.prod.outlook.com (20.179.3.144) by
 AM6PR05MB4246.eurprd05.prod.outlook.com (52.135.161.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Thu, 6 Jun 2019 10:21:54 +0000
Received: from AM6PR05MB6133.eurprd05.prod.outlook.com
 ([fe80::1cec:5ce0:adab:7a12]) by AM6PR05MB6133.eurprd05.prod.outlook.com
 ([fe80::1cec:5ce0:adab:7a12%7]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 10:21:54 +0000
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
Thread-Index: AQHVGgXT+S72SiTw0kK+/hqBqs3YWaaLuumAgAELMICAAI77AIABGjEA
Date:   Thu, 6 Jun 2019 10:21:54 +0000
Message-ID: <87imtjxbcv.fsf@mellanox.com>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-8-idosch@idosch.org>
 <20190604170349.wqsocilmlaisyzar@localhost> <87muiwxv8o.fsf@mellanox.com>
 <20190605173152.4lsfx7a5cvyzatww@localhost>
In-Reply-To: <20190605173152.4lsfx7a5cvyzatww@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0602CA0020.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::30) To AM6PR05MB6133.eurprd05.prod.outlook.com
 (2603:10a6:20b:af::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [78.45.160.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e06557ad-6822-4bf3-e5ba-08d6ea68cc3a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4246;
x-ms-traffictypediagnostic: AM6PR05MB4246:
x-microsoft-antispam-prvs: <AM6PR05MB424684CF65BA33F7F75CD1E9DB170@AM6PR05MB4246.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(136003)(366004)(39860400002)(346002)(199004)(189003)(54906003)(76176011)(68736007)(386003)(6506007)(6512007)(6916009)(316002)(99286004)(229853002)(66446008)(73956011)(66946007)(66476007)(66556008)(64756008)(52116002)(36756003)(14454004)(1411001)(6486002)(81166006)(6436002)(8676002)(81156014)(8936002)(476003)(2616005)(446003)(86362001)(4326008)(256004)(3846002)(6116002)(6246003)(7736002)(11346002)(305945005)(2906002)(53936002)(486006)(107886003)(4744005)(5660300002)(186003)(478600001)(66066001)(26005)(71190400001)(71200400001)(102836004)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4246;H:AM6PR05MB6133.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C6MWvMOkwvM+JCpCvyJkIODt7wbLkygYbvToQemn2+ahJygIXRsMA9CM+7j9rfzxlmHEpy6jaHZycpmkocsYmuqSiT8RXEzkte0EWntWnIK8Ii2ugtClKfeCkTCoWZ/rMAc06JAXSEW02aS7JaawACUiFYD35vH3okecvoDLB2xwyEBDg7wh90+5cVozwh8Viyjtl4H/GhQhyD7e5KraaR4a/5VEbhq0gNUw8Ixl9HkEWgDbQTCpFcsGigw96EyLCpusDl/IPHh1yVR37SNs6FCLsLwXLnYk2QgmlZSxpipwdgsDbI5+vgRZ7ML23TMfF5jHnulIhv8i/Q5t4uqsg/VzWPm+XuM1ZZwwoImxtFg9Nf9zXdhfMR+XRRXII0G7gn/OXxcz9z4fiZo91aPEvadigomDi/xncI0OpjMeCac=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e06557ad-6822-4bf3-e5ba-08d6ea68cc3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 10:21:54.6042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4246
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpSaWNoYXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4gd3JpdGVzOg0KDQo+
IE9uIFdlZCwgSnVuIDA1LCAyMDE5IGF0IDA5OjAwOjA5QU0gKzAwMDAsIFBldHIgTWFjaGF0YSB3
cm90ZToNCj4+IFdlIGRvbid0IGJ1aWxkIHRoZSBQVFAgbW9kdWxlIGF0IGFsbCB1bmxlc3MgQ09O
RklHX1BUUF8xNTg4X0NMT0NLIGlzDQo+PiBlbmFibGVkLCBhbmQgZmFsbCBiYWNrIHRvIGlubGlu
ZSBzdHVicyB1bmxlc3MgaXQgSVNfUkVBQ0hBQkxFLiBJIGJlbGlldmUNCj4+IHRoaXMgc2hvdWxk
IGJlIE9LLg0KPg0KPiBQbGVhc2UgdXNlICJpbXBseSBQVFBfMTU4OF9DTE9DSyIgaW4geW91ciBr
Y29uZmlnLCBqdXN0IGxpa2UgdGhlIG90aGVyDQo+IFBUUCBkcml2ZXJzIGRvLg0KDQpBbGwgcmln
aHQuDQo=
