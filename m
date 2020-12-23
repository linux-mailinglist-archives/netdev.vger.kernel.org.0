Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EBD2E1C8B
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 14:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgLWNWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 08:22:04 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2409 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbgLWNWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 08:22:03 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4D1DN928Vhz56YR;
        Wed, 23 Dec 2020 21:20:25 +0800 (CST)
Received: from DGGEMM533-MBX.china.huawei.com ([169.254.5.214]) by
 DGGEMM402-HUB.china.huawei.com ([10.3.20.210]) with mapi id 14.03.0509.000;
 Wed, 23 Dec 2020 21:21:11 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Subject: RE: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg
 fails
Thread-Topic: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg
 fails
Thread-Index: AQHW04Rfp56K/196YUuYX4LzCnUku6oBrxQAgABdIgCAAKMSgIAA0TwAgADtrdA=
Date:   Wed, 23 Dec 2020 13:21:11 +0000
Message-ID: <34EFBCA9F01B0748BEB6B629CE643AE60DB8E046@DGGEMM533-MBX.china.huawei.com>
References: <cover.1608065644.git.wangyunjian@huawei.com>
 <6b4c5fff8705dc4b5b6a25a45c50f36349350c73.1608065644.git.wangyunjian@huawei.com>
 <CAF=yD-K6EM3zfZtEh=305P4Z6ehO6TzfQC4cxp5+gHYrxEtXSg@mail.gmail.com>
 <acebdc23-7627-e170-cdfb-b7656c05e5c5@redhat.com>
 <CAF=yD-KCs5x1oX-02aDM=5JyLP=BaA7_Jg7Wxt3=JmK8JBnyiA@mail.gmail.com>
 <2a309efb-0ea5-c40e-5564-b8900601da97@redhat.com>
