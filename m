Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D796753D940
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 04:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243400AbiFECXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 22:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbiFECXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 22:23:40 -0400
Received: from m1322.mail.163.com (m1322.mail.163.com [220.181.13.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3F53193DA;
        Sat,  4 Jun 2022 19:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=Ou0NC
        Ock2iTr/mjmANBuaCkErVdvPD5EtAZbFlxHnWU=; b=WEJSbHO1wgybIbJp8Ual3
        cQyAJ3bJFkZyS4PBysP7zcDHkJdyo7ABvp8ftMbx16XCCoegZuEG9rtUXXPVj6WC
        nz5yIMAkfXhOjylUGq+FBW95NyUlRoSC2aC1VyhWdl/G7RnsqcRg5kIdDA1thZ94
        HtOFPkU2IFL423PYST2WN4=
Received: from chen45464546$163.com ( [171.221.147.121] ) by
 ajax-webmail-wmsvr22 (Coremail) ; Sun, 5 Jun 2022 10:22:26 +0800 (CST)
X-Originating-IP: [171.221.147.121]
Date:   Sun, 5 Jun 2022 10:22:26 +0800 (CST)
From:   "Chen Lin" <chen45464546@163.com>
To:     "Alexander Duyck" <alexander.duyck@gmail.com>
Cc:     "Felix Fietkau" <nbd@nbd.name>, "Jakub Kicinski" <kuba@kernel.org>,
        "John Crispin" <john@phrozen.org>,
        "Sean Wang" <sean.wang@mediatek.com>, Mark-MC.Lee@mediatek.com,
        "David Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, matthias.bgg@gmail.com,
        Netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re:Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix misuse of mem
 alloc interface netdev[napi]_alloc_frag
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <CAKgT0UdR-bdiZXsV_=8yJUS8zjoO6jeBS5bKNWAyxwLCiOP8ZQ@mail.gmail.com>
References: <2997c5b0-3611-5e00-466c-b2966f09f067@nbd.name>
 <1654245968-8067-1-git-send-email-chen45464546@163.com>
 <CAKgT0Uc9vSEJxrev10Uc3P==+tTip7+7W=AF2uE+VB3GVyOTxg@mail.gmail.com>
 <CAKgT0UdR-bdiZXsV_=8yJUS8zjoO6jeBS5bKNWAyxwLCiOP8ZQ@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <31d36b89.adf.18131abbaab.Coremail.chen45464546@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: FsGowAC3ezljE5xiZn4fAA--.30551W
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbCqR0Xnl0Df0HRXwAAsT
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXQgMjAyMi0wNi0wMyAyMzozMzoyNSwgIkFsZXhhbmRlciBEdXljayIgPGFsZXhhbmRlci5kdXlj
a0BnbWFpbC5jb20+IHdyb3RlOgo+T24gRnJpLCBKdW4gMywgMjAyMiBhdCA4OjI1IEFNIEFsZXhh
bmRlciBEdXljawo+PGFsZXhhbmRlci5kdXlja0BnbWFpbC5jb20+IHdyb3RlOgo+Pgo+PiBPbiBG
cmksIEp1biAzLCAyMDIyIGF0IDI6MDMgQU0gQ2hlbiBMaW4gPGNoZW40NTQ2NDU0NkAxNjMuY29t
PiB3cm90ZToKPj4gPgo+PiA+IFdoZW4gcnhfZmxhZyA9PSBNVEtfUlhfRkxBR1NfSFdMUk8sCj4+
ID4gcnhfZGF0YV9sZW4gPSBNVEtfTUFYX0xST19SWF9MRU5HVEgoNDA5NiAqIDMpID4gUEFHRV9T
SVpFLgo+PiA+IG5ldGRldl9hbGxvY19mcmFnIGlzIGZvciBhbGxvY3Rpb24gb2YgcGFnZSBmcmFn
bWVudCBvbmx5Lgo+PiA+IFJlZmVyZW5jZSB0byBvdGhlciBkcml2ZXJzIGFuZCBEb2N1bWVudGF0
aW9uL3ZtL3BhZ2VfZnJhZ3MucnN0Cj4+ID4KPj4gPiBCcmFuY2ggdG8gdXNlIGFsbG9jX3BhZ2Vz
IHdoZW4gcmluZy0+ZnJhZ19zaXplID4gUEFHRV9TSVpFLgo+PiA+Cj4+ID4gU2lnbmVkLW9mZi1i
eTogQ2hlbiBMaW4gPGNoZW40NTQ2NDU0NkAxNjMuY29tPgo+PiA+IC0tLQo+PiA+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5jIHwgICAyMiArKysrKysrKysrKysr
KysrKysrKy0tCj4+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQo+PiA+Cj4+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlh
dGVrL210a19ldGhfc29jLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRo
X3NvYy5jCj4+ID4gaW5kZXggYjNiM2MwNy4uNzcyZDkwMyAxMDA2NDQKPj4gPiAtLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5jCj4+ID4gKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX2V0aF9zb2MuYwo+PiA+IEBAIC0xNDY3LDcgKzE0
NjcsMTYgQEAgc3RhdGljIGludCBtdGtfcG9sbF9yeChzdHJ1Y3QgbmFwaV9zdHJ1Y3QgKm5hcGks
IGludCBidWRnZXQsCj4+ID4gICAgICAgICAgICAgICAgICAgICAgICAgZ290byByZWxlYXNlX2Rl
c2M7Cj4+ID4KPj4gPiAgICAgICAgICAgICAgICAgLyogYWxsb2MgbmV3IGJ1ZmZlciAqLwo+PiA+
IC0gICAgICAgICAgICAgICBuZXdfZGF0YSA9IG5hcGlfYWxsb2NfZnJhZyhyaW5nLT5mcmFnX3Np
emUpOwo+PiA+ICsgICAgICAgICAgICAgICBpZiAocmluZy0+ZnJhZ19zaXplIDw9IFBBR0VfU0la
RSkgewo+PiA+ICsgICAgICAgICAgICAgICAgICAgICAgIG5ld19kYXRhID0gbmFwaV9hbGxvY19m
cmFnKHJpbmctPmZyYWdfc2l6ZSk7Cj4+ID4gKyAgICAgICAgICAgICAgIH0gZWxzZSB7Cj4+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHBhZ2UgKnBhZ2U7Cj4+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgdW5zaWduZWQgaW50IG9yZGVyID0gZ2V0X29yZGVyKHJpbmctPmZyYWdf
c2l6ZSk7Cj4+ID4gKwo+PiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHBhZ2UgPSBhbGxvY19w
YWdlcyhHRlBfQVRPTUlDIHwgX19HRlBfQ09NUCB8Cj4+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBfX0dGUF9OT1dBUk4sIG9yZGVyKTsKPj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICBuZXdfZGF0YSA9IHBhZ2UgPyBwYWdlX2FkZHJlc3MocGFnZSkgOiBO
VUxMOwo+PiA+ICsgICAgICAgICAgICAgICB9Cj4+ID4gICAgICAgICAgICAgICAgIGlmICh1bmxp
a2VseSghbmV3X2RhdGEpKSB7Cj4+ID4gICAgICAgICAgICAgICAgICAgICAgICAgbmV0ZGV2LT5z
dGF0cy5yeF9kcm9wcGVkKys7Cj4+ID4gICAgICAgICAgICAgICAgICAgICAgICAgZ290byByZWxl
YXNlX2Rlc2M7Cj4+ID4gQEAgLTE5MTQsNyArMTkyMywxNiBAQCBzdGF0aWMgaW50IG10a19yeF9h
bGxvYyhzdHJ1Y3QgbXRrX2V0aCAqZXRoLCBpbnQgcmluZ19ubywgaW50IHJ4X2ZsYWcpCj4+ID4g
ICAgICAgICAgICAgICAgIHJldHVybiAtRU5PTUVNOwo+PiA+Cj4+ID4gICAgICAgICBmb3IgKGkg
PSAwOyBpIDwgcnhfZG1hX3NpemU7IGkrKykgewo+PiA+IC0gICAgICAgICAgICAgICByaW5nLT5k
YXRhW2ldID0gbmV0ZGV2X2FsbG9jX2ZyYWcocmluZy0+ZnJhZ19zaXplKTsKPj4gPiArICAgICAg
ICAgICAgICAgaWYgKHJpbmctPmZyYWdfc2l6ZSA8PSBQQUdFX1NJWkUpIHsKPj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICByaW5nLT5kYXRhW2ldID0gbmV0ZGV2X2FsbG9jX2ZyYWcocmluZy0+
ZnJhZ19zaXplKTsKPj4gPiArICAgICAgICAgICAgICAgfSBlbHNlIHsKPj4gPiArICAgICAgICAg
ICAgICAgICAgICAgICBzdHJ1Y3QgcGFnZSAqcGFnZTsKPj4gPiArICAgICAgICAgICAgICAgICAg
ICAgICB1bnNpZ25lZCBpbnQgb3JkZXIgPSBnZXRfb3JkZXIocmluZy0+ZnJhZ19zaXplKTsKPj4g
PiArCj4+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcGFnZSA9IGFsbG9jX3BhZ2VzKEdGUF9L
RVJORUwgfCBfX0dGUF9DT01QIHwKPj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIF9fR0ZQX05PV0FSTiwgb3JkZXIpOwo+PiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgIHJpbmctPmRhdGFbaV0gPSBwYWdlID8gcGFnZV9hZGRyZXNzKHBhZ2UpIDogTlVMTDsK
Pj4gPiArICAgICAgICAgICAgICAgfQo+PiA+ICAgICAgICAgICAgICAgICBpZiAoIXJpbmctPmRh
dGFbaV0pCj4+ID4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07Cj4+ID4g
ICAgICAgICB9Cj4+Cj4+IEFjdHVhbGx5IEkgbG9va2VkIGNsb3NlciBhdCB0aGlzIGRyaXZlci4g
SXMgaXQgYWJsZSB0byByZWNlaXZlIGZyYW1lcwo+PiBsYXJnZXIgdGhhbiAySz8gSWYgbm90IHRo
ZXJlIGlzbid0IGFueSBwb2ludCBpbiB0aGlzIGNoYW5nZS4KPj4KPj4gQmFzZWQgb24gY29tbWl0
IDRmZDU5NzkyMDk3YSAoIm5ldDogZXRoZXJuZXQ6IG1lZGlhdGVrOiBzdXBwb3J0Cj4+IHNldHRp
bmcgTVRVIikgaXQgbG9va3MgbGlrZSBpdCBkb2Vzbid0LCBzbyBvZGRzIGFyZSB0aGlzIHBhdGNo
IGlzIG5vdAo+PiBuZWNlc3NhcnkuCj4KPkkgc3Bva2UgdG9vIHNvb24uIEkgaGFkIG92ZXJsb29r
ZWQgdGhlIExSTyBwYXJ0LiBXaXRoIHRoYXQgYmVpbmcgdGhlCj5jYXNlIHlvdSBjYW4gcHJvYmFi
bHkgb3B0aW1pemUgdGhpcyBjb2RlIHRvIGRvIGF3YXkgd2l0aCB0aGUgZ2V0X29yZGVyCj5waWVj
ZSBlbnRpcmVseSwgYXQgbGVhc3QgZHVyaW5nIHJ1bnRpbWUuIE15IG1haW4gY29uY2VybiBpcyB0
aGF0IGRvaW5nCj50aGF0IGluIHRoZSBmYXN0LXBhdGggd2lsbCBiZSBleHBlbnNpdmUgc28geW91
IHdvdWxkIGJlIG11Y2ggYmV0dGVyCj5vZmYgZG9pbmcgc29tZXRoaW5nIGxpa2UKPmdldF9vcmRl
cihtdGtfbWF4X2ZyYWdfc2l6ZShNVEtfUlhfRkxBR1NfSFdMUk8pKSB3aGljaCB3b3VsZCBiZQo+
Y29udmVydGVkIGludG8gYSBjb25zdGFudCBhdCBjb21waWxlIHRpbWUgc2luY2UgZXZlcnl0aGlu
ZyBlbHNlIHdvdWxkCj5iZSBsZXNzIHRoYW4gMSBwYWdlIGluIHNpemUuCj4KPkFsc28geW91IGNv
dWxkIHRoZW4gcmVwbGFjZSBhbGxvY19wYWdlcyB3aXRoIF9fZ2V0X2ZyZWVfcGFnZXMgd2hpY2gK
PndvdWxkIHRha2UgY2FyZSBvZiB0aGUgcGFnZV9hZGRyZXNzIGNhbGwgZm9yIHlvdS4KClRoYW5r
cyBmb3IgdGhlIHRpcHMuIEknbGwgdHJ5IGFnYWluLgpJdCBjYW4gYWxzbyBiZSBzZWVuIGZyb20g
aGVyZSBpdCBpcyBlYXN5IHRvIG1ha2UgbWlzdGFrZXMgaW4gcGFyYW1ldGVyIGZyYWdzei4K
