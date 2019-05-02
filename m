Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78021175B
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 12:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfEBKgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 06:36:33 -0400
Received: from mail-eopbgr820081.outbound.protection.outlook.com ([40.107.82.81]:64640
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726231AbfEBKgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 06:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L40Qc+zMat3uNEKq4ePQ2mqCdXjJ4Y1Njlshcn/ZTio=;
 b=KQrnPe55g3nyuZud6KqHH6HsuPH1Nq9qAgZ4Q9u8XWo6zmhr48869C+2aBuyTFtekiRYeFNJh/x+zdUTQDaRUO4ZSiaHkjc+1Mkezqu3AaX0QgX6wBgwrcIUKbLV1fovz6sA4tsO9IuhhH6s6gFPvjWXX2rqjVulHH91NMz0aDo=
Received: from BN8PR10MB3540.namprd10.prod.outlook.com (20.179.78.205) by
 BN8PR10MB3314.namprd10.prod.outlook.com (20.179.139.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Thu, 2 May 2019 10:36:30 +0000
Received: from BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::24c5:ea68:cff3:4a16]) by BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::24c5:ea68:cff3:4a16%7]) with mapi id 15.20.1856.008; Thu, 2 May 2019
 10:36:30 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "madalin.bucur@nxp.com" <madalin.bucur@nxp.com>,
        "leoyang.li@nxp.com" <leoyang.li@nxp.com>,
        "laurentiu.tudor@nxp.com" <laurentiu.tudor@nxp.com>,
        "roy.pledge@nxp.com" <roy.pledge@nxp.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH v2 9/9] dpaa_eth: fix SG frame cleanup
