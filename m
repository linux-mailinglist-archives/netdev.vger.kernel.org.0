Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F12357CB64
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbiGUNHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbiGUNHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:07:00 -0400
Received: from m1391.mail.163.com (m1391.mail.163.com [220.181.13.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E00979EFC;
        Thu, 21 Jul 2022 06:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=obU8L
        slTVgOVRla7B6ldzzv4d4CHW/H4Bv5j3Gh3g5g=; b=JDD62z/N2qm7DIRfdy8ED
        vNGeoVz3BqCxukk6uAe1hwNzpXXTyw9aID/GGsnZ/utMNkxBjYhneXta2hFLck5M
        q+tYWgKm7V5nmWnZznQUN3mVmaTy/aeIPKJHxU2S+aZhn0ZRoQiLY01W2O2sqlKc
        zsY1nHSfQ8P1E8xeSS60B8=
Received: from chen45464546$163.com ( [171.221.148.42] ) by
 ajax-webmail-wmsvr91 (Coremail) ; Thu, 21 Jul 2022 21:05:33 +0800 (CST)
X-Originating-IP: [171.221.148.42]
Date:   Thu, 21 Jul 2022 21:05:33 +0800 (CST)
From:   "Chen Lin" <chen45464546@163.com>
To:     "Alexander Duyck" <alexander.duyck@gmail.com>
Cc:     "Maurizio Lombardi" <mlombard@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re:Re: Re: Re: [PATCH V3] mm: prevent page_frag_alloc() from
 corrupting the memory
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <CAKgT0Ueq=9XGW4uySmDj1sa9MYosaF4S6Na_jcVyiofW_TqgwA@mail.gmail.com>
References: <20220715125013.247085-1-mlombard@redhat.com>
 <5a469c5a.8b85.1821171d9de.Coremail.chen45464546@163.com>
 <CAFL455nnc04q8TohH+Qbv36Bo3=KKxMWr=diK_F5Ds5K-h5etw@mail.gmail.com>
 <22bf39a6.8f5e.18211c0898a.Coremail.chen45464546@163.com>
 <CAFL455mXFY5AFOoXxhpUY6EkPzc1677cRPQ8UX-RSykhm_52Nw@mail.gmail.com>
 <CAKgT0Uejy66aFAdD+vMPYFtSu2BWRgTxBG0mO+BLayk3nNuQMw@mail.gmail.com>
 <8a7e9cf.1b9.18218925734.Coremail.chen45464546@163.com>
 <CAKgT0Ueq=9XGW4uySmDj1sa9MYosaF4S6Na_jcVyiofW_TqgwA@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <351f0b3c.b021.18220dd0b35.Coremail.chen45464546@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: W8GowABHuRYdT9lir7Z3AA--.142W
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbB2AhFnmBHLZn2EwAAs9
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

CkF0IDIwMjItMDctMjAgMjI6NTQ6MTgsICJBbGV4YW5kZXIgRHV5Y2siIDxhbGV4YW5kZXIuZHV5
Y2tAZ21haWwuY29tPiB3cm90ZToKPk9uIFR1ZSwgSnVsIDE5LCAyMDIyIGF0IDM6MjcgUE0gQ2hl
biBMaW4gPGNoZW40NTQ2NDU0NkAxNjMuY29tPiB3cm90ZToKPj4KPj4gQXQgMjAyMi0wNy0xOCAy
MzozMzo0MiwgIkFsZXhhbmRlciBEdXljayIgPGFsZXhhbmRlci5kdXlja0BnbWFpbC5jb20+IHdy
b3RlOgo+PiA+T24gTW9uLCBKdWwgMTgsIDIwMjIgYXQgODoyNSBBTSBNYXVyaXppbyBMb21iYXJk
aSA8bWxvbWJhcmRAcmVkaGF0LmNvbT4gd3JvdGU6Cj4+ID4+Cj4+ID4+IHBvIDE4LiA3LiAyMDIy
IHYgMTY6NDAgb2Rlc6iqbGF0ZWwgQ2hlbiBMaW4gPGNoZW40NTQ2NDU0NkAxNjMuY29tPiBuYXBz
YWw6Cj4+ID4+ID4KPj4gPj4gPiBCdXQgdGhlIG9yaWdpbmFsIGludGVudGlvbiBvZiBwYWdlIGZy
YWcgaW50ZXJmYWNlIGlzIGluZGVlZCB0byBhbGxvY2F0ZSBtZW1vcnkKPj4gPj4gPiBsZXNzIHRo
YW4gb25lIHBhZ2UuIEl0J3Mgbm90IGEgZ29vZCBpZGVhIHRvICBjb21wbGljYXRlIHRoZSBkZWZp
bml0aW9uIG9mCj4+ID4+ID4gInBhZ2UgZnJhZ21lbnQiLgo+PiA+Pgo+PiA+PiBJIHNlZSB5b3Vy
IHBvaW50LCBJIGp1c3QgZG9uJ3QgdGhpbmsgaXQgbWFrZXMgbXVjaCBzZW5zZSB0byBicmVhawo+
PiA+PiBkcml2ZXJzIGhlcmUgYW5kIHRoZXJlCj4+ID4+IHdoZW4gYSBwcmFjdGljYWxseSBpZGVu
dGljYWwgMi1saW5lcyBwYXRjaCBjYW4gZml4IHRoZSBtZW1vcnkgY29ycnVwdGlvbiBidWcKPj4g
Pj4gd2l0aG91dCBjaGFuZ2luZyBhIHNpbmdsZSBsaW5lIG9mIGNvZGUgaW4gdGhlIGRyaXZlcnMu
Cj4+ID4+Cj4+ID4+IEJ5IHRoZSB3YXksIEkgd2lsbCB3YWl0IGZvciB0aGUgbWFpbnRhaW5lcnMg
dG8gZGVjaWRlIG9uIHRoZSBtYXR0ZXIuCj4+ID4+Cj4+ID4+IE1hdXJpemlvCj4+ID4KPj4gPkkn
bSBnb29kIHdpdGggdGhpcyBzbWFsbGVyIGFwcHJvYWNoLiBJZiBpdCBmYWlscyBvbmx5IHVuZGVy
IG1lbW9yeQo+PiA+cHJlc3N1cmUgSSBhbSBnb29kIHdpdGggdGhhdC4gVGhlIGlzc3VlIHdpdGgg
dGhlIHN0cmljdGVyIGNoZWNraW5nIGlzCj4+ID50aGF0IGl0IHdpbGwgYWRkIGFkZGl0aW9uYWwg
b3ZlcmhlYWQgdGhhdCBkb2Vzbid0IGFkZCBtdWNoIHZhbHVlIHRvCj4+ID50aGUgY29kZS4KPj4g
Pgo+PiA+VGhhbmtzLAo+PiA+Cj4+Cj4+ID4tIEFsZXgKPj4KPj4gT25lIGFkZGl0aW9uYWwgcXVl
c3Rpb26jugo+PiBJIGRvbid0IHVuZGVyc3RhbmQgdG9vIG11Y2ggYWJvdXQgIHdoeSBwb2ludCA+
o8E8ICBoYXZlIG1vcmUgb3ZlcmhlYWQgdGhhbiBwb2ludCA+QjwuCj4+IEl0IGFsbCBsb29rcyB0
aGUgc2FtZSwgZXhjZXB0IGZvciBqdW1waW5nIHRvIHRoZSByZWZpbGwgcHJvY2VzcywgYW5kIHRo
ZSByZWZpbGwgaXMgYSB2ZXJ5IGxvbmcgcHJvY2Vzcy4KPj4gQ291bGQgeW91IHBsZWFzZSBnaXZl
IG1vcmUgZXhwbGFpbqO/Cj4+Cj4+ICAgICAgICAgaWYgKHVubGlrZWx5KG9mZnNldCA8IDApKSB7
Cj4+ICAgICAgICAgICAgICAgICAgLS0tLS0tLS0tLS0tLS0+o8E8LS0tLS0tLS0tLS0tCj4KPklu
IG9yZGVyIHRvIHZlcmlmeSBpZiB0aGUgZnJhZ3N6IGlzIGxhcmdlciB0aGFuIGEgcGFnZSB3ZSB3
b3VsZCBoYXZlCj50byBhZGQgYSBjb21wYXJpc29uIGJldHdlZW4gdHdvIHZhbHVlcyB0aGF0IGFy
ZW4ndCBuZWNlc3NhcmlseSByZWxhdGVkCj50byBhbnl0aGluZyBlbHNlIGluIHRoaXMgYmxvY2sg
b2YgY29kZS4KPgo+QWRkaW5nIGEgY29tcGFyaXNvbiBhdCB0aGlzIHBvaW50IHNob3VsZCBlbmQg
dXAgYWRkaW5nIGluc3RydWN0aW9ucwo+YWxvbmcgdGhlIGxpbmVzIG9mCj4gICAgICAgIGNtcCAk
MHgxMDAwLCVbc29tZSByZWdpc3Rlcl0KPiAgICAgICAgamcgPHJldHVybiBOVUxMIGJsb2NrPgo+
Cj5UaGVzZSB0d28gbGluZXMgd291bGQgZW5kIHVwIGFwcGx5aW5nIHRvIGV2ZXJ5dGhpbmcgdGhh
dCB0YWtlcyB0aGlzCj5wYXRoIHNvIGV2ZXJ5IHRpbWUgd2UgaGl0IHRoZSBlbmQgb2YgYSBwYWdl
IHdlIHdvdWxkIGVuY291bnRlciBpdCwgYW5kCj5pbiBhbG1vc3QgYWxsIGNhc2VzIGl0IHNob3Vs
ZG4ndCBhcHBseSBzbyBpdCBpcyBleHRyYSBpbnN0cnVjdGlvbnMuIEluCj5hZGRpdGlvbiB0aGV5
IHdvdWxkIGJlIHNlcmlhbGl6ZWQgd2l0aCB0aGUgZWFybGllciBzdWJ0cmFjdGlvbiBzaW5jZQo+
d2UgY2FuJ3QgcHJvY2VzcyBpdCB1bnRpbCBhZnRlciB0aGUgZmlyc3QgY29tcGFyaXNvbiB3aGlj
aCBpcyBhY3R1YWxseQo+dXNpbmcgdGhlIGZsYWdzIHRvIHBlcmZvcm0gdGhlIGNoZWNrIHNpbmNl
IGl0IGlzIGNoZWNraW5nIGlmIG9mZnNldCBpcwo+c2lnbmVkLgo+Cj4+ICAgICAgICAgICAgICAg
ICBwYWdlID0gdmlydF90b19wYWdlKG5jLT52YSk7Cj4+Cj4+ICAgICAgICAgICAgICAgICBpZiAo
IXBhZ2VfcmVmX3N1Yl9hbmRfdGVzdChwYWdlLCBuYy0+cGFnZWNudF9iaWFzKSkKPj4gICAgICAg
ICAgICAgICAgICAgICAgICAgZ290byByZWZpbGw7Cj4+Cj4+ICAgICAgICAgICAgICAgICBpZiAo
dW5saWtlbHkobmMtPnBmbWVtYWxsb2MpKSB7Cj4+ICAgICAgICAgICAgICAgICAgICAgICAgIGZy
ZWVfdGhlX3BhZ2UocGFnZSwgY29tcG91bmRfb3JkZXIocGFnZSkpOwo+PiAgICAgICAgICAgICAg
ICAgICAgICAgICBnb3RvIHJlZmlsbDsKPj4gICAgICAgICAgICAgICAgIH0KPj4KPj4gI2lmIChQ
QUdFX1NJWkUgPCBQQUdFX0ZSQUdfQ0FDSEVfTUFYX1NJWkUpCj4+ICAgICAgICAgICAgICAgICAv
KiBpZiBzaXplIGNhbiB2YXJ5IHVzZSBzaXplIGVsc2UganVzdCB1c2UgUEFHRV9TSVpFICovCj4+
ICAgICAgICAgICAgICAgICBzaXplID0gbmMtPnNpemU7Cj4+ICNlbmRpZgo+PiAgICAgICAgICAg
ICAgICAgLyogT0ssIHBhZ2UgY291bnQgaXMgMCwgd2UgY2FuIHNhZmVseSBzZXQgaXQgKi8KPj4g
ICAgICAgICAgICAgICAgIHNldF9wYWdlX2NvdW50KHBhZ2UsIFBBR0VfRlJBR19DQUNIRV9NQVhf
U0laRSArIDEpOwo+Pgo+PiAgICAgICAgICAgICAgICAgLyogcmVzZXQgcGFnZSBjb3VudCBiaWFz
IGFuZCBvZmZzZXQgdG8gc3RhcnQgb2YgbmV3IGZyYWcgKi8KPj4gICAgICAgICAgICAgICAgIG5j
LT5wYWdlY250X2JpYXMgPSBQQUdFX0ZSQUdfQ0FDSEVfTUFYX1NJWkUgKyAxOwo+PiAgICAgICAg
ICAgICAgICAgb2Zmc2V0ID0gc2l6ZSAtIGZyYWdzejsKPj4gICAgICAgICAgICAgICAgICAtLS0t
LS0tLS0tLS0tLT5CPC0tLS0tLS0tLS0tLQo+Cj5BdCB0aGlzIHBvaW50IHdlIGhhdmUgYWxyZWFk
eSBleGNsdWRlZCB0aGUgc2hhcmVkIGFuZCBwZm1lbWFsbG9jCj5wYWdlcy4gSGVyZSB3ZSBkb24n
dCBoYXZlIHRvIGFkZCBhIGNvbXBhcmlzb24uIFRoZSBjb21wYXJpc29uIGlzCj5hbHJlYWR5IGhh
bmRsZWQgdmlhIHRoZSBzaXplIC0gZnJhZ3N6LCB3ZSBqdXN0IG5lZWQgdG8gbWFrZSB1c2Ugb2Yg
dGhlCj5mbGFncyBmb2xsb3dpbmcgdGhlIG9wZXJhdGlvbiBieSBjaGVja2luZyB0byBzZWUgaWYg
b2Zmc2V0IGlzIHNpZ25lZC4KPgo+U28gdGhlIGFkZGVkIGFzc2VtYmxlciB3b3VsZCBiZSBzb21l
dGhpbmcgdG8gdGhlIGVmZmVjdCBvZjoKPiAgICAgICAganMgPHJldHVybiBOVUxMIGJsb2NrPgo+
Cj5JbiBhZGRpdGlvbiB0aGUgYXNzaWdubWVudCBvcGVyYXRpb25zIHRoZXJlIHNob3VsZCBoYXZl
IG5vIGVmZmVjdCBvbgo+dGhlIGZsYWdzIHNvIHRoZSBqcyBjYW4gYmUgYWRkZWQgdG8gdGhlIGVu
ZCBvZiB0aGUgYmxvY2sgd2l0aG91dAo+aGF2aW5nIHRvIGRvIG11Y2ggaW4gdGVybXMgb2YgZm9y
Y2luZyBhbnkgcmVvcmRlcmluZyBvZiB0aGUKPmluc3RydWN0aW9ucy4KClRoYW5rIHlvdSBmb3Ig
eW91ciBkZXRhaWxlZCBleHBsYW5hdGlvbiwgSSBnZXQgaXQuCkkgb2JqZHVtcCB0aGUgdm1saW51
eCBvbiBkaWZmZXJlbnQgbW9kaWZpZWQgdmVyc2lvbnMgYW5kIHZlcmlmaWVkIHRoYXQgCnRoZSBn
ZW5lcmF0ZWQgaW5zdHJ1Y3Rpb25zIGFyZSB0aGUgc2FtZSBhcyB3aGF0IHlvdSBzYWlkLiAKClVu
ZGVyIHRoZSBzdHJpY3QgcGVyZm9ybWFuY2UgcmVxdWlyZW1lbnRzLCB0aGVyZSBzZWVtcyBubyBi
ZXR0ZXIgd2F5CnRoYW4gdGhlIHBhdGNoIE1hdXJpemlvIHByb3Bvc2VkLgo=
