Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87553510BBB
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 00:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355661AbiDZWQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 18:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiDZWQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 18:16:31 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527933BF86;
        Tue, 26 Apr 2022 15:13:22 -0700 (PDT)
Date:   Tue, 26 Apr 2022 15:13:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1651011200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ONCBO+e5tQXeuB1xqqICB6bR57S4tXEQxOiBCuhrW/I=;
        b=OOGII0HetFVOSjsZLi1gd3RE3w3HK4eGA85+lFWnNQINk7PsQUCLJ6D1oUhrMf5JkaAujg
        XDzi8sLsAZF/tBbAdHmIYRTcyhoA+SwIJWTb/ZqtXVoQRxGvN4ArsCo2kGa35XnhRbuRUC
        RvV9i34s3cE/gM7iK4P2z0BJnQu+bA8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Vasily Averin <vvs@openvz.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeelb@google.com>, kernel@openvz.org,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks
 allocations
Message-ID: <YmhueUucXP6RjMaR@carbon>
References: <YmdeCqi6wmgiSiWh@carbon>
 <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 09:43:43AM +0300, Vasily Averin wrote:
> __register_pernet_operations() executes init hook of registered
> pernet_operation structure in all existing net namespaces.
> 
> Typically, these hooks are called by a process associated with
> the specified net namespace, and all __GFP_ACCOUNT marked
> allocation are accounted for corresponding container/memcg.
> 
> However __register_pernet_operations() calls the hooks in the same
> context, and as a result all marked allocations are accounted
> to one memcg for all processed net namespaces.
> 
> This patch adjusts active memcg for each net namespace and helps
> to account memory allocated inside ops_init() into the proper memcg.
> 
> Signed-off-by: Vasily Averin <vvs@openvz.org>
> ---
> v4: get_mem_cgroup_from_kmem() renamed to get_mem_cgroup_from_obj(),
>     get_net_memcg() replaced by mem_cgroup_or_root(), suggested by Roman.
> 
> v3: put_net_memcg() replaced by an alreay existing mem_cgroup_put()
>     It checks memcg before accessing it, this is required for
>     __register_pernet_operations() called before memcg initialization.
>     Additionally fixed leading whitespaces in non-memcg_kmem version
>     of mem_cgroup_from_obj().
> 
> v2: introduced get/put_net_memcg(),
>     new functions are moved under CONFIG_MEMCG_KMEM
>     to fix compilation issues reported by Intel's kernel test robot
> 
> v1: introduced get_mem_cgroup_from_kmem(), which takes the refcount
>     for the found memcg, suggested by Shakeel
> ---
>  include/linux/memcontrol.h | 27 ++++++++++++++++++++++++++-
>  net/core/net_namespace.c   |  7 +++++++
>  2 files changed, 33 insertions(+), 1 deletion(-)

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
