Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A8248F463
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 03:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbiAOC02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 21:26:28 -0500
Received: from m13131.mail.163.com ([220.181.13.131]:58226 "EHLO
        m13131.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232179AbiAOC02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 21:26:28 -0500
X-Greylist: delayed 920 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2022 21:26:26 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=1T43d
        FltCo6Fgh9UbxbaeWXlV3mdmzK3+dU8cgtAtGo=; b=ABvmN62XIqf3qdpRw19cu
        LtVSxaEFVHYBfaWI4viwh974l9d28Vm1MRj8CjA2qLTnUwSmHxWwcNkVHglh0qEN
        VinCEoJIzhVL3RKxQP65mms2UvYpfD0xkCOrw76hOSO19yR9HOT1oc3pYy3Vhkb1
        Z67X6GkU+l6TIhBr4t/RFY=
Received: from slark_xiao$163.com ( [223.104.68.79] ) by
 ajax-webmail-wmsvr131 (Coremail) ; Sat, 15 Jan 2022 10:10:40 +0800 (CST)
X-Originating-IP: [223.104.68.79]
Date:   Sat, 15 Jan 2022 10:10:40 +0800 (CST)
From:   "Slark Xiao" <slark_xiao@163.com>
To:     "Loic Poulain" <loic.poulain@linaro.org>
Cc:     ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Shujun Wang" <wsj20369@163.com>
Subject: Re:Re: [PATCH] Fix MRU mismatch issue which may lead to data
 connection lost
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210622(1d4788a8)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <CAMZdPi8g2VxBFzS7Lw=TAN_NPQSuzwLuhEGB2akqn-Tjqer7vQ@mail.gmail.com>
References: <20220114100731.4033-1-slark_xiao@163.com>
 <CAMZdPi8g2VxBFzS7Lw=TAN_NPQSuzwLuhEGB2akqn-Tjqer7vQ@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <1d83ef81.381.17e5b804869.Coremail.slark_xiao@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: g8GowAAXHS4hLeJhwHIJAA--.26057W
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbBAwyJZGB0IojNQwABsT
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpBdCAyMDIyLTAxLTE0IDIzOjUxOjUzLCAiTG9pYyBQb3VsYWluIiA8bG9pYy5wb3VsYWluQGxp
bmFyby5vcmc+IHdyb3RlOgo+T24gRnJpLCAxNCBKYW4gMjAyMiBhdCAxMTowNywgU2xhcmsgWGlh
byA8c2xhcmtfeGlhb0AxNjMuY29tPiB3cm90ZToKPj4KPj4gSW4gcGNpX2dlbmVyaWMuYyB0aGVy
ZSBpcyBhICdtcnVfZGVmYXVsdCcgaW4gc3RydWN0IG1oaV9wY2lfZGV2X2luZm8uCj4+IFRoaXMg
dmFsdWUgc2hhbGwgYmUgdXNlZCBmb3Igd2hvbGUgbWhpIGlmIGl0J3MgZ2l2ZW4gYSB2YWx1ZSBm
b3IgYSBzcGVjaWZpYyBwcm9kdWN0Lgo+PiBCdXQgaW4gZnVuY3Rpb24gbWhpX25ldF9yeF9yZWZp
bGxfd29yaygpLCBpdCdzIHN0aWxsIHVzaW5nIGhhcmQgY29kZSB2YWx1ZSBNSElfREVGQVVMVF9N
UlUuCj4+ICdtcnVfZGVmYXVsdCcgc2hhbGwgaGF2ZSBoaWdoZXIgcHJpb3JpdHkgdGhhbiBNSElf
REVGQVVMVF9NUlUuCj4+IEFuZCBhZnRlciBjaGVja2luZywgdGhpcyBjaGFuZ2UgY291bGQgaGVs
cCBmaXggYSBkYXRhIGNvbm5lY3Rpb24gbG9zdCBpc3N1ZS4KPgo+SW50ZXJlc3RpbmcsIG5vdCBz
dXJlIHdoeSBpdCBmaXhlcyBkYXRhIGlzc3Vlcywgc2luY2UgdGhlIGRldmljZQo+c2hvdWxkIGNv
bXBseSB3aXRoIGFueSBzaXplLkNhbiB5b3UgYWRkIGEgRml4ZXMgdGFnIHRoZW4/IGFuZCBhZGQg
dGhlCj5jb3JyZWN0IFtQQVRDSCBuZXRdIHN1ZmZpeCBpbiB0aGUgc3ViamVjdDoKPmh0dHBzOi8v
d3d3Lmtlcm5lbC5vcmcvZG9jL2h0bWwvbGF0ZXN0L25ldHdvcmtpbmcvbmV0ZGV2LUZBUS5odG1s
Cj4KPldpdGggdGhhdDoKPgo+UmV2aWV3ZWQtYnk6IExvaWMgUG91bGFpbiA8bG9pYy5wb3VsYWlu
QGxpbmFyby5vcmc+Cj4KPlRoYW5rcywKPkxvaWMKPgpIaSBMb2ljLAogICBBY3R1YWxseSwgZm9y
IG91ciBGb3hjb25uIGRldmljZSBTRFg1NSwgaXQgaGFzIGJlZW4gY29uZmlybWVkIHRoYXQgTVJV
IDM1MDAgCndvdWxkIGxlYWQgdG8gYSBJUEEgc3R1Y2suIElQQSBzdHVjayB3b3VsZCBtYWtlIHRo
ZSBkYXRhIGNvbm5lY3Rpb24gbG9zdC4gCkZvciBvdGhlciBNUlUgdmFsdWUsIGxpa2UgNDAwMCwg
NDA5NiwzMjc2OCwgd2UgY2FuJ3QgcmVwcm9kdWNlIGl0LiAKICBXZSBhbHNvIGhhdmUgcmVwb3J0
IHRoaXMgaXNzdWUgaW4gaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9p
ZD0yMTU0MzMgLgogIEkgd2lsbCBzZW5kIGEgbmV3IHBhdGNoIGxhdGVyLgoKVGhhbmtzClNsYXJr
Cj4KPgo+Cj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFNodWp1biBXYW5nIDx3c2oyMDM2OUAxNjMuY29t
Pgo+PiBTaWduZWQtb2ZmLWJ5OiBTbGFyayBYaWFvIDxzbGFya194aWFvQDE2My5jb20+Cj4+IC0t
LQo+PiAgZHJpdmVycy9uZXQvd3dhbi9taGlfd3dhbl9tYmltLmMgfCA0ICsrLS0KPj4gIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC93d2FuL21oaV93d2FuX21iaW0uYyBiL2RyaXZlcnMvbmV0L3d3YW4v
bWhpX3d3YW5fbWJpbS5jCj4+IGluZGV4IDcxYmY5YjRmNzY5Zi4uNjg3Mjc4MmU4ZGQ4IDEwMDY0
NAo+PiAtLS0gYS9kcml2ZXJzL25ldC93d2FuL21oaV93d2FuX21iaW0uYwo+PiArKysgYi9kcml2
ZXJzL25ldC93d2FuL21oaV93d2FuX21iaW0uYwo+PiBAQCAtMzg1LDEzICszODUsMTMgQEAgc3Rh
dGljIHZvaWQgbWhpX25ldF9yeF9yZWZpbGxfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmsp
Cj4+ICAgICAgICAgaW50IGVycjsKPj4KPj4gICAgICAgICB3aGlsZSAoIW1oaV9xdWV1ZV9pc19m
dWxsKG1kZXYsIERNQV9GUk9NX0RFVklDRSkpIHsKPj4gLSAgICAgICAgICAgICAgIHN0cnVjdCBz
a19idWZmICpza2IgPSBhbGxvY19za2IoTUhJX0RFRkFVTFRfTVJVLCBHRlBfS0VSTkVMKTsKPj4g
KyAgICAgICAgICAgICAgIHN0cnVjdCBza19idWZmICpza2IgPSBhbGxvY19za2IobWJpbS0+bXJ1
LCBHRlBfS0VSTkVMKTsKPj4KPj4gICAgICAgICAgICAgICAgIGlmICh1bmxpa2VseSghc2tiKSkK
Pj4gICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7Cj4+Cj4+ICAgICAgICAgICAgICAgICBl
cnIgPSBtaGlfcXVldWVfc2tiKG1kZXYsIERNQV9GUk9NX0RFVklDRSwgc2tiLAo+PiAtICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBNSElfREVGQVVMVF9NUlUsIE1ISV9FT1QpOwo+
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBtYmltLT5tcnUsIE1ISV9FT1Qp
Owo+PiAgICAgICAgICAgICAgICAgaWYgKHVubGlrZWx5KGVycikpIHsKPj4gICAgICAgICAgICAg
ICAgICAgICAgICAga2ZyZWVfc2tiKHNrYik7Cj4+ICAgICAgICAgICAgICAgICAgICAgICAgIGJy
ZWFrOwo+PiAtLQo+PiAyLjI1LjEKPj4K
