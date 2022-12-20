Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7CB651B61
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 08:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiLTHQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 02:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbiLTHQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 02:16:10 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65554DEE4;
        Mon, 19 Dec 2022 23:14:34 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 8E0DA5FD04;
        Tue, 20 Dec 2022 10:14:31 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1671520471;
        bh=Xd0BCVsrk3kr4gnn18tLqXU4C6sJACZPPguQzkRYYsQ=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=iqojmdwNrEmeYrvi74CKc0x6N9zAVTFnYnGI8wuwvjWJc8vKrQ4j1SRUqx5MGhSAj
         pQASaU/+Hobep146+p32pbFyOzqFBl20T/Xyt6Eh30wzxL0k4CD056WAo0iL4DlYmS
         dDp//rv77FxBmcJoPR8eUnRTcAghEy+hxt808vb/1Rc8wcTBiRcbXkQ1ZF7g1KsWoV
         8AEtHEAhjj30KilkziU5cfqlOAjubBxBM0J3mGx2u9C/crndfE9IU5k/lL4LaqetOl
         5vmix4rTISeBcnFOizJtdHGodboS2qxquQMHbOgEaFy/vjBprx0FUoCE4CtZITKme9
         ME/gfMYrB9rhw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 20 Dec 2022 10:14:28 +0300 (MSK)
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
Thread-Index: AQHZEk+jG/1mxrs/wUyXm0IW7LxCR651KceAgAEEOAA=
Date:   Tue, 20 Dec 2022 07:14:27 +0000
Message-ID: <2bc5a0c0-5fb7-9d0e-bd45-879e42c1ea50@sberdevices.ru>
References: <39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru>
 <CAGxU2F4ca5pxW3RX4wzsTx3KRBtxLK_rO9KxPgUtqcaSNsqXCA@mail.gmail.com>
