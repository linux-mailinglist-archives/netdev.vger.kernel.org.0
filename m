Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9E35BC194
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 05:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiISDBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 23:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiISDBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 23:01:01 -0400
Received: from m1564.mail.126.com (m1564.mail.126.com [220.181.15.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4D4519C03
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 20:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=LRvb6
        NkRQyBwNQ+Uuqmva/zhNla81+bf+eL/QndGha4=; b=GNSr1qdJ3hJfmcp1dB2yS
        zGQYaw6M3KAoAVDBi2xGyyhAcAS7GjqFB+eUmsJ/9evq4foqYVTeQo2sLZ/O1gIl
        zdil3/5lC40KhHvFNQ+U2ntym0NyX5Nh8TVO1V1aat0amMcSwJ1obM1XxKOgJecy
        ubq+lpMnHYnc4dmGBCjdHk=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr64
 (Coremail) ; Mon, 19 Sep 2022 11:00:29 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Mon, 19 Sep 2022 11:00:29 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "David Ahern" <dsahern@kernel.org>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re:Re: [PATCH] ipv4: ping: Fix potential use-after-free bug
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <69a43dc8-c545-1187-7185-4b85215b726d@kernel.org>
References: <20220916100727.4096852-1-windhl@126.com>
 <69a43dc8-c545-1187-7185-4b85215b726d@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <4c3486e8.26e6.18353b0a836.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: QMqowAC3v3NP2ydjVqlyAA--.2451W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbiuBeBF2JVlcEd+wABs9
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpBdCAyMDIyLTA5LTE4IDIzOjMwOjIxLCAiRGF2aWQgQWhlcm4iIDxkc2FoZXJuQGtlcm5lbC5v
cmc+IHdyb3RlOgo+T24gOS8xNi8yMiA0OjA3IEFNLCBMaWFuZyBIZSB3cm90ZToKPj4gSW4gcGlu
Z191bmhhc2goKSwgd2Ugc2hvdWxkIG1vdmUgc29ja19wdXQoc2spIGFmdGVyIGFueSBwb3NzaWJs
ZQo+PiBhY2Nlc3MgcG9pbnQgYXMgdGhlIHB1dCBmdW5jdGlvbiBtYXkgZnJlZSB0aGUgb2JqZWN0
Lgo+Cj51bmhhc2ggaGFuZGxlcnMgYXJlIGNhbGxlZCBmcm9tIHNrX2NvbW1vbl9yZWxlYXNlIHdo
aWNoIHN0aWxsIGhhcyBhCj5yZWZlcmVuY2Ugb24gdGhlIHNvY2ssIHNvIG5vdCByZWFsbHkgZ29p
bmcgdG8gaGl0IGEgVUFGLgo+CgpUaGFua3MgZm9yIHRoaXMgdmFsdWFibGUgbGVzc29uLgoKPkkg
ZG8gYWdyZWUgdGhhdCBpdCBkb2VzIG5vdCByZWFkIGNvcnJlY3RseSB0byAncHV0JyBhIHJlZmVy
ZW5jZSB0aGVuCj5jb250aW51ZSB1c2luZyB0aGUgb2JqZWN0LiBpZS4sIHRoZSBwdXQgc2hvdWxk
IGJlIG1vdmVkIHRvIHRoZSBlbmQgbGlrZQo+eW91IGhhdmUgaGVyZS4gVGhpcyBpcyBtb3JlIG9m
IGEgdGlkaW5lc3MgZXhlcmNpc2UgdGhhbiBhIG5lZWQgdG8KPmJhY2twb3J0IHRvIHN0YWJsZSBr
ZXJuZWxzLgo+CgpPSywgdGhhbmtzLgoKPj4gCj4+IEZpeGVzOiBjMzE5YjRkNzZiOWUgKCJuZXQ6
IGlwdjQ6IGFkZCBJUFBST1RPX0lDTVAgc29ja2V0IGtpbmQiKQo+PiBTaWduZWQtb2ZmLWJ5OiBM
aWFuZyBIZSA8d2luZGhsQDEyNi5jb20+Cj4+IC0tLQo+PiAKPj4gIEkgaGF2ZSBmb3VuZCBvdGhl
ciBwbGFjZXMgY29udGFpbmluZyBzaW1pbGFyIGNvZGUgcGF0dGVybnMuCj4+IAo+PiAgbmV0L2lw
djQvcGluZy5jIHwgMiArLQo+PiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pCj4+IAo+PiBkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvcGluZy5jIGIvbmV0L2lwdjQv
cGluZy5jCj4+IGluZGV4IGI4M2MyYmQ5ZDcyMi4uZjkwYzg2ZDM3ZmZjIDEwMDY0NAo+PiAtLS0g
YS9uZXQvaXB2NC9waW5nLmMKPj4gKysrIGIvbmV0L2lwdjQvcGluZy5jCj4+IEBAIC0xNTcsMTAg
KzE1NywxMCBAQCB2b2lkIHBpbmdfdW5oYXNoKHN0cnVjdCBzb2NrICpzaykKPj4gIAlzcGluX2xv
Y2soJnBpbmdfdGFibGUubG9jayk7Cj4+ICAJaWYgKHNrX2hhc2hlZChzaykpIHsKPj4gIAkJaGxp
c3RfbnVsbHNfZGVsX2luaXRfcmN1KCZzay0+c2tfbnVsbHNfbm9kZSk7Cj4+IC0JCXNvY2tfcHV0
KHNrKTsKPj4gIAkJaXNrLT5pbmV0X251bSA9IDA7Cj4+ICAJCWlzay0+aW5ldF9zcG9ydCA9IDA7
Cj4+ICAJCXNvY2tfcHJvdF9pbnVzZV9hZGQoc29ja19uZXQoc2spLCBzay0+c2tfcHJvdCwgLTEp
Owo+PiArCQlzb2NrX3B1dChzayk7Cj4+ICAJfQo+PiAgCXNwaW5fdW5sb2NrKCZwaW5nX3RhYmxl
LmxvY2spOwo+PiAgfQo=
