Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43F06BB681
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbjCOOu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbjCOOu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:50:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D14260ABB;
        Wed, 15 Mar 2023 07:50:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E718B81DED;
        Wed, 15 Mar 2023 14:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04E0C433D2;
        Wed, 15 Mar 2023 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678891853;
        bh=wu9HXojxuH3AtIIT++MDX+kORwbWO7Y7OZ2upGm0F4g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ni/Hy4a5bJJNljjXzq8+c+485351OSOzfK6nHpUHJ4HBGlkidr8j4Ww1Q2RuUYgEe
         lM5RbzfsBlmTzMjurrLTYOKIicKITAeEXSadq2NXDNsMcKwXsyPhg3vCx7v0CyTaak
         Z1qShw49YNGDF0tf6+ts62FOZRD9PlrCnILgFgnC35g53MgiBu90OrC3zTB/FcmJEK
         PKsfzxa0MxPOdZDiIZPNF+SDQExt+L394j+lmThmbsIPDvHm+0Tf3KZO/wl52yIt2d
         qMM0Wh8SIAXaTwmSBaHY3xxbfGMEQcmci4HTUz6ClZ9Ais/uNviMgqBYxzb83kZopJ
         6jQsgqvSec0DQ==
Date:   Wed, 15 Mar 2023 16:50:34 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Mike Rapoport <mike.rapoport@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 7/7] mm/slab: document kfree() as allowed for
 kmem_cache_alloc() objects
Message-ID: <ZBHbOrk3P3TXSkK8@kernel.org>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-8-vbabka@suse.cz>
 <ZA2ic9JYXGVzps1+@kernel.org>
 <14043bee-af7d-38f3-5a46-f63940e56c1e@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14043bee-af7d-38f3-5a46-f63940e56c1e@suse.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 02:38:47PM +0100, Vlastimil Babka wrote:
> On 3/12/23 10:59, Mike Rapoport wrote:
> > On Fri, Mar 10, 2023 at 11:32:09AM +0100, Vlastimil Babka wrote:
> >> This will make it easier to free objects in situations when they can
> >> come from either kmalloc() or kmem_cache_alloc(), and also allow
> >> kfree_rcu() for freeing objects from kmem_cache_alloc().
> >> 
> >> For the SLAB and SLUB allocators this was always possible so with SLOB
> >> gone, we can document it as supported.
> >> 
> >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >> Cc: Mike Rapoport <rppt@kernel.org>
> >> Cc: Jonathan Corbet <corbet@lwn.net>
> >> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> >> Cc: Frederic Weisbecker <frederic@kernel.org>
> >> Cc: Neeraj Upadhyay <quic_neeraju@quicinc.com>
> >> Cc: Josh Triplett <josh@joshtriplett.org>
> >> Cc: Steven Rostedt <rostedt@goodmis.org>
> >> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> >> Cc: Joel Fernandes <joel@joelfernandes.org>
> >> ---
> >>  Documentation/core-api/memory-allocation.rst | 15 +++++++++++----
> >>  include/linux/rcupdate.h                     |  6 ++++--
> >>  mm/slab_common.c                             |  5 +----
> >>  3 files changed, 16 insertions(+), 10 deletions(-)
> >> 
> >> diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
> >> index 5954ddf6ee13..f9e8d352ed67 100644
> >> --- a/Documentation/core-api/memory-allocation.rst
> >> +++ b/Documentation/core-api/memory-allocation.rst
> >> @@ -170,7 +170,14 @@ should be used if a part of the cache might be copied to the userspace.
> >>  After the cache is created kmem_cache_alloc() and its convenience
> >>  wrappers can allocate memory from that cache.
> >>  
> >> -When the allocated memory is no longer needed it must be freed. You can
> >> -use kvfree() for the memory allocated with `kmalloc`, `vmalloc` and
> >> -`kvmalloc`. The slab caches should be freed with kmem_cache_free(). And
> >> -don't forget to destroy the cache with kmem_cache_destroy().
> >> +When the allocated memory is no longer needed it must be freed. Objects
> > 
> > I'd add a line break before Objects                               ^
> > 
> >> +allocated by `kmalloc` can be freed by `kfree` or `kvfree`.
> >> +Objects allocated by `kmem_cache_alloc` can be freed with `kmem_cache_free`
> >> +or also by `kfree` or `kvfree`, which can be more convenient as it does
> > 
> > Maybe replace 'or also by' with a coma:
> > 
> > Objects allocated by `kmem_cache_alloc` can be freed with `kmem_cache_free`,
> > `kfree` or `kvfree`, which can be more convenient as it does
> 
> But then I need to clarify what the "which" applies to?

Yeah, I kinda missed that...

> > 
> >> +not require the kmem_cache pointed.
> > 
> >                              ^ pointer.
> > 
> >> +The rules for _bulk and _rcu flavors of freeing functions are analogical.
> > 
> > Maybe 
> > 
> > The same rules apply to _bulk and _rcu flavors of freeing functions.
> 
> So like this incremental diff?
 
> diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
> index f9e8d352ed67..1c58d883b273 100644
> --- a/Documentation/core-api/memory-allocation.rst
> +++ b/Documentation/core-api/memory-allocation.rst
> @@ -170,12 +170,14 @@ should be used if a part of the cache might be copied to the userspace.
>  After the cache is created kmem_cache_alloc() and its convenience
>  wrappers can allocate memory from that cache.
>  
> -When the allocated memory is no longer needed it must be freed. Objects
> -allocated by `kmalloc` can be freed by `kfree` or `kvfree`.
> -Objects allocated by `kmem_cache_alloc` can be freed with `kmem_cache_free`
> -or also by `kfree` or `kvfree`, which can be more convenient as it does
> -not require the kmem_cache pointed.
> -The rules for _bulk and _rcu flavors of freeing functions are analogical.
> +When the allocated memory is no longer needed it must be freed.
> +
> +Objects allocated by `kmalloc` can be freed by `kfree` or `kvfree`. Objects
> +allocated by `kmem_cache_alloc` can be freed with `kmem_cache_free`, `kfree`
> +or `kvfree`, where the latter two might be more convenient thanks to not
> +needing the kmem_cache pointer.

... but this way it's more explicit that kfree and kvfree don't need
kmem_cache pointer.

> +
> +The same rules apply to _bulk and _rcu flavors of freeing functions.
>  
>  Memory allocated by `vmalloc` can be freed with `vfree` or `kvfree`.
>  Memory allocated by `kvmalloc` can be freed with `kvfree`.
> 

-- 
Sincerely yours,
Mike.
