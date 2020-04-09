Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE6CF1A38CE
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgDIRSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:18:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33328 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgDIRSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 13:18:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 123FC128B3890;
        Thu,  9 Apr 2020 10:18:45 -0700 (PDT)
Date:   Thu, 09 Apr 2020 10:18:44 -0700 (PDT)
Message-Id: <20200409.101844.1655988786538703860.davem@davemloft.net>
To:     keitasuzuki.park@sslab.ics.keio.ac.jp
Cc:     takafumi.kubota1012@sslab.ics.keio.ac.jp, kuba@kernel.org,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfp: Fix memory leak in nfp_resource_acquire()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200409150210.15488-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
References: <20200409150210.15488-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Apr 2020 10:18:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS2VpdGEgU3V6dWtpIDxrZWl0YXN1enVraS5wYXJrQHNzbGFiLmljcy5rZWlvLmFjLmpw
Pg0KRGF0ZTogVGh1LCAgOSBBcHIgMjAyMCAxNTowMjowNyArMDAwMA0KDQo+IFRoaXMgcGF0Y2gg
Zml4ZXMgYSBtZW1vcnkgbGVhayBpbiBuZnBfcmVzb3VyY2VfYWNxdWlyZSgpLiByZXMtPm11dGV4
IGlzDQo+IGFsbGxvY2F0ZWQgaW4gbmZwX3Jlc291cmNlX3RyeV9hY3F1aXJlKCkuIEhvd2V2ZXIs
IHdoZW4NCj4gbXNsZWVwX2ludGVycnVwdGlibGUoKSBvciB0aW1lX2lzX2JlZm9yZV9lcV9qaWZm
aWVzKCkgZmFpbHMsIGl0IGZhbGxzDQo+IGludG8gZXJyX2ZhaWxzIHBhdGggd2hlcmUgcmVzIGlz
IGZyZWVkLCBidXQgcmVzLT5tdXRleCBpcyBub3QuDQo+IA0KPiBGaXggdGhpcyBieSBjaGFuZ2lu
ZyBjYWxsIHRvIGZyZWUgdG8gbmZwX3Jlc291cmNlX3JlbGVhc2UoKS4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEtlaXRhIFN1enVraSA8a2VpdGFzdXp1a2kucGFya0Bzc2xhYi5pY3Mua2Vpby5hYy5q
cD4NCg0KRGlkIHlvdSB0ZXN0IGNvbXBpbGUgdGhpcz8NCg0KZHJpdmVycy9uZXQvZXRoZXJuZXQv
bmV0cm9ub21lL25mcC9uZnBjb3JlL25mcF9yZXNvdXJjZS5jOiBJbiBmdW5jdGlvbiChbmZwX3Jl
c291cmNlX2FjcXVpcmWiOg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvbmV0cm9ub21lL25mcC9uZnBj
b3JlL25mcF9yZXNvdXJjZS5jOjIwMzoyOiBlcnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2Yg
ZnVuY3Rpb24goW5mcF9yZXNvdXJjZV9yZWxhc2WiOyBkaWQgeW91IG1lYW4goW5mcF9yZXNvdXJj
ZV9yZWxlYXNloj8gWy1XZXJyb3I9aW1wbGljaXQtZnVuY3Rpb24tZGVjbGFyYXRpb25dDQogIG5m
cF9yZXNvdXJjZV9yZWxhc2UocmVzKTsNCiAgXn5+fn5+fn5+fn5+fn5+fn5+fg0KICBuZnBfcmVz
b3VyY2VfcmVsZWFzZQ0KDQpBbmQgdGhpcyBtYWtlcyBtZSBmZWVsIGxpa2UgdGhlIHRlc3Qgd2Fz
IG5vdCBydW50aW1lIHRlc3RlZCBlaXRoZXIuDQo=
