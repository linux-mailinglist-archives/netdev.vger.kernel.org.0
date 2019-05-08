Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44ECD172D0
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 09:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfEHHsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 03:48:06 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:20547
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726835AbfEHHsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 03:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1y9wsMOxo81ylIB2DbAFnZamnOUKFuK0JbOkf/31owc=;
 b=H6h6Z3Wmcy5KfES7J+/9V8pTzIc4Wv+lsk1M/vBw2Z9RNeOqRuYy00MCWvc3O6fpg7tSFo397g8wZaDlNgB1uDh6PapdqpFU2zPsRc2przii+F1iIrelL4VJlAmMzxku3ZfUHlb/I27llpsbSNY1S0+0OiJ36KRbcguMqgP3Fyg=
Received: from HE1PR05MB3257.eurprd05.prod.outlook.com (10.170.243.19) by
 HE1PR05MB3292.eurprd05.prod.outlook.com (10.170.243.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Wed, 8 May 2019 07:48:00 +0000
Received: from HE1PR05MB3257.eurprd05.prod.outlook.com
 ([fe80::3925:eb82:b9fb:5621]) by HE1PR05MB3257.eurprd05.prod.outlook.com
 ([fe80::3925:eb82:b9fb:5621%4]) with mapi id 15.20.1856.012; Wed, 8 May 2019
 07:48:00 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next 1/2] net: Take common prefetch code structure
 into a function
Thread-Topic: [PATCH net-next 1/2] net: Take common prefetch code structure
 into a function
Thread-Index: AQHVAy5s1wNYdeaXF06xxm1purIlqaZexwOAgACsZICAAWruAA==
Date:   Wed, 8 May 2019 07:48:00 +0000
Message-ID: <bfc82029-8b74-26f5-35db-034cda3836ad@mellanox.com>
References: <1557052567-31827-1-git-send-email-tariqt@mellanox.com>
 <1557052567-31827-2-git-send-email-tariqt@mellanox.com>
 <20190506165157.6e0f04e6@cakuba.hsd1.ca.comcast.net>
 <20190507120857.5975c059@carbon>
