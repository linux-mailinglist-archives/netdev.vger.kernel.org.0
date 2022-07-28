Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C5458386E
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 08:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiG1GJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 02:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiG1GJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 02:09:02 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57FC5D0C5;
        Wed, 27 Jul 2022 23:09:00 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 4DAE15FD0D;
        Thu, 28 Jul 2022 09:08:59 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658988539;
        bh=D6opYFkipKCS3N3a04jMOPNzwBO0XwrHBaVmWEuE3uo=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=AqdjO08aq/IQqfV0ttwwreBbkh7cVJZ8OcRYaPZyuJHFafhJEZnf2Wv2IEoNndqty
         54/Z/d7WJy4E20QdLpIlC1s3e5RJSByOJClBn8XtCWAZhWyrByz8FOGVClLww1iuAj
         mJ+rfGJ/iHb0pK1dck/fIuz+fOcoyLYgcqM7Ii2/uyaT9LbRMM1J4jlI+D6QnQgccB
         5KIUKc+6uPPBiB1P6xZEzkVKazXjok3SZEsmCsvuGLWGboJnxPNysQbaDG/xfG7mru
         nxmlQZFWFtVBYeUzf7lA/oCAi5BusNIjlqQhJLQyn8cbqz3q/HtgvPieWz6XyTlw3J
         mLQ9f+NFaKlhQ==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 28 Jul 2022 09:08:57 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "Dexuan Cui" <decui@microsoft.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Topic: [RFC PATCH v2 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Index: AQHYn/u277di/gNdd06E3+5muuhZo62R+OsAgAEl3oA=
Date:   Thu, 28 Jul 2022 06:08:38 +0000
Message-ID: <d5166d4e-4892-4cdf-df01-4da43b8e269d@sberdevices.ru>
References: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
 <20220727123710.pwzy6ag3gavotxda@sgarzare-redhat>
In-Reply-To: <20220727123710.pwzy6ag3gavotxda@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <369A9F40B249D74CA28AE174FDD1ED9F@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/07/28 02:09:00 #19985101
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjcuMDcuMjAyMiAxNTozNywgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBIaSBBcnNl
bml5LA0KPiANCj4gT24gTW9uLCBKdWwgMjUsIDIwMjIgYXQgMDc6NTQ6MDVBTSArMDAwMCwgQXJz
ZW5peSBLcmFzbm92IHdyb3RlOg0KPj4gSGVsbG8sDQo+Pg0KPj4gVGhpcyBwYXRjaHNldCBpbmNs
dWRlcyBzb21lIHVwZGF0ZXMgZm9yIFNPX1JDVkxPV0FUOg0KPj4NCj4+IDEpIGFmX3Zzb2NrOg0K
Pj4gwqAgRHVyaW5nIG15IGV4cGVyaW1lbnRzIHdpdGggemVyb2NvcHkgcmVjZWl2ZSwgaSBmb3Vu
ZCwgdGhhdCBpbiBzb21lDQo+PiDCoCBjYXNlcywgcG9sbCgpIGltcGxlbWVudGF0aW9uIHZpb2xh
dGVzIFBPU0lYOiB3aGVuIHNvY2tldCBoYXMgbm9uLQ0KPj4gwqAgZGVmYXVsdCBTT19SQ1ZMT1dB
VChlLmcuIG5vdCAxKSwgcG9sbCgpIHdpbGwgYWx3YXlzIHNldCBQT0xMSU4gYW5kDQo+PiDCoCBQ
T0xMUkROT1JNIGJpdHMgaW4gJ3JldmVudHMnIGV2ZW4gbnVtYmVyIG9mIGJ5dGVzIGF2YWlsYWJs
ZSB0byByZWFkDQo+PiDCoCBvbiBzb2NrZXQgaXMgc21hbGxlciB0aGFuIFNPX1JDVkxPV0FUIHZh
bHVlLiBJbiB0aGlzIGNhc2UsdXNlciBzZWVzDQo+PiDCoCBQT0xMSU4gZmxhZyBhbmQgdGhlbiB0
cmllcyB0byByZWFkIGRhdGEoZm9yIGV4YW1wbGUgdXNpbmfCoCAncmVhZCgpJw0KPj4gwqAgY2Fs
bCksIGJ1dCByZWFkIGNhbGwgd2lsbCBiZSBibG9ja2VkLCBiZWNhdXNlwqAgU09fUkNWTE9XQVQg
bG9naWMgaXMNCj4+IMKgIHN1cHBvcnRlZCBpbiBkZXF1ZXVlIGxvb3AgaW4gYWZfdnNvY2suYy4g
QnV0IHRoZSBzYW1lIHRpbWUswqAgUE9TSVgNCj4+IMKgIHJlcXVpcmVzIHRoYXQ6DQo+Pg0KPj4g
wqAgIlBPTExJTsKgwqDCoMKgIERhdGEgb3RoZXIgdGhhbiBoaWdoLXByaW9yaXR5IGRhdGEgbWF5
IGJlIHJlYWQgd2l0aG91dA0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYmxvY2tpbmcu
DQo+PiDCoMKgIFBPTExSRE5PUk0gTm9ybWFsIGRhdGEgbWF5IGJlIHJlYWQgd2l0aG91dCBibG9j
a2luZy4iDQo+Pg0KPj4gwqAgU2VlIGh0dHBzOi8vd3d3Lm9wZW4tc3RkLm9yZy9qdGMxL3NjMjIv
b3Blbi9uNDIxNy5wZGYsIHBhZ2UgMjkzLg0KPj4NCj4+IMKgIFNvLCB3ZSBoYXZlLCB0aGF0IHBv
bGwoKSBzeXNjYWxsIHJldHVybnMgUE9MTElOLCBidXQgcmVhZCBjYWxsIHdpbGwNCj4+IMKgIGJl
IGJsb2NrZWQuDQo+Pg0KPj4gwqAgQWxzbyBpbiBtYW4gcGFnZSBzb2NrZXQoNykgaSBmb3VuZCB0
aGF0Og0KPj4NCj4+IMKgICJTaW5jZSBMaW51eCAyLjYuMjgsIHNlbGVjdCgyKSwgcG9sbCgyKSwg
YW5kIGVwb2xsKDcpIGluZGljYXRlIGENCj4+IMKgIHNvY2tldCBhcyByZWFkYWJsZSBvbmx5IGlm
IGF0IGxlYXN0IFNPX1JDVkxPV0FUIGJ5dGVzIGFyZSBhdmFpbGFibGUuIg0KPj4NCj4+IMKgIEkg
Y2hlY2tlZCBUQ1AgY2FsbGJhY2sgZm9yIHBvbGwoKShuZXQvaXB2NC90Y3AuYywgdGNwX3BvbGwo
KSksIGl0DQo+PiDCoCB1c2VzIFNPX1JDVkxPV0FUIHZhbHVlIHRvIHNldCBQT0xMSU4gYml0LCBh
bHNvIGkndmUgdGVzdGVkIFRDUCB3aXRoDQo+PiDCoCB0aGlzIGNhc2UgZm9yIFRDUCBzb2NrZXQs
IGl0IHdvcmtzIGFzIFBPU0lYIHJlcXVpcmVkLg0KPj4NCj4+IMKgIEkndmUgYWRkZWQgc29tZSBm
aXhlcyB0byBhZl92c29jay5jIGFuZCB2aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jLA0KPj4gwqAg
dGVzdCBpcyBhbHNvIGltcGxlbWVudGVkLg0KPj4NCj4+IDIpIHZpcnRpby92c29jazoNCj4+IMKg
IEl0IGFkZHMgc29tZSBvcHRpbWl6YXRpb24gdG8gd2FrZSB1cHMsIHdoZW4gbmV3IGRhdGEgYXJy
aXZlZC4gTm93LA0KPj4gwqAgU09fUkNWTE9XQVQgaXMgY29uc2lkZXJlZCBiZWZvcmUgd2FrZSB1
cCBzbGVlcGVycyB3aG8gd2FpdCBuZXcgZGF0YS4NCj4+IMKgIFRoZXJlIGlzIG5vIHNlbnNlLCB0
byBraWNrIHdhaXRlciwgd2hlbiBudW1iZXIgb2YgYXZhaWxhYmxlIGJ5dGVzDQo+PiDCoCBpbiBz
b2NrZXQncyBxdWV1ZSA8IFNPX1JDVkxPV0FULCBiZWNhdXNlIGlmIHdlIHdha2UgdXAgcmVhZGVy
IGluDQo+PiDCoCB0aGlzIGNhc2UsIGl0IHdpbGwgd2FpdCBmb3IgU09fUkNWTE9XQVQgZGF0YSBh
bnl3YXkgZHVyaW5nIGRlcXVldWUsDQo+PiDCoCBvciBpbiBwb2xsKCkgY2FzZSwgUE9MTElOL1BP
TExSRE5PUk0gYml0cyB3b24ndCBiZSBzZXQsIHNvIHN1Y2gNCj4+IMKgIGV4aXQgZnJvbSBwb2xs
KCkgd2lsbCBiZSAic3B1cmlvdXMiLiBUaGlzIGxvZ2ljIGlzIGFsc28gdXNlZCBpbiBUQ1ANCj4+
IMKgIHNvY2tldHMuDQo+IA0KPiBOaWNlLCBpdCBsb29rcyBnb29kIQ0KVGhhbmsgWW91IQ0KPiAN
Cj4+DQo+PiAzKSB2bWNpL3Zzb2NrOg0KPj4gwqAgU2FtZSBhcyAyKSwgYnV0IGknbSBub3Qgc3Vy
ZSBhYm91dCB0aGlzIGNoYW5nZXMuIFdpbGwgYmUgdmVyeSBnb29kLA0KPj4gwqAgdG8gZ2V0IGNv
bW1lbnRzIGZyb20gc29tZW9uZSB3aG8ga25vd3MgdGhpcyBjb2RlLg0KPiANCj4gSSBDQ2VkIFZN
Q0kgbWFpbnRhaW5lcnMgdG8gdGhlIHBhdGNoIGFuZCBhbHNvIHRvIHRoaXMgY292ZXIsIG1heWJl
IGJldHRlciB0byBrZWVwIHRoZW0gaW4gdGhlIGxvb3AgZm9yIG5leHQgdmVyc2lvbnMuDQo+IA0K
PiAoSm9yZ2VuJ3MgYW5kIFJhamVzaCdzIGVtYWlscyBib3VuY2VkIGJhY2ssIHNvIEknbSBDQ2lu
ZyBoZXJlIG9ubHkgQnJ5YW4sIFZpc2hudSwgYW5kIHB2LWRyaXZlcnNAdm13YXJlLmNvbSkNCk9r
LCBpJ2xsIENDIHRoZW0gaW4gdGhlIG5leHQgdmVyc2lvbg0KPiANCj4+DQo+PiA0KSBIeXBlci1W
Og0KPj4gwqAgQXMgRGV4dWFuIEN1aSBtZW50aW9uZWQsIGZvciBIeXBlci1WIHRyYW5zcG9ydCBp
dCBpcyBkaWZmaWN1bHQgdG8NCj4+IMKgIHN1cHBvcnQgU09fUkNWTE9XQVQsIHNvIGhlIHN1Z2dl
c3RlZCB0byBkaXNhYmxlIHRoaXMgZmVhdHVyZSBmb3INCj4+IMKgIEh5cGVyLVYuDQo+IA0KPiBJ
IGxlZnQgYSBjb3VwbGUgb2YgY29tbWVudHMgaW4gc29tZSBwYXRjaGVzLCBidXQgaXQgc2VlbXMg
dG8gbWUgdG8gYmUgaW4gYSBnb29kIHN0YXRlIDotKQ0KPiANCj4gSSB3b3VsZCBqdXN0IHN1Z2dl
c3QgYSBiaXQgb2YgYSByZS1vcmdhbml6YXRpb24gb2YgdGhlIHNlcmllcyAodGhlIHBhdGNoZXMg
YXJlIGZpbmUsIGp1c3QgdGhlIG9yZGVyKToNCj4gwqAgLSBpbnRyb2R1Y2UgdnNvY2tfc2V0X3Jj
dmxvd2F0KCkNCj4gwqAgLSBkaXNhYmxpbmcgaXQgZm9yIGh2X3NvY2sNCj4gwqAgLSB1c2UgJ3Rh
cmdldCcgaW4gdmlydGlvIHRyYW5zcG9ydHMNCj4gwqAgLSB1c2UgJ3RhcmdldCcgaW4gdm1jaSB0
cmFuc3BvcnRzDQo+IMKgIC0gdXNlIHNvY2tfcmN2bG93YXQgaW4gdnNvY2tfcG9sbCgpDQo+IMKg
wqAgwqBJIHRoaW5rIGlzIGJldHRlciB0byBwYXNzIHNvY2tfcmN2bG93YXQoKSBhcyAndGFyZ2V0
JyB3aGVuIHRoZQ0KPiDCoMKgwqAgdHJhbnNwb3J0cyBhcmUgYWxyZWFkeSBhYmxlIHRvIHVzZSBp
dA0KPiDCoCAtIGFkZCB2c29ja19kYXRhX3JlYWR5KCkNCj4gwqAgLSB1c2UgdnNvY2tfZGF0YV9y
ZWFkeSgpIGluIHZpcnRpbyB0cmFuc3BvcnRzDQo+IMKgIC0gdXNlIHZzb2NrX2RhdGFfcmVhZHko
KSBpbiB2bWNpIHRyYW5zcG9ydHMNCj4gwqAgLSB0ZXN0cw0KPiANCj4gV2hhdCBkbyB5b3UgdGhp
bms/DQpObyBwcm9ibGVtISBJIHRoaW5rIGkgY2FuIHdhaXQgZm9yIHJlcGx5IGZyb20gVk1XYXJl
IGd1eXMgYmVmb3JlIHByZXBhcmluZyB2Mw0KPiANCj4gVGhhbmtzLA0KPiBTdGVmYW5vDQo+IA0K
DQo=
