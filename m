Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9602F9E2F
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 12:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389659AbhARLah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 06:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389976AbhARLaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 06:30:05 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A66C061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 03:29:24 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l1Sil-0005VK-JR; Mon, 18 Jan 2021 12:29:19 +0100
Date:   Mon, 18 Jan 2021 12:29:19 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Russell Stuart <russell-lartc@stuart.id.au>
Subject: tc: u32: Wrong sample hash calculation
Message-ID: <20210118112919.GC3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Russell Stuart <russell-lartc@stuart.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Playing with u32 filter's hash table I noticed it is not possible to use
'sample' option with keys larger than 8bits to calculate the hash
bucket. Turns out key hashing in kernel and iproute2 differ:

* net/sched/cls_u32.c (kernel) basically does:

hash = ntohl(key & mask);
hash >>= ffs(ntohl(mask)) - 1;
hash &= 0xff;
hash %= divisor;

* while tc/f_u32.c (iproute2) does:

hash = key & mask;
hash ^= hash >> 16;
hash ^= hash >> 8;
hash %= divisor;

In iproute2, the code changed in 2006 with commit 267480f55383c
("Backout the 2.4 utsname hash patch."), here's the relevant diff:

  hash = sel2.sel.keys[0].val&sel2.sel.keys[0].mask;
- uname(&utsname);
- if (strncmp(utsname.release, "2.4.", 4) == 0) {
-         hash ^= hash>>16;
-         hash ^= hash>>8;
- }
- else {
-         __u32 mask = sel2.sel.keys[0].mask;
-         while (mask && !(mask & 1)) {
-                 mask >>= 1;
-                 hash >>= 1;
-         }
-         hash &= 0xFF;
- }
+ hash ^= hash>>16;
+ hash ^= hash>>8;
  htid = ((hash%divisor)<<12)|(htid&0xFFF00000);

The old code would work if key and mask weren't in network byteorder. I
guess that also changed since then.

I would simply send a patch to fix iproute2, but I don't like the
kernel's hash "folding" as it ignores any bits beyond the first eight.
So I would prefer to "fix" the kernel instead but would like to hear
your opinions as that change has a much larger scope than just
iproute2's 'sample' option.

Thanks, Phil
