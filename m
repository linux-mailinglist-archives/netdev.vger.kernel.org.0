Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D6B57FD66
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 12:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbiGYK0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 06:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbiGYK0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 06:26:12 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2961582B;
        Mon, 25 Jul 2022 03:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658744771; x=1690280771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vb0TKNah0PY8LMc10juOYXDzyQajaqVinXtVknS6mSU=;
  b=AiMM6QmYA+OUHAvK/CmBoTXg1el/ZQvLyvo2KGX+HYGxZ8p/HrUI0pD+
   5bPJb+99gjdPf4qMnA+xEr0QxyL5ztwfWtlsA6nRELmmDUCaWGCmcYboE
   RCHjlygqRWZekBLueOukIoXdeft1pMYm3fFML4O4S+AAJCae+SMaFIARA
   BzbmahBDIe3pOFO56nSq91DyHxG8KsSRP7B0DaZ34XKRXH214RdqNuaqf
   fNqsXUQTFnPf4zc58db/6MpUeREe7kACcuyG9w/5iP04FsJTnFXmdMb+Y
   ShHHgE5RRfDillvH8KY/QmU4TaSLG9h5NDrbolEZ8CzL/ilKGiv82IAV9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10418"; a="349363359"
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="349363359"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 03:26:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="632309302"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 25 Jul 2022 03:25:58 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26PAPvQ6031778;
        Mon, 25 Jul 2022 11:25:57 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] netlink: add 'bitmap' attribute type and API
Date:   Mon, 25 Jul 2022 12:24:18 +0200
Message-Id: <20220725102418.2083779-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <CAHp75Ve7oXjNyc0GD5x9ZW=DVgCqmLOBfCP4O2cDi2DG=4SiwQ@mail.gmail.com>
References: <20220721155950.747251-1-alexandr.lobakin@intel.com> <20220721111318.1b180762@kernel.org> <20220722145514.767592-1-alexandr.lobakin@intel.com> <CAHp75Ve7oXjNyc0GD5x9ZW=DVgCqmLOBfCP4O2cDi2DG=4SiwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Fri, 22 Jul 2022 19:02:35 +0200

> On Friday, July 22, 2022, Alexander Lobakin <alexandr.lobakin@intel.com>
> wrote:
> 
> > From: Jakub Kicinski <kuba@kernel.org>
> > Date: Thu, 21 Jul 2022 11:13:18 -0700
> >
> > > On Thu, 21 Jul 2022 17:59:46 +0200 Alexander Lobakin wrote:
> > > > BTW, Ethtool bitsets provide similar functionality, but it operates
> > > > with u32s (u64 is more convenient and optimal on most platforms) and
> > > > Netlink bitmaps is a generic interface providing policies and data
> > > > verification (Ethtool bitsets are declared simply as %NLA_BINARY),
> > > > generic getters/setters etc.
> > >
> > > Are you saying we don't need the other two features ethtool bitmaps
> > > provide? Masking and compact vs named representations?
> >
> > Nah I didn't say that. I'm not too familiar with Ethtool bitsets,
> > just know that they're represented as arrays of u32s.
> >
> > >
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
> >
> > Re 64b vs extremely rare -- I would say so 5 years go, but now more
> > and more bitfields run out of 64 bits. Link modes, netdev features,
> > ...
> >
> > Re bigint -- do you mean implementing u128 as a union, like
> >
> > typedef union __u128 {
> >         struct {
> >                 u32 b127_96;
> >                 u32 b95_64;
> >                 u32 b63_32;
> >                 u32 b31_0;
> >         };
> >         struct {
> >                 u64 b127_64;
> >                 u64 b63_0;
> >         };
> > #ifdef __HAVE_INT128
> >         __int128 b127_0;
> > #endif
> > } u128;
> >
> > ?
> 
> 
> This looks not good (besides union aliasing, have you thought about BE64?).

It was just an example to vizualize the thought.

> 
> 
> 
> >
> >
> > We have similar feature in one of our internal trees and planning
> > to present generic u128 soon, but this doesn't work well for flags
> > I think.
> > bitmap API and bitops are widely used and familiar to tons of folks,
> > most platforms define their own machine-optimized bitops
> > implementation, arrays of unsigned longs are native...
> >
> > Re awkward -- all u64 <-> bitmap conversion is implemented in the
> > core code in 4/4 and users won't need doing anything besides one
> > get/set. And still use bitmap/bitops API. Userspace, as I said,
> > can use a single __u64 as long as it fits into 64 bits.
> >
> > Summarizing, I feel like bigints would lead to much more boilerplate
> > in both kernel and user spaces and need to implement a whole new API
> > instead of using the already existing and well-used bitmap one.
> > Continuation of using single objects with fixed size like %NLA_U* or
> > %NLA_BITFIELD_U32 will lead to introducing a new Netlink attr every
> > 32/64 bits (or even 16 like with IP tunnels, that was the initial
> > reason why I started working on those 3 series). As Jake wrote me
> > in PM earlier,
> >
> > "I like the concept of an NLA_BITMAP. I could have used this for
> > some of the devlink interfaces we've done, and it definitely feels
> > a bit more natural than being forced to a single u32 bitfield."
> 
> 
> Netlink is an ABI, how would you naturally convert unsigned long from
> 64-bit kernel to the unsigned long on 32-bit user space, esp. on BE
> architectures?

Uhm, that's what this patchset does. Cover letter says: we can't
transfer longs between userspace and the kernel, so in Netlink
messages they're represented as arrays of u64s, then Netlink core
in the kernel code takes care of converting them to longs when you
call getter (and vice versa for setter)...
On LE and 64-bit BE architectures this conversion is a noop (see
bitmap_{from,to}_arr64()), that's why u64s were chosen, not u32s
like in Ethtool for example.

> 
> 
> >
> > Thanks,
> > Olek
> >
> 
> 
> -- 
> With Best Regards,
> Andy Shevchenko

Thanks,
Olek
