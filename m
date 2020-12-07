Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5BB2D1A09
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgLGTwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:52:50 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:61507 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgLGTwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 14:52:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607370768; x=1638906768;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=UVRuDaQb7+ChxvHeSe7dag9XZt1jT6xUYv64Rrr30bw=;
  b=gEPiTKAoxmjw1JyOY7dE/gGifIP/zVLk3ytFy4P+bNOQL+KbiGF+HivB
   pY1epcFHVDidWaYhMUtblpU0YxAWQbb7wwCsyWhUYjFT6lw476RLDqzMn
   81nxrSaqoaAuURI+sfexwjDOhgGLEDzT3IG8dPlLPEPzbA2alB8W2duYN
   g=;
X-IronPort-AV: E=Sophos;i="5.78,400,1599523200"; 
   d="scan'208";a="901223170"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 07 Dec 2020 19:52:07 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id D3D72A186D;
        Mon,  7 Dec 2020 19:52:06 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.144) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 19:52:00 +0000
Subject: Re: [PATCH net-next v2 4/4] af_vsock: Assign the vsock transport
 considering the vsock address flags
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20201204170235.84387-1-andraprs@amazon.com>
 <20201204170235.84387-5-andraprs@amazon.com>
 <20201207100016.6n5x7bd2fqvf2mmi@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <0ce190c0-53c1-fa45-0e7d-45ed7913b076@amazon.com>
