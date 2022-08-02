Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C3F5876C7
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 07:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbiHBFgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 01:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbiHBFgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 01:36:07 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986B833A1D;
        Mon,  1 Aug 2022 22:35:59 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id C770B5FD18;
        Tue,  2 Aug 2022 08:35:56 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1659418556;
        bh=s0r/iXvFD+efR/87tJWYy1/jn0Av1q3wDPXPXDWSn7Q=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=EDUhQ89at6HrJPo/K+zklY7mnKfUpKDibHga9HiC4EWsfGOqyYRzyQ2eSZgUL259j
         p4h+4Sss+mwC18BLvpw4XLEbJWsTjAHeDEILAPAkaU+mixdu9oWa7cwrCF9gy07mWh
         FAaUmJbgPi9y6ZgegaKn9vbbciybt2ofA10PGSU84LjP/nHNIaxd/1DXrv2UHJdvKl
         5FaQM921wGKlWFsOO5SMSQn+mPxTU4SmnpBxRFraJFpmtuikVa+AatTMNzI6raMdCU
         x75s6sQQWgJAHqfpsHIda8iX6BIpWMHr6S10taXBOHGoEInbZ7hjNPLtszLSMPmYUK
         zM7Mz77AujWaA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Tue,  2 Aug 2022 08:35:51 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Vishnu Dasa <vdasa@vmware.com>
CC:     Stefano Garzarella <sgarzare@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
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
Thread-Index: AQHYn/u277di/gNdd06E3+5muuhZo62R+OsAgAEl3oCAB9EsAIAAATsA
Date:   Tue, 2 Aug 2022 05:35:48 +0000
Message-ID: <29ac3503-87e9-7236-bc9b-b1ac50c19f04@sberdevices.ru>
References: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
 <20220727123710.pwzy6ag3gavotxda@sgarzare-redhat>
 <d5166d4e-4892-4cdf-df01-4da43b8e269d@sberdevices.ru>
 <B67A3903-3AF5-40D0-9887-F2253F55C7EB@vmware.com>
