Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFC830E070
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhBCRCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhBCRBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 12:01:16 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3338C0613ED
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 09:00:36 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id y5so23018767ilg.4
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 09:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yQSZGYmAxJEOdlOPpP1cQ0lq8a1ltruHI8cil2E9HhE=;
        b=CwkiLupvN8DSA5kuPwvFQbjUEDbcq75HOB5UvqF3oCcuT/PEpzpIul6wxhQDM+ODgi
         kDci/AEnvI+nGTL1fsELZx+v5HRS9nIN2BO0PMiavsMcMZVyNBX4ZCNBMgmLJRMh2dFK
         KuMNcIBko0egjJgjMc+7BEV7Nj2VmkX9BdZIflKFCPm+Bgtn/g5d+yW+x3349abUggfV
         K87/fYnnQ4POOJGaYMkJoHKJnue7od+Ydta+77NO/oUymsF2KxHr555krUPbDBx2K9N9
         xHxqkC7rINHVMYuOy8gcBWwwMvwyKZafyQmODomikTRG1z+7zquM3E0Kj28Y3Vi+DtGB
         LViQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yQSZGYmAxJEOdlOPpP1cQ0lq8a1ltruHI8cil2E9HhE=;
        b=MH95By6z2FHrdA38FrBhirTo3Yl6Az243Qe2V/7vAME1Z4c4vM79KsBOgC2rdi7BPJ
         u5DoqoJ0dVlX1mg8o7DWB63N3XKqMr9aeCMNqDAHke6kMWg665ju7W+thmft1/6CY6eI
         sLUnjDktAJtOu4vpj4tp69XohYT1F/zRyDhysMBDhXmjPvMgNPm+LMYfXfa/kIP3rvkr
         vLyEt4/93xr82H7VBrfy2nPYQpCBpdVVCSWbYN17gcpqCuLGSEW45sJGfeGrs4qLUHON
         BFVLCWVEiVGcEqdLpXWTrdRzeLRiDe58aHJzgCBUqgL5BuYbHhDu5O7JIv2/1AGJwmLR
         9eAA==
X-Gm-Message-State: AOAM533zneW7lIXOzjfQPKiuEAPbbT0vM3TMtgFKfXN8MTuehLnjWODF
        msO+3vxoOUuJBmUE7UidWva5Ne7uPG3yBl/B4I1g84VaRaQ=
X-Google-Smtp-Source: ABdhPJwh67n73MyVAd/HEWFyWXdinqRN85648pvLnN7jpWfGA2Iye1YjS7mqIzIYN+RWaYyadi6ZtLftsDQUbUIJzZY=
X-Received: by 2002:a05:6e02:2196:: with SMTP id j22mr3367567ila.64.1612371635932;
 Wed, 03 Feb 2021 09:00:35 -0800 (PST)
MIME-Version: 1.0
References: <20210129181812.256216-1-weiwan@google.com> <20210129181812.256216-2-weiwan@google.com>
In-Reply-To: <20210129181812.256216-2-weiwan@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 3 Feb 2021 09:00:25 -0800
Message-ID: <CAKgT0UdQCERxqcGmMe+xdF3aHvrRWzbCg+Wd3jGo=LREJayOQw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 1/3] net: extract napi poll functionality to __napi_poll()
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 10:20 AM Wei Wang <weiwan@google.com> wrote:
>
> From: Felix Fietkau <nbd@nbd.name>
>
> This commit introduces a new function __napi_poll() which does the main
> logic of the existing napi_poll() function, and will be called by other
> functions in later commits.
> This idea and implementation is done by Felix Fietkau <nbd@nbd.name> and
> is proposed as part of the patch to move napi work to work_queue
> context.
> This commit by itself is a code restructure.
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Wei Wang <weiwan@google.com>
> ---
>  net/core/dev.c | 35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 0332f2e8f7da..7d23bff03864 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6768,15 +6768,10 @@ void __netif_napi_del(struct napi_struct *napi)
>  }
>  EXPORT_SYMBOL(__netif_napi_del);
>
> -static int napi_poll(struct napi_struct *n, struct list_head *repoll)
> +static int __napi_poll(struct napi_struct *n, bool *repoll)
>  {
> -       void *have;
>         int work, weight;
>
> -       list_del_init(&n->poll_list);
> -
> -       have = netpoll_poll_lock(n);
> -
>         weight = n->weight;
>
>         /* This NAPI_STATE_SCHED test is for avoiding a race
> @@ -6796,7 +6791,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
>                             n->poll, work, weight);
>
>         if (likely(work < weight))
> -               goto out_unlock;
> +               return work;
>
>         /* Drivers must not modify the NAPI state if they
>          * consume the entire weight.  In such cases this code
> @@ -6805,7 +6800,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
>          */
>         if (unlikely(napi_disable_pending(n))) {
>                 napi_complete(n);
> -               goto out_unlock;
> +               return work;
>         }
>
>         /* The NAPI context has more processing work, but busy-polling
> @@ -6818,7 +6813,7 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
>                          */
>                         napi_schedule(n);
>                 }
> -               goto out_unlock;
> +               return work;
>         }
>
>         if (n->gro_bitmask) {
> @@ -6836,9 +6831,29 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
>         if (unlikely(!list_empty(&n->poll_list))) {
>                 pr_warn_once("%s: Budget exhausted after napi rescheduled\n",
>                              n->dev ? n->dev->name : "backlog");
> -               goto out_unlock;
> +               return work;
>         }
>
> +       *repoll = true;
> +
> +       return work;
> +}
> +
> +static int napi_poll(struct napi_struct *n, struct list_head *repoll)
> +{
> +       bool do_repoll = false;
> +       void *have;
> +       int work;
> +
> +       list_del_init(&n->poll_list);
> +
> +       have = netpoll_poll_lock(n);
> +
> +       work = __napi_poll(n, &do_repoll);
> +
> +       if (!do_repoll)
> +               goto out_unlock;
> +
>         list_add_tail(&n->poll_list, repoll);
>
>  out_unlock:

Instead of using the out_unlock label why don't you only do the
list_add_tail if do_repoll is true? It will allow you to drop a few
lines of noise. Otherwise this looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