In-Reply-To: <CAGxU2F4ca5pxW3RX4wzsTx3KRBtxLK_rO9KxPgUtqcaSNsqXCA@mail.gmail.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE922E7A59E7144B9A68546850E08FC1@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/20 03:38:00 #20687629
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTkuMTIuMjAyMiAxODo0MSwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KDQpIZWxsbyEN
Cg0KPiBIaSBBcnNlbml5LA0KPiANCj4gT24gU2F0LCBEZWMgMTcsIDIwMjIgYXQgODo0MiBQTSBB
cnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4gd3JvdGU6DQo+Pg0KPj4g
SGVsbG8sDQo+Pg0KPj4gc2VlbXMgSSBmb3VuZCBzdHJhbmdlIHRoaW5nKG1heSBiZSBhIGJ1Zykg
d2hlcmUgc2VuZGVyKCd0eCcgbGF0ZXIpIGFuZA0KPj4gcmVjZWl2ZXIoJ3J4JyBsYXRlcikgY291
bGQgc3R1Y2sgZm9yZXZlci4gUG90ZW50aWFsIGZpeCBpcyBpbiB0aGUgZmlyc3QNCj4+IHBhdGNo
LCBzZWNvbmQgcGF0Y2ggY29udGFpbnMgcmVwcm9kdWNlciwgYmFzZWQgb24gdnNvY2sgdGVzdCBz
dWl0ZS4NCj4+IFJlcHJvZHVjZXIgaXMgc2ltcGxlOiB0eCBqdXN0IHNlbmRzIGRhdGEgdG8gcngg
YnkgJ3dyaXRlKCkgc3lzY2FsbCwgcngNCj4+IGRlcXVldWVzIGl0IHVzaW5nICdyZWFkKCknIHN5
c2NhbGwgYW5kIHVzZXMgJ3BvbGwoKScgZm9yIHdhaXRpbmcuIEkgcnVuDQo+PiBzZXJ2ZXIgaW4g
aG9zdCBhbmQgY2xpZW50IGluIGd1ZXN0Lg0KPj4NCj4+IHJ4IHNpZGUgcGFyYW1zOg0KPj4gMSkg
U09fVk1fU09DS0VUU19CVUZGRVJfU0laRSBpcyAyNTZLYihlLmcuIGRlZmF1bHQpLg0KPj4gMikg
U09fUkNWTE9XQVQgaXMgMTI4S2IuDQo+Pg0KPj4gV2hhdCBoYXBwZW5zIGluIHRoZSByZXByb2R1
Y2VyIHN0ZXAgYnkgc3RlcDoNCj4+DQo+IA0KPiBJIHB1dCB0aGUgdmFsdWVzIG9mIHRoZSB2YXJp
YWJsZXMgaW52b2x2ZWQgdG8gZmFjaWxpdGF0ZSB1bmRlcnN0YW5kaW5nOg0KPiANCj4gUlg6IGJ1
Zl9hbGxvYyA9IDI1NiBLQjsgZndkX2NudCA9IDA7IGxhc3RfZndkX2NudCA9IDA7DQo+ICAgICBm
cmVlX3NwYWNlID0gYnVmX2FsbG9jIC0gKGZ3ZF9jbnQgLSBsYXN0X2Z3ZF9jbnQpID0gMjU2IEtC
DQo+IA0KPiBUaGUgY3JlZGl0IHVwZGF0ZSBpcyBzZW50IGlmDQo+IGZyZWVfc3BhY2UgPCBWSVJU
SU9fVlNPQ0tfTUFYX1BLVF9CVUZfU0laRSBbNjQgS0JdDQo+IA0KPj4gMSkgdHggdHJpZXMgdG8g
c2VuZCAyNTZLYiArIDEgYnl0ZSAoaW4gYSBzaW5nbGUgJ3dyaXRlKCknKQ0KPj4gMikgdHggc2Vu
ZHMgMjU2S2IsIGRhdGEgcmVhY2hlcyByeCAocnhfYnl0ZXMgPT0gMjU2S2IpDQo+PiAzKSB0eCB3
YWl0cyBmb3Igc3BhY2UgaW4gJ3dyaXRlKCknIHRvIHNlbmQgbGFzdCAxIGJ5dGUNCj4+IDQpIHJ4
IGRvZXMgcG9sbCgpLCAocnhfYnl0ZXMgPj0gcmN2bG93YXQpIDI1NktiID49IDEyOEtiLCBQT0xM
SU4gaXMgc2V0DQo+PiA1KSByeCByZWFkcyA2NEtiLCBjcmVkaXQgdXBkYXRlIGlzIG5vdCBzZW50
IGR1ZSB0byAqDQo+IA0KPiBSWDogYnVmX2FsbG9jID0gMjU2IEtCOyBmd2RfY250ID0gNjQgS0I7
IGxhc3RfZndkX2NudCA9IDA7DQo+ICAgICBmcmVlX3NwYWNlID0gMTkyIEtCDQo+IA0KPj4gNikg
cnggZG9lcyBwb2xsKCksIChyeF9ieXRlcyA+PSByY3Zsb3dhdCkgMTkyS2IgPj0gMTI4S2IsIFBP
TExJTiBpcyBzZXQNCj4+IDcpIHJ4IHJlYWRzIDY0S2IsIGNyZWRpdCB1cGRhdGUgaXMgbm90IHNl
bnQgZHVlIHRvICoNCj4gDQo+IFJYOiBidWZfYWxsb2MgPSAyNTYgS0I7IGZ3ZF9jbnQgPSAxMjgg
S0I7IGxhc3RfZndkX2NudCA9IDA7DQo+ICAgICBmcmVlX3NwYWNlID0gMTI4IEtCDQo+IA0KPj4g
OCkgcnggZG9lcyBwb2xsKCksIChyeF9ieXRlcyA+PSByY3Zsb3dhdCkgMTI4S2IgPj0gMTI4S2Is
IFBPTExJTiBpcyBzZXQNCj4+IDkpIHJ4IHJlYWRzIDY0S2IsIGNyZWRpdCB1cGRhdGUgaXMgbm90
IHNlbnQgZHVlIHRvICoNCj4gDQo+IFJpZ2h0LCAoZnJlZV9zcGFjZSA8IFZJUlRJT19WU09DS19N
QVhfUEtUX0JVRl9TSVpFKSBpcyBzdGlsbCBmYWxzZS4NCj4gDQo+IFJYOiBidWZfYWxsb2MgPSAy
NTYgS0I7IGZ3ZF9jbnQgPSAxOTYgS0I7IGxhc3RfZndkX2NudCA9IDA7DQo+ICAgICBmcmVlX3Nw
YWNlID0gNjQgS0INCj4gDQo+PiAxMCkgcnggZG9lcyBwb2xsKCksIChyeF9ieXRlcyA8IHJjdmxv
d2F0KSA2NEtiIDwgMTI4S2IsIHJ4IHdhaXRzIGluIHBvbGwoKQ0KPiANCj4gSSBhZ3JlZSB0aGF0
IHRoZSBUWCBpcyBzdHVjayBiZWNhdXNlIHdlIGFyZSBub3Qgc2VuZGluZyB0aGUgY3JlZGl0IA0K
PiB1cGRhdGUsIGJ1dCBhbHNvIGlmIFJYIHNlbmRzIHRoZSBjcmVkaXQgdXBkYXRlIGF0IHN0ZXAg
OSwgUlggd29uJ3QgYmUgDQo+IHdva2VuIHVwIGF0IHN0ZXAgMTAsIHJpZ2h0Pw0KDQpZZXMsIFJY
IHdpbGwgc2xlZXAsIGJ1dCBUWCB3aWxsIHdha2UgdXAgYW5kIGFzIHdlIGluZm9ybSBUWCBob3cg
bXVjaA0KZnJlZSBzcGFjZSB3ZSBoYXZlLCBub3cgdGhlcmUgYXJlIHR3byBjYXNlcyBmb3IgVFg6
DQoxKSBzZW5kICJzbWFsbCIgcmVzdCBvZiBkYXRhKGUuZy4gd2l0aG91dCBibG9ja2luZyBhZ2Fp
biksIGxlYXZlICd3cml0ZSgpJw0KICAgYW5kIGNvbnRpbnVlIGV4ZWN1dGlvbi4gUlggc3RpbGwg
d2FpdHMgaW4gJ3BvbGwoKScuIExhdGVyIFRYIHdpbGwNCiAgIHNlbmQgZW5vdWdoIGRhdGEgdG8g
d2FrZSB1cCBSWC4NCjIpIHNlbmQgImJpZyIgcmVzdCBvZiBkYXRhIC0gaWYgcmVzdCBpcyB0b28g
YmlnIHRvIGxlYXZlICd3cml0ZSgpJyBhbmQgVFgNCiAgIHdpbGwgd2FpdCBhZ2FpbiBmb3IgdGhl
IGZyZWUgc3BhY2UgLSBpdCB3aWxsIGJlIGFibGUgdG8gc2VuZCBlbm91Z2ggZGF0YQ0KICAgdG8g
d2FrZSB1cCBSWCBhcyB3ZSBjb21wYXJlZCAncnhfYnl0ZXMnIHdpdGggcmN2bG93YXQgdmFsdWUg
aW4gUlguDQo+IA0KPj4NCj4+ICogaXMgb3B0aW1pemF0aW9uIGluICd2aXJ0aW9fdHJhbnNwb3J0
X3N0cmVhbV9kb19kZXF1ZXVlKCknIHdoaWNoDQo+PiAgIHNlbmRzIE9QX0NSRURJVF9VUERBVEUg
b25seSB3aGVuIHdlIGhhdmUgbm90IHRvbyBtdWNoIHNwYWNlIC0NCj4+ICAgbGVzcyB0aGFuIFZJ
UlRJT19WU09DS19NQVhfUEtUX0JVRl9TSVpFLg0KPj4NCj4+IE5vdyB0eCBzaWRlIHdhaXRzIGZv
ciBzcGFjZSBpbnNpZGUgd3JpdGUoKSBhbmQgcnggd2FpdHMgaW4gcG9sbCgpIGZvcg0KPj4gJ3J4
X2J5dGVzJyB0byByZWFjaCBTT19SQ1ZMT1dBVCB2YWx1ZS4gQm90aCBzaWRlcyB3aWxsIHdhaXQg
Zm9yZXZlci4gSQ0KPj4gdGhpbmssIHBvc3NpYmxlIGZpeCBpcyB0byBzZW5kIGNyZWRpdCB1cGRh
dGUgbm90IG9ubHkgd2hlbiB3ZSBoYXZlIHRvbw0KPj4gc21hbGwgc3BhY2UsIGJ1dCBhbHNvIHdo
ZW4gbnVtYmVyIG9mIGJ5dGVzIGluIHJlY2VpdmUgcXVldWUgaXMgc21hbGxlcg0KPj4gdGhhbiBT
T19SQ1ZMT1dBVCB0aHVzIG5vdCBlbm91Z2ggdG8gd2FrZSB1cCBzbGVlcGluZyByZWFkZXIuIEkn
bSBub3QNCj4+IHN1cmUgYWJvdXQgY29ycmVjdG5lc3Mgb2YgdGhpcyBpZGVhLCBidXQgYW55d2F5
IC0gSSB0aGluayB0aGF0IHByb2JsZW0NCj4+IGFib3ZlIGV4aXN0cy4gV2hhdCBkbyBZb3UgdGhp
bms/DQo+IA0KPiBJJ20gbm90IHN1cmUsIEkgaGF2ZSB0byB0aGluayBtb3JlIGFib3V0IGl0LCBi
dXQgaWYgUlggcmVhZHMgbGVzcyB0aGFuIA0KPiBTT19SQ1ZMT1dBVCwgSSBleHBlY3QgaXQncyBu
b3JtYWwgdG8gZ2V0IHRvIGEgY2FzZSBvZiBzdHVjay4NCj4gDQo+IEluIHRoaXMgY2FzZSB3ZSBh
cmUgb25seSB1bnN0dWNraW5nIFRYLCBidXQgZXZlbiBpZiBpdCBzZW5kcyB0aGF0IHNpbmdsZSAN
Cj4gYnl0ZSwgUlggaXMgc3RpbGwgc3R1Y2sgYW5kIG5vdCBjb25zdW1pbmcgaXQsIHNvIGl0IHdh
cyB1c2VsZXNzIHRvIHdha2UgDQo+IHVwIFRYIGlmIFJYIHdvbid0IGNvbnN1bWUgaXQgYW55d2F5
LCByaWdodD8NCg0KMSkgSSB0aGluayBpdCBpcyBub3QgdXNlbGVzcywgYmVjYXVzZSB3ZSBpbmZv
cm0obm90IGp1c3Qgd2FrZSB1cCkgVFggdGhhdA0KdGhlcmUgaXMgZnJlZSBzcGFjZSBhdCBSWCBz
aWRlIC0gYXMgaSBtZW50aW9uZWQgYWJvdmUuDQoyKSBBbnl3YXkgaSB0aGluayB0aGF0IHRoaXMg
c2l0dWF0aW9uIGlzIGEgbGl0dGxlIGJpdCBzdHJhbmdlOiBUWCB0aGlua3MgdGhhdA0KdGhlcmUg
aXMgbm8gZnJlZSBzcGFjZSBhdCBSWCBhbmQgd2FpdHMgZm9yIGl0LCBidXQgdGhlcmUgaXMgZnJl
ZSBzcGFjZSBhdCBSWCENCkF0IHRoZSBzYW1lIHRpbWUsIFJYIHdhaXRzIGluIHBvbGwoKSBmb3Jl
dmVyIC0gaXQgaXMgcmVhZHkgdG8gZ2V0IG5ldyBwb3J0aW9uDQpvZiBkYXRhIHRvIHJldHVybiBQ
T0xMSU4sIGJ1dCBUWCAidGhpbmtzIiBleGFjdGx5IG9wcG9zaXRlIHRoaW5nIC0gUlggaXMgZnVs
bA0Kb2YgZGF0YS4gT2YgY291cnNlLCBpZiB0aGVyZSB3aWxsIGJlIGp1c3Qgc3RhbGxzIGluIFRY
IGRhdGEgaGFuZGxpbmcgLSBpdCB3aWxsDQpiZSBvayAtIGp1c3QgcGVyZm9ybWFuY2UgZGVncmFk
YXRpb24sIGJ1dCBUWCBzdHVja3MgZm9yZXZlci4NCg0KPiANCj4gSWYgUlggd29rZSB1cCAoZS5n
LiBTT19SQ1ZMT1dBVCA9IDY0S0IpIGFuZCByZWFkIHRoZSByZW1haW5pbmcgNjRLQiwgDQo+IHRo
ZW4gaXQgd291bGQgc3RpbGwgc2VuZCB0aGUgY3JlZGl0IHVwZGF0ZSBldmVuIHdpdGhvdXQgdGhp
cyBwYXRjaCBhbmQgDQo+IFRYIHdpbGwgc2VuZCB0aGUgMSBieXRlLg0KDQpCdXQgaG93IFJYIHdp
bGwgd2FrZSB1cCBpbiB0aGlzIGNhc2U/IEUuZy4gaXQgY2FsbHMgcG9sbCgpIHdpdGhvdXQgdGlt
ZW91dCwNCmNvbm5lY3Rpb24gaXMgZXN0YWJsaXNoZWQsIFJYIGlnbm9yZXMgc2lnbmFsDQoNClRo
YW5rcywgQXJzZW5peQ0KPiANCj4gVGhhbmtzLA0KPiBTdGVmYW5vDQo+IA0KDQo=