In-Reply-To: <20190507120857.5975c059@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0044.eurprd05.prod.outlook.com
 (2603:10a6:208:be::21) To HE1PR05MB3257.eurprd05.prod.outlook.com
 (2603:10a6:7:35::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.127.110.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc3c4729-3f66-46f0-e16e-08d6d3897e38
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:HE1PR05MB3292;
x-ms-traffictypediagnostic: HE1PR05MB3292:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <HE1PR05MB32925F5DD9BB5650F2C817D2AE320@HE1PR05MB3292.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0031A0FFAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(136003)(376002)(346002)(189003)(199004)(6486002)(26005)(66946007)(53936002)(73956011)(478600001)(486006)(476003)(6246003)(2906002)(316002)(53546011)(81166006)(4326008)(14444005)(229853002)(81156014)(186003)(8936002)(3846002)(6306002)(2616005)(102836004)(386003)(6506007)(256004)(25786009)(6116002)(446003)(66066001)(71200400001)(64756008)(99286004)(66446008)(86362001)(66476007)(66556008)(71190400001)(11346002)(6436002)(68736007)(52116002)(54906003)(110136005)(8676002)(6512007)(31686004)(5660300002)(31696002)(966005)(7736002)(14454004)(36756003)(305945005)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3292;H:HE1PR05MB3257.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yVrpxJP6VRIa8wlJmPINiNzwGM60HTsyKauVogFunV/nQxlnFeT7S+7MfalU3ZeIJ4npDmYm1TJMzIK2z+XRafusxxESyJQ6cH665de4YQMu4gdbPflPY/YVnYeHL20NxVkdW4aOOcHKMAKvY+yvlDh11ih/wuPwcSGyxEX64GTdgd2U3wZOZsCnXBjd5Z7S1EGXdsV1rJO1yKZOeFgZRLMRiOs5E0PJhkfAmy9vhAF5S2hPa1mWgV6kAH7bLiaIFLIXaWsSCnZ7ggw3FKfV3RaRCcWuby5jqlHYuBaOKBR1yyMhf3/ga712CeLdgBRorBcbudN4Dk/JKvCwQ/PyeuJWUQWwlv0/mpHWrV2PohCZzZHmACPFB+q/as4utr9mOvsABl5Os3Zb0DQd3W+4ROWULcxUXGGKsEmnDV0p8HQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A3AF1DDDE22AC408015179A5F5093C1@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc3c4729-3f66-46f0-e16e-08d6d3897e38
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2019 07:48:00.4773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3292
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvNy8yMDE5IDE6MDggUE0sIEplc3BlciBEYW5nYWFyZCBCcm91ZXIgd3JvdGU6DQo+
IE9uIE1vbiwgNiBNYXkgMjAxOSAxNjo1MTo1NyAtMDcwMA0KPiBKYWt1YiBLaWNpbnNraSA8amFr
dWIua2ljaW5za2lAbmV0cm9ub21lLmNvbT4gd3JvdGU6DQo+IA0KPj4gT24gU3VuLCAgNSBNYXkg
MjAxOSAxMzozNjowNiArMDMwMCwgVGFyaXEgVG91a2FuIHdyb3RlOg0KPj4+IE1hbnkgZGV2aWNl
IGRyaXZlcnMgdXNlIHRoZSBzYW1lIHByZWZldGNoIGNvZGUgc3RydWN0dXJlIHRvDQo+Pj4gZGVh
bCB3aXRoIHNtYWxsIEwxIGNhY2hlbGluZSBzaXplLg0KPj4+IFRha2UgdGhpcyBjb2RlIGludG8g
YSBmdW5jdGlvbiBhbmQgY2FsbCBpdCBmcm9tIHRoZSBkcml2ZXJzLg0KPj4+DQo+Pj4gU3VnZ2Vz
dGVkLWJ5OiBKYWt1YiBLaWNpbnNraSA8amFrdWIua2ljaW5za2lAbmV0cm9ub21lLmNvbT4NCj4+
PiBTaWduZWQtb2ZmLWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBtZWxsYW5veC5jb20+DQo+Pj4g
UmV2aWV3ZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPj4+IENj
OiBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIDxicm91ZXJAcmVkaGF0LmNvbT4NCj4+DQo+PiBXZSBj
b3VsZCBiaWtlIHNoZWQgb24gdGhlIG5hbWUgYSBsaXR0bGUgLSBuZXRfcHJlZmV0Y2hfaGVhZGVy
cygpID8NCj4+IGJ1dCBhdCBsZWFzdCBhIHNob3J0IGtkb2MgZXhwbGFuYXRpb24gZm9yIHRoZSBw
dXJwb3NlIG9mIHRoaXMgaGVscGVyDQo+PiB3b3VsZCBiZSBnb29kIElNSE8uDQo+IA0KPiBJIHdv
dWxkIGF0IGxlYXN0IGltcHJvdmUgdGhlIGNvbW1pdCBtZXNzYWdlLiAgQXMgQWxleGFuZGVyIHNv
IG5pY2VseQ0KPiBleHBsYWluZWRbMV0sIHRoaXMgcHJlZmV0Y2ggcHVycG9zZTogInRoZSAyIHBy
ZWZldGNoZXMgYXJlIG5lZWRlZCBmb3IgeDg2DQo+IGlmIHlvdSB3YW50IGEgZnVsbCBUQ1Agb3Ig
SVB2NiBoZWFkZXIgcHVsbGVkIGludG8gdGhlIEwxIGNhY2hlIGZvcg0KPiBpbnN0YW5jZS4iICBB
bHRob3VnaCwgdGhpcyBpcyBub3QgdHJ1ZSBmb3IgYSBtaW5pbXVtIFRDUC1wYWNrZXQNCj4gRXRo
KDE0KStJUCgyMCkrVENQKDIwKT01NCBieXRlcy4gQW4gSSBtaXNzaW5nIGFuIGFsaWdubWVudCBp
biBteSBjYWxjPw0KPiANCj4gWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi9DQUtn
VDBVZUVMM1c0MmVEcVN0OTd4bm4zdFhEdFdNZjRzZFBCeUF0dmJ4PVo3U3g3aFFAbWFpbC5nbWFp
bC5jb20vDQo+IA0KPiBUaGUgbmFtZSBuZXRfcHJlZmV0Y2hfaGVhZGVycygpIHN1Z2dlc3RlZCBi
eSBKYWt1YiBtYWtlcyBzZW5zZSwgYXMgdGhpcw0KPiBpbmRpY2F0ZSB0aGF0IHRoaXMgc2hvdWxk
IGJlIHVzZWQgZm9yIHByZWZldGNoaW5nIHBhY2tldCBoZWFkZXJzLg0KPiANCj4gQXMgQWxleGFu
ZGVyIGFsc28gZXhwbGFpbmVkLCBJIHdhcyB3cm9uZyBpbiB0aGlua2luZyB0aGUgSFcgRENVIChE
YXRhDQo+IENhY2hlIFVuaXQpIHByZWZldGNoZXIgd2lsbCBmZXRjaCB0d28gY2FjaGUtbGluZXMg
YXV0b21hdGljYWxseS4gIEFzDQo+IHRoZSBEQ1UgcHJlZmV0Y2hlciBpcyBhIHN0cmVhbWluZyBw
cmVmZXRjaGVyLCBhbmQgZG9lc24ndCBzZWUgb3VyDQo+IGFjY2VzcyBwYXR0ZXJuLCB3aGljaCBp
cyB3aHkgd2UgbmVlZCB0aGlzLg0KPiANCg0KVGhhbmtzIGFsbCBmb3IgeW91ciBjb21tZW50cy4N
Ckkgd2lsbCBmaXggYW5kIHJlLXNwaW4gb25jZSB0aGUgd2luZG93IHJlLW9wZW5zLg0KDQpUYXJp
cQ0K
