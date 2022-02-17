Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F113A4BA448
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242407AbiBQPYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:24:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242335AbiBQPYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:24:03 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5792C2B1033
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:23:43 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2d66f95f1d1so35430687b3.0
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eHgl2T651ZUAY0dUPlPE7t+ZMJITI1iQLNfhsdAOi9A=;
        b=OyyGSpGsXoRUMe1+VpsE32Jzw9pC/T/sEcDlrwAfqTzFtyGDBuqSpPNuEl6SeVR0Qs
         AFKDV5ZQ+hSEpEmAZEquWsQhiHVRa+51dPltVToyoWlHiWM3F05pRItVl0UKT0SKGTD6
         Gnd0oITi7nX9dnvZedukOqsSj7dQH0gNGnogTJVu7dGl1enSylVzxd6sIOsMS/AB86YP
         A/Bue505Xt+429q5JQ96dXyKTLgWr3e0sJXowp398lVnEJS7amIKej8Lhrr6MbHdPkmV
         V1EDN4J9TgejynO66RlqTRvfaiuXkOCZFK/K+elmI9ZrPXgNaVLtbF1hH+O9ZN5vseEv
         BpKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eHgl2T651ZUAY0dUPlPE7t+ZMJITI1iQLNfhsdAOi9A=;
        b=q14IfPY05gaEgTwcDXZVa2B/APaNJg0auyHyMPnktGpfUqGx1EyiO6fNpW1ZgNjEHL
         XSZLh0uP01Yd3g0CiEGM7vj+liya/BPv+TpuzPeAs2rvOjp+NFyoiw+Z7WCdRKQyDTIg
         oP85ihjqM5jmiY4UVol04HeHJb2hK1PS4cXEDYuE+lJy1f8NwE5thmo9iy2kxRO2DoA5
         Vu/prm6KYxS7KR/6tgDJ0riBpEr5jGR1fnWhb7j/Df7YEwbkdcYawTYIRDZlENAGoueg
         fjC/kctPT4ZBdW0T4uWzb2GJeBJ41UqjQbVlKpnVxuXA5Y4KX6lyYCPDucxC+cDSztVa
         jX+Q==
X-Gm-Message-State: AOAM5301uO4V1r/EeI8UgFQ/T4WBNJD60q0kRC3OLxkmKDdX7QTQMdv5
        +7I0/TdFjloQMlCiQREbCX4P7nBDA+vcCevnhjfWBA==
X-Google-Smtp-Source: ABdhPJxz5oowmiHJjEfemLbZOdX9nQtJEvLXg9XI3jQCQQwFJ1+9KfpYgOqyvfPS/LNFkEGjad8EoMOsgMFm6yB5kso=
X-Received: by 2002:a81:91d2:0:b0:2d6:af3d:c93 with SMTP id
 i201-20020a8191d2000000b002d6af3d0c93mr1481740ywg.467.1645111422161; Thu, 17
 Feb 2022 07:23:42 -0800 (PST)
MIME-Version: 1.0
References: <20220217140441.1218045-1-andrzej.hajda@intel.com> <20220217140441.1218045-3-andrzej.hajda@intel.com>
In-Reply-To: <20220217140441.1218045-3-andrzej.hajda@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Feb 2022 07:23:31 -0800
Message-ID: <CANn89iKgzztLA3y6V+vw3RiyoScC3K=1Z1_gajj8H56wGWDw6A@mail.gmail.com>
Subject: Re: [PATCH 2/9] lib/ref_tracker: compact stacktraces before printing
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev <netdev@vger.kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 6:05 AM Andrzej Hajda <andrzej.hajda@intel.com> wrote:
>
> In cases references are taken alternately on multiple exec paths leak
> report can grow substantially, sorting and grouping leaks by stack_handle
> allows to compact it.
>
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
> Reviewed-by: Chris Wilson <chris.p.wilson@intel.com>
> ---
>  lib/ref_tracker.c | 35 +++++++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 8 deletions(-)
>
> diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
> index 1b0c6d645d64a..0e9c7d2828ccb 100644
> --- a/lib/ref_tracker.c
> +++ b/lib/ref_tracker.c
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0-or-later
>  #include <linux/export.h>
> +#include <linux/list_sort.h>
>  #include <linux/ref_tracker.h>
>  #include <linux/slab.h>
>  #include <linux/stacktrace.h>
> @@ -14,23 +15,41 @@ struct ref_tracker {
>         depot_stack_handle_t    free_stack_handle;
>  };
>
> +static int ref_tracker_cmp(void *priv, const struct list_head *a, const struct list_head *b)
> +{
> +       const struct ref_tracker *ta = list_entry(a, const struct ref_tracker, head);
> +       const struct ref_tracker *tb = list_entry(b, const struct ref_tracker, head);
> +
> +       return ta->alloc_stack_handle - tb->alloc_stack_handle;
> +}
> +
>  void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
>                            unsigned int display_limit)
>  {
> +       unsigned int i = 0, count = 0;
>         struct ref_tracker *tracker;
> -       unsigned int i = 0;
> +       depot_stack_handle_t stack;
>
>         lockdep_assert_held(&dir->lock);
>
> +       if (list_empty(&dir->list))
> +               return;
> +
> +       list_sort(NULL, &dir->list, ref_tracker_cmp);

What is going to be the cost of sorting a list with 1,000,000 items in it ?

I just want to make sure we do not trade printing at most ~10 references
(from netdev_wait_allrefs()) to a soft lockup :/ with no useful info
if something went terribly wrong.

I suggest that you do not sort a potential big list, and instead
attempt to allocate an array of @display_limits 'struct stack_counts'

I suspect @display_limits will always be kept to a reasonable value
(less than 100 ?)

struct stack_counts {
    depot_stack_handle_t stack_handle;
    unsigned int count;
}

Then, iterating the list and update the array (that you can keep
sorted by ->stack_handle)

Then after iterating, print the (at_most) @display_limits handles
found in the temp array.

> +
>         list_for_each_entry(tracker, &dir->list, head) {
> -               if (i < display_limit) {
> -                       pr_err("leaked reference.\n");
> -                       if (tracker->alloc_stack_handle)
> -                               stack_depot_print(tracker->alloc_stack_handle);
> -                       i++;
> -               } else {
> +               if (i++ >= display_limit)
>                         break;
> -               }
> +               if (!count++)
> +                       stack = tracker->alloc_stack_handle;
> +               if (stack == tracker->alloc_stack_handle &&
> +                   !list_is_last(&tracker->head, &dir->list))
> +                       continue;
> +
> +               pr_err("leaked %d references.\n", count);
> +               if (stack)
> +                       stack_depot_print(stack);
> +               count = 0;
>         }
>  }
>  EXPORT_SYMBOL(__ref_tracker_dir_print);
> --
> 2.25.1
>
