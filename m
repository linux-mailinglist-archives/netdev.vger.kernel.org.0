Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 611AFD79FF
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 17:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbfJOPlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 11:41:52 -0400
Received: from mail-eopbgr790077.outbound.protection.outlook.com ([40.107.79.77]:33096
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727856AbfJOPlw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 11:41:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XX8TmqYZzSjqOTEK62eGj2JSJ2nEcbDn3z3l5P6niGnEBJtvsPaoEjcffrGumLgPjpoOct41DJ8jHFunQ0RSUmfoDuh4zJqcmO1BEcVpzNRp9RXSHYPQYDHLcfwuPad3ivYhTsuIx6j3hwUDtIJTzbqc/fInKXKvthsXF1buMuLAH+37wYOcEQKc5dlLF2+XySIITo9RXXqnh8L9UbBZwYSaxtcWCvkNgyze9aom5ty+UdkSFy+yuk5fnUdLvSwTU0xpJWvwEt5BZKB1lHyCU6iH4cgCwm92y1ac1qerN+xB/LFWEd5lZiLpUECpdoAoxPuu7IpCEhDdnADfijB5mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crP0OL9WJWxh6IBxExwHK1mggcxs7sz4wpZFADaDn7w=;
 b=iMec3w/DvxoKahOYLqaEiZDzkBvK/34wKnzluUsVGsGmxuXpCaxFczgAkqHTeL6FKgov9heaQ+5PA7QjmzGOaSr5cqv4Oss5Ujm9sltc1/zOgcCNdJNHcV7MdEKLzwiY+OxV+sXNunUCxpdqGBBaYAK1Lr5Gxqqqxl0dVgvjuyKiqlpdOvR/YWmaNdpQJfnT03j9UgrBPhyhGFuk7l5BRIjWDp0ZZvtAwezQyR4i8crjTCia8/vJozdoNqJA0T4LHuSphi6A0SF1JIh7Lp4kPQT7X36KhLNrMDnPcFr2FLzoDgH8GR8ODk8wVhubz9zDAtiymUw7ATO2nyv7CWMRAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crP0OL9WJWxh6IBxExwHK1mggcxs7sz4wpZFADaDn7w=;
 b=IUBGEj99KFkNGn/OMCxO5P1c6JIBXHtsUX3nXB4tUakD+RRVEq7I87We4RNu+3Hid853KOzgUvAOh3KOQpp/Kksopg6VFEjZAwvCbBbbLb/B36/QqrYeXC2oZCsjD30lHLih6u8JhAQWp1/n2IItx+pVCXxJDQ1L0ZDgeggbU+A=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3116.namprd12.prod.outlook.com (20.178.31.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Tue, 15 Oct 2019 15:41:49 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa%7]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 15:41:49 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     James Morse <james.morse@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Dave S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH net 2/2] amd-xgbe: Avoid sleeping in napi_disable()
 while holding a spinlock
Thread-Topic: [RFC PATCH net 2/2] amd-xgbe: Avoid sleeping in napi_disable()
 while holding a spinlock
Thread-Index: AQHVg19ahBU3wSwkJ02AdKQdl1EY9Kdb110A
Date:   Tue, 15 Oct 2019 15:41:49 +0000
Message-ID: <1dbc2c4b-6377-46c9-a9a2-4f453046cc9f@amd.com>
References: <20191015134911.231121-1-james.morse@arm.com>
 <20191015134911.231121-3-james.morse@arm.com>
