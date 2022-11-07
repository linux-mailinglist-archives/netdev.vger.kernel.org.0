Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4BA62012E
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 22:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbiKGVcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 16:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiKGVcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 16:32:08 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB042CE2F;
        Mon,  7 Nov 2022 13:32:05 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id AF6C15FD0E;
        Tue,  8 Nov 2022 00:32:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1667856722;
        bh=US8mQjtPjQ+nTIYQ67lAnGXw53YUjkbVl/Fx3nsXJKY=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=i2QWWyBJFv+A7DLrAVRNM4QRt6AYiFjTJ6kKSORO6+G1hW1GkYiUqGvGPuqp6iYX2
         Tdz4hCGG/sMpvw3kortFs6Q81JA0JlJfqTmAvfvXNr+2S+cVfAf1kuz9BCPhyuHOzA
         Br53my2rdDPKE9PcHflZF/Jq5iW5OboKfgjnxP+0O4dX+kbZsQ5B54pSEXFn7Ayd43
         NemCPJGruWQDNkJxt7n693wX/X6nQDVUCrPSjWRB0urfSUl3+DoNPS3Xv6CGLAN3Y/
         xh00cwS4g+2epgFDtJLUPmiBWVHXrL+FXgEbOVPA5pewoZb8BUJtqDIw8VVX74QV0r
         OsFaI6PQT1zqQ==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue,  8 Nov 2022 00:32:00 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Krasnov Arseniy" <oxffffaa@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 01/11] virtio/vsock: rework packet allocation logic
Thread-Topic: [RFC PATCH v3 01/11] virtio/vsock: rework packet allocation
 logic
Thread-Index: AQHY8hcBEbxDmf4aG021vuOLUMusCa4yG6IAgACgBwCAAQxlgIAAAfSA
Date:   Mon, 7 Nov 2022 21:31:20 +0000
Message-ID: <76b4ee49-e3b0-34be-6b81-f58bc2bc3dcc@sberdevices.ru>
References: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
 <f896b8fd-50d2-2512-3966-3775245e9b96@sberdevices.ru>
 <3c6de80a-8fc1-0c63-6d2d-3eee294fe0a7@wanadoo.fr>
 <278ee0cc-83ae-5c26-7718-d0472841e049@sberdevices.ru>
 <6a0adc0d-da54-9c9b-3596-3422353e285d@wanadoo.fr>
