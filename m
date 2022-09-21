Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E64C5BFA09
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiIUJDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiIUJDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:03:43 -0400
Received: from m1524.mail.126.com (m1524.mail.126.com [220.181.15.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 501BB844E8
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 02:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=ZVqmE
        dbNqY9M11FSRnzIXZNASh8SGXKz7ipG1WCC7IY=; b=DfgL8IDe7VssXROft3kzj
        YBWaq7mx91FSDSkZEeyb4JNErtSLFVcp+RkCvOoxkb8U6wUGiwNVk+yip12AIJa4
        C9bdRBIGyWVznO0ivxPaqEBYCuCnyz1H+S5Tzab8RRrjkfbDXU+WahPt5r/g3Tul
        /NRioPvBk+IhspWxktAuAY=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr24
 (Coremail) ; Wed, 21 Sep 2022 17:02:52 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Wed, 21 Sep 2022 17:02:52 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org
Subject: Re:Re: [PATCH] net: marvell: Fix refcounting bugs in
 prestera_port_sfp_bind()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <20220920174529.3e8e106d@kernel.org>
References: <20220915040655.4007281-1-windhl@126.com>
 <20220920174529.3e8e106d@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <5722f6ba.6204.1835f4924aa.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: GMqowABHTyc90ypjfwZ8AA--.52799W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi3BKDF1pEESZuUQACsO
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CkF0IDIwMjItMDktMjEgMDg6NDU6MjksICJKYWt1YiBLaWNpbnNraSIgPGt1YmFAa2VybmVsLm9y
Zz4gd3JvdGU6Cj5PbiBUaHUsIDE1IFNlcCAyMDIyIDEyOjA2OjU1ICswODAwIExpYW5nIEhlIHdy
b3RlOgo+PiBJbiBwcmVzdGVyYV9wb3J0X3NmcF9iaW5kKCksIHRoZXJlIGFyZSB0d28gcmVmY291
bnRpbmcgYnVnczoKPj4gKDEpIHdlIHNob3VsZCBjYWxsIG9mX25vZGVfZ2V0KCkgYmVmb3JlIG9m
X2ZpbmRfbm9kZV9ieV9uYW1lKCkgYXMKPj4gaXQgd2lsbCBhdXRvbWFpdGNhbGx5IGRlY3JlYXNl
IHRoZSByZWZjb3VudCBvZiAnZnJvbScgYXJndW1lbnQ7Cj4+ICgyKSB3ZSBzaG91bGQgY2FsbCBv
Zl9ub2RlX3B1dCgpIGZvciB0aGUgYnJlYWsgb2YgdGhlIGl0ZXJhdGlvbgo+PiBmb3JfZWFjaF9j
aGlsZF9vZl9ub2RlKCkgYXMgaXQgd2lsbCBhdXRvbWF0aWNhbGx5IGluY3JlYXNlIGFuZAo+PiBk
ZWNyZWFzZSB0aGUgJ2NoaWxkJy4KPj4gCj4+IEZpeGVzOiA1MjMyM2VmNzU0MTQgKCJuZXQ6IG1h
cnZlbGw6IHByZXN0ZXJhOiBhZGQgcGh5bGluayBzdXBwb3J0IikKPj4gU2lnbmVkLW9mZi1ieTog
TGlhbmcgSGUgPHdpbmRobEAxMjYuY29tPgo+Cj5QbGVhc2UgcmVwb3N0IGFuZCBDQyBhbGwgdGhl
IGF1dGhvcnMgb2YgdGhlIHBhdGNoIHVuZGVyIEZpeGVzLgoKVGhhbmtzIGZvciB5b3VyIHJlcGx5
LCBKYWt1YgoKQXMgSSB3YXMgdGhlIG9ubHkgb25lIGF1dGhvciwgeW91IG1lYW4gZm9sbG93aW5n
IHRhZyBmb3JtYXQ6CgoiIgpGaXhlczogNTIzMjNlZjc1NDE0ICgibmV0OiBtYXJ2ZWxsOiBwcmVz
dGVyYTogYWRkIHBoeWxpbmsgc3VwcG9ydCIpCkNDOiBMaWFuZyBIZSA8d2luZGhsQDEyNi5jb20+
ClNpZ25lZC1vZmYtYnk6IExpYW5nIEhlIDx3aW5kaGxAMTI2LmNvbT4KIiIKCklmIHRoZXJlIGlz
IGFueXRoaW5nIHdyb25nLCBzb3JyeSBmb3IgdGhpcyB0cm91YmxlLgoKVGhhbmtzLAoKTGlhbmcK
Cg==
