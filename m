Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0DB604B85
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiJSPcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiJSPb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:31:57 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48E613FDE2;
        Wed, 19 Oct 2022 08:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666193117; x=1697729117;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BOqPvPQ9ce409RgxVJKbwf/QLmG9f5kjXyvxTvj2p18=;
  b=oGcYKIch1QBkHPBrqSJJEw6cTDho5u9W1eKtW/Gj5hC5ec9W4+q0W85u
   r4HpVcoSHbBYxDorVqyRULplrpBbgZB9jRW/3olPAqmswG1IbrcLyil8v
   Bh+W0xBjzJUj3XZHFNYhyNlkCWB0XWCEsxQOBtQb/zWMFEi06rm7sj/uL
   hNouWWiatmzo4torIAy33nOuU8rNAZxyj9QDa0jn0oFarGLCVnk6/LZ7L
   1JBH/1YlVhsEisC79iK1GoMC4PACR/sur/dbvzP/4Pw0dwX4IXKhd+wos
   qsKo4s0GiLVTens4h9cbwc8CB0Bnr98w/WFzQ1ymh6kOv0/BBMX10JWfe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="370659512"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="370659512"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 08:23:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="580388568"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="580388568"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 19 Oct 2022 08:23:36 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29JFNZox029637;
        Wed, 19 Oct 2022 16:23:35 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/6] bitmap: try to optimize arr32 <-> bitmap on 64-bit LEs
Date:   Wed, 19 Oct 2022 17:21:40 +0200
Message-Id: <20221019152140.2679055-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <Y08rqtdiTDbIm0EJ@yury-laptop>
References: <20221018140027.48086-1-alexandr.lobakin@intel.com> <20221018140027.48086-2-alexandr.lobakin@intel.com> <Y08rqtdiTDbIm0EJ@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Date: Tue, 18 Oct 2022 15:41:46 -0700

> On Tue, Oct 18, 2022 at 04:00:22PM +0200, Alexander Lobakin wrote:
> > Unlike bitmap_{from,to}_arr64(), when there can be no out-of-bounds
> > accesses (due to u64 always being no shorter than unsigned long),
> > it can't be guaranteed with arr32s due to that on 64-bit platforms:
> > 
> > bits     BITS_TO_U32 * sizeof(u32)    BITS_TO_LONGS * sizeof(long)
> > 1-32     4                            8
> > 33-64    8                            8
> > 95-96    12                           16
> > 97-128   16                           16
> > 
> > and so on.
> > That is why bitmap_{from,to}_arr32() are always defined there as
> > externs. But quite often @nbits is a compile-time constant, which
> > means we could suggest whether it can be inlined or not at
> > compile-time basing on the number of bits (above).
> > 
> > So, try to determine that at compile time and, in case of both
> > containers having the same size in bytes, resolve it to
> > bitmap_copy_clear_tail() on Little Endian. No changes here for
> > Big Endian or when the number of bits *really* is variable.
> 
> You're saying 'try to optimize', but don't show any numbers. What's
> the target for your optimization? Can you demonstrate how it performs
> in test or in real work?

I had them somewhere, but given that you provided a different
approach to try, I'd better retest each of them and collect some
fresh numbers. If it's not worth it, I'll simply drop the patch
from the series / include stats in the commitmsg otherwise.

>  
> > Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> > ---
> >  include/linux/bitmap.h | 51 ++++++++++++++++++++++++++++++------------
> >  lib/bitmap.c           | 12 +++++-----
> >  2 files changed, 43 insertions(+), 20 deletions(-)

[...]

> > +#if BITS_PER_LONG == 32
> > +#define bitmap_arr32_compat(nbits)		true
> > +#elif defined(__LITTLE_ENDIAN)
> > +#define bitmap_arr32_compat(nbits)		\
> 
> 'Compat' is reserved for a compatibility layer between kernel and
> user spaces running different ABIs. Can you pick some other word?

Yeah, sure. I was also thinking of this as it didn't sound good to
me as well, but didn't find anything better at the top of my head
and then forgot about it at all.

> 
> > +	(__builtin_constant_p(nbits) &&		\
> > +	 BITS_TO_U32(nbits) * sizeof(u32) ==	\
> > +	 BITS_TO_LONGS(nbits) * sizeof(long))
> 
> I think it should be:
>         round_up(nbits, 32) == round_up(nbits, 64)

Ah, correct.

> 
> >  #else
> > -#define bitmap_from_arr32(bitmap, buf, nbits)			\
> > -	bitmap_copy_clear_tail((unsigned long *) (bitmap),	\
> > -			(const unsigned long *) (buf), (nbits))
> > -#define bitmap_to_arr32(buf, bitmap, nbits)			\
> > -	bitmap_copy_clear_tail((unsigned long *) (buf),		\
> > -			(const unsigned long *) (bitmap), (nbits))
> 
> Can you keep this part untouched? I'd like to have a clear meaning -
> on 32-bit arch, bitmap_to_arr32 is a simple copy.

Sure, why not, I don't have a strong preference here.

> 
> > +#define bitmap_arr32_compat(nbits)		false
> >  #endif
> >  
> > +void __bitmap_from_arr32(unsigned long *bitmap, const u32 *buf, unsigned int nbits);
> > +void __bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits);
> > +
> > +static inline void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf,
> > +				     unsigned int nbits)
> > +{
> > +	const unsigned long *src = (const unsigned long *)buf;
> > +
> > +	if (bitmap_arr32_compat(nbits))
> > +		bitmap_copy_clear_tail(bitmap, src, nbits);
> > +	else
> > +		__bitmap_from_arr32(bitmap, buf, nbits);
> 
> If you would really want to optimize it, I'd suggest something like
> this:
>     #ifdef __LITTLE_ENDIAN
>         /*copy as many full 64-bit words as we can */
>         bitmap_copy(bitmap, src, round_down(nbits, BITS_PER_LONG)); 
> 
>         /* now copy part of last word per-byte */
>         ...
>     #else
> 	__bitmap_from_arr32(bitmap, buf, nbits);
>     #endif
> 
> This should be better because it uses fast bitmap_copy() regardless
> the number of bits. Assuming bitmap_copy() is significantly faster
> than bitmap_from_arr(), people will be surprised by the difference of
> speed of copying, say, 2048 and 2049-bit bitmaps. Right?
> 
> But unless we'll see real numbers, it's questionable to me if that's
> worth the effort.

Nice suggestion, thanks! I'll retest all I have and then we'll see.

> 
> Thanks,
> Yury

Thanks,
Olek
