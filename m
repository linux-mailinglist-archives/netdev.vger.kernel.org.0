Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F10221605E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgGFUgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGFUgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:36:54 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83C3C061755;
        Mon,  6 Jul 2020 13:36:54 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id i18so34101686ilk.10;
        Mon, 06 Jul 2020 13:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MCJphnGHi4ugJamu91O2peu/WOTsRbYb5BCnex+CVB8=;
        b=UBdS65GKr5NxV/i1VWdBZsz0Nzk77f4SvA4DDlsmNTWg33gHKXW0Evdq6sSdcJ0JK5
         nBCrdnGMAKyWKVicP+Vrdlx3WyJ4GZsy6Ofm2kdsYP4QUK9YcrwBuRdnyy1Yx8VQFv1Y
         Nn5LgoH8E0V1RuczIBdUrpSFJTeXgRAWlQ1K1r9MOdn3/NwzkkANlyxnXTYhatViUBcB
         Xi+ky2uqwrA/pJbg9BbN3GsrrV7+y7UMwCxE1KH98BHwdOuWAfi1GGOIwDt8awU3bVy1
         fGjSCNplYvVf8FIK22YSXBZgSEiVvmY55sHFYmOYsZm/VuCPNBn+AHiKDBTC+z6ujAcE
         XcbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MCJphnGHi4ugJamu91O2peu/WOTsRbYb5BCnex+CVB8=;
        b=I8pj+geWmK6p5j/66Pbdh0ZrUi+/JfU/BdQpUEZb90r0E0XRijjbg3yckaqoCAzhBt
         JUM5BnBUgb0ZSgfKZRTHTjML5deHHjGFhO+XsCgc9nvpNw+rq0CO7K2hXAiBikPPthsK
         uz1EvRwELe+K9sF2/0CId5NCEe0dt9ovAi4GXIhYUoWFRUEzNagFVqL5RSV3qzQCrkxa
         hsu2o/2jo2fmydEwZm6T29bByZW1mziEsAbay9tEeAKZENSrCVs1/O2gkaQM6A2RE8/U
         MTsbtuAT3sUjWWf72zjisXg6b0/iKAmBeAm8FsGJqEQXjlo6L0h8t7hnlMOP64hFsUxO
         Dw7Q==
X-Gm-Message-State: AOAM530xv6prFriRhC5wIkkA4/gvG8+kU2Qcdci4VnGHeA8chaHFpW5G
        k9ksVYOhWeEoMnUb3IObVU4YhkEBoc2mqe9h4HQ=
X-Google-Smtp-Source: ABdhPJzJ8AsCUj1Krh+ANHbICZ+1ndjQ3JjCD+N0vaixFPQB8mdeyopRJ2RLKMxlY4mDEmJMgFBMugK9yAEa4WtaS8Q=
X-Received: by 2002:a05:6e02:1212:: with SMTP id a18mr29300654ilq.97.1594067813705;
 Mon, 06 Jul 2020 13:36:53 -0700 (PDT)
MIME-Version: 1.0
References: <1593027056-43779-1-git-send-email-sridhar.samudrala@intel.com>
In-Reply-To: <1593027056-43779-1-git-send-email-sridhar.samudrala@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 6 Jul 2020 13:36:42 -0700
Message-ID: <CAKgT0UdD2cyikv8WgCoZSsHsxsbLm0-KZ9SxatbgEfgbb3z-FQ@mail.gmail.com>
Subject: Re: [PATCH v2] fs/epoll: Enable non-blocking busypoll when epoll
 timeout is 0
To:     Sridhar Samudrala <sridhar.samudrala@intel.com>
Cc:     linux-fsdevel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 4:03 PM Sridhar Samudrala
<sridhar.samudrala@intel.com> wrote:
>
> This patch triggers non-blocking busy poll when busy_poll is enabled,
> epoll is called with a timeout of 0 and is associated with a napi_id.
> This enables an app thread to go through napi poll routine once by
> calling epoll with a 0 timeout.
>
> poll/select with a 0 timeout behave in a similar manner.
>
> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
>
> v2:
> Added net_busy_loop_on() check (Eric)
>
> ---
>  fs/eventpoll.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 12eebcdea9c8..c33cc98d3848 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1847,6 +1847,19 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>                 eavail = ep_events_available(ep);
>                 write_unlock_irq(&ep->lock);
>
> +               /*
> +                * Trigger non-blocking busy poll if timeout is 0 and there are
> +                * no events available. Passing timed_out(1) to ep_busy_loop
> +                * will make sure that busy polling is triggered only once.
> +                */
> +               if (!eavail && net_busy_loop_on()) {
> +                       ep_busy_loop(ep, timed_out);
> +                       write_lock_irq(&ep->lock);
> +                       eavail = ep_events_available(ep);
> +                       write_unlock_irq(&ep->lock);
> +               }
> +
>                 goto send_events;
>         }

Doesn't this create a scenario where the NAPI ID will not be
disassociated if the polling fails?

It seems like in order to keep parity with existing busy poll code you
should need to check for !eavail after you release the lock and if
that is true you should be calling ep_reset_busy_poll_napi_id so that
you disassociate the NAPI ID from the eventpoll.
