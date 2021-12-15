Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7C4475F65
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 18:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhLORde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 12:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhLORde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 12:33:34 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01640C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 09:33:34 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id t24-20020a252d18000000b005c225ae9e16so44288308ybt.15
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 09:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=TLYfAwTCY3nUPUOTqfI7ivvRfXZ7qJuak8zLmgSwgRk=;
        b=PeNlBNvFeF2xQvXn2cVOEsciww6JuUuZD2YvcXaGqCYH+U/b/7MxBWNQ8shZQf+odw
         C2oR7OJ1q3Ktn4/SiPlHCKj15a5Hl6GwrXto/6IQoGwZ9GRdpUIiRlFxOCk5vc2hXfOP
         FbI2Z334IrG+kmEvvXaGkRucrle8rasJp3eugalWod9SIGNIp0Eypkqc6DnpOIwr8j4e
         GYXE6acSkKtNEZ1/q9uNgTrr46WcuHdZtM3y3bjWYPyvcvtrAooFMSv6WldqR6Sm+KfL
         +woj1+6/+DhH25DhCEg8M2vlKWsKdLh4qQgZrrB/Fhv+FpcJ7zFSQKXK7znqDbBVKVsL
         5aBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=TLYfAwTCY3nUPUOTqfI7ivvRfXZ7qJuak8zLmgSwgRk=;
        b=Gc7jLEBbZoTiEc9zLVNs0aWFi57CQxgkDJixBYBhEXG44nhNahNQXxJ+ddV3s4uFul
         OREy09W9dk/YnAAz90taObhaCOXwcUPsPLy5A+EGRKlU9e+C8a7YuUDOLB+eI6Lz7b4t
         8DTMRD8Vi5MfOp8jyxlwzC0f49zxQa6Qiq1VrmUsFZWqnIm8sFmJiHGvs+YeUlJr3bUt
         dwJIvojkaVOjqG2ExzddhtJUCAigFV+i9pdm5m74IrpCgVIPGuY+XPmgpDiCNL3+3E9F
         +zT1vVdmQL4uK4DsYt0zbiWht98amCD3sSRD1EI42gaXoXCkxy0mqdLwyT1VkEAo+f9L
         1uLg==
X-Gm-Message-State: AOAM531x6xM4VrO5luMd0Q0/23cZl5i9X2SDricQnHeFwca//u3AXN41
        1MC8c+vzqP+m6uhJDlhWgKxXUdA=
X-Google-Smtp-Source: ABdhPJyWRz0GZtpsabukbGJ4akWefyDgiz3hJPvFUkcl5WJZO/YKJT6CqzjPbZF83Io+fiZrHmnL6OM=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:fc03:a91c:4fe0:3b78])
 (user=sdf job=sendgmr) by 2002:a25:af85:: with SMTP id g5mr7797356ybh.636.1639589613151;
 Wed, 15 Dec 2021 09:33:33 -0800 (PST)
Date:   Wed, 15 Dec 2021 09:33:31 -0800
In-Reply-To: <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
Message-Id: <Ybom69OyOjsR7kmZ@google.com>
Mime-Version: 1.0
References: <462ce9402621f5e32f08cc8acbf3d9da4d7d69ca.1639579508.git.asml.silence@gmail.com>
 <Yboc/G18R1Vi1eQV@google.com> <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
