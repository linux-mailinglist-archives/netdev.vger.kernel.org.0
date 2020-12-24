Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401A52E2431
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 05:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgLXEio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 23:38:44 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2410 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgLXEio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 23:38:44 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4D1cjr2zzLz55gY;
        Thu, 24 Dec 2020 12:37:04 +0800 (CST)
Received: from DGGEMM533-MBX.china.huawei.com ([169.254.5.214]) by
 DGGEMM401-HUB.china.huawei.com ([10.3.20.209]) with mapi id 14.03.0509.000;
 Thu, 24 Dec 2020 12:37:53 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Subject: RE: [PATCH net v4 2/2] vhost_net: fix tx queue stuck when sendmsg
 fails
Thread-Topic: [PATCH net v4 2/2] vhost_net: fix tx queue stuck when sendmsg
 fails
Thread-Index: AQHW2ZwauZy8siBskUC5fxxdcA2PEKoFC1CAgACM7xA=
Date:   Thu, 24 Dec 2020 04:37:52 +0000
Message-ID: <34EFBCA9F01B0748BEB6B629CE643AE60DB8ED23@DGGEMM533-MBX.china.huawei.com>
References: <1608776746-4040-1-git-send-email-wangyunjian@huawei.com>
 <c854850b-43ab-c98d-a4d8-36ad7cd6364c@redhat.com>
