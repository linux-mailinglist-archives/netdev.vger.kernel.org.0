Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A8E69C725
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 10:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjBTJAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 04:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjBTJAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 04:00:45 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E3C1631D;
        Mon, 20 Feb 2023 01:00:15 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 812285FD0A;
        Mon, 20 Feb 2023 12:00:13 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1676883613;
        bh=5kNdYyEYeIWvvkZ9qMM0KnX6zGYYUptfleZqD7jwav8=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=FIPY0dasmHfwaTRO117dCVrFchSNLoo1sjBKXb2GUxn9FrRZH3nAhMry7da5sza6r
         RuI/SJf/TGPWuZ4e7n10sdKOhutpPhA+wMD/PCN+Gue4WWHqxvO05DIAyOvxhaoq8h
         Hda3CvS/Kj3Um3Pv8PGgLY6Lx2ZdLeu/E9AhI47iFeSHG3jlTaWhTnGcLA3icvx7aN
         8aLbRa58nWw4J15VWitmtIueZj/uemIUGhH1hazXx7D3vWDstT0FUc0u+BR36/hx5u
         dtxgncdkKlRm37Ah9m4+oaN7b+8feXVS6vvKF6EfUBaFS72hkXL04hFoTPpE0W9c6H
         +UYG6gpbUrczg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon, 20 Feb 2023 12:00:13 +0300 (MSK)
From:   Krasnov Arseniy <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 01/12] vsock: check error queue to set EPOLLERR
Thread-Topic: [RFC PATCH v1 01/12] vsock: check error queue to set EPOLLERR
Thread-Index: AQHZOfe0xY93Ok9p00a/1VHxin2e2a7RckiAgAX6MAA=
Date:   Mon, 20 Feb 2023 09:00:12 +0000
Message-ID: <d1b4bb5a-26f0-65db-5828-8654ceedae7c@sberdevices.ru>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <17a276d3-1112-3431-2a33-c17f3da67470@sberdevices.ru>
 <20230216134039.rgnb2hnzgme2ve76@sgarzare-redhat>
In-Reply-To: <20230216134039.rgnb2hnzgme2ve76@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3ED9CF40BB112C47B50F702CC2E5BDFC@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/02/20 05:01:00 #20887657
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTYuMDIuMjAyMyAxNjo0MCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBNb24s
IEZlYiAwNiwgMjAyMyBhdCAwNjo1MzoyMkFNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBJZiBzb2NrZXQncyBlcnJvciBxdWV1ZSBpcyBub3QgZW1wdHksIEVQT0xMRVJSIG11c3Qg
YmUgc2V0Lg0KPiANCj4gQ291bGQgdGhpcyBwYXRjaCBnbyByZWdhcmRsZXNzIG9mIHRoaXMgc2Vy
aWVzPw0KPiANCj4gQ2FuIHlvdSBleHBsYWluIChldmVuIGluIHRoZSBjb21taXQgbWVzc2FnZSkg
d2hhdCBoYXBwZW5zIHdpdGhvdXQgdGhpcw0KPiBwYXRjaD8NCg0KU3VyZSEgVGhhbmtzDQoNCj4g
DQo+IFRoYW5rcywNCj4gU3RlZmFubw0KPiANCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBBcnNlbml5
IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4NCj4+IC0tLQ0KPj4gbmV0L3Ztd192
c29jay9hZl92c29jay5jIHwgMiArLQ0KPj4gMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svYWZfdnNv
Y2suYyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KPj4gaW5kZXggMTlhZWE3Y2JhMjZlLi5i
NWU1MWVmNGE3NGMgMTAwNjQ0DQo+PiAtLS0gYS9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCj4+
ICsrKyBiL25ldC92bXdfdnNvY2svYWZfdnNvY2suYw0KPj4gQEAgLTEwMjYsNyArMTAyNiw3IEBA
IHN0YXRpYyBfX3BvbGxfdCB2c29ja19wb2xsKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qgc29j
a2V0ICpzb2NrLA0KPj4gwqDCoMKgwqBwb2xsX3dhaXQoZmlsZSwgc2tfc2xlZXAoc2spLCB3YWl0
KTsNCj4+IMKgwqDCoMKgbWFzayA9IDA7DQo+Pg0KPj4gLcKgwqDCoCBpZiAoc2stPnNrX2VycikN
Cj4+ICvCoMKgwqAgaWYgKHNrLT5za19lcnIgfHwgIXNrYl9xdWV1ZV9lbXB0eV9sb2NrbGVzcygm
c2stPnNrX2Vycm9yX3F1ZXVlKSkNCj4+IMKgwqDCoMKgwqDCoMKgIC8qIFNpZ25pZnkgdGhhdCB0
aGVyZSBoYXMgYmVlbiBhbiBlcnJvciBvbiB0aGlzIHNvY2tldC4gKi8NCj4+IMKgwqDCoMKgwqDC
oMKgIG1hc2sgfD0gRVBPTExFUlI7DQo+Pg0KPj4gLS3CoA0KPj4gMi4yNS4xDQo+IA0KDQo=