Thread-Topic: [PATCH v2 9/9] dpaa_eth: fix SG frame cleanup
Thread-Index: AQHU/MpTw42IuR0fykCaI1+07jqDiqZQPr+AgAdUG4CAABlegA==
Date:   Thu, 2 May 2019 10:36:30 +0000
Message-ID: <728fe477849debcc14bb1af01e35bc7b184a0a03.camel@infinera.com>
References: <20190427071031.6563-1-laurentiu.tudor@nxp.com>
         <20190427071031.6563-10-laurentiu.tudor@nxp.com>
         <2c6f5d170edab346e0a87b1dfeb12e2f65801685.camel@infinera.com>
         <VI1PR04MB5134C0D6707E78D674B96898EC340@VI1PR04MB5134.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB5134C0D6707E78D674B96898EC340@VI1PR04MB5134.eurprd04.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joakim.Tjernlund@infinera.com; 
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59f6c7b0-0605-4284-c375-08d6ceea0a1b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BN8PR10MB3314;
x-ms-traffictypediagnostic: BN8PR10MB3314:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BN8PR10MB3314BDAF20A30D8A5603C850F4340@BN8PR10MB3314.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0025434D2D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(366004)(396003)(346002)(376002)(189003)(199004)(13464003)(316002)(118296001)(186003)(6246003)(11346002)(305945005)(66476007)(73956011)(2616005)(64756008)(66446008)(66946007)(66556008)(53936002)(91956017)(76116006)(446003)(476003)(486006)(66066001)(3846002)(6486002)(71190400001)(71200400001)(86362001)(6436002)(6116002)(5660300002)(2201001)(229853002)(966005)(14444005)(8676002)(6306002)(256004)(68736007)(54906003)(110136005)(8936002)(81166006)(81156014)(7736002)(6512007)(7416002)(4326008)(36756003)(25786009)(102836004)(6506007)(76176011)(72206003)(2501003)(2906002)(14454004)(478600001)(99286004)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR10MB3314;H:BN8PR10MB3540.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: infinera.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: z1YXU6qwY4gFgNMUgdv6tNcgJcx0akvl9NOnrooCO3wJkEL7lQLeI1wnPht93EPWP+t9WGumHzcxkq2D+4fIhxol5Dbgnql+M/m4y99DaKVSRDuuxMwzdMomXay/IIumcWZtmioQoZTP8rvtcjGgGmBNBsY44L4si3ob6rp+30XdbWjpEqRP72UYTOAkMPmh1I/aGLTHs2kgpD7JWWynf3zXQyXfKshyUn2Ki09g6LCDvlMIyCj2jy2A08ThRHYyfc9Mb4YKvTjMEGrbm2/Pk+PCsEyv9Fm1Oh9KARKFPgJlp5AR7cJUPoIasqudgADddZWTBCd3BBsI/PH40QugrjH+asTGdGXS3cOqzr42unqcD3DreaOrx3Fo9jPyBnoo5DDbaj4Wa3BqGdCf6Om+TLuzmsqx0/zwODN6xP1DLpc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F9602CDEA854A469D9C83B5DEC64BBA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f6c7b0-0605-4284-c375-08d6ceea0a1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2019 10:36:30.5005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3314
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA1LTAyIGF0IDA5OjA1ICswMDAwLCBMYXVyZW50aXUgVHVkb3Igd3JvdGU6
DQo+IEhpIEpvYWtpbSwNCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBG
cm9tOiBKb2FraW0gVGplcm5sdW5kIDxKb2FraW0uVGplcm5sdW5kQGluZmluZXJhLmNvbT4NCj4g
PiBTZW50OiBTYXR1cmRheSwgQXByaWwgMjcsIDIwMTkgODoxMSBQTQ0KPiA+IA0KPiA+IE9uIFNh
dCwgMjAxOS0wNC0yNyBhdCAxMDoxMCArMDMwMCwgbGF1cmVudGl1LnR1ZG9yQG54cC5jb20gd3Jv
dGU6DQo+ID4gPiBGcm9tOiBMYXVyZW50aXUgVHVkb3IgPGxhdXJlbnRpdS50dWRvckBueHAuY29t
Pg0KPiA+ID4gDQo+ID4gPiBGaXggaXNzdWUgd2l0aCB0aGUgZW50cnkgaW5kZXhpbmcgaW4gdGhl
IHNnIGZyYW1lIGNsZWFudXAgY29kZSBiZWluZw0KPiA+ID4gb2ZmLWJ5LTEuIFRoaXMgcHJvYmxl
bSBzaG93ZWQgdXAgd2hlbiBkb2luZyBzb21lIGJhc2ljIGlwZXJmIHRlc3RzIGFuZA0KPiA+ID4g
bWFuaWZlc3RlZCBpbiB0cmFmZmljIGNvbWluZyB0byBhIGhhbHQuDQo+ID4gPiANCj4gPiA+IFNp
Z25lZC1vZmYtYnk6IExhdXJlbnRpdSBUdWRvciA8bGF1cmVudGl1LnR1ZG9yQG54cC5jb20+DQo+
ID4gPiBBY2tlZC1ieTogTWFkYWxpbiBCdWN1ciA8bWFkYWxpbi5idWN1ckBueHAuY29tPg0KPiA+
IA0KPiA+IFdhc24ndCB0aGlzIGEgc3RhYmxlIGNhbmRpZGF0ZSB0b28/DQo+IA0KPiBZZXMsIGl0
IGlzLiBJIGZvcmdvdCB0byBhZGQgdGhlIGNjOnN0YWJsZSB0YWcsIHNvcnJ5IGFib3V0IHRoYXQu
DQoNClRoZW4gdGhpcyBpcyBhIGJ1ZyBmaXggdGhhdCBzaG91bGQgZ28gZGlyZWN0bHkgdG8gbGlu
dXMvc3RhYmxlLg0KDQpJIG5vdGUgdGhhdCBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9zdGFibGUvbGludXguZ2l0L2xvZy9kcml2ZXJzL25ldC9ldGhlcm5l
dC9mcmVlc2NhbGUvZHBhYT9oPWxpbnV4LTQuMTkueQ0KaXMgaW4gNC4xOSBidXQgbm90IGluIDQu
MTQgLCBpcyBpdCBub3QgYXBwcm9wcmlhdGUgZm9yIDQuMTQ/DQoNCiBKb2NrZQ0KDQo+IA0KPiAt
LS0NCj4gQmVzdCBSZWdhcmRzLCBMYXVyZW50aXUNCj4gDQo+ID4gPiAtLS0NCj4gPiA+ICBkcml2
ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFhX2V0aC5jIHwgMiArLQ0KPiA+ID4g
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gDQo+
ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEvZHBh
YV9ldGguYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEvZHBhYV9l
dGguYw0KPiA+ID4gaW5kZXggZGFlZGU3MjcyNzY4Li40MDQyMGVkYzljZTYgMTAwNjQ0DQo+ID4g
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFhX2V0aC5jDQo+
ID4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFhX2V0aC5j
DQo+ID4gPiBAQCAtMTY2Myw3ICsxNjYzLDcgQEAgc3RhdGljIHN0cnVjdCBza19idWZmICpkcGFh
X2NsZWFudXBfdHhfZmQoY29uc3QNCj4gPiBzdHJ1Y3QgZHBhYV9wcml2ICpwcml2LA0KPiA+ID4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcW1fc2dfZW50cnlfZ2V0X2xlbigmc2d0
WzBdKSwgZG1hX2Rpcik7DQo+ID4gPiANCj4gPiA+ICAgICAgICAgICAgICAgICAvKiByZW1haW5p
bmcgcGFnZXMgd2VyZSBtYXBwZWQgd2l0aCBza2JfZnJhZ19kbWFfbWFwKCkNCj4gPiAqLw0KPiA+
ID4gLSAgICAgICAgICAgICAgIGZvciAoaSA9IDE7IGkgPCBucl9mcmFnczsgaSsrKSB7DQo+ID4g
PiArICAgICAgICAgICAgICAgZm9yIChpID0gMTsgaSA8PSBucl9mcmFnczsgaSsrKSB7DQo+ID4g
PiAgICAgICAgICAgICAgICAgICAgICAgICBXQVJOX09OKHFtX3NnX2VudHJ5X2lzX2V4dCgmc2d0
W2ldKSk7DQo+ID4gPiANCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGRtYV91bm1hcF9w
YWdlKGRldiwgcW1fc2dfYWRkcigmc2d0W2ldKSwNCj4gPiA+IC0tDQo+ID4gPiAyLjE3LjENCj4g
PiA+IA0K
