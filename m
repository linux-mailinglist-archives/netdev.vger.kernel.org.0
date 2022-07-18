Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA6C578366
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbiGRNPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbiGRNPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:15:04 -0400
Received: from m1373.mail.163.com (m1373.mail.163.com [220.181.13.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BEC16316;
        Mon, 18 Jul 2022 06:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=Q7weu
        vua13CV5ZC6aiIAss6kpEeQXj4br9mWW0EalhM=; b=NVOMNELKadbjexMKENDyZ
        +/WYIsZ5NI/YLQOVdWQqTJfq0DaABRPWLckfrxixBvS1jlY/DqIO/iRW92+MRKJo
        +KGT1pO5GbogFlU39O4hypA2HN8qNkwLF6yBZeKshdDVocfOSX2nTvtFw6k5THz8
        pKLa4OHsvcvTXe/GImGllo=
Received: from chen45464546$163.com ( [171.221.148.42] ) by
 ajax-webmail-wmsvr73 (Coremail) ; Mon, 18 Jul 2022 21:14:10 +0800 (CST)
X-Originating-IP: [171.221.148.42]
Date:   Mon, 18 Jul 2022 21:14:10 +0800 (CST)
From:   "Chen Lin" <chen45464546@163.com>
To:     "Maurizio Lombardi" <mlombard@redhat.com>
Cc:     alexander.duyck@gmail.com, kuba@kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re:[PATCH V3] mm: prevent page_frag_alloc() from corrupting the
 memory
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <20220715125013.247085-1-mlombard@redhat.com>
References: <20220715125013.247085-1-mlombard@redhat.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <5a469c5a.8b85.1821171d9de.Coremail.chen45464546@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: ScGowABnEwOiXNVi5dtUAA--.1594W
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbB2ApCnmBHLXpjqQAAs0
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXQgMjAyMi0wNy0xNSAyMDo1MDoxMywgIk1hdXJpemlvIExvbWJhcmRpIiA8bWxvbWJhcmRAcmVk
aGF0LmNvbT4gd3JvdGU6Cj5BIG51bWJlciBvZiBkcml2ZXJzIGNhbGwgcGFnZV9mcmFnX2FsbG9j
KCkgd2l0aCBhCj5mcmFnbWVudCdzIHNpemUgPiBQQUdFX1NJWkUuCj5JbiBsb3cgbWVtb3J5IGNv
bmRpdGlvbnMsIF9fcGFnZV9mcmFnX2NhY2hlX3JlZmlsbCgpIG1heSBmYWlsIHRoZSBvcmRlciAz
Cj5jYWNoZSBhbGxvY2F0aW9uIGFuZCBmYWxsIGJhY2sgdG8gb3JkZXIgMDsKPkluIHRoaXMgY2Fz
ZSwgdGhlIGNhY2hlIHdpbGwgYmUgc21hbGxlciB0aGFuIHRoZSBmcmFnbWVudCwgY2F1c2luZwo+
bWVtb3J5IGNvcnJ1cHRpb25zLgo+Cj5QcmV2ZW50IHRoaXMgZnJvbSBoYXBwZW5pbmcgYnkgY2hl
Y2tpbmcgaWYgdGhlIG5ld2x5IGFsbG9jYXRlZCBjYWNoZQo+aXMgbGFyZ2UgZW5vdWdoIGZvciB0
aGUgZnJhZ21lbnQ7IGlmIG5vdCwgdGhlIGFsbG9jYXRpb24gd2lsbCBmYWlsCj5hbmQgcGFnZV9m
cmFnX2FsbG9jKCkgd2lsbCByZXR1cm4gTlVMTC4KPgo+VjI6IGRvIG5vdCBmcmVlIHRoZSBjYWNo
ZSBwYWdlIGJlY2F1c2UgdGhpcyBjb3VsZCBtYWtlIG1lbW9yeSBwcmVzc3VyZQo+ZXZlbiB3b3Jz
ZSwganVzdCByZXR1cm4gTlVMTC4KPgo+VjM6IGFkZCBhIGNvbW1lbnQgdG8gZXhwbGFpbiB3aHkg
d2UgcmV0dXJuIE5VTEwuCj4KPlNpZ25lZC1vZmYtYnk6IE1hdXJpemlvIExvbWJhcmRpIDxtbG9t
YmFyZEByZWRoYXQuY29tPgo+LS0tCj4gbW0vcGFnZV9hbGxvYy5jIHwgMTIgKysrKysrKysrKysr
Cj4gMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykKPgo+ZGlmZiAtLWdpdCBhL21tL3Bh
Z2VfYWxsb2MuYyBiL21tL3BhZ2VfYWxsb2MuYwo+aW5kZXggZTAwOGEzZGYwNDg1Li41OWM0ZGRk
ZjM3OWYgMTAwNjQ0Cj4tLS0gYS9tbS9wYWdlX2FsbG9jLmMKPisrKyBiL21tL3BhZ2VfYWxsb2Mu
Ywo+QEAgLTU2MTcsNiArNTYxNywxOCBAQCB2b2lkICpwYWdlX2ZyYWdfYWxsb2NfYWxpZ24oc3Ry
dWN0IHBhZ2VfZnJhZ19jYWNoZSAqbmMsCj4gCQkvKiByZXNldCBwYWdlIGNvdW50IGJpYXMgYW5k
IG9mZnNldCB0byBzdGFydCBvZiBuZXcgZnJhZyAqLwo+IAkJbmMtPnBhZ2VjbnRfYmlhcyA9IFBB
R0VfRlJBR19DQUNIRV9NQVhfU0laRSArIDE7Cj4gCQlvZmZzZXQgPSBzaXplIC0gZnJhZ3N6Owo+
KwkJaWYgKHVubGlrZWx5KG9mZnNldCA8IDApKSB7Cj4rCQkJLyoKPisJCQkgKiBUaGUgY2FsbGVy
IGlzIHRyeWluZyB0byBhbGxvY2F0ZSBhIGZyYWdtZW50Cj4rCQkJICogd2l0aCBmcmFnc3ogPiBQ
QUdFX1NJWkUgYnV0IHRoZSBjYWNoZSBpc24ndCBiaWcKPisJCQkgKiBlbm91Z2ggdG8gc2F0aXNm
eSB0aGUgcmVxdWVzdCwgdGhpcyBtYXkKPisJCQkgKiBoYXBwZW4gaW4gbG93IG1lbW9yeSBjb25k
aXRpb25zLgo+KwkJCSAqIFdlIGRvbid0IHJlbGVhc2UgdGhlIGNhY2hlIHBhZ2UgYmVjYXVzZQo+
KwkJCSAqIGl0IGNvdWxkIG1ha2UgbWVtb3J5IHByZXNzdXJlIHdvcnNlCj4rCQkJICogc28gd2Ug
c2ltcGx5IHJldHVybiBOVUxMIGhlcmUuCj4rCQkJICovCj4rCQkJcmV0dXJuIE5VTEw7Cj4rCQl9
Cj4gCX0KPiAKPiAJbmMtPnBhZ2VjbnRfYmlhcy0tOwo+LS0gCj4yLjMxLjEKCldpbGwgIHRoaXMg
bGVhZCB0byBtZW1vcnkgbGVhayB3aGVuIGRldmljZSBkcml2ZXIgbWlzcyB1c2UgdGhpcyBpbnRl
cmZhY2UgbXV0aS10aW1lc6O/CgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tCklmIHdlIGNhbiBhY2NlcHQgYWRkaW5nIGEgYnJhbmNoIHRvIHRoaXMgcHJvY2Vzcywgd2h5
IG5vdCBhZGQgaXQgYXQgdGhlIGJlZ2lubmluZyBsaWtlIGJlbG93PwpUaGUgYmVsb3cgY2hhbmdl
cyBhcmUgYWxzbyBtb3JlIGluIGxpbmUgd2l0aCB0aGUgZGVmaW5pdGlvbiBvZiAicGFnZSBmcmFn
bWVudCIsIAp3aGljaCBpIG1lYW4gdGhlIGFib3ZlIGNoYW5nZXMgbWF5IG1ha2UgdGhlIGFsbG9j
YXRpb24gb2YgbW9yZSB0aGFuIG9uZSBwYWdlIHN1Y2Nlc3NmdWwuCgppbmRleCA3YTI4ZjdkLi45
ZDA5ZWE1IDEwMDY0NAotLS0gYS9tbS9wYWdlX2FsbG9jLmMKKysrIGIvbW0vcGFnZV9hbGxvYy5j
CkBAIC01NTUxLDYgKzU1NTEsOCBAQCB2b2lkICpwYWdlX2ZyYWdfYWxsb2NfYWxpZ24oc3RydWN0
IHBhZ2VfZnJhZ19jYWNoZSAqbmMsCgogICAgICAgIG9mZnNldCA9IG5jLT5vZmZzZXQgLSBmcmFn
c3o7CiAgICAgICAgaWYgKHVubGlrZWx5KG9mZnNldCA8IDApKSB7CisgICAgICAgICAgICAgICBp
ZiAodW5saWtlbHkoZnJhZ3N6ID4gUEFHRV9TSVpFKSkKKyAgICAgICAgICAgICAgICAgICAgICAg
cmV0dXJuIE5VTEw7CiAgICAgICAgICAgICAgICBwYWdlID0gdmlydF90b19wYWdlKG5jLT52YSk7
CgogICAgICAgICAgICAgICAgaWYgKCFwYWdlX3JlZl9zdWJfYW5kX3Rlc3QocGFnZSwgbmMtPnBh
Z2VjbnRfYmlhcykpCgo=
