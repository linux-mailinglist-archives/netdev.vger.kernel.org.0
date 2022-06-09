Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D699544B59
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 14:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbiFIMKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 08:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235532AbiFIMKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 08:10:02 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D61626520F;
        Thu,  9 Jun 2022 05:09:55 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id A56925FD04;
        Thu,  9 Jun 2022 15:09:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1654776591;
        bh=OXLdxNvSqM5+RgZ6719Zf0FdYnVMlJZBRSvFeGmh5n8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=kjMYdyT/AObMy+Rc9XM/Z26xepi3seFEvarZq3t1hJ3TPRZuvJTanScbKxDU7cZ5g
         HQudotFsv07PDB/2RBEMI815PGSO7i/Cz8H1IhGM2azoE+yxJvs9ocDUB1/7gOpM/I
         NYifWz9QJJyab+N0ij7j6/il1rTGwI8gpHbjn/msBJKAktz6nfgBiSS3ZM76JyemFH
         6ph1ab9rN2ns7ZKtY6accvH+sElFwBoC3cj4DISwJxGozg/PEShMPM/dlRyA91t7WH
         LPpKLIi3h+03yDAK0bh4DHQ06Bm4WWLmUPBETmbzDp7tsdNkNot5qNy+nrKLtxvCWY
         9BE+LBxy5xpZA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu,  9 Jun 2022 15:09:34 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v2 2/8] vhost/vsock: rework packet allocation logic
Thread-Topic: [RFC PATCH v2 2/8] vhost/vsock: rework packet allocation logic
Thread-Index: AQHYdwtmNyMIn8KDWEakLUC7mf1LGq1GmCAAgAA7C4A=
Date:   Thu, 9 Jun 2022 12:09:12 +0000
Message-ID: <b2a97b32-cd91-50f1-861d-05978ccb7205@sberdevices.ru>
References: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
 <72ae7f76-ffee-3e64-d445-7a0f4261d891@sberdevices.ru>
 <20220609083812.kfsmteh6cm5v3ag2@sgarzare-redhat>
