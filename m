Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B094744C
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 12:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfFPK4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 06:56:32 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:54891
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725947AbfFPK4c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jun 2019 06:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/41upEIg4gxMnPIn3AMuMnym0H3TXoCR39nju8ceKI=;
 b=YC2TZ28MQLRUXluqd7BUpvcWHZ6+/nkSZ4mDQu6PZnimLi+0mdR5PTdjjpxzwdguSfgC0cMmeQZX8r0VPMOx3b0S5CxjDPfoeUS9cRT+pCkYhO/RFyKt9gCW05a/jzjdIQjEJhyAb32fi5ov5zIjBQlBdJfeXGP2DyZ7eMOeMc0=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6587.eurprd05.prod.outlook.com (20.179.44.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Sun, 16 Jun 2019 10:56:25 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::50a0:251f:78ce:22c6]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::50a0:251f:78ce:22c6%6]) with mapi id 15.20.1987.014; Sun, 16 Jun 2019
 10:56:25 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        "toshiaki.makita1@gmail.com" <toshiaki.makita1@gmail.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "mcroce@redhat.com" <mcroce@redhat.com>
Subject: Re: [PATCH net-next v1 08/11] xdp: tracking page_pool resources and
 safe removal
Thread-Topic: [PATCH net-next v1 08/11] xdp: tracking page_pool resources and
 safe removal
Thread-Index: AQHVIhXWdZkOZdDdRUWI7Q95acedPaacdqgAgAGpcAA=
Date:   Sun, 16 Jun 2019 10:56:25 +0000
Message-ID: <a02856c1-46e7-4691-6bb9-e0efb388981f@mellanox.com>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
 <156045052249.29115.2357668905441684019.stgit@firesoul>
 <20190615093339.GB3771@khorivan>
