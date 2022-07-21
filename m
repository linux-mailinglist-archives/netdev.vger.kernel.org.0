Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6089657C408
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 08:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiGUGCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 02:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiGUGCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 02:02:45 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFCD1D319;
        Wed, 20 Jul 2022 23:02:43 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 1B2605FD31;
        Thu, 21 Jul 2022 09:02:41 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658383361;
        bh=LqYtRAFoz0ma2I9ckyn+2XhKXUFisTnrYlNzjAg7q9w=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=c8ZLFxGmHWJMGlq8X4iaj7vfnaYlNSSmD8axx3vJaufz9L+sbBVCoZAX2vzwnxN9y
         biH7BJrhNwGAydfFNYyKBwrjIDubT8TtlsyN1XmRg5vF8FlnLNA1Je7kw94hChFNLE
         JK4WDyH7Z7wGobQVssxsmD1mfgaB2fhgYzuO3c82psf7uBDmMJa3Agrj+JRk6sIXer
         Xk2Nf3Nui3hpQ17PxLIziODCotnuMc3HgK+8X1/y5TEKRBLzBFPqJFvgaX3W26UdHU
         sJrFpAlH6pAFb5KiC5IKZsEyb8WuGXqMdoGVL/nnL5F9Y54DaXeQRoU2Ihee3uiJGn
         x0Yhrr3ts9C7w==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 21 Jul 2022 09:02:36 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 2/3] virtio/vsock: use 'target' in notify_poll_in,
 callback.
Thread-Topic: [RFC PATCH v1 2/3] virtio/vsock: use 'target' in notify_poll_in,
 callback.
Thread-Index: AQHYmn7T+PqKYxwQ8USiiecixCHJYa2FdImAgAEZ/YCAAC4SgIAAsIoAgAC6iAA=
Date:   Thu, 21 Jul 2022 06:02:17 +0000
Message-ID: <420cde93-bc9d-925b-e68e-fdf04326f031@sberdevices.ru>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <358f8d52-fd88-ad2e-87e2-c64bfa516a58@sberdevices.ru>
 <20220719124857.akv25sgp6np3pdaw@sgarzare-redhat>
 <15f38fcf-f1ff-3aad-4c30-4436bb8c4c44@sberdevices.ru>
 <20220720082307.djbf7qgnlsjmrxcf@sgarzare-redhat>
 <SN6PR2101MB132703A0F4D08DC28D37A17EBF8E9@SN6PR2101MB1327.namprd21.prod.outlook.com>