In-Reply-To: <B67A3903-3AF5-40D0-9887-F2253F55C7EB@vmware.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A592B319152FC41B33B0F21D1CF39E2@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/02 03:42:00 #20031579
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,T_SPF_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDIuMDguMjAyMiAwODozMSwgVmlzaG51IERhc2Egd3JvdGU6DQo+IA0KPiANCj4+IE9uIEp1
bCAyNywgMjAyMiwgYXQgMTE6MDggUE0sIEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJk
ZXZpY2VzLnJ1PiB3cm90ZToNCj4+DQo+PiBPbiAyNy4wNy4yMDIyIDE1OjM3LCBTdGVmYW5vIEdh
cnphcmVsbGEgd3JvdGU6DQo+Pj4gSGkgQXJzZW5peSwNCj4+Pg0KPj4+IE9uIE1vbiwgSnVsIDI1
LCAyMDIyIGF0IDA3OjU0OjA1QU0gKzAwMDAsIEFyc2VuaXkgS3Jhc25vdiB3cm90ZToNCj4+Pj4g
SGVsbG8sDQo+Pj4+DQo+Pj4+IFRoaXMgcGF0Y2hzZXQgaW5jbHVkZXMgc29tZSB1cGRhdGVzIGZv
ciBTT19SQ1ZMT1dBVDoNCj4+Pj4NCj4+Pj4gMSkgYWZfdnNvY2s6DQo+Pj4+IER1cmluZyBteSBl
eHBlcmltZW50cyB3aXRoIHplcm9jb3B5IHJlY2VpdmUsIGkgZm91bmQsIHRoYXQgaW4gc29tZQ0K
Pj4+PiBjYXNlcywgcG9sbCgpIGltcGxlbWVudGF0aW9uIHZpb2xhdGVzIFBPU0lYOiB3aGVuIHNv
Y2tldCBoYXMgbm9uLQ0KPj4+PiBkZWZhdWx0IFNPX1JDVkxPV0FUKGUuZy4gbm90IDEpLCBwb2xs
KCkgd2lsbCBhbHdheXMgc2V0IFBPTExJTiBhbmQNCj4+Pj4gUE9MTFJETk9STSBiaXRzIGluICdy
ZXZlbnRzJyBldmVuIG51bWJlciBvZiBieXRlcyBhdmFpbGFibGUgdG8gcmVhZA0KPj4+PiBvbiBz
b2NrZXQgaXMgc21hbGxlciB0aGFuIFNPX1JDVkxPV0FUIHZhbHVlLiBJbiB0aGlzIGNhc2UsdXNl
ciBzZWVzDQo+Pj4+IFBPTExJTiBmbGFnIGFuZCB0aGVuIHRyaWVzIHRvIHJlYWQgZGF0YShmb3Ig
ZXhhbXBsZSB1c2luZyAncmVhZCgpJw0KPj4+PiBjYWxsKSwgYnV0IHJlYWQgY2FsbCB3aWxsIGJl
IGJsb2NrZWQsIGJlY2F1c2UgU09fUkNWTE9XQVQgbG9naWMgaXMNCj4+Pj4gc3VwcG9ydGVkIGlu
IGRlcXVldWUgbG9vcCBpbiBhZl92c29jay5jLiBCdXQgdGhlIHNhbWUgdGltZSwgUE9TSVgNCj4+
Pj4gcmVxdWlyZXMgdGhhdDoNCj4+Pj4NCj4+Pj4gIlBPTExJTiBEYXRhIG90aGVyIHRoYW4gaGln
aC1wcmlvcml0eSBkYXRhIG1heSBiZSByZWFkIHdpdGhvdXQNCj4+Pj4gYmxvY2tpbmcuDQo+Pj4+
IFBPTExSRE5PUk0gTm9ybWFsIGRhdGEgbWF5IGJlIHJlYWQgd2l0aG91dCBibG9ja2luZy4iDQo+
Pj4+DQo+Pj4+IFNlZSBodHRwczovL25hbTA0LnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2su
Y29tLz91cmw9aHR0cHMlM0ElMkYlMkZ3d3cub3Blbi1zdGQub3JnJTJGanRjMSUyRnNjMjIlMkZv
cGVuJTJGbjQyMTcucGRmJmFtcDtkYXRhPTA1JTdDMDElN0N2ZGFzYSU0MHZtd2FyZS5jb20lN0Nh
ZTgzNjIxZDg3MDk0MjFkZTE0YjA4ZGE3MDVmYWE5YyU3Q2IzOTEzOGNhM2NlZTRiNGFhNGQ2Y2Q4
M2Q5ZGQ2MmYwJTdDMCU3QzElN0M2Mzc5NDU4NTM0NzM3NDAyMzUlN0NVbmtub3duJTdDVFdGcGJH
WnNiM2Q4ZXlKV0lqb2lNQzR3TGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazFoYVd3
aUxDSlhWQ0k2TW4wJTNEJTdDMzAwMCU3QyU3QyU3QyZhbXA7c2RhdGE9TnJieWNDY1ZYVjlUejhO
UkRZQnBuRHg3S3BGRjZCWnBTUmJ1aHoxSWZKNCUzRCZhbXA7cmVzZXJ2ZWQ9MCwgcGFnZSAyOTMu
DQo+Pj4+DQo+Pj4+IFNvLCB3ZSBoYXZlLCB0aGF0IHBvbGwoKSBzeXNjYWxsIHJldHVybnMgUE9M
TElOLCBidXQgcmVhZCBjYWxsIHdpbGwNCj4+Pj4gYmUgYmxvY2tlZC4NCj4+Pj4NCj4+Pj4gQWxz
byBpbiBtYW4gcGFnZSBzb2NrZXQoNykgaSBmb3VuZCB0aGF0Og0KPj4+Pg0KPj4+PiAiU2luY2Ug
TGludXggMi42LjI4LCBzZWxlY3QoMiksIHBvbGwoMiksIGFuZCBlcG9sbCg3KSBpbmRpY2F0ZSBh
DQo+Pj4+IHNvY2tldCBhcyByZWFkYWJsZSBvbmx5IGlmIGF0IGxlYXN0IFNPX1JDVkxPV0FUIGJ5
dGVzIGFyZSBhdmFpbGFibGUuIg0KPj4+Pg0KPj4+PiBJIGNoZWNrZWQgVENQIGNhbGxiYWNrIGZv
ciBwb2xsKCkobmV0L2lwdjQvdGNwLmMsIHRjcF9wb2xsKCkpLCBpdA0KPj4+PiB1c2VzIFNPX1JD
VkxPV0FUIHZhbHVlIHRvIHNldCBQT0xMSU4gYml0LCBhbHNvIGkndmUgdGVzdGVkIFRDUCB3aXRo
DQo+Pj4+IHRoaXMgY2FzZSBmb3IgVENQIHNvY2tldCwgaXQgd29ya3MgYXMgUE9TSVggcmVxdWly
ZWQuDQo+Pj4+DQo+Pj4+IEkndmUgYWRkZWQgc29tZSBmaXhlcyB0byBhZl92c29jay5jIGFuZCB2
aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jLA0KPj4+PiB0ZXN0IGlzIGFsc28gaW1wbGVtZW50ZWQu
DQo+Pj4+DQo+Pj4+IDIpIHZpcnRpby92c29jazoNCj4+Pj4gSXQgYWRkcyBzb21lIG9wdGltaXph
dGlvbiB0byB3YWtlIHVwcywgd2hlbiBuZXcgZGF0YSBhcnJpdmVkLiBOb3csDQo+Pj4+IFNPX1JD
VkxPV0FUIGlzIGNvbnNpZGVyZWQgYmVmb3JlIHdha2UgdXAgc2xlZXBlcnMgd2hvIHdhaXQgbmV3
IGRhdGEuDQo+Pj4+IFRoZXJlIGlzIG5vIHNlbnNlLCB0byBraWNrIHdhaXRlciwgd2hlbiBudW1i
ZXIgb2YgYXZhaWxhYmxlIGJ5dGVzDQo+Pj4+IGluIHNvY2tldCdzIHF1ZXVlIDwgU09fUkNWTE9X
QVQsIGJlY2F1c2UgaWYgd2Ugd2FrZSB1cCByZWFkZXIgaW4NCj4+Pj4gdGhpcyBjYXNlLCBpdCB3
aWxsIHdhaXQgZm9yIFNPX1JDVkxPV0FUIGRhdGEgYW55d2F5IGR1cmluZyBkZXF1ZXVlLA0KPj4+
PiBvciBpbiBwb2xsKCkgY2FzZSwgUE9MTElOL1BPTExSRE5PUk0gYml0cyB3b24ndCBiZSBzZXQs
IHNvIHN1Y2gNCj4+Pj4gZXhpdCBmcm9tIHBvbGwoKSB3aWxsIGJlICJzcHVyaW91cyIuIFRoaXMg
bG9naWMgaXMgYWxzbyB1c2VkIGluIFRDUA0KPj4+PiBzb2NrZXRzLg0KPj4+DQo+Pj4gTmljZSwg
aXQgbG9va3MgZ29vZCENCj4+IFRoYW5rIFlvdSENCj4+Pg0KPj4+Pg0KPj4+PiAzKSB2bWNpL3Zz
b2NrOg0KPj4+PiBTYW1lIGFzIDIpLCBidXQgaSdtIG5vdCBzdXJlIGFib3V0IHRoaXMgY2hhbmdl
cy4gV2lsbCBiZSB2ZXJ5IGdvb2QsDQo+Pj4+IHRvIGdldCBjb21tZW50cyBmcm9tIHNvbWVvbmUg
d2hvIGtub3dzIHRoaXMgY29kZS4NCj4+Pg0KPj4+IEkgQ0NlZCBWTUNJIG1haW50YWluZXJzIHRv
IHRoZSBwYXRjaCBhbmQgYWxzbyB0byB0aGlzIGNvdmVyLCBtYXliZSBiZXR0ZXIgdG8ga2VlcCB0
aGVtIGluIHRoZSBsb29wIGZvciBuZXh0IHZlcnNpb25zLg0KPj4+DQo+Pj4gKEpvcmdlbidzIGFu
ZCBSYWplc2gncyBlbWFpbHMgYm91bmNlZCBiYWNrLCBzbyBJJ20gQ0NpbmcgaGVyZSBvbmx5IEJy
eWFuLCBWaXNobnUsIGFuZCBwdi1kcml2ZXJzQHZtd2FyZS5jb20pDQo+PiBPaywgaSdsbCBDQyB0
aGVtIGluIHRoZSBuZXh0IHZlcnNpb24NCj4+Pg0KPj4+Pg0KPj4+PiA0KSBIeXBlci1WOg0KPj4+
PiBBcyBEZXh1YW4gQ3VpIG1lbnRpb25lZCwgZm9yIEh5cGVyLVYgdHJhbnNwb3J0IGl0IGlzIGRp
ZmZpY3VsdCB0bw0KPj4+PiBzdXBwb3J0IFNPX1JDVkxPV0FULCBzbyBoZSBzdWdnZXN0ZWQgdG8g
ZGlzYWJsZSB0aGlzIGZlYXR1cmUgZm9yDQo+Pj4+IEh5cGVyLVYuDQo+Pj4NCj4+PiBJIGxlZnQg
YSBjb3VwbGUgb2YgY29tbWVudHMgaW4gc29tZSBwYXRjaGVzLCBidXQgaXQgc2VlbXMgdG8gbWUg
dG8gYmUgaW4gYSBnb29kIHN0YXRlIDotKQ0KPj4+DQo+Pj4gSSB3b3VsZCBqdXN0IHN1Z2dlc3Qg
YSBiaXQgb2YgYSByZS1vcmdhbml6YXRpb24gb2YgdGhlIHNlcmllcyAodGhlIHBhdGNoZXMgYXJl
IGZpbmUsIGp1c3QgdGhlIG9yZGVyKToNCj4+PiAtIGludHJvZHVjZSB2c29ja19zZXRfcmN2bG93
YXQoKQ0KPj4+IC0gZGlzYWJsaW5nIGl0IGZvciBodl9zb2NrDQo+Pj4gLSB1c2UgJ3RhcmdldCcg
aW4gdmlydGlvIHRyYW5zcG9ydHMNCj4+PiAtIHVzZSAndGFyZ2V0JyBpbiB2bWNpIHRyYW5zcG9y
dHMNCj4+PiAtIHVzZSBzb2NrX3Jjdmxvd2F0IGluIHZzb2NrX3BvbGwoKQ0KPj4+IEkgdGhpbmsg
aXMgYmV0dGVyIHRvIHBhc3Mgc29ja19yY3Zsb3dhdCgpIGFzICd0YXJnZXQnIHdoZW4gdGhlDQo+
Pj4gdHJhbnNwb3J0cyBhcmUgYWxyZWFkeSBhYmxlIHRvIHVzZSBpdA0KPj4+IC0gYWRkIHZzb2Nr
X2RhdGFfcmVhZHkoKQ0KPj4+IC0gdXNlIHZzb2NrX2RhdGFfcmVhZHkoKSBpbiB2aXJ0aW8gdHJh
bnNwb3J0cw0KPj4+IC0gdXNlIHZzb2NrX2RhdGFfcmVhZHkoKSBpbiB2bWNpIHRyYW5zcG9ydHMN
Cj4+PiAtIHRlc3RzDQo+Pj4NCj4+PiBXaGF0IGRvIHlvdSB0aGluaz8NCj4+IE5vIHByb2JsZW0h
IEkgdGhpbmsgaSBjYW4gd2FpdCBmb3IgcmVwbHkgZnJvbSBWTVdhcmUgZ3V5cyBiZWZvcmUgcHJl
cGFyaW5nIHYzDQo+IA0KPiBMb29rcyBmaW5lIHRvIG1lLCBlc3BlY2lhbGx5IHRoZSBWTUNJIHBh
cnRzLiAgUGxlYXNlIHNlbmQgdjMsIGFuZCB3ZSBjYW4gdGVzdCBpdA0KPiBmcm9tIFZNQ0kgcG9p
bnQgb2YgdmlldyBhcyB3ZWxsLg0KR3JlYXQsIHRoYW5rIHlvdSBmb3IgcmVwbHkuIEknbGwgcHJl
cGFyZSB2MyBBU0FQIGFuZCBZb3Ugd2lsbCBiZSBDQ2VkDQoNClRoYW5rcywNCkFyc2VuaXkNCj4g
DQo+IFRoYW5rcywNCj4gVmlzaG51DQoNCg==
