Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214F332DDDA
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 00:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbhCDX1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 18:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbhCDX1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 18:27:39 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D0BC061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 15:27:39 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 418214D2D0CC8;
        Thu,  4 Mar 2021 15:27:37 -0800 (PST)
Date:   Thu, 04 Mar 2021 15:27:33 -0800 (PST)
Message-Id: <20210304.152733.1381456342956729385.davem@davemloft.net>
To:     paul@paul-moore.com
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, dvyukov@google.com
Subject: Re: [PATCH] cipso,calipso: resolve a number of problems with the
 DOI refcounts
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHC9VhTxfMOzABdAg=RO3k1cfyE2A2DEQ0gUQ9M6NVELpJVw7Q@mail.gmail.com>
References: <161489339182.63157.2775083878484465675.stgit@olly>
        <20210304.143347.415521310565498642.davem@davemloft.net>
        <CAHC9VhTxfMOzABdAg=RO3k1cfyE2A2DEQ0gUQ9M6NVELpJVw7Q@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 04 Mar 2021 15:27:37 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGF1bCBNb29yZSA8cGF1bEBwYXVsLW1vb3JlLmNvbT4NCkRhdGU6IFRodSwgNCBNYXIg
MjAyMSAxODoxMzoyMSAtMDUwMA0KDQo+IE9uIFRodSwgTWFyIDQsIDIwMjEgYXQgNTozMyBQTSBE
YXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+IHdyb3RlOg0KPj4gRnJvbTogUGF1bCBN
b29yZSA8cGF1bEBwYXVsLW1vb3JlLmNvbT4NCj4+IERhdGU6IFRodSwgMDQgTWFyIDIwMjEgMTY6
Mjk6NTEgLTA1MDANCj4+DQo+PiA+ICtzdGF0aWMgdm9pZCBjYWxpcHNvX2RvaV9wdXRkZWYoc3Ry
dWN0IGNhbGlwc29fZG9pICpkb2lfZGVmKTsNCj4+ID4gKw0KPj4NCj4+IFRoaXMgaXMgYSBnbG9i
YWwgc3ltYm9sLCBzbyB3aHkgdGhlIHN0YXRpYyBkZWNsIGhlcmU/DQo+IA0KPiBUbyByZXNvbHZl
IHRoaXM6DQo+IA0KPiAgIENDICAgICAgbmV0L2lwdjYvY2FsaXBzby5vDQo+IG5ldC9pcHY2L2Nh
bGlwc28uYzogSW4gZnVuY3Rpb24goWNhbGlwc29fZG9pX3JlbW92ZaI6DQo+IG5ldC9pcHY2L2Nh
bGlwc28uYzo0NTM6MjogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uIKFj
YWxpcHNvX2RvaV9wDQo+IHV0ZGVmog0KPiANCj4gSSB0aGluayB0aGVyZSBhcmUgc29tZSBvZGQg
dGhpbmdzIHdpdGggaG93IHRoZSBDQUxJUFNPIHByb3RvdHlwZXMgYXJlDQo+IGhhbmRsZWQsIHNv
bWUgb2YgdGhhdCBJJ20gZ3Vlc3NpbmcgaXMgZHVlIHRvIGhhbmRsaW5nIElQdjYNCj4gYXMtYS1t
b2R1bGUsIGJ1dCByZWdhcmRsZXNzIG9mIHRoZSByZWFzb24gaXQgc2VlbWVkIGxpa2UgdGhlIHNt
YWxsZXN0DQo+IGZpeCB3YXMgdG8gYWRkIHRoZSBmb3J3YXJkIGRlY2xhcmF0aW9uIGF0IHRoZSB0
b3Agb2YgdGhlIGZpbGUuDQo+IENvbnNpZGVyaW5nIHRoYXQgSSBiZWxpZXZlIHRoaXMgc2hvdWxk
IGJlIHNlbnQgdG8gLXN0YWJsZSBJIGZpZ3VyZWQgYQ0KPiBzbWFsbGVyIHBhdGNoLCB3aXRoIGxl
c3MgY2hhbmNlIGZvciBtZXJnZSBjb25mbGljdHMsIHdvdWxkIGJlIG1vcmUNCj4gZGVzaXJhYmxl
Lg0KDQpUaGFua3MgZm9yIGV4cGxhaW5pbmcuLi4NCg0K