In-Reply-To: <c854850b-43ab-c98d-a4d8-36ad7cd6364c@redhat.com>
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
amFzb3dhbmdAcmVkaGF0LmNvbV0NCj4gU2VudDogVGh1cnNkYXksIERlY2VtYmVyIDI0LCAyMDIw
IDExOjEwIEFNDQo+IFRvOiB3YW5neXVuamlhbiA8d2FuZ3l1bmppYW5AaHVhd2VpLmNvbT47IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IG1zdEByZWRoYXQuY29tOyB3aWxsZW1kZWJydWlqbi5r
ZXJuZWxAZ21haWwuY29tDQo+IENjOiB2aXJ0dWFsaXphdGlvbkBsaXN0cy5saW51eC1mb3VuZGF0
aW9uLm9yZzsgTGlsaWp1biAoSmVycnkpDQo+IDxqZXJyeS5saWxpanVuQGh1YXdlaS5jb20+OyBj
aGVuY2hhbmdodSA8Y2hlbmNoYW5naHVAaHVhd2VpLmNvbT47DQo+IHh1ZGluZ2tlIDx4dWRpbmdr
ZUBodWF3ZWkuY29tPjsgaHVhbmdiaW4gKEopDQo+IDxicmlhbi5odWFuZ2JpbkBodWF3ZWkuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldCB2NCAyLzJdIHZob3N0X25ldDogZml4IHR4IHF1
ZXVlIHN0dWNrIHdoZW4gc2VuZG1zZw0KPiBmYWlscw0KPiANCj4gDQo+IE9uIDIwMjAvMTIvMjQg
5LiK5Y2IMTA6MjUsIHdhbmd5dW5qaWFuIHdyb3RlOg0KPiA+IEZyb206IFl1bmppYW4gV2FuZyA8
d2FuZ3l1bmppYW5AaHVhd2VpLmNvbT4NCj4gPg0KPiA+IEN1cnJlbnRseSB0aGUgZHJpdmVyIGRv
ZXNuJ3QgZHJvcCBhIHBhY2tldCB3aGljaCBjYW4ndCBiZSBzZW50IGJ5IHR1bg0KPiA+IChlLmcg
YmFkIHBhY2tldCkuIEluIHRoaXMgY2FzZSwgdGhlIGRyaXZlciB3aWxsIGFsd2F5cyBwcm9jZXNz
IHRoZQ0KPiA+IHNhbWUgcGFja2V0IGxlYWQgdG8gdGhlIHR4IHF1ZXVlIHN0dWNrLg0KPiA+DQo+
ID4gVG8gZml4IHRoaXMgaXNzdWU6DQo+ID4gMS4gaW4gdGhlIGNhc2Ugb2YgcGVyc2lzdGVudCBm
YWlsdXJlIChlLmcgYmFkIHBhY2tldCksIHRoZSBkcml2ZXIgY2FuDQo+ID4gc2tpcCB0aGlzIGRl
c2NyaXB0b3IgYnkgaWdub3JpbmcgdGhlIGVycm9yLg0KPiA+IDIuIGluIHRoZSBjYXNlIG9mIHRy
YW5zaWVudCBmYWlsdXJlIChlLmcgLUVBR0FJTiBhbmQgLUVOT01FTSksIHRoZQ0KPiA+IGRyaXZl
ciBzY2hlZHVsZXMgdGhlIHdvcmtlciB0byB0cnkgYWdhaW4uDQo+IA0KPiANCj4gSSBtaWdodCBi
ZSB3cm9uZyBidXQgbG9va2luZyBhdCBhbGxvY19za2Jfd2l0aF9mcmFncygpLCBpdCByZXR1cm5z
IC1FTk9CVUZTDQo+IGFjdHVhbGx5Og0KPiANCj4gIMKgwqDCoCAqZXJyY29kZSA9IC1FTk9CVUZT
Ow0KPiAgwqDCoMKgIHNrYiA9IGFsbG9jX3NrYihoZWFkZXJfbGVuLCBnZnBfbWFzayk7DQo+ICDC
oMKgwqAgaWYgKCFza2IpDQo+ICDCoMKgwqAgwqDCoMKgIHJldHVybiBOVUxMOw0KDQpZZXMsIGJ1
dCB0aGUgc29ja19hbGxvY19zZW5kX3Bza2IoKSByZXR1cm5zIC0gRUFHQUlOIHdoZW4gbm8gc25k
YnVmIHNwYWNlLg0KU28gdGhlcmUgaXMgbmVlZCB0byBjaGVjayByZXR1cm4gdmFsdWUgd2hpY2gg
aXMgLUVBR0FJTiBvciAtRU5PTUVNIG9yIC0gRUFHQUlOPw0KDQpzdHJ1Y3Qgc2tfYnVmZiAqc29j
a19hbGxvY19zZW5kX3Bza2IoKQ0Kew0KLi4uDQoJZm9yICg7Oykgew0KLi4uDQoJCXNrX3NldF9i
aXQoU09DS1dRX0FTWU5DX05PU1BBQ0UsIHNrKTsNCgkJc2V0X2JpdChTT0NLX05PU1BBQ0UsICZz
ay0+c2tfc29ja2V0LT5mbGFncyk7DQoJCWVyciA9IC1FQUdBSU47DQoJCWlmICghdGltZW8pDQoJ
CQlnb3RvIGZhaWx1cmU7DQouLi4NCgl9DQoJc2tiID0gYWxsb2Nfc2tiX3dpdGhfZnJhZ3MoaGVh
ZGVyX2xlbiwgZGF0YV9sZW4sIG1heF9wYWdlX29yZGVyLA0KCQkJCSAgIGVycmNvZGUsIHNrLT5z
a19hbGxvY2F0aW9uKTsNCglpZiAoc2tiKQ0KCQlza2Jfc2V0X293bmVyX3coc2tiLCBzayk7DQoJ
cmV0dXJuIHNrYjsNCi4uLg0KCSplcnJjb2RlID0gZXJyOw0KCXJldHVybiBOVUxMOw0KfQ0KPiAN
Cj4gVGhhbmtzDQo+IA0KPiANCj4gPg0KPiA+IEZpeGVzOiAzYTRkNWM5NGU5NTkgKCJ2aG9zdF9u
ZXQ6IGEga2VybmVsLWxldmVsIHZpcnRpbyBzZXJ2ZXIiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFl1
bmppYW4gV2FuZyA8d2FuZ3l1bmppYW5AaHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGRyaXZl
cnMvdmhvc3QvbmV0LmMgfCAxNiArKysrKysrKy0tLS0tLS0tDQo+ID4gICAxIGZpbGUgY2hhbmdl
ZCwgOCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdmhvc3QvbmV0LmMgYi9kcml2ZXJzL3Zob3N0L25ldC5jIGluZGV4DQo+ID4gYzg3
ODRkZmFmZGQ3Li5lNzYyNDVkYWE3ZjYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy92aG9zdC9u
ZXQuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdmhvc3QvbmV0LmMNCj4gPiBAQCAtODI3LDE0ICs4Mjcs
MTMgQEAgc3RhdGljIHZvaWQgaGFuZGxlX3R4X2NvcHkoc3RydWN0IHZob3N0X25ldCAqbmV0LA0K
PiBzdHJ1Y3Qgc29ja2V0ICpzb2NrKQ0KPiA+ICAgCQkJCW1zZy5tc2dfZmxhZ3MgJj0gfk1TR19N
T1JFOw0KPiA+ICAgCQl9DQo+ID4NCj4gPiAtCQkvKiBUT0RPOiBDaGVjayBzcGVjaWZpYyBlcnJv
ciBhbmQgYm9tYiBvdXQgdW5sZXNzIEVOT0JVRlM/ICovDQo+ID4gICAJCWVyciA9IHNvY2stPm9w
cy0+c2VuZG1zZyhzb2NrLCAmbXNnLCBsZW4pOw0KPiA+IC0JCWlmICh1bmxpa2VseShlcnIgPCAw
KSkgew0KPiA+ICsJCWlmICh1bmxpa2VseShlcnIgPT0gLUVBR0FJTiB8fCBlcnIgPT0gLUVOT01F
TSkpIHsNCj4gPiAgIAkJCXZob3N0X2Rpc2NhcmRfdnFfZGVzYyh2cSwgMSk7DQo+ID4gICAJCQl2
aG9zdF9uZXRfZW5hYmxlX3ZxKG5ldCwgdnEpOw0KPiA+ICAgCQkJYnJlYWs7DQo+ID4gICAJCX0N
Cj4gPiAtCQlpZiAoZXJyICE9IGxlbikNCj4gPiArCQlpZiAoZXJyID49IDAgJiYgZXJyICE9IGxl
bikNCj4gPiAgIAkJCXByX2RlYnVnKCJUcnVuY2F0ZWQgVFggcGFja2V0OiBsZW4gJWQgIT0gJXpk
XG4iLA0KPiA+ICAgCQkJCSBlcnIsIGxlbik7DQo+ID4gICBkb25lOg0KPiA+IEBAIC05MjIsNyAr
OTIxLDYgQEAgc3RhdGljIHZvaWQgaGFuZGxlX3R4X3plcm9jb3B5KHN0cnVjdCB2aG9zdF9uZXQN
Cj4gKm5ldCwgc3RydWN0IHNvY2tldCAqc29jaykNCj4gPiAgIAkJCW1zZy5tc2dfZmxhZ3MgJj0g
fk1TR19NT1JFOw0KPiA+ICAgCQl9DQo+ID4NCj4gPiAtCQkvKiBUT0RPOiBDaGVjayBzcGVjaWZp
YyBlcnJvciBhbmQgYm9tYiBvdXQgdW5sZXNzIEVOT0JVRlM/ICovDQo+ID4gICAJCWVyciA9IHNv
Y2stPm9wcy0+c2VuZG1zZyhzb2NrLCAmbXNnLCBsZW4pOw0KPiA+ICAgCQlpZiAodW5saWtlbHko
ZXJyIDwgMCkpIHsNCj4gPiAgIAkJCWlmICh6Y29weV91c2VkKSB7DQo+ID4gQEAgLTkzMSwxMSAr
OTI5LDEzIEBAIHN0YXRpYyB2b2lkIGhhbmRsZV90eF96ZXJvY29weShzdHJ1Y3Qgdmhvc3RfbmV0
DQo+ICpuZXQsIHN0cnVjdCBzb2NrZXQgKnNvY2spDQo+ID4gICAJCQkJbnZxLT51cGVuZF9pZHgg
PSAoKHVuc2lnbmVkKW52cS0+dXBlbmRfaWR4IC0gMSkNCj4gPiAgIAkJCQkJJSBVSU9fTUFYSU9W
Ow0KPiA+ICAgCQkJfQ0KPiA+IC0JCQl2aG9zdF9kaXNjYXJkX3ZxX2Rlc2ModnEsIDEpOw0KPiA+
IC0JCQl2aG9zdF9uZXRfZW5hYmxlX3ZxKG5ldCwgdnEpOw0KPiA+IC0JCQlicmVhazsNCj4gPiAr
CQkJaWYgKGVyciA9PSAtRUFHQUlOIHx8IGVyciA9PSAtRU5PTUVNKSB7DQo+ID4gKwkJCQl2aG9z
dF9kaXNjYXJkX3ZxX2Rlc2ModnEsIDEpOw0KPiA+ICsJCQkJdmhvc3RfbmV0X2VuYWJsZV92cShu
ZXQsIHZxKTsNCj4gPiArCQkJCWJyZWFrOw0KPiA+ICsJCQl9DQo+ID4gICAJCX0NCj4gPiAtCQlp
ZiAoZXJyICE9IGxlbikNCj4gPiArCQlpZiAoZXJyID49IDAgJiYgZXJyICE9IGxlbikNCj4gPiAg
IAkJCXByX2RlYnVnKCJUcnVuY2F0ZWQgVFggcGFja2V0OiAiDQo+ID4gICAJCQkJICIgbGVuICVk
ICE9ICV6ZFxuIiwgZXJyLCBsZW4pOw0KPiA+ICAgCQlpZiAoIXpjb3B5X3VzZWQpDQoNCg==
