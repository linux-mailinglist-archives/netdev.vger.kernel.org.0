Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0750857FF7A
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 15:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbiGYNE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 09:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbiGYNEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 09:04:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05ACC13D61;
        Mon, 25 Jul 2022 06:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658754287; x=1690290287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E83Tmbh5/zhrEp/vNkDY4GH+IapcokwsvE85DEfS/wM=;
  b=GYgEMug3IypU94SL1HzQFvAYUYkzXFbHCmkxpEYMVGytbzqL6GPNG86i
   I2q/e9vmHzeexDzXPP0+1epXl3NQ4MxYcjXt9+hgc28ZQx9Qm050AaJBg
   8KX1Gkc5gzDKjdl03TtmfILZhbyGh1SFcLJCY+w0wKRYzZgmYaJoWyP8w
   5jm/NJpulEqcfggdMdIkL10wNQDSO5SDAMat7sP7eI5R0anfVizB6kxIX
   Xber1c2t2b/PVwqIG7Bd+NwIP2rnCdfQfBENotKVEGvNIj/IFVBrP8lFu
   k285EQ2uaiHKZ39UdCMOYFFR1W1KG2ijA7AlMjQBcaZ+Yu5bFS3Bjxl6b
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10418"; a="351686928"
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="351686928"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 06:04:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="575046525"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 25 Jul 2022 06:04:33 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26PD4Vdv013796;
        Mon, 25 Jul 2022 14:04:31 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] netlink: add 'bitmap' attribute type and API
Date:   Mon, 25 Jul 2022 15:02:55 +0200
Message-Id: <20220725130255.3943438-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220722111951.6a2fd39c@kernel.org>
References: <20220721155950.747251-1-alexandr.lobakin@intel.com> <20220721111318.1b180762@kernel.org> <20220722145514.767592-1-alexandr.lobakin@intel.com> <20220722111951.6a2fd39c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 22 Jul 2022 11:19:51 -0700

> On Fri, 22 Jul 2022 16:55:14 +0200 Alexander Lobakin wrote:
> > > I think that straight up bitmap with a fixed word is awkward and leads
> > > to too much boilerplate code. People will avoid using it. What about
> > > implementing a bigint type instead? Needing more than 64b is extremely
> > > rare, so in 99% of the cases the code outside of parsing can keep using
> > > its u8/u16/u32.  
> > 
> > In-kernel code can still use single unsigned long for some flags if
> > it wouldn't need more than 64 bits in a couple decades and not
> > bother with the bitmap API. Same with userspace -- a single 64 is
> > fine for that API, just pass a pointer to it to send it as a bitmap
> > to the kernel.
> 
> Single unsigned long - exactly. What I'm saying is that you need to
> convince people who think they are "clever" by using u8 or u16 for
> flags because it "saves space". Happens a lot, I can tell your from
> reviewing such patches. And to avoid that we should give people a
  ^^^^^^^^^^^^^^^^^^^^^^

Oh true!

> "growable" type but starting from smaller sizes than a bitmap.
> 
> It's about human psychology as observed, not logic, just to be extra
> clear.
> 
> A logical argument of smaller importance is that ID types have a
> similar problem, although practically it's even more rare than for
> flags  (I think it did happen once with inodes or some such, tho). 
> So bigint has more uses.
> 
> I'd forgo the endianness BTW, it's a distraction at the netlink level.
> There was more reason for it in fixed-size fields.

Hmm yeah, and I don't use explicit-endian arr64s in the IP tunnel
changeset. Probably not worth it, I did it only for some... uhm,
_flexibility_.

> 
> > Re 64b vs extremely rare -- I would say so 5 years go, but now more
> > and more bitfields run out of 64 bits. Link modes, netdev features,
> > ...
> 
> I like how you put the "..." there even tho these are the only two cases
> either of us can think of, right? :) There are hundreds of flags in the

Hahaha you got me!

> kernel, two needed to grow into a bitmap. And the problem you're
> working on is with a 16 bit field, or 32 bit filed? Defo not 64b, right?

It's even worse, IP tunnel flags is __be16, so I have to redo all
the use sites either case, whether I change them to u64 or bitmap
or even __be64 -- no way to optimize it to a noop >_<