In-Reply-To: <20190615093339.GB3771@khorivan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P192CA0002.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::15) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90daf94d-4a48-4256-897f-08d6f24946d5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6587;
x-ms-traffictypediagnostic: DBBPR05MB6587:
x-microsoft-antispam-prvs: <DBBPR05MB65870C70E8ABD00E912AB59CAEE80@DBBPR05MB6587.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0070A8666B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(396003)(39860400002)(366004)(189003)(199004)(31696002)(81156014)(86362001)(6506007)(4326008)(386003)(81166006)(8936002)(53936002)(52116002)(2906002)(5660300002)(53546011)(102836004)(8676002)(110136005)(25786009)(6436002)(54906003)(99286004)(229853002)(6486002)(6246003)(76176011)(31686004)(6512007)(305945005)(316002)(486006)(71200400001)(73956011)(66476007)(66556008)(64756008)(7736002)(66946007)(66446008)(26005)(14454004)(478600001)(256004)(11346002)(446003)(6116002)(476003)(3846002)(68736007)(2616005)(36756003)(71190400001)(66066001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6587;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6tYBlIb0enyaTlZ3MczWWw+CseMuy/ZgBM4lBFh3ewrjH2eYndIAfQ/pfAQiyJfWnOOe+JSl72/D6TMNiOZuVlAe/jL3ywurM6ygSlkDK7KsShCjYzrUBib4efT0Npz590SnfRZOsC7REpCmpgVV5S0WxGihEp86BH/lU8Xldcruk6i5WN8BT9yrBgRmaziWj0n4sXfm85fCdi1ZWni/4Ys0RWVnRShUkPfx3K6bwV5wiYjw8aHeCizS7dOBxN1RerMQfqlKx90rXtgY//qra7jLMgKn5ll2rSt5dfEZ3arXshj7GS6JRU+deBa3UymBSOAqAAhgt3JJ6KQV1tExAA6vg1HODLxxAy8ViWsZf9Iwqsh4H8SiZNxNdQSxuphmuHCxREHic/19Q/+Ot4kPGdcmYY2D6QaHGngaSKXXZoQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE1DFFF11F644440990831894FCC149C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90daf94d-4a48-4256-897f-08d6f24946d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2019 10:56:25.7266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6587
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMTUvMjAxOSAxMjozMyBQTSwgSXZhbiBLaG9yb256aHVrIHdyb3RlOg0KPiBPbiBU
aHUsIEp1biAxMywgMjAxOSBhdCAwODoyODo0MlBNICswMjAwLCBKZXNwZXIgRGFuZ2FhcmQgQnJv
dWVyIHdyb3RlOg0KPiBIaSwgSmVzcGVyDQo+IA0KPj4gVGhpcyBwYXRjaCBpcyBuZWVkZWQgYmVm
b3JlIHdlIGNhbiBhbGxvdyBkcml2ZXJzIHRvIHVzZSBwYWdlX3Bvb2wgZm9yDQo+PiBETUEtbWFw
cGluZ3MuIFRvZGF5IHdpdGggcGFnZV9wb29sIGFuZCBYRFAgcmV0dXJuIEFQSSwgaXQgaXMgcG9z
c2libGUgdG8NCj4+IHJlbW92ZSB0aGUgcGFnZV9wb29sIG9iamVjdCAoZnJvbSByaGFzaHRhYmxl
KSwgd2hpbGUgdGhlcmUgYXJlIHN0aWxsDQo+PiBpbi1mbGlnaHQgcGFja2V0LXBhZ2VzLiBUaGlz
IGlzIHNhZmVseSBoYW5kbGVkIHZpYSBSQ1UgYW5kIGZhaWxlZCANCj4+IGxvb2t1cHMgaW4NCj4+
IF9feGRwX3JldHVybigpIGZhbGxiYWNrIHRvIGNhbGwgcHV0X3BhZ2UoKSwgd2hlbiBwYWdlX3Bv
b2wgb2JqZWN0IGlzIA0KPj4gZ29uZS4NCj4+IEluLWNhc2UgcGFnZSBpcyBzdGlsbCBETUEgbWFw
cGVkLCB0aGlzIHdpbGwgcmVzdWx0IGluIHBhZ2Ugbm90ZSBnZXR0aW5nDQo+PiBjb3JyZWN0bHkg
RE1BIHVubWFwcGVkLg0KPj4NCj4+IFRvIHNvbHZlIHRoaXMsIHRoZSBwYWdlX3Bvb2wgaXMgZXh0
ZW5kZWQgd2l0aCB0cmFja2luZyBpbi1mbGlnaHQgDQo+PiBwYWdlcy4gQW5kDQo+PiBYRFAgZGlz
Y29ubmVjdCBzeXN0ZW0gcXVlcmllcyBwYWdlX3Bvb2wgYW5kIHdhaXRzLCB2aWEgd29ya3F1ZXVl
LCBmb3IgYWxsDQo+PiBpbi1mbGlnaHQgcGFnZXMgdG8gYmUgcmV0dXJuZWQuDQo+Pg0KPj4gVG8g
YXZvaWQga2lsbGluZyBwZXJmb3JtYW5jZSB3aGVuIHRyYWNraW5nIGluLWZsaWdodCBwYWdlcywg
dGhlIGltcGxlbWVudA0KPj4gdXNlIHR3byAodW5zaWduZWQpIGNvdW50ZXJzLCB0aGF0IGluIHBs
YWNlZCBvbiBkaWZmZXJlbnQgY2FjaGUtbGluZXMsIGFuZA0KPj4gY2FuIGJlIHVzZWQgdG8gZGVk
dWN0IGluLWZsaWdodCBwYWNrZXRzLiBUaGlzIGlzIGRvbmUgYnkgbWFwcGluZyB0aGUNCj4+IHVu
c2lnbmVkICJzZXF1ZW5jZSIgY291bnRlcnMgb250byBzaWduZWQgVHdvJ3MgY29tcGxlbWVudCBh
cml0aG1ldGljDQo+PiBvcGVyYXRpb25zLiBUaGlzIGlzIGUuZy4gdXNlZCBieSBrZXJuZWwncyB0
aW1lX2FmdGVyIG1hY3JvcywgZGVzY3JpYmVkIGluDQo+PiBrZXJuZWwgY29tbWl0IDFiYTNhYWIz
MDMzYiBhbmQgNWE1ODFiMzY3YjUsIGFuZCBhbHNvIGV4cGxhaW5lZCBpbiANCj4+IFJGQzE5ODIu
DQo+Pg0KPj4gVGhlIHRyaWNrIGlzIHRoZXNlIHR3byBpbmNyZW1lbnRpbmcgY291bnRlcnMgb25s
eSBuZWVkIHRvIGJlIHJlYWQgYW5kDQo+PiBjb21wYXJlZCwgd2hlbiBjaGVja2luZyBpZiBpdCdz
IHNhZmUgdG8gZnJlZSB0aGUgcGFnZV9wb29sIHN0cnVjdHVyZS4gDQo+PiBXaGljaA0KPj4gd2ls
bCBvbmx5IGhhcHBlbiB3aGVuIGRyaXZlciBoYXZlIGRpc2Nvbm5lY3RlZCBSWC9hbGxvYyBzaWRl
LiBUaHVzLCBvbiBhDQo+PiBub24tZmFzdC1wYXRoLg0KPj4NCj4+IEl0IGlzIGNob3NlbiB0aGF0
IHBhZ2VfcG9vbCB0cmFja2luZyBpcyBhbHNvIGVuYWJsZWQgZm9yIHRoZSBub24tRE1BDQo+PiB1
c2UtY2FzZSwgYXMgdGhpcyBjYW4gYmUgdXNlZCBmb3Igc3RhdGlzdGljcyBsYXRlci4NCj4+DQo+
PiBBZnRlciB0aGlzIHBhdGNoLCB1c2luZyBwYWdlX3Bvb2wgcmVxdWlyZXMgbW9yZSBzdHJpY3Qg
cmVzb3VyY2UgDQo+PiAicmVsZWFzZSIsDQo+PiBlLmcuIHZpYSBwYWdlX3Bvb2xfcmVsZWFzZV9w
YWdlKCkgdGhhdCB3YXMgaW50cm9kdWNlZCBpbiB0aGlzIA0KPj4gcGF0Y2hzZXQsIGFuZA0KPj4g
cHJldmlvdXMgcGF0Y2hlcyBpbXBsZW1lbnQvZml4IHRoaXMgbW9yZSBzdHJpY3QgcmVxdWlyZW1l
bnQuDQo+Pg0KPj4gRHJpdmVycyBuby1sb25nZXIgY2FsbCBwYWdlX3Bvb2xfZGVzdHJveSgpLiBE
cml2ZXJzIGFscmVhZHkgY2FsbA0KPj4geGRwX3J4cV9pbmZvX3VucmVnKCkgd2hpY2ggY2FsbCB4
ZHBfcnhxX2luZm9fdW5yZWdfbWVtX21vZGVsKCksIHdoaWNoIA0KPj4gd2lsbA0KPj4gYXR0ZW1w
dCB0byBkaXNjb25uZWN0IHRoZSBtZW0gaWQsIGFuZCBpZiBhdHRlbXB0IGZhaWxzIHNjaGVkdWxl
IHRoZQ0KPj4gZGlzY29ubmVjdCBmb3IgbGF0ZXIgdmlhIGRlbGF5ZWQgd29ya3F1ZXVlLg0KPj4N
Cj4+IFNpZ25lZC1vZmYtYnk6IEplc3BlciBEYW5nYWFyZCBCcm91ZXIgPGJyb3VlckByZWRoYXQu
Y29tPg0KPj4gLS0tDQo+PiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW5fbWFpbi5jIHzCoMKgwqAgMyAtDQo+PiBpbmNsdWRlL25ldC9wYWdlX3Bvb2wuaMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAgNDEgKysr
KysrKysrKy0tLQ0KPj4gbmV0L2NvcmUvcGFnZV9wb29sLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgIDYyIA0KPj4gKysrKysr
KysrKysrKysrLS0tLS0NCj4+IG5ldC9jb3JlL3hkcC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoCA2NSAN
Cj4+ICsrKysrKysrKysrKysrKysrKystLQ0KPj4gNCBmaWxlcyBjaGFuZ2VkLCAxMzYgaW5zZXJ0
aW9ucygrKSwgMzUgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMgDQo+PiBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMNCj4+IGluZGV4IDJmNjQ3YmUy
OTJiNi4uNmM5ZDRkN2RlZmJjIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KPiANCj4gWy4uLl0NCj4gDQo+PiAtLS0g
YS9uZXQvY29yZS94ZHAuYw0KPj4gKysrIGIvbmV0L2NvcmUveGRwLmMNCj4+IEBAIC0zOCw2ICsz
OCw3IEBAIHN0cnVjdCB4ZHBfbWVtX2FsbG9jYXRvciB7DQo+PiDCoMKgwqDCoH07DQo+PiDCoMKg
wqDCoHN0cnVjdCByaGFzaF9oZWFkIG5vZGU7DQo+PiDCoMKgwqDCoHN0cnVjdCByY3VfaGVhZCBy
Y3U7DQo+PiArwqDCoMKgIHN0cnVjdCBkZWxheWVkX3dvcmsgZGVmZXJfd3E7DQo+PiB9Ow0KPj4N
Cj4+IHN0YXRpYyB1MzIgeGRwX21lbV9pZF9oYXNoZm4oY29uc3Qgdm9pZCAqZGF0YSwgdTMyIGxl
biwgdTMyIHNlZWQpDQo+PiBAQCAtNzksMTMgKzgwLDEzIEBAIHN0YXRpYyB2b2lkIF9feGRwX21l
bV9hbGxvY2F0b3JfcmN1X2ZyZWUoc3RydWN0IA0KPj4gcmN1X2hlYWQgKnJjdSkNCj4+DQo+PiDC
oMKgwqDCoHhhID0gY29udGFpbmVyX29mKHJjdSwgc3RydWN0IHhkcF9tZW1fYWxsb2NhdG9yLCBy
Y3UpOw0KPj4NCj4+ICvCoMKgwqAgLyogQWxsb2NhdG9yIGhhdmUgaW5kaWNhdGVkIHNhZmUgdG8g
cmVtb3ZlIGJlZm9yZSB0aGlzIGlzIGNhbGxlZCAqLw0KPj4gK8KgwqDCoCBpZiAoeGEtPm1lbS50
eXBlID09IE1FTV9UWVBFX1BBR0VfUE9PTCkNCj4+ICvCoMKgwqDCoMKgwqDCoCBwYWdlX3Bvb2xf
ZnJlZSh4YS0+cGFnZV9wb29sKTsNCj4+ICsNCj4gDQo+IFdoYXQgd291bGQgeW91IHJlY29tbWVu
ZCB0byBkbyBmb3IgdGhlIGZvbGxvd2luZyBzaXR1YXRpb246DQo+IA0KPiBTYW1lIHJlY2VpdmUg
cXVldWUgaXMgc2hhcmVkIGJldHdlZW4gMiBuZXR3b3JrIGRldmljZXMuIFRoZSByZWNlaXZlIHJp
bmcgaXMNCj4gZmlsbGVkIGJ5IHBhZ2VzIGZyb20gcGFnZV9wb29sLCBidXQgeW91IGRvbid0IGtu
b3cgdGhlIGFjdHVhbCBwb3J0IChuZGV2KQ0KPiBmaWxsaW5nIHRoaXMgcmluZywgYmVjYXVzZSBh
IGRldmljZSBpcyByZWNvZ25pemVkIG9ubHkgYWZ0ZXIgcGFja2V0IGlzIA0KPiByZWNlaXZlZC4N
Cj4gDQo+IFRoZSBBUEkgaXMgc28gdGhhdCB4ZHAgcnhxIGlzIGJpbmQgdG8gbmV0d29yayBkZXZp
Y2UsIGVhY2ggZnJhbWUgaGFzIA0KPiByZWZlcmVuY2UNCj4gb24gaXQsIHNvIHJ4cSBuZGV2IG11
c3QgYmUgc3RhdGljLiBUaGF0IG1lYW5zIGVhY2ggbmV0ZGV2IGhhcyBpdCdzIG93biByeHENCj4g
aW5zdGFuY2UgZXZlbiBubyBuZWVkIGluIGl0LiBUaHVzLCBhZnRlciB5b3VyIGNoYW5nZXMsIHBh
Z2UgbXVzdCBiZSANCj4gcmV0dXJuZWQgdG8NCj4gdGhlIHBvb2wgaXQgd2FzIHRha2VuIGZyb20s
IG9yIHJlbGVhc2VkIGZyb20gb2xkIHBvb2wgYW5kIHJlY3ljbGVkIGluIA0KPiBuZXcgb25lDQo+
IHNvbWVob3cuDQo+IA0KPiBBbmQgdGhhdCBpcyBpbmNvbnZlbmllbmNlIGF0IGxlYXN0LiBJdCdz
IGhhcmQgdG8gbW92ZSBwYWdlcyBiZXR3ZWVuIA0KPiBwb29scyB3L28NCj4gcGVyZm9ybWFuY2Ug
cGVuYWx0eS4gTm8gd2F5IHRvIHVzZSBjb21tb24gcG9vbCBlaXRoZXIsIGFzIHVucmVnX3J4cSBu
b3cgDQo+IGRyb3BzDQo+IHRoZSBwb29sIGFuZCAyIHJ4cWEgY2FuJ3QgcmVmZXJlbmNlIHNhbWUg
cG9vbC4NCj4gDQoNCldpdGhpbiB0aGUgc2luZ2xlIG5ldGRldiwgc2VwYXJhdGUgcGFnZV9wb29s
IGluc3RhbmNlcyBhcmUgYW55d2F5IA0KY3JlYXRlZCBmb3IgZGlmZmVyZW50IFJYIHJpbmdzLCB3
b3JraW5nIHVuZGVyIGRpZmZlcmVudCBOQVBJJ3MuDQpTbyBJIGRvbid0IHVuZGVyc3RhbmQgeW91
ciBjb21tZW50IGFib3ZlIGFib3V0IGJyZWFraW5nIHNvbWUgDQptdWx0aS1uZXRkZXYgcG9vbCBz
aGFyaW5nIHVzZSBjYXNlLi4uDQoNClRhcmlxDQo=