Date:   Mon, 7 Dec 2020 21:51:55 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201207100016.6n5x7bd2fqvf2mmi@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D14UWC003.ant.amazon.com (10.43.162.19) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpPbiAwNy8xMi8yMDIwIDEyOjAwLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBPbiBG
cmksIERlYyAwNCwgMjAyMCBhdCAwNzowMjozNVBNICswMjAwLCBBbmRyYSBQYXJhc2NoaXYgd3Jv
dGU6Cj4+IFRoZSB2c29jayBmbGFncyBmaWVsZCBjYW4gYmUgc2V0IGluIHRoZSBjb25uZWN0IGFu
ZCAobGlzdGVuKSByZWNlaXZlCj4+IHBhdGhzLgo+Pgo+PiBXaGVuIHRoZSB2c29jayB0cmFuc3Bv
cnQgaXMgYXNzaWduZWQsIHRoZSByZW1vdGUgQ0lEIGlzIHVzZWQgdG8KPj4gZGlzdGluZ3Vpc2gg
YmV0d2VlbiB0eXBlcyBvZiBjb25uZWN0aW9uLgo+Pgo+PiBVc2UgdGhlIHZzb2NrIGZsYWdzIHZh
bHVlIChpbiBhZGRpdGlvbiB0byB0aGUgQ0lEKSBmcm9tIHRoZSByZW1vdGUKPj4gYWRkcmVzcyB0
byBkZWNpZGUgd2hpY2ggdnNvY2sgdHJhbnNwb3J0IHRvIGFzc2lnbi4gRm9yIHRoZSBzaWJsaW5n
IFZNcwo+PiB1c2UgY2FzZSwgYWxsIHRoZSB2c29jayBwYWNrZXRzIG5lZWQgdG8gYmUgZm9yd2Fy
ZGVkIHRvIHRoZSBob3N0LCBzbwo+PiBhbHdheXMgYXNzaWduIHRoZSBndWVzdC0+aG9zdCB0cmFu
c3BvcnQgaWYgdGhlIFZNQUREUl9GTEFHX1RPX0hPU1QgZmxhZwo+PiBpcyBzZXQuIEZvciB0aGUg
b3RoZXIgdXNlIGNhc2VzLCB0aGUgdnNvY2sgdHJhbnNwb3J0IGFzc2lnbm1lbnQgbG9naWMgaXMK
Pj4gbm90IGNoYW5nZWQuCj4+Cj4+IENoYW5nZWxvZwo+Pgo+PiB2MSAtPiB2Mgo+Pgo+PiAqIFVz
ZSBiaXR3aXNlIG9wZXJhdG9yIHRvIGNoZWNrIHRoZSB2c29jayBmbGFnLgo+PiAqIFVzZSB0aGUg
dXBkYXRlZCAiVk1BRERSX0ZMQUdfVE9fSE9TVCIgZmxhZyBuYW1pbmcuCj4+ICogTWVyZ2UgdGhl
IGNoZWNrcyBmb3IgdGhlIGcyaCB0cmFuc3BvcnQgYXNzaWdubWVudCBpbiBvbmUgImlmIiBibG9j
ay4KPj4KPj4gU2lnbmVkLW9mZi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24u
Y29tPgo+PiAtLS0KPj4gbmV0L3Ztd192c29jay9hZl92c29jay5jIHwgOSArKysrKysrLS0KPj4g
MSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPj4KPj4gZGlm
ZiAtLWdpdCBhL25ldC92bXdfdnNvY2svYWZfdnNvY2suYyBiL25ldC92bXdfdnNvY2svYWZfdnNv
Y2suYwo+PiBpbmRleCA4M2QwMzVlYWIwYjA1Li42NmU2NDNjM2I1Zjg1IDEwMDY0NAo+PiAtLS0g
YS9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMKPj4gKysrIGIvbmV0L3Ztd192c29jay9hZl92c29j
ay5jCj4+IEBAIC00MjEsNyArNDIxLDggQEAgc3RhdGljIHZvaWQgdnNvY2tfZGVhc3NpZ25fdHJh
bnNwb3J0KHN0cnVjdCAKPj4gdnNvY2tfc29jayAqdnNrKQo+PiDCoCogVGhlIHZzay0+cmVtb3Rl
X2FkZHIgaXMgdXNlZCB0byBkZWNpZGUgd2hpY2ggdHJhbnNwb3J0IHRvIHVzZToKPj4gwqAqwqAg
LSByZW1vdGUgQ0lEID09IFZNQUREUl9DSURfTE9DQUwgb3IgZzJoLT5sb2NhbF9jaWQgb3IgCj4+
IFZNQUREUl9DSURfSE9TVCBpZgo+PiDCoCrCoMKgwqAgZzJoIGlzIG5vdCBsb2FkZWQsIHdpbGwg
dXNlIGxvY2FsIHRyYW5zcG9ydDsKPj4gLSAqwqAgLSByZW1vdGUgQ0lEIDw9IFZNQUREUl9DSURf
SE9TVCB3aWxsIHVzZSBndWVzdC0+aG9zdCB0cmFuc3BvcnQ7Cj4+ICsgKsKgIC0gcmVtb3RlIENJ
RCA8PSBWTUFERFJfQ0lEX0hPU1Qgb3IgaDJnIGlzIG5vdCBsb2FkZWQgb3IgcmVtb3RlIAo+PiBm
bGFncyBmaWVsZAo+PiArICrCoMKgwqAgaW5jbHVkZXMgVk1BRERSX0ZMQUdfVE9fSE9TVCBmbGFn
IHZhbHVlLCB3aWxsIHVzZSBndWVzdC0+aG9zdCAKPj4gdHJhbnNwb3J0Owo+PiDCoCrCoCAtIHJl
bW90ZSBDSUQgPiBWTUFERFJfQ0lEX0hPU1Qgd2lsbCB1c2UgaG9zdC0+Z3Vlc3QgdHJhbnNwb3J0
Owo+PiDCoCovCj4+IGludCB2c29ja19hc3NpZ25fdHJhbnNwb3J0KHN0cnVjdCB2c29ja19zb2Nr
ICp2c2ssIHN0cnVjdCB2c29ja19zb2NrIAo+PiAqcHNrKQo+PiBAQCAtNDI5LDYgKzQzMCw3IEBA
IGludCB2c29ja19hc3NpZ25fdHJhbnNwb3J0KHN0cnVjdCB2c29ja19zb2NrIAo+PiAqdnNrLCBz
dHJ1Y3QgdnNvY2tfc29jayAqcHNrKQo+PiDCoMKgwqDCoMKgIGNvbnN0IHN0cnVjdCB2c29ja190
cmFuc3BvcnQgKm5ld190cmFuc3BvcnQ7Cj4+IMKgwqDCoMKgwqAgc3RydWN0IHNvY2sgKnNrID0g
c2tfdnNvY2sodnNrKTsKPj4gwqDCoMKgwqDCoCB1bnNpZ25lZCBpbnQgcmVtb3RlX2NpZCA9IHZz
ay0+cmVtb3RlX2FkZHIuc3ZtX2NpZDsKPj4gK8KgwqDCoMKgwqAgdW5zaWduZWQgc2hvcnQgcmVt
b3RlX2ZsYWdzOwo+PiDCoMKgwqDCoMKgIGludCByZXQ7Cj4+Cj4+IMKgwqDCoMKgwqAgLyogSWYg
dGhlIHBhY2tldCBpcyBjb21pbmcgd2l0aCB0aGUgc291cmNlIGFuZCBkZXN0aW5hdGlvbiBDSURz
IAo+PiBoaWdoZXIKPj4gQEAgLTQ0Myw2ICs0NDUsOCBAQCBpbnQgdnNvY2tfYXNzaWduX3RyYW5z
cG9ydChzdHJ1Y3QgdnNvY2tfc29jayAKPj4gKnZzaywgc3RydWN0IHZzb2NrX3NvY2sgKnBzaykK
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHZzay0+cmVtb3RlX2FkZHIuc3ZtX2NpZCA+IFZNQUREUl9D
SURfSE9TVCkKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdnNrLT5yZW1vdGVfYWRkci5z
dm1fZmxhZ3MgfD0gVk1BRERSX0ZMQUdfVE9fSE9TVDsKPj4KPj4gK8KgwqDCoMKgwqAgcmVtb3Rl
X2ZsYWdzID0gdnNrLT5yZW1vdGVfYWRkci5zdm1fZmxhZ3M7Cj4+ICsKPj4gwqDCoMKgwqDCoCBz
d2l0Y2ggKHNrLT5za190eXBlKSB7Cj4+IMKgwqDCoMKgwqAgY2FzZSBTT0NLX0RHUkFNOgo+PiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBuZXdfdHJhbnNwb3J0ID0gdHJhbnNwb3J0X2RncmFt
Owo+PiBAQCAtNDUwLDcgKzQ1NCw4IEBAIGludCB2c29ja19hc3NpZ25fdHJhbnNwb3J0KHN0cnVj
dCB2c29ja19zb2NrIAo+PiAqdnNrLCBzdHJ1Y3QgdnNvY2tfc29jayAqcHNrKQo+PiDCoMKgwqDC
oMKgIGNhc2UgU09DS19TVFJFQU06Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICh2
c29ja191c2VfbG9jYWxfdHJhbnNwb3J0KHJlbW90ZV9jaWQpKQo+PiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbmV3X3RyYW5zcG9ydCA9IHRyYW5zcG9ydF9sb2Nh
bDsKPj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGVsc2UgaWYgKHJlbW90ZV9jaWQgPD0g
Vk1BRERSX0NJRF9IT1NUIHx8ICF0cmFuc3BvcnRfaDJnKQo+PiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgZWxzZSBpZiAocmVtb3RlX2NpZCA8PSBWTUFERFJfQ0lEX0hPU1QgfHwgCj4+ICF0
cmFuc3BvcnRfaDJnIHx8Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAocmVtb3RlX2ZsYWdzICYgVk1BRERSX0ZMQUdfVE9fSE9TVCkgPT0gCj4+IFZNQURE
Ul9GTEFHX1RPX0hPU1QpCj4KPiBNYXliZSAicmVtb3RlX2ZsYWdzICYgVk1BRERSX0ZMQUdfVE9f
SE9TVCIgc2hvdWxkIGJlIGVub3VnaCwgYnV0IHRoZQo+IHBhdGNoIGlzIG9rYXk6Cj4KPiBSZXZp
ZXdlZC1ieTogU3RlZmFubyBHYXJ6YXJlbGxhIDxzZ2FyemFyZUByZWRoYXQuY29tPgoKRG9uZSwg
dXBkYXRlZCB0byBoYXZlIG9ubHkgdGhlIGJpdHdpc2UgbG9naWMsIHdpdGhvdXQgdGhlIGNvbXBh
cmlzb24uCgpUaGFua3MsCkFuZHJhCgo+Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBuZXdfdHJhbnNwb3J0ID0gdHJhbnNwb3J0X2cyaDsKPj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgZWxzZQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgbmV3X3RyYW5zcG9ydCA9IHRyYW5zcG9ydF9oMmc7Cj4+IC0tIAo+PiAyLjIw
LjEgKEFwcGxlIEdpdC0xMTcpCj4+Cj4+Cj4+Cj4+Cj4+IEFtYXpvbiBEZXZlbG9wbWVudCBDZW50
ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiAKPj4gTGF6YXIg
U3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlh
LiAKPj4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIx
LzIwMDUuCj4+Cj4KCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5M
LiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIs
IElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5p
YS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

