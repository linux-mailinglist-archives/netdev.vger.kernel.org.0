Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C85652033
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 13:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbiLTMJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 07:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiLTMJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 07:09:42 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51B7101D0;
        Tue, 20 Dec 2022 04:09:40 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 041715FD04;
        Tue, 20 Dec 2022 15:09:39 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1671538179;
        bh=Pe7f+X2GSFt4tJ8TgDi+rPvFRjMaeC8w+iD49Pz5ZAg=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=F4BzULaOPHd9p9cG8uNGFHhqXE4qOInHk+O2su9OJVDYsKPDvu6HhC1rBZASrmDIG
         09eDjmmRf4L2FWSETBVTlGCjWR6ev30rf0mfpl5JyzgFRFTWANILLXd7WAcBZPMQAA
         UwnC2bMD6sV82/+9zveppnXylBd/vKV+HOSCFtoCD5msPCXmzJ22Jr2SewaguDRIib
         /J+C8Iy3LjTHpeYRTprH9aUk3xGLuN3/4917cHRngkeVqfu84is3UpLZY+sF/Xe/SL
         wonmlrMQj9gU6gIjxWnmL0H5q3KKKfH32WqPWvSGUgTSihqlpr98XWPHtra8J/PDEk
         PxgYN/LcbK+Gg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 20 Dec 2022 15:09:38 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 0/2] virtio/vsock: fix mutual rx/tx hungup
Thread-Topic: [RFC PATCH v1 0/2] virtio/vsock: fix mutual rx/tx hungup
Thread-Index: AQHZEk+jG/1mxrs/wUyXm0IW7LxCR651KceAgAEEOACAABZ8gIAADYMAgAAWzgCAABeqgA==
Date:   Tue, 20 Dec 2022 12:09:36 +0000
Message-ID: <e60fb580-01ea-baf6-3635-8fc8933f817f@sberdevices.ru>
References: <39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru>
 <CAGxU2F4ca5pxW3RX4wzsTx3KRBtxLK_rO9KxPgUtqcaSNsqXCA@mail.gmail.com>
 <2bc5a0c0-5fb7-9d0e-bd45-879e42c1ea50@sberdevices.ru>
 <20221220083313.mj2fd4tvfoifayaq@sgarzare-redhat>
 <741d7969-0c39-1e09-7297-84edbc8fddc7@sberdevices.ru>
 <20221220104312.5efhzu5ildj5smnn@sgarzare-redhat>
