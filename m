Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0234C31004A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 23:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBDWpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 17:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhBDWpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 17:45:10 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25529C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 14:44:30 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id u20so5018119iot.9
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 14:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RJyZ1GlW+6QkoPhnT4J0qOs9l0QB6rhozJ2MCmravco=;
        b=USRpNbl5Ov5OCZN36t+4A6cN+f1hqXE6lgiEs0hMriBPRd5GqlUigQ19dh9+IIrYWE
         BMctM/lbmwMEicPVVJith+MXB/7/MK/plf/8BG6lCzETzs7+jvin/EEDdFqc5ud2PWSG
         GXO0ZnhRTAIc47l+yHNCIy6QXGZc8SwvWdyQOVb8R6q8O9kE+jCgEffnnmTMqXuVb9xG
         LsJk+A7HcugGVUhGXYJ9ecCEVJd3J+jxqSs363vtLHSKNuSn9m92YeNu4VZN7bEUil5B
         xxT3xfAJ4ofmq5xvYxFhkyGxB7HkEyQgNKntGPaciX9CnOB6db/DdtOHTLnvlKJ4vwZ0
         s/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RJyZ1GlW+6QkoPhnT4J0qOs9l0QB6rhozJ2MCmravco=;
        b=PsBbAKD7TSfqaghRqnFBQgG1HWf9uyfqx3snv1mtTsLRcs9K4y9JSFstx9s7xp05Xf
         i6HScJnUmxcOgaWdM1EddKj8CyCUkU6pFCX7ZgSmcdvfL/hr5i8Fj0uYzesfjkD18ddY
         CdQgER+EW+vVXYKnqEQ+E8t35zoi8ok3GbH8c/LjiikWVOfY3VLeKlEPeb8lnRk8ZIE6
         eQZFe7VDh8P7DUXFutbtC13NWalJ/DPlOX6j3EI7CJRLCXILZkTtqiTxfNRgkYevrDsf
         M6ejLM2ui/7G7O8IIuIYJ3pi4Q0wYX3RfsCxyJFZDeaxgHtYZAwmo9OaI8Fg3ZYapaDv
         5ppg==
X-Gm-Message-State: AOAM531cA4RMpG+pl7C/t0MSHXrLlpmP096L0P3YxwcpkZmSysoDaTms
        hjyog1nKCbnkO7/fcny+dQ8SQVpzDXaMorZBLDNL8YKszFZcyWVF
X-Google-Smtp-Source: ABdhPJxkwkdq8rJgeTG4aMV9ZNyopXXhY5/A0Ck82GBD05vTuMVYkcsBcSOQh0DVYKg2NDp4YViMCXK4dAdaSN2hyDw=
X-Received: by 2002:a5d:94cb:: with SMTP id y11mr1352389ior.117.1612478669383;
 Thu, 04 Feb 2021 14:44:29 -0800 (PST)
MIME-Version: 1.0
References: <20210204213146.4192368-1-eric.dumazet@gmail.com> <dbad0731e30c920cf4ab3458dfce3c73060e917c.camel@kernel.org>
In-Reply-To: <dbad0731e30c920cf4ab3458dfce3c73060e917c.camel@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 4 Feb 2021 23:44:17 +0100
Message-ID: <CANn89iJ4ki9m6ne0W72QZuSJsBvrv9BMf9Me5hL9gw2tUnHhWg@mail.gmail.com>
Subject: Re: [PATCH net] net: gro: do not keep too many GRO packets in napi->rx_list
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        John Sperbeck <jsperbeck@google.com>,
        Jian Yang <jianyang@google.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Edward Cree <ecree@solarflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 11:14 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Thu, 2021-02-04 at 13:31 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Commit c80794323e82 ("net: Fix packet reordering caused by GRO and
> > listified RX cooperation") had the unfortunate effect of adding
> > latencies in common workloads.
> >
> > Before the patch, GRO packets were immediately passed to
> > upper stacks.
> >
> > After the patch, we can accumulate quite a lot of GRO
> > packets (depdending on NAPI budget).
> >
>
> Why napi budget ? looking at the code it seems to be more related to
> MAX_GRO_SKBS * gro_normal_batch, since we are counting GRO SKBs as 1


Simply because we call gro_normal_list() from napi_poll(),

So we flush the napi rx_list every 64 packets under stress.(assuming
NIC driver uses NAPI_POLL_WEIGHT),
or more often if napi_complete_done() is called if the budget was not exhausted.

GRO always has been able to keep MAX_GRO_SKBS in its layer, but no recent patch
has changed this part.


>
>
> but maybe i am missing some information about the actual issue you are
> hitting.


Well, the issue is precisely described in the changelog.

>
>
> > My fix is counting in napi->rx_count number of segments
> > instead of number of logical packets.
> >
> > Fixes: c80794323e82 ("net: Fix packet reordering caused by GRO and
> > listified RX cooperation")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Bisected-by: John Sperbeck <jsperbeck@google.com>
> > Tested-by: Jian Yang <jianyang@google.com>
> > Cc: Maxim Mikityanskiy <maximmi@mellanox.com>
> > Cc: Alexander Lobakin <alobakin@dlink.ru>
> > Cc: Saeed Mahameed <saeedm@mellanox.com>
> > Cc: Edward Cree <ecree@solarflare.com>
> > ---
> >  net/core/dev.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index
> > a979b86dbacda9dfe31dd8b269024f7f0f5a8ef1..449b45b843d40ece7dd1e2ed6a5
> > 996ee1db9f591 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -5735,10 +5735,11 @@ static void gro_normal_list(struct
> > napi_struct *napi)
> >  /* Queue one GRO_NORMAL SKB up for list processing. If batch size
> > exceeded,
> >   * pass the whole batch up to the stack.
> >   */
> > -static void gro_normal_one(struct napi_struct *napi, struct sk_buff
> > *skb)
> > +static void gro_normal_one(struct napi_struct *napi, struct sk_buff
> > *skb, int segs)
> >  {
> >         list_add_tail(&skb->list, &napi->rx_list);
> > -       if (++napi->rx_count >= gro_normal_batch)
> > +       napi->rx_count += segs;
> > +       if (napi->rx_count >= gro_normal_batch)
> >                 gro_normal_list(napi);
> >  }
> >
> > @@ -5777,7 +5778,7 @@ static int napi_gro_complete(struct napi_struct
> > *napi, struct sk_buff *skb)
> >         }
> >
> >  out:
> > -       gro_normal_one(napi, skb);
> > +       gro_normal_one(napi, skb, NAPI_GRO_CB(skb)->count);
>
> Seems correct to me,
>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
>
>
