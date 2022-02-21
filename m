Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADF34BEEA9
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 02:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbiBUXyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 18:54:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiBUXys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 18:54:48 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF0E1A3AF
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 15:54:24 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id j2so37702372ybu.0
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 15:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3lC+GIB4kzAe3ece369swUyKHnvK/S1h9xrQbJ/8q+w=;
        b=GOHpLflJrqC43QFF/5GQvG7V2qEcPuaQvtK5vbSduDp5b1yp3G7IW6vFy9EFQmifR3
         R3K6rvushU3hJCS+Q6RbNcy7Y3MCAD1xh9DmsmuJ2Cuki5Tpvo/WJIioUd+G4028WrXV
         6EuITKbzai/dr+E7N6V+RpaG1AFgkgkp6ZhZ8BaDO2LbPeNApEd5+THSlbqAL01gEya8
         0Xor7hYcueU2c9Tbn4MBzNzpxCXuancOC8749h9QPVjrrHJ3E6H1ilmIQGjh55yX4Tre
         yHb37zO9WMY3AhiVF9UhNZkRfPoZ3Oq5BjEJAfTtRCAwySv7PvxrLqZhsd9hjmo9PsV4
         R69A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3lC+GIB4kzAe3ece369swUyKHnvK/S1h9xrQbJ/8q+w=;
        b=TdG9cMHhFKzSXvjVOjpdyl8s8BLyO+m8M3SQLhOld7Wxa91mSQbbdMqg8fdcEs0p9t
         90715uW6iWS3J07D+af8ZC59dhlfI3qIbuwrRVRVtImqRaR20351j5ZYFLyqfs97nPni
         mfk5HpH8Ewfq52s6xDPosZFvzs5lV4TRlmUmr5gIjE6vpRl4af9Go1CuIvRexO5Cx0QB
         YosNM+DRtNicLIYLlPlhkkSBq4P8poZAwdVWBCYedFYJN4AbLWUhp63jvApK8NzVAwuW
         Vh9YkqbavEatjUfxivL7wx9uJwaDE5/pBCG1e6mo3AUIdvpzQVb3ngGfx1zGaP+mAx6n
         +Zsg==
X-Gm-Message-State: AOAM530OaJfhoLInRwbSJyXH3c+gzZvkIntGaQPIyZ+L6NCvR7zdoozj
        6Yf1/kXdRV3f+ygHuayt+xArtJvUwmR2SaSmnNnuiQ==
X-Google-Smtp-Source: ABdhPJwK0jOhPcM1lDe3429/m25HSYMiQee5DR7/0JGbbsQegVXI/XBsnoJbutUJ1jTG6re1CQZuJ8cXV0HIPfxMSxQ=
X-Received: by 2002:a25:a28d:0:b0:623:fa1b:3eb7 with SMTP id
 c13-20020a25a28d000000b00623fa1b3eb7mr21159078ybi.387.1645487663454; Mon, 21
 Feb 2022 15:54:23 -0800 (PST)
MIME-Version: 1.0
References: <20220221232542.1481315-1-andrzej.hajda@intel.com> <20220221232542.1481315-8-andrzej.hajda@intel.com>
In-Reply-To: <20220221232542.1481315-8-andrzej.hajda@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Feb 2022 15:54:12 -0800
Message-ID: <CANn89i+E3z-iXSJh8316KSycYk2VTS-n0E=tAOj23fuDSi1Zjg@mail.gmail.com>
Subject: Re: [PATCH v3 07/11] lib/ref_tracker: remove warnings in case of
 allocation failure
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
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 3:26 PM Andrzej Hajda <andrzej.hajda@intel.com> wrote:
>
> Library can handle allocation failures. To avoid allocation warnings
> __GFP_NOWARN has been added everywhere. Moreover GFP_ATOMIC has been
> replaced with GFP_NOWAIT in case of stack allocation on tracker free
> call.
>
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
> ---
>  lib/ref_tracker.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
> index 2ef4596b6b36f..cae4498fcfd70 100644
> --- a/lib/ref_tracker.c
> +++ b/lib/ref_tracker.c
> @@ -189,7 +189,7 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
>         unsigned long entries[REF_TRACKER_STACK_ENTRIES];
>         struct ref_tracker *tracker;
>         unsigned int nr_entries;
> -       gfp_t gfp_mask = gfp;
> +       gfp_t gfp_mask = gfp | __GFP_NOWARN;

SGTM

>         unsigned long flags;
>
>         WARN_ON_ONCE(dir->dead);
> @@ -237,7 +237,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
>                 return -EEXIST;
>         }
>         nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
> -       stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
> +       stack_handle = stack_depot_save(entries, nr_entries,
> +                                       GFP_NOWAIT | __GFP_NOWARN);

Last time I looked at this, __GFP_NOWARN was enforced in __stack_depot_save()

>
>         spin_lock_irqsave(&dir->lock, flags);
>         if (tracker->dead) {
> --
> 2.25.1
>
