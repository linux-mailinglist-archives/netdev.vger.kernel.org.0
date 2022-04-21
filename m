Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C23050A4C3
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 17:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbiDUP7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 11:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiDUP7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 11:59:14 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D7941304
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 08:56:23 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id bg9so4987981pgb.9
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 08:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tb6I/vNw4MkH6cXJACmThyQFIFSwo0v3WzOA2XSKmSs=;
        b=hkeImdbTeSMXSMeckvO9JBqgK+ypyTZt/okKK7TMyp+Jj42kGAhZ/7QBcpqgOpnqZj
         gGCX5b138SAqJNu67mSEPBS6HjBSc3NUwwii2N9q3VIj1j6hfggpfT0NzCG9RSRX5XzX
         nem4EvlLHjThukcbQCBeuQSpwwkuANGAiKT4jdpMxO+QaID+CZCjyfdsqCFNkXN894SL
         ibNTaINtlSpFjl1GBaz7n+xDgttL7ngW7o2eXndy6RqXfSveGmsHbAN72F463+yh9jhQ
         LwpxF/i4bpdWG8LRcg6N36V32wZxeba+ZnbpooMdNjNU398VMLDoMlcqVKTjzjuxKwPh
         7KWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tb6I/vNw4MkH6cXJACmThyQFIFSwo0v3WzOA2XSKmSs=;
        b=FLXF/OtCQ2wRgXLu6wD4/lybmPW7PycbR0ibD3I/0kWGQr4FRFgHhEAE+QOwubDGB1
         p+ZVX0eVQxIjSpKHQNL+P3/ulYupya0eQohWZyvaSJbui9knIbziDn+VRF6w0yP8DZpY
         tMj/HJmFToKyB5RpDRJw4X7rxRHkYqDoQeT/3EM3J6A7HZw3MTEZFuwFuiVVlHaKLPL/
         dA3dtYnQtsBsl8YoKJ8w8zIQGC83CU2T/wSDopU/ilSLZyFiey5Fyj/wW5CFwFWEwB1P
         8yReuvwfSqxffjR7K1xsJzUHQAN4k0GahupYDiblWerSF/Iz3uIPLotF2cAZXgLGziin
         2ijQ==
X-Gm-Message-State: AOAM530Z8lXr1t3SNW7/3T7WJHOCTsahM95EfvXKuQ1fxP9WbJsD9MRc
        6TfwVSbSK7RRQBvH2NPUKcP9uDBOTDZ37aAA04kiGg==
X-Google-Smtp-Source: ABdhPJzl3m2COqyb0vmSqE7CigU3O3oCUJAkex/AAQkQPfRDhlCItCldOZZiRmn4K+gJ/4u1hsqVXRz0RihG4QjuGGM=
X-Received: by 2002:a63:9502:0:b0:386:3916:ca8e with SMTP id
 p2-20020a639502000000b003863916ca8emr78805pgd.357.1650556582965; Thu, 21 Apr
 2022 08:56:22 -0700 (PDT)
MIME-Version: 1.0
References: <46c1c59e-1368-620d-e57a-f35c2c82084d@linux.dev> <55605876-d05a-8be3-a6ae-ec26de9ee178@openvz.org>
In-Reply-To: <55605876-d05a-8be3-a6ae-ec26de9ee178@openvz.org>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 21 Apr 2022 08:56:12 -0700
Message-ID: <CALvZod47PARcupR4P41p5XJRfCaTqSuy-cfXs7Ky9=-aJQuoFA@mail.gmail.com>
Subject: Re: [PATCH memcg RFC] net: set proper memcg for net_init hooks allocations
To:     Vasily Averin <vvs@openvz.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>, kernel@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 16, 2022 at 11:39 PM Vasily Averin <vvs@openvz.org> wrote:
>
> __register_pernet_operations() executes init hook of registered
> pernet_operation structure in all existing net namespaces.
>
> Typically, these hooks are called by a process associated with
> the specified net namespace, and all __GFP_ACCOUNTING marked
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
> Dear Vlastimil, Roman,
> I'm not sure that memcg is used correctly here,
> is it perhaps some additional locking required?
> ---
>  net/core/net_namespace.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index a5b5bb99c644..171c6e0b2337 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -26,6 +26,7 @@
>  #include <net/net_namespace.h>
>  #include <net/netns/generic.h>
>
> +#include <linux/sched/mm.h>
>  /*
>   *     Our network namespace constructor/destructor lists
>   */
> @@ -1147,7 +1148,13 @@ static int __register_pernet_operations(struct list_head *list,
>                  * setup_net() and cleanup_net() are not possible.
>                  */
>                 for_each_net(net) {
> +                       struct mem_cgroup *old, *memcg = NULL;
> +#ifdef CONFIG_MEMCG
> +                       memcg = (net == &init_net) ? root_mem_cgroup : mem_cgroup_from_obj(net);

memcg from obj is unstable, so you need a reference on memcg. You can
introduce get_mem_cgroup_from_kmem() which works for both
MEMCG_DATA_OBJCGS and MEMCG_DATA_KMEM. For uncharged objects (like
init_net) it should return NULL.

> +#endif
> +                       old = set_active_memcg(memcg);
>                         error = ops_init(ops, net);
> +                       set_active_memcg(old);
>                         if (error)
>                                 goto out_undo;
>                         list_add_tail(&net->exit_list, &net_exit_list);
> --
> 2.31.1
>
