Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA295785A0
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 16:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiGROkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 10:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGROkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 10:40:40 -0400
Received: from m1373.mail.163.com (m1373.mail.163.com [220.181.13.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A77DD1F2F8;
        Mon, 18 Jul 2022 07:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=34DID
        9/3/C/yNi8IrBRnK49soxFVrG4+0TxfPot0gxs=; b=jk48i6p3vqnpUcH/vr+lV
        JRHcfM0nImzVMVBhOwuJSLc3SfccSJhFuBI5ff1KKyIxqiNUDHqM/eZRjzgVwvQE
        sJqbqkB2jlMpH55vv+LgkJ4DgfAdtJ3GmglWUOEoh2sjp1Fzae7j+DGVntKY2NEN
        ZrlDEiwlONJp/jHL7HhDWM=
Received: from chen45464546$163.com ( [171.221.148.42] ) by
 ajax-webmail-wmsvr73 (Coremail) ; Mon, 18 Jul 2022 22:40:07 +0800 (CST)
X-Originating-IP: [171.221.148.42]
Date:   Mon, 18 Jul 2022 22:40:07 +0800 (CST)
From:   "Chen Lin" <chen45464546@163.com>
To:     "Maurizio Lombardi" <mlombard@redhat.com>
Cc:     "Alexander Duyck" <alexander.duyck@gmail.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re:Re: [PATCH V3] mm: prevent page_frag_alloc() from corrupting the
 memory
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <CAFL455nnc04q8TohH+Qbv36Bo3=KKxMWr=diK_F5Ds5K-h5etw@mail.gmail.com>
References: <20220715125013.247085-1-mlombard@redhat.com>
 <5a469c5a.8b85.1821171d9de.Coremail.chen45464546@163.com>
 <CAFL455nnc04q8TohH+Qbv36Bo3=KKxMWr=diK_F5Ds5K-h5etw@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <22bf39a6.8f5e.18211c0898a.Coremail.chen45464546@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: ScGowAAnXrTHcNViEehUAA--.4659W
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbBdgdCnmDkn+vHVAAAsO
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

CkF0IDIwMjItMDctMTggMjE6NTA6NDEsICJNYXVyaXppbyBMb21iYXJkaSIgPG1sb21iYXJkQHJl
ZGhhdC5jb20+IHdyb3RlOgo+cG8gMTguIDcuIDIwMjIgdiAxNToxNCBvZGVzqKpsYXRlbCBDaGVu
IExpbiA8Y2hlbjQ1NDY0NTQ2QDE2My5jb20+IG5hcHNhbDoKPj4gLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+PiBJZiB3ZSBjYW4gYWNjZXB0IGFkZGluZyBhIGJyYW5j
aCB0byB0aGlzIHByb2Nlc3MsIHdoeSBub3QgYWRkIGl0IGF0IHRoZSBiZWdpbm5pbmcgbGlrZSBi
ZWxvdz8KPj4gVGhlIGJlbG93IGNoYW5nZXMgYXJlIGFsc28gbW9yZSBpbiBsaW5lIHdpdGggdGhl
IGRlZmluaXRpb24gb2YgInBhZ2UgZnJhZ21lbnQiLAo+PiB3aGljaCBpIG1lYW4gdGhlIGFib3Zl
IGNoYW5nZXMgbWF5IG1ha2UgdGhlIGFsbG9jYXRpb24gb2YgbW9yZSB0aGFuIG9uZSBwYWdlIHN1
Y2Nlc3NmdWwuCj4+Cj4+IGluZGV4IDdhMjhmN2QuLjlkMDllYTUgMTAwNjQ0Cj4+IC0tLSBhL21t
L3BhZ2VfYWxsb2MuYwo+PiArKysgYi9tbS9wYWdlX2FsbG9jLmMKPj4gQEAgLTU1NTEsNiArNTU1
MSw4IEBAIHZvaWQgKnBhZ2VfZnJhZ19hbGxvY19hbGlnbihzdHJ1Y3QgcGFnZV9mcmFnX2NhY2hl
ICpuYywKPj4KPj4gICAgICAgICBvZmZzZXQgPSBuYy0+b2Zmc2V0IC0gZnJhZ3N6Owo+PiAgICAg
ICAgIGlmICh1bmxpa2VseShvZmZzZXQgPCAwKSkgewo+PiArICAgICAgICAgICAgICAgaWYgKHVu
bGlrZWx5KGZyYWdzeiA+IFBBR0VfU0laRSkpCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHJl
dHVybiBOVUxMOwo+PiAgICAgICAgICAgICAgICAgcGFnZSA9IHZpcnRfdG9fcGFnZShuYy0+dmEp
Owo+Pgo+PiAgICAgICAgICAgICAgICAgaWYgKCFwYWdlX3JlZl9zdWJfYW5kX3Rlc3QocGFnZSwg
bmMtPnBhZ2VjbnRfYmlhcykpCj4+Cj4KPlRoaXMgd2lsbCBtYWtlICphbGwqIHBhZ2VfZnJhZ19h
bGxvYygpIGNhbGxzIHdpdGggZnJhZ3N6ID4gUEFHRV9TSVpFCj5mYWlsLCBzbyBpdCB3aWxsCj5i
YXNpY2FsbHkgYnJlYWsgYWxsIHRob3NlIGRyaXZlcnMgdGhhdCBhcmUgcmVseWluZyBvbiB0aGUg
Y3VycmVudCBiZWhhdmlvdXIuCj5XaXRoIG15IHBhdGNoIGl0IHdpbGwgcmV0dXJuIE5VTEwgb25s
eSBpZiB0aGUgY2FjaGUgaXNuJ3QgYmlnIGVub3VnaC4KPgo+TWF1cml6aW8uCgpCdXQgdGhlIG9y
aWdpbmFsIGludGVudGlvbiBvZiBwYWdlIGZyYWcgaW50ZXJmYWNlIGlzIGluZGVlZCB0byBhbGxv
Y2F0ZSBtZW1vcnkgCmxlc3MgdGhhbiBvbmUgcGFnZS4gSXQncyBub3QgYSBnb29kIGlkZWEgdG8g
IGNvbXBsaWNhdGUgdGhlIGRlZmluaXRpb24gb2YgCiJwYWdlIGZyYWdtZW50Ii4KCkZ1cnRoZXJt
b3JlLCB0aGUgcGF0Y2ggYWJvdmUgaXMgZWFzaWVyIHRvIHN5bmNocm9uaXplIHRvIGxvd2VyIHZl
cnNpb25zLgo=
