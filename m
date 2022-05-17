Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A669529FD3
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 12:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343858AbiEQK5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 06:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344572AbiEQK5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 06:57:00 -0400
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id BA67A483AA;
        Tue, 17 May 2022 03:56:54 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Tue, 17 May 2022 18:56:31
 +0800 (GMT+08:00)
X-Originating-IP: [124.236.130.193]
Date:   Tue, 17 May 2022 18:56:31 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        broonie@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] NFC: hci: fix sleep in atomic context bugs in
 nfc_hci_hcp_message_tx
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <ea2af2f9-002a-5681-4293-a05718ce9dcd@linaro.org>
References: <20220516021028.54063-1-duoming@zju.edu.cn>
 <d5fdfe27-a6de-3030-ce51-9f4f45d552f3@linaro.org>
 <6aba1413.196eb.180cc609bf1.Coremail.duoming@zju.edu.cn>
 <ea2af2f9-002a-5681-4293-a05718ce9dcd@linaro.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <fc6a78c.196ab.180d1a98cc9.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgDHnyJff4NiljNaAA--.8491W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAggNAVZdtZu2IgADs0
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBNb24sIDE2IE1heSAyMDIyIDEyOjQzOjA3ICswMjAwIEtyenlzenRvZiB3cm90
ZToKCj4gPj4+IFRoZXJlIGFyZSBzbGVlcCBpbiBhdG9taWMgY29udGV4dCBidWdzIHdoZW4gdGhl
IHJlcXVlc3QgdG8gc2VjdXJlCj4gPj4+IGVsZW1lbnQgb2Ygc3QyMW5mY2EgaXMgdGltZW91dC4g
VGhlIHJvb3QgY2F1c2UgaXMgdGhhdCBremFsbG9jIGFuZAo+ID4+PiBhbGxvY19za2Igd2l0aCBH
RlBfS0VSTkVMIHBhcmFtZXRlciBpcyBjYWxsZWQgaW4gc3QyMW5mY2Ffc2Vfd3RfdGltZW91dAo+
ID4+PiB3aGljaCBpcyBhIHRpbWVyIGhhbmRsZXIuIFRoZSBjYWxsIHRyZWUgc2hvd3MgdGhlIGV4
ZWN1dGlvbiBwYXRocyB0aGF0Cj4gPj4+IGNvdWxkIGxlYWQgdG8gYnVnczoKPiA+Pj4KPiA+Pj4g
ICAgKEludGVycnVwdCBjb250ZXh0KQo+ID4+PiBzdDIxbmZjYV9zZV93dF90aW1lb3V0Cj4gPj4+
ICAgbmZjX2hjaV9zZW5kX2V2ZW50Cj4gPj4+ICAgICBuZmNfaGNpX2hjcF9tZXNzYWdlX3R4Cj4g
Pj4+ICAgICAgIGt6YWxsb2MoLi4uLCBHRlBfS0VSTkVMKSAvL21heSBzbGVlcAo+ID4+PiAgICAg
ICBhbGxvY19za2IoLi4uLCBHRlBfS0VSTkVMKSAvL21heSBzbGVlcAo+ID4+Pgo+ID4+PiBUaGlz
IHBhdGNoIGNoYW5nZXMgYWxsb2NhdGlvbiBtb2RlIG9mIGt6YWxsb2MgYW5kIGFsbG9jX3NrYiBm
cm9tCj4gPj4+IEdGUF9LRVJORUwgdG8gR0ZQX0FUT01JQyBpbiBvcmRlciB0byBwcmV2ZW50IGF0
b21pYyBjb250ZXh0IGZyb20KPiA+Pj4gc2xlZXBpbmcuIFRoZSBHRlBfQVRPTUlDIGZsYWcgbWFr
ZXMgbWVtb3J5IGFsbG9jYXRpb24gb3BlcmF0aW9uCj4gPj4+IGNvdWxkIGJlIHVzZWQgaW4gYXRv
bWljIGNvbnRleHQuCj4gPj4+Cj4gPj4+IEZpeGVzOiA4YjhkMmUwOGJmMGQgKCJORkM6IEhDSSBz
dXBwb3J0IikKPiA+Pj4gU2lnbmVkLW9mZi1ieTogRHVvbWluZyBaaG91IDxkdW9taW5nQHpqdS5l
ZHUuY24+Cj4gPj4+IC0tLQo+ID4+PiAgbmV0L25mYy9oY2kvaGNwLmMgfCA0ICsrLS0KPiA+Pj4g
IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4gPj4+Cj4g
Pj4+IGRpZmYgLS1naXQgYS9uZXQvbmZjL2hjaS9oY3AuYyBiL25ldC9uZmMvaGNpL2hjcC5jCj4g
Pj4+IGluZGV4IDA1YzYwOTg4ZjU5Li4xY2FmOWMyMDg2ZiAxMDA2NDQKPiA+Pj4gLS0tIGEvbmV0
L25mYy9oY2kvaGNwLmMKPiA+Pj4gKysrIGIvbmV0L25mYy9oY2kvaGNwLmMKPiA+Pj4gQEAgLTMw
LDcgKzMwLDcgQEAgaW50IG5mY19oY2lfaGNwX21lc3NhZ2VfdHgoc3RydWN0IG5mY19oY2lfZGV2
ICpoZGV2LCB1OCBwaXBlLAo+ID4+PiAgCWludCBoY2lfbGVuLCBlcnI7Cj4gPj4+ICAJYm9vbCBm
aXJzdGZyYWcgPSB0cnVlOwo+ID4+PiAgCj4gPj4+IC0JY21kID0ga3phbGxvYyhzaXplb2Yoc3Ry
dWN0IGhjaV9tc2cpLCBHRlBfS0VSTkVMKTsKPiA+Pj4gKwljbWQgPSBremFsbG9jKHNpemVvZigq
Y21kKSwgR0ZQX0FUT01JQyk7Cj4gPj4KPiA+PiBObywgdGhpcyBkb2VzIG5vdCBsb29rIGNvcnJl
Y3QuIFRoaXMgZnVuY3Rpb24gY2FuIHNsZWVwLCBzbyBpdCBjYW4gdXNlCj4gPj4gR0ZQX0tFUk5F
TC4gUGxlYXNlIGp1c3QgbG9vayBhdCB0aGUgZnVuY3Rpb24gYmVmb3JlIHJlcGxhY2luZyBhbnkg
ZmxhZ3MuLi4KPiA+IAo+ID4gSSBhbSBzb3JyeSwgSSBkb25gdCB1bmRlcnN0YW5kIHdoeSBuZmNf
aGNpX2hjcF9tZXNzYWdlX3R4KCkgY2FuIHNsZWVwLgo+IAo+IFdoeT8gYmVjYXVzZSBpbiBsaW5l
IDkzIGl0IHVzZXMgYSBtdXRleCAod2hpY2ggaXMgYSBzbGVlcGluZyBwcmltaXR2ZSkuCj4gCj4g
PiAKPiA+IEkgdGhpbmsgc3QyMW5mY2Ffc2Vfd3RfdGltZW91dCgpIGlzIGEgdGltZXIgaGFuZGxl
ciwgd2hpY2ggaXMgaW4gaW50ZXJydXB0IGNvbnRleHQuCj4gPiBUaGUgY2FsbCB0cmVlIHNob3dz
IHRoZSBleGVjdXRpb24gcGF0aHMgdGhhdCBjb3VsZCBsZWFkIHRvIGJ1Z3M6Cj4gPiAKPiA+IHN0
MjFuZmNhX2hjaV9zZV9pbygpCj4gPiAgIG1vZF90aW1lcigmaW5mby0+c2VfaW5mby5id2lfdGlt
ZXIsLi4uKQo+ID4gICAgIHN0MjFuZmNhX3NlX3d0X3RpbWVvdXQoKSAgLy90aW1lciBoYW5kbGVy
LCBpbnRlcnJ1cHQgY29udGV4dAo+ID4gICAgICAgbmZjX2hjaV9zZW5kX2V2ZW50KCkKPiA+ICAg
ICAgICAgbmZjX2hjaV9oY3BfbWVzc2FnZV90eCgpCj4gPiAgICAgICAgICAga3phbGxvYyguLi4s
IEdGUF9LRVJORUwpIC8vbWF5IHNsZWVwCj4gPiAgICAgICAgICAgYWxsb2Nfc2tiKC4uLiwgR0ZQ
X0tFUk5FTCkgLy9tYXkgc2xlZXAKPiA+IAo+ID4gV2hhdGBzIG1vcmUsIEkgdGhpbmsgdGhlICJt
dXRleF9sb2NrKCZoZGV2LT5tc2dfdHhfbXV0ZXgpIiBjYWxsZWQgYnkgbmZjX2hjaV9oY3BfbWVz
c2FnZV90eCgpCj4gPiBpcyBhbHNvIGltcHJvcGVyLgo+ID4gCj4gPiBQbGVhc2UgY29ycmVjdCBt
ZSwgSWYgeW91IHRoaW5rIEkgYW0gd3JvbmcuIFRoYW5rcyBmb3IgeW91ciB0aW1lLgo+IAo+IFlv
dXIgcGF0Y2ggaXMgbm90IGNvcnJlY3QgaW4gY3VycmVudCBzZW1hbnRpY3Mgb2YgdGhpcyBmdW5j
dGlvbi4gVGhpcwo+IGZ1bmN0aW9uIGNhbiBzbGVlcCAoYmVjYXVzZSBpdCB1c2VzIGEgbXV0ZXgp
LCBzbyB0aGUgbWlzdGFrZSBpcyByYXRoZXIKPiBjYWxsaW5nIGl0IGZyb20gaW50ZXJydXB0IGNv
bnRleHQuCgpXZSBoYXZlIHRvIGNhbGwgbmZjX2hjaV9zZW5kX2V2ZW50KCkgaW4gc3QyMW5mY2Ff
c2Vfd3RfdGltZW91dCgpLCBiZWNhdXNlIHdlIG5lZWQgdG8gc2VuZCAKYSByZXNldCByZXF1ZXN0
IGFzIHJlY292ZXJ5IHByb2NlZHVyZS4gSSB0aGluayByZXBsYWNlIEdGUF9LRVJORUwgdG8gR0ZQ
X0FUT01JQyBhbmQgcmVwbGFjZQptdXRleF9sb2NrIHRvIHNwaW5fbG9jayBpbiBuZmNfaGNpX2hj
cF9tZXNzYWdlX3R4KCkgaXMgYmV0dGVyLgoKV2hhdCdzIG1vcmUsIGluIG9yZGVyIHRvIHN5bmNo
cm9uaXplIHdpdGggb3RoZXIgZnVuY3Rpb25zIHJlbGF0ZWQgd2l0aCBoY2kgbWVzc2FnZSBUWCwg
CldlIG5lZWQgdG8gcmVwbGFjZSB0aGUgbXV0ZXhfbG9jaygmaGRldi0+bXNnX3R4X211dGV4KSB0
byBzcGluX2xvY2sgaW4gb3RoZXIgZnVuY3Rpb25zCmFzIHdlbGwuIEkgc2VudCAicGF0Y2ggdjIi
IGp1c3Qgbm93LgoKQmVzdCByZWdhcmRzLApEdW9taW5nIFpob3UK
