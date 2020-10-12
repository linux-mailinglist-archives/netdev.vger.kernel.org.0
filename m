Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAD628AB68
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 03:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgJLB0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 21:26:54 -0400
Received: from smtp.h3c.com ([60.191.123.56]:31220 "EHLO h3cspam01-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbgJLB0y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 21:26:54 -0400
Received: from DAG2EX06-IDC.srv.huawei-3com.com ([10.8.0.69])
        by h3cspam01-ex.h3c.com with ESMTPS id 09C1Q0W3023693
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 12 Oct 2020 09:26:00 +0800 (GMT-8)
        (envelope-from tian.xianting@h3c.com)
Received: from DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66) by
 DAG2EX06-IDC.srv.huawei-3com.com (10.8.0.69) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 09:26:01 +0800
Received: from DAG2EX03-BASE.srv.huawei-3com.com ([fe80::5d18:e01c:bbbd:c074])
 by DAG2EX03-BASE.srv.huawei-3com.com ([fe80::5d18:e01c:bbbd:c074%7]) with
 mapi id 15.01.1713.004; Mon, 12 Oct 2020 09:26:01 +0800
From:   Tianxianting <tian.xianting@h3c.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] bpf: Avoid allocing memory on memoryless numa node
Thread-Topic: [PATCH] bpf: Avoid allocing memory on memoryless numa node
Thread-Index: AQHWnuLrmIxw4uY1XUG+lUKVObi7NKmSqAmAgACHNeA=
Date:   Mon, 12 Oct 2020 01:26:01 +0000
Message-ID: <21cff6313475470e9b316911c748f890@h3c.com>
References: <20201010084417.5400-1-tian.xianting@h3c.com>
 <CAADnVQJUL7BynGMD_nGu8y=D1yv6TybOxeSh03TrkD7kS0aOrA@mail.gmail.com>
In-Reply-To: <CAADnVQJUL7BynGMD_nGu8y=D1yv6TybOxeSh03TrkD7kS0aOrA@mail.gmail.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.141.128]
x-sender-location: DAG2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-DNSRBL: 
X-MAIL: h3cspam01-ex.h3c.com 09C1Q0W3023693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIEFsZXhlaSBmb3IgeW91ciBzdWdnZXN0aW9uLA0KSSB3aWxsIHRyeSB0byBkbyBpdC4N
Cg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEFsZXhlaSBTdGFyb3ZvaXRvdiBb
bWFpbHRvOmFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb21dIA0KU2VudDogTW9uZGF5LCBPY3Rv
YmVyIDEyLCAyMDIwIDk6MjEgQU0NClRvOiB0aWFueGlhbnRpbmcgKFJEKSA8dGlhbi54aWFudGlu
Z0BoM2MuY29tPg0KQ2M6IEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+OyBEYW5p
ZWwgQm9ya21hbm4gPGRhbmllbEBpb2dlYXJib3gubmV0PjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZl
bUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IEplc3Bl
ciBEYW5nYWFyZCBCcm91ZXIgPGhhd2tAa2VybmVsLm9yZz47IEpvaG4gRmFzdGFiZW5kIDxqb2hu
LmZhc3RhYmVuZEBnbWFpbC5jb20+OyBNYXJ0aW4gS2FGYWkgTGF1IDxrYWZhaUBmYi5jb20+OyBT
b25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPjsgWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNv
bT47IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+OyBLUCBTaW5naCA8a3BzaW5naEBj
aHJvbWl1bS5vcmc+OyBOZXR3b3JrIERldmVsb3BtZW50IDxuZXRkZXZAdmdlci5rZXJuZWwub3Jn
PjsgYnBmIDxicGZAdmdlci5rZXJuZWwub3JnPjsgTEtNTCA8bGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZz4NClN1YmplY3Q6IFJlOiBbUEFUQ0hdIGJwZjogQXZvaWQgYWxsb2NpbmcgbWVtb3J5
IG9uIG1lbW9yeWxlc3MgbnVtYSBub2RlDQoNCk9uIFNhdCwgT2N0IDEwLCAyMDIwIGF0IDE6NTUg
QU0gWGlhbnRpbmcgVGlhbiA8dGlhbi54aWFudGluZ0BoM2MuY29tPiB3cm90ZToNCj4NCj4gSW4g
YXJjaGl0ZWN0dXJlIGxpa2UgcG93ZXJwYywgd2UgY2FuIGhhdmUgY3B1cyB3aXRob3V0IGFueSBs
b2NhbCANCj4gbWVtb3J5IGF0dGFjaGVkIHRvIGl0LiBJbiBzdWNoIGNhc2VzIHRoZSBub2RlIGRv
ZXMgbm90IGhhdmUgcmVhbCBtZW1vcnkuDQo+DQo+IFVzZSBsb2NhbF9tZW1vcnlfbm9kZSgpLCB3
aGljaCBpcyBndWFyYW50ZWVkIHRvIGhhdmUgbWVtb3J5Lg0KPiBsb2NhbF9tZW1vcnlfbm9kZSBp
cyBhIG5vb3AgaW4gb3RoZXIgYXJjaGl0ZWN0dXJlcyB0aGF0IGRvZXMgbm90IA0KPiBzdXBwb3J0
IG1lbW9yeWxlc3Mgbm9kZXMuDQouLi4NCj4gICAgICAgICAvKiBIYXZlIG1hcC0+bnVtYV9ub2Rl
LCBidXQgY2hvb3NlIG5vZGUgb2YgcmVkaXJlY3QgdGFyZ2V0IENQVSAqLw0KPiAtICAgICAgIG51
bWEgPSBjcHVfdG9fbm9kZShjcHUpOw0KPiArICAgICAgIG51bWEgPSBsb2NhbF9tZW1vcnlfbm9k
ZShjcHVfdG9fbm9kZShjcHUpKTsNCg0KVGhlcmUgYXJlIHNvIG1hbnkgY2FsbHMgdG8gY3B1X3Rv
X25vZGUoKSB0aHJvdWdob3V0IHRoZSBrZXJuZWwuDQpBcmUgeW91IGdvaW5nIHRvIGNvbnZlcnQg
YWxsIG9mIHRoZW0gb25lIHBhdGNoIGF0IGEgdGltZSB0byB0aGUgYWJvdmUgc2VxdWVuY2U/DQpX
aHkgbm90IGRvIHRoaXMgQ09ORklHX0hBVkVfTUVNT1JZTEVTU19OT0RFUyBpbiBjcHVfdG9fbm9k
ZSgpIGluc3RlYWQ/DQphbmQgc2F2ZSB0aGUgY2h1cm4uDQo=
