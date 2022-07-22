Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DE257E661
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbiGVST5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiGVST4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:19:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B7176E82;
        Fri, 22 Jul 2022 11:19:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CE8CB829E2;
        Fri, 22 Jul 2022 18:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB65EC341C6;
        Fri, 22 Jul 2022 18:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658513993;
        bh=k6b1OiCHUvzlQDFeiOtP3/Y1uQExyI/isDWGGjsSDvE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F4QyxsZZaE1cG4yP04FDDJkIczej9j//PBhRwylnCNWEC/m3spzKGtqMNdn/wd3dR
         N3wat2b1324Kv2VkZ1haywridAU2M0dZe+H6gCPK9T1e04Fcnz1rYcxVi8tXdYfH0/
         5C2uZSbsY20IPHzWNLuXdR6+jZkUcIwP6CCXiydKVpmJO/WLhivKY0XTjwNbRx6Iar
         fabW1AImuPHVQ9mmgcyicKk/VT6Qu4B3msSQlPZHMKu8MmsuFRcxyE3WnVKwdK4J+o
         mH1AyiOjr+RoMnLPGuyENCxJpualjPcbTtCo/DuzoP6M4HExD1q86JBDerfCPtKIVt
         cyPjbQB/AyiEA==
Date:   Fri, 22 Jul 2022 11:19:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] netlink: add 'bitmap' attribute type and
 API
Message-ID: <20220722111951.6a2fd39c@kernel.org>
In-Reply-To: <20220722145514.767592-1-alexandr.lobakin@intel.com>
References: <20220721155950.747251-1-alexandr.lobakin@intel.com>
        <20220721111318.1b180762@kernel.org>
        <20220722145514.767592-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jul 2022 16:55:14 +0200 Alexander Lobakin wrote:
> > I think that straight up bitmap with a fixed word is awkward and leads
> > to too much boilerplate code. People will avoid using it. What about
> > implementing a bigint type instead? Needing more than 64b is extremely
> > rare, so in 99% of the cases the code outside of parsing can keep using
> > its u8/u16/u32.  
> 
> In-kernel code can still use single unsigned long for some flags if
> it wouldn't need more than 64 bits in a couple decades and not
> bother with the bitmap API. Same with userspace -- a single 64 is
> fine for that API, just pass a pointer to it to send it as a bitmap
> to the kernel.

Single unsigned long - exactly. What I'm saying is that you need to
convince people who think they are "clever" by using u8 or u16 for
flags because it "saves space". Happens a lot, I can tell your from
reviewing such patches. And to avoid that we should give people a
"growable" type but starting from smaller sizes than a bitmap.

It's about human psychology as observed, not logic, just to be extra
clear.

A logical argument of smaller importance is that ID types have a
similar problem, although practically it's even more rare than for
flags  (I think it did happen once with inodes or some such, tho). 
So bigint has more uses.

I'd forgo the endianness BTW, it's a distraction at the netlink level.
There was more reason for it in fixed-size fields.

> Re 64b vs extremely rare -- I would say so 5 years go, but now more
> and more bitfields run out of 64 bits. Link modes, netdev features,
> ...

I like how you put the "..." there even tho these are the only two cases
either of us can think of, right? :) There are hundreds of flags in the
kernel, two needed to grow into a bitmap. And the problem you're
working on is with a 16 bit field, or 32 bit filed? Defo not 64b, right?

> Re bigint -- do you mean implementing u128 as a union, like
> 
> typedef union __u128 {
> 	struct {
> 		u32 b127_96;
> 		u32 b95_64;
> 		u32 b63_32;
> 		u32 b31_0;
> 	};
> 	struct {
> 		u64 b127_64;
> 		u64 b63_0;
> 	};
> #ifdef __HAVE_INT128
> 	__int128 b127_0;
> #endif
> } u128;
> 
> ? We have similar feature in one of our internal trees and planning
> to present generic u128 soon, but this doesn't work well for flags
> I think.

Actually once a field crosses the biggest natural int size I was
thinking that the user would go to a bitmap.

So at the netlink level the field is bigint (LE, don't care about BE).
Kernel side API is:

	nla_get_b8, nla_get_b16, nla_get_b32, nla_get_b64,
	nla_get_bitmap
	nla_put_b8, nla_put_b16 etc.

	u16 my_flags_are_so_toight;

	my_flags_are_so_toight = nla_get_b16(attr[BLAA_BLA_BLA_FLAGS]);

The point is - the representation can be more compact than u64 and will
therefore encourage anyone who doesn't have a strong reason to use
fixed size fields to switch to the bigint.

Honestly, if we were redoing netlink from scratch today I'd argue there
should be no fixed width integers in host endian.

> bitmap API and bitops are widely used and familiar to tons of folks,
> most platforms define their own machine-optimized bitops
> implementation, arrays of unsigned longs are native...
> 
> Re awkward -- all u64 <-> bitmap conversion is implemented in the
> core code in 4/4 and users won't need doing anything besides one
> get/set. And still use bitmap/bitops API. Userspace, as I said,
> can use a single __u64 as long as it fits into 64 bits.

Yes, but people will see a bitmap and think "I don't need a bitmap, 
I just need X bits".

> Summarizing, I feel like bigints would lead to much more boilerplate
> in both kernel and user spaces and need to implement a whole new API
> instead of using the already existing and well-used bitmap one.
> Continuation of using single objects with fixed size like %NLA_U* or
> %NLA_BITFIELD_U32 will lead to introducing a new Netlink attr every
> 32/64 bits (or even 16 like with IP tunnels, that was the initial
> reason why I started working on those 3 series). As Jake wrote me
> in PM earlier,

Every netlink attribute carries length. As long as you establish
correct expectations for parsing there is no need to create new types.

> "I like the concept of an NLA_BITMAP. I could have used this for
> some of the devlink interfaces we've done, and it definitely feels
> a bit more natural than being forced to a single u32 bitfield."

Slightly ironic to say "if I could use a larger type I would" 
and then not use the largest one available? ;) But the point is
about being flexible when it comes to size, I guess, more than
bitmap in particular.