In-Reply-To: <20220609083812.kfsmteh6cm5v3ag2@sgarzare-redhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C1E8A9F7E6DA9458DD02C2DFE9C464E@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/06/09 08:45:00 #19722238
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDkuMDYuMjAyMiAxMTozOCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBGcmks
IEp1biAwMywgMjAyMiBhdCAwNTozMzowNEFNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBGb3IgcGFja2V0cyByZWNlaXZlZCBmcm9tIHZpcnRpbyBSWCBxdWV1ZSwgdXNlIGJ1ZGR5
DQo+PiBhbGxvY2F0b3IgaW5zdGVhZCBvZiAna21hbGxvYygpJyB0byBiZSBhYmxlIHRvIGluc2Vy
dA0KPj4gc3VjaCBwYWdlcyB0byB1c2VyIHByb3ZpZGVkIHZtYS4gU2luZ2xlIGNhbGwgdG8NCj4+
ICdjb3B5X2Zyb21faXRlcigpJyByZXBsYWNlZCB3aXRoIHBlci1wYWdlIGxvb3AuDQo+Pg0KPj4g
U2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+
DQo+PiAtLS0NCj4+IGRyaXZlcnMvdmhvc3QvdnNvY2suYyB8IDgxICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0NCj4+IDEgZmlsZSBjaGFuZ2VkLCA2OSBpbnNlcnRp
b25zKCspLCAxMiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aG9z
dC92c29jay5jIGIvZHJpdmVycy92aG9zdC92c29jay5jDQo+PiBpbmRleCBlNmM5ZDQxZGIxZGUu
LjBkYzIyMjlmMThmNyAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvdmhvc3QvdnNvY2suYw0KPj4g
KysrIGIvZHJpdmVycy92aG9zdC92c29jay5jDQo+PiBAQCAtNTgsNiArNTgsNyBAQCBzdHJ1Y3Qg
dmhvc3RfdnNvY2sgew0KPj4NCj4+IMKgwqDCoMKgdTMyIGd1ZXN0X2NpZDsNCj4+IMKgwqDCoMKg
Ym9vbCBzZXFwYWNrZXRfYWxsb3c7DQo+PiArwqDCoMKgIGJvb2wgemVyb2NvcHlfcnhfb247DQo+
IA0KPiBUaGlzIGlzIHBlci1kZXZpY2UsIHNvIGEgc2luZ2xlIHNvY2tldCBjYW4gY2hhbmdlIHRo
ZSBiZWhhdmlvdXIgb2YgYWxsIHRoZSBzb2NrZXRzIG9mIHRoaXMgZGV2aWNlLg0KDQpTdXJlLCBt
eSBtaXN0YWtlDQoNCj4gDQo+IENhbiB3ZSBkbyBzb21ldGhpbmcgYmV0dGVyPw0KPiANCj4gTWF5
YmUgd2UgY2FuIGFsbG9jYXRlIHRoZSBoZWFkZXIsIGNvcHkgaXQsIGZpbmQgdGhlIHNvY2tldCBh
bmQgY2hlY2sgaWYgemVyby1jb3B5IGlzIGVuYWJsZWQgb3Igbm90IGZvciB0aGF0IHNvY2tldC4N
Cj4gDQo+IE9mIGNvdXJzZSB3ZSBzaG91bGQgY2hhbmdlIG9yIGV4dGVuZCB2aXJ0aW9fdHJhbnNw
b3J0X3JlY3ZfcGt0KCkgdG8gYXZvaWQgdG8gZmluZCB0aGUgc29ja2V0IGFnYWluLg0KDQpJIHRo
aW5rIHllcw0KDQo+IA0KPiANCj4+IH07DQo+Pg0KPj4gc3RhdGljIHUzMiB2aG9zdF90cmFuc3Bv
cnRfZ2V0X2xvY2FsX2NpZCh2b2lkKQ0KPj4gQEAgLTM1Nyw2ICszNTgsNyBAQCB2aG9zdF92c29j
a19hbGxvY19wa3Qoc3RydWN0IHZob3N0X3ZpcnRxdWV1ZSAqdnEsDQo+PiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBpbnQgb3V0LCB1bnNpZ25lZCBpbnQgaW4pDQo+PiB7DQo+
PiDCoMKgwqDCoHN0cnVjdCB2aXJ0aW9fdnNvY2tfcGt0ICpwa3Q7DQo+PiArwqDCoMKgIHN0cnVj
dCB2aG9zdF92c29jayAqdnNvY2s7DQo+PiDCoMKgwqDCoHN0cnVjdCBpb3ZfaXRlciBpb3ZfaXRl
cjsNCj4+IMKgwqDCoMKgc2l6ZV90IG5ieXRlczsNCj4+IMKgwqDCoMKgc2l6ZV90IGxlbjsNCj4+
IEBAIC0zOTMsMjAgKzM5NSw3NSBAQCB2aG9zdF92c29ja19hbGxvY19wa3Qoc3RydWN0IHZob3N0
X3ZpcnRxdWV1ZSAqdnEsDQo+PiDCoMKgwqDCoMKgwqDCoCByZXR1cm4gTlVMTDsNCj4+IMKgwqDC
oMKgfQ0KPj4NCj4+IC3CoMKgwqAgcGt0LT5idWYgPSBrbWFsbG9jKHBrdC0+bGVuLCBHRlBfS0VS
TkVMKTsNCj4+IC3CoMKgwqAgaWYgKCFwa3QtPmJ1Zikgew0KPj4gLcKgwqDCoMKgwqDCoMKgIGtm
cmVlKHBrdCk7DQo+PiAtwqDCoMKgwqDCoMKgwqAgcmV0dXJuIE5VTEw7DQo+PiAtwqDCoMKgIH0N
Cj4+IC0NCj4+IMKgwqDCoMKgcGt0LT5idWZfbGVuID0gcGt0LT5sZW47DQo+PiArwqDCoMKgIHZz
b2NrID0gY29udGFpbmVyX29mKHZxLT5kZXYsIHN0cnVjdCB2aG9zdF92c29jaywgZGV2KTsNCj4+
DQo+PiAtwqDCoMKgIG5ieXRlcyA9IGNvcHlfZnJvbV9pdGVyKHBrdC0+YnVmLCBwa3QtPmxlbiwg
Jmlvdl9pdGVyKTsNCj4+IC3CoMKgwqAgaWYgKG5ieXRlcyAhPSBwa3QtPmxlbikgew0KPj4gLcKg
wqDCoMKgwqDCoMKgIHZxX2Vycih2cSwgIkV4cGVjdGVkICV1IGJ5dGUgcGF5bG9hZCwgZ290ICV6
dSBieXRlc1xuIiwNCj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHBrdC0+bGVuLCBu
Ynl0ZXMpOw0KPj4gLcKgwqDCoMKgwqDCoMKgIHZpcnRpb190cmFuc3BvcnRfZnJlZV9wa3QocGt0
KTsNCj4+IC3CoMKgwqDCoMKgwqDCoCByZXR1cm4gTlVMTDsNCj4+ICvCoMKgwqAgaWYgKCF2c29j
ay0+emVyb2NvcHlfcnhfb24pIHsNCj4+ICvCoMKgwqDCoMKgwqDCoCBwa3QtPmJ1ZiA9IGttYWxs
b2MocGt0LT5sZW4sIEdGUF9LRVJORUwpOw0KPj4gKw0KPj4gK8KgwqDCoMKgwqDCoMKgIGlmICgh
cGt0LT5idWYpIHsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGtmcmVlKHBrdCk7DQo+PiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gTlVMTDsNCj4+ICvCoMKgwqDCoMKgwqDCoCB9
DQo+PiArDQo+PiArwqDCoMKgwqDCoMKgwqAgcGt0LT5zbGFiX2J1ZiA9IHRydWU7DQo+PiArwqDC
oMKgwqDCoMKgwqAgbmJ5dGVzID0gY29weV9mcm9tX2l0ZXIocGt0LT5idWYsIHBrdC0+bGVuLCAm
aW92X2l0ZXIpOw0KPj4gK8KgwqDCoMKgwqDCoMKgIGlmIChuYnl0ZXMgIT0gcGt0LT5sZW4pIHsN
Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZxX2Vycih2cSwgIkV4cGVjdGVkICV1IGJ5dGUg
cGF5bG9hZCwgZ290ICV6dSBieXRlc1xuIiwNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcGt0LT5sZW4sIG5ieXRlcyk7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2aXJ0
aW9fdHJhbnNwb3J0X2ZyZWVfcGt0KHBrdCk7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gTlVMTDsNCj4+ICvCoMKgwqDCoMKgwqDCoCB9DQo+PiArwqDCoMKgIH0gZWxzZSB7DQo+
PiArwqDCoMKgwqDCoMKgwqAgc3RydWN0IHBhZ2UgKmJ1Zl9wYWdlOw0KPj4gK8KgwqDCoMKgwqDC
oMKgIHNzaXplX3QgcGt0X2xlbjsNCj4+ICvCoMKgwqDCoMKgwqDCoCBpbnQgcGFnZV9pZHg7DQo+
PiArDQo+PiArwqDCoMKgwqDCoMKgwqAgLyogVGhpcyBjcmVhdGVzIG1lbW9yeSBvdmVycnVuLCBh
cyB3ZSBhbGxvY2F0ZQ0KPj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBhdCBsZWFzdCBvbmUgcGFnZSBm
b3IgZWFjaCBwYWNrZXQuDQo+PiArwqDCoMKgwqDCoMKgwqDCoCAqLw0KPj4gK8KgwqDCoMKgwqDC
oMKgIGJ1Zl9wYWdlID0gYWxsb2NfcGFnZXMoR0ZQX0tFUk5FTCwgZ2V0X29yZGVyKHBrdC0+bGVu
KSk7DQo+PiArDQo+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGJ1Zl9wYWdlID09IE5VTEwpIHsNCj4+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGtmcmVlKHBrdCk7DQo+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gTlVMTDsNCj4+ICvCoMKgwqDCoMKgwqDCoCB9DQo+PiArDQo+PiArwqDC
oMKgwqDCoMKgwqAgcGt0LT5idWYgPSBwYWdlX3RvX3ZpcnQoYnVmX3BhZ2UpOw0KPj4gKw0KPj4g
K8KgwqDCoMKgwqDCoMKgIHBhZ2VfaWR4ID0gMDsNCj4+ICvCoMKgwqDCoMKgwqDCoCBwa3RfbGVu
ID0gcGt0LT5sZW47DQo+PiArDQo+PiArwqDCoMKgwqDCoMKgwqAgLyogQXMgYWxsb2NhdGVkIHBh
Z2VzIGFyZSBub3QgbWFwcGVkLCBwcm9jZXNzDQo+PiArwqDCoMKgwqDCoMKgwqDCoCAqIHBhZ2Vz
IG9uZSBieSBvbmUuDQo+PiArwqDCoMKgwqDCoMKgwqDCoCAqLw0KPj4gK8KgwqDCoMKgwqDCoMKg
IHdoaWxlIChwa3RfbGVuID4gMCkgew0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdm9pZCAq
bWFwcGVkOw0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6ZV90IHRvX2NvcHk7DQo+PiAr
DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtYXBwZWQgPSBrbWFwKGJ1Zl9wYWdlICsgcGFn
ZV9pZHgpOw0KPj4gKw0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG1hcHBlZCA9PSBO
VUxMKSB7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZpcnRpb190cmFuc3Bv
cnRfZnJlZV9wa3QocGt0KTsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0
dXJuIE5VTEw7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9DQo+PiArDQo+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB0b19jb3B5ID0gbWluKHBrdF9sZW4sICgoc3NpemVfdClQQUdFX1NJ
WkUpKTsNCj4+ICsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG5ieXRlcyA9IGNvcHlfZnJv
bV9pdGVyKG1hcHBlZCwgdG9fY29weSwgJmlvdl9pdGVyKTsNCj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGlmIChuYnl0ZXMgIT0gdG9fY29weSkgew0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB2cV9lcnIodnEsICJFeHBlY3RlZCAlenUgYnl0ZSBwYXlsb2FkLCBnb3QgJXp1
IGJ5dGVzXG4iLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHRvX2NvcHksIG5ieXRlcyk7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGt1bm1hcChtYXBwZWQpOw0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2aXJ0
aW9fdHJhbnNwb3J0X2ZyZWVfcGt0KHBrdCk7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHJldHVybiBOVUxMOw0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQ0KPj4gKw0K
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAga3VubWFwKG1hcHBlZCk7DQo+PiArDQo+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBwa3RfbGVuIC09IHRvX2NvcHk7DQo+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBwYWdlX2lkeCsrOw0KPj4gK8KgwqDCoMKgwqDCoMKgIH0NCj4+IMKgwqDCoMKg
fQ0KPj4NCj4+IMKgwqDCoMKgcmV0dXJuIHBrdDsNCj4+IC0twqANCj4+IDIuMjUuMQ0KPiANCg0K
