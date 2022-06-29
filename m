Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9354560080
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiF2MzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiF2MzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:55:14 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374D02BB23;
        Wed, 29 Jun 2022 05:55:14 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 73-20020a9d084f000000b00616b04c7656so10763828oty.3;
        Wed, 29 Jun 2022 05:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DJv7P9JBK5V21yUHUPSn4s4mgLe8+QTUb4c7j/mSOLk=;
        b=eM9fqYL7ibhxiiJX8yOPW5oaV4u0Psui/sBLW5T3uFQmjEewxYqjdbXglrZPcg6Mb+
         gx3Z/xnu6ZwC1yC2UsmNxBRW4CEQZEz6BkpBuq1g+r3XrAEWRWoojU+NIdBUwoDT+ozG
         YFZZFfmGh+lQbFoBiZsKgXXn5BQZJHRBd/NPhXgIjGW5OoivEFa723vgglP7u6cEyPWT
         iLxZVYR09XdioFObXfZAn4Cl5hJSAk7SfxUaxgw4q9KoV/mr1fpcmdKqN+XDnHCxDg8n
         l33B3qs8wiEnDGpm+9lQTFzTRlg0MCdgdOSQuDcBkXKzkDrY2rb9ab4GkJ2VvU6lnJzu
         2Myg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DJv7P9JBK5V21yUHUPSn4s4mgLe8+QTUb4c7j/mSOLk=;
        b=1cbib8oofnMdUQErHPl3VawqbhBXksNkS2Gm0FfSbJgKP0PG8uaiNcjd3KzfdHL8ak
         DwR9Xtjhgmd5dvdvf/9g1o8alUxW8ufJRkMGxVEtxGDE9BwfKyRtZckQp4EpnfXN1HXJ
         4rUNNrXyWJ8iwH+XyMEqQswaFVLwwDxJUVcpJ2EZv3Ox1C5q8/MTqluYvYOCMTMDN0q0
         Sc2uMUhwe8mgGiM8riYfsMHsdEG9R1sN3W/d7BHWtWWakbn/XE1em6Lm+Fd65cCSLF58
         lhcbUT3cev6kF+LSpli/JlY4NbebCnP4OgrqX6geiIh7dijzYmqIIWae+sQN6K+rkdWp
         /eQA==
X-Gm-Message-State: AJIora9sBpjkO+Pphkopo0abTMzPV5i7J0kUP3HAEkkBtqoGyicVLflG
        IdX5gTFExwo4GbCsanekdO8FZwnLXDIYeAO34OI=
X-Google-Smtp-Source: AGRyM1ubOMO/6qYKDT6+NrKMJ5lSTgo6Osgx4Ml9JrLcBoiH7a89AVmmPX6l4FFSm0TPsUsfpuT+IafBw4ee7YzbwBQ=
X-Received: by 2002:a9d:1c6:0:b0:617:865:c204 with SMTP id e64-20020a9d01c6000000b006170865c204mr558791ote.17.1656507313503;
 Wed, 29 Jun 2022 05:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1656031586.git.duoming@zju.edu.cn> <c31f454f74833b2003713fffa881aabb190b8290.1656031586.git.duoming@zju.edu.cn>
 <ecac788497ea0e4e5b725226ad8b1209dc62fa0e.camel@redhat.com> <411487ea.1b211.181ad932398.Coremail.duoming@zju.edu.cn>
In-Reply-To: <411487ea.1b211.181ad932398.Coremail.duoming@zju.edu.cn>
From:   Dan Cross <crossd@gmail.com>
Date:   Wed, 29 Jun 2022 08:54:37 -0400
Message-ID: <CAEoi9W6KBmJNO1obk5pPVhugjRjSs8PY2fC3r0wN2OD=3Ei5eg@mail.gmail.com>
Subject: Re: [PATCH net v3 2/2] net: rose: fix null-ptr-deref caused by rose_kill_by_neigh
To:     duoming@zju.edu.cn
Cc:     Paolo Abeni <pabeni@redhat.com>, linux-hams@vger.kernel.org,
        ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 11:59 PM <duoming@zju.edu.cn> wrote:
> Hello,
>
> On Tue, 28 Jun 2022 13:12:40 +0200 Paolo Abeni wrote:
> > [snip]
> > I'm sorry, I likely was not clear enough in my previous reply. This is
> > broken. If a list is [spin_]lock protected, you can't release the lock,
> > reacquire it and continue traversing the list from the [now invalid]
> > same iterator.
> >
> > e.g. if s is removed from the list, even if the sock is not de-
> > allocated due to the addtional refcount, the traversing will errnously
> > stop after this sock, instead of continuing processing the remaining
> > socks in the list.
>
> I understand. The following is a new solution:
>
> diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
> index bf2d986a6bc..24dcbde88fb 100644
> --- a/net/rose/af_rose.c
> +++ b/net/rose/af_rose.c
> @@ -165,13 +165,21 @@ void rose_kill_by_neigh(struct rose_neigh *neigh)
>         struct sock *s;
>
>         spin_lock_bh(&rose_list_lock);
> +again:
>         sk_for_each(s, &rose_list) {
>                 struct rose_sock *rose = rose_sk(s);
>
>                 if (rose->neighbour == neigh) {
> +                       sock_hold(s);
> +                       spin_unlock_bh(&rose_list_lock);
> +                       lock_sock(s);
>                         rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
>                         rose->neighbour->use--;
>                         rose->neighbour = NULL;
> +                       release_sock(s);
> +                       spin_lock_bh(&rose_list_lock);
> +                       sock_put(s);
> +                       goto again;

It may be worthwhile noting that this changes the time complexity
of the algorithm to be O(n^2) in the number of entries in `rose_list`,
instead of linear.  But as that number is extremely unlikely to ever
be large, it probably makes no practical difference.

        - Dan C.

>                 }
>         }
>         spin_unlock_bh(&rose_list_lock);
> diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
> index fee6409c2bb..b116828b422 100644
> --- a/net/rose/rose_route.c
> +++ b/net/rose/rose_route.c
> @@ -827,7 +827,9 @@ void rose_link_failed(ax25_cb *ax25, int reason)
>                 ax25_cb_put(ax25);
>
>                 rose_del_route_by_neigh(rose_neigh);
> +               spin_unlock_bh(&rose_neigh_list_lock);
>                 rose_kill_by_neigh(rose_neigh);
> +               return;
>         }
>         spin_unlock_bh(&rose_neigh_list_lock);
>  }
>
> If s is removed from the list, the traversing will not stop erroneously.
>
> Best regards,
> Duoming Zhou
