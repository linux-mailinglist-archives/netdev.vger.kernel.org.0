Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF45B64FC1F
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 20:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiLQTmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 14:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLQTmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 14:42:14 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090DFE08A;
        Sat, 17 Dec 2022 11:42:11 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 949035FD03;
        Sat, 17 Dec 2022 22:42:08 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1671306128;
        bh=MglaPv/ZJAQYTBRWx0CWkDk0JuAmC526ZvJW04XE1lM=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=JhvYuHbFPy55vMW5EU76Z1K6K4ZCJ+8sv8ciNgVIg8pEeCJq2uLv68QCc45cUa8cy
         5zxFBjPhigL2CdhB6SSwmgA+mhCJ04fbCdcQKWZYM25Y6F53WT2R8cgR94Udg4ckJX
         LB0mK3g/Q+TRmsPmP7LYBtF60q3BDLvkcNe9TULQjxif1n0uHuCVXhwLlKZ1eDhyH0
         tPrly3AsoCOHZxlPsHxLwSgLVfgShl8uq3FBeLuuSjugf9sj9cOjlwZDBTmd4K0jSX
         KL2t3ZSXvkvxqJ6EDHHDt18ZZ18oDFyu+0uGPpnQgeV0gC09DWsREaFq/7lJaHN1oM
         C9WQG/15XdT7Q==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat, 17 Dec 2022 22:42:04 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v1 0/2] virtio/vsock: fix mutual rx/tx hungup
