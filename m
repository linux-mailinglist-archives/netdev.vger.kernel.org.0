Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02AD59B702
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 02:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiHVAUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 20:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbiHVAUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 20:20:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D912018F
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 17:20:52 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e21so7035269edc.7
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 17:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=itKnzEEgxdRanMi9GUPBS95li3Z7do6JuAGWEAWhYEg=;
        b=guVICWeqFQ8c3vdR8GBUuEyOVA0+5EO5OmTjHqWEu6VFAbXZCzD8du432ghmvYgJhQ
         RvhjnmWNjHAres1/WFOa7u85aN+wL7vVAGauR2TkbUDtfiEBAXM8d8woD4OK3YR4i9By
         ROoju+R4k73Q8z6CL8yQaelkmRtkkt2ChGCPVsaia6rbwlV4wz6sduV7nkHR4czQ01aV
         nTYqLzKSWXx8g3YTHTp1n3tr3K0/HL5bsdRB9fZYGzYXdMycMvI6WQgC+dNqstFVupCb
         Dr7SNfpCd7U3oIUkjp6zD1NCoV474OmknfhA3jNoJFdCbarhzlTJZXkn6gHjiS5kG4O4
         fcTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=itKnzEEgxdRanMi9GUPBS95li3Z7do6JuAGWEAWhYEg=;
        b=tbFl9xM0HzZa5BvvSqza8fhyNGmgO4/x7NjiBsd1DIwXe/+mrLgBlwsrD/3fAFDVWl
         +V7GOzMiWWWS6IfMoJVtSKw4TVnkGnjrvV+RjTYuTeUJQ3eu53gZai3jkmpguzhKOVvp
         zA7DpX4/qKEJ9qByi8fZJN4LpyTqk2xjSb9Cif30gpaicSWD+TTvCSNO9BaixPCFU/Wi
         SvJ0Ho+uRB4LRDnJeKriNaLd3PYcjBEaMLmONxwGeYg0bl+upJYyEyuAPVRb86Ypq2mC
         5CC0TSfrKu0bHv+eX7oh6kGPDymwav+QHjNURjqIhusLhuX7vsyPH3Yane7u55lyotLM
         RCdg==
X-Gm-Message-State: ACgBeo1LTI6w1cFZnwirGGCMMqs5bOQR/ln+my7c+l6XdNTIrPV8EX1X
        Z+xIZFl3AUL1qXmq64T36ehgrbcEHulEJoYhDfUDag==
X-Google-Smtp-Source: AA6agR6lSgQcCZCvUYP8FRcUweR76r3Cilqo11shbVm7XXhBywGbxJf+ReHNDI1Bu4CF5Iaxy+qp6DBFFwaZW8Mqmh4=
X-Received: by 2002:a05:6402:5ca:b0:43b:6e01:482c with SMTP id
 n10-20020a05640205ca00b0043b6e01482cmr14637867edx.189.1661127650293; Sun, 21
 Aug 2022 17:20:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-2-shakeelb@google.com>
In-Reply-To: <20220822001737.4120417-2-shakeelb@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Sun, 21 Aug 2022 20:20:14 -0400
Message-ID: <CACSApvbSnCN8Fy1E3KyhkBDF=_h4vg==eoJGzM1Njf0ArX+zcg@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: page_counter: remove unneeded atomic ops for low/min
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 21, 2022 at 8:17 PM Shakeel Butt <shakeelb@google.com> wrote:
>
> For cgroups using low or min protections, the function
> propagate_protected_usage() was doing an atomic xchg() operation
> irrespectively. It only needs to do that operation if the new value of
> protection is different from older one. This patch does that.
>
> To evaluate the impact of this optimization, on a 72 CPUs machine, we
> ran the following workload in a three level of cgroup hierarchy with top
> level having min and low setup appropriately. More specifically
> memory.min equal to size of netperf binary and memory.low double of
> that.
>
>  $ netserver -6
>  # 36 instances of netperf with following params
>  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
>
> Results (average throughput of netperf):
> Without (6.0-rc1)       10482.7 Mbps
> With patch              14542.5 Mbps (38.7% improvement)
>
> With the patch, the throughput improved by 38.7%
>
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>

Nice speed up!

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  mm/page_counter.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index eb156ff5d603..47711aa28161 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -17,24 +17,23 @@ static void propagate_protected_usage(struct page_counter *c,
>                                       unsigned long usage)
>  {
>         unsigned long protected, old_protected;
> -       unsigned long low, min;
>         long delta;
>
>         if (!c->parent)
>                 return;
>
> -       min = READ_ONCE(c->min);
> -       if (min || atomic_long_read(&c->min_usage)) {
> -               protected = min(usage, min);
> +       protected = min(usage, READ_ONCE(c->min));
> +       old_protected = atomic_long_read(&c->min_usage);
> +       if (protected != old_protected) {
>                 old_protected = atomic_long_xchg(&c->min_usage, protected);
>                 delta = protected - old_protected;
>                 if (delta)
>                         atomic_long_add(delta, &c->parent->children_min_usage);
>         }
>
> -       low = READ_ONCE(c->low);
> -       if (low || atomic_long_read(&c->low_usage)) {
> -               protected = min(usage, low);
> +       protected = min(usage, READ_ONCE(c->low));
> +       old_protected = atomic_long_read(&c->low_usage);
> +       if (protected != old_protected) {
>                 old_protected = atomic_long_xchg(&c->low_usage, protected);
>                 delta = protected - old_protected;
>                 if (delta)
> --
> 2.37.1.595.g718a3a8f04-goog
>
