Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8CF6C0633
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 00:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjCSXAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 19:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCSXAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 19:00:21 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E4A12BFE;
        Sun, 19 Mar 2023 16:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679266819; x=1710802819;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=s4BG9r1dyTLxYEqUOdUn0mdobQsXAN0A78/09axaYy4=;
  b=hrdzPqFieTJdJDpo2anb72iNhKRIEyfNIxMtnTL0u3B/r6wGSuzaB9y6
   sPufyYZKJrK/mXEp6bvDL7xYnnktbMyb8ZGSXQG3Lmy6CaORUx6lq/Oh2
   0gE0v76LIkZWaBJP4yd2+c8cNBlVTC9ZLtiZZguvL0kTHXeMbHurtrX2Y
   4p7uG8emmrfHwewudNbvzDFXfwGMQujQ3j4XOPAeUV/JjkwbSNxs7gXKn
   XtySmeZptT0bfTtGpCZUhe4WFjrjIjSH7WPc9OgbzT58TBtGJmoOgYbzJ
   8cyyoXK5RmLqeguPH8w/TvYMXbfkqtywnj1ssdwJ30dfnbgiPUxW5bUBE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="326914236"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="326914236"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 16:00:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="791382656"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="791382656"
Received: from msbunten-mobl1.amr.corp.intel.com (HELO intel.com) ([10.251.221.102])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 16:00:14 -0700
Date:   Sun, 19 Mar 2023 23:59:49 +0100
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [Intel-gfx] [PATCH v4 01/10] lib/ref_tracker: add unlocked leak
 print helper
Message-ID: <ZBeT5cWWqY4hkqu6@ashyti-mobl2.lan>
References: <20230224-track_gt-v4-0-464e8ab4c9ab@intel.com>
 <20230224-track_gt-v4-1-464e8ab4c9ab@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-track_gt-v4-1-464e8ab4c9ab@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrzej,

[...]

> diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
> index dc7b14aa3431e2..5e9f90bbf771b0 100644
> --- a/lib/ref_tracker.c
> +++ b/lib/ref_tracker.c
> @@ -14,6 +14,38 @@ struct ref_tracker {
>  	depot_stack_handle_t	free_stack_handle;
>  };
>  
> +void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
> +			   unsigned int display_limit)

can we call this ref_tracker_dir_print_locked() instead of using
the '__'?

> +{
> +	struct ref_tracker *tracker;
> +	unsigned int i = 0;
> +
> +	lockdep_assert_held(&dir->lock);
> +
> +	list_for_each_entry(tracker, &dir->list, head) {
> +		if (i < display_limit) {
> +			pr_err("leaked reference.\n");
> +			if (tracker->alloc_stack_handle)
> +				stack_depot_print(tracker->alloc_stack_handle);
> +			i++;
> +		} else {
> +			break;
> +		}
> +	}
> +}
> +EXPORT_SYMBOL(__ref_tracker_dir_print);
> +
> +void ref_tracker_dir_print(struct ref_tracker_dir *dir,
> +			   unsigned int display_limit)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dir->lock, flags);
> +	__ref_tracker_dir_print(dir, display_limit);
> +	spin_unlock_irqrestore(&dir->lock, flags);
> +}
> +EXPORT_SYMBOL(ref_tracker_dir_print);
> +
>  void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
>  {
>  	struct ref_tracker *tracker, *n;
> @@ -27,13 +59,13 @@ void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
>  		kfree(tracker);
>  		dir->quarantine_avail++;
>  	}
> -	list_for_each_entry_safe(tracker, n, &dir->list, head) {
> -		pr_err("leaked reference.\n");
> -		if (tracker->alloc_stack_handle)
> -			stack_depot_print(tracker->alloc_stack_handle);
> +	if (!list_empty(&dir->list)) {
> +		__ref_tracker_dir_print(dir, 16);
>  		leak = true;
> -		list_del(&tracker->head);
> -		kfree(tracker);
> +		list_for_each_entry_safe(tracker, n, &dir->list, head) {
> +			list_del(&tracker->head);
> +			kfree(tracker);
> +		}

Just thinking whether this should go on a different patch, but I
don't have a strong opinion.

Looks good!

Andi
