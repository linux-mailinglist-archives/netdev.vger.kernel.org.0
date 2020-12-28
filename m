Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD1F2E36D1
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 12:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgL1L7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 06:59:00 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2931 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgL1L67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 06:58:59 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4D4GJ62tlKz5889;
        Mon, 28 Dec 2020 19:57:26 +0800 (CST)
Received: from DGGEMM533-MBX.china.huawei.com ([169.254.5.164]) by
 DGGEMM403-HUB.china.huawei.com ([10.3.20.211]) with mapi id 14.03.0509.000;
 Mon, 28 Dec 2020 19:58:05 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Subject: RE: [PATCH net v5 1/2] vhost_net: fix ubuf refcount incorrectly
 when sendmsg fails
Thread-Topic: [PATCH net v5 1/2] vhost_net: fix ubuf refcount incorrectly
 when sendmsg fails
Thread-Index: AQHW2o79xwyR7XBrFku61rdjezGWBKoKSheAgABRaoCAAdCKYA==
Date:   Mon, 28 Dec 2020 11:58:04 +0000
Message-ID: <34EFBCA9F01B0748BEB6B629CE643AE60DBA8B49@DGGEMM533-MBX.china.huawei.com>
References: <1608881065-7572-1-git-send-email-wangyunjian@huawei.com>
 <20201227062220-mutt-send-email-mst@kernel.org>
 <CA+FuTScnt=jVt2+sagtYUXxTrc7RieKc=YyCdp+0zuS9jCiNuA@mail.gmail.com>
In-Reply-To: <CA+FuTScnt=jVt2+sagtYUXxTrc7RieKc=YyCdp+0zuS9jCiNuA@mail.gmail.com>
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBXaWxsZW0gZGUgQnJ1aWpuIFtt
YWlsdG86d2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbV0NCj4gU2VudDogTW9uZGF5LCBE
ZWNlbWJlciAyOCwgMjAyMCAxMjoxNSBBTQ0KPiBUbzogTWljaGFlbCBTLiBUc2lya2luIDxtc3RA
cmVkaGF0LmNvbT4NCj4gQ2M6IHdhbmd5dW5qaWFuIDx3YW5neXVuamlhbkBodWF3ZWkuY29tPjsg
TmV0d29yayBEZXZlbG9wbWVudA0KPiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IEphc29uIFdh
bmcgPGphc293YW5nQHJlZGhhdC5jb20+OyBXaWxsZW0gZGUNCj4gQnJ1aWpuIDx3aWxsZW1kZWJy
dWlqbi5rZXJuZWxAZ21haWwuY29tPjsNCj4gdmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtZm91
bmRhdGlvbi5vcmc7IExpbGlqdW4gKEplcnJ5KQ0KPiA8amVycnkubGlsaWp1bkBodWF3ZWkuY29t
PjsgY2hlbmNoYW5naHUgPGNoZW5jaGFuZ2h1QGh1YXdlaS5jb20+Ow0KPiB4dWRpbmdrZSA8eHVk
aW5na2VAaHVhd2VpLmNvbT47IGh1YW5nYmluIChKKQ0KPiA8YnJpYW4uaHVhbmdiaW5AaHVhd2Vp
LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQgdjUgMS8yXSB2aG9zdF9uZXQ6IGZpeCB1
YnVmIHJlZmNvdW50IGluY29ycmVjdGx5IHdoZW4NCj4gc2VuZG1zZyBmYWlscw0KPiANCj4gT24g
U3VuLCBEZWMgMjcsIDIwMjAgYXQgNjoyNiBBTSBNaWNoYWVsIFMuIFRzaXJraW4gPG1zdEByZWRo
YXQuY29tPiB3cm90ZToNCj4gPg0KPiA+IE9uIEZyaSwgRGVjIDI1LCAyMDIwIGF0IDAzOjI0OjI1
UE0gKzA4MDAsIHdhbmd5dW5qaWFuIHdyb3RlOg0KPiA+ID4gRnJvbTogWXVuamlhbiBXYW5nIDx3
YW5neXVuamlhbkBodWF3ZWkuY29tPg0KPiA+ID4NCj4gPiA+IEN1cnJlbnRseSB0aGUgdmhvc3Rf
emVyb2NvcHlfY2FsbGJhY2soKSBtYXliZSBiZSBjYWxsZWQgdG8gZGVjcmVhc2UNCj4gPiA+IHRo
ZSByZWZjb3VudCB3aGVuIHNlbmRtc2cgZmFpbHMgaW4gdHVuLiBUaGUgZXJyb3IgaGFuZGxpbmcg
aW4gdmhvc3QNCj4gPiA+IGhhbmRsZV90eF96ZXJvY29weSgpIHdpbGwgdHJ5IHRvIGRlY3JlYXNl
IHRoZSBzYW1lIHJlZmNvdW50IGFnYWluLg0KPiA+ID4gVGhpcyBpcyB3cm9uZy4gVG8gZml4IHRo
aXMgaXNzdWUsIHdlIG9ubHkgY2FsbCB2aG9zdF9uZXRfdWJ1Zl9wdXQoKQ0KPiA+ID4gd2hlbiB2
cS0+aGVhZHNbbnZxLT5kZXNjXS5sZW4gPT0gVkhPU1RfRE1BX0lOX1BST0dSRVNTLg0KPiA+ID4N
Cj4gPiA+IEZpeGVzOiAwNjkwODk5YjRkNDUgKCJ0dW46IGV4cGVyaW1lbnRhbCB6ZXJvIGNvcHkg
dHggc3VwcG9ydCIpDQo+ID4NCj4gPiBBcmUgeW91IHN1cmUgYWJvdXQgdGhpcyB0YWc/IHRoZSBw
YXRjaCBpbiBxdWVzdGlvbiBvbmx5IGFmZmVjdHMgdHVuLA0KPiA+IHdoaWxlIHRoZSBmaXggb25s
eSBhZmZlY3RzIHZob3N0Lg0KPiANCj4gVGhhdCB3YXMgbXkgc3VnZ2VzdGlvbi4gQnV0IHlvdSdy
ZSByaWdodC4gUGVyaGFwcyBiZXR0ZXI6DQo+IA0KPiBGaXhlczogYmFiNjMyZDY5ZWU0ICgidmhv
c3Q6IHZob3N0IFRYIHplcm8tY29weSBzdXBwb3J0IikNCg0KT0ssIHRoYW5rcywgSSB3aWxsIGZp
eCBpdCBpbiBuZXh0IHZlcnNpb24uDQoNCj4gDQo+IFRoYXQgaW50cm9kdWNlcyB0aGUgYWN0dWFs
IGJsb2NrIHRoYXQgcmVsZWFzZXMgdGhlIGJ1ZmZlciBvbiBlcnJvcjoNCj4gDQo+ICINCj4gICAg
ICAgICAgICAgICAgIGVyciA9IHNvY2stPm9wcy0+c2VuZG1zZyhOVUxMLCBzb2NrLCAmbXNnLCBs
ZW4pOw0KPiAgICAgICAgICAgICAgICAgaWYgKHVubGlrZWx5KGVyciA8IDApKSB7DQo+ICsgICAg
ICAgICAgICAgICAgICAgICAgIGlmICh6Y29weSkgew0KPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGlmICh1YnVmcykNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHZob3N0X3VidWZfcHV0KHVidWZzKTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB2cS0+dXBlbmRfaWR4ID0NCj4gKCh1bnNpZ25lZCl2cS0+dXBlbmRfaWR4IC0gMSkg
JQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgVUlPX01BWElPVjsN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgfQ0KPiAiDQo=
