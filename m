Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5726CD1EB
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjC2GDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 02:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjC2GDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:03:44 -0400
Received: from m1550.mail.126.com (m1550.mail.126.com [220.181.15.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29CAEFF
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 23:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
        Message-ID; bh=g5Gxnv+bVqpsIwHw5oLWbqt6FwpyGhQb9A0/Pm4QsOU=; b=V
        yeNvrh8o0MTaqV59kB5KFQJBNIpHdJ5GEhFQusKmTrEidK+6KIZGtsrlwawQoA+1
        v5XftE/TzRuxzCInfNpZ9XXJjQiAnpGJ1t8EGFdyWQFmaxZ6/26uEooHTCYABSYB
        uezL35AZ3sQ1VGPKVWAjBkNj+xzuh1NRvLxHBntphg=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr50
 (Coremail) ; Wed, 29 Mar 2023 14:01:30 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Wed, 29 Mar 2023 14:01:30 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re:Re: [PATCH] rionet: Fix refcounting bugs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20230109(dcb5de15)
 Copyright (c) 2002-2023 www.mailtech.cn 126com
In-Reply-To: <20230328191051.4ceea7bb@kernel.org>
References: <20230328045006.2482327-1-windhl@126.com>
 <20230328191051.4ceea7bb@kernel.org>
X-NTES-SC: AL_QuyTAvydtk4i5iSQYekXnkwQhu05Ucq4u/8l1YVVP5E0uCrNxRwdZ3huH3LE//CiAh+Ttx+mSCZt4/ZxWpVFQImj10BMV48sQjjQC/lFv0S1
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <7e193767.4214.1872bf50476.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: MsqowACnr6s81CNkv_ACAA--.24369W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi5RdBF1pD97B80wACsX
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_INVALID,DKIM_SIGNED,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CkhpLCBKYWt1YiwKCkZpcnN0LCB0aGFua3MgZm9yIHlvdSByZXZpZXdpbmcgb3VyIHBhdGNoIGFn
YWluLgoKQXQgMjAyMy0wMy0yOSAxMDoxMDo1MSwgIkpha3ViIEtpY2luc2tpIiA8a3ViYUBrZXJu
ZWwub3JnPiB3cm90ZToKPk9uIFR1ZSwgMjggTWFyIDIwMjMgMTI6NTA6MDYgKzA4MDAgTGlhbmcg
SGUgd3JvdGU6Cj4+IEluIHJpb25ldF9zdGFydF94bWl0KCksIHdlIHNob3VsZCBwdXQgdGhlIHJl
ZmNvdW50X2luYygpCj4+IGJlZm9yZSB3ZSBhZGQgKnNrYiogaW50byB0aGUgcXVldWUsIG90aGVy
d2lzZSBpdCBtYXkgY2F1c2UKPj4gdGhlIGNvbnN1bWVyIHRvIHByZW1hdHVyZWx5IGNhbGwgcmVm
Y291bnRfZGVjKCkuCj4KPkFyZSB5b3Ugc3VyZSB0aGUgcmFjZSBjYW4gaGFwcGVuPyBMb29rIGFy
b3VuZCB0aGUgY29kZSwgcGxlYXNlLgoKV2UgY29tbWl0IHRoaXMgcGF0Y2ggYmFzZWQgb24gdGhl
IHBhdHRlcm4gd2UgbGVhcm5lZCBmcm9tIHRoZXNlIGNvbW1pdHMsCmh0dHBzOi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21taXQv
P2g9djYuMy1yYzQmaWQ9YmI3NjVkMWMzMzFmNjJiNTkwNDlkMzU2MDdlZDJlMzY1ODAyYmVmOQpo
dHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9s
aW51eC5naXQvY29tbWl0Lz9oPXY2LjMtcmM0JmlkPTQ3YTAxN2YzMzk0MzI3ODU3MGMwNzJiYzcx
NjgxODA5YjI1NjdiM2EKaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvdG9ydmFsZHMvbGludXguZ2l0L2NvbW1pdC8/aD12Ni4zLXJjNCZpZD1iNzgwZDc0MTVh
YWNlYzg1NWUyZjIzNzBjYmY5OGY5MThiMjI0OTAzCgpJZiBpdCBpcyBpbmRlZWQgaW4gZGlmZmVy
ZW50IGNvbnRleHQgd2hpY2ggbWFrZXMgb3VyIHBhdHRlcm4gZmFpbGVkLCBwbGVhc2Uga2luZGx5
IHBvaW50aW5nIG91dCBpdC4KPgo+PiBCZXNpZGVzLCBiZWZvcmUgdGhlIG5leHQgcmlvbmV0X3F1
ZXVlX3R4X21zZygpIHdoZW4gd2UKPj4gbWVldCB0aGUgJ1JJT05FVF9NQUNfTUFUQ0gnLCB3ZSBz
aG91bGQgYWxzbyBjYWxsCj4+IHJlZmNvdW50X2luYygpIGJlZm9yZSB0aGUgc2tiIGlzIGFkZGVk
IGludG8gdGhlIHF1ZXVlLgo+Cj5BbmQgd2h5IGlzIHRoYXQ/CgpXZSB0aGluayBpdCBzaG91bGQg
YmUgYmV0dGVyIHRvIGtlZXAgdGhlIGNvbnNpc3RlbnQgcmVmY291bnRpbmctb3BlcmF0aW9uCndo
ZW4gd2UgcHV0IHRoZSAqc2tiKiBpbnRvIHRoZSBxdWV1ZS4KCj4KPkFzIGZhciBhcyBJIGNhbiB0
ZWxsIHlvdXIgcGF0Y2ggcmVvcmRlcnMgc29tZXRoaW5nIHRoYXQgZG9lc24ndCBtYXR0ZXIKPmFu
ZCB0aGVuIGFkZHMgYSBidWcgOnwKCklmIHRoZXJlIGlzIGFueSBidWcsIGNhbiB5b3Uga2luZGx5
IHRlbGwgdXM/CgpUaGFua3MsCgpMaWFuZwo=
