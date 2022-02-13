Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CED4B3D04
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 19:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbiBMS6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 13:58:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbiBMS6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 13:58:03 -0500
X-Greylist: delayed 308 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 13 Feb 2022 10:57:55 PST
Received: from mxo2.nje.dmz.twosigma.com (mxo2.nje.dmz.twosigma.com [208.77.214.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1D058388
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 10:57:55 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mxo2.nje.dmz.twosigma.com (Postfix) with ESMTP id 4Jxc1B25tsz28tv;
        Sun, 13 Feb 2022 18:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=twosigma.com;
        s=202008; t=1644778366;
        bh=i4OCLTOZoS3HdCkHA1yLbQLmQSYKicZWYIu/y6YNjqg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=iUEjC+qzQGXH4DamppRRqNk/ZG+TBAt6WZZpilZbkq/hLje98Ypng4FZ0ArSnLQWb
         Yw9vRcqpG6bkmB0FapZwmPdjXBewVbTojpb+kHO+QF/jAUjGzwAtQla9ulljv1pRue
         NMbRzgHlgHLXpUYztV4EzP2fyb9wY0IRFilo34+FjPqhadQ9QIBqjDK5HN+j/rSnI8
         fxXGR+ViTsiFyjzsf6r6zco1q8+WESLmudeS9O1cv3G8/W6piV2mp8VIpg/QLw4eVm
         olUZVinB71pxq3BqaBylt2bhOFYQyXDbO3fuxxh/J1j2TU+AB/+KPokexs6ytVdcd+
         a7DbZcLUNLMpw==
X-Virus-Scanned: Debian amavisd-new at twosigma.com
Received: from mxo2.nje.dmz.twosigma.com ([127.0.0.1])
        by localhost (mxo2.nje.dmz.twosigma.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WuxHZHYj_FFg; Sun, 13 Feb 2022 18:52:46 +0000 (UTC)
Received: from exmbdft8.ad.twosigma.com (exmbdft8.ad.twosigma.com [172.22.2.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxo2.nje.dmz.twosigma.com (Postfix) with ESMTPS id 4Jxc1B0z0Hz28r3;
        Sun, 13 Feb 2022 18:52:46 +0000 (UTC)
Received: from exmbdft6.ad.twosigma.com (172.22.1.5) by
 exmbdft8.ad.twosigma.com (172.22.2.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 13 Feb 2022 18:52:45 +0000
Received: from exmbdft6.ad.twosigma.com ([fe80::c47f:175e:9f31:d58c]) by
 exmbdft6.ad.twosigma.com ([fe80::c47f:175e:9f31:d58c%17]) with mapi id
 15.00.1497.012; Sun, 13 Feb 2022 18:52:45 +0000
From:   Tian Lan <Tian.Lan@twosigma.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Tian Lan <tilan7663@gmail.com>, netdev <netdev@vger.kernel.org>,
        "Andrew Chester" <Andrew.Chester@twosigma.com>
Subject: RE: [PATCH] tcp: allow the initial receive window to be greater than
 64KiB
Thread-Topic: [PATCH] tcp: allow the initial receive window to be greater than
 64KiB
Thread-Index: AQHYII8R50vJ9luEckWkqpgQGqAi+KyQ4b2AgADavqCAAAbEgIAAAnNA
Date:   Sun, 13 Feb 2022 18:52:45 +0000
Message-ID: <dd7f3fd1b08a44328d59116cd64f483a@exmbdft6.ad.twosigma.com>
References: <20220213040545.365600-1-tilan7663@gmail.com>
 <CANn89i+=wXy-UFTy1a+1gaVgmynQ9u4LiAutFBf=dsE2fgF3rA@mail.gmail.com>
 <101663cb4d7d43e9b6bfa946f6b8036b@exmbdft6.ad.twosigma.com>
 <CANn89iKDzgHk_gk9+56xumy9M40br-aEoUXJ13KtFgxZRQJVOw@mail.gmail.com>
In-Reply-To: <CANn89iKDzgHk_gk9+56xumy9M40br-aEoUXJ13KtFgxZRQJVOw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.23.151.37]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBUbyBiZSBjbGVhciwgaWYgdGhlIHNlbmRlciByZXNwZWN0cyB0aGUgaW5pdGlhbCB3aW5kb3cg
aW4gZmlyc3QgUlRUICwgdGhlbiBmaXJzdCBBQ0sgaXQgd2lsbCByZWNlaXZlIGFsbG93cyBhIG11
Y2ggYmlnZ2VyIHdpbmRvdyAoYXQgbGVhc3QgMngpLCAgYWxsb3dpbmcgZm9yIHN0YW5kYXJkIHNs
b3cgc3RhcnQgYmVoYXZpb3IsIGRvdWJsaW5nIENXTkQgYXQgZWFjaCBSVFQ+DQo+DQo+IGxpbnV4
IFRDUCBzdGFjayBpcyBjb25zZXJ2YXRpdmUsIGFuZCB3YW50cyBhIHByb29mIG9mIHJlbW90ZSBw
ZWVyIHdlbGwgYmVoYXZpbmcgYmVmb3JlIG9wZW5pbmcgdGhlIGdhdGVzLg0KPg0KPiBUaGUgdGhp
bmcgaXMsIHdlIGhhdmUgdGhpcyBpc3N1ZSBiZWluZyBkaXNjdXNzZWQgZXZlcnkgMyBtb250aHMg
b3Igc28sIGJlY2F1c2Ugc29tZSBwZW9wbGUgdGhpbmsgdGhlIFJXSU4gaXMgbmV2ZXIgY2hhbmdl
ZCBvciBzb21ldGhpbmcuDQo+DQo+IExhc3QgdGltZSwgd2UgYXNrZWQgdG8gbm90IGNoYW5nZSB0
aGUgc3RhY2ssIGFuZCBpbnN0ZWFkIHN1Z2dlc3RlZCB1c2VycyB0dW5lIGl0IHVzaW5nIGVCUEYg
aWYgdGhleSByZWFsbHkgbmVlZCB0byBieXBhc3MgVENQIHN0YW5kYXJkcy4NCj4NCj4gaHR0cHM6
Ly9sa21sLm9yZy9sa21sLzIwMjEvMTIvMjIvNjUyDQoNCkkgdG90YWxseSB1bmRlcnN0YW5kIHRo
YXQgTGludXggd2FudHMgdG8gYmUgY29uc2VydmF0aXZlIGJlZm9yZSBvcGVuaW5nIHVwIHRoZSBn
YXRlIGFuZCBJJ20gZnVsbHkgc3VwcG9ydCBvZiB0aGlzIGlkZWEuIEkgdGhpbmsgdGhlIGN1cnJl
bnQgTGludXggYmVoYXZpb3IgaXMgZ29vZCBmb3IgbmV0d29yayB3aXRoIGxvdyBsYXRlbmN5LCBi
dXQgaW4gYW4gZW52aXJvbm1lbnQgd2l0aCBoaWdoIFJUVCAoaS5lIDIwbXMpLCB0aGUgcmN2X3du
ZCByZWFsbHkgYmVjb21lcyB0aGUgYm90dGxlbmVjay4gSXQgdG9vayBhcHByb3hpbWF0ZWx5IDYg
KiBSVFQgb24gYXZlcmFnZSBmb3IgNE1pQiB0cmFuc2ZlciBldmVuIHdpdGggbGFyZ2UgaW5pdGlh
bCBzbmRfY3duZC4gSSB0aGluayBhbGxvd2luZyBhIGxhcmdlciBkZWZhdWx0IHJjdl93bmQgd291
bGQgZ3JlYXRseSByZWR1Y2UgdGhlIG51bWJlciBvZiBSVFQgcmVxdWlyZWQgZm9yIHRoZSB0cmFu
c2Zlci4gDQoNCkZyb20gbXkgdW5kZXJzdGFuZGluZywgQlBGX1NPQ0tfT1BTX1JXTkRfSU5JVCB3
YXMgYWRkZWQgdG8gdGhlIGtlcm5lbCB0byBhbGxvdyB0aGUgdXNlcnMgdG8gYnktcGFzcyB0aGUg
ZGVmYXVsdCBpZiB0aGV5IGNob29zZSB0by4gUHJpb3IgdG8ga2VybmVsIDQuMTksIHRoZSByY3Zf
d25kIHNldCB2aWEgQlBGX1NPQ0tfT1BTX1JXTkRfSU5JVCBjb3VsZCBleGNlZWQgNjRLaUIgYW5k
IHVwIHRvIHRoZSBzcGFjZS4gQnV0IHNpbmNlIHRoZW4sIHRoZSBpbml0aWFsIHJ3bmQgd291bGQg
YWx3YXlzIGJlIGxpbWl0ZWQgdG8gdGhlIDY0S2lCLiBUaGlzIHBhdGNoIHdvdWxkIGp1c3QgbWFr
ZSB0aGUga2VybmVsIGJlaGF2ZSBzaW1pbGFybHkgdG8gdGhlIGtlcm5lbCBwcmlvciB0byA0LjE5
IGlmIHJjdl93bmQgaXMgc2V0IGJ5IGVCUEYuIA0KDQpXaGF0IHdvdWxkIHlvdSBzdWdnZXN0IGZv
ciB0aGUgYXBwbGljYXRpb24gdGhhdCBjdXJyZW50bHkgcmVsaWVzIG9uIHNldHRpbmcgYSAibGFy
Z2VyIiByY3Zfd25kIHZpYSBCUEZfU09DS19PUFNfUldORF9JTklULCBkbyB5b3UgdGhpbmsgaWYg
aXQgaXMgYSBiZXR0ZXIgaWRlYSBpZiB0aGUgcmN2X3duZCBpcyBzZXQgYWZ0ZXIgdGhlIGNvbm5l
Y3Rpb24gaXMgZXN0YWJsaXNoZWQuIA0K