In-Reply-To: <SN6PR2101MB132703A0F4D08DC28D37A17EBF8E9@SN6PR2101MB1327.namprd21.prod.outlook.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <281EBE318E5239428D1B59BB68E59335@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/07/20 23:43:00 #19928907
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAuMDcuMjAyMiAyMTo1NCwgRGV4dWFuIEN1aSB3cm90ZToNCj4+IEZyb206IFN0ZWZhbm8g
R2FyemFyZWxsYSA8c2dhcnphcmVAcmVkaGF0LmNvbT4NCj4+IFNlbnQ6IFdlZG5lc2RheSwgSnVs
eSAyMCwgMjAyMiAxOjIzIEFNDQo+PiAuLi4NCj4+IE9uIFdlZCwgSnVsIDIwLCAyMDIyIGF0IDA1
OjM4OjAzQU0gKzAwMDAsIEFyc2VuaXkgS3Jhc25vdiB3cm90ZToNCj4+PiBPbiAxOS4wNy4yMDIy
IDE1OjQ4LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6DQo+Pj4+IE9uIE1vbiwgSnVsIDE4LCAy
MDIyIGF0IDA4OjE3OjMxQU0gKzAwMDAsIEFyc2VuaXkgS3Jhc25vdiB3cm90ZToNCj4+Pj4+IFRo
aXMgY2FsbGJhY2sgY29udHJvbHMgc2V0dGluZyBvZiBQT0xMSU4sUE9MTFJETk9STSBvdXRwdXQg
Yml0cw0KPj4+Pj4gb2YgcG9sbCgpIHN5c2NhbGwsYnV0IGluIHNvbWUgY2FzZXMsaXQgaXMgaW5j
b3JyZWN0bHkgdG8gc2V0IGl0LA0KPj4+Pj4gd2hlbiBzb2NrZXQgaGFzIGF0IGxlYXN0IDEgYnl0
ZXMgb2YgYXZhaWxhYmxlIGRhdGEuIFVzZSAndGFyZ2V0Jw0KPj4+Pj4gd2hpY2ggaXMgYWxyZWFk
eSBleGlzdHMgYW5kIGVxdWFsIHRvIHNrX3Jjdmxvd2F0IGluIHRoaXMgY2FzZS4NCj4+Pj4+DQo+
Pj4+PiBTaWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNl
cy5ydT4NCj4+Pj4+IC0tLQ0KPj4+Pj4gbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2Nv
bW1vbi5jIHwgMiArLQ0KPj4+Pj4gMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pDQo+Pj4+Pg0KPj4+Pj4gZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svdmlydGlv
X3RyYW5zcG9ydF9jb21tb24uYw0KPj4gYi9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRf
Y29tbW9uLmMNCj4+Pj4+IGluZGV4IGVjMmMyYWZiZjBkMC4uNTkxOTA4NzQwOTkyIDEwMDY0NA0K
Pj4+Pj4gLS0tIGEvbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jDQo+Pj4+
PiArKysgYi9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMNCj4+Pj4+IEBA
IC02MzQsNyArNjM0LDcgQEAgdmlydGlvX3RyYW5zcG9ydF9ub3RpZnlfcG9sbF9pbihzdHJ1Y3Qg
dnNvY2tfc29jaw0KPj4gKnZzaywNCj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBzaXplX3QgdGFyZ2V0LA0KPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJv
b2wgKmRhdGFfcmVhZHlfbm93KQ0KPj4+Pj4gew0KPj4+Pj4gLcKgwqDCoCBpZiAodnNvY2tfc3Ry
ZWFtX2hhc19kYXRhKHZzaykpDQo+Pj4+PiArwqDCoMKgIGlmICh2c29ja19zdHJlYW1faGFzX2Rh
dGEodnNrKSA+PSB0YXJnZXQpDQo+Pj4+PiDCoMKgwqDCoMKgwqDCoCAqZGF0YV9yZWFkeV9ub3cg
PSB0cnVlOw0KPj4+Pj4gwqDCoMKgwqBlbHNlDQo+Pj4+PiDCoMKgwqDCoMKgwqDCoCAqZGF0YV9y
ZWFkeV9ub3cgPSBmYWxzZTsNCj4+Pj4NCj4+Pj4gUGVyaGFwcyB3ZSBjYW4gdGFrZSB0aGUgb3Bw
b3J0dW5pdHkgdG8gY2xlYW4gdXAgdGhlIGNvZGUgaW4gdGhpcyB3YXk6DQo+Pj4+DQo+Pj4+IMKg
wqDCoMKgKmRhdGFfcmVhZHlfbm93ID0gdnNvY2tfc3RyZWFtX2hhc19kYXRhKHZzaykgPj0gdGFy
Z2V0Ow0KPj4+IEFjaw0KPj4+Pg0KPj4+PiBBbnl3YXksIEkgdGhpbmsgd2UgYWxzbyBuZWVkIHRv
IGZpeCB0aGUgb3RoZXIgdHJhbnNwb3J0cyAodm1jaSBhbmQgaHlwZXJ2KSwNCj4+Pj4gd2hhdCBk
byB5b3UgdGhpbms/DQo+Pj4gRm9yIHZtY2kgaXQgaXMgbG9vayBjbGVhciB0byBmaXggaXQuIEZv
ciBoeXBlcnYgaSBuZWVkIHRvIGNoZWNrIGl0IG1vcmUsIGJlY2F1c2UgaXQNCj4+PiBhbHJlYWR5
IHVzZXMgc29tZSBpbnRlcm5hbCB0YXJnZXQgdmFsdWUuDQo+Pg0KPj4gWWVwLCBJIHNlZS4gTWF5
YmUgeW91IGNhbiBwYXNzIGB0YXJnZXRgIHRvIGh2c19jaGFubmVsX3JlYWRhYmxlKCkgYW5kDQo+
PiB1c2UgaXQgYXMgcGFyYW1ldGVyIG9mIEhWU19QS1RfTEVOKCkuDQo+Pg0KPj4gQERleHVhbiB3
aGF0IGRvIHlvdSB0aGluaz8NCj4+DQo+PiBUaGFua3MsDQo+PiBTdGVmYW5vDQo+IA0KPiBDYW4g
d2UgcmV0dXJuICJub3Qgc3VwcG9ydGVkIiB0byBzZXRfcmN2bG93YXQgZm9yIEh5cGVyLVYgdnNv
Y2s/IDotKQ0KPiANCj4gRm9yIEh5cGVyLVYgdnNvY2ssIGl0J3MgZWFzeSB0byB0ZWxsIGlmIHRo
ZXJlIGlzIGF0IGxlYXN0IDEgYnl0ZSB0byByZWFkOiANCj4gcGxlYXNlIHJlZmVyIHRvIGh2c19j
aGFubmVsX3JlYWRhYmxlKCksIGJ1dCBpdCdzIGRpZmZpY3VsdCB0byBmaWd1cmUgb3V0DQo+IGV4
YWN0bHkgaG93IG1hbnkgYnl0ZXMgY2FuIGJlIHJlYWQuIA0KPiANCj4gSW4gaHZzX2NoYW5uZWxf
cmVhZGFibGUoKSwgaHZfZ2V0X2J5dGVzX3RvX3JlYWQoKSByZXR1cm5zIHRoZSB0b3RhbCANCj4g
Ynl0ZXMgb2YgMCwgMSBvciBtdWx0aXBsZSBIeXBlci1WIHZzb2NrIHBhY2tldHM6IGVhY2ggcGFj
a2V0IGhhcyBhDQo+IDI0LWJ5dGUgaGVhZGVyIChzZWUgSFZTX0hFQURFUl9MRU4pLCB0aGUgcGF5
bG9hZCwgc29tZSBwYWRkaW5nDQo+IGJ5dGVzIChpZiB0aGUgcGF5bG9hZCBsZW5ndGggaXMgbm90
IGEgbXVsdGlwbGUgb2YgOCksIGFuZCA4IHRyYWlsaW5nDQo+IHVzZWxlc3MgYnl0ZXMuDQo+IA0K
PiBJdCdzIGhhcmQgdG8gZ2V0IHRoZSB0b3RhbCBwYXlsb2FkIGxlbmd0aCBiZWNhdXNlIHRoZXJl
IGlzIG5vIEFQSSBpbg0KPiBpbmNsdWRlL2xpbnV4L2h5cGVydi5oLCBkcml2ZXJzL2h2L2NoYW5u
ZWwuYyBhbmQgDQo+IGRyaXZlcnMvaHYvcmluZ19idWZmZXIuYyB0aGF0IGFsbG93cyB1cyB0byBw
ZWVrIGF0IHRoZSBkYXRhIGluIHRoZQ0KPiBWTUJ1cyBjaGFubmVsJ3MgcmluZ2J1ZmZlci4gDQo+
IA0KPiBXZSBjb3VsZCBhZGQgc3VjaCBhICJwZWVrIiBBUEkgaW4gZHJpdmVycy9odi9jaGFubmVs
LmMgKHNlZSB0aGUNCj4gbm9uLXBlZWsgdmVyc2lvbiBvZiB0aGUgQVBJcyBpbiBodnNfc3RyZWFt
X2RlcXVldWUoKTogDQo+IGh2X3BrdF9pdGVyX2ZpcnN0KCkgYW5kIGh2X3BrdF9pdGVyX25leHQo
KSksIGFuZCBleGFtaW5lIHRoZSB3aG9sZQ0KPiByaW5nYnVmZmUgdG8gZmlndXJlIG91dCB0aGUg
ZXhhY3QgdG90YWwgcGF5bG9hZCBsZW5ndGgsIGJ1dCBJIGZlZWwgaXQgbWF5IA0KPiBub3QgYmUg
d29ydGggdGhlIG5vbi10cml2aWFsIGNvbXBsZXhpdHkganVzdCB0byBiZSBQT1NJWC1jb21wbGlh
bnQgLS0NCj4gbm9ib2R5IGV2ZXIgY29tcGxhaW5lZCBhYm91dCB0aGlzIGZvciB0aGUgcGFzdCA1
IHllYXJzIDotKSBTbyBJJ20NCj4gd29uZGVyaW5nIGlmIHdlIHNob3VsZCBhbGxvdyBIeXBlci1W
IHZzb2NrIHRvIG5vdCBzdXBwb3J0IHRoZSANCj4gc2V0X3Jjdmxvd2F0IG9wPw0KSSBzZWUsIGkg
Y2FuIHByZXBhcmUgcGF0Y2ggZm9yIHRoaXMgaW4gdGhpcyBwYXRjaHNldCBpbiB2Mi4gQ2FsbCB0
byBzZXQgU09fUkNWTE9XQVQgZm9yIEh5cGVyLVYNCnRyYW5zcG9ydCB3aWxsIHJldHVybiBFT1BO
T1RTVVBQLg0KDQpUaGFuayBZb3UNCj4gDQo+IFRoYW5rcywNCj4gLS0gRGV4dWFuDQo+IA0KDQo=
