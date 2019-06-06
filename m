Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A18636F19
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfFFIuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:50:20 -0400
Received: from mail-eopbgr10082.outbound.protection.outlook.com ([40.107.1.82]:26036
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbfFFIuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 04:50:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCrqjl09AvLWqWT8xyppiQ1wd9+DRvWv2a/OteSodsg=;
 b=D2hjXsQjrnXSUHhCCja2iTrwEJoVN4bVuKF0gPEMvPbg90wcRmbN9SGDVZrY2EUBv1K/rOPikWWumTqOfYpJhTJjRVM+eMo633Z3peGcANkjLc89nZa2jq4EnIGdVe/oOfEE1m8wV1DM05ZPiSFHCBnu6GSHHnOKVUKoCnbd6P8=
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com (20.177.119.89) by
 AM6PR05MB6296.eurprd05.prod.outlook.com (20.179.4.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Thu, 6 Jun 2019 08:50:16 +0000
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae]) by AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae%5]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 08:50:16 +0000
From:   Shalom Toledo <shalomt@mellanox.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Thread-Topic: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Thread-Index: AQHVGgXTQ0R6KLy1CUKANB7103lOSqaLj3aAgAFkg4CAAGN+gIAAHjmAgAB5eACAAGaBgA==
Date:   Thu, 6 Jun 2019 08:50:16 +0000
Message-ID: <7c51a280-9d39-3a13-fd92-5e5afcca07d9@mellanox.com>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-8-idosch@idosch.org>
 <20190604142819.cml2tbkmcj2mvkpl@localhost>
 <5c757fb9-8b47-c03a-6b78-45ac2b2140f3@mellanox.com>
 <20190605174025.uwy2u7z55v3c2opm@localhost>
 <be656773-93e8-2f95-ad63-bfec18c9523a@mellanox.com>
 <20190606024320.6ilfk5ur3a3d6ead@localhost>
In-Reply-To: <20190606024320.6ilfk5ur3a3d6ead@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
x-clientproxiedby: AM0PR05CA0089.eurprd05.prod.outlook.com
 (2603:10a6:208:136::29) To AM6PR05MB5524.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 615e6402-5081-4752-e79f-08d6ea5bfecf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6296;
x-ms-traffictypediagnostic: AM6PR05MB6296:
x-microsoft-antispam-prvs: <AM6PR05MB6296C20B9F87D3B4A5C8D3D2C5170@AM6PR05MB6296.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(346002)(376002)(39860400002)(366004)(189003)(199004)(31686004)(36756003)(478600001)(4744005)(14454004)(58126008)(54906003)(316002)(64126003)(68736007)(5660300002)(71200400001)(71190400001)(107886003)(6246003)(25786009)(6116002)(4326008)(6916009)(1411001)(2906002)(305945005)(7736002)(53936002)(6436002)(8936002)(102836004)(8676002)(81156014)(81166006)(53546011)(6506007)(386003)(31696002)(26005)(3846002)(52116002)(99286004)(6512007)(76176011)(229853002)(6486002)(86362001)(65826007)(446003)(11346002)(66066001)(476003)(486006)(2616005)(65806001)(65956001)(66946007)(66476007)(66556008)(64756008)(66446008)(73956011)(256004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6296;H:AM6PR05MB5524.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: haeRib6YF/XtZS+2qxaVWitEuHzzkonPKWKf4n286VCUlD9AaC1yCxARto3uJ28V4xBMI0TPOUeVPcYVpc7IVkW/Y+2td17xaUpVoukluzINV1G5N0RMU9ewFd1rIpBV9FodH+4pPGFFgqBler2cdGBlmElm8YeqiQnY2K2DAmBxT9hCvD2AJ5dcUvOn2pHUbs7WN6QGxzh4HbWFHG9Mexs8PS+7CtbLyyD6OKHUw+M1P643YdgyeMTEEqs9ApSnKX2qzQIflvt3Dcb+rjc+7C+FslW4xJgoBMT43ASVa3jwi0cH0depT/+CORvyryl+VI9pmrF9OuI/8LOXB3bvcj5rxXWwI7Za+ZYB1B+I/nFuFgLHMzJN68jPAyHSrle1CQyhm86lyO63orb/QP/MBzH68u0KXrC4KhCvZeIu+P8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F73F42C8E58CB7408A34ADE7B64E17B8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 615e6402-5081-4752-e79f-08d6ea5bfecf
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 08:50:16.0483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shalomt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDYvMDYvMjAxOSA1OjQzLCBSaWNoYXJkIENvY2hyYW4gd3JvdGU6DQo+IE9uIFdlZCwgSnVu
IDA1LCAyMDE5IGF0IDA3OjI4OjM4UE0gKzAwMDAsIFNoYWxvbSBUb2xlZG8gd3JvdGU6DQo+PiBT
bywgdGhlcmUgaXMgYW4gSFcgbWFjaGluZSB3aGljaCByZXNwb25zaWJsZSBmb3IgYWRkaW5nIFVU
QyB0aW1lc3RhbXAgb24NCj4+IFItU1BBTiBtaXJyb3IgcGFja2V0cyBhbmQgdGhlcmUgaXMgbm8g
Y29ubmVjdGlvbiB0byB0aGUgSFcgZnJlZSBydW5uaW5nDQo+PiBjb3VudGVyLg0KPiANCj4gSWYg
dGhlcmUgaXMgbm8gY29ubmVjdGlvbiwgdGhlbiB0aGUgZnJlcXVlbmN5IGFkanVzdG1lbnRzIHRv
IHRoZSBIVw0KPiBjbG9jayB3aWxsIG5vdCB3b3JrIGFzIGV4cGVjdGVkLg0KDQpJIG1lYW4gdGhh
dCB0aGVzZSBhcmUgdHdvIGRpZmZlcmVudCBwZWFjZXMgb2YgSFcgd2l0aCBkaWZmZXJlbnQgY29u
dHJvbA0KaW50ZXJmYWNlcy4NCg0KPiANCj4gUGVyaGFwcyB0aGUgZnJlZSBydW5uaW5nIGNvdW50
ZXIgYW5kIHRoZSBIVyBjbG9jayBzaGFyZSB0aGUgc2FtZSBjbG9jaw0KPiBzb3VyY2U/DQoNClll
cywgb2YgY291cnNlLg0KDQo+IA0KPiBUaGFua3MsDQo+IFJpY2hhcmQNCj4gDQoNCg==
