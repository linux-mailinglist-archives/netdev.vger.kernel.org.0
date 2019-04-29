Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE3E9DAE1
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 05:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfD2Dxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 23:53:46 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3003 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726819AbfD2Dxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Apr 2019 23:53:46 -0400
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 60D8B949FE01AB8477CA;
        Mon, 29 Apr 2019 11:53:43 +0800 (CST)
Received: from DGGEML532-MBS.china.huawei.com ([169.254.7.161]) by
 DGGEML402-HUB.china.huawei.com ([fe80::fca6:7568:4ee3:c776%31]) with mapi id
 14.03.0439.000; Mon, 29 Apr 2019 11:53:33 +0800
From:   "weiyongjun (A)" <weiyongjun1@huawei.com>
To:     Jason Wang <jasowang@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     yuehaibing <yuehaibing@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "lirongqing@baidu.com" <lirongqing@baidu.com>,
        nicolas dichtel <nicolas.dichtel@6wind.com>,
        "3chas3@gmail.com" <3chas3@gmail.com>,
        "wangli39@baidu.com" <wangli39@baidu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>
Subject: RE: [PATCH] tun: Fix use-after-free in tun_net_xmit
Thread-Topic: [PATCH] tun: Fix use-after-free in tun_net_xmit
Thread-Index: AQHU/W9g3sfuWPKNdEe3Jj6+nCJHZaZQYsSAgAARegCAAJO30P//pXyAgACp3ACAAIzUgIAAnq8w
Date:   Mon, 29 Apr 2019 03:53:32 +0000
Message-ID: <6AADFAC011213A4C87B956458587ADB4021F9A34@dggeml532-mbs.china.huawei.com>
References: <71250616-36c1-0d96-8fac-4aaaae6a28d4@redhat.com>
 <20190428030539.17776-1-yuehaibing@huawei.com>
 <516ba6e4-359b-15d0-e169-d8cc1e989a4a@redhat.com>
 <2c823bbf-28c4-b43d-52d9-b0e0356f03ae@redhat.com>
 <6AADFAC011213A4C87B956458587ADB4021F7531@dggeml532-mbs.china.huawei.com>
 <b33ce1f9-3d65-2d05-648b-f5a6cfbd59ab@redhat.com>
 <CAM_iQpUfpruaFowbiTOY7aH4Ts-xcY4JACGLOT3CUjLqpg_zXw@mail.gmail.com>
 <528517144.24310809.1556504619719.JavaMail.zimbra@redhat.com>
In-Reply-To: <528517144.24310809.1556504619719.JavaMail.zimbra@redhat.com>
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

