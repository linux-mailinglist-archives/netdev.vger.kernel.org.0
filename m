Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4E1EFD4
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 07:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfD3FL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 01:11:56 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2948 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbfD3FL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 01:11:56 -0400
Received: from DGGEML403-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 02DC252454B093154051;
        Tue, 30 Apr 2019 13:11:54 +0800 (CST)
Received: from DGGEML532-MBS.china.huawei.com ([169.254.7.161]) by
 DGGEML403-HUB.china.huawei.com ([fe80::74d9:c659:fbec:21fa%31]) with mapi id
 14.03.0439.000; Tue, 30 Apr 2019 13:11:46 +0800
From:   "weiyongjun (A)" <weiyongjun1@huawei.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     yuehaibing <yuehaibing@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Li,Rongqing" <lirongqing@baidu.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Chas Williams <3chas3@gmail.com>,
        "wangli39@baidu.com" <wangli39@baidu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: RE: [PATCH] tun: Fix use-after-free in tun_net_xmit
Thread-Topic: [PATCH] tun: Fix use-after-free in tun_net_xmit
Thread-Index: AQHU/W9g3sfuWPKNdEe3Jj6+nCJHZaZSthwAgAAig4CAAU5I4A==
Date:   Tue, 30 Apr 2019 05:11:45 +0000
Message-ID: <6AADFAC011213A4C87B956458587ADB4021FE16C@dggeml532-mbs.china.huawei.com>
References: <71250616-36c1-0d96-8fac-4aaaae6a28d4@redhat.com>
 <20190428030539.17776-1-yuehaibing@huawei.com>
 <20190429105422-mutt-send-email-mst@kernel.org>
 <CAM_iQpWvp2i6iOZtSPskqU_uXHL2zKfM_cS1rGTh_T0r3BwvnA@mail.gmail.com>
In-Reply-To: <CAM_iQpWvp2i6iOZtSPskqU_uXHL2zKfM_cS1rGTh_T0r3BwvnA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.30.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBOZXR3b3JrIERldmVsb3BlcnMgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6
IFJlOiBbUEFUQ0hdIHR1bjogRml4IHVzZS1hZnRlci1mcmVlIGluIHR1bl9uZXRfeG1pdA0KPiAN
Cj4gT24gTW9uLCBBcHIgMjksIDIwMTkgYXQgNzo1NSBBTSBNaWNoYWVsIFMuIFRzaXJraW4gPG1z
dEByZWRoYXQuY29tPg0KPiB3cm90ZToNCj4gPiBUaGUgcHJvYmxlbSBzZWVtcyByZWFsIGVub3Vn
aCwgYnV0IGFuIGV4dHJhIHN5bmNocm9uaXplX25ldCBvbg0KPiB0dW5fYXR0YWNoDQo+ID4gbWln
aHQgYmUgYSBwcm9ibGVtLCBzbG93aW5nIGd1ZXN0IHN0YXJ0dXAgc2lnbmlmaWNhbnRseS4NCj4g
PiBCZXR0ZXIgaWRlYXM/DQo+IA0KPiBZZXMsIEkgcHJvcG9zZWQgdGhlIGZvbGxvd2luZyBwYXRj
aCBpbiB0aGUgb3RoZXIgdGhyZWFkLg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3R1
bi5jIGIvZHJpdmVycy9uZXQvdHVuLmMNCj4gaW5kZXggZTljYTFjMDg4ZDBiLi4zMWMzMjEwMjg4
Y2IgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3R1bi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0
L3R1bi5jDQo+IEBAIC0zNDMxLDYgKzM0MzEsNyBAQCBzdGF0aWMgaW50IHR1bl9jaHJfb3Blbihz
dHJ1Y3QgaW5vZGUgKmlub2RlLA0KPiBzdHJ1Y3QgZmlsZSAqIGZpbGUpDQo+ICAgICAgICAgZmls
ZS0+cHJpdmF0ZV9kYXRhID0gdGZpbGU7DQo+ICAgICAgICAgSU5JVF9MSVNUX0hFQUQoJnRmaWxl
LT5uZXh0KTsNCj4gDQo+ICsgICAgICAgc29ja19zZXRfZmxhZygmdGZpbGUtPnNrLCBTT0NLX1JD
VV9GUkVFKTsNCj4gICAgICAgICBzb2NrX3NldF9mbGFnKCZ0ZmlsZS0+c2ssIFNPQ0tfWkVST0NP
UFkpOw0KPiANCj4gICAgICAgICByZXR1cm4gMDsNCg0KDQpUaGlzIHBhdGNoIHNob3VsZCBub3Qg
d29yay4gVGhlIGtleSBwb2ludCBpcyB0aGF0IHdoZW4gZGV0YWNoIHRoZSBxdWV1ZQ0Kd2l0aCBp
bmRleCBpcyBlcXVhbCB0byB0dW4tPm51bXF1ZXVlcyAtIDEsIHdlIGRvIG5vdCBjbGVhciB0aGUg
cG9pbnQNCmluIHR1bi0+dGZpbGVzOg0KDQpzdGF0aWMgdm9pZCBfX3R1bl9kZXRhY2goLi4uKQ0K
ew0KLi4uDQogICAgICAgICoqKiogaWYgaW5kZXggPT0gdHVuLT5udW1xdWV1ZXMgLSAxLCBub3Ro
aW5nIGNoYW5nZWQgKioqKg0KICAgICAgICByY3VfYXNzaWduX3BvaW50ZXIodHVuLT50ZmlsZXNb
aW5kZXhdLA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
dHVuLT50ZmlsZXNbdHVuLT5udW1xdWV1ZXMgLSAxXSk7DQouLi4uDQp9DQoNCkFuZCBhZnRlciB0
ZmlsZSBmcmVlLCB4bWl0IGhhdmUgY2hhbmdlIHRvIGdldCBhbmQgdXNlIHRoZSBmcmVlZCBmaWxl
IHBvaW50Lg0KDQpSZWdhcmRzDQoNCg==