Thread-Topic: [RFC PATCH v1 0/2] virtio/vsock: fix mutual rx/tx hungup
Thread-Index: AQHZEk+jG/1mxrs/wUyXm0IW7LxCRw==
Date:   Sat, 17 Dec 2022 19:42:04 +0000
Message-ID: <39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B630B2DE33D4A447A205C54F3C3BD444@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/17 15:49:00 #20678428
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCnNlZW1zIEkgZm91bmQgc3RyYW5nZSB0aGluZyhtYXkgYmUgYSBidWcpIHdoZXJl
IHNlbmRlcigndHgnIGxhdGVyKSBhbmQNCnJlY2VpdmVyKCdyeCcgbGF0ZXIpIGNvdWxkIHN0dWNr
IGZvcmV2ZXIuIFBvdGVudGlhbCBmaXggaXMgaW4gdGhlIGZpcnN0DQpwYXRjaCwgc2Vjb25kIHBh
dGNoIGNvbnRhaW5zIHJlcHJvZHVjZXIsIGJhc2VkIG9uIHZzb2NrIHRlc3Qgc3VpdGUuDQpSZXBy
b2R1Y2VyIGlzIHNpbXBsZTogdHgganVzdCBzZW5kcyBkYXRhIHRvIHJ4IGJ5ICd3cml0ZSgpIHN5
c2NhbGwsIHJ4DQpkZXF1ZXVlcyBpdCB1c2luZyAncmVhZCgpJyBzeXNjYWxsIGFuZCB1c2VzICdw
b2xsKCknIGZvciB3YWl0aW5nLiBJIHJ1bg0Kc2VydmVyIGluIGhvc3QgYW5kIGNsaWVudCBpbiBn
dWVzdC4NCg0Kcnggc2lkZSBwYXJhbXM6DQoxKSBTT19WTV9TT0NLRVRTX0JVRkZFUl9TSVpFIGlz
IDI1NktiKGUuZy4gZGVmYXVsdCkuDQoyKSBTT19SQ1ZMT1dBVCBpcyAxMjhLYi4NCg0KV2hhdCBo
YXBwZW5zIGluIHRoZSByZXByb2R1Y2VyIHN0ZXAgYnkgc3RlcDoNCg0KMSkgdHggdHJpZXMgdG8g
c2VuZCAyNTZLYiArIDEgYnl0ZSAoaW4gYSBzaW5nbGUgJ3dyaXRlKCknKQ0KMikgdHggc2VuZHMg
MjU2S2IsIGRhdGEgcmVhY2hlcyByeCAocnhfYnl0ZXMgPT0gMjU2S2IpDQozKSB0eCB3YWl0cyBm
b3Igc3BhY2UgaW4gJ3dyaXRlKCknIHRvIHNlbmQgbGFzdCAxIGJ5dGUNCjQpIHJ4IGRvZXMgcG9s
bCgpLCAocnhfYnl0ZXMgPj0gcmN2bG93YXQpIDI1NktiID49IDEyOEtiLCBQT0xMSU4gaXMgc2V0
DQo1KSByeCByZWFkcyA2NEtiLCBjcmVkaXQgdXBkYXRlIGlzIG5vdCBzZW50IGR1ZSB0byAqDQo2
KSByeCBkb2VzIHBvbGwoKSwgKHJ4X2J5dGVzID49IHJjdmxvd2F0KSAxOTJLYiA+PSAxMjhLYiwg
UE9MTElOIGlzIHNldA0KNykgcnggcmVhZHMgNjRLYiwgY3JlZGl0IHVwZGF0ZSBpcyBub3Qgc2Vu
dCBkdWUgdG8gKg0KOCkgcnggZG9lcyBwb2xsKCksIChyeF9ieXRlcyA+PSByY3Zsb3dhdCkgMTI4
S2IgPj0gMTI4S2IsIFBPTExJTiBpcyBzZXQNCjkpIHJ4IHJlYWRzIDY0S2IsIGNyZWRpdCB1cGRh
dGUgaXMgbm90IHNlbnQgZHVlIHRvICoNCjEwKSByeCBkb2VzIHBvbGwoKSwgKHJ4X2J5dGVzIDwg
cmN2bG93YXQpIDY0S2IgPCAxMjhLYiwgcnggd2FpdHMgaW4gcG9sbCgpDQoNCiogaXMgb3B0aW1p
emF0aW9uIGluICd2aXJ0aW9fdHJhbnNwb3J0X3N0cmVhbV9kb19kZXF1ZXVlKCknIHdoaWNoDQog
IHNlbmRzIE9QX0NSRURJVF9VUERBVEUgb25seSB3aGVuIHdlIGhhdmUgbm90IHRvbyBtdWNoIHNw
YWNlIC0NCiAgbGVzcyB0aGFuIFZJUlRJT19WU09DS19NQVhfUEtUX0JVRl9TSVpFLg0KDQpOb3cg
dHggc2lkZSB3YWl0cyBmb3Igc3BhY2UgaW5zaWRlIHdyaXRlKCkgYW5kIHJ4IHdhaXRzIGluIHBv
bGwoKSBmb3INCidyeF9ieXRlcycgdG8gcmVhY2ggU09fUkNWTE9XQVQgdmFsdWUuIEJvdGggc2lk
ZXMgd2lsbCB3YWl0IGZvcmV2ZXIuIEkNCnRoaW5rLCBwb3NzaWJsZSBmaXggaXMgdG8gc2VuZCBj
cmVkaXQgdXBkYXRlIG5vdCBvbmx5IHdoZW4gd2UgaGF2ZSB0b28NCnNtYWxsIHNwYWNlLCBidXQg
YWxzbyB3aGVuIG51bWJlciBvZiBieXRlcyBpbiByZWNlaXZlIHF1ZXVlIGlzIHNtYWxsZXINCnRo
YW4gU09fUkNWTE9XQVQgdGh1cyBub3QgZW5vdWdoIHRvIHdha2UgdXAgc2xlZXBpbmcgcmVhZGVy
LiBJJ20gbm90DQpzdXJlIGFib3V0IGNvcnJlY3RuZXNzIG9mIHRoaXMgaWRlYSwgYnV0IGFueXdh
eSAtIEkgdGhpbmsgdGhhdCBwcm9ibGVtDQphYm92ZSBleGlzdHMuIFdoYXQgZG8gWW91IHRoaW5r
Pw0KDQpQYXRjaHNldCB3YXMgcmViYXNlZCBhbmQgdGVzdGVkIG9uIHNrYnVmZiB2NyBwYXRjaCBm
cm9tIEJvYmJ5IEVzaGxlbWFuOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzIwMjIx
MjEzMTkyODQzLjQyMTAzMi0xLWJvYmJ5LmVzaGxlbWFuQGJ5dGVkYW5jZS5jb20vDQoNCkFyc2Vu
aXkgS3Jhc25vdigyKToNCiB2aXJ0aW8vdnNvY2s6IHNlbmQgY3JlZGl0IHVwZGF0ZSBkZXBlbmRp
bmcgb24gU09fUkNWTE9XQVQNCiB2c29ja190ZXN0OiBtdXR1YWwgaHVuZ3VwIHJlcHJvZHVjZXIN
Cg0KIG5ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYyB8ICA5ICsrKy0NCiB0
b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyAgICAgICAgfCA3OCArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCiAyIGZpbGVzIGNoYW5nZWQsIDg1IGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pDQotLSANCjIuMjUuMQ0K
