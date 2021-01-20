Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744A02FD406
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbhATPcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403868AbhATPYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 10:24:46 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2790C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 07:24:05 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l2FKx-0005BT-8v; Wed, 20 Jan 2021 16:23:59 +0100
Date:   Wed, 20 Jan 2021 16:23:59 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Russell Stuart <russell-lartc@stuart.id.au>
Subject: Re: tc: u32: Wrong sample hash calculation
Message-ID: <20210120152359.GM3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Russell Stuart <russell-lartc@stuart.id.au>
References: <20210118112919.GC3158@orbyte.nwl.cc>
 <8df2e0cc-3de4-7084-6859-df1559921fc7@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8df2e0cc-3de4-7084-6859-df1559921fc7@mojatatu.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamal,

On Wed, Jan 20, 2021 at 08:55:11AM -0500, Jamal Hadi Salim wrote:
> On 2021-01-18 6:29 a.m., Phil Sutter wrote:
> > Hi!
> > 
> > Playing with u32 filter's hash table I noticed it is not possible to use
> > 'sample' option with keys larger than 8bits to calculate the hash
> > bucket. 
> 
> 
> I have mostly used something like: ht 2:: sample ip protocol 1 0xff
> Hoping this is continuing to work.

This should read 'sample ip protocol 1 divisor 0xff', right?

> I feel i am missing something basic in the rest of your email:
> Sample is a user space concept i.e it is used to instruct the
> kernel what table/bucket to insert the node into. This computation
> is done in user space. The kernel should just walk the nodes in
> the bucket and match.

Correct, but the kernel has to find the right bucket first. This is
where its key hashing comes into place.

> Reminder: you can only have 256 buckets (8 bit representation).
> Could that be the contributing factor?

It is. Any key smaller than 256B is unaffected as no folding is done in
either kernel or user space.

> Here's an example of something which is not 8 bit that i found in
> an old script that should work (but I didnt test in current kernels).
> ht 2:: sample u32 0x00000800 0x0000ff00 at 12
> We are still going to extract only 8 bits for the bucket.

Yes. The resulting key is 8Bit as the low zeroes are automatically
shifted away.

> Can you provide an example of what wouldnt work?

Sure, sorry for not including it in the original email. Let's apply
actions to some packets based on source IP address. To efficiently
support arbitrary numbers, we use a hash table with 256 buckets:

# tc qd add dev test0 ingress
# tc filter add dev test0 parent ffff: prio 99 handle 1: u32 divisor 256
# tc filter add dev test0 parent ffff: prio 1 protocol ip u32 \
	hashkey mask 0xffffffff at 12 link 1: match u8 0 0

So with the above in place, the kernel uses 32bits at offset 12 as a key
to determine the bucket to jump to. This is done by just extracting the
lowest 8bits in host byteorder, i.e. the last octet of the packet's
source address.

Users don't know the above (and shouldn't need to), so they use sample
to have the bucket determined automatically:

# tc filter add dev test0 parent ffff: prio 99 u32 \
	match ip src 10.0.0.2 \
	ht 1: sample ip src 10.0.0.2 divisor 256 \
	action drop

iproute2 calculates bucket 8 (= 10 ^ 2), while the kernel will check
bucket 2. So the above filter will never match.

Cheers, Phil
