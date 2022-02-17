Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6257A4BA40F
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242347AbiBQPNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:13:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241782AbiBQPNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:13:41 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E28294123
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:13:26 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2d66f95f1d1so35042447b3.0
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ue09UYaxTaEqS175+LfKF6ZQhoNdq+QTxAZ6/A1fP2M=;
        b=DbdZsHSudW3XTJiY+K1xA58iiJbLUQuB5eSPGNbbgrAQPf8IlmE03xiqg1+9wuD6fz
         prwczh4o+KUv8m47n1jAFn1qlfpy8WgmxUtJU/UkjM4IEiFhE+lKg/ImrzVwLl9cfwfr
         2GNgce03dRItFvEmtPhz8UhPt0AuJ3S9+3H5wTMYIgsXFNpN0hjy4pN2DVvhRasuX/eq
         0p33LNW5rO3BP2q6hlTUU+N6+1LwrNkcul1fnfrspmH5cI+FTRtcmC5a1ODWbB+hX/vG
         PykTm84tq45e7zRH6B+axrW4X3oQ+cbMYPhhkaugixg9Db8CDpkGUKfZhEErAOW4Grp6
         C+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ue09UYaxTaEqS175+LfKF6ZQhoNdq+QTxAZ6/A1fP2M=;
        b=p0BLs2u5XbtYuvne1j/hAfX9/dWkuqw09WD1TPIrRAVBojN5yl5lNSZGNxQheqSHI3
         8lLcYnn7UAVGAOXZnwZAhsfoYf6bkbB7Cftw+5eAWp0ZTupoMZU2clZqNvQ9V+/lXaMA
         salyn1LY1ItaFUSlYH9YOkkf5LOgfBnuIwuFwmpSnPzhzFB+ggZ3OukUwF5ajw5ik7fT
         7PLsrbrXqledTv5ljumQeVYZYw6lgjgaH/3MKihGRzr/Pi5DaNfCp+1V4gUkxMcM6CtA
         1zZb+aKoaHNcz1tNuvxI9CIBp8LTEy42Qfw2c0Q9Ys6YXeZGByE4n3G1tryAPgotjVnV
         G2sA==
X-Gm-Message-State: AOAM530MQA0T66g2+ulUY//r3CBxybbBXxX6Ozr3KPvKzYd25oz3Ig5R
        F5ysgUi92ZjReJfvhQSQKIoFrH/VacskXCjf7xtJKw==
X-Google-Smtp-Source: ABdhPJzbG6wC2LPbv8HnQDMoclI9DH40Jr8ukHtJRt4zE8if4FlSJ1G02bARjfum6c6K95QFlyMggt7miSl+zAX9Fpc=
X-Received: by 2002:a81:1516:0:b0:2d0:e7ca:2a5 with SMTP id
 22-20020a811516000000b002d0e7ca02a5mr2946109ywv.55.1645110804769; Thu, 17 Feb
 2022 07:13:24 -0800 (PST)
MIME-Version: 1.0
References: <20220217140441.1218045-1-andrzej.hajda@intel.com> <20220217140441.1218045-6-andrzej.hajda@intel.com>
In-Reply-To: <20220217140441.1218045-6-andrzej.hajda@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Feb 2022 07:13:13 -0800
Message-ID: <CANn89i+nCZ6LV_1E2OnJ4qWE0XkO2FGW+A6_tkmQpdxiiEh=LQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] lib/ref_tracker: improve allocation flags
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
> Library can be called in non-sleeping context, so it should not use
> __GFP_NOFAIL. Instead it should calmly handle allocation fails, for
> this __GFP_NOWARN has been added as well.

Your commit changelog is misleading .

The GFP_NOFAIL issue has been fixed already in
commit c12837d1bb31032bead9060dec99ef310d5b9fb7 ("ref_tracker: use
__GFP_NOFAIL more carefully")


>
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
> ---
>  lib/ref_tracker.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
> index 7b00bca300043..c8441ffbb058a 100644
> --- a/lib/ref_tracker.c
> +++ b/lib/ref_tracker.c
> @@ -59,7 +59,7 @@ __ref_tracker_dir_pr_ostream(struct ref_tracker_dir *dir,
>         if (list_empty(&dir->list))
>                 return;
>
> -       sbuf = kmalloc(STACK_BUF_SIZE, GFP_NOWAIT);
> +       sbuf = kmalloc(STACK_BUF_SIZE, GFP_NOWAIT | __GFP_NOWARN);

This belongs to patch 3 in your series.

>
>         list_for_each_entry(tracker, &dir->list, head)
>                 ++total;
> @@ -154,11 +154,11 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
>         unsigned long entries[REF_TRACKER_STACK_ENTRIES];
>         struct ref_tracker *tracker;
>         unsigned int nr_entries;
> -       gfp_t gfp_mask = gfp;

Simply change this line to : gfp_t gfp_mask = gfp | __GFP_NOFAIL;

> +       gfp_t gfp_mask;
>         unsigned long flags;
>

Then leave all this code as is ? I find current code more readable.

> -       if (gfp & __GFP_DIRECT_RECLAIM)
> -               gfp_mask |= __GFP_NOFAIL;
> +       gfp |= __GFP_NOWARN;
> +       gfp_mask = (gfp & __GFP_DIRECT_RECLAIM) ? (gfp | __GFP_NOFAIL) : gfp;
>         *trackerp = tracker = kzalloc(sizeof(*tracker), gfp_mask);
>         if (unlikely(!tracker)) {
>                 pr_err_once("memory allocation failure, unreliable refcount tracker.\n");
> @@ -191,7 +191,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
>         }
>         nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
>         nr_entries = filter_irq_stacks(entries, nr_entries);

lib/ref_tracker.c got patches in net-next, your patch series is going
to add conflicts.

git log --oneline 5740d0689096..4d449bdc5b26 --no-merges -- lib/ref_tracker.c
c2d1e3df4af59261777b39c2e47476acd4d1cbeb ref_tracker: remove
filter_irq_stacks() call
8fd5522f44dcd7f05454ddc4f16d0f821b676cd9 ref_tracker: add a count of
untracked references
e3ececfe668facd87d920b608349a32607060e66 ref_tracker: implement
use-after-free detection


> -       stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
> +       stack_handle = stack_depot_save(entries, nr_entries,
> +                                       GFP_NOWAIT | __GFP_NOWARN);

This is fine.

>
>         spin_lock_irqsave(&dir->lock, flags);
>         if (tracker->dead) {
> --
> 2.25.1
>
