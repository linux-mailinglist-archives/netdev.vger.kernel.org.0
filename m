Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3982657A9CF
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 00:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbiGSW2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 18:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238262AbiGSW2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 18:28:07 -0400
Received: from m1322.mail.163.com (m1322.mail.163.com [220.181.13.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CD4B54640;
        Tue, 19 Jul 2022 15:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=+15mK
        BPYs1qBfs6/EfK1JusOug9HlD34zW4LwUmpuFc=; b=nbLKuWZWHlbWeTwN/TJd+
        Qi8+TmbVUljnMllD3kfgGfP0kryw0Q6cNPb6vDpyG+5bt2nRZ8tnJ//5aLoFGuth
        k/nVmCqV5ZeBZCQv1yeraxrs2ASo+zoPeZJznAAYnxPhH45cK1bbxTCSH0rKYF6r
        hMQJzMuIGWrCJaRT9J0njY=
Received: from chen45464546$163.com ( [171.221.148.42] ) by
 ajax-webmail-wmsvr22 (Coremail) ; Wed, 20 Jul 2022 06:27:00 +0800 (CST)
X-Originating-IP: [171.221.148.42]
Date:   Wed, 20 Jul 2022 06:27:00 +0800 (CST)
From:   "Chen Lin" <chen45464546@163.com>
To:     "Alexander Duyck" <alexander.duyck@gmail.com>
Cc:     "Maurizio Lombardi" <mlombard@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re:Re: Re: [PATCH V3] mm: prevent page_frag_alloc() from corrupting
 the memory
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <CAKgT0Uejy66aFAdD+vMPYFtSu2BWRgTxBG0mO+BLayk3nNuQMw@mail.gmail.com>
References: <20220715125013.247085-1-mlombard@redhat.com>
 <5a469c5a.8b85.1821171d9de.Coremail.chen45464546@163.com>
 <CAFL455nnc04q8TohH+Qbv36Bo3=KKxMWr=diK_F5Ds5K-h5etw@mail.gmail.com>
 <22bf39a6.8f5e.18211c0898a.Coremail.chen45464546@163.com>
 <CAFL455mXFY5AFOoXxhpUY6EkPzc1677cRPQ8UX-RSykhm_52Nw@mail.gmail.com>
 <CAKgT0Uejy66aFAdD+vMPYFtSu2BWRgTxBG0mO+BLayk3nNuQMw@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <8a7e9cf.1b9.18218925734.Coremail.chen45464546@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: FsGowAAn5ji0L9di21xQAA--.22583W
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbBdghDnmDkn-vhVAABs3
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

QXQgMjAyMi0wNy0xOCAyMzozMzo0MiwgIkFsZXhhbmRlciBEdXljayIgPGFsZXhhbmRlci5kdXlj
a0BnbWFpbC5jb20+IHdyb3RlOgo+T24gTW9uLCBKdWwgMTgsIDIwMjIgYXQgODoyNSBBTSBNYXVy
aXppbyBMb21iYXJkaSA8bWxvbWJhcmRAcmVkaGF0LmNvbT4gd3JvdGU6Cj4+Cj4+IHBvIDE4LiA3
LiAyMDIyIHYgMTY6NDAgb2Rlc6iqbGF0ZWwgQ2hlbiBMaW4gPGNoZW40NTQ2NDU0NkAxNjMuY29t
PiBuYXBzYWw6Cj4+ID4KPj4gPiBCdXQgdGhlIG9yaWdpbmFsIGludGVudGlvbiBvZiBwYWdlIGZy
YWcgaW50ZXJmYWNlIGlzIGluZGVlZCB0byBhbGxvY2F0ZSBtZW1vcnkKPj4gPiBsZXNzIHRoYW4g
b25lIHBhZ2UuIEl0J3Mgbm90IGEgZ29vZCBpZGVhIHRvICBjb21wbGljYXRlIHRoZSBkZWZpbml0
aW9uIG9mCj4+ID4gInBhZ2UgZnJhZ21lbnQiLgo+Pgo+PiBJIHNlZSB5b3VyIHBvaW50LCBJIGp1
c3QgZG9uJ3QgdGhpbmsgaXQgbWFrZXMgbXVjaCBzZW5zZSB0byBicmVhawo+PiBkcml2ZXJzIGhl
cmUgYW5kIHRoZXJlCj4+IHdoZW4gYSBwcmFjdGljYWxseSBpZGVudGljYWwgMi1saW5lcyBwYXRj
aCBjYW4gZml4IHRoZSBtZW1vcnkgY29ycnVwdGlvbiBidWcKPj4gd2l0aG91dCBjaGFuZ2luZyBh
IHNpbmdsZSBsaW5lIG9mIGNvZGUgaW4gdGhlIGRyaXZlcnMuCj4+Cj4+IEJ5IHRoZSB3YXksIEkg
d2lsbCB3YWl0IGZvciB0aGUgbWFpbnRhaW5lcnMgdG8gZGVjaWRlIG9uIHRoZSBtYXR0ZXIuCj4+
Cj4+IE1hdXJpemlvCj4KPkknbSBnb29kIHdpdGggdGhpcyBzbWFsbGVyIGFwcHJvYWNoLiBJZiBp
dCBmYWlscyBvbmx5IHVuZGVyIG1lbW9yeQo+cHJlc3N1cmUgSSBhbSBnb29kIHdpdGggdGhhdC4g
VGhlIGlzc3VlIHdpdGggdGhlIHN0cmljdGVyIGNoZWNraW5nIGlzCj50aGF0IGl0IHdpbGwgYWRk
IGFkZGl0aW9uYWwgb3ZlcmhlYWQgdGhhdCBkb2Vzbid0IGFkZCBtdWNoIHZhbHVlIHRvCj50aGUg
Y29kZS4KPgo+VGhhbmtzLAo+Cgo+LSBBbGV4CgpPbmUgYWRkaXRpb25hbCBxdWVzdGlvbqO6Ckkg
ZG9uJ3QgdW5kZXJzdGFuZCB0b28gbXVjaCBhYm91dCAgd2h5IHBvaW50ID6jwTwgIGhhdmUgbW9y
ZSBvdmVyaGVhZCB0aGFuIHBvaW50ID5CPC4gCkl0IGFsbCBsb29rcyB0aGUgc2FtZSwgZXhjZXB0
IGZvciBqdW1waW5nIHRvIHRoZSByZWZpbGwgcHJvY2VzcywgYW5kIHRoZSByZWZpbGwgaXMgYSB2
ZXJ5IGxvbmcgcHJvY2Vzcy4KQ291bGQgeW91IHBsZWFzZSBnaXZlIG1vcmUgZXhwbGFpbqO/CgoJ
aWYgKHVubGlrZWx5KG9mZnNldCA8IDApKSB7CiAgICAgICAgICAgICAgICAgLS0tLS0tLS0tLS0t
LS0+o8E8LS0tLS0tLS0tLS0tCgkJcGFnZSA9IHZpcnRfdG9fcGFnZShuYy0+dmEpOwoKCQlpZiAo
IXBhZ2VfcmVmX3N1Yl9hbmRfdGVzdChwYWdlLCBuYy0+cGFnZWNudF9iaWFzKSkKCQkJZ290byBy
ZWZpbGw7CgoJCWlmICh1bmxpa2VseShuYy0+cGZtZW1hbGxvYykpIHsKCQkJZnJlZV90aGVfcGFn
ZShwYWdlLCBjb21wb3VuZF9vcmRlcihwYWdlKSk7CgkJCWdvdG8gcmVmaWxsOwoJCX0KCiNpZiAo
UEFHRV9TSVpFIDwgUEFHRV9GUkFHX0NBQ0hFX01BWF9TSVpFKQoJCS8qIGlmIHNpemUgY2FuIHZh
cnkgdXNlIHNpemUgZWxzZSBqdXN0IHVzZSBQQUdFX1NJWkUgKi8KCQlzaXplID0gbmMtPnNpemU7
CiNlbmRpZgoJCS8qIE9LLCBwYWdlIGNvdW50IGlzIDAsIHdlIGNhbiBzYWZlbHkgc2V0IGl0ICov
CgkJc2V0X3BhZ2VfY291bnQocGFnZSwgUEFHRV9GUkFHX0NBQ0hFX01BWF9TSVpFICsgMSk7CgoJ
CS8qIHJlc2V0IHBhZ2UgY291bnQgYmlhcyBhbmQgb2Zmc2V0IHRvIHN0YXJ0IG9mIG5ldyBmcmFn
ICovCgkJbmMtPnBhZ2VjbnRfYmlhcyA9IFBBR0VfRlJBR19DQUNIRV9NQVhfU0laRSArIDE7CgkJ
b2Zmc2V0ID0gc2l6ZSAtIGZyYWdzejsKICAgICAgICAgICAgICAgICAtLS0tLS0tLS0tLS0tLT5C
PC0tLS0tLS0tLS0tLQoJfQoK
