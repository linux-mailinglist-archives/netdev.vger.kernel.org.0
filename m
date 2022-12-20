Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660B6651D3E
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 10:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiLTJXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 04:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiLTJXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 04:23:33 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BD718356;
        Tue, 20 Dec 2022 01:23:28 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 8DFA25FD04;
        Tue, 20 Dec 2022 12:23:26 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1671528206;
        bh=hztykxjCoED8g4N0YDVkc5SDIPDr3ONZRsiRsKyLYK0=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=fAa8sg45+KNrDhhvzc8OjiMcQObK/uqY0iQmLslf2/ISnB/yGk5dsZBB8BWJDQiaI
         YAFzto4WxQ5Q1J6hCx18NMnvAXTPHjLL/KtiTvs2KHUKXk7xbKCNJcVsWbiMH4qvWJ
         z0e+WnPBOKbvfkvj0siTILeXMqge5ofo3Zy8JVV5IdRreuu4Mydeh0MD6RpZ7W/JJD
         8jig1PVQ9n89frXKKeTJ/cwHgFe/2vAWYa0pT0Unbtk9LlyAF0CBts49Hy7jv1N3qX
         xUFrKyxZvZq2LE2GNs2RbogL7pOgGYTe/9pplivPXb1Ny0EDoTFHahYp0LviunilG/
         jVbhCYJ3jT7Dg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 20 Dec 2022 12:23:24 +0300 (MSK)
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
Thread-Index: AQHZEk+jG/1mxrs/wUyXm0IW7LxCR651KceAgAEEOACAABZ8gIAADYMA
Date:   Tue, 20 Dec 2022 09:23:17 +0000
Message-ID: <741d7969-0c39-1e09-7297-84edbc8fddc7@sberdevices.ru>
References: <39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru>
 <CAGxU2F4ca5pxW3RX4wzsTx3KRBtxLK_rO9KxPgUtqcaSNsqXCA@mail.gmail.com>
 <2bc5a0c0-5fb7-9d0e-bd45-879e42c1ea50@sberdevices.ru>
 <20221220083313.mj2fd4tvfoifayaq@sgarzare-redhat>
In-Reply-To: <20221220083313.mj2fd4tvfoifayaq@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EAE404A9A96C041A0D5E9EF2A9D36CE@sberdevices.ru>
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

