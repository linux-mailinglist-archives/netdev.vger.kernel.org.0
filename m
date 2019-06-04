Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6462634FC1
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 20:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfFDSTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 14:19:55 -0400
Received: from mail-eopbgr50071.outbound.protection.outlook.com ([40.107.5.71]:65025
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726179AbfFDSTz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 14:19:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QW2ofeS90cyKLwsL6W45i2vp4WFTzWroAPc7aFl9WfE=;
 b=CfVKV+g0wSf75beooRdZUmPzQEY+kEv3AaZrFOXiegNR6exzg+mz1kZDK01XC0/sg3RolO06ZEoqPwc44oGFWRYRdQF+82oOA6t+QqBBPKi8saB1tBBIbQtSyBZbmy7vNvww4YTVOdeDWAUNjKgYf0ePzJbJRba6sE9omo3j3rY=
Received: from DB8PR05MB5897.eurprd05.prod.outlook.com (20.179.9.78) by
 DB8PR05MB6026.eurprd05.prod.outlook.com (20.179.10.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Tue, 4 Jun 2019 18:19:51 +0000
Received: from DB8PR05MB5897.eurprd05.prod.outlook.com
 ([fe80::3d8e:cfe5:abc9:8166]) by DB8PR05MB5897.eurprd05.prod.outlook.com
 ([fe80::3d8e:cfe5:abc9:8166%5]) with mapi id 15.20.1965.011; Tue, 4 Jun 2019
 18:19:50 +0000
From:   Eli Britstein <elibr@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Davide Caratti <dcaratti@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net v3 0/3] net/sched: fix actions reading the network
 header in case of QinQ packets
Thread-Topic: [PATCH net v3 0/3] net/sched: fix actions reading the network
 header in case of QinQ packets
Thread-Index: AQHVF9YCXzM5AJb6fEe3JxZQMbJbvaaFkZSAgAA3bgCAAAgFAIAB9OqAgAQHtICAAAbcAA==
Date:   Tue, 4 Jun 2019 18:19:50 +0000
Message-ID: <d480caba-16e2-da3e-be33-ff4aeb5c6420@mellanox.com>
References: <cover.1559322531.git.dcaratti@redhat.com>
 <CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com>
 <739e0a292a31b852e32fb1096520bb7d771f8579.camel@redhat.com>
 <CAM_iQpUmuHH8S35ERuJ-sFS=17aa-C8uHSWF-WF7toANX2edCQ@mail.gmail.com>
 <82ec3877-8026-67f7-90d8-6e9988513fef@mellanox.com>
 <CAM_iQpXsGc2EpGkLq_3tcgiD+Mshe1GvGuURwcmeBEqpmQaiTw@mail.gmail.com>
In-Reply-To: <CAM_iQpXsGc2EpGkLq_3tcgiD+Mshe1GvGuURwcmeBEqpmQaiTw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR06CA0035.eurprd06.prod.outlook.com
 (2603:10a6:20b:14::48) To DB8PR05MB5897.eurprd05.prod.outlook.com
 (2603:10a6:10:a5::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=elibr@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [46.120.174.225]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 417451d9-e2bd-496a-b4a7-08d6e9193bd0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6026;
x-ms-traffictypediagnostic: DB8PR05MB6026:
x-microsoft-antispam-prvs: <DB8PR05MB602618C464972704D586303BD5150@DB8PR05MB6026.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(39860400002)(366004)(136003)(396003)(51444003)(189003)(199004)(68736007)(99286004)(6116002)(3846002)(5660300002)(52116002)(66556008)(66476007)(66946007)(73956011)(66066001)(71200400001)(71190400001)(316002)(2906002)(6486002)(25786009)(229853002)(76176011)(256004)(31696002)(7736002)(31686004)(102836004)(305945005)(53936002)(6246003)(6436002)(4326008)(64756008)(66446008)(36756003)(26005)(6916009)(186003)(8676002)(8936002)(476003)(11346002)(486006)(2616005)(86362001)(6512007)(54906003)(81166006)(446003)(14454004)(81156014)(508600001)(6506007)(386003)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6026;H:DB8PR05MB5897.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bSHYKUfm5TM2/gAHOHzTkgQzW46eqX44Jwu45XqZPZeg923iXU2Mh4iQKnjQEwKlvLETfBmGAPj1nfv7gxzQa2H5G13kAEKxKWaAn4FsKy28M07g4smmLWNxZVXCEDqA5XpxBhyRPBdIQhpr6vigYoLMxk47LGKQbFPpoKyCtmn7lFOwot9DNVSMowMyudiNaszdpDlNQSJbvdY4xsjpeiIsEVOnHfQEu+QGNfaRdRZkhcndsvSse0VfPlyFhDokwbVMj4hYxtw1pZtTjNh0xjf3cd2IXugL6FxQt/U9lcFVQOnuYAlWj9Ko1TmeASQZd4ci2FS5x2X769CLNLpLuFjP76GvQiBuL87aiRFiyDc8+kDHH8q5JYkfbjfPuu6tb9z+6m2OyeX/HX04JqbTGy+xeR0QlHOn9nTt/0JOIdY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F35D22F27DAE74493103B2452E72541@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 417451d9-e2bd-496a-b4a7-08d6e9193bd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 18:19:50.8430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: elibr@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6026
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzQvMjAxOSA4OjU1IFBNLCBDb25nIFdhbmcgd3JvdGU6DQo+IE9uIFNhdCwgSnVuIDEs
IDIwMTkgYXQgOToyMiBQTSBFbGkgQnJpdHN0ZWluIDxlbGlickBtZWxsYW5veC5jb20+IHdyb3Rl
Og0KPj4gSSB0aGluayB0aGF0J3MgYmVjYXVzZSBRaW5RLCBvciBWTEFOIGlzIG5vdCBhbiBlbmNh
cHN1bGF0aW9uLiBUaGVyZSBpcw0KPj4gbm8gb3V0ZXIvaW5uZXIgcGFja2V0cywgYW5kIGlmIHlv
dSB3YW50IHRvIG1hbmdsZSBmaWVsZHMgaW4gdGhlIHBhY2tldA0KPj4geW91IGNhbiBkbyBpdCBh
bmQgdGhlIHJlc3VsdCBpcyB3ZWxsLWRlZmluZWQuDQo+IFNvcnQgb2YsIHBlcmhhcHMgVkxBTiB0
YWdzIGFyZSB0b28gc2hvcnQgdG8gYmUgY2FsbGVkIGFzIGFuDQo+IGVuY2Fwc3VsYXRpb24sIG15
IHBvaW50IGlzIHRoYXQgaXQgc3RpbGwgbmVlZHMgc29tZSBlbmRwb2ludHMgdG8gcHVzaA0KPiBv
ciBwb3AgdGhlIHRhZ3MsIGluIGEgc2ltaWxhciB3YXkgd2UgZG8gZW5jYXAvZGVjYXAuDQo+DQo+
DQo+PiBCVFcsIHRoZSBtb3RpdmF0aW9uIGZvciBteSBmaXggd2FzIGEgdXNlIGNhc2Ugd2VyZSAy
IFZHVCBWTXMNCj4+IGNvbW11bmljYXRpbmcgYnkgT1ZTIGZhaWxlZC4gU2luY2UgT1ZTIHNlZXMg
dGhlIHNhbWUgVkxBTiB0YWcsIGl0DQo+PiBkb2Vzbid0IGFkZCBleHBsaWNpdCBWTEFOIHBvcC9w
dXNoIGFjdGlvbnMgKGkuZSBwb3AsIG1hbmdsZSwgcHVzaCkuIElmDQo+PiB5b3UgZm9yY2UgZXhw
bGljaXQgcG9wL21hbmdsZS9wdXNoIHlvdSB3aWxsIGJyZWFrIHN1Y2ggYXBwbGljYXRpb25zLg0K
PiAgRnJvbSB3aGF0IHlvdSBzYWlkLCBpdCBzZWVtcyBhY3RfY3N1bSBpcyBpbiB0aGUgbWlkZGxl
IG9mIHBhY2tldA0KPiByZWNlaXZlL3RyYW5zbWl0IHBhdGguIFNvLCB3aGljaCBpcyB0aGUgb25l
IHBvcHMgdGhlIFZMQU4gdGFncyBpbg0KPiB0aGlzIHNjZW5hcmlvPyBJZiB0aGUgVk0ncyBhcmUg
dGhlIGVuZHBvaW50cywgd2h5IG5vdCB1c2UgYWN0X2NzdW0NCj4gdGhlcmU/DQoNCkluIGEgc3dp
dGNoZGV2IG1vZGUsIHdlIGNhbiBwYXNzdGhydSB0aGUgVkZzIHRvIFZNcywgYW5kIGhhdmUgdGhl
aXIgDQpyZXByZXNlbnRvcnMgaW4gdGhlIGhvc3QsIGVuYWJsaW5nIHVzIHRvIG1hbmlwdWxhdGUg
dGhlIEhXIGVzd2l0Y2ggDQp3aXRob3V0IGtub3dsZWRnZSBvZiB0aGUgVk1zLg0KDQpUbyBzaW1w
bGlmeSBpdCwgY29uc2lkZXIgdGhlIGZvbGxvd2luZyBzZXR1cDoNCg0KdjFhIDwtPiB2MWIgYW5k
IHYyYSA8LT4gdjJiIGFyZSB2ZXRoIHBhaXJzLg0KDQpOb3csIHdlIGNvbmZpZ3VyZSB2MWEuMjAg
YW5kIHYyYS4yMCBhcyBWTEFOIGRldmljZXMgb3ZlciB2MWEvdjJhIA0KcmVzcGVjdGl2ZWx5IChh
bmQgcHV0IHRoZSAiYSIgZGV2cyBpbiBzZXBhcmF0ZSBuYW1lc3BhY2VzKS4NCg0KVGhlIFRDIHJ1
bGVzIGFyZSBvbiB0aGUgImIiIGRldnMsIGZvciBleGFtcGxlOg0KDQp0YyBmaWx0ZXIgYWRkIGRl
diB2MWIgLi4uIGFjdGlvbiBwZWRpdCAuLi4gYWN0aW9uIGNzdW0gLi4uIGFjdGlvbiANCnJlZGly
ZWN0IGRldiB2MmINCg0KTm93LCBwaW5nIGZyb20gdjFhLjIwIHRvIHYxYi4yMC4gVGhlIG5hbWVz
cGFjZXMgdHJhbnNtaXQvcmVjZWl2ZSB0YWdnZWQgDQpwYWNrZXRzLCBhbmQgYXJlIG5vdCBhd2Fy
ZSBvZiB0aGUgcGFja2V0IG1hbmlwdWxhdGlvbiAoYW5kIHRoZSByZXF1aXJlZCANCmFjdF9jc3Vt
KS4NCj4gVGhhbmtzLg0K