In-Reply-To: <2a309efb-0ea5-c40e-5564-b8900601da97@redhat.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.243.127]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYXNvbiBXYW5nIFttYWlsdG86
amFzb3dhbmdAcmVkaGF0LmNvbV0NCj4gU2VudDogV2VkbmVzZGF5LCBEZWNlbWJlciAyMywgMjAy
MCAxMDo1NCBBTQ0KPiBUbzogV2lsbGVtIGRlIEJydWlqbiA8d2lsbGVtZGVicnVpam4ua2VybmVs
QGdtYWlsLmNvbT4NCj4gQ2M6IHdhbmd5dW5qaWFuIDx3YW5neXVuamlhbkBodWF3ZWkuY29tPjsg
TmV0d29yayBEZXZlbG9wbWVudA0KPiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IE1pY2hhZWwg
Uy4gVHNpcmtpbiA8bXN0QHJlZGhhdC5jb20+Ow0KPiB2aXJ0dWFsaXphdGlvbkBsaXN0cy5saW51
eC1mb3VuZGF0aW9uLm9yZzsgTGlsaWp1biAoSmVycnkpDQo+IDxqZXJyeS5saWxpanVuQGh1YXdl
aS5jb20+OyBjaGVuY2hhbmdodSA8Y2hlbmNoYW5naHVAaHVhd2VpLmNvbT47DQo+IHh1ZGluZ2tl
IDx4dWRpbmdrZUBodWF3ZWkuY29tPjsgaHVhbmdiaW4gKEopDQo+IDxicmlhbi5odWFuZ2JpbkBo
dWF3ZWkuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldCB2MiAyLzJdIHZob3N0X25ldDog
Zml4IGhpZ2ggY3B1IGxvYWQgd2hlbiBzZW5kbXNnIGZhaWxzDQo+IA0KPiANCj4gT24gMjAyMC8x
Mi8yMiDkuIvljYgxMDoyNCwgV2lsbGVtIGRlIEJydWlqbiB3cm90ZToNCj4gPiBPbiBNb24sIERl
YyAyMSwgMjAyMCBhdCAxMTo0MSBQTSBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0K
PiB3cm90ZToNCj4gPj4NCj4gPj4gT24gMjAyMC8xMi8yMiDkuIrljYg3OjA3LCBXaWxsZW0gZGUg
QnJ1aWpuIHdyb3RlOg0KPiA+Pj4gT24gV2VkLCBEZWMgMTYsIDIwMjAgYXQgMzoyMCBBTSB3YW5n
eXVuamlhbjx3YW5neXVuamlhbkBodWF3ZWkuY29tPg0KPiB3cm90ZToNCj4gPj4+PiBGcm9tOiBZ
dW5qaWFuIFdhbmc8d2FuZ3l1bmppYW5AaHVhd2VpLmNvbT4NCj4gPj4+Pg0KPiA+Pj4+IEN1cnJl
bnRseSB3ZSBicmVhayB0aGUgbG9vcCBhbmQgd2FrZSB1cCB0aGUgdmhvc3Rfd29ya2VyIHdoZW4N
Cj4gPj4+PiBzZW5kbXNnIGZhaWxzLiBXaGVuIHRoZSB3b3JrZXIgd2FrZXMgdXAgYWdhaW4sIHdl
J2xsIG1lZXQgdGhlIHNhbWUNCj4gPj4+PiBlcnJvci4NCj4gPj4+IFRoZSBwYXRjaCBpcyBiYXNl
ZCBvbiB0aGUgYXNzdW1wdGlvbiB0aGF0IHN1Y2ggZXJyb3IgY2FzZXMgYWx3YXlzDQo+ID4+PiBy
ZXR1cm4gRUFHQUlOLiBDYW4gaXQgbm90IGFsc28gYmUgRU5PTUVNLCBzdWNoIGFzIGZyb20gdHVu
X2J1aWxkX3NrYj8NCj4gPj4+DQo+ID4+Pj4gVGhpcyB3aWxsIGNhdXNlIGhpZ2ggQ1BVIGxvYWQu
IFRvIGZpeCB0aGlzIGlzc3VlLCB3ZSBjYW4gc2tpcCB0aGlzDQo+ID4+Pj4gZGVzY3JpcHRpb24g
YnkgaWdub3JpbmcgdGhlIGVycm9yLiBXaGVuIHdlIGV4Y2VlZHMgc25kYnVmLCB0aGUNCj4gPj4+
PiByZXR1cm4gdmFsdWUgb2Ygc2VuZG1zZyBpcyAtRUFHQUlOLiBJbiB0aGUgY2FzZSB3ZSBkb24n
dCBza2lwIHRoZQ0KPiA+Pj4+IGRlc2NyaXB0aW9uIGFuZCBkb24ndCBkcm9wIHBhY2tldC4NCj4g
Pj4+IHRoZSAtPiB0aGF0DQo+ID4+Pg0KPiA+Pj4gaGVyZSBhbmQgYWJvdmU6IGRlc2NyaXB0aW9u
IC0+IGRlc2NyaXB0b3INCj4gPj4+DQo+ID4+PiBQZXJoYXBzIHNsaWdodGx5IHJldmlzZSB0byBt
b3JlIGV4cGxpY2l0bHkgc3RhdGUgdGhhdA0KPiA+Pj4NCj4gPj4+IDEuIGluIHRoZSBjYXNlIG9m
IHBlcnNpc3RlbnQgZmFpbHVyZSAoaS5lLiwgYmFkIHBhY2tldCksIHRoZSBkcml2ZXINCj4gPj4+
IGRyb3BzIHRoZSBwYWNrZXQgMi4gaW4gdGhlIGNhc2Ugb2YgdHJhbnNpZW50IGZhaWx1cmUgKGUu
ZywuIG1lbW9yeQ0KPiA+Pj4gcHJlc3N1cmUpIHRoZSBkcml2ZXIgc2NoZWR1bGVzIHRoZSB3b3Jr
ZXIgdG8gdHJ5IGFnYWluIGxhdGVyDQo+ID4+DQo+ID4+IElmIHdlIHdhbnQgdG8gZ28gd2l0aCB0
aGlzIHdheSwgd2UgbmVlZCBhIGJldHRlciB0aW1lIHRvIHdha2V1cCB0aGUNCj4gPj4gd29ya2Vy
LiBPdGhlcndpc2UgaXQganVzdCBwcm9kdWNlcyBtb3JlIHN0cmVzcyBvbiB0aGUgY3B1IHRoYXQg
aXMNCj4gPj4gd2hhdCB0aGlzIHBhdGNoIHRyaWVzIHRvIGF2b2lkLg0KPiA+IFBlcmhhcHMgSSBt
aXN1bmRlcnN0b29kIHRoZSBwdXJwb3NlIG9mIHRoZSBwYXRjaDogaXMgaXQgdG8gZHJvcA0KPiA+
IGV2ZXJ5dGhpbmcsIHJlZ2FyZGxlc3Mgb2YgdHJhbnNpZW50IG9yIHBlcnNpc3RlbnQgZmFpbHVy
ZSwgdW50aWwgdGhlDQo+ID4gcmluZyBydW5zIG91dCBvZiBkZXNjcmlwdG9ycz8NCj4gDQo+IA0K
PiBNeSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQgdGhlIG1haW4gbW90aXZhdGlvbiBpcyB0byBhdm9p
ZCBoaWdoIGNwdSB1dGlsaXphdGlvbg0KPiB3aGVuIHNlbmRtc2coKSBmYWlsIGR1ZSB0byBndWVz
dCByZWFzb24gKGUuZyBiYWQgcGFja2V0KS4NCj4gDQoNCk15IG1haW4gbW90aXZhdGlvbiBpcyB0
byBhdm9pZCB0aGUgdHggcXVldWUgc3R1Y2suDQoNClNob3VsZCBJIGRlc2NyaWJlIGl0IGxpa2Ug
dGhpczoNCkN1cnJlbnRseSB0aGUgZHJpdmVyIGRvbid0IGRyb3AgYSBwYWNrZXQgd2hpY2ggY2Fu
J3QgYmUgc2VuZCBieSB0dW4NCihlLmcgYmFkIHBhY2tldCkuIEluIHRoaXMgY2FzZSwgdGhlIGRy
aXZlciB3aWxsIGFsd2F5cyBwcm9jZXNzIHRoZQ0Kc2FtZSBwYWNrZXQgbGVhZCB0byB0aGUgdHgg
cXVldWUgc3R1Y2suDQoNClRvIGZpeCB0aGlzIGlzc3VlOg0KMS4gaW4gdGhlIGNhc2Ugb2YgcGVy
c2lzdGVudCBmYWlsdXJlIChlLmcgYmFkIHBhY2tldCksIHRoZSBkcml2ZXIgY2FuIHNraXANCnRo
aXMgZGVzY3JpcHRpb3IgYnkgaWdub3JpbmcgdGhlIGVycm9yLg0KMi4gaW4gdGhlIGNhc2Ugb2Yg
dHJhbnNpZW50IGZhaWx1cmUgKGUuZyAtRUFHQUlOIGFuZCAtRU5PTUVNKSwgdGhlIGRyaXZlcg0K
c2NoZWR1bGVzIHRoZSB3b3JrZXIgdG8gdHJ5IGFnYWluLg0KDQpUaGFua3MNCg0KPiANCj4gPg0K
PiA+IEkgY2FuIHVuZGVyc3RhbmQgYm90aCBhIGJsb2NraW5nIGFuZCBkcm9wIHN0cmF0ZWd5IGR1
cmluZyBtZW1vcnkNCj4gPiBwcmVzc3VyZS4gQnV0IHBhcnRpYWwgZHJvcCBzdHJhdGVneSB1bnRp
bCBleGNlZWRpbmcgcmluZyBjYXBhY2l0eQ0KPiA+IHNlZW1zIGxpa2UgYSBwZWN1bGlhciBoeWJy
aWQ/DQo+IA0KPiANCj4gWWVzLiBTbyBJIHdvbmRlciBpZiB3ZSB3YW50IHRvIGJlIGRvIGJldHRl
ciB3aGVuIHdlIGFyZSBpbiB0aGUgbWVtb3J5DQo+IHByZXNzdXJlLiBFLmcgY2FuIHdlIGxldCBz
b2NrZXQgd2FrZSB1cCB1cyBpbnN0ZWFkIG9mIHJlc2NoZWR1bGluZyB0aGUNCj4gd29ya2VycyBo
ZXJlPyBBdCBsZWFzdCBpbiB0aGlzIGNhc2Ugd2Uga25vdyBzb21lIG1lbW9yeSBtaWdodCBiZSBm
cmVlZD8NCj4gDQo+IFRoYW5rcw0KPiANCj4gDQo+ID4NCg0K
