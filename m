Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C6569C733
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 10:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjBTJCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 04:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjBTJCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 04:02:37 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1191DFF1A;
        Mon, 20 Feb 2023 01:02:19 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 702CF5FD41;
        Mon, 20 Feb 2023 12:02:17 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1676883737;
        bh=VlvWeERXUiNtfOqASZFPm3v3jAcmeDDopMGQqrbvT0s=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=J+m0WkZnmzlrUGX2UbkJI3imxyijb1tHg5uUa0ACZ4ISi9fGSmEQklxKpUZV7DfV3
         9qghPfnMsrveL0x+VJYWCWQVCBv9/68nejkJbKMGIzPZjmGBdEuRJi8uAb0nh3US0V
         ldj8OpZ5s2gOgnEgFrzZzJGNrwS6X/4fHI1ZfTSS7LOxwa9C/BaIh7xbsP7fM7Bv7J
         eHaGgmIjNezbqqUYmWrvuSNvBC32IOxZ8tQJcd6efQy4RQHtdPB5EjTTJOnwfTaiFj
         zPnDAuRz+N1UF1x+ftWBGxbCnriyJlQQaVZ0TLu8Jxn3j73TlL58mTjM1VKGgo3eVj
         E8XzTmWrqCefw==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon, 20 Feb 2023 12:02:17 +0300 (MSK)
From:   Krasnov Arseniy <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 05/12] vsock/virtio: non-linear skb support
Thread-Topic: [RFC PATCH v1 05/12] vsock/virtio: non-linear skb support
Thread-Index: AQHZOfhn3a4rtLPBJ0ikS/zrL9u2k67RfPkAgAXwE4A=
Date:   Mon, 20 Feb 2023 09:02:17 +0000
Message-ID: <dd627cde-e20a-6b0e-b82c-b749dc367db1@sberdevices.ru>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <b3060caf-df19-f1df-6d27-4e58f894c417@sberdevices.ru>
 <20230216141856.fnczv3ui6d3lpujy@sgarzare-redhat>
