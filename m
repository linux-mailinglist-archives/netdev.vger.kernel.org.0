Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4503466BBA8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjAPKZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjAPKZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:25:24 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD7117CF3;
        Mon, 16 Jan 2023 02:25:23 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id b4so20570160edf.0;
        Mon, 16 Jan 2023 02:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YcVEcFChFoao6dFWLdC+6sKirsCf6cE7CdgCXlv/MdI=;
        b=ccjuZwAG4Qnn/+DcpP++uZbdCwYYS0Dj306vDsQeWu7u5rv4vpbTr7XZbPnAz4abfT
         IoOp7jNKlsbT9b39kCWgnhbbfTdy31mkigwr7FyOCvnTQtxuVZ+H1HY3vxls95uap8PR
         vkMmzsNpU0hWsVV7DukRLioRXiEmzOaaXxVRN7MJnzPYKSA7RAkVbdenvW3JS6YlFV6+
         uH/e3jTZcaDHk+YoOVv0M4WKB+JsWoZ7wtwCyXEjLfQbTLrDsoj2w369cqsvI2dOrRMB
         F2cZHR3+FmxakahFDqT1anhHMIo4ibWA1kP8SJEaBkbJSddbH93kzQ7T2trpab64P1yQ
         UIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YcVEcFChFoao6dFWLdC+6sKirsCf6cE7CdgCXlv/MdI=;
        b=JWh8mbK4CP2PnBEWiEjMmrlcsgIYlQc0ZKweOYApvzvbcQZUOJbc6Ak07l0eh13e6E
         fGProVrJ5yfzWobPljuHu68xJiivcShC7O81TXSBMKVtJRCOOzmB5SijPc0OoS+qkMaF
         A+6vMebeyZ2RR135I8tOp6ylqlFWpPuolEXpg9Nuo17cTr6KE2wJpyua2zYr7VCOF6I3
         kxI3XSlMNEZf1Q3cXKl0NmFPCm6D1ZpeOIE08oxlL4Roo1p+p1iYd7SZQspdNN6dtQjd
         3z2rLOE+tt8G9w9PXi2ScsNjzjnhqrVN2zkJlWbWR9INKMOdjkjjV2m6EYDpchNnJu/Y
         porw==
X-Gm-Message-State: AFqh2krbueX8No5ijW2Udr5a2iNeDMJRv092z72+XQUD7mES7zxaFnEg
        yi1e/QLL/o8leT3rAmTuvlwYpUs7u3cB6SP0SWvDblPuQXGN6A==
X-Google-Smtp-Source: AMrXdXvpdoGOWEsrHOk8V+Y5fHqtq9UjUH/aAuJgKTxxj4Y3irS2GWTgj7gcqwnyUIXTHaDk8fGpBDgn197U6R46TMw=
X-Received: by 2002:a05:6402:4285:b0:48f:a9a2:29ec with SMTP id
 g5-20020a056402428500b0048fa9a229ecmr5536154edc.67.1673864721657; Mon, 16 Jan
 2023 02:25:21 -0800 (PST)
MIME-Version: 1.0
References: <20230116073813.24097-1-kerneljasonxing@gmail.com> <CANn89i+qCZOCSaNbqRxirS8zouAWJFpvPX51deT=bG9uxnJ4oA@mail.gmail.com>
In-Reply-To: <CANn89i+qCZOCSaNbqRxirS8zouAWJFpvPX51deT=bG9uxnJ4oA@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 16 Jan 2023 18:24:45 +0800
Message-ID: <CAL+tcoCZ0vLUq+yF5_kaQAgz+fCBvzwf73cfEgewUQasPm6zDQ@mail.gmail.com>
Subject: Re: [PATCH v4 net] tcp: avoid the lookup process failing to get sk in
 ehash table
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 5:54 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Jan 16, 2023 at 8:38 AM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > While one cpu is working on looking up the right socket from ehash
> > table, another cpu is done deleting the request socket and is about
> > to add (or is adding) the big socket from the table. It means that
> > we could miss both of them, even though it has little chance.
> >
> >
> > Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > Link: https://lore.kernel.org/lkml/20230112065336.41034-1-kerneljasonxing@gmail.com/
> > ---
> > v4:
> > 1) adjust the code style and make it easier to read.
> >
> > v3:
> > 1) get rid of else-if statement.
> >
> > v2:
> > 1) adding the sk node into the tail of list to prevent the race.
> > 2) fix the race condition when handling time-wait socket hashdance.
> > ---
> >  net/ipv4/inet_hashtables.c    | 18 ++++++++++++++++--
> >  net/ipv4/inet_timewait_sock.c |  6 +++---
> >  2 files changed, 19 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > index 24a38b56fab9..c64eec874b31 100644
> > --- a/net/ipv4/inet_hashtables.c
> > +++ b/net/ipv4/inet_hashtables.c
> > @@ -650,8 +650,21 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
> >         spin_lock(lock);
> >         if (osk) {
> >                 WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
> > -               ret = sk_nulls_del_node_init_rcu(osk);
> > -       } else if (found_dup_sk) {
> > +               if (sk_hashed(osk)) {
> > +                       /* Before deleting the node, we insert a new one to make
> > +                        * sure that the look-up-sk process would not miss either
> > +                        * of them and that at least one node would exist in ehash
> > +                        * table all the time. Otherwise there's a tiny chance
> > +                        * that lookup process could find nothing in ehash table.
> > +                        */
> > +                       __sk_nulls_add_node_tail_rcu(sk, list);
> > +                       sk_nulls_del_node_init_rcu(osk);
> > +               } else {
> > +                       ret = false;
>
>
> Well, you added another 'else' statement...
>

Yeah, I want to make the code look more concise and easy to read. I
alway felt the previous series of commits are not human-readable
though it could work.

> What about the following ?
>
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 24a38b56fab9e9d7d893e23b30d26e275359ec70..1bcf5ce8dd1317b2144bcb47a2ad238532b9accf
> 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -650,8 +650,14 @@ bool inet_ehash_insert(struct sock *sk, struct
> sock *osk, bool *found_dup_sk)
>         spin_lock(lock);
>         if (osk) {
>                 WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
> -               ret = sk_nulls_del_node_init_rcu(osk);
> -       } else if (found_dup_sk) {
> +               ret = sk_hashed(osk);
> +               if (ret) {
> +                       __sk_nulls_add_node_tail_rcu(sk, list);
> +                       sk_nulls_del_node_init_rcu(osk);
> +               }

Ah, I prefer this one :)

Thanks,
Jason

> +               goto unlock;
> +       }
> +       if (found_dup_sk) {
>                 *found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
>                 if (*found_dup_sk)
>                         ret = false;
> @@ -659,7 +665,7 @@ bool inet_ehash_insert(struct sock *sk, struct
> sock *osk, bool *found_dup_sk)
>
>         if (ret)
>                 __sk_nulls_add_node_rcu(sk, list);
> -
> +unlock:
>         spin_unlock(lock);
>
>         return ret;
