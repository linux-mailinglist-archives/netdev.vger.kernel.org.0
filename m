Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFBCECB5BE
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 10:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbfJDIJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 04:09:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731053AbfJDIJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 04:09:08 -0400
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 240382CE953
        for <netdev@vger.kernel.org>; Fri,  4 Oct 2019 08:09:07 +0000 (UTC)
Received: by mail-lj1-f198.google.com with SMTP id p18so1549552ljn.1
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 01:09:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=CxTGr3OoNs+1k7o4ga9lw+ILp07RapA8ZHUGhYn/b08=;
        b=JJk+jxbp7pKNfW8R7/b5XcjVZf3knrYI5gKU2LzNmSHmBQfoV7GqK60YiX8JHI7j1T
         cTF64pil37oOlF8qpm+MA3bQmznlw2lwpMx5G/+kAUQAsAY8pBioSfG/NCkyjr17LR6N
         +a+ZjfM/4EtqBvBN7F96JIu5bUWqqC9vJbGavrlYzFA7Zlnls91lOTeouJM8h1/5Yy4i
         IKbeinNj6VrOT2CB0gelz3+8rsHAM1mrwJ0odt90b3Q1PHZrSDwQIrWJnF85PAPthaie
         0S0XkWZJCYnXslMFVIrdFNZmoA+uMtz+U3JzHzKS+o2ZN6bJHVR5RwdhZwxo8j8Ekq1c
         ddqw==
X-Gm-Message-State: APjAAAWce3f33N/lSBEjjUoXCM/is2G3seefa5B7EtVx/sv2VVKp18hO
        SbHZDT3JLJ0u84xynx1DskPsrhtKis40yteGJpe2HUdBgicVLR1om2QWYXYbdJi7auA/W0kiOP4
        xXsmL0+eS2UdXMm4Y
X-Received: by 2002:a2e:9d4a:: with SMTP id y10mr8606086ljj.181.1570176545659;
        Fri, 04 Oct 2019 01:09:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwXdOsafsBtw1ID/IHtklN1DXHglNPA9xvu8TmDnmxL1/HwjensqucJ31jIfzkD42V9B9jhBA==
X-Received: by 2002:a2e:9d4a:: with SMTP id y10mr8606064ljj.181.1570176545324;
        Fri, 04 Oct 2019 01:09:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id f28sm993491lfp.28.2019.10.04.01.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 01:09:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 930C318063D; Fri,  4 Oct 2019 10:09:03 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single interface through chain calls
