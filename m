Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA03B4BCC1D
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 05:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbiBTEHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 23:07:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiBTEHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 23:07:05 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBBEA18D
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 20:06:44 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id u12so13416183ybd.7
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 20:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FuJMjA1+O2ZDoyKJnX94JwibhyGanzChisqYedRhBSk=;
        b=k6ENV5woCkLIDnGTCOuCy2i6KQmpq+Ne+HF4ip+brpYlNXBMHg0oRhYiwtdKEd3DBM
         Czh0yeW5YPZ1KmmvIPmro7z78MkStXDohWhoWiiT4xgD3FEzjs3cj0aVZ1VfncsYsmkW
         KPZVr/mz7AhF3+jdfvby3zPYFYsa48nhCFq/7RjACvy8npaHzngGjE+RaFoL92A4QU+N
         +rZbOJIFZYEfL7RY+tQRjhbLf7fUKinqEYCnVVYpAwnGPw5f85SxzNHxwf/p9r9n8cch
         dSk9HNWLs2sj4JZZ0imCssqK7VfMqXXgh/GdLx3mxvIX+s/gYmbYoTpw/QyWqyMETXMu
         igOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FuJMjA1+O2ZDoyKJnX94JwibhyGanzChisqYedRhBSk=;
        b=36eKrrMa4o9j5sT1lKoU29mjpbZfM6Yxnyh2a/GvnKqbY6XLJrwSk/yywgD+rLijMg
         A/YxQ2g5tfaT5YU6/9dXn0JKA/0cdNV/1supl7OnFRZYRwMzjYZIEVxN97p15tauPXM3
         sJ9uLK+mtt62ueHsJTkdhQWvi+ig+J9Gp6jZ1m0RDUHD29cijFWHe8esMFJkCw6TEmq8
         +lP9nJvzA/x4MBrlXJwdytPoHOm5wkCoafh0gwfKX7eDoVGl/K9Hn55ipWGSMj7G3F4W
         D2lNaASRZ8VxBuMuSL/wGpM5G711omUyjxImcqBoZ4xtX/Lkuz7O8YKXNPdEAgxFOZ1D
         vNAg==
X-Gm-Message-State: AOAM533EMFtg4CTukXgXxEHFd+mvqy5c+zeK1dMPqtxScoTtGNgbAIOd
        YJCBDa50FCWCB6k6mPBLDuaUUmlUIM5IvNzB75Wvcg==
X-Google-Smtp-Source: ABdhPJxvc40qt44FCnxIcMetBjNCB1qtPmlVePC4MUHHbjP4cZUuzrrzDV0On9TJW6KCGd3/iS0lVCqH1H9F6lkXfX8=
X-Received: by 2002:a5b:ac8:0:b0:621:6b:3e10 with SMTP id a8-20020a5b0ac8000000b00621006b3e10mr13588329ybr.427.1645330003661;
 Sat, 19 Feb 2022 20:06:43 -0800 (PST)
MIME-Version: 1.0
References: <20220220035739.577181-1-eric.dumazet@gmail.com>
In-Reply-To: <20220220035739.577181-1-eric.dumazet@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 19 Feb 2022 20:06:32 -0800
Message-ID: <CANn89iLSX5y3NN2LQ-A4ANWfTVc77PioaTAshxZhemZemdtuFg@mail.gmail.com>
Subject: Re: [PATCH net-next] gro_cells: avoid using synchronize_rcu() in gro_cells_destroy()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
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

On Sat, Feb 19, 2022 at 7:57 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Another thing making netns dismantles potentially very slow is located
> in gro_cells_destroy(),
> whenever cleanup_net() has to remove a device using gro_cells framework.
>
> RTNL is not held at this stage, so synchronize_net()
> is calling synchronize_rcu():
>
> netdev_run_todo()
>  ip_tunnel_dev_free()
>   gro_cells_destroy()
>    synchronize_net()
>     synchronize_rcu() // Ouch.
>
> This patch uses call_rcu(), and gave me a 25x performance improvement
> in my tests.
>
> cleanup_net() is no longer blocked ~10 ms per synchronize_rcu()
> call.
>
> In the case we could not allocate the memory needed to queue the
> deferred free, use synchronize_rcu_expedited()
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/core/gro_cells.c | 36 +++++++++++++++++++++++++++++++-----
>  1 file changed, 31 insertions(+), 5 deletions(-)
>
> diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
> index 6eb2e5ec2c5068e1d798557e55d084b785187a9b..46fa7d93fd9696755efd56b72731f08e821042e1 100644
> --- a/net/core/gro_cells.c
> +++ b/net/core/gro_cells.c
> @@ -89,8 +89,23 @@ int gro_cells_init(struct gro_cells *gcells, struct net_device *dev)
>  }
>  EXPORT_SYMBOL(gro_cells_init);
>
> +struct percpu_free_defer {
> +       struct rcu_head rcu;
> +       void __percpu   *ptr;
> +};
> +
> +void percpu_free_defer_callback(struct rcu_head *head)

This will get a static in v2

> +{
> +       struct percpu_free_defer *defer;
> +
> +       defer = container_of(head, struct percpu_free_defer, rcu);
> +       free_percpu(defer->ptr);
> +       kfree(defer);
> +}
> +
>  void gro_cells_destroy(struct gro_cells *gcells)
>  {
> +       struct percpu_free_defer *defer;
>         int i;
>
>         if (!gcells->cells)
> @@ -102,12 +117,23 @@ void gro_cells_destroy(struct gro_cells *gcells)
>                 __netif_napi_del(&cell->napi);
>                 __skb_queue_purge(&cell->napi_skbs);
>         }
> -       /* This barrier is needed because netpoll could access dev->napi_list
> -        * under rcu protection.
> +       /* We need to observe an rcu grace period before freeing ->cells,
> +        * because netpoll could access dev->napi_list under rcu protection.
> +        * Try hard using call_rcu() instead of synchronize_rcu(),
> +        * because we might be called from cleanup_net(), and we
> +        * definitely do not want to block this critical task.
>          */
> -       synchronize_net();
> -
> -       free_percpu(gcells->cells);
> +       defer = kmalloc(sizeof(*defer), GFP_KERNEL | __GFP_NOWARN);
> +       if (likely(defer)) {
> +               defer->ptr = gcells->cells;
> +               call_rcu(&defer->rcu, percpu_free_defer_callback);
> +       } else {
> +               /* We do not hold RTNL at this point, synchronize_net()
> +                * would not be able to expedite this sync.
> +               */

I also will fix the comment alignment.

> +               synchronize_rcu_expedited();
> +               free_percpu(gcells->cells);
> +       }
>         gcells->cells = NULL;
>  }
>  EXPORT_SYMBOL(gro_cells_destroy);
> --
> 2.35.1.473.g83b2b277ed-goog
>
