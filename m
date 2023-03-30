Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13FA6CF90E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 04:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjC3CNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 22:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC3CNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 22:13:37 -0400
Received: from m1550.mail.126.com (m1550.mail.126.com [220.181.15.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 733FB46B4
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 19:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
        Message-ID; bh=Mn5g/VuARPZnjVpi2wk1Q3zLmU2rhA0E9O0gHi+8YWI=; b=B
        uF7MUl0yofTaxr9kMvmZQE8yrNLKHCKmZiTJwxT46a0Nnd7jVZs5MkWFOp0WeZcn
        NPnOP2DLpRy4dWrG0AIDHjRNGjumVz9sT5dQMrqqnHP40h5faJA2aUZc0MEnob8z
        9ZN2BQN2QXh/5cPYWVE987WkKfU+g436BzrEt4wrL0=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr50
 (Coremail) ; Thu, 30 Mar 2023 10:09:42 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Thu, 30 Mar 2023 10:09:42 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Simon Horman" <simon.horman@corigine.com>
Cc:     "Jakub Kicinski" <kuba@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re:Re: [PATCH] rionet: Fix refcounting bugs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20230109(dcb5de15)
 Copyright (c) 2002-2023 www.mailtech.cn 126com
In-Reply-To: <ZCR+5p8TGvS+GQsP@corigine.com>
References: <20230328045006.2482327-1-windhl@126.com>
 <20230328191051.4ceea7bb@kernel.org>
 <7e193767.4214.1872bf50476.Coremail.windhl@126.com>
 <ZCR+5p8TGvS+GQsP@corigine.com>
X-NTES-SC: AL_QuyTAv2fvUkj5CGbbOkXnkwQhu05Ucq4u/8l1YVVP5E0uCrc3DIdZ3hiN0H7//CpMhyWtx+GTTps0dx9X6pmR7D5TU7k2VYrVE2e/VsFIz/c
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <f9af1c5.1a76.187304726fd.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: MsqowABXZ6tn7yRknHsDAA--.27422W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbiHgxCF2IxqMXbDwABss
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_INVALID,DKIM_SIGNED,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgpBdCAyMDIzLTAzLTMwIDAyOjA5OjQyLCAiU2ltb24gSG9ybWFuIiA8c2ltb24uaG9ybWFuQGNv
cmlnaW5lLmNvbT4gd3JvdGU6Cj5PbiBXZWQsIE1hciAyOSwgMjAyMyBhdCAwMjowMTozMFBNICsw
ODAwLCBMaWFuZyBIZSB3cm90ZToKPj4gCj4+IEhpLCBKYWt1YiwKPj4gCj4+IEZpcnN0LCB0aGFu
a3MgZm9yIHlvdSByZXZpZXdpbmcgb3VyIHBhdGNoIGFnYWluLgo+PiAKPj4gQXQgMjAyMy0wMy0y
OSAxMDoxMDo1MSwgIkpha3ViIEtpY2luc2tpIiA8a3ViYUBrZXJuZWwub3JnPiB3cm90ZToKPj4g
Pk9uIFR1ZSwgMjggTWFyIDIwMjMgMTI6NTA6MDYgKzA4MDAgTGlhbmcgSGUgd3JvdGU6Cj4+ID4+
IEluIHJpb25ldF9zdGFydF94bWl0KCksIHdlIHNob3VsZCBwdXQgdGhlIHJlZmNvdW50X2luYygp
Cj4+ID4+IGJlZm9yZSB3ZSBhZGQgKnNrYiogaW50byB0aGUgcXVldWUsIG90aGVyd2lzZSBpdCBt
YXkgY2F1c2UKPj4gPj4gdGhlIGNvbnN1bWVyIHRvIHByZW1hdHVyZWx5IGNhbGwgcmVmY291bnRf
ZGVjKCkuCj4+ID4KPj4gPkFyZSB5b3Ugc3VyZSB0aGUgcmFjZSBjYW4gaGFwcGVuPyBMb29rIGFy
b3VuZCB0aGUgY29kZSwgcGxlYXNlLgo+PiAKPj4gV2UgY29tbWl0IHRoaXMgcGF0Y2ggYmFzZWQg
b24gdGhlIHBhdHRlcm4gd2UgbGVhcm5lZCBmcm9tIHRoZXNlIGNvbW1pdHMsCj4+IGh0dHBzOi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4Lmdp
dC9jb21taXQvP2g9djYuMy1yYzQmaWQ9YmI3NjVkMWMzMzFmNjJiNTkwNDlkMzU2MDdlZDJlMzY1
ODAyYmVmOQo+PiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9oPXY2LjMtcmM0JmlkPTQ3YTAxN2YzMzk0MzI3
ODU3MGMwNzJiYzcxNjgxODA5YjI1NjdiM2EKPj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L2NvbW1pdC8/aD12Ni4zLXJj
NCZpZD1iNzgwZDc0MTVhYWNlYzg1NWUyZjIzNzBjYmY5OGY5MThiMjI0OTAzCj4+IAo+PiBJZiBp
dCBpcyBpbmRlZWQgaW4gZGlmZmVyZW50IGNvbnRleHQgd2hpY2ggbWFrZXMgb3VyIHBhdHRlcm4g
ZmFpbGVkLCBwbGVhc2Uga2luZGx5IHBvaW50aW5nIG91dCBpdC4KPgo+VGhlIGRpZmZlcmVuY2Ug
aXMgdGhhdCB0aGVzZSBhcmUgbm90IHN0YXJ0X3htaXQgY2FsbGJhY2tzLgo+U2VlIGJlbG93Lgo+
Cj4+ID4+IEJlc2lkZXMsIGJlZm9yZSB0aGUgbmV4dCByaW9uZXRfcXVldWVfdHhfbXNnKCkgd2hl
biB3ZQo+PiA+PiBtZWV0IHRoZSAnUklPTkVUX01BQ19NQVRDSCcsIHdlIHNob3VsZCBhbHNvIGNh
bGwKPj4gPj4gcmVmY291bnRfaW5jKCkgYmVmb3JlIHRoZSBza2IgaXMgYWRkZWQgaW50byB0aGUg
cXVldWUuCj4+ID4KPj4gPkFuZCB3aHkgaXMgdGhhdD8KPj4gCj4+IFdlIHRoaW5rIGl0IHNob3Vs
ZCBiZSBiZXR0ZXIgdG8ga2VlcCB0aGUgY29uc2lzdGVudCByZWZjb3VudGluZy1vcGVyYXRpb24K
Pj4gd2hlbiB3ZSBwdXQgdGhlICpza2IqIGludG8gdGhlIHF1ZXVlLgo+Cj5JdCdzIHN1YmplY3Rp
dmUuCj5EdWUgdG8gdGhlIGxvY2tpbmcgb2YgdGhlIGNvZGUgaW4gcXVlc3Rpb24gdGhlcmUgaXMg
bm8gcmFjZS4KPlRoZSBjb2RlIHlvdSBtb2RpZnkgaXMgcHJvdGVjdGVkIGJ5ICZybmV0LT50eF9s
b2NrLgoKVGhhbmtzIGZvciB5b3VyIHJlcGx5LCB3ZSBnZXQgaXQuCgo+QXMgaXMgdGhlIGNvZGUg
dGhhdCB3aWxsIGRlY3JlbWVudCAoYW5kIGZyZWUpIHRoZSBza2IuCj4KPj4gPkFzIGZhciBhcyBJ
IGNhbiB0ZWxsIHlvdXIgcGF0Y2ggcmVvcmRlcnMgc29tZXRoaW5nIHRoYXQgZG9lc24ndCBtYXR0
ZXIKPj4gPmFuZCB0aGVuIGFkZHMgYSBidWcgOnwKPj4gCj4+IElmIHRoZXJlIGlzIGFueSBidWcs
IGNhbiB5b3Uga2luZGx5IHRlbGwgdXM/Cj4KPldlIGFyZSBkZWFsaW5nIHdpdGggYSBzdGFydF94
bWl0IE5ETyBjYWxsYmFjay4KPlRvIHNpbXBsaWZ5IHRoaW5ncywgbGV0IHVzIG9ubHkgY29uc2lk
ZXIgY2FzZXMgd2hlcmUKPk5FVERFVl9UWF9PSyBpcyByZXR1cm5lZCwgd2hpY2ggaXMgdGhlIGNh
c2UgZm9yIHRoZSBjb2RlIHlvdSBtb2RpZnkuCj5JbiBzdWNoIGNhc2VzIHRoZSBjYWxsYmFjayBz
aG91bGQgY29uc3VtZSB0aGUgc2tiLCB3aGljaCBhbHJlYWR5Cj5oYXMgYSByZWZlcmVuY2UgdGFr
ZW4gb24gaXQuIFRoaXMgaXMgZG9uZSBpbiB0aGUgZHJpdmVyIGJ5IGEgY2FsbAo+dG8gZGV2X2tm
cmVlX3NrYl9pcnEoKSB3aGljaCBpcyBleGVjdXRlZCBpbmRpcmVjdGx5IHZpYQo+cmlvbmV0X3F1
ZXVlX3R4X21zZygpLgo+Cj5TbyBjdXJyZW50bHkgdGhlIHJlZmVyZW5jZSBjb3VudCBoYW5kbGlu
ZyBpcyBjb3JyZWN0Lgo+QnkgdGFraW5nIGFuIGV4dHJhIHJlZmVyZW5jZSwgaXQgd2lsbCBuZXZl
ciByZWFjaCB6ZXJvLAo+YW5kIHRodXMgdGhlIHJlc291cmNlcyBvZiB0aGUgc2tiIHdpbGwgYmUg
bGVha2VkLgoKU29ycnkgZm9yIG91ciB0cm91YmxlLgo=