In-Reply-To: <20191015134911.231121-3-james.morse@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0062.namprd12.prod.outlook.com
 (2603:10b6:802:20::33) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b65ed3f3-ade4-4f0a-23ef-08d75186317a
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM6PR12MB3116:
x-microsoft-antispam-prvs: <DM6PR12MB311608BEC58860F74A9AAECCEC930@DM6PR12MB3116.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(199004)(189003)(14444005)(2906002)(76176011)(256004)(31686004)(31696002)(386003)(8936002)(316002)(478600001)(3846002)(53546011)(6116002)(6506007)(6512007)(102836004)(81166006)(81156014)(52116002)(6246003)(4326008)(229853002)(8676002)(6436002)(25786009)(6486002)(446003)(476003)(11346002)(2616005)(486006)(5660300002)(186003)(99286004)(86362001)(305945005)(26005)(7736002)(71200400001)(71190400001)(110136005)(36756003)(14454004)(2501003)(64756008)(66556008)(66476007)(66946007)(66446008)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3116;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /eT5BSiUJQu0lgo5kpRlKdfYuT+nm1avItM3fc2HKezrDNL2GtJc80gp79DEueCosz7j5GPg2MziT3QhJlknjBaiuKdoAfgfn+8pcKvdlFjVQpQ5y54EYIrbVh9vLYQ0/1qHsMm5XS2eo+MUnS1jqy1bSVQcY6ev2bxpk7PGlrqVR7nKbVTbWo466ioOrSP+gpz3Cd8Wy7FueEMC5QsxIv55jJuk12FwoRfyXW5YBP9nSKgpbqsKqEOL4Xy6luD4qtaJfJQaZurC0oJEN4dLxFWLSKV3+Lmm6M5feDise3TcI+Bk431yiiALO3FBRFbn4mj2GUuvOhhnOMIHH8y60J9+3PH1NQQJh5Or492kbQCJ3vLGkG2+BIsCyEzrGqOsKR1sVfoKu0Zy7bRtRdQ18rSoHHNgVDqVvdMACaqMd1I=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <83935D6430ACE2479EA4D29C64EF3AED@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b65ed3f3-ade4-4f0a-23ef-08d75186317a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 15:41:49.5059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XUIaFCAvUmj3RG4MI8c/jZx3+UqjtDuC6TOxYQUEaKXNlAlHjR2J2+ME/cNaTJ/hLUr8NWBrvhBH3rGoWmZZ1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3116
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTUvMTkgODo0OSBBTSwgSmFtZXMgTW9yc2Ugd3JvdGU6DQo+IHhnYmVfcG93ZXJkb3du
KCkgdGFrZXMgYW4gaXJxc2F2ZSBzcGlubG9jaywgdGhlbiBjYWxscyBuYXBpX2Rpc2FibGUoKQ0K
PiB2aWEgeGdiZV9uYXBpX2Rpc2FibGUoKS4gbmFwaV9kaXNhYmxlKCkgbWlnaHQgY2FsbCBtc2xl
ZXAoKS4NCj4gREVCVUdfQVRPTUlDX1NMRUVQIGlzbid0IGhhcHB5IGFib3V0IHRoaXM6DQo+IHwg
QlVHOiBzbGVlcGluZyBmdW5jdGlvbiBjYWxsZWQgZnJvbSBpbnZhbGlkIGNvbnRleHQgYXQgLi4v
bmV0L2NvcmUvZGV2LmM6NjMzMg0KPiB8IGluX2F0b21pYygpOiAxLCBpcnFzX2Rpc2FibGVkKCk6
IDEyOCwgbm9uX2Jsb2NrOiAwLCBwaWQ6IDI4MzEsIG5hbWU6IGJhc2gNCj4gfCBDUFU6IDMgUElE
OiAyODMxIENvbW06IGJhc2ggVGFpbnRlZDogRyAgICAgICAgVyAgICAgICAgIDUuNC4wLXJjMy0w
MDAwMS1nOWRiZTc5M2YyNjNiICMxMTQNCj4gfCBIYXJkd2FyZSBuYW1lOiBBTUQgU2VhdHRsZSAo
UmV2LkIwKSBEZXZlbG9wbWVudCBCb2FyZCAoT3ZlcmRyaXZlKSAoRFQpDQo+IHwgQ2FsbCB0cmFj
ZToNCj4gfCAgZHVtcF9iYWNrdHJhY2UrMHgwLzB4MTYwDQo+IHwgIHNob3dfc3RhY2srMHgyNC8w
eDMwDQo+IHwgIGR1bXBfc3RhY2srMHhiMC8weGY4DQo+IHwgIF9fX21pZ2h0X3NsZWVwKzB4MTI0
LzB4MTQ4DQo+IHwgIF9fbWlnaHRfc2xlZXArMHg1NC8weDkwDQo+IHwgIG5hcGlfZGlzYWJsZSsw
eDQ4LzB4MTQwDQo+IHwgIHhnYmVfbmFwaV9kaXNhYmxlKzB4NjQvMHhjMA0KPiB8ICB4Z2JlX3Bv
d2VyZG93bisweGIwLzB4MTIwDQo+IHwgIHhnYmVfcGxhdGZvcm1fc3VzcGVuZCsweDM0LzB4ODAN
Cj4gfCAgcG1fZ2VuZXJpY19mcmVlemUrMHgzYy8weDU4DQo+IHwgIGFjcGlfc3Vic3lzX2ZyZWV6
ZSsweDJjLzB4MzgNCj4gfCAgZHBtX3J1bl9jYWxsYmFjaysweDNjLzB4MWU4DQo+IHwgIF9fZGV2
aWNlX3N1c3BlbmQrMHgxMzAvMHg0NjgNCj4gfCAgZHBtX3N1c3BlbmQrMHgxMTQvMHgzODgNCj4g
fCAgaGliZXJuYXRpb25fc25hcHNob3QrMHhlOC8weDM3OA0KPiB8ICBoaWJlcm5hdGUrMHgxOGMv
MHgyZjgNCj4gDQo+IE1vdmUgeGdiZV9uYXBpX2Rpc2FibGUoKSBvdXRzaWRlIHRoZSBzcGluX2xv
Y2soKWQgcmVnaW9uIG9mDQo+IHhnYmVfcG93ZXJkb3duKCkuIFRoaXMgbWF0Y2hlcyBpdHMgdXNl
IGluIHhnYmVfc3RvcCgpIC4uLiBidXQgdGhpcw0KPiBtaWdodCBvbmx5IGJlIHNhZmUgYmVjYXVz
ZSBvZiB0aGUgZWFybGllciBjYWxsIHRvIHhnYmVfZnJlZV9pcnFzKCkuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBKYW1lcyBNb3JzZSA8amFtZXMubW9yc2VAYXJtLmNvbT4NCj4gDQo+IC0tLQ0KPiBS
RkMgYXMgSSdtIG5vdCBmYW1pbGlhciB3aXRoIHRoaXMgZHJpdmVyLiBJJ20gaGFwcHkgdG8gdGVz
dCBhIGJldHRlciBmaXghDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1kL3hnYmUv
eGdiZS1kcnYuYyB8IDQgKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9h
bWQveGdiZS94Z2JlLWRydi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1kL3hnYmUveGdiZS1k
cnYuYw0KPiBpbmRleCBiZmJhN2VmZmNmOWYuLmE2ZTZjMjFlOTIxZiAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1kL3hnYmUveGdiZS1kcnYuYw0KPiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9hbWQveGdiZS94Z2JlLWRydi5jDQo+IEBAIC0xMjc4LDEwICsxMjc4LDEw
IEBAIGludCB4Z2JlX3Bvd2VyZG93bihzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCB1bnNpZ25l
ZCBpbnQgY2FsbGVyKQ0KPiAgCWh3X2lmLT5wb3dlcmRvd25fdHgocGRhdGEpOw0KPiAgCWh3X2lm
LT5wb3dlcmRvd25fcngocGRhdGEpOw0KPiAgDQo+IC0JeGdiZV9uYXBpX2Rpc2FibGUocGRhdGEs
IDApOw0KPiAtDQo+ICAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcGRhdGEtPmxvY2ssIGZsYWdz
KTsNCj4gIA0KPiArCXhnYmVfbmFwaV9kaXNhYmxlKHBkYXRhLCAwKTsNCj4gKw0KDQpBcyBmYXIg
YXMgSSBjYW4gdGVsbCwgSSB0aGluayB0aGlzIGlzIHNhZmUuIFdoZXRoZXIgaW5zaWRlIG9yIG91
dHNpZGUgdGhlDQpzcGlubG9jayBkb2Vzbid0IG1ha2UgYSBkaWZmZXJlbmNlIHRvIHRoZSBpbnRl
cnJ1cHQgcm91dGluZSBzaW5jZSBpdA0KZG9lc24ndCBhY3F1aXJlIHRoaXMgbG9jay4gQW5kIHRo
ZSBzdXNwZW5kL3Jlc3VtZSBmdW5jdGlvbnMgY2FuJ3QgYmUNCmNhbGxlZCBhdCB0aGUgc2FtZSB0
aW1lLg0KDQpUaGFua3MsDQpUb20NCg0KPiAgCURCR1BSKCI8LS14Z2JlX3Bvd2VyZG93blxuIik7
DQo+ICANCj4gIAlyZXR1cm4gMDsNCj4gDQo=
