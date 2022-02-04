Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102124A9E7C
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377284AbiBDSAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356110AbiBDSAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:00:08 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A99EC061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:00:07 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id u14so14064465lfo.11
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HW08o76JFwHVBhbpBrnhcE4PAaebxf4ac5IWAri1O80=;
        b=vD4r6ePzJGt7WG5hpoZuurEv4v2K441G5a5nTjhsEySiQn4+TgZioDusO0C7Adkqel
         hGsHCRS3NWzx9WLYAU3Te+K0DhoUUdr0Fr4esvyUNLj65GUxzdgDK3Y839ynuURas4gt
         Rwiz5L6oO/PLO7ZD8gSG6oiHVlLf4YtJN9jjE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HW08o76JFwHVBhbpBrnhcE4PAaebxf4ac5IWAri1O80=;
        b=5YM0Q2SXs2cxDBIXi2t3fYeE1e2Q4YX5YM0o+EPnXnxoYKUunTmpN+/K4+Qtea4zLG
         28k8xeir9cppOB36BlOJs8rSW1BPwApjpUwPFMu1xN2Q6wqC2IiaIr75BiP2j+iqgOru
         risfVvf1uZxgXJDmnnSP87mP7ZHy3eyIUj+NMYNc0+9zFFMuP1QLHmkZXx0dygJ90xMJ
         QN+iq4x6oJ6HjFR38JCkv6xSPa41pbif3S9/leb8xVO3dqai3E9h0JaMJR70DU/RYy5E
         /DBiEXuEoVks/VP7PFP+JVXsrHx+tjlLJcXd+IFmUdi9qUn3ShpuY3w+j4ETZ3Ckdz8g
         vebg==
X-Gm-Message-State: AOAM530YktayzEoVVAMbf/8hKncwXcRxtpeBCT9oKKsWr3sT5slSZ+BZ
        ikJzGAByPODK89/1uGXzyipu9EfRvisuGRF4uw3PBw==
X-Google-Smtp-Source: ABdhPJzjI3UbKvFiyg0AjtdhLZvXWWD/rZp+6VzcZZszzT9B91EdfKq9yZGrdD25ZZvtaS36U1Xr5MYr561c43xFhDQ=
X-Received: by 2002:ac2:5e64:: with SMTP id a4mr67161lfr.674.1643997606116;
 Fri, 04 Feb 2022 10:00:06 -0800 (PST)
MIME-Version: 1.0
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
 <1643933373-6590-11-git-send-email-jdamato@fastly.com> <YfzZXTyQ+BNss0ji@hades>
In-Reply-To: <YfzZXTyQ+BNss0ji@hades>
From:   Joe Damato <jdamato@fastly.com>
Date:   Fri, 4 Feb 2022 09:59:55 -0800
Message-ID: <CALALjgxav2PUm-sLpj=XHC7gbBdCbbjKm6EitJCdh+a9kXOFoQ@mail.gmail.com>
Subject: Re: [net-next v4 10/11] page_pool: Add a stat tracking waived pages
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        hawk@kernel.org, saeed@kernel.org, ttoukan.linux@gmail.com,
        brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 11:44 PM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> Hi Joe,
>
> On Thu, Feb 03, 2022 at 04:09:32PM -0800, Joe Damato wrote:
> > Track how often pages obtained from the ring cannot be added to the cache
> > because of a NUMA mismatch.
> >
> > Signed-off-by: Joe Damato <jdamato@fastly.com>
> > ---
> >  include/net/page_pool.h | 1 +
> >  net/core/page_pool.c    | 1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 65cd0ca..bb87706 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -150,6 +150,7 @@ struct page_pool_stats {
> >                           * slow path allocation
> >                           */
> >               u64 refill; /* allocations via successful refill */
> > +             u64 waive;  /* failed refills due to numa zone mismatch */
> >       } alloc;
> >  };
> >  #endif
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 4fe48ec..0bd084c 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -166,6 +166,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
> >                        * This limit stress on page buddy alloactor.
> >                        */
> >                       page_pool_return_page(pool, page);
> > +                     this_cpu_inc_alloc_stat(pool, waive);
> >                       page = NULL;
> >                       break;
> >               }
> > --
> > 2.7.4
> >
>
> Personally i'd find it easier to read if patches 1-10 were squashed in a
> single commit.

Thanks for the feedback. I've squashed patches 1-10 to a single commit
in my v5 branch.