In-Reply-To: <20230216141856.fnczv3ui6d3lpujy@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <18FBA27B9F20034E8B8A1E8E3C320438@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/02/20 05:01:00 #20887657
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTYuMDIuMjAyMyAxNzoxOCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBNb24s
IEZlYiAwNiwgMjAyMyBhdCAwNjo1ODoyNEFNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBVc2UgcGFnZXMgb2Ygbm9uLWxpbmVhciBza2IgYXMgYnVmZmVycyBpbiB2aXJ0aW8gdHgg
cXVldWUuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZA
c2JlcmRldmljZXMucnU+DQo+PiAtLS0NCj4+IG5ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9y
dC5jIHwgMzEgKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLQ0KPj4gMSBmaWxlIGNoYW5n
ZWQsIDI1IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBh
L25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jIGIvbmV0L3Ztd192c29jay92aXJ0aW9f
dHJhbnNwb3J0LmMNCj4+IGluZGV4IDI4YjVhOGU4ZTA5NC4uYjhhN2Q2ZGM5ZjQ2IDEwMDY0NA0K
Pj4gLS0tIGEvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0LmMNCj4+ICsrKyBiL25ldC92
bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydC5jDQo+PiBAQCAtMTAwLDcgKzEwMCw4IEBAIHZpcnRp
b190cmFuc3BvcnRfc2VuZF9wa3Rfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+PiDC
oMKgwqDCoHZxID0gdnNvY2stPnZxc1tWU09DS19WUV9UWF07DQo+Pg0KPj4gwqDCoMKgwqBmb3Ig
KDs7KSB7DQo+PiAtwqDCoMKgwqDCoMKgwqAgc3RydWN0IHNjYXR0ZXJsaXN0IGhkciwgYnVmLCAq
c2dzWzJdOw0KPj4gK8KgwqDCoMKgwqDCoMKgIHN0cnVjdCBzY2F0dGVybGlzdCAqc2dzW01BWF9T
S0JfRlJBR1MgKyAxXTsNCj4+ICvCoMKgwqDCoMKgwqDCoCBzdHJ1Y3Qgc2NhdHRlcmxpc3QgYnVm
c1tNQVhfU0tCX0ZSQUdTICsgMV07DQo+IA0KPiArIDEgaXMgZm9yIHRoZSBoZWFkZXIsIHJpZ2h0
Pw0KPiBJJ2QgYWRkIGEgY29tbWVudCBqdXN0IHRvIGJlIGNsZWFyIDstKQ0KPiANCj4+IMKgwqDC
oMKgwqDCoMKgIGludCByZXQsIGluX3NnID0gMCwgb3V0X3NnID0gMDsNCj4+IMKgwqDCoMKgwqDC
oMKgIHN0cnVjdCBza19idWZmICpza2I7DQo+PiDCoMKgwqDCoMKgwqDCoCBib29sIHJlcGx5Ow0K
Pj4gQEAgLTExMSwxMiArMTEyLDMwIEBAIHZpcnRpb190cmFuc3BvcnRfc2VuZF9wa3Rfd29yayhz
dHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+Pg0KPj4gwqDCoMKgwqDCoMKgwqAgdmlydGlvX3Ry
YW5zcG9ydF9kZWxpdmVyX3RhcF9wa3Qoc2tiKTsNCj4+IMKgwqDCoMKgwqDCoMKgIHJlcGx5ID0g
dmlydGlvX3Zzb2NrX3NrYl9yZXBseShza2IpOw0KPj4gK8KgwqDCoMKgwqDCoMKgIHNnX2luaXRf
b25lKCZidWZzWzBdLCB2aXJ0aW9fdnNvY2tfaGRyKHNrYiksIHNpemVvZigqdmlydGlvX3Zzb2Nr
X2hkcihza2IpKSk7DQo+PiArwqDCoMKgwqDCoMKgwqAgc2dzW291dF9zZysrXSA9ICZidWZzWzBd
Ow0KPj4gKw0KPj4gK8KgwqDCoMKgwqDCoMKgIGlmIChza2JfaXNfbm9ubGluZWFyKHNrYikpIHsN
Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludCBpOw0KPj4gKw0KPj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgZm9yIChpID0gMDsgaSA8IHNrYl9zaGluZm8oc2tiKS0+bnJfZnJhZ3M7IGkr
Kykgew0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgcGFnZSAqZGF0
YV9wYWdlID0gc2tiX3NoaW5mbyhza2IpLT5mcmFnc1tpXS5idl9wYWdlOw0KPj4gKw0KPj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBXZSB3aWxsIHVzZSAncGFnZV90b192aXJ0
KCknIGZvciB1c2Vyc3BhY2UgcGFnZSBoZXJlLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgICogYmVjYXVzZSB2aXJ0aW8gbGF5ZXIgd2lsbCBjYWxsICd2aXJ0X3RvX3BoeXMo
KScgbGF0ZXINCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIHRvIGZpbGwg
YnVmZmVyIGRlc2NyaXB0b3IuIFdlIGRvbid0IHRvdWNoIG1lbW9yeSBhdA0KPj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogInZpcnR1YWwiIGFkZHJlc3Mgb2YgdGhpcyBwYWdl
Lg0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICovDQo+IA0KPiBJSVVDIGRh
dGFfcGFnZSBpcyBhIHVzZXIgcGFnZSwgc28gc2luY2Ugd2UgYXJlIGV4cG9zaW5nIGl0IHRvIHRo
ZSBob3N0LA0KPiBJIHRoaW5rIHdlIHNob3VsZCBwaW4gaXQuDQo+IA0KPiBJcyBkYXRhX3BhZ2Ug
YWx3YXlzIGEgdXNlciBwYWdlLCBvciBjYW4gaXQgYmUgYSBrZXJuZWwgcGFnZSB3aGVuIHNrYiBp
cyBub25saW5lYXI/DQoNCkJ5IGRlZmF1bHQgaXQgaXMgdXNlciBwYWdlLCBidXQuLi5tYXkgYmUg
aXQgaXMgcG9zc2libGUgdG8gc2VuZCBwYWdlIG9mIG1hcHBlZA0KZmlsZSB3aXRoIE1BUF9TSEFS
RUQgZmxhZ3MoaSB0aGluayBpdCB0aGlzIGNhc2UgaXQgd2lsbCBiZSBwYWdlIGZyb20gcGFnZSBj
YWNoZSkNCg0KPiANCj4gVGhhbmtzLA0KPiBTdGVmYW5vDQo+IA0KPj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBzZ19pbml0X29uZSgmYnVmc1tpICsgMV0sDQo+PiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwYWdlX3RvX3ZpcnQoZGF0YV9w
YWdlKSwgUEFHRV9TSVpFKTsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2dz
W291dF9zZysrXSA9ICZidWZzW2kgKyAxXTsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0N
Cj4+ICvCoMKgwqDCoMKgwqDCoCB9IGVsc2Ugew0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
aWYgKHNrYi0+bGVuID4gMCkgew0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBz
Z19pbml0X29uZSgmYnVmc1sxXSwgc2tiLT5kYXRhLCBza2ItPmxlbik7DQo+PiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNnc1tvdXRfc2crK10gPSAmYnVmc1sxXTsNCj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIH0NCj4+DQo+PiAtwqDCoMKgwqDCoMKgwqAgc2dfaW5pdF9vbmUo
JmhkciwgdmlydGlvX3Zzb2NrX2hkcihza2IpLCBzaXplb2YoKnZpcnRpb192c29ja19oZHIoc2ti
KSkpOw0KPj4gLcKgwqDCoMKgwqDCoMKgIHNnc1tvdXRfc2crK10gPSAmaGRyOw0KPj4gLcKgwqDC
oMKgwqDCoMKgIGlmIChza2ItPmxlbiA+IDApIHsNCj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHNnX2luaXRfb25lKCZidWYsIHNrYi0+ZGF0YSwgc2tiLT5sZW4pOw0KPj4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgc2dzW291dF9zZysrXSA9ICZidWY7DQo+PiDCoMKgwqDCoMKgwqDCoCB9DQo+
Pg0KPj4gwqDCoMKgwqDCoMKgwqAgcmV0ID0gdmlydHF1ZXVlX2FkZF9zZ3ModnEsIHNncywgb3V0
X3NnLCBpbl9zZywgc2tiLCBHRlBfS0VSTkVMKTsNCj4+IC0twqANCj4+IDIuMjUuMQ0KPiANCg0K
