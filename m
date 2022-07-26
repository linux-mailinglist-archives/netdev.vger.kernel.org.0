Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C9A58183A
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 19:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbiGZRRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 13:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiGZRRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 13:17:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4033E1A076
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 10:17:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 060B5B8189B
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 17:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AE6C433D6;
        Tue, 26 Jul 2022 17:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658855869;
        bh=McLUTemWAgKX2Zqbocu/WCjryysXGAT2ZZU+iWMMP5E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OYsgSN8Vq9OkmCdtiwAsoh+2x/rHPT4qJQb/+Tz744Cqo+aGX5Csgo5eKoZ/tPh79
         JIX084JPfwVq1NmDKcKR7Uvz+TslTuTzwG9m9By6ct7O4fgl/HlIzMegRlNJybo0/T
         Ah78QN0AuA78eWExGiMzn5NGn/9l2dLHw1iDbY2THc2MU6adGZMbsijwj6Bz3eLP3S
         7m9O0MObtYe2QTmLbkmHUkG6bqtZoz21j8LqOk2DMcCm4pL4/KAtVdXV1980TtevLr
         Gb5NC2kA49Q0Xw4MzVcZvOFXFLGL4xATci0YRmoBJuiDqKeBq8zkYns6c2FhBbFamj
         uVCDWY4ckXvuA==
Date:   Tue, 26 Jul 2022 10:17:48 -0700
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
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] netlink: add 'bitmap' attribute type and
 API
Message-ID: <20220726101748.76aaac09@kernel.org>
In-Reply-To: <20220726104145.1857628-1-alexandr.lobakin@intel.com>
References: <20220721155950.747251-1-alexandr.lobakin@intel.com>
        <20220721111318.1b180762@kernel.org>
        <20220722145514.767592-1-alexandr.lobakin@intel.com>
        <20220722111951.6a2fd39c@kernel.org>
        <20220725130255.3943438-1-alexandr.lobakin@intel.com>
        <20220725115324.7a1ad2d6@kernel.org>
        <20220726104145.1857628-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 12:41:45 +0200 Alexander Lobakin wrote:
> > Modulo the fact that I do still want to pack to u32. Especially a
> > single u32 - perhaps once we cross 8B we can switch to requiring 8B
> > increments.
> > 
> > The nla_len is 16bit, which means that attrs nested inside other attrs
> > are quite tight for space (see the sad story of VF attrs in
> > RTM_GETLINK). If we don't represent u8/u16/u32 in a netlink-level
> > efficient manner we're back to people arguing for raw u32s rather than
> > using the new type.  
> 
> Ah, got it. I think you're right. The only thing that bothers me
> a bit is that we'll be converting arrays of u32s to unsigned longs
> each time, unlike u64s <--> longs which are 1:1 for 64 bits and LEs.

For LE the size of the word doesn't matter, right? Don't trust me on
endian questions, but I thought for LE you can just load the data as
ulongs as long as size is divisible by sizeof(ulong) and you're gonna
be good. It'd add some #ifdefs and ifs() to the bitmap code, but the
ethtool u32 conversions would probably also benefit?

> But I guess it's better anyway than waste Netlink attrs for
> paddings?

Yes, AFAIU it's pretty bad. Say you have a nest with objects with 
3 big ints inside. With u32 the size of a nest is 4 + 3*(4+4) = 28.
With u64 it's 4 + 4+8 + 2*(4+4+8) = 48 so 28 vs 48. Netlink header
being 4B almost always puts us out of alignment.

> So I'd like to summarize for a v2:
> 
> * represent as u32s, not u64s;
> * present it as "bigints", not bitmaps. It can carry bitmaps as
>   well, but also ->
> * add getters/setters for u8, 16, 32, 64s. Bitmaps are already here.
>   Probably u32 arrays as well? Just copy them directly. And maybe
>   u64 arrays, too (convert Netlink u32s to target u64s)?

I don't think we need the array helpers.

> * should I drop Endianness stuff? With it still in place, it would
>   be easier to use this new API to exchange with e.g. __be64.

If you have a use case, sure. AFAIU the explicit endian types are there
for carrying protocol fields. I don't think there are many protocols
that we deal with in netlink that have big int fields.

> * hope I didn't miss anything?

I think that's it, but I reserve the right to remember something after
you post the code :)

> Thanks a lot, some great ideas here from your side :)