From:   sdf@google.com
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTUsIFBhdmVsIEJlZ3Vua292IHdyb3RlOg0KPiBPbiAxMi8xNS8yMSAxNjo1MSwgc2Rm
QGdvb2dsZS5jb20gd3JvdGU6DQo+ID4gT24gMTIvMTUsIFBhdmVsIEJlZ3Vua292IHdyb3RlOg0K
PiA+ID4gQWRkIHBlciBzb2NrZXQgZmFzdCBwYXRoIGZvciBub3QgZW5hYmxlZCBCUEYgc2tiIGZp
bHRlcmluZywgd2hpY2ggIA0KPiBzaGVkcw0KPiA+ID4gYSBuaWNlIGNodW5rIG9mIHNlbmQvcmVj
diBvdmVyaGVhZCB3aGVuIGFmZmVjdGVkLiBUZXN0aW5nIHVkcCB3aXRoIDEyOA0KPiA+ID4gYnl0
ZSBwYXlsb2FkIGFuZC9vciB6ZXJvY29weSB3aXRoIGFueSBwYXlsb2FkIHNpemUgc2hvd2VkIDIt
MyUNCj4gPiA+IGltcHJvdmVtZW50IGluIHJlcXVlc3RzL3Mgb24gdGhlIHR4IHNpZGUgdXNpbmcg
ZmFzdCBOSUNzIGFjcm9zcyAgDQo+IG5ldHdvcmssDQo+ID4gPiBhbmQgYXJvdW5kIDQlIGZvciBk
dW1teSBkZXZpY2UuIFNhbWUgZ29lcyBmb3IgcngsIG5vdCBtZWFzdXJlZCwgYnV0DQo+ID4gPiBu
dW1iZXJzIHNob3VsZCBiZSByZWxhdGFibGUuDQo+ID4gPiBJbiBteSB1bmRlcnN0YW5kaW5nLCB0
aGlzIHNob3VsZCBhZmZlY3QgYSBnb29kIHNoYXJlIG9mIG1hY2hpbmVzLCBhbmQgIA0KPiBhdA0K
PiA+ID4gbGVhc3QgaXQgaW5jbHVkZXMgbXkgbGFwdG9wcyBhbmQgc29tZSBjaGVja2VkIHNlcnZl
cnMuDQo+ID4NCj4gPiA+IFRoZSBjb3JlIG9mIHRoZSBwcm9ibGVtIGlzIHRoYXQgZXZlbiB0aG91
Z2ggdGhlcmUgaXMNCj4gPiA+IGNncm91cF9icGZfZW5hYmxlZF9rZXkgZ3VhcmRpbmcgZnJvbSBf
X2Nncm91cF9icGZfcnVuX2ZpbHRlcl9za2IoKQ0KPiA+ID4gb3ZlcmhlYWQsIHRoZXJlIGFyZSBj
YXNlcyB3aGVyZSB3ZSBoYXZlIHNldmVyYWwgY2dyb3VwcyBhbmQgbG9hZGluZyBhDQo+ID4gPiBC
UEYgcHJvZ3JhbSB0byBvbmUgYWxzbyBtYWtlcyBhbGwgb3RoZXJzIHRvIGdvIHRocm91Z2ggdGhl
IHNsb3cgcGF0aA0KPiA+ID4gZXZlbiB3aGVuIHRoZXkgZG9uJ3QgaGF2ZSBhbnkgQlBGIGF0dGFj
aGVkLiBJdCdzIGV2ZW4gd29yc2UsIGJlY2F1c2UNCj4gPiA+IGFwcGFyZW50bHkgc3lzdGVtZCBv
ciBzb21lIG90aGVyIGVhcmx5IGluaXQgbG9hZHMgc29tZSBCUEYgYW5kIHNvDQo+ID4gPiB0cmln
Z2VycyBleGFjdGx5IHRoaXMgc2l0dWF0aW9uIGZvciBub3JtYWwgbmV0d29ya2luZy4NCj4gPg0K
PiA+ID4gU2lnbmVkLW9mZi1ieTogUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5j
b20+DQo+ID4gPiAtLS0NCj4gPg0KPiA+ID4gdjI6IHJlcGxhY2UgYml0bWFzayBhcHBvYWNoIHdp
dGggZW1wdHlfcHJvZ19hcnJheSAoc3VnZ2VzdGVkIGJ5ICANCj4gTWFydGluKQ0KPiA+ID4gdjM6
IGFkZCAiYnBmXyIgcHJlZml4IHRvIGVtcHR5X3Byb2dfYXJyYXkgKE1hcnRpbikNCj4gPg0KPiA+
ID4g77+9IGluY2x1ZGUvbGludXgvYnBmLWNncm91cC5oIHwgMjQgKysrKysrKysrKysrKysrKysr
KysrLS0tDQo+ID4gPiDvv70gaW5jbHVkZS9saW51eC9icGYuaO+/ve+/ve+/ve+/ve+/ve+/ve+/
vSB8IDEzICsrKysrKysrKysrKysNCj4gPiA+IO+/vSBrZXJuZWwvYnBmL2Nncm91cC5j77+977+9
77+977+977+977+977+9IHwgMTggKystLS0tLS0tLS0tLS0tLS0tDQo+ID4gPiDvv70ga2VybmVs
L2JwZi9jb3JlLmPvv73vv73vv73vv73vv73vv73vv73vv73vv70gfCAxNiArKysrLS0tLS0tLS0t
LS0tDQo+ID4gPiDvv70gNCBmaWxlcyBjaGFuZ2VkLCA0MCBpbnNlcnRpb25zKCspLCAzMSBkZWxl
dGlvbnMoLSkNCj4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvYnBmLWNncm91
cC5oIGIvaW5jbHVkZS9saW51eC9icGYtY2dyb3VwLmgNCj4gPiA+IGluZGV4IDExODIwYTQzMGQ2
Yy4uYzZkYWNkYmRmNTY1IDEwMDY0NA0KPiA+ID4gLS0tIGEvaW5jbHVkZS9saW51eC9icGYtY2dy
b3VwLmgNCj4gPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvYnBmLWNncm91cC5oDQo+ID4gPiBAQCAt
MjE5LDExICsyMTksMjggQEAgaW50IGJwZl9wZXJjcHVfY2dyb3VwX3N0b3JhZ2VfY29weShzdHJ1
Y3QgIA0KPiBicGZfbWFwICptYXAsIHZvaWQgKmtleSwgdm9pZCAqdmFsdWUpOw0KPiA+ID4g77+9
IGludCBicGZfcGVyY3B1X2Nncm91cF9zdG9yYWdlX3VwZGF0ZShzdHJ1Y3QgYnBmX21hcCAqbWFw
LCB2b2lkICprZXksDQo+ID4gPiDvv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73v
v73vv73vv73vv73vv73vv73vv73vv73vv73vv70gdm9pZCAqdmFsdWUsIHU2NCBmbGFncyk7DQo+
ID4NCj4gPiA+ICtzdGF0aWMgaW5saW5lIGJvb2wNCj4gPiA+ICtfX2Nncm91cF9icGZfcHJvZ19h
cnJheV9pc19lbXB0eShzdHJ1Y3QgY2dyb3VwX2JwZiAqY2dycF9icGYsDQo+ID4gPiAr77+977+9
77+977+977+977+977+977+977+977+977+977+977+977+977+977+9IGVudW0gY2dyb3VwX2Jw
Zl9hdHRhY2hfdHlwZSB0eXBlKQ0KPiA+ID4gK3sNCj4gPiA+ICvvv73vv73vv70gc3RydWN0IGJw
Zl9wcm9nX2FycmF5ICphcnJheSA9ICANCj4gcmN1X2FjY2Vzc19wb2ludGVyKGNncnBfYnBmLT5l
ZmZlY3RpdmVbdHlwZV0pOw0KPiA+ID4gKw0KPiA+ID4gK++/ve+/ve+/vSByZXR1cm4gYXJyYXkg
PT0gJmJwZl9lbXB0eV9wcm9nX2FycmF5LmhkcjsNCj4gPiA+ICt9DQo+ID4gPiArDQo+ID4gPiAr
I2RlZmluZSBDR1JPVVBfQlBGX1RZUEVfRU5BQkxFRChzaywgYXR5cGUp77+977+977+977+977+9
77+977+977+977+977+977+977+977+977+977+977+977+977+977+977+977+977+9IFwNCj4g
PiA+ICsoe++/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/
ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/
ve+/ve+/ve+/ve+/ve+/ve+/vSBcDQo+ID4gPiAr77+977+977+9IHN0cnVjdCBjZ3JvdXAgKl9f
Y2dycCA9ICANCj4gc29ja19jZ3JvdXBfcHRyKCYoc2spLT5za19jZ3JwX2RhdGEpO++/ve+/ve+/
ve+/ve+/ve+/ve+/ve+/ve+/ve+/vSBcDQo+ID4gPiAr77+977+977+977+977+977+977+977+9
77+977+977+977+977+977+977+977+977+977+977+977+977+977+977+977+977+977+977+9
77+977+977+977+977+977+977+977+977+977+977+977+977+977+977+9IFwNCj4gPiA+ICvv
v73vv73vv70gIV9fY2dyb3VwX2JwZl9wcm9nX2FycmF5X2lzX2VtcHR5KCZfX2NncnAtPmJwZiwg
IA0KPiAoYXR5cGUpKTvvv73vv73vv73vv73vv73vv73vv73vv73vv73vv70gXA0KPiA+ID4gK30p
DQo+ID4gPiArDQo+ID4gPiDvv70gLyogV3JhcHBlcnMgZm9yIF9fY2dyb3VwX2JwZl9ydW5fZmls
dGVyX3NrYigpIGd1YXJkZWQgYnkgIA0KPiBjZ3JvdXBfYnBmX2VuYWJsZWQuICovDQo+ID4gPiDv
v70gI2RlZmluZSBCUEZfQ0dST1VQX1JVTl9QUk9HX0lORVRfSU5HUkVTUyhzaywgc2tiKe+/ve+/
ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/vSBcDQo+ID4gPiDv
v70gKHvvv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73v
v73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv73v
v73vv73vv73vv73vv70gXA0KPiA+ID4g77+977+977+977+977+9IGludCBfX3JldCA9IDA777+9
77+977+977+977+977+977+977+977+977+977+977+977+977+977+977+977+977+977+977+9
77+977+977+977+977+977+977+977+977+977+977+977+977+9IFwNCj4gPiA+IC3vv73vv73v
v70gaWYgKGNncm91cF9icGZfZW5hYmxlZChDR1JPVVBfSU5FVF9JTkdSRVNTKSnvv73vv73vv73v
v73vv73vv73vv73vv73vv73vv73vv73vv73vv70gXA0KPiA+ID4gK++/ve+/ve+/vSBpZiAoY2dy
b3VwX2JwZl9lbmFibGVkKENHUk9VUF9JTkVUX0lOR1JFU1MpICYmIHNrICANCj4gJibvv73vv73v
v73vv73vv73vv73vv73vv73vv73vv73vv73vv73vv70gXA0KPiA+ID4gK++/ve+/ve+/ve+/ve+/
ve+/ve+/vSBDR1JPVVBfQlBGX1RZUEVfRU5BQkxFRCgoc2spLCAgDQo+IENHUk9VUF9JTkVUX0lO
R1JFU1MpKe+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/ve+/vSBcDQo+ID4NCj4gPiBXaHkgbm90
IGFkZCB0aGlzIF9fY2dyb3VwX2JwZl9ydW5fZmlsdGVyX3NrYiBjaGVjayB0bw0KPiA+IF9fY2dy
b3VwX2JwZl9ydW5fZmlsdGVyX3NrYj8gUmVzdWx0IG9mIHNvY2tfY2dyb3VwX3B0cigpIGlzIGFs
cmVhZHkgIA0KPiB0aGVyZQ0KPiA+IGFuZCB5b3UgY2FuIHVzZSBpdC4gTWF5YmUgbW92ZSB0aGUg
dGhpbmdzIGFyb3VuZCBpZiB5b3Ugd2FudA0KPiA+IGl0IHRvIGhhcHBlbiBlYXJsaWVyLg0KDQo+
IEZvciBpbmxpbmluZy4gSnVzdCB3YW50ZWQgdG8gZ2V0IGl0IGRvbmUgcmlnaHQsIG90aGVyd2lz
ZSBJJ2xsIGxpa2VseSBiZQ0KPiByZXR1cm5pbmcgdG8gaXQgYmFjayBpbiBhIGZldyBtb250aHMg
Y29tcGxhaW5pbmcgdGhhdCBJIHNlZSBtZWFzdXJhYmxlDQo+IG92ZXJoZWFkIGZyb20gdGhlIGZ1
bmN0aW9uIGNhbGwgOikNCg0KRG8geW91IGV4cGVjdCB0aGF0IGRpcmVjdCBjYWxsIHRvIGJyaW5n
IGFueSB2aXNpYmxlIG92ZXJoZWFkPw0KV291bGQgYmUgbmljZSB0byBjb21wYXJlIHRoYXQgaW5s
aW5lZCBjYXNlIHZzDQpfX2Nncm91cF9icGZfcHJvZ19hcnJheV9pc19lbXB0eSBpbnNpZGUgb2Yg
X19jZ3JvdXBfYnBmX3J1bl9maWx0ZXJfc2tiDQp3aGlsZSB5b3UncmUgYXQgaXQgKHBsdXMgbW92
ZSBvZmZzZXQgaW5pdGlhbGl6YXRpb24gZG93bj8pLg0K
