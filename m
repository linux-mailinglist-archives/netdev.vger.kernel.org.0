Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405E82DA8C8
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 08:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgLOHwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 02:52:46 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:4116 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgLOHwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 02:52:36 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Cw9S15PXRzXnZn;
        Tue, 15 Dec 2020 15:51:13 +0800 (CST)
Received: from DGGEMM422-HUB.china.huawei.com (10.1.198.39) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 15 Dec 2020 15:51:45 +0800
Received: from DGGEMM533-MBX.china.huawei.com ([169.254.5.214]) by
 dggemm422-hub.china.huawei.com ([169.254.138.104]) with mapi id
 14.03.0509.000; Tue, 15 Dec 2020 15:51:38 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Subject: RE: [PATCH net 1/2] vhost_net: fix ubuf refcount incorrectly when
 sendmsg fails
Thread-Topic: [PATCH net 1/2] vhost_net: fix ubuf refcount incorrectly when
 sendmsg fails
Thread-Index: AQHW0oRrOeilOZk5R0qV3D/I0yKaZan27aCAgADbGHA=
Date:   Tue, 15 Dec 2020 07:51:37 +0000
Message-ID: <34EFBCA9F01B0748BEB6B629CE643AE60DB82A21@DGGEMM533-MBX.china.huawei.com>
References: <cover.1608024547.git.wangyunjian@huawei.com>
 <5e2ecf3d0f07b864d307b9f0425b7b7fe8bf4d2c.1608024547.git.wangyunjian@huawei.com>
 <CA+FuTSeH-+p_7i9UdEy0UL2y2EoprO4sE-BYNe2Vt8ThxaCLcA@mail.gmail.com>
In-Reply-To: <CA+FuTSeH-+p_7i9UdEy0UL2y2EoprO4sE-BYNe2Vt8ThxaCLcA@mail.gmail.com>
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
YWlsdG86d2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbV0NCj4gU2VudDogVHVlc2RheSwg
RGVjZW1iZXIgMTUsIDIwMjAgMTA6NDYgQU0NCj4gVG86IHdhbmd5dW5qaWFuIDx3YW5neXVuamlh
bkBodWF3ZWkuY29tPg0KPiBDYzogTmV0d29yayBEZXZlbG9wbWVudCA8bmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZz47IE1pY2hhZWwgUy4gVHNpcmtpbg0KPiA8bXN0QHJlZGhhdC5jb20+OyBKYXNvbiBX
YW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPjsgV2lsbGVtIGRlIEJydWlqbg0KPiA8d2lsbGVtZGVi
cnVpam4ua2VybmVsQGdtYWlsLmNvbT47IHZpcnR1YWxpemF0aW9uQGxpc3RzLmxpbnV4LWZvdW5k
YXRpb24ub3JnOw0KPiBMaWxpanVuIChKZXJyeSkgPGplcnJ5LmxpbGlqdW5AaHVhd2VpLmNvbT47
IGNoZW5jaGFuZ2h1DQo+IDxjaGVuY2hhbmdodUBodWF3ZWkuY29tPjsgeHVkaW5na2UgPHh1ZGlu
Z2tlQGh1YXdlaS5jb20+OyBodWFuZ2JpbiAoSikNCj4gPGJyaWFuLmh1YW5nYmluQGh1YXdlaS5j
b20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0IDEvMl0gdmhvc3RfbmV0OiBmaXggdWJ1ZiBy
ZWZjb3VudCBpbmNvcnJlY3RseSB3aGVuDQo+IHNlbmRtc2cgZmFpbHMNCj4gDQo+IE9uIE1vbiwg
RGVjIDE0LCAyMDIwIGF0IDg6NTkgUE0gd2FuZ3l1bmppYW4gPHdhbmd5dW5qaWFuQGh1YXdlaS5j
b20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gRnJvbTogWXVuamlhbiBXYW5nIDx3YW5neXVuamlhbkBo
dWF3ZWkuY29tPg0KPiA+DQo+ID4gQ3VycmVudGx5IHRoZSB2aG9zdF96ZXJvY29weV9jYWxsYmFj
aygpIG1heWJlIGJlIGNhbGxlZCB0byBkZWNyZWFzZQ0KPiA+IHRoZSByZWZjb3VudCB3aGVuIHNl
bmRtc2cgZmFpbHMgaW4gdHVuLiBUaGUgZXJyb3IgaGFuZGxpbmcgaW4gdmhvc3QNCj4gPiBoYW5k
bGVfdHhfemVyb2NvcHkoKSB3aWxsIHRyeSB0byBkZWNyZWFzZSB0aGUgc2FtZSByZWZjb3VudCBh
Z2Fpbi4NCj4gPiBUaGlzIGlzIHdyb25nLiBUbyBmaXggdGhpcyBpc3N1ZSwgd2Ugb25seSBjYWxs
IHZob3N0X25ldF91YnVmX3B1dCgpDQo+ID4gd2hlbiB2cS0+aGVhZHNbbnZxLT5kZXNjXS5sZW4g
PT0gVkhPU1RfRE1BX0lOX1BST0dSRVNTLg0KPiA+DQo+ID4gRml4ZXM6IDQ0NzcxMzhmYTBhZSAo
InR1bjogcHJvcGVybHkgdGVzdCBmb3IgSUZGX1VQIikNCj4gPiBGaXhlczogOTBlMzNkNDU5NDA3
ICgidHVuOiBlbmFibGUgbmFwaV9ncm9fZnJhZ3MoKSBmb3IgVFVOL1RBUA0KPiA+IGRyaXZlciIp
DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZdW5qaWFuIFdhbmcgPHdhbmd5dW5qaWFuQGh1YXdl
aS5jb20+DQo+IA0KPiBQYXRjaCBsb29rcyBnb29kIHRvIG1lLiBUaGFua3MuDQo+IA0KPiBCdXQg
SSB0aGluayB0aGUgcmlnaHQgRml4ZXMgdGFnIHdvdWxkIGJlDQo+IA0KPiBGaXhlczogMDY5MDg5
OWI0ZDQ1ICgidHVuOiBleHBlcmltZW50YWwgemVybyBjb3B5IHR4IHN1cHBvcnQiKQ0KDQpPSywg
dGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbi4gSSB3aWxsIGZpeCBpdCBpbiBuZXh0IHZlcnNpb24u
DQo=
