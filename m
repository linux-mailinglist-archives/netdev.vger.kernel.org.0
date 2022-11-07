Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0DB61EA64
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 06:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiKGFYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 00:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiKGFYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 00:24:31 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AFADED9;
        Sun,  6 Nov 2022 21:24:27 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 267C45FD03;
        Mon,  7 Nov 2022 08:24:25 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1667798665;
        bh=N/FJrbNYXYSHo6GVXdgb2GwN2aXLggaKpUpoNvMndF8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=AI6aNfQmzkvbMKP5een6s3GFl/6zamWOUECSUIevf2b42d+8O7rWzSD/XExHclZUT
         t5rsmQCuWdAUnpbiZwhOpwJf67ttTYfmKrIVsc+gT1s7nxt/lF7kvoo6hT556DBd17
         8+xizvcXp3TJ59HSEZAaa5f0iMFxjjrcyboMM5qnAolSnjzUmwIg+RXOAUCuG75hbS
         kbNavo7VmHbYg4vjabqhoLGw5f8XcKA6fHX17WFy6bbk5NtFYmyHAgffuJgBP2UJWo
         8zwqUJ4+aLgWhlttio9CSPP8KMTqGydWPp+a+dZL+3aD+AcTlEtBYVEvw0sVM1oZ1S
         R4yWrf/7TcJ7A==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  7 Nov 2022 08:24:21 +0300 (MSK)
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
Thread-Index: AQHY8hcBEbxDmf4aG021vuOLUMusCa4yG6IAgACgBwA=
Date:   Mon, 7 Nov 2022 05:23:47 +0000
Message-ID: <278ee0cc-83ae-5c26-7718-d0472841e049@sberdevices.ru>
References: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
 <f896b8fd-50d2-2512-3966-3775245e9b96@sberdevices.ru>
 <3c6de80a-8fc1-0c63-6d2d-3eee294fe0a7@wanadoo.fr>