In-Reply-To: <5d964d8ccfd90_55732aec43fe05c47b@john-XPS-13-9370.notmuch>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1> <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com> <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com> <87r23vq79z.fsf@toke.dk> <20191003105335.3cc65226@carbon> <CAADnVQKTbaxJhkukxXM7Ue7=kA9eWsGMpnkXc=Z8O3iWGSaO0A@mail.gmail.com> <87pnjdq4pi.fsf@toke.dk> <1c9b72f9-1b61-d89a-49a4-e0b8eead853d@solarflare.com> <5d964d8ccfd90_55732aec43fe05c47b@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 04 Oct 2019 10:09:03 +0200
Message-ID: <87tv8pnd9c.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sm9obiBGYXN0YWJlbmQgPGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbT4gd3JpdGVzOg0KDQo+IEVk
d2FyZCBDcmVlIHdyb3RlOg0KPj4gT24gMDMvMTAvMjAxOSAxNTozMywgVG9rZSBIw7hpbGFuZC1K
w7hyZ2Vuc2VuIHdyb3RlOg0KPj4gPiBJbiBhbGwgY2FzZXMsIHRoZSBzeXNhZG1pbiBjYW4ndCAo
b3IgZG9lc24ndCB3YW50IHRvKSBtb2RpZnkgYW55IG9mIHRoZQ0KPj4gPiBYRFAgcHJvZ3JhbXMu
IEluIGZhY3QsIHRoZXkgbWF5IGp1c3QgYmUgaW5zdGFsbGVkIGFzIHByZS1jb21waWxlZCAuc28N
Cj4+ID4gQlBGIGZpbGVzIG9uIGhpcyBzeXN0ZW0uIFNvIGhlIG5lZWRzIHRvIGJlIGFibGUgdG8g
Y29uZmlndXJlIHRoZSBjYWxsDQo+PiA+IGNoYWluIG9mIGRpZmZlcmVudCBwcm9ncmFtcyB3aXRo
b3V0IG1vZGlmeWluZyB0aGUgZUJQRiBwcm9ncmFtIHNvdXJjZQ0KPj4gPiBjb2RlLg0KPj4gUGVy
aGFwcyBJJ20gYmVpbmcgZHVtYiwgYnV0IGNhbid0IHdlIHNvbHZlIHRoaXMgaWYgd2UgbWFrZSBs
aW5raW5nIHdvcms/DQo+PiBJLmUuIG15SURTLnNvIGhhcyBpZHNfbWFpbigpIGZ1bmN0aW9uLCBt
eUZpcmV3YWxsLnNvIGhhcyBmaXJld2FsbCgpDQo+PiDCoGZ1bmN0aW9uLCBhbmQgc3lzYWRtaW4g
d3JpdGVzIGEgbGl0dGxlIFhEUCBwcm9nIHRvIGNhbGwgdGhlc2U6DQo+PiANCj4+IGludCBtYWlu
KHN0cnVjdCB4ZHBfbWQgKmN0eCkNCj4+IHsNCj4+IMKgwqDCoMKgwqDCoMKgIGludCByYyA9IGZp
cmV3YWxsKGN0eCksIHJjMjsNCj4+IA0KPj4gwqDCoMKgwqDCoMKgwqAgc3dpdGNoKHJjKSB7DQo+
PiDCoMKgwqDCoMKgwqDCoCBjYXNlIFhEUF9EUk9QOg0KPj4gwqDCoMKgwqDCoMKgwqAgY2FzZSBY
RFBfQUJPUlRFRDoNCj4+IMKgwqDCoMKgwqDCoMKgIGRlZmF1bHQ6DQo+PiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJjOw0KPj4gwqDCoMKgwqDCoMKgwqAgY2FzZSBYRFBf
UEFTUzoNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gaWRzX21haW4o
Y3R4KTsNCj4+IMKgwqDCoMKgwqDCoMKgIGNhc2UgWERQX1RYOg0KPj4gwqDCoMKgwqDCoMKgwqAg
Y2FzZSBYRFBfUkVESVJFQ1Q6DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmMy
ID0gaWRzX21haW4oY3R4KTsNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAo
cmMyID09IFhEUF9QQVNTKQ0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCByZXR1cm4gcmM7DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIHJjMjsNCj4+IMKgwqDCoMKgwqDCoMKgIH0NCj4+IH0NCj4+IA0KPj4gTm93IGhlIGNv
bXBpbGVzIHRoaXMgYW5kIGxpbmtzIGl0IGFnYWluc3QgdGhvc2UgLnNvIGZpbGVzLCBnaXZpbmcg
aGltDQo+PiDCoGEgbmV3IG9iamVjdCBmaWxlIHdoaWNoIGhlIGNhbiB0aGVuIGluc3RhbGwuDQo+
PiANCj4+IChPbmUgcHJvYmxlbSB3aGljaCBkb2VzIHNwcmluZyB0byBtaW5kIGlzIHRoYXQgdGhl
IC5zbyBmaWxlcyBtYXkgdmVyeQ0KPj4gwqBpbmNvbnNpZGVyYXRlbHkgYm90aCBuYW1lIHRoZWly
IGVudHJ5IHBvaW50cyBtYWluKCksIHdoaWNoIG1ha2VzDQo+PiDCoGxpbmtpbmcgYWdhaW5zdCBi
b3RoIG9mIHRoZW0gcmF0aGVyIGNoYWxsZW5naW5nLsKgIEJ1dCBJIHRoaW5rIHRoYXQNCj4+IMKg
Y2FuIGJlIHdvcmtlZCBhcm91bmQgd2l0aCBhIHN1ZmZpY2llbnRseSBjbGV2ZXIgbGlua2VyKS4N
Cj4NCj4gSSBhZ3JlZSBidXQgdGhlIHNhbWUgY291bGQgYmUgZG9uZSB0b2RheSBpZiBpZHNfbWFp
biBhbmQgZmlyZXdhbGwNCj4gd2VyZSBpbmxpbmUgZnVuY3Rpb25zLiBBZG1pbiBjYW4gd3JpdGUg
dGhlaXIgbGl0dGxlIHByb2dyYW0gbGlrZSBhYm92ZQ0KPiBhbmQganVzdCAnI2luY2x1ZGUgZmly
ZXdhbGwnLCAnI2luY2x1ZGUgaWRzJy4gVGhlbiB5b3UgZG9uJ3QgbmVlZA0KPiBsaW5raW5nIGFs
dGhvdWdoIGl0IGRvZXMgbWFrZSB0aGluZ3MgbmljZXIuDQoNCihSZXBseWluZyB0byBib3RoIHlv
dSBhbmQgRWR3YXJkIGhlcmUsIGFzIHdoYXQgeW91IHN1Z2dlc3RlZCBpbiB5b3VyDQpvdGhlciBl
bWFpbCBpcyBiYXNpY2FsbHkgdGhlIHNhbWUpLg0KDQpZZXMsIHlvdSBhcmUgcmlnaHQgdGhhdCB3
ZSBjb3VsZCB0ZWNobmljYWxseSBkbyB0aGlzIGVudGlyZWx5IGluDQp1c2Vyc3BhY2Ugd2l0aCBh
IHN1ZmZpY2llbnRseSBzbWFydCBsb2FkZXIuIFRoaXMgd2FzIGV2ZW4gaW4gdGhlDQpwcmVzZW50
YXRpb24gYXQgTFBDIChzZWUgc2xpZGUgMzQ6ICJJbXBsZW1lbnRhdGlvbiBvcHRpb24gIzE6IHVz
ZXJzcGFjZQ0Kb25seSIpLg0KDQpUaGUgcmVhc29uIHdlIHdhbnQgdG8gYWRkIGtlcm5lbCBzdXBw
b3J0IGlzIHRoYXQgaXQgc29sdmVzIHNldmVyYWwNCmltcG9ydGFudCBwcm9ibGVtczoNCg0KLSBD
ZW50cmFsaXNhdGlvbjogVG8gZG8gdGhpcyBlbnRpcmVseSBpbiB1c2Vyc3BhY2UsIGV2ZXJ5dGhp
bmcgaGFzIHRvIGdvDQogIHRocm91Z2ggdGhlIHNhbWUgbG9hZGVyIHRoYXQgYnVpbGRzIHRoZSAi
ZGlzcGF0Y2hlciBwcm9ncmFtIi4NCg0KLSBFbmZvcmNlbWVudDogUmVsYXRlZCB0byB0aGUgcG9p
bnQgYWJvdmUgLSBpZiBhbiBYRFAtZW5hYmxlZA0KICBhcHBsaWNhdGlvbiBsb2FkcyBpdHMgb3du
IFhEUCBwcm9ncmFtIHdpdGhvdXQgZ29pbmcgdGhyb3VnaCB0aGUNCiAgY2VudHJhbCBsb2FkZXIs
IHdlIGNhbid0IGxvYWQgYW5vdGhlciBwcm9ncmFtIGFmdGVyIHRoYXQuDQoNCi0gU3RhdGUgaW5z
cGVjdGlvbjogSWYgdXNlcnNwYWNlIGJ1aWxkcyBhbmQgbG9hZHMgYSBzaW5nbGUgZGlzcGF0Y2gN
CiAgcHJvZ3JhbSwgaXQgaXMgZGlmZmljdWx0IHRvIGdvIGZyb20gdGhhdCBiYWNrIHRvIHRoZSBj
YWxsIHNlcXVlbmNlDQogIGdyYXBoLg0KDQotIER5bmFtaWMgY2hhbmdlczogV2hpbGUgdGhlIGRp
c3BhdGNoIHByb2dyYW0gY2FuIGJlIHJlYnVpbHQgZnJvbSBhDQogIGNvbmZpZyBmaWxlLCBpdCBi
ZWNvbWVzIGRpZmZpY3VsdCB0byBkbyBkeW5hbWljIGNoYW5nZXMgdG8gdGhlDQogIHNlcXVlbmNl
IChzdWNoIGFzIHRlbXBvcmFyaWx5IGF0dGFjaGluZyB4ZHBkdW1wIHRvIHRoZSBYRFBfRFJPUCBh
Y3Rpb24NCiAgb2YgdGhpcyBhbHJlYWR5LWxvYWRlZCBwcm9ncmFtIHdoaWxlIGRlYnVnZ2luZyku
DQoNCkhhdmluZyB0aGUgbWVjaGFuaXNtIGJlIGluLWtlcm5lbCBtYWtlcyBzb2x2aW5nIHRoZXNl
IHByb2JsZW1zIGEgbG90DQplYXNpZXIsIGJlY2F1c2UgdGhlIGtlcm5lbCBjYW4gYmUgcmVzcG9u
c2libGUgZm9yIHN0YXRlIG1hbmFnZW1lbnQsIGFuZA0KaXQgY2FuIGVuZm9yY2UgdGhlIGNoYWlu
IGNhbGwgZXhlY3V0aW9uIGxvZ2ljLg0KDQpUaGUgZmFjdCB0aGF0IExvcmVueiBldCBhbCBhcmUg
aW50ZXJlc3RlZCBpbiB0aGlzIGZlYXR1cmUgKGV2ZW4gdGhvdWdoDQp0aGV5IGFyZSBlc3NlbnRp
YWxseSBhbHJlYWR5IGRvaW5nIHdoYXQgeW91IHN1Z2dlc3RlZCwgYnkgaGF2aW5nIGENCmNlbnRy
YWxpc2VkIGRhZW1vbiB0byBtYW5hZ2UgYWxsIFhEUCBwcm9ncmFtcyksIHRlbGxzIG1lIHRoYXQg
aGF2aW5nDQprZXJuZWwgc3VwcG9ydCBmb3IgdGhpcyBpcyB0aGUgcmlnaHQgdGhpbmcgdG8gZG8u
DQoNCi1Ub2tlDQo=