PiA+IE9uIFN1biwgQXByIDI4LCAyMDE5IGF0IDEyOjUxIEFNIEphc29uIFdhbmcgPGphc293YW5n
QHJlZGhhdC5jb20+DQo+IHdyb3RlOg0KPiA+Pj4gdHVuX25ldF94bWl0KCkgZG9lc24ndCBoYXZl
IHRoZSBjaGFuY2UgdG8NCj4gPj4+IGFjY2VzcyB0aGUgY2hhbmdlIGJlY2F1c2UgaXQgaG9sZGlu
ZyB0aGUgcmN1X3JlYWRfbG9jaygpLg0KPiA+Pg0KPiA+Pg0KPiA+PiBUaGUgcHJvYmxlbSBpcyB0
aGUgZm9sbG93aW5nIGNvZGVzOg0KPiA+Pg0KPiA+Pg0KPiA+PiAgICAgICAgICAtLXR1bi0+bnVt
cXVldWVzOw0KPiA+Pg0KPiA+PiAgICAgICAgICAuLi4NCj4gPj4NCj4gPj4gICAgICAgICAgc3lu
Y2hyb25pemVfbmV0KCk7DQo+ID4+DQo+ID4+IFdlIG5lZWQgbWFrZSBzdXJlIHRoZSBkZWNyZW1l
bnQgb2YgdHVuLT5udW1xdWV1ZXMgYmUgdmlzaWJsZSB0bw0KPiByZWFkZXJzDQo+ID4+IGFmdGVy
IHN5bmNocm9uaXplX25ldCgpLiBBbmQgaW4gdHVuX25ldF94bWl0KCk6DQo+ID4NCj4gPiBJdCBk
b2Vzbid0IG1hdHRlciBhdCBhbGwuIFJlYWRlcnMgYXJlIG9rYXkgdG8gcmVhZCBpdCBldmVuIHRo
ZXkgc3RpbGwgdXNlIHRoZQ0KPiA+IHN0YWxlIHR1bi0+bnVtcXVldWVzLCBhcyBsb25nIGFzIHRo
ZSB0ZmlsZSBpcyBub3QgZnJlZWQgcmVhZGVycyBjYW4gcmVhZA0KPiA+IHdoYXRldmVyIHRoZXkg
d2FudC4uLg0KPiANCj4gVGhpcyBpcyBvbmx5IHRydWUgaWYgd2Ugc2V0IFNPQ0tfUkNVX0ZSRUUs
IGlzbid0IGl0Pw0KPiANCj4gPg0KPiA+IFRoZSBkZWNyZW1lbnQgb2YgdHVuLT5udW1xdWV1ZXMg
aXMganVzdCBob3cgd2UgdW5wdWJsaXNoIHRoZSBvbGQNCj4gPiB0ZmlsZSwgaXQgaXMgc3RpbGwg
dmFsaWQgZm9yIHJlYWRlcnMgdG8gcmVhZCBpdCBfYWZ0ZXJfIHVucHVibGlzaCwgd2Ugb25seSBu
ZWVkDQo+ID4gdG8gd29ycnkgYWJvdXQgZnJlZSwgbm90IGFib3V0IHVucHVibGlzaC4gVGhpcyBp
cyB0aGUgd2hvbGUgc3Bpcml0IG9mIFJDVS4NCj4gPg0KPiANCj4gVGhlIHBvaW50IGlzIHdlIGRv
bid0IGNvbnZlcnQgdHVuLT5udW1xdWV1ZXMgdG8gUkNVIGJ1dCB1c2UNCj4gc3luY2hyb25pemVf
bmV0KCkuDQo+IA0KPiA+IFlvdSBuZWVkIHRvIHJldGhpbmsgYWJvdXQgbXkgU09DS19SQ1VfRlJF
RSBwYXRjaC4NCj4gDQo+IFRoZSBjb2RlIGlzIHdyb3RlIGJlZm9yZSBTT0NLX1JDVV9GUkVFIGlz
IGludHJvZHVjZWQgYW5kIGFzc3VtZSBubw0KPiBkZS1yZWZlcmVuY2UgZnJvbSBkZXZpY2UgYWZ0
ZXIgc3luY2hyb25pemVfbmV0KCkuIEl0IGRvZXNuJ3QgaGFybSB0bw0KPiBmaWd1cmUgb3V0IHRo
ZSByb290IGNhdXNlIHdoaWNoIG1heSBnaXZlIHVzIG1vcmUgY29uZmlkZW5jZSB0byB0aGUgZml4
DQo+IChlLmcgbGlrZSBTT0NLX1JDVV9GUkVFKS4NCj4gDQo+IEkgZG9uJ3Qgb2JqZWN0IHRvIGZp
eCB3aXRoIFNPQ0tfUkNVX0ZSRUUsIGJ1dCB0aGVuIHdlIHNob3VsZCByZW1vdmUNCj4gdGhlIHJl
ZHVuZGFudCBzeW5jaHJvbml6ZV9uZXQoKS4gQnV0IEkgc3RpbGwgcHJlZmVyIHRvIHN5bmNocm9u
aXplDQo+IGV2ZXJ5dGhpbmcgZXhwbGljaXRseSBsaWtlIChjb21wbGV0ZWx5IHVudGVzdGVkKToN
Cj4gDQo+IEZyb20gZGY5MWY3N2QzNWE2YWE3OTQzYjZmMmE3ZDRiMzI5OTkwODk2YTBmZSBNb24g
U2VwIDE3IDAwOjAwOjAwDQo+IDIwMDENCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVk
aGF0LmNvbT4NCj4gRGF0ZTogTW9uLCAyOSBBcHIgMjAxOSAxMDoyMTowNiArMDgwMA0KPiBTdWJq
ZWN0OiBbUEFUQ0hdIHR1bnRhcDogc3luY2hyb25pemUgdGhyb3VnaCB0ZmlsZXMgaW5zdGVhZCBv
ZiBudW1xdWV1ZXMNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEphc29uIFdhbmcgPGphc293YW5nQHJl
ZGhhdC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvdHVuLmMgfCAxMSArKysrKy0tLS0tLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC90dW4uYyBiL2RyaXZlcnMvbmV0L3R1bi5jDQo+IGlu
ZGV4IDgwYmZmMWI0ZWMxNy4uMDM3MTVmNjA1ZmI1IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC90dW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC90dW4uYw0KPiBAQCAtNjk4LDYgKzY5OCw3IEBA
IHN0YXRpYyB2b2lkIF9fdHVuX2RldGFjaChzdHJ1Y3QgdHVuX2ZpbGUgKnRmaWxlLCBib29sDQo+
IGNsZWFuKQ0KPiANCj4gIAkJcmN1X2Fzc2lnbl9wb2ludGVyKHR1bi0+dGZpbGVzW2luZGV4XSwN
Cj4gIAkJCQkgICB0dW4tPnRmaWxlc1t0dW4tPm51bXF1ZXVlcyAtIDFdKTsNCj4gKwkJcmN1X2Fz
c2lnbl9wb2ludGVyKHR1bi0+dGZpbGVzW3R1bi0+bnVtcXVldWVzXSwgTlVMTCk7DQoNClNob3Vs
ZCBiZSAicmN1X2Fzc2lnbl9wb2ludGVyKHR1bi0+dGZpbGVzW3R1bi0+bnVtcXVldWVzIC0gMV0s
IE5VTEwpOyINCg0KPiAgCQludGZpbGUgPSBydG5sX2RlcmVmZXJlbmNlKHR1bi0+dGZpbGVzW2lu
ZGV4XSk7DQo+ICAJCW50ZmlsZS0+cXVldWVfaW5kZXggPSBpbmRleDsNCj4gDQo+IEBAIC0xMDgy
LDcgKzEwODMsNyBAQCBzdGF0aWMgbmV0ZGV2X3R4X3QgdHVuX25ldF94bWl0KHN0cnVjdCBza19i
dWZmDQo+ICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+ICAJdGZpbGUgPSByY3VfZGVy
ZWZlcmVuY2UodHVuLT50ZmlsZXNbdHhxXSk7DQo+IA0KPiAgCS8qIERyb3AgcGFja2V0IGlmIGlu
dGVyZmFjZSBpcyBub3QgYXR0YWNoZWQgKi8NCj4gLQlpZiAodHhxID49IHR1bi0+bnVtcXVldWVz
KQ0KPiArCWlmICghdGZpbGUpDQo+ICAJCWdvdG8gZHJvcDsNCj4gDQo+ICAJaWYgKCFyY3VfZGVy
ZWZlcmVuY2UodHVuLT5zdGVlcmluZ19wcm9nKSkNCj4gQEAgLTEzMDUsMTUgKzEzMDYsMTMgQEAg
c3RhdGljIGludCB0dW5feGRwX3htaXQoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCj4gaW50IG4s
DQo+IA0KPiAgCXJjdV9yZWFkX2xvY2soKTsNCj4gDQo+IC0JbnVtcXVldWVzID0gUkVBRF9PTkNF
KHR1bi0+bnVtcXVldWVzKTsNCj4gLQlpZiAoIW51bXF1ZXVlcykgew0KPiArCXRmaWxlID0gcmN1
X2RlcmVmZXJlbmNlKHR1bi0+dGZpbGVzW3NtcF9wcm9jZXNzb3JfaWQoKSAlDQo+ICsJCQkJCSAg
ICB0dW4tPm51bXF1ZXVlc10pOw0KPiArCWlmICghdGZpbGUpIHsNCj4gIAkJcmN1X3JlYWRfdW5s
b2NrKCk7DQo+ICAJCXJldHVybiAtRU5YSU87IC8qIENhbGxlciB3aWxsIGZyZWUvcmV0dXJuIGFs
bCBmcmFtZXMgKi8NCj4gIAl9DQo+IA0KPiAtCXRmaWxlID0gcmN1X2RlcmVmZXJlbmNlKHR1bi0+
dGZpbGVzW3NtcF9wcm9jZXNzb3JfaWQoKSAlDQo+IC0JCQkJCSAgICBudW1xdWV1ZXNdKTsNCj4g
LQ0KPiAgCXNwaW5fbG9jaygmdGZpbGUtPnR4X3JpbmcucHJvZHVjZXJfbG9jayk7DQo+ICAJZm9y
IChpID0gMDsgaSA8IG47IGkrKykgew0KPiAgCQlzdHJ1Y3QgeGRwX2ZyYW1lICp4ZHAgPSBmcmFt
ZXNbaV07DQo+IC0tDQo+IDIuMTkuMQ0K
