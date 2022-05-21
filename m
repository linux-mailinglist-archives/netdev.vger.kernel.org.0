Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C1352FD10
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 16:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243786AbiEUOAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 10:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243755AbiEUOAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 10:00:23 -0400
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 777633EF1B;
        Sat, 21 May 2022 07:00:19 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Sat, 21 May 2022 21:59:46
 +0800 (GMT+08:00)
X-Originating-IP: [124.236.130.193]
Date:   Sat, 21 May 2022 21:59:46 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Kalle Valo" <kvalo@kernel.org>
Cc:     "Jeff Johnson" <quic_jjohnson@quicinc.com>,
        linux-kernel@vger.kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: wireless: marvell: mwifiex: fix sleep in
 atomic context bugs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <87ilpzwg3e.fsf@kernel.org>
References: <20220519135345.109936-1-duoming@zju.edu.cn>
 <87zgjd1sd4.fsf@kernel.org>
 <699e56d5.22006.180dce26e02.Coremail.duoming@zju.edu.cn>
 <18852332-ee42-ef7e-67a3-bbd91a6694ba@quicinc.com>
 <4e778cb1.22654.180decbcb8e.Coremail.duoming@zju.edu.cn>
 <ec16c0b5-b8c7-3bd1-e733-f054ec3c2cd1@quicinc.com>
 <ed03525.253c1.180e4a21950.Coremail.duoming@zju.edu.cn>
 <87ilpzwg3e.fsf@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4cd03c34.25fad.180e6eac2d7.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgDXQCBS8IhitCeLAA--.13906W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgQRAVZdtZzwSwAAsP
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW3Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBTYXQsIDIxIE1heSAyMDIyIDA5OjMyOjM3ICswMzAwIEthbGxlIFZhbG8gd3Jv
dGU6Cgo+ID4+ID4+Pj4+IFRoZXJlIGFyZSBzbGVlcCBpbiBhdG9taWMgY29udGV4dCBidWdzIHdo
ZW4gdXBsb2FkaW5nIGRldmljZSBkdW1wCj4gPj4gPj4+Pj4gZGF0YSBvbiB1c2IgaW50ZXJmYWNl
LiBUaGUgcm9vdCBjYXVzZSBpcyB0aGF0IHRoZSBvcGVyYXRpb25zIHRoYXQKPiA+PiA+Pj4+PiBt
YXkgc2xlZXAgYXJlIGNhbGxlZCBpbiBmd19kdW1wX3RpbWVyX2ZuIHdoaWNoIGlzIGEgdGltZXIg
aGFuZGxlci4KPiA+PiA+Pj4+PiBUaGUgY2FsbCB0cmVlIHNob3dzIHRoZSBleGVjdXRpb24gcGF0
aHMgdGhhdCBjb3VsZCBsZWFkIHRvIGJ1Z3M6Cj4gPj4gPj4+Pj4KPiA+PiA+Pj4+PiAgICAgIChJ
bnRlcnJ1cHQgY29udGV4dCkKPiA+PiA+Pj4+PiBmd19kdW1wX3RpbWVyX2ZuCj4gPj4gPj4+Pj4g
ICAgIG13aWZpZXhfdXBsb2FkX2RldmljZV9kdW1wCj4gPj4gPj4+Pj4gICAgICAgZGV2X2NvcmVk
dW1wdiguLi4sIEdGUF9LRVJORUwpCj4gPj4gPj4KPiA+PiA+PiBqdXN0IGxvb2tpbmcgYXQgdGhp
cyBkZXNjcmlwdGlvbiwgd2h5IGlzbid0IHRoZSBzaW1wbGUgZml4IGp1c3QgdG8KPiA+PiA+PiBj
aGFuZ2UgdGhpcyBjYWxsIHRvIHVzZSBHRlBfQVRPTUlDPwo+ID4+ID4gCj4gPj4gPiBCZWNhdXNl
IGNoYW5nZSB0aGUgcGFyYW1ldGVyIG9mIGRldl9jb3JlZHVtcHYoKSB0byBHRlBfQVRPTUlDIGNv
dWxkIG9ubHkgc29sdmUKPiA+PiA+IHBhcnRpYWwgcHJvYmxlbS4gVGhlIGZvbGxvd2luZyBHRlBf
S0VSTkVMIHBhcmFtZXRlcnMgYXJlIGluIC9saWIva29iamVjdC5jCj4gPj4gPiB3aGljaCBpcyBu
b3QgaW5mbHVlbmNlZCBieSBkZXZfY29yZWR1bXB2KCkuCj4gPj4gPiAKPiA+PiA+ICAga29iamVj
dF9zZXRfbmFtZV92YXJncwo+ID4+ID4gICAgIGt2YXNwcmludGZfY29uc3QoR0ZQX0tFUk5FTCwg
Li4uKTsgLy9tYXkgc2xlZXAKPiA+PiA+ICAgICBrc3RyZHVwKHMsIEdGUF9LRVJORUwpOyAvL21h
eSBzbGVlcAo+ID4+IAo+ID4+IFRoZW4gaXQgc2VlbXMgdGhlcmUgaXMgYSBwcm9ibGVtIHdpdGgg
ZGV2X2NvcmVkdW1wbSgpLgo+ID4+IAo+ID4+IGRldl9jb3JlZHVtcG0oKSB0YWtlcyBhIGdmcCBw
YXJhbSB3aGljaCBtZWFucyBpdCBleHBlY3RzIHRvIGJlIGNhbGxlZCBpbiAKPiA+PiBhbnkgY29u
dGV4dCwgYnV0IGl0IHRoZW4gY2FsbHMgZGV2X3NldF9uYW1lKCkgd2hpY2gsIGFzIHlvdSBwb2lu
dCBvdXQsIAo+ID4+IGNhbm5vdCBiZSBjYWxsZWQgZnJvbSBhbiBhdG9taWMgY29udGV4dC4KPiA+
PiAKPiA+PiBTbyBpZiB3ZSBjYW5ub3QgY2hhbmdlIHRoZSBmYWN0IHRoYXQgZGV2X3NldF9uYW1l
KCkgY2Fubm90IGJlIGNhbGxlZCAKPiA+PiBmcm9tIGFuIGF0b21pYyBjb250ZXh0LCB0aGVuIGl0
IHdvdWxkIHNlZW0gdG8gZm9sbG93IHRoYXQgCj4gPj4gZGV2X2NvcmVkdW1wdiBhbHNvIGNhbm5v
dCBiZSBjYWxsZWQgZnJvbSBhbiBhdG9taWMgCj4gPj4gY29udGV4dCBhbmQgaGVuY2UgdGhlaXIg
Z2ZwIHBhcmFtIGlzIHBvaW50bGVzcyBhbmQgc2hvdWxkIHByZXN1bWFibHkgYmUgCj4gPj4gcmVt
b3ZlZC4KPiA+Cj4gPiBUaGFua3MgZm9yIHlvdXIgdGltZSBhbmQgc3VnZ2VzdGlvbnMhIEkgdGhp
bmsgdGhlIGdmcF90IHBhcmFtZXRlciBvZiBkZXZfY29yZWR1bXB2IGFuZAo+ID4gZGV2X2NvcmVk
dW1wbSBtYXkgbm90IGJlIHJlbW92ZWQsIGJlY2F1c2UgaXQgY291bGQgYmUgdXNlZCB0byBwYXNz
IHZhbHVlIHRvIGdmcF90Cj4gPiBwYXJhbWV0ZXIgb2Yga3phbGxvYyBpbiBkZXZfY29yZWR1bXBt
LiBXaGF0J3MgbW9yZSwgdGhlcmUgYXJlIGFsc28gbWFueSBvdGhlciBwbGFjZXMKPiA+IHVzZSBk
ZXZfY29yZWR1bXB2IGFuZCBkZXZfY29yZWR1bXBtLCBpZiB3ZSByZW1vdmUgdGhlIGdmcF90IHBh
cmFtZXRlciwgdGhlcmUgYXJlIHRvbyBtYW55Cj4gPiBwbGFjZXMgdGhhdCBuZWVkIHRvIG1vZGlm
eSBhbmQgdGhlc2UgcGxhY2VzIGFyZSBub3QgaW4gaW50ZXJydXB0Cj4gPiBjb250ZXh0Lgo+IAo+
ICJUb28gbWFueSB1c2VycyIgaXMgbm90IGEgdmFsaWQgcmVhc29uIHRvIGxlYXZlIGEgYnVnIGlu
IHBsYWNlLCBlaXRoZXIKPiBkZXZfY29yZWR1bXB2KCkgc2hvdWxkIHN1cHBvcnQgR0ZQX0FUT01J
QyBvciB0aGUgZ2ZwX3QgcGFyYW1ldGVyIHNob3VsZAo+IGJlIHJlbW92ZWQuCgpUaGUgZm9sbG93
aW5nIGlzIG9uZSBtZXRob2QgdGhhdCBsZXR0aW5nIGRldl9jb3JlZHVtcCgpIHN1cHBvcnQgR0ZQ
X0FUT01JQzoKCkkgdGhpbmsgZGV2X3NldF9uYW1lKCkgaXMgdXNlZCB0byBhbGxvY2F0ZSBtZW1v
cnkgdG8gc2V0IGEgZGV2aWNlIG5hbWUsIAp3aGljaCBuZWVkIG9ubHkgc2V2ZXJhbCBieXRlcyBh
bmQgdGhlcmUgaXMgbGl0dGxlIGNoYW5jZSB0byBzbGVlcCBpbiB0aGUKcmVhbCB3b3JsZC4gSG93
ZXZlciB0aGUgZGV2X2NvcmVkdW1wdigpIGlzIHVzZWQgdG8gYWxsb2NhdGUgbWVtb3J5IHRvIHN0
b3JlCmRldmljZSBjb3JlZHVtcCwgd2hpY2ggbmVlZCBsb3RzIG9mIG1lbW9yeSBzcGFjZSBhbmQg
aGF2ZSBtb3JlIGNoYW5jZXMKdG8gc2xlZXAuIFNvIEkgdGhpbmsgb25seSBjaGFuZ2UgdGhlIGdm
cF90IHBhcmFtZXRlciBvZiBkZXZfY29yZWR1bXB2KCkKZnJvbSBHRlBfS0VSTkVMIHRvIEdGUF9B
VE9NSUMgaXMgb2suCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9t
d2lmaWV4L21haW4uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9tYWlu
LmMKaW5kZXggYWNlNzM3MWM0NzcuLjI1ODkwNjkyMGEyIDEwMDY0NAotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvbWFpbi5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL21hcnZlbGwvbXdpZmlleC9tYWluLmMKQEAgLTExMTYsNyArMTExNiw3IEBAIHZvaWQgbXdp
ZmlleF91cGxvYWRfZGV2aWNlX2R1bXAoc3RydWN0IG13aWZpZXhfYWRhcHRlciAqYWRhcHRlcikK
ICAgICAgICBtd2lmaWV4X2RiZyhhZGFwdGVyLCBNU0csCiAgICAgICAgICAgICAgICAgICAgIj09
IG13aWZpZXggZHVtcCBpbmZvcm1hdGlvbiB0byAvc3lzL2NsYXNzL2RldmNvcmVkdW1wIHN0YXJ0
XG4iKTsKICAgICAgICBkZXZfY29yZWR1bXB2KGFkYXB0ZXItPmRldiwgYWRhcHRlci0+ZGV2ZHVt
cF9kYXRhLCBhZGFwdGVyLT5kZXZkdW1wX2xlbiwKLSAgICAgICAgICAgICAgICAgICAgIEdGUF9L
RVJORUwpOworICAgICAgICAgICAgICAgICAgICAgR0ZQX0FUT01JQyk7CiAgICAgICAgbXdpZmll
eF9kYmcoYWRhcHRlciwgTVNHLAogICAgICAgICAgICAgICAgICAgICI9PSBtd2lmaWV4IGR1bXAg
aW5mb3JtYXRpb24gdG8gL3N5cy9jbGFzcy9kZXZjb3JlZHVtcCBlbmRcbiIpOwoKPiA+IFRoZXJl
IGFyZSB0d28gc29sdXRpb25zIG5vdzogb25lIGlzIHRvIG1vdmVzIHRoZSBvcGVyYXRpb25zIHRo
YXQgbWF5Cj4gPiBzbGVlcCBpbnRvIGEgd29yayBpdGVtLgo+IAo+IFRoYXQgZG9lcyBub3QgZml4
IHRoZSByb290IGNhdXNlIHRoYXQgZGV2X2NvcmVkdW1wdigpIGNsYWltcyBpdCBjYW4gYmUKPiBj
YWxsZWQgaW4gYXRvbWljIGNvbnRleHRzLgoKSSBhZ3JlZSB3aXRoIHlvdS4gVGhlcmUgaXMgbm90
IEdGUF9BVE9NSUMgaW4gbGliL2tvYmplY3QuYy4gU2hvdWxkIHdlIG1vZGlmeQp0aGUgZ2ZwX3Qg
cGFyYW1ldGVyIGluIGtvYmplY3QuYyBpbiBvcmRlciB0byBzdXBwb3J0IGF0b21pYyBjb250ZXh0
cz8gRG8geW91IGhhdmUKYW55IG90aGVyIGdvb2QgbWV0aG9kcz8KCj4gPiBBbm90aGVyIGlzIHRv
IGNoYW5nZSB0aGUgZ2ZwX3QgcGFyYW1ldGVyIG9mIGRldl9jb3JlZHVtcHYgZnJvbSBHRlBfS0VS
TkVMIHRvIEdGUF9BVE9NSUMsIGFuZAo+ID4gY2hhbmdlIHRoZSBnZnBfdCBwYXJhbWV0ZXIgb2Yg
a3Zhc3ByaW50Zl9jb25zdCBhbmQga3N0cmR1cCBmcm9tIEdGUF9LRVJORUwgdG8gCj4gPiAiaW5f
aW50ZXJydXB0KCkgPyBHRlBfQVRPTUlDIDogR0ZQX0tFUk5FTCIuCj4gCj4gaW5faW50ZXJydXB0
KCkgaXMgZGVwcmVjYXRlZCBhbmQgc2hvdWxkIG5vdCBiZSB1c2VkLiBBbmQgSSBkb24ndCB0aGlu
awo+IGl0IGRldGVjdHMgYWxsIGF0b21pYyBjb250ZXh0cyBsaWtlIHNwaW5sb2Nrcy4KCkkgYWdy
ZWUgd2l0aCB5b3UsIHRoZSBpbl9pbnRlcnJ1cHQoKSBpcyBub3QgcHJvcGVyLgoKVGhhbmtzIGZv
ciB5b3VyIHRpbWUgYW5kIHN1Z2dlc3Rpb25zIQoKQmVzdCByZWdhcmRzLApEdW9taW5nIFpob3UK

