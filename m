Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FC549318C
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 01:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350348AbiASADq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 19:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350331AbiASADp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 19:03:45 -0500
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEF4C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:03:45 -0800 (PST)
Received: by mail-vk1-xa2d.google.com with SMTP id 191so440628vkc.1
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4pK7f5GL6F7w/LmgOcH/k3Rkqhl1UmfiKcr2kEZMCjQ=;
        b=lOqXItVdo5KcoAIy3ALB/sWXT/BvsuzOxB48fK2YKWIgdDTngYNd/OmOtKnT3Ro6VK
         J2rrXOuB6qMMZgJeZxNO85fASJu6h1m+DE1Qs6BUrMlExSjec6DOhz/Y2Yugo2NvRxLD
         dONeEXrLWOKVSGyssXtGraSv+vHwGA7ZLdWutS35iOe6rETwKjJaOn+j0fSwQFcZsftS
         E5k78YqyFIl99/iioUQkPLsmzAD/VL3Q5956pwr/58KubN6UyrgLs3USXq6UXBlzjP/d
         551NMzBY7BIA+dt60wYbjhirGeF3TwEUp7+L31CjNfXyj5lGWSr4rSB71nRyTHAJJHkt
         lA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4pK7f5GL6F7w/LmgOcH/k3Rkqhl1UmfiKcr2kEZMCjQ=;
        b=zuzitVsbeI3ZwAlaXNypI9PrG7a0/Nu8nWOz8S7/rqSmL2X160o2VdZSj7WtQ1WGN5
         sSh2tA3cjdD2gdRIKnhTGATDbaH+kIbMGixsusPxaYW76574wVfo6Zbt3A4bpRp7CF7U
         YKyGMYb2SMopW04oVXys65eNGvvpMd0WDeAs1MpSjRjT8+4KFOsyTCqAgkKgm7QP6S1d
         40H7G+HHi1yY1hnmxDEkjiqhrESF3VozXDVML1+FfdBKN89FIcO4pS9VpnWuIPhRi71v
         F19s8earNwaWmXpEkuFjKFF5yziRw/sRyx4prPjVkFC10bmwty9GSFNTdkt3qSOgQNW/
         8WpQ==
X-Gm-Message-State: AOAM531HrYB2jLqdvkHzv+LbLBGZlA8iIrdIIghdAYS+x+cp27FEbFGx
        B58DgnLHjPgmKmhDjV6EKcn/lHn+WiJUXGYqSOJ91vXdjlBo2g==
X-Google-Smtp-Source: ABdhPJwUKEmUYVsEsf2wMbcUGmi0Y6al5MK5bwtqxGegS4Vu0NlN9hJAjyqj6Xq4VDj6EWGriK9Kixfsp3qzjm6AP24=
X-Received: by 2002:a05:6122:90a:: with SMTP id j10mr11092194vka.12.1642550624307;
 Tue, 18 Jan 2022 16:03:44 -0800 (PST)
MIME-Version: 1.0
References: <20220106005251.2833941-1-evitayan@google.com> <20220106005251.2833941-3-evitayan@google.com>
 <20220112075708.GB1223722@gauss3.secunet.de>
In-Reply-To: <20220112075708.GB1223722@gauss3.secunet.de>
From:   Yan Yan <evitayan@google.com>
Date:   Tue, 18 Jan 2022 16:03:33 -0800
Message-ID: <CADHa2dBqrVSEWD9YbuHXLoHS8pxj07VVpN5Q+ZSmG3e61v_gkg@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] xfrm: Fix xfrm migrate issues when address family changes
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        nharold@googlel.com, benedictwong@googlel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Steffen, I will pull out xfrm_init_state() as you suggested.

On Tue, Jan 11, 2022 at 11:57 PM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Wed, Jan 05, 2022 at 04:52:51PM -0800, Yan Yan wrote:
>
> ...
>
> > -static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
> > -                                        struct xfrm_encap_tmpl *encap)
> > +static struct xfrm_state *xfrm_state_clone1(struct xfrm_state *orig,
> > +                                         struct xfrm_encap_tmpl *encap)
> >  {
> >       struct net *net = xs_net(orig);
> >       struct xfrm_state *x = xfrm_state_alloc(net);
> > @@ -1579,8 +1579,20 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
> >       memcpy(&x->mark, &orig->mark, sizeof(x->mark));
> >       memcpy(&x->props.smark, &orig->props.smark, sizeof(x->props.smark));
> >
> > -     if (xfrm_init_state(x) < 0)
> > -             goto error;
> > +     return x;
> > +
> > + error:
> > +     xfrm_state_put(x);
> > +out:
> > +     return NULL;
> > +}
> > +
> > +static int xfrm_state_clone2(struct xfrm_state *orig, struct xfrm_state *x)
>
> I'm not a frind of numbering function names, this just invites to
> create xfrm_state_clone3 :)
>
> > +{
> > +     int err = xfrm_init_state(x);
> > +
> > +     if (err < 0)
> > +             return err;
> >
> >       x->props.flags = orig->props.flags;
> >       x->props.extra_flags = orig->props.extra_flags;
> > @@ -1595,12 +1607,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
> >       x->replay = orig->replay;
> >       x->preplay = orig->preplay;
> >
> > -     return x;
> > -
> > - error:
> > -     xfrm_state_put(x);
> > -out:
> > -     return NULL;
> > +     return 0;
> >  }
> >
> >  struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net,
> > @@ -1661,10 +1668,14 @@ struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
> >  {
> >       struct xfrm_state *xc;
> >
> > -     xc = xfrm_state_clone(x, encap);
> > +     xc = xfrm_state_clone1(x, encap);
> >       if (!xc)
> >               return NULL;
> >
> > +     xc->props.family = m->new_family;
> > +     if (xfrm_state_clone2(x, xc) < 0)
> > +             goto error;
>
> xfrm_state_migrate() is the only function that calls xfrm_state_clone().
> Wouldn't it be better to move xfrm_init_state() out of xfrm_state_clone()
> and call it afterwards?
>
> This would also fix the replay window initialization on ESN because
> currently x->props.flags (which holds XFRM_STATE_ESN) is initialized
> after xfrm_init_state().
>


-- 
--
Best,
Yan