T24gMjAuMTIuMjAyMiAxMTozMywgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBUdWUs
IERlYyAyMCwgMjAyMiBhdCAwNzoxNDoyN0FNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBPbiAxOS4xMi4yMDIyIDE4OjQxLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6DQo+Pg0K
Pj4gSGVsbG8hDQo+Pg0KPj4+IEhpIEFyc2VuaXksDQo+Pj4NCj4+PiBPbiBTYXQsIERlYyAxNywg
MjAyMiBhdCA4OjQyIFBNIEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1
PiB3cm90ZToNCj4+Pj4NCj4+Pj4gSGVsbG8sDQo+Pj4+DQo+Pj4+IHNlZW1zIEkgZm91bmQgc3Ry
YW5nZSB0aGluZyhtYXkgYmUgYSBidWcpIHdoZXJlIHNlbmRlcigndHgnIGxhdGVyKSBhbmQNCj4+
Pj4gcmVjZWl2ZXIoJ3J4JyBsYXRlcikgY291bGQgc3R1Y2sgZm9yZXZlci4gUG90ZW50aWFsIGZp
eCBpcyBpbiB0aGUgZmlyc3QNCj4+Pj4gcGF0Y2gsIHNlY29uZCBwYXRjaCBjb250YWlucyByZXBy
b2R1Y2VyLCBiYXNlZCBvbiB2c29jayB0ZXN0IHN1aXRlLg0KPj4+PiBSZXByb2R1Y2VyIGlzIHNp
bXBsZTogdHgganVzdCBzZW5kcyBkYXRhIHRvIHJ4IGJ5ICd3cml0ZSgpIHN5c2NhbGwsIHJ4DQo+
Pj4+IGRlcXVldWVzIGl0IHVzaW5nICdyZWFkKCknIHN5c2NhbGwgYW5kIHVzZXMgJ3BvbGwoKScg
Zm9yIHdhaXRpbmcuIEkgcnVuDQo+Pj4+IHNlcnZlciBpbiBob3N0IGFuZCBjbGllbnQgaW4gZ3Vl
c3QuDQo+Pj4+DQo+Pj4+IHJ4IHNpZGUgcGFyYW1zOg0KPj4+PiAxKSBTT19WTV9TT0NLRVRTX0JV
RkZFUl9TSVpFIGlzIDI1NktiKGUuZy4gZGVmYXVsdCkuDQo+Pj4+IDIpIFNPX1JDVkxPV0FUIGlz
IDEyOEtiLg0KPj4+Pg0KPj4+PiBXaGF0IGhhcHBlbnMgaW4gdGhlIHJlcHJvZHVjZXIgc3RlcCBi
eSBzdGVwOg0KPj4+Pg0KPj4+DQo+Pj4gSSBwdXQgdGhlIHZhbHVlcyBvZiB0aGUgdmFyaWFibGVz
IGludm9sdmVkIHRvIGZhY2lsaXRhdGUgdW5kZXJzdGFuZGluZzoNCj4+Pg0KPj4+IFJYOiBidWZf
YWxsb2MgPSAyNTYgS0I7IGZ3ZF9jbnQgPSAwOyBsYXN0X2Z3ZF9jbnQgPSAwOw0KPj4+IMKgwqDC
oCBmcmVlX3NwYWNlID0gYnVmX2FsbG9jIC0gKGZ3ZF9jbnQgLSBsYXN0X2Z3ZF9jbnQpID0gMjU2
IEtCDQo+Pj4NCj4+PiBUaGUgY3JlZGl0IHVwZGF0ZSBpcyBzZW50IGlmDQo+Pj4gZnJlZV9zcGFj
ZSA8IFZJUlRJT19WU09DS19NQVhfUEtUX0JVRl9TSVpFIFs2NCBLQl0NCj4+Pg0KPj4+PiAxKSB0
eCB0cmllcyB0byBzZW5kIDI1NktiICsgMSBieXRlIChpbiBhIHNpbmdsZSAnd3JpdGUoKScpDQo+
Pj4+IDIpIHR4IHNlbmRzIDI1NktiLCBkYXRhIHJlYWNoZXMgcnggKHJ4X2J5dGVzID09IDI1Nkti
KQ0KPj4+PiAzKSB0eCB3YWl0cyBmb3Igc3BhY2UgaW4gJ3dyaXRlKCknIHRvIHNlbmQgbGFzdCAx
IGJ5dGUNCj4+Pj4gNCkgcnggZG9lcyBwb2xsKCksIChyeF9ieXRlcyA+PSByY3Zsb3dhdCkgMjU2
S2IgPj0gMTI4S2IsIFBPTExJTiBpcyBzZXQNCj4+Pj4gNSkgcnggcmVhZHMgNjRLYiwgY3JlZGl0
IHVwZGF0ZSBpcyBub3Qgc2VudCBkdWUgdG8gKg0KPj4+DQo+Pj4gUlg6IGJ1Zl9hbGxvYyA9IDI1
NiBLQjsgZndkX2NudCA9IDY0IEtCOyBsYXN0X2Z3ZF9jbnQgPSAwOw0KPj4+IMKgwqDCoCBmcmVl
X3NwYWNlID0gMTkyIEtCDQo+Pj4NCj4+Pj4gNikgcnggZG9lcyBwb2xsKCksIChyeF9ieXRlcyA+
PSByY3Zsb3dhdCkgMTkyS2IgPj0gMTI4S2IsIFBPTExJTiBpcyBzZXQNCj4+Pj4gNykgcnggcmVh
ZHMgNjRLYiwgY3JlZGl0IHVwZGF0ZSBpcyBub3Qgc2VudCBkdWUgdG8gKg0KPj4+DQo+Pj4gUlg6
IGJ1Zl9hbGxvYyA9IDI1NiBLQjsgZndkX2NudCA9IDEyOCBLQjsgbGFzdF9md2RfY250ID0gMDsN
Cj4+PiDCoMKgwqAgZnJlZV9zcGFjZSA9IDEyOCBLQg0KPj4+DQo+Pj4+IDgpIHJ4IGRvZXMgcG9s
bCgpLCAocnhfYnl0ZXMgPj0gcmN2bG93YXQpIDEyOEtiID49IDEyOEtiLCBQT0xMSU4gaXMgc2V0
DQo+Pj4+IDkpIHJ4IHJlYWRzIDY0S2IsIGNyZWRpdCB1cGRhdGUgaXMgbm90IHNlbnQgZHVlIHRv
ICoNCj4+Pg0KPj4+IFJpZ2h0LCAoZnJlZV9zcGFjZSA8IFZJUlRJT19WU09DS19NQVhfUEtUX0JV
Rl9TSVpFKSBpcyBzdGlsbCBmYWxzZS4NCj4+Pg0KPj4+IFJYOiBidWZfYWxsb2MgPSAyNTYgS0I7
IGZ3ZF9jbnQgPSAxOTYgS0I7IGxhc3RfZndkX2NudCA9IDA7DQo+Pj4gwqDCoMKgIGZyZWVfc3Bh
Y2UgPSA2NCBLQg0KPj4+DQo+Pj4+IDEwKSByeCBkb2VzIHBvbGwoKSwgKHJ4X2J5dGVzIDwgcmN2
bG93YXQpIDY0S2IgPCAxMjhLYiwgcnggd2FpdHMgaW4gcG9sbCgpDQo+Pj4NCj4+PiBJIGFncmVl
IHRoYXQgdGhlIFRYIGlzIHN0dWNrIGJlY2F1c2Ugd2UgYXJlIG5vdCBzZW5kaW5nIHRoZSBjcmVk
aXQNCj4+PiB1cGRhdGUsIGJ1dCBhbHNvIGlmIFJYIHNlbmRzIHRoZSBjcmVkaXQgdXBkYXRlIGF0
IHN0ZXAgOSwgUlggd29uJ3QgYmUNCj4+PiB3b2tlbiB1cCBhdCBzdGVwIDEwLCByaWdodD8NCj4+
DQo+PiBZZXMsIFJYIHdpbGwgc2xlZXAsIGJ1dCBUWCB3aWxsIHdha2UgdXAgYW5kIGFzIHdlIGlu
Zm9ybSBUWCBob3cgbXVjaA0KPj4gZnJlZSBzcGFjZSB3ZSBoYXZlLCBub3cgdGhlcmUgYXJlIHR3
byBjYXNlcyBmb3IgVFg6DQo+PiAxKSBzZW5kICJzbWFsbCIgcmVzdCBvZiBkYXRhKGUuZy4gd2l0
aG91dCBibG9ja2luZyBhZ2FpbiksIGxlYXZlICd3cml0ZSgpJw0KPj4gwqAgYW5kIGNvbnRpbnVl
IGV4ZWN1dGlvbi4gUlggc3RpbGwgd2FpdHMgaW4gJ3BvbGwoKScuIExhdGVyIFRYIHdpbGwNCj4+
IMKgIHNlbmQgZW5vdWdoIGRhdGEgdG8gd2FrZSB1cCBSWC4NCj4+IDIpIHNlbmQgImJpZyIgcmVz
dCBvZiBkYXRhIC0gaWYgcmVzdCBpcyB0b28gYmlnIHRvIGxlYXZlICd3cml0ZSgpJyBhbmQgVFgN
Cj4+IMKgIHdpbGwgd2FpdCBhZ2FpbiBmb3IgdGhlIGZyZWUgc3BhY2UgLSBpdCB3aWxsIGJlIGFi
bGUgdG8gc2VuZCBlbm91Z2ggZGF0YQ0KPj4gwqAgdG8gd2FrZSB1cCBSWCBhcyB3ZSBjb21wYXJl
ZCAncnhfYnl0ZXMnIHdpdGggcmN2bG93YXQgdmFsdWUgaW4gUlguDQo+IA0KPiBSaWdodCwgc28g
SSdkIHVwZGF0ZSB0aGUgdGVzdCB0byBiZWhhdmUgbGlrZSB0aGlzLg0KU29ycnksIFlvdSBtZWFu
IHZzb2NrX3Rlc3Q/IFRvIGNvdmVyIFRYIHdhaXRpbmcgZm9yIGZyZWUgc3BhY2UgYXQgUlgsIHRo
dXMgY2hlY2tpbmcNCnRoaXMga2VybmVsIHBhdGNoIGxvZ2ljPw0KPiBBbmQgSSdkIGV4cGxhaW4g
YmV0dGVyIHRoZSBwcm9ibGVtIHdlIGFyZSBnb2luZyB0byBmaXggaW4gdGhlIGNvbW1pdCBtZXNz
YWdlLg0KT2sNCj4gDQo+Pj4NCj4+Pj4NCj4+Pj4gKiBpcyBvcHRpbWl6YXRpb24gaW4gJ3ZpcnRp
b190cmFuc3BvcnRfc3RyZWFtX2RvX2RlcXVldWUoKScgd2hpY2gNCj4+Pj4gwqAgc2VuZHMgT1Bf
Q1JFRElUX1VQREFURSBvbmx5IHdoZW4gd2UgaGF2ZSBub3QgdG9vIG11Y2ggc3BhY2UgLQ0KPj4+
PiDCoCBsZXNzIHRoYW4gVklSVElPX1ZTT0NLX01BWF9QS1RfQlVGX1NJWkUuDQo+Pj4+DQo+Pj4+
IE5vdyB0eCBzaWRlIHdhaXRzIGZvciBzcGFjZSBpbnNpZGUgd3JpdGUoKSBhbmQgcnggd2FpdHMg
aW4gcG9sbCgpIGZvcg0KPj4+PiAncnhfYnl0ZXMnIHRvIHJlYWNoIFNPX1JDVkxPV0FUIHZhbHVl
LiBCb3RoIHNpZGVzIHdpbGwgd2FpdCBmb3JldmVyLiBJDQo+Pj4+IHRoaW5rLCBwb3NzaWJsZSBm
aXggaXMgdG8gc2VuZCBjcmVkaXQgdXBkYXRlIG5vdCBvbmx5IHdoZW4gd2UgaGF2ZSB0b28NCj4+
Pj4gc21hbGwgc3BhY2UsIGJ1dCBhbHNvIHdoZW4gbnVtYmVyIG9mIGJ5dGVzIGluIHJlY2VpdmUg
cXVldWUgaXMgc21hbGxlcg0KPj4+PiB0aGFuIFNPX1JDVkxPV0FUIHRodXMgbm90IGVub3VnaCB0
byB3YWtlIHVwIHNsZWVwaW5nIHJlYWRlci4gSSdtIG5vdA0KPj4+PiBzdXJlIGFib3V0IGNvcnJl
Y3RuZXNzIG9mIHRoaXMgaWRlYSwgYnV0IGFueXdheSAtIEkgdGhpbmsgdGhhdCBwcm9ibGVtDQo+
Pj4+IGFib3ZlIGV4aXN0cy4gV2hhdCBkbyBZb3UgdGhpbms/DQo+Pj4NCj4+PiBJJ20gbm90IHN1
cmUsIEkgaGF2ZSB0byB0aGluayBtb3JlIGFib3V0IGl0LCBidXQgaWYgUlggcmVhZHMgbGVzcyB0
aGFuDQo+Pj4gU09fUkNWTE9XQVQsIEkgZXhwZWN0IGl0J3Mgbm9ybWFsIHRvIGdldCB0byBhIGNh
c2Ugb2Ygc3R1Y2suDQo+Pj4NCj4+PiBJbiB0aGlzIGNhc2Ugd2UgYXJlIG9ubHkgdW5zdHVja2lu
ZyBUWCwgYnV0IGV2ZW4gaWYgaXQgc2VuZHMgdGhhdCBzaW5nbGUNCj4+PiBieXRlLCBSWCBpcyBz
dGlsbCBzdHVjayBhbmQgbm90IGNvbnN1bWluZyBpdCwgc28gaXQgd2FzIHVzZWxlc3MgdG8gd2Fr
ZQ0KPj4+IHVwIFRYIGlmIFJYIHdvbid0IGNvbnN1bWUgaXQgYW55d2F5LCByaWdodD8NCj4+DQo+
PiAxKSBJIHRoaW5rIGl0IGlzIG5vdCB1c2VsZXNzLCBiZWNhdXNlIHdlIGluZm9ybShub3QganVz
dCB3YWtlIHVwKSBUWCB0aGF0DQo+PiB0aGVyZSBpcyBmcmVlIHNwYWNlIGF0IFJYIHNpZGUgLSBh
cyBpIG1lbnRpb25lZCBhYm92ZS4NCj4+IDIpIEFueXdheSBpIHRoaW5rIHRoYXQgdGhpcyBzaXR1
YXRpb24gaXMgYSBsaXR0bGUgYml0IHN0cmFuZ2U6IFRYIHRoaW5rcyB0aGF0DQo+PiB0aGVyZSBp
cyBubyBmcmVlIHNwYWNlIGF0IFJYIGFuZCB3YWl0cyBmb3IgaXQsIGJ1dCB0aGVyZSBpcyBmcmVl
IHNwYWNlIGF0IFJYIQ0KPj4gQXQgdGhlIHNhbWUgdGltZSwgUlggd2FpdHMgaW4gcG9sbCgpIGZv
cmV2ZXIgLSBpdCBpcyByZWFkeSB0byBnZXQgbmV3IHBvcnRpb24NCj4+IG9mIGRhdGEgdG8gcmV0
dXJuIFBPTExJTiwgYnV0IFRYICJ0aGlua3MiIGV4YWN0bHkgb3Bwb3NpdGUgdGhpbmcgLSBSWCBp
cyBmdWxsDQo+PiBvZiBkYXRhLiBPZiBjb3Vyc2UsIGlmIHRoZXJlIHdpbGwgYmUganVzdCBzdGFs
bHMgaW4gVFggZGF0YSBoYW5kbGluZyAtIGl0IHdpbGwNCj4+IGJlIG9rIC0ganVzdCBwZXJmb3Jt
YW5jZSBkZWdyYWRhdGlvbiwgYnV0IFRYIHN0dWNrcyBmb3JldmVyLg0KPiANCj4gV2UgZGlkIGl0
IHRvIGF2b2lkIGEgbG90IG9mIGNyZWRpdCB1cGRhdGUgbWVzc2FnZXMuDQpZZXMsIGkgc2VlDQo+
IEFueXdheSBJIHRoaW5rIGhlcmUgdGhlIG1haW4gcG9pbnQgaXMgd2h5IFJYIGlzIHNldHRpbmcg
U09fUkNWTE9XQVQgdG8gMTI4IEtCIGFuZCB0aGVuIHJlYWRzIG9ubHkgaGFsZiBvZiBpdD8NCj4g
DQo+IFNvIEkgdGhpbmsgaWYgdGhlIHVzZXJzIHNldCBTT19SQ1ZMT1dBVCB0byBhIHZhbHVlIGFu
ZCB0aGVuIFJYIHJlYWRzIGxlc3MgdGhlbiBpdCwgaXMgZXhwZWN0ZWQgdG8gZ2V0IHN0dWNrLg0K
VGhhdCBhIHJlYWxseSBpbnRlcmVzdGluZyBxdWVzdGlvbiwgSSd2ZSBmb3VuZCBub3RoaW5nIGFi
b3V0IHRoaXMgY2FzZSBpbiBHb29nbGUobm90IHN1cmUgZm9yIDEwMCUpIG9yIFBPU0lYLiBCdXQs
DQppIGNhbiBtb2RpZnkgcmVwcm9kdWNlcjogaXQgc2V0cyBTT19SQ1ZMT1dBVCB0byAxMjhLYiBC
RUZPUkUgZW50ZXJpbmcgaXRzIGxhc3QgcG9sbCB3aGVyZSBpdCB3aWxsIHN0dWNrLiBJbiB0aGlz
DQpjYXNlIGJlaGF2aW91ciBsb29rcyBtb3JlIGxlZ2FsOiBpdCB1c2VzIGRlZmF1bHQgU09fUkNW
TE9XQVQgb2YgMSwgcmVhZCA2NEtiIGVhY2ggdGltZS4gRmluYWxseSBpdCBzZXRzIFNPX1JDVkxP
V0FUDQp0byAxMjhLYihhbmQgaW1hZ2luZSB0aGF0IGl0IHByZXBhcmVzIDEyOEtiICdyZWFkKCkn
IGJ1ZmZlcikgYW5kIGVudGVycyBwb2xsKCkgLSB3ZSB3aWxsIGdldCBzYW1lIGVmZmVjdDogVFgg
d2lsbCB3YWl0DQpmb3Igc3BhY2UsIFJYIHdhaXRzIGluICdwb2xsKCknLg0KPiANCj4gQW55d2F5
LCBzaW5jZSB0aGUgY2hhbmdlIHdpbGwgbm90IGltcGFjdCB0aGUgZGVmYXVsdCBiZWhhdmlvdXIg
KFNPX1JDVkxPV0FUID0gMSkgd2UgY2FuIG1lcmdlIHRoaXMgcGF0Y2gsIGJ1dCBJTUhPIHdlIG5l
ZWQgdG8gZXhwbGFpbiB0aGUgY2FzZSBiZXR0ZXIgYW5kIGltcHJvdmUgdGhlIHRlc3QuDQpJIHNl
ZSwgb2YgY291cnNlIEknbSBub3Qgc3VyZSBhYm91dCB0aGlzIGNoYW5nZSwganVzdCB3YW50IHRv
IGFzayBzb21lb25lIHdobyBrbm93cyB0aGlzIGNvZGUgYmV0dGVyDQo+IA0KPj4NCj4+Pg0KPj4+
IElmIFJYIHdva2UgdXAgKGUuZy4gU09fUkNWTE9XQVQgPSA2NEtCKSBhbmQgcmVhZCB0aGUgcmVt
YWluaW5nIDY0S0IsDQo+Pj4gdGhlbiBpdCB3b3VsZCBzdGlsbCBzZW5kIHRoZSBjcmVkaXQgdXBk
YXRlIGV2ZW4gd2l0aG91dCB0aGlzIHBhdGNoIGFuZA0KPj4+IFRYIHdpbGwgc2VuZCB0aGUgMSBi
eXRlLg0KPj4NCj4+IEJ1dCBob3cgUlggd2lsbCB3YWtlIHVwIGluIHRoaXMgY2FzZT8gRS5nLiBp
dCBjYWxscyBwb2xsKCkgd2l0aG91dCB0aW1lb3V0LA0KPj4gY29ubmVjdGlvbiBpcyBlc3RhYmxp
c2hlZCwgUlggaWdub3JlcyBzaWduYWwNCj4gDQo+IFJYIHdpbGwgd2FrZSB1cCBiZWNhdXNlIFNP
X1JDVkxPV0FUIGlzIDY0S0IgYW5kIHRoZXJlIGFyZSA2NCBLQiBpbiB0aGUgYnVmZmVyLiBUaGVu
IFJYIHdpbGwgcmVhZCBpdCBhbmQgc2VuZCB0aGUgY3JlZGl0IHVwZGF0ZSB0byBUWCBiZWNhdXNl
DQo+IGZyZWVfc3BhY2UgaXMgMC4NCklJVUMsIGknbSB0YWxraW5nIGFib3V0IDEwIHN0ZXBzIGFi
b3ZlLCBlLmcuIFJYIHdpbGwgbmV2ZXIgd2FrZSB1cCwgYmVjYXVzZSBUWCBpcyB3YWl0aW5nIGZv
ciBzcGFjZS4NCj4gDQo+IFRoYW5rcywNCj4gU3RlZmFubw0KPiANClRoYW5rcywgQXJzZW5peQ0K
DQo=