Initially I've converted them to u64 IIRC. Then I looked at the
timeline of adding new flags and calculated that in the best case
we'll run out of u64 in 20 years. But there's a spike in ~5 new
flags during the last n months, so... Given that it took a lot of
routine non-so-exicing adjusting all the use sites (I can't imagine
how that guy who's converting netdev features to bitmaps right now
managed finish redoing 120+ drivers under drivers/net/), if/when
`u64 flags` comes to its end, there will be a new patch series
doing the same job again...

> 
> > Re bigint -- do you mean implementing u128 as a union, like
> > 
> > typedef union __u128 {
> > 	struct {
> > 		u32 b127_96;
> > 		u32 b95_64;
> > 		u32 b63_32;
> > 		u32 b31_0;
> > 	};
> > 	struct {
> > 		u64 b127_64;
> > 		u64 b63_0;
> > 	};
> > #ifdef __HAVE_INT128
> > 	__int128 b127_0;
> > #endif
> > } u128;
> > 
> > ? We have similar feature in one of our internal trees and planning
> > to present generic u128 soon, but this doesn't work well for flags
> > I think.
> 
> Actually once a field crosses the biggest natural int size I was
> thinking that the user would go to a bitmap.
> 
> So at the netlink level the field is bigint (LE, don't care about BE).
> Kernel side API is:
> 
> 	nla_get_b8, nla_get_b16, nla_get_b32, nla_get_b64,
> 	nla_get_bitmap
> 	nla_put_b8, nla_put_b16 etc.
> 
> 	u16 my_flags_are_so_toight;
> 
> 	my_flags_are_so_toight = nla_get_b16(attr[BLAA_BLA_BLA_FLAGS]);
> 
> The point is - the representation can be more compact than u64 and will
> therefore encourage anyone who doesn't have a strong reason to use
> fixed size fields to switch to the bigint.

Ahh looks like I got it! So you mean that at Netlink level we should
exchange with bigint/u64arrs, but there should be an option to
get/set only 16/32/64 bits from them to simplify (or keep simple)
users? Like, if we have `u16 uuid`, to not do

	unsigned long uuid_bitmap;

	nla_get_bitmap(attr[FLAGS], &uuid_bitmap, BITS_PER_TYPE(u16));
	uuid = (u16)uuid_bitmap;

but instead

	uuid = nla_get_b16(attr[FLAGS]);

?

> 
> Honestly, if we were redoing netlink from scratch today I'd argue there
> should be no fixed width integers in host endian.
> 
> > bitmap API and bitops are widely used and familiar to tons of folks,
> > most platforms define their own machine-optimized bitops
> > implementation, arrays of unsigned longs are native...
> > 
> > Re awkward -- all u64 <-> bitmap conversion is implemented in the
> > core code in 4/4 and users won't need doing anything besides one
> > get/set. And still use bitmap/bitops API. Userspace, as I said,
> > can use a single __u64 as long as it fits into 64 bits.
> 
> Yes, but people will see a bitmap and think "I don't need a bitmap, 
> I just need X bits".
> 
> > Summarizing, I feel like bigints would lead to much more boilerplate
> > in both kernel and user spaces and need to implement a whole new API
> > instead of using the already existing and well-used bitmap one.
> > Continuation of using single objects with fixed size like %NLA_U* or
> > %NLA_BITFIELD_U32 will lead to introducing a new Netlink attr every
> > 32/64 bits (or even 16 like with IP tunnels, that was the initial
> > reason why I started working on those 3 series). As Jake wrote me
> > in PM earlier,
> 
> Every netlink attribute carries length. As long as you establish
> correct expectations for parsing there is no need to create new types.

Right, but %NLA_BITFIELD_U32 landed +/- recently IIRC :)


> 
> > "I like the concept of an NLA_BITMAP. I could have used this for
> > some of the devlink interfaces we've done, and it definitely feels
> > a bit more natural than being forced to a single u32 bitfield."
> 
> Slightly ironic to say "if I could use a larger type I would" 
> and then not use the largest one available? ;) But the point is

:D Agree

> about being flexible when it comes to size, I guess, more than
> bitmap in particular.

Probably, but you also said above that for anything bigger than
longs you'd go for bitmaps, didn't you? So I guess that series
goes in the right direction, just needs a couple more inlines
to be able to get/put u{32, 64; 8, 16 -- not sure about these two
after reading your follow-up mail} as easy as nla_{get,put}<size>()
and probably dropping Endianness stuff? Hope I got it right ._.

Thanks,
Olek