In-Reply-To: <6a0adc0d-da54-9c9b-3596-3422353e285d@wanadoo.fr>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E5A8D8A54BFEE45911937884202227E@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/07 12:25:00 #20578330
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDguMTEuMjAyMiAwMDoyNCwgQ2hyaXN0b3BoZSBKQUlMTEVUIHdyb3RlOg0KPiBMZSAwNy8x
MS8yMDIyIMOgIDA2OjIzLCBBcnNlbml5IEtyYXNub3YgYSDDqWNyaXTCoDoNCj4+IE9uIDA2LjEx
LjIwMjIgMjI6NTAsIENocmlzdG9waGUgSkFJTExFVCB3cm90ZToNCj4+PiBMZSAwNi8xMS8yMDIy
IMOgIDIwOjM2LCBBcnNlbml5IEtyYXNub3YgYSDDqWNyaXTCoDoNCj4+Pj4gVG8gc3VwcG9ydCB6
ZXJvY29weSByZWNlaXZlLCBwYWNrZXQncyBidWZmZXIgYWxsb2NhdGlvbiBpcyBjaGFuZ2VkOiBm
b3INCj4+Pj4gYnVmZmVycyB3aGljaCBjb3VsZCBiZSBtYXBwZWQgdG8gdXNlcidzIHZtYSB3ZSBj
YW4ndCB1c2UgJ2ttYWxsb2MoKScoYXMNCj4+Pj4ga2VybmVsIHJlc3RyaWN0cyB0byBtYXAgc2xh
YiBwYWdlcyB0byB1c2VyJ3Mgdm1hKSBhbmQgcmF3IGJ1ZGR5DQo+Pj4+IGFsbG9jYXRvciBub3cg
Y2FsbGVkLiBCdXQsIGZvciB0eCBwYWNrZXRzKHN1Y2ggcGFja2V0cyB3b24ndCBiZSBtYXBwZWQN
Cj4+Pj4gdG8gdXNlciksIHByZXZpb3VzICdrbWFsbG9jKCknIHdheSBpcyB1c2VkLCBidXQgd2l0
aCBzcGVjaWFsIGZsYWcgaW4NCj4+Pj4gcGFja2V0J3Mgc3RydWN0dXJlIHdoaWNoIGFsbG93cyB0
byBkaXN0aW5ndWlzaCBiZXR3ZWVuICdrbWFsbG9jKCknIGFuZA0KPj4+PiByYXcgcGFnZXMgYnVm
ZmVycy4NCj4+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNu
b3ZAc2JlcmRldmljZXMucnU+DQo+Pj4+IC0tLQ0KPj4+PiDCoMKgIGRyaXZlcnMvdmhvc3QvdnNv
Y2suY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMSArDQo+Pj4+IMKg
wqAgaW5jbHVkZS9saW51eC92aXJ0aW9fdnNvY2suaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKg
IDEgKw0KPj4+PiDCoMKgIG5ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jwqDCoMKgwqDC
oMKgwqAgfMKgIDggKysrKysrLS0NCj4+Pj4gwqDCoCBuZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFu
c3BvcnRfY29tbW9uLmMgfCAxMCArKysrKysrKystDQo+Pj4+IMKgwqAgNCBmaWxlcyBjaGFuZ2Vk
LCAxNyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy92aG9zdC92c29jay5jIGIvZHJpdmVycy92aG9zdC92c29jay5jDQo+Pj4+IGlu
ZGV4IDU3MDM3NzVhZjEyOS4uNjU0NzVkMTI4YTFkIDEwMDY0NA0KPj4+PiAtLS0gYS9kcml2ZXJz
L3Zob3N0L3Zzb2NrLmMNCj4+Pj4gKysrIGIvZHJpdmVycy92aG9zdC92c29jay5jDQo+Pj4+IEBA
IC0zOTksNiArMzk5LDcgQEAgdmhvc3RfdnNvY2tfYWxsb2NfcGt0KHN0cnVjdCB2aG9zdF92aXJ0
cXVldWUgKnZxLA0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gTlVMTDsNCj4+Pj4g
wqDCoMKgwqDCoMKgIH0NCj4+Pj4gwqDCoCArwqDCoMKgIHBrdC0+c2xhYl9idWYgPSB0cnVlOw0K
Pj4+PiDCoMKgwqDCoMKgwqAgcGt0LT5idWZfbGVuID0gcGt0LT5sZW47DQo+Pj4+IMKgwqAgwqDC
oMKgwqDCoCBuYnl0ZXMgPSBjb3B5X2Zyb21faXRlcihwa3QtPmJ1ZiwgcGt0LT5sZW4sICZpb3Zf
aXRlcik7DQo+Pj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3ZpcnRpb192c29jay5oIGIv
aW5jbHVkZS9saW51eC92aXJ0aW9fdnNvY2suaA0KPj4+PiBpbmRleCAzNWQ3ZWVkYjVlOGUuLmQw
MmNiN2FhOTIyZiAxMDA2NDQNCj4+Pj4gLS0tIGEvaW5jbHVkZS9saW51eC92aXJ0aW9fdnNvY2su
aA0KPj4+PiArKysgYi9pbmNsdWRlL2xpbnV4L3ZpcnRpb192c29jay5oDQo+Pj4+IEBAIC01MCw2
ICs1MCw3IEBAIHN0cnVjdCB2aXJ0aW9fdnNvY2tfcGt0IHsNCj4+Pj4gwqDCoMKgwqDCoMKgIHUz
MiBvZmY7DQo+Pj4+IMKgwqDCoMKgwqDCoCBib29sIHJlcGx5Ow0KPj4+PiDCoMKgwqDCoMKgwqAg
Ym9vbCB0YXBfZGVsaXZlcmVkOw0KPj4+PiArwqDCoMKgIGJvb2wgc2xhYl9idWY7DQo+Pj4+IMKg
wqAgfTsNCj4+Pj4gwqDCoCDCoCBzdHJ1Y3QgdmlydGlvX3Zzb2NrX3BrdF9pbmZvIHsNCj4+Pj4g
ZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jIGIvbmV0L3Ztd192
c29jay92aXJ0aW9fdHJhbnNwb3J0LmMNCj4+Pj4gaW5kZXggYWQ2NGY0MDM1MzZhLi4xOTkwOWMx
ZTliYTMgMTAwNjQ0DQo+Pj4+IC0tLSBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5j
DQo+Pj4+ICsrKyBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jDQo+Pj4+IEBAIC0y
NTUsMTYgKzI1NSwyMCBAQCBzdGF0aWMgdm9pZCB2aXJ0aW9fdnNvY2tfcnhfZmlsbChzdHJ1Y3Qg
dmlydGlvX3Zzb2NrICp2c29jaykNCj4+Pj4gwqDCoMKgwqDCoMKgIHZxID0gdnNvY2stPnZxc1tW
U09DS19WUV9SWF07DQo+Pj4+IMKgwqAgwqDCoMKgwqDCoCBkbyB7DQo+Pj4+ICvCoMKgwqDCoMKg
wqDCoCBzdHJ1Y3QgcGFnZSAqYnVmX3BhZ2U7DQo+Pj4+ICsNCj4+Pj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcGt0ID0ga3phbGxvYyhzaXplb2YoKnBrdCksIEdGUF9LRVJORUwpOw0KPj4+PiDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBpZiAoIXBrdCkNCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBicmVhazsNCj4+Pj4gwqDCoCAtwqDCoMKgwqDCoMKgwqAgcGt0LT5idWYgPSBrbWFsbG9j
KGJ1Zl9sZW4sIEdGUF9LRVJORUwpOw0KPj4+PiAtwqDCoMKgwqDCoMKgwqAgaWYgKCFwa3QtPmJ1
Zikgew0KPj4+PiArwqDCoMKgwqDCoMKgwqAgYnVmX3BhZ2UgPSBhbGxvY19wYWdlKEdGUF9LRVJO
RUwpOw0KPj4+PiArDQo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAoIWJ1Zl9wYWdlKSB7DQo+Pj4+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmlydGlvX3RyYW5zcG9ydF9mcmVlX3BrdChw
a3QpOw0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOw0KPj4+PiDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB9DQo+Pj4+IMKgwqAgK8KgwqDCoMKgwqDCoMKgIHBrdC0+YnVmID0g
cGFnZV90b192aXJ0KGJ1Zl9wYWdlKTsNCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgcGt0LT5i
dWZfbGVuID0gYnVmX2xlbjsNCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgcGt0LT5sZW4gPSBi
dWZfbGVuOw0KPj4+PiDCoMKgIGRpZmYgLS1naXQgYS9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFu
c3BvcnRfY29tbW9uLmMgYi9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMN
Cj4+Pj4gaW5kZXggYTk5ODBlOWI5MzA0Li4zN2U4ZGJmZTJmNWQgMTAwNjQ0DQo+Pj4+IC0tLSBh
L25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYw0KPj4+PiArKysgYi9uZXQv
dm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMNCj4+Pj4gQEAgLTY5LDYgKzY5LDcg
QEAgdmlydGlvX3RyYW5zcG9ydF9hbGxvY19wa3Qoc3RydWN0IHZpcnRpb192c29ja19wa3RfaW5m
byAqaW5mbywNCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKCFwa3QtPmJ1ZikNCj4+Pj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dF9wa3Q7DQo+Pj4+IMKgwqAgK8Kg
wqDCoMKgwqDCoMKgIHBrdC0+c2xhYl9idWYgPSB0cnVlOw0KPj4+PiDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBwa3QtPmJ1Zl9sZW4gPSBsZW47DQo+Pj4+IMKgwqAgwqDCoMKgwqDCoMKgwqDCoMKgIGVy
ciA9IG1lbWNweV9mcm9tX21zZyhwa3QtPmJ1ZiwgaW5mby0+bXNnLCBsZW4pOw0KPj4+PiBAQCAt
MTMzOSw3ICsxMzQwLDE0IEBAIEVYUE9SVF9TWU1CT0xfR1BMKHZpcnRpb190cmFuc3BvcnRfcmVj
dl9wa3QpOw0KPj4+PiDCoMKgIMKgIHZvaWQgdmlydGlvX3RyYW5zcG9ydF9mcmVlX3BrdChzdHJ1
Y3QgdmlydGlvX3Zzb2NrX3BrdCAqcGt0KQ0KPj4+PiDCoMKgIHsNCj4+Pj4gLcKgwqDCoCBrdmZy
ZWUocGt0LT5idWYpOw0KPj4+PiArwqDCoMKgIGlmIChwa3QtPmJ1Zl9sZW4pIHsNCj4+Pj4gK8Kg
wqDCoMKgwqDCoMKgIGlmIChwa3QtPnNsYWJfYnVmKQ0KPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBrdmZyZWUocGt0LT5idWYpOw0KPj4+DQo+Pj4gSGksDQo+Pj4NCj4+PiBrZnJlZSgpPyAo
YWNjb3JkaW5nIHRvIHZpcnRpb190cmFuc3BvcnRfYWxsb2NfcGt0KCkgaW4gLW5leHQpIG9yIHNv
bWV0aGluZyBlbHNlIG5lZWQgdG8gYmUgY2hhbmdlZC4NCj4+Pg0KPj4gSGVsbG8gQ3Jpc3RvcGhl
LA0KPj4NCj4+IEkgdGhpbmssICdrdmZyZWUoKScgaXMgc3RpbGwgbmVlZGVkIGhlcmUsIGJlY2F1
c2UgYnVmZmVyIGZvciBwYWNrZXQgY291bGQgYmUgYWxsb2NhdGVkIGJ5ICdrdm1hbGxvYygpJw0K
Pj4gaW4gZHJpdmVycy92aG9zdC92c29jay5jLiBDb3JyZWN0IG1lIGlmIGknbSB3cm9uZy4NCj4g
DQo+IEFncmVlZC4NCj4gDQo+Pg0KPj4+PiArwqDCoMKgwqDCoMKgwqAgZWxzZQ0KPj4+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBmcmVlX3BhZ2VzKCh1bnNpZ25lZCBsb25nKXBrdC0+YnVmLA0K
Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdldF9vcmRlcihwa3Qt
PmJ1Zl9sZW4pKTsNCj4+Pg0KPj4+IEluIHZpcnRpb192c29ja19yeF9maWxsKCksIG9ubHkgYWxs
b2NfcGFnZSgpIGlzIHVzZWQuDQo+Pj4NCj4+PiBTaG91bGQgdGhpcyBiZSBhbGxvY19wYWdlcygu
LiwgZ2V0X29yZGVyKGJ1Zl9sZW4pKSBvciBmcmVlX3BhZ2UoKSAod2l0aG91dCBhbiAncycpIGhl
cmU/DQo+PiBUaGlzIGZ1bmN0aW9uIGZyZWVzIHBhY2tldHMgd2hpY2ggd2VyZSBhbGxvY2F0ZWQg
aW4gdmhvc3QgcGF0aCBhbHNvLiBJbiB2aG9zdCwgZm9yIHplcm9jb3B5DQo+PiBwYWNrZXRzIGFs
bG9jX3BhZ2VTKCkgaXMgdXNlZC4NCj4gDQo+IE9rLiBTZWVuIGluIHBhdGNoIDUvMTEuDQo+IA0K
PiBCdXQgd291bGRuJ3QgaXQgYmUgY2xlYW5lciBhbmQgZnV0dXJlLXByb29mIHRvIGFsc28gaGF2
ZSBhbGxvY19wYWdlUygpIGluIHZpcnRpb192c29ja19yeF9maWxsKCksIGV2ZW4gaWYgZ2V0X29y
ZGVyKGJ1Zi0+bGVuKSBpcyBrd293biB0byBiZSAwPw0KPiANCj4gV2hhdCwgaWYgZm9yIHNvbWUg
cmVhc29uIGEgUEFHRV9TSVpFIHdhcyA8IDRrYiBmb3IgYSBnaXZlbiBhcmNoLCBvciBWSVJUSU9f
VlNPQ0tfREVGQVVMVF9SWF9CVUZfU0laRSBpbmNyZWFzZWQ/DQpZZXMsIGkgc2VlLiBZb3UncmUg
cmlnaHQuIEl0IHdpbGwgYmUgY29ycmVjdCB0byB1c2UgYWxsb2NfcGFnZXMoZ2V0X29yZGVyKGJ1
Zi0+bGVuKSksIGJlY2F1c2UgaW4gY3VycmVudCB2ZXJzaW9uLCByZWFsIGxlbmd0aCBvZg0KcGFj
a2V0IGJ1ZmZlcihlLmcuIHNpbmdsZSBwYWdlKSBpcyB0b3RhbGx5IHVucmVsYXRlZCB3aXRoIFZJ
UlRJT19WU09DS19ERUZBVUxUX1JYX0JVRl9TSVpFLiBJJ2xsIGZpeCBpdCBpbiBuZXh0IHZlcnNp
b24uDQoNClRoYW5rIFlvdQ0KPiANCj4gQ0oNCj4gDQo+Pg0KPj4gVGhhbmsgWW91LCBBcnNlbml5
DQo+Pj4NCj4+PiBKdXN0IG15IDJjLA0KPj4+DQo+Pj4gQ0oNCj4+Pg0KPj4+PiArwqDCoMKgIH0N
Cj4+Pj4gKw0KPj4+PiDCoMKgwqDCoMKgwqAga2ZyZWUocGt0KTsNCj4+Pj4gwqDCoCB9DQo+Pj4+
IMKgwqAgRVhQT1JUX1NZTUJPTF9HUEwodmlydGlvX3RyYW5zcG9ydF9mcmVlX3BrdCk7DQo+Pj4N
Cj4+DQo+IA0KDQo=
