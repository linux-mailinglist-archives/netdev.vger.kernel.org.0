Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FEF6CD9A6
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjC2MwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjC2MwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:52:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BD61707;
        Wed, 29 Mar 2023 05:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680094328; x=1711630328;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JYQNzSG0sA9n+CdvfVfHs6vcGajSiMyhZ3Q5AzZfSCo=;
  b=RRTHrU/oFSs89W/43FaVNfM+usW/H0ELylUqieByxM3kZVGaRQqSKrSD
   43acC61kD9OMsclr+oh3pg71PodKFMWWOlXhMKGAgzGcdgSUdlD4BxR1R
   9/+8t3dcasdqlAMkjZk7VzCTHj6jZ61bEaCT7+QqC5WLsVsPmeH18viBq
   xlFBhm0JgiiyA0DRgkwRNC6AaELDRtmHDwChsr3x+1KMwQxXRDhz6+VjH
   QTILU4en0hPT6am7NsgAR6usnVw/XbQF3inaCrE6Qpe2+gidj4NIPRbqh
   Ed1+PyeLHLPAGpBH8kgJ8bH+iagvhaCFx5MdwIRVtMewbKYXRRG8qUXuW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="324769433"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="324769433"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 05:52:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="677768924"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="677768924"
Received: from ostermam-mobl.amr.corp.intel.com (HELO intel.com) ([10.249.32.144])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 05:52:02 -0700
Date:   Wed, 29 Mar 2023 14:51:37 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andi Shyti <andi.shyti@linux.intel.com>
Subject: Re: [PATCH v6 2/8] lib/ref_tracker: improve printing stats
Message-ID: <ZCQ0WSnZ9L2NFsvA@ashyti-mobl2.lan>
References: <20230224-track_gt-v6-0-0dc8601fd02f@intel.com>
 <20230224-track_gt-v6-2-0dc8601fd02f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-track_gt-v6-2-0dc8601fd02f@intel.com>
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrzej,

[...]

> -void ref_tracker_dir_print_locked(struct ref_tracker_dir *dir,
> -				  unsigned int display_limit)
> +struct ref_tracker_dir_stats {
> +	int total;
> +	int count;
> +	struct {
> +		depot_stack_handle_t stack_handle;
> +		unsigned int count;
> +	} stacks[];
> +};
> +
> +static struct ref_tracker_dir_stats *
> +ref_tracker_get_stats(struct ref_tracker_dir *dir, unsigned int limit)
>  {
> +	struct ref_tracker_dir_stats *stats;
>  	struct ref_tracker *tracker;
> -	unsigned int i = 0;
>  
> -	lockdep_assert_held(&dir->lock);
> +	stats = kmalloc(struct_size(stats, stacks, limit),
> +			GFP_NOWAIT | __GFP_NOWARN);
> +	if (!stats)
> +		return ERR_PTR(-ENOMEM);
> +	stats->total = 0;
> +	stats->count = 0;
>  
>  	list_for_each_entry(tracker, &dir->list, head) {
> -		if (i < display_limit) {
> -			pr_err("leaked reference.\n");
> -			if (tracker->alloc_stack_handle)
> -				stack_depot_print(tracker->alloc_stack_handle);
> -			i++;
> -		} else {
> -			break;
> +		depot_stack_handle_t stack = tracker->alloc_stack_handle;
> +		int i;
> +
> +		++stats->total;
> +		for (i = 0; i < stats->count; ++i)
> +			if (stats->stacks[i].stack_handle == stack)
> +				break;
> +		if (i >= limit)
> +			continue;
> +		if (i >= stats->count) {
> +			stats->stacks[i].stack_handle = stack;
> +			stats->stacks[i].count = 0;
> +			++stats->count;
>  		}
> +		++stats->stacks[i].count;
> +	}
> +
> +	return stats;
> +}
> +
> +void ref_tracker_dir_print_locked(struct ref_tracker_dir *dir,
> +				  unsigned int display_limit)
> +{
> +	struct ref_tracker_dir_stats *stats;
> +	unsigned int i = 0, skipped;
> +	depot_stack_handle_t stack;
> +	char *sbuf;
> +
> +	lockdep_assert_held(&dir->lock);
> +
> +	if (list_empty(&dir->list))
> +		return;
> +
> +	stats = ref_tracker_get_stats(dir, display_limit);
> +	if (IS_ERR(stats)) {
> +		pr_err("%s@%pK: couldn't get stats, error %pe\n",
> +		       dir->name, dir, stats);
> +		return;
>  	}
> +
> +	sbuf = kmalloc(STACK_BUF_SIZE, GFP_NOWAIT | __GFP_NOWARN);
> +
> +	for (i = 0, skipped = stats->total; i < stats->count; ++i) {
> +		stack = stats->stacks[i].stack_handle;
> +		if (sbuf && !stack_depot_snprint(stack, sbuf, STACK_BUF_SIZE, 4))
> +			sbuf[0] = 0;
> +		pr_err("%s@%pK has %d/%d users at\n%s\n", dir->name, dir,
> +		       stats->stacks[i].count, stats->total, sbuf);
> +		skipped -= stats->stacks[i].count;
> +	}
> +
> +	if (skipped)
> +		pr_err("%s@%pK skipped reports about %d/%d users.\n",
> +		       dir->name, dir, skipped, stats->total);
> +
> +	kfree(sbuf);
> +
> +	kfree(stats);

There's a chance of confusion here because
ref_tracker_get_stats() might need a ref_tracker_put_stats() to
go with it.

When you allocate in one function and free in another without a
clear pair (get/put, alloc/free, etc.), it can be hard to notice
and could lead to mistakes.

But in this simple situation, it's not a big problem, and I'm not
sure if having the put side is really needed.

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com> 

Thanks,
Andi

>  }
>  EXPORT_SYMBOL(ref_tracker_dir_print_locked);
>  
> 
> -- 
> 2.34.1