In-Reply-To: <3c6de80a-8fc1-0c63-6d2d-3eee294fe0a7@wanadoo.fr>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <08141BE9C325D14E9FD1A056E8394ECB@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/06 22:06:00 #20575944
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDYuMTEuMjAyMiAyMjo1MCwgQ2hyaXN0b3BoZSBKQUlMTEVUIHdyb3RlOg0KPiBMZSAwNi8x
MS8yMDIyIMOgIDIwOjM2LCBBcnNlbml5IEtyYXNub3YgYSDDqWNyaXTCoDoNCj4+IFRvIHN1cHBv
cnQgemVyb2NvcHkgcmVjZWl2ZSwgcGFja2V0J3MgYnVmZmVyIGFsbG9jYXRpb24gaXMgY2hhbmdl
ZDogZm9yDQo+PiBidWZmZXJzIHdoaWNoIGNvdWxkIGJlIG1hcHBlZCB0byB1c2VyJ3Mgdm1hIHdl
IGNhbid0IHVzZSAna21hbGxvYygpJyhhcw0KPj4ga2VybmVsIHJlc3RyaWN0cyB0byBtYXAgc2xh
YiBwYWdlcyB0byB1c2VyJ3Mgdm1hKSBhbmQgcmF3IGJ1ZGR5DQo+PiBhbGxvY2F0b3Igbm93IGNh
bGxlZC4gQnV0LCBmb3IgdHggcGFja2V0cyhzdWNoIHBhY2tldHMgd29uJ3QgYmUgbWFwcGVkDQo+
PiB0byB1c2VyKSwgcHJldmlvdXMgJ2ttYWxsb2MoKScgd2F5IGlzIHVzZWQsIGJ1dCB3aXRoIHNw
ZWNpYWwgZmxhZyBpbg0KPj4gcGFja2V0J3Mgc3RydWN0dXJlIHdoaWNoIGFsbG93cyB0byBkaXN0
aW5ndWlzaCBiZXR3ZWVuICdrbWFsbG9jKCknIGFuZA0KPj4gcmF3IHBhZ2VzIGJ1ZmZlcnMuDQo+
Pg0KPj4gU2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmlj
ZXMucnU+DQo+PiAtLS0NCj4+IMKgIGRyaXZlcnMvdmhvc3QvdnNvY2suY8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMSArDQo+PiDCoCBpbmNsdWRlL2xpbnV4L3ZpcnRp
b192c29jay5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMSArDQo+PiDCoCBuZXQvdm13X3Zz
b2NrL3ZpcnRpb190cmFuc3BvcnQuY8KgwqDCoMKgwqDCoMKgIHzCoCA4ICsrKysrKy0tDQo+PiDC
oCBuZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMgfCAxMCArKysrKysrKyst
DQo+PiDCoCA0IGZpbGVzIGNoYW5nZWQsIDE3IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0p
DQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvdnNvY2suYyBiL2RyaXZlcnMvdmhv
c3QvdnNvY2suYw0KPj4gaW5kZXggNTcwMzc3NWFmMTI5Li42NTQ3NWQxMjhhMWQgMTAwNjQ0DQo+
PiAtLS0gYS9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMNCj4+ICsrKyBiL2RyaXZlcnMvdmhvc3QvdnNv
Y2suYw0KPj4gQEAgLTM5OSw2ICszOTksNyBAQCB2aG9zdF92c29ja19hbGxvY19wa3Qoc3RydWN0
IHZob3N0X3ZpcnRxdWV1ZSAqdnEsDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIE5VTEw7
DQo+PiDCoMKgwqDCoMKgIH0NCj4+IMKgICvCoMKgwqAgcGt0LT5zbGFiX2J1ZiA9IHRydWU7DQo+
PiDCoMKgwqDCoMKgIHBrdC0+YnVmX2xlbiA9IHBrdC0+bGVuOw0KPj4gwqAgwqDCoMKgwqDCoCBu
Ynl0ZXMgPSBjb3B5X2Zyb21faXRlcihwa3QtPmJ1ZiwgcGt0LT5sZW4sICZpb3ZfaXRlcik7DQo+
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC92aXJ0aW9fdnNvY2suaCBiL2luY2x1ZGUvbGlu
dXgvdmlydGlvX3Zzb2NrLmgNCj4+IGluZGV4IDM1ZDdlZWRiNWU4ZS4uZDAyY2I3YWE5MjJmIDEw
MDY0NA0KPj4gLS0tIGEvaW5jbHVkZS9saW51eC92aXJ0aW9fdnNvY2suaA0KPj4gKysrIGIvaW5j
bHVkZS9saW51eC92aXJ0aW9fdnNvY2suaA0KPj4gQEAgLTUwLDYgKzUwLDcgQEAgc3RydWN0IHZp
cnRpb192c29ja19wa3Qgew0KPj4gwqDCoMKgwqDCoCB1MzIgb2ZmOw0KPj4gwqDCoMKgwqDCoCBi
b29sIHJlcGx5Ow0KPj4gwqDCoMKgwqDCoCBib29sIHRhcF9kZWxpdmVyZWQ7DQo+PiArwqDCoMKg
IGJvb2wgc2xhYl9idWY7DQo+PiDCoCB9Ow0KPj4gwqAgwqAgc3RydWN0IHZpcnRpb192c29ja19w
a3RfaW5mbyB7DQo+PiBkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0
LmMgYi9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnQuYw0KPj4gaW5kZXggYWQ2NGY0MDM1
MzZhLi4xOTkwOWMxZTliYTMgMTAwNjQ0DQo+PiAtLS0gYS9uZXQvdm13X3Zzb2NrL3ZpcnRpb190
cmFuc3BvcnQuYw0KPj4gKysrIGIvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0LmMNCj4+
IEBAIC0yNTUsMTYgKzI1NSwyMCBAQCBzdGF0aWMgdm9pZCB2aXJ0aW9fdnNvY2tfcnhfZmlsbChz
dHJ1Y3QgdmlydGlvX3Zzb2NrICp2c29jaykNCj4+IMKgwqDCoMKgwqAgdnEgPSB2c29jay0+dnFz
W1ZTT0NLX1ZRX1JYXTsNCj4+IMKgIMKgwqDCoMKgwqAgZG8gew0KPj4gK8KgwqDCoMKgwqDCoMKg
IHN0cnVjdCBwYWdlICpidWZfcGFnZTsNCj4+ICsNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBwa3Qg
PSBremFsbG9jKHNpemVvZigqcGt0KSwgR0ZQX0tFUk5FTCk7DQo+PiDCoMKgwqDCoMKgwqDCoMKg
wqAgaWYgKCFwa3QpDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsNCj4+IMKg
IC3CoMKgwqDCoMKgwqDCoCBwa3QtPmJ1ZiA9IGttYWxsb2MoYnVmX2xlbiwgR0ZQX0tFUk5FTCk7
DQo+PiAtwqDCoMKgwqDCoMKgwqAgaWYgKCFwa3QtPmJ1Zikgew0KPj4gK8KgwqDCoMKgwqDCoMKg
IGJ1Zl9wYWdlID0gYWxsb2NfcGFnZShHRlBfS0VSTkVMKTsNCj4+ICsNCj4+ICvCoMKgwqDCoMKg
wqDCoCBpZiAoIWJ1Zl9wYWdlKSB7DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2aXJ0
aW9fdHJhbnNwb3J0X2ZyZWVfcGt0KHBrdCk7DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBicmVhazsNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCB9DQo+PiDCoCArwqDCoMKgwqDCoMKgwqAg
cGt0LT5idWYgPSBwYWdlX3RvX3ZpcnQoYnVmX3BhZ2UpOw0KPj4gwqDCoMKgwqDCoMKgwqDCoMKg
IHBrdC0+YnVmX2xlbiA9IGJ1Zl9sZW47DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcGt0LT5sZW4g
PSBidWZfbGVuOw0KPj4gwqAgZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5z
cG9ydF9jb21tb24uYyBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYw0K
Pj4gaW5kZXggYTk5ODBlOWI5MzA0Li4zN2U4ZGJmZTJmNWQgMTAwNjQ0DQo+PiAtLS0gYS9uZXQv
dm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMNCj4+ICsrKyBiL25ldC92bXdfdnNv
Y2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYw0KPj4gQEAgLTY5LDYgKzY5LDcgQEAgdmlydGlv
X3RyYW5zcG9ydF9hbGxvY19wa3Qoc3RydWN0IHZpcnRpb192c29ja19wa3RfaW5mbyAqaW5mbywN
Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoIXBrdC0+YnVmKQ0KPj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgZ290byBvdXRfcGt0Ow0KPj4gwqAgK8KgwqDCoMKgwqDCoMKgIHBrdC0+c2xh
Yl9idWYgPSB0cnVlOw0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgIHBrdC0+YnVmX2xlbiA9IGxlbjsN
Cj4+IMKgIMKgwqDCoMKgwqDCoMKgwqDCoCBlcnIgPSBtZW1jcHlfZnJvbV9tc2cocGt0LT5idWYs
IGluZm8tPm1zZywgbGVuKTsNCj4+IEBAIC0xMzM5LDcgKzEzNDAsMTQgQEAgRVhQT1JUX1NZTUJP
TF9HUEwodmlydGlvX3RyYW5zcG9ydF9yZWN2X3BrdCk7DQo+PiDCoCDCoCB2b2lkIHZpcnRpb190
cmFuc3BvcnRfZnJlZV9wa3Qoc3RydWN0IHZpcnRpb192c29ja19wa3QgKnBrdCkNCj4+IMKgIHsN
Cj4+IC3CoMKgwqAga3ZmcmVlKHBrdC0+YnVmKTsNCj4+ICvCoMKgwqAgaWYgKHBrdC0+YnVmX2xl
bikgew0KPj4gK8KgwqDCoMKgwqDCoMKgIGlmIChwa3QtPnNsYWJfYnVmKQ0KPj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqAga3ZmcmVlKHBrdC0+YnVmKTsNCj4gDQo+IEhpLA0KPiANCj4ga2ZyZWUo
KT8gKGFjY29yZGluZyB0byB2aXJ0aW9fdHJhbnNwb3J0X2FsbG9jX3BrdCgpIGluIC1uZXh0KSBv
ciBzb21ldGhpbmcgZWxzZSBuZWVkIHRvIGJlIGNoYW5nZWQuDQo+IA0KSGVsbG8gQ3Jpc3RvcGhl
LA0KDQpJIHRoaW5rLCAna3ZmcmVlKCknIGlzIHN0aWxsIG5lZWRlZCBoZXJlLCBiZWNhdXNlIGJ1
ZmZlciBmb3IgcGFja2V0IGNvdWxkIGJlIGFsbG9jYXRlZCBieSAna3ZtYWxsb2MoKScNCmluIGRy
aXZlcnMvdmhvc3QvdnNvY2suYy4gQ29ycmVjdCBtZSBpZiBpJ20gd3JvbmcuDQoNCj4+ICvCoMKg
wqDCoMKgwqDCoCBlbHNlDQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmcmVlX3BhZ2VzKCh1
bnNpZ25lZCBsb25nKXBrdC0+YnVmLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBnZXRfb3JkZXIocGt0LT5idWZfbGVuKSk7DQo+IA0KPiBJbiB2aXJ0aW9fdnNvY2tf
cnhfZmlsbCgpLCBvbmx5IGFsbG9jX3BhZ2UoKSBpcyB1c2VkLg0KPiANCj4gU2hvdWxkIHRoaXMg
YmUgYWxsb2NfcGFnZXMoLi4sIGdldF9vcmRlcihidWZfbGVuKSkgb3IgZnJlZV9wYWdlKCkgKHdp
dGhvdXQgYW4gJ3MnKSBoZXJlPw0KVGhpcyBmdW5jdGlvbiBmcmVlcyBwYWNrZXRzIHdoaWNoIHdl
cmUgYWxsb2NhdGVkIGluIHZob3N0IHBhdGggYWxzby4gSW4gdmhvc3QsIGZvciB6ZXJvY29weQ0K
cGFja2V0cyBhbGxvY19wYWdlUygpIGlzIHVzZWQuDQoNClRoYW5rIFlvdSwgQXJzZW5peQ0KPiAN
Cj4gSnVzdCBteSAyYywNCj4gDQo+IENKDQo+IA0KPj4gK8KgwqDCoCB9DQo+PiArDQo+PiDCoMKg
wqDCoMKgIGtmcmVlKHBrdCk7DQo+PiDCoCB9DQo+PiDCoCBFWFBPUlRfU1lNQk9MX0dQTCh2aXJ0
aW9fdHJhbnNwb3J0X2ZyZWVfcGt0KTsNCj4gDQoNCg==