In-Reply-To: <20221220104312.5efhzu5ildj5smnn@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0150E65FAD09FA4EBB48139FE3A58CDA@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/20 06:32:00 #20688041
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAuMTIuMjAyMiAxMzo0MywgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBUdWUs
IERlYyAyMCwgMjAyMiBhdCAwOToyMzoxN0FNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBPbiAyMC4xMi4yMDIyIDExOjMzLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6DQo+Pj4g
T24gVHVlLCBEZWMgMjAsIDIwMjIgYXQgMDc6MTQ6MjdBTSArMDAwMCwgQXJzZW5peSBLcmFzbm92
IHdyb3RlOg0KPj4+PiBPbiAxOS4xMi4yMDIyIDE4OjQxLCBTdGVmYW5vIEdhcnphcmVsbGEgd3Jv
dGU6DQo+Pj4+DQo+Pj4+IEhlbGxvIQ0KPj4+Pg0KPj4+Pj4gSGkgQXJzZW5peSwNCj4+Pj4+DQo+
Pj4+PiBPbiBTYXQsIERlYyAxNywgMjAyMiBhdCA4OjQyIFBNIEFyc2VuaXkgS3Jhc25vdiA8QVZL
cmFzbm92QHNiZXJkZXZpY2VzLnJ1PiB3cm90ZToNCj4+Pj4+Pg0KPj4+Pj4+IEhlbGxvLA0KPj4+
Pj4+DQo+Pj4+Pj4gc2VlbXMgSSBmb3VuZCBzdHJhbmdlIHRoaW5nKG1heSBiZSBhIGJ1Zykgd2hl
cmUgc2VuZGVyKCd0eCcgbGF0ZXIpIGFuZA0KPj4+Pj4+IHJlY2VpdmVyKCdyeCcgbGF0ZXIpIGNv
dWxkIHN0dWNrIGZvcmV2ZXIuIFBvdGVudGlhbCBmaXggaXMgaW4gdGhlIGZpcnN0DQo+Pj4+Pj4g
cGF0Y2gsIHNlY29uZCBwYXRjaCBjb250YWlucyByZXByb2R1Y2VyLCBiYXNlZCBvbiB2c29jayB0
ZXN0IHN1aXRlLg0KPj4+Pj4+IFJlcHJvZHVjZXIgaXMgc2ltcGxlOiB0eCBqdXN0IHNlbmRzIGRh
dGEgdG8gcnggYnkgJ3dyaXRlKCkgc3lzY2FsbCwgcngNCj4+Pj4+PiBkZXF1ZXVlcyBpdCB1c2lu
ZyAncmVhZCgpJyBzeXNjYWxsIGFuZCB1c2VzICdwb2xsKCknIGZvciB3YWl0aW5nLiBJIHJ1bg0K
Pj4+Pj4+IHNlcnZlciBpbiBob3N0IGFuZCBjbGllbnQgaW4gZ3Vlc3QuDQo+Pj4+Pj4NCj4+Pj4+
PiByeCBzaWRlIHBhcmFtczoNCj4+Pj4+PiAxKSBTT19WTV9TT0NLRVRTX0JVRkZFUl9TSVpFIGlz
IDI1NktiKGUuZy4gZGVmYXVsdCkuDQo+Pj4+Pj4gMikgU09fUkNWTE9XQVQgaXMgMTI4S2IuDQo+
Pj4+Pj4NCj4+Pj4+PiBXaGF0IGhhcHBlbnMgaW4gdGhlIHJlcHJvZHVjZXIgc3RlcCBieSBzdGVw
Og0KPj4+Pj4+DQo+Pj4+Pg0KPj4+Pj4gSSBwdXQgdGhlIHZhbHVlcyBvZiB0aGUgdmFyaWFibGVz
IGludm9sdmVkIHRvIGZhY2lsaXRhdGUgdW5kZXJzdGFuZGluZzoNCj4+Pj4+DQo+Pj4+PiBSWDog
YnVmX2FsbG9jID0gMjU2IEtCOyBmd2RfY250ID0gMDsgbGFzdF9md2RfY250ID0gMDsNCj4+Pj4+
IMKgwqDCoCBmcmVlX3NwYWNlID0gYnVmX2FsbG9jIC0gKGZ3ZF9jbnQgLSBsYXN0X2Z3ZF9jbnQp
ID0gMjU2IEtCDQo+Pj4+Pg0KPj4+Pj4gVGhlIGNyZWRpdCB1cGRhdGUgaXMgc2VudCBpZg0KPj4+
Pj4gZnJlZV9zcGFjZSA8IFZJUlRJT19WU09DS19NQVhfUEtUX0JVRl9TSVpFIFs2NCBLQl0NCj4+
Pj4+DQo+Pj4+Pj4gMSkgdHggdHJpZXMgdG8gc2VuZCAyNTZLYiArIDEgYnl0ZSAoaW4gYSBzaW5n
bGUgJ3dyaXRlKCknKQ0KPj4+Pj4+IDIpIHR4IHNlbmRzIDI1NktiLCBkYXRhIHJlYWNoZXMgcngg
KHJ4X2J5dGVzID09IDI1NktiKQ0KPj4+Pj4+IDMpIHR4IHdhaXRzIGZvciBzcGFjZSBpbiAnd3Jp
dGUoKScgdG8gc2VuZCBsYXN0IDEgYnl0ZQ0KPj4+Pj4+IDQpIHJ4IGRvZXMgcG9sbCgpLCAocnhf
Ynl0ZXMgPj0gcmN2bG93YXQpIDI1NktiID49IDEyOEtiLCBQT0xMSU4gaXMgc2V0DQo+Pj4+Pj4g
NSkgcnggcmVhZHMgNjRLYiwgY3JlZGl0IHVwZGF0ZSBpcyBub3Qgc2VudCBkdWUgdG8gKg0KPj4+
Pj4NCj4+Pj4+IFJYOiBidWZfYWxsb2MgPSAyNTYgS0I7IGZ3ZF9jbnQgPSA2NCBLQjsgbGFzdF9m
d2RfY250ID0gMDsNCj4+Pj4+IMKgwqDCoCBmcmVlX3NwYWNlID0gMTkyIEtCDQo+Pj4+Pg0KPj4+
Pj4+IDYpIHJ4IGRvZXMgcG9sbCgpLCAocnhfYnl0ZXMgPj0gcmN2bG93YXQpIDE5MktiID49IDEy
OEtiLCBQT0xMSU4gaXMgc2V0DQo+Pj4+Pj4gNykgcnggcmVhZHMgNjRLYiwgY3JlZGl0IHVwZGF0
ZSBpcyBub3Qgc2VudCBkdWUgdG8gKg0KPj4+Pj4NCj4+Pj4+IFJYOiBidWZfYWxsb2MgPSAyNTYg
S0I7IGZ3ZF9jbnQgPSAxMjggS0I7IGxhc3RfZndkX2NudCA9IDA7DQo+Pj4+PiDCoMKgwqAgZnJl
ZV9zcGFjZSA9IDEyOCBLQg0KPj4+Pj4NCj4+Pj4+PiA4KSByeCBkb2VzIHBvbGwoKSwgKHJ4X2J5
dGVzID49IHJjdmxvd2F0KSAxMjhLYiA+PSAxMjhLYiwgUE9MTElOIGlzIHNldA0KPj4+Pj4+IDkp
IHJ4IHJlYWRzIDY0S2IsIGNyZWRpdCB1cGRhdGUgaXMgbm90IHNlbnQgZHVlIHRvICoNCj4+Pj4+
DQo+Pj4+PiBSaWdodCwgKGZyZWVfc3BhY2UgPCBWSVJUSU9fVlNPQ0tfTUFYX1BLVF9CVUZfU0la
RSkgaXMgc3RpbGwgZmFsc2UuDQo+Pj4+Pg0KPj4+Pj4gUlg6IGJ1Zl9hbGxvYyA9IDI1NiBLQjsg
ZndkX2NudCA9IDE5NiBLQjsgbGFzdF9md2RfY250ID0gMDsNCj4+Pj4+IMKgwqDCoCBmcmVlX3Nw
YWNlID0gNjQgS0INCj4+Pj4+DQo+Pj4+Pj4gMTApIHJ4IGRvZXMgcG9sbCgpLCAocnhfYnl0ZXMg
PCByY3Zsb3dhdCkgNjRLYiA8IDEyOEtiLCByeCB3YWl0cyBpbiBwb2xsKCkNCj4+Pj4+DQo+Pj4+
PiBJIGFncmVlIHRoYXQgdGhlIFRYIGlzIHN0dWNrIGJlY2F1c2Ugd2UgYXJlIG5vdCBzZW5kaW5n
IHRoZSBjcmVkaXQNCj4+Pj4+IHVwZGF0ZSwgYnV0IGFsc28gaWYgUlggc2VuZHMgdGhlIGNyZWRp
dCB1cGRhdGUgYXQgc3RlcCA5LCBSWCB3b24ndCBiZQ0KPj4+Pj4gd29rZW4gdXAgYXQgc3RlcCAx
MCwgcmlnaHQ/DQo+Pj4+DQo+Pj4+IFllcywgUlggd2lsbCBzbGVlcCwgYnV0IFRYIHdpbGwgd2Fr
ZSB1cCBhbmQgYXMgd2UgaW5mb3JtIFRYIGhvdyBtdWNoDQo+Pj4+IGZyZWUgc3BhY2Ugd2UgaGF2
ZSwgbm93IHRoZXJlIGFyZSB0d28gY2FzZXMgZm9yIFRYOg0KPj4+PiAxKSBzZW5kICJzbWFsbCIg
cmVzdCBvZiBkYXRhKGUuZy4gd2l0aG91dCBibG9ja2luZyBhZ2FpbiksIGxlYXZlICd3cml0ZSgp
Jw0KPj4+PiDCoCBhbmQgY29udGludWUgZXhlY3V0aW9uLiBSWCBzdGlsbCB3YWl0cyBpbiAncG9s
bCgpJy4gTGF0ZXIgVFggd2lsbA0KPj4+PiDCoCBzZW5kIGVub3VnaCBkYXRhIHRvIHdha2UgdXAg
UlguDQo+Pj4+IDIpIHNlbmQgImJpZyIgcmVzdCBvZiBkYXRhIC0gaWYgcmVzdCBpcyB0b28gYmln
IHRvIGxlYXZlICd3cml0ZSgpJyBhbmQgVFgNCj4+Pj4gwqAgd2lsbCB3YWl0IGFnYWluIGZvciB0
aGUgZnJlZSBzcGFjZSAtIGl0IHdpbGwgYmUgYWJsZSB0byBzZW5kIGVub3VnaCBkYXRhDQo+Pj4+
IMKgIHRvIHdha2UgdXAgUlggYXMgd2UgY29tcGFyZWQgJ3J4X2J5dGVzJyB3aXRoIHJjdmxvd2F0
IHZhbHVlIGluIFJYLg0KPj4+DQo+Pj4gUmlnaHQsIHNvIEknZCB1cGRhdGUgdGhlIHRlc3QgdG8g
YmVoYXZlIGxpa2UgdGhpcy4NCj4+IFNvcnJ5LCBZb3UgbWVhbiB2c29ja190ZXN0PyBUbyBjb3Zl
ciBUWCB3YWl0aW5nIGZvciBmcmVlIHNwYWNlIGF0IFJYLCB0aHVzIGNoZWNraW5nDQo+PiB0aGlz
IGtlcm5lbCBwYXRjaCBsb2dpYz8NCj4gDQo+IFllcCwgSSBtZWFuIHRoZSB0ZXN0IHRoYXQgeW91
IGFkZGVkIGluIHRoaXMgc2VyaWVzLg0KT2sNCj4gDQo+Pj4gQW5kIEknZCBleHBsYWluIGJldHRl
ciB0aGUgcHJvYmxlbSB3ZSBhcmUgZ29pbmcgdG8gZml4IGluIHRoZSBjb21taXQgbWVzc2FnZS4N
Cj4+IE9rDQo+Pj4NCj4+Pj4+DQo+Pj4+Pj4NCj4+Pj4+PiAqIGlzIG9wdGltaXphdGlvbiBpbiAn
dmlydGlvX3RyYW5zcG9ydF9zdHJlYW1fZG9fZGVxdWV1ZSgpJyB3aGljaA0KPj4+Pj4+IMKgIHNl
bmRzIE9QX0NSRURJVF9VUERBVEUgb25seSB3aGVuIHdlIGhhdmUgbm90IHRvbyBtdWNoIHNwYWNl
IC0NCj4+Pj4+PiDCoCBsZXNzIHRoYW4gVklSVElPX1ZTT0NLX01BWF9QS1RfQlVGX1NJWkUuDQo+
Pj4+Pj4NCj4+Pj4+PiBOb3cgdHggc2lkZSB3YWl0cyBmb3Igc3BhY2UgaW5zaWRlIHdyaXRlKCkg
YW5kIHJ4IHdhaXRzIGluIHBvbGwoKSBmb3INCj4+Pj4+PiAncnhfYnl0ZXMnIHRvIHJlYWNoIFNP
X1JDVkxPV0FUIHZhbHVlLiBCb3RoIHNpZGVzIHdpbGwgd2FpdCBmb3JldmVyLiBJDQo+Pj4+Pj4g
dGhpbmssIHBvc3NpYmxlIGZpeCBpcyB0byBzZW5kIGNyZWRpdCB1cGRhdGUgbm90IG9ubHkgd2hl
biB3ZSBoYXZlIHRvbw0KPj4+Pj4+IHNtYWxsIHNwYWNlLCBidXQgYWxzbyB3aGVuIG51bWJlciBv
ZiBieXRlcyBpbiByZWNlaXZlIHF1ZXVlIGlzIHNtYWxsZXINCj4+Pj4+PiB0aGFuIFNPX1JDVkxP
V0FUIHRodXMgbm90IGVub3VnaCB0byB3YWtlIHVwIHNsZWVwaW5nIHJlYWRlci4gSSdtIG5vdA0K
Pj4+Pj4+IHN1cmUgYWJvdXQgY29ycmVjdG5lc3Mgb2YgdGhpcyBpZGVhLCBidXQgYW55d2F5IC0g
SSB0aGluayB0aGF0IHByb2JsZW0NCj4+Pj4+PiBhYm92ZSBleGlzdHMuIFdoYXQgZG8gWW91IHRo
aW5rPw0KPj4+Pj4NCj4+Pj4+IEknbSBub3Qgc3VyZSwgSSBoYXZlIHRvIHRoaW5rIG1vcmUgYWJv
dXQgaXQsIGJ1dCBpZiBSWCByZWFkcyBsZXNzIHRoYW4NCj4+Pj4+IFNPX1JDVkxPV0FULCBJIGV4
cGVjdCBpdCdzIG5vcm1hbCB0byBnZXQgdG8gYSBjYXNlIG9mIHN0dWNrLg0KPj4+Pj4NCj4+Pj4+
IEluIHRoaXMgY2FzZSB3ZSBhcmUgb25seSB1bnN0dWNraW5nIFRYLCBidXQgZXZlbiBpZiBpdCBz
ZW5kcyB0aGF0IHNpbmdsZQ0KPj4+Pj4gYnl0ZSwgUlggaXMgc3RpbGwgc3R1Y2sgYW5kIG5vdCBj
b25zdW1pbmcgaXQsIHNvIGl0IHdhcyB1c2VsZXNzIHRvIHdha2UNCj4+Pj4+IHVwIFRYIGlmIFJY
IHdvbid0IGNvbnN1bWUgaXQgYW55d2F5LCByaWdodD8NCj4+Pj4NCj4+Pj4gMSkgSSB0aGluayBp
dCBpcyBub3QgdXNlbGVzcywgYmVjYXVzZSB3ZSBpbmZvcm0obm90IGp1c3Qgd2FrZSB1cCkgVFgg
dGhhdA0KPj4+PiB0aGVyZSBpcyBmcmVlIHNwYWNlIGF0IFJYIHNpZGUgLSBhcyBpIG1lbnRpb25l
ZCBhYm92ZS4NCj4+Pj4gMikgQW55d2F5IGkgdGhpbmsgdGhhdCB0aGlzIHNpdHVhdGlvbiBpcyBh
IGxpdHRsZSBiaXQgc3RyYW5nZTogVFggdGhpbmtzIHRoYXQNCj4+Pj4gdGhlcmUgaXMgbm8gZnJl
ZSBzcGFjZSBhdCBSWCBhbmQgd2FpdHMgZm9yIGl0LCBidXQgdGhlcmUgaXMgZnJlZSBzcGFjZSBh
dCBSWCENCj4+Pj4gQXQgdGhlIHNhbWUgdGltZSwgUlggd2FpdHMgaW4gcG9sbCgpIGZvcmV2ZXIg
LSBpdCBpcyByZWFkeSB0byBnZXQgbmV3IHBvcnRpb24NCj4+Pj4gb2YgZGF0YSB0byByZXR1cm4g
UE9MTElOLCBidXQgVFggInRoaW5rcyIgZXhhY3RseSBvcHBvc2l0ZSB0aGluZyAtIFJYIGlzIGZ1
bGwNCj4+Pj4gb2YgZGF0YS4gT2YgY291cnNlLCBpZiB0aGVyZSB3aWxsIGJlIGp1c3Qgc3RhbGxz
IGluIFRYIGRhdGEgaGFuZGxpbmcgLSBpdCB3aWxsDQo+Pj4+IGJlIG9rIC0ganVzdCBwZXJmb3Jt
YW5jZSBkZWdyYWRhdGlvbiwgYnV0IFRYIHN0dWNrcyBmb3JldmVyLg0KPj4+DQo+Pj4gV2UgZGlk
IGl0IHRvIGF2b2lkIGEgbG90IG9mIGNyZWRpdCB1cGRhdGUgbWVzc2FnZXMuDQo+PiBZZXMsIGkg
c2VlDQo+Pj4gQW55d2F5IEkgdGhpbmsgaGVyZSB0aGUgbWFpbiBwb2ludCBpcyB3aHkgUlggaXMg
c2V0dGluZyBTT19SQ1ZMT1dBVCB0byAxMjggS0IgYW5kIHRoZW4gcmVhZHMgb25seSBoYWxmIG9m
IGl0Pw0KPj4+DQo+Pj4gU28gSSB0aGluayBpZiB0aGUgdXNlcnMgc2V0IFNPX1JDVkxPV0FUIHRv
IGEgdmFsdWUgYW5kIHRoZW4gUlggcmVhZHMgbGVzcyB0aGVuIGl0LCBpcyBleHBlY3RlZCB0byBn
ZXQgc3R1Y2suDQo+PiBUaGF0IGEgcmVhbGx5IGludGVyZXN0aW5nIHF1ZXN0aW9uLCBJJ3ZlIGZv
dW5kIG5vdGhpbmcgYWJvdXQgdGhpcyBjYXNlIGluIEdvb2dsZShub3Qgc3VyZSBmb3IgMTAwJSkg
b3IgUE9TSVguIEJ1dCwNCj4+IGkgY2FuIG1vZGlmeSByZXByb2R1Y2VyOiBpdCBzZXRzIFNPX1JD
VkxPV0FUIHRvIDEyOEtiIEJFRk9SRSBlbnRlcmluZyBpdHMgbGFzdCBwb2xsIHdoZXJlIGl0IHdp
bGwgc3R1Y2suIEluIHRoaXMNCj4+IGNhc2UgYmVoYXZpb3VyIGxvb2tzIG1vcmUgbGVnYWw6IGl0
IHVzZXMgZGVmYXVsdCBTT19SQ1ZMT1dBVCBvZiAxLCByZWFkIDY0S2IgZWFjaCB0aW1lLiBGaW5h
bGx5IGl0IHNldHMgU09fUkNWTE9XQVQNCj4+IHRvIDEyOEtiKGFuZCBpbWFnaW5lIHRoYXQgaXQg
cHJlcGFyZXMgMTI4S2IgJ3JlYWQoKScgYnVmZmVyKSBhbmQgZW50ZXJzIHBvbGwoKSAtIHdlIHdp
bGwgZ2V0IHNhbWUgZWZmZWN0OiBUWCB3aWxsIHdhaXQNCj4+IGZvciBzcGFjZSwgUlggd2FpdHMg
aW4gJ3BvbGwoKScuDQo+IA0KPiBHb29kIHBvaW50IQ0KPiANCj4+Pg0KPj4+IEFueXdheSwgc2lu
Y2UgdGhlIGNoYW5nZSB3aWxsIG5vdCBpbXBhY3QgdGhlIGRlZmF1bHQgYmVoYXZpb3VyIChTT19S
Q1ZMT1dBVCA9IDEpIHdlIGNhbiBtZXJnZSB0aGlzIHBhdGNoLCBidXQgSU1ITyB3ZSBuZWVkIHRv
IGV4cGxhaW4gdGhlIGNhc2UgYmV0dGVyIGFuZCBpbXByb3ZlIHRoZSB0ZXN0Lg0KPj4gSSBzZWUs
IG9mIGNvdXJzZSBJJ20gbm90IHN1cmUgYWJvdXQgdGhpcyBjaGFuZ2UsIGp1c3Qgd2FudCB0byBh
c2sgc29tZW9uZSB3aG8ga25vd3MgdGhpcyBjb2RlIGJldHRlcg0KPiANCj4gWWVzLCBpdCdzIGFu
IFJGQywgc28geW91IGRpZCB3ZWxsISA6LSkNClNvIG9rLCBJJ2xsIHByZXBhcmUgUkZDIHZlcnNp
b24gb2YgdGhpcyBwYXRjaHNldChlLmcuIENWIHdpdGggZXhwbGFuYXRpb24sIGtlcm5lbCBwYXRj
aCBhbmQgdGVzdCBmb3IgaXQpDQo+IA0KPj4+DQo+Pj4+DQo+Pj4+Pg0KPj4+Pj4gSWYgUlggd29r
ZSB1cCAoZS5nLiBTT19SQ1ZMT1dBVCA9IDY0S0IpIGFuZCByZWFkIHRoZSByZW1haW5pbmcgNjRL
QiwNCj4+Pj4+IHRoZW4gaXQgd291bGQgc3RpbGwgc2VuZCB0aGUgY3JlZGl0IHVwZGF0ZSBldmVu
IHdpdGhvdXQgdGhpcyBwYXRjaCBhbmQNCj4+Pj4+IFRYIHdpbGwgc2VuZCB0aGUgMSBieXRlLg0K
Pj4+Pg0KPj4+PiBCdXQgaG93IFJYIHdpbGwgd2FrZSB1cCBpbiB0aGlzIGNhc2U/IEUuZy4gaXQg
Y2FsbHMgcG9sbCgpIHdpdGhvdXQgdGltZW91dCwNCj4+Pj4gY29ubmVjdGlvbiBpcyBlc3RhYmxp
c2hlZCwgUlggaWdub3JlcyBzaWduYWwNCj4+Pg0KPj4+IFJYIHdpbGwgd2FrZSB1cCBiZWNhdXNl
IFNPX1JDVkxPV0FUIGlzIDY0S0IgYW5kIHRoZXJlIGFyZSA2NCBLQiBpbiB0aGUgYnVmZmVyLiBU
aGVuIFJYIHdpbGwgcmVhZCBpdCBhbmQgc2VuZCB0aGUgY3JlZGl0IHVwZGF0ZSB0byBUWCBiZWNh
dXNlDQo+Pj4gZnJlZV9zcGFjZSBpcyAwLg0KPj4gSUlVQywgaSdtIHRhbGtpbmcgYWJvdXQgMTAg
c3RlcHMgYWJvdmUsIGUuZy4gUlggd2lsbCBuZXZlciB3YWtlIHVwLCBiZWNhdXNlIFRYIGlzIHdh
aXRpbmcgZm9yIHNwYWNlLg0KPiANCj4gWWVwLCBidXQgaWYgUlggdXNlcyBTT19SQ1ZMT1dBVCA9
IDY0IEtCIGluc3RlYWQgb2YgMTI4IEtCIChJIG1lYW4gaWYgUlggcmVhZHMgYWxsIHRoZSBieXRl
cyB0aGF0IGl0J3Mgd2FpdGluZyBhcyBpdCBzcGVjaWZpZWQgaW4gU09fUkNWTE9XQVQpLCB0aGVu
IFJYIHdpbGwgc2VuZCB0aGUgY3JlZGl0IG1lc3NhZ2UuDQo+IA0KPiBCdXQgdGhlcmUgaXMgdGhl
IGNhc2UgdGhhdCB5b3UgbWVudGlvbmVkLCB3aGVuIFNPX1JDVkxPV0FUIGlzIGNoYWdlbmQgd2hp
bGUgZXhlY3V0aW5nLg0KSSdsbCB1c2UgdGhpcyBjYXNlIGZvciB0ZXN0DQo+IA0KPiBUaGFua3Ms
DQo+IFN0ZWZhbm8NCj4gDQpUaGFua3MsIEFyc2VuaXkNCg0K
