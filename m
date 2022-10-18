Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419F1602E0D
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiJRONl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJRONj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:13:39 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD781E708;
        Tue, 18 Oct 2022 07:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666102417; x=1697638417;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=94bOPuLfvb++UsTwZ2og0iogtTMZkU8RTP6q7KeUdqA=;
  b=ZHeMV3GbYxmapXRl3k0sOtgmMzN54mG2I9b9Ta2QJIbu/LjAolKysjrz
   KcBkOZo7fI4Df0qVfYB/DV8RfCQx1fllVadYMzU4Lstx40G0EB0jj0bg/
   Vo0doYHxK76utw0HxaCAsIpYTI6UnulGJtXIVfhBxG55TT+7BisHbhRMh
   Y+LfYgAx29Vy7QQ5MQJZu9U+F3CRFVZcuABgaSB334yGxR4t48CwitPHg
   PwhPNsG0OF83L0URH/4A8i7tB7VJgwz52lLYB1SwOfm0zSFaZqm2O659m
   BbK+V0nrmROf7X0LuMfwgoXvs1HK4RgShowAyOlgY1VHNE3dsMKuwSuCw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="306097558"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="306097558"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 07:13:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="754061907"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="754061907"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga004.jf.intel.com with ESMTP; 18 Oct 2022 07:13:32 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oknLW-009PYY-1H;
        Tue, 18 Oct 2022 17:13:30 +0300
Date:   Tue, 18 Oct 2022 17:13:30 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 6/6] netlink: add universal 'bigint'
 attribute type
Message-ID: <Y060io/942BpWpQw@smile.fi.intel.com>
References: <20221018140027.48086-1-alexandr.lobakin@intel.com>
 <20221018140027.48086-7-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018140027.48086-7-alexandr.lobakin@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 04:00:27PM +0200, Alexander Lobakin wrote:
> Add a new type of Netlink attribute -- big integer.
> 
> Basically bigints are just arrays of u32s, but can carry anything,
> with 1 bit precision. Using variable-length arrays of a fixed type
> gives the following:
> 
> * versatility: one type can carry scalars from u8 to u64, bitmaps,
>   binary data etc.;
> * scalability: the same Netlink attribute can be changed to a wider
>   (or shorter) data type with no compatibility issues, same for
>   growing bitmaps;
> * optimization: 4-byte units don't require wasting slots for empty
>   padding attributes (they always have natural alignment in Netlink
>   messages).
> 
> The only downside is that get/put functions sometimes are not just
> direct assignment inlines due to the internal representation using
> bitmaps (longs) and the bitmap API.
> 
> Basic consumer functions/macros are:
> * nla_put_bigint() and nla_get_bigint() -- to easily put a bigint to
>   an skb or get it from a received message (only pointer to an
>   unsigned long array and the number of bits in it are needed);
> * nla_put_bigint_{u,be,le,net}{8,16,32,64}() -- alternatives to the
>   already existing family to send/receive scalars using the new type
>   (instead of distinct attr types);
> * nla_total_size_bigint*() -- to provide estimate size in bytes to
>   Netlink needed to store a bigint/type;
> * NLA_POLICY_BIGINT*() -- to declare a Netlink policy for a bigint
>   attribute.
> 
> There are also *_bitmap() aliases for the *_bigint() helpers which
> have no differences and designed to distinguish bigints from bitmaps
> in the call sites (for readability).
> 
> Netlink policy for a bigint can have an optional bitmap mask of bits
> supported by the code -- for example, to filter out obsolete bits
> removed some time ago or limit value to n bits (e.g. 53 instead of
> 64). Without it, Netlink will just make sure no bits past the passed
> number are set. Both variants can be requested from the userspace
> and the kernel will put a mask into a new policy attribute
> (%NL_POLICY_TYPE_ATTR_BIGINT_MASK).
> 
> Note on including <linux/bitmap.h> into <net/netlink.h>: seems to
> introduce no visible compilation time regressions, make includecheck
> doesn't see anything illegit as well. Hiding everything inside
> lib/nlattr.c would require making a couple dozens optimizable
> inlines external, doesn't sound optimal.

...

>  #ifndef __NET_NETLINK_H
>  #define __NET_NETLINK_H
>  
> -#include <linux/types.h>
> +#include <linux/bitmap.h>

types.h is not guaranteed to be included by bitmap.h. So, if you want to
clean up the headers in this header, do it in a separate change.

Also I would suggest to check what Ingo did in his 2000+ patch series
to see if there is anything interesting towards this header.

>  #include <linux/netlink.h>
>  #include <linux/jiffies.h>
>  #include <linux/in6.h>

-- 
With Best Regards,
Andy Shevchenko


